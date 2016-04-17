/**
    About
    -----
    Description: This class is used to test G2O_PARSearchView_Customer_WS
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
private class G2O_PARSearchView_Customer_WS_TEST {

    static testMethod void successfulResponseTest() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_Account');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Account account = UTIL_TestFactory.createAccount();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_PARSearchView_Customer_WS parCustomer = new G2O_PARSearchView_Customer_WS(account);
        parCustomer.send();
        Test.stopTest();
        
        // Assert
        System.debug(Logginglevel.ERROR, parCustomer.result);
        System.assert(parCustomer.result.size() == 6,'The number of LEs don\'t match');
        Account LE;
        
        for(Account a : parCustomer.result.keySet()) {
        	if(a.Name == 'Fosli Severin Andreas') {
        		LE = a;
        		break;
        	}
        }
    	
    	System.debug(Logginglevel.ERROR, LE);
    	System.debug(Logginglevel.ERROR,'parCustomer.result.get(LE)' + parCustomer.result.get(LE));
		System.assert(LE.Name == 'Fosli Severin Andreas','Name don\'t match');
		System.assert(LE.External_Provider_Party_ID__c == '111:100357275','External_Provider_Party_ID__c don\'t match');
		System.assert(LE.Postal_Address_Postal_Code__c == '1348','Postal_Address_Postal_Code__c don\'t match');
    	System.assert(parCustomer.result.get(LE).size() == 1,'The number of WSs don\'t match');
    	System.assert(parCustomer.result.get(LE)[0].External_Provider_Party_ID__c == '111:200364161','External_Provider_Party_ID__c don\'t match');
    	System.assert(parCustomer.result.get(LE)[0].Name == 'Fosli Severin Andreas','Name don\'t match');
    	system.debug( Logginglevel.ERROR, 'Postal_Address_Postal_Code__c: ' + parCustomer.result.get(LE)[0].Postal_Address_Postal_Code__c);
    	System.assert(parCustomer.result.get(LE)[0].Postal_Address_Postal_Code__c == '1348','Postal_Address_Postal_Code__c don\'t match');
    }

    static testMethod void errorResponseTest() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponsErrorPAR_Account');
        errorMock.setStatusCode(200);
        errorMock.setHeader('Content-Type', 'text/xml');
        Account account = UTIL_TestFactory.createAccount();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, errorMock);
        G2O_PARSearchView_Customer_WS parCustomer = new G2O_PARSearchView_Customer_WS(account);
        parCustomer.send();
        Test.stopTest();
        
        // Assert
        System.assertEquals('100' , parCustomer.callout.error.errCode);
        System.assertEquals('Some fault message' , parCustomer.callout.error.description);
    }
}