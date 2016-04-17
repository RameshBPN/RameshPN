/**
    About
    -----
    Description: Before Update Trigger on Event
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Filters:
    -------
        1. Filters out tasks for setting activity indicator on Account if the related Event is completed within last 14 days.
		2. Filters out events with an empty location and a sales area of either 1000 or 4000
		
    Update History
    --------------
    Created June 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
        
*/
trigger Event_BeforeUpdate on Event (before update) {

    List<Event> eventIndicatorList = new List<Event>();
    List<Event> eventLocationList = new List<Event>();   
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    set<String> eventTypeSet = UTIL_OrgSettings.EventActivityCompletedDateTypes();  //Getting the valid Type values from the custom setting.
	    
	    // Creating Lists and Maps based on filter criteria
	    for(Event e : trigger.new) {
	        
	        //Filter 1.
	        if(eventTypeSet.contains(e.Activity_Type_std__c) && (e.Status__c == 'Completed' || e.Status__c == 'Scheduled')) {  
	            eventIndicatorList.add(e);
	        }
			
			//Filter 2.
			if((e.Sales_area__c == '1000' || e.Sales_area__c == '4000') && (e.location == null || e.location == '')) { 
	            eventLocationList.add(e);
	        }
	    }
	    
	    // Execute logic in a service class
	    
	    //Filter 1.
	    if(!eventIndicatorList.isEmpty()) {
	        G2O_Event_SVC.setActivityIndicator(eventIndicatorList);
	    }
	    
	    //Filter 2.
	    if(!eventLocationList.isEmpty()) {
	        G2O_Event_SVC.setLocation(eventLocationList);
	    }	    
    }
}