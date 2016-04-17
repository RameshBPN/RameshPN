/**
    About
    -----
    Description: Before Insert Trigger on Relationship__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2013
    
    Filters:
    -------
        1. Filters out the records that is not soft deleted and validates their relations
        2. Filters out all the payer relationships
        
    Update History
    --------------
    Created August 2013 - K.E.A.J.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/

trigger Relationship_BeforeInsert on Relationship__c (before insert) {
    
    list<Relationship__c> allRelationships = new list<Relationship__c>();
    set<Relationship__c> allPayerRelationships = new set<Relationship__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Creating Lists and Maps based on filter criteria
	    for (Relationship__c relationship : trigger.new) {
	        // Filter 1    
	        allRelationships.add(relationship);
	        
	        //Filter 2
	        if (relationship.Relationship_Type__c == UTIL_OrgSettings.RelationshipTypePayer()) {
	        	allPayerRelationships.add(relationship);
	        }
	    }
	    
	    // Execute logic in a service class
	    
	    // Filter 1
	    if (allRelationships.size() > 0){
	        G2O_Relationship_SVC.validateSalesAreaOnRelationship(allRelationships);
	    }
	    //Filter 2
	    if (allPayerRelationships.size() > 0) {
	    	G2O_Relationship_SVC.validateOnlyOnePayerPerSalesArea(allPayerRelationships);
	    }
    }
}