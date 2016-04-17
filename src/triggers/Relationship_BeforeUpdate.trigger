/**
    About
    -----
    Description: Before Update Trigger on Relationship__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters:
    -------
        1. Filters out the records where the field "PN_Mark_As_Synced" chages from false to true because it is updated by CINT
        2. Filters out the records that has been updated and has the PN_Mark_As_Synced field set to false
        3. Filters out the records that is not soft deleted
        
    Update History
    --------------
    Created March 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger Relationship_BeforeUpdate on Relationship__c (before update) {

    List<Relationship__c> withFlagsToUpdate = new List<Relationship__c>();
    List<Relationship__c> withSyncToUpdate = new List<Relationship__c>();
    list<Relationship__c> allRelationships = new list<Relationship__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
    	
	    // Creating Lists and Maps based on filter criteria
	    for (Relationship__c relationship : trigger.new) {
	    
	        // Filter 1
	        if (relationship.PN_Mark_As_Synced__c && !trigger.oldMap.get(relationship.Id).PN_Mark_As_Synced__c) {
	            withFlagsToUpdate.add(relationship);
	        }
	        // Filter 2
	        else {
	            withSyncToUpdate.add(relationship);
	        }
	        // Filter 3
	        allRelationships.add(relationship);
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
	    if (allRelationships.size() > 0){
	        G2O_Relationship_SVC.validateSalesAreaOnRelationship(allRelationships);
	    }
    }
}