/**
    About
    -----
    Description: This class is used to test G2O_MODValidation_WS
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
private class G2O_MODValidation_WS_TEST {

    static testMethod void successfulResponseTestB2B() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsMOD');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Account account = UTIL_TestFactory.createAccount();
        account.Postal_Address_House_Number__c		=	'10';
        account.Postal_Address_House_Letter__c		= 	'A';
        account.Postal_Address_Postal_Code__c		=	'1234';
        account.Postal_Address_Street__c			=	'Street';
        account.Corporate_Registration_Number__c	=	'847598';
        account.Work_Site_Registration_Number__c	=	'7515465';
        account.Postal_Address_City__c				=	'City';
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_MODValidation_WS mod = new G2O_MODValidation_WS(account, G2O_MODValidation_WS.QueryType.B2B);
        mod.send();
        Test.stopTest();
        
        // Assert
        System.assertEquals(19, mod.resultList.size());
        System.assertEquals('Konservator Jørgen Bau', mod.resultList[0].Name);
        System.assertEquals('4', mod.resultList[0].Postal_Address_House_Number__c);
        System.assertEquals('B', mod.resultList[0].Postal_Address_House_Letter__c);
        System.assertEquals(false, mod.resultList[0].Secret_Address__c);

    }
    
    static testMethod void successfulResponseTestB2C() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsMOD');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Account account = UTIL_TestFactory.createPersonAccount();
        account.Postal_Address_Postal_Code__c		=	'1234';
        account.Postal_Address_Street__c			=	'Street';
        account.firstName							=	'first';
        account.lastName							=	'last';
        account.Postal_Address_City__c				=	'City';
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_MODValidation_WS mod = new G2O_MODValidation_WS(account, G2O_MODValidation_WS.QueryType.B2C);
        mod.send();
        Test.stopTest();
        
        // Assert
        System.assertEquals(19, mod.resultList.size());
    }
    
    static testMethod void errorResponseTest() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponsErrorMOD');
        errorMock.setStatusCode(200);
        errorMock.setHeader('Content-Type', 'text/xml');
        Account account = UTIL_TestFactory.createAccount();
        account.Postal_Address_Postal_Code__c		=	'1234';
        account.Postal_Address_Street__c			=	'Street';
        account.Corporate_Registration_Number__c	=	'847598';
        account.Work_Site_Registration_Number__c	=	'7515465';
        account.Postal_Address_City__c				=	'City';
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, errorMock);
        G2O_MODValidation_WS mod = new G2O_MODValidation_WS(account, G2O_MODValidation_WS.QueryType.B2B);
        mod.send();
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, mod.callout.error);
        System.assertEquals('USR', mod.callout.error.errCode);
        System.assertEquals('Ingen modtagere matcher de indtastede kriterier.', mod.callout.error.description);
    }
    
    
}