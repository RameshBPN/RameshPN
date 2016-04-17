/**
    About
    -----
    Description: Scheduling class for handling changes to AccountTeamMembers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: September 2013
    
    Details
    ------- 
    The AccountTeamMemberSync_BATCH_SCH class will schedule the AccountTeamMemberSynch_BATCH class.
     
    Update History
    -------------- 
    Created September 2013 - K.E.A.J. 
    
    Issues / TODOs:
    --------------  
*/
global class G2O_AccountTeamMemberSync_BATCH_SCH implements Schedulable{
	global void execute(SchedulableContext sc) {   
		CronTrigger ct = [SELECT id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        if(UTIL_OrgSettings.AccountTeamMemberSyncJobId() == ''){
        	ScheduledJobParameters__c scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        	scheduledParameters.AccountTeamMemberSyncJobId__c = ct.id;
        	update scheduledParameters;
        }
        // Checks if the job is disabled, if it is, this execution instance is skipped.
        if(!UTIL_OrgSettings.isAccountTeamMemberSyncJobDisabled()){
	        if(UTIL_OrgSettings.AccountTeamMemberSyncJobId() == '' || UTIL_OrgSettings.AccountTeamMemberSyncJobId() == (string)ct.id){
	        	G2O_AccountTeamMemberSync_BATCH ATMSyncJob = new G2O_AccountTeamMemberSync_BATCH();
	        	database.executebatch(ATMSyncJob); 
	        }     
        }
    } 
}