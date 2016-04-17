/**
    About
    -----
    Description: Before Update Trigger on Contact
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters:
    -------
        1. Filters out the records where the field "PN_Mark_As_Synced" chages from false to true because it is updated by CINT
        2. Filters out the records that has been updated and has the PN_Mark_As_Synced field set to false
        3. Account is changed
        4. Contact Person ID has been set (by workflow), create Account Contact Role
        
    Actions:
    -------
        1. If the Permission channel is changed then the field Permission Channel Timestamp populated with date, time and user who edited the field Permission Channel.
        2. If the field Permission is changed then the field Permission Timestamp populated with date, time and user who edited the field Permission.  
        
    Update History
    --------------
    Created March 2013 - C.H.F.
    Additional filter May 2013 - M.E. - ACRs now created only after the Contact Person ID has been set by workflow
    Updated August 2013 - C.H.F. - Cleaned up
    Updated June 2014 - Ramesh T N - Updated Action 1 and Action 2
    Updated June 2015 - Madhav Kakani - Fluido Denmark - Placed code for the Contact Center project to normalise phone numbers
        
    Issues / TODOs
    --------------  

    
*/
trigger Contact_BeforeUpdate on Contact (before update) {

    List<Contact> withFlagsToUpdate = new List<Contact>();
    List<Contact> withSyncToUpdate = new List<Contact>();
    List<Contact> newContactPersonIDSet = new List<Contact>();
    Map<Contact, Id> accountChanged = new Map<Contact, Id>(); //Map Contact->Old accountID
    List<Contact> contDoNotUpdateNewList = new List<Contact>();
    Map<Id,Contact> contDoNotUpdateOldMap = new Map<Id,Contact>();
    Set<Id> accountIds = new Set<Id>();
    Map<Id,Account> accountsMap = new Map<Id,Account>();
    
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        
        // Constructing Accounts Map
        for (Contact c : trigger.new) {
            
            //Filter 0
            if(c.AccountId != null){
                
                accountIds.add(c.AccountId);
            }

            // Placed code to normalise phone numbers for the Contact Center project - Fluido Denmark
            c.CC_Phone__c = UTIL_Apex.NormalisePhone(c.Phone, c.Account_Country__c);
            c.CC_Mobile__c = UTIL_Apex.NormalisePhone(c.MobilePhone, c.Account_Country__c);
        }
        if(accountIds.size()>0){
        	
        	accountsMap = new Map<Id, Account>([Select Id, Do_Not_Update_Address_Automatically__c from Account where Id IN :accountIds]);
        }
        
        
        // Creating Lists and Maps based on filter criteria
        for (Contact c : trigger.new) {
            
            // Filter 1
            if (c.PN_Mark_As_Synced__c && !trigger.oldMap.get(c.Id).PN_Mark_As_Synced__c) {
                withFlagsToUpdate.add(c);
            }
            
            // Filter 2
            else {
                withSyncToUpdate.add(c);
            }
            
            // Filter 3
            if (c.AccountId!=Trigger.oldMap.get(c.id).AccountId && !UTIL_Apex.empty(c.Contact_Person_ID__c))
            {
                accountChanged.put(c,Trigger.oldMap.get(c.id).AccountID);
            }
            
            // Filter 4
            if (!UTIL_Apex.empty(c.Contact_Person_ID__c) && UTIL_Apex.empty(Trigger.oldMap.get(c.id).Contact_Person_ID__c) && !c.Deletion_Flag__c)
            {
                newContactPersonIDSet.add(c);
            }
            
            //Filter 5
            if(UTIL_Meta.isIntegrationUser(UserInfo.getProfileId()) && accountsMap.get(c.AccountId).Do_Not_Update_Address_Automatically__c){
                contDoNotUpdateNewList.add(c);
                contDoNotUpdateOldMap.put(c.Id,Trigger.oldMap.get(c.id));
            }
            
            
            
            // Action 1
            if (c.Permission_Channel__c!= Trigger.oldMap.get(c.id).Permission_Channel__c){
                c.Permission_Channel_timestamp__c = System.NOW().Format() + ', ' + UserInfo.getName();
            }
            
            // Action 2
            if (c.Permission__c!= Trigger.oldMap.get(c.id).Permission__c){
                c.Permission_Time_stamp__c = System.NOW().Format() + ', ' + UserInfo.getName();
            }
        }
        
        // Filter 1
        if (withFlagsToUpdate.size() > 0) {     
            G2O_TransactionSecurityFlags_SVC.updateTransactionSecurityFlags(withFlagsToUpdate);
        }
        
        // Filter 2
        if (withSyncToUpdate.size() > 0) {      
            G2O_TransactionSecurityFlags_SVC.setSynchronizedToFalse(withSyncToUpdate);
        }
        
        // Filter 3
        if (accountChanged.size() > 0) {      
            G2O_AccountContactRole_SVC.updateRoles(accountChanged);
        }
        
        // Filter 4
        if (newContactPersonIDSet.size() > 0) {
            G2O_AccountContactRole_SVC.createRoles(newContactPersonIDSet);
        }
        
        //Filter 5 
        if(contDoNotUpdateNewList.size() > 0){
            G2O_Contact_SVC.doNotUpdateAutomatically(contDoNotUpdateNewList,contDoNotUpdateOldMap);
        }
    }
}