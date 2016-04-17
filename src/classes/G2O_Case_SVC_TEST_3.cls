@isTest
private class G2O_Case_SVC_TEST_3 {

  static testMethod void updateOpportunityApprovalStatusDateFieldsTest(){
        //Set up
        UTIL_TestFactory.setUpOrg();        
        Opportunity[] opps = new Opportunity[]{};                
       // Create one account and a set of opps owned by the system
        Account acct = UTIL_TestFactory.createAccount();
        acct.recordTypeId = UTIL_Meta.getAccountWorksiteRT();
        Database.SaveResult accSR=Database.insert(acct,false);  
        if(accSR.isSuccess()){
             Opportunity testOpp = UTIL_TestFactory.createOpportunity(acct);      
             Database.SaveResult oppSR=Database.insert(testOpp,false);
             if(oppSR.isSuccess()){
                List<Case> caseListToInsert=new List<Case>();
                String adminRecType=System.Label.Opportunity_Approval_RecordType;
                RecordType rt=[Select r.Name, r.Id, r.DeveloperName From RecordType r where  r.DeveloperName =:adminRecType AND r.SobjectType ='Case' limit 1];                
                Case c1 = UTIL_TestFactory.createCase();
                c1.Opportunity__c = testOpp.Id;           
                c1.Admin_case_type__c = System.Label.Admin_Case_Type_Operations;         
                c1.Opportunity_Approval_Status__c = System.Label.Opp_Approval_Status_Created;
                c1.Expected_date_to_be_approved__c = date.today();  
                c1.Requested_date_to_be_Approved__c = date.today();                
                c1.Opportunity_Approval_Type__c = System.Label.Admin_Case_Type_Both;   
                c1.RecordTypeId = rt.Id;                
                caseListToInsert.add(c1);
                
                
                Case c2 = c1.clone();
                c2.Opportunity_Approval_Type__c = System.Label.Admin_Case_Type_Operations; 
                caseListToInsert.add(c2);  
                
                Case c3 = c1.clone();
                c2.Opportunity_Approval_Type__c = System.Label.Admin_Case_Type_Price_group; 
                caseListToInsert.add(c3);
                System.assertEquals(System.Label.Admin_Case_Type_Price_group, c2.Opportunity_Approval_Type__c);
                Database.SaveResult[] caseSRList=Database.insert(caseListToInsert,false);
                if(caseSRList[0].isSuccess()){
                     Case c=caseListToInsert[0];
                     c.Opportunity_Approval_Type__c =System.Label.Admin_Case_Type_Price_group; 
                     c.Clone_case__c=true;
                     update c;
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_In_Progress;
                     update c;
                     System.assertEquals(System.Label.Opp_Approval_Status_In_Progress, c.Opportunity_Approval_Status__c);
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_Pending_Operations;
                     update c;
                     System.assertEquals(System.Label.Opp_Approval_Status_Pending_Operations, c.Opportunity_Approval_Status__c); 
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_Pending_Price;
                     update c;
                     System.assertEquals(System.Label.Opp_Approval_Status_Pending_Price, c.Opportunity_Approval_Status__c); 
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_Rejected;
                     update c;
                     System.assertEquals(System.Label.Opp_Approval_Status_Rejected, c.Opportunity_Approval_Status__c); 
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_Approved;
                     update c;
                     System.assertEquals(System.Label.Opp_Approval_Status_Approved, c.Opportunity_Approval_Status__c);                    
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_Not_Started;
                     update c; 
                     System.assertEquals(System.Label.Opp_Approval_Status_Not_Started, c.Opportunity_Approval_Status__c); 
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_Operation_inquiry;
                     update c;
                     System.assertEquals(System.Label.Opp_Approval_Status_Operation_inquiry, c.Opportunity_Approval_Status__c); 
                     c.Opportunity_Approval_Status__c=System.Label.Opp_Approval_Status_Pending_Sales;
                     update c;                    
                     System.assertEquals(System.Label.Opp_Approval_Status_Pending_Sales, c.Opportunity_Approval_Status__c);
                }
             }
         }    

    }
    
      static testMethod void updateCaseStatusDateFieldsTest(){
        //Set up
        UTIL_TestFactory.setUpOrg();        
        String caseStatusCreated = 'Created';
        String caseStatusFinal = 'Closed';                
       // Create one account and a set of opps owned by the system
        Account acct = UTIL_TestFactory.createAccount();
        acct.recordTypeId = UTIL_Meta.getAccountWorksiteRT();
        Database.SaveResult accSR=Database.insert(acct,false);  
        if(accSR.isSuccess()){
             Opportunity testOpp = UTIL_TestFactory.createOpportunity(acct);      
             Database.SaveResult oppSR=Database.insert(testOpp,false);
             if(oppSR.isSuccess()){
                List<Case> caseListToInsert=new List<Case>();
                String DKAdminCaseRecType = UTIL_Meta.getDKAdminCaseRT();                           
                Case c = UTIL_TestFactory.createCase();                 
                c.RecordtypeId=DKAdminCaseRecType;
                c.Status = caseStatusCreated;
                c.Opportunity__c = testOpp.Id;            
                caseListToInsert.add(c);
                insert c;
                for(Case ca:caseListToInsert){
                     ca.Status=System.Label.Case_Status_Assigned_to_Queue;
                     }
                     update caseListToInsert;
                for(Case ca:caseListToInsert){
                     ca.Status=System.Label.Case_Status_In_Progress;
                     }
                     update caseListToInsert;
                for(Case ca:caseListToInsert){
                     ca.Status=System.Label.Case_Status_Waiting_for_Info;
                     }
                     update caseListToInsert;
                 for(Case ca:caseListToInsert){
                     ca.Status=System.Label.Case_Status_Cancelled;
                     }
                     update caseListToInsert;
                 for(Case ca:caseListToInsert){
                     ca.Status=caseStatusFinal;
                     }
                     update caseListToInsert;      
             }
         }    

    }       
}