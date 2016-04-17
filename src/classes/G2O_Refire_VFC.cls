/**
    About
    -----
    Description: Implementation class for the SAP Refire Functionality
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Feb 2015
    
    Details
    -------
    
    Update History
    --------------
    Created Feb 2015
    
    Issues / TODOs :
    --------------  
*/
public without sharing class G2O_Refire_VFC {
    public Integer numberOfItemsToAdd{get;set;}
    public List<G2O_RefireModel> refireModelList{get;set;}
    public String operation{get;set;}
    public String fileUploadOperation{get;set;}
    public Integer number_Of_OBMs_ToUpsert{get;set;}
    public Set<String> involvedPartyIdsFoundInSFDC{get;set;}
    public Blob involvedPartyFile{get;set;}
    private static final String LABEL_NONE= 'NONE';
    private static final String LABEL_INSERT= 'INSERT';
    private static final String LABEL_UPDATE= 'UPDATE';
    private static final String LABEL_CUSTOMER_ID_HEADER='Customer Number';
    public G2O_Refire_VFC()
    {
        numberOfItemsToAdd=1;
        fileUploadOperation=LABEL_NONE;
        number_Of_OBMs_ToUpsert=0;
        refireModelList=new List<G2O_RefireModel>();
        involvedPartyIdsFoundInSFDC=new Set<String>();
        addItemsToRefireModelList();       
    }
    public boolean isMobile
    {
        get{
            //Using RegEx, figure out if the user is on a mobile device based on the user-agent string
            String userAgentString = System.currentPageReference().getHeaders().get('User-Agent');
            if (userAgentString == null)  return false;
            Pattern p = Pattern.compile('Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune');
            Matcher pm = p.matcher( userAgentString );      
            return pm.find();
         }
         set; 
    }
    public Integer numberOfItemsCanBeAdded
    {
        get{
            return 1000 - refireModelList.size();
         }
         set; 
    }
    public SelectOption[] operationOptions
    {
        get
        {               
               operationOptions = new SelectOption[]{};
               operationOptions.add(new SelectOption(LABEL_NONE,'--'+LABEL_NONE+'--'));
               operationOptions.add(new SelectOption(LABEL_INSERT,LABEL_INSERT));
               operationOptions.add(new SelectOption(LABEL_UPDATE,LABEL_UPDATE));
               /*
               Schema.DescribeFieldResult operationfieldResult =Outbound_Notification__c.Operation__c.getDescribe();
               List<Schema.PicklistEntry> plEntryList = operationfieldResult.getPicklistValues();               
               for( Schema.PicklistEntry plEntry:plEntryList)
               {
                  operationOptions.add(new SelectOption(plEntry.getValue(),plEntry.getLabel()));
               } 
               */      
                return operationOptions;
        }
        private set;
    }
    public Integer pageBlockTableDivSize
    {
        get
        {               
            pageBlockTableDivSize=isMobile ? 110 : 155;
            if(!refireModelList.isEmpty()) 
            {
               Integer refireModelListSize=refireModelList.size();
               pageBlockTableDivSize=pageBlockTableDivSize+(refireModelListSize*(isMobile ? 45 : 37));
               for(G2O_RefireModel rm:refireModelList){
                   if((!UTIL_Apex.empty(rm.idToRefireErrorMsg)) || (!UTIL_Apex.empty(rm.operationErrorMsg))){
                      pageBlockTableDivSize=pageBlockTableDivSize+(isMobile ? 20 : 20);
                   }
               }
            }               
            if(pageBlockTableDivSize>(isMobile ? 430 : 350)){
                pageBlockTableDivSize=isMobile ? 430 : 350;
            }
            return pageBlockTableDivSize;
        }
        private set;
    }
    public void uploadInvolvedPartyFile()
    {
           readCsvFile(involvedPartyFile);
    }
    private void readCsvFile(Blob csvFile)
    {
               System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.readCsvFile');
               if(csvFile==null)  {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Refire_Please_select_a_file));              
                    return;
               }      
               else{        
                       String blobString=EncodingUtil.base64Encode(csvFile);
                       Blob strToBlob=EncodingUtil.base64Decode(blobString);
                       String nameFile='';
                       try{
                           nameFile=strToBlob.toString();
                       }
                       catch(Exception e){
                             if(e.getMessage().equalsIgnoreCase(System.Label.Refire_BLOB_is_not_valid)){
                                e.setMessage(System.Label.Refire_Please_select_a_valid_file);
                             }
                             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                             return;
                       }
                       String[] filelines = new String[]{};
                       filelines = nameFile.split('\n');
                       List<List<String>> allCellvalues = new List<List<String>>();       
                       //to hold each row
                       for (Integer i=0;i<filelines.size();i++){
                             String[] inputvalues = new String[]{};                 
                             inputvalues = filelines[i].split(',');
                             //to hold each cell
                             List<String> eachRowCellValues=new List<String>();
                             for (Integer y=0;y<inputvalues.size();y++){         
                               eachRowCellValues.add(inputvalues[y]);
                             }                           
                             allCellvalues.add(eachRowCellValues);         
                       } 
                       String[] headerRowCells = allCellvalues[0];
                       Integer invPartyColHeaderIndex;
                       Boolean hasCustomerNumberColumn=false;
                       for(Integer i=0;i<headerRowCells.size();i++){
                          String headerValue=headerRowCells[i].trim().replace(' ','');                         
                          String headerLabel=System.Label.Refire_Customer_Number_Header_In_CSV_File.replace(' ','');
                          if(headerValue.equalsIgnoreCase(headerLabel)){                          
                             invPartyColHeaderIndex=i;
                             hasCustomerNumberColumn=true;                           
                          }
                       }
                       Set<String>   involvedIdSet=new Set<String>();
                       if(hasCustomerNumberColumn){                           
                           for (Integer i=1;i<allCellvalues.size();i++){
                                String[] eachRowCells = new String[]{};                                         
                                eachRowCells = allCellvalues[i];
                                involvedIdSet.add(eachRowCells[invPartyColHeaderIndex].trim());  
                           }  
                           Integer randomInt = Crypto.getRandomInteger();
                           if(involvedIdSet.size() <= numberOfItemsCanBeAdded){
                               for(String invId:involvedIdSet){
                                   G2O_RefireModel rm=new G2O_RefireModel(false,invId,fileUploadOperation,randomInt);
                                   refireModelList.add(rm);
                               } 
                           }
                           else{
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Refire_1000_records_can_be_processed_at_a_time));
                              return;
                           }
                       } 
                       else{
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Refire_Customer_Number_Not_Found));
                           return;
                       }
                   involvedPartyFile=null;                                    
               }
               resetRefireModelIndex();
               System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.readCsvFile');
    }
    public void addItemsToRefireModelList()
    {
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.addItemsToRefireModelList');
         Integer randomInt = Crypto.getRandomInteger();
         for(Integer i=0;i<numberOfItemsToAdd;i++){
             G2O_RefireModel rm=new G2O_RefireModel(false,'',LABEL_NONE,randomInt);
             refireModelList.add(rm);
         }
         resetRefireModelIndex();    
         System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.addItemsToRefireModelList');    
    }
    private Map<String,Set<Integer>> findDuplicates(List<G2O_RefireModel> refireModels)
    {
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.findDuplicates');
         Map<String,Set<Integer>> duplicatesMap=new Map<String,Set<Integer>>();
         for(G2O_RefireModel rm:refireModels){
             if(!UTIL_Apex.empty(rm.idToRefire)){
                 if(!duplicatesMap.containsKey(rm.idToRefire)){
                     duplicatesMap.put(rm.idToRefire,new Set<Integer>{});
                 }
                 else{
                     duplicatesMap.get(rm.idToRefire).add(rm.index+1);
                 }
             }
         }
         System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.findDuplicates');
         return duplicatesMap;      
    }
    private void resetRefireModelIndex()
    {
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.resetRefireModelIndex');
         Integer refireModelListSize=refireModelList.size(),htmlColorIndex = 0;
         for(Integer i=0;i<refireModelListSize;i++){    
               refireModelList[i].index=i;                   
               if((refireModelListSize > 1) && (i < refireModelListSize-1)){
                   refireModelList[i].showCopyDownLink=true;  
               } 
               else{
                   refireModelList[i].showCopyDownLink=false;
               }  
                if(!(i > 0 && refireModelList[i].trackingNumber == refireModelList[i-1].trackingNumber)){
                    htmlColorIndex++;
                }
                if(htmlColorIndex >= HTMLColors.values().size()){
                    htmlColorIndex = 0;
                }
                refireModelList[i].htmlColor = HTMLColors.values()[htmlColorIndex].name();                      
         }    
         System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.resetRefireModelIndex');       
    }   
    public void removeItemsFromRefireModelList()
    {
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.removeItemsFromRefireModelList');
         List<G2O_RefireModel> refireModels_AfterRemove=new List<G2O_RefireModel>();
         for(Integer i=0;i<refireModelList.size();i++){           
            if(!refireModelList[i].isSelected){
               refireModels_AfterRemove.add(refireModelList[i]);               
            }
         }
         refireModelList=new List<G2O_RefireModel>();
         refireModelList=refireModels_AfterRemove;
         refireModels_AfterRemove=new List<G2O_RefireModel>();
         resetRefireModelIndex();
         System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.removeItemsFromRefireModelList');
    }
    public void resetAll()
    {
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.resetAll');
         refireModelList=new List<G2O_RefireModel>();  
         System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.resetAll');     
    }
    public void refireAllItems()
    {
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.refireAllItems');
         if(!refireModelList.isEmpty()){
                 intiateRefire(refireModelList);
         } 
         System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.refireAllItems');           
    }
    public void refireTheSelectedItems()
    {
             System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.refireTheSelectedItems');
             List<G2O_RefireModel> selectedRefireModels=new List<G2O_RefireModel>();
             for(Integer i=0;i<refireModelList.size();i++){
                if(refireModelList[i].isSelected){
                    selectedRefireModels.add(refireModelList[i]);
                }
             }  
             if(!selectedRefireModels.isEmpty()){
                 intiateRefire(selectedRefireModels);
             }     
             System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.refireTheSelectedItems');          
    }
    private void intiateRefire(List<G2O_RefireModel> refireModels)
    {
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.intiateRefire');
         Boolean hasError=false,isAllSetForRefire=true;
         Map<String,G2O_RefireModel> mapToRefire=new Map<String,G2O_RefireModel>();
         Map<String,Set<Integer>> duplicatesMap=findDuplicates(refireModels);
         for(Integer i=0;i<refireModels.size();i++){
                Boolean hasValidId=isInvolvedPartyIdValid(refireModels[i]);
                Boolean hasValidOperation=isOperationValid(refireModels[i]);
                if((!hasValidId) || (!hasValidOperation)){
                     isAllSetForRefire=false;
                }  
                if(duplicatesMap.containsKey(refireModels[i].idToRefire)){             
                     if(duplicatesMap.get(refireModels[i].idToRefire).isEmpty()){
                         mapToRefire.put(refireModels[i].idToRefire,refireModels[i]);
                     }
                     else{
                        if(!duplicatesMap.get(refireModels[i].idToRefire).contains(refireModels[i].index+1))
                        {  
                          refireModels[i].idToRefireErrorMsg='Please delete duplicate rows '+duplicatesMap.get(refireModels[i].idToRefire)+' and try again.'; 
                          isAllSetForRefire=false;
                        }
                     }
                }     
         }  
         if(isAllSetForRefire){
             if(!mapToRefire.isEmpty()){
                  List<Outbound_Notification__c> OBMs_ToUpsert=getOutboundNotificationsToUpsert(mapToRefire);
                  if(OBMs_ToUpsert!=null && OBMs_ToUpsert.size()>0){
                      number_Of_OBMs_ToUpsert=OBMs_ToUpsert.size();
                      upsertOutboundNotifications(OBMs_ToUpsert);
                  }
                  diplayNoteMessage(mapToRefire.keySet());
             }
         }    
         System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.intiateRefire'); 
    }
    private Boolean isInvolvedPartyIdValid(G2O_RefireModel refireModel){
            System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.isInvolvedPartyIdValid'); 
            refireModel.idToRefireErrorMsg='';
            Boolean isValid=true;
            if(!UTIL_Apex.empty(refireModel.idToRefire)){ 
                  try{                  
                      Double invPartyId_double=Double.valueOf(refireModel.idToRefire);
                      if(invPartyId_double <= 0)
                      {
                          isValid=false;
                          refireModel.idToRefireErrorMsg=System.Label.Refire_Please_enter_a_valid_Involved_Party_Id;
                      }
                  }
                  catch(Exception e){
                       isValid=false;
                       refireModel.idToRefireErrorMsg=System.Label.Refire_Please_enter_a_valid_Involved_Party_Id;
                  }                 
            }
            else{
                  isValid=false;
                  refireModel.idToRefireErrorMsg=System.Label.Refire_Please_enter_an_Involved_Party_Id;
            } 
          System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.isInvolvedPartyIdValid');          
          return isValid;
    }
    private Boolean isOperationValid(G2O_RefireModel refireModel){
         System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.isOperationValid');
            refireModel.operationErrorMsg='';
            Boolean isValid=true;
            if(refireModel.operation.equalsIgnoreCase(LABEL_NONE)){                 
                  isValid=false;
                  refireModel.operationErrorMsg=System.Label.Refire_Please_select_an_operation;
            }
            else{
                  refireModel.operationErrorMsg='';
            }
          System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.isOperationValid'); 
          return isValid;
    }
    private void diplayNoteMessage(Set<String> involvedPartyIdsSet)
    {
        System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.diplayNoteMessage');
        Boolean hasInvolvedIdsNotFound=false;
        String note_Message='Involved Party Id(s)-';
        for(String involvedId:involvedPartyIdsSet){
              if(!involvedPartyIdsFoundInSFDC.contains(involvedId)){
                  hasInvolvedIdsNotFound=true;
                  note_Message=note_Message+involvedId+',';
              }
        }
        if(hasInvolvedIdsNotFound){
            note_Message=note_Message.subString(0,note_Message.length()-1);
            note_Message=note_Message+' Does not exist.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,note_Message));
        }  
        System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.diplayNoteMessage');      
    }
    private void upsertOutboundNotifications(List<Outbound_Notification__c> OBN_List_To_Upsert)
    {       
        if(OBN_List_To_Upsert!=null && OBN_List_To_Upsert.size()>0){
                Database.UpsertResult[] upsertResults= Database.upsert(OBN_List_To_Upsert,Outbound_Notification__c.Fields.Notification_Key__c,false);
                Boolean isUpsertFailed=false;
                for(Database.UpsertResult  upsert_Result : upsertResults){
                    if (!upsert_Result.isSuccess()){
                        isUpsertFailed=true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,upsert_Result.errors[0].message));
                        System.debug('\n\nERROR r: '+upsert_Result.errors[0].message+'\n\n');
                    }
                }
                if(!isUpsertFailed){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Refire_Operation_Completed));
                }                
         }      
    }
    private String getOperation(Map<String,G2O_RefireModel> refireIdsmap,String involvedId)
    {
           System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.getOperation');  
             String operationToReturn='',involvedPartyId=UTIL_Apex.empty(involvedId)?'':involvedId;
             if(refireIdsmap.containsKey(involvedPartyId)){
                 if(!UTIL_Apex.empty(refireIdsmap.get(involvedPartyId).operation)){
                     operationToReturn=refireIdsmap.get(involvedPartyId).operation;
                 }
             }
           System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.getOperation');  
             return operationToReturn;
    }
    private String prepareOutboundNotificationKey(String operation,String objectApiName,String objExternalId,String involvedId)
    {
             System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.prepareOutboundNotificationKey'); 
             String notificationKey=objectApiName,involvedPartyId=UTIL_Apex.empty(involvedId)?'':involvedId;
             if(!UTIL_Apex.empty(objExternalId)){
                  notificationKey=notificationKey+':'+objExternalId;
             }            
             if(!UTIL_Apex.empty(operation)){
                notificationKey=notificationKey+':'+operation;
             }
             System.debug('notificationKey...................='+notificationKey);
             System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.prepareOutboundNotificationKey');
           return notificationKey;
    }
    private List<Outbound_Notification__c> getOutboundNotificationsToUpsert(Map<String,G2O_RefireModel> refireIdsmap)
    {
        System.debug(LoggingLevel.info,'*** START: G2O_Refire_VFC.getOutboundNotificationsToUpsert');
        List<Outbound_Notification__c> OBN_List=new List<Outbound_Notification__c>();
        involvedPartyIdsFoundInSFDC=new Set<String>();
        
        for(Account acc:[SELECT Id, Involved_Party_Id__c FROM Account WHERE Involved_Party_Id__c IN:refireIdsmap.keySet()]){
             involvedPartyIdsFoundInSFDC.add(acc.Involved_Party_Id__c);
             String operation=getOperation(refireIdsmap,acc.Involved_Party_Id__c);             
             String notificationKey=prepareOutboundNotificationKey(operation,'Account',acc.Involved_Party_Id__c,acc.Involved_Party_Id__c);            
             Outbound_Notification__c obn=new Outbound_Notification__c(Object_SFDC_ID__c=acc.Id,Object_API_Name__c='Account',Object_External_ID__c=acc.Involved_Party_Id__c,Notification_Key__c=notificationKey,Operation__c=operation);
             OBN_List.add(obn);
        }
        for(Account_Contact_Role_Transaction__c accCRT:[SELECT Id, Account_Contact_Role_SFID__c,Account__r.Involved_Party_Id__c FROM Account_Contact_Role_Transaction__c  WHERE Account__r.Involved_Party_Id__c IN:refireIdsmap.keySet()]){
             involvedPartyIdsFoundInSFDC.add(accCRT.Account__r.Involved_Party_Id__c);
             String operation=getOperation(refireIdsmap,accCRT.Account__r.Involved_Party_Id__c);
             String notificationKey=prepareOutboundNotificationKey(operation,'Account_Contact_Role_Transaction__c',accCRT.Account_Contact_Role_SFID__c,accCRT.Account__r.Involved_Party_Id__c);
             Outbound_Notification__c obn=new Outbound_Notification__c(Object_SFDC_ID__c=accCRT.Id,Object_API_Name__c='Account_Contact_Role_Transaction__c',Object_External_ID__c=accCRT.Account_Contact_Role_SFID__c,Notification_Key__c=notificationKey,Operation__c=operation);
             OBN_List.add(obn);
        }
        for(Bank_Details__c bDetails:[SELECT Id, Bank_Details_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Bank_Details__c WHERE Account__r.Involved_Party_Id__c IN:refireIdsmap.keySet()]){
             involvedPartyIdsFoundInSFDC.add(bDetails.Account__r.Involved_Party_Id__c);
             String operation=getOperation(refireIdsmap,bDetails.Account__r.Involved_Party_Id__c);
             String notificationKey=prepareOutboundNotificationKey(operation,'Bank_Details__c',bDetails.Bank_Details_Compound_SFID__c,bDetails.Account__r.Involved_Party_Id__c);
             Outbound_Notification__c obn=new Outbound_Notification__c(Object_SFDC_ID__c=bDetails.Id,Object_API_Name__c='Bank_Details__c',Object_External_ID__c=bDetails.Bank_Details_Compound_SFID__c,Notification_Key__c=notificationKey,Operation__c=operation);
             OBN_List.add(obn);
        }
        for(Contact con:[SELECT Id, Contact_Person_ID__c,Account.Involved_Party_Id__c FROM Contact WHERE Account.Involved_Party_Id__c IN:refireIdsmap.keySet()]){
             involvedPartyIdsFoundInSFDC.add(con.Account.Involved_Party_Id__c);
             String operation=getOperation(refireIdsmap,con.Account.Involved_Party_Id__c);
             if(!UTIL_Apex.empty(con.Contact_Person_ID__c)){
                 String notificationKey=prepareOutboundNotificationKey(operation,'Contact',con.Contact_Person_ID__c,con.Account.Involved_Party_Id__c);
                 Outbound_Notification__c obn=new Outbound_Notification__c(Object_SFDC_ID__c=con.Id,Object_API_Name__c='Contact',Object_External_ID__c=con.Contact_Person_ID__c,Notification_Key__c=notificationKey,Operation__c=operation);
                 OBN_List.add(obn);
             }
        }
        for(Credit_Information__c creditInfo:[SELECT Id, Credit_Information_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Credit_Information__c WHERE Account__r.Involved_Party_Id__c IN:refireIdsmap.keySet()]){
            involvedPartyIdsFoundInSFDC.add(creditInfo.Account__r.Involved_Party_Id__c);
            String operation=getOperation(refireIdsmap,creditInfo.Account__r.Involved_Party_Id__c);
            String notificationKey=prepareOutboundNotificationKey(operation,'Credit_Information__c',creditInfo.Credit_Information_Compound_SFID__c,creditInfo.Account__r.Involved_Party_Id__c);
            Outbound_Notification__c obn=new Outbound_Notification__c(Object_SFDC_ID__c=creditInfo.Id,Object_API_Name__c='Credit_Information__c',Object_External_ID__c=creditInfo.Credit_Information_Compound_SFID__c,Notification_Key__c=notificationKey,Operation__c=operation);
            OBN_List.add(obn);
        }
        for(Relationship__c relation:[SELECT Id, Relationship_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Relationship__c WHERE Account__r.Involved_Party_Id__c IN:refireIdsmap.keySet()]){
             involvedPartyIdsFoundInSFDC.add(relation.Account__r.Involved_Party_Id__c);
             String operation=getOperation(refireIdsmap,relation.Account__r.Involved_Party_Id__c);
             String notificationKey=prepareOutboundNotificationKey(operation,'Relationship__c',relation.Relationship_Compound_SFID__c,relation.Account__r.Involved_Party_Id__c);
             Outbound_Notification__c obn=new Outbound_Notification__c(Object_SFDC_ID__c=relation.Id,Object_API_Name__c='Relationship__c',Object_External_ID__c=relation.Relationship_Compound_SFID__c,Notification_Key__c=notificationKey,Operation__c=operation);
             OBN_List.add(obn);
        }
        for(Sales_Area_Information__c salesAreaInfo:[SELECT Id, Sales_Area_Information_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Sales_Area_Information__c WHERE Account__r.Involved_Party_Id__c IN:refireIdsmap.keySet()]){
             involvedPartyIdsFoundInSFDC.add(salesAreaInfo.Account__r.Involved_Party_Id__c);
             String operation=getOperation(refireIdsmap,salesAreaInfo.Account__r.Involved_Party_Id__c);
             String notificationKey=prepareOutboundNotificationKey(operation,'Sales_Area_Information__c ',salesAreaInfo.Sales_Area_Information_Compound_SFID__c,salesAreaInfo.Account__r.Involved_Party_Id__c);
             Outbound_Notification__c obn=new Outbound_Notification__c(Object_SFDC_ID__c=salesAreaInfo.Id,Object_API_Name__c='Sales_Area_Information__c',Object_External_ID__c=salesAreaInfo.Sales_Area_Information_Compound_SFID__c,Notification_Key__c=notificationKey,Operation__c=operation);
             OBN_List.add(obn);
        }      
        System.debug(LoggingLevel.info,'*** END: G2O_Refire_VFC.getOutboundNotificationsToUpsert');  
        return OBN_List;
    }
    public enum HTMLColors
    {
        LightPink,
        LightCoral,
        LightSalmon,
        LightGreen,
        LightBlue
    }
    public class G2O_RefireModel {
        
        public Boolean isSelected{get;set;}  
        public String idToRefire{get;set;}
        public Integer invPartyId{get;set;}
        public Integer index{get;set;}
        public Boolean showCopyDownLink{get;set;}
        public String operation{get;set;}
        public String idToRefireErrorMsg{get;set;}
        public String operationErrorMsg{get;set;}
        public String htmlColor{get;set;}
        public Integer trackingNumber{get;set;}
        
        public G2O_RefireModel(Boolean isSel,String idToRef,String op,Integer randInt)
        {
               isSelected=isSel;
               idToRefire=idToRef;
               operation=op;
               trackingNumber=randInt;
        }       
    }
}