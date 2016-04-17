/**
    About
    -----
    Description: This class is used to test TransactionSecurityFlags_SVC and corresponging triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    1-3: Tests TransactionSecurityFlag behavior on Account
    4-5: Tests TransactionSecurityFlag behavior on Contact
    6-7: Tests TransactionSecurityFlag behavior on Account Contact Relation Transaction
    8-9: Tests TransactionSecurityFlag behavior on Bank Detail
    9-11: Tests TransactionSecurityFlag behavior on Credit Information
    12-13: Tests TransactionSecurityFlag behavior on Relationship
    14-15: Tests TransactionSecurityFlag behavior on Sales Area Information
    16-17: Tests TransactionSecurityFlag behavior on Outbound Notification
    
    Update History
    --------------
    Created March 2013 - C.H.F.
    Merged Sprint02_TransactionSecurityFlags_TEST into the class, and added structure - K.E.A.J
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_TransactionSecurityFlags_SVC_TEST {

    /* Tests for Account */
    // 1. Tests that when the PN_Mark_As_Synced__c flag is false no change is made on account update.
    static testMethod void testUpdateTransactionSecurityFlagsNoChange() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        // Act
        account.Name = 'false';
        update account;
        
        Account accountAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Account WHERE Id = :account.Id];
        
        // Assert
        System.assertEquals(false, account.PN_Mark_As_Synced__c, 'the PN_Mark_As_Synced__c flag was false before the update, and should be after');
        System.assertEquals(false, accountAfterUpdate.PN_Mark_As_Synced__c, 'the PN_Mark_As_Synced__c flag was false before the update, and should be after');
        System.assertEquals(false, accountAfterUpdate.PN_Synchronized__c, 'the PN_Mark_As_Synced__c flag was false before the update, so should the PN_Synchronized__c flag be after');
    }
    
    // 2. Tests that an account marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsAccount() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Account> accountList = UTIL_TestFactory.createAccounts();
        insert accountList;
        
        // Act
        List<Account> accountListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c FROM Account LIMIT 200];
        
        for (Account account : accountListBeforeUpdate) {
            account.PN_Mark_As_Synced__c = true;
        }
        update accountListBeforeUpdate;
        
        List<Account> accountListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Account WHERE Id = :accountListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, accountListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the Account should be marked as synced');
        System.assertEquals(false, accountListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the Account should no longer be marked as synced');
        System.assertEquals(true, accountListAfterUpdate[0].PN_Synchronized__c, 'After the update the Account should be marked as Synchronized');
        
    }
    
    // 3. Tests that changing the name of an account will change it form synchronized to not synchronized
    static testMethod void testSetSynchronizedToFalseAccount() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Account> accountList = UTIL_TestFactory.createAccounts();
        for (Account account : accountList) {
            account.PN_Synchronized__c = true;
        }
        insert accountList;
        
        // Act
        List<Account> accountListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Account LIMIT 200];
        
        for (Account account : accountListBeforeUpdate) {
            account.Name = 'NOW ' + String.valueOf(System.now());
        }
        update accountListBeforeUpdate;
        
        List<Account> accountListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Account WHERE Id = :accountListBeforeUpdate];
        
        // Assert
        System.assertEquals(false, accountListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, accountListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the accounts name is changed');
    }
    
    /** Tests for Contact */
    // 4. Tests that a contact marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsContact() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account acc = UTIL_TestFactory.createAccount();
        insert acc;
        List<Contact> contactList = UTIL_TestFactory.createContacts();
        for(Contact cont : contactList){
        	cont.AccountId = acc.id;
        }
        insert contactList;
        
        // Act
        List<Contact> contactListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c FROM Contact LIMIT 200];
        
        for (Contact contact : contactListBeforeUpdate) {
            contact.PN_Mark_As_Synced__c = true;
        }
        update contactListBeforeUpdate;
        
        List<Contact> contactListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Contact WHERE Id = :contactListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, contactListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the Contact should be marked as synced');
        System.assertEquals(false, contactListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the Contact should no longer be marked as synced');
        System.assertEquals(true, contactListAfterUpdate[0].PN_Synchronized__c, 'After the update the Contact should be marked as Synchronized');        
    }

    // 5. Tests that changing the name of a contact will change it form synchronized to not synchronized    
    static testMethod void testSetSynchronizedToFalseContact() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account acc = UTIL_TestFactory.createAccount();
        insert acc;
        List<Contact> contactList = UTIL_TestFactory.createContacts();
        for (Contact contact : contactList) {
            contact.PN_Synchronized__c = true;
        	contact.AccountId = acc.id;            
        }
        insert contactList;
        
        // Act
        List<Contact> contactListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Contact LIMIT 200];
        
        for (Contact contact : contactListBeforeUpdate) {
            contact.LastName = 'NOW ' + String.valueOf(System.now());
        }
        update contactListBeforeUpdate;
        
        List<Contact> contactListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Contact WHERE Id = :contactListBeforeUpdate];
        
        // Assert
        System.assertEquals(false, contactListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, contactListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the contact last name is changed');
     }
    
    /** Tests for Account Contact Role Transaction (ACRT) */
    // 6. Tests that an Account Contact Role Transaction marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsAcrt() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Account_Contact_Role_Transaction__c> acrtListBeforeUpdate = UTIL_TestFactory.createAcrts();
        
        // Act        
        for (Account_Contact_Role_Transaction__c acrt : acrtListBeforeUpdate) {
            acrt.PN_Mark_As_Synced__c = true;
        }
        update acrtListBeforeUpdate;
        
        List<Account_Contact_Role_Transaction__c> acrtListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Account_Contact_Role_Transaction__c WHERE Id = :acrtListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, acrtListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the Account Contact Role Transaction should be marked as synced');
        System.assertEquals(false, acrtListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the Account Contact Role Transaction should no longer be marked as synced');
        System.assertEquals(true, acrtListAfterUpdate[0].PN_Synchronized__c, 'After the update the Account Contact Role Transaction should be marked as Synchronized');        
    }

    // 7. Tests that changing the primary position of an ACRT will change it form synchronized to not synchronized        
    static testMethod void testSetSynchronizedToFalseAcrt() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Account_Contact_Role_Transaction__c> acrtList = UTIL_TestFactory.createAcrts();
        for (Account_Contact_Role_Transaction__c acrt : acrtList) {
            acrt.PN_Synchronized__c = true;
        }
        update acrtList;
        
        // Act
        List<Account_Contact_Role_Transaction__c> acrtListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Account_Contact_Role_Transaction__c LIMIT 200];
        
        for (Account_Contact_Role_Transaction__c acrt : acrtListBeforeUpdate) {
            acrt.Primary_Position__c = 'NOW ' + String.valueOf(System.now());
        }
        update acrtListBeforeUpdate;
        
        List<Account_Contact_Role_Transaction__c> acrtListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Account_Contact_Role_Transaction__c WHERE Id = :acrtListBeforeUpdate];
        
        // Assert
        System.assertEquals(false, acrtListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, acrtListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the ACRT Primary position is changed');
    }
    
    /** Tests for Bank Details */
    // 8. Tests that a Bank Detail marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsBankDetail() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Bank_Details__c> bankDetailList = UTIL_TestFactory.createBankDetails();
        insert bankDetailList;
        
        // Act
        List<Bank_Details__c> bankDetailListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c FROM Bank_Details__c LIMIT 200];
        
        for (Bank_Details__c bankDetail : bankDetailListBeforeUpdate) {
            bankDetail.PN_Mark_As_Synced__c = true;
        }
        update bankDetailListBeforeUpdate;
        
        List<Bank_Details__c> bankDetailListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Bank_Details__c WHERE Id = :bankDetailListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, bankDetailListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the Bank Detail should be marked as synced');
        System.assertEquals(false, bankDetailListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the Bank Detail should no longer be marked as synced');
        System.assertEquals(true, bankDetailListAfterUpdate[0].PN_Synchronized__c, 'After the update the Bank Detail should be marked as Synchronized');                
    }
    
    // 9. Tests that changing the IBAN number of a Bank Detail will change it form synchronized to not synchronized   
    static testMethod void testSetSynchronizedToFalseBankDetail() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Bank_Details__c> bankDetailList = UTIL_TestFactory.createBankDetails();
        insert bankDetailList;
        for (Bank_Details__c bankDetail : bankDetailList) {
            bankDetail.PN_Mark_As_Synced__c = true;
        }
        update bankDetailList; // PN_Synchronized__c will be set to true
        
        // Act
        List<Bank_Details__c> bankDetailListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Bank_Details__c WHERE Id IN :bankDetailList];
        
        for (Bank_Details__c bankDetail : bankDetailListBeforeUpdate) {
            bankDetail.IBAN_Number__c = 'NOW ' + String.valueOf(System.now());
        }
        update bankDetailListBeforeUpdate; // PN_Synchronized__c will be set to false
        
        List<Bank_Details__c> bankDetailListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Bank_Details__c WHERE Id IN :bankDetailList];
        
        // Assert
        System.assertEquals(false, bankDetailListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, bankDetailListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the Band Details IBAN number is changed');
    }
    
    /** Tests for Credit Information */
    // 10. Tests that a Credit Information marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsCreditInformation() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Credit_Information__c> creditInformationList = UTIL_TestFactory.createCreditInformations();
        insert creditInformationList;
        
        // Act
        List<Credit_Information__c> creditInformationListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c FROM Credit_Information__c LIMIT 200];
        
        for (Credit_Information__c creditInformation : creditInformationListBeforeUpdate) {
            creditInformation.PN_Mark_As_Synced__c = true;
        }
        update creditInformationListBeforeUpdate;
        
        List<Credit_Information__c> creditInformationListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Credit_Information__c WHERE Id = :creditInformationListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, creditInformationListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the Credit Information should be marked as synced');
        System.assertEquals(false, creditInformationListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the Credit Information should no longer be marked as synced');
        System.assertEquals(true, creditInformationListAfterUpdate[0].PN_Synchronized__c, 'After the update the Credit Information should be marked as Synchronized');        
    }
 
     // 11. Tests that changing the credit limit of a Credit Information will change it form synchronized to not synchronized      
    static testMethod void testSetSynchronizedToFalseCreditInformation() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Credit_Information__c> creditInformationList = UTIL_TestFactory.createcreditInformations();
        for (Credit_Information__c creditInformation : creditInformationList) {
            creditInformation.PN_Synchronized__c = true;
        }
        insert creditInformationList;
        
        // Act
        List<Credit_Information__c> creditInformationListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Credit_Information__c LIMIT 200];
        
        for (Credit_Information__c creditInformation : creditInformationListBeforeUpdate) {
            creditInformation.Credit_Limit__c = Math.random();
        }
        update creditInformationListBeforeUpdate;
        
        List<Credit_Information__c> creditInformationListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Credit_Information__c WHERE Id = :creditInformationListBeforeUpdate];
        
        // Assert
        System.assertEquals(false, creditInformationListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, creditInformationListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the Credit Informations Credit limit is changed');
    }
    
    /** Tests for Relationship */
    // 12. Tests that a Relationship marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsRelationship() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        
        List<Relationship__c> relationshipList = UTIL_TestFactory.createRelationships();
        insert relationshipList;
        
        // Act
        List<Relationship__c> relationshipListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c FROM Relationship__c LIMIT 200];
        for (Relationship__c relationship : relationshipListBeforeUpdate) {
            relationship.PN_Mark_As_Synced__c = true;
        }
        update relationshipListBeforeUpdate;
        
        List<Relationship__c> relationshipListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Relationship__c WHERE Id = :relationshipListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, relationshipListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the Relationship should be marked as synced');
        System.assertEquals(false, relationshipListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the Relationship should no longer be marked as synced');
        System.assertEquals(true, relationshipListAfterUpdate[0].PN_Synchronized__c, 'After the update the Relationship should be marked as Synchronized');        
    }
	
	// 13. Tests that changing the Relationship type of a Relationship will change it form synchronized to not synchronized          
    static testMethod void testSetSynchronizedToFalseRelationship() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Relationship__c> relationshipList = UTIL_TestFactory.createRelationships();
        for (Relationship__c relationship : relationshipList) {
            relationship.PN_Synchronized__c = true;
        }
        insert relationshipList;
        
        // Act
        List<Relationship__c> relationshipListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Relationship__c LIMIT 200];
        //Do an update on the relationship objects, an "empty" update where no fields are updated is enough
        update relationshipListBeforeUpdate;
        
        List<Relationship__c> relationshipListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Relationship__c WHERE Id = :relationshipListBeforeUpdate];
        
        // Assert
        System.assertEquals(false, relationshipListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, relationshipListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the Relationships relationship type is changed');
    }
    
    /** Tests for Sales Area Information */
    // 14. Tests that a Sales Area Information marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsSalesAreaInformation() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Sales_Area_Information__c> salesAreaInformationsList = UTIL_TestFactory.createSalesAreaInformations();
        insert salesAreaInformationsList;
        
        // Act
        List<Sales_Area_Information__c> salesAreaInformationsListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c FROM Sales_Area_Information__c LIMIT 200];
        
        for (Sales_Area_Information__c salesAreaInformations : salesAreaInformationsListBeforeUpdate) {
            salesAreaInformations.PN_Mark_As_Synced__c = true;
        }
        update salesAreaInformationsListBeforeUpdate;
        
        List<Sales_Area_Information__c> salesAreaInformationsListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Sales_Area_Information__c WHERE Id = :salesAreaInformationsListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, salesAreaInformationsListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the Relationship should be marked as synced');
        System.assertEquals(false, salesAreaInformationsListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the Relationship should no longer be marked as synced');
        System.assertEquals(true, salesAreaInformationsListAfterUpdate[0].PN_Synchronized__c, 'After the update the Relationship should be marked as Synchronized');
    }

     // 15. Tests that changing the invouce list schedule of a Sales Area Information will change it form synchronized to not synchronized              
    static testMethod void testSetSynchronizedToFalseSalesAreaInformation() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Sales_Area_Information__c> salesAreaInformationList = UTIL_TestFactory.createSalesAreaInformations();
        for (Sales_Area_Information__c salesAreaInformation : salesAreaInformationList) {
            salesAreaInformation.PN_Synchronized__c = true;
        }
        insert salesAreaInformationList;
        
        // Act
        List<Sales_Area_Information__c> salesAreaInformationListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Sales_Area_Information__c LIMIT 200];
        
        for (Sales_Area_Information__c salesAreaInformation : salesAreaInformationListBeforeUpdate) {
            salesAreaInformation.Invoice_List_Schedule__c =  'NOW ' + String.valueOf(System.now());
        }
        update salesAreaInformationListBeforeUpdate;
        
        List<Sales_Area_Information__c> salesAreaInformationListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Sales_Area_Information__c WHERE Id = :salesAreaInformationListBeforeUpdate];
        
        // Assert
        System.assertEquals(false, salesAreaInformationListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, salesAreaInformationListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the Sales Area Informations Invoice list schedule is changed');
    }
    
    /** Tests for Outbound Notification */
    // 16. Tests that a Outbound Notification marked as synced will be synchronized and no longer be marked as synced after an update.
    static testMethod void testUpdateTransactionSecurityFlagsOutboundNotification() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Outbound_Notification__c> obnList = UTIL_TestFactory.createOutboundNotifications(200);
        insert obnList;
        
        // Act
        List<Outbound_Notification__c> obnListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c FROM Outbound_Notification__c LIMIT 200];
        
        for (Outbound_Notification__c obn : obnListBeforeUpdate) {
            obn.PN_Mark_As_Synced__c = true;
        }
        update obnListBeforeUpdate;
        
        List<Outbound_Notification__c> obnListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Outbound_Notification__c WHERE Id = :obnListBeforeUpdate];
        
        // Assert
        System.assertEquals(true, obnListBeforeUpdate[0].PN_Mark_As_Synced__c, 'Before the update the OBN should be marked as synced');
        System.assertEquals(false, obnListAfterUpdate[0].PN_Mark_As_Synced__c, 'After the update the OBN should no longer be marked as synced');
        System.assertEquals(true, obnListAfterUpdate[0].PN_Synchronized__c, 'After the update the OBN should be marked as Synchronized');
    }

     // 17. Tests that upserting to the Outbound Notification record with a new SFDC ID will change it form synchronized to not synchronized              
    static testMethod void testSetSynchronizedToFalseOutboundNotification() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        List<Outbound_Notification__c> obnList = UTIL_TestFactory.createOutboundNotifications(200);
        for (Outbound_Notification__c obn : obnList) {
            obn.PN_Synchronized__c = true;
        }
        insert obnList;
        
        // Act
        List<Outbound_Notification__c> obnListBeforeUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Outbound_Notification__c LIMIT 200];
        
        for (Outbound_Notification__c obn : obnListBeforeUpdate) {
            obn.Object_SFDC_ID__c = String.valueOf(System.now()).right(18);
        }
        update obnListBeforeUpdate;
        
        List<Outbound_Notification__c> obnListAfterUpdate = [SELECT Id, PN_Mark_As_Synced__c, PN_Synchronized__c FROM Outbound_Notification__c WHERE Id = :obnListBeforeUpdate];
        
        // Assert
        System.assertEquals(false, obnListAfterUpdate[0].PN_Mark_As_Synced__c, 'PN_Mark_As_Synced__c was false before, expected it to be false after update');
        System.assertEquals(false, obnListAfterUpdate[0].PN_Synchronized__c, 'PN_Synchronized__c should be false after the SFDC ID field is changed');
    }
}