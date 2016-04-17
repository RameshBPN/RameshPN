/**
    About
    -----
    Description: This class is used to test G2O_Case_SVC (part 2 of 2)
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class is Part 2 to test the functionality of G2O_Case_SVC class.
    1. Test updating of the Status field on the related Opportunity for Admin Activity Cases.

    Update History
    --------------
    Created August 2014 - A.C.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Case_SVC_TEST_2 {
    
    //1. Test updating of the Status field on the related Opportunity for Admin Activity Cases.
    static testMethod void updateOppStatusTest(){
        //Set up
        Integer numberOfRecords = 201;
        String caseStatusStart = 'Not Started';
        String caseStatusFinal = 'SAP updated';
        
        UTIL_TestFactory.setUpOrg();
        
        /*
        // Get a sales user with the appropriate access levels for the work 
        User salesUser = UTIL_TestFactory.createSalesUser('testUser1@cg.com');
        salesUser.Sales_Area1__c = '4000';
        salesUser.UserRole = UTIL_TestFactory.getRoleId_HighestDanishSalesRole();
        insert salesUser;
        
        //Creating Opportunity
        Opportunity[] opps = new Opportunity[]{};
            
        // Create one account and a set of opps owned by the system
        Account acct = UTIL_TestFactory.createAccount();
        acct.recordTypeId = UTIL_Meta.getAccountWorksiteRT();
        insert acct;
        
        for (integer i=0; i<numberOfRecords; i++)
        {
            Opportunity testOpp1 = UTIL_TestFactory.createOpportunity(acct);
            opps.add(testOpp1);
        }
        insert opps;
        
        //Creating Case
        Case[] cases = new Case[]{};
        for (integer i =0; i<numberOfRecords; i++)
        {
            Case c = UTIL_TestFactory.createCase();
            c.Status = caseStatusStart;
            c.Opportunity__c = opps[i].Id;
            cases.add(c);
        }
        insert cases;
        
        // Set the case with new status which will fire the trigger on update
        for (integer i =0; i<numberOfRecords; i++)
        {
            Case c = cases[i];
            c.Status = caseStatusFinal;
        }
        
        Test.startTest();
        // Try the update
        // But WITHOUT the user on the opportunity team. This should fail.
        try
        {
            system.runAs(salesUser) {
                update cases;
            }
            System.assert(false, 'User who is not the owner or on the opp team should not have been able to update the opportunity via the case status');
        } catch (Exception e) {
            // This should fail as the user is not part of the opp team or the opp owner, so continue.
        }
        
        // Add user to an opp team for each opp
        OpportunityTeamMember[] otms = new OpportunityTeamMember[]{};
        for (integer i =0; i<numberOfRecords; i++)
        {
            OpportunityTeamMember otm = UTIL_TestFactory.createOpportunityTeamMember();
            otm.OpportunityId = opps[i].Id;
            otm.UserId = salesUser.Id;
            otms.add(otm);
        }
        insert otms;
        
        // get all of the team members' sharing records
        List<OpportunityShare> shares = [select Id, OpportunityAccessLevel,  
          RowCause from OpportunityShare where OpportunityId IN :opps 
          and RowCause = 'Team'];
        
        // set all team members access to read/write
        for (OpportunityShare share : shares)  
          share.OpportunityAccessLevel = 'Edit';
        
        update shares;  
                
        // Update the case with new status to fire the trigger
        // This time the user should be on the respective opportunity teams and should succeed
        system.runAs(salesUser) {
            update cases;
        }
        Test.stopTest();
        */
        
        /* START OF WORK AROUND
         * USING ADMIN INSTEAD OF SALES USER: CODE ABOVE SHOULD BE CORRECTED AND REPLACE THIS SECTION
         **/
            // Get a sales user with the appropriate access levels for the work 
            User adminUser = UTIL_TestFactory.createAdmin('testUser1@cg.com');
            adminUser.Sales_Area1__c = '4000';
            insert adminUser;
            
            //Creating Opportunity
            Opportunity[] opps = new Opportunity[]{};
                
            // Create one account and a set of opps owned by the system
            Account acct = UTIL_TestFactory.createAccount();
            acct.recordTypeId = UTIL_Meta.getAccountWorksiteRT();
            insert acct;
            
            for (integer i=0; i<numberOfRecords; i++)
            {
                Opportunity testOpp1 = UTIL_TestFactory.createOpportunity(acct);
                opps.add(testOpp1);
            }
            insert opps;
            
            //Creating Case
            Case[] cases = new Case[]{};
            for (integer i =0; i<numberOfRecords; i++)
            {
                Case c = UTIL_TestFactory.createCase();
                c.Status = caseStatusStart;
                c.Opportunity__c = opps[i].Id;
                cases.add(c);
            }
            insert cases;
            
            // Set the case with new status which will fire the trigger on update
            for (integer i =0; i<numberOfRecords; i++)
            {
                Case c = cases[i];
                c.Status = caseStatusFinal;
            }
            
            Test.startTest();
            // Try the update
            // Update the case with new status to fire the trigger
            // The user will succeed as it's an admin
            system.runAs(adminUser) {
                update cases;
            }
            Test.stopTest();
        /* END OF WORKAROUND
         **/
        
        // Check the case statuses where copied over
        Opportunity[] updatedOpps = [select id, Admin_Activity_Status__c from Opportunity where id in :opps];
        for (integer i =0; i<numberOfRecords; i++)
        {
            Opportunity o = updatedOpps[i];
            System.assert(caseStatusFinal.equalsIgnoreCase(o.Admin_Activity_Status__c), 'Trigger failed to update opportunity status based on case');
            // To remove, just a reminder: When flag code is ready, we check the opporunity flag is now clear...
            // To remove, just a reminder: System.assertEquals(false,o.Ignore_Workflow_Rules__c, 'Trigger failed to clear the opportunity flag');
        }
    }

 static testMethod void autoInsertCase(){
          
        List<Case> cases = new List<Case>();   
        List<Case> caseToUpdate = new List<case>();
        Set<id> parentCaseIds = new Set<id>();
        Integer count = 0;
           
             
        cases = UTIL_TestFactory.createParentCase();
            
       insert cases;
        for (Case c: cases) 
        {
        if (c.ParentId!=null) 
         {
            parentCaseIds.add(c.ParentId);
         }
        }

 if (parentCaseIds.size()>0) {
        List<Case> parentCases = [Select Id, ISParent__c, 
                                    (Select id From Cases) 
                                    From Case
                                    Where Id in :parentCaseIds];
       for(Case hold : parentcases)
        {
            hold.ISParent__c=true;
            caseToUpdate.add(hold);
        }
       Case parent = [select ISParent__c from Case where Id=:parentCaseIds];  
      System.assert(parent.ISParent__c==True);
       
           
       }
   }
        
   static testMethod void autoCloseParentCase(){ 
        List<Case> cases = new List<Case>();   
        List<Case> caseToUpdate = new List<case>();
        List<Case> caseToUpdateParent = new List<Case>();  
      List<Case> casesPartial = new List<Case>();
        Set<id> parentCaseIds = new Set<id>();
       // Set<id> parentCaseIdsDel = new Set<id>();
        Integer childCount = 0;
        cases = UTIL_TestFactory.deleteParentCase();
       // caseToUpdateParent =  UTIL_TestFactory.deleteParentPartCase(); 
       //update caseToUpdateParent;
        update cases;
        for (Case c: cases) 
        {
        if (c.ParentId!=null) 
         {
            parentCaseIds.add(c.ParentId);
         }
        }

 if (parentCaseIds.size()>0) {
        List<Case> parentCases = [Select Id, ISParent__c, (Select id From Cases) From Case Where Id in :parentCaseIds];
       for(Case hold : parentcases)
        {
        childCount = hold.cases.size();
         if(childCount==0){
         hold.ISParent__c=false;
         caseToUpdate.add(hold);
        }
        }
     Case parent = [select ISParent__c from Case where Id=:parentCaseIds];  
      System.assert(parent.ISParent__c==false);
     
   
  }   
}

    // test the contact center project part of the Case_BeforeUpdate and Case_AfterUpdate triggers
    static testMethod void CC_Case_TriggerTest() {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {            
            // Create a sample queue
            Group g1 = new Group(Name='Fluido Test', type='Queue');
            insert g1;
            system.assert(g1.Id != null);
            
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            insert q1;
            system.assert(q1.Id != null);
    
            // create a sample clear it queue custom settings
            CC_ClearIT_Queues__c cc_q = new CC_ClearIT_Queues__c();
            cc_q.Name = 'Fluido Test';
            cc_q.ClearIT_Queue_Name__c = 'uppdrag2';
            insert cc_q;
                      
            UTIL_TestFactory.setUpOrg();
            
            // Create a sample account and case
            Account acct = UTIL_TestFactory.createAccount();
            acct.Phone = '60602020';
            acct.Mobile_Phone__c = '50501010';
            insert acct;
            system.assert(acct.Id != null);
    
            Case c = new Case();
            c.AccountId = acct.Id;
            c.OwnerId = UserInfo.getUserId();
            c.Subject = 'Test case';
            insert c;
            system.assert(c.Id != null);
                    
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new CC_MockHttpResponseGenerator());

            Test.startTest();        

            UTIL_Apex.CC_CaseBeforeUpdateProcessing = false; // reset the semaphore
            
            c = [SELECT Id, OwnerId FROM Case WHERE Id=:c.Id];
            c.OwnerId = g1.Id; // change the ownership to a queue
            update c; // trigger enqueues the case

            c = [SELECT Id, OwnerId FROM Case WHERE Id=:c.Id];
            system.assertEquals(c.OwnerId, g1.Id);

            Test.stopTest();
            
            c = [SELECT Id, CC_Item_Id__c, CC_Queue_Status__c, Status FROM Case WHERE Id=:c.Id];
            system.assert(c.CC_Item_Id__c != null);
            system.assert(c.CC_Queue_Status__c == Label.Case_Enqueued);

            // Test DeQueue case
            c.Status = 'Closed';
            update c; // trigger dequeues the case
        }
    }    

}