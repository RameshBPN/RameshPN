/**
    About
    -----
    Description: Before Update Trigger on Account_Contact_Role_Transaction__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters:
    -------
        1. Filters out the records where the field "PN_Mark_As_Synced__c" chages from false to true because it is updated by CINT
        2. Filters out the records that has been updated and has the PN_Mark_As_Synced__c field set to false
        
    Update History
    --------------
    Created March 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger AccountContactRoleTransaction_BeforeUpdate on Account_Contact_Role_Transaction__c (before update) {
   
    List<Account_Contact_Role_Transaction__c> withFlagsToUpdate = new List<Account_Contact_Role_Transaction__c>();
    List<Account_Contact_Role_Transaction__c> withSyncToUpdate = new List<Account_Contact_Role_Transaction__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
    	
	    // Creating Lists and Maps based on filter criteria
	    for (Account_Contact_Role_Transaction__c role : trigger.new) {
	    
	        // Filter 1
	        if (role.PN_Mark_As_Synced__c && !trigger.oldMap.get(role.Id).PN_Mark_As_Synced__c) {
	            withFlagsToUpdate.add(role);
	        }
	        // Filter 2
	        else {
	            withSyncToUpdate.add(role);
	        }  
	    }
	    
	    // Exectue logic in a service class
	    
	    // Filter 1
	    if (withFlagsToUpdate.size() > 0) {     
	        G2O_TransactionSecurityFlags_SVC.updateTransactionSecurityFlags(withFlagsToUpdate);
	    }
	    
	    // Filter 2
	    if (withSyncToUpdate.size() > 0) {      
	        G2O_TransactionSecurityFlags_SVC.setSynchronizedToFalse(withSyncToUpdate);
	    }
    }
}