/**
    About
    -----
    Description: Test class for the Account Team Panel
    Created for: Postnord Get2OneCRM Master template/Winter updates
    Create date: 
    
    Details
    -------
    
    Update History
    --------------
    Created 2014 Sept: M.Evans

    TEST CASES
    ----------
    1. Page Navigation
    a) View the account teams
    b) Confirm access to buttons (edit/delete/insert) with correct permissions 
    - @TOM: Which profiles are not supposed to have edit,insert or delete permissions that we know?
    Change modes and navigation in the pane 
    c) Display access toggle
    d) Change to view edit
    e) On saving a change (account team member edit, add default team, add team member, delete team member, delete all) the page refreshes
    f) On hitting "cancel" or display access the whole page does NOT refresh

    2. Add the default account team from the user's settings
    - Add admin, customer responsible, two other roles
    a) users added with correct access levels
    aa) Confirm access permissions set  under the OWD do not cause an error*
    b) Confirm cannot repeat CR's
    c) Confirm cannot repeat users
    e) Confirm this account and child accounts have team member added (if the role is in the Sync Roles custom settings list)
    d) Confirm this account and child account mapped fields are updated (when the role is in AccountMapping)

    3. Add one and then five users to account team from the UI
    - Add admin, customer responsible, three other roles
    a) users added with correct access levels
    aa) Confirm access permissions set  under the OWD do not cause an error*
    b) Confirm cannot repeat CR's
    c) Confirm cannot repeat users
    e) Confirm this account and child accounts (when an LE) have team member added (if the role is in the Sync Roles custom settings list)
    ee) If this is an LE with no child accounts, then no error is thrown when there is no where to copy to!
    d) Confirm this account and child account mapped fields (when an LE) are updated (when the role is in AccountMapping)
    dd) If this is an LE with no child accounts, then no error is thrown when there is no where to copy to!

    4. Edit a team member
    a) To below the OWD's (fails, user should get OWD permissions applied)
    e) Confirm this account and child accounts (when an LE) have team member updated (if the role is no longer in the sync roles, it should be removed)
    ee) If this is an LE with no child accounts, then no error is thrown when there is no where to copy to!
    d) Confirm this account and child account mapped fields (when an LE) are updated (when the role is in AccountMapping. if the role is no longer in the sync roles, the old values should be cleared)
    dd) If this is an LE with no child accounts, then no error is thrown when there is no where to copy to!

    5. Delete a specific team member
    b) Confirm this account and child accounts have the team member removed
    d) Confirm this account and child account mapped fields are cleared

    6. Delete all team members
    Edit a specific team member
    a) Confirm this account and child accounts have the MATCHING team members removed (ie a child could have additional roles remaining post delete)
    d) Confirm this account and child account mapped fields are cleared

    NOTES
    ** Access levels cannot be set below the organisation wide defaults for an object
    ** BULK code cannot handle deletes as it doesn't know what was removed, therefore the need for this UI
    ** BULK code should however be repaired and not retired to handle that Users can create own teams and apply them by default to their accounts. Batch apex currently does copy these accross all accounts. This could be an argument to leave the bulk processing in place but have it run only once on demand by the admin via a custom setting. The code will need fixing to implement the requirement to remove customer responsible duplications.
    ** Work around for updating the BULK code and retiring it compeltely is to educate the users to not use the default 'add to teams' on their profile. Risky. There is no customisation possible in salesforce today that allows this.
    ** When recalculating sharing rules (ex. when chaning OWD's, the security model or when ownership on an account changes) the manual apex shares are lost. Teams remain but any custom shares will revert to default settings. On aking org wide changes the Admin will need to export accountShare records and import them again
    **  KNOWN ISSUES:

    Custome reponsible is not being detected in the test. Default issue or other?
*/

