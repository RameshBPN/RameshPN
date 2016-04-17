/*
    About
    -----
    Description: Test class for the Account Team Panel
    Created for: Postnord Get2OneCRM Master template/Winter updates
    Create date: 
    
    Details
    -------
    Recreates the functionality of the Account Team Member related list, with the
    added advantage of being able to apply rules to how the members are being added (see AuditTeamMembers method)

    Use Cases / Test cases
    1. Page Navigation
    2. Add the default account team from the user's settings
    3. Add one and then five users to account team from the UI
    4. Edit a speciffic team member
    5. Delete a specific team member
    6. Delete all team members

    Note that access levels cannot be set below the organisation wide defaults for an object

    Update History
    --------------
    Created 2014 Sept: M.Evans
    Updated 2014 nov: Aref Alazzani to fix bugs around changes replications and some other bugs
    
    Tp Do (Open issues)
    --------------------
    - Displaying Full access for Admin users is not implemented yet
    
*/
public class G2O_AccountTeamPanel_VFCx {
    
    //Constants
    final Map<String, Integer> accessRank = new Map<String, Integer>{
        
        'None' => 1, 'Read' => 2, 'Edit' => 3, 'Full' => 4
    };
    
    // Page set up
    Organization org = UTIL_Meta.getOrgInfo();
    public String mode{get;set;}
    public Boolean displayAccess {get;set;}
    public Boolean refreshPage {get{refreshPage=refreshPage!=null ? refreshPage:false;return refreshPage;}set;}
    public Boolean insertPermissions {get{return Schema.sObjectType.AccountTeamMember.isCreateable();}set;}
    public Boolean editPermissions {get{return Schema.sObjectType.AccountTeamMember.isUpdateable();}set;}
    public Boolean deletePermissions {get{return Schema.sObjectType.AccountTeamMember.isDeletable();}set;}
    
    //This attribute determine if users will have access to buttons and links in the panel
    public Boolean showPanelButtons 
    {   
        get
        {   
                
            AccountTeamPanelController__c buttonsUserSetting = AccountTeamPanelController__c.getInstance(UserInfo.getUserId());
            if(buttonsUserSetting == null){  
                AccountTeamPanelController__c buttonsProfileSetting = AccountTeamPanelController__c.getInstance(UserInfo.getProfileId());
                if(buttonsProfileSetting == null){
                    AccountTeamPanelController__c buttonsOrgSetting = AccountTeamPanelController__c.getOrgDefaults();
                    if(buttonsOrgSetting != null){
                        return !(buttonsOrgSetting.HidePanelButtons__c);
                    } else{
                        return true;
                    }
                } else{
                    return !(buttonsProfileSetting.HidePanelButtons__c);
                }
            } else{
            
                return !(buttonsUserSetting.HidePanelButtons__c);
            }
         }
        set;
    }
 
    // Page params + state
    public Account acct {get;set;}
    public String atmId {get;set;}
    public AccountTeamMember[] accountTeamMembers {get{return atmMap.values();} set;}
    Map<Id,AccountTeamMember> atmMap = new Map<Id,AccountTeamMember>();
    public atmWrapper[] accountTeamMembersDetail{get{return atmDetailMap.values();} set;}
    Map<Id,atmWrapper> atmDetailMap = new Map<Id,atmWrapper>();
    public atmWrapper editMember{get; set;}
    public atmWrapper[] newMembers{get{newMembers = newMembers==null ? new atmWrapper[]{} : newMembers; return newMembers;} set;}
    public String passbackMessage {get;set;}
    
    // Config behaviour
    String uniqueRoleString = UTIL_OrgSettings.customerResponsibleRole();

    // Constructor
    public G2O_AccountTeamPanel_VFCx (ApexPages.StandardController controller) { 
        acct = (Account) controller.getRecord();
        mode = 'standard';
        displayAccess = false;
        refreshPage = false;
        system.debug(LoggingLevel.error,'#### '+ApexPages.currentpage().getparameters());
        if (ApexPages.currentpage().getparameters().get('passbackMessage')!=null)
        {
            passbackMessage = ApexPages.currentpage().getparameters().get('passbackMessage');
        }
        refreshData();
    }

    /**** **** **** **** **** **** **** Page Actions **** **** **** **** **** **** ****/

