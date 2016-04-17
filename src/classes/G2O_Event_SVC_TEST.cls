/**
    About
    -----
    Description: This class is used to test Event_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Details
    -------
    This Class test the Event_SVC class.
    1. Test the setCompletedDate functionality for PDK LO SalesArea for Events.
    2. Test the setLocation functionality for PDK LO SalesArea for Events. 
    
    Update History
    --------------
    Created June 2013 - A.B.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Event_SVC_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static List<User> userLst;
    static List<Account> accList;
    static List<Contact> contactList; 
    static List<Event> eventList;
    static Account acc;
    
    //A.T.T.R.I.B.U.T.E.S
    
    //1. Test the setCompletedDate functionality for PDK LO SalesArea for Events.
    static testMethod void setCompletedDateEventTest(){
        
        //Arrange
        createTestData();
        
        //Act and //Assert
        System.runas(userLst[0]){
          // Date within two weeks
          eventList[0].StartDateTime = DateTime.now().addDays(-1);
          eventList[0].ActivityDateTime = eventList[0].StartDateTime;
          eventList[0].DurationInMinutes = 5;
            insert eventList;
            
            Event e = [Select Id, Account.ActivityCompletedDate__c From Event where Id = :eventList[0].Id];
            System.assertEquals(Date.today().addDays(-1),e.Account.ActivityCompletedDate__c); // Set to same date
            
            // Date before ActivityCompletedDate__c
            e.StartDateTime = DateTime.now().addDays(-100);
            update e;
            
            e = [Select Id, Account.ActivityCompletedDate__c From Event where Id = :eventList[0].Id];
            System.assertEquals(Date.today().addDays(-1),e.Account.ActivityCompletedDate__c); // No change
            
            // Date 25 days the future
            e.StartDateTime = DateTime.now().addDays(25);
            update e;
            
            e = [Select Id, Account.ActivityCompletedDate__c From Event where Id = :eventList[0].Id];
            System.assertEquals(Date.today().addDays(25),e.Account.ActivityCompletedDate__c); // Set to same date
            
            // Date 50 days the future
            e.StartDateTime = DateTime.now().addDays(50);
            update e;
            
            e = [Select Id, Account.ActivityCompletedDate__c From Event where Id = :eventList[0].Id];
            System.assertEquals(Date.today().addDays(25),e.Account.ActivityCompletedDate__c); // No change
        }
    }
    
    //2. Test the setLocation functionality for PDK LO SalesArea for Events.
    static testMethod void setLocation(){
        
        //Arrange
        createInsertUpdateTestData();
        
        //Act and //Assert
        System.runas(userLst[0]){
            insert eventList;
            
            System.assertEquals('Test AccountName, Test Street 5, 2100 Test City',[Select Id, location From Event where Id = :eventList[0].Id].Location); 
            System.assertEquals('Test AccountName, Test Street 5, 2100 Test City',[Select Id, location From Event where Id = :eventList[1].Id].Location); 
            System.assertEquals(null,[Select Id, location From Event where Id = :eventList[2].Id].Location);         
            System.assertEquals(null,[Select Id, location From Event where Id = :eventList[3].Id].Location);         
            
            eventList[2].whatId = acc.id;   
            acc.Name = 'Test AccountNameModified';
            update acc;
            update eventList;
            
            System.assertEquals('Test AccountName, Test Street 5, 2100 Test City',[Select Id, location From Event where Id = :eventList[0].Id].Location); 
            System.assertEquals('Test AccountName, Test Street 5, 2100 Test City',[Select Id, location From Event where Id = :eventList[1].Id].Location); 
            System.assertEquals('Test AccountNameModified, Test Street 5, 2100 Test City',[Select Id, location From Event where Id = :eventList[2].Id].Location);         
            System.assertEquals(null,[Select Id, location From Event where Id = :eventList[3].Id].Location);         
        }
    }
    
    //Create Test Data for Task.
    static void createTestData(){
        
        //Creating custom setting.
        UTIL_TestFactory.setUpOrg();
        
        //Creating Users.
        userLst =new List<User>();
        /*
        User usr0 = UTIL_TestFactory.createUser('testUser1@cg.com','CS Standard User');
        usr0.Sales_Area1__c = '4000';
        userLst.add(usr0);
        */
        User usr1 = UTIL_TestFactory.createUser('testUser2@cg.com','CS Standard User');
        usr1.Sales_Area1__c = '1000';
        userLst.add(usr1);
        
        accList = UTIL_TestFactory.createAccounts();
        insert accList;
        
        contactList =UTIL_TestFactory.createContacts();

        for(integer i =0;i<contactList.size();i++){
            contactList[i].AccountId = accList[i].Id;
        }
        insert contactList;
        
        system.debug('+++contactList+11++'+contactList[0].AccountId);
        eventList = UTIL_TestFactory.createEvents();
        
        for(integer i=0; i<eventList.size();i++){
            eventList[i].Activity_Type_std__c ='Physical Meeting';
            eventList[i].Status__c='Completed';
            eventList[i].Activity_Sub_Type__c ='Close Deal';
            eventList[i].WhoId = contactList[i].Id;
            eventList[i].StartDateTime = DateTime.now().addDays(-100);
            eventList[i].ActivityDateTime = eventList[i].StartDateTime;
            eventList[i].DurationInMinutes = 5;
        }  
    }
    
        //Create Test Data for Task.
    static void createInsertUpdateTestData(){
        
        //Creating custom setting.
        UTIL_TestFactory.setUpOrg();
        
        //Creating Users.
        userLst =new List<User>();
        accList = new list<Account>();
        contactList = new list<Contact>();
        eventList = new list<Event>();
        
        User usr0 = UTIL_TestFactory.createUser('testUser1@cg.com','CS Standard User');
        usr0.Sales_Area1__c = '1000';
        userLst.add(usr0);
        
        acc = UTIL_TestFactory.createAccount();
        acc.Name = 'Test AccountName';
        acc.Postal_Address_City__c = 'Test City';
        acc.Postal_Address_Country__c = 'GB';
        acc.Registration_Country__c = 'GB';
        acc.Postal_Address_House_Number__c = '5';
        acc.Postal_Address_Street__c = 'Test Street';
        
        insert acc;
        
        Contact con = UTIL_TestFactory.createContact();
        con.AccountId = acc.id;
        insert con;

    Event ev1 = UTIL_TestFactory.createEvent();
    ev1.WhatId = Acc.id;
    ev1.Sales_area__c = '1000';
    Event ev2 = UTIL_TestFactory.createEvent();
    ev2.WhoId = con.id;
    Event ev3 = UTIL_TestFactory.createEvent();
    Event ev4 = UTIL_TestFactory.createEvent();
    
        eventList.add(ev1);
        eventList.add(ev2);
        eventList.add(ev3);
        eventList.add(ev4);
    }
}