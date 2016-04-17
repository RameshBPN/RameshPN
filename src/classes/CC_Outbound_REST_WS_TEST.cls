/**
    About
    -----
    Description: This class is used to test CC_Outbound_REST_WS class
    Created for: Postnord Contact Center project
    Create date: June 2015

    Details
    -------
    1. Tests WebService calls to Clear IT 
        
    Update History
    --------------
    Created July 2015 - Miroslav Macko - Fluido Denmark
    --------------
        
*/

@isTest                        
private class CC_Outbound_REST_WS_TEST {
    // normal callout with no errors
     @isTest static void testCalloutNormal() {
         // Create an entry                           
        HTTP_Integration_Services__c hs = new HTTP_Integration_Services__c();
        hs.Name = 'ClearIT_CTC';
        hs.Endpoint__c = 'https://api.clearinteract.se/postnordtest02/api/v1.0/click-to-call';
        hs.Password__c = 'secret_key';
        hs.Provider__c = 'ClearIT';
        hs.SOAPAction__c = 'Process';
        hs.Host__c = 'api.clearinteract.se';
        insert hs;

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
        
        CC_Outbound_REST_WS ows = new CC_Outbound_REST_WS();
        
        Test.startTest();
        
        String result = ows.clickToCall('123','1234','0812345678', null);
        System.assertEquals('OK', result);

        Test.stopTest();    
    }

    // normal callout with errors
     @isTest static void testCalloutError() {
         // Create an entry                           
        HTTP_Integration_Services__c hs = new HTTP_Integration_Services__c();
        hs.Name = 'ClearIT_CTC';
        hs.Endpoint__c = 'https://api.clearinteract.se/postnordtest02/api/v1.0/click-to-call';
        hs.Password__c = 'secret_key';
        hs.Provider__c = 'ClearIT';
        hs.SOAPAction__c = 'Process';
        hs.Host__c = 'api.clearinteract.se';
        insert hs;

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
        
        CC_Outbound_REST_WS ows = new CC_Outbound_REST_WS();
        
        Test.startTest();
        
        String result = ows.clickToCall('-1','1234','0812345678', null);
        System.assertEquals('Unauthorized', result);

        Test.stopTest();    
    }

}