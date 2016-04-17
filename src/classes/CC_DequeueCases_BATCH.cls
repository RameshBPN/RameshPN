/*
* Apex class: CC_DequeueCases_BATCH
*
*
* Description:
* Batch class for the Customer Console project
* Dequeue closed cases in ClearInteract system.
* Change Log:
* 2015-06-11  Madhav Kakani  Initial Development
*
*/
global class CC_DequeueCases_BATCH implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global final String query;
            
    global CC_DequeueCases_BATCH() { 
        // Get all the records which have not been dequeued in ClearInteract        
        if(!Test.isRunningTest()) { 
            query = 'SELECT Id, CC_Item_Id__c, CC_Queue_Status__c FROM Case WHERE IsClosed=true AND CreatedDate=LAST_N_DAYS:60 AND CC_Item_Id__c!= NULL AND CC_Queue_Status__c=\'Enqueued\'';
        }
        else {
            query = 'SELECT Id, CC_Item_Id__c, CC_Queue_Status__c FROM Case WHERE IsClosed=true AND CreatedDate=LAST_N_DAYS:60';
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
/*
        if(Test.isRunningTest()) { 
            Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());
        }
*/        
        CC_Outbound_WS ws = new CC_Outbound_WS();
        ws.SetWritelog(false); // turn off writing the log

        List<Case> lstCases = scope;
        List<Case> lstUpdate = new List<Case>();
        
        for(Case c : lstCases) {
            String result = ws.endItem(c.CC_Item_Id__c, c.Id); 
            if(!UTIL_Apex.empty(result)) {
                c.CC_Queue_Status__c = Label.Case_Dequeued; // Dequeued
                lstUpdate.add(c);
            }        
        }
        
        try {
            if(!lstUpdate.isEmpty()) update lstUpdate;
        } catch(DMLException e) {
            UTIL_Error.report('CC_DequeueCases_BATCH Errorr:', e);
            UTIL_Error.write();
        }

    }
        
    global void finish(Database.BatchableContext BC) {
    }   
}