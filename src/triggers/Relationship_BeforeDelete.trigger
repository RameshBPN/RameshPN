/**
    About
    -----
    Description: Before Delete Trigger on Relationship__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Filters:
    -------
        1. Add all the relationships that has got the Relationship Compound ID (should be all deletions not done by integrations)

    Update History
    --------------
    Created October 2013 - T.R.
    
    Issues / TODOs
    --------------  
    
*/

trigger Relationship_BeforeDelete on Relationship__c (before delete) {

	List<Relationship__c> deletedRelationships = new List<Relationship__c>();

    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
         
        // Creating Lists and Maps based on filter criteria 
        for (Relationship__c rel : trigger.old) {
            
            // Filter 1
            if (UTIL_Apex.isSet(rel.Relationship_Compound_SFID__c) && 
            					!UTIL_Meta.isIntegrationUser(UserInfo.getProfileId())) {
                deletedRelationships.add(rel);
            }
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        if (deletedRelationships.size() > 0) {
        	G2O_OutboundNotification_SVC.createDeleteNotifications(deletedRelationships);
        }
    }

}