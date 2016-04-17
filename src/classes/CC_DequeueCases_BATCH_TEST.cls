/*
* Apex class: CC_DequeueCases_BATCH_TEST
*
*
* Description:
* Test class for the batch class CC_DequeueCases_BATCH
* Change Log:
* 2015-06-14  Madhav Kakani  Initial Development
*
*/
@isTest
private class CC_DequeueCases_BATCH_TEST {
    static testMethod void runTest() {   
        UTIL_TestFactory.setUpOrg();
        
        // Create a sample account and case
        Account acct = UTIL_TestFactory.createAccount();
        acct.Phone = '60602020';
        acct.Mobile_Phone__c = '50501010';
        insert acct;
        system.assert(acct.Id != null);

        Case c = new Case();
        c.AccountId = acct.Id;
        c.CC_Item_Id__c = '30';
        c.CC_Queue_Status__c = 'Enqueued';
        c.Subject = 'Test case';
        c.Status = 'Closed';
        insert c;
        system.assert(c.Id != null);
                
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
            
        Test.startTest();        

        CC_DequeueCases_BATCH batch = new CC_DequeueCases_BATCH();
        Id batchId = Database.executeBatch(batch, 1);
            
        Test.stopTest();
    }
}