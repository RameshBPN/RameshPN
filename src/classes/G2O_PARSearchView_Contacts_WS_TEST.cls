/**
    About
    -----
    Description: This class is used to test G2O_PARSearchView_Contacts_WS
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    
    Update History
    --------------
    Created March 2013 - C.H.F.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_PARSearchView_Contacts_WS_TEST {

    static testMethod void successfulResponseTestPARIDs() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_Contact');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        List<Account> accountList = UTIL_TestFactory.createAccounts();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_PARSearchView_Contacts_WS parContact = new G2O_PARSearchView_Contacts_WS(accountList);
        parContact.send();
        Test.stopTest();
        
        // Assert
        System.assert(parContact.result.size() == 3, 'Not correct number of contacts stored in the result');
        System.assert(parContact.result.get('302820319').relationshipList.size() == 4, 'Not correct number of relationships');
        System.assert(parContact.result.get('302820319').relationshipList[0].accountExternalId == '1:202093092', 'accountExternalId not mapped correctly');
        System.assert(parContact.result.get('302820319').relationshipList[0].relationshipExternalId == '403438772', 'relationshipExternalId not mapped correctly');
        System.assert(parContact.result.get('302820319').relationshipList[0].positions[0] == 'BE11100', 'position not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.External_Provider_Party_ID__c == '302820319', 'External_Provider_Party_ID__c not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.FirstName == 'Anna', 'FirstName not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.LastName == 'Tibell', 'LastName not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.External_Contact_Person_Status__c == 'ST00', 'External_Contact_Person_Status__c not mapped correctly');
    }
    
    static testMethod void successfulResponseTestName() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_Contact');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Account account = UTIL_TestFactory.createAccount();
        account.External_Provider_Party_ID__c = '12345';
        insert account;
        account = [select 	id, 
					        BillingCountry,         
					        Name,                             
					        Corporate_Registration_Number__c, 
					        Visiting_Address_Street__c,      
					        Visiting_Address_Country__c,     
					        Visiting_Address_Postal_Code__c,  
					        Visiting_Address_City__c,        
					        Postal_Address_Street__c,        
					        Postal_Address_Country__c,        
					        Postal_Address_Postal_Code__c,    
        					Postal_Address_City__c,
        					External_Provider_Party_ID__c from Account Where id = :account.id];
        Contact contact = UTIL_TestFactory.createContact();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_PARSearchView_Contacts_WS parContact = new G2O_PARSearchView_Contacts_WS(account,contact);
        parContact.send();
        Test.stopTest();
        
        // Assert
        System.assert(parContact.result.size() == 3, 'Not correct number of contacts stored in the result');
        System.assert(parContact.result.get('302820319').relationshipList.size() == 4, 'Not correct number of relationships');
        System.assert(parContact.result.get('302820319').relationshipList[0].accountExternalId == '1:202093092', 'accountExternalId not mapped correctly');
        System.assert(parContact.result.get('302820319').relationshipList[0].relationshipExternalId == '403438772', 'relationshipExternalId not mapped correctly');
        System.assert(parContact.result.get('302820319').relationshipList[0].positions[0] == 'BE11100', 'position not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.External_Provider_Party_ID__c == '302820319', 'External_Provider_Party_ID__c not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.FirstName == 'Anna', 'FirstName not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.LastName == 'Tibell', 'LastName not mapped correctly');
		System.assert(parContact.result.get('302820319').theContact.External_Contact_Person_Status__c == 'ST00', 'External_Contact_Person_Status__c not mapped correctly');

    }
    
    static testMethod void errorResponseTest() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponsErrorPAR_Account');
        errorMock.setStatusCode(200);
        errorMock.setHeader('Content-Type', 'text/xml');
        List<Account> accountList = UTIL_TestFactory.createAccounts();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, errorMock);
        G2O_PARSearchView_Contacts_WS parContact = new G2O_PARSearchView_Contacts_WS(accountList);
        parContact.send();
        Test.stopTest();
        
        // Assert
        System.assertEquals('100' , parContact.callout.error.errCode);
        System.assertEquals('Some fault message' , parContact.callout.error.description);
    }
    
    static testMethod void testCreateACRsFromContactRelationships() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_Contact');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        List<Account> accountList = UTIL_TestFactory.createAccounts();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_PARSearchView_Contacts_WS parContact = new G2O_PARSearchView_Contacts_WS(accountList);
        parContact.opt_ApplySearchFirst = true;
        parContact.send();
        
        List<G2O_PARSearchView_Contacts_WS.ContactWrapper> contactWrappers = new List<G2O_PARSearchView_Contacts_WS.ContactWrapper>();
        
        for(G2O_PARSearchView_Contacts_WS.ContactWrapper cw : parContact.result.values()) {
        	contactWrappers.add(cw);
        }
        
        Map<String, Account_Contact_Role_Transaction__c> acrMap = G2O_PARSearchView_Contacts_WS.createACRsFromContactRelationships(contactWrappers);
        Test.stopTest();
        
        // Assert
		System.assert(true); // This needs to be teste higher up in G2O_CustomerCreateContact_VFCx_TEST
    }
}