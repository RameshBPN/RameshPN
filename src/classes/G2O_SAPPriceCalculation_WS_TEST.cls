/**
    About
    -----
    Description: This class is used to test G2O_SAPPriceCalculation_WS
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    
    Update History
    --------------
    Created March 2013 - C.H.F.
    
    Issues / TODOs
    
*/
@isTest
private class G2O_SAPPriceCalculation_WS_TEST {

    static testMethod void successfulResponseTest() {
        User u = UTIL_TestFactory.createUser('SAPTestUser@test.test', 'Standard User');
		u.Sales_Area1__c = 'SA1234'; //Must mach that of the Customer_Service_Product__c
		insert u;
        
        // Arrange
        System.runAs(u){
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsSAP');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        
        Account sender = UTIL_TestFactory.createAccount();
        insert sender;
        
        Case c = UTIL_TestFactory.createCase();
        c.sender__c = sender.Id;
        insert c;
        
        Additional_Service__c addService1 = new Additional_Service__c();
        addService1.Product_Article_ID__c = 'Z077';
        insert addService1;
        
        Additional_Service__c addService2 = new Additional_Service__c();
        addService2.Product_Article_ID__c = 'Z073';
        insert addService2;
        
        Additional_Service__c addService3 = new Additional_Service__c();
        addService3.Product_Article_ID__c = 'Z018';
        insert addService3;
        
        Additional_Service__c addService4 = new Additional_Service__c();
        addService4.Product_Article_ID__c = 'Z015';
        insert addService4;
        
        Customer_Service_Product__c csp = UTIL_TestFactory.createProductArticl();
        insert csp;
        
        CaseProduct__c caseProduct = UTIL_TestFactory.createCaseProd();
        caseProduct.Case__c = c.Id;
        caseProduct.Additional_Service1__c = addService1.Id;
        caseProduct.Additional_Service2__c = addService2.Id;
        caseProduct.Additional_Service3__c = addService3.Id;
        caseProduct.Additional_Service4__c = addService4.Id;
        caseProduct.Customer_Service_Product__c = csp.Id;
        insert caseProduct;
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_SAPPriceCalculation_WS sapPriceCalc = new G2O_SAPPriceCalculation_WS(caseProduct);
        sapPriceCalc.send();
        Test.stopTest();
        
        // Assert 
		System.assertEquals(11, sapPriceCalc.result.Net_Value__c);
		System.assertEquals(12, sapPriceCalc.result.GrossValue__c);
		System.assertEquals(25, sapPriceCalc.result.Price_on_Add_Service_1_before_VAT__c);
		System.assertEquals(25, sapPriceCalc.result.Additional_service_1_VAT__c);
		System.assertEquals(0, sapPriceCalc.result.Price_on_Add_Service_2_before_VAT__c);
		System.assertEquals(25, sapPriceCalc.result.Additional_service_2_VAT__c);
        }
    }
    
    static testMethod void errorResponseTest() {
        User u = UTIL_TestFactory.createUser('SAPTestUser@test.test', 'Standard User');
		u.Sales_Area1__c = 'SA1234'; //Must mach that of the Customer_Service_Product__c
		insert u;
		
        // Arrange
        System.runAs(u){
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponsErrorSAP');
        errorMock.setStatusCode(200);
        errorMock.setHeader('Content-Type', 'text/xml');
		
		Account sender = UTIL_TestFactory.createAccount();
        insert sender;
        
        Case c = UTIL_TestFactory.createCase();
        c.sender__c = sender.Id;
        insert c;
        
        Customer_Service_Product__c csp = UTIL_TestFactory.createProductArticl();
        insert csp;
        
        CaseProduct__c caseProduct = new CaseProduct__c();
        caseProduct.Case__c = c.Id;
        caseProduct.Customer_Service_Product__c = csp.Id;
        insert caseProduct;
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, errorMock);
        G2O_SAPPriceCalculation_WS sapPriceCalc = new G2O_SAPPriceCalculation_WS(caseProduct);
        sapPriceCalc.send();
        Test.stopTest();
        
        // Assert
        System.assertEquals('Der findes ingen kundestamdata for kunde 10003141' , sapPriceCalc.callout.error.description);
        System.assertEquals('E' , sapPriceCalc.callout.error.errCode);
        }
    }
    
    
}