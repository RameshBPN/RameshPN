/*
* Apex class: CC_PostNord_SoftPhone_VFC
*
*
* Description:
* Controller class for the CC_PostNord_SoftPhone visualforce page - Customer Console project
*
* Change Log:
* 2015-04-30  Madhav Kakani  Initial Development
*
*/
global with sharing class CC_PostNord_SoftPhone_VFC {
    // Dequeue the case right after its ownerhship is assigned to an agent
    @RemoteAction
    global static void DeQueueCase(String caseId, String clearit_itemid) {
        UTIL_Apex.DeQueueCase(caseId, clearit_itemid); // call the future method
    }

    // Request live agent chat
    @RemoteAction
    global static void RequestChat() {
        // Get the ClearIT queue for live agent chat
        CC_ClearIT_Queues__c cc_queue = CC_ClearIT_Queues__c.getInstance('Live Agent Chat');
        
        // Enqueue the request in ClearIT
        CC_Outbound_WS ws = new CC_Outbound_WS();
        String itemId = ws.queueItemMapped(cc_queue.ClearIT_Queue_Name__c, '1', null);
    }
    
    // Click to dial
    @RemoteAction
    global static void CallPhoneNumber(String objName, String objId, String phone, String usrId) {
        // Setup the task record
        Task t = new Task();
        t.Subject = 'Phone call';
        t.Type = 'Telephone Contact';
        t.Status = 'Completed';
        t.ActivityDate = Date.today();
        t.Priority = 'Normal';
        t.OwnerId = usrId;
        t.WhatId = objId;
        
        // Normalise the phone number
        String normalPhone = null; // normalised phone number
        if(objName == 'Account') {
            List<Account> acct = [SELECT Postal_Address_Country__c FROM Account WHERE Id=:objId];
            if(!acct.isEmpty()) normalPhone = UTIL_Apex.NormalisePhone(phone, acct[0].Postal_Address_Country__c);
        }
        else if(objName == 'Case') {
            List<Case> c = [SELECT ContactId, Account.Postal_Address_Country__c FROM Case WHERE Id=:objId];
            if(!c.isEmpty()) {
                normalPhone = UTIL_Apex.NormalisePhone(phone, c[0].Account.Postal_Address_Country__c);
                t.WhoId = c[0].ContactId;
            }
        }
        else if(objName == 'Contact') {
            List<Contact> ct = [SELECT Account_Country__c FROM Contact WHERE Id=:objId];
            if(!ct.isEmpty()) normalPhone = UTIL_Apex.NormalisePhone(phone, ct[0].Account_Country__c);
        }
        
        if(normalPhone == null) return; // null;

        // Get the appropriate Agent Id in CLearIT from the CC Agent Interface record
        List<CC_Agent_Interface__c> agent = [SELECT Id, External_Agent_Id__c, Queue_Id__c FROM CC_Agent_Interface__c WHERE User__c=:usrId];
        if(agent.isEmpty()) return; // null;
        
        // Now contact ClearIT to make the call
        CC_Outbound_REST_WS ows = new CC_Outbound_REST_WS();
        String result = ows.clickToCall(agent[0].External_Agent_Id__c, agent[0].Queue_Id__c, normalPhone, objId);

        try {
            insert t; // Create a task
        } catch(DMLException e) {
            UTIL_Error.report('CallPhoneNumber Error:', e);
            UTIL_Error.write();
        }       
    }
}