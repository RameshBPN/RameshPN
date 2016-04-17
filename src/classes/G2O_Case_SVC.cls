/**
    About
    -----  
    Description:Class for General Case Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
     1. Inserts new CaseProduct record for new case of recordtypes: 'Complaint','Customer Feedback' or 'Customer Assignment' only if product/article or itemid is present.
     2. Updates the primary caseProduct with product-article & ItemId field.
     3. Inserts new CaseProduct record for a case of 'Complaint','Customer Feedback' or 'Customer Assignment' recordtypes if product/article or itemid is populated for the first time.
     4. Structured Communicaiton functionality.
     5. Update credit limit on case on Before Insert scenario.
     6. Updates the correct country field based on an account relation
     7. Updates the Status field on the linked opportunity for Admin Activity Cases. Copies the status from the Case.
     
    Update History
    --------------
    Created April 2013 - A.B.
    1. Updated JUNE  2013 - A.B. Commented manageCaseOwnerChangeBeforeUpdate & manageCaseOwnerChangeBeforeInsert ,Case_Owner__c is no longer required, removed & requirement is satisfied by SFDC out of the box functionality.
    2. Updated July  2013 - A.B.-Refactored
    3. Updated August 2014 - A.C. - Added method updateOppStatus to cover pount 7 in the details section
    4. Updated November 2014 Karthik K.J-Refactored(Added method autoInsertCase,autoCloseParentCase to upate the parent case)
    Issues / TODOs: 
    --------------  
*/
public with sharing class G2O_Case_SVC {
    
    //A.T.T.R.I.B.U.T.E.S
    
    public static Boolean setArticle = false;       //This flag is set to true to prevent recursive call from setCaseProductArticleBeforeUpdate.
    public static Boolean createCP = false;          //This flag is set to true to prevent recursive call from createCaseProductBeforeUpdate.
    static public Integer childCount = 0;
    //A.T.T.R.I.B.U.T.E.S
    
    //1. This is called from After Insert Trigger,this inserts new CaseProduct record for new case of 'Complaint','Customer Feedback' or 'Customer Assignment' recordtypes if product/article or itemid is present.
    public static void createCaseProductAfterInsert(List<Case> newCase){
        
        System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<createCaseProductAfterInsert>');
        
        system.debug(Logginglevel.INFO,'FLAG:+++++1setArticle_BU INSIDE+++++'+setArticle);
        system.debug(Logginglevel.INFO,'FLAG:+++++1createCP_BU INSIDE+++++'+createCP);
        
        try{
            if(!createCP){
                
                createCP=true;              //Setting the flag to prevent recursive call to this trigger on case Insert.
                setArticle=true;            //Setting the flag to prevent recursive call to this trigger on case Insert.
                
                set<Id> rTypeIdSet = new set<Id>();
                List<CaseProduct__c> caseProLst =new List<CaseProduct__c>();
                String developerName = UTIL_OrgSettings.CaseRecordTypes();
                List<String> rTypLst = developerName.split(',');        //Valid Developer Name from Custom Settings.
                
                for(RecordType rType:[Select r.Name, r.Id, r.DeveloperName From RecordType r where  r.DeveloperName IN:rTypLst AND r.SobjectType ='Case']){
                    rTypeIdSet.add(rType.Id);
                }
                
                system.debug(Logginglevel.INFO,'++++newCase2++++'+newCase);
                system.debug(Logginglevel.INFO,'++++rTypeIdSet+++'+rTypeIdSet);
                for(Case cas:newCase){
                    
                    //Checking if the recordType is valid,Product_Article__c & itemId are not empty.
                    if(rTypeIdSet.contains(cas.RecordTypeId)){
                        caseProLst.add(copyCaseProductFieldsFromCase(cas));
                    }
                }
                
                system.debug(Logginglevel.INFO,'+++++caseProLst++++'+caseProLst);
                
                if(!caseProLst.isEmpty())
                insert caseProLst;
            }
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        
        System.debug(LoggingLevel.info,'*** END: <Case_SVC>.<createCaseProductAfterInsert>');
    }
    
    //2. This is called from After Update Trigger,this updates the primary caseProduct with product-article & ItemId field.
    public static void setCaseProductArticleAfterUpdate(List<Case> newCase){
        
        System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<setCaseProductArticleAfterUpdate>');
        
        system.debug(Logginglevel.INFO,'FLAG:+++++2setArticle_BU INSIDE+++++'+setArticle);
        system.debug(Logginglevel.INFO,'FLAG:+++++2createCP_BU INSIDE+++++'+createCP);
        
        try{
            if(!setArticle){
                
                setArticle=true;                       //setting the flag to prevent recursive call.
                
                system.debug(Logginglevel.INFO,'+++++INSIDE CASE AFTER+++++');
                Map<Id,Case> caseIdToCaseMap =new Map<Id,Case> ();
                List<CaseProduct__c> caseProLst =new List<CaseProduct__c>();
                
                for(Case cas:newCase){

                    caseIdToCaseMap.put(cas.Id,cas);
                }
                
                for(CaseProduct__c casePro:[Select c.IsPrimary__c,c.Customer_Service_Product__c,c.Item_Id__c, c.Case__c From CaseProduct__c c where c.Case__c IN:caseIdToCaseMap.keySet() AND c.IsPrimary__c=true]){
                    casePro.Customer_Service_Product__c=caseIdToCaseMap.get(casePro.Case__c).Product_Article__c;
                    casePro.Item_Id__c=caseIdToCaseMap.get(casePro.Case__c).Item_Id__c;
                    caseProLst.add(casePro);
                }
                
                if(!caseProLst.isEmpty()){
                    update caseProLst;
                }
            }
        }catch(EXCEPTION e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        
        System.debug(LoggingLevel.info,'*** END: <Case_SVC>.<setCaseProductArticleAfterUpdate>');
    }
    
    //3. This is called from After Update Trigger,this inserts new CaseProduct record for a case of 'Complaint','Customer Feedback' 
    //   or 'Customer Assignment' recordtypes if product/article or itemid is populated for the first time.
    public static void createCaseProductAfterUpdate(List<Case> newCase){
        
        System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<createCaseProductAfterUpdate>');
        
        system.debug(Logginglevel.INFO,'FLAG:+++++5setArticle_BU INSIDE+++++'+setArticle);
        system.debug(Logginglevel.INFO,'FLAG:+++++5createCP_BU INSIDE+++++'+createCP);
        
        try{
            if(!createCP){
                
                createCP = true;                //Setting the flag to prevent recursive call to this trigger on case Insert.
                setArticle = true;          //Setting the flag to prevent recursive call to this trigger on case Insert.
                
                set<Id> rTypeIdSet = new set<Id>();
                List<CaseProduct__c> caseProLst =new List<CaseProduct__c>();
                String developerName = UTIL_OrgSettings.CaseRecordTypes();
                List<String> rTypLst = developerName.split(',');        //Valid Developer Name from Custom Settings.
                
                for(RecordType rType:[Select r.Name, r.Id, r.DeveloperName From RecordType r where  r.DeveloperName IN:rTypLst AND r.SobjectType ='Case']){
                    rTypeIdSet.add(rType.Id);
                }
                
                
                for(Case cas:newCase){
                    //Checking if the recordType is valid.
                    if(rTypeIdSet.contains(cas.RecordTypeId)){
                        caseProLst.add(copyCaseProductFieldsFromCase(cas));
                    }
                }
                
                system.debug(Logginglevel.INFO,'++++caseProLst+++'+caseProLst);
                if(!caseProLst.isEmpty())
                    insert caseProLst;
            }
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        
        System.debug(LoggingLevel.info,'*** END: <Case_SVC>.<createCaseProductAfterUpdate>');
    }
    
    // This method copies the fields from case to caseproduct & returns a caseproduct record.
    private static CaseProduct__c copyCaseProductFieldsFromCase(Case cas){
        
        CaseProduct__c cpRec =new CaseProduct__c();
        
        cpRec.Item_Id__c = cas.Item_Id__c;
        cpRec.Case__c = cas.Id;
        cpRec.Customer_Service_Product__c = cas.Product_Article__c;
        cpRec.Sender_Postal_Address_C_O__c = cas.Sender_Postal_Address_C_O__c;
        cpRec.Sender_Postal_Address_Street__c = cas.Sender_Postal_Address_Street__c;
        cpRec.Sender_Postal_Address_Postal_Code__c = cas.Sender_Postal_Address_Postal_Code__c;
        cpRec.Sender_Postal_Address_City__c = cas.Sender_Postal_Address_City__c;
        cpRec.Sender_Postal_Address_Country__c = cas.Sender_Postal_Address_Country__c;
        cpRec.Receiver_Company_Name__c = cas.Receiver_Name__c;
        cpRec.Receiver_Postal_Address_C_O__c = cas.Receiver_Postal_Address_C_O__c;
        cpRec.Receiver_Postal_Address_Street__c = cas.Receiver_Postal_Address_Street__c;
        cpRec.Receiver_Postal_Address_Postal_Code__c = cas.Receiver_Postal_Address_Postal_Code__c;
        cpRec.Receiver_Postal_Address_City__c = cas.Receiver_Postal_Address_City__c;
        cpRec.Receiver_Postal_Address_Country__c = cas.Receiver_Postal_Address_Country__c;
        cpRec.COD_Amount__c = cas.COD_Amount__c;
        cpRec.Value__c = cas.Value__c;
        cpRec.Account_Number__c = cas.Account_Number__c;
        cpRec.Account_Type__c = cas.Account_Type__c;
        
        return cpRec;
    }
    
    //4. This is called from Before Update Trigger,This addresses Structured Communicaiton functionality.
    public static void structuredComm_ManageFunctionalInboxes(List<Case> functionalInboxCases){
        
        System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<structuredCommunicaiton>');
        system.debug(Logginglevel.INFO,'+++functionalInboxCases++'+functionalInboxCases);
        //A.T.T.R.I.B.U.T.E.S
        
        List<Contact> contactsToUpsertLst = new List<Contact>();                        //Holds contacts name for which contact record has to be upserted.
        
        Map<Id,List<Case>> accIdToLstOfCaseMap = new Map<Id,List<Case>>();          //Holds account Ids to case mapping for which contact record has to be set.
        
        Map<Id,Contact> accIdToContactMap =new Map<Id,Contact>();                   //Holds accountId to related contact mapping based on Account Name.
        Map<Id,Account> accIdToAccountMap = new Map<Id,Account>();                  //Holds account Ids to Account Map.
        
        String namePrefix =UTIL_OrgSettings.ContactName_StructuredCommunication();  //Getting the namePrefix from custom setting.
        Id rTypeId = UTIL_Meta.getContactPostNordEmployeeRT();
        Id orgStructureRTId = UTIL_Meta.getAccountPostNordOrgStructureRT();
        
        //A.T.T.R.I.B.U.T.E.S
        
        List<Id> accountIds = new  List<Id>();
        
        for(Case c : functionalInboxCases) {
            accountIds.add(c.Respondent_Org_ID__c);
        }
        
        Map<Id, Account> accountRecordTypeMap = new Map<Id, Account>([SELECT Id, RecordTypeId FROM Account WHERE Id IN :accountIds]);

        //Filtering the records base on Is_Main_Case__c & Respondent_Org_ID__c.
        for(Case casRec: functionalInboxCases){
            
            if(casRec.Respondent_Org_ID__c==null){  //Case records where Respondent_Org_ID__c Id is being removed.
                casRec.ContactId = null;
                
                system.debug(Logginglevel.INFO,'++casRec+'+casRec);
                
            }else if(accountRecordTypeMap.get(casRec.Respondent_Org_ID__c).RecordTypeId == orgStructureRTId){
                if(accIdToLstOfCaseMap.containsKey(casRec.Respondent_Org_ID__c)){   //Case records where Respondent_Org_ID__c Id is changed but not removed.
                    accIdToLstOfCaseMap.get(casRec.Respondent_Org_ID__c).add(casRec);
                }else{
                    accIdToLstOfCaseMap.put(casRec.Respondent_Org_ID__c,new List<Case> {casRec});
                }
            }
            
        }
        
        system.debug(Logginglevel.INFO,'++accIdToLstOfCaseMap+'+accIdToLstOfCaseMap);
        
        //Getting the records from Account based on Respondent_Org_ID__c value to get the account name.
        if(!accIdToLstOfCaseMap.keySet().isEmpty()){
            
            for(Account accRec: [Select Name, Id, Functional_Inbox_Email__c, language__c, RecordTypeId From Account Where Id IN:accIdToLstOfCaseMap.keySet()]){
                accIdToAccountMap.put(accRec.Id,accRec);
            }
        }
        
        //Getting the functional inbox contacts for these accounts.
        for(Contact conRec: [Select c.RecordTypeId, c.Name, c.Is_Org_Unit_Contact__c, c.AccountId From Contact c
                                Where c.AccountId IN:accIdToLstOfCaseMap.keySet() AND c.RecordTypeId =:rTypeId 
                                AND c.Is_Org_Unit_Contact__c=true]){
            
            accIdToContactMap.put(conRec.AccountId,conRec);
        }
        
        system.debug(Logginglevel.INFO,'+++accIdToContactMap+++'+accIdToContactMap);
        
        //Populating contact.
        for(Id accId: accIdToLstOfCaseMap.keySet()){
            Contact contct = new Contact();
            
            // If contacts exist for the account.
            if(accIdToContactMap.containsKey(accId)){
                contct = accIdToContactMap.get(accId);
                contct.Email = accIdToAccountMap.get(accId).Functional_Inbox_Email__c;  //Setting the contact email to account Functional Inbox email.
                system.debug(Logginglevel.INFO,'+++1contct+++'+contct);
            }else{
                // If no contact exist for the account,creating new contact & adding it to the list to insert it later.
                contct.FirstName = namePrefix;
                contct.LastName = accIdToAccountMap.get(accId).Name;
                contct.AccountId = accId;
                contct.RecordTypeId = rTypeId;
                contct.Is_Org_Unit_Contact__c = true;
                contct.Email = accIdToAccountMap.get(accId).Functional_Inbox_Email__c;  //Setting the contact email to account Functional Inbox email.
                contct.Language__c = accIdToAccountMap.get(accId).Language__c;
                contct.Contact_Person_Type__c = 'PostNord Created';
                contct.Verified__c = 'N';
                system.debug(Logginglevel.INFO,'+++contct+++'+contct);
                system.debug('+++namePrefix+++'+namePrefix);
                system.debug('+++contct+++'+contct);
            }
            contactsToUpsertLst.add(contct);
        }
        
        system.debug('+++contactsToUpsertLst+++'+contactsToUpsertLst);
        system.debug(Logginglevel.INFO,'+++contactsToUpsertLst+++'+contactsToUpsertLst);
        
        //Upserting Contacts records.
        upsert contactsToUpsertLst;
        
        for(integer i=0; i<contactsToUpsertLst.size();i++){
            if(accIdToLstOfCaseMap.containsKey(contactsToUpsertLst[i].AccountId)){
                
                for(Case cas:accIdToLstOfCaseMap.get(contactsToUpsertLst[i].AccountId)){
                    cas.ContactId = contactsToUpsertLst[i].Id;
                    system.debug(Logginglevel.INFO,'+++1contct2+++'+cas.ContactId);
                }
            }
        }
        
        System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<structuredCommunicaiton>');
    }
    
    //5. Update credit limit on case on Before Insert scenario.
    public static void updateCreditLimit(List<Case> creditLimitList){
        
        Set<Id> accountIdSet = new Set<Id>();
        Set<String> caseCreditControlSet = new Set<String>();
        Map<Id,List<Credit_Information__c>> accIdToCreditInfoMap = new Map<Id,List<Credit_Information__c>>();
        
        
        for(Case cas : creditLimitList){
            
            accountIdSet.add(cas.AccountId);
            caseCreditControlSet.add(cas.Credit_control_area__c);
        }
        
        system.debug(Logginglevel.INFO,'++accountIdSet+++'+accountIdSet);
        system.debug(Logginglevel.INFO,'++caseCreditControlSet+++'+caseCreditControlSet);
        
        for(Credit_Information__c creditInfo: [Select c.Credit_Control_Area__c,c.Credit_Limit__c, c.Account__c From Credit_Information__c c
                                                Where c.Account__c IN:accountIdSet AND c.Credit_Control_Area__c IN:caseCreditControlSet ]){
            
            system.debug(Logginglevel.INFO,'++creditInfo++'+creditInfo);
            
            if(accIdToCreditInfoMap.containsKey(creditInfo.Account__c)){
                accIdToCreditInfoMap.get(creditInfo.Account__c).add(creditInfo);
            }else{
                accIdToCreditInfoMap.put(creditInfo.Account__c,new List<Credit_Information__c> {creditInfo});
            }
        }
        
        system.debug(Logginglevel.INFO,'+++accIdToCreditInfoMap+++'+accIdToCreditInfoMap);
        
        //Comparing the Case AccountId,Credit Control Area to Credit_Information__c record & getting the Credit_Limit__c.
        for(Case caseRecord : creditLimitList){
            
            system.debug(Logginglevel.INFO,'++caseRecord0+++'+caseRecord);
            
            if(accIdToCreditInfoMap.containsKey(caseRecord.AccountId)){
                
                system.debug(Logginglevel.INFO,'++caseRecord1+++'+caseRecord);
                
                for(Credit_Information__c creditRec: accIdToCreditInfoMap.get(caseRecord.AccountId) ){
                    
                    if(caseRecord.Credit_control_area__c == creditRec.Credit_Control_Area__c){
                        caseRecord.Existing_Credit_Limit__c = creditRec.Credit_Limit__c;
                        system.debug(Logginglevel.INFO,'++caseRecord5+++'+caseRecord);
                    }
                    
                }
                
            }
        }
    }
    
    // 6. Updates the correct country field based on an account relation
    public static void updateCountryField(list<case> casesToUpdate, map<id,case> casesOldMap){
        list<id> accountId = new list<id>();
        // first fetches all the account Ids
        for(Case c : casesToUpdate){        
            if(c.Compensation_Receiver__c != null && (casesOldMap == null || c.Compensation_Receiver__c != casesOldMap.get(c.id).Compensation_Receiver__c)){
                accountId.add(c.Compensation_Receiver__c);
            }
            if(c.Accountid != null && (casesOldMap == null || c.Accountid != casesOldMap.get(c.id).Accountid)){
                accountId.add(c.Accountid);
            }
            if(c.Receiver__c != null && (casesOldMap == null || c.Receiver__c != casesOldMap.get(c.id).Receiver__c)){
                accountId.add(c.Receiver__c);
            }
            if(c.Regress_partner__c != null &&(casesOldMap == null || c.Regress_partner__c != casesOldMap.get(c.id).Regress_partner__c)){
                accountId.add(c.Regress_partner__c);
            }
            if(c.Sender__c != null && (casesOldMap == null || c.Sender__c != casesOldMap.get(c.id).Sender__c)){
                accountId.add(c.Sender__c);
            }
        }
        map<id,Account> accountMap = new map<id,Account>([select id, Postal_Address_Country__c from Account Where id IN :accountId]);

        // Updates relevant fields
        for(Case c : casesToUpdate){ 
            if(c.Compensation_Receiver__c == null){
                c.Comp_Receiver_Country__c = null;
            }else if((casesOldMap == null) || c.Compensation_Receiver__c != casesOldMap.get(c.id).Compensation_Receiver__c){
                c.Comp_Receiver_Country__c = accountMap.get(c.Compensation_Receiver__c).Postal_Address_Country__c;
            }
            if(c.Accountid == null){
                c.Postal_Address_Country__c = null;
            }else if((casesOldMap == null) || c.Accountid != casesOldMap.get(c.id).Accountid){
                c.Postal_Address_Country__c = accountMap.get(c.accountid).Postal_Address_Country__c;
            }
            if(c.Receiver__c == null){
                c.Receiver_Postal_Address_Country__c = null;
            }else if((casesOldMap == null) || c.Receiver__c != casesOldMap.get(c.id).Receiver__c){
                c.Receiver_Postal_Address_Country__c = accountMap.get(c.Receiver__c).Postal_Address_Country__c;
            }
            if(c.Regress_partner__c == null){
                c.Regress_Partner_Country__c = null;
            }else if((casesOldMap == null) || c.Regress_partner__c != casesOldMap.get(c.id).Regress_partner__c){
                c.Regress_Partner_Country__c = accountMap.get(c.Regress_partner__c).Postal_Address_Country__c;
            }
            if(c.Sender__c == null){
                c.Sender_Postal_Address_Country__c = null;
            }else if((casesOldMap == null) || c.Sender__c != casesOldMap.get(c.id).Sender__c){
                c.Sender_Postal_Address_Country__c = accountMap.get(c.Sender__c).Postal_Address_Country__c;
            }
        }       
    }
    
    // 7. Updates the status field on related opportunity for Admin Activity Cases
    public static void updateOppStatus(list<case> adminActivityCaseList){
        Map<id,Case> casesByOppId = new Map<id,Case>();
        for(Case adminActivityCase : adminActivityCaseList) {
        casesByOppId.put(adminActivityCase.Opportunity__c,adminActivityCase);
        }
        
        Opportunity[] opps = [Select o.Id, o.Admin_Activity_Status__c from Opportunity o where o.Id in :casesByOppId.keySet()];
        for(Opportunity opp : opps){
            opp.Admin_Activity_Status__c = casesByOppId.get(opp.id).Status;
        }
        
        Database.SaveResult[] srList = Database.update(opps,false);
        for (integer i=0; i<srList.size(); i++) {
            Database.SaveResult sr = srList[i];
            if (!sr.isSuccess()){
                casesByOppId.get(opps[i].id).addError(Label.Opp_Status_Update_Error);
            }
        }
    }
    
    //To update the Parent case as ISparent check box to false
   Public static void autoCloseParentCase(List<Case> allcase){
           Set<Id> parentCaseIds = new Set<Id>();
           List<Case> parentCasesToUpdate = new List<Case>();
    
           try{
               for (Case c:allcase) {
                    if (c.ParentId!=null) {
                        parentCaseIds.add(c.ParentId);
                    }
                }
            
                if(parentCaseIds.size()>0) {
                       List<Case> parentCases = [Select Id, ISParent__c, (Select id From Cases) From Case Where Id in :parentCaseIds];                     
                       for(Case hold : parentCases ){
                           childCount = hold.cases.size();
                           if(childCount==0){
                               hold.ISParent__c=false;
                               parentCasesToUpdate.add(hold);
                           }
                        }
                 }
            }  
            catch(Exception e){
                    system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e); 
            }
          
            // bulk update
           if (parentCasesToUpdate.size()>0) {
                   
                update parentCasesToUpdate;
            }     
    }
    //To update the Parent case as ISparent check box to true
    Public static void autoInsertCase(List<Case> allcase){
        Set<Id> parentCaseIds = new Set<Id>(); 
        List<Case> parentCasesToUpdate = new List<Case>();
        
        
        
        try{
                for (Case c:allcase) {
                    if (c.ParentId!=null) {
                        parentCaseIds.add(c.ParentId);
                    }
                }
                
                if (parentCaseIds.size()>0) {
                    List<Case> parentCases = [Select Id, ISParent__c, 
                                                (Select id From Cases) 
                                                From Case
                                                Where Id in :parentCaseIds];                                                         
                        for(Case hold : parentcases){
                            hold.ISParent__c=true;
                            parentCasesToUpdate.add(hold);
                        }
                   
                 }
                // bulk update
                if (parentCasesToUpdate.size()>0) {
                    update parentCasesToUpdate;
                } 
            }
            catch(Exception e){
              system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e); 
            }                              
      }
      Public static void updateOpportunityApprovalStatusDateFields(List<Case> caseList){
         
          System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<updateOpportunityApprovalStatusDateFields>');
          for(Case c:caseList)
          {
              
               if(!UTIL_Apex.empty(c.Opportunity_Approval_Status__c)){
                   if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Created)){
                        c.Opp_Aprvl_Status_Created_Date__c=DateTime.now();
                   }
                   else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Pending_Sales)){
                        c.Opp_Aprvl_Status_Pending_Sales_Date__c=DateTime.now();
                   }
                    else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_In_Progress)){
                        c.Opp_Aprvl_Status_In_Progress_Date__c=DateTime.now();
                   }
                    else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Not_Started)){
                        c.Opp_Aprvl_Status_Not_Started_Date__c=DateTime.now();
                   }
                    else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Pending_Operations)){
                        c.Opp_Aprvl_Status_Pending_Operations_Date__c=DateTime.now();
                   }
                    else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Pending_Price)){
                        c.Opp_Aprvl_Status_Pending_Price_Date__c=DateTime.now();
                   }
                    else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Rejected)){
                        c.Opp_Aprvl_Status_Rejected_Date__c=DateTime.now();
                   }
                   else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Approved)){
                        c.Opp_Aprvl_Status_Approved_Date__c=DateTime.now();
                   }
                    else if(c.Opportunity_Approval_Status__c.equalsIgnoreCase(System.Label.Opp_Approval_Status_Operation_inquiry)){
                        c.Opp_Aprvl_Status_Operation_Inquiry_Date__c=DateTime.now();
                   }
               }
            
               
          }
              System.debug(LoggingLevel.info,'*** END: <Case_SVC>.<updateOpportunityApprovalStatusDateFields>');
      }
      
      Public static void updateCaseStatusDateFields(List<Case> caseList){
         
          System.debug(LoggingLevel.info,'*** START: <Case_TimeSpan>.<updateCaseStatusDateFields>');
          for(Case c:caseList)
          {              
               if(!UTIL_Apex.empty(c.Status)){                                     
                   if(c.Status.equalsIgnoreCase(System.Label.Case_Status_Assigned_to_Queue)){
                        c.Case_Status_Assigned_to_Queue_Date__c=DateTime.now();
                   }                   
                    else if(c.Status.equalsIgnoreCase(System.Label.Case_Status_In_Progress)){
                        c.Case_Status_In_Progress_Date__c=DateTime.now();
                   }
                    else if(c.Status.equalsIgnoreCase(System.Label.Case_Status_Waiting_for_Info)){
                        c.Case_Status_Waiting_for_Info_Date__c=DateTime.now();
                   }
                   else if(c.Status.equalsIgnoreCase(System.Label.Case_Status_Cancelled)){
                        c.Case_Status_Cancelled_Date__c=DateTime.now();
                   }
               }            
               
          }
              System.debug(LoggingLevel.info,'*** END: <Case_TimeSpan>.<updateCaseStatusDateFields>');
      } 
      
      Public static void createNewOperationCaseAndSubmit(List<Case> caseListToClone){
          
             System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<createNewOperationCaseAndSubmit>');
             List<Case> caseListToInsert=new List<Case>();
             Map<Case,Case> caseMap=new Map<Case,Case>();
             for(Case caseToClone:caseListToClone){
                 Case newOperationCase = new Case(AccountId=caseToClone.AccountId,
                                                  RecordTypeId=caseToClone.RecordTypeId,
                                                  Opportunity__c=caseToClone.Opportunity__c,
                                                  Requested_date_to_be_Approved__c=caseToClone.Requested_date_to_be_Approved__c,
                                                  Expected_date_to_be_Approved__c=caseToClone.Expected_date_to_be_Approved__c,
                                                  Notes_to_approver__c=caseToClone.Notes_to_approver__c,
                                                  Complex__c=caseToClone.Complex__c,
                                                  Opportunity_Approval_Status__c=System.label.Opp_Approval_Status_Created,
                                                  Opportunity_Approval_Type__c=System.Label.Admin_Case_Type_Operations);
                 caseMap.put(caseToClone,newOperationCase);
             }
             if(!caseMap.isEmpty()){                   
                    Database.SaveResult[] insertResults= Database.insert(caseMap.values(),false);
                    List<Approval.ProcessSubmitRequest> approvalProcessSubmitRequestList=new List<Approval.ProcessSubmitRequest>();
                    for(Database.SaveResult insert_Result : insertResults){
                        if(insert_Result.isSuccess()){
                             Approval.ProcessSubmitRequest newAPSR = new Approval.ProcessSubmitRequest();
                             newAPSR.setObjectId(insert_Result.getId());
                             approvalProcessSubmitRequestList.add(newAPSR);
                        }
                    }
                    for(Case c:caseMap.keySet()){
                       if(caseMap.get(c).Id == null){
                            c.addError(System.label.Operation_Case_Insert_Error);
                       }
                    }
                    if(!approvalProcessSubmitRequestList.isEmpty()){
                         List<Approval.ProcessResult> approvalResults = Approval.process(approvalProcessSubmitRequestList,false);                        
                         for(Approval.ProcessResult approval_Result : approvalResults){
                            if (!approval_Result.isSuccess()){
                                System.debug('\n\nERROR r: '+approval_Result.errors[0].message+'\n\n');
                            }
                         }                     
                    }
             }
      System.debug(LoggingLevel.info,'*** END: <Case_SVC>.<createNewOperationCaseAndSubmit>');                
      }
      Public static void updateDependentFieldsOnOpportunity(List<Case> CaseList,Boolean isCaseUpdate){
          System.debug(LoggingLevel.info,'*** START: <Case_SVC>.<updateDependentFieldsOnOpportunity>');
          Map<Id,Case> opportunityBothCasesMap=new Map<Id,Case>();
          Map<Id,Case> opportunityPriceGroupCasesMap=new Map<Id,Case>();
          Map<Id,Case> opportunityOperationCasesMap=new Map<Id,Case>();
          Set<Id> opportunityIds=new Set<Id>();
          List<Opportunity> opportunitiesToUpdate=new List<Opportunity>();
          Set<Id> insertedOrUpdatedcaseIds=new Set<Id>();
          for(Case c:CaseList){
              opportunityIds.add(c.Opportunity__c);
              insertedOrUpdatedcaseIds.add(c.Id);
          }
          String opportunityApprovalLabel=System.Label.Admin_Case_Type_Opportunity_Approval;
          if(isCaseUpdate && (!opportunityIds.isEmpty())){
              for(Case c:[select Id,Opportunity__c,CreatedDate,Opportunity_Approval_Status__c,Expected_date_to_be_approved__c,Opportunity_Approval_Type__c,Admin_case_type__c from Case where Opportunity__c IN:opportunityIds and Admin_case_type__c =:opportunityApprovalLabel]){
                  CaseList.add(c);
              }
          }
          for(Case c:CaseList){
              //opportunityIds.add(c.Opportunity__c);
              if(!UTIL_Apex.empty(c.Opportunity_Approval_Type__c)){
                  if(c.Opportunity_Approval_Type__c.equalsIgnoreCase(System.Label.Admin_Case_Type_Both)){
                     if(opportunityBothCasesMap.containsKey(c.Opportunity__c)){
                         if(opportunityBothCasesMap.get(c.Opportunity__c).CreatedDate < c.CreatedDate){
                              opportunityBothCasesMap.remove(c.Opportunity__c);
                              opportunityBothCasesMap.put(c.Opportunity__c,c);
                         }
                     }
                     else{
                        opportunityBothCasesMap.put(c.Opportunity__c,c);
                     }
                  }
                  else if(c.Opportunity_Approval_Type__c.equalsIgnoreCase(System.Label.Admin_Case_Type_Price_group)){
                     if(opportunityPriceGroupCasesMap.containsKey(c.Opportunity__c)){
                         if(opportunityPriceGroupCasesMap.get(c.Opportunity__c).CreatedDate < c.CreatedDate){
                              opportunityPriceGroupCasesMap.remove(c.Opportunity__c);
                              opportunityPriceGroupCasesMap.put(c.Opportunity__c,c);
                         }
                     }
                     else{
                        opportunityPriceGroupCasesMap.put(c.Opportunity__c,c);
                     }
                  }
                  else if(c.Opportunity_Approval_Type__c.equalsIgnoreCase(System.Label.Admin_Case_Type_Operations)){
                     if(opportunityOperationCasesMap.containsKey(c.Opportunity__c)){
                         if(opportunityOperationCasesMap.get(c.Opportunity__c).CreatedDate < c.CreatedDate){
                              opportunityOperationCasesMap.remove(c.Opportunity__c);
                              opportunityOperationCasesMap.put(c.Opportunity__c,c);
                         }
                     }
                     else{
                        opportunityOperationCasesMap.put(c.Opportunity__c,c);
                     }
                  }
              }
          }//end of for
          if(!opportunityIds.isEmpty()){
             for(Opportunity opp:[Select id,Operations_Status__c,PriceGroup_Status__c,Expected_Price_Group_Approval_Date__c,Expected_Operation_Group_Approval_Date__c from Opportunity where id IN:opportunityIds]){
                Boolean hasToUpdateThisOpportunity=false;
                //price group
                if(opportunityBothCasesMap.containsKey(opp.Id)){
                    if(opportunityPriceGroupCasesMap.containsKey(opp.Id)){
                         if(opportunityPriceGroupCasesMap.get(opp.Id).CreatedDate < opportunityBothCasesMap.get(opp.Id).CreatedDate){
                             //both
                             if(insertedOrUpdatedcaseIds.contains(opportunityBothCasesMap.get(opp.Id).Id)){
                                 opp.Expected_Price_Group_Approval_Date__c=opportunityBothCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                                 opp.PriceGroup_Status__c=opportunityBothCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                                 hasToUpdateThisOpportunity=true;
                             }
                         }
                         else{
                           //price group
                           if(insertedOrUpdatedcaseIds.contains(opportunityPriceGroupCasesMap.get(opp.Id).Id)){
                                 opp.Expected_Price_Group_Approval_Date__c=opportunityPriceGroupCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                                 opp.PriceGroup_Status__c=opportunityPriceGroupCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                                 hasToUpdateThisOpportunity=true;
                            }
                         }
                    }
                    else{
                         //both
                         if(insertedOrUpdatedcaseIds.contains(opportunityBothCasesMap.get(opp.Id).Id)){
                             opp.Expected_Price_Group_Approval_Date__c=opportunityBothCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                             opp.PriceGroup_Status__c=opportunityBothCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                             hasToUpdateThisOpportunity=true;
                         }                        
                    }
                }
                else if(opportunityPriceGroupCasesMap.containsKey(opp.Id)){
                       //price group
                       if(insertedOrUpdatedcaseIds.contains(opportunityPriceGroupCasesMap.get(opp.Id).Id)){
                             opp.Expected_Price_Group_Approval_Date__c=opportunityPriceGroupCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                             opp.PriceGroup_Status__c=opportunityPriceGroupCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                             hasToUpdateThisOpportunity=true;
                        }
                }
                //Operations
                if(opportunityBothCasesMap.containsKey(opp.Id)){
                    if(opportunityOperationCasesMap.containsKey(opp.Id)){
                        if(opportunityOperationCasesMap.get(opp.Id).CreatedDate < opportunityBothCasesMap.get(opp.Id).CreatedDate){
                             //both
                             if(insertedOrUpdatedcaseIds.contains(opportunityBothCasesMap.get(opp.Id).Id)){
                                 opp.Expected_Operation_Group_Approval_Date__c=opportunityBothCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                                 opp.Operations_Status__c=opportunityBothCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                                 hasToUpdateThisOpportunity=true;
                             }
                         }
                         else{
                             //Operations
                             if(insertedOrUpdatedcaseIds.contains(opportunityOperationCasesMap.get(opp.Id).Id)){
                                 opp.Expected_Operation_Group_Approval_Date__c=opportunityOperationCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                                 opp.Operations_Status__c=opportunityOperationCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                                 hasToUpdateThisOpportunity=true;
                             }
                         }
                    }
                    else{
                         //Both
                         if(insertedOrUpdatedcaseIds.contains(opportunityBothCasesMap.get(opp.Id).Id)){
                             opp.Expected_Operation_Group_Approval_Date__c=opportunityBothCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                             opp.Operations_Status__c=opportunityBothCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                             hasToUpdateThisOpportunity=true;
                         }
                    }
                }
                else if(opportunityOperationCasesMap.containsKey(opp.Id)){
                     //Operations
                     if(insertedOrUpdatedcaseIds.contains(opportunityOperationCasesMap.get(opp.Id).Id)){
                         opp.Expected_Operation_Group_Approval_Date__c=opportunityOperationCasesMap.get(opp.Id).Expected_date_to_be_approved__c;
                         opp.Operations_Status__c=opportunityOperationCasesMap.get(opp.Id).Opportunity_Approval_Status__c;
                         hasToUpdateThisOpportunity=true;
                     }
                }
                if(hasToUpdateThisOpportunity){
                    opportunitiesToUpdate.add(opp);
                }
             }//end for opp query
          } //end if oppids.is not empty 
          if(!opportunitiesToUpdate.isEmpty()){
               Database.SaveResult[] results= Database.update(opportunitiesToUpdate,false);
               for(Database.SaveResult save_Result : results){
                    if (!save_Result.isSuccess()){
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,save_Result.errors[0].message));
                        System.debug('\n\nERROR r: '+save_Result.errors[0].message+'\n\n');
                    }
               }
          }
        System.debug(LoggingLevel.info,'*** END: <Case_SVC>.<updateDependentFieldsOnOpportunity>');
      }            
}