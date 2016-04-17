/**
	About
	-----
	Description: PAR Verify process on Account detail page.
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: March 2013
	
	Details / Methods
	-----------------
	Detail Steps:
	-------------
	Rereives external party provider details for Unverified accounts (LE's and Worksites only)
	
	Note regarding duplicate checking:
	If an exisiting External Involved Party Id (PAR Id) exists in already created Customer (Account), create possible duplicate account.
	(1) PAR Id on an account is unique. As we will never have duplicate PAR ID in system so we are not handling it from the batch.
	(2) However, On PAR verify (Button Click) if we get a result with a PAR ID that already exists then we show an Alert saying "Duplicate Par Id" 
	(3) When the user clicks OK, Enrich goes ahead a possible duplicate is created. (CHECK IF THE ACCOUNT BEING ENRICHED GETS THE PAR ID OR THE PAR ID STAYS ON THE OLD ACCOUNT)
	If an exisiting External Involved Party Id (PAR Id) does not exist, enrich the account.
	
	Methods / Classes:
	------------------
		
	Update History
	--------------
	Created Aug 2013 - ME
	CR021 Aug 2013 - ME
	
	Issues / TODOs
	--------------

*/
public with sharing class G2O_CustomerSearch_Enrich_VFCx {
	//*
	// Search and entry critieria
	public Account theAccount{get;set;}
	public String recordTypeName{get{recordTypeName = theAccount!=null && theAccount.RecordType.Name!=null ? theAccount.RecordType.Name : ''; return recordTypeName;}set;}
	Boolean isLegalEntity{get{isLegalEntity = (theAccount!=null && theAccount.recordTypeId == UTIL_Meta.getAccountLegalEntityRT()); return isLegalEntity;}set;}
	Boolean isWorkSite{get{isWorkSite = (theAccount!=null && theAccount.recordTypeId == UTIL_Meta.getAccountWorkSiteRT()); return isWorkSite;}set;}
	
	// Results
    map<Account,list<Account>> externalResults {get{externalResults = externalResults==null ? new map<Account,list<Account>>() : externalResults;return externalResults;}set;} 
    ResultWrapper[] allSearchResults {get{allSearchResults = allSearchResults==null ? new ResultWrapper[]{} : allSearchResults; searchResultsPagination=null; return allSearchResults;}set;} 
	public UTIL_Apex.Pagination searchResultsPagination {get {searchResultsPagination = searchResultsPagination==null ? new UTIL_Apex.Pagination((Object[])allSearchResults,5) : searchResultsPagination; return searchResultsPagination;}set;}
	public ResultWrapper[] searchResults {get{searchResults = new ResultWrapper[]{}; for (object o: searchResultsPagination.paginatedList){searchResults.add((ResultWrapper)o);} return searchResults;} set;}
	
	// Indexed and mapped results
	map<String,ResultWrapper> resultsByExternalId {get{resultsByExternalId = resultsByExternalId==null ? new map<String,ResultWrapper>() : resultsByExternalId;return resultsByExternalId;}set;} 
	map<String,String> legalEntityByWorksite {get{legalEntityByWorksite = legalEntityByWorksite==null ? new map<String,String>() : legalEntityByWorksite;return legalEntityByWorksite;}set;} 
	map<String,String> hqByLegalEntity {get{hqByLegalEntity = hqByLegalEntity==null ? new map<String,String>() : hqByLegalEntity;return hqByLegalEntity;}set;} 
	Account duplicateAccount;
	
	// UI and Feedback
	public Boolean 	externalServiceFailure 	{get{externalServiceFailure = externalServiceFailure==null ? false : externalServiceFailure;return externalServiceFailure;}set;} 
	public String 	externalServiceFailure_Msg {get{externalServiceFailure_Msg = externalServiceFailure_Msg==null ? '':externalServiceFailure_Msg; return externalServiceFailure_Msg;}set;} // message to pop in alert dialogue
	public String 	selectedExternalId 		{get{selectedExternalId = selectedExternalId==null ? '':selectedExternalId; return selectedExternalId;}set;} // message to pop in alert dialogue
	public String 	resultMsg 				{get{resultMsg=resultMsg==null? '' :resultMsg; return resultMsg;}set;}
	public Boolean	searched 				{get{searched = searched==null ? false : searched;return searched;}set;} 
	public Boolean	enrichPerformed 		{get{enrichPerformed = enrichPerformed==null ? false : enrichPerformed;return enrichPerformed;}set;} 
	public Boolean	noErrors 				{get{noErrors = noErrors==null ? true : noErrors;return noErrors;}set;} 
	
	// Testing constants
	Boolean SEARCHEXTERNAL = true;
	
	// Constructor for PAR Verify/ PAR Enrich
	public G2O_CustomerSearch_Enrich_VFCx(ApexPages.StandardController controller) {
		theAccount = (Account)controller.getRecord();
		if (theAccount.Id!=null)
		{
			
			String query = 'SELECT Id, ParentId, Work_Site_Type__c, External_Provider_Party_ID__c, RecordTypeId';
			for (Schema.FieldSetMember f: SObjectType.Account.FieldSets.CustomerSearch_Enrich_Fields.getFields()) {
				if (!query.contains(f.getFieldPath())) query += ', ' + f.getFieldPath();
			}
			query += ' From Account where Id =\'' + theAccount.Id + '\' limit 1';
			
			theAccount = Database.query(query);
		}
		
		// Accept LE's and Worksites only
		if (theAccount.recordTypeId!=UTIL_Meta.getAccountLegalEntityRT() && theAccount.recordTypeId!=UTIL_Meta.getAccountWorkSiteRT())
		{
			theAccount = new Account();
		}
	}
	
	// Search the external provider (PAR)
	public void searchExternalProvider() {
		System.debug(logginglevel.Info, '### START searchExternalParty ');
		System.debug(logginglevel.Info, '### No Errors so far: ' + noErrors);
		
		allSearchResults = null;
		resultsByExternalId = null;
		searched = true;
		
        // If we have a valid account to work with (an existing account) call the external service and get the list of matching accounts
        if(theAccount.Id != null) {
        	
        	// Call the webservice
    		if (SEARCHEXTERNAL)
    		{
    			
    			G2O_PARSearchView_Customer_WS objSearchPAR = new G2O_PARSearchView_Customer_WS(theAccount);
    			
    			// FOR TESTING, USE A MOCK RESPONSE -> objSearchPAR.opt_MockDocument = 'TestMockResponse_PAR_Verify';
    			
				try
				{
					objSearchPAR.send(theAccount.Id);
					externalResults = objSearchPAR.result;
					System.debug(Logginglevel.INFO,'### PAR Results '+externalResults);
					
					// Feedback errors
					if (objSearchPAR.callout.errors.size()>0)
					{
						System.debug(Logginglevel.INFO,'### PAR Result Errors '+objSearchPAR.callout.errors);
						externalServiceFailure = true;
						externalServiceFailure_Msg = Label.Ext_Request_Failed+': '+objSearchPAR.callout.errors[0].description;
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,externalServiceFailure_Msg));
					}
				} catch(CalloutException e){
        			externalServiceFailure = true;
        			externalServiceFailure_Msg = Label.Error_from_Callout+' '+e.getMessage();
        			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Callout + ' ' + e.getMessage()));
        
        		} catch(UTIL_HttpIntegration.MappingException e){
        			externalServiceFailure = true;
        			externalServiceFailure_Msg = Label.Error_Field_Missing+' '+e.fieldPath;
        			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Field_Missing + ' ' + e.fieldPath));
        
        		}catch (Exception e){
					externalServiceFailure = true;
					externalServiceFailure_Msg = Label.Error_from_Salesforce;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
					UTIL_Error.report('G2O_CustomerSearch_Enrich_VFCx.searchExternalProvider()', e);
            		UTIL_Error.write();
				}
    		}
    		
			// Compile the results into a list to display (allSearchResults) and index by external id
			if (externalResults.size()>0)
			{
				for (Account le : externalResults.keySet())
				{
					ResultWrapper legalEntity_r = new ResultWrapper(le);
					resultsByExternalId.put(le.External_Provider_Party_ID__c, legalEntity_r);
					System.debug(Logginglevel.INFO,'### PAR Results legalEntity_r '+legalEntity_r);
					
					if (isLegalEntity)
					{
						// If we are searching to enrich a legal entity:
						// Add LE to the search results displayed and index
						allSearchResults.add(legalEntity_r);
					} else if (isWorkSite) {
						for (Account ws : externalResults.get(le))
						{	
							// If we are searching to enrich a worksite:
							ResultWrapper workSite_r = new ResultWrapper(ws);
							System.debug(Logginglevel.INFO,'### PAR Results workSite_r '+workSite_r);
							
							// Add WS to the search results displayed and index
							allSearchResults.add(workSite_r);
							
							// Index the record by external id
							resultsByExternalId.put(ws.External_Provider_Party_ID__c, workSite_r);
							
							// Index legal entities by worksite (so we can check the worksite's LE when enriching)
							legalEntityByWorksite.put(ws.External_Provider_Party_ID__c, le.External_Provider_Party_ID__c);
							
							// If the ws is an HQ, index the (last, if multple, we only require one) HQ for the legal entity (so we can check the worksite has a sibling HQ when enriching)
							if (ws.Work_Site_Type__c==UTIL_OrgSettings.workSiteTypeHQ()) hqByLegalEntity.put(le.External_Provider_Party_ID__c, ws.External_Provider_Party_ID__c);
						}
					}
				}
			}
        } else
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.Account_does_not_exist));
        }
		System.debug(Logginglevel.INFO,'### PAR Results resultsByExternalId '+resultsByExternalId);
		System.debug(Logginglevel.INFO,'### Indexed le\'s: legalEntityByWorksite: '+legalEntityByWorksite);
		System.debug(Logginglevel.INFO,'### Indexed hq\'s: hqByLegalEntity: '+hqByLegalEntity);
        System.debug(logginglevel.Info, '### END searchExternalParty '); 		
	}
	
	
	// Navigate away from the page, called after providing feedback given by the enrich process
	public PageReference navigateAway()
	{
		if (duplicateAccount!=null && duplicateAccount.id!=null)
		{
			// Was a duplicate
			// Go to the duplicate record (duplicateAccount set in the enrichCustomerRecord method)
			return new PageReference('/'+duplicateAccount.id);
		} else {
			// Go to the enriched account record
			return new PageReference('/'+theAccount.Id);
		}
	}
	
	// Enrich the account with selected item
	public PageReference enrichCustomerRecord()
	{
		System.debug(logginglevel.Info, '### START enrichCustomerRecord '+selectedExternalId); 
		System.debug(logginglevel.info,'### Enriching: from resultsByExternalId:'+resultsByExternalId);
		System.debug(logginglevel.info,'### Enriching: from legalEntityByWorksite:'+legalEntityByWorksite);
		System.debug(logginglevel.info,'### Enriching: from hqByLegalEntity:'+hqByLegalEntity);
		resultMsg = '';
        duplicateAccount = null;
        enrichPerformed = true;
		noErrors = true;
		
        // Get the account, HQ and LE (if required)
		map<String,Account> accountsByExternalId = new map<String,Account>();
		Map<Id, Set<Account>> duplicates = new Map<Id, Set<Account>>();
		Account legalEntity;
		Account worksiteHQ;
		//Account worksite;
		
		Account[] allAccounts = new Account[]{};
		G2O_PARSearchView_Contacts_WS contactSearch;
		
		// Enrich the main account
		System.debug(logginglevel.info,'### theAccount:'+theAccount);
		Account mainAccountFound = resultsByExternalId.get(selectedExternalId).theAccount;
		balanceAddressFields(mainAccountFound);
		enrichRecord(mainAccountFound, theAccount);
		System.debug(logginglevel.info,'### enrichRecord<-mainAccountFound:'+mainAccountFound);
		System.debug(logginglevel.info,'### enrichRecord->theAccount:'+theAccount);
		theAccount.External_Provider_Party_ID__c = mainAccountFound.External_Provider_Party_ID__c;
		accountsByExternalId.put(theAccount.External_Provider_Party_ID__c, theAccount);
		
		if (isWorksite)
		{
			// Lookup the worksite's LE (if it exists) and find an HQ (if this worksite is not an HQ)
			// If these records exist use the PAR data to enrich them (set the ID), or create new
			
			String legalEntityExternalId = legalEntityByWorksite.get(selectedExternalId);
			System.debug(logginglevel.info,'### Enriching: legalEntityExternalId:'+legalEntityExternalId);
			
			legalEntity = resultsByExternalId.get(legalEntityExternalId).theAccount;
			accountsByExternalId.put(legalEntity.External_Provider_Party_ID__c, legalEntity);
			
			if (legalEntity!=null && theAccount.parentId!=null && (theAccount.parent.Verified__c == null || theAccount.parent.Verified__c!='Y'))
			{
				legalEntity.Id = theAccount.parentId;
			}
			if (legalEntity!=null)
			{
				balanceAddressFields(legalEntity);
			}
			System.debug(logginglevel.info,'### Enriching: legalEntity:'+legalEntity);
			
			// If the result marks the search as a head office, but it wasnt' before, correct the Record Type on the record
			if (hqByLegalEntity.get(legalEntity.External_Provider_Party_ID__c) == theAccount.External_Provider_Party_ID__c)
			{
				theAccount.Work_Site_Type__c = UTIL_OrgSettings.workSiteTypeHQ();
			}
			
			// If not, try to find the worksite
			if (theAccount.Work_Site_Type__c != UTIL_OrgSettings.workSiteTypeHQ())
			{
				String worksiteHqId = hqByLegalEntity.get(legalEntity.External_Provider_Party_ID__c);
				System.debug(logginglevel.info,'### Enriching: worksiteHqId:'+worksiteHqId);
				
				if (resultsByExternalId.containsKey(worksiteHqId))
				{
					worksiteHQ = resultsByExternalId.get(worksiteHqId).theAccount;
					if (worksiteHQ!=null)
					{
						// Only one verified HQ per legal entity is allowed, so take the first
						Account[] hqSiblingAccounts = [select id from Account where Work_Site_Type__c = :UTIL_OrgSettings.workSiteTypeHQ() and External_Provider_Party_ID__c = :worksiteHqId limit 1];
						if (hqSiblingAccounts.size()>0) 
						{
							worksiteHQ.Id = hqSiblingAccounts[0].id;
						}
						balanceAddressFields(worksiteHQ);					
						accountsByExternalId.put(worksiteHQ.External_Provider_Party_ID__c, worksiteHQ);
					}
				} else {
					noErrors = false;
					resultMsg += Label.Ext_No_valid_Head_Office+'\\n';
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Ext_No_valid_Head_Office));
				}
				System.debug(logginglevel.info,'### Enriching: worksiteHQ:'+worksiteHQ);
			}
			
			// Get worksite contacts (process after account DML)
			contactSearch = new G2O_PARSearchView_Contacts_WS(accountsByExternalId.values());
			contactSearch.opt_ApplySearchFirst = true;
			try
			{
				if(!test.isrunningtest()){
					contactSearch.send(theAccount.id);
					System.debug(logginglevel.info,'### Enriching: contactSearch.result:'+contactSearch.result);
					if (contactSearch.callout!=null && contactSearch.callout.errors!=null)
					{
						for (UTIL_HttpIntegration.ErrorContainer e : contactSearch.callout.errors)
						{
							System.debug(logginglevel.Info, '### Error fetchContacts in Customer Search Enrich: ( '+e+')');
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.description));
							resultMsg += e.description + '\\n';
							noErrors = false;
						}
					}
				}
			} catch (Exception e) {
				noErrors = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
				system.debug(logginglevel.warn, 'Error happened in calling the webservice 2');

            	UTIL_Error.report('G2O_CustomerSearch_Enrich_VFCx.enrichCustomerRecord()', e);
            	UTIL_Error.write();
			}
		}
		
		system.debug(logginglevel.info,'### accountsByExternalId: '+accountsByExternalId);
		
		// We are enriching UNVERIFIED accounts. VERIFIED accounts are quto enriched via PNCM. 
		// Prevent duplicate External Id's by:
		// 1) Checking if any of the External Id's exist from the account records being enriched
		// 2) If they do, clear the External Id from the sobject record and create a duplicate record
		for (Account existingAcc : [select id,External_Provider_Party_ID__c from Account where External_Provider_Party_ID__c in :accountsByExternalId.keySet()])
		{
			/*// Ensure this is a different account than one being enriched
			if (existingAcc.id != accountsByExternalId.get(existingAcc.External_Provider_Party_ID__c).id)
			{*/
			// If we are creating a new legal entity for an un parented worksite, check if there is a duplicate on the LE. 
			// If so, attach the LE to this record instead of generating a duplicate
			if ((theAccount.parentId == null || theAccount.parent.External_Provider_Party_ID__c != legalEntityByWorksite.get(theAccount.External_Provider_Party_ID__c))&& theAccount.recordTypeId == UTIL_Meta.getAccountWorkSiteRT() 
				&& legalEntity.External_Provider_Party_ID__c == existingAcc.External_Provider_Party_ID__c
				&& existingAcc.recordTypeId == UTIL_Meta.getAccountLegalEntityRT())
			{
				system.debug(logginglevel.warn, '====> FOUND EXISTING LE, SETTING AS PARENT!');
				legalEntity.Id = existingAcc.Id;
				legalEntity.Verified__c = 'Y';
			} else {
				// Under any other condition, we may be creating a new account or enriching an existing one but a duplicate condition has been found
				Account accountToEnrich = accountsByExternalId.get(existingAcc.External_Provider_Party_ID__c);
				
				System.debug(logginglevel.info,'### Enriching: Duplicate found:existingAcc: '+existingAcc+' vs: accountToEnrich: '+accountToEnrich);
				
				// If this duplicate is on the main account, take note as the user will be forwarded to the duplicate record
				if (accountToEnrich.External_Provider_Party_ID__c == theAccount.External_Provider_Party_ID__c) 
				{
					System.debug(logginglevel.info,'### Duplicate is on the main account');
					duplicateAccount = existingAcc;
					System.debug(logginglevel.info,'### FWD to '+duplicateAccount);
					resultMsg = Label.Fwd_to_Duplicate_Account;
				}
				
				// Remove the external ID from the enriched records that overlap to avoid conflicts
				accountToEnrich.External_Provider_Party_ID__c = null;
				
				// Register the duplicate
				Set<Account> duplicateList = duplicates.containsKey(existingAcc.Id) ? duplicates.get(existingAcc.Id) : new Set<Account>();
				duplicateList.add(accountToEnrich);
				duplicates.put(existingAcc.Id, duplicateList); 
			}
			/*}*/
		}
		system.debug(logginglevel.info,'### Duplcates found: duplicates: '+duplicates);
		
		// Commit the enrichment to accounts, processed as an enriching integration user
		for (Account a : accountsByExternalId.values())
		{
			a.Process_as_Integration_User__c = true;
		}
		
		if (isWorksite)
		{
			try
			{
				// Never update a verified LE
				if(legalEntity.Verified__c != 'Y'){
					upsert legalEntity;
				}
				theAccount.parentId = legalEntity.id;
				try
				{
					if (worksiteHQ!=null)
					{
						worksiteHQ.parentId = legalEntity.id;
						upsert worksiteHQ;
					}
				} catch (Exception e) {
					noErrors = false;
					resultMsg += Label.Could_not_Enrich_Worksite_HQ+' \''+worksiteHQ.Name+'\', '+e.getMessage();
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resultMsg));
					system.debug(logginglevel.warn, 'Error happened in calling the webservice 3');
            		UTIL_Error.report('G2O_CustomerSearch_Enrich_VFCx.enrichCustomerRecord()', e);
            		UTIL_Error.write();
				}
			} catch (Exception e) {
				noErrors = false;
				resultMsg += Label.Could_not_Enrich_Legal_Entity+' \''+legalEntity.Name+'\', '+e.getMessage();
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resultMsg));
					system.debug(logginglevel.warn, 'Error happened in calling the webservice 4');
				UTIL_Error.report('G2O_CustomerSearch_Enrich_VFCx.enrichCustomerRecord()', e);
            	UTIL_Error.write();
			}
		}

		Database.Upsertresult[] results = Database.upsert(new Account[]{theAccount}, false);
		System.debug(logginglevel.info,'### Enriching: Upserting theAccount: result:'+results);
		
		for (integer i = 0; i<results.size(); i++)
		{
			Database.Upsertresult r = results[i];
			if (!r.isSuccess())
			{
				noErrors = false;
				resultMsg += Label.Could_not_Enrich_Account+' \''+accountsByExternalId.values()[i].Name;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resultMsg));
				
				for (Database.Error e : r.getErrors())
				{
					String errorDetail = e.getMessage()+'; ';
					for (String f : e.getfields())
					{
						// Try to output the fields and values if possible
						try
						{
							errorDetail += accountsByExternalId.values()[i].get(f)+' ';
						} catch (exception ex) {
							system.debug(logginglevel.warn, 'Error happened in calling the webservice 5');

							UTIL_Error.report('G2O_CustomerSearch_Enrich_VFCx.enrichCustomerRecord()', ex);
						}
					}
					if(UTIL_Error.reports.size() > 0){
						UTIL_Error.write();
					}
					System.debug(logginglevel.info,'### Error on account upsert: detail: '+errorDetail);
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorDetail));
					resultMsg += '\\n'+errorDetail;
				}
			}
		}
		
		// Commit the duplicate observations on the sucessfull upserts
		System.debug(logginglevel.info,'### Create duplicates... Build Id map...');
		Map<Id, Set<Id>> duplicateIdMap = new Map<Id, Set<Id>>();
		for (Id dupId : duplicates.keySet())
		{
			for (Account a : duplicates.get(dupId))
			{
				Set<id> duplicateIds = duplicateIdMap.containsKey(dupId) ? duplicateIdMap.get(dupId) : new Set<id>();
				if (a.id!=null) duplicateIds.add(a.id); // ignore accounts that failed to insert or update
				duplicateIdMap.put(dupId,duplicateIds);
			}
			if (duplicateIdMap.get(dupId).size()==0) duplicateIdMap.remove(dupId); // remove blanks
		}
		System.debug(logginglevel.info,'### Create duplicates: duplicateIdMap:'+duplicateIdMap);
		G2O_PossibleDuplicateAccount_SVC.getPossibleDuplicateRecords(duplicateIdMap, G2O_PossibleDuplicateAccount_SVC.PAR);
		
		if (noErrors) {
			// No errors creating accounts, so process the contact results
			if (isWorksite && contactSearch.result!=null && contactSearch.result.size()>0)
			{
				// Align each Contact returned to an account
				try
				{
					// Set the account on those contacts that don't exist today
					Contact[] contactsToInsert = new Contact[]{};
					for (G2O_PARSearchView_Contacts_WS.ContactWrapper c : contactSearch.result.values())
					{
						if (!c.exists)
						{
							// default account id is the selected account
							c.theContact.AccountId = theAccount.id;
							
							// Set this correctly based on relationships listed in the contact webservice response
							for (G2O_PARSearchView_Contacts_WS.RelationshipWrapper r : c.relationshipList)
							{
								if (accountsByExternalId.containsKey(r.accountExternalId))
								{
									c.theContact.AccountId = accountsByExternalId.get(r.accountExternalId).Id;
								}
							}
							
							contactsToInsert.add(c.theContact);
						}
					}
					
					System.debug(logginglevel.info,'@@ contacts to insert: '+contactsToInsert);
					if (contactsToInsert.size()>0) insert contactsToInsert;
					
					// Create ACRs
					// Includes existing contacts and accounts (trigger should take care of duplicates)
					map<String, Account_Contact_Role_Transaction__c> acrsToUpsert = new map<String, Account_Contact_Role_Transaction__c>();
			        acrsToUpsert = G2O_PARSearchView_Contacts_WS.createACRsFromContactRelationships(contactSearch.result.values());
			        
			        // Upsert to the database using the Key field Account_Contact_Role_SFID__c to avoid conflicts
			        database.upsert(acrsToUpsert.values(), Account_Contact_Role_Transaction__c.Account_Contact_Role_SFID__c, false);
					
				} catch (Exception e) {
					noErrors = false;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Could_not_create_contacts+': '+e.getMessage()));
					system.debug(logginglevel.warn, 'Error happened in calling the webservice 6');
					UTIL_Error.report('G2O_CustomerSearch_Enrich_VFCx.enrichCustomerRecord()', e);
            		UTIL_Error.write();
				}
			}
			noErrors = true;
		}
		
        System.debug(logginglevel.Info, '### END enrichCustomerRecord '); 
        
        return null;
	}
	
	static void balanceAddressFields(Account sourceData)
	{
		// Copy address details between postal and visiting addresses on the source Data object
		if(sourceData.Postal_Address_C_O__c != null || sourceData.Postal_Address_House_Number__c != null 
			|| sourceData.Postal_Address_House_Number_Supplement__c != null || sourceData.Postal_Address_Street__c != null 
			|| sourceData.Postal_Address_Suburb__c != null || sourceData.Postal_Address_City__c != null 
			|| sourceData.Postal_Address_Postal_Code__c != null || sourceData.Postal_Address_Country__c != null) 
		{
			sourceData.Visiting_Address_House_Number__c = sourceData.Postal_Address_House_Number__c;
			sourceData.Visiting_Address_House_Number_Supplement__c = sourceData.Postal_Address_House_Number_Supplement__c;
			sourceData.Visiting_Address_Street__c = sourceData.Postal_Address_Street__c;
			//sourceData.Visiting_Address_Suburb__c = sourceData.Postal_Address_Suburb__c;
			sourceData.Visiting_Address_City__c = sourceData.Postal_Address_City__c;
			sourceData.Visiting_Address_Postal_Code__c = sourceData.Postal_Address_Postal_Code__c;
			sourceData.Visiting_Address_Country__c = sourceData.Postal_Address_Country__c;
		}
	}
	
	// Perform the enrich over specified field set only: CustomerSearch_Enrich_Fields
	void enrichRecord(Account sourceData, Account accToEnrich)
	{
		// Validation rules on Corp reg number and registration country can create conflicts when reg country changes if the VAT/reg nr are invalid for the new country
		// ...we need to clear the values and accept the values from PAR; or leave them blank to avoid a validation rule breaking the enrich process
		for (Schema.FieldSetMember f: SObjectType.Account.FieldSets.CustomerSearch_Enrich_Fields.getFields())
		{
			if (f.fieldPath=='Registration_Country__c' && sourceData.Registration_Country__c != accToEnrich.Registration_Country__c)
			{
				accToEnrich.Corporate_Registration_Number__c = null;
				accToEnrich.VAT_Number__c = null;
			}
		}
		
		// Enrich the given fields
		for (Schema.FieldSetMember f: SObjectType.Account.FieldSets.CustomerSearch_Enrich_Fields.getFields())
		{
			if (UTIL_Apex.isSet(sourceData.get(f.fieldPath)))
			{
				accToEnrich.put(f.fieldPath, sourceData.get(f.fieldPath));
			}
		}
	}
	
	
	/***************** Wrapper Classes ****************/
    // Wrapper Class defined for storing a web service search result
    // Implements the Comparable interface to allow custom sorting via the standard .sort() operation on a List
	public class ResultWrapper{
		
		// Declarations
		public Account theAccount{get;set;} //nullable
		public String address{get{address=buildShortAddress(); return address;}set;}
		public Boolean isSFDC{get{return (theAccount==null ? false : theAccount.id!=null);}set;}
		public Boolean selected{get{selected = selected==null ? false : selected; return selected;} set;}
		public Boolean childSelected{get{for(ResultWrapper cws : childWorksites){if (cws.selected){return true;}}return false;} set;}
		public ResultWrapper parent{get;set;}
		
		// Contain any children (LE's will need this)
		public Boolean hasChildren{get {return childWorksites.size()>0;} set;}
		public ResultWrapper[] childWorksites{get{childWorksites=childWorksites==null? new ResultWrapper[]{}:childWorksites; childWorksites.sort(); return childWorksites;}set;}
		
	    // Constructors
	    public ResultWrapper(Account theAccount) {
	        this.theAccount = theAccount;
	    }
/*	    public ResultWrapper(Account theAccount, ResultWrapper parent) {
	        this.theAccount = theAccount;  
	        this.parent = parent;
	    }*/
/*	    public ResultWrapper(Account theAccount, Account[] childWorksites) {
	    	for (Account a: childWorksites)
	    	{
	    		ResultWrapper r = new ResultWrapper(a, this); // Pass this through so the Parent value can be populated
	    		this.childWorksites.add(r);
	    	}
	        this.theAccount = theAccount;
	    }*/
/*	    public ResultWrapper(Account theAccount, Boolean selected, list<ResultWrapper> childWorksites) {
	    	this.theAccount = theAccount;   
	        this.selected = selected;
	        this.childWorksites = childWorksites;
	    }*/
		
		String buildShortAddress()
		{
			String theAddr = '';
	        if (theAccount!=null)
			{
				theAddr += UTIL_Apex.isSet(theAccount.Postal_Address_Street__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(theAccount.Postal_Address_Street__c) : '';
		        theAddr += UTIL_Apex.isSet(theAccount.Postal_Address_Postal_Code__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(theAccount.Postal_Address_Postal_Code__c) : '';
		        theAddr += UTIL_Apex.isSet(theAccount.Postal_Address_City__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(theAccount.Postal_Address_City__c) : '';
		        theAddr += UTIL_Apex.isSet(theAccount.Postal_Address_Country__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(theAccount.Postal_Address_Country__c) : '';
			}
	        return theAddr;
		}
		
		// Compare PAR Wrapper objects based on if the Account they contain are an LE (LE's come first) and is unverified (verified first), then worksite type (HQ first) then Name, then Street then City (all alphabetical)
	    /*public Integer compareTo(Object compareTo) {
	        ResultWrapper compareToPAR = (ResultWrapper)compareTo;
	        Integer returnValue = 0; // The return value of 0 indicates that both elements are equal
	        
	        // Handle if the accounts are null or have no definition
	        if (this.theAccount==null && compareToPAR.theAccount==null)
	        {
	        	return 0;
	        }
	        if (this.theAccount!=null && compareToPAR.theAccount==null)
	        {
	        	return -1;
	        }
	        if (this.theAccount==null && compareToPAR.theAccount!=null)
	        {
	        	return 1;
	        }
	        
	        try
	        {
		        // LE's come first
		        if (this.theAccount.RecordTypeId==UTIL_Meta.getAccountLegalEntityRT())
		        {
		        	if (compareToPAR.theAccount.RecordTypeId!=UTIL_Meta.getAccountLegalEntityRT())
			        {
			        	return -1; // If this account is an LE and the other is not, then the LE comes first
			        }
					
			        if (UTIL_Apex.isSet(this.theAccount.External_Provider_Party_ID__c) && UTIL_Apex.empty(compareToPAR.theAccount.External_Provider_Party_ID__c))
			        {
			        	return -1; // If they are both LE's then it is the verified LE that comes first
			        }
		        }
	        } catch(exception e) {}
	        
	        try
	        {
		        // WS's HQ's
		        if (this.theAccount.RecordTypeId==UTIL_Meta.getAccountWorkSiteRT())
		        {
		        	if (compareToPAR.theAccount.RecordTypeId!=UTIL_Meta.getAccountWorkSiteRT())
			        {
			        	return -1; // If this account is a WS and the other is not, then the WS comes first
			        }
			        
		        	if (this.theAccount.Work_Site_Type__c == UTIL_OrgSettings.WorkSiteTypeHQ() && compareToPAR.theAccount.Work_Site_Type__c != UTIL_OrgSettings.WorkSiteTypeHQ())
			        {
			        	return -1; // Worksite HQ's come before others
			        }
		        }
	        } catch(exception e) {}
	        
	        try
	        {
		       	//  Name
		       	returnValue = this.theAccount.Name.compareTo(compareToPAR.theAccount.Name);
		       	if (returnValue!=0) return returnValue;
	        } catch(exception e) {}
	       	
	        try
	        {
		       	//  Visiting_Address_Street__c
		       	if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_Street__c) && UTIL_Apex.isSet(compareToPAR.theAccount.Visiting_Address_Street__c)) 
		       	{
		       		returnValue = this.theAccount.Visiting_Address_Street__c.compareTo(compareToPAR.theAccount.Visiting_Address_Street__c);
		       		if (returnValue!=0) return returnValue;
		       	} else if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_Street__c))
		       	{
		       		return -1;
		       	} else 
		       	{
		       		return 1;
		       	}
	        } catch(exception e) {}
	       	
	        try
	        {
		       	//  Visiting_Address_City__c
		       	if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_City__c) && UTIL_Apex.isSet(compareToPAR.theAccount.Visiting_Address_City__c)) 
		       	{
		       		returnValue = this.theAccount.Visiting_Address_City__c.compareTo(compareToPAR.theAccount.Visiting_Address_City__c);
		       		if (returnValue!=0) return returnValue;
		       	} else if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_City__c))
		       	{
		       		return -1;
		       	} else 
		       	{
		       		return 1;
		       	}
	        } catch(exception e) {}
	       	
	        try
	        {
		       	//  Visiting_Address_Country__c
		       	if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_Country__c) && UTIL_Apex.isSet(compareToPAR.theAccount.Visiting_Address_Country__c)) 
		       	{
		       		returnValue = this.theAccount.Visiting_Address_Country__c.compareTo(compareToPAR.theAccount.Visiting_Address_Country__c);
		       		if (returnValue!=0) return returnValue;
		       	} else if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_Country__c))
		       	{
		       		return -1;
		       	} else 
		       	{
		       		return 1;
		       	}
	        } catch(exception e) {}
	       	
	        return 0;       
	    }*/
	}
}