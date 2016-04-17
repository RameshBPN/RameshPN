/**
    About
    -----
    Description: Before Insert Trigger on Task
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2014
    
    Filters:
    -------
        1. Populate the Task Assigned to and Comments fields
        
    Update History
    --------------
    Created March 2014 - T.R.
    
    Issues / TODOs
    --------------  
        
*/

trigger Task_BeforeInsert on Task (before insert) {

	if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.

	    // Creating Lists and Maps based on filter criteria
		Set<Task> populateWithCampaignInfo = new Set<Task>();
		
		for (Task task : trigger.new) {
			
			//Filter 1
			if (UTIL_Apex.isSet(task.Subject) && task.Subject.containsIgnoreCase(UTIL_OrgSettings.CallContactTaskName())) {
				populateWithCampaignInfo.add(task);
			}
		}
	
		//Filter 1
		if (populateWithCampaignInfo.size() > 0) {
			G2O_Task_SVC.populateCampaignFields(populateWithCampaignInfo);
		}
	}
}