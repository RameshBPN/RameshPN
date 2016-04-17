/**
	About
	-----
	Description: Customer Search MOD - On create of Private Person, or MOD Validation (both B2B & B2C)
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: July 2013
	
	Methods:
	-------
	G2O_CustomerSearch_MOD_VFCx(ApexPages.StandardController controller) // Constructor
	
	Pagereference cancelSearch() // This method cancels the search and fwds to the account's page or the Account tab
	PageReference createUnverified() // This method creates an account by redirecting it to the Std Edit New page of Accounts. // Create Unverified Customer - after they have searched once, they can create an unverified account using the current search criteria
	void addSearchFieldValuesToURLParamters(Account a, PageReference p) // Map field values to a URL that salesforce will recognise // This private method is used to redirect to Std new edit page with values passed on
	
	PageReference doSearch() // search SFDC and then, if it's a DK account, MOD
	void searchSFDC() // Search SFDC for matching accounts accoding to the search criteria
	void searchMOD() // Call out to Mod webservice to search the MOD database
	
	PageReference selectModResult() // When a user hits 'use mod result' on a mod value, this method picks up the record from the results and then queries for any existing accounts with matching numbers. Set by page: selectedModIntrNr selectedModModtagNr, representing the modResult.MOD_Interessent_Number__c and MOD_Modtager_Number__c //Find mod from the result list and assign it to selectedModResult. //Search for overlapping accounts in SFDC by modtager nr or interessent nr and populate sfdcModMatches //To avoid over complication we will only search on B2B or B2C account types
	PageReference clearSelectedModResult() // Clears the mod result being inspected and returns to the search results view
	PageReference useModResult() // Merge the MOD result with the main account object, then save it (if existing) or go to the edit page (if new).
	PageReference enrichExistingCustomer() // The MOD result enriches the selected Account according to the CustomerSearch_MOD_EnrichFields field set. It will then redirect to that account's page.
	void enrichCustomerRecord(accountObject, [Boolean commitToDb]) // Enrich a customer record by the MOD speciffic fields only and optionally commit to the database
	
	Update History
	--------------
	Refactored - July/August 2013 M.E.
	Updated to ignore some wildcards in fields to generate a more general SFDC result but still avoiding LIKE operations - Aug 2013 ME
	Enhancement #1078 - Nov 13 M.E.
	
	Issues / TODOs
	--------------

*/

