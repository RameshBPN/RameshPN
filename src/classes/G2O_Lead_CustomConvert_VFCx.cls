/**
    About
    -----
    Description: G2O_Lead_CustomConvert_VFCx
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: July 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    Provides Custom Lead Conversion Process:
    Methods:
    -------
        1. Method to get the Account pick list values.
		2. Method to get the Contact pick list values.
		3. Method to get the Convert status pick list values.
		4. Method to get the account pick list value selected from the lookup.
		5. Method to get the contact pick list value selected from the lookup.
		6. Method containing logic for lead conversion process.
		7. method performing Lead Convert.
        
    Wrapper Classes Created:
    -----------------------
        
    Update History
    --------------
    
    Issues / TODOs :
    --------------  

*/
public with sharing class G2O_Lead_CustomConvert_VFCx {
    
    //A.T.T.R.I.B.U.T.E.S
    public Lead leadToConvert{get;set;}         //Lead record to be converted.
    public Lead leadRecord{get;set;}            //To display account lookUp as leadRecord.Account__c.
    public Account recordOwner {get{recordOwner= recordOwner==null ? new Account() : recordOwner; return recordOwner;}set;}      //To display the user lookup
    public Case caseRecord {get;set;}           //To display the contact lookupu under ContactName as caseRecord.ContactId.
    public String accountSelected{get;set;}     //For getting/setting the picklist value if Account__c != null.
    public String contactSelected{get;set;}     //For setting the default contact value.
    public String convertStatusSelected{get;set;}       //For setting the convert Status values.
    public Boolean hasAccess {get;set;}					//User has the acces to convert the lead or not.
    
    List<SelectOption> accountNames = new List<SelectOption>();
    List<SelectOption> contactNames = new List<SelectOption>();
    List<SelectOption> convertStatusNames = new List<SelectOption>();
    
    Map<String,String>  accountPickValMap = new Map<String,String>();   //Map to hold accountId to AccountName values for the accounts selected from AccountLookup.
    Map<String,String>  contactPickValMap = new Map<String,String>();   //Map to hold contactId to Name values for the contact selected from ContactLookup.
    Map<Id,String> convertStatusMap = new Map<Id,String>();
    
    public Id oppId;													//Hold the Opportunity Id of the newly created opportunity.
    public Id conId;													//Holds the Contact Id of the newly created contact.
    Database.LeadConvertResult lcr;
    Boolean delContact = false;									//If Set to true,Delete the Contact created during the Lead Conversion process.
    String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
    String personAccRT = UTIL_Meta.getPersonAccountRT();
    String accountSelectedName;
    //A.T.T.R.I.B.U.T.E.S
    
    
    public G2O_Lead_CustomConvert_VFCx(ApexPages.StandardController controller) {
       
        leadToConvert = (Lead)controller.getRecord();
		
        //Getting values related to the Lead record.
        leadToConvert = [Select Id, Account__c,CreatedById,Short_Description__c, Name,AnnualRevenue,Company,Fax,Industry,
                            NumberOfEmployees,Phone,Rating,Website,LeadSource,OwnerId,Description,Email,FirstName,LastName,Title,Street,
                            State,PostalCode,Country,City,Account__r.Involved_Party_ID__c, Account__r.Name, Account__r.Id,IsConverted
                            From Lead where Id=: leadToConvert.Id limit 1]; 
		
        //M recordOwner = new Opportunity(); 
        //M recordOwner.OwnerId = leadToConvert.OwnerId;   //Assigning the Lead's Created User to Account's Owner, this is done basically because the CreatedById on Lead is read only
		recordOwner.OwnerId = leadToConvert.OwnerId;
		
        //Set the default value of Lead Account Name.
        if(leadToConvert.Account__c != null) {
            accountSelected = leadToConvert.Account__c;
            accountSelectedName = leadToConvert.Account__r.Name+ ' -Involved Party ID- '+leadToConvert.Account__r.Involved_Party_ID__c;
        }
        
        leadRecord = new Lead();
        caseRecord = new Case();
        system.debug(LoggingLevel.ERROR,'+++++Inside the constructor++'+leadToConvert);
    }
    
    //0. Executes when a page loads,check if the user has the access to convert the lead or not.
     public PageReference init(){
    	
    	hasAccess = true;
    	
		UserRecordAccess usrAccess =[SELECT RecordId, HasReadAccess,HasEditAccess,HasAllAccess,HasDeleteAccess, HasTransferAccess, MaxAccessLevel FROM UserRecordAccess 
										WHERE UserId =:userinfo.getUserId() AND RecordId =:leadToConvert.Id];
		system.debug(LoggingLevel.ERROR, '+++usrAccess+++'+usrAccess);
    	if(!usrAccess.HasAllAccess){
    		hasAccess = false;
    	}
    	return null;
    }
    
    
    //1. Getting the Account pick list values.
    public List<SelectOption> getAccountDetail() {
        
        accountNames = new List<SelectOption>();
        if(UTIL_Apex.empty(leadToConvert.Account__c)){

            if(leadToConvert.Company != null){
                
                //Get the accounts matching the Lead Company Name.
                String query = 'SELECT Id,Involved_Party_ID__c, Name FROM Account WHERE Name LIKE \''+String.escapeSingleQuotes(leadToConvert.Company)+'%\'';
                query += ' AND RecordTypeId = \''+workSiteRT+'\'';
                query += ' limit 10000';

                List<Account> accountMatchingLeadCompany = Database.Query(query);
                
                if(!accountMatchingLeadCompany.isEmpty()){
                    accountNames.add(new SelectOption('#NONE#', '--None--'));
                    accountNames.add(new SelectOption('#NEW#', 'Create New Account: '+leadToConvert.Company));
                    for(Account accountMatchName: accountMatchingLeadCompany){
                        accountNames.add(new SelectOption(String.valueOf(accountMatchName.Id), 'Attach to Existing: '+accountMatchName.Name+ ' -Involved Party ID- '+accountMatchName.Involved_Party_ID__c));
                    }
                }else{
                    accountNames.add(new SelectOption('#NEW#', 'Create New Account: '+leadToConvert.Company));
                }
            }
            
        }else {
            accountNames.add(new SelectOption('#NEW#', 'Create New Account: '+leadToConvert.Account__r.Name));
        	if(!accountPickValMap.containsKey(accountSelected)){
        		accountPickValMap.put(accountSelected,accountSelectedName);
        	}
        }
        
        for(String accId :accountPickValMap.keySet()){
            accountNames.add(new SelectOption(accId, 'Attach to Existing: '+accountPickValMap.get(accId)));
        }
        
        return accountNames;
    }
    
   
    //2. Getting the Contact pick list values.
    public List<SelectOption> getContactDetail() {
        
        contactNames = new List<SelectOption>();
        List<Contact> contactMatchingLeadName = new List<Contact>();
        
        if(!UTIL_Apex.empty(leadToConvert.Account__c)){
	        String query = 'SELECT Id, LastName,FirstName,Name FROM Contact WHERE AccountId =\''+leadToConvert.Account__c+'\'';
			query += ' AND ( FirstName LIKE\''+String.escapeSingleQuotes(leadToConvert.FirstName)+'%\'';
	        query += ' OR LastName LIKE\''+String.escapeSingleQuotes(leadToConvert.LastName)+'%\'';
	        query += ')limit 10000';
	        
	        contactMatchingLeadName = Database.Query(query);
        }
		contactNames.add(new SelectOption('#DoNotCreateContact#', 'Do Not Create Contact'));
        contactNames.add(new SelectOption('#NEW#', 'Create New Contact: '+leadToConvert.Name));

        for(Contact contactMatchName: contactMatchingLeadName){
            contactNames.add(new SelectOption(String.valueOf(contactMatchName.Id), 'Attach to Existing: '+contactMatchName.Name));
        }
        
        for(Id contactId :contactPickValMap.keySet()){
            contactNames.add(new SelectOption(contactId, 'Attach to Existing: '+contactPickValMap.get(contactId)));
        }
        
        return contactNames;
    }
    

    //3. Getting the Convert status pick list values.
    public List<SelectOption> getConvertStatus() {
        
        List<LeadStatus> leadStatusList = [Select Id, MasterLabel,IsConverted From LeadStatus where IsConverted =true];
        
        for(LeadStatus leadStatusName: leadStatusList){
            convertStatusNames.add(new SelectOption(String.valueOf(leadStatusName.Id), leadStatusName.MasterLabel));
            
            if(!convertStatusMap.containsKey(leadStatusName.Id)){
        		convertStatusMap.put(String.valueOf(leadStatusName.Id),leadStatusName.MasterLabel);
        	}
        }

        return convertStatusNames;
    }
    
    
    //4. Method to get the account pick list value selected from the lookup.
    public void  getAccountPickVal() {
            
        Account accRecord = [SELECT Id,Involved_Party_ID__c, Name FROM Account WHERE Id = :leadRecord.Account__c];
        
        accountSelected = accRecord.Id;
        accountSelectedName = accRecord.Name+ ' -Involved Party ID- '+accRecord.Involved_Party_ID__c;
        
        if(!accountPickValMap.containsKey(accRecord.Id)){
            accountPickValMap.put(accRecord.Id,accountSelectedName);
        }
    }


    //5. Method to get the contact pick list value selected from the lookup.
    public void  getContactPickVal() {
        
        Contact conRecord = [SELECT Id, Name FROM Contact WHERE Id = :caseRecord.ContactId];
        
        contactSelected = conRecord.Id;
        if(!contactPickValMap.containsKey(conRecord.Id)){
            contactPickValMap.put(conRecord.Id,conRecord.Name);
        } 
    }
    
    
    //6. Method containing logic for lead conversion.
    public PageReference leadConvertProcess(){
    	
    	Database.LeadConvert lc = new database.LeadConvert();
    	PageReference Page; 
    	
    	try{
    	
	    	system.debug(LoggingLevel.ERROR, '+++accountSelected+++'+accountSelected);
	    	system.debug(LoggingLevel.ERROR, '+++contactSelected+++'+contactSelected);
	    	
	    	//ACCOUNT VALIDATION ERRORS
	    	if(accountSelected =='#NONE#'){
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Account Name: You must enter a value'));
	    		return null;
	    	
	    	}
	    	//CONTACT VALIDATION ERRORS
	    	else if(contactSelected =='#NONE#'){
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' Contact Name: You must enter a value'));
	    		return null;
	    	
	    	}
	    	//VALIDATION ERROR- NEW ACCOUNT --- ATTACH TO EXISTING CONTACT
	    	else if(accountSelected =='#NEW#' && (contactSelected != '#DoNotCreateContact#' && contactSelected !='#NEW#') ){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lead Convert Error: Can not attach to an existing contact while creating a new account'));
	    		return null;
	    	}
	
	    	//1. NEW ACCOUNT --- NEW CONTACT
	    	else if(accountSelected =='#NEW#' && contactSelected =='#NEW#'){				
				/*
	    		Testing Result: Both Account & Contact is getting created from the standard process.
	    		*/
	    		system.debug(LoggingLevel.ERROR,'++NEW ACCOUNT --- NEW CONTACT++');
	    		leadConvert(lc);
	    		
	    	}
	
	    	//2. NEW ACCOUNT --- DO NOT CREATE CONTACT **DONE
	    	else if(accountSelected =='#NEW#' && contactSelected == '#DoNotCreateContact#'){	
	    		
	    		system.debug(LoggingLevel.ERROR,'++NEW ACCOUNT --- DO NOT CREATE CONTACT++');
	    		delContact = true;
	    		leadConvert(lc);
	    		/*
	    		Testing Result: Both Account & Contact is getting created from the standard process
	    		Do we need to delete the newly created contact.
	    		*/
	    		
	    	}
	    	
	    	//3. ATTACH TO EXISTING ACCOUNT --- ATTACH TO EXISTING CONTACT **DONE
	    	else if(!UTIL_Apex.empty(accountSelected) && (contactSelected != '#DoNotCreateContact#' && contactSelected !='#NEW#')){
	    		
	    		system.debug(LoggingLevel.ERROR,'++ATTACH TO EXISTING ACCOUNT --- ATTACH TO EXISTING CONTACT++');
	    		/*
	    		Testing Result: Both Account & Contact are getting updated,Contact Account Name is changed to the new Account.
	    		*/
	    		lc.setAccountId(accountSelected);
	    		updateContact();
	    		lc.setContactId(contactSelected);
	    		leadConvert(lc);
	    	}
	    	
	    	//4. ATTACH TO EXISTING ACCOUNT --- NEW CONTACT **DONE
	    	else if(!UTIL_Apex.empty(accountSelected) && contactSelected =='#NEW#'){
	    		
	    		system.debug(LoggingLevel.ERROR,'++ATTACH TO EXISTING ACCOUNT --- NEW CONTACT++');
	    		/*This is working fine as per standard functionality.
	    		*/
			    lc.setAccountId(accountSelected);
    			leadConvert(lc);
	    		
	    	}
	    	//5. ATTACH TO EXISTING ACCOUNT --- DO NOT CREATE CONTACT **DONE
	    	else if(!UTIL_Apex.empty(accountSelected) && contactSelected == '#DoNotCreateContact#'){
	    		
	    		system.debug(LoggingLevel.ERROR,'++ATTACH TO EXISTING ACCOUNT --- DO NOT CREATE CONTACT++');
	    		lc.setAccountId(accountSelected);
	    		delContact = true;
	    		/*
	    		Testing Result: Account is getting updated & 
	    		Contact is getting created from the standard process having Related list Opportunity,Activities,Activity History,Account Contact Role .
	    		Do we need to delete the newly created contact.
	    		*/
	    		leadConvert(lc);
	    	}
	    	
	    	if(oppId != null){
		        Page = new PageReference('/'+oppId);
		        Page.setRedirect(true); 
	    	}
    	}catch(Exception e){
    			system.debug(LoggingLevel.ERROR, '++++exception+++++'+e);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }    
        return Page;
    }
    
    
	//7. Perform convert lead process.
    public void leadConvert(Database.LeadConvert lconvert){
    	
    	try{
    	
	    	lconvert.setLeadId(leadToConvert.id);
	    	lconvert.setConvertedStatus(convertStatusMap.get(convertStatusSelected));
	    	lconvert.setOwnerId(recordOwner.OwnerId);
	    	lconvert.setOpportunityName(leadToConvert.Short_Description__c);
	    	
	    	system.debug(LoggingLevel.ERROR, '++lconvert++'+lconvert);
	    	
	    	if (leadToConvert.isconverted == false){	
	    		lcr = Database.convertLead(lconvert);
	    		system.debug(LoggingLevel.ERROR, '+++++getErrors(11)++'+lcr.getErrors());
	    	}
			
	    	oppId = lcr.getOpportunityId();
	    	conId = lcr.getContactId();
	    	
	    	system.debug(LoggingLevel.ERROR, '++++conId++'+conId);
	    	system.debug(LoggingLevel.ERROR, '++oppId++'+oppId);
			
			//Updating Contact Person Type  to "Lead Contact Person" if creating a New Contact.
			if(delContact != true && contactSelected =='#NEW#' && conId != null){
				
		    	Contact conRecord = new contact(Id = conId,Contact_Person_Type__c = UTIL_OrgSettings.ContactPersonTypefromLeadConvert());
    			update conRecord;
			}
			
	    	if(delContact == true && conId != null){
	    		G2O_AccountContactRole_SVC.allowDeleteOfACR = true;		//Setting the flag to true to Skip the errors set in trigger. 
	    		deleteContact();
	    	}
	    	
    	}catch(Exception e){
    		system.debug(LoggingLevel.ERROR, '++++e3++++'+e);
    		String leadConvertError = Label.CustomConvert_LeadConvertFailed;
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, leadConvertError));
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
    	}
    	
    }
    
    
	//Updates the existing contact with the existing AccountId.
    public void updateContact(){
    	
    	Contact conRecord = new contact(Id = contactSelected,AccountId = accountSelected);
    	update conRecord;
    }
    
       
    //Delete the contact record.
    public void deleteContact(){
    	
		Contact conRecord = new Contact(Id = conId,Deletion_Flag__c = true,OwnerId = Userinfo.getUserId());
		update conRecord;
		
		//Restore Activities.
		restoreActivities();
		
		delete conRecord;
	    	
    }
    
    
    //Prevents Activities from deleting when contact is deleted by remove the association of Activities from the contact.
    public void restoreActivities(){
    	
    	List<Event> eventsList = new List<Event>();
    	List<Task> tasksList = new List<Task>();
    	
    	for(Event eve: [Select e.WhoId, e.WhatId, e.Subject, e.IsAllDayEvent, e.ActivityDateTime From Event e where  e.WhoId=:conId]){
    		
    		eve.WhoId = null;
    		eventsList.add(eve);
    	}
    	
    	for(Task tas: [Select t.WhoId, t.WhatId, t.Subject, t.Status, t.ActivityDate From Task t where t.WhoId=:conId]){
    		
    		tas.WhoId = null;
    		tasksList.add(tas);
    	}
    	
    	update eventsList;
    	update tasksList;
    	
    }
    
}