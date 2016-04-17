/**
    About
    -----
    Description: Before Insert Trigger on Contact
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  Creates new account contact roles for new contacts that already have a Contact Person ID provided
        
    Update History
    --------------
    Created April May - C.H.F.
    Updated May - M.E. - New routing for ACR creation. now only creating roles if the contact person id is already provided, otherwise wait for workflow to set the field and then generate roles in the on update trigger
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger Contact_AfterInsert on Contact (after insert) {
    
    Contact[] hasContactPersonId = new Contact[]{};
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
    	
	    // Creating Lists and Maps based on filter criteria
	    for (Contact c: trigger.new) {
	        
	        // Filter 1
	        if (!UTIL_Apex.empty(c.Contact_Person_ID__c)) {
	            hasContactPersonId.add(c);
	        }
	    }
	    
	    // Execute logic in a service class
	    
	    // Filter 1
	    if(hasContactPersonId.size() > 0) {
	        G2O_AccountContactRole_SVC.createRoles(hasContactPersonId);
	    }
    }
}