/**
    About
    -----
    Description: After Insert Trigger on Case
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  This inserts new CaseProduct record for a case of 'Complaint','Customer Feedback'or 'Customer Assignment' recordtypes if product/article or itemid is populated for the first time.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated July  2013 - A.B. - Refactored
    Updated August 2013 - C.H.F. - Cleaned up
    Updated November 2014 Karthik K.J - Refactored
    Issues / TODOs
    --------------  
*/
trigger Case_AfterInsert on Case (after insert) {
    
    Case[] createCaseProduct = new Case[]{};
    Case[] allNewCase = new Case[]{};

    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        
        // Creating Lists and Maps based on filter criteria 
        for (Case c : trigger.new){           
            // Filter 1
            if((c.Product_Article__c!=null) || (c.Item_Id__c!=null && c.Item_Id__c!='') ){
                createCaseProduct.add(c);
            }
    
        }
        
        // Exectue logic in a service class
        
        // Filter 1       
        if (createCaseProduct.size() > 0) {  
            G2O_Case_SVC.createCaseProductAfterInsert(createCaseProduct);       
        }
        //Call to service call to check for child case
        List<Case> opportunityCaseList=new List<Case>();
        String approvalAdminActivityRecType = UTIL_Meta.getcaseApprovalAdminActivityRT();   
        for(Case c : Trigger.new){
           if(c.ParentId != Null){  
               allNewCase.add(c);
           }
           if((approvalAdminActivityRecType != null) && (c.RecordTypeId == approvalAdminActivityRecType)){
                 
               if((c.Opportunity__c !=null) && (c.Admin_case_type__c!=null) && (c.Admin_case_type__c.equalsIgnoreCase(System.Label.Admin_Case_Type_Opportunity_Approval))){
                   opportunityCaseList.add(c);
               }
           }
        }
        if(allNewCase != NULL){
            G2O_Case_SVC.autoInsertCase(allNewCase);
        }
        if(!opportunityCaseList.isEmpty()){
            G2O_Case_SVC.updateDependentFieldsOnOpportunity(opportunityCaseList,Trigger.isUpdate);
        }
    }
}