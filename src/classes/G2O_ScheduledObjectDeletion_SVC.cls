/**
    About
    -----
    Description: Batch class for going through the objects for deletion records and deleting all older than a grace period.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: September 2013
    
    Details
    -------
    1. Deletes Apex Callout Log records
    2. Deletes Apex Error Log records
    3. Deletes Outbound Notification records
    4. Deletes Inbound Message Log records
    
    Update History
    --------------
    Created September 2013 - K.E.A.J. 
    Updated August 2015 - Ramesh Botlagunta
    
    Issues / TODOs:
    --------------  
*/
global with sharing class G2O_ScheduledObjectDeletion_SVC{

    //A.T.T.R.I.B.U.T.E.S
    
    private list<String> errorList = new list<String>();
    
    public integer totalRows = 0;
    private list<Database.DeleteResult> srList;
    private list<sObject> deletionList;
    public static final boolean DELETE_APEXCALLOUTLOG = UTIL_OrgSettings.ApexCalloutLogDeletion();
    public static final boolean DELETE_APEXERRORLOG = UTIL_OrgSettings.ApexErrorLogDeletion();
    public static final boolean DELETE_OUTBOUNDNOTIFICATIONERROR = UTIL_OrgSettings.OutboundNotificationDeletion();
    public static final boolean DELETE_INBOUNDMESSAGELOG = UTIL_OrgSettings.InboundMessageLogDeletion();

    public static final Integer GRACE_PERIOD_FOR_APEXCALLOUTLOG = Integer.ValueOf(UTIL_OrgSettings.ApexCalloutLogGraceperiod());
    public static final Integer GRACE_PERIOD_FOR_APEXERRORLOG = Integer.ValueOf(UTIL_OrgSettings.ApexErrorLogGraceperiod());
    public static final Integer GRACE_PERIOD_FOR_OUTBOUNDNOTIFICATION = Integer.ValueOf(UTIL_OrgSettings.OutboundNotificationGraceperiod());
    public static final Integer GRACE_PERIOD_FOR_INBOUNDMESSAGELOG = Integer.ValueOf(UTIL_OrgSettings.InboundMessageLogGraceperiod());
   
    //C.O.N.S.T.R.U.C.T.O.R
    global G2O_ScheduledObjectDeletion_SVC(){
          totalRows = 1;//As one row is already created by its scheduler class G2O_ScheduledObjectDeletion_SVC_SCH
                        //which basically update the values in the custom setting ScheduledJobParameters__c
    }
    
    //1. Deletes Apex Callout Log records
    public boolean deleteApexCalloutLog(){
        if(totalRows < 10000 && DELETE_APEXCALLOUTLOG){
            deletionList = [select id from ApexCalloutLog__c where createddate < :DateTime.now().addhours(-1*GRACE_PERIOD_FOR_APEXCALLOUTLOG) limit :(10000 - totalRows)];
            totalRows += deletionList.size();
            
            srList = Database.delete(deletionList, false);
            for (integer i = 0; i < srList.size(); i++) {
                if (!srList[i].isSuccess()) { 
                    system.debug(logginglevel.warn, 'ERROR: ' + srList[i]);
                    // Operation failed, so get all errors                
                    for(Database.Error err : srList[i].getErrors()) {
                        errorList.add(' An error occured when trying to delete ApexCalloutLog__c, Error is: ' + err);
                    }  
                } 
            }
            if(errorList.size() > 0){
                for(String error : errorList){
                    UTIL_Error.report('Handled Exception',error,'G2O_ApexCalloutLogCleanup_BATCH');                 
                }
                UTIL_Error.writeNow(); 
                return false;
            }
        }
        return true;      
    }
    
    //2. Deletes Apex Error Log records
    public boolean deleteApexErrorLog(){
        if(totalRows < 10000 && DELETE_APEXERRORLOG){
            deletionList = [select id from ApexErrorLog__c where createddate < :DateTime.now().addhours(-1*GRACE_PERIOD_FOR_APEXERRORLOG) limit :(10000 - totalRows)];
            totalRows += deletionList.size();

            srList = Database.delete(deletionList, false);
            for (integer i = 0; i < srList.size(); i++) {
                if (!srList[i].isSuccess()) { 
                    system.debug(logginglevel.warn, 'ERROR: ' + srList[i]);
                    // Operation failed, so get all errors                
                    for(Database.Error err : srList[i].getErrors()) {
                        errorList.add(' An error occured when trying to delete ApexCalloutLog__c, Error is: ' + err);
                    }  
                } 
            }
            if(errorList.size() > 0){
                for(String error : errorList){
                    UTIL_Error.report('Handled Exception',error,'G2O_ApexCalloutLogCleanup_BATCH');                 
                }
                UTIL_Error.writeNow(); 
                return false;
            }
        }
        return true;      
    }
    
    //3. Deletes Outbound Notification records
    public boolean deleteOutboundNotification(){
        if(totalRows < 10000 && DELETE_OUTBOUNDNOTIFICATIONERROR){
            deletionList = [select id from Outbound_Notification__c where (PN_Synchronized__c = true And createddate < :DateTime.now().addhours(-1*GRACE_PERIOD_FOR_OUTBOUNDNOTIFICATION)) limit :(10000 - totalRows)];
            totalRows += deletionList.size();

            srList = Database.delete(deletionList, false);
            for (integer i = 0; i < srList.size(); i++) {
                if (!srList[i].isSuccess()) { 
                    system.debug(logginglevel.warn, 'ERROR: ' + srList[i]);
                    // Operation failed, so get all errors                
                    for(Database.Error err : srList[i].getErrors()) {
                        errorList.add(' An error occured when trying to delete Outbound_Notification__c, Error is: ' + err);
                    }  
                } 
            }
            if(errorList.size() > 0){
                for(String error : errorList){
                    UTIL_Error.report('Handled Exception',error,'Outbound_Notification__c');                 
                }
                UTIL_Error.writeNow(); 
                return false;
            }
        }
        return true;      
    }
    //4. Deletes Inbound Message Log records
    public boolean deleteInboundMessageLog(){
        if(totalRows < 10000 && DELETE_INBOUNDMESSAGELOG){
            deletionList = [select id from Inbound_Message_Log__c where createddate < :DateTime.now().addhours(-1*GRACE_PERIOD_FOR_INBOUNDMESSAGELOG) limit :(10000 - totalRows)];
            totalRows += deletionList.size();

            srList = Database.delete(deletionList, false);
            for (integer i = 0; i < srList.size(); i++) {
                if (!srList[i].isSuccess()) { 
                    system.debug(logginglevel.warn, 'ERROR: ' + srList[i]);
                    // Operation failed, so get all errors                
                    for(Database.Error err : srList[i].getErrors()) {
                        errorList.add(' An error occured when trying to delete Inbound_Message_Log__c, Error is: ' + err);
                    }  
                } 
            }
            if(errorList.size() > 0){
                for(String error : errorList){
                    UTIL_Error.report('Handled Exception',error,'Inbound_Message_Log__c');                 
                }
                UTIL_Error.writeNow(); 
                return false;
            }
        }
        return true;      
    }
}