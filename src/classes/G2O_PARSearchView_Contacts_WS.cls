/**
    About
    -----
    Description: Service for PNCM_PAR_Request:Contact
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Jan 2013
    
    Details / Methods
    -----------------
    Depends on G2O_CINT_SoapIntegration->
    
    Use
        Set up an integration configuration in HTTP Integration Services (custom setting) called 'PARSearchView_Contacts'
        Code to use the service:
        
        // Create the connection
        G2O_PARSearchView_Contacts_WS parContact = new G2O_PARSearchView_Contacts_WS(accountsWithPARIDs);
        G2O_PARSearchView_Contacts_WS parContact = new G2O_PARSearchView_Contacts_WS(account,firstNam,lastName,contactRoles);
        
        // Send the callout
        parContact.send('some objectID - case etc.'');
        //or just parContact.send() if you don't want to relate the result to a record
        
        // Use the result
        parContact.result; // Now contains the resulting PAR information
        
        // If the result is null then check for errors
        parContact.callout.errors; // Contains a list of ErrorContainer objects which will describe the problems with error codes etc.
        parContact.callout.error; // The latest (Final) error is kept on .error for convenience
    
    Update History
    --------------
    Created Jan 2013 - M.E.
    First Compile March 2013 - M.E.
    Updated April 2013 - C.H.F.
    
    Issues / TODOs
    --------------  

*/
public with sharing class G2O_PARSearchView_Contacts_WS extends G2O_CINT_SoapIntegration {
    
    // Result map: Contact's external ID, and Wrapper containing the contact and list of account position relationships by the account's external id's
    public map<String,ContactWrapper> result = new map<String,ContactWrapper>();
    
    // Attributes
    // Map allows the calling script to easily check on the accounts they sent in to match the returned positions for each Contact by External Id
    public map<String,Account> param_accountsByExternalId = new map<String,Account>();
    public boolean opt_ApplySearchFirst = false; // Public option: Set to true and the result will have any contacts existing in the database marked with their corresponding ContactId
    public boolean opt_GetAllPositions = false; // Public option: Set to true to ignore the contact positions list (default required list or otherwise)
    public String[] opt_AlternativePositions = new String[]{}; // Public attribute: If set, this is used instead of the requiredContactPositions() filter
    
    /***** Constructor *****/
    public G2O_PARSearchView_Contacts_WS(Account[] accountsWithExternalPartyProviderIDs)
    {
        super('G2O_PARSearchView_Contacts_WS', 'PAR_Contact');
        
        this.opt_ApplySearchFirst = opt_ApplySearchFirst;
        
        // Throw errors if mandatory data not supplied
        if (accountsWithExternalPartyProviderIDs==null || accountsWithExternalPartyProviderIDs.size()==0)
        {
            // Throw on Name field for want of a better field
            throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Name',Label.Search_ContactWS_No_search_criteria);
        }
        
        // Organise the accounts by IDs
        param_accountsByExternalId = new Map<String,Account>();
        for (Account a : accountsWithExternalPartyProviderIDs)
        {
            if (a.External_Provider_Party_ID__c!=null) param_accountsByExternalId.put(a.External_Provider_Party_ID__c, a);
        }
        
        // Build the request parameters for the service
        requestParameters.put('MaxRecords',maxRecords);
        sequenceRequestParameters.put('ExternalProviderPartyID',new List<String>(param_accountsByExternalId.keySet()));
        if (useStandardContactPositions()) 
        {
            sequenceRequestParameters.put('PrimaryPosition',UTIL_OrgSettings.requiredContactPositions());
        } else if (useAltContactPositions()) {
            sequenceRequestParameters.put('PrimaryPosition',opt_AlternativePositions);
        }
    }

    public G2O_PARSearchView_Contacts_WS(Account account, Contact contact)
    {
        super('G2O_ExternalSearchView_Contacts_WS', 'PAR_Contact');
        this.opt_ApplySearchFirst = opt_ApplySearchFirst;
        
        param_accountsByExternalId = new Map<String,Account>();
        param_accountsByExternalId.put(account.External_Provider_Party_ID__c, account);
        
         // Throw errors if mandatory data not supplied
        if (account.External_Provider_Party_ID__c == null)
        {
            throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'External_Provider_Party_ID__c','External ProviderParty ID missing on the account');
        }
        
        requestParameters.put('MaxRecords',maxRecords);
        requestParameters.put('ExternalProviderPartyID',account.External_Provider_Party_ID__c);
        if(!UTIL_Apex.empty(contact.FirstName))requestParameters.put('FirstName',contact.FirstName);
        if(!UTIL_Apex.empty(contact.LastName))requestParameters.put('LastName',contact.LastName);
    }

    boolean useStandardContactPositions()
    {
        return !opt_GetAllPositions && opt_AlternativePositions.size()==0;
    }
    
    boolean useAltContactPositions()
    {
        return !opt_GetAllPositions && opt_AlternativePositions.size()>0;
    }
    
    /***** External Result *****/
    public override void handleResponse()
    {
        // Clear the result list
        result = new map<String,ContactWrapper>();
        
        // Check the errors in callout.errors
        if (callout.errors.size()==0) {
            
            List<Dom.XMLNode> contactNodes = new List<Dom.XMLNode>();
            
            // Parse the xml reponse and get hold of contacts
            Dom.Document doc = new Dom.Document();
            doc.load(UTIL_Apex.empty(callout.response.getBody()) ? '' : callout.response.getBody());
            Dom.XMLNode root = doc.getRootElement();
            
            Dom.XMLNode Body = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            
            Dom.XMLNode ItemLocation = Body.getChildElement('ItemLocation', 'http://new.webservice.namespace');
            
            Dom.XMLNode UserArea = ItemLocation.getChildElement('UserArea', 'http://new.webservice.namespace');
            
            Dom.XMLNode Body2 = UserArea.getChildElement('Body', '');
            
            Dom.XMLNode ReadMdmCustomerResponse = Body2.getChildElement('ReadMdmCustomerResponse', 'urn:Namespaces.PostNord.Com:Cint:Mdm:Customer:CrudScenarios:v0002');
            
            Dom.XMLNode ListOfItems = ReadMdmCustomerResponse.getChildElement('ListOfItems', 'urn:Namespaces.PostNord.Com:Cint:Mdm:Customer:CrudScenarios:v0002');
            
            contactNodes = ListOfItems.getChildElements();
            
            // New parse code
            for(Dom.XMLNode contactNode : contactNodes) {
            	Integer contactProcessed = 0;
                if(contactNode.getName() == 'ContactPerson' && contactProcessed <= Integer.valueOf(maxRecords)) {
                	contactProcessed++;
                    Contact contact = new Contact();
                    contact.Contact_Person_Type__c = UTIL_OrgSettings.ContactPersonTypefromPAR();
                    
                    String externalRelationshipNumber;
                    String department;
                    String wsExternalPartyID;
                    List<String> positionList = new String[4];
                    
                    for(Dom.XMLNode node : contactNode.getChildElements()) { 
                    	
                        if(node.getName() == 'PNCM_ID') {
                            contact.External_Provider_Party_ID__c = node.getText();
                        }
                        if(node.getName() == 'WS_ExternalPartyID') {
                            wsExternalPartyID = node.getText();
                        }
                        if(node.getName() == 'ExternalRelationshipNumber') {
                            externalRelationshipNumber = node.getText();
                        }
                        if(node.getName() == 'Department') {
                            if(node.getChildElement('Description', null) != null) {
                                department = node.getChildElement('Description', null).getText();
                            }
                        }
                        if(node.getName() == 'Position') {
                        	if(node.getChildElement('PositionOrder', null) != null && node.getChildElement('Code', null) != null) {
                                
                                // Put the postions in the right order
                                if(node.getChildElement('PositionOrder', null).getText() == '1') {
                                	positionList[0] = node.getChildElement('Code', null).getText();
                                }
                                if(node.getChildElement('PositionOrder', null).getText() == '2') {
                                	positionList[1] = node.getChildElement('Code', null).getText();
                                }
                                if(node.getChildElement('PositionOrder', null).getText() == '3') {
                                	positionList[2] = node.getChildElement('Code', null).getText();
                                }
                                if(node.getChildElement('PositionOrder', null).getText() == '4') {
                                	positionList[3] = node.getChildElement('Code', null).getText();
                                }
                            }
                            
                        }
                        if(node.getName() == 'Title') {
                            contact.Title = node.getText();
                        }
                        if(node.getName() == 'FirstName') {
                            contact.FirstName = node.getText();
                        }
                        if(node.getName() == 'LastName') {
                            contact.LastName = node.getText();
                        }
                        if(node.getName() == 'ExternalContactPersonStatus') {
                        	if(node.getChildElement('Code', null) != null) {
                            	contact.External_Contact_Person_Status__c = node.getChildElement('Code', null).getText();
                        	}
                        }
                        if(node.getName() == 'ContactBlockExternal') {
                            contact.External_Advertising_Block__c = Boolean.valueOf(node.getText());
                        }
                        if(node.getName() == 'Communication') {
                            if(node.getChildElement('EmailAddress', null) != null) {
                                contact.Email = node.getChildElement('EmailAddress', null).getText();
                            }
                            if(node.getChildElement('PhoneNumber', null) != null) {
                                contact.Phone = node.getChildElement('PhoneNumber', null).getText();
                            }
                        }
                    }
                    
                    // Only need to add the contact info once for each contact (the contact info is repeated forevery contact-account realationship)
                    if(!result.containsKey(contact.External_Provider_Party_ID__c)) {   
                        // Filter out the contacts without External_Provider_Party_ID__c set
                        if(contact.External_Provider_Party_ID__c !=null) {
                            result.put(contact.External_Provider_Party_ID__c,new ContactWrapper(Contact,new RelationshipWrapper(wsExternalPartyID, externalRelationshipNumber, department, positionList)));
                        } else {
                            callout.error = new ErrorContainer(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'No External_Provider_Party_ID__c in the response');
                        }
                    } else {
                        result.get(contact.External_Provider_Party_ID__c).addRelationship(new RelationshipWrapper(wsExternalPartyID, externalRelationshipNumber, department, positionList));
                    }
                }
            }           
        }

        // The apply search first option if set
        if(opt_ApplySearchFirst)
        {
            applySearchFirst();
        }
    }
    
    // Search First: To replace any returned results with matching records in Salesforce
    // This will add the SFDC id's to contacts that match existing records based on External Provider Party Id
    // Ex. Allow us to enrich a contact using external data, but maintain the main ("primary") Account reference
    public void applySearchFirst() 
    {
        if (result.size()>0)
        {
            
            // Update the results from the web service with contacts that match the external IDs and look up their related accounts
            for (Contact c : [select id, AccountId, Contact_Person_ID__c, External_Provider_Party_ID__c from Contact where External_Provider_Party_ID__c in:result.keySet() LIMIT 1000])
            {
                // Apply Id's to the returned results 
                result.get(c.External_Provider_Party_ID__c).theContact.id = c.Id;
                result.get(c.External_Provider_Party_ID__c).theContact.Contact_Person_ID__c = c.Contact_Person_ID__c;
                result.get(c.External_Provider_Party_ID__c).theContact.AccountId = c.AccountId;
            }
            
            // Map each existing contact by it's account Id
            map<id, ContactWrapper[]> contactsByAccountIds = new map<id, ContactWrapper[]>();
            for (String externalID : result.keySet())
            {
                ContactWrapper c = result.get(externalID);
                // Ensure the contact exists and has an account
                if (c.theContact.id!=null && c.theContact.accountId!=null)
                {
                    // Map by account id
                    ContactWrapper[] crs = contactsByAccountIds.get(c.theContact.accountId) != null ? contactsByAccountIds.get(c.theContact.accountId) : new ContactWrapper[]{};
                    crs.add(c);
                    contactsByAccountIds.put(c.theContact.accountId, crs);
                }
            }
            
            // Fetch the primary accounts for the existing contact
            for(Account a : [SELECT Name, IsPersonAccount, Involved_Party_ID__c, External_Provider_Party_Id__c, 
                                    Corporate_Registration_Number__c, Registration_Country__c 
                                    FROM Account WHERE Id in :contactsByAccountIds.keySet()])
            {
                for (ContactWrapper c : contactsByAccountIds.get(a.Id))
                {
                    c.primaryAccount = a;
                }
            }
        }
    }
    
    /***** Result Wrapper(s) *****/
    public virtual class ContactWrapper implements Comparable 
    {
        // Values populated by the web service
        public Contact theContact {get{theContact = theContact==null ? new Contact() : theContact; return theContact;}set;}
        public List<RelationshipWrapper> relationshipList {get{relationshipList = relationshipList==null ? new List<RelationshipWrapper>() : relationshipList; return relationshipList;}set;}
        
        // Additional paramters
        public Account primaryAccount {get;set;} // Set when opt_ApplySearchFirst is true and a match on contact is found
        public Boolean exists {get{return this.theContact.id!=null;}set;}
        
        public ContactWrapper(){}
        
        public ContactWrapper(Contact theContact, RelationshipWrapper relationship)
        {
            this.theContact = theContact;
            this.relationshipList.add(relationship);
        }
        
        public void addRelationship(RelationshipWrapper relationship)
        {
            this.relationshipList.add(relationship);
        }
        
        public List<String> getAccountPositions(String externalId)
        {
            for(RelationshipWrapper rW : relationshipList) {
                if(rW.accountExternalId == externalId) {
                    return rw.positions;
                }
            }
            return null;
        }
        
        public String getRelationshipExternalId(String externalId)
        {
            for(RelationshipWrapper rW : relationshipList) {
                if(rW.accountExternalId == externalId) {
                    return rw.relationshipExternalId;
                }
            }
            return null;
        }
        
        public String getDepartment(String externalId)
        {
            for(RelationshipWrapper rW : relationshipList) {
                if(rW.accountExternalId == externalId) {
                    return rw.department;
                }
            }
            return null;
        }
        
        public Set<String> getAccountExternalIds()
        {
			System.debug(logginglevel.info,'### START: getAccountExternalIds: relationshipList: '+relationshipList);
            Set<String> accountExternalIds = new Set<String>();
            
            for(RelationshipWrapper rW : relationshipList) {
                accountExternalIds.add(rW.accountExternalId);
            }
			System.debug(logginglevel.info,'### END: getAccountExternalIds: accountExternalIds: '+accountExternalIds);
            return accountExternalIds;
        }
        
        // Compare Contact Wrapper objects based on name
        public Integer compareTo(Object compareTo) {
            ContactWrapper compareToObj = (ContactWrapper)compareTo;
            Integer returnValue = 0; // The return value of 0 indicates that both elements are equal
            
            // Handle if the contacts are null or have no definition
            if (this.theContact==null && compareToObj.theContact==null)
            {
                return 0;
            }
            if (this.theContact!=null && compareToObj.theContact==null)
            {
                return -1;
            }
            if (this.theContact==null && compareToObj.theContact!=null)
            {
                return 1;
            }
            
            try
            {
                //  Last Name
                returnValue = this.theContact.LastName.compareTo(compareToObj.theContact.LastName);
                if (returnValue!=0) return returnValue;
            } catch(exception e) {}
            
            try
            {
                //  First Name
                returnValue = this.theContact.FirstName.compareTo(compareToObj.theContact.FirstName);
                if (returnValue!=0) return returnValue;
            } catch(exception e) {}

            return 0;       
        }
    }
    
    public virtual class RelationshipWrapper{
        
        public String accountExternalId;    // External Provider Party Id (on account)
        public String relationshipExternalId;   // External Provider Relationship Id (on ACR)
        public String department;
        public List<String> positions = new List<String>();  // Position Codes
        
        public RelationshipWrapper(){}
        
        public RelationshipWrapper(String accountExternalId, String relationshipExternalId, String department, List<String> positions) {
            this.accountExternalId = accountExternalId;
            this.relationshipExternalId = relationshipExternalId;
            this.department = department;
            this.positions = positions;
        }
    }
    
    /***** Static processing methods *****/
    // Generate a set of Account Contact Roles to represent the relationships in a set of Contact Wrappers
    /*
     	>> 
         Creates sets of ACR records to be upserted (to allow updates) based on a set of Contact Wrappers, usually returned form the external webservice and enhanced in a trigger or controller
         Any verified (external) relationships contained in the wrapper on the accountRelationships map will be searched and an ACR(T) record generated.
         Inserting a contact will create the standard ACR record, and doesn't need to call this method.
         This method is intended to build the associations to validated relationships.
      	<< 
 	*/
    public static map<String, Account_Contact_Role_Transaction__c> createACRsFromContactRelationships(G2O_PARSearchView_Contacts_WS.ContactWrapper[] contactWrappers)
    {
		System.debug(logginglevel.info,'### START: createACRsFromContactRelationships: '+contactWrappers);
       	map<String, Account_Contact_Role_Transaction__c> accountContactRoles = new map<String, Account_Contact_Role_Transaction__c>();
        map<String, G2O_PARSearchView_Contacts_WS.ContactWrapper[]> contactsByAccountExternalId = new map<String, G2O_PARSearchView_Contacts_WS.ContactWrapper[]>();
        
        map<id,ContactWrapper> contactsById = new map<id,ContactWrapper>();
        
        // Organise the contacts by their native Id
        for (G2O_PARSearchView_Contacts_WS.ContactWrapper w : contactWrappers)
        {
        	if (w.theContact.id!=null)
        	{
        		contactsById.put(w.theContact.id, w);
        	}
        }
		System.debug(logginglevel.info,'### contacts by their native Id: contactsById: '+contactsById);
        
        // Query for them and...
        for (Contact c : [select id, accountId, Contact_Person_Id__c, External_Provider_Party_ID__c from Contact where id in :contactsById.keySet()])
        {
        	ContactWrapper w = contactsById.get(c.id);
        	
        	// Complement the current contact records
        	w.theContact = c;
        	
			System.debug(logginglevel.info,'### w.theContact: '+w.theContact);
			
    	  	// Group by worksite external IDs for ACR generation
            for (String externalID : w.getAccountExternalIds())
            {
                G2O_PARSearchView_Contacts_WS.ContactWrapper[] relatedContacts = contactsByAccountExternalId.containsKey(externalID) ? contactsByAccountExternalId.get(externalID) : new G2O_PARSearchView_Contacts_WS.ContactWrapper[]{};
                relatedContacts.add(w);
				System.debug(logginglevel.info,'### externalID: '+externalID+' relatedContacts: '+relatedContacts);
                contactsByAccountExternalId.put(externalId, relatedContacts);
            }
        }
		System.debug(logginglevel.warn,'### queriedcontactsByAccountExternalId: '+contactsByAccountExternalId);
        
        // Create the verified relationships
        // Fetch all accounts with matching external Ids to the accountRelationships map on each contact
        // Enrich or create ACRs for account
        for (Account a : [select id,Involved_Party_ID__c,External_Provider_Party_ID__c from Account where External_Provider_Party_ID__c in:contactsByAccountExternalId.keySet()])
        {
            for (G2O_PARSearchView_Contacts_WS.ContactWrapper w : contactsByAccountExternalId.get(a.External_Provider_Party_ID__c))
            {
                Account_Contact_Role_Transaction__c accountACR = new Account_Contact_Role_Transaction__c();
                accountACR.Contact__c = w.theContact.Id;
                accountACR.Account__c = a.Id;
                accountACR.Ignore_ACR_Validation_Rules__c = true;
                G2O_AccountContactRole_SVC.setKey(accountACR, a.Involved_Party_ID__c,  w.theContact.Contact_Person_ID__c);
                
                // Set position data for the account - this should be verified data, so overwrite empty values
                // >> Note The datamodel only supports up to four positions per account <<
                String[] positions = w.getAccountPositions(a.External_Provider_Party_ID__c);
                if (positions.size()>0)
                {
	                accountACR.Primary_Position__c = positions.size()>0 && UTIL_Apex.isSet(positions[0]) ? positions[0] : null;
	                accountACR.Secondary_Position_1__c = positions.size()>1 && UTIL_Apex.isSet(positions[1]) ? positions[1] : null;
	                accountACR.Secondary_Position_2__c = positions.size()>2 && UTIL_Apex.isSet(positions[2]) ? positions[2] : null;
	                accountACR.Secondary_Position_3__c = positions.size()>3 && UTIL_Apex.isSet(positions[3]) ? positions[3] : null;
                }
                
                // Set External id on the ACR
                accountACR.External_Provider_Relationship_ID__c = w.getRelationshipExternalId(a.External_Provider_Party_ID__c);
                
                // Set Department on the ACR
                accountACR.Department__c = w.getDepartment(a.External_Provider_Party_ID__c);
                
                // Append/update the map
                accountContactRoles.put(accountACR.Account_Contact_Role_SFID__c, accountACR);
            }
        }
        
		System.debug(logginglevel.info,'### END: createACRsFromContactRelationships: '+accountContactRoles);
        return accountContactRoles;
    }    
}