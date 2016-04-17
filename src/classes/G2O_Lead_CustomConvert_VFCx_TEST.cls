/**
    About
    -----
    Description: This class is used to test G2O_Lead_CustomConvert_VFCx
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Aug 2013
    
    Details
    -------
    This Class test the functionality of G2O_Lead_CustomConvert_VFCx class.
    1. Test Account validation Errors.
    2. Test Contact Validation Errors.
    3. Test Validation Error for : NEW ACCOUNT --- ATTACH TO EXISTING CONTACT Condition.
    4. Test Lead convert process for : Test NEW ACCOUNT --- NEW CONTACT Condition.
    5. Test Lead convert process for : Test NEW ACCOUNT --- DO NOT CREATE CONTACT Condition.
    6. Test Lead convert process for : ATTACH TO EXISTING ACCOUNT --- ATTACH TO EXISTING CONTACT Condition.
    7. Test Lead convert process for : ATTACH TO EXISTING ACCOUNT --- NEW CONTACT Condition.
    8. Test Lead convert process for : ATTACH TO EXISTING ACCOUNT --- DO NOT CREATE CONTACT Condition.
    9. Test Lead convert process for : Attach Account --- Attach Contact condition using getAccountPickVal,getContactPickVal(Lookup).
    10.Test Lead convert process for : Account__c is populated on Lead.
    Update History
    --------------
    Created Aug 2013 - A.B.
    
    Issues / TODOs
    --------------
    
*/
@isTest(SeeAllData=true)
private class G2O_Lead_CustomConvert_VFCx_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static Lead lead;           //Account__c is Empty for this lead.
    static Lead lead0;          //Account__c is populated for this lead.
    static Account account1;    //Account of record type Worksite having same Name as Lead,used in testing "Attach to existing" account use case.
    static Account account2;    //Account of record type Worksite associated to contact.    
    static Account account3;    //Account of record type as Person account. 
    static Account account4;    //Account associated to no contact.
    static Contact contact1;    //Contact to be used in the Lead_Identifier__c while creating lead.
    static Contact contact2;    //Contact having the same First Name & Last Name as of Lead,used in testing "Attach to existing" contact use case.
    static LeadStatus leadStatus;
    static User sysAdminUser;
    //A.T.T.R.I.B.U.T.E.S
    
    //1. Test ACCOUNT VALIDATION ERRORS.
    static testMethod void leadConvertProcessTest1(){
        
        //Arrange
        createTestData();
        String expError = '';
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        //Setting the Selected Account as 'NONE' so that a validation error is thrown.
        ext.accountSelected = '#NONE#';
        try{
            ext.leadConvertProcess();
            
        }catch(Exception e){
            system.debug('++++e1+++');
            expError = e.getMessage();
            system.debug('++++e+++');
        }
        Test.stopTest();
        
        //Assert
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        Boolean hasError = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Account Name: You must enter a value')) hasError = true;
        }
        System.assertEquals(true,hasError);
        
    }
    
    //2. Test CONTACT VALIDATION ERRORS.
    static testMethod void leadConvertProcessTest2(){
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        //Setting the selected contact as 'NONE',Thus a validation error will be thrown.
        ext.accountSelected = account1.Id;
        ext.contactSelected = '#NONE#';
        ext.leadConvertProcess();
        Test.stopTest();
        
        //Assert
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        Boolean hasError = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Contact Name: You must enter a value')) hasError = true;
        }
        System.assertEquals(true,hasError);
    }
    
    //3. Test VALIDATION ERROR- NEW ACCOUNT --- ATTACH TO EXISTING CONTACT Condition
    static testMethod void leadConvertProcessTest3(){
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        //Setting the Account selected to 'NEW' & associating the contact selected to an existing account,This will set a validation error.
        ext.accountSelected = '#NEW#';
        ext.contactSelected = contact2.Id;
        ext.leadConvertProcess();
        Test.stopTest();
        
        //Assert
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        Boolean hasError = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Lead Convert Error')) hasError = true;
        }
        System.assertEquals(true,hasError);
        
    }
    
    //4. Test NEW ACCOUNT --- NEW CONTACT Condition.
    static testMethod void leadConvertProcessTest4(){
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        //Setting the Selected Account to be 'New' & Selected Contact to be 'New'.
        ext.accountSelected = '#NEW#';
        ext.contactSelected = '#NEW#';
        ext.convertStatusSelected = leadStatus.Id;
        ext.leadConvertProcess();
        Test.stopTest();
        
        //Assert
        //A new contact is created.
        List<Contact> conRecList = [Select c.Id,c.AccountId From Contact c Where c.Id =:ext.conId];
        System.assert(conRecList.size() > 0, 'No contact was created.');
        
        //A new account contact role is created.
        List<Account_Contact_Role_Transaction__c> accContactRole =[Select a.Contact__c, a.Account__c From Account_Contact_Role_Transaction__c a Where  a.Contact__c =:ext.conId AND a.Account__c  =:conRecList[0].AccountId ];
        System.assert(accContactRole.size() > 0, 'No account contact role was created.');
        
        System.assertEquals(18,String.ValueOf(ext.conId).length());
        
        //Checking if the new opportunity is created.
        System.assertEquals(18,String.ValueOf(ext.oppId).length());
        System.assertEquals(18,string.ValueOf(conRecList[0].AccountId).length());
        System.assertEquals(1,accContactRole.size());
        
    }
    
    //5. Test NEW ACCOUNT --- DO NOT CREATE CONTACT Condition.
    static testMethod void leadConvertProcessTest5(){
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
            PageReference pageRef = Page.G2O_Lead_CustomConvert;
            Test.setCurrentPage(pageRef);
            ApexPages.standardController theController = new ApexPages.standardController(lead);
            G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
            ext.getAccountDetail();
            ext.getContactDetail();
            ext.getConvertStatus();
            //Setting the account selected to 'New' & contact selected to 'Do No Create Contact'.
            ext.accountSelected = '#NEW#';
            ext.contactSelected = '#DoNotCreateContact#';
            ext.convertStatusSelected = leadStatus.Id;
            ext.leadConvertProcess();
            Test.stopTest();
            
        //Assert
        List<Opportunity> opptyList = [Select o.Id,o.AccountId From Opportunity o Where o.Id =:ext.oppId];
        //New opp is created.
        System.assert(opptyList.size() != 0, 'No Opportunity created');
        //new opportunity is created.
        System.assertEquals(true,ext.oppId !=null);
        //new account is created.
        System.assertEquals(true,opptyList[0].AccountId !=null);
        
        List<Contact> conList = [Select c.Id,c.AccountId From Contact c Where c.AccountId =:opptyList[0].AccountId];
        //No new contact is created.
        System.assertEquals(0,conList.size());
        
        List<Account_Contact_Role_Transaction__c> accContactRole =[Select a.Contact__c, a.Account__c From Account_Contact_Role_Transaction__c a Where a.Account__c  =:opptyList[0].AccountId ];
        //No new account contact role transaction is created.
        System.assertEquals(0,accContactRole.size());
    }
    
    
    //6. Test  ATTACH TO EXISTING ACCOUNT --- ATTACH TO EXISTING CONTACT Condition.
    static testMethod void leadConvertProcessTest6(){
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        //Setting the account & contact to existing records.
        ext.accountSelected = account4.Id;
        ext.contactSelected = contact2.Id;
        ext.convertStatusSelected = leadStatus.Id;
        ext.leadConvertProcess();
        Test.stopTest();
        
        //Assert
        //New opportunity is created.
        List<Opportunity> opptyList = [Select o.Id,o.AccountId From Opportunity o Where o.Id =:ext.oppId];
        //New contact is created.
        List<Contact> conList = [Select c.Id,c.AccountId From Contact c Where c.AccountId =:opptyList[0].AccountId];
        List<Account_Contact_Role_Transaction__c> accContactRole =[Select a.Contact__c, a.Account__c From Account_Contact_Role_Transaction__c a Where  a.Contact__c =:contact2.Id AND a.Account__c  =:account4.Id ];
        
        //New opportunity is created.
        System.assertEquals(true,ext.oppId !=null);
        System.assertEquals(account4.Id,opptyList[0].AccountId);
        System.assertEquals(contact2.Id,conList[0].Id);
        System.assertEquals(1,accContactRole.size());   //When a new Opportunity is created,Then Account is associated to the contact thus a new ACRT record is created.
    }
    
    
    //7. Test  ATTACH TO EXISTING ACCOUNT --- NEW CONTACT Condition.
    static testMethod void leadConvertProcessTest7(){
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        //Setting the account selected to 'Existing' & contact selected to 'New'.
        ext.accountSelected = account4.Id;  //Using account4 as it is not associated to any contact.
        ext.contactSelected = '#NEW#';
        ext.convertStatusSelected = leadStatus.Id;
        ext.leadConvertProcess();
        Test.stopTest();
        
        //Assert
        List<Opportunity> opptyList = [Select o.Id,o.AccountId From Opportunity o Where o.Id =:ext.oppId];
        List<Contact> conList = [Select c.Id,c.AccountId From Contact c Where c.AccountId =:opptyList[0].AccountId];
        List<Account_Contact_Role_Transaction__c> accContactRole =[Select a.Contact__c, a.Account__c From Account_Contact_Role_Transaction__c a Where  a.Contact__c =:conList[0].Id AND a.Account__c  =:opptyList[0].AccountId ];
        
        //Opportunity is created.
        System.assertEquals(true,ext.oppId !=null);
        //Account is updated.
        System.assertEquals(account4.Id,opptyList[0].AccountId);
        System.assertEquals(ext.conId,conList[0].Id);
        System.assertEquals(1,accContactRole.size());   //When a new Opportunity is created,Then Account is associated to the contact thus a new ACRT record is created.

    }
    
    
    //8. Test  ATTACH TO EXISTING ACCOUNT --- DO NOT CREATE CONTACT Condition.
    static testMethod void leadConvertProcessTest8(){
        
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
            PageReference pageRef = Page.G2O_Lead_CustomConvert;
            Test.setCurrentPage(pageRef);
            ApexPages.standardController theController = new ApexPages.standardController(lead);
            G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
            ext.getAccountDetail();
            ext.getContactDetail();
            ext.getConvertStatus();
            //Setting the account Selected to 'Existing' & not creating any contact.
            ext.accountSelected = account4.Id;              //Using account4 as it is not associated to any contact.
            ext.contactSelected = '#DoNotCreateContact#';
            ext.convertStatusSelected = leadStatus.Id;
            ext.leadConvertProcess();
            Test.stopTest();
            
            //Assert
            List<Opportunity> opptyList = [Select o.Id,o.AccountId From Opportunity o Where o.Id =:ext.oppId];
            List<Contact> conList = [Select c.Id,c.AccountId From Contact c Where c.AccountId =:opptyList[0].AccountId];
            List<Account_Contact_Role_Transaction__c> accContactRole =[Select a.Contact__c, a.Account__c From Account_Contact_Role_Transaction__c a Where  a.Account__c  =:opptyList[0].AccountId ];
            
            //New opportunity is created.
            System.assertEquals(true,ext.oppId !=null);
            //Account is updated.
            System.assertEquals(account4.Id,opptyList[0].AccountId);
            //No contact is created.
            System.assertEquals(0,conList.size());
            System.assertEquals(0,accContactRole.size());   //When a new Opportunity is created & No Contact is created then no ACRT is created.
            
    }
    
    //9. Test NEW ACCOUNT --- NEW CONTACT Condition & Changing it to a Attach Account --- Attach Contact condition using getAccountPickVal,getContactPickVal
    static testMethod void leadConvertProcessTest9(){
        
        //Arrange
        createTestData();
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        ext.accountSelected = '#NEW#';
        ext.contactSelected = '#NEW#';
        //Setting the Account record from the Account Lookup.
        ext.leadRecord.Account__c = account4.Id;
        //Setting the Contact record from the Contact Lookup.
        ext.caseRecord.ContactId = contact2.Id;
        ext.getAccountPickVal();
        ext.getContactPickVal();
        ext.convertStatusSelected = leadStatus.Id;
        ext.leadConvertProcess();
        Test.stopTest();
        
        //Assert
        List<Opportunity> opptyList = [Select o.Id,o.AccountId From Opportunity o Where o.Id =:ext.oppId];
        List<Contact> conList = [Select c.Id,c.AccountId From Contact c Where c.AccountId =:opptyList[0].AccountId];
        List<Account_Contact_Role_Transaction__c> accContactRole =[Select a.Contact__c, a.Account__c From Account_Contact_Role_Transaction__c a Where  a.Contact__c =:contact2.Id AND a.Account__c  =:account4.Id ];
        
        //New opportunity is created.
        System.assertEquals(true,ext.oppId !=null);
        //Account selected from the loopup is updated.
        System.assertEquals(account4.Id,opptyList[0].AccountId);
        //Contact selected from the lookup is updated.
        System.assertEquals(contact2.Id,conList[0].Id);
        System.assertEquals(1,accContactRole.size());   //When a new Opportunity is created,Then Account is associated to the contact thus a new ACRT record is created.

        
    }
    
    //10. Test Condition where Account__c is populated on Lead,by default the it will satisfy condition: CREATE NEW CONTACT-lead.Account__r.Name --- DO NOT CREATE CONTACT.
    static testMethod void leadConvertProcessTest10(){
        
        //Arrange
        createTestData();       //Here lead0 is associate to account4.
        
        //Act
        Test.startTest();
        PageReference pageRef = Page.G2O_Lead_CustomConvert;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(lead0);
        G2O_Lead_CustomConvert_VFCx ext = new G2O_Lead_CustomConvert_VFCx(theController);
        ext.getAccountDetail();
        ext.getContactDetail();
        ext.getConvertStatus();
        ext.convertStatusSelected = leadStatus.Id;
        ext.contactSelected = '#DoNotCreateContact#';
        ext.leadConvertProcess();
        Test.stopTest();
        
        //Assert
        List<Opportunity> opptyList = [Select o.Id,o.AccountId From Opportunity o Where o.Id =:ext.oppId];
        List<Contact> conList = [Select c.Id,c.AccountId From Contact c Where c.AccountId =:opptyList[0].AccountId];
        List<Account_Contact_Role_Transaction__c> accContactRole =[Select a.Contact__c, a.Account__c From Account_Contact_Role_Transaction__c a Where a.Account__c  =:account4.Id ];
        
        //Opportunity is created.
        System.assertEquals(true,ext.oppId !=null);
        System.assertEquals(account4.Id,opptyList[0].AccountId);
        System.assertEquals(0,conList.size());
        System.assertEquals(0,accContactRole.size());   //When a new Opportunity is created,Then Account is associated to the contact thus a new ACRT record is created.
        
    }
    //Creating Test Data.
    static void createTestData() {
        
        //Creating Custom Settings.
        UTIL_TestFactory.setupOrg();

        //Getting the Convert Status,That will be used during lead convert process.
        leadStatus = [Select Id, MasterLabel,IsConverted From LeadStatus where IsConverted =true Limit 1];
         
        //Creating Accounts.
        account1 = new Account();       //Account of record type Worksite.
        account2 = new Account();       //Account of record type Worksite,associate to contact.  
        account3 = new Account();       //Account of record type as Person account.
        account4 = new Account(); 		//Worksite Account RecordType,Acc associated to no Contact,So No ACRT(Account Contact Role Transaction should be created)
        
        //Worksite Account RecordType
        account1 = UTIL_TestFactory.createAccount();
        account1.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        account1.External_Provider_Party_ID__c = '#111#';
        account1.Corporate_Registration_Number__c = '25508343';
        account1.Name = 'testComp1#';
        insert account1;
        
        //Worksite Account RecordType,Associated to Contact.
        account2 = UTIL_TestFactory.createAccount();
        account2.RecordTypeId = UTIL_Meta.getAccountPostNordOrgStructureRT();
        account2.External_Provider_Party_ID__c = '#121123#';
        account2.Corporate_Registration_Number__c = '25508343';
        account2.Name = 'testCom2#';
        insert account2;
        
        //Person Account RecordType.
        account3 = UTIL_TestFactory.createPersonAccount();
        account3.RecordTypeId = UTIL_Meta.getPersonAccountRT();
        account3.FirstName = 'testComp4#';
        insert account3;
        
        //Worksite Account RecordType,Acc associated to no Contact,So No ACRT(Account Contact Role Transaction should be created)
        account4 = UTIL_TestFactory.createAccount();
        account4.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        account4.External_Provider_Party_ID__c = '#1115#';
        account4.Corporate_Registration_Number__c = '25508343';
        account4.Name = 'testComp1#';
        insert account4;
        
        //Creating Contacts.
        contact1 = new Contact();   //Contact to be used in the Lead_Identifier__c while creating lead.
        contact2 = new Contact();   //Contact having the same First Name & Last Name as of Lead.
        
        //Contact: To be populated in the Lead_Identifier__c field while creating lead,it should be of RecordType PostNordEmployee & related to Account of type AccountPostNordOrgStructureRT.
        contact1 = new Contact();
        contact1 = UTIL_TestFactory.createContact();
        contact1.RecordTypeId = UTIL_Meta.getContactPostNordEmployeeRT();
        contact1.External_Provider_Party_ID__c = '67123';
        contact1.AccountId = account2.Id;
        contact1.FirstName = 'testFName testLName';
        contact1.LastName = 'testFName testLName';
        insert contact1;
        
        //Contact: Having the same First Name & Last Name as of Lead.
        contact2 = new Contact();
        contact2 = UTIL_TestFactory.createContact();
        contact2.RecordTypeId = UTIL_Meta.getContactPersonRT();
        contact2.External_Provider_Party_ID__c = '681234';
        contact2.AccountId = account1.Id;
        contact2.FirstName = 'testFName';
        contact2.LastName = 'testFName';
        insert contact2;
        
        //Creating Lead with leadToConvert.Account__c empty.
        lead = new Lead();
        lead.City = 'testCity';
        lead.Address_City__c = 'testCity';
		lead.Address_Country__c = 'DK';
        lead.Short_Description__c = 'testShortDescription';
        lead.LastName = 'testLName';
        lead.FirstName = 'testFName';
        lead.Lead_Identifier__c = contact1.Id;
        lead.Product_Interest__c = 'testProductInterest';
        lead.Company = 'testComp';
        insert lead;
        
        //Creating Lead with leadToConvert.Account__c populated.
        lead0 = new Lead();
        lead0.City = 'testCity';
        lead0.Address_City__c = 'testCity';
		lead0.Address_Country__c = 'DK';
        lead0.Short_Description__c = 'testShortDescription';
        lead0.LastName = 'testLName';
        lead0.FirstName = 'testFName';
        lead0.Lead_Identifier__c = contact1.Id;
        lead0.Product_Interest__c = 'testProductInterest';
        lead0.Account__c = account4.Id;
        insert lead0;
    }

}