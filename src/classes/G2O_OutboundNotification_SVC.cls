/**
    About
    -----
    Description: Service class for General Outbound Notification Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Details
    -------
    The trigger service class will reflect inserts/updates/deletes on Outbound Notification object.
     1. Create a record that notifies that a record has been physically deleted
     2. Empty the recycle bin of the records that has been deleted

     
    Update History
    --------------
    Created October 2013 - T.R.
    
    Issues / TODOs
    --------------  

*/

public with sharing class G2O_OutboundNotification_SVC {
    
    //1. Create a record that notifies that a record has been physically deleted
    public static void createDeleteNotifications(List<sObject> recordsToDelete) {
        
        System.debug(LoggingLevel.info,'*** START: <G2O_OutboundNotification_SVC>.<createDeletedRecord>');
        try {
            createOutboundNotificationObjects(recordsToDelete, UTIL_OrgSettings.outboundNotification_Delete());
        } catch(Exception e) {
            system.debug(Logginglevel.INFO,'++++Exception+++'+e);
            UTIL_Error.report('Outbound Notification Delete', e);
            UTIL_Error.writeNow();
        }
        
        System.debug(LoggingLevel.info,'*** END: <G2O_OutboundNotification_SVC>.<createDeletedRecord>');
    }
    
    //Private method that will create the notification record with the correct operation
    private static void createOutboundNotificationObjects(List<SObject> updatedRecords, String operation) {
        
        List<Outbound_Notification__c> recordsToUpsert = new List<Outbound_Notification__c>();
        for (SObject record: updatedRecords) {
            Outbound_Notification__c obn = new Outbound_Notification__c();
            
            //Set field values on the obn record
            obn.Operation__c = operation;
            obn.Object_SFDC_ID__c = record.Id;
            String objectName = UTIL_Meta.getObjectType(record.Id).getDescribe().getName();
            
            //These string vary between objects
            String objectCompoundId =  record.Id;
            
             // Adding outbound notification for Credit Information
             if (record instanceOf Credit_Information__c ) {
                  List<Credit_Information__c> CreditRecords = new List<Credit_Information__c>();
                  CreditRecords = [select Id, Credit_Information_Compound_SFID__c from  Credit_Information__c where id = :record.id];
                  system.debug('CreditRecords'+CreditRecords);
                  if (CreditRecords != null && CreditRecords.size() > 1)
                  objectCompoundId = CreditRecords[0].Credit_Information_Compound_SFID__c;
                  // objectCompoundId = (String)record.get('Credit_Information_Compound_SFID__c');
            }
            
            //Based on the object type, field values are held in different fields on the original object            
            if (record instanceOf Bank_Details__c) {
                objectCompoundId = (String)record.get('Bank_Details_Compound_SFID__c');
            }
            if (record instanceOf Relationship__c) {
                objectCompoundId = (String)record.get('Relationship_Compound_SFID__c');
            }
            if (record instanceOf Account_Contact_Role_Transaction__c) {
                objectCompoundId = (String)record.get('Account_Contact_Role_SFID__c');
            }
            
            obn.Object_API_Name__c = objectName;
            obn.Object_External_ID__c = objectCompoundId;
            obn.Notification_Key__c = objectName + ':' + objectCompoundId + ':' + operation;
            
            recordsToUpsert.add(obn);
        }
        upsert recordsToUpsert Notification_Key__c;
    }
}