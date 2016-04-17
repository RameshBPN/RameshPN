/*
* Apex class: CC_QueueCases_BATCH_SCH
*
*
* Description:
* Scheduler to run the CC_EnqueueCases_BATCH and CC_DequeueCases_BATCH batch jobs - Customer Console project
* Change Log:
* 2015-06-10  Madhav Kakani  Initial Development
*
*/
global class CC_QueueCases_BATCH_SCH implements Schedulable {
    global void execute(SchedulableContext sc) { 
        // Handle cases that are not yet queued
        CC_EnqueueCases_BATCH bqc1 = new CC_EnqueueCases_BATCH();           
        ID bID1 = Database.executeBatch(bqc1, 100);

        // Handle cases that are are closed and are not yet dequeued
        CC_DequeueCases_BATCH bqc2 = new CC_DequeueCases_BATCH();           
        ID bID2 = Database.executeBatch(bqc2, 100);
    }
}