/**
    About
    -----
    Description: Before Update Trigger on Credit_Information__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters:
    -------
        1. Filters out the records where the field "PN_Mark_As_Synced" chages from false to true because it is updated by CINT
        2. Filters out the records that has been updated and has the PN_Mark_As_Synced field set to false
        
    Update History
    --------------
    Created March 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger CreditInformation_BeforeUpdate on Credit_Information__c (before update) {
 
    List<Credit_Information__c> withFlagsToUpdate = new List<Credit_Information__c>();
    List<Credit_Information__c> withSyncToUpdate = new List<Credit_Information__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Creating Lists and Maps based on filter criteria
	    for (Credit_Information__c creditInformation : trigger.new) {
	    
	        // Filter 1
	        if (creditInformation.PN_Mark_As_Synced__c && !trigger.oldMap.get(creditInformation.Id).PN_Mark_As_Synced__c) {
	            withFlagsToUpdate.add(creditInformation);
	        }
	        // Filter 2
	        else {
	            withSyncToUpdate.add(creditInformation);
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