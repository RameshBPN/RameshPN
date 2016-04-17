/*
* Apex class: CC_PostNord_SoftPhone_VFC_TEST
*
*
* Description:
* Test class for the controller class CC_PostNord_SoftPhone_VFC
* Change Log:
* 2015-06-14  Madhav Kakani  Initial Development
*
*/
@isTest
private class CC_PostNord_SoftPhone_VFC_TEST {
    public static Case c;
    public static Account acct;
    public static Contact ct;
    
    static void setupData() {
            // Create a sample queue
            Group g1 = new Group(Name='Fluido Test', type='Queue');
            insert g1;
            system.assert(g1.Id != null);
            
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            insert q1;
            system.assert(q1.Id != null);
    
            // create a sample clear it queue custom settings
            CC_ClearIT_Queues__c cc_q = new CC_ClearIT_Queues__c();
            cc_q.Name = 'Live Agent Chat';
            cc_q.ClearIT_Queue_Name__c = 'uppdrag2';
            cc_q.ClearIT_Queue_Id__c = '67';

            insert cc_q;
            
            // create a sample cc agent interface record
            CC_Agent_Interface__c agent = new CC_Agent_Interface__c();
            agent.Name = Userinfo.getName();
            agent.User__c = Userinfo.getUserId();
            agent.External_Agent_Id__c = '1';
            agent.Queue_Id__c = '67';
            insert agent;
            system.assert(agent.Id != null);
                      
            UTIL_TestFactory.setUpOrg();
            
            // Create a sample account and case
            acct = UTIL_TestFactory.createAccount();
            acct.Phone = '60602020';
            acct.Mobile_Phone__c = '50501010';
            acct.Postal_Address_PO_Box__c = '2300';
            acct.Postal_Address_Country__c = 'Denmark';
            acct.Registration_Country__c = 'DK';
            insert acct;
            system.assert(acct.Id != null);
    
            ct = new Contact();
            ct.FirstName = 'Test';
            ct.LastName = 'Contact';
            ct.AccountId = acct.Id;
            insert ct;
            system.assert(ct.Id!= null);
            
            c = new Case();
            c.AccountId = acct.Id;
            c.OwnerId = g1.Id;
            c.Subject = 'Test case';
            insert c;
            system.assert(c.Id != null);

            // Create the click to call entry                           
            HTTP_Integration_Services__c hs = new HTTP_Integration_Services__c();
            hs.Name = 'ClearIT_CTC';
            hs.Endpoint__c = 'https://api.clearinteract.se/postnordtest02/api/v1.0/click-to-call';
            hs.Password__c = 'secret_key';
            hs.Provider__c = 'ClearIT';
            hs.SOAPAction__c = 'Process';
            hs.Host__c = 'api.clearinteract.se';
            insert hs;
    }
    
    static testMethod void runTest() {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) { 
            setupData();
            
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());

            Test.startTest();        
            CC_PostNord_SoftPhone_VFC ctrl = new CC_PostNord_SoftPhone_VFC();
            CC_PostNord_SoftPhone_VFC.RequestChat();

            CC_PostNord_SoftPhone_VFC.DeQueueCase(c.Id, '1');

            // CC_PostNord_SoftPhone_VFC.CallPhoneNumber('Account', acct.Id, '60205378', Userinfo.getUserId());
            Test.stopTest();
                
        }
    }

    static testMethod void testCallAcctNumber() {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) { 
            setupData();
                              
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());

            Test.startTest();
            CC_PostNord_SoftPhone_VFC.CallPhoneNumber('Account', acct.Id, '60205378', Userinfo.getUserId());
            Test.stopTest();                
        }
    }

    static testMethod void testCallContactNumber() {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) { 
            setupData();
                              
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());

            Test.startTest();
            CC_PostNord_SoftPhone_VFC.CallPhoneNumber('Contact', ct.Id, '60205378', Userinfo.getUserId());
            Test.stopTest();                
        }
    }

    static testMethod void testCallCaseNumber() {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) { 
            setupData();
                              
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());

            Test.startTest();
            CC_PostNord_SoftPhone_VFC.CallPhoneNumber('Case', c.Id, '60205378', Userinfo.getUserId());
            Test.stopTest();                
        }
    }

}