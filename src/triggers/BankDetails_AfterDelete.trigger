/**
    About
    -----
    Description: After Delete Trigger on Bank_Details__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Filters:
    -------
        1. Add all the bank details that has been deleted by a Non-Integration User

    Update History
    --------------
    Created October 2013 - T.R.
    
    Issues / TODOs
    --------------  
    
*/

trigger BankDetails_AfterDelete on Bank_Details__c (after delete) {

	List<Id> deletedBankDetails = new List<Id>();

    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
         
        // Creating Lists and Maps based on filter criteria 
        for (Bank_Details__c bd : trigger.old) {
            
            // Filter 1
            if (!UTIL_Meta.isIntegrationUser(UserInfo.getProfileId())) {
                deletedBankDetails.add(bd.Id);
            }
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        if (deletedBankDetails.size() > 0) {
            UTIL_Apex.emptyRecycleBin(deletedBankDetails);
        }
    }
}