/**
    About
    -----
    Description: This class is used to test CC_OutboundWS class
    Created for: Postnord Contact Center project
    Create date: June 2015

    Details
    -------
    1. Provide Mockup class for WebService call 
        
    Update History
    --------------
    Created June 2015 - Miroslav Macko - Fluido Denmark
    --------------
        
*/

@isTest
                        
global class CC_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
           
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');
        
        String responseXml = '';
        
        if(req.getBody().contains('queueItemMapped')){
            responseXml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
                            +'    <soapenv:Body>'
                            +'        <ns1:queueItemMappedResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="services.soap.uqf.clearit.se">'
                            +'            <queueItemMappedReturn xsi:type="xsd:int">10</queueItemMappedReturn>'
                            +'        </ns1:queueItemMappedResponse>'
                            +'    </soapenv:Body>'
                            +'</soapenv:Envelope>';                        
        } else if(req.getBody().contains('endItem')){
            responseXml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
                            +'   <soapenv:Body>'
                            +'      <ns1:endItemResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="services.soap.uqf.clearit.se">'
                            +'         <endItemReturn xsi:type="xsd:int">20</endItemReturn>'
                            +'      </ns1:endItemResponse>'
                            +'   </soapenv:Body>'
                            +'</soapenv:Envelope>';       
        } else if(req.getBody().contains('dequeueItem')){
            responseXml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
                            +'   <soapenv:Body>'
                            +'      <ns1:dequeueItemResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="services.soap.uqf.clearit.se">'
                            +'         <dequeueItemReturn xsi:type="xsd:int">1</dequeueItemReturn>'
                            +'      </ns1:dequeueItemResponse>'
                            +'   </soapenv:Body>'
                            +'</soapenv:Envelope>';
        } else if(req.getBody().contains('getQueuedItemsMapped')){
            responseXml = '<?xml version="1.0" encoding="UTF-8"?>'
                + '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
                + '<soapenv:Body>'
                + '<ns1:getQueuedItemsMappedResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="services.soap.uqf.clearit.se">'
                + '<getQueuedItemsMappedReturn xsi:type="xsd:string">&lt;items&gt;'
                + '    &lt;item&gt;'
                + '        &lt;item_id&gt;251&lt;/item_id&gt;'
                + '        &lt;task_id&gt;uppdrag2&lt;/task_id&gt;'
                + '        &lt;original_time&gt;2015-08-26 16:54:46.0&lt;/original_time&gt;'
                + '        &lt;cris&gt;'
                + '            &lt;cri&gt;'
                + '                &lt;name&gt;bot_data_0&lt;/name&gt;'
                + '                &lt;value&gt;1&lt;/value&gt;'
                + '            &lt;/cri&gt;'
                + '        &lt;/cris&gt;'
                + '    &lt;/item&gt;'
                + '    &lt;item&gt;'
                + '        &lt;item_id&gt;306&lt;/item_id&gt;'
                + '        &lt;task_id&gt;uppdrag2&lt;/task_id&gt;'
                + '        &lt;original_time&gt;2015-09-01 13:21:52.0&lt;/original_time&gt;'
                + '        &lt;cris&gt;'
                + '            &lt;cri&gt;'
                + '                &lt;name&gt;bot_data_0&lt;/name&gt;'
                + '                &lt;value&gt;1&lt;/value&gt;'
                + '            &lt;/cri&gt;'
                + '        &lt;/cris&gt;'
                + '    &lt;/item&gt;'
                + '&lt;/items&gt;'
                + '</getQueuedItemsMappedReturn></ns1:getQueuedItemsMappedResponse>'
                + '</soapenv:Body>'
                + '</soapenv:Envelope>';                            
        } else if(req.getBody().contains('agent-id')){
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(req.getBody());
            String agentId = (String) m.get('agent-id');
            if(agentId != '-1') {
                responseXml = 'OK';
            }
            else {
                responseXml = 'NOT OK';
                res.setStatusCode(401); // something different from 200
                res.setStatus('Unauthorized');
            }
        }                                           

        res.setBody(responseXml);
        return res;
    }
}