    // Turn the display access logic on or off
    public PageReference toggleTeamAccess() {
        displayAccess = !displayAccess;
        if (displayAccess) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,label.Account_Team_Access_warning));
        }
        refreshPage = false;
        return null;
    }

    // Add the default account team from the user's settings
    public PageReference addDefaultTeam() {
        
        Map<String, atmWrapper> beforeCustRespRoles = refreshData();
        List<atmWrapper> newAtmWrappers = new List<atmWrapper>();
        
        System.debug(LoggingLevel.INFO, '### START addDefaultTeam');
        // Lookup the default team
        UserAccountTeamMember[] defaultTeam = [
            SELECT AccountAccessLevel, CaseAccessLevel, ContactAccessLevel, OpportunityAccessLevel,
                CreatedById, CreatedDate, Id, LastModifiedById, LastModifiedDate, OwnerId, SystemModstamp, 
                TeamMemberRole, UserId
            FROM UserAccountTeamMember
            WHERE OwnerId =: UserInfo.getUserId()
            LIMIT 999
        ];
        System.debug(LoggingLevel.INFO, '### defaultTeam: '+defaultTeam);

        Map<id,AccountTeamMember> newMembers = new Map<id,AccountTeamMember>();
        AccountShare[] accShares = new AccountShare[]{};
        if (defaultTeam.size()>0)
        {
            // Check for existing customer responsible records
            Set<String> existingCustRespRoles = new Set<String>();
            for (AccountTeamMember atm : [select id, TeamMemberRole, userId, AccountID from AccountTeamMember where accountId=:acct.Id])
            {
                if (atm.TeamMemberRole.containsIgnoreCase(uniqueRoleString))
                {
                    existingCustRespRoles.add(atm.TeamMemberRole);
                }
            }
            // Create the account team members
            for (UserAccountTeamMember u : defaultTeam)
            {
                // Respect the unique customer responsible role && dont' overwrite existing users
                if (!atmMap.containsKey(u.userId) && !existingCustRespRoles.contains(u.TeamMemberRole))
                {
                    AccountTeamMember newATM = new AccountTeamMember();
                    newATM.userId = u.userId;
                    newATM.AccountId = acct.Id;
                    newATM.TeamMemberRole = u.TeamMemberRole;
                    newMembers.put(u.userId, newATM);
                    
                    AccountShare accShare = new AccountShare();
                    accShare.AccountAccessLevel = u.AccountAccessLevel;
                    accShare.CaseAccessLevel = u.CaseAccessLevel;
                    accShare.OpportunityAccessLevel = u.OpportunityAccessLevel;
                    accShare.AccountId = acct.id;
                    accShare.UserOrGroupId = u.userId;
                    accShares.add(accShare);
                    
                    // Assess share levels before upserting
                    // By moving up those that dip under OWD's or removing those that are not elevating permissions at any point
                    atmWrapper a = new atmWrapper();
                    a.atm = newATM;
                    a.accShare = accShare;
                    
                    if(validateAccessLevels(a) != 0){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Default_Team_Access_Error));
                        return null;
                    } 
                    
                }
            }
            System.debug(LoggingLevel.INFO, '### upsert account team members, newMembers '+newMembers);
            
            try{ 
                upsert newMembers.values();
                checkMinimumAccessLevels(accShares);
                upsert accShares;
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ''+e.getMessage()));
                return null;
            }
        }
        
        Map<String, atmWrapper> afterCustRespRoles = refreshData();
        
        // Copy team members and data up the worksite tree
        replicateTeamMembers(beforeCustRespRoles, afterCustRespRoles);
        System.debug(LoggingLevel.INFO, '### END addDefaultTeam');
        return null;
    }
    
    
    // Delete a specific team member
    public PageReference deleteTeamMember() {
        
        Map<String, atmWrapper> beforeCustRespRoles = refreshData();
        
        
        // Remove the speciffic chosen account team member
        // Id is set in atmId
        atmId = apexpages.currentpage().getparameters().get('atmId'); 
        System.debug(LoggingLevel.INFO, '### deleteTeamMember: atmId '+atmId);
        AccountTeamMember atm = atmMap.get(atmId);
        delete atm;

        // Audit the team members, apply automation etc.
        //replicateTeamMembers(new AccountTeamMember[]{atm});
        
        Map<String, atmWrapper> afterCustRespRoles = refreshData();
        
        // Copy team members and data up the worksite tree
        replicateTeamMembers(beforeCustRespRoles, afterCustRespRoles);
        
        // Refresh the page to avoid any issues (if successful)
        return goback();
    }

    // Delete all team members
    public PageReference deleteAll() {
        
        Map<String, atmWrapper> beforeCustRespRoles = refreshData();
        
        delete accountTeamMembers;

        // Audit the team members, apply automation etc.
        //replicateTeamMembers(accountTeamMembers);
        
        Map<String, atmWrapper> afterCustRespRoles = refreshData();
        
        // Copy team members and data up the worksite tree
        replicateTeamMembers(beforeCustRespRoles, afterCustRespRoles);
        
        
        // Refresh the page to avoid any issues (if successful)
        return goback();
    }
    
    // Insert one or more team memebers
    public PageReference salesTeamMemberInsert() {
        
        mode = 'salesTeamMemberInsert';

        // Prepare a set of blank rows for the UI
        newMembers = null;  
        for (integer i=0; i<5;i++)
        {
            newMembers.add(new atmWrapper());
        }
        return null;
    }
    public PageReference salesTeamMemberInsert_Save() {
        
        Map<String, atmWrapper> beforeCustRespRoles = refreshData();
        
        atmWrapper[] errors = new atmWrapper[]{};
        atmWrapper[] valid = new atmWrapper[]{};
        integer namedUsers = 0;

        // Error checking

        // Ensure we know the status of current customer responsible roles as they are unique
        Set<String> existingCustomerResponibleRoles = new Set<String>();
        for (AccountTeamMember atm : accountTeamMembers)
        {
            if (atm.TeamMemberRole.containsIgnoreCase(uniqueRoleString))
            {
                existingCustomerResponibleRoles.add(atm.TeamMemberRole);
            }
        }
        for (atmWrapper a : newMembers)
        {
            // No user? Blank the row
            if(a.atm.userId==null)
            {
                a = new atmWrapper();
            } else {
                namedUsers++;
                // Prevent repeated / duplciate customer responsbiles
                if (a.atm.TeamMemberRole!=null && a.atm.TeamMemberRole.containsIgnoreCase(uniqueRoleString))
                {
                    
                    if (existingCustomerResponibleRoles.contains(a.atm.TeamMemberRole))
                    {
                        // Cust resp. already exists = ERROR
                        a.atm.TeamMemberRole.addError(Label.Customer_responsible_already_exists);
                        return null;    
                    } else {
                        
                        existingCustomerResponibleRoles.add(a.atm.TeamMemberRole);
                    }
                }
                
                
                // User set? Then ensure all data is given
                if(validateAccessLevelsUI(a)){
                    valid.add(a);
                }
                
                
            }
        } 
        // Make sure all records pass checks, otherwise exit
        if (valid.size()!=namedUsers) return null;

        // Save members
        AccountTeamMember[] newATMs = new AccountTeamMember[]{};
        for (atmWrapper aw : valid)
        {
            AccountTeamMember newATM = new AccountTeamMember();
            newATM.userId = aw.atm.userId;
            newATM.AccountId = acct.Id;
            newATM.TeamMemberRole = aw.atm.TeamMemberRole;
            newATMs.add(newATM);
        }
        upsert newATMs;

        // Create share records
        AccountShare[] newShares = new AccountShare[]{};
        for (atmWrapper aw : valid)
        {
            AccountShare accShare = new AccountShare();
            accShare.AccountAccessLevel = aw.accShare.AccountAccessLevel;
            accShare.CaseAccessLevel = aw.accShare.CaseAccessLevel;
            accShare.OpportunityAccessLevel = aw.accShare.OpportunityAccessLevel;
            accShare.AccountId = acct.id;
            accShare.UserOrGroupId = aw.atm.userId;
            newShares.add(accShare);
        }
        checkMinimumAccessLevels(newShares);
        upsert newShares; 

        // Audit the team members, apply automation etc.
        //replicateTeamMembers();
        
        Map<String, atmWrapper> afterCustRespRoles = refreshData();
        
        // Copy team members and data up the worksite tree
        replicateTeamMembers(beforeCustRespRoles, afterCustRespRoles);
        
        // Refresh the page to avoid any issues (if successful)
        return goback();
    }

    // Edit a speciffic team member
    public PageReference salesTeamMemberEdit() {
        atmId = apexpages.currentpage().getparameters().get('atmId'); 
        mode = 'salesTeamMemberEdit';
        editMember = atmDetailMap.get(atmId);
        return null;
    }
    public PageReference salesTeamMemberEdit_Save() {
        
        Map<String, atmWrapper> beforeCustRespRoles = refreshData();
        
        
        // Error check the record isn't a duplicate customer responsible role
        for (accountTeamMember a : accountTeamMembers)
        {
            if (a.id != editmember.atm.id && a.TeamMemberRole.containsIgnoreCase(uniqueRoleString) && editMember.atm.TeamMemberRole == a.TeamMemberRole)
            {
                 
                editmember.atm.TeamMemberRole.addError(Label.Customer_responsible_already_exists);
                return null;
                
            }
        }
        
        if(validateAccessLevelsUI(editMember)){
            
            // Save the AccountTeamMember
            update editMember.atm;
        } else{
            
            //This means that an access level violation happened
            return null;
        }
        
        
        
        
        // Query for existing shares, and update it as at this point we already validated access level
        Map<Id,AccountShare> existingShares = new Map<Id,AccountShare>([select id from AccountShare where AccountID=:acct.Id and UserOrGroupId=:editMember.atm.userId]);
        if (existingShares.containsKey(editmember.accShare.Id))
        {
            update editmember.accShare;
        } 
        
        
        Map<String, atmWrapper> afterCustRespRoles = refreshData();
        
        // Copy team members and data up the worksite tree
        replicateTeamMembers(beforeCustRespRoles, afterCustRespRoles);
        
        // Refresh the page to avoid any issues (if successful)
        return goback();
    }

    // Go back and reset the panel
    public PageReference goback() {
        refreshData();
        mode = 'standard';
        displayAccess = false;
        return null;
    }


    /**** **** **** **** **** **** **** Utility functions **** **** **** **** **** **** ****/
    // Wrapper combining account team members and shares by user
    public class atmWrapper {
        public AccountTeamMember atm {get;set;}
        public AccountShare accShare {get;set;}
        //public String accountAccess = accShare.AccountAccessLevel;
        //public String opportunityAccess = accShare.OpportunityAccessLevel;
        //public String caseAccess = accShare.CaseAccessLevel;
        public atmWrapper(AccountTeamMember atm, AccountShare accShare)
        {
            this.atm = atm;
            this.accShare = accShare;
        }
        public atmWrapper()
        {
            this.atm = new AccountTeamMember();
            this.accShare = new AccountShare();
        }
    }
    
    // Generic refresh of the main data used in the panel
    Map<String, atmWrapper> refreshData() {
        
        Map<String, atmWrapper> currentCustRespAtmMap = new Map<String, atmWrapper>();
        
        atmMap = new Map<Id,AccountTeamMember>([
            SELECT Id, AccountId, Account.Name, TeamMemberRole,UserId, AccountAccessLevel, SystemModstamp
            , User.Name, User.Email, User.Title, User.Phone, User.Team__c
            FROM AccountTeamMember 
            where AccountId = :acct.Id 
            order by LastModifiedDate limit 999
        ]);
        
        AccountShare[] accShares = [
            SELECT Id, AccountId, AccountAccessLevel, CaseAccessLevel, OpportunityAccessLevel, UserOrGroupId
            FROM AccountShare 
            WHERE AccountId = :acct.Id
        ];
        
        Map<id,AccountShare> accShareByUserOrGroupId = new Map<id,AccountShare>();
        Organization org = UTIL_Meta.getOrgInfo();
        for (AccountShare a : accShares)
        { 
            accShareByUserOrGroupId.put(a.UserOrGroupId, a);
        } 
        for (AccountTeamMember atm : accountTeamMembers)
        {
            AccountShare shareRecord = new AccountShare();
            // Deal with a blank. This is usually due to the OWD being used instead
            shareRecord.AccountId = acct.id;
            shareRecord.AccountAccessLevel = org.DefaultAccountAccess;
            shareRecord.CaseAccessLevel = org.DefaultCaseAccess;
            shareRecord.OpportunityAccessLevel = org.DefaultOpportunityAccess;
            shareRecord.UserOrGroupId = atm.UserId; 
            if (accShareByUserOrGroupId.containsKey(atm.UserId))
            {
                // Share record found for this relationship, use this, not the default access level
                shareRecord = accShareByUserOrGroupId.get(atm.UserId);
            }
            
            atmWrapper aw = new atmWrapper(atm, shareRecord);
            atmDetailMap.put(atm.Id, aw);
            currentCustRespAtmMap.put(atm.TeamMemberRole, aw);
        }
        
        return currentCustRespAtmMap;
    }

    // Provide the VF page with the defaults to enable the drop downs to be reduced in size
    public String getDefaultAccountAccessLevel() {
        Organization org = UTIL_Meta.getOrgInfo();
        return (string)org.DefaultAccountAccess;
    }
    public String getDefaultOpportunityAccessLevel() {
        Organization org = UTIL_Meta.getOrgInfo();
        return (string)org.DefaultOpportunityAccess;
    }
    public String getDefaultCaseAccessLevel() {
        Organization org = UTIL_Meta.getOrgInfo();
        return (string)org.DefaultCaseAccess;
    }
    
    // Ensure that account shares do not violate the OWD's
    Boolean validateAccessLevelsUI(atmWrapper a) {
        
        if (!(a.accShare.AccountAccessLevel!=null && a.accShare.OpportunityAccessLevel!=null && a.accShare.CaseAccessLevel!=null))
        {
            if (validateAccessLevels(a) == 1) a.accShare.AccountAccessLevel.addError(Label.All_Fields_Must_Have_A_Value_warning);
            if (validateAccessLevels(a) == 2) a.accShare.OpportunityAccessLevel.addError(Label.All_Fields_Must_Have_A_Value_warning);
            if (validateAccessLevels(a) == 3) a.accShare.CaseAccessLevel.addError(Label.All_Fields_Must_Have_A_Value_warning);
            
            return false;
        } 
        else if (validateAccessLevels(a) == 4) {
            a.atm.TeamMemberRole.addError(Label.All_Fields_Must_Have_A_Value_warning);
            return false;
        }
        else if (validateAccessLevels(a) == 5) {
            a.accShare.AccountAccessLevel.addError(Label.Access_Level_is_lower_than_Org_Wide_setting);
            return false;
        }
        else if (validateAccessLevels(a) == 6) {
            a.accShare.OpportunityAccessLevel.addError(Label.Access_Level_is_lower_than_Org_Wide_setting);
            return false;
        }
        else if (validateAccessLevels(a) == 7) {
            a.accShare.CaseAccessLevel.addError(Label.Access_Level_is_lower_than_Org_Wide_setting);
            return false;
            
        }else if (validateAccessLevels(a) == 8) {
            a.accShare.AccountAccessLevel.addError(Label.Access_Level_is_higher_than_Org_Wide_setting);
            return false;
        }
        else if (validateAccessLevels(a) == 9) {
            a.accShare.OpportunityAccessLevel.addError(Label.Access_Level_is_higher_than_Org_Wide_setting);
            return false;
        }
        else if (validateAccessLevels(a) == 10) {
            a.accShare.CaseAccessLevel.addError(Label.Access_Level_is_higher_than_Org_Wide_setting);
            return false;
            
        } else{
            return true;
        }
        
    }
    Integer validateAccessLevels(atmWrapper a) {
    
        if (!(a.accShare.AccountAccessLevel!=null && a.accShare.OpportunityAccessLevel!=null && a.accShare.CaseAccessLevel!=null))
        {
            if (a.accShare.AccountAccessLevel==null) 
                return 1;
            else if (a.accShare.OpportunityAccessLevel==null) 
                return 2; 
            else 
                return 3; 
        } 
        else if (a.atm.TeamMemberRole==null) {
            return 4; 
        }
        else if (lowerThanOWD(a.accShare.AccountAccessLevel, org.DefaultAccountAccess)) {
            return 5;
        }
        else if (lowerThanOWD(a.accShare.OpportunityAccessLevel, org.DefaultOpportunityAccess)) {
            return 6;
        }
        else if (lowerThanOWD(a.accShare.CaseAccessLevel, org.DefaultCaseAccess)) {
            return 7;
        }
        else if (higherThanOWD(a.accShare.AccountAccessLevel, org.DefaultAccountAccess)) {
            return 8;
        }
        else if (higherThanOWD(a.accShare.OpportunityAccessLevel, org.DefaultOpportunityAccess)) {
            return 9;
        }
        else if (higherThanOWD(a.accShare.CaseAccessLevel, org.DefaultCaseAccess)) {
            return 10;
        } else{
            
            return 0;
        }
    }
    Boolean lowerThanOWD(String accessLevel, String OWD){
        
        if(accessRank.get(accessLevel) < accessRank.get(OWD))
            return true;
        else 
            return false;
        
    }
    Boolean higherThanOWD(String accessLevel, String OWD){
        
        if(accessRank.get(accessLevel) > accessRank.get(OWD))
            return true;
        else 
            return false;
    }
    
    //This automated check and fix will be applied to Add Default Team option
    AccountShare[] checkMinimumAccessLevels(AccountShare[] accShares) {
        AccountShare[] noncompliantShares = new AccountShare[]{};
        for (Integer i = 0; i<accShares.size(); i++)
        {
            AccountShare a = accShares[i];
            AccountShare faultyShare = checkMinimumAccessLevels(accShares[i]);
            if (faultyShare!=null) {
                noncompliantShares.add(a);
                accShares.remove(i);
                i--;
            }
        }
        return noncompliantShares;
    }
    AccountShare checkMinimumAccessLevels(AccountShare a) {
        
        // A share must be set to an access level that is at least equal to the organization’s default Account access level. 
        // In addition, either the AccountAccessLevel, the OpportunityAccessLevel field, or the CaseAccessLevel field must be set higher 
        // than the organization’s default access level. In this case an error may be thrown, and no sharing record will be created. 
        
        
        
        // Check we haven't dipped below the org defaults
        if ((a.AccountAccessLevel == null || a.AccountAccessLevel == 'Read') 
            && org.DefaultAccountAccess == 'Edit') 
                a.AccountAccessLevel = 'Edit'; //Raise to EDIT
        if ((a.AccountAccessLevel == null) 
            && org.DefaultAccountAccess == 'Read') 
                a.AccountAccessLevel = 'Read'; //Raise to READ


        if ((a.CaseAccessLevel == null || a.CaseAccessLevel == 'Read') 
            && org.DefaultCaseAccess == 'Edit') 
                a.CaseAccessLevel = 'Edit'; //Raise to EDIT
        if ((a.CaseAccessLevel == null) 
            && org.DefaultCaseAccess == 'Read') 
                a.CaseAccessLevel = 'Read'; //Raise to READ

        if ((a.OpportunityAccessLevel == null || a.OpportunityAccessLevel == 'Read') 
            && org.DefaultOpportunityAccess == 'Edit') 
                a.OpportunityAccessLevel = 'Edit'; //Raise to EDIT
        if ((a.OpportunityAccessLevel == null) 
            && org.DefaultOpportunityAccess == 'Read') 
                a.OpportunityAccessLevel = 'Read'; //Raise to READ

        // Check at least ONE of these is higher than the org default
        // If so, remove it from this list and return it in the noncompliantShares list
        Integer elevated = 0;
        if (org.DefaultAccountAccess == 'Read' && 
            (a.AccountAccessLevel == 'Edit' || a.AccountAccessLevel == 'Full')) elevated++;
        if (org.DefaultCaseAccess == 'Read' && 
            (a.CaseAccessLevel == 'Edit' || a.CaseAccessLevel == 'Full')) elevated++;
        if (org.DefaultOpportunityAccess == 'Read' && 
            (a.OpportunityAccessLevel == 'Edit' || a.OpportunityAccessLevel == 'Full')) elevated++;

        if (elevated==0) {
            System.debug(LoggingLevel.ERROR,'### Non compliant share with no levels higher than OWD. OWD:  '+ org +' Share: '+ a);
            return a; // It is non compliant, send it back
        }

        return null; // A Null value indicates the record has passed / been adjusted already
    }
    
    
    
    void replicateTeamMembers(Map<String, atmWrapper> beforeCustRespRoles, Map<String, atmWrapper> afterCustRespRoles){
        
        /*
        // 1- Here we prepare all assets that will be used to process the replication logic
        */
        //These are the custom settings that controls the replication logic
        map<String, AccountTeamMemberRolesToSync__c> rolesToSync = UTIL_OrgSettings.AccountTeamMemberRolesToSync();
        map<String,AccountTeamMemberToAccountMapping__c[]> atm2AccMap = UTIL_OrgSettings.AccountTeamMemberToAccountMapping_ByRole();
        
        //Retrieve details about child accounts and corresponding ATM's
        map<Id,Account> childAccounts = new map<Id,Account> ([ SELECT id, parentId, name 
                                        FROM Account 
                                        WHERE Parentid = :acct.Id
                                        AND RecordTypeid = :UTIL_Meta.getAccountWorkSiteRT()]);
        AccountTeamMember[] oldChildAtms = [select id, TeamMemberRole, AccountId, UserId,SystemModstamp, User.Name, User.Email, User.Title,
                                        User.Phone, User.Team__c
                                        FROM AccountTeamMember 
                                        WHERE AccountId in :childAccounts.keySet()];
        
        
        // Get the latest copies of accounts and their mapped fields
        Set<id> accountIds = new Set<id>(childAccounts.keySet());
        accountIds.add(acct.id);
        String accountQuery = buildAccountQueryFields();
        Map<Id,Account> allAccounts = new Map<Id,Account>();
        for (Account a : Database.Query('select '+accountQuery+' from Account where id in :accountIds'))
        {
            allAccounts.put(a.id, a);
        }
        
        Account currentAccount;
        Map<Id,Account> accountsToReplicate = new Map<Id,Account>();
        for(Account a : allAccounts.values()){
            
            if(a.id == acct.id)
                currentAccount = a;
            else 
                accountsToReplicate.put(a.id, a);
                
        }
        
        // Get the latest team member records for all accounts and update the fields. (Not just those we have edited but also existing records too)
        map<id, AccountTeamMember[]> accountATMs = new map<id,AccountTeamMember[]>();
        String atmQuery = buildAtmQueryFields();
        AccountTeamMember[] requeriedAtms = Database.query('select '+atmQuery+' from AccountTeamMember where AccountId in :accountIds');
        for (AccountTeamMember atm : requeriedAtms)
        {
            AccountTeamMember[] atmsToAssign = new AccountTeamMember[]{};
            atmsToAssign = accountATMs.containsKey(atm.accountId) ? accountATMs.get(atm.accountId) : atmsToAssign;
            atmsToAssign.add(atm);
            accountATMs.put(atm.AccountId,atmsToAssign);
        }
        System.debug(LoggingLevel.INFO,'### Latest team member records for all accounts: accountATMs'+accountATMs);
        
        
        //Calculate the deleted, added and modified roles based on previous and current Customer Roles
        Map<String, atmWrapper> deletedRolesMap = new Map<String, atmWrapper>();
        Map<String, atmWrapper> addedRolesMap = new Map<String, atmWrapper>();
        
        for(String beforeRole : beforeCustRespRoles.keySet()){
            
            if(!afterCustRespRoles.containsKey(beforeRole)){
                
                deletedRolesMap.put(beforeRole, beforeCustRespRoles.get(beforeRole));
                
            } 
            
        }
        for(String afterRole : afterCustRespRoles.keySet()){
            
            if(!beforeCustRespRoles.containsKey(afterRole)){
                
                addedRolesMap.put(afterRole, afterCustRespRoles.get(afterRole));
            }
            
        }
        
        
        
        //This map gives the list of ATMs in child accounts for every role
        Map<String, AccountTeamMember[]> roleOldChildAtms = new Map<String, AccountTeamMember[]>();
        for(AccountTeamMember oldChildAtm : OldChildAtms){
            
            AccountTeamMember[] atms = roleOldChildAtms.containsKey(oldChildAtm.TeamMemberRole) ? roleOldChildAtms.get(oldChildAtm.TeamMemberRole) : new AccountTeamMember[]{};
            atms.add(oldChildAtm);
            roleOldChildAtms.put(oldChildAtm.TeamMemberRole, atms);
            
            
        }
        
        /*
        // 2- This block replicate the removed roles from LE either as a result of an ATM deletion or as a result of
        // of changing a role for an ATM
        */
        if (deletedRolesMap.size()>0)
        {
            AccountTeamMember[] childAccountATMsToRemove = new AccountTeamMember[]{};
            
            // Loop through the old members
            for (AccountTeamMember oldAtm : oldChildAtms)
            {
                if(rolesToSync.containsKey(oldAtm.TeamMemberRole)){
                    // If this role exists in the deleted items list then it should be removed
                    if (deletedRolesMap.containsKey(oldAtm.TeamMemberRole) )
                    {
                        childAccountATMsToRemove.add(oldAtm);
                    }
                }
            }

            // Remove those marked
            System.debug(LoggingLevel.INFO,'### Removing child account team members: '+childAccountATMsToRemove);
            if (childAccountATMsToRemove.size()>0) delete childAccountATMsToRemove;
            
            
        }
        
        
        /*
        // 3- This block replicate the added roles from LE either as a result of an ATM addition or as a result of
        // of changing a role for an ATM
        */
        if (addedRolesMap.size()>0)
        {
            
            //We delete all ATMs in Child accounts that match these roles and then recreate them as per LE
            AccountTeamMember[] childAccountATMsToRemove = new AccountTeamMember[]{};
            for(String addedRole : addedRolesMap.keySet()){
                
                if(rolesToSync.containsKey(addedRole)){
                    
                    if(roleOldChildAtms.get(addedRole) != null)
                        childAccountATMsToRemove.addAll(roleOldChildAtms.get(addedRole));
                }
            }
            
            // Remove those marked
            System.debug(LoggingLevel.INFO,'### Removing child account team members: '+childAccountATMsToRemove);
            if (childAccountATMsToRemove.size()>0) delete childAccountATMsToRemove;
            
            AccountTeamMember[] childAccountATMsToUpsert = new AccountTeamMember[]{};
            for(String addedRole : addedRolesMap.keySet()){
                
                if(rolesToSync.containsKey(addedRole)){
                    
                    for(Account childAccount : childAccounts.values()){
                        
                        childAccountATMsToUpsert.add(
                            
                            new AccountTeamMember(
                                accountId = childAccount.Id,
                                userId = addedRolesMap.get(addedRole).atm.userId,
                                TeamMemberRole = addedRole
                            )
                        );
                        
                    }
                }
                
                    
            }
            
            if(childAccountATMsToUpsert.size()>0) upsert childAccountATMsToUpsert;
            
        }
        
        /*
        // 4- This block will update the Account fields in LE and WS for the removed/added roles either 
        // as a result of an ATM deletion or as a result of changing a role for an ATM
        */
        //This code update Accounts fields for the current Account
        for (AccountTeamMemberToAccountMapping__c fieldMap : UTIL_OrgSettings.AccountTeamMemberToAccountMapping().values())
        {
            if(deletedRolesMap.containsKey(fieldMap.Account_Team_Member_Role__c)){
                
                currentAccount.put(fieldMap.DestinationField__c,'');
            }
            
            if(addedRolesMap.containsKey(fieldMap.Account_Team_Member_Role__c))
            {
                
                AccountTeamMember atm = addedRolesMap.get(fieldMap.Account_Team_Member_Role__c).atm;
                currentAccount = updateAccountFields(currentAccount, fieldMap, atm);
                
            }
            
            update currentAccount;
        }
        //This code update Accounts fields for child Accounts
        for (Account a : accountsToReplicate.values())
        {
            
            Boolean updated = false;    
            
            for (AccountTeamMemberToAccountMapping__c fieldMap : UTIL_OrgSettings.AccountTeamMemberToAccountMapping().values())
            {   
                
                System.debug(LoggingLevel.INFO, '### fieldMap:' + fieldMap);
                if(deletedRolesMap.containsKey(fieldMap.Account_Team_Member_Role__c) && rolesToSync.containsKey(fieldMap.Account_Team_Member_Role__c)){
                    
                    // Ensure we only update those accounts that need to be updated to avoid database locks
                    if (a.get(fieldMap.DestinationField__c)!=null && a.get(fieldMap.DestinationField__c)!='')
                    {
                        a.put(fieldMap.DestinationField__c,'');
                        updated = true;
                    }
                }
                
                if(addedRolesMap.containsKey(fieldMap.Account_Team_Member_Role__c) && rolesToSync.containsKey(fieldMap.Account_Team_Member_Role__c))
                {
                    AccountTeamMember atm = addedRolesMap.get(fieldMap.Account_Team_Member_Role__c).atm;
                    System.debug(LoggingLevel.INFO, '### atm' + atm);
                    
                    a = updateAccountFields(a, fieldMap, atm);
                    if(a != null)   
                        updated = true;
                    else {
                        updated = false;
                    }
                        
                }
                
                
            }
            System.debug(LoggingLevel.INFO,'### Cleared all mapped fields on the account: '+a);
            
            
            // If no Account team members where copied, pop that account from the list
            if (!updated) 
            {
                accountsToReplicate.remove(a.Id);
            }
        } 

        // Update the accounts with new ATM information
        System.debug(LoggingLevel.INFO, '### Accounts to replicate '+accountsToReplicate);
        if (accountsToReplicate.size()>0) update accountsToReplicate.values();
        
        
        /*
        // 5- This block will handle the last steps of replication logic
        */
        // Note the account page will now require reloading to avoid database conflicts
        refreshPage = true;

        // Log reported errors
        UTIL_Error.writeNow();

        System.debug(LoggingLevel.INFO, '### Completed AuditTeamMembers');
    }
    
    Account updateAccountFields(Account a, AccountTeamMemberToAccountMapping__c fieldMap, AccountTeamMember atm){
        
        try{
                        
            // If the field is on a related object a different syntax is needed
            if(fieldMap.sourceField__c.contains('.')){
                
                System.debug(LoggingLevel.INFO, '### fieldMap.sourceField__c:' + fieldMap.sourceField__c);
                a.put(fieldMap.DestinationField__c, 
                    
                    atm.getSObject(
                    
                        fieldMap.sourceField__c.subString(0,fieldMap.sourceField__c.indexOf('.'))).get(fieldMap.sourceField__c.subString(fieldMap.sourceField__c.indexOf('.')+1)
                    )
                );
                System.debug(LoggingLevel.INFO, '### Updated account field '+fieldMap.DestinationField__c+' with '+ atm.getSObject(fieldMap.sourceField__c.subString(0,fieldMap.sourceField__c.indexOf('.'))).get(fieldMap.sourceField__c.subString(fieldMap.sourceField__c.indexOf('.')+1)));
            }
            else{
                a.put(fieldMap.DestinationField__c, atm.get(fieldMap.sourceField__c));           
                System.debug(LoggingLevel.INFO, '### Updated account field '+fieldMap.DestinationField__c+' with '+atm.get(fieldMap.sourceField__c));                   
            }
            
            return a;
            
        }
        catch(SObjectException e){
            // Fail silently but log the issue
            String errorMsg = 'Cannot copy accountTeamFields to account on '+a.Id+'.';
            errorMsg += 'Non Compatible fields in Custom setting. Sourcefield: ' + fieldMap.sourceField__c + ' Doesnt match its destination field: ' + fieldMap.DestinationField__c;
            errorMsg += ' Error is: ' + e;
            UTIL_Error.report(errorMsg);
            return null;
        }
        
        
    }
    
    /*
    // Class Utility methods
    */

    String buildAtmQueryFields() {
        // Pick out the fields from the mapped roles and create a string of fields that are query compatible
        String fieldMap_SourceFields = 'Id, AccountAccessLevel, AccountId, CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, SystemModstamp, TeamMemberRole, UserId';
        Map<String, AccountTeamMemberToAccountMapping__c> mappedRoles = UTIL_OrgSettings.AccountTeamMemberToAccountMapping();
        for (AccountTeamMemberToAccountMapping__c m : mappedRoles.values())
        {
            fieldMap_SourceFields += fieldMap_SourceFields.containsIgnoreCase(m.SourceField__c) ? '' : ', '+m.SourceField__c;
        }
        return fieldMap_SourceFields;
    }

    String buildAccountQueryFields() {
        // Pick out the fields from the mapped roles and create a string of fields that are query compatible
        String fieldMap_DestinationFields = 'Id, CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, SystemModstamp';
        Map<String, AccountTeamMemberToAccountMapping__c> mappedRoles = UTIL_OrgSettings.AccountTeamMemberToAccountMapping();
        for (AccountTeamMemberToAccountMapping__c m : mappedRoles.values())
        {
            fieldMap_DestinationFields += fieldMap_DestinationFields.containsIgnoreCase(m.DestinationField__c) ? '' : ', '+m.DestinationField__c;
        }
        return fieldMap_DestinationFields;
    }
}