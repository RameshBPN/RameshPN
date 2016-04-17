/**
    About
    -----
    Description: This class is used to test G2O_Case_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of G2O_Case_SVC class.
    1. Test setCaseProductArticleBeforeUpdate functionality.
    2. Test createCaseProductAfterInsert functionality.
    3. Test CreateCaseProductAfterUpdate functionality.
    4. Test structured Communication ManageFunctionalInboxes functionality.
    5. Test updateCreditLimit functionality of G2O_Case_SVC.
  6. Test for manageFunctionalInboxes functionality on Account Trigger,On Account updates.
  7. Test the setNextCallListDate functionality for 4000 SalesArea.
  8. Test the setNotReachedCounter functionality for 4000 SalesArea.
  9. Test the setCompletedDate functionality for 4000 SalesArea for Events.
  10. Test updating of the Account relation fields on the Case

    Update History
    --------------
    Created April 2013 - A.B.
    Updated Aug 2013 A.B.
    Updated April 2014 - T.R.
    March 2016
    1) Since SalesArea 4000 is removed for DK users - Excluded the test cases 7
    2) Updated the Test case 8 to support for Sales Area 1000 
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Case_SVC_TEST {
    
    //A.T.T.R.I.B.U.T.E.S   
    static List<Case> caseLst =new List<Case>();                                                            //Holds case records of recordType Complaint.
    static List<Case> creditCheckCaseLst =new List<Case>();                                                         //Holds case records of recordType Complaint.
    static List<Customer_Service_Product__c> productArticleLst =new List<Customer_Service_Product__c>();    //Holds customer service product records.
    static List<Account> accLst =new List<Account>();                   //Holds test account records.
    static List<Contact> conLst =new List<Contact>();                   //Holds test contact records.
    static List<Credit_Information__c> creditInfoLst = new List<Credit_Information__c>();
    static set<Id> caseIdSet =new Set<Id>();
    static Account acc;
    
    static List<User> userLst;
  static List<Task> taskCompleted_4000List;
  static List<Task> taskPostponed_4000List;
  static List<Task> taskNotReached_4000List;
  static List<Task> taskNotReached_1000List;
  static List<Task> taskCompletedDate_4000List;
  static List<Task> taskCompleted_1000List;
  static List<Event> eventList;
    
    static User sysAdmin;
    static User sysAdmin0;
    static User sysAdmin1;
    //A.T.T.R.I.B.U.T.E.S
      
    //1. Test setCaseProductArticleAfterUpdate functionality.
    static testMethod void setCaseProductArticleAfterUpdate(){
        
        // Arrange
        createTestData();
        List<Case> assertLst = new List<Case>();
        
        // Act
        Test.startTest();
        
        for(integer i=0;i<100;i++){
            caseLst[i].Product_Article__c = productArticleLst[1].Id;            //Updating the  product article.
        }
        for(integer i=100;i<150;i++){
            caseLst[i].Product_Article__c = productArticleLst[0].Id;        
        }
        
        G2O_Case_SVC.setArticle=false;
        assertLst.add(caseLst[0]);
        assertLst.add(caseLst[5]);
        
        system.runAs(sysAdmin){
            update assertLst;
        }
        system.debug('+++assertLst++'+assertLst);
        
        Test.stopTest();
        
        //Assert
        caseIdSet.add(assertLst[0].Id);
        caseIdSet.add(assertLst[1].Id);
        
        List<CaseProduct__c> caseProLst =[Select c.IsPrimary__c,c.Customer_Service_Product__c, c.Case__c From CaseProduct__c c where c.Case__c IN:caseIdSet AND c.IsPrimary__c=true];
        
        System.assertEquals(assertLst[0].Product_Article__c,caseProLst[0].Customer_Service_Product__c);         
        System.assertEquals(assertLst[1].Product_Article__c,caseProLst[1].Customer_Service_Product__c);         
    }
    
    //2. Test createCaseProductAfterInsert functionality.
    static testMethod void createCaseProductAfterInsert(){
        // Arrange
        createTestData();
        
        //Assert
        List<CaseProduct__c> cpLst=[Select Id From CaseProduct__c c where c.Case__c =:caseLst[0].Id];
        System.assertEquals(1,cpLst.size());
    }
    
    //3. Test CreateCaseProductAfterUpdate functionality.
    static testMethod void createCaseProductAfterUpdate(){
        
        // Arrange
        createTestData();
        
        //Act
        system.runAs(sysAdmin){
            caseLst[150].Item_Id__c='2010';
            G2O_Case_SVC.createCP=false;
            
            update caseLst;
        }
        
        //Assert
        List<CaseProduct__c> cpLst=[Select Id From CaseProduct__c c where c.Case__c =:caseLst[150].Id];
        System.assertEquals(1,cpLst.size());
    }
    
    //4. Test structured Communication ManageFunctionalInboxes functionality.
    static testMethod void manageFuncInbxTestCase1(){
        
        // Arrange
        CreateTestData_FunctionalInbox();
        
        System.assertEquals(null,[Select ContactId from Case where Id=:caseLst[0].Id].ContactId);
        System.assertEquals(0,[Select count() from Contact where AccountId=:caseLst[0].Respondent_Org_ID__c]);
        
        Test.startTest();
        //Act
        for (Integer i = 1; i < caseLst.size(); i++) {
            caseLst[i].Respondent_Org_ID__c = accLst[i].Id;     //Updating the respondent OrgId.
        }
        update caseLst;
        Test.stopTest();
        
        //Assert
        System.assertEquals([Select Id from Contact where AccountId=:accLst[1].Id].Id,[Select ContactId from Case where Id=:caseLst[1].Id].ContactId);
        System.assertEquals(1,[Select count() from Contact where AccountId=:caseLst[1].Respondent_Org_ID__c]);
        //Assert for condition when contact already exist for a Respondent_Org_ID,New contact must not be created.
        System.assertEquals(1,[Select count() from Contact where Is_Org_Unit_Contact__c =true AND AccountId=:caseLst[9].Respondent_Org_ID__c]);
        caseLst.clear();
    } 
    
    //5.Test updateCreditLimit functionality of G2O_Case_SVC. 
    static testMethod void updateCreditLimit_TEST(){
        
        //Arrange
        createCreditLimitTestdata();
        List<Case> caseListSalesArea1000 = new List<Case>();
        List<Case> caseListSalesAreaKR01 = new List<Case>();
        
        //Act
        Test.startTest();
        
        for(integer i = 0; i<creditCheckCaseLst.size(); i++){
            
            if(i < 50){
                
                caseListSalesArea1000.add(creditCheckCaseLst[i]);
            }else {

                caseListSalesAreaKR01.add(creditCheckCaseLst[i]);
            }
            
        }
        
        system.runAs(sysAdmin0){
            insert caseListSalesArea1000;
        }
        
        system.runAs(sysAdmin1){
            insert caseListSalesAreaKR01;
        }
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(99,[Select c.Id,c.Existing_Credit_Limit__c From Case c Where c.Id =:caseListSalesArea1000[0].Id limit 1].Existing_Credit_Limit__c);
        System.assertEquals(99,[Select c.Id,c.Existing_Credit_Limit__c From Case c Where c.Id =:caseListSalesArea1000[1].Id limit 1].Existing_Credit_Limit__c);
        
        System.assertEquals(500,[Select c.Id,c.Existing_Credit_Limit__c From Case c Where c.Id =:caseListSalesAreaKR01[0].Id limit 1].Existing_Credit_Limit__c);
        System.assertEquals(500,[Select c.Id,c.Existing_Credit_Limit__c From Case c Where c.Id =:caseListSalesAreaKR01[1].Id limit 1].Existing_Credit_Limit__c);
    }

    //6. Test for manageFunctionalInboxes functionality on Account Trigger,On Account updates.
    static testMethod void updateAccountTest(){
        
        //Creating Custom Setting.
        UTIL_TestFactory.setUpOrg();
        
        //Arrange
        Id rTypeIdPNContact = UTIL_Meta.getContactPostNordEmployeeRT();
        Id rTypeIdPNAcc = UTIL_Meta.getAccountPostNordOrgStructureRT();
        
        //Creating Accounts
        Account testAcc1 = UTIL_TestFactory.createAccount();
        testAcc1.RecordTypeId = rTypeIdPNAcc;
        testAcc1.Functional_Inbox_Email__c = 'funInbox@cg.com';
        insert testAcc1;
        
        //Creating Contacts
        Contact testCon1 = UTIL_TestFactory.createContact();
        testCon1.RecordTypeId = rTypeIdPNContact;
        testCon1.LastName = 'NOW ' + String.valueOf(System.now());
        testCon1.Is_Org_Unit_Contact__c =true;
        testCon1.AccountId = testAcc1.Id;
        insert testCon1;
        
        Test.startTest();
        //Act
        testAcc1.Functional_Inbox_Email__c = 'inboxno@cg.com';
        update testAcc1;
        Test.stopTest();
        
        system.debug('++23++'+testAcc1.Functional_Inbox_Email__c);
        //Assert
        System.assertEquals(testAcc1.Functional_Inbox_Email__c, [Select c.Id,c.RecordTypeId, c.Is_Org_Unit_Contact__c, c.Email From Contact c Where c.AccountId =:testAcc1.Id 
                                    AND c.Is_Org_Unit_Contact__c = true AND c.RecordTypeId=:rTypeIdPNContact].Email);
    
    }
/*
    //7. Test the setNextCallListDate functionality for 4000 SalesArea.
  static testMethod void setNextCallListDate_Test(){
    
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
    
  }
*/  
  //8. Test the setNotReachedCounter functionality for 4000 SalesArea.
  static testMethod void setNotReachedCounter(){
    
    //Arrange
    createTaskTestData();
    
    //Act
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

    //Segment present for '4000' & CustomCallInterval is not present,To Test notReachedCounter functionality.
    System.assertEquals(callListDate +365/7,tskList[0].Account.Next_Call_List_Date_PDK_BE__c);
    System.assertEquals(0,tskList[0].Account.Not_reached_counter_PDK_BE__c);
  }
  
  // 9. Test the setCompletedDate functionality for 4000 SalesArea for Events.
  static testMethod void setCompletedDateEventTest(){
    
    //Arrange
    createEventTestData();
    
    //Act
    System.runas(userLst[0]){
        eventList[0].StartDateTime = DateTime.now().addDays(-1);
        eventList[0].ActivityDateTime = eventList[0].StartDateTime;
        eventList[0].DurationInMinutes = 5;
        insert eventList;
    
        List<Id> eventIdList = new List<Id>();
        for(Event events:eventList){
          eventIdList.add(events.Id);
        }
        
        List<Event> eList = [Select e.Id,e.Account.ActivityCompletedDate__c From Event e where e.Id IN:eventIdList];
        //Assert
        System.assertEquals(Date.today().addDays(-1),eList[0].Account.ActivityCompletedDate__c);
        //System.assertEquals(system.today(),eList[1].Account.ActivityCompletedDate__c);
      }
  }        
  
  // 10. Test updating of the Account relation fields on the Case
  static testMethod void testUpdateCountryField(){
        UTIL_TestFactory.setUpOrg();
        acc = UTIL_TestFactory.createAccount();
        acc.Postal_Address_Country__c = 'BR';
        acc.Registration_Country__c = 'BR';
        insert acc;

        Account acc2 = UTIL_TestFactory.createAccount();
        acc2.Postal_Address_Country__c = 'GB';
        acc2.Registration_Country__c = 'GB';
        insert acc2;
                
        list<Case> caseList = new list<Case>();
        Case tmpCase;
    tmpCase = UTIL_TestFactory.createCase();
      tmpCase.Postal_Address_Country__c = null;
      tmpCase.Accountid = acc.id;
      caseList.add(tmpCase);
    
    tmpCase = UTIL_TestFactory.createCase();
      tmpCase.Comp_Receiver_Country__c  = null;
      tmpCase.Compensation_Receiver__c = acc.id;
      caseList.add(tmpCase);
      
    tmpCase = UTIL_TestFactory.createCase();
      tmpCase.Receiver_Postal_Address_Country__c  = null;
      tmpCase.Receiver__c = acc.id;
      caseList.add(tmpCase);
    
    tmpCase = UTIL_TestFactory.createCase();
      tmpCase.Regress_Partner_Country__c   = null;
      tmpCase.Regress_Partner__c  = acc.id;
      caseList.add(tmpCase);
    
    tmpCase = UTIL_TestFactory.createCase();
      tmpCase.Sender_Postal_Address_Country__c   = null;
      tmpCase.Sender__c  = acc.id;
      caseList.add(tmpCase); 
      
      insert caseList;
      caseList = [select id, Postal_Address_Country__c, Comp_Receiver_Country__c, Receiver_Postal_Address_Country__c, Regress_Partner_Country__c, Sender_Postal_Address_Country__c From Case];
      
      test.StartTest();
      system.assertEquals(5, caseList.size());
      system.assertEquals(null, caseList[1].Postal_Address_Country__c, caseList[1]);
      system.assertEquals('BR', caseList[1].Comp_Receiver_Country__c, caseList);
      system.assertEquals(null, caseList[1].Receiver_Postal_Address_Country__c, caseList[1]);
      system.assertEquals(null, caseList[1].Regress_Partner_Country__c, caseList[1]);
      system.assertEquals(null, caseList[1].Sender_Postal_Address_Country__c, caseList[1]);

      system.assertEquals(null, caseList[2].Postal_Address_Country__c, caseList[2]);
      system.assertEquals(null, caseList[2].Comp_Receiver_Country__c, caseList[2]);
      system.assertEquals('BR', caseList[2].Receiver_Postal_Address_Country__c, caseList[2]);
      system.assertEquals(null, caseList[2].Regress_Partner_Country__c, caseList[2]);
      system.assertEquals(null, caseList[2].Sender_Postal_Address_Country__c, caseList[2]);

      system.assertEquals(null, caseList[3].Postal_Address_Country__c, caseList[3]);
      system.assertEquals(null, caseList[3].Comp_Receiver_Country__c, caseList[3]);
      system.assertEquals(null, caseList[3].Receiver_Postal_Address_Country__c, caseList[3]);
      system.assertEquals('BR', caseList[3].Regress_Partner_Country__c, caseList[3]);
      system.assertEquals(null, caseList[3].Sender_Postal_Address_Country__c, caseList[3]);

      system.assertEquals(null, caseList[4].Postal_Address_Country__c, caseList[4]);
      system.assertEquals(null, caseList[4].Comp_Receiver_Country__c, caseList[4]);
      system.assertEquals(null, caseList[4].Receiver_Postal_Address_Country__c, caseList[4]);
      system.assertEquals(null, caseList[4].Regress_Partner_Country__c, caseList[4]);
      system.assertEquals('BR', caseList[4].Sender_Postal_Address_Country__c, caseList[4]);
      
    system.assertEquals('BR', caseList[0].Postal_Address_Country__c, caseList);
      system.assertEquals(null, caseList[0].Comp_Receiver_Country__c, caseList[0]);
      system.assertEquals(null, caseList[0].Receiver_Postal_Address_Country__c, caseList[0]);
      system.assertEquals(null, caseList[0].Regress_Partner_Country__c, caseList[0]);
      system.assertEquals(null, caseList[0].Sender_Postal_Address_Country__c, caseList[0]);

    caseList[0].Postal_Address_Country__c = 'SE';
    update caseList[0];
      caseList = [select id, Postal_Address_Country__c, Comp_Receiver_Country__c, Receiver_Postal_Address_Country__c, Regress_Partner_Country__c, Sender_Postal_Address_Country__c From Case];

      system.assertEquals('SE', caseList[0].Postal_Address_Country__c);
      system.assertEquals(null, caseList[0].Comp_Receiver_Country__c);
      system.assertEquals(null, caseList[0].Receiver_Postal_Address_Country__c);
      system.assertEquals(null, caseList[0].Regress_Partner_Country__c);
      system.assertEquals(null, caseList[0].Sender_Postal_Address_Country__c);  
      
      caseList[0].Accountid = acc2.id;
      update caseList[0];  
    test.stopTest();

      caseList = [select id, Postal_Address_Country__c, Comp_Receiver_Country__c, Receiver_Postal_Address_Country__c, Regress_Partner_Country__c, Sender_Postal_Address_Country__c From Case];
      system.assertEquals('GB', caseList[0].Postal_Address_Country__c, caseList[0]);
      system.assertEquals(null, caseList[0].Comp_Receiver_Country__c);
      system.assertEquals(null, caseList[0].Receiver_Postal_Address_Country__c);
      system.assertEquals(null, caseList[0].Regress_Partner_Country__c);
      system.assertEquals(null, caseList[0].Sender_Postal_Address_Country__c);  

  }

    //Creating Test Data.
    static void createCreditLimitTestdata(){        
        List<Account> accLst1000 = new List<Account>();
        List<Account> accLstKR01 = new List<Account>();
        List<Case> caseLst1000 = new List<Case>();
        List<Case> caseLstKR01 = new List<Case>();
        
        //Creating custom setting.
        UTIL_TestFactory.setUpOrg();
        
        //Creating a Sys Admin with a Sales Area Defined
        sysAdmin0 = UTIL_TestFactory.createAdmin('testCaseSysAdm11@mail.com');
        sysAdmin0.Sales_Area1__c = '1000';
        insert sysAdmin0;
        
        //'F091
        sysAdmin1 = UTIL_TestFactory.createAdmin('testCaseSysAdm22@mail.com');
        sysAdmin1.Sales_Area1__c = '4000';
        insert sysAdmin1;
        
        //Creating Account.
        for (Integer i = 0; i < 50; i++) {
            accLst1000.add(UTIL_TestFactory.createAccount());
        }
        
        for (Integer i = 0; i < 50; i++) {
            accLstKR01.add(UTIL_TestFactory.createAccount());
        }
        
        
        system.runAs(sysAdmin1){
            insert accLst1000;
            insert accLstKR01;
        }
        
        system.debug('++++accLst1000+++'+accLst1000);
        system.debug('++++accLstKR01+++'+accLstKR01);
        
        //Creating Credit_Information__c for SalesArea 1000.
        
        for(integer i = 0; i< accLst1000.size();i++){
        
            Credit_Information__c creditInfo1000 = new Credit_Information__c();
            creditInfo1000.Account__c =  accLst1000[i].Id;
            creditInfo1000.Credit_Control_Area__c = '1000';
            creditInfo1000.Credit_Limit__c = 99;
            creditInfoLst.add(creditInfo1000);
        }
        
        //Creating Credit_Information__c for SalesArea KR01.
        
        for(integer i = 0; i< accLstKR01.size();i++){
            
            Credit_Information__c creditInfoKR01 = new Credit_Information__c();
            system.debug('+++accLstKR01[i].Id+++'+accLstKR01[i].Id);
            creditInfoKR01.Account__c =  accLstKR01[i].Id;
            creditInfoKR01.Credit_Control_Area__c = 'KR01';
            creditInfoKR01.Credit_Limit__c = 500;
            creditInfoLst.add(creditInfoKR01);
            
        }
        insert  creditInfoLst;  
        
        system.debug('++++creditInfoLst+++'+creditInfoLst);
        
        //Creating Case.
        
        //caseLst = UTIL_TestFactory.createCases();
        for (Integer i = 0; i < 50; i++) {
            Case cas =new Case();
            caseLst1000.add(cas);
        }
        
        for (Integer i = 0; i < 50; i++) {
            Case cas =new Case();
            caseLstKR01.add(cas);
        }
        
        for(integer i = 0; i< accLst1000.size();i++){
            
            caseLst1000[i].RecordTypeId = UTIL_Meta.getcaseCreditCheckRT();
            caseLst1000[i].Requested_credit_limit__c = 1;
            caseLst1000[i].AccountId = accLst1000[i].Id;
            caseLst1000[i].Credit_control_area__c = '1000';
            system.debug('+++caseLst100033++'+caseLst1000[i]);
            caseLst1000[i].Credit_check_requested_by__c = sysAdmin0.Id;
            creditCheckCaseLst.add(caseLst1000[i]);
        }
        
        for(integer i = 0; i< accLstKR01.size();i++){
            
            caseLstKR01[i].RecordTypeId = UTIL_Meta.getcaseCreditCheckRT();
            caseLstKR01[i].Requested_credit_limit__c = 1;
            caseLstKR01[i].AccountId = accLstKR01[i].Id;
      caseLstKR01[i].Credit_control_area__c = 'KR01';
            system.debug('+++caseLstKR0122++'+caseLstKR01[i]);
            caseLstKR01[i].Credit_check_requested_by__c = sysAdmin1.Id;
            creditCheckCaseLst.add(caseLstKR01[i]);
        }
    }
    
    //Creating test data.
    static void createTestData() {
        
        UTIL_TestFactory.setUpOrg();
        
        sysAdmin = UTIL_TestFactory.createAdmin('testCaseSysAdm@mail.com');
        sysAdmin.Sales_Area1__c = '1000';
        insert sysAdmin;
        
        //Getting the Developer Name from Custom Setting.
        String developerName = UTIL_OrgSettings.CaseRecordTypes();
        
        //Getting the recordTypeId.
        Id rTypeId=[Select r.Name, r.Id, r.DeveloperName From RecordType r where r.DeveloperName=:developerName Limit 1].Id;
        system.debug('++rTypeId+++'+rTypeId);
        
        system.debug('++++CurrentUserSales_Area__c+++'+Userinfo.getUserId());

        //Creating Customer Service Product
        productArticleLst=UTIL_TestFactory.createProductArticle();
        for(integer i=0;i<productArticleLst.size();i++){
            productArticleLst[i].Sales_Area__c = 'PDK BE';
            productArticleLst[i].Active__c = true;
            productArticleLst[i].Product_Type__c = 'Product Group';
        }
        
        //Creating Cases
        caseLst=UTIL_TestFactory.createCases();
        
        system.runAs(sysAdmin){
            insert productArticleLst;
        }
        
        system.debug('+++productArticleLst22++'+productArticleLst);
        
        for (Integer i = 0; i < 199; i++) {
            
            caseLst[i].Status='For Approval';
            caseLst[i].Priority='Medium';
            caseLst[i].Origin='Telefon';
            caseLst[i].RecordTypeId=rTypeId;
            
            if(i<100){                              // Assigning testUser0 from Index:0 to 100 & Product_Article__c is Index:0 of productArticleLst.
                //caseLst[i].OwnerId=userLst[0].Id; 
                caseLst[i].Product_Article__c=productArticleLst[0].Id;
            }else if(i<150){                        // Assigning queue from Index: 100 to 150 & Product_Article__c is Index:1 of productArticleLst.
                //caseLst[i].OwnerId=queue.QueueId; 
                caseLst[i].Product_Article__c=productArticleLst[1].Id;
            }
            // Case from Index: 150 to 180 with no ItemId & no Product_Article__c.
        }
        
        system.runAs(sysAdmin){
            insert caseLst; 
        }
        system.debug('+++caseLstwe++'+caseLst);     
    }
    
    
    //Creating test data for .
    static void CreateTestData_FunctionalInbox() {
        
        UTIL_TestFactory.setUpOrg();
        
        //Getting the recordTypeId for case.
        Id rTypeIdCase = UTIL_Meta.getcaseReturpostRT();
        
        //Getting the recordTypeId for account.
        Id rTypeIdPNAcc = UTIL_Meta.getAccountPostNordOrgStructureRT();
        
        Id rTypeIdWSAcc = UTIL_Meta.getAccountWorkSiteRT();
        
        Id rTypeIdPNContact = UTIL_Meta.getContactPostNordEmployeeRT();
        
        //Creating Acounts.
        accLst = UTIL_TestFactory.createAccounts();
        for (Integer i = 0; i < accLst.size(); i++) {
            
            if(i==0){
                accLst[i].RecordTypeId =rTypeIdWSAcc;       //Account of 'Work_Site' record Type.
            }else{
                accLst[i].RecordTypeId =rTypeIdPNAcc;       //Account of 'PostNord_Org_Structure' record Type.  
            }
        }
        insert accLst;
        
        //Creating Cases.
        caseLst=UTIL_TestFactory.createCases();
        for (Integer i = 0; i < caseLst.size(); i++) {
            
            caseLst[i].Status ='For Approval';
            caseLst[i].Priority ='Medium';
            caseLst[i].Origin ='Telefon';
            caseLst[i].RecordTypeId =rTypeIdCase;
            caseLst[i].AccountId =accLst[0].Id;
        }
        insert caseLst; 
        
        //Creating Contact & associating them with Accounts at index 198.l
        conLst= UTIL_TestFactory.createContacts();
        for (Integer i = 0; i < conLst.size(); i++) {
            
            conLst[i].LastName = 'NOW ' + String.valueOf(System.now());
            conLst[i].RecordTypeId= rTypeIdPNContact;
            conLst[i].AccountId =accLst[198].Id;
            
            if(i==0){
                conLst[i].Is_Org_Unit_Contact__c =true;
            }
        }
        insert conLst;
    }
  
  //Create Test Data for Task.
  static void createEventTestData(){
    
    //Creating Users.
    userLst =new List<User>();
    
    User usr0 = UTIL_TestFactory.createUser('testUser1@cg.com','CS Standard User');
    usr0.Sales_Area1__c = '1000';
    userLst.add(usr0);
    
    User usr1 = UTIL_TestFactory.createUser('testUser2@cg.com','CS Standard User');
    usr1.Sales_Area1__c = '1000';
    userLst.add(usr1);
    
    accLst = UTIL_TestFactory.createAccounts();
    insert accLst;
    
    conLst =UTIL_TestFactory.createContacts();

    for(integer i =0;i<conLst.size();i++){
      conLst[i].AccountId = accLst[i].Id;
    }
    insert conLst;
    
    system.debug('+++conLst+11++'+conLst[0].AccountId);
    eventList = UTIL_TestFactory.createEvents();
    
    for(integer i=0; i<eventList.size();i++){
      eventList[i].Activity_Type_std__c ='Physical Meeting';
      eventList[i].Status__c='Completed';
      eventList[i].Activity_Sub_Type__c ='Close Deal';
      eventList[i].WhoId = conLst[i].Id;
    }
  }
  
  //Create Test Data for Task.
  static void createTaskTestData(){
    
    UTIL_TestFactory.setUpOrg();
    
    //Creating Users.
    userLst =new List<User>();
    conLst = new List <Contact>();
    
    User usr0 = UTIL_TestFactory.createUser('testUser1@cg.com','CS Standard User');
    usr0.Sales_Area1__c = '4000';
    userLst.add(usr0);
    
    User usr1 = UTIL_TestFactory.createUser('testUser2@cg.com','CS Standard User');
    usr1.Sales_Area1__c = '1000';
    userLst.add(usr1);
    
    insert userLst;
    
    system.debug('+++User1+++'+userLst[0].Sales_Area1__c);
    system.debug('+++User2+++'+userLst[1].Sales_Area1__c);
    
    //Creating Account.
    /*
      1. testAcc0 :Segement present for '4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
      2. testAcc1 :Segment present for '4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
      3. testAcc2 :Segement not present for SalesArea:'4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
      4. testAcc3 :Segement not present for SalesArea:'4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
      5. testAcc4 :Segement present for '1000' & CustomCallInterval is present,To Test notReachedCounter functionality.
      6. testAcc5 :Segment present for '1000' & CustomCallInterval is not present,To Test notReachedCounter functionality.
    */
    accLst = new List<Account>();
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
    //testAcc1.LO_FI_custom_call_interval__c = '';
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
    //testAcc3.LO_FI_custom_call_interval__c = '';
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
    accLst.add(accounts4000SalesArea[0]);
    accLst.add(accounts4000SalesArea[1]);
    accLst.add(accounts4000SalesArea[2]);
    accLst.add(accounts4000SalesArea[3]);
    accLst.add(accounts1000SalesArea[0]);
    accLst.add(accounts4000SalesArea[4]);
    accLst.add(accounts1000SalesArea[1]);
    accLst.add(accounts1000SalesArea[2]);
         
    //Create Contacts
    for(integer i=0; i<8 ;i++){
      
          Contact c = UTIL_TestFactory.createContact();
          c.LastName = 'NOW '+i + String.valueOf(System.now());
           c.FirstName = 'NOW '+i + String.valueOf(System.now());
           c.AccountId = accLst[i].Id;
           conLst.add(c);
    }
    insert conLst;
    
    //Creating Task.
    /*
      1. taskCompleted_4000List[0] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAcc0.
      2. taskCompleted_4000List[1] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAc1.
      3. taskCompleted_4000List[2] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAc2.
      4. taskCompleted_4000List[3] :Activity_Type_std__c ='Completed',SalesArea:4000 associated to testAc3.
      5. taskNotReached_4000List[0] :Activity_Type_std__c ='Not reached',SalesArea:4000 associated to testAc4.
      6. taskNotReached_4000List[1] :Activity_Type_std__c ='Not reached',SalesArea:4000 associated to testAc5.
    */
    /*  1. testAcc0 :Segement present for '4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
      2. testAcc1 :Segment present for '4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
      3. testAcc2 :Segement not present for SalesArea:'4000' & CustomCallInterval is present,To Test NextCallListDate functionality.
      4. testAcc3 :Segement not present for SalesArea:'4000' & CustomCallInterval is not present,To Test NextCallListDate functionality.
      5. testAcc4 :Segement present for '1000' & CustomCallInterval is present,To Test notReachedCounter functionality.
      6. testAcc5 :Segment present for '4000' & CustomCallInterval is not present,To Test notReachedCounter functionality.
    */
    taskCompleted_4000List = new List<Task>();
    taskNotReached_4000List = new List<Task>();
    taskNotReached_1000List = new List<Task>();
    taskCompleted_1000List = new List<Task>();
    taskCompletedDate_4000List = new List<Task>();
    taskPostponed_4000List = new List<Task>();

    for(integer i = 0; i<3 ; i++){
      Task tsk0 = UTIL_TestFactory.createTask();
      tsk0.Category__c = 'Telesales task';
      tsk0.Activity_Type_std__c ='Completed';
      tsk0.Status ='Completed';
      tsk0.WhoId = conLst[i].Id;
      taskCompleted_4000List.add(tsk0);
    }
    
        Task tsk1 = UTIL_TestFactory.createTask();
        system.debug('+++tsk1+++'+tsk1);
        tsk1.Category__c = 'Telesales task';
        tsk1.Activity_Type_std__c ='Completed';
        tsk1.Status ='Completed';
        tsk1.WhoId = conLst[3].Id;
        taskCompleted_4000List.add(tsk1);
        
        Task tsk2 = UTIL_TestFactory.createTask();
        tsk2.Category__c = 'Telesales task';
        tsk2.Activity_Type_std__c ='Postponed';
        tsk2.ActivityDate = system.today() - 2;
        tsk2.Status ='Completed';
        tsk2.WhoId = conLst[0].Id;
        taskPostponed_4000List.add(tsk2);
        
        Task tsk3 = UTIL_TestFactory.createTask();
        tsk3.Category__c = 'Telesales task';
        tsk3.Activity_Type_std__c ='Not reached';
        tsk3.Status ='Completed';
        tsk3.WhoId = conLst[4].Id;
        taskNotReached_1000List.add(tsk3);
        
        Task tsk4 = UTIL_TestFactory.createTask();
        tsk4.Category__c = 'Telesales task';
        tsk4.Activity_Type_std__c ='Not reached';
        tsk4.Status ='Completed';
        tsk4.WhoId = conLst[5].Id;
        taskNotReached_4000List.add(tsk4);
        
        Task tsk5 = UTIL_TestFactory.createTask();
        tsk5.Category__c = 'Telesales task';
        tsk5.Activity_Type_std__c ='Telephone Contact';
        tsk5.Status ='Completed';
        tsk5.WhoId = conLst[5].Id;
        taskCompletedDate_4000List.add(tsk5);
        
        Task tsk6 = UTIL_TestFactory.createTask();
        tsk6.Category__c = 'Telesales task';
        tsk6.Activity_Type_std__c ='Completed';
        tsk6.Status ='Completed';
        tsk6.WhoId = conLst[6].Id;
        taskCompleted_1000List.add(tsk6);
        
        Task tsk7 = UTIL_TestFactory.createTask();
        tsk7.Category__c = 'Telesales task';
        tsk7.Activity_Type_std__c ='Completed';
        tsk7.Status ='Completed';
        tsk7.WhoId = conLst[7].Id;
        taskCompleted_1000List.add(tsk7);
    
  }
}