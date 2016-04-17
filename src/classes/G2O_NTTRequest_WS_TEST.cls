/**
    About
    -----
    Description: This class is used to test G2O_NTTRequest_WS
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
private class G2O_NTTRequest_WS_TEST {

    static testMethod void successfulResponseTest() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsNTT');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        
        Account senderAccount = UTIL_TestFactory.createAccount();
        senderAccount.RecordTypeId = UTIL_Meta.getAccountPostNordOrgStructureRT();
        senderAccount.GTT_Customer_Number__c = '5001285203';
        insert senderAccount;
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_NTTRequest_WS ntt = new G2O_NTTRequest_WS('85829178741SE');
        ntt.send();
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, ntt.result);
        System.assertEquals('85829178741SE', ntt.result.nttCase.Item_Id__c);
        System.assertEquals('PY016486055DK', ntt.result.nttCase.Alternate_Item_Id__c);
        System.assertEquals('21', ntt.result.nttHistoryList[0].Event_Code__c);
        System.assertEquals('DELIVERED', ntt.result.nttCaseProduct.Status__c);
        System.assertEquals(senderAccount.Id, ntt.result.nttCase.Sender__c);

    }
    
    static testMethod void errorResponseTest() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponsErrorNTT');
        errorMock.setStatusCode(200);
        errorMock.setHeader('Content-Type', 'text/xml');
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, errorMock);
        G2O_NTTRequest_WS ntt = new G2O_NTTRequest_WS('85829178741SE');
        ntt.send();
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, ntt.callout.error);
        System.assertEquals('unsupportedLocale', ntt.callout.error.errCode);
        System.assertEquals('Locale not supported', ntt.callout.error.description);
    }
    
    
}