/**
    About
    -----
    Description: After Update Trigger on Opportunity 
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Has to be in AfterUpdate because of some roll-up summary fields triggered on stage name change (to prevent recursion)
    
    Filters:
    -------
        1.1 Opportunities where the StageName changes to Closed Won (Updates products/qoutes)
        1.2 Opportunities where the StageName changes to Closed Won (Create Assets)
        2   Opportunities where the StageName changes to Closed Lost (Updates products/qoutes)
        
    Update History
    --------------
    Created March April 2013 - C.H.F.
    Added Oppotunity Closed Won/ Closed Lost trigger May 2013  - R.M
    Changed order of 1.1 and 1.2 so the product stage is changed before assets is created
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  

*/
trigger Opportunity_AfterUpdate on Opportunity (after update) {
    
    List<Opportunity> oppFilterOneList = new List<Opportunity>();
    List<Opportunity> oppFilterTwoList = new List<Opportunity>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
    	
	    // Creating Lists and Maps based on filter criteria
	    for(Opportunity opp : Trigger.new)
	    {
	        // Filter 1
	        if (opp.StageName == 'Closed Won' && trigger.oldmap.get(opp.Id).StageName != 'Closed Won') {
	            // Filter 1.1 & Filter 1.2
	            oppFilterOneList.add(opp);
	        }
	        
	        // Filter 2
	        if (opp.StageName == 'Closed Lost' && trigger.oldmap.get(opp.Id).StageName != 'Closed Lost') {
	            oppFilterTwoList.add(opp);
	        }
	        
	    }
	    
	    // Execute logic in a service class
	    
	    // Filter 1.1
	    if(oppFilterOneList.size() > 0) {
	        G2O_Opportunity_SVC.updateProductStatusClosedWon(oppFilterOneList);
	    }
	    // Filter 1.2
	    if(oppFilterOneList.size() > 0 && G2O_Opportunity_SVC.ASSETS_CREATED == false) {
	        G2O_Opportunity_SVC.createAssets(oppFilterOneList);
	    }
	    
	    // Filter 2
	    if(oppFilterTwoList.size() > 0) {
	        G2O_Opportunity_SVC.updateProductStatusClosedLost(oppFilterTwoList);
	    }
    }
}