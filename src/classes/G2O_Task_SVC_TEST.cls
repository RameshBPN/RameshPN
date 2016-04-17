/**
    About
    -----
    Description: This class is used to test Task_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Details
    -------
    This Class test the Task_SVC class.
    1. Test the setNextCallListDate functionality for 4000 SalesArea.
    2. Test the setActivityDate functionality for 4000 SalesArea.
    3. Test the setNotReachedCounter functionality for 4000 & 1000 SalesArea.
    4. Test the setCompletedDate functionality for 4000 SalesArea.
    5. Test the setNextCallListDate functionality for 1000 SalesArea.
    6. Test that the campaign fields are populated on the task
    
    Update History
    --------------
    Created June 2013 - A.B.
    1 . March 2016 - Since SalesArea 4000 is removed for DK users - Excluded the test cases 1 & 2 
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Task_SVC_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static List<User> userLst;
    static List<Account> accList;
    static List<Contact> contactList; 
    static List<Task> taskCompleted_4000List;
    static List<Task> taskPostponed_4000List;
    static List<Task> taskNotReached_4000List;
    static List<Task> taskNotReached_1000List;
    static List<Task> taskCompletedDate_4000List;
    static List<Task> taskCompleted_1000List;
    
    //A.T.T.R.I.B.U.T.E.S
/*    
    //1. Test the setNextCallListDate functionality for PDK BE SalesArea.
   static testMethod void setNextCallListDate_Test1(){
        
        //Arrange
        createTaskTestData();
        
        //Act
        System.runas(userLst[0]){
            insert taskCompleted_4000List;
        }
        
        List<Id> taskIdList = new List<Id>();
        for(Task tasks : taskCompleted_4000List){
            taskIdList.add(tasks.Id);
        }
        
        //Assert
        List<Task> tskList = [Select t.Account.ME_SE_custom_call_interval__c, t.Account.LO_NO_custom_call_interval__c, 
                                t.Account.LO_FI_DPD_custom_call_interval__c, t.Account.PDK_BE_custom_call_interval__c, t.Account.PDK_LO_custom_call_interval__c,
                                t.Account.LO_SE_custom_call_interval__c, t.Account.LO_FI_custom_call_interval__c, t.Account.Next_Call_List_Date_LO_NO__c, 
                                t.Account.Next_Call_List_Date_LO_FI_DPD__c, t.Account.Next_Call_List_Date_LO_FI__c, t.Account.Next_Call_List_Date_LO_SE__c, 
                                t.Account.Next_Call_List_Date_ME_SE__c, t.Account.Next_Call_List_Date_PDK_LO__c, t.Account.Not_reached_counter_LO_NO__c, 
                                t.Account.Not_reached_counter_LO_FI_DPD__c, t.Account.Not_reached_counter_LO_FI__c, t.Account.Not_reached_counter_LO_SE__c, 
                                t.Account.Not_reached_counter_PDK_BE__c, t.Account.Next_Call_List_Date_PDK_BE__c, t.Account.Not_reached_counter_LO_DK__c, 
                                t.Account.Not_reached_counter_PDK_LO__c, t.Account.Next_Call_List_Date_LO_DK__c,
                                t.Account.PDK_LO_Top_Segment__c,t.Account.PDK_BE_Top_Segment__c,t.Account.ME_SE_Top_Segment__c,
                                t.Account.LO_SE_Top_Segment__c,t.Account.LO_NO_Top_Segment__c,t.Account.LO_FI_Top_Segment__c,
                                t.Account.LO_FI_DPD_Top_Segment__c,t.Account.LO_DK_Top_Segment__c,
                                t.Account.PDK_LO_Sub_Segment__c,t.Account.PDK_BE_Sub_Segment__c,t.Account.ME_SE_Sub_Segment__c,
                                t.Account.LO_SE_Sub_Segment__c,t.Account.LO_NO_Sub_Segment__c,t.Account.LO_FI_Sub_Segment__c,
                                t.Account.LO_FI_DPD_Sub_Segment__c ,t.Account.LO_DK_Sub_Segment__c From Task t where t.Id IN:taskIdList];
        
        Date callListDate = system.Today();
        //Segement present for '4000' & CustomCallInterval is present on Account,To Test NextCallListDate functionality.
        System.assertEquals(callListDate +365/2,tskList[0].Account.Next_Call_List_Date_PDK_LO__c);
        System.assertEquals('KA',tskList[0].Account.PDK_LO_Top_Segment__c);
        
        //Segment present for '4000' & CustomCallInterval is not present on Account,To Test NextCallListDate functionality.
        System.assertEquals(callListDate +365/52,tskList[1].Account.Next_Call_List_Date_PDK_LO__c);
        System.assertEquals('KA',tskList[1].Account.PDK_LO_Top_Segment__c);
        
        //Segement not present for SalesArea:'4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
        System.assertEquals(callListDate +365/3,tskList[2].Account.Next_Call_List_Date_PDK_LO__c);
        System.assertEquals(null,tskList[2].Account.PDK_LO_Top_Segment__c);
        
        //Segement not present for SalesArea:'4000' & CustomCallInterval is not present on Account,It must take the customCallInterval Value  from CustomSetting.
        //To Test NextCallListDate functionality.
        System.assertEquals(callListDate +365/5,tskList[3].Account.Next_Call_List_Date_PDK_LO__c);
        System.assertEquals(null,tskList[3].Account.PDK_LO_Top_Segment__c);
    }
   
    //2. Test the setActivityDate functionality for 4000 SalesArea.
    static testMethod void setActivityDate(){
        
        //Arrange
        createTaskTestData();
        
        //Act
        System.runas(userLst[0]){
            insert taskPostponed_4000List;
        }
        
        //Assert
        List<Task> tskList = [Select t.Account.ME_SE_custom_call_interval__c, t.Account.LO_NO_custom_call_interval__c, 
                                t.Account.LO_FI_DPD_custom_call_interval__c, t.Account.PDK_BE_custom_call_interval__c, t.Account.PDK_LO_custom_call_interval__c,
                                t.Account.LO_SE_custom_call_interval__c, t.Account.LO_FI_custom_call_interval__c, t.Account.Next_Call_List_Date_LO_NO__c, 
                                t.Account.Next_Call_List_Date_LO_FI_DPD__c, t.Account.Next_Call_List_Date_LO_FI__c, t.Account.Next_Call_List_Date_LO_SE__c, 
                                t.Account.Next_Call_List_Date_ME_SE__c, t.Account.Next_Call_List_Date_PDK_LO__c, t.Account.Not_reached_counter_LO_NO__c, 
                                t.Account.Not_reached_counter_LO_FI_DPD__c, t.Account.Not_reached_counter_LO_FI__c, t.Account.Not_reached_counter_LO_SE__c, 
                                t.Account.Not_reached_counter_PDK_BE__c, t.Account.Next_Call_List_Date_PDK_BE__c, t.Account.Not_reached_counter_LO_DK__c, 
                                t.Account.Not_reached_counter_PDK_LO__c, t.Account.Next_Call_List_Date_LO_DK__c,
                                t.Account.PDK_LO_Top_Segment__c,t.Account.PDK_BE_Top_Segment__c,t.Account.ME_SE_Top_Segment__c,
                                t.Account.LO_SE_Top_Segment__c,t.Account.LO_NO_Top_Segment__c,t.Account.LO_FI_Top_Segment__c,
                                t.Account.LO_FI_DPD_Top_Segment__c,t.Account.LO_DK_Top_Segment__c,
                                t.Account.PDK_LO_Sub_Segment__c,t.Account.PDK_BE_Sub_Segment__c,t.Account.ME_SE_Sub_Segment__c,
                                t.Account.LO_SE_Sub_Segment__c,t.Account.LO_NO_Sub_Segment__c,t.Account.LO_FI_Sub_Segment__c,
                                t.Account.LO_FI_DPD_Sub_Segment__c ,t.Account.LO_DK_Sub_Segment__c From Task t where t.Id =:taskPostponed_4000List[0].Id];
        
        Date nextCallListDate =  system.today() - 2;
        //Get the Next Call List Date based on the Sales Area and populate it with the Activity date.
        System.assertEquals(nextCallListDate,tskList[0].Account.Next_Call_List_Date_PDK_LO__c);
        
        //Next Call List Date should be populated as per the SalesArea & for others it should be null.
        System.assertEquals(null,tskList[0].Account.Next_Call_List_Date_ME_SE__c);
    }
*/    
    //3. Test the setNotReachedCounter functionality for 4000 & 1000 SalesArea.
    static testMethod void setNotReachedCounter(){
        
        //Arrange
        createTaskTestData();
        
        //Act
 /*       System.runas(userLst[0]){
            insert taskNotReached_4000List;
        }
 */       
        System.runas(userLst[1]){
            insert taskNotReached_1000List;
        }
        
        List<Id> taskIdList = new List<Id>();
        taskIdList.add(taskNotReached_4000List[0].Id);
        taskIdList.add(taskNotReached_1000List[0].Id);
        
        
        //Assert
        List<Task> tskList = [Select t.Account.ME_SE_custom_call_interval__c, t.Account.LO_NO_custom_call_interval__c, 
                                t.Account.LO_FI_DPD_custom_call_interval__c, t.Account.PDK_BE_custom_call_interval__c, t.Account.PDK_LO_custom_call_interval__c,
                                t.Account.LO_SE_custom_call_interval__c, t.Account.LO_FI_custom_call_interval__c, t.Account.Next_Call_List_Date_LO_NO__c, 
                                t.Account.Next_Call_List_Date_LO_FI_DPD__c, t.Account.Next_Call_List_Date_LO_FI__c, t.Account.Next_Call_List_Date_LO_SE__c, 
                                t.Account.Next_Call_List_Date_ME_SE__c, t.Account.Next_Call_List_Date_PDK_LO__c, t.Account.Not_reached_counter_LO_NO__c, 
                                t.Account.Not_reached_counter_LO_FI_DPD__c, t.Account.Not_reached_counter_LO_FI__c, t.Account.Not_reached_counter_LO_SE__c, 
                                t.Account.Not_reached_counter_PDK_BE__c, t.Account.Next_Call_List_Date_PDK_BE__c, t.Account.Not_reached_counter_LO_DK__c, 
                                t.Account.Not_reached_counter_PDK_LO__c, t.Account.Next_Call_List_Date_LO_DK__c,
                                t.Account.PDK_LO_Top_Segment__c,t.Account.PDK_BE_Top_Segment__c,t.Account.ME_SE_Top_Segment__c,
                                t.Account.LO_SE_Top_Segment__c,t.Account.LO_NO_Top_Segment__c,t.Account.LO_FI_Top_Segment__c,
                                t.Account.LO_FI_DPD_Top_Segment__c,t.Account.LO_DK_Top_Segment__c,
                                t.Account.PDK_LO_Sub_Segment__c,t.Account.PDK_BE_Sub_Segment__c,t.Account.ME_SE_Sub_Segment__c,
                                t.Account.LO_SE_Sub_Segment__c,t.Account.LO_NO_Sub_Segment__c,t.Account.LO_FI_Sub_Segment__c,
                                t.Account.LO_FI_DPD_Sub_Segment__c ,t.Account.LO_DK_Sub_Segment__c From Task t where t.Id IN:taskIdList];
        
        Date callListDate = system.Today();
  /*      //Segement present for '4000' & CustomCallInterval is present,To Test notReachedCounter functionality.
        System.assertEquals(null,tskList[0].Account.Next_Call_List_Date_PDK_LO__c);
        System.assertEquals(1,tskList[0].Account.Not_reached_counter_PDK_BE__c);
   */     
        //Segment present for '4000' & CustomCallInterval is not present,To Test notReachedCounter functionality.
        System.assertEquals(callListDate +365/7,tskList[0].Account.Next_Call_List_Date_PDK_BE__c);
        System.assertEquals(0,tskList[0].Account.Not_reached_counter_PDK_BE__c);
        
    }
    
    //4. Test the setCompletedDate functionality for 4000 SalesArea.
    static testMethod void setCompletedDateTask(){
        
        //Arrange
        createTaskTestData();
        
        //Act and //Assert
        System.runas(userLst[0]){
          // Date within two weeks
          taskCompletedDate_4000List[0].ActivityDate = Date.today().addDays(-1);
            insert taskCompletedDate_4000List;
            
            Task t = [Select Id, Account.ActivityCompletedDate__c From Task where Id = :taskCompletedDate_4000List[0].Id];
            System.assertEquals(Date.today().addDays(-1),t.Account.ActivityCompletedDate__c); // Set to same date
            
            // Date before ActivityCompletedDate__c
            t.ActivityDate = Date.today().addDays(-100);
            update t;
            
            t = [Select Id, Account.ActivityCompletedDate__c From Task where Id = :taskCompletedDate_4000List[0].Id];
            System.assertEquals(Date.today().addDays(-1),t.Account.ActivityCompletedDate__c); // No change
            
            // Date in the future
            t.ActivityDate = Date.today().addDays(1);
            update t;
            
            t = [Select Id, Account.ActivityCompletedDate__c From Task where Id = :taskCompletedDate_4000List[0].Id];
            System.assertEquals(Date.today(),t.Account.ActivityCompletedDate__c); // Set to today
        } 
    }

    //5. Test the setNextCallListDate functionality for 1000 SalesArea .
    static testMethod void setNextCallListDate_Test2(){
        
        //Arrange
        createTaskTestData();
        
        //Act
        System.runas(userLst[1]){
            insert taskCompleted_1000List;
        }
        
        //Assert
        List<Id> taskIdList = new List<Id>();
        for(Task tasks : taskCompleted_1000List){
            taskIdList.add(tasks.Id);
        }
        
        system.debug('++++taskIdList+++'+taskIdList);
        
        //Assert
        List<Task> tskList = [Select t.Account.ME_SE_custom_call_interval__c, t.Account.LO_NO_custom_call_interval__c, 
                                t.Account.LO_FI_DPD_custom_call_interval__c, t.Account.PDK_BE_custom_call_interval__c, t.Account.PDK_LO_custom_call_interval__c,
                                t.Account.LO_SE_custom_call_interval__c, t.Account.LO_FI_custom_call_interval__c, t.Account.Next_Call_List_Date_LO_NO__c, 
                                t.Account.Next_Call_List_Date_LO_FI_DPD__c, t.Account.Next_Call_List_Date_LO_FI__c, t.Account.Next_Call_List_Date_LO_SE__c, 
                                t.Account.Next_Call_List_Date_ME_SE__c, t.Account.Next_Call_List_Date_PDK_LO__c, t.Account.Not_reached_counter_LO_NO__c, 
                                t.Account.Not_reached_counter_LO_FI_DPD__c, t.Account.Not_reached_counter_LO_FI__c, t.Account.Not_reached_counter_LO_SE__c, 
                                t.Account.Not_reached_counter_PDK_BE__c, t.Account.Next_Call_List_Date_PDK_BE__c, t.Account.Not_reached_counter_LO_DK__c, 
                                t.Account.Not_reached_counter_PDK_LO__c, t.Account.Next_Call_List_Date_LO_DK__c,
                                t.Account.PDK_LO_Top_Segment__c,t.Account.PDK_BE_Top_Segment__c,t.Account.ME_SE_Top_Segment__c,
                                t.Account.LO_SE_Top_Segment__c,t.Account.LO_NO_Top_Segment__c,t.Account.LO_FI_Top_Segment__c,
                                t.Account.LO_FI_DPD_Top_Segment__c,t.Account.LO_DK_Top_Segment__c,
                                t.Account.PDK_LO_Sub_Segment__c,t.Account.PDK_BE_Sub_Segment__c,t.Account.ME_SE_Sub_Segment__c,
                                t.Account.LO_SE_Sub_Segment__c,t.Account.LO_NO_Sub_Segment__c,t.Account.LO_FI_Sub_Segment__c,
                                t.Account.LO_FI_DPD_Sub_Segment__c ,t.Account.LO_DK_Sub_Segment__c From Task t where t.Id IN:taskIdList];
        
        system.debug('++++tskList+++'+tskList);
        
        Date callListDate = system.Today();
        list<id> accountTempList = new list<id>();
        for(Task tsk : tskList){
          accountTempList.add(tsk.Accountid);
        }
        
        //Segement present for '1000' & CustomCallInterval is present on Account,To Test NextCallListDate functionality.
        System.assertEquals(callListDate +365/365,tskList[0].Account.Next_Call_List_Date_PDK_BE__c);
        System.assertEquals('KA',tskList[0].Account.PDK_BE_Top_Segment__c);
        
        //Segment present for '1000' & CustomCallInterval is not present on Account,Get the Interval from CustomSetting.To Test NextCallListDate functionality.
        System.assertEquals(callListDate +365/3,tskList[1].Account.Next_Call_List_Date_PDK_BE__c);
        System.assertEquals('KA',tskList[1].Account.PDK_BE_Top_Segment__c);
    }
    
    //6. Test that the campaign fields are populated on the task
    static testMethod void testCampaignFieldsPopulation() {
      //Arrange
      UTIL_TestFactory.setUpOrg();
      
      String campaignName = 'Test Campaign Name';
      String campaignDesc = 'Test Campaign Description';
      
      Account account = UTIL_TestFactory.createAccount();
      account.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
      insert account;
      
      Contact contact = UTIL_TestFactory.createContact();
      contact.AccountId = account.Id;
      contact.Campaign_Name__c = campaignName;
      contact.Campaign_Description__c = campaignDesc;
      contact.Campaign_Task__c = 'PDK BE';
      
      Campaign campaign = UTIL_TestFactory.createCampaign();
      campaign.Name = campaignName;
      
      //Act
      insert contact;
      
      //Assert
      Task task = [SELECT Id, WhatId, Description FROM Task WHERE WhoId =: contact.Id];
      
      System.assertNotEquals(null, task, 'No task created.');
      System.assertEquals(campaign.Id, task.WhatId, 'Task not related to campaign.');
      System.assertEquals(campaignDesc, task.Description, 'Campaign description not copied to Task comments.');
    }
    
    //Create Test Data for Task.
    static void createTaskTestData(){
        
        UTIL_TestFactory.setUpOrg();
        
        //Creating Users.
        userLst = new List<User>();
        contactList = new List <Contact>();
        
        User usr0 = UTIL_TestFactory.createUser('testUser1@cg.com','CS Standard User');
        usr0.Sales_Area1__c = '4000';
        userLst.add(usr0);
        
        User usr1 = UTIL_TestFactory.createUser('testUser2@cg.com','CS Standard User');
        usr1.Sales_Area1__c = '1000';
        userLst.add(usr1);
        
        insert userLst;
        
        //Creating Account.
        /*
            1. testAcc0 :Segement present for '4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
            2. testAcc1 :Segment present for '4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
            3. testAcc2 :Segement not present for SalesArea:'4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
            4. testAcc3 :Segement not present for SalesArea:'4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
            5. testAcc4 :Segement present for '4000' & CustomCallInterval is present,To Test notReachedCounter functionality.
            6. testAcc5 :Segment present for '4000' & CustomCallInterval is not present,To Test notReachedCounter functionality.
            7. testAcc6 :Segment present for '1000' & CustomCallInterval is present,To Test NextCallListDate functionality.
            8. testAcc7 :Segment present for '1000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
        */
       accList = new List<Account>();
       list<Account> accounts4000SalesArea = new list<Account>();
       list<Account> accounts1000SalesArea = new list<Account>();

        Account testAcc0 = UTIL_TestFactory.createAccount();
        testAcc0.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc0.PDK_LO_custom_call_interval__c = 2;
        testAcc0.PDK_LO_Top_Segment__c = 'KA';
        testAcc0.PDK_LO_Sub_Segment__c = '1A';
        accounts4000SalesArea.add(testAcc0);
        
        Account testAcc1 = UTIL_TestFactory.createAccount();
        testAcc1.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc1.PDK_LO_Top_Segment__c = 'KA';
        testAcc1.PDK_LO_Sub_Segment__c = '1A';
        accounts4000SalesArea.add(testAcc1);
        
        Account testAcc2 = UTIL_TestFactory.createAccount();
        testAcc2.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc2.PDK_LO_custom_call_interval__c = 3;
        testAcc2.PDK_LO_Top_Segment__c = '';
        testAcc2.PDK_LO_Sub_Segment__c = '';
        accounts4000SalesArea.add(testAcc2);
        
        Account testAcc3 = UTIL_TestFactory.createAccount();
        testAcc3.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc3.PDK_LO_Top_Segment__c = '';
        testAcc3.PDK_LO_Sub_Segment__c = '';
        accounts4000SalesArea.add(testAcc3);
        
        Account testAcc4 = UTIL_TestFactory.createAccount();
        testAcc4.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc4.PDK_BE_custom_call_interval__c = 7;
        testAcc4.PDK_BE_Top_Segment__c = 'KA';
        testAcc4.PDK_BE_Sub_Segment__c = '1A';
        accounts1000SalesArea.add(testAcc4);
        
        Account testAcc5 = UTIL_TestFactory.createAccount();
        testAcc5.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc5.PDK_LO_Top_Segment__c = 'KA';
        testAcc5.PDK_LO_Sub_Segment__c = '1A';
        accounts4000SalesArea.add(testAcc5);
        
        Account testAcc6 = UTIL_TestFactory.createAccount();
        testAcc6.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc6.PDK_BE_custom_call_interval__c = 365;
        testAcc6.PDK_BE_Top_Segment__c = 'KA';
        testAcc6.PDK_BE_Sub_Segment__c = '1A';
        accounts1000SalesArea.add(testAcc6);
        
        Account testAcc7 = UTIL_TestFactory.createAccount();
        testAcc7.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        testAcc7.PDK_BE_Top_Segment__c = 'KA';
        testAcc7.PDK_BE_Sub_Segment__c = '1A';
        accounts1000SalesArea.add(testAcc7);
        
        // Inserting accounts with users that doesn't match the sales area being worked on
        // To prevent the segment fields from being overwritten
         system.runAs(userLst[0]){
          insert accounts1000SalesArea;       
         }
         system.runAs(userLst[1]){
          insert accounts4000SalesArea;       
         }
    // Merges the 2 account lists into 1, ensuring the ordering fits for the tests even after the update
    accList.add(accounts4000SalesArea[0]);
    accList.add(accounts4000SalesArea[1]);
    accList.add(accounts4000SalesArea[2]);
    accList.add(accounts4000SalesArea[3]);
    accList.add(accounts1000SalesArea[0]);
    accList.add(accounts4000SalesArea[4]);
    accList.add(accounts1000SalesArea[1]);
    accList.add(accounts1000SalesArea[2]);
                
        //Create Contacts
        for(integer i=0; i<8 ;i++){
            Contact c = UTIL_TestFactory.createContact();
            c.LastName = 'NOW '+i + String.valueOf(System.now());
            c.FirstName = 'NOW '+i + String.valueOf(System.now());
            c.AccountId = accList[i].Id;
            contactList.add(c);
        }
        insert contactList;
        
        //Creating Task.
        /*
            1. taskCompleted_4000List[0] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAcc0.
            2. taskCompleted_4000List[1] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAc1.
            3. taskCompleted_4000List[2] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAc2.
            4. taskCompleted_4000List[3] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAc3.
            5. taskPostponed_4000List[0] :Activity_Type_std__c ='Postponed',SalesArea:4000 associate  to testAcc0.
            6. taskNotReached_4000List[0] :Activity_Type_std__c ='Not reached',SalesArea:4000 associated to testAc4.
            7. taskNotReached_4000List[1] :Activity_Type_std__c ='Not reached',SalesArea:4000 associated to testAc5.
            8. taskCompletedDate_4000List[0] :Activity_Type_std__c ='Telephone Contact',SalesArea:4000 associated to testAc5.
            9. taskCompleted_1000List[0] :Activity_Type_std__c ='Completed',SalesArea:1000 associated to testAcc6.
            10.taskCompleted_1000List[0] :Activity_Type_std__c ='Completed',SalesArea:1000 associated to testAcc7.
        */
        /*  1. testAcc0 :Segement present for '4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
            2. testAcc1 :Segment present for '4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
            3. testAcc2 :Segement not present for SalesArea:'4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
            4. testAcc3 :Segement not present for SalesArea:'4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
            5. testAcc4 :Segement present for '1000' & CustomCallInterval is present,To Test notReachedCounter functionality.
            6. testAcc5 :Segment present for '4000' & CustomCallInterval is not present,To Test notReachedCounter functionality.
            7. testAcc6 :Segment present for '1000' & CustomCallInterval is present,To Test NextCallListDate functionality.
            10.testAcc7 :Segment present for '1000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
        */
        taskCompleted_4000List = new List<Task>();
        taskPostponed_4000List = new List<Task>();
        taskNotReached_4000List = new List<Task>();
        taskNotReached_1000List = new List<Task>();
        taskCompletedDate_4000List = new List<Task>();
        taskCompleted_1000List = new List<Task>();
        
        for(integer i = 0; i<3 ; i++){
            Task tsk0 = UTIL_TestFactory.createTask();
            tsk0.Category__c = 'Telesales task';
            tsk0.Activity_Type_std__c ='Completed';
            tsk0.Status ='Completed';
            tsk0.WhoId = contactList[i].Id;
            taskCompleted_4000List.add(tsk0);
        }
        
        Task tsk1 = UTIL_TestFactory.createTask();
        system.debug('+++tsk1+++'+tsk1);
        tsk1.Category__c = 'Telesales task';
        tsk1.Activity_Type_std__c ='Completed';
        tsk1.Status ='Completed';
        tsk1.WhoId = contactList[3].Id;
        taskCompleted_4000List.add(tsk1);
        
        Task tsk2 = UTIL_TestFactory.createTask();
        tsk2.Category__c = 'Telesales task';
        tsk2.Activity_Type_std__c ='Postponed';
        tsk2.ActivityDate = system.today() - 2;
        tsk2.Status ='Completed';
        tsk2.WhoId = contactList[0].Id;
        taskPostponed_4000List.add(tsk2);
        
        Task tsk3 = UTIL_TestFactory.createTask();
        tsk3.Category__c = 'Telesales task';
        tsk3.Activity_Type_std__c ='Not reached';
        tsk3.Status ='Completed';
        tsk3.WhoId = contactList[4].Id;
        taskNotReached_1000List.add(tsk3);
        
        Task tsk4 = UTIL_TestFactory.createTask();
        tsk4.Category__c = 'Telesales task';
        tsk4.Activity_Type_std__c ='Not reached';
        tsk4.Status ='Completed';
        tsk4.WhoId = contactList[5].Id;
        taskNotReached_4000List.add(tsk4);
        
        Task tsk5 = UTIL_TestFactory.createTask();
        tsk5.Category__c = 'Telesales task';
        tsk5.Activity_Type_std__c ='Telephone Contact';
        tsk5.Status ='Completed';
        tsk5.WhoId = contactList[5].Id;
        taskCompletedDate_4000List.add(tsk5);
        
        Task tsk6 = UTIL_TestFactory.createTask();
        tsk6.Category__c = 'Telesales task';
        tsk6.Activity_Type_std__c ='Completed';
        tsk6.Status ='Completed';
        tsk6.WhoId = contactList[6].Id;
        taskCompleted_1000List.add(tsk6);
        
        Task tsk7 = UTIL_TestFactory.createTask();
        tsk7.Category__c = 'Telesales task';
        tsk7.Activity_Type_std__c ='Completed';
        tsk7.Status ='Completed';
        tsk7.WhoId = contactList[7].Id;
        taskCompleted_1000List.add(tsk7);
    }
}