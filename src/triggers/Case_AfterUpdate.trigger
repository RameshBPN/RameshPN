/**
    About
    -----
    Description: After Update Trigger on Case
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1. Updates the primary caseProduct with product-article & ItemId field on caseproduct.
        2. This inserts new CaseProduct record for a case of 'Complaint','Customer Feedback'or 'Customer Assignment' recordtypes if product/article or itemid is populated for the first time.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated July  2013 - A.B.-Refactored
    Updated August 2013 - C.H.F. - Cleaned up
    Updated November 2014 Karthik K.J-Refactored
    Updated June 2015 - Madhav Kakani - Fluido Denmark - Placed code for the Contact Center project
    Issues / TODOs
    --------------  
*/
trigger Case_AfterUpdate on Case (after update) {
    
    Case[] setCaseProductArticle = new Case[]{};
    Case[] createCaseProduct = new Case[]{};
    Case[] allNewCase = new Case[]{};
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
            
        // Creating Lists and Maps based on filter criteria
        for (Case c : trigger.new){
                
            //Filter 1
            if((c.Product_Article__c!=trigger.oldMap.get(c.Id).Product_Article__c)|| (c.Item_Id__c!=trigger.oldMap.get(c.Id).Item_Id__c)){
                setCaseProductArticle.add(c);
            }
                
            //Filter 2
            if(((c.Product_Article__c!=null && trigger.oldMap.get(c.Id).Product_Article__c==null && trigger.oldMap.get(c.Id).Item_Id__c==null ) 
                || (c.Item_Id__c!=null && trigger.oldMap.get(c.Id).Item_Id__c==null && trigger.oldMap.get(c.Id).Product_Article__c==null ))){
                createCaseProduct.add(c);
            }
        }
        
        // Exectue logic in a service class
             
        // Follow the below order of execution,else functionality won't work (Filter 1 & 2).   
            
        // Filter 1
        if (setCaseProductArticle.size() > 0) {  
            G2O_Case_SVC.setCaseProductArticleAfterUpdate(setCaseProductArticle);
        }
        
        // Filter 2 
        if (createCaseProduct.size() > 0) {  
            G2O_Case_SVC.createCaseProductAfterUpdate(createCaseProduct);
        }
    
       //Call service class to check child case 
        for(Case c : Trigger.old){
            if(c.ParentId != Null)  
               allNewCase.add(c);
        }
        G2O_Case_SVC.autoCloseParentCase(allNewCase);
        
         //clone and approval test 
        List<Case> opportunityCaseList=new List<Case>();
        List<Case> caseListToClone=new List<Case>();
        String approvalAdminActivityRecType = UTIL_Meta.getcaseApprovalAdminActivityRT();   
        for(Case c : Trigger.new){   
               if((approvalAdminActivityRecType != null) && (c.RecordTypeId == approvalAdminActivityRecType)){                    
                       if((!Trigger.oldMap.get(c.Id).Clone_case__c) && c.Clone_case__c){                
                          caseListToClone.add(c);
                       }
                       if((c.Opportunity__c !=null)&& (c.Admin_case_type__c!=null) && (c.Admin_case_type__c.equalsIgnoreCase(System.Label.Admin_Case_Type_Opportunity_Approval))){
                          if((Trigger.oldMap.get(c.Id).Expected_date_to_be_approved__c!=c.Expected_date_to_be_approved__c)
                            ||(Trigger.oldMap.get(c.Id).Opportunity_Approval_Status__c!=c.Opportunity_Approval_Status__c)
                            ||(Trigger.oldMap.get(c.Id).Opportunity_Approval_Type__c!=c.Opportunity_Approval_Type__c)){
                              opportunityCaseList.add(c);
                          }
                       }                     
               }
        }
        if(!caseListToClone.isEmpty()){
            G2O_Case_SVC.createNewOperationCaseAndSubmit(caseListToClone);
        }
        if(!opportunityCaseList.isEmpty()){
              G2O_Case_SVC.updateDependentFieldsOnOpportunity(opportunityCaseList,Trigger.isUpdate);
        }

        // START: Contact Center Project - Fluido Denmark
        if(System.isBatch() || System.isScheduled()) return; 
        for(Case c : Trigger.new) {
            if(c.IsClosed && !UTIL_Apex.empty(c.CC_Item_Id__c) && c.CC_Queue_Status__c==Label.Case_Enqueued) {
                UTIL_Apex.DeQueueCase(c.Id, c.CC_Item_Id__c); // call the future method
            }
        }
        // END: Contact Center Project - Fluido Denmark
    }
}