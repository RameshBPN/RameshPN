/**
    About
    -----
    Description: Scheduling class for cleaning out objects
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details
    -------
     
    Update History
    --------------
    Created September 2013 - K.E.A.J.
    Updated March 2014 - T.R.
    
    Issues / TODOs:
    --------------  
*/
global class G2O_ScheduledObjectDeletion_SVC_SCH implements Schedulable{
    
    global void execute(SchedulableContext sc) {    
        CronTrigger ct = [SELECT id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        if(UTIL_OrgSettings.DeletionJobId() == ''){
            ScheduledJobParameters__c scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
            scheduledParameters.DeletionJobId__c = ct.id;
            update scheduledParameters;
        }
        // Checks if the job is disabled, if it is, this execution instance is skipped.
        if(!UTIL_OrgSettings.isDeletionJobDisabled()){       
            if(UTIL_OrgSettings.DeletionJobId() == '' || UTIL_OrgSettings.DeletionJobId() == (string)ct.id){
                G2O_ScheduledObjectDeletion_SVC sodJob = new G2O_ScheduledObjectDeletion_SVC();
                sodJob.deleteApexCalloutLog();
                sodJob.deleteApexErrorLog();
                sodJob.deleteOutboundNotification();
                sodJob.deleteInboundMessageLog();
            }
        }
    }
}