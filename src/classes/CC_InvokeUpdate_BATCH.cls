/*
* Apex class: CC_InvokeUpdate_BATCH
*
*
* Description:
* Mass update records with this batch class
* Change Log:
* 2015-06-12  Madhav Kakani  Initial Development
*
*/
global class CC_InvokeUpdate_BATCH implements Database.Batchable<sObject> {
  private String sObjectName;
 
    global CC_InvokeUpdate_BATCH(String sObjectName) {
        this.sObjectName = sObjectName;
    }
 
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id FROM ' + sObjectName;
        return Database.getQueryLocator(query); 
    }
 
    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        database.update(scope, false);
    }
 
    global void finish(Database.BatchableContext BC){
    }
 
}