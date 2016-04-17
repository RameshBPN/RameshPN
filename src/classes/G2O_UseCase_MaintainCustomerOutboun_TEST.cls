/**
    About
    -----
    Description: This class is used to test that the records that are created will get the fields that are mandatory for outbound communication
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    Class name is cut short due to 40 char class name limit
    
    Update History
    --------------
    Created March 2013 - T.R.
    Merged August 2013 based on the Sprint03_MaintainCustomerOutbound_TEST class - K.E.A.J.
*/
@isTest
public with sharing class G2O_UseCase_MaintainCustomerOutboun_TEST {

    /*
    Test that NEWLY created objects get the fields that are needed for an OBM
    */
    
    //Account
    static testMethod void testNewWorkSiteAccountCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User salesUser = UTIL_TestFactory.createSalesUser('salesUser_h8sw7hgw87eg87whf8whvf8w@test.com');
        salesUser.Sales_Area1__c = '1000';
        insert salesUser;
        
        Account account = UTIL_TestFactory.createAccount();
        Id recordType = UTIL_TestFactory.getAccountRecordType('Work_Site');
        account.RecordTypeId = recordType;
        
        //Act
        System.runAs(salesUser) {
            insert account;
        }
        
        //Assert
        Account insertedAccount = [SELECT Name, Involved_Party_ID__c FROM Account WHERE Id =: account.Id];
        System.assertEquals(account.Name, insertedAccount.Name);
        System.assertEquals(true, UTIL_Apex.isSet(insertedAccount.Involved_Party_ID__c));
        
        Sales_Area_Information__c insertedSAI = [SELECT Id, Sales_Area__c, Division__c, Distribution_Channel__c, PostNord_Company_Name__c FROM Sales_Area_Information__c Where Account__c =: insertedAccount.Id];
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Sales_Area__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Division__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Distribution_Channel__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.PostNord_Company_Name__c));
    }
    
    static testMethod void testNewPersonAccountCreated() {
        //Arrange
        User adminUser = UTIL_TestFactory.createAdmin('testAdminUser_89qudqwjq9dwwqwd@test.com');
        Account account = UTIL_TestFactory.createPersonAccount();

        //Act
        System.runAs(adminUser) {
            insert account;
        }
        
        //Assert
        Id recordType = UTIL_Meta.getPersonAccountRT();
        
        Account insertedAccount = [SELECT LastName, Involved_Party_ID__c, RecordTypeId FROM Account WHERE Id =: account.Id];
        System.assertEquals(account.LastName, insertedAccount.LastName);
        System.assertEquals(true, UTIL_Apex.isSet(insertedAccount.Involved_Party_ID__c));
        System.assertEquals(recordType, insertedAccount.RecordTypeId);
        
        Sales_Area_Information__c insertedSAI = [SELECT Id, Sales_Area__c, Division__c, Distribution_Channel__c, PostNord_Company_Name__c FROM Sales_Area_Information__c Where Account__c =: insertedAccount.Id];
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Sales_Area__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Division__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Distribution_Channel__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.PostNord_Company_Name__c));
    }
    
    static testMethod void testNewNetbutikkenB2BAccountCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser_23r092k3r2093k@test.com');
        UTIL_TestFactory.createGet2OneCrm();
        Account account = UTIL_TestFactory.createAccount();
        Id recordType = UTIL_TestFactory.getAccountRecordType('B2B_Webshop_Placeholder');
        account.RecordTypeId = recordType;
        
        //Act
        System.runAs(integrationUser) {
            insert account;
        }
        //Assert
        Account insertedAccount = [SELECT Name, Involved_Party_ID__c, Verified__c, PN_Synchronized__c, Origin__c FROM Account WHERE Id=:account.Id];
        System.assertEquals(UTIL_OrgSettings.Webshop_B2B_Name(), insertedAccount.Name);
        System.assertEquals(true, UTIL_Apex.isSet(insertedAccount.Involved_Party_ID__c));
        System.assertEquals('N', insertedAccount.Verified__c);
        System.assertEquals(true, insertedAccount.PN_Synchronized__c);
        System.assertEquals(UTIL_OrgSettings.Webshop_Origin(), insertedAccount.Origin__c);
    }
    
    static testMethod void testNewNetbutikkenB2CAccountCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser_298r9j394r@test.com');
        UTIL_TestFactory.createGet2OneCrm();
        Account account = UTIL_TestFactory.createPersonAccount();
        Id recordType = UTIL_TestFactory.getAccountRecordType('B2C_Webshop_Placeholder');
        account.RecordTypeId = recordType;
        
        //Act
        System.runAs(integrationUser) {
            insert account;
        }
        
        //Assert
        Account insertedAccount = [SELECT LastName, Involved_Party_ID__c, Verified__c, PN_Synchronized__c, Origin__c FROM Account WHERE Id=:account.Id];
        System.assertEquals(UTIL_OrgSettings.Webshop_B2C_Name(), insertedAccount.LastName);
        System.assertEquals(true, UTIL_Apex.isSet(insertedAccount.Involved_Party_ID__c));
        System.assertEquals('N', insertedAccount.Verified__c);
        System.assertEquals(true, insertedAccount.PN_Synchronized__c);
        System.assertEquals(UTIL_OrgSettings.Webshop_Origin(), insertedAccount.Origin__c);
    }
    
    //Contact
    static testMethod void testNewContactCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        //Act
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        insert contact;
        
        //Assert
        Contact insertedContact = [SELECT Id, Contact_Person_ID__c FROM Contact WHERE Id = :contact.Id];
        System.assertEquals(true, UTIL_Apex.isSet(insertedContact.Contact_Person_ID__c));
        
        Account_Contact_Role_Transaction__c ACRT = [SELECT Id, Account__c, Contact__c, Account_Contact_Role_SFID__c FROM Account_Contact_Role_Transaction__c WHERE Account__c = :account.Id AND Contact__c = :contact.Id];
        System.assertEquals(insertedContact.Id, ACRT.Contact__c);
        System.assertEquals(contact.AccountId, ACRT.Account__c);
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Account_Contact_Role_SFID__c));
    }
    
    //Account Contact Role Transaction
    static testMethod void testNewAccountContactRoleTransactionCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        account.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        insert account;
        
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        insert contact;
        
        Account account2 = UTIL_TestFactory.createAccount();
        account.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        insert account2;
        
        //Act
        Account_Contact_Role_Transaction__c ACRT = new Account_Contact_Role_Transaction__c();
        ACRT.Account__c = account2.Id;
        ACRT.Contact__c = contact.Id;
        insert ACRT;

        //Assert
        Account_Contact_Role_Transaction__c insertedACRT = [SELECT Id, Account__c, Contact__c, Account_Contact_Role_SFID__c FROM Account_Contact_Role_Transaction__c WHERE Id =: ACRT.Id];
        System.assertEquals(account2.Id, insertedACRT.Account__c);
        System.assertEquals(contact.Id, insertedACRT.Contact__c);
        System.assertEquals(true, UTIL_Apex.isSet(insertedACRT.Account_Contact_Role_SFID__c));
    }
    
    //Relationship
    static testMethod void testNewRelationshipCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        User runAsUser = UTIL_TestFactory.createSalesUser('salesuser_2039r21111@sales.com');
        runAsUser.Sales_Area1__c = '1000';
        insert runAsUser;
        
        System.runAs(runAsUser) {
        	Account accountLE = UTIL_TestFactory.createAccount();
	        accountLE.recordTypeId = UTIL_Meta.getAccountLegalEntityRT();
	        insert accountLE;
	        
	        List<Account> accounts = new List<Account>();
	        Account accountWS = UTIL_TestFactory.createAccount();
	        accountWS.recordTypeId = UTIL_Meta.getAccountWorkSiteRT();
	        accountWS.ParentId = accountLE.Id;
	        accounts.add(accountWS);
	        Account accountIR = UTIL_TestFactory.createAccount();
	        accountIR.recordTypeId = UTIL_Meta.getAccountInvoiceRecipientRT();
	        accounts.add(accountIR);
	        insert accounts;
	        
	        Sales_Area_Information__c accountSAI = [SELECT Id FROM Sales_Area_Information__c Where Account__c =: accountWS.Id];
	        accountSAI.Type__c = 'Customer';
	        update accountSAI;   
	        
	        //Act
	        Relationship__c relationship = UTIL_TestFactory.createRelationship();
	        relationship.Account__c = accountWS.Id;
	        relationship.Related_Account__c = accountIR.Id;
	        relationship.Relationship_Type__c = 'RE';
	        relationship.Sales_Area__c = runAsUser.Sales_Area1__c;
	        relationship.Distribution_Channel__c = '10';
	        relationship.Division__c = '00';
	        Test.startTest();
	        insert relationship;
	        Test.stopTest();
	        
	        //Assert
	        Relationship__c insertedRelationship = [SELECT Id, Account__c, Related_Account__c, Relationship_Type__c, Sales_Area__c, Distribution_Channel__c, Division__c, Relationship_Compound_SFID__c FROM Relationship__c WHERE Id =: relationship.Id];
	        System.assertEquals(true, UTIL_Apex.isSet(insertedRelationship.Account__c));
	        System.assertEquals(true, UTIL_Apex.isSet(insertedRelationship.Related_Account__c));
	        System.assertEquals(true, UTIL_Apex.isSet(insertedRelationship.Sales_Area__c));
	        System.assertEquals(true, UTIL_Apex.isSet(insertedRelationship.Distribution_Channel__c));
	        System.assertEquals(true, UTIL_Apex.isSet(insertedRelationship.Division__c));
	        System.assertEquals(true, UTIL_Apex.isSet(insertedRelationship.Relationship_Type__c));
	        System.assertEquals(true, UTIL_Apex.isSet(insertedRelationship.Relationship_Compound_SFID__c));
        }
	}
    
    //Sales Area Information
    static testMethod void testNewSalesAreaInformationCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        //Act
        Sales_Area_Information__c SAI = UTIL_TestFactory.createSalesAreaInformation();
        SAI.Account__c = account.Id;
        SAI.Sales_Area__c = 'TEST_SA';
        SAI.Distribution_Channel__c = 'TEST_DIST_CH';
        SAI.Division__c = 'TEST_DIV';
        SAI.PostNord_Company_Name__c = 'TEST_PN_NAME';
        insert SAI;

        //Assert
        Sales_Area_Information__c insertedSAI = [SELECT Id, Account__c, Sales_Area__c, Distribution_Channel__c, Division__c, PostNord_Company_Name__c, Sales_Area_Information_Compound_SFID__c FROM Sales_Area_Information__c WHERE Id =: SAI.Id];
        System.assertEquals(account.Id, insertedSAI.Account__c);
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Sales_Area__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Distribution_Channel__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Division__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.PostNord_Company_Name__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Sales_Area_Information_Compound_SFID__c));
    }
    
    //Credit Information
    static testMethod void testNewCreditInformationCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        //Act
        Credit_Information__c CI = UTIL_TestFactory.createCreditInformation();
        CI.Account__c = account.Id;
        CI.Credit_Control_Area__c = 'TEST_CCA';
        insert CI;

        //Assert
        Credit_Information__c insertedCI = [SELECT Id, Account__c, Credit_Control_Area__c, Credit_Information_Compound_SFID__c FROM Credit_Information__c WHERE Id =: CI.Id];
        System.assertEquals(account.Id, insertedCI.Account__c);
        System.assertEquals(true, UTIL_Apex.isSet(insertedCI.Credit_Control_Area__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedCI.Credit_Information_Compound_SFID__c));
    }
    
    //Bank Details
    static testMethod void testNewBankDetailsCreated() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Bank_Key__c bankKey = UTIL_TestFactory.createBankKey();
        bankKey.Country__c = 'SE';
        insert bankKey;

        //Act
        Bank_Details__c BD = UTIL_TestFactory.createBankDetail();
        BD.Bank_Country__c = bankKey.Country__c;
        BD.Bank_Key__c = bankKey.Id;
        BD.Bank_Account__c = 'TestAccount';
        insert BD;
        
        //Assert
        Bank_Details__c insertedBD = [SELECT Id, Account__c, Bank_Country__c, Bank_Key__c, Bank_Account__c, Bank_Details_Compound_SFID__c FROM Bank_Details__c WHERE Id =: BD.Id];
        System.assertEquals(BD.Account__c, insertedBD.Account__c);
        System.assertEquals(true, UTIL_Apex.isSet(insertedBD.Bank_Country__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedBD.Bank_Key__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedBD.Bank_Account__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedBD.Bank_Details_Compound_SFID__c));
    }
    
    /* Compound key verifications */
    
    //ACRT compound key verification
    static testMethod void testCompoundKeyOnACRT() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        insert contact;
        
        //Act
        Account insertedAccount = [SELECT Id, Involved_Party_ID__c FROM Account WHERE Id =: account.Id];
        Contact insertedContact = [SELECT Id, Contact_Person_ID__c FROM Contact WHERE Id =: contact.Id];
        Account_Contact_Role_Transaction__c ACRT = [SELECT Id, Account__c, Contact__c, Account_Contact_Role_SFID__c FROM Account_Contact_Role_Transaction__c WHERE Account__c = :account.Id AND Contact__c = :contact.Id];
        
        //Assert
        System.assertEquals(insertedAccount.Involved_Party_ID__c + ':' + insertedContact.Contact_Person_ID__c, 
                            ACRT.Account_Contact_Role_SFID__c);
    }
    
    //Relationship compound key verification
    static testMethod void testCompoundKeyOnRelationship() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        User runAsUser = UTIL_TestFactory.createSalesUser('salesuser_23r02rfr203f33ff3@sales.com');
        runAsUser.Sales_Area1__c = '1000';
        insert runAsUser;
        
        System.runAs(runAsUser) {
        	Account accountLE = UTIL_TestFactory.createAccount();
        accountLE.recordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        insert accountLE;
        
        List<Account> accounts = new List<Account>();
        Account accountWS = UTIL_TestFactory.createAccount();
        accountWS.recordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        accountWS.ParentId = accountLE.Id;
        accountWS.Involved_Party_ID__c = '12121212';
        accounts.add(accountWS);
        Account accountIR = UTIL_TestFactory.createAccount();
        accountIR.recordTypeId = UTIL_Meta.getAccountInvoiceRecipientRT();
        accountIR.Involved_Party_ID__c = '34343434';
        accounts.add(accountIR);
        insert accounts;
        
        Sales_Area_Information__c accountSAI = [SELECT Id FROM Sales_Area_Information__c Where Account__c =: accountWS.Id];
        accountSAI.Type__c = 'Customer';
        update accountSAI;    

        //Act
        Relationship__c relationship = UTIL_TestFactory.createRelationship();
        relationship.Account__c = accountWS.Id;
        relationship.Related_Account__c = accountIR.Id;
        relationship.Sales_Area__c = runAsUser.Sales_Area1__c;
        relationship.Distribution_Channel__c = 'testDistCh';
        relationship.Division__c = 'testDiv';
        relationship.Relationship_Type__c = 'testType';
        Test.startTest();
        insert relationship;
        Test.stopTest();

        //Assert
        Relationship__c insertedRelationship = [SELECT Id, Relationship_Compound_SFID__c 
                                        FROM Relationship__c Where Id =: relationship.Id];
        System.assertEquals(accountWS.Involved_Party_ID__c + ':' + relationship.Relationship_Type__c
                + ':' + relationship.Sales_Area__c + ':' + relationship.Distribution_Channel__c
                + ':' + relationship.Division__c + ':' + accountIR.Involved_Party_ID__c,
                insertedRelationship.Relationship_Compound_SFID__c);
        }
    }
    
    //Sales Area Information compound key verification
    static testMethod void testCompoundKeyOnSalesAreaInformation() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        account.Involved_Party_ID__c = '12121212';
        insert account;
        
        //Act
        Sales_Area_Information__c SAI = new Sales_Area_Information__c();
        SAI.Account__c = account.Id;
        SAI.Sales_Area__c = '1000';
        SAI.Distribution_Channel__c = 'TestDistCh';
        SAI.Division__c = 'TestDiv';
        insert SAI;
        
        //Assert
        Sales_Area_Information__c insertedSAI = [SELECT Id, Sales_Area_Information_Compound_SFID__c 
                                        FROM Sales_Area_Information__c Where Id =: SAI.Id];
        System.assertEquals(account.Involved_Party_ID__c + ':' + SAI.Sales_Area__c + ':'
                             + SAI.Distribution_Channel__c + ':' + SAI.Division__c, 
                             insertedSAI.Sales_Area_Information_Compound_SFID__c);
    }
    
    //Credit Information compound key verification
    static testMethod void testCompoundKeyOnCreditInformation() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        account.Involved_Party_ID__c = '12121212';
        insert account;
        
        //Act
        Credit_Information__c CI = new Credit_Information__c();
        CI.Account__c = account.Id;
        CI.Credit_Control_Area__c = 'TestCreditControlArea';
        insert CI;
        
        //Assert
        Credit_Information__c insertedCI = [SELECT Id, Credit_Information_Compound_SFID__c 
                                        FROM Credit_Information__c Where Id =: CI.Id];
        System.assertEquals(account.Involved_Party_ID__c + ':' + CI.Credit_Control_Area__c,
                             insertedCI.Credit_Information_Compound_SFID__c);
    }
    
    //Bank Details compound key verification
    static testMethod void testCompoundKeyOnBankDetails() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        account.Involved_Party_ID__c = '12121212';
        insert account;
        
        Bank_Key__c bankKey = UTIL_TestFactory.createBankKey();
        bankKey.Name = 'testKey';
        bankKey.Country__c = 'SE';
        insert bankKey;
        
        //Act
        Bank_Details__c BD = new Bank_Details__c();
        BD.Account__c = account.Id;
        BD.Bank_Country__c = bankKey.country__c;
        BD.Bank_Key__c = bankKey.Id;
        BD.Bank_Account__c = 'TestBankAccount';
        insert BD;
        
        //Assert
        Bank_Details__c insertedBD = [SELECT Id, Bank_Details_Compound_SFID__c 
                                        FROM Bank_Details__c Where Id =: BD.Id];
        System.assertEquals(account.Involved_Party_ID__c + ':' + BD.Bank_Country__c
                            + ':' + bankKey.Name + ':' + BD.Bank_Account__c,
                            insertedBD.Bank_Details_Compound_SFID__c);
    }
}