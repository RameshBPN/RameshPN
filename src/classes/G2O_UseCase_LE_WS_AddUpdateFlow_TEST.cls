/**
    About
    -----
    Description: This class is used to test functionality/flow around LE-WS Address Updates. 
                                            
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Details
    -------
    1. 

    Update History
    --------------
    Created Aug 2013 - A.B.
    
 */
@isTest
private class G2O_UseCase_LE_WS_AddUpdateFlow_TEST {
    
    
    //A.T.T.R.I.B.U.T.E.S
    static Account accountLE0;
    static Account accountLE1;
    static Account accountWS0;      //Related to accountLE0.
    static Account accountWS1;      //Related to accountLE0.
    static Account accountWS2;      //Related to accountLE1.
    static Account accountWS3;      //Related to accountLE1.
    static Account accountWS4;      //WorkSite without a parent LE.
    
    static AccountTeamMember AccountTeamMember0;
    static AccountTeamMember AccountTeamMember1;

    static User salesUser0;         //User with sales area : 1000
    static User salesUser1;         //User with sales area : 1000
    static User salesUser2;         //User with sales area : 4000
    
    static User integrationUser;
    static Sales_Area_Information__c salesAreaInf0;
    static Sales_Area_Information__c salesAreaInf1;
    static Sales_Area_Information__c salesAreaInf2;
    
    static String rTypeWS = UTIL_Meta.getAccountWorkSiteRT();
    static String rTypeLE = UTIL_Meta.getAccountLegalEntityRT();
    static final String salesArea = '0540';//Sales area for testing
    //A.T.T.R.I.B.U.T.E.S
    
    
    /*1.0 Test the below functionality:
        (a)Use Case 1.0: INTEGRATION USER CREATES Account Team Member record on Account of record type Legal Entity.
        (b)Expected Result: APEX trigger creates Account Team Member record (copy of record created on LE) for all child Accounts of 
            Legal Entity that have record type Work Site.
   */ 
    static testMethod void LE_WS_AddUpdateFlow_Test1(){
        
        // Arrange
        createTestData();
        
        //Act
        Test.startTest();
        
        //Integration user creates a Account Team Member record.
        system.runAs(integrationUser){
            
            AccountTeamMember0.AccountId = accountLE0.Id;
            AccountTeamMember0.UserId = salesUser1.Id;
            AccountTeamMember0.TeamMemberRole = 'PDK BE - Customer Responsible';
            insert AccountTeamMember0;
        }
        
        // Run batchjob emulating AccountTeamMember Trigger
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh);

        Test.stopTest();
        
