/**
    About
    -----
    Description: Before Update Trigger on Lead
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
    1.  Filters out the leads that should be updated with a Lead Reciever (OwnerID)
        
    Update History
    --------------
    Created April 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger Lead_BeforeUpdate on Lead (before update) {

    String leadStatus = UTIL_OrgSettings.LeadStatus();
    String leadSalesArea = UTIL_OrgSettings.LeadSalesAreaSAPcodes();
    
    List<Lead> leadReceiverList = new List<Lead>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
    	
	    // Creating Lists and Maps based on filter criteria
	    for(Lead lead : trigger.new) {
	    
	        // Filter 1
	        if(lead.Account__c != null && lead.Status != null && lead.Sales_Area__c != null) {
	            if(leadStatus.contains(lead.Status) && leadSalesArea.contains(lead.Sales_Area__c) && (lead.OwnerId == Trigger.oldMap.get(lead.Id).OwnerId)) {
	                leadReceiverList.add(lead);
	            }
	        }
	    }
	    
	    // Execute logic in a service class
	    
	    // Filter 1
	    if (leadReceiverList.size() > 0) {     
	        G2O_Lead_SVC.updateLeadReceiver(leadReceiverList);
	    }
    }
}