public with sharing class G2O_CustomerSearch_MOD_VFCx {
	
	// About the account being enriched/created
	public Account theAccount {get{theAccount = theAccount==null?new Account():theAccount; return theAccount;}set;} // the account record in question new/existing
	public Contact theAccountContact {get{theAccountContact = theAccountContact==null?new Contact():theAccountContact; return theAccountContact;}set{theAccountContact = value;theAccount.firstName = theAccountContact.FirstName;theAccount.LastName = theAccountContact.LastName;}} // the account record in question new/existing
	
	public Boolean isExistingAccount {get{return UTIL_Apex.isSet(theAccount.id);}set;} // true if this is an enrich of an existing account record
	public Boolean newPrivatePerson {get{return isPersonAccount && !isExistingAccount;}set;} // true if this is the create private person flow
	public Boolean isPersonAccount {get{isPersonAccount = isPersonAccount==null ? false : isPersonAccount; return isPersonAccount;}set;} // set according to the record type chosen on the account
	public Boolean searched {get{searched=searched==null?false:searched;return searched;}set;}
	public String alertMessage {get{return alertMessage = alertMessage==null ? '':alertMessage; return alertMessage;}set;} // message to pop in alert dialogue
	
	// The main search results from Mod
	// Pagination is applied automatically to the public variables
	public Account[] allModResults{get{allModResults = allModResults==null ? new Account[]{} : allModResults; return allModResults;} set{allModResults=value; modResultsPagination=null;}}
	public UTIL_Apex.Pagination modResultsPagination{get {modResultsPagination = modResultsPagination==null ? new UTIL_Apex.Pagination((Object[])allModResults,10) : modResultsPagination; return modResultsPagination;}set;}
	public Account[] modResults{get{modResults = new Account[]{}; for (object o: modResultsPagination.paginatedList){modResults.add((Account)o);} return modResults;} set;}
	
	// The main search results from SFDC
	// Pagination is applied automatically to the public variables
	public Account[] allSfdcResults{get{allSfdcResults = allSfdcResults==null ? new Account[]{} : allSfdcResults; return allSfdcResults;} set{allSfdcResults=value; sfdcResultsPagination=null;}}
	public UTIL_Apex.Pagination sfdcResultsPagination{get {sfdcResultsPagination = sfdcResultsPagination==null ? new UTIL_Apex.Pagination((Object[])allSfdcResults,10) : sfdcResultsPagination; return sfdcResultsPagination;}set;}
	public Account[] sfdcResults{get{sfdcResults = new Account[]{}; for (object o: sfdcResultsPagination.paginatedList){sfdcResults.add((Account)o);} return sfdcResults;} set;}
	
	// Detailed results
	public String selectedModIntrNr{get;set;} // Set by the user when they choose a mod result.
	public String selectedModModtagNr{get;set;} // Set by the user when they choose a mod result.
	public Account selectedModResult{get;set;} // the mod result the user is interested in
	public ID accountIdToEnrich{get;set;} // an existing account in salesforce to populate with MOD details
	
	// SFDC Results matching MOD result ID's
	// Pagination is applied automatically to the public variables
	public Map<Id,Account> allSfdcModMatches{get{allSfdcModMatches = allSfdcModMatches == null ? new Map<Id,Account>() : allSfdcModMatches; return allSfdcModMatches;} set{allSfdcModMatches=value; sfdcModMatchesPagination=null;}}
	public UTIL_Apex.Pagination sfdcModMatchesPagination{get {sfdcModMatchesPagination = sfdcModMatchesPagination == null ? new UTIL_Apex.Pagination((Object[])allSfdcModMatches.values(),10) : sfdcModMatchesPagination; return sfdcModMatchesPagination;}set;}
	public Account[] sfdcModMatches{get{sfdcModMatches = new Account[]{}; for (object o: sfdcModMatchesPagination.paginatedList){sfdcModMatches.add((Account)o);} return sfdcModMatches;} set;}
	
	// Parent account name and Id (if referred)
	string parentAccountName;
	ID parentAccountId;
	
	/*** Constructor ***/
	public G2O_CustomerSearch_MOD_VFCx(ApexPages.StandardController controller){
		theAccount = (Account)controller.getRecord();	
		// Handle if the page is viewed without any parameters. Define this as a default new account of type worksite.
		if (theAccount.RecordTypeId==null)
		{
			theAccount = new Account();
			theAccount.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
		}
		
		// If this was a redirect from the External Provider Create process, scrub the URL for passed search parameters
		map<String,String> pageParams = ApexPages.currentPage().getParameters();
		if (pageParams.get('externalNew')=='true')
		{
			// Add the search terms by collecting from the URL based on the external search page's fields
			for (Schema.FieldSetMember f : SObjectType.Account.FieldSets.CustomerSearch.getFields())
			{
				String fieldPath = f.fieldPath;
				String paramPath = 'x'+f.fieldPath; // The 'x' is used to ensure there's no confusion between native and passed URL parameters
				
				if (theAccount.get(fieldPath)==null && pageParams.get(paramPath)!=null && pageParams.get(paramPath)!='')
				{
					theAccount.put(fieldPath, pageParams.get(paramPath));
				}
				
				// Ensure visiting and postal address references are inter-changeable
				system.debug(logginglevel.info, 'fieldPath: ' + fieldPath + ' ' + theAccount.get(fieldPath));
				if (fieldPath.indexOf('Visiting_Address')!=-1)
				{
					fieldPath = fieldPath.replace('Visiting','Postal');
					if (theAccount.get(fieldPath)==null && pageParams.get(paramPath)!=null && pageParams.get(paramPath)!='')
					{
						theAccount.put(fieldPath, pageParams.get(paramPath));
					}
				}
			}
			
			// Allow parent ID to be passed
			if (pageParams.get('xParentId')!=null)
			{
				parentAccountId = (ID)pageParams.get('xParentId');
				parentAccountName = [Select Id, Name from account where id=:parentAccountId limit 1].Name;
				theAccount.parentId = (ID)pageParams.get('xParentId');
			}
			
			// Allow record type ID to be passed
			if (pageParams.get('xRecordType')!=null)
			{
				theAccount.RecordTypeId = (ID)pageParams.get('xRecordType');
			}
			
			// Allow VAT number to be passed
			if (pageParams.get('xVAT_Number__c')!=null)
			{
				theAccount.VAT_Number__c = pageParams.get('xVAT_Number__c');
			}
			// Allow Corporate Registration Number to be passed
			if (pageParams.get('xCorporate_Registration_Number__c')!=null)
			{
				theAccount.Corporate_Registration_Number__c = pageParams.get('xCorporate_Registration_Number__c');
			}
		}
		
		// Get some information about the current type of account
		RecordType rt = [select id, IsPersonType from recordType where id=:theAccount.RecordTypeId];
		if (rt.IsPersonType)
		{
			isPersonAccount = true;
		}
		
		// For person Accounts populate the contact object used to contain the name values
		if (isExistingAccount && isPersonAccount)
		{
			theAccountContact = [select id,firstname,lastname from Contact where accountId = :theAccount.id limit 1];
		}
		if(theAccount.id != null){
			Account workSiteAcc = [Select id, Work_Site_Name__c From Account Where id = :theAccount.id];
			if(workSiteAcc.Work_Site_Name__c != null){
				theAccount.Name = workSiteAcc.Work_Site_Name__c;
			}
		}
	}
	
	// This method cancels the search and fwds to the account's page or the Account tab
	public Pagereference cancelSearch() {
		PageReference p = null;
		if(isExistingAccount) {
			p = new PageReference('/' +theAccount.Id);  // this will redirect the page to the account (MOD validate process) 
		} else {
			p = new PageReference('/'+Account.SObjectType.getDescribe().getKeyPrefix()+'/o');		// this will redirect to the New account page (Customer Search for private person)
		}
		return p;  
	}
	
	// Create Unverified Customer - after they have searched once, they can create an unverified account using the current search criteria
	// This method creates an account by redirecting it to the Std Edit New page of Accounts
	public PageReference createUnverified() {
		system.debug(logginglevel.warn, 'Updating with account: ' + theAccount);
		PageReference p = new PageReference('/' + Account.SObjectType.getDescribe().getKeyPrefix() + '/e');
	    addSearchFieldValuesToURLParamters(theAccount, p);
	    return p;
	}
	
	// This private method is used to redirect to Std new edit page with values passed on
	void addSearchFieldValuesToURLParamters(Account a, PageReference p){
		Map<String, String> mapURL = p.getParameters();
		
		// Copy the values in the account's search fields and MOD enrich fields into the URL parameter map based on the URL hacking map for this sObject
        List<Schema.FieldSetMember> urlFields = new List<Schema.FieldSetMember>();
        
        // Append the Search fields to this general field set
        if (a.IsPersonAccount)
        {
        	urlFields.addAll(Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MODB2C_Search1').getFields());
        	urlFields.addAll(Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MODB2C_Search2').getFields());
        } else
        {
        	urlFields.addAll(Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MODB2B_Search').getFields());
        }
        
        // Append the MOD enrich fields (required to be included if we are creating a private person for the first time)
    	urlFields.addAll(Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MOD_EnrichFields').getFields());
		
		// Get the GenericURL map for the account object to build the URL from
        Map<String, GenericURLHacking__c> urlLabels = UTIL_OrgSettings.GenericURLHacking('Account');
        
		// Add to the URL map if values are present
		for(Schema.FieldSetMember f : urlFields) {
			system.debug(logginglevel.warn, 'adding field: ' + f);
			// Trim field path to under 38 chars which is the length limit in the custom setting name field
			String theFieldPath = f.fieldPath;
			theFieldPath = theFieldPath.substring(0, theFieldPath.length()>38 ? 38 : theFieldPath.length()); 
			
        	if(UTIL_Apex.isSet(a.get(f.fieldPath)) && urlLabels.containsKey(theFieldPath)) {			
        		if (f.getType() == Schema.DisplayType.Boolean)
        		{
	        		mapURL.put(urlLabels.get(theFieldPath).URL_Field_Id__c, a.get(f.fieldPath)!=null && a.get(f.fieldPath)==true ? '1' : '0'); 
        		} else {
	        		mapURL.put(urlLabels.get(theFieldPath).URL_Field_Id__c, String.valueOf(a.get(f.fieldPath))); 
        		}
        	}
        }
        
        // Append Parent if referred in URL
        if (parentAccountId!=null) 
        {
            mapURL.put(urlLabels.get('ParentAccountId').URL_Field_Id__c, parentAccountId);
            mapURL.put(urlLabels.get('ParentAccountName').URL_Field_Id__c, parentAccountName);
        }
        
        // Append VAT number if referred in URL
		if (theAccount.VAT_Number__c!=null)
		{
            mapURL.put(urlLabels.get('VAT_Number__c').URL_Field_Id__c, theAccount.VAT_Number__c);
		}
		// Append Corporate Registration Number if referred in URL
		if (theAccount.Corporate_Registration_Number__c!=null)
		{
            mapURL.put(urlLabels.get('Corporate_Registration_Number__c').URL_Field_Id__c, theAccount.Corporate_Registration_Number__c);
		}
		
		//Append Language Danish if Postal Address Country is Denmark
		if (theAccount.Postal_Address_Country__c == 'DK') {
			mapURL.put(urlLabels.get('Language__c').URL_Field_Id__c, 'da');
		}
    
        // Mandatory values
	    mapURL.put('RecordType', a.RecordTypeId);
	    mapURL.put('nooverride', '1');
	    
	    if(!isExistingAccount) {
	    	mapURL.put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
	    } else {
	    	mapURL.put('retURL', a.Id);
	    }
	    
        system.debug(Logginglevel.INFO,'@@ mapURL:'+mapURL);
	}
	
	public PageReference doSearch()
	{
		alertMessage = '';
		selectedModResult=null;
		searchSFDC();
		if (theAccount.Postal_Address_Country__c=='DK') searchMOD();
		searched = true;
		return null;
	}
	
	void searchSFDC()
	{
		// Clean off previous searches
		allSfdcResults = null; 
		// If this is an existing account, don't run the search, and ensure the results are empty
		if (isExistingAccount) 
		{
			return;
		}
		
		// Populate allSfdcResults : Buld query using the field set values. Address values are grouped into AND statements
		String query = 'select Id, Name, Short_Name__c, Metaphone_Primary_Encoding__c, IsPersonAccount, External_Provider_Party_ID__c ';
		for(Schema.FieldSetMember f : Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MOD_SFDCSearchResults').getFields()) {
			query += ','+f.fieldPath;
        }

        String whereQuery = ' from Account where recordTypeId=\''+String.escapeSingleQuotes(theAccount.recordTypeId)+'\' AND (';
        
        List<Schema.FieldSetMember> searchFields = new List<Schema.FieldSetMember>();
        if (isPersonAccount)
        {
        	theAccount.FirstName = theAccountContact.FirstName;
        	theAccount.LastName = theAccountContact.LastName;
        	query+= ',FirstName,LastName';
        	
        	whereQuery += ' LastName = \''+String.escapeSingleQuotes(theAccountContact.LastName)+'\' ';
        	
        	// Allow the user to give the first name as a wildcard in MOD; but ignore it in the SOQL search to avoid LIKE operations
        	if (theAccountContact.FirstName.indexOf('*')==-1)  whereQuery += ' OR FirstName = \''+String.escapeSingleQuotes(theAccountContact.FirstName)+'\' ';
        	
			searchFields.addAll(Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MODB2C_Search1').getFields());
        	searchFields.addAll(Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MODB2C_Search2').getFields());
        } else
        {
        	whereQuery += 'Name = \''+String.escapeSingleQuotes(theAccount.Name)+'\' ';
        	searchFields.addAll(Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MODB2B_Search').getFields());
        }

		// Add some fuzzy matching on names
        if (!isExistingAccount)
        {
        	
        	G2O_Account_SVC.applySerchFirstNaming(theAccount, isPersonAccount);
        	UTIL_DoubleMetaphone.encode(theAccount, isPersonAccount);
        }
		whereQuery += 'OR Short_Name__c = \''+String.escapeSingleQuotes(theAccount.Short_Name__c)+'\' OR Metaphone_Primary_Encoding__c = \''+String.escapeSingleQuotes(theAccount.Metaphone_Primary_Encoding__c)+'\') ';
        
        // Country match
        if (UTIL_Apex.isSet(theAccount.Postal_Address_Country__c))
        {
        		whereQuery += ' AND Postal_Address_Country__c= \''+String.escapeSingleQuotes(theAccount.Postal_Address_Country__c)+'\' ';
        }
        
        query += whereQuery;
		whereQuery = '';
        
		String[] whereClause = new String[]{};
		Integer items = 0;

        for(Schema.FieldSetMember f : searchFields) {
			items++;
			// While building the rest of the 'where' clause, ignore fields with a * in though as these are wildcard fields for MOD and we want to avoid LIKE operations
			if (UTIL_Apex.isSet(theAccount.get(f.fieldPath)) && f.FieldPath!='Postal_Address_Country__c' && String.valueOf(theAccount.get(f.fieldPath)).indexOf('*')==-1)
			{
				whereClause.add(f.fieldPath);
				if (whereClause.size()>1 && whereClause[whereClause.size()-2].indexOf('Address')!=-1 && f.fieldPath.indexOf('Address')!=-1) 
        		{
        			whereQuery += ' AND ';
        		} else if (whereClause.size()>1 && whereClause[whereClause.size()-2].indexOf('Address')!=-1) 
        		{
				whereQuery += ') OR ';
				} else if (whereClause.size()>1 && f.fieldPath.indexOf('Address')!=-1)
        		{
        			whereQuery += ' OR (';
				} else if (whereClause.size()==1 && f.fieldPath.indexOf('Address')!=-1)
        		{
        			whereQuery += '(';
        		}  else if (whereClause.size()==1)
        		{
        			whereQuery += '';
        		} else
        		{
        			whereQuery += ' OR ';
        		}
        		String value = String.escapeSingleQuotes(String.valueOf(theAccount.get(f.fieldPath)));
        		whereQuery += f.fieldPath+' = \''+ value +'\'';
			}
        }
		while(whereQuery.countMatches('(')>whereQuery.countMatches(')'))
		{
			whereQuery += ')';
		}
        query += (whereQuery!='' ?  'AND ('+whereQuery+')' : '') +' Limit 9999';
		
		system.debug(logginglevel.info, '@@ '+query);
    	allSfdcResults = Database.query(query);
		system.debug(logginglevel.info, '@@ '+allSfdcResults);
    	
	}
	
	void searchMOD()
	{
		if (isPersonAccount)
        {
        	theAccount.FirstName = theAccountContact.FirstName;
        	theAccount.LastName = theAccountContact.LastName;
        }
		
		allModResults = null;
		try
		{
			G2O_MODValidation_WS.QueryType typeOfQuery = isPersonAccount ? G2O_MODValidation_WS.QueryType.B2C : G2O_MODValidation_WS.QueryType.B2B;
			G2O_MODValidation_WS modCallout = new G2O_MODValidation_WS(theAccount, typeOfQuery);
			modCallout.send();
			if (modCallout.callout.errors.size()>0)
			{
				// Compile the error messages to display on the page
				alertMessage = Label.MOD_Search_Problem+'\\n';
				for (UTIL_HttpIntegration.ErrorContainer e : modcallout.callout.errors)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.description));
					alertMessage = e.description + '\\n';
				}
			}
			if(modCallout.resultList != null) {  
				System.debug(Logginglevel.Info, '@@ Mod result: '+modCallout.resultList);
				allModResults = modCallout.resultList; 
			}
		} catch(CalloutException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Callout + ' ' + e.getMessage()));
        
        } catch(UTIL_HttpIntegration.MappingException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Field_Missing + ' ' + e.fieldPath));
        
        } catch (Exception e)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
            UTIL_Error.report('G2O_CustomerSearch_MOD_VFCx.searchMOD()', e);
            UTIL_Error.write();
		}
	}
	
	public PageReference selectModResult()
	{
		//Set by page: selectedModIntrNr selectedModModtagNr, representing the modResult.MOD_Interessent_Number__c and MOD_Modtager_Number__c
		//Find mod from the result list and assign it to selectedModResult
		selectedModResult = null;
		allSfdcModMatches = null;
		
		boolean foundModItem = false;
		System.debug(logginglevel.info, '@@ Searched '+String.valueOf(searched)+'\n Selected mod numbers '+selectedModIntrNr+','+selectedModModtagNr);
		for(Account r : allModResults)
		{
			if (r.MOD_Interessent_Number__c == selectedModIntrNr && r.MOD_Modtager_Number__c == selectedModModtagNr)
			{
				selectedModResult = r;
				foundModItem = true;
				System.debug(logginglevel.info, '@@ Found mod item '+String.valueOf(selectedModResult));
				break;
			}
		}
		
		if (foundModItem)
		{
			//Search for overlapping accounts in SFDC by modtager nr or interessent nr and populate sfdcModMatches
			//To avoid over complication we will only search on B2B or B2C account types
			String query = 'Select id, Name, FirstName, LastName, Short_Name__c, Metaphone_Primary_Encoding__c, IsPersonAccount, External_Provider_Party_ID__c ';
			
			for(Schema.FieldSetMember f : Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MOD_SFDCMatchingModDetail').getFields()) {
				query += ','+f.fieldPath;
	        }
			query += ' from Account where IsPersonAccount='+isPersonAccount+' AND (MOD_Modtager_Number__c=\''+selectedModResult.MOD_Modtager_Number__c+'\' OR MOD_Interessent_Number__c = \''+selectedModResult.MOD_Interessent_Number__c+'\') limit 9999';
		    
		    System.debug(logginglevel.info, '@@ Query accounts: '+query);
			
		    allSfdcModMatches = new Map<ID,Account>();
		    for (Account a : Database.query(query))
		    {
		    	allSfdcModMatches.put(a.id,a);
		    }
		    if (isExistingAccount)
		    {
		    	allSfdcModMatches.remove(theAccount.id);
		    } 
			
			System.debug(logginglevel.info, '@@ Found mod item overlapping accounts in db by number '+String.valueOf(allSfdcModMatches)+' '+sfdcModMatchesPagination);
			
			//If no overlaps found, then go directly to useModResult
			if (allSfdcModMatches.size()==0) return useModResult();
		}
		return null;
	}
	
	public PageReference clearSelectedModResult()
	{
		selectedModResult = null;
		return null;
	}
	
	public PageReference useModResult()
	{
		// Merge the MOD result with the main account object, then save it (if existing) or go to the edit page (if new).
		alertMessage = '';
		try {
			if (!isExistingAccount)
			{
				// If a new account, then instead of inserting the record, Enrich the account record then collect the data into the URL and fwd to a new result page
				enrichCustomerRecord(theAccount);
				theAccount.Registration_Country__c = UTIL_OrgSettings.NewCustomerMODFlowRegCountry();
				theAccount.Work_Site_Type__c = UTIL_OrgSettings.NewCustomerMODFlowWSType();
				insert theAccount;
				return new PageReference('/'+theAccount.Id);
			} else {
				// Otherwise if this is validating an existing record, enrich an update-only record with the MOD data only and commit it
	
				enrichCustomerRecord(theAccount, true);
				return new PageReference('/'+theAccount.Id);
				
			}
		} catch (System.DmlException ex) {
				System.debug(logginglevel.info, '@@ Error found: '+ex);
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getDmlMessage(0)));
				alertMessage = ex.getDmlMessage(0);
				selectedModResult = null;
			}
		return null;
	}
	
	public PageReference enrichExistingCustomer()
	{
		// The MOD result enriches the selected Account according to the CustomerSearch_MOD_EnrichFields field set
		// It will then redirect to that account's page.
		alertMessage = '';

		try
		{
			if (UTIL_Apex.isSet(accountIdToEnrich)) {
				enrichCustomerRecord(allSfdcModMatches.get(accountIdToEnrich), true);
			}
			return new PageReference('/'+accountIdToEnrich);
		} catch (Exception ex) {
			System.debug(logginglevel.info, '@@ Error found: '+ex);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getDmlMessage(0)));
			alertMessage = ex.getDmlMessage(0);
		}
		return null;
	}
	
	// Enrich a customer record by the MOD speciffic fields only and optionally commit to the database
	void enrichCustomerRecord(Account accountObject)
	{
		enrichCustomerRecord(new list<Account>{accountObject}, false);
	}
	void enrichCustomerRecord(Account accountObject, Boolean commitToDb)
	{	
		enrichCustomerRecord(new list<Account>{accountObject}, commitToDb);
	}
	
	void enrichCustomerRecord(list<Account> accountList, Boolean commitToDb)
	{	
		// Copy the updated data to both the passed by reference accountObject (for reference) and an sObject (as the DB update is applied to the updated fields only, an sObject can perform this update method for us)
		list<sObject> sObjectToUpdate = new list<sObject>();

		for(Account accountObject : accountList){
			sObject sobjectToEnrich = Account.SObjectType.newSObject(accountObject.id);
			Boolean accountToEnrichIsVerified = UTIL_Apex.isSet(accountObject.External_Provider_Party_ID__c);
			
			// Iterating over the fields of the chosen account 
			for(Schema.FieldSetMember f : Schema.SObjectType.Account.fieldSets.getMap().get('CustomerSearch_MOD_EnrichFields').getFields()) {
				String theFieldPath = f.fieldPath;
				// Putting the MOD data into an existing SFDC Account (note the type of account defines the type of MOD query result - B2B or B2C)
				if(UTIL_Apex.isSet(selectedModResult.get(theFieldPath))) {
					
					// If we have MOD results from a B2C account, update the first and last name, but not the Name field (is read only)
					if (isPersonAccount && theFieldPath!='Name')
					{
						sobjectToEnrich.put(theFieldPath, selectedModResult.get(theFieldPath));
						accountObject.put(theFieldPath, selectedModResult.get(theFieldPath));
					} else if (!isPersonAccount && theFieldPath!='LastName' && theFieldPath!='FirstName') {
						
						// If we have a B2B MOD result, and the account we are writing to is externally verified, do not overwrite the Name field
						if (accountToEnrichIsVerified && theFieldPath =='Name'){
							// Do nothing
						} else {
							sobjectToEnrich.put(theFieldPath, selectedModResult.get(theFieldPath));
							accountObject.put(theFieldPath, selectedModResult.get(theFieldPath));
						}
					}
					
				} else if (theFieldPath!='Name' && theFieldPath!='LastName' && theFieldPath!='FirstName') {
					// Enhancement #1078
					// If the field is empty or missing from the MOD result, enhancement #1078 requests that we clear the field value
					// - Note the Name field cannot be empty, so this is skipped
					try
					{
						sobjectToEnrich.put(theFieldPath, '');
						accountObject.put(theFieldPath, '');
					} catch (exception e) {}
				}
			}
			sobjectToEnrich.put('Is_MOD_validated__c', true);
			accountObject.put('Is_MOD_validated__c', true);
		
			System.debug(logginglevel.info,'@@ Account to Enrich: '+sobjectToEnrich);
			if (commitToDb)
			{	
				// Allow truncation of long strings
				Database.DMLOptions dmo = new Database.DMLOptions();
				dmo.allowFieldTruncation = true;
				sobjectToEnrich.setOptions(dmo);
				sObjectToUpdate.add(sobjectToEnrich);
			}	
		}
		if(commitToDb){
			// Apply the update
			System.debug(logginglevel.info,'@@ Account to Enrich, before update: '+sObjectToUpdate);	
			update sObjectToUpdate;
		}
	}
}