/**
    About
    -----
    Description: After Delete Trigger on Account_Contact_Role_Transaction__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Filters:
    -------
        1. Add all the ACRTs that has been deleted by a Non-Integration User
        
    Update History
    --------------
    Created October 2013 - T.R.
    
    Issues / TODOs
    --------------  
    
*/

trigger AccountContactRoleTransaction_AfterDelete on Account_Contact_Role_Transaction__c (after delete) {

	List<Id> deletedByNonIntegrationACRTs = new List<Id>();

    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
         
        // Creating Lists and Maps based on filter criteria 
        for (Account_Contact_Role_Transaction__c acr : trigger.old) {
            
            // Filter 1
            if (!UTIL_Meta.isIntegrationUser(UserInfo.getProfileId())) {
                deletedByNonIntegrationACRTs.add(acr.Id);
            }
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        if (deletedByNonIntegrationACRTs.size() > 0) {
            UTIL_Apex.emptyRecycleBin(deletedByNonIntegrationACRTs);
        }
    }
}