/**
    About
    -----
    Description: After Insert Trigger on OpportunityLineItem
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  Updates Marketo Product CSV field on related Opportunities. No filter needed.
        
    Update History
    --------------
    Created April 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger OpportunityLineItem_AfterInsert on OpportunityLineItem (after insert) {
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Execute logic in a service class
	    
	    // Filter 1
	    G2O_OpportunityLineItem_SVC.updateMarketoProductField(trigger.new);
    }
}