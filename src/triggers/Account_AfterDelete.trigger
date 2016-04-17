/**
    About
    -----
    Description: Before Update Trigger on Account
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Aug 2013
    
    Filters:
    -------
        1. Deletes the records holding the involved party ID's record on deletion of related account record.
        
    Update History
    --------------
    Created Aug 2013 - ME
    
Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    -------------- 
    
*/
trigger Account_AfterDelete on Account (after delete) {
    
    map<id,Account> deletedAccountsById = new map<id,Account>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
    	 
	    // Creating Lists and Maps based on filter criteria 
	    for (Account a : trigger.old) {
	        
	        // Filter 1
	        if (UTIL_Apex.isSet(a.Involved_Party_ID__c))
	        {
	            deletedAccountsById.put(a.id,a);
	        }
	    }
	    
	    // Exectue logic in a service class
	    
	    // Filter 1
	    G2O_Account_SVC.deleteInvolvedPartyIds(deletedAccountsById);
	}
}