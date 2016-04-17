/**
    About
    -----
    Description: Before Insert Trigger on Event
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: February 2014
    
    Filters:
    -------
    Update Location only for SalesArea PDK BE and PDK LO

    Update History
    --------------
    Created February 2014 - K.E.A.J
    
    Issues / TODOs
    --------------  
        
*/

trigger Event_BeforeInsert on Event (before insert) {
    List<Event> eventLocationList = new List<Event>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    // Creating Lists and Maps based on filter criteria
	    for(Event e : trigger.new) {
	        
	        //Filter 1.
	        if((e.Sales_area__c == '1000' || e.Sales_area__c == '4000') && (e.location == null || e.location == '')) { 
	            eventLocationList.add(e);
	        }
	    }
	    
	    // Execute logic in a service class
	    
	    //Filter 1.
	    if(!eventLocationList.isEmpty()) {
	        G2O_Event_SVC.setLocation(eventLocationList);
	    }
    }
}