/*
* Apex class: CC_InvokeUpdate_BATCH_TEST
*
*
* Description:
* Test class for the batch class CC_InvokeUpdate_BATCH
* Change Log:
* 2015-06-12  Madhav Kakani  Initial Development
*
*/
@isTest
private class CC_InvokeUpdate_BATCH_TEST {
    static testMethod void runTest() {
        // create country code custom settings
        Country_Calling_Codes__c cc = new Country_Calling_Codes__c();
        cc.Name = 'DK';
        cc.Code__c = '45';
        cc.Country__c = 'DENMARK';
        insert cc;

        UTIL_TestFactory.setUpOrg();
        
        Account acct = UTIL_TestFactory.createAccount();
        acct.Phone = '60602020';
        acct.Mobile_Phone__c = '50501010';
        insert acct;
        system.assert(acct.Id != null);
        
        Test.startTest();        

        CC_InvokeUpdate_BATCH batch = new CC_InvokeUpdate_BATCH('Account');
        Id batchId = Database.executeBatch(batch, 1);
                
        Test.stopTest();

        Account act = [SELECT Id, CC_Phone__c, CC_Mobile__c FROM Account WHERE Id = :acct.Id];
        system.assert(act.Id != null);
        system.assertEquals(act.CC_Phone__c, '+4560602020');
        system.assertEquals(act.CC_Mobile__c, '+4550501010');
    }

}