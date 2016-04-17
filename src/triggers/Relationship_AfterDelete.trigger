/**
    About
    -----
    Description: After Delete Trigger on Relationship__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Filters:
    -------
        1. Add all the relationships that has been deleted by a Non-Integration User

    Update History
    --------------
    Created October 2013 - T.R.
    
    Issues / TODOs
    --------------  
    
*/

trigger Relationship_AfterDelete on Relationship__c (after delete) {

	List<Id> deletedRelationships = new List<Id>();

    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
         
        // Creating Lists and Maps based on filter criteria 
        for (Relationship__c rel : trigger.old) {
            
            // Filter 1
            if (!UTIL_Meta.isIntegrationUser(UserInfo.getProfileId())) {
                deletedRelationships.add(rel.Id);
            }
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        if (deletedRelationships.size() > 0) {
        	UTIL_Apex.emptyRecycleBin(deletedRelationships);
        }
    }
}