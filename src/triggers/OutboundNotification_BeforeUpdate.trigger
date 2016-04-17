/**
    About
    -----
    Description: Before Update Trigger on Bank_Details__c
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

trigger OutboundNotification_BeforeUpdate on Outbound_Notification__c (before update) {

	List<Outbound_Notification__c> withFlagsToUpdate = new List<Outbound_Notification__c>();
    List<Outbound_Notification__c> withSyncToUpdate = new List<Outbound_Notification__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Creating Lists and Maps based on filter criteria
	    for (Outbound_Notification__c outboundNotification : trigger.new) {
	    
	        // Filter 1
	        if (outboundNotification.PN_Mark_As_Synced__c && !trigger.oldMap.get(outboundNotification.Id).PN_Mark_As_Synced__c) {
	            withFlagsToUpdate.add(outboundNotification);
	        }
	        // Filter 2
	        else {
	            withSyncToUpdate.add(outboundNotification);
	        }
	    }
	    
	    // Execute logic in a service class
	    
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