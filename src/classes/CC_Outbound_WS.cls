/*
* Apex Class: CC_Outbound_WS
*
*
* Description:
* Outbound webservice calls to ClearInteract
*
* Change Log:
* 2015-05-19  Miroslav Macko Initial Development
*
*/
public class CC_Outbound_WS {
    public String END_POINT;
    public UTIL_HttpIntegration.CalloutResult callout; // Log all callouts  
    private Boolean bWritelog = true;
        
    public CC_Outbound_WS() {
        callout = new UTIL_HttpIntegration.CalloutResult();
        if(Test.isRunningTest()) { 
            END_POINT = 'http://api.clearinteract.se/postnordtest02/axis/services/UqfLight2';
        }
        else {
            HTTP_Integration_Services__c hs = HTTP_Integration_Services__c.getInstance('ClearIT');
            END_POINT = hs.Endpoint__c;
        }
    }

    // Make writing the log true or false
    public void SetWritelog(Boolean writelog) {
        bWritelog = writelog;
    }
    /* 
    * Queueing an email-to-case case id to ClearInteract
    *
    */
    public String queueItemMapped(String taskIdentifier, String data, String whatId){
        callout.related_SObjectId = whatId;
        
        String result = null;
        String bodyXml = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="services.soap.uqf.clearit.se">'
                        +'   <soapenv:Header/>'
                        +'   <soapenv:Body>'
                        +'      <ser:queueItemMapped soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
                        +'         <taskIdentifier1 xsi:type="xsd:string">'+ taskIdentifier +'</taskIdentifier1>'
                        +'         <data xsi:type="xsd:string">'+ data +'</data>'
                        +'      </ser:queueItemMapped>'
                        +'   </soapenv:Body>'
                        +'</soapenv:Envelope>';
        
        String responseXml = callService(bodyXml);                
        
        //parse response
        if(!UTIL_Apex.empty(responseXml)){
            System.debug('responseXml: ' + responseXml);
            result = parseXML(responseXml, 'queueItemMappedResponse', 'queueItemMappedReturn'); 
        }
                        
        return result;
    }

    /* 
    * Telling ClearInteract that the email-to-case case is resolved and can be removed from the queue in ClearInteract
    *
    */
    public String endItem(String sItemId, String whatId){
        callout.related_SObjectId = whatId;
        Integer itemid = Integer.valueof(sItemId);
        String result = null;
        String bodyXml = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="services.soap.uqf.clearit.se">'
                        +'   <soapenv:Header/>'
                        +'   <soapenv:Body>'
                        +'      <ser:endItem soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
                        +'         <itemId2 xsi:type="xsd:int">'+ itemId +'</itemId2>'
                        +'      </ser:endItem>'
                        +'   </soapenv:Body>'
                        +'</soapenv:Envelope>';
                        
        String responseXml = callService(bodyXml);                              

        //parse response
        if(!UTIL_Apex.empty(responseXml)){
            result = parseXML(responseXml, 'endItemResponse', 'endItemReturn'); 
        }        
                        
        return result;
    }
    
    /* 
    * Remove a previously queued in ClearInteract
    *
    */
    public String dequeueItem(String sItemId){
        Integer itemid = Integer.valueof(sItemId);
        String result = null;    
        String bodyXml = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="services.soap.uqf.clearit.se">'
                        +'   <soapenv:Header/>'
                        +'   <soapenv:Body>'
                        +'      <ser:dequeueItem soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
                        +'         <itemId1 xsi:type="xsd:int">'+ itemId +'</itemId1>'
                        +'      </ser:dequeueItem>'
                        +'   </soapenv:Body>'
                        +'</soapenv:Envelope>';

        String responseXml = callService(bodyXml);                              

        //parse response
        if(!UTIL_Apex.empty(responseXml)){
            result = parseXML(responseXml, 'dequeueItemResponse', 'dequeueItemReturn'); 
        }
                                
        return result;
    }
    
