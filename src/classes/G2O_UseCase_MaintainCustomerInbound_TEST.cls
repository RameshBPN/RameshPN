/**
    About
    -----
    Description: This class is used to test Integration #2. Account Information to CRM
                                            Integration #8. PNCM New/Changed Account
                                            Integration #9. Netbutikken new/updated customer
                                            
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2013
    
    Details
    -------
    
    Update History
    --------------
    Created March 2013 - T.R.
    Merged August 2013 based on the Sprint03_MaintainCustomerInbound_TEST class - K.E.A.J.

 */
 
 
@isTest
public with sharing class G2O_UseCase_MaintainCustomerInbound_TEST {    
    //New records added 

    //New account inserted
    static testMethod void upsertNotExistingAccount() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        account.Name = 'Testing123';
        account.Involved_Party_ID__c = '12121212';
        
        //Act
        System.runAs(integrationUser) {
            upsert account Involved_Party_ID__c;
        }
        
        //Assert
        Account newAccount = [SELECT Id, Name, Involved_Party_ID__c FROM Account WHERE Name = 'Testing123'];
        System.assertEquals(true, UTIL_Apex.isSet(newAccount.Id));
        System.assertEquals(true, UTIL_Apex.isSet(newAccount.Involved_Party_Id__c));
    }

    static testMethod void upsertExistingAccount() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account oldAccount = UTIL_TestFactory.createAccount();
        oldAccount.Name = 'TestingOldName';
        oldAccount.Involved_Party_ID__c = '12121212';
        insert oldAccount;

        Account inboundAccount = UTIL_TestFactory.createAccount();
        inboundAccount.Involved_Party_ID__c = '12121212';
        inboundAccount.Name = 'TestingNewName';
        
        //Act
        System.runAs(integrationUser) {
            upsert inboundAccount Involved_Party_Id__c;
        }
        
        //Assert
        Account updatedAccount = [SELECT Id, Name, Involved_Party_Id__c FROM Account WHERE Id = :oldAccount.Id];
        System.assertEquals(updatedAccount.Name, 'TestingNewName');
        System.assertEquals(true, UTIL_Apex.isSet(updatedAccount.Involved_Party_ID__c));
    }
    
    //New Contact inserted
    static testMethod void upsertNotExistingContact() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;

        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        contact.LastName = 'Testing';
        contact.Contact_Person_ID__c = 'TEXT-11111111';
        
        //Act
        System.runAs(integrationUser) {
            upsert contact Contact_Person_ID__c;
        }
        
        Contact newContact = [SELECT Id, AccountId, Contact_Person_ID__c
            FROM Contact WHERE Id =: contact.Id];
        
        Account_Contact_Role_Transaction__c ACRT = [SELECT Id, Account__c, Contact__c, Account_Contact_Role_SFID__c 
            FROM Account_Contact_Role_Transaction__c 
            WHERE Account__c =: account.Id AND Contact__c =: newContact.Id];

        //Assert
        System.assertEquals(true, UTIL_Apex.isSet(newContact.Id));
        System.assertEquals(account.Id, newContact.AccountId);
        System.assertEquals(true, UTIL_Apex.isSet(newContact.Contact_Person_ID__c));
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Id));
        System.assertEquals(account.Id, ACRT.Account__c);
        System.assertEquals(contact.Id, ACRT.Contact__c);
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Account_Contact_Role_SFID__c));
    }

    static testMethod void upsertExistingContactWithExternalProviderPartyId() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        contact.LastName = 'Testing';
        contact.External_Provider_Party_ID__c = '10101010';
        insert contact;

        Contact inboundContact = UTIL_TestFactory.createContact();
        inboundContact.AccountId = account.Id;
        inboundContact.LastName = 'TestingInbound';

        inboundContact.External_Provider_Party_ID__c = '10101010';

        //Act
        System.runAs(integrationUser) {
            upsert inboundContact External_Provider_Party_ID__c;
        }
        
        //Assert
        Contact newContact = [SELECT Id, LastName, AccountId, Contact_Person_ID__c 
            FROM Contact WHERE Id =: contact.Id];
        Account_Contact_Role_Transaction__c ACRT = [SELECT Id, Account__c, Contact__c, Account_Contact_Role_SFID__c 
            FROM Account_Contact_Role_Transaction__c WHERE Contact__c =: contact.Id];

        //Assert Contact
        System.assertEquals('TestingInbound', newContact.LastName);
        System.assertEquals(account.Id, newContact.AccountId);
        System.assertEquals(true, UTIL_Apex.isSet(newContact.Contact_Person_ID__c));
        //Assert ACRT
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Id));
        System.assertEquals(account.Id, ACRT.Account__c);
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Contact__c));
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Account_Contact_Role_SFID__c));
    }
    
    static testMethod void upsertExistingContactWithContactPersonId() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        contact.LastName = 'newContact';
        contact.Contact_Person_ID__c = 'PNCM-1234567890';
            
        Contact inboundContact = UTIL_TestFactory.createContact();
        inboundContact.LastName = 'inboundContact';
        inboundContact.Contact_Person_ID__c = 'PNCM-1234567890';
        
        System.runAs(integrationUser) {
            insert contact;

            //Act
            upsert inboundContact Contact_Person_ID__c;
        }
        
        //Assert
        Contact newContact = [SELECT Id, LastName, AccountId, Contact_Person_ID__c 
            FROM Contact WHERE Id =: contact.Id];
 
        Account_Contact_Role_Transaction__c ACRT = [SELECT Id, Account__c, Contact__c, Account_Contact_Role_SFID__c 
            FROM Account_Contact_Role_Transaction__c WHERE Contact__c =: contact.Id];

        //Assert Contact
        System.assertEquals('inboundContact', newContact.LastName);
        System.assertEquals(account.Id, newContact.AccountId);
        System.assertEquals(true, UTIL_Apex.isSet(newContact.Contact_Person_ID__c));
        //Assert ACRT
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Id));
        System.assertEquals(account.Id, ACRT.Account__c);
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Contact__c));
        System.assertEquals(true, UTIL_Apex.isSet(ACRT.Account_Contact_Role_SFID__c));
    }

    //New Account Contact Role Transaction inserted
    static testMethod void upsertNotExistingAccountContactRoleTransaction() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        
        //Create 3 accounts, 1 to connect contacts 2 and 2 to add connection to in the Act
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i < 3; i++) {
            Account account = UTIL_TestFactory.createAccount();
            accounts.add(account);
        }
        insert accounts;
        
        //Add the 2 contacts to Account 1
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i < 2; i++) {
            Contact contact = UTIL_TestFactory.createContact();
            contact.AccountId = accounts[2].Id;
            contact.LastName = 'Testing';
            contacts.add(contact);
        }
        insert contacts;
        
        //Inbound ACRTs - Connect contacts to Account 2 och 3
        List<Account_Contact_Role_Transaction__c> inboundACRTs = new List<Account_Contact_Role_Transaction__c>();
        for (Integer i=0; i < contacts.size(); i++) {
            Account_Contact_Role_Transaction__c inboundACRT = new Account_Contact_Role_Transaction__c();
            inboundACRT.Account__c = accounts[i].Id;
            inboundACRT.Contact__c = contacts[i].Id;
            inboundACRT.Primary_Position__c = 'Payer';
            inboundACRTs.add(inboundACRT);
        }
        
        //Set external Ids - Should not exist in the system already
        inboundACRTs[0].External_Provider_Relationship_ID__c = '12341234';
        inboundACRTs[1].Account_Contact_Role_SFID__c = account.Involved_Party_ID__c + ':' + 
                contact.External_Provider_Party_ID__c; 

        //Act
        System.runAs(integrationUser) {
            upsert inboundACRTs[0] External_Provider_Relationship_ID__c;
            upsert inboundACRTs[1] Account_Contact_Role_SFID__c;
        }
        
        //Assert
        List<Account_Contact_Role_Transaction__c> newACRTs = [SELECT Id, Name, Account__c, Contact__c, Primary_Position__c, External_Provider_Relationship_ID__c, Account_Contact_Role_SFID__c FROM Account_Contact_Role_Transaction__c WHERE Id =:inboundACRTs];
        for (Integer i=0; i < newACRTs.size(); i++) {
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Id));
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Account__c));
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Contact__c));
            System.assertEquals('Payer', newACRTs[i].Primary_Position__c);
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Account_Contact_Role_SFID__c));
        }
    }
    
    //Updated Account Contact Role Transaction inserted
    static testMethod void upsertExistingAccountContactRoleTransaction() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i < 2; i++) {
            Contact contact = UTIL_TestFactory.createContact();
            contact.AccountId = account.Id;
            contact.LastName = 'Testing';
            contacts.add(contact);
        }
        insert contacts;

        //Get the ACRTs that have been created and set external Ids on them
        List<Account_Contact_Role_Transaction__c> ACRTs = [SELECT Id, Account__c, Contact__c, Account_Contact_Role_SFID__c 
            FROM Account_Contact_Role_Transaction__c 
            WHERE Account__c =: account.Id AND Contact__c IN : contacts];
            
        ACRTs[0].External_Provider_Relationship_ID__c = '12341234';
        ACRTs[1].Account_Contact_Role_SFID__c = '56785678';
        update ACRTs;

        //Inbound ACRTs
        List<Account_Contact_Role_Transaction__c> inboundACRTs = new List<Account_Contact_Role_Transaction__c>();
        for (Integer i=0; i < ACRTs.size(); i++) {
            Account_Contact_Role_Transaction__c inboundACRT = new Account_Contact_Role_Transaction__c();
            inboundACRT.Account__c = account.Id;
            inboundACRT.Contact__c = contacts[i].Id;
            inboundACRT.Primary_Position__c = 'TestRole';
            inboundACRTs.add(inboundACRT);
        }
        
        inboundACRTs[0].External_Provider_Relationship_ID__c = '12341234';
        inboundACRTs[1].Account_Contact_Role_SFID__c = '56785678';

        //Act
        System.runAs(integrationUser) {
            upsert inboundACRTs[0] External_Provider_Relationship_ID__c;
            upsert inboundACRTs[1] Account_Contact_Role_SFID__c;
        }
        
        //Assert
        List<Account_Contact_Role_Transaction__c> newACRTs = [SELECT Id, Name, Account__c, Contact__c, Primary_Position__c, External_Provider_Relationship_ID__c, Account_Contact_Role_SFID__c FROM Account_Contact_Role_Transaction__c WHERE Id IN: ACRTs];
        for (Integer i=0; i < newACRTs.size(); i++) {
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Id));
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Account__c));
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Contact__c));
            System.assertEquals('TestRole', newACRTs[i].Primary_Position__c);
            System.assertEquals(true, UTIL_Apex.isSet(newACRTs[i].Account_Contact_Role_SFID__c));
        }
    }
    
    static testMethod void upsertNotExistingRelationship() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
		integrationUser.Sales_Area1__c = '1000';
		insert integrationUser;
		
		System.runAs(integrationUser) {
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
	        
	        Sales_Area_Information__c SAI = UTIL_TestFactory.createSalesAreaInformation();
	        SAI.Account__c = accountWS.Id;
	        SAI.Type__c = 'Customer';
	        SAI.Sales_Area__c = integrationUser.Sales_Area1__c;
	        insert SAI; 

        //Act
	        Relationship__c relationship = new Relationship__c();
	        relationship.Account__c = accountWS.Id;
	        relationship.Related_Account__c = accountIR.Id;
	        relationship.Relationship_Type__c = 'RE';
	        relationship.Sales_Area__c = integrationUser.Sales_Area1__c;
	        relationship.Distribution_Channel__c = '10';
	        relationship.Division__c = '00';

        	relationship.Relationship_Compound_SFID__c =
                relationship.Account__r.Involved_Party_ID__c + ':' +
                relationship.Relationship_Type__c + ':' +
                relationship.Sales_Area__c + ':' +
                relationship.Distribution_Channel__c + ':' +
                relationship.Division__c + ':' +
                relationship.Related_Account__r.Involved_Party_ID__c;
        	Test.startTest();
            upsert relationship Relationship_Compound_SFID__c;
            Test.stopTest();
            
            //Assert
	        Relationship__c newRelation = [SELECT Id, Account__c, Related_Account__c, Relationship_Type__c, Sales_Area__c, Distribution_Channel__c, Division__c, Relationship_Compound_SFID__c 
	            FROM Relationship__c WHERE Account__c =: accountWS.Id AND Related_Account__c =: accountIR.Id];

	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Id));
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Account__c));
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Related_Account__c));
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Relationship_Type__c));
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Sales_Area__c));
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Distribution_Channel__c));
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Division__c));
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Relationship_Compound_SFID__c));
        }
    }

    static testMethod void upsertExistingRelationship() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
		integrationUser.Sales_Area1__c = '1000';
		insert integrationUser;
		
		System.runAs(integrationUser) {
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
	        
	        Sales_Area_Information__c SAI = new Sales_Area_Information__c();
	        SAI.Account__c = accountWS.Id;
	        SAI.Type__c = 'Customer';
	        SAI.Sales_Area__c = integrationUser.Sales_Area1__c;
	        SAI.Distribution_Channel__c = '10';
	        SAI.Division__c = '00';
	        SAI.PostNord_Company_Name__c = integrationUser.Sales_Area1__c;
	        insert SAI;
	        
	        Relationship__c relationship = new Relationship__c();
	        relationship.Account__c = accounts[0].Id;
	        relationship.Related_Account__c = accounts[1].Id;
	        relationship.Relationship_Type__c = 'RE';
	        relationship.Sales_Area__c = integrationUser.Sales_Area1__c;
	        relationship.Distribution_Channel__c = '10';
	        relationship.Division__c = '00';
	        
	        insert relationship;    
	        
	        //Create inbound relationships
	        Relationship__c inboundRelationship = new Relationship__c();
	        Relationship__c existingRelationship = [SELECT Id, Account__r.Involved_Party_ID__c, Related_Account__r.Involved_Party_ID__c, Sales_Area__c, Relationship_Compound_SFID__c FROM Relationship__c WHERE Id =: relationship.Id];
	        
	        inboundRelationship.Account__c = existingRelationship.Account__c;
	        inboundRelationship.Related_Account__c = existingRelationship.Related_Account__c;
	        inboundRelationship.PN_Synchronization_ErrorReasonCode__c = 'TEST';
	        inboundRelationship.Sales_Area__c = existingRelationship.Sales_Area__c;
	        inboundRelationship.Relationship_Compound_SFID__c = existingRelationship.Relationship_Compound_SFID__c;
		
			//Act
			upsert inboundRelationship Relationship_Compound_SFID__c;

	        //Assert
	        Relationship__c newRelation = [SELECT Id, PN_Synchronization_ErrorReasonCode__c, Relationship_Compound_SFID__c FROM Relationship__c WHERE Id =: relationship.Id];
	        System.assertEquals('TEST', newRelation.PN_Synchronization_ErrorReasonCode__c);
	        System.assertEquals(true, UTIL_Apex.isSet(newRelation.Relationship_Compound_SFID__c));
		}
    }
    
    //New Sales Area Information inserted
    static testMethod void upsertNotExistingSalesAreaInformation() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Sales_Area_Information__c salesAreaInformation = UTIL_TestFactory.createSalesAreaInformation();
        salesAreaInformation.Account__c = account.Id;
        salesAreaInformation.Sales_Area__c = 'SAPID1';
        salesAreaInformation.Distribution_Channel__c = 'SAPID2';
        salesAreaInformation.Division__c = 'SAPID3';
        salesAreaInformation.Sales_Area_Information_Compound_SFID__c = '1234';
        
        //Act
        System.runAs(integrationUser) {
            upsert salesAreaInformation Sales_Area_Information_Compound_SFID__c;
        }
        
        //Assert
        Sales_Area_Information__c insertedSAI = [SELECT Id, Account__c, Sales_Area__c, Distribution_Channel__c, Division__c, Sales_Area_Information_Compound_SFID__c FROM Sales_Area_Information__c WHERE Id =: salesAreaInformation.Id];
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Id));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Account__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Sales_Area__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Distribution_Channel__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Division__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedSAI.Sales_Area_Information_Compound_SFID__c));
    }
    
    static testMethod void upsertExistingSalesAreaInformation() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Sales_Area_Information__c oldSAI = UTIL_TestFactory.createSalesAreaInformation();
        oldSAI.Account__c = account.Id;
        oldSAI.Sales_Area_Information_Compound_SFID__c = '1234';
        oldSAI.Invoice_Reference__c = 'TestReferenceOld';
        insert oldSAI;
        
        //Create inbound SAI
        Sales_Area_Information__c inboundSAI = UTIL_TestFactory.createSalesAreaInformation();
        inboundSAI.Account__c = account.Id;
        inboundSAI.Sales_Area_Information_Compound_SFID__c = '1234';
        inboundSAI.Invoice_Reference__c = 'TestReferenceNew';        
        
        //Act
        System.runAs(integrationUser) {
            upsert inboundSAI Sales_Area_Information_Compound_SFID__c;
        }
        
        //Assert
        Sales_Area_Information__c updatedSAI = [SELECT Id, Invoice_Reference__c, Sales_Area_Information_Compound_SFID__c FROM Sales_Area_Information__c Where Id =: oldSAI.Id];
        System.assertEquals('TestReferenceNew', updatedSAI.Invoice_Reference__c);
        System.assertEquals(true, UTIL_Apex.isSet(updatedSAI.Sales_Area_Information_Compound_SFID__c));
    }
    
    //New Credit Information inserted
    static testMethod void upsertNotExistingCreditInformation() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;

        Credit_Information__c creditInformation = UTIL_TestFactory.createCreditInformation();
        creditInformation.Account__c = account.Id;
        creditInformation.Credit_Control_Area__c = 'SAPID1';
        creditInformation.Credit_Information_Compound_SFID__c = '1234';
        
        //Act
        System.runAs(integrationUser) {
            upsert creditInformation Credit_Information_Compound_SFID__c;
        }
        
        //Assert
        Credit_Information__c insertedCI = [SELECT Id, Account__c, Credit_Control_Area__c, Credit_Information_Compound_SFID__c FROM Credit_Information__c WHERE Id =: creditInformation.Id];
        System.assertEquals(true, UTIL_Apex.isSet(insertedCI.Id));
        System.assertEquals(true, UTIL_Apex.isSet(insertedCI.Account__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedCI.Credit_Control_Area__c));
        System.assertEquals(true, UTIL_Apex.isSet(insertedCI.Credit_Information_Compound_SFID__c));
    }

    //Updated Credit Information
    static testMethod void upsertExistingCreditInformation() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Credit_Information__c oldCI = UTIL_TestFactory.createCreditInformation();
        oldCI.Account__c = account.Id;
        oldCI.Credit_Block__c = true;
        oldCI.Credit_Information_Compound_SFID__c = '1234';
        insert oldCI;
        
        //Create inbound SAI
        Credit_Information__c inboundCI = new Credit_Information__c();
        inboundCI.Credit_Block__c = false;
        inboundCI.Credit_Information_Compound_SFID__c = '1234';
        
        //Act
        System.runAs(integrationUser) {
            upsert inboundCI Credit_Information_Compound_SFID__c;
        }
        
        //Assert
        Credit_Information__c updatedSAI = [SELECT Id, Credit_Block__c, Credit_Information_Compound_SFID__c FROM Credit_Information__c Where Id =: oldCI.Id];
        System.assertEquals(false, updatedSAI.Credit_Block__c);
        System.assertEquals(true, UTIL_Apex.isSet(updatedSAI.Credit_Information_Compound_SFID__c));
    }
    
    //New Bank Details inserted
    static testMethod void upsertNotExistingBankDetails() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;

        Bank_Key__c bankKey = UTIL_TestFactory.createBankKey();
        bankKey.Country__c = 'DK';
        bankKey.Bank_key_external_ID__c = bankKey.Name + ':' + bankKey.Country__c;
        insert bankKey;
        
        Account insertedAccount = [SELECT Id, Involved_Party_ID__c FROM Account Where Id =: account.Id];
        
        Bank_Details__c bankDetails = UTIL_TestFactory.createBankDetail();
        bankDetails.Account__r = insertedAccount;
        bankDetails.Bank_Key__r = bankKey;
        bankDetails.Bank_Country__c = 'DK';
        bankDetails.Bank_Account__c = '1234567890';
        bankDetails.Bank_Details_Compound_SFID__c = '12341234';

        //Act
        System.runAs(integrationUser) {
            upsert bankDetails Bank_Details_Compound_SFID__c;
        }
        
        //Assert
        Bank_Details__c updatedBD = [SELECT Id, Account__c, Bank_Country__c, Bank_Key__c, Bank_Account__c, Bank_Details_Compound_SFID__c FROM Bank_Details__c Where Id =: bankDetails.Id];
        System.assertEquals(true, UTIL_Apex.isSet(updatedBD.Id));
        System.assertEquals(true, UTIL_Apex.isSet(updatedBD.Account__c));
        System.assertEquals(true, UTIL_Apex.isSet(updatedBD.Bank_Country__c));
        System.assertEquals(true, UTIL_Apex.isSet(updatedBD.Bank_Key__c));
        System.assertEquals(true, UTIL_Apex.isSet(updatedBD.Bank_Account__c));
        System.assertEquals(true, UTIL_Apex.isSet(updatedBD.Bank_Details_Compound_SFID__c));
    }

    //Updated Bank Details
    static testMethod void upsertExistingBankDetails() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Bank_Details__c oldBD = UTIL_TestFactory.createBankDetail();
        oldBD.Account__c = account.Id;
        oldBD.IBAN_Number__c = 'OLD_TEST';
        oldBD.Bank_Details_Compound_SFID__c = 'TEMP'; //Will be replaced by workflow to correct Compound Key
        insert oldBD;

		Bank_Details__c insertedOldBD = [SELECT Bank_Details_Compound_SFID__c FROM Bank_Details__c Where Id =: oldBD.Id];
		
        //Create inbound BD
        Bank_Details__c inboundBD = new Bank_Details__c();
        inboundBD.Account__c = account.Id;
        inboundBD.IBAN_Number__c = 'NEW_TEST';
        inboundBD.Bank_Details_Compound_SFID__c = insertedOldBD.Bank_Details_Compound_SFID__c;
        
        //Act
        System.runAs(integrationUser) {
            upsert inboundBD Bank_Details_Compound_SFID__c;
        }

        //Assert
        Bank_Details__c updatedBD = [SELECT Id, IBAN_Number__c, Bank_Details_Compound_SFID__c FROM Bank_Details__c Where Id =: oldBD.Id];
        System.assertEquals('NEW_TEST', updatedBD.IBAN_Number__c, 'The IBAN Number is not updated');
        System.assertEquals(true, UTIL_Apex.isSet(updatedBD.Bank_Details_Compound_SFID__c));
    }
}