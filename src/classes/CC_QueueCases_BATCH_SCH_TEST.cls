/*
* Apex class: CC_QueueCases_BATCH_SCH_TEST
*
*
* Description:
* Test class for the scheduler class CC_QueueCases_BATCH_SCH
* Change Log:
* 2015-06-14  Madhav Kakani  Initial Development
*
*/
@isTest
private class CC_QueueCases_BATCH_SCH_TEST {
    static testMethod void runTest() {   
        Test.StartTest();

        // Schedule the test job, midnight December 3rd. 2013
        Integer nYear = System.today().year();
        String CRON_EXP = '0 0 0 3 12 ? ' + String.valueOf(nYear);
        String jobId = System.schedule('SchedulerTest', CRON_EXP, new CC_QueueCases_BATCH_SCH());

        // Get the information from the CronTrigger API object 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same 
        System.assertEquals(CRON_EXP, ct.CronExpression);        

        // Verify the job has not run 
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        String sTime =  String.valueOf(nYear) + '-12-03 00:00:00';
        System.assertEquals(sTime, String.valueOf(ct.NextFireTime));
        
        Test.StopTest();
    }
}