    /* 
    * Get a list of all items currently queued in ClearInteract. Will be used to "synchronise" the queue in ClearInteract
    * with Salesforce queue in case there would be a mismatch. By calling this method ClearInteract will tell all items queued. 
    * This list is then compared with list of cases in Salesforce to see is systems are in sync.
    *
    */
    public List<QueueItem> getQueuedItemsMapped(String taskIdentifier){
        List<QueueItem> queueItems = new List<QueueItem>();
    
        String bodyXml = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="services.soap.uqf.clearit.se">'
                        +'   <soapenv:Header/>'
                        +'   <soapenv:Body>'
                        +'      <ser:getQueuedItemsMapped soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
                        +'         <taskIdentifier2 xsi:type="xsd:string">'+ taskIdentifier +'</taskIdentifier2>'
                        +'      </ser:getQueuedItemsMapped>'
                        +'   </soapenv:Body>'
                        +'</soapenv:Envelope>';

        String responseXml = callService(bodyXml);
        
        // System.debug('DATA: getQueuedItemsMapped responseXml: ' + responseXml); 
        
        //parse response
        String encoded = EncodingUtil.urlEncode(responseXml,'UTF-8');
        encoded = encoded.replaceAll('%3C%21%5BCDATA%5B',''); // i.e. '<![CDATA['
        encoded = encoded.replaceAll('%5D%5D%3E',''); // i.e. ']]>'
        responseXml = EncodingUtil.urlDecode(encoded,'UTF-8');        
            
        if(!UTIL_Apex.empty(responseXml)){
                 
            Dom.Document doc = new Dom.Document();
            doc.load(responseXml);
            
            Dom.XMLNode root = doc.getRootElement();
            
            Dom.XMLNode body = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
    
            Dom.XMLNode responseNode = body.getChildElement('getQueuedItemsMappedResponse', 'services.soap.uqf.clearit.se');
            Dom.XMLNode returnNode = responseNode.getChildElement('getQueuedItemsMappedReturn', null);
            
            // System.debug('DATA: returnNode: ' + returnNode);
            // System.debug('DATA: returnNode.getText(): ' + returnNode.getText()); 
            
            if(!UTIL_Apex.empty(returnNode.getText()) && returnNode.getText().length() > 15){
            
                Dom.Document docItems = new Dom.Document();
                docItems.load(returnNode.getText());
                
                Dom.XMLNode rootItems = docItems.getRootElement();
                
                Dom.XmlNode[] items = rootItems.getChildElements();
                
                for(Dom.XmlNode item: items){
                    QueueItem queueItem = new QueueItem();

                    Dom.XMLNode item_id = item.getChildElement('item_id', null);
            
                    //System.debug('Node : ' + item_id);
                    //System.debug('Value: ' + item_id.getText());
                    
                    queueItem.item_id = Integer.valueOf(item_id.getText());
                    
                    Dom.XMLNode task_id = item.getChildElement('task_id', null);
                    queueItem.task_id = task_id.getText();
                    
                    Dom.XMLNode original_time = item.getChildElement('original_time', null);
                    queueItem.original_time = original_time.getText();

                    Dom.XMLNode cris = item.getChildElement('cris', null);
                    Dom.XMLNode[] crisItems = cris.getChildElements();
                    
                    List<Map<String,String>> crisList = new List<Map<String,String>>();
                    
                    for(Dom.XmlNode itemCri :crisItems){
                        Map<String,String> criMap = new Map<String,String>();
                        
                        Dom.XMLNode name = itemCri.getChildElement('name', null);
                        criMap.put('name', name.getText());

                        Dom.XMLNode value = itemCri.getChildElement('value', null);
                        criMap.put('value', value.getText());
                        
                        crisList.add(criMap);
                    }
                    
                    queueItem.cris = crisList;
                    
                    queueItems.add(queueItem);
                            
                }
                // System.debug('Number of queueItems: ' + queueItems.size());
                // System.debug('queueItems: ' + queueItems);
            }
        }
                        
        return queueItems;                        
    }                        
       
