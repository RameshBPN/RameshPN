/**
    About
    -----
    Description: This class is used to test G2O_Account_SVC. This is part 1 of 2 of the G2O_Account_SVC tests.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    1. extAddupdate_BeforeUpdate_Test - Test the update Extension Addresses on WorkSite Update functionality of Account_SVC class.
    2. testCopyAccountTeamMembersBulk - Bulk test of copyAccountTeamMembers
    3. manageFunctionalInboxesTest - Test manageFunctionalInboxes functionality, Copies FunctionalInboxEmail of account on the related contacts.
    4. createSalesAreaInformationMassRecord - Create Sales Area Information
    5. updateNoChangeNoPARId - No PAR Id, so it should not go in the trigger 
    6. testexternalPartyConnectExistingChildRecordsAfterInsert - copies the new Account Id to accounts where PAR Parent ID equals PAR ID after insert.
    7. testexternalPartyConnectExistingParentRecordsAfterInsert - copies the new Account Id to accounts where PAR ID equals PAR Parent ID after insert.
    8. testexternalPartyConnectExistingChildRecordsUpdateBeforeUpdate - copies the new Account Id to accounts where PAR Parent ID equals PAR ID and removes children connection if any
    9. testexternalPartyConnectExistingParentRecordsBeforeUpdate - copies the new Account Id to accounts where PAR ID equals PAR Parent ID before update
    10. updateMixResultsForParentId - Update some records where Parent PAR Id is matching
    11. testSearchFirstNaming_B2B - Test the create short name function for B2B
    12. testSearchFirstNaming_B2C - Test the create short name function for B2C
    13. insertWsOnExistingLe - tests that when inserting a new WS to an existing LE the account teams should be copied from the LE to the new WS
    14. testSynchProjectFieldsBetweenWSwithLE - 
    15. testSetProjectFieldsOnWsWithParentChange - 
    16. createSalesAreaInformationSingleRecord - Insert one Sales Area Information
    17. noSalesAreaCreatedForIntegrationUser - No sales Area information is created for Integration User
    18. testDeleteInvolvedPartyIdRecord - 
    19. MaintainExtAdd_Test - Test the update Extension Addresses on WorkSite Update.
    20. checkAccountAddressOverwrite - Testing that an intergration user can't overwrite the address on an account if the 'do not overwrite' checkbox is set
    21. updateExtAddOnExtInsert_Test - Test the functionality of updating of extension address from worksite to extension on extension creation.

    Update History
    --------------
    Created March 2013 - A.B.
    Updated May 2013 - R.M.
    Updated March 2014 - T.R.
    
    Issues / TODOs
    --------------
*/
@isTest
private  class G2O_Account_SVC_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static list<Account> lstLegalEntityAcc = new list<Account>();
    static List<Account> lstWorksiteAcc = new list<Account>();
    static List<Account> accountlst;
    static Account legalEntityRec;
    static Account extensionRec; 	//Record to be set as a Possible_Duplicate_Account__c for testing flagToRecheckDuplicates functionality.
    static Account workSiteRec; 	//Record to be set as a ParentId.
    static Account accountPAR;
    static Account objAcc;
    
    static Id extrTypeId;
    static Id wrkrTypeId;
    static Id lerTypeId;
    static String RecordTypeLegalEntity;
    static String RecordTypeWorkSite = UTIL_Meta.getAccountWorksiteRT();
    
    static List<sObject> lstWkAcc = new List<sObject>();
    static List<sObject> lstExAcc = new List<sObject>();
    static User usr;
    static List<Schema.FieldSetMember> fieldSet1 = new List<Schema.FieldSetMember>();
    
    //A.T.T.R.I.B.U.T.E.S

    //1. Test the update Extension Addresses on WorkSite Update functionality of Account_SVC class.
    static testMethod void extAddupdate_BeforeUpdate_Test(){
        
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
        
        // Arrange
        createData();
        
        //Get the Parent LE and set the VAT Number to match the new WS value
		String queryLE = 'SELECT Id From Account WHERE Id =\'' + lstWkAcc[0].get('ParentId') + '\'';
		Account LE = Database.query(queryLE);
		LE.VAT_Number__c = '##0000##';
		update LE;
        
        for (Integer j = 0; j <lstWkAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldAPIName = fieldSet[i].getFieldPath();
                if(String.valueOf(fieldSet[i].getType()).equalsIgnoreCase('STRING')){
                    lstWkAcc[j].put(fieldAPIName,'##0000##');
                }
            }
        }
        
        // Act
        Test.startTest();
        update lstWkAcc;    //Updating the WS.
        Test.stopTest();
        
        //************USE CASE1:Do Not update Flag = false,Fields get copied from WS To Extension******************
        String query = 'SELECT ';
        for(Integer i=0; i<fieldSet.size(); i++) {  
            query += fieldSet[i].getFieldPath() +',';
        }
        query += ' Id From Account';
        query += ' WHERE '; 
        query += 'ParentId =\''+lstWkAcc[0].Id+'\'';
        
        system.debug(Logginglevel.INFO,'+++lstWkAcc[0].Id+++'+lstWkAcc[0].Id);
        List<Account> extensionAccRec0 = new List<Account> ();
        extensionAccRec0 = Database.query(query);
        
        system.debug(Logginglevel.INFO,'++extensionAccRec0++'+extensionAccRec0[0].Id);
        
        for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldName = fieldSet[i].getFieldPath();
                
                system.debug(Logginglevel.INFO,'Fields1+++'+fieldSet[i].getFieldPath());
                system.debug(Logginglevel.INFO,'Fields2+++'+extensionAccRec0[0].get(fieldSet[i].getFieldPath()));
                if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
                    System.assertEquals('##0000##',extensionAccRec0[0].get(fieldSet[i].getFieldPath()));
                }
        }
        
        //************USE CASE2:Do Not update Flag = true,Fields are not copied from WS To Extension****************** 
        String query0 = 'SELECT ';
        for(Integer i=0; i<fieldSet.size(); i++) {  
            query0 += fieldSet[i].getFieldPath() +',';
        }
        query0 += ' Id,Do_Not_Update_Address_Automatically__c From Account';
        query0 += ' WHERE '; 
        query0 += 'ParentId =\''+lstWkAcc[150].Id+'\'';
        
        List<Account> extensionAccRec1 = new List<Account> ();
        extensionAccRec1 = Database.query(query0);
        
        for(Integer i=0; i<fieldSet.size(); i++) {
            
            String fieldName = fieldSet[i].getFieldPath();
            

            //WorkSite & Extension Address same as index0 Do Not update Flag is set as false.
            if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
            
            system.debug(Logginglevel.INFO,'Fields12+++'+fieldSet[i].getFieldPath());
            system.debug(Logginglevel.INFO,'Fields22+++'+extensionAccRec1[0].get(fieldSet[i].getFieldPath()));
            	
            	if(fieldSet[i].getFieldPath().containsIgnoreCase('VAT_Number__c')){
                	System.assertEquals('DK34943400',extensionAccRec1[0].get(fieldSet[i].getFieldPath()));
            	}
            	else{
                	System.assertEquals('##9999##',extensionAccRec1[0].get(fieldSet[i].getFieldPath()));
            	}
            }
        }
    }

    //2. Bulk test of copyAccountTeamMembers
    static testMethod void testCopyAccountTeamMembersBulk(){
        
        // Arrange
        UTIL_TestFactory.setUpOrg();
        
        // Creates 201 users
        List<User> userList = new List<User>();
        
        for(Integer i = 0; i < 20;i++) {
            String userName = i+'accountTeamMember@test.com';
                User user = UTIL_TestFactory.createUser(userName, 'Standard User');
                userList.add(user);
            }
            
        insert userList;
        
        // Creates 201 accounts
        List<Account> legalEnityList = UTIL_TestFactory.createAccounts();

        for (Account LE : legalEnityList) {
            LE.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        }
        
        insert legalEnityList;
        
        List<AccountTeamMember> accountTeamMemberList = new  List<AccountTeamMember>();
        
        // Adds 20 ATM for every LE
        for(Account LE: legalEnityList) {
            for(Integer i = 0; i < 20; i++) {
                AccountTeamMember accountTeamMember = new AccountTeamMember();
                accountTeamMember.AccountId = LE.id;
                accountTeamMember.UserId = userList[i].Id;
                accountTeamMember.TeamMemberRole = 'Role';
                accountTeamMemberList.add(accountTeamMember);
            }
        }
        
        insert accountTeamMemberList;
        
        // Creates 201 accounts
        List<Account> workSiteList = UTIL_TestFactory.createAccounts();
        
        
        // Adds one LE for every WS
        for (Account WS : workSiteList) {
            Integer n = 0;
            WS.RecordTypeId = RecordTypeWorkSite;
            WS.ParentId = legalEnityList[n].Id;
            n++;
        }

        // Act
        Test.startTest();
        insert workSiteList;
        Test.stopTest();
        
        // Assert
        Integer copiedAccountTeamMembers = [SELECT COUNT() FROM AccountTeamMember WHERE AccountId IN :workSiteList];
                                                   
        System.assertEquals(4020, copiedAccountTeamMembers); // 201*20 = 4020

    }
    
    //3. Test manageFunctionalInboxes functionality, Copies FunctionalInboxEmail of account on the related contacts.
    static testMethod void manageFunctionalInboxesTest(){
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
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
        
        //Act
        
        Test.startTest();
        testAcc1.Functional_Inbox_Email__c = 'inboxno@cg.com';
        update testAcc1;
        Test.stopTest();
        
        system.debug(Logginglevel.INFO,'++23++'+testAcc1.Functional_Inbox_Email__c);
        //Assert
        System.assertEquals(testAcc1.Functional_Inbox_Email__c, [Select c.Id,c.RecordTypeId, c.Is_Org_Unit_Contact__c, c.Email From Contact c Where c.AccountId =:testAcc1.Id 
                                    AND c.Is_Org_Unit_Contact__c = true AND c.RecordTypeId=:rTypeIdPNContact].Email);
    }
    

    //4. Create Sales Area Information
    static testMethod void createSalesAreaInformationMassRecord() { 
        
        // Use Case: Insert Mass Sales Area Information   
        UTIL_TestFactory.setUpOrg();
        User u1 = [SELECT Id, Sales_Area1__c FROM User WHERE Profile.Name =: 'System Administrator' AND IsActive=: true AND Sales_Area1__c != null limit 1];

        System.RunAs(u1){
            
            List<Account> accountList = new List<Account>();
            Set<Id> setAccount = new Set<Id>();
            
            String strRT = UTIL_Meta.getAccountWorksiteRT();
            
            Test.startTest();
            
            for(Integer i=0; i < 100; i++) {
                Account objAcc1 = new Account();
                objAcc1 = UTIL_TestFactory.createAccount();
                objAcc1.RecordTypeId = strRT;
                accountList.add(objAcc1);
            }
            
            insert accountList; // inserting accounts
            
            Test.stopTest();
            
            for(Account acc: accountList) {
                setAccount.add(acc.Id); // putting in a set
            }
            
            List<Sales_Area_Information__c> lstSalesInfo = [Select Id, Name, Sales_Area__c, Is_First_SAI__c from Sales_Area_Information__c where Account__c IN: setAccount]; // checking Sales Area Information created 
            
            // Assert
            System.assertEquals(lstSalesInfo.size(), 100);
            System.assertEquals(lstSalesInfo[75].Sales_Area__c, u1.Sales_Area1__c);
            System.assertEquals(true, lstSalesInfo[75].Is_First_SAI__c, 'The SAI was created by the Account trigger and Created_With_Account should be true');
        }
    }
    
   //5. No PAR Id, so it should not go in the trigger 
   static testMethod void updateNoChangeNoPARId() {    
 
        // Arrange
        init(); 
        
        // Act
        for(Integer i = 0; i < 200 ; i ++){
            Account objAccParent = UTIL_TestFactory.createAccount();
            objAccParent.Name = 'Test name' + i;
            objAccParent.RecordTypeId = RecordTypeWorkSite;
            objAccParent.External_Provider_Party_Parent_ID__c = '98733';
            accountlst.add(objAccParent);
        }
        insert accountlst;
       
        insert accountPAR;   
        
        accountlst = [Select Id, External_Provider_Party_ID__c, External_Provider_Party_Parent_ID__c, ParentId from Account where External_Provider_Party_Parent_ID__c =: '98733'];
        
        // Assert
        System.assertEquals(accountlst[0].ParentId, null);
        System.assertNotEquals(accountlst[1].External_Provider_Party_Parent_ID__c, accountPAR.External_Provider_Party_ID__c);     
    }
    
    // 6. copies the new Account Id to accounts where PAR Parent ID equals PAR ID.
   static testMethod void testexternalPartyConnectExistingChildRecordsAfterInsert() {
        
        // Use Case: when a Parent PAR id is inserted, a check is done on PAR Id if it has that Parent PAR id, if yes, assigns account of Parent PAR Id to Parent Id.
        
        // Arrange
        init();
        
        // ACT
        Account accountParent = UTIL_TestFactory.createAccount();
        accountParent.Name = 'Test name';
        accountParent.RecordTypeId = RecordTypeWorkSite;
        accountParent.External_Provider_Party_ID__c = '74987438739873';
        accountlst.add(accountParent);
        
        Account accountParent1 = UTIL_TestFactory.createAccount();
        accountParent1.Name = 'Test name1';
        accountParent1.RecordTypeId = RecordTypeWorkSite;
        accountParent1.External_Provider_Party_ID__c = '98393879';
        accountlst.add(accountParent1);
        
        Account accountParent2 = UTIL_TestFactory.createAccount();
        accountParent2.Name = 'Test name2';
        accountParent2.RecordTypeId = RecordTypeWorkSite;
        accountParent2.External_Provider_Party_ID__c = '979387983';
        accountlst.add(accountParent2);
        
        insert accountlst;
        
        
        Test.startTest();
        
        accountPAR.External_Provider_Party_Parent_ID__c = '74987438739873';
        insert accountPAR;  
         
        Test.stopTest();
        
        accountlst = [Select Id, External_Provider_Party_ID__c, External_Provider_Party_Parent_ID__c, ParentId from Account where External_Provider_Party_ID__c =: '74987438739873'];
        Integer noOfParentIdRecordsUpdated = [Select COUNT() from Account where External_Provider_Party_ID__c =: accountPAR.External_Provider_Party_Parent_ID__c];
        
        
        // Assert
        System.assertEquals(1, noOfParentIdRecordsUpdated);
        System.assertEquals(accountlst[0].ParentId, accountPAR.Id);
        System.assertEquals(accountlst[0].External_Provider_Party_Parent_ID__c, accountPAR.External_Provider_Party_ID__c);
         
    }
    
    // 7. copies the new Account Id to accounts where PAR ID equals PAR Parent ID.
    static testMethod void testexternalPartyConnectExistingParentRecordsAfterInsert() {
        
        // Use Case: when a PAR id is inserted, a check is done on PARENT PAR Id has that PAR id, if yes, assigns account of PAR Id to Parent Id.
        
        // Arrange
        init();
        
        // ACT
        for(Integer i = 0; i < 200 ; i ++){
            Account accountChild = UTIL_TestFactory.createAccount();
            accountChild.Name = 'Test name' + i;
            accountChild.RecordTypeId = RecordTypeWorkSite;
            accountChild.External_Provider_Party_Parent_ID__c = '98733';
            accountlst.add(accountChild);
        }
        insert accountlst;
       
        accountPAR.External_Provider_Party_ID__c = '98733';
        insert accountPAR;   
        
        accountlst = [Select Id, External_Provider_Party_ID__c, External_Provider_Party_Parent_ID__c, ParentId from Account where External_Provider_Party_Parent_ID__c =: '98733'];
        Integer noOfParentIdRecordsUpdated = [Select COUNT() from Account where External_Provider_Party_Parent_ID__c =: accountPAR.External_Provider_Party_ID__c];
        
        
        // Assert
        System.assertEquals(200, noOfParentIdRecordsUpdated);
        System.assertEquals(accountlst[0].ParentId, accountPAR.Id);
        System.assertEquals(accountlst[1].External_Provider_Party_Parent_ID__c, accountPAR.External_Provider_Party_ID__c);
         
    }
    
    //8. copies the new Account Id to accounts where PAR Parent ID equals PAR ID and removes children connection if any
    static testMethod void testexternalPartyConnectExistingChildRecordsUpdateBeforeUpdate() {
        
        // Use Case: copies the new Account Id to accounts where PAR Parent ID equals PAR ID and removes children connection if any
        
        // Arrange
        init();
        
        // ACT
        //Creating Child records with External_Provider_Party_Parent_ID__c = '98733'.
        for(Integer i = 0; i < 200 ; i ++){
            Account accountChild = UTIL_TestFactory.createAccount();
            accountChild.Name = 'Test name' + i;
            accountChild.RecordTypeId = RecordTypeWorkSite;
            accountChild.External_Provider_Party_Parent_ID__c = '98733';
            accountlst.add(accountChild);
        }
        insert accountlst;
       
       //Creating parent record with External_Provider_Party_ID__c = '98733'.
        accountPAR.External_Provider_Party_ID__c = '98733';
        insert accountPAR;   
        
        //Creating one more set of child records with External_Provider_Party_Parent_ID__c = '87474'.
        List<Account> accountUpdate = new List<Account>();
        for(Integer x = 0; x < 200 ; x ++){
            Account accountChild = UTIL_TestFactory.createAccount();
            accountChild.Name = 'Test name' + x;
            accountChild.RecordTypeId = RecordTypeWorkSite;
            accountChild.External_Provider_Party_Parent_ID__c = '87474';
            accountUpdate.add(accountChild);
        }
        insert accountUpdate;
        
        //Updating the parent record External_Provider_Party_ID__c from  '98733' To 87474'.
        accountPAR.External_Provider_Party_ID__c = '87474';
        update accountPAR;
        
        accountlst = [Select Id, External_Provider_Party_ID__c, External_Provider_Party_Parent_ID__c, ParentId from Account where External_Provider_Party_Parent_ID__c =: '98733'];
        accountUpdate = [Select Id, External_Provider_Party_ID__c, External_Provider_Party_Parent_ID__c, ParentId from Account where External_Provider_Party_Parent_ID__c =: accountPAR.External_Provider_Party_ID__c];
        Integer noOfParentIdRecordsUpdated = [Select COUNT() from Account where External_Provider_Party_Parent_ID__c =: accountPAR.External_Provider_Party_ID__c];
        
        // Assert
        System.assertEquals(200, noOfParentIdRecordsUpdated);
        System.assertEquals(accountlst[0].ParentId, null);
        System.assertEquals(accountUpdate[1].External_Provider_Party_Parent_ID__c, accountPAR.External_Provider_Party_ID__c); 
        System.assertEquals(accountUpdate[10].ParentId, accountPAR.Id); 
    }
    
    // 9. copies the new Account Id to accounts where PAR ID equals PAR Parent ID before update.
    static testMethod void testexternalPartyConnectExistingParentRecordsBeforeUpdate() {
        
        // Use Case: when a Parent PAR id is updated, a check is done on PAR Id if it has that Parent PAR id, if yes, assigns account of Parent PAR Id to Parent Id.
        
        // Arrange
        init();
        
        // ACT
        
        // insert accounts with PAR Ids
        Account accountParent = UTIL_TestFactory.createAccount();
        accountParent.Name = 'Test name';
        accountParent.RecordTypeId = RecordTypeWorkSite;
        accountParent.External_Provider_Party_ID__c = '74987438739873';
        accountlst.add(accountParent);
        
        Account accountParent1 = UTIL_TestFactory.createAccount();
        accountParent1.Name = 'Test name1';
        accountParent1.RecordTypeId = RecordTypeWorkSite;
        accountParent1.External_Provider_Party_ID__c = '98393879';
        accountlst.add(accountParent1);
                
        insert accountlst;
        
        // insert account with Parent PAR Id
        accountPAR.External_Provider_Party_Parent_ID__c = '74987438739873';
        insert accountPAR; 
        
        // update account 
        accountPAR.External_Provider_Party_Parent_ID__c = '98393879';
        update accountPAR; 
        
        accountlst = [Select Id, External_Provider_Party_ID__c, External_Provider_Party_Parent_ID__c, ParentId from Account where External_Provider_Party_ID__c =: '98393879'];
        Integer noOfParentIdRecordsUpdated = [Select COUNT() from Account where External_Provider_Party_ID__c =: accountPAR.External_Provider_Party_Parent_ID__c];
        
        // Assert
        System.assertEquals(1, noOfParentIdRecordsUpdated);
        System.assertEquals(accountlst[0].ParentId, accountPAR.Id);
        System.assertEquals(accountlst[0].External_Provider_Party_Parent_ID__c, accountPAR.External_Provider_Party_ID__c);
         
    }
    
    // 10. Update some records where Parent PAR Id is matching
    static testMethod void updateMixResultsForParentId() {      
        
        // Use case: Update some records where Parent PAR Id is matching
           
        // Arrange
       	init(); 
        
        
        // ACT
        for(Integer i = 0; i < 10 ; i ++){
            Account objAccParent = UTIL_TestFactory.createAccount();
            objAccParent.Name = 'Test name' + i;
            objAccParent.RecordTypeId = RecordTypeWorkSite;
            if(i == 0 || i < 5) {
                objAccParent.External_Provider_Party_Parent_ID__c = '98733';
            } else {
                objAccParent.External_Provider_Party_Parent_ID__c = '387397';
            }
            accountlst.add(objAccParent);
        }
        insert accountlst;
       
        accountPAR.External_Provider_Party_ID__c = '98733';
        insert accountPAR; 
        
        accountlst = [Select Id, External_Provider_Party_ID__c, External_Provider_Party_Parent_ID__c, ParentId from Account where External_Provider_Party_Parent_ID__c =: '98733'];
        System.debug('@@ lstAcc @@' +accountlst.size()+ accountlst);
        Integer noOfParentIdRecordsUpdated = [Select COUNT() from Account where External_Provider_Party_Parent_ID__c =: accountPAR.External_Provider_Party_ID__c];
        
        
        // Assert
        System.assertEquals(5, noOfParentIdRecordsUpdated);
        System.assertEquals(accountlst[4].ParentId, accountPAR.Id);
    }    
    
    //11. Test the create short name function for B2B
    static testMethod void testSearchFirstNaming_B2B()
    {
        UTIL_TestFactory.setUpOrg();
        Account a = UTIL_TestFactory.createAccount();
        a.Name = 'Something &!*?-;:-_  with &!*?-;:-_ punctuation';
        insert a;
        a = [select id,Name,Metaphone_Primary_Encoding__c,Short_Name__c from Account where id = :a.Id];
        System.assert(a.Name == 'Something &!*?-;:-_  with &!*?-;:-_ punctuation');
        System.assert(a.Short_Name__c == 'Somethingwithpunctuation');
        System.assert(a.Metaphone_Primary_Encoding__c == UTIL_DoubleMetaphone.encode(a.Name));
        
        // Check updating works ok
        a.name = 'Something else entirely.';
        update a;
        a = [select id,Name,Metaphone_Primary_Encoding__c,Short_Name__c from Account where id = :a.Id];
        System.assert(a.Name == 'Something else entirely.');
        System.assert(a.Short_Name__c == 'Somethingelseentirely');
        System.assert(a.Metaphone_Primary_Encoding__c == UTIL_DoubleMetaphone.encode(a.Name));
        
    }
    
    //12. Test the create short name function for B2C
    static testMethod void testSearchFirstNaming_B2C()
    {
        UTIL_TestFactory.setUpOrg();
        Account a = UTIL_TestFactory.createPersonAccount();
        a.FirstName = 'Something &!*?-;:-_';
        a.LastName = 'with &!*?-;:-_ punctuation';
        insert a;
        a = [select id,FirstName,LastName,Metaphone_Primary_Encoding__c,Short_Name__c from Account where id = :a.Id];
        System.assert(a.FirstName == 'Something &!*?-;:-_');
        System.assert(a.LastName == 'with &!*?-;:-_ punctuation');
        System.assert(a.Short_Name__c == 'Somethingwithpunctuation');
        System.assert(a.Metaphone_Primary_Encoding__c == UTIL_DoubleMetaphone.encode(a.FirstName + ' ' + a.LastName));
        
        //Check update works ok
        a.FirstName = 'A';
        a.LastName = 'Something else entirely.';
        update a;
        a = [select id,FirstName,LastName,Metaphone_Primary_Encoding__c,Short_Name__c from Account where id = :a.Id];
        System.assert(a.FirstName == 'A');
        System.assert(a.LastName == 'Something else entirely.');
        System.assert(a.Short_Name__c == 'ASomethingelseentirely');
        System.assert(a.Metaphone_Primary_Encoding__c == UTIL_DoubleMetaphone.encode(a.FirstName + ' ' + a.LastName));
    }
    
    //13. tests that when inserting a new WS to an existing LE the account teams should be copied from the LE to the new WS
    static testMethod void insertWsOnExistingLe() {
        // Arrange
        User user = UTIL_TestFactory.createUser('accountTeamMember1@test.com', 'Standard User');
        insert user;
        
        Account LE = UTIL_TestFactory.createAccount();
        LE.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        insert LE;
        
        AccountTeamMember accountTeamMember = new AccountTeamMember();
        accountTeamMember.AccountId = LE.id;
        accountTeamMember.UserId = user.Id;
        accountTeamMember.TeamMemberRole = 'Role';
        insert accountTeamMember;
        
        Account WS = UTIL_TestFactory.createAccount();
        WS.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        WS.ParentId = LE.Id;
        
        // Act
        Test.startTest();
        insert WS;
        Test.stopTest();
        
        // Assert
        List<AccountTeamMember> accountTeamMemberList = [SELECT Id, AccountId, UserId, TeamMemberRole
                                                   FROM AccountTeamMember
                                                   WHERE AccountId = :WS.Id];
                                                   
        System.assert(accountTeamMemberList.size() == 1,  'The AccountTeamMember din\'t get copied from LE to WS');
        System.assert(accountTeamMemberList[0].UserId == user.Id, 'The correct user was not set');
        System.assert(accountTeamMemberList[0].TeamMemberRole == 'Role', 'The correct role was not set');
    }
    
    // 14.
    static testMethod void testSynchProjectFieldsBetweenWSwithLE(){
         //Creating Testdata.
        createLEandWSAccountData();
        
        // Arrange
        lstLegalEntityAcc[0].Legal_Entity_Primary_Industry__c = 'ABCDEF';
        lstLegalEntityAcc[0].Legal_Entity_Primary_Ind_Group_77__c = '12345';        
        lstLegalEntityAcc[1].Legal_Entity_Primary_Ind_Group_8__c = 'QWERTY';
        lstLegalEntityAcc[1].Legal_Entity_Primary_Ind_Group_77__c = '67890';

        // Act
        Test.StartTest(); 
        update lstLegalEntityAcc;
        Test.StopTest();
        
        //Assert
        for(Account acc : [select id, parentid, Legal_Entity_Primary_Industry__c, Legal_Entity_Primary_Ind_Group_77__c, Legal_Entity_Primary_Ind_Group_8__c from Account where parentid = :lstLegalEntityAcc[0].id OR parentid = :lstLegalEntityAcc[1].id]){
            if(acc.parentId == lstLegalEntityAcc[0].id){
                system.assertEquals('ABCDEF', acc.Legal_Entity_Primary_Industry__c);
                system.assertEquals('12345', acc.Legal_Entity_Primary_Ind_Group_77__c);             
                system.assertEquals(null, acc.Legal_Entity_Primary_Ind_Group_8__c);
            }
            else if(acc.parentId == lstLegalEntityAcc[1].id){
                system.assertEquals(null, acc.Legal_Entity_Primary_Industry__c);
                system.assertEquals('67890', acc.Legal_Entity_Primary_Ind_Group_77__c);             
                system.assertEquals('QWERTY', acc.Legal_Entity_Primary_Ind_Group_8__c);
            }
        }
        
    }

    // 15.
    static testMethod void testSetProjectFieldsOnWsWithParentChange(){
         //Creating Testdata.
        createLeAndWSDataNoDML();
        
		// Arrange
        lstLegalEntityAcc[0].Legal_Entity_Primary_Industry__c = 'ABCDEF';
        lstLegalEntityAcc[0].Legal_Entity_Primary_Ind_Group_77__c = '12345';        
        lstLegalEntityAcc[1].Legal_Entity_Primary_Ind_Group_8__c = 'QWERTY';
        lstLegalEntityAcc[1].Legal_Entity_Primary_Ind_Group_77__c = '67890';
        
        insert lstLegalEntityAcc;
        
        for(Account acc : lstWorkSiteAcc){
        	acc.parentid = lstLegalEntityAcc[0].id;
        }
        
        // Act
        Test.StartTest(); 
        insert lstWorkSiteAcc;
        for(Account acc : [select id, parentid, Legal_Entity_Primary_Industry__c, Legal_Entity_Primary_Ind_Group_77__c, Legal_Entity_Primary_Ind_Group_8__c from Account where recordTypeId = :wrkrTypeId]){
			system.assertEquals('ABCDEF', acc.Legal_Entity_Primary_Industry__c);
            system.assertEquals('12345', acc.Legal_Entity_Primary_Ind_Group_77__c);             
            system.assertEquals(null, acc.Legal_Entity_Primary_Ind_Group_8__c);
        }
		
		for(Account acc: lstWorkSiteAcc){
        	acc.parentid = lstLegalEntityAcc[1].id;			
		}
        Test.StopTest();
        
        //Assert
        for(Account acc : [select id, parentid, Legal_Entity_Primary_Industry__c, Legal_Entity_Primary_Ind_Group_77__c, Legal_Entity_Primary_Ind_Group_8__c from Account where recordTypeId = :wrkrTypeId]){
			system.assertEquals(null, acc.Legal_Entity_Primary_Industry__c);
            system.assertEquals('67890', acc.Legal_Entity_Primary_Ind_Group_77__c);             
            system.assertEquals('QWERTY', acc.Legal_Entity_Primary_Ind_Group_8__c);
        }        
    }
    
    // 16. Insert one Sales Area Information
    static testMethod void createSalesAreaInformationSingleRecord() {

        // Arrange
        salesAreaInit();
             
        // ACT
        User u1 = [SELECT Id, Sales_Area1__c FROM User WHERE ProfileId =: UTIL_Meta.profileId('System Administrator') AND IsActive=: true AND Sales_Area1__c != null limit 1];

        System.RunAs(u1){
            
            insert objAcc;
            objAcc = [SELECT Id, Name, CreatedById FROM Account WHERE CreatedDate = TODAY and CreatedById = :u1.id limit 1];
            
            List<Sales_Area_Information__c> lstSalesInfo = [Select Id, Name, Sales_Area__c from Sales_Area_Information__c where Account__c =: objAcc.Id];
            
            // Assert
            System.assertNotEquals(objAcc.CreatedById, null);
            System.assertEquals(lstSalesInfo.size(), 1);
            System.assertEquals(lstSalesInfo[0].Sales_Area__c, u1.Sales_Area1__c);
        }
        
    }
    
    // 17. No sales Area information is created for Integration User
    static testMethod void noSalesAreaCreatedForIntegrationUser() { 
 
        UTIL_TestFactory.setUpOrg();
        User u1 = [SELECT Id, Sales_Area1__c FROM User WHERE ProfileId =: UTIL_Meta.profileId('Integration User') AND IsActive=: true limit 1];
        

        System.RunAs(u1){
            
            List<Account> accountList = new List<Account>();
            Set<Id> setAccount = new Set<Id>();
            
            for(Integer i=0; i < 100; i++) {
                Account objAcc1 = new Account();
                objAcc1 = UTIL_TestFactory.createAccount();
                objAcc1.RecordTypeId = RecordTypeWorkSite;
                accountList.add(objAcc1);
            }
            
            insert accountList;
            
            for(Account acc: accountList) {
                setAccount.add(acc.Id);
            }
            
            List<Sales_Area_Information__c> lstSalesInfo = [Select Id, Name, Sales_Area__c from Sales_Area_Information__c where Account__c IN: setAccount];
            
            // Assert
            System.assertEquals(lstSalesInfo.size(), 0);
        }
    }
    
    // 18.
    static testMethod void testDeleteInvolvedPartyIdRecord(){
    	//Arrange
        UTIL_TestFactory.setUpOrg();
        
        test.startTest();
        list<Account> accountList = new list<Account>();
        accountList = UTIL_TestFactory.createAccounts();
        set<String> Involved_Party_IDs = new set<String>();
        for(Account acc : accountList){
            acc.External_or_Internal__c = 'External';       
        }
        insert accountList;
        
        //Create a list of Account Ids to send into recycle bin method
        list<Id> accountListIds = new list<Id>();
        for (Account a : accountList){
        	accountListIds.add(a.Id);
        }
        
        //Run an emptyRecycleBin to make sure the recycleBin is already emptied
        try {	
    		UTIL_Apex.emptyRecycleBin(accountListIds);
        } catch (Exception e) {
        	System.debug('Exception: ' + e);
        	System.assert(false, 'An unexpected error was thrown.');
        }
        test.stopTest();

        //Assert
        system.assertEquals(0, [SELECT count() FROM Involved_Party_ID_Range__c]);   
        for(Account acc : [Select id, Involved_Party_ID__c from Account]){
            Involved_Party_IDs.add(acc.Involved_Party_ID__c);
        }
        system.assertEquals(201, Involved_Party_IDs.size());

		List<ApexErrorLog__c> errors = [SELECT Id, Error_Code__c FROM ApexErrorLog__c];
        System.assertEquals(accountList.size(), errors.size(), 'Incorrect number of errors.');
        System.assertEquals('EmptyRecycleBin', errors[0].Error_Code__c, 'Incorrect error code.');
    }
    
    //19. Test the update Extension Addresses on WorkSite Update.
	static testMethod void MaintainExtAdd_Test(){
		
		List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
		fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
		
		fieldSet1 = SObjectType.Account.FieldSets.doNotUpdateFieldsForIntegrationUsers.getFields();
		
		// Arrange
		createMaintainExtData();
		
		//Get the Parent LE and set the VAT Number to match the new WS value
		String queryLE = 'SELECT Id From Account WHERE Id =\'' + lstWkAcc[0].get('ParentId') + '\'';
		Account LE = Database.query(queryLE);
		LE.VAT_Number__c = '##0000##';
		update LE;
		
		for (Integer j = 0; j <lstWkAcc.size(); j++) {
			
			for(Integer i=0; i<fieldSet.size(); i++) {
				String fieldAPIName = fieldSet[i].getFieldPath();
				
				if(String.valueOf(fieldSet[i].getType()).equalsIgnoreCase('STRING')){
					lstWkAcc[j].put(fieldAPIName,'##0000##');
				}
			}
		}
		
		// Act
		Test.startTest();
		update lstWkAcc;
		Test.stopTest();
		
		
		//************USE CASE1******************
		String query = 'SELECT ';
		for(Integer i=0; i<fieldSet.size(); i++) {	
			query += fieldSet[i].getFieldPath() +',';
		}
		query += ' Id From Account';
		query += ' WHERE '; 
		query += 'ParentId =\''+lstWkAcc[0].Id+'\'';
		
		system.debug('+++lstWkAcc[0].Id+++'+lstWkAcc[0].Id);
		List<Account> extensionAccRec0 = new List<Account> ();
		extensionAccRec0 = Database.query(query);
		
		
		for(Integer i=0; i<fieldSet.size(); i++) {
				String fieldName = fieldSet[i].getFieldPath();
				
				system.debug('Fields1+++'+fieldSet[i].getFieldPath());
				system.debug('Fields2+++'+extensionAccRec0[0].get(fieldSet[i].getFieldPath()));
				//WorkSite & Extension Address same as index0 Do Not update Flag is set as false.
				if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
					System.assertEquals('##0000##',extensionAccRec0[0].get(fieldSet[i].getFieldPath()));
				}
		}
		
		//************USE CASE2****************** 
		String query0 = 'SELECT ';
		for(Integer i=0; i<fieldSet.size(); i++) {	
			query0 += fieldSet[i].getFieldPath() +',';
		}
		query0 += ' Id,Do_Not_Update_Address_Automatically__c From Account';
		query0 += ' WHERE '; 
		query0 += 'ParentId =\''+lstWkAcc[1].Id+'\'';
		
		system.debug('+++lstWkAcc[1].Id+++'+lstWkAcc[1].Id);
		List<Account> extensionAccRec1 = new List<Account> ();
		extensionAccRec1 = Database.query(query0);
		
		for(Integer i=0; i<fieldSet.size(); i++) {
			
			String fieldName = fieldSet[i].getFieldPath();
			

			//WorkSite & Extension Address same as index0 Do Not update Flag is set as false.
			if(String.valueOf(fieldSet[i].getType()) == 'STRING'){			
				for(Integer j=0; j<fieldSet1.size(); j++){
					if(fieldSet[i].getFieldPath() == fieldSet1[j].getFieldPath()){
						System.assertEquals('##9999##',extensionAccRec1[0].get(fieldSet[i].getFieldPath()), fieldSet[i].getFieldPath());
					}
				}				
			}
		} 
	}

	// 20. Testing that an intergration user can't overwrite the address on an account if the 'do not overwrite' checkbox is set
	static testMethod void checkAccountAddressOverwrite() {
        User u = UTIL_TestFactory.createIntegrationUser('user54234523453@acme.com');
        System.runAs(u)
        {
            Account a = UTIL_TestFactory.createAccount();
            a.Visiting_Address_City__c = 'apples';
            insert a;
            a.Do_Not_Update_Address_Automatically__c = true;
            update a;
            a.Visiting_Address_City__c = 'bananas';
            update a;
            a = [select id,Visiting_Address_City__c from Account where id=:a.id];
            System.assert(a.Visiting_address_City__c == 'apples','The account address should not be allowed to be updated if the "Do not update" flag is checked');
        }
    }
    
    //21. Test the functionality of updating of extension address from worksite to extension on extension creation.
    static testMethod void updateExtAddOnExtInsert_Test(){
		
		// Arrange
		createDataForUpdateExtAddOnExtInsert();
		
		insert lstExAcc;
		
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
		fieldSet1 = SObjectType.Account.FieldSets.doNotUpdateFieldsForIntegrationUsers.getFields();
		                
        //************UseCase1: Fields get copied from WS To Extension******************
        String query = 'SELECT ';
        for(Integer i=0; i<fieldSet.size(); i++) {  
            query += fieldSet[i].getFieldPath() +',';
        }
        query += ' Id From Account';
        query += ' WHERE '; 
        query += 'ParentId =\''+lstWkAcc[10].Id+'\'';
        
        List<Account> extensionAccRec10 = new List<Account> ();
        extensionAccRec10 = Database.query(query);
        
        system.debug(Logginglevel.INFO,'++extensionAccRec10++'+extensionAccRec10[0].Id);
        
        for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldName = fieldSet[i].getFieldPath();
               
                //WorkSite & Extension Address same as index0 Do Not update Flag is set as false.
                if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
                    System.assertEquals('#00#',extensionAccRec10[0].get(fieldSet[i].getFieldPath()));
                }
        }
        
        
    	//************UseCase2: Fields not copied from WS To Extension as Do Not Update Flag is set as true on Extension******************
        String query0 = 'SELECT ';
        for(Integer i=0; i<fieldSet.size(); i++) {  
            query0 += fieldSet[i].getFieldPath() +',';
        }
        query0 += ' Id From Account';
        query0 += ' WHERE '; 
        query0 += 'ParentId =\''+lstWkAcc[0].Id+'\'';
        
        List<Account> extensionAccRec0 = new List<Account> ();
        extensionAccRec0 = Database.query(query0);
        
        system.debug(Logginglevel.INFO,'++extensionAccRec0++'+extensionAccRec0[0].Id);
        
        for(Integer i=0; i<fieldSet.size(); i++) {			
			for(Integer j=0; j<fieldSet1.size(); j++){
				if(fieldSet[i].getFieldPath() == fieldSet1[j].getFieldPath()){
			        //WorkSite & Extension Address same as index0 Do Not update Flag is set as false.
			        if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
			            System.assertEquals('#11#',extensionAccRec0[0].get(fieldSet[i].getFieldPath()), fieldSet[i].getFieldPath() + ' ' + extensionAccRec0[0]);
			        }					
				}
			}	       
        }
	}
	
	//creating test data.
	private static void createDataForUpdateExtAddOnExtInsert() {
		
		UTIL_TestFactory.setUpOrg();
		
		wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
		extrTypeId= UTIL_Meta.getAccountExtensionRT();
		lerTypeId  = UTIL_Meta.getAccountLegalEntityRT();
		
		//***Creating Legal Entity****
        Account legalEntity = UTIL_TestFactory.createAccount();
        legalEntity.RecordTypeId = lerTypeId;
        legalEntity.Postal_Address_Country__c = 'BA';
        legalEntity.Registration_Country__c = 'BA';
        legalEntity.VAT_Number__c = '#00#';
        insert legalEntity;
		
		//Getting the fields from FieldSet that need to be copied from WorkSites To Extensions.
		List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
		fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();	
			
		//Inserting accounts with RecordType as Work_Site
		//lstWorksiteAcc = UTIL_TestFactory.createAccounts();
		lstWorksiteAcc = new List<Account>();   
        for (Integer i = 0; i < 199; i++) {
        	sObject accRec    = UTIL_TestFactory.createAccount();
        	accRec.put('ParentId', legalEntity.Id);
        	accRec.put('Postal_Address_Country__c','BA');
        	accRec.put('Registration_Country__c','BA');
        	accRec.put('RecordTypeId',wrkrTypeId);
            if(i == 10){
                accRec.put('Do_Not_Update_Address_Automatically__c',true); //If WorkSite Do_Not_Update_Address_Automatically__c is set to true,it should not impact copying of Add to Extensions.
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',false);
            }
            lstWkAcc.add(accRec);
        }

        for (Integer j = 0; j <lstWkAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldAPIName = fieldSet[i].getFieldPath();
                if(String.valueOf(fieldSet[i].getType()).equalsIgnoreCase('STRING')){
                    lstWkAcc[j].put(fieldAPIName,'#00#');
                    lstWkAcc[j].put('Name','#00#');
                }
            }
        }
		
		insert lstWkAcc;
		
		//Update all SAIs on WSs to Customer to pass Extension validation rule
        List<Sales_Area_Information__c> wsSAIs = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c IN: lstWkAcc];
        for (Sales_Area_Information__c SAI : wsSAIs) {
        	SAI.Type__c = 'Customer';
        }
        update wsSAIs;
		
        //***Creating Extensions****
        for(Integer i = 0; i < 199; i++){
            
            sObject accRec    = UTIL_TestFactory.createAccount();
            accRec.put('Postal_Address_Country__c', 'BA');
            accRec.put('Registration_Country__c','BA');
            accRec.put('RecordTypeId',extrTypeId);
            accRec.put('ParentId',lstWkAcc[i].Id);
            
            if(i < 10){
                accRec.put('Do_Not_Update_Address_Automatically__c',true);
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',false);
            }
            lstExAcc.add(accRec);
        }
        
        for (Integer j = 0; j <lstExAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldAPIName = fieldSet[i].getFieldPath();
                if(String.valueOf(fieldSet[i].getType()).equalsIgnoreCase('STRING')){
                	lstExAcc[j].put('Name','#11#');
                    lstExAcc[j].put(fieldAPIName,'#11#');
                }
            }
        }
	}
    
    /*
    * DATA CONSTRUCTORS
    */
    private static void init() { 
        UTIL_TestFactory.setUpOrg();
        RecordTypeLegalEntity = UTIL_Meta.getAccountLegalEntityRT();
        RecordTypeWorkSite = UTIL_Meta.getAccountWorksiteRT();
        
        accountPAR = new Account();
        accountPAR = UTIL_TestFactory.createAccount();
        accountPAR.RecordTypeId = RecordTypeLegalEntity;
        
        accountlst = new list<Account>();
    }
    
    private static void salesAreaInit() {    
        
        UTIL_TestFactory.setUpOrg();
        objAcc = new Account();
        objAcc = UTIL_TestFactory.createAccount();
        objAcc.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        
    }
        
    //creating test data.
    private static void createData() {
        
        UTIL_TestFactory.setUpOrg();
        
        usr = UTIL_TestFactory.createAdmin('test@get2One.com');
        
        wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
        extrTypeId = UTIL_Meta.getAccountExtensionRT();
        lerTypeId  = UTIL_Meta.getAccountLegalEntityRT();
        
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
        
        //***Creating Legal Entity****
        Account legalEntity = UTIL_TestFactory.createAccount();
        legalEntity.RecordTypeId = lerTypeId;
        legalEntity.Postal_Address_Country__c = 'BA';
        legalEntity.Registration_Country__c = 'BA';
        legalEntity.VAT_Number__c = 'DK34943400';
        
        //Possible duplicate LE
        legalEntityRec = UTIL_TestFactory.createAccount();
        legalEntityRec.RecordTypeId = lerTypeId;
        
        //Put the LEs in a list to keep down the SOQL queries
        List<Account> listOfLegalEntites = new List<Account>();
        listOfLegalEntites.add(legalEntity);
        listOfLegalEntites.add(legalEntityRec);
        insert listOfLegalEntites;
        
        //***Creating Work Sites****
        for(Integer i = 0; i < 199; i++){
            
            String externalProviderId = String.ValueOf('22:7654'+i);
            sObject accRec    = UTIL_TestFactory.createAccount();
            accRec.put('ParentId', legalEntity.Id);
            accRec.put('RecordTypeId',wrkrTypeId);
            accRec.put('External_Provider_Party_ID__c',externalProviderId);
            
            if(i < 100){
                accRec.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',true);//Setting the Do not update Address fields.
            }
            lstWkAcc.add(accRec);
        }
        
        for (Integer j = 0; j <lstWkAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldAPIName = fieldSet[i].getFieldPath();
                
                system.debug(Logginglevel.INFO,'+++lstWorksiteAcc77+++'+(fieldSet[i].getType()));
                if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
					lstWkAcc[j].put('Postal_Address_Country__c','BA');
					lstWkAcc[j].put('Registration_Country__c','BA');
                    lstWkAcc[j].put(fieldAPIName,'##7777##');
                    lstWkAcc[j].put('Name','##7777##');                    
					lstWkAcc[j].put('VAT_Number__c', 'DK34943400');
                }
            }   
        }
        
        //Possible Duplicte WS. To be set as a parent Account.
        workSiteRec =  UTIL_TestFactory.createAccount();
        workSiteRec.RecordTypeId = wrkrTypeId;
        workSiteRec.ParentId = legalEntityRec.Id;
        
      	//Put the WSs in a list to keep down the SOQL queries
        List<sObject> listOfWorkSites = new List<sObject>();
        listOfWorkSites.addAll(lstWkAcc);
        listOfWorkSites.add(workSiteRec);
        insert listOfWorkSites;
        
        //Update all SAIs on WSs to Customer to pass Extension validation rule
        List<Sales_Area_Information__c> wsSAIs = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c IN: listOfWorkSites];
        for (Sales_Area_Information__c SAI : wsSAIs) {
        	SAI.Type__c = 'Customer';
        }
        update wsSAIs;
        
        //***Creating Extensions****
        for(Integer i = 0; i < 199; i++){
            
            sObject accRec    = UTIL_TestFactory.createAccount();
            accRec.put('RecordTypeId',extrTypeId);
            accRec.put('ParentId',lstWkAcc[i].Id);
            String externalProviderId = String.ValueOf('22:7655'+i);
            accRec.put('External_Provider_Party_ID__c',externalProviderId);
            
            if(i < 100){
                accRec.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',true);//Setting the Do not update Address fields.
            }
            lstExAcc.add(accRec);
        }
        
        for (Integer j = 0; j < lstExAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldAPIName = fieldSet[i].getFieldPath();

                system.debug(Logginglevel.INFO,'+++lstWorksiteAcc77+++'+(fieldSet[i].getType()));
                if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
					lstExAcc[j].put('Postal_Address_Country__c','BA');
					lstExAcc[j].put('Registration_Country__c','BA');
                    lstExAcc[j].put(fieldAPIName,'##9999##');
                    lstExAcc[j].put('Name','##9999##');
					lstExAcc[j].put('VAT_Number__c', 'DK34943400');
                }
            }   
        }
        
        //Creating an extension to be set as a Possible_Duplicate__c fields.
        extensionRec = UTIL_TestFactory.createAccount();
        extensionRec.RecordTypeId = extrTypeId;
        extensionRec.ParentId = workSiteRec.Id;
        
        //Put the EXTs in a list to keep down the SOQL queries
        List<sObject> listOfExtensions = new List<sObject>();
        listOfExtensions.addAll(lstExAcc);
        listOfExtensions.add(extensionRec);
        insert listOfExtensions;
    }
    
    private static void createLEandWSAccountData(){
        UTIL_TestFactory.setUpOrg();
        
        usr = UTIL_TestFactory.createAdmin('test@get2One.com');
        
        RecordTypeWorkSite = UTIL_Meta.getAccountWorkSiteRT();
        RecordTypeLegalEntity= UTIL_Meta.getAccountLegalEntityRT();
        
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
        // Create 2 LE Accounts
        for(Integer i = 0; i < 2; i++){
            Account acc = UTIL_TestFactory.createAccount();
            acc.RecordTypeId = RecordTypeLegalEntity;   
            lstLegalEntityAcc.add(acc);
        }
        insert lstLegalEntityAcc;

        //***Creating Work Site****
        for(Integer i = 0; i < 30; i++){            
            Account acc = UTIL_TestFactory.createAccount();
            acc.RecordTypeId = RecordTypeWorkSite;
            if(i < 15){
                acc.parentId = lstLegalEntityAcc[0].id;
            }else{
                acc.parentId = lstLegalEntityAcc[1].id;             
            }
            lstWorksiteAcc.add(acc);
        }
        insert lstWorksiteAcc;
    }

    private static void createLeAndWSDataNoDML(){
        UTIL_TestFactory.setUpOrg();
        
        usr = UTIL_TestFactory.createAdmin('test@get2One.com');
        
        RecordTypeWorkSite = UTIL_Meta.getAccountWorkSiteRT();
        RecordTypeLegalEntity= UTIL_Meta.getAccountLegalEntityRT();
        
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
        // Create 2 LE Accounts
        for(Integer i = 0; i < 2; i++){
            Account acc = UTIL_TestFactory.createAccount();
            acc.RecordTypeId = RecordTypeLegalEntity;   
            lstLegalEntityAcc.add(acc);
        }

        //***Creating Work Site****
        for(Integer i = 0; i < 30; i++){            
            Account acc = UTIL_TestFactory.createAccount();
            acc.RecordTypeId = RecordTypeWorkSite;
            lstWorksiteAcc.add(acc);
        }
    }    
    //creating test data.
	private static void createMaintainExtData() {
		
		UTIL_TestFactory.setUpOrg();
		usr = UTIL_TestFactory.createAdmin('test@get2One.com');
		
		wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
		extrTypeId = UTIL_Meta.getAccountExtensionRT();
		lerTypeId  = UTIL_Meta.getAccountLegalEntityRT();
		
		//***Creating Legal Entity****
        Account legalEntity = UTIL_TestFactory.createAccount();
        legalEntity.RecordTypeId = lerTypeId;
        legalEntity.Postal_Address_Country__c = 'BA';
        legalEntity.Registration_Country__c = 'BA';
        legalEntity.VAT_Number__c = '##7777##';
        insert legalEntity;
		
		//Fieldset that is holding the fields that should be copied from Work Site to Acc
		List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
		fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
		
		//*************CREATING WORK SITE**************	
		SObject accWKRec0 = UTIL_TestFactory.createAccount();
		accWKRec0.put('ParentId', legalEntity.Id);
		accWKRec0.put('Postal_Address_Country__c','BA');//Setting the Do not update Address fields.
		accWKRec0.put('Registration_Country__c','BA');
		
		accWKRec0.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
		lstWkAcc.add(accWKRec0);
		
		sObject accWKRec1    = UTIL_TestFactory.createAccount();
		accWKRec1.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
		accWKRec1.put('ParentId', legalEntity.Id);
		lstWkAcc.add(accWKRec1);
		
		for (Integer j = 0; j <lstWkAcc.size(); j++) {
			
			for(Integer i=0; i<fieldSet.size(); i++) {
				String fieldAPIName = fieldSet[i].getFieldPath();
				
				system.debug('+++lstWorksiteAcc77+++'+(fieldSet[i].getType()));
				if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
					lstWkAcc[j].put(fieldAPIName,'##7777##');
				}
			}
			lstWkAcc[j].put('Postal_Address_Country__c','BA'); 
            lstWkAcc[j].put('Visiting_Address_Country__c','BA'); 
            lstWkAcc[j].put('Registration_Country__c', 'BA');	
		}
		
		insert lstWkAcc;
		
		//Update all SAIs on WSs to Customer to pass Extension validation rule
        List<Sales_Area_Information__c> wsSAIs = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c IN: lstWkAcc];
        for (Sales_Area_Information__c SAI : wsSAIs) {
        	SAI.Type__c = 'Customer';
        }
        update wsSAIs;
		
		//*************CREATING EXTENSION**************	
		sObject accEXRec0    = UTIL_TestFactory.createAccount();
		accEXRec0.put('RecordTypeId',extrTypeId);
		system.debug('++lstWkAcc[0].get++'+lstWkAcc[0].get('Id'));
		accEXRec0.put('ParentId',lstWkAcc[0].get('Id'));
		accEXRec0.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
		lstExAcc.add(accEXRec0);
		
		sObject accEXRec1    = UTIL_TestFactory.createAccount();
		accEXRec1.put('RecordTypeId',extrTypeId);
		system.debug('++lstWkAcc[1].get++'+lstWkAcc[1].get('Id'));
		accEXRec1.put('ParentId',lstWkAcc[1].get('Id'));
		accEXRec1.put('Do_Not_Update_Address_Automatically__c',true);//Setting the Do not update Address fields.
		lstExAcc.add(accEXRec1);
		
		for (Integer j = 0; j < lstExAcc.size(); j++) {
			
			for(Integer i=0; i<fieldSet.size(); i++) {
				String fieldAPIName = fieldSet[i].getFieldPath();

				system.debug('+++lstWorksiteAcc77+++'+(fieldSet[i].getType()));
				if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
					lstExAcc[j].put(fieldAPIName,'##9999##');
				}
			}
			lstExAcc[j].put('Postal_Address_Country__c','BA'); 
            lstExAcc[j].put('Visiting_Address_Country__c','BA');
            lstExAcc[j].put('Registration_Country__c','BA');  				
		}
		insert lstExAcc;
	}
}