/*
* Apex Class: CC_Outbound_REST_WS
*
*
* Description:
* Outbound webservice calls to ClearInteract
*
* Change Log:
* 2015-07-15  Miroslav Macko Initial Development
*
*/
public class CC_Outbound_REST_WS{
    public UTIL_HttpIntegration.CalloutResult callout; // Log all callouts  

    public String END_POINT;
    public String SECRET_API_KEY;
    private Boolean bWritelog = true;
    
    public String clickToCall(String agentId, String taskId, String phoneNumber, String whatId) {
        HTTP_Integration_Services__c hs = HTTP_Integration_Services__c.getInstance('ClearIT_CTC');
        END_POINT = hs.Endpoint__c;
        SECRET_API_KEY = hs.Password__c;
        
        String response = null;

        Http h = new Http();      
        HttpRequest req = new HttpRequest();
        
        String body = '{"agent-id" : "'+ agentId +'","task-id" : "'+ taskId +'","phone-number" : "'+ phoneNumber +'"}';
        req.setHeader('Content-Length', String.valueOf(body.length()));
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', SECRET_API_KEY);    
        req.setBody(body);
        req.setEndpoint(END_POINT);
        req.setMethod('POST');
        
        HttpResponse res;
        callout = new UTIL_HttpIntegration.CalloutResult();
        callout.calloutStart = Datetime.now();
        callout.related_SObjectId = whatId;

        try {
            res = h.send(req);
            callout.calloutFinalResponse = Datetime.now();
            response = res.getStatus();
            
            try {  
                UTIL_XmlDom xml = new UTIL_XMLDom( UTIL_Apex.empty(res.getBody()) ? '' : res.getBody());
            } catch(Exception e) {
                callout.error =  new UTIL_HttpIntegration.ErrorContainer('SERVICE_TYPE_NOT_SUPPORTED', 'NO_DATA');           
            }
            
            if(res.getStatusCode() != 200) { 
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
}