/*   About
    -----
    Description: This class  will Test G2O_ScheduledObjectDeletion_SVC_SCH class
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details
    -------
    The G2O_ScheduledObjectDeletion_SVC_SCH_TEST class will Test G2O_ScheduledObjectDeletion_SVC_SCH class.
     1.
     
    Update History
    --------------
    Created July 2013 - A.B.
    Updated March 2014 - T.R.
    
    Issues / TODOs
    --------------  
*/
@isTest
public with sharing class G2O_ScheduledObjectDeletion_SVC_SCH_TEST {    
    
    //A.T.T.R.I.B.U.T.E.S
    static list<ApexCalloutLog__c> calloutLogList = new list<ApexCalloutLog__c>();

    private static testMethod void testObjectDeletionScheduler() {

        createData();
        
        String scheduleTimeStr = prepareJobsSchTime(System.now(), 2);
        Test.StartTest();
        String jobId = System.schedule('ApexCalloutLogCleanup_BATCH1092', scheduleTimeStr, new G2O_ScheduledObjectDeletion_SVC_SCH());
 
      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		system.assertNotEquals(null, ct);
		
      	// Verify the job has not run
     	System.assertEquals(0, ct.TimesTriggered);
	
      	// Verify the next time the job will run (jobs doesn't take seconds into consideration so these are nulled)
      	System.assertEquals(System.now().addMinutes(2).addSeconds(-1 * system.now().second()),ct.NextFireTime);
      	Test.StopTest();        
    }

    //Creating test data.
    private static void createData() {
        UTIL_TestFactory.setUpOrg();
        
        //Creating CustomSetting.
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        //Set the grace period to a negative value so the batch job will pick up the created records in the test
        scheduledJobParameters.ApexCalloutLoggracePeriod__c = '-1';
        scheduledJobParameters.ApexCalloutLogDeletionActive__c = true;
        update scheduledJobParameters;
        
        for(integer i = 0; i < 200; i++){
            calloutLogList.add(UTIL_TestFactory.createApexCalloutLog());                  
        }
        insert calloutLogList; 
    }
    
    //Returns DateTime in proper string format to finish method for Scheduling other batch apex classes.
    private static String prepareJobsSchTime(DateTime startDate, Integer addMinutes) {
        Datetime scheduleTime = startDate.addMinutes(addMinutes);
        String hour = scheduleTime.format('k');
        if (hour == '24') {
        	hour = '0';
        }
        String scheduleTimeStr = '0 ' + scheduleTime.format('m') + ' ' + hour + scheduleTime.format(' d M') + ' ? ' + scheduleTime.format('yyyy');
        System.debug(Logginglevel.INFO,'scheduleTimeStr: ' + scheduleTimeStr);
        return scheduleTimeStr;
    }
}