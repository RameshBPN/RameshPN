/**
    About
    -----
    Description: Before Update Trigger on Sales_Area_Information__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters:
    -------
        1. Filters out the records where the field "PN_Mark_As_Synced" chages from false to true because it is updated by CINT
        2. Filters out the records that has been updated and has the PN_Mark_As_Synced field set to false
        3. Gives all records because the method need awareness of all objects in the trigger context
    Update History
    --------------
    Created March 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  

    
*/
trigger SalesAreaInformation_BeforeUpdate on Sales_Area_Information__c (before update) {

    List<Sales_Area_Information__c> withFlagsToUpdate = new List<Sales_Area_Information__c>();
    List<Sales_Area_Information__c> withSyncToUpdate = new List<Sales_Area_Information__c>();
    list<Sales_Area_Information__c> hasBecomeCustomer = new list<Sales_Area_Information__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    // Creating Lists and Maps based on filter criteria
	    for (Sales_Area_Information__c sai : trigger.new) {
	    
	        // Filter 1
	        if (sai.PN_Mark_As_Synced__c && !trigger.oldMap.get(sai.Id).PN_Mark_As_Synced__c) {
	            withFlagsToUpdate.add(sai);
	        }
	        // Filter 2
	        else {
	            withSyncToUpdate.add(sai);
	        }
	        // Filter 3
            hasBecomeCustomer.add(sai);
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
	    // Filter 3
	    if (hasBecomeCustomer.size() > 0){
	        G2O_SalesAreaInformation_SVC.syncSalesAreaInformationOnLE(hasBecomeCustomer, trigger.oldMap);
	    }
    }
}