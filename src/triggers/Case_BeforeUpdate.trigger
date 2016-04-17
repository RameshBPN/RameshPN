/**
    About
    -----
    Description: Before Update Trigger on Case
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  Structured communication - create/update a functional inbox (fake contact) for an account on cases where responded org id is set / updated and Main case = false
        2.
        3. All cases that have a related opportunity and the status has changed. Calls method to update status field on opportunity from Case Status field

    Update History
    --------------
    Created April 2013 - A.B.
    Updated June  2013 - A.B. - Setting of Case_Owner__c is no longer required, removed as requirement is satisfied by SFDC out of the box functionality.
    Updated August 2013 - C.H.F. - Cleaned up
    Updated August 2014 - A.C. - Add logic to copy status to a related opportunity. Only for cases of record type Admin Activity
    
    Issues / TODOs
    --------------  
*/

trigger Case_BeforeUpdate on Case (before update) {

    Case[] functionalInboxCases = new Case[]{};
    list<Case> countrySyncCaseList = new list<Case>();
    map<id,Case> countrySyncCaseOldMap = new map<id,Case>();
    list<Case> adminActivityCaseList = new list<Case>();
    List<Case> opportunityCaseList=new List<Case>();
    List<Case> caseList=new List<Case>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        String approvalAdminActivityRecType = UTIL_Meta.getcaseApprovalAdminActivityRT();   
        String DKAdminCaseRecType = UTIL_Meta.getDKAdminCaseRT();   
        // Creating Lists and Maps based on filter criteria
        for (Case c : trigger.new)
        {
            // Filter 1
            if (!c.Is_Main_Case__c && c.Respondent_Org_ID__c!=trigger.oldMap.get(c.Id).Respondent_Org_ID__c)
            {
                functionalInboxCases.add(c);
            }
            
            // Filter 2
            if(c.Compensation_Receiver__c != trigger.oldMap.get(c.id).Compensation_Receiver__c ||
            c.Accountid != trigger.oldMap.get(c.id).Accountid ||
            c.Receiver__c != trigger.oldMap.get(c.id).Receiver__c ||
            c.Regress_partner__c != trigger.oldMap.get(c.id).Regress_partner__c ||
            c.Sender__c != trigger.oldMap.get(c.id).Sender__c){
                countrySyncCaseList.add(c);
                countrySyncCaseOldMap.put(c.id, trigger.oldMap.get(c.id));
            }
            
            // Filter 3
            if(c.Opportunity__c != null && c.Status != trigger.oldmap.get(c.id).Status) {
               adminActivityCaseList.add(c);
            }
            //Filter 4           
            if((approvalAdminActivityRecType != null) && (c.RecordTypeId == approvalAdminActivityRecType)){                
                 opportunityCaseList.add(c);               
            } 
            //Filter 5
                
            if((DKAdminCaseRecType != null) && (c.RecordTypeId == DKAdminCaseRecType)){                
                 caseList.add(c);               
            }     
        }
        
        // Exectue logic in a service class
        
        // Filter1
        if (functionalInboxCases.size() > 0) {  
            G2O_Case_SVC.structuredComm_ManageFunctionalInboxes(functionalInboxCases);
        }
        // Filter 2
        if (countrySyncCaseList.size() > 0){
            G2O_Case_SVC.updateCountryField(countrySyncCaseList, countrySyncCaseOldMap);
        }
        // Filter 3
        if (adminActivityCaseList.size() > 0){
            G2O_Case_SVC.updateOppStatus(adminActivityCaseList);
        }
        //Filter4
        if(!opportunityCaseList.isEmpty()){
            G2O_Case_SVC.updateOpportunityApprovalStatusDateFields(opportunityCaseList);
        }

         //Filter 5
        if(!caseList.isEmpty()){
            G2O_Case_SVC.updateCaseStatusDateFields(caseList);
        }

        // Contact Center Project - Fluido Denmark
        UTIL_Apex.CC_CaseBeforeUpdateHandler(Trigger.new);
    }
}