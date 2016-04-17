/*
* Apex class: CC_EnqueueCases_BATCH_TEST
*
*
* Description:
* Test class for the batch class CC_EnqueueCases_BATCH
* Change Log:
* 2015-06-14  Madhav Kakani  Initial Development
*
*/
@isTest
private class CC_EnqueueCases_BATCH_TEST {
    static testMethod void runTest() {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) { 
            // Create a sample queue
            Group g1 = new Group(Name='Fluido Test', type='Queue');
            insert g1;
            system.assert(g1.Id != null);
            
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            insert q1;
            system.assert(q1.Id != null);
    
            // create a sample clear it queue custom settings
            CC_ClearIT_Queues__c cc_q = new CC_ClearIT_Queues__c();
            cc_q.Name = 'Fluido Test';
            cc_q.ClearIT_Queue_Name__c = 'uppdrag2';
            insert cc_q;
                      
            UTIL_TestFactory.setUpOrg();
            
            // Create a sample account and case
            Account acct = UTIL_TestFactory.createAccount();
            acct.Phone = '60602020';
            acct.Mobile_Phone__c = '50501010';
            insert acct;
            system.assert(acct.Id != null);
    
            Case c = new Case();
            c.AccountId = acct.Id;
            c.OwnerId = g1.Id;
            c.Subject = 'Test case';
            insert c;
            system.assert(c.Id != null);
                    
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());

            Test.startTest();        

            CC_EnqueueCases_BATCH batch = new CC_EnqueueCases_BATCH();
            Id batchId = Database.executeBatch(batch, 1);
                
            Test.stopTest();
        }
    }

}