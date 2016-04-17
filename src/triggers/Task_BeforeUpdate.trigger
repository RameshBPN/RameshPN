/**
    About
    -----
    Description: Before Update Trigger on Task
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Filters:
    -------
        1. Filters out tasks for setting next call list date on associated account.
        2. Filters out tasks for setting next call date on associated account.
        3. Filters out tasks for setting Not_Reached_Counter__c associated to account.
        4. Filters out tasks for setting an indicator on account if any of the related activity has been completed within the last 14 days.

    Update History
    --------------
    Created June 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
        
*/
trigger Task_BeforeUpdate on Task (before update) {

    List<Task> nextCallListDateTaskList = new List<Task>();
    List<Task> activityDateTaskList = new List<Task>();
    List<Task> notReachedCounterTaskList = new List<Task>();
    List<Task> taskIndicatorList = new List<Task>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
    	
	    //Getting the valid Type values from the custom setting.
	    set<String> CallListDateTypeSet = UTIL_OrgSettings.TaskNextCallListDateTypes();             //Associated with Filter 1.
	    set<String> ActivityDateTypeSet = UTIL_OrgSettings.TaskActivityDateTypes();                 //Associated with Filter 2.
	    set<String> NotReachedCounterTypeSet = UTIL_OrgSettings.TaskNotReachedCounterTypes();       //Associated with Filter 3.
	    set<String> CompletedDateTypeSet = UTIL_OrgSettings.TaskActivityCompletedDateTypes();       //Associated with Filter 4.
	    
	    // Creating Lists and Maps based on filter criteria
	    for(Task t : trigger.new) {
	        
	        //Filter 1
	        if(t.Category__c =='Telesales task' && CallListDateTypeSet.contains(t.Activity_Type_std__c) && t.Status =='Completed' ) {   
	            nextCallListDateTaskList.add(t);
	        }
	        
	        //Filter 2 
	        if(t.Category__c =='Telesales task' && ActivityDateTypeSet.contains(t.Activity_Type_std__c) && t.Status=='Completed') {
	            activityDateTaskList.add(t);    
	        }
	        
	        //Filter 3.
	        if(t.Category__c =='Telesales task' && NotReachedCounterTypeSet.contains(t.Activity_Type_std__c) && t.Status=='Completed') {
	            notReachedCounterTaskList.add(t);
	        }
	        
	        //Filter 4.
	        if((t.Category__c =='Telesales task' || CompletedDateTypeSet.contains(t.Activity_Type_std__c)) && t.Status=='Completed') {
	            taskIndicatorList.add(t);
	        }
	    }
	    
	    // Execute logic in a service class
	    
	    //Filter 1
	    if(!nextCallListDateTaskList.isEmpty()) {
	        G2O_Task_SVC.setNextCallListDate(nextCallListDateTaskList);
	    }
	    
	    //Filter 2
	    if(!activityDateTaskList.isEmpty()) {
	        G2O_Task_SVC.setActivityDate(activityDateTaskList);
	    }
	    
	    //Filter 3
	    if(!notReachedCounterTaskList.isEmpty()) {
	        G2O_Task_SVC.setNotReachedCounter(notReachedCounterTaskList);
	    }
	    
	    //Filter 4
	    if(!taskIndicatorList.isEmpty()) {
	        G2O_Task_SVC.setActivityIndicator(taskIndicatorList);
	    }
    }
}