        //Assert
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS0.Id]);
        System.assertEquals(salesUser1.Id,[Select a.UserId, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS0.Id limit 1].UserId);  
        
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS1.Id]);
        System.assertEquals(salesUser1.Id,[Select a.UserId, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS1.Id limit 1].UserId);  
        
    }
    
    
    /* 1.1 Test the below functionality:
         (a)Use Case 1.1: INTEGRATION USER UPDATES Account Team Member record on Account of record type Legal Entity.
         (b)Expected Result: APEX trigger UPDATES Account Team Member record (copy of record created on LE) for all child Accounts of 
            Legal Entity that have record type Work Site.
    */  
    static testMethod void LE_WS_AddUpdateFlow_Test2(){
        
        // Arrange
        createTestData();
        
        //Act
        Test.startTest();
        
        //Integration user creates a Account Team Member record.
        system.runAs(integrationUser){
            
            AccountTeamMember0.AccountId = accountLE0.Id;
            AccountTeamMember0.UserId = salesUser1.Id;
            AccountTeamMember0.TeamMemberRole = 'PostNord Customer Responsible';
            insert AccountTeamMember0;
        }
        
        //From salesUser1 to salesUser0
        AccountTeamMember0.TeamMemberRole = 'PDK BE - Customer Responsible';
        update AccountTeamMember0;

        // Run batchjob emulating AccountTeamMember Trigger
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh); 

        Test.stopTest();
        
        //Assert
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS0.Id]);
        System.assertEquals('PDK BE - Customer Responsible',[Select a.TeamMemberRole, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS0.Id limit 1].TeamMemberRole);    
        
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS1.Id]);
        System.assertEquals('PDK BE - Customer Responsible',[Select a.TeamMemberRole, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS1.Id limit 1].TeamMemberRole);    
        
    }
    
    
    /* 1.2 Test the below functionality:
         (a)Use Case 1.2: SALES USER CREATES Account Team Member record on Account of record type Legal Entity.
         (b)Expected Result: APEX trigger creates Account Team Member record (copy of record created on LE) for all child Accounts of 
            Legal Entity that have record type Work Site.
    */
    static testMethod void LE_WS_AddUpdateFlow_Test3(){
        
        // Arrange
        createTestData();
        
        //Act
        Test.startTest();
        
        //Integration user creates a Account Team Member record.
        system.runAs(salesUser0){
            
            AccountTeamMember0.AccountId = accountLE0.Id;
            AccountTeamMember0.UserId = salesUser1.Id;
            AccountTeamMember0.TeamMemberRole = 'PDK BE - Customer Responsible';
            insert AccountTeamMember0;
        }

        // Run batchjob emulating AccountTeamMember Trigger
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh); 

        Test.stopTest();
        
        //Assert
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS0.Id]);
        System.assertEquals(salesUser1.Id,[Select a.UserId, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS0.Id limit 1].UserId);  
        
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS1.Id]);
        System.assertEquals(salesUser1.Id,[Select a.UserId, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS1.Id limit 1].UserId);  
        
    }
    
    
    /* 1.3 Test the below functionality:
         (a)Use Case 1.3: SALES USER UPDATES Account Team Member record on Account of record type Legal Entity.
         (b)Expected Result: APEX trigger UPDATES Account Team Member record (copy of record created on LE) for all child Accounts of 
            Legal Entity that have record type Work Site.
    */
    static testMethod void LE_WS_AddUpdateFlow_Test4(){
        
        // Arrange
        createTestData();
        
        //Act
        Test.startTest();
        
        //Integration user creates a Account Team Member record.
        system.runAs(salesUser1){
            
            AccountTeamMember0.AccountId = accountLE0.Id;
            AccountTeamMember0.UserId = salesUser1.Id;
            AccountTeamMember0.TeamMemberRole = 'PostNord Customer Responsible';
            insert AccountTeamMember0; 
        }
        
        //Updating TeamMemberRole From salesUser1 to salesUser0
        AccountTeamMember0.TeamMemberRole = 'PDK BE - Customer Responsible';
        update AccountTeamMember0;

        // Run batchjob emulating AccountTeamMember Trigger
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh); 
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS0.Id]);
        System.assertEquals('PDK BE - Customer Responsible',[Select a.TeamMemberRole, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS0.Id limit 1].TeamMemberRole);    
        
        System.assertEquals(1,[Select count() From AccountTeamMember a Where a.AccountId =:accountWS1.Id]);
        System.assertEquals('PDK BE - Customer Responsible',[Select a.TeamMemberRole, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId =:accountWS1.Id limit 1].TeamMemberRole);    
        
    }


    /* 2.0 Test the below functionality:
      (a)Use Case 2.0: INTEGRATION USER adds new SAI(Sales Area Information) record to Account of record type Legal Entity.
      (b)Expected Result: APEX trigger creates new SAI record (copy of record created on LE) for all child Accounts of Legal 
         Entity that have record type Work Site provided that a SAI record containing a matching Sales_Area__c doesn’t not 
         already exist for the Work Site.
    */
    static testMethod void LE_WS_AddUpdateFlow_Test5(){
        
        //Arrange
        createTestData();
        
        //Act
        //Integration user creates a Sales Area Information.
        //This Sales Area does't exist for the worksite:accountWS0.
        //This Sales Area Exist for the worksite:accountWS2.
        test.startTest();       
        system.runAs(integrationUser){
                       
            //Creating Sales Area for the worksite:accountWS2.
            salesAreaInf0.Account__c = accountWS2.Id;
            salesAreaInf0.Sales_Area__c = '1000';
            insert salesAreaInf0;
            
            Sales_Area_Information__c salesAreaInf1000ForLE1 = [Select Id,Account__c,Sales_Area__c From Sales_Area_Information__c a Where a.Account__c =:accountLE1.Id AND a.Sales_Area__c = '1000'];
            delete salesAreaInf1000ForLE1;
            
            //Sales Area '1000' is created on LE as Sales Area are copied from WS to Related LE.
            //Now deleting the Sales Area '1000' from LE & Creating Sales Area for the LE1,this should not be copied to WS2 
            //as it already have SAI of same salesArea but should be copied to WS3..
            
            G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS = false;
            salesAreaInf1.Account__c = accountLE1.Id;
            salesAreaInf1.Sales_Area__c = '1000';
            insert salesAreaInf1;
           
            G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS = false;
            //Creating Sales Area for the LE0,this should be copied to WS0 & WS1 as this Sales Area doesn't Exist for the worksite: accountWS0 & accountWS1.
            salesAreaInf2.Account__c = accountLE0.Id;
            salesAreaInf2.Sales_Area__c = '1000';
            insert salesAreaInf2;
            
        }
        test.stopTest();
        
        //Assert       
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS0.Id]);
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS1.Id]);
        
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS2.Id]);
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS3.Id]);
        
    }
    
    
    /* 2.1 Test the below functionality:
      (a)Use Case 2.1: SALE USER adds new SAI(Sales Area Information) record to Account of record type Legal Entity.
      (b)Expected Result: APEX trigger creates new SAI record (copy of record created on LE) for all child Accounts of Legal 
         Entity that have record type Work Site provided that a SAI record containing a matching Sales_Area__c doesn’t not 
         already exist for the Work Site.
    */
    static testMethod void LE_WS_AddUpdateFlow_Test6(){
        
        //Arrange
        createTestData();
        
        system.runAs(salesUser0){
            
            //Creating Sales Area for the worksite:accountWS2.
            salesAreaInf0.Account__c = accountWS2.Id;
            salesAreaInf0.Sales_Area__c = '1000';
            insert salesAreaInf0;
            
            Sales_Area_Information__c salesAreaInf1000ForLE1 = [Select Id,Account__c,Sales_Area__c From Sales_Area_Information__c a Where a.Account__c =:accountLE1.Id AND a.Sales_Area__c = '1000'];
            delete salesAreaInf1000ForLE1;
            
            //Creating Sales Area for the LE1,this should not be copied to WS2 as it already have SAI of same salesArea but should be copied to WS3.
            G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS = false;
            salesAreaInf1.Account__c = accountLE1.Id;
            salesAreaInf1.Sales_Area__c = '1000';
            insert salesAreaInf1;
            
            //Creating Sales Area for the LE0,this should be copied to WS0 & WS1 as this Sales Area doesn't Exist for the worksite: accountWS0 & accountWS1.
            G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS = false;
            salesAreaInf2.Account__c = accountLE0.Id;
            salesAreaInf2.Sales_Area__c = '1000';
            insert salesAreaInf2;
        }
        
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS0.Id]);
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS1.Id]);
        
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS2.Id]);
        System.assertEquals(2,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS3.Id]);
    }
    
    
    /* 3.1 Test the below functionality:
      (a)Use Case 3.1: Any of the following fields are updated on a Sales Area Information record :Sales_group__c,Sales_Office__c,
                      Competitor__c,External_Partner__c,External_Partner_Type__c
      (b)Expected Result: APEX trigger updates the field values on SAI records for all child Work Site records that have a matching 
                    Sales Area Information record (match on field Sales_Area__c) . If no matching Sales Area Information records found, 
                    no action is required
    */
    static testMethod void LE_WS_AddUpdateFlow_Test7(){
        
        
        //Arrange
        createTestData();
        
        //Act
        List<Sales_Area_Information__c> salesAreaInfoLEList = new List<Sales_Area_Information__c>();
        List<Sales_Area_Information__c> salesAreaInfoWSList = new List<Sales_Area_Information__c>();
        
        system.runAs(salesUser2){
            
            salesAreaInfoLEList = [select Id,Account__c,Competitor__c,External_Partner_Type__c,Sales_Area__c From Sales_Area_Information__c
                                    Where Account__c =:accountLE0.Id ];
            
            system.debug('++salesAreaInfoList[0].Competitor__c++'+salesAreaInfoLEList[0].External_Partner_Type__c);
            
            salesAreaInfoLEList[0].Competitor__c = true;
            salesAreaInfoLEList[0].External_Partner_Type__c = 'DM Agency';
            update salesAreaInfoLEList;
            
            salesAreaInfoLEList[0].Competitor__c = false;
            update salesAreaInfoLEList;
            
            salesAreaInfoWSList = [select Id,Account__c,Competitor__c,External_Partner_Type__c,Sales_Area__c From Sales_Area_Information__c
                                    Where Account__c =:accountWS0.Id ];
            
            System.assertEquals('DM Agency',salesAreaInfoWSList[0].External_Partner_Type__c);
        }
    }
    
    
    /* 4.1 Test the below functionality:
      (a)Use Case 4.1: Any of the following fields are updated on an account record with record type Legal Entity :
                        Legal_Entity_Primary_Ind_Group_77__c,Legal_Entity_Primary_Ind_Group_8__c,Legal_Entity_Primary_Industry__c.
      (b)Expected Result: APEX trigger updates the field values on account records for all child Work Sites
    */
    static testMethod void LE_WS_AddUpdateFlow_Test8(){
        
        //Arrange
        createTestData();
        
        //Act
        List<Account> accountWSList = new List<Account>();
        
        accountLE0.Legal_Entity_Primary_Ind_Group_77__c = 'testLegalEntity';
        update accountLE0;
        
        accountWSList = [select Id,Legal_Entity_Primary_Ind_Group_77__c From Account
                                    Where Id =:accountWS0.Id ];
        System.assertEquals('testLegalEntity',accountWSList[0].Legal_Entity_Primary_Ind_Group_77__c);
    }
    
    
    /* 5.1 Test the below functionality:
      (a)Use Case 5.1: INTEGRATION USER adds new SAI record to Account of record type Work Site
      (b)Expected Result: APEX trigger creates new SAI record (copy of record created on WS) for the parent account (Legal Entity) 
                            of the Work Site provided that a SAI record containing the Sales Area doesn’t not already exist on the Legal Entity. 
                            NOTE : If WS does not have a parent account, no action is required
      
    */
    static testMethod void LE_WS_AddUpdateFlow_Test9(){
        
        //Arrange
        createTestData();
        
        //Act
        system.runAs(integrationUser){
            
            salesAreaInf0.Account__c = accountWS0.Id;
            salesAreaInf0.Sales_Area__c = '1000';
            insert salesAreaInf0;
        }
        
        List<Sales_Area_Information__c> salesAreaInfoList =  [Select Id,Sales_Area__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id];
        
        System.assertEquals(2,salesAreaInfoList.size());
        System.assertEquals(salesArea,salesAreaInfoList[0].Sales_Area__c);
        System.assertEquals('1000',salesAreaInfoList[1].Sales_Area__c);
        
        //Other WorkSite in the hierachy should not be updated with the new SalesArea.
        System.assertEquals(1,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS1.Id]);
    }
    
    /* 5.2 Test the below functionality:
      (a)Use Case 5.2: SALES USER adds new SAI record to Account of record type Work Site
      (b)Expected Result: APEX trigger creates new SAI record (copy of record created on WS) for the parent account (Legal Entity) 
                            of the Work Site provided that a SAI record containing the Sales Area doesn’t not already exist on the Legal Entity. 
                            NOTE : If WS does not have a parent account, no action is required
      
    */
    static testMethod void LE_WS_AddUpdateFlow_Test10(){
        
        //Arrange
        createTestData();
        
        //Act
        system.runAs(salesUser0){
            
            salesAreaInf0.Account__c = accountWS0.Id;
            salesAreaInf0.Sales_Area__c = '1000';
            insert salesAreaInf0;
        }
        
        List<Sales_Area_Information__c> salesAreaInfoList =  [Select Id,Sales_Area__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id];
        
        System.assertEquals(2,salesAreaInfoList.size());
        System.assertEquals(salesArea,salesAreaInfoList[0].Sales_Area__c);
        System.assertEquals('1000',salesAreaInfoList[1].Sales_Area__c);
        
        //Other WorkSite in the hirerchy should not be updated with the new SalesArea.
        System.assertEquals(1,[Select count() From Sales_Area_Information__c a Where a.Account__c =:accountWS1.Id]);
    }
    
    
    /* 6.1 Test the below functionality:
      (a)Use Case 6.1: Field Type__c on Sales Area Information record gets updated to “Customer”. 
      (b)Expected Result: (1)Validation rule will check the WS has a parent LE. If not, then user will not be allowed to update Type__c to customer.
                          (2)Validation rule will check that Type__c can only be updated to Customer on WS.
                          (3)Workflow rules update fields on WS account record.
                          (4)APEX trigger updates Type__c on Sales Area Information record of parent LE account (if parent LE) exists. 
                              Only Sales Area Information record matching the Sales Area of the SAI record updated for the WS should have 
                              the type field updated to Customer.
                          (5)If a matching Sales Area information record for the parent LE cannot be 
                              found then it should be created. TO DO: Once the logic is in place,complete the test method.
    */
    static testMethod void LE_WS_AddUpdateFlow_Test11(){
        
        //Arrange
        createTestData();
        
        //Act
        List<Sales_Area_Information__c> salesAreaInfoWSList0 = new List<Sales_Area_Information__c> ();
        List<Sales_Area_Information__c> salesAreaInfoWSList4 = new List<Sales_Area_Information__c> ();
        
        test.startTest();
        system.runAs(salesUser2){
            
            salesAreaInfoWSList0 = [Select Id,Type__c,Sales_Area__c From Sales_Area_Information__c a Where a.Account__c =:accountWS0.Id AND Sales_Area__c =:salesArea];
            salesAreaInfoWSList0[0].Type__c = 'Customer';
            
            //Updating a WS0 having a parent LE & having a matching SalesArea, ExpectedResult:4
            update salesAreaInfoWSList0;
            
            //Updating a WS4 having no parent LE, ExpectedResult:1
            salesAreaInfoWSList4 = [Select Id,Type__c,Sales_Area__c From Sales_Area_Information__c a Where a.Account__c =:accountWS4.Id AND Sales_Area__c =:salesArea];
            salesAreaInfoWSList4[0].Type__c = 'Customer';
            try{
                update salesAreaInfoWSList4;
                system.assert(false);           
            }
            catch(DMLException e){
                system.assert(true);
                system.assert(e.getMessage().contains('You cannot convert this Work Site to a customer as it does not have a Legal Entity'));
            }
            
            //Tested: Validation is working fine,error message You cannot convert this Work Site to a customer as it does not have a Legal Entity.: [Type__c]
            system.debug('+IS THE WORK FLOW WORKING+'+salesAreaInfoWSList4);
        }
        
        test.stopTest();
        //Assert
        //The related LE To the work Site must get updated with the new value.
        System.assertEquals('Customer',[Select Id,Type__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id AND Sales_Area__c =:salesArea].Type__c);
        
    }
    
    /* 6.2 Test the below functionality:
      (a)Use Case 6.2: Field Type__c on Sales Area Information record gets updated to “Customer”. 
      (b)Expected Result: 
                          (1)APEX trigger updates Type__c on Sales Area Information record of parent LE account (if parent LE) exists. 
                              Only Sales Area Information record matching the Sales Area of the SAI record updated for the WS should have 
                              the type field updated to Customer.   
                          (2)(APEX) If a matching SAI record exists at the LE level and fields Sales_Group__c and Sales_Office__c are not 
                                null on this record, these fields should be copied from the LE SAI to the WS SAI. 
                          (3)Other default values on the SAI record and the LE account record will be updated via workflow rules.        
      
    */
    static testMethod void LE_WS_AddUpdateFlow_Test12(){
        
        //Arrange
        createTestData();
        
        //Act
        List<Sales_Area_Information__c> salesAreaInfoWSList0 = new List<Sales_Area_Information__c> ();
        List<Sales_Area_Information__c> salesAreaInfoLEList0 = new List<Sales_Area_Information__c> ();
        
        test.startTest();
        system.runAs(salesUser2){
            
            salesAreaInfoLEList0 = [Select Id,Type__c,Sales_Area__c,Sales_Group_Name__c,Sales_Office_Name__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id AND Sales_Area__c =:salesArea];
            
            //Updating Sales_Group_Name__c & Sales_Office_Name__c on LE0
            salesAreaInfoLEList0[0].Sales_Group_Name__c = 'Team IDEA';
            salesAreaInfoLEList0[0].Sales_Office_Name__c = 'SMV';
            
            update salesAreaInfoLEList0;
            
            //Updating a WS0 having a parent LE0(Where Sales_Group__c & Sales_Office__c are populated) & having a matching SalesArea, ExpectedResult:2
            salesAreaInfoWSList0 = [Select Id,Type__c,Sales_Area__c From Sales_Area_Information__c a Where a.Account__c =:accountWS0.Id AND Sales_Area__c =:salesArea];
            salesAreaInfoWSList0[0].Type__c = 'Customer';
            salesAreaInfoWSList0[0].Account_Name__c = 'defaultValueUpdatesByworkFlow';
            update salesAreaInfoWSList0;

        }
        
        test.stopTest();
        //Assert
        //The related LE To the work Site must get updated with the new value.
        System.assertEquals('Customer',[Select Id,Type__c,Sales_Group_Name__c,Sales_Office_Name__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id AND Sales_Area__c =:salesArea].Type__c);
        System.assertEquals('SMV',[Select Id,Type__c,Sales_Group_Name__c,Sales_Office_Name__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id AND Sales_Area__c =:salesArea].Sales_Office_Name__c);
        System.assertEquals('Team IDEA',[Select Id,Type__c,Sales_Group_Name__c,Sales_Office_Name__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id AND Sales_Area__c =:salesArea].Sales_Group_Name__c);
        
        System.assertEquals('Team IDEA',[Select Id,Type__c,Sales_Group_Name__c,Sales_Office_Name__c From Sales_Area_Information__c a Where a.Account__c =:accountLE0.Id AND Sales_Area__c =:salesArea].Sales_Group_Name__c);
    }
    
    
    /* 7.1 Test the below functionality:
      (a)Use Case 6.2:  
      (b)Expected Result: 
                    (1)User clicks Add Unverified LE for WS button on WS record.
                    (2)System presents Account Edit screen (RT of Legal Entity)
                    (3)Fields pre-populated from the WS:Corporate_Registration_Number__c,Registration_Country__c,VAT_Number__c.
                    (4)User adds information and presses save.
                    (5)System validates information and saves Legal Entity record.
                    (6)System populates Parent Account field on WS record with LE record just created.   
      
      //To Do; This will be a CR:
      To do the pre-popuation we'd need to use a VF page and controller with a field set like we do everywhere else.
      
    */

    
    
    //Create Test Data.
    static void createTestData(){
        
        //***Creating custom setting.***
        UTIL_TestFactory.setUpOrg();
        
        //Creating CustomSetting.
        ScheduledJobParameters__c scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledParameters.AccountBatchHeapLimit__c = '7549747';
        scheduledParameters.AccountBatchJobSize__c = '200';
        scheduledParameters.AccountBatchDmlRowsLimit__c = '7000';
        scheduledParameters.AccountTeamMemberSyncSuccessTime__c = datetime.now().addhours(-2);
        update scheduledParameters;
        
        UTIL_TestFactory.createAccountTeamMemberToAccountMapping();
        UTIL_TestFactory.createAccountTeamMemberRolesToSync();
        
        list<User> userList = new list<User>();
        //***Creating a salesUser.***
        salesUser0 = UTIL_TestFactory.createAdmin('testSalesUsr0@mail.com');
        salesUser0.Sales_Area1__c = '1000';
        userList.add(salesUser0);
        
        salesUser1 = UTIL_TestFactory.createAdmin('testSalesUsr1@mail.com');
        salesUser1.Sales_Area1__c = '1000';
        userList.add(salesUser1);
        
        salesUser2 = UTIL_TestFactory.createAdmin('testSalesUsr2@mail.com');
        salesUser2.Sales_Area1__c = salesArea;
        userList.add(salesUser2);
        
        //***Creating a Integration User.***
        integrationUser = UTIL_TestFactory.createIntegrationUser('testIntegration@mail.com');
        integrationUser.Sales_Area1__c = '1000';
        userList.add(integrationUser);
        
        insert userList;
        
        list<Account> accountLEList = new list<Account>();
        //***Creating LE*****
        accountLE0 = UTIL_TestFactory.createAccount();
        accountLE0.RecordTypeId = rTypeLE;
        accountLE0.Involved_Party_ID__c = 'LE0';
        accountLEList.add(accountLE0);
        
        accountLE1 = UTIL_TestFactory.createAccount();
        accountLE1.RecordTypeId = rTypeLE;
        accountLE1.Involved_Party_ID__c = 'LE1';
        accountLEList.add(accountLE1);
                
        system.runAs(salesUser2){
            insert accountLEList;
        }

        list<Account> accountWSList = new list<Account>();      
        //***Creating WS*****
        accountWS0 = UTIL_TestFactory.createAccount();
        accountWS0.RecordTypeId = rTypeWS;
        accountWS0.ParentId = accountLE0.Id;
        accountWS0.Involved_Party_ID__c = 'WS0';
        accountWSList.add(accountWS0);
        
        accountWS1 = UTIL_TestFactory.createAccount();
        accountWS1.RecordTypeId = rTypeWS;
        accountWS1.ParentId = accountLE0.Id;
        accountWS1.Involved_Party_ID__c = 'WS1';
        accountWSList.add(accountWS1);
                
        accountWS2 = UTIL_TestFactory.createAccount();
        accountWS2.RecordTypeId = rTypeWS;
        accountWS2.ParentId = accountLE1.Id;
        accountWS2.Involved_Party_ID__c = 'WS2';
        accountWSList.add(accountWS2);
                
        accountWS3 = UTIL_TestFactory.createAccount();
        accountWS3.RecordTypeId = rTypeWS;
        accountWS3.ParentId = accountLE1.Id;
        accountWS3.Involved_Party_ID__c = 'WS3';
        accountWSList.add(accountWS3);      
        
        accountWS4 = UTIL_TestFactory.createAccount();
        accountWS4.RecordTypeId = rTypeWS;
        accountWS4.Involved_Party_ID__c = 'WS4';
        accountWSList.add(accountWS4);
                
        system.runAs(salesUser2){
            insert accountWSList;
        }
        
        //***Creating Account Team Member***
        AccountTeamMember0 = UTIL_TestFactory.createAccountTeamMember();
        
        AccountTeamMember1 = UTIL_TestFactory.createAccountTeamMember();
        
        //***Creating  Sales_Area_Information__c***
        salesAreaInf0 = new Sales_Area_Information__c();
        //salesAreaInf0.Account__c = acct.Id;
        
        salesAreaInf1 = new Sales_Area_Information__c();
        
        salesAreaInf2 = new Sales_Area_Information__c();
        //salesAreaInf0.Account__c = acct.Id;
    }
    
}