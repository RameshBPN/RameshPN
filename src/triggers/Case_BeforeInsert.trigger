/**
    About
    -----
    Description: After Insert Trigger on Case
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2013
    
    Filters:
    -------
        1. Update credit limit on case of record type 'Credit Check' when AccountId & Credit_control_area__c are populated on case.
        2. Sync Postal country from related Accounts to Case
        3. All cases that have a related opportunity and the status has changed. Calls method to update status field on opportunity from Case Status field
        
    Update History
    --------------
    Created August 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    Updated August 2014 - A.C.
    
    Issues / TODOs
    --------------  
*/
trigger Case_BeforeInsert on Case (before insert) {

    List<Case> creditLimitCaseList = new List<Case>();
    list<Case> countrySyncCaseList = new list<Case>();
    list<Case> adminActivityCaseList = new list<Case>();
    List<Case> opportunityCaseList=new List<Case>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
    
        String approvalAdminActivityRecType = UTIL_Meta.getcaseApprovalAdminActivityRT();        
        String rType = UTIL_Meta.getcaseCreditCheckRT();        
        
        // Creating Lists and Maps based on filter criteria
        for (Case cas : trigger.new) {
            
            // Filter 1 
            if(cas.RecordTypeId == rType && !UTIL_Apex.empty(cas.AccountId) && !UTIL_Apex.empty(cas.Credit_control_area__c) ){
                creditLimitCaseList.add(cas);
            }
            
            // Filter 2
            if(cas.Compensation_Receiver__c != null ||
            cas.Accountid != null ||
            cas.Receiver__c != null ||
            cas.Regress_partner__c != null ||
            cas.Sender__c != null){
                countrySyncCaseList.add(cas);
            }
            
            // Filter 3
            if(cas.Opportunity__c != null) {
               adminActivityCaseList.add(cas);
            }
            //Filter 4           
            if((approvalAdminActivityRecType != null) && (cas.RecordTypeId == approvalAdminActivityRecType)){                 
                  opportunityCaseList.add(cas);                
            }
        }
        
        // Execute logic in a service class
        
        // Filter 1
        if (creditLimitCaseList.size() > 0) {  
            G2O_Case_SVC.updateCreditLimit(creditLimitCaseList);
        }
        // Filter 2
        if (countrySyncCaseList.size() > 0){
            G2O_Case_SVC.updateCountryField(countrySyncCaseList, null);
        }
        // Filter 3
        if (adminActivityCaseList.size() > 0){
            G2O_Case_SVC.updateOppStatus(adminActivityCaseList);
        }
        //Filter4
        if(!opportunityCaseList.isEmpty()){
            G2O_Case_SVC.updateOpportunityApprovalStatusDateFields(opportunityCaseList);
        }
    }
}