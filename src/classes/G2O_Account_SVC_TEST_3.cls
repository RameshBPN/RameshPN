/**
    About
    -----
    Description: This class is used to test Account_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2014
    
    Details
    -------
    This Class test the functionality of Account_SVC class Part 3 of 3.
    1. Ensure duplication logic does not interfere with upsert operations (TEMP AUG '14 M.E., TO BE RE-WRITTEN FOR RELEASE AUG 25th '14)
    
    Update History
    --------------
    2. Contact Center project - Fluido Denmark - Test case to normalise phone numbers
    3. New range of PN Internal customers - Capgemini - Test Case scenario for New Range of PN internal customer Creation 'PostNord Internal PN SE/ PN DK' - 30th December 2015
    
    
    Created Agust 2014 - M.E.
    
    Issues / TODOs
    --------------
    
*/

@isTest
public with sharing class G2O_Account_SVC_TEST_3 {
    
    static User integrationUser;
    
    //1. Ensure duplication logic does not interfere with upsert operations (TEMP AUG '14 M.E., TO BE RE-WRITTEN FOR RELEASE AUG 25th '14)
    static testMethod void ensureDuplicationFailSurpressed() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        //adminUser = UTIL_TestFactory.createAdmin('testAdmin@get2One.com');
        integrationUser = UTIL_TestFactory.createIntegrationUser('testIntegration@get2One.com');
        
        // Act
        Test.startTest();
        system.runAs(integrationUser){
            
            // Create faulty B2C accounts with no first name
            Id b2cRecordTypeId = UTIL_Meta.getAccountB2CWebshopPlaceHolderRT();
            Integer quantity = 5;
            String accountType = 'B2C';
            Integer counter = 0;
            
            Account[] corruptAccounts = new Account[]{};
            Account[] newAccounts = new Account[]{};
            
            for(Integer i = 0; i < quantity; i++) {
                Account account = new Account();
                Account account2 = new Account();
    
                account.RecordTypeId = b2cRecordTypeId;
                account.LastName = UTIL_OrgSettings.webshop_B2C_Name();
                
                account2.RecordTypeId = b2cRecordTypeId;
                account2.LastName = UTIL_OrgSettings.webshop_B2C_Name();
                
                corruptAccounts.add(account);
                newAccounts.add(account2);
            }
            
            insert corruptAccounts;
            insert newAccounts;
            
            // Incorrectly convert one set with no first name to corrupt the records
            for (Account a: corruptAccounts)
            {
                counter++;
                // Misses out first name
                a.LastName = 'account';
                a.Email_Address__c = 'some_corrupt_email'+counter+'@testmail.test';
            }
            // TODO: If validation errors are fixed then an assert should go here to ensure that these fail. Today they should succeed.
            update corruptAccounts;
            
            // Correctly convert these accounts. No errors should be thrown
            for (Account a: newAccounts)
            {
                counter++;
                a.FirstName = 'first';
                a.LastName = 'account';
                a.Email_Address__c = 'some_email'+counter+'@testmail.test';
            }
            update corruptAccounts;
            
        }
        Test.stopTest();
    }

    //2.  Contact Center project - Fluido Denmark - Test case to normalise phone numbers
    static testMethod void normalisePhoneNumbers() {
        // create country code custom settings
        Country_Calling_Codes__c cc = new Country_Calling_Codes__c();
        cc.Name = 'DK';
        cc.Code__c = '45';
        cc.Country__c = 'DENMARK';
        insert cc;
        
        UTIL_TestFactory.setUpOrg();

        // create a sample account
        Account acct = UTIL_TestFactory.createAccount();
        acct.Phone = '60602020';
        acct.Mobile_Phone__c = '50501010';
        insert acct;
        system.assert(acct.Id != null);
         
        Account act = [SELECT Id, CC_Phone__c, CC_Mobile__c FROM Account WHERE Id = :acct.Id];
        system.assert(act.Id != null);
        system.assertEquals(act.CC_Phone__c, '+4560602020');
        system.assertEquals(act.CC_Mobile__c, '+4550501010');
    }
    
    //3. Test Case for New range of internal customsers - 'PostNord Internal PN SE/ PN DK'
    static testMethod void createNewRangeOfPNInternalCustomers() {
        
        UTIL_TestFactory.setupOrg();
        
        Account account =  UTIL_TestFactory.createAccount();
        account.External_or_Internal__c = 'PostNord Internal PN DK';
        insert account;
        
        system.assert(account.Id != null, 'Account Insertion Failed');
         
        Account act = [SELECT Id, External_or_Internal__c, Involved_Party_ID__c FROM Account WHERE Id = :account.Id];
            String accountNumber = String.valueOf(act.Involved_Party_ID__c); 
        
        system.assertEquals(act.External_or_Internal__c, 'PostNord Internal PN DK');
        //system.assert(accountNumber.startsWith('42'), 'Account Id/number is not in Range');

        account.Deletion_Flag__c = True;
        update account;
        
        delete account;
        system.assert(true, account.IsDeleted);

    } 
    
}