@IsTest
public with sharing class G2O_AccountTeamPanel_VFCx_TEST {

    static Account parentLEAccount = new Account();
    static map<id,Account> worksites = new map<id,Account>();
    static User admin = new User();
    static User mainUser = new User();
    static User[] userList = new User[]{};
    static UserAccountTeamMember[] defaultTeam = new UserAccountTeamMember[]{};
    static ApexPages.StandardController controller{get{controller = controller ==null ? new ApexPages.StandardController(parentLEAccount):controller; return controller;}set;}
    static G2O_AccountTeamPanel_VFCx panel {get{panel = panel ==null ? new G2O_AccountTeamPanel_VFCx(controller):panel; return panel;}set;}
    static Map<String,AccountTeamMemberToAccountMapping__c> mappedRoles;
    static Map<String, AccountTeamMemberRolesToSync__c> rolesToSync;
    static Map<String,AccountTeamMemberToAccountMapping__c[]> atm2Map;
            
    static String fieldMap_DestinationFields = 'id,RecordTypeId,parentId';
    static String fieldMap_SourceFields = 'id,AccountId,userId,TeamMemberRole';
    static String custResp_Role = '';
    static String non_custResp_Role = '';
    static Organization org;

/*
1. Page Navigation
    a) View the account teams
    b) Confirm access to buttons (edit/delete/insert) with correct permissions 
    - @TOM: Which profiles are not supposed to have edit,insert or delete permissions that we know?
    Change modes and navigation in the pane 
    c) Display access toggle
    d) Change to view edit
    e) On saving a change (account team member edit, add default team, add team member, delete team member, delete all) the page refreshes
    f) On hitting "cancel" or display access the whole page does NOT refresh
*/
    static testMethod void page_Navigation() {
        init();
        Test.startTest();
        System.runAs(mainUser)
        {
            System.assertEquals(panel.mode,'standard','Screen is not opening in correct mode.');
            System.assertEquals(panel.displayAccess,false,'Screen is openining in mode to show full access.');
            System.assertEquals(panel.refreshPage,false,'Screen is openining with an auto refresh. This will cause an infinate refresh loop. Fix immediately!');
            System.assertEquals(panel.insertPermissions, Schema.sObjectType.AccountTeamMember.isCreateable(),'Page is ignoring org wide defaults: AccountTeamMember.isCreateable');
            System.assertEquals(panel.editPermissions, Schema.sObjectType.AccountTeamMember.isUpdateable(),'Page is ignoring org wide defaults: AccountTeamMember.isUpdateable');
            System.assertEquals(panel.deletePermissions, Schema.sObjectType.AccountTeamMember.isDeletable(),'Page is ignoring org wide defaults: AccountTeamMember.isDeletable');
            panel.toggleTeamAccess();
            System.assertEquals(panel.displayAccess,true,'Unable to toggle the table to show all team access details');
            panel.salesTeamMemberInsert();
            System.assertEquals(panel.mode,'salesTeamMemberInsert','Unable to switch to the add team member panel');
            
            // The following cannot be tested for return values as they are nillable. Code coverage therefore instead.
            panel.getDefaultAccountAccessLevel();
            panel.getDefaultOpportunityAccessLevel();
            panel.getDefaultCaseAccessLevel();
        }
        Test.stopTest();
    }
    
    /*
        2. Add the default account team from a user's settings
        NOTES:
        // Make a main user with a default account team that contains at least one role that should be sync'd to child worksites
        // Note DML is not allowed on the UserAccounTeamMember object (not even create)
        // As DML is not allowed on the UserAccountTeamMember table, we can only confirm these members as being added. 
        // More complex functionality, ex considering removal of duplicates or other more subtle logic will need to be 
        // tested in other use cases where we can control the test case data
    */
    static testMethod void addDefaultTeam() {
        init();
        
        /*
        defaultTeam = [Select id, ownerId, userId, TeamMemberRole, CaseAccessLevel, AccountAccessLevel, OpportunityAccessLevel 
            from UserAccountTeamMember where TeamMemberRole in :rolesToSync.keySet() 
            AND AccountAccessLevel = :org.DefaultAccountAccess AND OpportunityAccessLevel = :org.DefaultOpportunityAccess
            AND CaseAccessLevel = :org.DefaultCaseAccess 
            AND ownerId IN (select Id from User where isActive = true)  limit 1];
        defaultTeam = [Select id, ownerId, userId, TeamMemberRole, CaseAccessLevel, AccountAccessLevel, OpportunityAccessLevel from UserAccountTeamMember where ownerId =:defaultTeam[0].ownerId];
        
        mainUser = [SELECT id from User where id =:defaultTeam[0].ownerId AND isActive=true];
        */
        mainUser = [SELECT id from User where id =:UserInfo.getUserId()];
        
        Test.startTest();
        if(mainUser.id != null){
            System.runAs(mainUser)
            {
                panel.addDefaultTeam();
                if(defaultTeam.size()>0){
                    
                    System.assertNotEquals(panel.accountTeamMembers.size(),0, 'Could not assign a randomly selected default team to the test account:'+defaultTeam);
        
                    // Check the member(s) was/where copied to the child worksites
                    Set<id> accountIds = new Set<id>();
                    accountIds.add(panel.acct.id);
                    for(Account a : worksites.values())
                    {
                        accountIds.add(a.id);
                    } 
        
                    // Confirm all accounts recived at least one role
                    AccountTeamMember[] atms = [select id, accountId, TeamMemberRole, userId from AccountTeamMember where accountId in :accountIds];
                    Set<id> accountsWithRoles = new Set<Id>();
                    for (AccountTeamMember a : atms)
                    {
                        accountsWithRoles.add(a.AccountId);
                    }
                    System.assertEquals(accountIds.size(), accountsWithRoles.size(),'Unequal number of team members copied');
            
                }
            }
        }
        Test.stopTest();
    }

    /*
        3. Add five users to account team via the UI methods
        - Add admin, 2xcustomer responsible, one other role from the sync list, one role not in the sync list
        a) users added with correct access levels
        aa) Confirm access permissions set  under the OWD do not cause an error*
        b) Confirm cannot repeat CR's
        e) Confirm this account and child accounts (when an LE) have relvant team member added (if the role is in the Sync Roles custom settings list)
        ee) If this is an LE with no child accounts, then no error is thrown when there is no where to copy to!
        d) Confirm this account and child account mapped fields (when an LE) are updated (when the role is in AccountMapping)
        dd) If this is an LE with no child accounts, then no error is thrown when there is no where to copy to!
    
        4. Edit a team member
        a) To below the OWD's (fails, user should get OWD permissions applied)
        e) Confirm this account and child accounts (when an LE) have team member updated (if the role is no longer in the sync roles, it should be removed)
        ee) If this is an LE with no child accounts, then no error is thrown when there is noHwere to copy to!
        d) Confirm this account and child account mapped fields (when an LE) are updated (when the role is in AccountMapping. if the role is no longer in the sync roles, the old values should be cleared)
        dd) If this is an LE with no child accounts, then no error is thrown when there is nowHere to copy to!

        5. Delete a specific team member
        b) Confirm this account and child accounts have the team member removed
        d) Confirm this account and child account mapped fields are cleared

        6. Delete all team members
        Edit a specific team member
        a) Confirm this account and child accounts have the MATCHING team members removed (ie a child could have additional roles remaining post delete)
        d) Confirm this account and child account mapped fields are cleared
    */
    static testMethod void manageTeam() {
        init();
        ID legalEntityId = parentLEAccount.Id;  
            
        Test.startTest();
        //System.runAs(mainUser)
        //{
            /* 3: Add five users */
            // Add the following 5 users:
            // Admin with full permission, 2xcustomer responsible with elevated permissions, one below the OWD, one equal to the OWD
            panel.salesTeamMemberInsert();
            AccountTeamMember atm = new AccountTeamMember();
            AccountShare accShare = new AccountShare();
            G2O_AccountTeamPanel_VFCx.atmWrapper[] newMembers = panel.newMembers;
            
            //Any entries with same Customer responsible role or not matching OWD will fail
            
            // Team member: Admin
            //This will not be created as ATM as sharing does not meet OWD
            atm = new AccountTeamMember(); 
            accShare = new AccountShare(); 
            atm.AccountId = legalEntityId;
            atm.userId = admin.Id;
            atm.TeamMemberRole = custResp_Role; // Set role as one not to be mapped
            accShare.AccountAccessLevel = 'Read'; // Set all as low as possible to try to get below OWD and the user's access - easy to break with an admin profile
            accShare.OpportunityAccessLevel = 'Read';
            accShare.CaseAccessLevel = 'Read';
            panel.newMembers[0].atm = atm;
            panel.newMembers[0].accShare = accShare;
            
            //This will not be created as ATM as sharing does not meet OWD
            atm = new AccountTeamMember(); 
            accShare = new AccountShare(); 
            atm.AccountId = legalEntityId;
            atm.userId = userList[0].id;
            atm.TeamMemberRole = custResp_Role; // Set role as one not to be mapped
            accShare.AccountAccessLevel = 'Edit'; // Set all as low as possible to try to get below OWD and the user's access - easy to break with an admin profile
            accShare.OpportunityAccessLevel = 'Edit';
            accShare.CaseAccessLevel = 'Edit';
            panel.newMembers[1].atm = atm;
            panel.newMembers[1].accShare = accShare;
            
            // Fetch the account team members and account shares
            System.debug(LoggingLevel.INFO,'### Requeriing for account team members with additional mapped fields: select '+fieldMap_SourceFields+' from AccountTeamMember where accountId=:legalEntityId');
            AccountTeamMember[] atms = Database.query('select '+fieldMap_SourceFields+' from AccountTeamMember where accountId=:legalEntityId');
            System.debug(LoggingLevel.INFO,'### Requeried for account team members with additional mapped fields: '+atms);
            AccountShare[] accShares = [select id, AccountAccessLevel, CaseAccessLevel, OpportunityAccessLevel, userOrGroupId, AccountId from AccountShare where accountId = :legalEntityId];

            // Confirm none of the ATMs is created due to validation issue
            System.assertEquals(0,atms.size(),'Incorrect number of team members have been added:'+atms);
            
            panel.newMembers = null; 
            for (integer i=0; i<5;i++)
            {
                panel.newMembers.add(new G2O_AccountTeamPanel_VFCx.atmWrapper());
            }
            
            // Team member: Admin
            atm = new AccountTeamMember(); 
            accShare = new AccountShare(); 
            atm.AccountId = legalEntityId;
            atm.userId = admin.Id;
            atm.TeamMemberRole = 'NonListRole'; // Set role as one not to be mapped
            accShare.AccountAccessLevel = org.DefaultAccountAccess;
            accShare.OpportunityAccessLevel = org.DefaultOpportunityAccess;
            accShare.CaseAccessLevel = org.DefaultCaseAccess;
            panel.newMembers[0].atm = atm;
            panel.newMembers[0].accShare = accShare;

            
            // Team member: Equal to OWD
            atm = new AccountTeamMember(); 
            accShare = new AccountShare(); 
            atm.AccountId = legalEntityId;
            atm.userId = userList[2].id;
            atm.TeamMemberRole = 'NonListRole2';
            accShare.AccountAccessLevel = org.DefaultAccountAccess;
            accShare.OpportunityAccessLevel = org.DefaultOpportunityAccess;
            accShare.CaseAccessLevel = org.DefaultCaseAccess;
            panel.newMembers[1].atm = atm;
            panel.newMembers[1].accShare = accShare;
            
            // Team member: Equal to OWD
            atm = new AccountTeamMember(); 
            accShare = new AccountShare(); 
            atm.AccountId = legalEntityId;
            atm.userId = userList[3].id;
            atm.TeamMemberRole =  custResp_Role; 
            accShare.AccountAccessLevel = org.DefaultAccountAccess;
            accShare.OpportunityAccessLevel = org.DefaultOpportunityAccess;
            accShare.CaseAccessLevel = org.DefaultCaseAccess;
            panel.newMembers[2].atm = atm;
            panel.newMembers[2].accShare = accShare;
            
            // The above should save with no errors
            //System.debug(LoggingLevel.INFO,'### Submitting new account team member list to save method: '+newMembers);
            panel.salesteamMemberInsert_Save();
            
            
            // Fetch the account team members and account shares
            System.debug(LoggingLevel.INFO,'### Requeriing for account team members with additional mapped fields: select '+fieldMap_SourceFields+' from AccountTeamMember where accountId=:legalEntityId');
            atms = Database.query('select '+fieldMap_SourceFields+' from AccountTeamMember where accountId=:legalEntityId');
            System.debug(LoggingLevel.INFO,'### Requeried for account team members with additional mapped fields: '+atms);
            accShares = [select id, AccountAccessLevel, CaseAccessLevel, OpportunityAccessLevel, userOrGroupId, AccountId from AccountShare where accountId = :legalEntityId];

            // Confirm exepcted number of team members
            System.assertEquals(3,atms.size(),'Incorrect number of team members have been added:'+atms);

            // Confirm no duplicate Customer Responsible roles (only one should have made it)
            integer countCustomerResponsible = 0;
            id teamMemberToUpdate;
            for (AccountTeamMember a : atms)
            {
                if (a.TeamMemberRole.equalsIgnoreCase(custResp_Role))
                {
                    countCustomerResponsible++;
                    teamMemberToUpdate = a.Id;
                }
            }
            System.assertEquals(1,countCustomerResponsible,'More than one customer responsibles where inserted!');

            // Confirm field sync: Account fields contained the copied data
            Account parentAcctRequery = Database.query('select '+fieldMap_DestinationFields+' from Account where id=:legalEntityId');
            System.debug(LoggingLevel.INFO,'### Requerying for account with additional mapped fields: '+parentAcctRequery);
            
            for (AccountTeamMember copiedAtm : atms)
            {
                // For each mapped role, check the correct values where copied to the account record
                if (atm2Map.containsKey(copiedAtm.TeamMemberRole))
                {
                    for (AccountTeamMemberToAccountMapping__c fieldMap : atm2Map.get(copiedAtm.TeamMemberRole))
                    {
                        if(fieldMap.sourceField__c.contains('.')){
                            System.assertEquals(copiedAtm.getSObject(fieldMap.sourceField__c.subString(0,fieldMap.sourceField__c.indexOf('.'))).get(fieldMap.sourceField__c.subString(fieldMap.sourceField__c.indexOf('.')+1)),parentAcctRequery.get(fieldMap.DestinationField__c),
                                'Uneven parameters for fieldMap '+fieldMap+' on '+copiedAtm+' for account '+parentAcctRequery);
                        }
                        else{
                            System.assertEquals(copiedAtm.get(fieldMap.sourceField__c),parentAcctRequery.get(fieldMap.DestinationField__c),
                                'Uneven parameters for fieldMap '+fieldMap+' on '+copiedAtm+' for account '+parentAcctRequery);                           
                        }
                    }
                }
            }


            // Confirm account team members also on child worksites (one should have been copied per child worksite)
            Account[] childAccounts = Database.query('select '+fieldMap_DestinationFields+' from Account where parentId = :legalEntityId');
            worksites = new Map<id,Account>();
            Set<Id> childAccountIds = new Set<Id>();
            for (Account a : childAccounts)
            {
                worksites.put(a.Id, a);
                childAccountIds.add(a.Id);
            }
            AccountTeamMember[] childAtms = Database.query('select '+fieldMap_SourceFields+' from AccountTeamMember where accountId in :childAccountIds');
            System.debug(LoggingLevel.INFO,'### Confirming team members for child worksites: childAtms: '+childAtms+' worksites:'+worksites);
            System.assertEquals(childAtms.size(),(worksites.size()),'Could not copy team members to child accounts');


            // Confirm the child account fields contained the copied data
            for (Account childWS : worksites.values())
            {
                // Cycle though the account team members that where to have been copied
                for (AccountTeamMember copiedAtm : atms)
                {
                    // For each mapped role, check the correct values where copied to the account record
                    if (atm2Map.containsKey(copiedAtm.TeamMemberRole))
                    {
                        for (AccountTeamMemberToAccountMapping__c fieldMap : atm2Map.get(copiedAtm.TeamMemberRole))
                        {
                            if(fieldMap.sourceField__c.contains('.')){
                                System.assertEquals(copiedAtm.getSObject(fieldMap.sourceField__c.subString(0,fieldMap.sourceField__c.indexOf('.'))).get(fieldMap.sourceField__c.subString(fieldMap.sourceField__c.indexOf('.')+1)),childWS.get(fieldMap.DestinationField__c),
                                    'Uneven parameters for fieldMap '+fieldMap+' on '+copiedAtm+' for account '+childWS);
                            }
                            else{
                                System.assertEquals(copiedAtm.get(fieldMap.sourceField__c),childWS.get(fieldMap.DestinationField__c),
                                    'Uneven parameters for fieldMap '+fieldMap+' on '+copiedAtm+' for account '+childWS);                           
                            }
                        }
                    }
                }
            }
            

            if (teamMemberToUpdate!=null)
            {
                /* 4 Edit team member */
                apexpages.currentpage().getparameters().put('atmId',teamMemberToUpdate); 
                panel.salesTeamMemberEdit();

                // Change team member to a non-mapped role should also remove this role from child worksites
                String oldUserId = panel.editMember.atm.userId;
                String oldRole = panel.editMember.atm.TeamMemberRole;
                panel.editMember.atm.TeamMemberRole = 'NonMappedRole4';
                panel.salesTeamMemberEdit_Save();

                // Confirm the role changed
                atm = [select id,userId,TeamMemberRole,AccountId from AccountTeamMember where id=:panel.editMember.atm.Id limit 1];
                System.assertEquals('NonMappedRole4', atm.TeamMemberRole, 'Team member role was not updated: '+atm);

                // Confirm the role was removed from child worksites
                childAtms =  [select id from AccountTeamMember where accountId in :worksites.keySet() and UserId = :oldUserId];
                System.assertEquals(0,childAtms.size(),'The child worksites still contain a mapped account team member that was removed from the parent: '+childAtms);

                // Ensure the old role associated fields are empty or null
                parentAcctRequery = Database.query('select '+fieldMap_DestinationFields+' from Account where id=:legalEntityId');
                childAccounts = Database.query('select '+fieldMap_DestinationFields+' from Account where parentId = :legalEntityId');
                if (atm2Map.containsKey(oldRole))
                {
                    for (AccountTeamMemberToAccountMapping__c fieldMap : atm2Map.get(oldRole))
                    {
                        System.assert(parentAcctRequery.get(fieldMap.DestinationField__c) == null || String.valueOf(parentAcctRequery.get(fieldMap.DestinationField__c))=='',
                            'Mapped account fields not emptied '+fieldMap+' on '+oldRole+' for account '+parentAcctRequery);
                    }

                    // Confirm the child account fields that contained the copied data are now removed
                    for (Account childWS : childAccounts)
                    {
                        for (AccountTeamMemberToAccountMapping__c fieldMap : atm2Map.get(oldRole))
                        {
                            System.assert(childWS.get(fieldMap.DestinationField__c) == null || String.valueOf(childWS.get(fieldMap.DestinationField__c))=='',
                                'Mapped account fields not emptied '+fieldMap+' on '+oldRole+' for account '+childWS);
                        }
                    }
                }

                /* 5 : Delete team member */
                apexpages.currentpage().getparameters().put('atmId',teamMemberToUpdate); 
                panel.deleteTeamMember();

                // Confirm account fields that contained the copied data are now empty
                parentAcctRequery = Database.query('select '+fieldMap_DestinationFields+' from Account where id=:legalEntityId');
                
            }
            /* 6 : Delete all team members */
            panel.deleteAll();
        //}
        Test.stopTest();
        
    }

    /* Main Set up */
    static void init() {
        UTIL_TestFactory.setUpOrg();
        UTIL_TestFactory.createAccountTeamMemberRolesToSync();
        UTIL_TestFactory.createAccountTeamMemberToAccountMapping();
        rolesToSync = UTIL_OrgSettings.AccountTeamMemberRolesToSync();
        mappedRoles = UTIL_OrgSettings.AccountTeamMemberToAccountMapping();
        atm2Map = UTIL_OrgSettings.accountTeamMemberToAccountMapping_ByRole();
        org = UTIL_Meta.getOrgInfo();
        createUsers();
        createLEtoWSData();
        
        
        
        // Pick out one role from the Role to Sync list (custom setting) that is a customer responsible role
        custResp_Role = '';
        for (String rName : rolesToSync.keySet())
        {
            if (rName.containsIgnoreCase(UTIL_OrgSettings.customerResponsibleRole()))
            {
                custResp_Role = rName;
            } else {
                non_custResp_Role = rName;
            }
        }
        System.assertNotEquals('',custResp_Role,'At least one customer responsible role "'+UTIL_OrgSettings.customerResponsibleRole()+'" is exptected in the "roles to sync" custom setting. This role is identified by containing the text held in the "Customer Responsible Role" field defined by Get2One custom settings. Ensure default values in the Roles to Sync list (currently:"'+rolesToSync+'") contains at least one instance of this value and that there are default values where not set.');
    
        // Pick out the fields from the mapped roles and create a string of fields that are query compatible
        for (AccountTeamMemberToAccountMapping__c m : mappedRoles.values())
        {
            fieldMap_DestinationFields += fieldMap_DestinationFields.containsIgnoreCase(','+m.DestinationField__c) ? '' : ','+m.DestinationField__c;
            fieldMap_SourceFields += fieldMap_SourceFields.containsIgnoreCase(','+m.SourceField__c) ? '' : ','+m.SourceField__c;
        }
    }

    static void createUsers() {
        // Create an admin user
        admin = UTIL_TestFactory.createAdmin('AccountTeamMemberTestAdmin@AccountTeamMemberTestAdmin.se');
        insert admin;


        // Create a small sample set of users
        for(integer i = 0; i < 4; i++){
            User u = UTIL_TestFactory.createUser('AccountTeamMemberTestUser' + i + '@AccountTeamMemberTestUser.se', 'Standard User');
            u.Title = 'UserTitle ' + i;
            u.Email = 'AccountTeamMemberTestUser' + i + '@AccountTeamMemberTestUser.se';
            u.Phone = ''+i;
            u.Team__c = 'UserTeam ' + i;
            userList.add(u); 
        }
        // Add TWO customer responsible type roles as we will check for duplicates being blocked
        for(integer i = 0; i < 2; i++){
            User u = UTIL_TestFactory.createUser('AccountTeamMemberTestUser' + (i+200) + '@AccountTeamMemberTestUser.se', 'Standard User');
            u.Title = 'UserTitle ' + i;
            u.Email = 'AccountTeamMemberTestUser' + i + '@AccountTeamMemberTestUser.se';
            u.Phone = ''+i;
            u.Team__c = UTIL_OrgSettings.customerResponsibleRole() + ' ' + i;
            userList.add(u); 
        }
        insert userList;

        mainUser = [SELECT id from User where email='AccountTeamMemberTestUser0@AccountTeamMemberTestUser.se' limit 1];
    }

    static void createLEtoWSData(){
        UTIL_TestFactory.setUpOrg();
        
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
        
        //Creating Accounts
        parentLEAccount = UTIL_TestFactory.createAccount();
        parentLEAccount.recordTypeId = legalEntityRT;    
        insert parentLEAccount;
        
        Account[] childWorksites = new Account[]{};
        for(integer i = 0; i < 4; i++){
            Account w = UTIL_TestFactory.createAccount();
            w.parentid = parentLEAccount.id;
            w.RecordTypeId = workSiteRT; 
            childWorksites.add(w);        
        }
        System.debug(LoggingLevel.INFO,'### Child Worksites inserted: '+childWorksites);
        insert childWorksites;
        worksites = new Map<id,Account>([select id, parentId, RecordTypeId from Account where parentId = :parentLEAccount.id]);
    }
    
}