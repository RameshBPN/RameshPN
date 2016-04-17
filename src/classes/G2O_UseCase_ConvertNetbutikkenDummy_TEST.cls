/**
    About
    -----
    Description:    This class contains Use case tests relating to the automatic converting of Dummy Accounts from Netbutikken
    *               When an integration user is updating a Netbutikken dummy record it should convert to an
    *               Unverified Private Person Account or an Unverified Worksite.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2013
    
    Details
    -------
    1. Converts a B2B dummy account with an integration user
    2. Converts a B2C dummy account with an integration user
    3. Converts a non dummy account with an integration user
    
    Update History
    --------------
    Created August 2013 based on the Sprint03_ConvertNetbutikkenDummy_TEST class - K.E.A.J.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_UseCase_ConvertNetbutikkenDummy_TEST {
    
    // Tests a B2B dummy account updated to prospect by an integration user
    static testMethod void convertB2BNetbutikkenDummyAccount() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();    
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        
        Account dummyAccount = UTIL_TestFactory.createAccount();
        dummyAccount.RecordTypeId = UTIL_Meta.getAccountB2BWebshopPlaceHolderRT();
        dummyAccount.Name = UTIL_OrgSettings.webshop_B2B_Name();
        insert dummyAccount;
        
        //Act
        Account insertedAccount = [SELECT Id, Involved_Party_ID__c FROM Account Where Id =: dummyAccount.Id];
        insertedAccount.Name = 'New Name';
        System.runAs(integrationUser) {
            upsert insertedAccount insertedAccount.Involved_Party_ID__c;
        }

        //Assert
        Account updatedAccount = [SELECT Id, Name, RecordTypeId, Verified__c, Converted_From_Webshop_Dummy__c FROM Account Where Id =: insertedAccount.Id];
        System.assertEquals(UTIL_Meta.getAccountWorkSiteRT(), updatedAccount.RecordTypeId, 'The Account record type should have changed to a Work Site');
        System.assertEquals('N', updatedAccount.Verified__c, 'The Verified state of the account was expected to be N, received: ' + updatedAccount.Verified__c);
        System.assertEquals(true, updatedAccount.Converted_From_Webshop_Dummy__c, 'It should be marked on the account that it was converted from a webshop dummy');
    }

    // Tests a B2C dummy account updated to prospect by an integration user    
    static testMethod void convertB2CNetbutikkenDummyAccount() {
        // Arrange
        UTIL_TestFactory.createGet2OneCrm();    
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        
        Account dummyAccount = UTIL_TestFactory.createPersonAccount();
        dummyAccount.RecordTypeId = UTIL_Meta.getAccountB2CWebshopPlaceHolderRT();
        dummyAccount.LastName = UTIL_OrgSettings.webshop_B2C_Name();
        insert dummyAccount;
        
        //Act
        Account insertedAccount = [SELECT Id, Involved_Party_ID__c FROM Account Where Id =: dummyAccount.Id];
        insertedAccount.LastName = 'New Name';
        System.runAs(integrationUser) {
            upsert insertedAccount insertedAccount.Involved_Party_ID__c;
        }
        
        // Assert
        Account updatedAccount = [SELECT Id, LastName, RecordTypeId, Verified__c, Converted_From_Webshop_Dummy__c, Type FROM Account Where Id =: insertedAccount.Id];
        System.assertEquals(UTIL_meta.getPersonAccountRT(), updatedAccount.RecordTypeId, 'The Account record type should have changed to a PersonAccount');
        System.assertEquals('N', updatedAccount.Verified__c, 'The Verified state of the account was expected to be N, received: ' + updatedAccount.Verified__c);
        System.assertEquals(true, updatedAccount.Converted_From_Webshop_Dummy__c, 'It should be marked on the account that it was converted from a webshop dummy');
    }
    
    // Tests that if an integration user converts a non dummy account it is not subject to the dummy conversion rules
    static testMethod void convertNonDummyAccount() {
    	
        // Arrange
        UTIL_TestFactory.createGet2OneCrm();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        Account dummyAccount = UTIL_TestFactory.createAccount();
        dummyAccount.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        dummyAccount.Name = UTIL_OrgSettings.Webshop_B2B_Name();
        insert dummyAccount;
        
        //Act
        Account insertedAccount = [SELECT Id, Involved_Party_ID__c FROM Account Where Id =: dummyAccount.Id];
        insertedAccount.Name = 'New Name';
        System.runAs(integrationUser) {
            upsert insertedAccount insertedAccount.Involved_Party_ID__c;
        }
        
        // Assert
        System.assertEquals(UTIL_Meta.getAccountLegalEntityRT(), dummyAccount.RecordTypeId, 'The account record type should remain as Legal Entity, ' + dummyAccount.RecordTypeId);
        System.assertEquals(false, dummyAccount.Converted_From_Webshop_Dummy__c, 'The Account should not be marked as it if was converted from a webshop dummy');
    }
}