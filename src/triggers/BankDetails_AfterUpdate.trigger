trigger BankDetails_AfterUpdate on Bank_Details__c (After update) {
    if(!UTIL_OrgSettings.isTriggersDisabled()) { 
        //Log Inbound Messages 
        if(Log_Inbound_Messages__c.getInstance().Log_Messages__c){
            G2O_InboundMessageLog_SVC.logInboundMessages(Trigger.new,Trigger.oldMap);
        }
    }
}