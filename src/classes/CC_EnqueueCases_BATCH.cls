/*
* Apex class: CC_EnqueueCases_BATCH
*
*
* Description:
* Batch class for the Customer Console project
* Processes any missed cases which were not initially queued in the ClearInteract system and attempts to queue them again.
* Change Log:
* 2015-06-10  Madhav Kakani  Initial Development
*
*/
global class CC_EnqueueCases_BATCH implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global final String query;
    global final Map<String, CC_ClearIT_Queues__c> queueNames; // Map of SF and ClearInteract queue names
    global final Map<Id, String> sf_queues; // Map of SF queue id and queue name
    global final Set<Id> ownerIds; // set of queue/owner ids
            
    global CC_EnqueueCases_BATCH() { 
        queueNames = CC_ClearIT_Queues__c.getAll(); // Get the salesforce queue and ClearInteract queues

        // Get the Salesforce queue ids
        sf_queues = new Map<Id, String>();
        for(Group grp : [SELECT Id, Name FROM Group WHERE Type='Queue' AND Name IN :queueNames.keySet()]) {
            sf_queues.put(grp.Id, grp.Name);
        }

        ownerIds = sf_queues.keySet();

        // Get all the records which are owned by the above Salesforce queues and which have not been queued in ClearInteract        
        if(!Test.isRunningTest()) { 
            query = 'SELECT Id, OwnerId, CC_Item_Id__c, CC_Queue_Name__c, CC_Queue_Status__c FROM Case WHERE CreatedDate=LAST_N_DAYS:14 AND CC_Item_Id__c=NULL AND IsClosed=false AND CC_Queue_Status__c=NULL AND OwnerId IN :ownerIds';
        }
        else query = 'SELECT Id, OwnerId, CC_Item_Id__c, CC_Queue_Name__c, CC_Queue_Status__c FROM Case WHERE CreatedDate=LAST_N_DAYS:14 AND IsClosed=false AND OwnerId IN :ownerIds';
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
            String sf_queue_name = sf_queues.get(c.OwnerId); // Get the case owner queue name
            CC_ClearIT_Queues__c cc_cq = queueNames.get(sf_queue_name); // get the corresponding ClearInteract queue
            
            String itemId = ws.queueItemMapped(cc_cq.ClearIT_Queue_Name__c, '1', c.Id); // call the webservice to queue the case
            if(!UTIL_Apex.empty(itemId)) {
                c.CC_Item_Id__c = itemId;
                c.CC_Queue_Name__c = cc_cq.ClearIT_Queue_Name__c;
                c.CC_Queue_Status__c = Label.Case_Enqueued; // Enqueued
                lstUpdate.add(c);
            }        
        }

        try {
            if(!lstUpdate.isEmpty()) update lstUpdate;
        } catch(DMLException e) {
            UTIL_Error.report('CC_EnqueueCases_BATCH Error:', e);
            UTIL_Error.write();
        }
    }
        
    global void finish(Database.BatchableContext BC) {
    }   
}