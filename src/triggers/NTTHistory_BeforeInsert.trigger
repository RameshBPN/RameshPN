/**
    About
    -----
    Description: Before Insert Trigger on NTT_History__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Filters:
    -------
        1.  Sets the IsLatest__c  flag to true for the latest Tracking Event. No filter needed.
        
    Update History
    --------------
    Created May 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger NTTHistory_BeforeInsert on NTT_History__c (before insert) {
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Execute logic in a service class
	        
	    // Filter 1
	    G2O_NTTHistory_SVC.setLatestTrackingEvent(trigger.new);
    }

}