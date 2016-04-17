/**
    About
    -----
    Description: Apex programming helper methods
    Created for: Postnord Get2OneCRM Master/DK
    Create date: August 2015
    
    Details / Methods
    -----------------
       
    Update History
    --------------
    Created August 2015 - Ramesh Botlagunta
    
    Issues / TODOs
    --------------
*/
public with sharing class G2O_InboundMessageLog_SVC{
   
    public static Boolean  isthisCalledfromInboundMessageLogtest=False;
    
    public static void logInboundMessages(List<sObject> new_sObjects,Map<Id,sObject> old_sObjectMap){
        
        Boolean hasToExcute=true;
        if(Test.isRunningTest() && (!isthisCalledfromInboundMessageLogtest)){
           hasToExcute=false;
        }
        
        if(hasToExcute){
            hasToExcuteLogInboundMessages(new_sObjects, old_sObjectMap);    
        }
         
    }
    
    public static void hasToExcuteLogInboundMessages(List<sObject> new_sObjects,Map<Id,sObject> old_sObjectMap){
    
         try{
              System.debug(LoggingLevel.info,'*** Start: <G2O_InboundMessage_SVC>.<logInboundMessages>');
              System.debug(LoggingLevel.info,'*****new_sObjects****' + new_sObjects + '****old_sObjectMap****' + old_sObjectMap );
              List<String> fieldList=new List<String>();
              Map<Schema.sObjectType,String> inboundMSG_LookupFieldsByType = new Map<Schema.sObjectType,String>();
              Map <String, Schema.SObjectField> new_sObjectFieldMap = new_sObjects.getsObjectType().getDescribe().fields.getMap(); 
              Map <String, String> new_sObjectFieldLabelMap = new Map <String, String>();        
              for(Schema.SObjectField sfield : new_sObjectFieldMap.Values()){
                    schema.describefieldresult dfield = sfield.getDescribe();               
                    fieldList.add(dfield.getname());  
                    new_sObjectFieldLabelMap.put(dfield.getname(),dfield.getLabel());                                                                          
              } 
              /*To populate name for id fields*/
              Map<String,List<Schema.sObjectType>> fieldNameSobjectTypesMap=new Map<String,List<Schema.sObjectType>>();
              for(Schema.SObjectField sfield : new_sObjectFieldMap.Values()){
                 List <Schema.sObjectType> types = sfield.getDescribe().getReferenceTo();
                 if (types.size()>0) {
                    fieldNameSobjectTypesMap.put(sfield.getDescribe().getName(),types);
                 }
              } 
              List<String> referenceIds=new List<String>();
              for(sObject new_sObject:new_sObjects){
                   Id sObjectId=(ID) new_sObject.get('Id');
                   if(old_sObjectMap.containsKey(sObjectId)){
                       Boolean isChanged=false;
                       sObject old_Sobject = old_sObjectMap.get(sObjectId);
                       for(String fieldName:fieldList){
                          if(new_sObject.get(fieldName) != old_sObject.get(fieldName)){  
                               if(fieldNameSobjectTypesMap.containsKey(fieldName)){
                                   if(!fieldNameSobjectTypesMap.get(fieldName).isEmpty()){
                                       if(!UTIL_Apex.empty(new_sObject.get(fieldName))){
                                           referenceIds.add(String.valueOf(new_sObject.get(fieldName)));
                                       }
                                       if(!UTIL_Apex.empty(old_sObject.get(fieldName))){
                                          referenceIds.add(String.valueOf(old_sObject.get(fieldName)));
                                       }
                                   }                                                                       
                               }                                         
                          }
                       }
                       
                   }
              }
              System.debug(LoggingLevel.info,'*****fieldNameSobjectTypesMap****' + fieldNameSobjectTypesMap+ '****referenceIds****' + referenceIds);
              
               //Id,Name of record
              Map<String,String> recordNamesByIdMap=new Map<String,String>();
              if(!referenceIds.isEmpty()){
                 Set<Schema.sObjectType> sobjectTypes=new Set<Schema.sObjectType>();
                 for(String refId:referenceIds){
                    Id referenceId=(Id)refId;
                    sobjectTypes.add(referenceId.getsObjectType());                    
                 }
                
                 Set<SObject> allSObjects=new Set<SObject>();
                 for(Schema.sObjectType sType:sobjectTypes){
                     String queryString='Select Id,Name from ';
                     queryString+=sType.getDescribe().getName();
                     queryString+=' where Id IN:referenceIds';
                     allSObjects.addAll((List<SObject>)Database.query(queryString));                    
                 }
                 for(SObject so:allSObjects){
                    recordNamesByIdMap.put(String.valueOf(so.get('Id')),String.valueOf(so.get('Name')));
                 }
                 System.debug(LoggingLevel.info,'*****recordNamesByIdMap****' + recordNamesByIdMap );
              
              }
              /*To populate name for id fields*/
              
                Map<String, Schema.SObjectField> fieldMap = UTIL_Meta.getFieldMap('Inbound_Message_Log__c');
                for (String fieldName : UTIL_Meta.getFieldMap('Inbound_Message_Log__c').keySet()) {
                    if (fieldName.indexOf('__c')!=-1) {
                        Schema.sObjectField fld = UTIL_Meta.getFieldMap('Inbound_Message_Log__c').get(fieldName);
                        List <Schema.sObjectType> types = fld.getDescribe().getReferenceTo();
                        if (types.size()>0) {
                            for (Schema.sObjectType tp : types) {
                                inboundMSG_LookupFieldsByType.put(tp, fieldName);                          
                            }
                        }
                    }
                } 
                String relatedFieldName = '';
                if (inboundMSG_LookupFieldsByType.containsKey(new_sObjects.getsObjectType())) {
                    relatedFieldName = inboundMSG_LookupFieldsByType.get(new_sObjects.getsObjectType());
                }
              List<Inbound_Message_Log__c> inboundMSG_List_ToInsert=new List<Inbound_Message_Log__c>();
              for(sObject new_sObject:new_sObjects){
                   Id sObjectId=(ID) new_sObject.get('Id');
                   if(old_sObjectMap.containsKey(sObjectId)){
                       Boolean isChanged=false;
                       sObject old_Sobject = old_sObjectMap.get(sObjectId);
                       String summary='<table border="1">';
                       summary=summary+'<tr><th>Field Label</th><th>Field Name</th><th>New Value</th><th>Old Value</th></tr>';
                       for(String fieldName:fieldList){
                          System.debug(LoggingLevel.info,'new_sObject.get(fieldName)......................'+new_sObject.get(fieldName));
                          System.debug(LoggingLevel.info,'old_sObject.get(fieldName)......................'+old_sObject.get(fieldName));
                          if(new_sObject.get(fieldName) != old_sObject.get(fieldName)){  
                               if(!isChanged){
                                  isChanged=true;
                               } 
                               System.debug(LoggingLevel.info,'new_sObject.get(fieldName).......................'+new_sObject.get(fieldName));
                               System.debug(LoggingLevel.info,'recordNamesByIdMap.......................'+recordNamesByIdMap);
                                      
                               //updated
                               if(fieldNameSobjectTypesMap.containsKey(fieldName)){
                                   if(!fieldNameSobjectTypesMap.get(fieldName).isEmpty()){
                                      summary+='<tr>';
                                      summary+='<td>'+ new_sObjectFieldLabelMap.get(fieldName)+'</td>';
                                      summary+='<td>'+ fieldName +'</td>';
                                      if(!UTIL_Apex.empty(new_sObject.get(fieldName))){
                                         summary+='<td>'+'<a href=/'+new_sObject.get(fieldName)+'>'+recordNamesByIdMap.get(String.valueOf(new_sObject.get(fieldName)))+'</a>'+'</td>';
                                      }
                                      else{
                                         summary+='<td>'+''+'</td>';
                                      }
                                      if(!UTIL_Apex.empty(old_sObject.get(fieldName))){
                                         summary+='<td>'+'<a href=/'+old_sObject.get(fieldName)+'>'+recordNamesByIdMap.get(String.valueOf(old_sObject.get(fieldName)))+'</a>'+'</td>';
                                      }
                                      else{
                                         summary+='<td>'+''+'</td>';
                                      }
                                      summary+='</tr>';
                                      //summary+='<td>'+'<a href=/'+new_sObject.get(fieldName)+'>'+recordNamesByIdMap.get(String.valueOf(new_sObject.get(fieldName)))+'</a>'+'</td>';
                                      //summary+='<td>'+'<a href=/'+old_sObject.get(fieldName)+'>'+recordNamesByIdMap.get(String.valueOf(old_sObject.get(fieldName)))+'</a>'+'</td>';
                                      //summary+='</td><td>'+recordNamesByIdMap.get(String.valueOf(old_sObject.get(fieldName)))+'<br />('+old_sObject.get(fieldName)+')'+'</td></tr>';                                         
                                      //summary=summary+'<tr><td>'+ new_sObjectFieldLabelMap.get(fieldName)+ '</td><td>'+ fieldName +'</td><td>'+recordNamesByIdMap.get(String.valueOf(new_sObject.get(fieldName)))+'<br />('+ new_sObject.get(fieldName)+')'+ '</td><td>'+recordNamesByIdMap.get(String.valueOf(old_sObject.get(fieldName)))+'<br />('+old_sObject.get(fieldName)+')'+'</td></tr>';                                         
                                   }
                                   else{
                                      summary=summary+'<tr><td>'+ new_sObjectFieldLabelMap.get(fieldName) + '</td><td>'+ fieldName +'</td><td>'+ new_sObject.get(fieldName) + '</td><td>'+old_sObject.get(fieldName)+'</td></tr>';                                         
                                   }
                               } 
                               else{                   
                                    summary=summary+'<tr><td>'+ new_sObjectFieldLabelMap.get(fieldName) + '</td><td>'+ fieldName +'</td><td>'+ new_sObject.get(fieldName) + '</td><td>'+old_sObject.get(fieldName)+'</td></tr>';                                         
                               }
                               
                               //summary=summary+'<tr><td>'+ new_sObjectFieldLabelMap.get(fieldName) + '</td><td>'+ fieldName +'</td><td>'+ new_sObject.get(fieldName) + '</td><td>'+old_sObject.get(fieldName)+'</td></tr>';
                          }
                       }
                       summary=summary+'</table>';
                       
                       if(isChanged){
                           
                           Inbound_Message_Log__c new_IM=new Inbound_Message_Log__c();
                           if (!UTIL_Apex.empty(relatedFieldName)) new_IM.put(relatedFieldName, sObjectId);
                           new_IM.Inbound_Message_Details__c=summary;
                           inboundMSG_List_ToInsert.add(new_IM);
                       }
                   }
              } 
              if(!inboundMSG_List_ToInsert.isEmpty()){        
                  System.debug(LoggingLevel.info,'*****inboundMSG_List_ToInsert****' + inboundMSG_List_ToInsert );
                  Database.SaveResult[] saveResults= Database.Insert(inboundMSG_List_ToInsert,false); 
                  for (Database.SaveResult sr : saveResults) {
                        if (!sr.isSuccess()) {               
                            /*List<Database.Error> errorlist=sr.getErrors();
                            UTIL_Error.report('Fields that affected this error while inserting Inbound Message : '+errorlist[0].getFields()+'-'+errorlist[0].getStatusCode() + ': ' + errorlist[0].getMessage());                                      
                            */
                        }
                  }          
              }
              
              System.debug(LoggingLevel.info,'*** End: <G2O_InboundMessage_SVC>.<logInboundMessages>');
         }
         catch(Exception e){
              UTIL_Error.report('Fields that affected this error while inserting Inbound Message : '+ e.getMessage());                                      
         }
         
     }
}