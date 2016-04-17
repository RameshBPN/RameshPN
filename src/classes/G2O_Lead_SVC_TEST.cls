/**
    About
    -----
    Description: This class is used to test Lead_SVC and corresponging triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
        
    Update History
    --------------
    Created March 2013 - C.H.F.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Lead_SVC_TEST {
    
    // Tests that if no team member exicts, the fail flag is set
    static testMethod void noAccountTeamMembersOnAccout() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        User user = UTIL_TestFactory.createUser('lead@lead.lead', 'System Administrator');
        insert user;
        Lead lead = UTIL_TestFactory.createLead();
        lead.Account__c = account.Id;
        lead.Status = 'Qualified by lead data';
        lead.Sales_Area__c = '001';
        
        // Act
        insert lead;
        
        Lead leadAfterInsert = [SELECT Id, OwnerId, Failed_Allocate_Assign__c FROM Lead WHERE Id = :lead.Id];
        
        // Assert
        System.assertNotEquals(user.Id, leadAfterInsert.OwnerId, 'the lead should not have been assigned to the user');
        System.assert(leadAfterInsert.Failed_Allocate_Assign__c == true , 'Failed flag not set');
    }
    
    // Tests that if no team member has a role that matches the lead sales area, no change is made to the system
    static testMethod void noChangeOnNoMatch() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        User user = UTIL_TestFactory.createUser('lead@lead.lead', 'System Administrator');
        insert user;
        AccountTeamMember aTeamMember = UTIL_TestFactory.createAccountTeamMember();
        aTeamMember.AccountId = account.Id;
        aTeamMember.UserId = user.Id;
        aTeamMember.TeamMemberRole = 'LO DK - Customer Responsible';
        insert aTeamMember;
        Lead lead = UTIL_TestFactory.createLead();
        lead.Account__c = account.Id;
        lead.Status = 'Qualified by lead data';
        lead.Sales_Area__c = '001';
        
        // Act
        insert lead;
        
        Lead leadAfterInsert = [SELECT Id, OwnerId, Failed_Allocate_Assign__c FROM Lead WHERE Id = :lead.Id];
        
        // Assert
        System.assertNotEquals(user.Id, leadAfterInsert.OwnerId, 'the lead should not have been assigned to the user since their business areas doesn\'t match');
        System.assert(leadAfterInsert.Failed_Allocate_Assign__c == true , 'Failed flag not set');
    }
    
    // Tests that when multiple accounts matches the business area of the lead, one of them is correctly selected
    static testMethod void matchOnMultiMatch() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        User user = UTIL_TestFactory.createUser('lead@lead.lead', 'System Administrator');
        insert user;
        AccountTeamMember aTeamMember = UTIL_TestFactory.createAccountTeamMember();
        aTeamMember.AccountId = account.Id;
        aTeamMember.UserId = user.Id;
        aTeamMember.TeamMemberRole = 'BE - Customer Responsible';
        insert aTeamMember;
        AccountTeamMember aTeamMember2 = UTIL_TestFactory.createAccountTeamMember();
        aTeamMember2.AccountId = account.Id;
        aTeamMember2.UserId = user.Id;
        aTeamMember2.TeamMemberRole = 'BE - Customer Responsible';
        insert aTeamMember2;
        Lead lead = UTIL_TestFactory.createLead();
        lead.Account__c = account.Id;
        lead.Status = 'Qualified by lead data';
        lead.Sales_Area__c = '001';
        
        // Act
        insert lead;
        
        Lead leadAfterInsert = [SELECT Id, OwnerId, Failed_Allocate_Assign__c FROM Lead WHERE Id = :lead.Id];
        
        // Assert
        System.assertEquals(user.Id, leadAfterInsert.OwnerId, 'The business area of Account team member and lead matches so the lead should be assigned to the user');
        System.assert(leadAfterInsert.Failed_Allocate_Assign__c == false , 'Failed flag set');
    }
    
    // Tests that upon inserting a lead it is correctly assigned to the user
    static testMethod void correctLeadReceiverCreate () {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        User user = UTIL_TestFactory.createUser('lead@lead.lead', 'System Administrator');
        insert user;
        AccountTeamMember aTeamMember = UTIL_TestFactory.createAccountTeamMember();
        aTeamMember.AccountId = account.Id;
        aTeamMember.UserId = user.Id;
        aTeamMember.TeamMemberRole = 'BE - Customer Responsible';
        insert aTeamMember;
        
        // Act
        Lead lead = UTIL_TestFactory.createLead();
        lead.Account__c = account.Id;
        lead.Status = 'Qualified by lead data';
        lead.Sales_Area__c = '001';
        insert lead;
        
        Lead leadAfterInsert = [SELECT Id, OwnerId, Failed_Allocate_Assign__c FROM Lead WHERE Id = :lead.Id];
        
        // Assert
        System.assertEquals(user.Id, leadAfterInsert.OwnerId, 'The business area of Account team member and lead matches so the lead should be assigned to the user');
        System.assert(leadAfterInsert.Failed_Allocate_Assign__c == false , 'Failed flag set');
    }
        
    // Tests that upon receiving multiple leads they are correctly assigned without breaking DML limits
    static testMethod void correctLeadReceiverMassCreate() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        User user = UTIL_TestFactory.createUser('lead@lead.lead', 'System Administrator');
        insert user;
        AccountTeamMember aTeamMember = UTIL_TestFactory.createAccountTeamMember();
        aTeamMember.AccountId = account.Id;
        aTeamMember.UserId = user.Id;
        aTeamMember.TeamMemberRole = 'BE - Customer Responsible';
        insert aTeamMember;
        
        // Act
        List<Lead> leadList = UTIL_TestFactory.createLeads();
        for(Lead lead : leadList) {
            lead.Account__c = account.Id;
            lead.Status = 'Qualified by lead data';
            lead.Sales_Area__c = '001';
        }
        insert leadList;
        
        List<Lead> leadListAfterInsert = [SELECT Id, OwnerId, Failed_Allocate_Assign__c FROM Lead WHERE Id = :leadList];
        System.debug('user.Id: ' + user.Id);
        System.debug('leadListAfterInsert: ' + leadListAfterInsert);
        // Assert
        System.assertEquals(user.Id, leadListAfterInsert[0].OwnerId, 'The business area of Account team member and lead matches so the lead should be assigned to the user');
        System.assert(leadListAfterInsert[0].Failed_Allocate_Assign__c == false , 'Failed flag set');
    }
    

    // Tests that upon updating a lead it is correctly assigned to the user    
    static testMethod void correctLeadReceiverUpdate () {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        User user = UTIL_TestFactory.createUser('lead@lead.lead', 'System Administrator');
        insert user;
        AccountTeamMember aTeamMember = UTIL_TestFactory.createAccountTeamMember();
        aTeamMember.AccountId = account.Id;
        aTeamMember.UserId = user.Id;
        aTeamMember.TeamMemberRole = 'BE - Customer Responsible';
        insert aTeamMember;
        
        Lead lead = UTIL_TestFactory.createLead();
        lead.Account__c = account.Id;
        lead.Status = 'Created';
        lead.Sales_Area__c = '001';
        insert lead;
        
        // Act
        lead.Status = 'Qualified by lead data';
        update lead;
        
        
        Lead leadAfterUpdate = [SELECT Id, OwnerId, Failed_Allocate_Assign__c FROM Lead WHERE Id = :lead.Id];
        
        // Assert
        System.assertEquals(user.Id, leadAfterUpdate.OwnerId, 'The business area of Account team member and lead matches so the lead should be assigned to the user');
        System.assert(leadAfterUpdate.Failed_Allocate_Assign__c == false , 'Failed flag set');
    }
}