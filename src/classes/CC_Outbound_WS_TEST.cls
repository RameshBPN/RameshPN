/**
    About
    -----
    Description: This class is used to test CC_OutboundWS class
    Created for: Postnord Contact Center project
    Create date: June 2015

    Details
    -------
    1. Tests WebService calls to Clear IT 
        
    Update History
    --------------
    Created June 2015 - Miroslav Macko - Fluido Denmark
    --------------
        
*/

@isTest                        
private class CC_Outbound_WS_TEST {
     @isTest static void testQueueItemMapped() {                           
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
        
        CC_Outbound_WS ows = new CC_Outbound_WS();
        ows.SetWritelog(true);
        
        Test.startTest();
        
        String result = ows.queueItemMapped('test','test', null);
        System.assertEquals('10', result);
                
        Test.stopTest();       
    }
    
     @isTest static void testEndItem() {                           
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
        
        CC_Outbound_WS ows = new CC_Outbound_WS();
        
        Test.startTest();
        
        String result = ows.endItem('20', null);
        System.assertEquals('20', result);
        
        Test.stopTest();       
    }
    
     @isTest static void testDequeueItem() {                           
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
        
        CC_Outbound_WS ows = new CC_Outbound_WS();
        
        Test.startTest();
        
        String result = ows.dequeueItem('1');
        System.assertEquals('1', result);
        
        Test.stopTest();       
    }

     @isTest static void testGetQueuedItemsMapped() {                           
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
        
        CC_Outbound_WS ows = new CC_Outbound_WS();
        
        Test.startTest();
                
        List<CC_Outbound_WS.QueueItem> lstItems = ows.getQueuedItemsMapped('test');
       
        Test.stopTest();       
    }
    
}