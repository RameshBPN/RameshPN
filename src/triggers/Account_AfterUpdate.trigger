/**
    About
    -----
    Description: After Update Trigger on Account
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters:
    -------
        1. Filters out logical deleted accounts
        2. Filters out logical undeleted accounts for non Private persons accounts
        3. Filters out Legal Entity Accounts for field synchronisation with Worksites
                
    Update History
    --------------
    Created March 2013 - A.B.
    Updated May 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  

    
*/

trigger Account_AfterUpdate on Account (after update) { 
    
    List<Account> logicalDelete = new List<Account>();
    List<Account> logicalUnDelete = new List<Account>();
    list<Account> legalEntityNew = new list<Account>();
    map<id, Account> legalEntityOldMap = new map<id, Account>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        
        // Creating Lists and Maps based on filter criteria
        for (Account acc : trigger.new) {
            
            // Filter 1
            if (acc.Deletion_Flag__c!=Trigger.oldMap.get(acc.id).Deletion_Flag__c && acc.Deletion_Flag__c)
            {
                logicalDelete.add(acc);
            }
            // Filter 2
            if (acc.Deletion_Flag__c!=Trigger.oldMap.get(acc.id).Deletion_Flag__c && !acc.Deletion_Flag__c && !acc.IsPersonAccount)
            {
                logicalUndelete.add(acc);
            }
            // filter 3
            if (acc.recordTypeid == legalEntityRT){
                legalEntityNew.add(acc);
                legalEntityOldMap.put(acc.Id,Trigger.oldMap.get(acc.id));
            }
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        if (logicalDelete.size() > 0) {
            G2O_Account_SVC.setDeletionFlagOnChildRecords(logicalDelete);
        }
        
        // Filter 2
        if (logicalUndelete.size() > 0) {      
            G2O_AccountContactRole_SVC.createRoles(logicalUnDelete);
        }
        
        // Filter 3
        if (legalEntityNew.size() > 0) {
            G2O_Account_SVC.synchProjectFieldsBetweenWSwithLE(legalEntityNew, legalEntityOldMap);
        }
        
        //Log Inbound Messages 
        if(Log_Inbound_Messages__c.getInstance().Log_Messages__c){
            G2O_InboundMessageLog_SVC.logInboundMessages(Trigger.new,Trigger.oldMap);
        }
    }
}