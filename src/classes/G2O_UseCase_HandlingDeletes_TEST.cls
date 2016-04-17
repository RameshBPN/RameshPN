/**
 * Test delets/undeletes of records and the process around OMB and CINT.
 *
 * Tests for ACRT is found in G2O_AccountContactRole_SVC_TEST
 */
@isTest
private class G2O_UseCase_HandlingDeletes_TEST {
    
    static testMethod void testDeleteFlag() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        //The following objects should only be deleted logicaly, meaning by setting Deletion Flag
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        Credit_Information__c creditInformation = UTIL_TestFactory.createCreditInformation();
        creditInformation.Account__c = account.Id;
        
        insert contact;
        insert creditInformation;
        
        //Act
        test.startTest();
        //Deletes the objects by setting deletion flag
        account.Deletion_Flag__c = true;
        contact.Deletion_Flag__c = true;
        creditInformation.Deletion_Flag__c = true;
        
        update account;
        update contact;
        update creditInformation;

        //Assert
        Account[] accountList = [SELECT Id, Deletion_Flag__c FROM Account WHERE Id = :account.Id];
        Contact[] contactList = [SELECT Id, Deletion_Flag__c FROM Contact WHERE Id = :contact.Id];
        Credit_Information__c[] creditInformationList = [SELECT Id, Deletion_Flag__c FROM Credit_Information__c WHERE Id = :creditInformation.Id];
		test.stopTest();
                
        //Logical delete
        System.assert(accountList.size() == 1, 'Account should not be physical deleted');
        System.assert(contactList.size() == 1, 'Contact should not be physical deleted');
        System.assert(creditInformationList.size() == 1, 'Credit Information should not be physical deleted');       
    }
    
    static testMethod void testDeleteParent() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        //Parent
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        //Child records
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        Credit_Information__c creditInformation = new Credit_Information__c();
        creditInformation.Account__c = account.Id;
        
        insert contact;
        insert creditInformation;
        
        //Act
        
        test.startTest();
        //Deletes the objects by setting deletion flag
        account.Deletion_Flag__c = true;
        update account;
        
        //Assert
        
        Contact[] contactList = [SELECT Id, Deletion_Flag__c FROM Contact WHERE Id = :contact.Id];
        Account[] accountList = [SELECT Id, Deletion_Flag__c FROM Account WHERE Id = :account.Id];
        Credit_Information__c[] creditInformationList = [SELECT Id, Deletion_Flag__c FROM Credit_Information__c WHERE Id = :creditInformation.Id];
        
        test.stopTest();
        //Logical delete
        System.assert(accountList.size() == 1, 'Account should not be physical deleted');
        System.assert(accountList[0].Deletion_Flag__c == true, 'Deletion_Flag__c should be true');
        System.assert(contactList.size() == 1, 'Contact should not be physical deleted');
        System.assert(contactList[0].Deletion_Flag__c == true, 'Deletion_Flag__c should be true');
        System.assert(creditInformationList.size() == 1, 'Credit Information should not be physical deleted');
        System.assert(creditInformationList[0].Deletion_Flag__c == true, 'Deletion_Flag__c should be true');
    }
    
    static testMethod void testUndeleteLogical() {
        //Arrange
        UTIL_TestFactory.setUpOrg();

        Account account = UTIL_TestFactory.createAccount();
        insert account;
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        Credit_Information__c creditInformation = UTIL_TestFactory.createCreditInformation();
        creditInformation.Account__c = account.Id;

        insert contact;
        insert creditInformation;
        
        //Act
        
        //Deletes the objects by setting the deletion flag, this mimic the custom Delete button
        test.startTest();
        account.Deletion_Flag__c = true;
        contact.Deletion_Flag__c = true;
        creditInformation.Deletion_Flag__c = true;
        
        update account;
        update contact;
        update creditInformation;
        
        //Undeletes the objects by setting deletion flag to false
        account.Deletion_Flag__c = false;
        contact.Deletion_Flag__c = false;
        creditInformation.Deletion_Flag__c = false;
        
        update account;
        update contact;
        update creditInformation;
        
        //Assert
        
        Account[] accountList = [SELECT Id, Deletion_Flag__c FROM Account WHERE Id = :account.Id];
        Contact[] contactList = [SELECT Id, Deletion_Flag__c FROM Contact WHERE Id = :contact.Id];
        Credit_Information__c[] creditInformationList = [SELECT Id, Deletion_Flag__c FROM Credit_Information__c WHERE Id = :creditInformation.Id];
        test.stopTest();       
        //Logical undelete
        System.assert(accountList.size() == 1, 'Account should not be physical deleted');
        System.assert(accountList[0].Deletion_Flag__c == false, 'Deletion_Flag__c should be false');
        System.assert(contactList.size() == 1, 'Contact should not be physical deleted');
        System.assert(contactList[0].Deletion_Flag__c == false, 'Deletion_Flag__c should be false');
        System.assert(creditInformationList.size() == 1, 'Credit Information should not be physical deleted');
        System.assert(creditInformationList[0].Deletion_Flag__c == false, 'Deletion_Flag__c should be false');
    }

    static testMethod void testUndeleteParent() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        //Parrent
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        //Child record
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        Credit_Information__c creditInformation = new Credit_Information__c();
        creditInformation.Account__c = account.Id;
        
        insert contact;
        insert creditInformation;

        //Act
        
        test.startTest();
        //Deletes the objects by setting deletion flag
        account.Deletion_Flag__c = true;
        update account;
        
        //Undeletes the objects by setting deletion flag to false
        account.Deletion_Flag__c = false;
        update account;

        //Assert
        Account[] accountList = [SELECT Id, Deletion_Flag__c FROM Account WHERE Id = :account.Id];
        Contact[] contactList = [SELECT Id, Deletion_Flag__c FROM Contact WHERE Id = :contact.Id];
        Credit_Information__c[] creditInformationList = [SELECT Id, Deletion_Flag__c FROM Credit_Information__c WHERE Id = :creditInformation.Id];
        test.stopTest();
        
        //Logical delete: The delete flag on the children should remain the same.
        System.assert(accountList.size() == 1, 'Account should not be physical deleted');
        System.assert(accountList[0].Deletion_Flag__c == false, 'Deletion_Flag__c should be false');
        System.assert(contactList.size() == 1, 'Contact should not be physical deleted');
        System.assert(contactList[0].Deletion_Flag__c == true, 'Deletion_Flag__c should be true');
        System.assert(creditInformationList.size() == 1, 'Credit Information should not be physical deleted');
        System.assert(creditInformationList[0].Deletion_Flag__c == true, 'Deletion_Flag__c should be true');
    }
    
    static testMethod void testDeleteFlagValidation() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        //The following objects has validations on BeforeDelete trigger preventing deletion on records without deletion flag set to true
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        Contact contact = UTIL_TestFactory.createContact();
        contact.AccountId = account.Id;
        insert contact;
        
        //Act and Assert
        test.startTest();
        
        // Try to deletes the objects without setting the deletion flag first
		try{
			delete contact;
			System.assert(true, 'Contact should not have been deleted');
		} catch(Exception e) {}
		
		try{
			delete account;
			System.assert(true, 'Account should not have been deleted');
		} catch(Exception e) {}
		
        test.stopTest();    
    }
}