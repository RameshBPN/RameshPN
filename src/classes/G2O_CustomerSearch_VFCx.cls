/**
    About
    -----
    Description: Customer Creation for B2B Search (Record Type: Work Site, Legal Entity, External Partner & Competitor)
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    
    
    Methods:
    -------
        
    Update History
    --------------
    Created March 2013 - R.M.
    Rewritten August 2013 - ME
    CR021 Aug 2013 - ME
    
    Updaetd - Jan 2016- Added the below lines for the MVU 
    Set the field External_or_Internal__c for work sites - r.theAccount.External_or_Internal__c = theAccount.External_or_Internal__c;
    Set the field External_or_Internal__c for Legal Entity - legalEntity.External_or_Internal__c = LABEL.Customer_Type_External; 
    
    Issues / TODOs
    --------------

    TESTED
    ------
    Created a WS with an LE - ?
    Created mutiple WS for an LE - ?
    Created WS for a non-validated LE - ?
    Created mutiple WS for a non-validated LE - ?
    Create a WS for an LE - ?
    PAR Verify an existing unverified LE - ?
    
*/
public with sharing class G2O_CustomerSearch_VFCx {
    
    // Search and entry criteria
    public Account theAccount{get{theAccount = theAccount==null ? new Account() : theAccount; return theAccount;}set;}
    public Account parentAccount{get{parentAccount = parentAccount==null ? new Account() : parentAccount; return parentAccount;}set;}
    public Boolean isExistingAccount {get{return UTIL_Apex.isSet(theAccount.id);}set;} // true if this is an enrich of an existing account record
    public ID parentAccountId {get;set;}
    public String parentAccountName {get{parentAccountName = parentAccountName==null ? '' : parentAccountName; return parentAccountName;}set;}
    
    // Results
    map<Account,list<Account>> externalResults {get{externalResults = externalResults==null ? new map<Account,list<Account>>() : externalResults;return externalResults;}set;} 
    ResultWrapper[] allSearchResults {get{allSearchResults = allSearchResults==null ? new ResultWrapper[]{} : allSearchResults; searchResultsPagination=null; return allSearchResults;}set;} 
    public UTIL_Apex.Pagination searchResultsPagination {get {searchResultsPagination = searchResultsPagination==null ? new UTIL_Apex.Pagination((Object[])allSearchResults,5) : searchResultsPagination; return searchResultsPagination;}set;}
    public ResultWrapper[] searchResults {get{searchResults = new ResultWrapper[]{}; for (object o: searchResultsPagination.paginatedList){searchResults.add((ResultWrapper)o);} return searchResults;} set;}
    
    // Legal Entity Selected with Created Worksites
    public ResultWrapper selectedLegalEntity {get{selectedLegalEntity = selectedLegalEntity==null ? new ResultWrapper(new Account()) : selectedLegalEntity; return selectedLegalEntity;}set;} 
    
    // UI Feedback / Control
    public Boolean searched             {get{searched = searched==null ? false : searched;return searched;}set;} 
    public Boolean customersCreated     {get{customersCreated = customersCreated==null ? false : customersCreated;return customersCreated;}set;} 
    public Boolean isNewChildAccount    {get{isNewChildAccount = isNewChildAccount==null ? false : isNewChildAccount;return isNewChildAccount;}set;} 
    public String alertMessage          {get{alertMessage = alertMessage==null ? '':alertMessage; return alertMessage;}set;} // message to pop in alert dialogue
    public Boolean externalServiceFailure {get{externalServiceFailure = externalServiceFailure==null ? false : externalServiceFailure;return externalServiceFailure;}set;} 
    public String externalServiceFailure_Msg {get{externalServiceFailure_Msg = externalServiceFailure_Msg==null ? '':externalServiceFailure_Msg; return externalServiceFailure_Msg;}set;} // message to pop in alert dialogue
    public Boolean isWorksite           {get{return (theAccount.recordTypeId==UTIL_Meta.getAccountWorkSiteRT() || 
                                                    theAccount.recordTypeId==UTIL_Meta.getAccountCompetitorRT() ||
                                                    theAccount.recordTypeId==UTIL_Meta.getAccountExternalPartnerRT());}set;} 
    // Test Values, used by test scripts to ensure both query methods are operating correctly independantly of one another
    public boolean DISABLE_WEBSERVICE = false;
    public boolean DISABLE_SEARCHFIRST = false;
    public boolean DISABLE_QUERY = false;
    
    public G2O_CustomerSearch_VFCx(ApexPages.StandardController controller) {
        //controller.addFields(new List<String>{'Registration_Country__c'});
        theAccount = (Account)controller.getRecord();
        
        // Check the URL for record type if none set already
        if (theAccount.RecordTypeId==null)
        {
            if(ApexPages.currentPage().getParameters().containsKey('RecordType')){
                theAccount.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            }
        }
        
        // Default record type if none set
        if (theAccount.RecordTypeId==null)
        {
            theAccount.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT(); 
        }
        
        // Handle if the page has been passed parent information, it is therefore to create a child work site account
        // -Copy the Name, Corp reg number, VAT Number, Work Site reg num to the new worksite account
        if (ApexPages.currentPage().getParameters().containsKey('ParentAccountId'))
        {
            try
            {
                isNewChildAccount = true;
                parentAccountId = ApexPages.currentPage().getParameters().get('ParentAccountId');
                parentAccount = [select id,name,Corporate_Registration_Number__c,VAT_Number__c
                                from Account where id=:parentAccountId limit 1];
                theAccount.Corporate_Registration_Number__c = parentAccount.Corporate_Registration_Number__c;
                theAccount.VAT_Number__c = parentAccount.VAT_Number__c;
                theAccount.Name = parentAccount.Name;
                theAccount.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                theAccount.ParentId = parentAccountId;
            } catch (exception e)
            {
                // Parent ID or other issue in inherited information. Show error and continue to form
                Apexpages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Ext_Could_Not_Create_Child_Account+' '+e.getMessage()));
            }
        }
    }
    
    // Create an unverified account
    public PageReference createUnverified()
    {
        // If the user changes the country at the last minute on the form, double check they didn't choose DK
        if (theAccount.Postal_Address_Country__c=='DK')
        {
            return continueUnverifiedToMOD();
        }
        
        PageReference p;
        p = new PageReference('/' + Account.SObjectType.getDescribe().getKeyPrefix() + '/e');
        addSearchFieldValuesToURLParamters(theAccount, p);
        return p;
    }
    
    // Instead of creating an unverified account if DK and a Worksite; the user is sent to MOD search instead of just creating the empty record
    public PageReference continueUnverifiedToMOD()
    {
        PageReference p;
        p = Page.G2O_CustomerSearch_MOD;
        
        // Tell MOD we are passing parameters from the new customer process based on the external provider services
        p.getParameters().put('externalNew','true');
        
        // Add the search terms to the page reference so it's caught by the mod page
        // Note the 'x' is used in the URL parameter name to ensure there's no confusion between native and passed URL parameters
        for (Schema.FieldSetMember f : SObjectType.Account.FieldSets.CustomerSearch.getFields())
        {
            String fieldPath = f.fieldPath;
            if (theAccount.get(fieldPath)!=null)
            {
                p.getParameters().put('x'+fieldPath, String.valueOf(theAccount.get(fieldPath)));
            }
        }
        
        // Add the parent Id as well (applies if we are creting a WS for an LE)
        if (theAccount.parentId!=null)
        {
            p.getParameters().put('xParentId',theAccount.parentId);
        }
        
        // And the record type
        if (theAccount.RecordTypeId!=null)
        {
            p.getParameters().put('xRecordType',theAccount.RecordTypeId);
        }
        
        return p;
    }
    
    // This private method is used in Create Unverified flow to redirect to Std new edit page with values passed on
    void addSearchFieldValuesToURLParamters(Account a, PageReference p){
        Map<String, String> mapURL = p.getParameters();
        
        // Get the GenericURL map for the account object to build the URL from
        Map<String, GenericURLHacking__c> urlLabels = UTIL_OrgSettings.GenericURLHacking('Account');
        
        // Copy the values in the account's search fields into the URL parameter map based on the URL hacking map for this sObject
        List<Schema.FieldSetMember> urlFields = SObjectType.Account.FieldSets.CustomerSearch.getFields();
        
        // Add to the URL map if values are present
        // Special condition: Skip the External Provider Party Id, and duplicate visting and postal address values into both sets of fields
        for(Schema.FieldSetMember f : urlFields) 
        {
            // Trim field path to under 38 chars which is the length limit in the custom setting name field
            String theFieldPath = f.fieldPath;
            theFieldPath = theFieldPath.substring(0, theFieldPath.length()>38 ? 38 : theFieldPath.length()); 
            
            if(UTIL_Apex.isSet(a.get(f.fieldPath)) && urlLabels.containsKey(theFieldPath)) {            
                if (f.getType() == Schema.DisplayType.Boolean)
                {
                    mapURL.put(urlLabels.get(theFieldPath).URL_Field_Id__c, a.get(f.fieldPath)!=null && a.get(f.fieldPath)==true ? '1' : '0'); 
                } else if (String.valueof(f.getFieldPath()) != 'External_Provider_Party_ID__c') 
                {
                    mapURL.put(urlLabels.get(theFieldPath).URL_Field_Id__c, String.valueOf(a.get(f.fieldPath)));
                }
            }
        }
        mapURL.put('RecordType', a.RecordTypeId);
        
        // Copy parent information to the URL if creating a new child account
        if(isNewChildAccount) {
            mapURL.put(urlLabels.get('ParentAccountId').URL_Field_Id__c, parentAccount.Id);
            mapURL.put(urlLabels.get('ParentAccountName').URL_Field_Id__c, parentAccount.Name);
        }
        
        // Mandatory values
        mapURL.put('nooverride', '1');
        if(UTIL_Apex.isSet(ApexPages.currentPage().getParameters().get('retURL'))) {
            mapURL.put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
        }
        system.debug(Logginglevel.INFO,'@@ END mapURL:'+mapURL);
    }
    
    
    /**** SEARCH ****/
    public PageReference doSearch()
    {
        System.debug(Logginglevel.Error,'### Do Search: IN: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
        
        // Search both sfdc and the nominated external party
        // To avoid using wildcard searches the external search is made first, and the results used to enrich the internal search search
        
        // Set up: Clear current results, create a map for tracking returned values by key IDs and a set to contain all possible names
        allSearchResults = null;
        map <String,ResultWrapper> allSearchResultsByExternalID = new map<String,ResultWrapper>();
        map<String, ResultWrapper> allSearchResultLEsByCorpRegNumber = new map<String, ResultWrapper>();
        set <String> searchNames = new set<String>();
        alertMessage = '';
        
        // Check some values where entered in the search form
        Boolean searchCriteriaProvided = false;
        for (Schema.FieldSetMember searchField : SObjectType.Account.FieldSets.CustomerSearch.getFields())
        {   
            String fieldPath = searchField.getFieldPath();
            if (UTIL_Apex.isSet(theAccount.get(fieldPath)))
            {
                searchCriteriaProvided = true;
                break;
            }
        }
        if (!searchCriteriaProvided) 
        {
            alertMessage = Label.Ext_Please_provide_at_least_one_search_term;
            return null;
        }
        
        //Query PAR
        if (!DISABLE_WEBSERVICE)
        {
            System.debug(Logginglevel.Error,'### Do Search: Pre-Webservice: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
            try
            {
                G2O_PARSearchView_Customer_WS objSearchPAR = new G2O_PARSearchView_Customer_WS(theAccount);
                objSearchPAR.send();
                externalResults = objSearchPAR.result;
                System.debug(Logginglevel.Error, '### PAR Results '+externalResults);
                System.debug(Logginglevel.Error, '### PAR1 Results '+externalResults);
                System.debug(Logginglevel.Error, '### PAR Result Errors '+objSearchPAR.callout.errors);
                System.debug(Logginglevel.Error, '### Do Search: Post-Webservice: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
                
                if (objSearchPAR.callout.errors.size()>0)
                {
                    // Report back fist error to the user
                    externalServiceFailure = true;
                    externalServiceFailure_Msg = Label.Ext_Request_Failed+' '+objSearchPAR.callout.errors[0].description; 
                    alertMessage = externalServiceFailure_Msg;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Ext_Request_Failed+' '+objSearchPAR.callout.errors[0].description));
                }
                
                //Merge external web service results into the result wrapper
                // Index by external ID for search first application and collect names for query generalisation
                if (theAccount.Name!=null) searchNames.add(theAccount.Name);
                
                System.debug(Logginglevel.Error,'### Do Search: Pre-Merge: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
                for(Account acc: externalResults.keySet()) {
                    ResultWrapper r = new ResultWrapper(acc,externalResults.get(acc));
                    allSearchResults.add(r);
                    
                    System.debug(Logginglevel.warn,'###1 allSearchresults '+allSearchresults);
                    
                    //Index the results by external ID for search first and collect names
                    if (acc.Name!=null) searchNames.add(acc.Name);
                    allSearchResultsByExternalID.put(acc.External_Provider_Party_ID__c, r);
                    if (r.hasChildren)
                    {
                        for (ResultWrapper c : r.childWorksites)
                        {
                            if (c.theAccount.Name!=null) searchNames.add(c.theAccount.Name);
                            allSearchResultsByExternalID.put(c.theAccount.External_Provider_Party_ID__c, c);
                        }
                    }
                }
                
                System.debug(Logginglevel.Error,'### Do Search: Post-Merge: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
                
                System.debug(Logginglevel.warn,'### 1allSearchResultsByExternalID '+allSearchresults);
                // Map the external result LE's by Corporate_registration_Number__c 
                // to allow us to swap in unverified LE's that may be enriched automatically if a child WS is selected
                System.debug(Logginglevel.warn,'###2 allSearchresults '+allSearchresults);
                for (ResultWrapper r : allSearchresults)
                {
                    if (r.theAccount.Corporate_registration_Number__c!=null)
                    {
                        // note we add the country to the list to force the corp number to be unique in the map
                        allSearchResultLEsByCorpRegNumber.put(r.theAccount.Registration_Country__c+':'+r.theAccount.Corporate_registration_Number__c,r);
                    }
                }
                System.debug(Logginglevel.warn,'### allSearchResultLEsByCorpRegNumber '+allSearchResultLEsByCorpRegNumber);
                
                // Index and collect the names and Ids for use in merge and query operations
                System.debug(Logginglevel.Error,'### Do Search: Pre-Search First: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
                if (!DISABLE_SEARCHFIRST)
                {
                    applySearchFirst(allSearchResultsByExternalID, allSearchResultLEsByCorpRegNumber);
                }
            } catch(CalloutException e){
                alertMessage = Label.Error_from_Callout + ' ' + e.getMessage();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Callout + ' ' + e.getMessage()));
        
            } catch(UTIL_HttpIntegration.MappingException e){
                alertMessage = Label.Error_Field_Missing + ' ' + e.fieldPath;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Field_Missing + ' ' + e.fieldPath));
        
            } catch (Exception e){
                
                alertMessage = Label.Error_from_Salesforce;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
                UTIL_Error.report('G2O_CustomerSearch_VFCx.doSearch()', e);
                UTIL_Error.write();
            }
        }
        
        //Query SFDC
        if (!DISABLE_QUERY)
        {
            System.debug(Logginglevel.Error,'### Do Search: Pre-SFDC Search: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
                
            // Use the names returned in the query to allow some minor wild card matching to occurr
            Map<Id, Account> queryResult = querySFDC(searchNames);
            Map<Id, ResultWrapper> allSearchResultsSFDCParentNodesById = new Map<Id, ResultWrapper>();
            
            System.debug(Logginglevel.warn,'### queryResult1 '+queryResult);
            
            System.debug(Logginglevel.Error,'### Do Search: Pre-SFDC Search merge with PAR results: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
            // Append LE's, or any account with no parent (or a parent that's not an LE) to the main search results as root nodes
            for(ID accId: queryResult.keySet()) {
                Account acc = queryResult.get(accId);
                String externalId = acc.External_Provider_Party_ID__c;
                String corpRegNum = acc.Registration_Country__c+':'+acc.Corporate_Registration_Number__c;
                
                // If the item is verified, check it is not already in the list by external ID, or by corporate reg number (note filter by record type = LE for this case)
                if (externalId!=null && allSearchResultsByExternalID.containsKey(externalId) 
                    || acc.RecordTypeId == UTIL_Meta.getAccountLegalEntityRT() && corpRegNum!=null && allSearchResultLEsByCorpRegNumber.containsKey(corpRegNum))
                {
                    // Remove verified items we already have in the list
                    queryResult.remove(accId);
                } else {
                    // If it is a Legal Entity, it has no parent, or the parent it does have is not a Legal Entity
                    if (acc.RecordTypeId == UTIL_Meta.getAccountLegalEntityRT() || acc.ParentId==null || (acc.ParentId!=null && acc.Parent.RecordTypeId!=UTIL_Meta.getAccountLegalEntityRT()))
                    {
                        // Add to the main search results as root nodes and index
                        system.debug('adding SFDC result: ' + acc);
                        ResultWrapper r = new ResultWrapper(acc);
                        allSearchResults.add(r);
                        allSearchResultsSFDCParentNodesById.put(acc.Id, r);
                        queryResult.remove(accId);
                    }
                }
            }
            
            // Append the remaining worksites to their relevant parent nodes, either by ID or by external ID
            for(ID accId: queryResult.keySet()) {
                Account acc = queryResult.get(accId);
                String parentId = acc.ParentId;
                String parentExternalId = (acc.ParentId !=null ? acc.Parent.External_Provider_Party_ID__c : null);
                if (parentExternalId!=null && allSearchResultsByExternalID.containsKey(parentExternalId))
                {
                    // The parent's external id is in the list
                    ResultWrapper parentAcc = allSearchResultsByExternalID.get(parentExternalId);
                    
                    // Ensure that we don't land on a worksite by accident
                    while (parentAcc.parent!=null)
                    {
                        parentAcc = parentAcc.parent;
                    }
                    
                    // Apend to the parent
                    parentAcc.childWorksites.add(new ResultWrapper(acc, parentAcc));
                }
                else if (parentId!=null && allSearchResultsSFDCParentNodesById.containsKey(parentId))
                {
                    // The parent's SFDC id is in the list
                    ResultWrapper parentAcc = allSearchResultsSFDCParentNodesById.get(parentId);
                    
                    // Ensure that we don't land on a worksite by accident
                    while (parentAcc.parent!=null)
                    {
                        parentAcc = parentAcc.parent;
                    }
                    
                    // Apend to the parent
                    parentAcc.childWorksites.add(new ResultWrapper(acc));
                }
                else
                {
                    // No parent, or parent not found. 
                    // We should not be able to land here if the returned data was cohesive. This is only for data error condition handling.
                    // Add to the main search results as root nodes and index
                    ResultWrapper r = new ResultWrapper(acc);
                    allSearchResults.add(r);
                    allSearchResultsSFDCParentNodesById.put(acc.Id, r);
                }
            }
            System.debug(Logginglevel.Error,'### Do Search: Post-SFDC Search merge with PAR results: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
            
        }
        
        // Sort the list
        System.debug(Logginglevel.Error,'### Do Search: Pre-Sort: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
        
        System.debug(Logginglevel.warn,'### allSearchresults3 '+allSearchresults);
        System.debug(Logginglevel.warn,'### searchResults22 '+searchResults);  
        for(ResultWrapper rw : allSearchResults){
            if(rw.hasChildren){
                sortChildren(rw);
            }
        } 
        allSearchResults.sort(); 
            
        // Search complete
        searched = true;
        
        System.debug(Logginglevel.Error,'### Do Search: OUT: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
        return null;
    }
    
    // Search first: Replace items in the current search results (mapped by external ID) that already exist (match on the external id)
    void applySearchFirst(map <String,ResultWrapper> allSearchResultsByExternalID, map<String, ResultWrapper> allSearchResultLEsByCorpRegNumber)
    {
        // Populate the ID on accounts that either exist with matching external ID's (hence no duplicates are possible)
        // or corporate account number to allow an enrich on unverified LE's
        if (allSearchResultsByExternalID.size()>0)
        {
            // Set the ID of those records in allSearchResultsByExternalID where the external ID exists
            // Remove empties
            // >> Note. The web service should be stripping any empty external references already.
            Set<String> externalIds = allSearchResultsByExternalID.keySet();
            externalIds.remove(null);
            externalIds.remove('');
            
            // Swap out items based on the external provider party Id
            System.debug(logginglevel.Info, '### START applySearchFirst ( '+ allSearchResultsByExternalID+')');
            for(Account matchingAcc :[SELECT Id, Name, Corporate_registration_Number__c, Work_Site_Type__c, Verified__c, 
                                        Short_Name__c, Metaphone_Primary_Encoding__c, ParentId, RecordTypeId,
                                        RecordType.Name, IsPersonAccount, Postal_Address_Street__c, Registration_Country__c,
                                        Postal_Address_Postal_Code__c,  Postal_Address_City__c, Postal_Address_Country__c, 
                                        Visiting_Address_Street__c, Visiting_Address_Postal_Code__c,  Visiting_Address_City__c, 
                                        Visiting_Address_Country__c, Work_Site_Registration_Number__c,External_Provider_Party_ID__c, 
                                        External_Provider_Party_Parent_ID__c,External_Work_Site_Status__c,External_Legal_Entity_Status__c,
                                        Work_Site_Name__c 
                                        FROM Account 
                                        WHERE External_Provider_Party_ID__c in :externalIds
                                        AND (RecordTypeId=:UTIL_Meta.getAccountWorkSiteRT() OR 
                                        RecordTypeId=:UTIL_Meta.getAccountCompetitorRT() OR 
                                        RecordTypeId=:UTIL_Meta.getAccountExternalPartnerRT() OR 
                                        RecordTypeId=:UTIL_Meta.getAccountLegalEntityRT())
                                        LIMIT 9999]) {
                if (allSearchResultsByExternalID.containsKey(matchingAcc.External_Provider_Party_ID__c))
                {
                    ResultWrapper r = allSearchResultsByExternalID.get(matchingAcc.External_Provider_Party_ID__c);
                    r.theAccount = matchingAcc;
                }
            }
        }
            
        // Set the ID of those records in allSearchResultLEsByCorpRegNumber where the corporate ID exists, and are UNVERIFIED
        if (allSearchResultLEsByCorpRegNumber.size()>0)
        {
            // Get the reg numbers and countries to check against
            Set<String> corpNumbers = new Set<String>();
            Set<String> countries = new Set<String>();
            
            for (ResultWrapper r : allSearchResultLEsByCorpRegNumber.values())
            {
                corpNumbers.add(r.theAccount.Corporate_registration_Number__c);
                countries.add(r.theAccount.Registration_Country__c);
            }
            
            // These records will be enriched by the external result if a child WS is selected
            for(Account matchingAcc :[SELECT Id, Name, Corporate_registration_Number__c, Work_Site_Type__c, Verified__c, 
                                        Short_Name__c, Metaphone_Primary_Encoding__c, ParentId, RecordTypeId,
                                        RecordType.Name, IsPersonAccount, Postal_Address_Street__c, Registration_Country__c,
                                        Postal_Address_Postal_Code__c,  Postal_Address_City__c, Postal_Address_Country__c, 
                                        Visiting_Address_Street__c, Visiting_Address_Postal_Code__c,  Visiting_Address_City__c, 
                                        Visiting_Address_Country__c, Work_Site_Registration_Number__c,External_Provider_Party_ID__c, 
                                        External_Provider_Party_Parent_ID__c,External_Work_Site_Status__c,External_Legal_Entity_Status__c,
                                        Work_Site_Name__c 
                                        FROM Account 
                                        WHERE Corporate_registration_Number__c in : corpNumbers
                                        AND RecordTypeId=:UTIL_Meta.getAccountLegalEntityRT()
                                        AND Registration_Country__c in : countries
                                        AND (External_Provider_Party_Parent_ID__c=null OR External_Provider_Party_Parent_ID__c='')
                                        LIMIT 9999]) {
            
            String corpRegNum = matchingAcc.Corporate_registration_Number__c;
            String country = matchingAcc.Registration_Country__c;
            String key = country+':'+corpRegNum;
            
            ResultWrapper r = allSearchResultLEsByCorpRegNumber.get(key);
            
            if (r!=null && r.theAccount.External_Provider_Party_Parent_ID__c==null)
            {
                System.debug(Logginglevel.INFO,'### Setting ID on returned LE ('+r.theAccount+') to the values of the existing account (id: '+matchingAcc+'), so it enriches the existing record with PAR data');
                r.theAccount.id = matchingAcc.id;
                r.theAccount.Name = matchingAcc.Name; // Display the salesforce name rather than the PAR result. All other details will be copied
                System.debug(Logginglevel.INFO,'### Setting ID on an LE that should be enriched by PAR due to corp reg number match: Result wrapper gets theAccount: '+theAccount);                 }
            }
        }
        
        System.debug(logginglevel.Info, '### END applySearchFirst');
    }
    
    // Dynamic query based on the user input's for customer Search.
    Map<Id, Account> querySFDC(set<string> searchNames) {
        System.debug(logginglevel.Info, '### START querySFDC');
        System.debug(logginglevel.Info, '### Names to be included in the search: searchNames: '+searchNames);
        
        //Get the encoded an short versions of the given names
        if (theAccount.Name!=null) G2O_Account_SVC.applySerchFirstNaming(theAccount);
        
        // put the fields of the field set in the list
        list<Schema.FieldSetMember> searchFields = SObjectType.Account.FieldSets.CustomerSearch.getFields();
        searchFields.remove(10); // It will exclude the Newly added field 'External_or_Internal__c' in the search.
                // Build the select from the search fields
        String query = 'SELECT Id, Registration_Country__c, Name, Short_Name__c, Metaphone_Primary_Encoding__c, Work_Site_Type__c, Verified__c, ParentId, Parent.Id, Parent.Verified__c, Parent.Name, Parent.RecordTypeId, Parent.RecordType.Name, Parent.External_Provider_Party_ID__c, RecordType.Name, IsPersonAccount, Postal_Address_Street__c, Postal_Address_Postal_Code__c,  Postal_Address_City__c, Postal_Address_Country__c, External_Provider_Party_ID__c,External_Work_Site_Status__c,External_Legal_Entity_Status__c,Work_Site_Name__c';
        for(Schema.FieldSetMember f : searchFields) {
            if (query.indexOf(f.getFieldPath())==-1) query += ', ' + f.getFieldPath();
        }
        query += ' FROM Account ';
        
        // WHERE clauses
        //Build from the name + search criteria, OR the PAR / worksite numbers
        String whereClause = '';
        String addressClause = '';
        String nameClause = '';
        
        // Work site registration number
        if(UTIL_Apex.isSet(theAccount.Work_Site_Registration_Number__c)) {
            whereClause += 'Work_Site_Registration_Number__c =\''+theAccount.Work_Site_Registration_Number__c+'\'';
        }
        // External provider party id
        if(UTIL_Apex.isSet(theAccount.External_Provider_Party_ID__c)) {
            whereClause += (whereClause!='' ? ' OR ' : '') + 'External_Provider_Party_ID__c =\''+theAccount.External_Provider_Party_ID__c+'\'';
        }
        if (whereClause=='')
        {
            // Search criteria
            String andOrCondition;
            for (Schema.FieldSetMember searchField : searchFields)
            {   
                String fieldPath = searchField.getFieldPath();
                System.debug(logginglevel.Info, '### Build query from: '+fieldPath+': '+theAccount.get(fieldPath));
                System.debug(logginglevel.Info, '### Build query from: searchNames: '+searchNames);
                andOrCondition = '';
                if (fieldPath=='Name' && searchNames.size()>0 && UTIL_Apex.isSet(theAccount.name)) 
                {
                    // Names clause
                    // Name needs to search mutiple fields for alt spellings and include the searchNames set to allow some fuzzy matching on the name to occurr without a 'LIKE' match
                    if (UTIL_Apex.isSet(searchNames)) nameClause = ' Name in :searchNames ';
                    if (UTIL_Apex.isSet(theAccount.Metaphone_Primary_Encoding__c)) nameClause += ( ' OR Metaphone_Primary_Encoding__c' + ' =\''+String.escapeSingleQuotes(theAccount.Metaphone_Primary_Encoding__c)+'\'');
                    if (UTIL_Apex.isSet(theAccount.Short_Name__c)) nameClause += ( ' OR Short_Name__c' + ' =\''+String.escapeSingleQuotes(theAccount.Short_Name__c)+'\'');
                } else if (fieldPath.toLowerCase().indexOf('_address')!=-1)// && searchField.getType() != Schema.Displaytype.PICKLIST)
                {
                    // Addresses clause
                    // Search both the visting and postal addresses lines for a good match likelihood
                    if (UTIL_Apex.isSet(theAccount.get(fieldPath))) 
                    {
                        String fieldPath_Post = fieldPath.replace('Visiting','Postal');
                        addressClause += addressClause!='' ? ' AND ' : '';
                        addressClause += '(';
                        addressClause += fieldPath + ' = \''+String.escapeSingleQuotes(String.valueof(theAccount.get(fieldPath)))+'\'';
                        addressClause += ' OR ';
                        addressClause += fieldPath_Post + ' = \''+String.escapeSingleQuotes(String.valueof(theAccount.get(fieldPath)))+'\'';
                        addressClause += ')';
                    }
                } else {
                    // Everything else
                    if (UTIL_Apex.isSet(theAccount.get(fieldPath))) whereClause += (whereClause!='' ? ' OR ':'') + fieldPath + ' =\''+String.escapeSingleQuotes(String.valueof(theAccount.get(fieldPath)))+'\'';
                }
                System.debug(logginglevel.Info, '### Build query nameClause: '+nameClause);
                System.debug(logginglevel.Info, '### Build query addressClause: '+addressClause);
                System.debug(logginglevel.Info, '### Build query whereClause: '+whereClause);
            }
        }
        whereClause = ' WHERE (RecordTypeId=\''+UTIL_Meta.getAccountWorkSiteRT()+'\' OR RecordTypeId=\''+UTIL_Meta.getAccountExternalPartnerRT()+'\'OR RecordTypeId=\''+UTIL_Meta.getAccountCompetitorRT()+'\' OR RecordTypeId=\''+UTIL_Meta.getAccountLegalEntityRT()+'\')' + (whereClause!='' ? ' AND ('+ whereClause+')':'');
        if (nameClause!='' || addressClause!='')
        {
            whereClause += nameClause!='' ? ' AND ('+ (nameClause!='' ? nameClause : '') +')' : '';
            whereClause += addressClause!='' ? ' AND ('+ (addressClause!='' ? addressClause : '') +')' : '';
        }
        query += whereClause;
        query += ' LIMIT 200';
        System.debug(logginglevel.Info, '### Built query: '+query);
        
        Map<Id, Account> queryResult = new Map<Id, Account>(  (List<Account>) Database.query( query ) );
        System.debug(logginglevel.Info, '### Built query database result: '+queryResult);
        
        System.debug(logginglevel.Info, '### END querySFDC');
        return queryResult;
    }
    
    
    
    /**** CREATE ****/
    public PageReference createSelected()
    {
        System.debug(logginglevel.Info, '### START createSelected ( '+ allSearchResults+')');
        alertMessage = '';
        
        // Check that anything was returned by the search
        if(allSearchResults.size() > 0){        
            //Get the legal entity containing the WS to create
            //Check the selected data to ensure multiple LE's haven't been chosen 
            String LEExternalId = '';
            selectedLegalEntity = null;     
            for (ResultWrapper r : allSearchResults)
            {
                if (LEExternalId!='' && r.childSelected)
                {
                    alertMessage = Label.PAR_Multiple_LE_Error;
                    return null;
                } else if (r.childSelected)
                {
                    LEExternalId=r.theAccount.External_Provider_Party_ID__c;
                    selectedLegalEntity = r;
                }
            }
            if (!selectedLegalEntity.childSelected)
            {
                alertMessage = Label.Ext_No_Selected_Worksite;
                return null;
            }
            
            // Next, ensure no front end issue has ocurred from javascript or apex logic by double checking the key value on the parent
            if (UTIL_Apex.empty(selectedLegalEntity.theAccount.External_Provider_Party_ID__c))
            {
                alertMessage = Label.Ext_Tech_LE_Has_No_ID;
                return null;
            }
            
            // Check the HQ has been selected. If it's not already in SFDC and has not been selected, then select it automatically.
            for (ResultWrapper r : selectedLegalEntity.childWorksites)
            {
                if (!r.isSFDC && r.theAccount.Work_Site_Type__c == UTIL_OrgSettings.WorkSiteTypeHQ())
                {
                    r.selected = true;
                }
            }
            
            // Collect all the LE and worksite records to be worked with
            Account[] worksites = new Account[]{};
            for(ResultWrapper r : selectedLegalEntity.childWorksites)
            {
                if (r.selected)
                {
                    r.theAccount.Process_as_Integration_User__c = true; // Set the 'Process_as_Integration_User__c' flag so that it is processed as such by the account triggers
                    r.theAccount.External_or_Internal__c = theAccount.External_or_Internal__c; //Set the field External_or_Internal__c for work sites
                    worksites.add(r.theAccount);
                }
            }
            
            // If the WS is being created for an existing LE, and the LE is not verified, enrich it (setting the ID will cause an enrich)
            if (theAccount.parentId!=null && selectedLegalEntity.theAccount.id==null)
            {
                Account parentAccount = [select id,Name,External_Provider_Party_ID__c from Account where id=:theAccount.parentId];
                if (parentAccount!=null && parentAccount.External_Provider_Party_ID__c==null || parentAccount.External_Provider_Party_ID__c=='')
                {
                    Account existingLEtoUpdate = selectedLegalEntity.theAccount;
                    existingLEtoUpdate.id = parentAccount.Id;
                    existingLEtoUpdate.Name = parentAccount.Name; // Display the salesforce name rather than the PAR result. All other details will be copied
                    existingLEtoUpdate.Process_As_Integration_User__c = true; // Process as an enrich from integrations
                }
            }
            
            // Define the final LE record
            Account legalEntity = selectedLegalEntity.theAccount;
            legalEntity.Process_as_Integration_User__c = true; // Set the 'Process_as_Integration_User__c' flag so that it is processed as such by the account triggers
            legalEntity.External_or_Internal__c = LABEL.Customer_Type_External; //Set the field External_or_Internal__c for Legal Entity
            
            // Request contacts from External Service with search first matching option "true"
            Account[] allAccounts = new Account[]{legalEntity};
            allAccounts.addAll(worksites);
            
            G2O_PARSearchView_Contacts_WS contactsWebservice = new G2O_PARSearchView_Contacts_WS(allAccounts);
            contactsWebservice.opt_ApplySearchFirst = true;
            
            try
            {
                if(!test.isrunningtest()){
                    // Call the webservice to get the contacts for our worksites
                    contactsWebservice.send();
                    
                    if (contactsWebservice.callout.errors.size()>0)
                    {
                        // Compile any error messages to display on the page
                        alertMessage = Label.Ext_Contact_Request_Failed+'\\n';
                        for (UTIL_HttpIntegration.ErrorContainer e : contactsWebservice.callout.errors)
                        {
                            System.debug(logginglevel.Info, '### Error fetchContacts ( '+e+')');
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.description));
                            alertMessage = e.description + '\\n';
                        }
                    }
                }
                
                /*** NO MORE CALLOUTS!!! ***/
                
                // Update or insert The Legal Entity
                if (!selectedLegalEntity.isSFDC)
                {
                    // Insert the record. Do an upsert based on the External Provider Party Id to avoid any cross system conflicts and marge with any preexisting items added during the search process by other users
                    Database.UpsertResult dmlResult = Database.upsert(legalEntity, Account.Fields.External_Provider_Party_Id__c, false); // TODO: Attach errors to some objects so we can show them in the results screen, if required.
                    if (dmlResult.getErrors().size()>0)
                    {
                        alertMessage = dmlResult.getErrors().size()+' '+Label.Could_not_create_accounts;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, alertMessage));
                        for (Database.Error err : dmlResult.getErrors())
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage()));
                        }
                    }
                } else {
                    // The record exists, so upsert it using the native id explicitly
                    Database.UpsertResult dmlResult = Database.upsert(legalEntity); // TODO: Attach errors to some objects so we can show them in the results screen, if required.
                    if (dmlResult.getErrors().size()>0)
                    {
                        alertMessage = dmlResult.getErrors().size()+' '+Label.Could_not_create_accounts;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, alertMessage));
                        for (Database.Error err : dmlResult.getErrors())
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage()));
                        }
                    }
                }
                
                // Parent the worksites to ensure they all have the LE as parent record (new WS's wont already have this field set)
                // Ensure the record types reflect the record type selected on create (unless a legal entity, then default to worksite)
                System.debug(Logginglevel.info, '### theAccount: '+theAccount);
                ID recordTypeId = theAccount.RecordTypeId;
                for(ResultWrapper r : selectedLegalEntity.childWorksites)
                {
                    if (r.selected)
                    {
                        r.theAccount.ParentId = legalEntity.Id;
                        
                        // Pass through the main account's record type, unless an LE; default is worksite
                        if(recordTypeId != UTIL_Meta.getAccountLegalEntityRT()) {
                            r.theAccount.RecordTypeId = recordTypeId;
                        } else {
                            r.theAccount.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
                        }
                        
                        // If a competitor, set the competitor flag to true /note: should be handled by workflow/
                        if(recordTypeId == UTIL_Meta.getAccountCompetitorRT()) {
                            r.theAccount.Competitor__c = true;
                        }
                    }
                }
                System.debug(Logginglevel.info, '### selectedLegalEntity.childWorksites: '+selectedLegalEntity.childWorksites);
                
                // Update or insert the worksites 
                // Use external ID as the key
                System.debug(Logginglevel.info, '### worksites: '+worksites);
                Database.UpsertResult[] dmlResults = Database.upsert(worksites, Account.Fields.External_Provider_Party_Id__c, false); 
                Boolean createdWorksites = true;
                
                for (integer i=(dmlResults.size()-1); i>=0; i--)
                {
                    Database.UpsertResult dmlresult = dmlResults[i];
                    if (dmlResult.getErrors().size()>0)
                    {
                        createdWorksites = false;
                        alertMessage = Label.Could_not_create_accounts+': ('+dmlResult.getErrors().size()+')';
                        for (Database.Error err : dmlResult.getErrors())
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, worksites[i].Name+': '+err.getMessage()));
                        }
                        // remove the error from the list so we don't show it as created
                        worksites.remove(i);
                    }
                }
                System.debug(Logginglevel.info, '### dmlResults: '+dmlResults);
                System.debug(Logginglevel.info, '### worksites: '+worksites);
                
                // Present the worksites created/enriched only under the legal entity for display on the page (ie remove the unchecked items)
                ResultWrapper[] shortlist = new ResultWrapper[]{};
                for(Account w : worksites)
                {
                    shortlist.add(new ResultWrapper(w, selectedLegalEntity));
                }
                selectedLegalEntity.childWorksites = shortlist;
                System.debug(Logginglevel.info, '### shortlist: '+shortlist);
                
                if (createdWorksites)
                {
                    // Process Contacts
                    Contact[] newContactList = new Contact[]{};
                    
                    // Parent and insert new contacts with a worksite account
                    for (String externalContactId : contactsWebservice.result.keySet())
                    {
                        G2O_PARSearchView_Contacts_WS.ContactWrapper c = contactsWebservice.result.get(externalContactId);
                        if (!c.exists) {
                            // Contact is new, set the account Id to a worksite in our list (we can't know which is the primary if there are mutiple returned)
                            for (Account w : worksites)
                            {
                                String accExternalId = w.External_Provider_Party_ID__c;
                                if (accExternalId!=null && contactsWebservice.param_accountsByExternalId.containsKey(accExternalId))
                                {
                                    c.theContact.AccountId = contactsWebservice.param_accountsByExternalId.get(accExternalId).Id;
                                    break;
                                }
                            }
                            
                            // Error check that a contact was not returned as an orphan
                            if (c.theContact.AccountId==null) 
                            {
                                System.debug(LoggingLevel.ERROR,'@@ Error when processing contacts. Contact with no Account: '+c);
                                contactsWebService.result.remove(externalContactId);
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Orphaned_contact+' : External Provider Party ID: '+externalContactId));
                            } else {
                                newContactList.add(c.theContact);
                            }
                        }
                    }
                    insert newContactList;
                    
                    // Create ACRs
                    // Includes existing contacts and accounts (trigger should take care of duplicates)
                    map<String, Account_Contact_Role_Transaction__c> acrsToUpsert = new map<String, Account_Contact_Role_Transaction__c>();
                    acrsToUpsert = G2O_PARSearchView_Contacts_WS.createACRsFromContactRelationships(contactsWebservice.result.values());
                    
                    // Upsert to the database using the Key field Account_Contact_Role_SFID__c to avoid conflicts
                    database.upsert(acrsToUpsert.values(), Account_Contact_Role_Transaction__c.Account_Contact_Role_SFID__c, false);
                    
                    System.debug(logginglevel.Info, '### END showCreatedAccount');
                    
                    // If only 1 WS created, fwd to that page, otherwise refesh the page to show the results
                    if (worksites.size()>1)
                    {
                        customersCreated = true;
                        return null;
                    } else {
                        PageReference pr = new PageReference('/'+worksites[0].Id); 
                        customersCreated = true;
                        //return null;
                        return pr;
                    }
                }
            } catch (Exception e) {
                System.debug(logginglevel.Info, '### Error fetchContacts Exception ( '+e+')');
                alertMessage = Label.Ext_Could_Not_Create_Contacts+' '+e.getMessage()+' '+alertMessage;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
            }
        }
        else{
            alertMessage = Label.Ext_No_Selected_Worksite;
        }   
        return null;        
    }
    
    public void sortChildren(ResultWrapper rw){
        rw.childWorksites.sort();
        for(ResultWrapper childRw : rw.childWorksites){
            if(childRw.hasChildren){
                sortChildren(childRw);
            }
        }
    }
    
    /***************** Wrapper Classes ****************/
    // Wrapper Class defined for storing a web service search result
    // Implements the Comparable interface to allow custom sorting via the standard .sort() operation on a List
    public class ResultWrapper implements Comparable {
        
        // Declarations
        public Account theAccount{get;set;} //nullable
        public String address{get{address=buildShortAddress(); return address;}set;}
        public Boolean isSFDC{get{return (theAccount==null ? false : theAccount.id!=null);}set;}
        public Boolean selected{get{selected = selected==null ? false : selected; return selected;} set;}
        public Boolean childSelected{get{for(ResultWrapper cws : childWorksites){if (cws.selected){return true;}}return false;} set;}
        public ResultWrapper parent{get;set;}
        
        // Contain any children (LE's will need this)
        public Boolean hasChildren{get {return childWorksites.size()>0;} set;}
        public ResultWrapper[] childWorksites{get{childWorksites=childWorksites==null? new ResultWrapper[]{}:childWorksites; return childWorksites;}set;}
        
        // Constructors
        public ResultWrapper(Account theAccount) {
            this.theAccount = theAccount;
        }
        public ResultWrapper(Account theAccount, ResultWrapper parent) {
            this.theAccount = theAccount;  
            this.parent = parent;
        }
        public ResultWrapper(Account theAccount, Account[] childWorksites) {
            for (Account a: childWorksites)
            {
                ResultWrapper r = new ResultWrapper(a, this); // Pass this through so the Parent value can be populated
                this.childWorksites.add(r);
            }
            this.theAccount = theAccount;
        }

        public String getRTName()
        {
            if (theAccount.RecordTypeId!=null)
            {
                return UTIL_Meta.getRTName(theAccount.RecordTypeId);
            }
            return '';
        }
        
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
        public Integer compareTo(Object compareTo) {
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
                } else if (compareToPAR.theAccount.RecordTypeId==UTIL_Meta.getAccountLegalEntityRT() && this.theAccount.RecordTypeId!=UTIL_Meta.getAccountLegalEntityRT()) {
                    return 1; // if the compare to acount is an LE and this account is not, then the LE should come first
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
                    
                    if (this.theAccount.Work_Site_Type__c == UTIL_OrgSettings.WorkSiteTypeHQ() 
                        && compareToPAR.theAccount.Work_Site_Type__c != UTIL_OrgSettings.WorkSiteTypeHQ())
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
                if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_Street__c) 
                    && UTIL_Apex.isSet(compareToPAR.theAccount.Visiting_Address_Street__c)) 
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
                if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_City__c) 
                    && UTIL_Apex.isSet(compareToPAR.theAccount.Visiting_Address_City__c)) 
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
                if (UTIL_Apex.isSet(this.theAccount.Visiting_Address_Country__c) 
                    && UTIL_Apex.isSet(compareToPAR.theAccount.Visiting_Address_Country__c)) 
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
        }
    }
}