    // This function contains a callout and a DML afterwards - which is fine if this function is called once
    // If called in a loop, the function fails due to uncommitted work pending error.
    // Turn off logging before calling the function in a loop to avoid the error. 
    public String callService(String body){
        String response = null;
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(END_POINT);
        req.setTimeout(15000);
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '""');
        req.setBody(body);

        HttpResponse res;
        Boolean success = false;
        callout.calloutStart = Datetime.now();
        try {
            res = http.send(req);
            callout.calloutFinalResponse = Datetime.now();
            
            try {  
                UTIL_XmlDom xml = new UTIL_XMLDom( UTIL_Apex.empty(res.getBody()) ? '' : res.getBody());
            } catch(Exception e) {
                callout.error =  new UTIL_HttpIntegration.ErrorContainer('SERVICE_TYPE_NOT_SUPPORTED', 'NO_DATA');           
            }
            
            if(res.getStatusCode() == 200){ // Good response
                response = res.getBody();
            }
            else { // error
                 callout.error = new UTIL_HttpIntegration.ErrorContainer('CALLOUT_FAILURE', + res.getStatus());      
            }
        } catch(UTIL_HttpIntegration.HTTPRequestException e) {
            callout.error = new UTIL_HttpIntegration.ErrorContainer(e.code);                        
        }
        
        //Start writing the log to Apex Callout object
        if(bWritelog){
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.allowFieldTruncation = true;
            if(callout.errors.size()>0) {
                ApexCalloutLog__c[] log = new ApexCalloutLog__c[]{};
                for(UTIL_HttpIntegration.ErrorContainer error : callout.errors) {
                    ApexCalloutLog__c logItem = new ApexCalloutLog__c();
                    logItem.Source__c = 'CLEAR IT';
                    logItem.Request_Message__c = UTIL_Apex.empty(req) ? '' : req.getBody();
                    logItem.Response_Message__c = UTIL_Apex.empty(res) ? '' : res.getBody();
                    logItem.Request_Initiated__c = callout.calloutStart;
                    logItem.Response_Final__c = callout.calloutFinalResponse;
                    logItem.System_Error_Code__c = '' + error.systemErrCode;
                    logItem.Error_Code__c = error.errCode;
                    logItem.Error_Type__c = error.errType;
                    logItem.Error_Description__c = error.description;
                    logItem.WhatId__c = callout.related_SObjectId;
                    logItem.setOptions(dmo);
                    log.add(logItem);                    
                }
                upsert log;
            } else {       
                ApexCalloutlog__c logItem = new ApexCalloutLog__c();
                logItem.Source__c = 'CLEAR IT';
                logItem.Request_Message__c = UTIL_Apex.empty(req) ? '' : req.getBody();
                logItem.Response_Message__c = UTIL_Apex.empty(res) ? '' : res.getBody();
                logItem.Request_Initiated__c = callout.calloutStart;
                logItem.Response_Final__c = callout.calloutFinalResponse;
                logItem.WhatId__c = callout.related_SObjectId;
                logItem.setOptions(dmo);
                upsert logItem;
            }
        }
        
        return response;        
    } 
    
    public class QueueItem {
        public Integer item_id;
        public String task_id;
        public String original_time; // date format 2009-01-28 16:20:47.0 
        public String time_to_dist; // date format 2009-02-13 14:00:00.0
        public List<Map<String,String>> cris;
    }
    
    private String parseXML(String responseXml, String responseName, String returnName){
        Dom.Document doc = new Dom.Document();
        doc.load(responseXml);
        
        Dom.XMLNode root = doc.getRootElement();
        
        Dom.XMLNode body = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');

        Dom.XMLNode responseNode = body.getChildElement(responseName, 'services.soap.uqf.clearit.se');
        Dom.XMLNode returnNode = responseNode.getChildElement(returnName, null);
        
        if(!UTIL_Apex.empty(returnNode.getText())){
            return returnNode.getText();
        }
                
        return null;
    }    

}