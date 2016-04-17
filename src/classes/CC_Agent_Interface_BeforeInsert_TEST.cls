/*
* Apex class: CC_Agent_Interface_BeforeInsert_TEST
*
*
* Description:
* Test class for the CC_Agent_Interface_BeforeInsert trigger
* Change Log:
* 2015-06-18  Madhav Kakani  Initial Development
*
*/
@isTest
private class CC_Agent_Interface_BeforeInsert_TEST {
    static testMethod void runTest() {   
        UTIL_TestFactory.setUpOrg();

        CC_Agent_Interface__c c1 = new CC_Agent_Interface__c();
        c1.Name = 'Test Agent 1';
        c1.User__c = Userinfo.getUserId();
        c1.External_Agent_Id__c = '1';
        insert c1;
        system.assert(c1.Id != null);

        CC_Agent_Interface__c c2 = new CC_Agent_Interface__c();
        c2.Name = 'Test Agent 2';
        c2.User__c = Userinfo.getUserId();
        c2.External_Agent_Id__c = '2';
        try {
            insert c2; // should give an error
        } catch(Exception e) {
            System.assert(e.getMessage().contains(Label.CC_Duplicates_Not_Allowed));
        }
                            
        Test.startTest();        

        Test.stopTest();
    }
}