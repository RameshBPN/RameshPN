/**
    About
    -----
    Description: This class is used to test SalesAreaInformation_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Sep 2013
    
    Details
    -------
    This Class test the functionality of Account_SVC class.
    1. Test the copySalesAreaInformationFromLEOnWS method for insert usecase By NonIntegration User.
    2.
    3. Test the copySalesAreaInformationFromWSOnLE method for insert usecase By NonIntegration User.
    4. Test the copySalesAreaInformationFromLEOnWS method for insert usecase By Integration User.
    5. Test the copySalesAreaInformationFromWSOnLE method for insert usecase By Integration User.
    testCreateExtensionWithCustomerSAIExistingOnWS() - Positive test that the SAI on Extension validation is not triggered for correct data when creating an Extension
    testCreateExtensionWithCustomerSAINotExistingOnWS() - Negative test that the SAI on Extension validation is triggered for incorrect data when creating an Extension
    testCreateSAIOnExtensionWithCustomerSAIExistingOnWS() - Positive test that the SAI on Extension validation is not triggered for correct data when creating an SAI on Extension
    testCreateSAIOnExtensionWithCustomerSAINotExistingOnWS() - Negative test that the SAI on Extension validation is triggered for incorrect data when creating an SAI on Extension
    testCreateLEAndWSNotTriggeringExtensionValidation - Test that the creation of SAI on LE or WS does not trigger the Extension SAI validation rule
    
    Update History
    --------------
    Created Sep 2013 - A.B.
    
    Issues / TODOs
    --------------
*/
@isTest
private  class G2O_SalesAreaInformation_SVC_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static Account le0;                             //Legal Entity Associated to ws0 & ws1.
    static Account le1;                             //Legal Entity Associated to ws2.
    static List<Account> wsList0;                   //WorkSite Associated to LE-le0.
    static List<Account> wsList1;                   //WorkSite Associated to LE-le0.
    static list<Account> wsListJoined = new list<Account>();
    static Account ws2;                             //WorkSite Associated to LE-le1.
    static Sales_Area_Information__c sai0;          //Sales Area Information related to ws1.
    static Sales_Area_Information__c sai1;          //Sales Area Information related to le0.
    static Sales_Area_Information__c sai2;          //Sales Area Information related to le0.
    static List<Sales_Area_Information__c> saiList0; //Holds SAI records for copySAIFromWSOnLE_Test.
    static User sysAdmin;                           //Creating a user with Sys Admin profile & defined SalesArea.
    static User integrationUsr;
    static final String salesArea = '0540';//Sales area for testing
    //A.T.T.R.I.B.U.T.E.S
    
    
    /*1. Test the copySalesAreaInformationFromLEOnWS method for insert usecase.
    Creating Sales Area Information & associating it with legalentity,Copy of this Sales Area Information record must be 
    created to the related worksites only if its not related to a Sales Area Information record with the same SalesArea.*/
    static testMethod void copySAIFromLEOnWS_SysAdmin_Test(){
        
        // Arrange
        createTestDataForcopySAIFromWSOnLEBySysAdmin();
        
        //Act
        Test.startTest();
        //Creating Sales Area Information & associating it with legalentity,Copy of this Sales Area Information record must be 
        //created to the related worksites only if its not related to a Sales Area Information record with the same SalesArea.
        
        G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS = false;    //Seeting the flag as false as it is set to true during test data creation
        
        // Creating New SAI with Sales Area as 'PDK LO' on LE:le0
        sai1 = UTIL_TestFactory.createSalesAreaInformation();
        sai1.Account__c = le0.Id;
        sai1.Sales_Area__c = 'PDK LO';
        sai1.Sub_Segment__c = '1B';
        insert sai1;

        
        
        //***LE To WS**
        //le0: wsList0,wsList1
        //le1: ws2
        
        //***WS TO SAI**
        //wsList1[0]: sai0 -'PDK LO'
        
        //***LE TO Sales Area***
        //le0               : Sales Area Information:1000,PDK LO,PDK LO
        //le1               : Sales Area Information:1000
        //wsList0           : Sales Area Information:1000,PDK LO.
        //wsList1[0]        : Sales Area Information:1000,PDK LO,PDK LO
        //wsList1           : Sales Area Information:1000,PDK LO for all the records(excluding wsList1[0]  ).
        //ws2               : Sales Area Information:1000
        
        //Assert
        //New SalesArea Information record is created from Le-le0 from WS-wsList0
        System.assertEquals(2,[Select count() from Sales_Area_Information__c where Account__c =:wsList0[1].Id]);
        System.assertEquals(2,[Select count() from Sales_Area_Information__c where Account__c =:wsList0[198].Id]);
        
        //New SalesArea Information record is created from Le-le0 from WS-wsList0 of Sales Area 'PDK LO'
        System.assertEquals('PDK LO',[Select Id,Sub_Segment__c,Sales_Area__c,Account__c from Sales_Area_Information__c where Account__c =:wsList0[1].Id AND Sales_Area__c ='PDK LO'].Sales_Area__c);
                        
        //New SalesArea Information record is created from Le-le0 from WS-wsList1
        System.assertEquals(2,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[0].Id]);
        Test.stopTest();
    }

    //2. Test that child SalesAreas are correctly updated when the parent SalesArea is.
    static testMethod void salesAreaInformationUpdate_Test(){
        
        // Arrange
        createUpdateTestData();
        
        //Act
        Test.startTest();
        //Creating Sales Area Information & associating it with legalentity,Copy of this Sales Area Information record must be 
        //created to the related worksites only if its not related to a Sales Area Information record with the same SalesArea.
        sai1 = UTIL_TestFactory.createSalesAreaInformation();
        sai1.Account__c = le0.Id;
        sai1.Sales_Area__c = 'PDK LO';
        sai1.Sub_Segment__c = '1B';
        sai1.Sales_Office_Name__c = 'SalesOfficeNameOrg';
        sai1.Competitor__c = false;
        sai1.Sales_Group_Name__c = 'SalesGroupNameOrg';
        sai1.External_Partner__c = false;
        sai1.External_Partner_Type__c = 'ExternalPartnerTypeOrg';
        insert sai1;

        Sales_Area_Information__c childSAI1 = [SELECT id, Sales_Office_Name__c, Competitor__c, Sales_Group_Name__c, External_Partner__c, External_Partner_Type__c, Sales_Area__c FROM Sales_Area_Information__c WHERE account__c = :wsList0[0].id AND Sales_Area__c = 'PDK LO'];
        Sales_Area_Information__c childSAI2 = [SELECT id, Sales_Office_Name__c, Competitor__c, Sales_Group_Name__c, External_Partner__c, External_Partner_Type__c, Sales_Area__c FROM Sales_Area_Information__c WHERE account__c = :wsList0[0].id AND Sales_Area__c = 'PDK LO'];
        system.assertNotEquals(null, childSAI1);
        system.assertNotEquals(null, childSAI2);
        
        // Validating that before any changes are made, child SalesAreaInformation objects are created with correct data
        system.assertEquals('SalesOfficeNameOrg', childSAI1.Sales_Office_Name__c);
        system.assertEquals(false, childSAI1.Competitor__c);
        system.assertEquals('SalesGroupNameOrg', childSAI1.Sales_Group_Name__c);
        //system.assertEquals(false, childSAI1.External_Partner__c);
        system.assertEquals('ExternalPartnerTypeOrg', childSAI1.External_Partner_Type__c);

        system.assertEquals('SalesOfficeNameOrg', childSAI2.Sales_Office_Name__c);
        system.assertEquals(false, childSAI2.Competitor__c);
        system.assertEquals('SalesGroupNameOrg', childSAI2.Sales_Group_Name__c);
        //system.assertEquals(false, childSAI2.External_Partner__c);
        system.assertEquals('ExternalPartnerTypeOrg', childSAI2.External_Partner_Type__c);

        sai1.Sales_Office_Name__c = 'SalesOfficeNameUpdated';
        sai1.Competitor__c = true;
        sai1.Sales_Group_Name__c = 'SalesGroupNameUpdated';
        sai1.External_Partner__c = true;
        sai1.External_Partner_Type__c = 'ExternalPartnerTypeUpdated';
        update sai1;
        Test.stopTest();    

        childSAI1 = [SELECT id, Sales_Office_Name__c, Competitor__c, Sales_Group_Name__c, External_Partner__c, External_Partner_Type__c, Sales_Area__c FROM Sales_Area_Information__c WHERE account__c = :wsList0[0].id AND Sales_Area__c = 'PDK LO'];
        childSAI2 = [SELECT id, Sales_Office_Name__c, Competitor__c, Sales_Group_Name__c, External_Partner__c, External_Partner_Type__c, Sales_Area__c FROM Sales_Area_Information__c WHERE account__c = :wsList0[0].id AND Sales_Area__c = 'PDK LO'];
        
        // Validating that after the update the relevant fields has been updated
        system.assertEquals('SalesOfficeNameUpdated', childSAI1.Sales_Office_Name__c);
        system.assertEquals(true, childSAI1.Competitor__c);
        system.assertEquals('SalesGroupNameUpdated', childSAI1.Sales_Group_Name__c);
        system.assertEquals(true, childSAI1.External_Partner__c);
        system.assertEquals('ExternalPartnerTypeUpdated', childSAI1.External_Partner_Type__c);

        system.assertEquals('SalesOfficeNameUpdated', childSAI2.Sales_Office_Name__c);
        system.assertEquals(true, childSAI2.Competitor__c);
        system.assertEquals('SalesGroupNameUpdated', childSAI2.Sales_Group_Name__c);
        system.assertEquals(true, childSAI2.External_Partner__c);
        system.assertEquals('ExternalPartnerTypeUpdated', childSAI2.External_Partner_Type__c);  
    }

    //3. Test that parent and child SalesAreas are correctly updated when the child 
    //   SalesArea changes type to customer.
    static testMethod void salesAreaTypeUpdate_Test(){
        
        // Arrange
        createUpdateTestData();

        //Act
        Test.startTest();
        //Creating Sales Area Information & associating it with legalentity,Copy of this Sales Area Information record must be 
        //created to the related worksites only if its not related to a Sales Area Information record with the same SalesArea.
        sai1 = UTIL_TestFactory.createSalesAreaInformation();
        sai1.Account__c = le0.Id;
        sai1.Sales_Area__c = 'PDK LO';
        sai1.Sub_Segment__c = '1B';
        sai1.Sales_Office_Name__c = 'SalesOfficeNameOrg';
        sai1.Competitor__c = false;
        sai1.Sales_Group_Name__c = 'SalesGroupNameOrg';
        sai1.External_Partner__c = false;
        sai1.External_Partner_Type__c = 'ExternalPartnerTypeOrg';
        sai1.Type__c = 'Prospect';
        insert sai1;

        Sales_Area_Information__c childSAI1 = [SELECT id, Sales_Office_Name__c, Competitor__c, Sales_Group_Name__c, External_Partner__c, External_Partner_Type__c, Sales_Area__c, Type__c FROM Sales_Area_Information__c WHERE account__c = :wsList0[0].id AND Sales_Area__c = 'PDK LO'];
        system.assertNotEquals(null, childSAI1);
    
        // Validating that before any changes are made, child SalesAreaInformation objects are created with correct data
        system.assertEquals('Prospect', childSAI1.Type__c);

        childSAI1.Sales_Office_Name__c = 'randomWrongOfficeName';
        childSAI1.Sales_Group_Name__c = 'randomWrongGroupName';
        childSAI1.Type__c = 'Customer';
        update childSAI1;
        Test.stopTest();    

        childSAI1 = [SELECT id, Sales_Office_Name__c, Competitor__c, Sales_Group_Name__c, External_Partner__c, External_Partner_Type__c, Sales_Area__c, Type__c FROM Sales_Area_Information__c WHERE account__c = :wsList0[0].id AND Sales_Area__c = 'PDK LO'];
        sai1 = [SELECT id, Sales_Office_Name__c, Competitor__c, Sales_Group_Name__c, External_Partner__c, External_Partner_Type__c, Sales_Area__c, Type__c FROM Sales_Area_Information__c WHERE account__c = :wsList0[0].id AND Sales_Area__c = 'PDK LO'];
        
        // Validating that after the update the relevant fields has been updated
        system.assertEquals('SalesOfficeNameOrg', childSAI1.Sales_Office_Name__c);
        system.assertEquals('Customer', childSAI1.Type__c);
        system.assertEquals('SalesGroupNameOrg', childSAI1.Sales_Group_Name__c);

        system.assertEquals('Customer', sai1.Type__c);
    
    }
            
    //Create Test Data.
    static void createTestDataForcopySAIFromWSOnLEBySysAdmin(){
        
        //Setting Org
        UTIL_TestFactory.setUpOrg();
        
        //Creating a Sys Admin with a Sales Area Defined
        sysAdmin = UTIL_TestFactory.createAdmin('testCaseSys1Adm@mail.com');
        sysAdmin.Sales_Area1__c = '1000';
        insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            //Creating Legal Entity & will associate this Le with Worksite:w0,w1.
            //This LE will have (1SAI-1000)
        
            le0 = UTIL_TestFactory.createAccount();
            le0.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert le0;
            
            ///*Creating Work Site & associating this with Legal Entity: le0.
            //This WS will have (1SAI-1000)

            wsList0 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList0[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList0[i].ParentId = le0.Id;
                wsListJoined.add(wsList0[i]);
            }

           
            //Creating Work Site & associating this with Legal Entity: le0.
            //This WS will have (1SAI-1000)
            
            wsList1 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList1[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList1[i].ParentId = le0.Id;
                wsListJoined.add(wsList1[i]);                
            }
            insert wsListJoined;
        }
    }
    
    //Create Test Data.
    static void createUpdateTestData(){
        //Setting Org
        UTIL_TestFactory.setUpOrg();
        
        //Creating a Sys Admin with a Sales Area Defined
        sysAdmin = UTIL_TestFactory.createAdmin('testCaseSys1Adm@mail.com');
        sysAdmin.Sales_Area1__c = '1000';
        insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            le0 = UTIL_TestFactory.createAccount();
            le0.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert le0;
                        
            wsList0 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList0[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList0[i].ParentId = le0.Id;
            }
            insert wsList0; 
        }
    }

    /*3. Test the copySalesAreaInformationFromWSOnLE method for insert usecase: Stress Testing.
      Creates new SAI record (copy of record created on WS) for the parent account (Legal Entity) of the Work Site provided that a 
      SAI record containing the Sales Area doesn’t not already exist on the Legal Entity.
      NOTE : If WS does not have a parent account, no action is required*/
    static testMethod void copySAIFromWSOnLE_SysAdmin_Test(){
        
        // Arrange
        createTestDatacopySAIFromWSOnLEBySysAdmin();
        
        //le0           :wsList0
        //le1           :ws2
        
        //le0           : FO91,PDK LO,PDK LO
        //le1           : FO91
        //wsList1[0]    : FO91,PDK LO,PDK LO
        //ws2           : FO91
        //wsList0       : FO91
        //sai0      : PDK LO
        
        //Creating Sales Area Information & associating it with WorkSite,Copy of this Sales Area Information record must be 
        //created to the related LegalEntity only if its not related to a Sales Area Information record with the same SalesArea.
    
        //Act
        Test.startTest();
        
        saiList0 = new List<Sales_Area_Information__c>();
        for(integer i=0; i< wsList1.size(); i++){
            sai1 = new Sales_Area_Information__c();
            sai1.Account__c = wsList1[i].Id;
            sai1.Sales_Area__c = 'PDK LO';
            sai1.Sub_Segment__c = '1B';
            saiList0.add(sai1);
        }
                
        insert saiList0;
        
        Test.stopTest();
        
        //Assert
        //New Sales Area must be created on the LE -le0 assoiciated to WS-wsList1.
        System.assertEquals(2,[Select count() from Sales_Area_Information__c where Account__c =:le0.Id]);
        
        //New Sales Area 'PDK LO' is created on LE:le0
        System.assertEquals('PDK LO',[Select Id,Sub_Segment__c,Sales_Area__c,Account__c from Sales_Area_Information__c where Account__c =:le0.Id AND Sales_Area__c ='PDK LO'].Sales_Area__c);
        
        //wsList[0] will have SAI record for Sales Area: 1000
        System.assertEquals(2,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[0].Id]);
        
        //wsList1 excluding(wsList1[0]) will have SAI record for Sales Area: 1000 & PDK LO.
        System.assertEquals(2,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[1].Id]);
        System.assertEquals(2,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[198].Id]);        
    }
    
    //Create Test Data for Sales Area Information insert on WS that needs to be created on related LE.
    static void  createTestDatacopySAIFromWSOnLEBySysAdmin(){
        
        //Setting Org
        UTIL_TestFactory.setUpOrg();
        
        //Creating a Sys Admin with a Sales Area Defined
        sysAdmin = UTIL_TestFactory.createAdmin('testCaseSys1Adm@mail.com');
        sysAdmin.Sales_Area1__c = '1000';
        insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            //Creating Legal Entity & will associate this Le with Worksite:wsList0,wsList1.
            //This LE will have (1SAI-1000)
            
            le0 = UTIL_TestFactory.createAccount();
            le0.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert le0;
                        
            //Creating Work Site & associating this with Legal Entity: le0.
            //This WS will have (1SAI-1000)
            
            wsList0 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList0[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList0[i].ParentId = le0.Id;
            }
            
            //Creating Work Site & associating this with Legal Entity: le0.
            //This WS will have (1SAI-1000)
            
            wsList1 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList1.size(); i++){
                wsList1[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList1[i].ParentId = le0.Id;
            }
            
            //Insert the WS lists at once to keep down the DML operations
            List<Account> allWSList = new List<Account>();
            allWSList.addAll(wsList0);
            allWSList.addAll(wsList1);
            insert allWSList;            
        }
    }
    
    /*4. Test the copySalesAreaInformationFromLEOnWS method for insert usecase.
    Creating Sales Area Information & associating it with legalentity,Copy of this Sales Area Information record must be 
    created to the related worksites only if its not related to a Sales Area Information record with the same SalesArea.*/
    static testMethod void copySAIFromLEOnWS_IntUser_Test(){
        
        // Arrange
        createTestDataForcopySAIFromWSOnLEByIntUser();
        
        //Act
        Test.startTest();
        //Creating Sales Area Information & associating it with legalentity,Copy of this Sales Area Information record must be 
        //created to the related worksites only if its not related to a Sales Area Information record with the same SalesArea.
        
        G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS = false;    //Seeting the flag as false as it is set to true during test data creation
        
        // Creating New SAI with Sales Area as 'PDK LO' on LE:le0

        system.runAs(integrationUsr){
            sai1 = UTIL_TestFactory.createSalesAreaInformation();
            sai1.Account__c = le0.Id;
            sai1.Sales_Area__c = 'PDK LO';
            sai1.Sub_Segment__c = '1B';
            insert sai1;
        }
        Test.stopTest();
        
        //***LE To WS**
        //le0: wsList0,wsList1
        //le1: ws2
        
        //***WS TO SAI**
        //wsList1[0]: sai0 -'PDK LO'
        
        //***LE TO Sales Area***
        //le0             : Sales Area Information:PDK LO,PDK LO
        //le1             : Sales Area Information:
        //wsList0         : Sales Area Information:PDK LO.
        //wsList1[0]      : Sales Area Information:PDK LO,PDK LO
        //wsList1         : Sales Area Information:PDK LO for all the records(excluding wsList1[0]  ).
        //ws2             : Sales Area Information:

        //Assert
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:wsList0[1].Id]);
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:wsList0[1].Id]);
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:wsList0[198].Id]);
        
        //New SalesArea Information record is created from Le-le0 from WS-wsList0 of Sales Area 'PDK LO'
        System.assertEquals('PDK LO',[Select Id,Sub_Segment__c,Sales_Area__c,Account__c from Sales_Area_Information__c where Account__c =:wsList0[1].Id AND Sales_Area__c ='PDK LO'].Sales_Area__c);
                        
        //New SalesArea Information record is created from Le-le0 from WS-wsList1
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[0].Id]);
                
        //No Upsert on the work site associated associated to other Legal Entity.
        System.assertEquals(0,[Select count() from Sales_Area_Information__c where Account__c =:ws2.Id]);
    }
    
    //Create Test Data.
    static void createTestDataForcopySAIFromWSOnLEByIntUser(){
        
        //Setting Org
        UTIL_TestFactory.setUpOrg();
        
        //Creating a Integration User with a Sales Area Defined
        integrationUsr = UTIL_TestFactory.createIntegrationUser('testCaseIntegrationUsr1@mail.com');
        integrationUsr.Sales_Area1__c = '1000';
        insert integrationUsr;
        
        system.runAs(integrationUsr){
            
            //Creating Legal Entity & will associate this Le with Worksite:w0,w1.
            //This LE will NOT have Sales Area Created for  FO91
            
            le0 = UTIL_TestFactory.createAccount();
            le0.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert le0;
            
            //Creating Legal Entity & associating this Le with Work:2
            //This LE will NOT have Sales Area Created for  FO91
            
            le1 = UTIL_TestFactory.createAccount();
            le1.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert le1;
            
            //Creating Work Site & associating this with Legal Entity: le0.
            //This WS will NOT have Sales Area Created for  FO91
            
            wsList0 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList0[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList0[i].ParentId = le0.Id;
            }
            insert wsList0;
            
            //Creating Work Site & associating this with Legal Entity: le1.
            //This WS will NOT have Sales Area Created for  FO91
            
            ws2 = UTIL_TestFactory.createAccount();
            ws2.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            ws2.ParentId = le1.Id;
            insert ws2;
            
            //Creating Work Site & associating this with Legal Entity: le0.
            //This WS will NOT have Sales Area Created for  FO91
            
            wsList1 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList1[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList1[i].ParentId = le0.Id;
            }
            insert wsList1;
        }
    }

    
    /*5. Test the copySalesAreaInformationFromWSOnLE method for insert usecase: Stress Testing.
      Creates new SAI record (copy of record created on WS) for the parent account (Legal Entity) of the Work Site provided that a 
      SAI record containing the Sales Area doesn’t not already exist on the Legal Entity.
      NOTE : If WS does not have a parent account, no action is required*/
    static testMethod void copySAIFromWSOnLE_IntUser_Test(){
        
        // Arrange
        createTestDatacopySAIFromWSOnLEByIntUser();
        
        //le0         :wsList0
        //le1         :ws2
        
        //le0         : FO91,PDK LO,PDK LO
        //le1         : FO91
        //wsList1[0]  : FO91,PDK LO,PDK LO
        //ws2         : FO91
        //wsList0     : FO91
        //sai0        : PDK LO
        
        //Creating Sales Area Information & associating it with WorkSite,Copy of this Sales Area Information record must be 
        //created to the related LegalEntity only if its not related to a Sales Area Information record with the same SalesArea.
    
        //Act
        Test.startTest();
        
        saiList0 = new List<Sales_Area_Information__c>();
        for(integer i=0; i< wsList1.size(); i++){
            sai1 = new Sales_Area_Information__c();
            sai1.Account__c = wsList1[i].Id;
            sai1.Sales_Area__c = 'PDK LO';
            sai1.Sub_Segment__c = '1B';
            saiList0.add(sai1);
        }
        system.runAs(integrationUsr){       
            insert saiList0;
        }
        Test.stopTest();
        
        //Assert
        //New Sales Area must be created on the LE -le0 assoiciated to WS-wsList1.
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:le0.Id]);
        
        //New Sales Area 'PDK LO' is created on LE:le0
        System.assertEquals('PDK LO',[Select Id,Sub_Segment__c,Sales_Area__c,Account__c from Sales_Area_Information__c where Account__c =:le0.Id AND Sales_Area__c ='PDK LO'].Sales_Area__c);
        System.assertEquals('PDK LO',[Select Id,Sub_Segment__c,Sales_Area__c,Account__c from Sales_Area_Information__c where Account__c =:le0.Id AND Sales_Area__c ='PDK LO'].Sales_Area__c);
        
        //wsList[0] will Not have SAI record for Sales Area: 1000
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[0].Id]);
        
        //wsList1 excluding(wsList1[0]) will have SAI record for Sales Area: PDK LO 
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[1].Id]);
        System.assertEquals(1,[Select count() from Sales_Area_Information__c where Account__c =:wsList1[198].Id]);
                        
        //No Upsert on the work site associated associated to other Legal Entity.
        System.assertEquals(0,[Select count() from Sales_Area_Information__c where Account__c =:ws2.Id]);
        
    }
    
    //Create Test Data for Sales Area Information insert on WS that needs to be created on related LE.
    static void  createTestDatacopySAIFromWSOnLEByIntUser(){
        
        //Setting Org
        UTIL_TestFactory.setUpOrg();
        
        //Creating a Integration User with a Sales Area Defined
        integrationUsr = UTIL_TestFactory.createIntegrationUser('testCaseIntegrationUsr1@mail.com');
        integrationUsr.Sales_Area1__c = '1000';
        insert integrationUsr;
        
        system.runAs(integrationUsr){
            
            //Creating Legal Entity & will associate this Le with Worksite:wsList0,wsList1.
            //This LE will NOT have Sales Area Created for  FO91
            
            le0 = UTIL_TestFactory.createAccount();
            le0.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert le0;
            
            //Creating Legal Entity & associating this Le with Worksite:w2
            //This LE will NOT have Sales Area Created for  FO91
            
            le1 = UTIL_TestFactory.createAccount();
            le1.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert le1;
            
            //Creating Work Site & associating this with Legal Entity: le0.
            //This WS will NOT have Sales Area Created for  FO91
            
            wsList0 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList0[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList0[i].ParentId = le0.Id;
            }
            insert wsList0;
            
            //Creating Work Site & associating this with Legal Entity: le1.
            //This WS will NOT have Sales Area Created for  FO91
            
            ws2 = UTIL_TestFactory.createAccount();
            ws2.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            ws2.ParentId = le1.Id;
            insert ws2;
            
            //Creating Work Site & associating this with Legal Entity: le0.
            //This WS will NOT have Sales Area Created for  FO91
            
            wsList1 = UTIL_TestFactory.createAccounts();
            for(integer i=0; i< wsList0.size(); i++){
                wsList1[i].RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                wsList1[i].ParentId = le0.Id;
            }
            insert wsList1;
        }
    }       
    
    static testMethod void SalesAreaInformationSimultanousUpdate(){
        UTIL_TestFactory.setUpOrg();
        Account parentAccount = UTIL_TestFactory.createAccount();
        parentAccount.recordtypeid = UTIL_Meta.getAccountLegalEntityRT();
        insert parentAccount;
        
        Account childAcc1 = UTIL_TestFactory.createAccount();           
        childAcc1.parentid = parentAccount.id;
        insert childAcc1;
        
        Account childAcc2 = UTIL_TestFactory.createAccount();           
        childAcc2.parentid = parentAccount.id;
        insert childAcc2;
        list<Sales_Area_Information__c> saiList = [select id from Sales_Area_Information__c where account__c = :childAcc2.id or account__c = :childAcc1.id];
        for(Sales_Area_Information__c SAI : saiList){
            SAI.type__c = 'Customer';
        }
        update saiList;
    }       
    
    static testMethod void testConflictingBatchUpdate(){
        UTIL_TestFactory.setUpOrg();
        Account parentAccount = UTIL_TestFactory.createAccount();
        parentAccount.recordtypeid = UTIL_Meta.getAccountLegalEntityRT();
        insert parentAccount;
        
        Account childAcc1 = UTIL_TestFactory.createAccount();           
        childAcc1.parentid = parentAccount.id;
        insert childAcc1;

        list<Sales_Area_Information__c> saiList = [select id, Account__c from Sales_Area_Information__c where account__c = :childAcc1.id or account__c = :parentAccount.id];
        for(Sales_Area_Information__c SAI : saiList){
            if(SAI.Account__c == childAcc1.id){
                SAI.type__c = 'Customer';
            }
        }
        update saiList;
        
        system.assertEquals('Customer', [Select id, Type__c From Sales_Area_Information__c WHERE account__c = :parentAccount.id].Type__c);
    }
    
    static testMethod void testGovernanceLimits(){
        UTIL_TestFactory.setUpOrg();
        Account parentAccount = UTIL_TestFactory.createAccount();
        parentAccount.recordtypeid = UTIL_Meta.getAccountLegalEntityRT();
        insert parentAccount;
        
        list<Account> childAccs = new list<Account>();
        Account childAcc;
        for(integer i = 0; i < 400; i++){
            childAcc = UTIL_TestFactory.createAccount();
            childAcc.parentid = parentAccount.id;
            childAccs.add(childAcc);
        }
        insert childAccs;

        list<id> childAccIds = new list<id>();
        for(Account acc : childAccs){
            childAccIds.add(acc.id);
        }
        list<Sales_Area_Information__c> saiList = [select id, Account__c from Sales_Area_Information__c where account__c IN :childAccIds or account__c = :parentAccount.id];
        for(Sales_Area_Information__c SAI : saiList){
            if(SAI.Account__c != parentAccount.id){
                SAI.Sales_Office_Name__c = 'WS SalesOfficeName';
            }
            else{
                SAI.Sales_Office_Name__c = 'LE SalesOfficeName';                
            }
        }
        update saiList; 
        system.debug(logginglevel.Error, 'SOQL Limit:' + limits.getQueries());  
        test.startTest();
        system.debug(logginglevel.Error, 'SOQL Limit:' + limits.getQueries());  

        for(Sales_Area_Information__c SAI : saiList){
            if(SAI.Account__c != parentAccount.id){
                SAI.type__c = 'Customer';
            }
            else{
                SAI.DK_Postbox_Customer__c = true;
            }
        }
        update saiList;
        system.debug(logginglevel.Error, 'SOQL Limit:' + limits.getQueries());  
        test.stopTest();
        system.assertEquals('Customer', [Select id, Type__c From Sales_Area_Information__c WHERE account__c = :parentAccount.id].Type__c);
    }
    
    /* This method will create an Extension with a SAI connected to a WS where the 
    Sales Area Information created on the Extension exists as a Customer SAI on the WS
    */
    static testMethod void testCreateExtensionWithCustomerSAIExistingOnWS() {
        //Arrange
        User adminUser = UTIL_TestFactory.createAdmin('adminUser_imoweimfow@user.com');
        adminUser.Sales_Area1__c = '1000';
        insert adminUser;
        
        System.runAs(adminUser) {
            Account legalEntity = UTIL_TestFactory.createAccount();
            legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            legalEntity.Name = 'Legal Entity';
            insert legalEntity;

            Account workSite = UTIL_TestFactory.createAccount();
            workSite.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSite.Name = 'Work Site';
            workSite.ParentId = legalEntity.Id;
            insert workSite;
            
            //Update the SAI that was created by a trigger to a Customer to pass validation
            Sales_Area_Information__c SAI = [SELECT Id FROM Sales_Area_Information__c Where Account__c =: workSite.Id];
            SAI.Type__c = 'Customer';
            update SAI;
            
            //Act
            Account extension = UTIL_TestFactory.createAccount();
            extension.RecordTypeId = UTIL_Meta.getAccountExtensionRT();
            extension.Name = 'Extension';
            extension.ParentId = workSite.Id;
            try {
                insert extension;
            //Assert
            } catch(Exception e) {
                System.assert(false, 'The Sales Area Information on the extension that should pass the validation rule does not, exception: ' + e.getMessage());
            }
        }
    }
    
    /* This method will create an Extension with a SAI connected to a WS where the 
    Sales Area Information created on the Extension does not exist as a Customer SAI on the WS
    */
    static testMethod void testCreateExtensionWithCustomerSAINotExistingOnWS() {
        //Arrange
        User adminUser = UTIL_TestFactory.createAdmin('adminUser_imoweimfow@user.com');
        adminUser.Sales_Area1__c = '1000';
        insert adminUser;
        
        System.runAs(adminUser) {
            Account legalEntity = UTIL_TestFactory.createAccount();
            legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            legalEntity.Name = 'Legal Entity';
            insert legalEntity;
            
            Account workSite = UTIL_TestFactory.createAccount();
            workSite.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSite.Name = 'Work Site';
            workSite.ParentId = legalEntity.Id;
            insert workSite;
            
            //Make the WS a Customer to the other Sales Area Information
            Sales_Area_Information__c wsSecondSAI = UTIL_TestFactory.createSalesAreaInformationDMLFree();
            wsSecondSAI.Type__c = 'Customer';
            wsSecondSAI.Sales_Area__c = salesArea;
            wsSecondSAI.PostNord_Company_Name__c = salesArea;
            wsSecondSAI.Account__c = workSite.Id;
            insert wsSecondSAI;
            
            //Act
            Account extension = UTIL_TestFactory.createAccount();
            extension.RecordTypeId = UTIL_Meta.getAccountExtensionRT();
            extension.Name = 'Extension';
            extension.ParentId = workSite.Id;
            try {
                insert extension;
            //Assert
            } catch(Exception e) {
                System.assert(e.getMessage().contains(Label.Parent_WS_does_not_have_corresponding_SAI), 'Unexpected error: ' + e.getMessage());
            }
        }   
    }
    
    /* This method will create an additional SAI on an Extension that is connected to a WS where the 
    Sales Area Information created on the Extension does exist as a Customer SAI on the WS
    */
    static testMethod void testCreateSAIOnExtensionWithCustomerSAIExistingOnWS() {
        //Arrange
        User adminUser = UTIL_TestFactory.createAdmin('adminUser_imoweimfow@user.com');
        adminUser.Sales_Area1__c = '1000';
        insert adminUser;
        
        System.runAs(adminUser) {
            Account legalEntity = UTIL_TestFactory.createAccount();
            legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            legalEntity.Name = 'Legal Entity';
            insert legalEntity;
            
            Account workSite = UTIL_TestFactory.createAccount();
            workSite.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSite.Name = 'Work Site';
            workSite.ParentId = legalEntity.Id;
            insert workSite;
            
            //Update the SAI that was created by a trigger to a Customer to be able to add an extension to it
            Sales_Area_Information__c SAI = [SELECT Id FROM Sales_Area_Information__c Where Account__c =: workSite.Id];
            SAI.Type__c = 'Customer';
            update SAI;
            
            //Add a SAI to the WS that did not exist before to match against in the validation
            Sales_Area_Information__c wsSAI = UTIL_TestFactory.createSalesAreaInformationDMLFree();
            wsSAI.Type__c = 'Customer';
            wsSAI.Sales_Area__c = salesArea;
            wsSAI.PostNord_Company_Name__c = salesArea;
            wsSAI.Account__c = workSite.Id;
            insert wsSAI;
            
            Account extension = UTIL_TestFactory.createAccount();
            extension.RecordTypeId = UTIL_Meta.getAccountExtensionRT();
            extension.Name = 'Extension';
            extension.ParentId = workSite.Id;
            insert extension;
            
            //Act
            //This is the new SAI that will be validated
            Sales_Area_Information__c extSAI = UTIL_TestFactory.createSalesAreaInformationDMLFree();
            extSAI.Type__c = 'Customer';
            extSAI.Sales_Area__c = salesArea;
            extSAI.PostNord_Company_Name__c = salesArea;
            extSAI.Account__c = extension.Id;
            //Assert
            try {
                insert extSAI;
            } catch(Exception e) {
                System.assert(false, 'The Sales Area Information that should pass the validation rule does not, exception: ' + e.getMessage());
            }
        }   
    }
    
    /* This method will create an additional SAI on an Extension that is connected to a WS where the 
    Sales Area Information created on the Extension does not exist as a Customer SAI on the WS,
    either it does not exist at all or it is not a Customer SAI
    */
    static testMethod void testCreateSAIOnExtensionWithCustomerSAINotExistingOnWS() {
        //Arrange
        User adminUser = UTIL_TestFactory.createAdmin('adminUser_imoweimfow@user.com');
        adminUser.Sales_Area1__c = '1000';
        insert adminUser;
        
        System.runAs(adminUser) {
            Account legalEntity = UTIL_TestFactory.createAccount();
            legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            legalEntity.Name = 'Legal Entity';
            insert legalEntity;
            
            Account workSite = UTIL_TestFactory.createAccount();
            workSite.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSite.Name = 'Work Site';
            workSite.ParentId = legalEntity.Id;
            insert workSite;
            
            //Update the SAI that was created by a trigger to a Customer to be able to add an extension to the WS
            Sales_Area_Information__c SAI = [SELECT Id FROM Sales_Area_Information__c Where Account__c =: workSite.Id];
            SAI.Type__c = 'Customer';
            update SAI;
            
            //Add a SAI to the WS that did not exist before to match against in the validation
            Sales_Area_Information__c wsSAI = UTIL_TestFactory.createSalesAreaInformationDMLFree();
            wsSAI.Type__c = 'Prospect';
            wsSAI.Sales_Area__c = salesArea;
            wsSAI.PostNord_Company_Name__c = salesArea;
            wsSAI.Account__c = workSite.Id;
            insert wsSAI;
            
            Account extension = UTIL_TestFactory.createAccount();
            extension.RecordTypeId = UTIL_Meta.getAccountExtensionRT();
            extension.Name = 'Extension';
            extension.ParentId = workSite.Id;
            insert extension;
            
            //Act
            //This is a new SAI that will be validated (Prospect SAI on WS)
            Sales_Area_Information__c extSAI1 = UTIL_TestFactory.createSalesAreaInformationDMLFree();
            extSAI1.Type__c = 'Prospect';
            extSAI1.Sales_Area__c = '4000';
            extSAI1.PostNord_Company_Name__c = '4000';
            extSAI1.Account__c = extension.Id;
            
            //This is a new SAI that will be validated (No corresponding SAI on WS)
            Sales_Area_Information__c extSAI2 = UTIL_TestFactory.createSalesAreaInformationDMLFree();
            extSAI2.Type__c = 'Prospect';
            extSAI2.Sales_Area__c = 'FO90';
            extSAI2.PostNord_Company_Name__c = 'FO90';
            extSAI2.Account__c = extension.Id;
            
            //Assert
            try {
                insert extSAI1;
            } catch(Exception e) {
                System.assert(e.getMessage().contains(Label.Parent_WS_does_not_have_corresponding_SAI), 'Unexpected error: ' + e.getMessage());
            }
            
            try {
                insert extSAI2;
            } catch(Exception e) {
                System.assert(e.getMessage().contains(Label.Parent_WS_does_not_have_corresponding_SAI), 'Unexpected error: ' + e.getMessage());
            }
        }   
    }
    
    /* This method will create an Legal Entity and Work Site to make sure the 
        validation rule for extensions is not affecting those record types
    */
    static testMethod void testCreateLEAndWSNotTriggeringExtensionValidation() {
        //Arrange
        User adminUser1000 = UTIL_TestFactory.createAdmin('adminUser_imoweimfow@user.com');
        adminUser1000.Sales_Area1__c = '1000';
        insert adminUser1000;
        
        User adminUser4000 = UTIL_TestFactory.createAdmin('adminUser_3gqfq34fQWDQW@user.com');
        adminUser4000.Sales_Area1__c = '4000';
        insert adminUser4000;
        
        Account legalEntity = UTIL_TestFactory.createAccount();
        legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        legalEntity.Name = 'Legal Entity';
        
        System.runAs(adminUser1000) {
            try { //Act
                insert legalEntity;
            } catch (Exception e) {
                //Assert
                System.assert(e.getMessage().contains(Label.Parent_WS_does_not_have_corresponding_SAI), 'Legal Entity failed insertion due to Extension validation rule, it should not.');
            }
        }

        System.runAs(adminUser4000) {
            Account workSite = UTIL_TestFactory.createAccount();
            workSite.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSite.Name = 'Work Site';
            workSite.ParentId = legalEntity.Id;
            try { //Act
                insert workSite;
            } catch (Exception e) {
                //Assert
                System.assert(e.getMessage().contains(Label.Parent_WS_does_not_have_corresponding_SAI), 'Work Site failed insertion due to Extension validation rule, it should not.');
            }
        }
    }
}