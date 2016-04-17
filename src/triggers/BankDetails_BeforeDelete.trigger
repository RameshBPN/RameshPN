/**
    About
    -----
    Description: Before Delete Trigger on Bank_Details__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Filters:
    -------
        1. Add all the bank details that has got the Bank Details Compound ID (should be all deletions not done by integrations)

    Update History
    --------------
    Created October 2013 - T.R.
    
    Issues / TODOs
    --------------  
    
*/

trigger BankDetails_BeforeDelete on Bank_Details__c (before delete) {

    List<Bank_Details__c> deletedBankDetails = new List<Bank_Details__c>();

    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
         
        // Creating Lists and Maps based on filter criteria 
        for (Bank_Details__c bd : trigger.old) {
            
            // Filter 1
            if (UTIL_Apex.isSet(bd.Bank_Details_Compound_SFID__c) && 
                                !UTIL_Meta.isIntegrationUser(UserInfo.getProfileId())) {
                deletedBankDetails.add(bd);
            }
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        if (deletedBankDetails.size() > 0) {
            G2O_OutboundNotification_SVC.createDeleteNotifications(deletedBankDetails);
        }
    }
}