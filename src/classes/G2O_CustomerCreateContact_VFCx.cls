/**
    About
    -----
    Description: Contact Creation
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
        1. Search the contacts on different parameters like Corporate Registration Number, Account Name, First Name, Last Name, Primary Position
        2. If the Account Name is Verified, i.e. has External Provider Party Id (PAR Id), both SFDC & PAR results should be shown.
        3. If the Account Name is Not Verified, i.e. has no External Provider Party Id (PAR Id), only SFDC Results should be shown
        4. If the user selects PAR Contacts (which has exisiting PAR Id in sfdc) OR SFDC Contact, only Account Contact Role(ACR) is created.
        5. If the user selects PAR Contacts (which does not have anexisiting PAR Id in sfdc) a contact is created.
        
    Wrapper Classes Created:
    -----------------------
    ContactWrapper
        
    Update History
    --------------
    Created May 2013 - R.M.
    Refactored Aug 2013 - M.E.
    CR012 Aug 2013 - M.E.
    
    Issues / TODOs
    --------------

*/

public with sharing class G2O_CustomerCreateContact_VFCx {
    
    public Contact theContact{get{theContact = theContact==null ? new Contact() : theContact; return theContact;} set;} // to store contact from standard controller
    public Account theAccount{get{theAccount = theAccount==null ? new Account() : theAccount; return theAccount;} set;} // to store contact from standard controller
    
    // Results
    ContactWrapper[] allSearchResults {get{allSearchResults = allSearchResults==null ? new ContactWrapper[]{} : allSearchResults; return allSearchResults;}set{allSearchResults=value;searchResultsPagination=null;}}       // list containing contacts from SFDC as well as External service 
    public UTIL_Apex.Pagination searchResultsPagination {get {searchResultsPagination = searchResultsPagination==null ? new UTIL_Apex.Pagination((Object[])allSearchResults,10) : searchResultsPagination; return searchResultsPagination;}set;}
    public ContactWrapper[]     searchResults {get{searchResults = new ContactWrapper[]{}; for (object o: searchResultsPagination.paginatedList){searchResults.add((ContactWrapper)o);} return searchResults;} set;}
    
    // UI Display & control
    public boolean noResults {get{return searchResults.size()==0;}set;} // confirm results where made
    public boolean searched {get{searched = searched==null ? false : searched; return searched;}set;}   // Confirm a search has been made
    public boolean hasAccountAssigned {get{hasAccountAssigned = hasAccountAssigned==null ? false : hasAccountAssigned; return hasAccountAssigned;}set;} // The contact is being created from an account page
    public boolean checkAllToggle {get{checkAllToggle = checkAllToggle==null ? true : checkAllToggle; return checkAllToggle;}set;} // Toggle to check all or uncheck all. Done by controller so that viewstate is updated
    public String alertMessage {get{alertMessage = alertMessage==null ? '' : alertMessage; return alertMessage;}set;}
    
    /***** Constructor *****/
    public G2O_CustomerCreateContact_VFCx(ApexPages.StandardController controller) {
        
        theContact = (Contact)controller.getRecord();   // assigning contact values to the standard controller object
        if (theContact.AccountId!=null)
        {
            // For contacts that have the account passed into the controller, do not allow them to select a different account
            theAccount = getAccount(theContact.accountId);
            hasAccountAssigned = true;
        }
    }
    
    /***** UI *****/
    public PageReference checkAll()
    {
        // Reverse the check on all items
        for (ContactWrapper c : searchResults)
        {
            c.selected = true;
        }
        return null;
    }
    
    public PageReference findContacts()
    {
        alertMessage = '';
        contactSearch();
        System.debug(logginglevel.Info, '### searchResultsPagination '+searchResultsPagination);
        if (searchResults.size()==0)
        {
            alertMessage += Label.Contact_Create_No_Results;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Contact_Create_No_Results));
        }
        return null;
    }
    
    public PageReference createUnverified()
    {
        return createUnverifiedPageReference();
    }
    
    
    public PageReference createContacts()
    {
        alertMessage = '';
        try
        {
            createAndUpdateSelectedContact();
            PageReference p = new PageReference('/'+theAccount.Id);
            return p;
        } catch (Exception e) {
            alertMessage = Label.Ext_Could_Not_Create_Contacts;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Ext_Could_Not_Create_Contacts));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()+' l.'+e.getLineNumber()));
            UTIL_Error.report('G2O_CustomerCreateContact_VFCx.createContacts()', e);
            UTIL_Error.write();
            
        }
        return null;
    }
    
    
    
    
    /**** **** **** **** **** **** ****
        Logic 
    /**** **** **** **** **** **** ****/
    
    Account getAccount(ID accountId)
    {
        return [SELECT Name, IsPersonAccount, Involved_Party_ID__c, External_Provider_Party_Id__c, 
                                    Corporate_Registration_Number__c, Registration_Country__c 
                                    FROM Account WHERE Id =: accountId limit 1];
    }
    
    /**** Create ****/
    void createAndUpdateSelectedContact()
    {
        System.debug(logginglevel.Info, '### START createAndUpdateSelectedContact');
        
        // Process the contact that have been selected that are not on the searched account if they exist, or are new from the external service
        ContactWrapper[] selectedResults = new ContactWrapper[]{};
        
        for (ContactWrapper result : allSearchResults)
        {
            if (result.selected && result.selectable)
            {
                selectedResults.add(result);
                System.debug(logginglevel.Info, '### Selected result '+result);
            }
        }
        
        // If they do not have an ID they are new*, and should be inserted
        // *The search first option on the web service must match any external ID's against existing contacts in the search method, before we get here
        Contact[] contactsToInsert = new Contact[]{};
        for (ContactWrapper w : selectedResults)
        {
            if (w.theContact.id==null)
            {
                contactsToInsert.add(w.theContact);
            }
        }
        System.debug(logginglevel.Info, '### contactsToInsert: '+contactsToInsert);
        insert contactsToInsert;
        
        // Create the ACR records based on the external relationships
        map<String, Account_Contact_Role_Transaction__c> acrsToUpsert = new map<String, Account_Contact_Role_Transaction__c>();
        acrsToUpsert = G2O_PARSearchView_Contacts_WS.createACRsFromContactRelationships((G2O_PARSearchView_Contacts_WS.ContactWrapper[]) selectedResults);
        System.debug(logginglevel.Info, '### acrsToUpsert (from PAR results): '+acrsToUpsert);
        
        // Create the additional ACRs based on the existing internal records
        for (ContactWrapper w : selectedResults)
        {
        	Account_Contact_Role_Transaction__c accountACR = new Account_Contact_Role_Transaction__c();
	        accountACR.Contact__c = w.theContact.Id;
	        accountACR.Account__c = theAccount.Id;
	        G2O_AccountContactRole_SVC.setKey(accountACR, theAccount.Involved_Party_ID__c,  w.theContact.Contact_Person_ID__c);
            if (accountACR.Account_Contact_Role_SFID__c!=null && !acrsToUpsert.containsKey(accountACR.Account_Contact_Role_SFID__c))
            {
                acrsToUpsert.put(accountACR.Account_Contact_Role_SFID__c, accountACR);
            }
        }
        System.debug(logginglevel.Info, '### acrsToUpsert (PAR + SFDC): '+acrsToUpsert);
        
        // Upsert to the database using the Key field Account_Contact_Role_SFID__c to avoid conflicts
        database.upsert(acrsToUpsert.values(), Account_Contact_Role_Transaction__c.Account_Contact_Role_SFID__c, false);
        System.debug(logginglevel.Info, '### END createAndUpdateSelectedContact');
    }
    
    
    /**** Search ****/
    // Search SFDC and External Provider for Contacts
    void contactSearch()
    {
        System.debug(logginglevel.Info, '### START contactSearch');
        searched = true;
        
        // Refresh the account, based on the lookup value of the Contact (if changed) - this is a mandatory field
        theAccount = getAccount(theContact.accountId);
        
        // Prepare attributes to collect the results
        set<id> contactsToIgnore = new set<id>();
        map<String, ContactWrapper> externalContacts = new map<String, ContactWrapper>();
        allSearchResults = null;
        alertMessage = '';
        
        System.debug(logginglevel.Info, '### searchExternalProvider? theAccount.External_Provider_Party_ID__c!=null ? '+(theAccount.External_Provider_Party_ID__c!=null));
        if (theAccount.External_Provider_Party_ID__c!=null)
        {
            // Search external provider
            System.debug(logginglevel.Info, '### Call searchExternalProvider');
            externalContacts = searchExternalProvider();
            System.debug(logginglevel.Info, '### Returned from searchExternalProvider');
        }
        
        // Search SFDC
        System.debug(logginglevel.Info, '### Search SFDC');
        ContactWrapper[] sfdcContacts = searchSfdcContacts(externalContacts.keySet()); //Tell the method to ignore the externalIds returned by the service
        
        // Merge results
        allSearchResults.addAll(sfdcContacts);
        allSearchResults.addAll(externalContacts.values());
        allSearchResults.sort();
        System.debug(logginglevel.Info, '### allSearchResults '+allSearchResults);
        System.debug(logginglevel.Info, '### theAccount '+theAccount);
        
        // Define account relationships
        // For new contacts; ensure the account field is set
        // For existing contact, find those contacts with account contact roles that point to this account. 
        // If an ACR already exist connecting the contact to the Account then don't allow the user to select it.
        map<ID, ContactWrapper> acrSearchContacts = new map<ID, ContactWrapper>();
        for (ContactWrapper w : allSearchResults)
        {
            if (w.primaryAccount == null) {
				// No Account was found for a contact, therefore it is new and should be defaulted to this account
				w.primaryAccount = theAccount;
				w.theContact.AccountId = theAccount.id;
			} else if (w.exists && w.primaryAccount.Id == theAccount.id)
			{
                // A relationship exists on the contact and account already 
                w.selectable = false;
                System.debug(logginglevel.Info, '### Disable select: '+(w.exists && w.primaryAccount.Id == theAccount.id)+' w: '+w+' theAccount:'+theAccount);
            } else if (w.exists) {
                //  A relationship might exist exists on the contact and account already, add to the list to check from the ACRT table
                acrSearchContacts.put(w.theContact.id, w);
            }
        }
        for (Account_Contact_Role_Transaction__c a : [select id, Contact__c, Account__c from Account_Contact_Role_Transaction__c where Contact__c in:acrSearchContacts.keySet()])
        {
            // A relationship exists on the contact and account already
            if (a.Account__c == theAccount.id)
            {
                acrSearchContacts.get(a.Contact__c).selectable = false;
            }
        }
        System.debug(logginglevel.Info, '### allSearchResults '+allSearchResults);
        
        System.debug(logginglevel.Info, '### END contactSearch');
    }
    
    // Search external provider
    map<String, ContactWrapper> searchExternalProvider() {
        System.debug(logginglevel.Info, '### START searchExternalProvider');
        try
        {
            // Request for all matching contacts
            // Call with the apply Search First option to have it set the contact and primary account ids if they exist
            G2O_PARSearchView_Contacts_WS fetchContacts = new G2O_PARSearchView_Contacts_WS(theAccount, theContact);    
            fetchContacts.opt_ApplySearchFirst = true; // Web service option sets the contact IDs and look up Accounts if they exist by matching the external web service id to sfdc Contact records    
            //fetchContacts.opt_MockDocument='TestMockResponsPAR_Contact';  // umcomment this to get a mock response from PAR
            
            fetchContacts.send();            
            
            if (fetchContacts.callout.errors.size()>0)
            {
                // Report back first error to the user
                alertMessage = Label.Ext_Request_Failed+' '+fetchContacts.callout.errors[0].description;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Ext_Request_Failed+' '+fetchContacts.callout.errors[0].description));
                System.debug(logginglevel.Info, '### PAR ERROR(S) '+fetchContacts.callout.errors);
            }
            
            System.debug(logginglevel.Info, '### END searchExternalProvider: '+fetchContacts.result);
            if (fetchContacts.result != null) {
                map<String,ContactWrapper> results = new map<String,ContactWrapper>();
                for (String key : fetchContacts.result.keySet())
                {
                    ContactWrapper w = new ContactWrapper(fetchContacts.result.get(key));
                    results.put(key,w);
                }
                return results;
            }
        } catch(CalloutException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Callout + ' ' + e.getMessage()));
        
        } catch(UTIL_HttpIntegration.MappingException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Field_Missing + ' ' + e.fieldPath));
        
        } catch (Exception e) {
            alertMessage += Label.Error_from_Salesforce;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
            UTIL_Error.report('G2O_CustomerCreateContact_VFCx.searchExternalProvider()', e);
            UTIL_Error.write();
        }
        return new map<String,ContactWrapper>();
    }
    
    // Search SFDC
    ContactWrapper[] searchSfdcContacts(set<String> externalIds)
    {
        System.debug(logginglevel.Info, '### START searchSfdcContacts:'+externalIds);
        ContactWrapper[] result = new ContactWrapper[]{}; // map contact wrapper by contact id
        
        // Build the main query
        String query = 'SELECT Id, Contact_Person_ID__c, External_Provider_Party_Id__c, FirstName, LastName, External_Contact_Person_Status__c, ';
        query += 'Account.Id, Account.Name, Account.FirstName, Account.LastName, Account.IsPersonAccount, Account.Involved_Party_ID__c, Account.External_Provider_Party_Id__c, Account.Customer_ID__c, Account.Corporate_Registration_Number__c, Account.Registration_Country__c';
        for(Schema.FieldSetMember f: SObjectType.Contact.FieldSets.CreateContact.getFields()) {
            query += query.indexOf(f.getFieldPath())==-1 ? f.getFieldPath() + ', ' : '';
        }
        query += ' FROM Contact WHERE RecordTypeId =\''+UTIL_Meta.getContactPersonRT()+'\'';
        
        // Append further conditions
        if (theAccount.Corporate_Registration_Number__c != null) {
            query += ' AND Account.Corporate_Registration_Number__c =\''+String.escapeSingleQuotes(theAccount.Corporate_Registration_Number__c)+'\'';
        }
        if (theAccount.Corporate_Registration_Number__c == null) {
            query += ' AND Account.Name =\''+String.escapeSingleQuotes(theAccount.Name)+'\'';
        }
        if (UTIL_Apex.isSet(theContact.LastName)) {
            query += ' AND LastName LIKE \'%'+String.escapeSingleQuotes(theContact.LastName)+'%\'';
        }
        if (UTIL_Apex.isSet(theContact.FirstName)) {
            query += ' AND FirstName LIKE \'%'+String.escapeSingleQuotes(theContact.FirstName)+'%\'';
        }
        // We dont include person accounts in the search
        query += ' AND Account.IsPersonAccount = FALSE';
        query += ' LIMIT 1000';
        
        System.debug(logginglevel.Info, '### query '+query);
        Contact[] internalSearchResults = Database.query(query);
        
        // Create Wrapper objects
        for(Contact c : internalSearchResults)
        {
            // Ignore those we've already returned from the external search
            if (!externalIds.contains(c.External_Provider_Party_Id__c))
            {
                ContactWrapper cw = new ContactWrapper();
                cw.theContact = c;
                result.add(cw);
                
                // Set the primary account info for display and Account Contact Role creation
                // Note the accounts info has been subselected in the above query
                Account a = (Account)Account.sObjectType.newSobject(cw.theContact.AccountId);
                // Person accounts are no longer included in the search
                //if (cw.theContact.Account.IsPersonAccount)
                //{
                //    a.FirstName = cw.theContact.Account.FirstName;
                //    a.LastName = cw.theContact.Account.LastName;
                //    a.name = a.FirstName + ' ' + a.LastName;
                //} else {
                    a.name = cw.theContact.Account.Name;
                //}
                a.Involved_Party_ID__c          = cw.theContact.Account.Involved_Party_ID__c;
                a.External_Provider_Party_Id__c = cw.theContact.Account.External_Provider_Party_Id__c;
                //a.Customer_ID__c              = cw.theContact.Account.Customer_ID__c;
                a.Corporate_Registration_Number__c = cw.theContact.Account.Corporate_Registration_Number__c;
                a.Registration_Country__c       = cw.theContact.Account.Registration_Country__c;
                cw.primaryAccount = a;
            }
        }
        
        System.debug(logginglevel.Info, '### END searchSfdcContacts: '+result);
        return result;
    }
    
    
    /**** Create Unverified ****/
    // Creates page reference to create unverified contact page
    // Passes through the search criteria from the panel to the target page
    public PageReference createUnverifiedPageReference() {

        System.debug(logginglevel.Info, '### START createUnverifiedPageReference');
        
        // Get the GenericURL map for the account object to build the URL from
        Map<String, GenericURLHacking__c> urlLabels = UTIL_OrgSettings.GenericURLHacking('Contact');
        
        // Copy the values in the account's search fields and MOD enrich fields into the URL parameter map based on the URL hacking map for this sObject
        List<Schema.FieldSetMember> urlFields = SObjectType.Contact.FieldSets.CreateContact.getFields();

        // Fwd to contact create page
        PageReference p = new PageReference('/' + Contact.SObjectType.getDescribe().getKeyPrefix() + '/e');         
        
        // Fill the URL parameters dynamically
        Map<String, String> mapURL = p.getParameters();
        
        // Add to the URL map if values are present
        // Special condition: Skip the External Provider Party Id, and duplicate visting and postal address values into both sets of fields
        for(Schema.FieldSetMember f : urlFields) 
        {
            // Trim field path to under 38 chars which is the length limit in the custom setting name field
            String theFieldPath = f.fieldPath;
            theFieldPath = theFieldPath.substring(0, theFieldPath.length()>38 ? 38 : theFieldPath.length()); 
            
            if(theFieldPath.indexOf('.')==-1 && UTIL_Apex.isSet(theContact.get(f.fieldPath)) && urlLabels.containsKey(theFieldPath)) {          
                if (f.getType() == Schema.DisplayType.Boolean)
                {
                    mapURL.put(urlLabels.get(theFieldPath).URL_Field_Id__c, theContact.get(f.fieldPath)!=null && theContact.get(f.fieldPath)==true ? '1' : '0'); 
                } else 
                {
                    mapURL.put(urlLabels.get(theFieldPath).URL_Field_Id__c, String.valueOf(theContact.get(f.fieldPath))); 
                }
            }
        }

        // Complete account parameters if set
        if(theContact.accountId != null) {
            theAccount = getAccount(theContact.accountId);
            mapURL.put(String.valueOf(urlLabels.get('Account.Name').URL_Field_Id__c), theAccount.Name);
            mapURL.put(String.valueOf(urlLabels.get('Account.Id').URL_Field_Id__c), theAccount.Id);
        }

        // Complete contact parameters if set
        if(theContact.firstName != null) {
            mapURL.put(String.valueOf(urlLabels.get('FirstName_Contact').URL_Field_Id__c), theContact.firstName);
        }
        if(theContact.lastname != null) {
            mapURL.put(String.valueOf(urlLabels.get('LastName_Contact').URL_Field_Id__c), theContact.lastname);
        }
                
        mapURL.put('RecordType', theContact.recordTypeId);
        mapURL.put('nooverride', '1');
        mapURL.put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
        
        System.debug(logginglevel.Info, '### END createUnverifiedPageReference ('+ p +')');
        return p;
    }
    
    
    
    
    /**** Wrapper to take care of checkboxes. ****/
    public class ContactWrapper extends G2O_PARSearchView_Contacts_WS.ContactWrapper {
        public Boolean selected {get{selected=selected==null?false:selected;return selected;}set;}
        public Boolean selectable {get{selectable=selectable==null?true:selectable;return selectable;}set;}
        
        public ContactWrapper()
        {
            super();
        }
        public ContactWrapper(G2O_PARSearchView_Contacts_WS.ContactWrapper castObject)
        {
            this.theContact = castObject.theContact;
            this.relationshipList = castObject.relationshipList;
            this.primaryAccount = castObject.primaryAccount;
        }
    }
}