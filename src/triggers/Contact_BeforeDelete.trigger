/**
    About
    -----
    Description: Before Delete Trigger on Contact
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Filters:
    -------
        1. Prevent deletes on contacts that has not been soft deleted (Deletion_Flag__c)
        
    Update History
    --------------
    Created May 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  

    
*/
trigger Contact_BeforeDelete on Contact (before delete) {
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
    	
	    // Creating Lists and Maps based on filter criteria
	    for (Contact c : trigger.old) {
	        
	        // Filter 1
	        if(c.Deletion_Flag__c == false) {
	            c.addError('Can\'t delete contacts that has not been soft deleted (Deletion_Flag__c) first');
	        }
	    }
	    
	    // Execute logic in a service class
    }

}