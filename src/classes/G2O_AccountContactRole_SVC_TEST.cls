/**
    About
    -----
    Description: This class is used to test G2O_AccountContactRole_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: September 2013

    Details
    -------
    1. Tests automatic creation of AccountContactRole on account inserts, and the soft deletion flag
    2. Tests that a new ACRT is created when a contact changes from one account to another, and that the old ACRT remains
    3. Tests the ability to create a PAR owned ACRT
    4. Tests the PAR governed rules, an external provider relationship id can be added to a ACRT and a standard user
       Can't delete an ACRT with such an id defined
    5. Tests that it is not possible to delete a ACRT if the contact is directly linked to the account of the ACRT
    6. Tests that the primary role is automatically set on another ACRT if the current primary is deleted
    7. Tests that Person Accounts are not impacted by the ACRT functionality
    8. Tests that Permission channel and Permission fields functionality on Person Accounts 
        
    Update History
    --------------
    Created September 2013 - K.E.A.J.
    Tests merged from Sprint03_Intgr_AccountcontactRole_TEST - K.E.A.J
    Updated April 2014 - T.R.
    Updated June 2014 - T.N.R - Updated Test 8     
    Issues / TODOs
    --------------
        
*/
@isTest
private class G2O_AccountContactRole_SVC_TEST {

    // 1. Tests automatic creation of AccountContactRole on account inserts
    static testMethod void createAndRemoveNewAccountContact() 
    {
        UTIL_TestFactory.setUpOrg();
        // every contact when inserted should create a contact role
        Account a = UTIL_TestFactory.createAccount();
        insert a;
        Contact c = UTIL_TestFactory.createContact();
        c.accountId = a.Id;
        insert c;
        
        // confirm an ACRT is created
        Account_Contact_Role_Transaction__c[] roles = [Select a.PN_Synchronized__c, a.PN_Synchronization_Error__c, 
                                    a.PN_Synchronization_ErrorReasonCode__c, a.PN_Mark_As_Synced__c, a.Name, 
                                    a.Last_PN_Synchronized_Date__c, a.LastModifiedDate, a.LastModifiedById, 
                                    a.IsDeleted, a.Id, 
                                    a.External_Provider_Relationship_ID__c, a.CurrencyIsoCode, a.CreatedDate, 
                                    a.CreatedById, a.Contact__c, a.Account__c, a.Account_Contact_Role_SFID__c
                                    From Account_Contact_Role_Transaction__c a where Account__c = :a.id and Contact__c = :c.Id];
        System.assert(roles.size()==1, 'Incorrect number of account contact roles created. Expected 1, found '+roles.size());

        // Add a list of contacts to an account
        // every contact when inserted should create a contact role
        Contact[] cs = UTIL_TestFactory.createContacts();
        for(Contact ct:cs)
        {
            ct.accountId = a.Id;
        }
        insert cs;
        
        // confirm an ACR is created in both tables
        roles = [Select  a.PN_Synchronized__c, a.PN_Synchronization_Error__c, a.PN_Synchronization_ErrorReasonCode__c, 
                a.PN_Mark_As_Synced__c, a.Name, a.Last_PN_Synchronized_Date__c, a.LastModifiedDate, a.LastModifiedById, 
                a.IsDeleted, a.Id, a.External_Provider_Relationship_ID__c, 
                a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Contact__c, a.Account__c, a.Account_Contact_Role_SFID__c
                From Account_Contact_Role_Transaction__c a where Account__c = :a.id and Contact__c IN :cs];
        System.assert(roles.size()==cs.size(), 'Account contact role objects not in sync after multiple contacts added to account. Found '+roles.size()+', expected '+cs.size()); // in sync
        
    }    
    
    // 2. Tests that a new ACRT is created when a contact changes from one account to another, and that the old ACRT remains
    static testMethod void updateAccountOnContact() 
    {
        UTIL_TestFactory.setUpOrg();
        Account a = UTIL_TestFactory.createAccount();
        insert a;
        Contact c = UTIL_TestFactory.createContact();
        c.accountId = a.Id;
        insert c;
        
        Account_Contact_Role_Transaction__c[] roles = [Select  a.PN_Synchronized__c, a.PN_Synchronization_Error__c, 
                                    a.PN_Synchronization_ErrorReasonCode__c, a.PN_Mark_As_Synced__c, a.Name, a.Last_PN_Synchronized_Date__c, 
                                    a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                                    a.External_Provider_Relationship_ID__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Contact__c, 
                                    a.Account__c, a.Account_Contact_Role_SFID__c
                                    From Account_Contact_Role_Transaction__c a where contact__c = :c.id];
        
        System.assert(roles.size()>0,'Roles not created when inserting account then contact');
        
        Account b = UTIL_TestFactory.createAccount();
        insert b;
        
        c.accountId = b.Id;
        update c;
        
        Account_Contact_Role_Transaction__c[] roles2 = [Select  a.PN_Synchronized__c, a.PN_Synchronization_Error__c, 
                                    a.PN_Synchronization_ErrorReasonCode__c, a.PN_Mark_As_Synced__c, a.Name, a.Last_PN_Synchronized_Date__c, 
                                    a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                                    a.External_Provider_Relationship_ID__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Contact__c, a.Account__c, 
                                    a.Account_Contact_Role_SFID__c
                                    From Account_Contact_Role_Transaction__c a where contact__c = :c.id 
                                    ORDER BY a.CreatedDate];

        System.assert(roles2.size() == 2, 'There should be 2 ACRs after contact\'s account field was edited');
        System.assert(roles2[0].Account__c == a.Id, 'The account on the first ACR should not change');
        System.assert(roles2[1].Account__c == b.Id, 'The account on the second ACR should be the contact\'s new account');
    }
    
    // 3. Tests the ability to create a PAR owned ACRT
    static testMethod void createParOwnedNewAccountContactRole() 
    {
        UTIL_TestFactory.setUpOrg();
        Account a = UTIL_TestFactory.createAccount();
        insert a;
        Account b = UTIL_TestFactory.createAccount();
        insert b;
        Contact c = UTIL_TestFactory.createContact();
        c.accountId = a.id;
        insert c;
        
        Account_Contact_Role_Transaction__c roles = new Account_Contact_Role_Transaction__c();
        roles.External_Provider_Relationship_ID__c = 'someId';
        roles.Account__c = b.Id;
        roles.Contact__c = c.Id;
        insert roles;
        
        Account_Contact_Role_Transaction__c[] roles2 = [Select  a.PN_Synchronized__c, a.PN_Synchronization_Error__c, 
                                    a.PN_Synchronization_ErrorReasonCode__c, a.PN_Mark_As_Synced__c, a.Name, a.Last_PN_Synchronized_Date__c, 
                                    a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                                    a.External_Provider_Relationship_ID__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Contact__c, a.Account__c, 
                                    a.Account_Contact_Role_SFID__c
                                    From Account_Contact_Role_Transaction__c a where Contact__c = :c.id];
        System.assert(roles2.size() == 2, 'Could not create new PAR governed account contact role. AccountContactRole not created.');
    }
    
    // 4. Tests the PAR governed rules, an external provider relationship id can be added to a ACRT and a standard user
    // Can't delete an ACRT with such an id defined
    static testmethod void PARgovernedRoles()
    {
        UTIL_TestFactory.setUpOrg();
        User u = UTIL_TestFactory.createUser('test29763287@acme.com', 'Standard User');
        Account a = UTIL_TestFactory.createAccount();
        insert a;
        Account b = UTIL_TestFactory.createAccount();
        insert b;
        Contact c = UTIL_TestFactory.createContact();
        c.accountId = a.id;
        insert c;
                
        
        // Apply external party governance to an existing PAR relationship by filling in the relationship ID
        Account_Contact_Role_Transaction__c roles = new Account_Contact_Role_Transaction__c();
        roles.Account__c = b.Id;
        roles.Contact__c = c.Id;
        insert roles;
        
        roles.External_Provider_Relationship_ID__c = 'someId';
        
        try
        {
            update roles;
        } catch(exception e){
            System.assert(false,'Could not apply External Relationship ID to an éxisting account contact role relationship');
        }

        // Prevent deletion of a role governed by PAR, by a regular user
        System.runAs(UTIL_TestFactory.createUser('tester12352323@atest.com','Standard User'))
        {
            try
            {
                delete roles;
                System.assert(false,'Non integration or non admin users should not be able to delete an Account_Contact_Role_Transaction__c record when it is govarned by PAR');
            } catch(exception e){}
        }
    }
    
    // 5. Tests that it is not possible to delete a ACRT if the contact is directly linked to the account of the ACRT
    static testMethod void preventOrphans()
    {
        UTIL_TestFactory.setUpOrg();
        // Roles shouldn't be allowed to be removed from an account where the contacts are tied directly to the account 
        // (ie the Contact's AccountId is that account)
        // This is to prevent contacts from being decoupled
        
        User u = UTIL_TestFactory.createUser('test29763287@acme.com', 'Standard User');
        
        Account a = UTIL_TestFactory.createAccount();
        insert a;
        Account b = UTIL_TestFactory.createAccount();
        insert b;
        Contact c = UTIL_TestFactory.createContact();
        c.accountId = a.id;
        
        insert c;
        Account_Contact_Role_Transaction__c[] roless = [select id, Account__c, Contact__c, Account_Contact_Role_SFID__c, Account__r.External_Provider_Party_ID__c, Contact__r.External_Provider_Party_ID__c
                from Account_Contact_Role_Transaction__c where Account__c = :a.Id and Contact__c = :c.Id];
                
        System.runAs(u){
            try
            {
                delete roless;
                System.assert(false,'Non integration or non admin users should not be able to delete a ACR record if the contact references the account directly. A contact needs a minimum of one account contact role which should match its main account');
            } catch(exception e){}
            
            Account_Contact_Role_Transaction__c role = new Account_Contact_Role_Transaction__c();
            role.Account__c = b.Id;
            role.Contact__c = c.Id;
            insert role;
            
            try
            {
                delete role;
            } catch(Exception e)
            {
                System.assert(false,'Unable to remove an Account Contact Role Transaction record despite it not being PAR governed or the main account reference on the contact record');
            }
        }
    }
    
    // 6. Tests that the primary role is automatically set on another ACRT if the current primary is deleted
    static testMethod void automaticallyReplacePrimaryRoleOnDelete() {
        UTIL_TestFactory.setUpOrg();
        
        Test.startTest();
        Account a = UTIL_TestFactory.createAccount();
        insert a;
        Account b = UTIL_TestFactory.createAccount();
        insert b;
        Contact c = UTIL_TestFactory.createContact();
        c.accountId = a.id;
        insert c;
        
        Account_Contact_Role_Transaction__c primaryRole = [SELECT Id,IsPrimary__c FROM Account_Contact_Role_Transaction__c WHERE IsPrimary__c = true];
        
        // Create a none primary role
        Account_Contact_Role_Transaction__c role = new Account_Contact_Role_Transaction__c();
        role.Account__c = b.Id;
        role.Contact__c = c.Id;
        insert role;
        // Try to delete the primary role
        try{
            delete primaryRole;
        } catch(Exception e){
            Test.stopTest();
            System.assert(false,'Can\'t delete primary role');
        }
        Test.stopTest();
        role = [SELECT Id, IsPrimary__c FROM Account_Contact_Role_Transaction__c WHERE Id = :role.Id];
        System.assert(role.IsPrimary__c == true,'Primary role was not replaced with other role');
    }
    
    // 7. Tests that Person Accounts are not impacted by the ACRT functionality
    static testMethod void createRemovePersonAccount() 
    {
        UTIL_TestFactory.setUpOrg();
        // a person account can have a role created in the Transactional Account Contact Role table but it is not required
        try
        {
            Account a = UTIL_TestFactory.createPersonAccount();
            insert a;
            a.Deletion_Flag__c = true;
            update a;
            a.Deletion_Flag__c = false;
            update a;
            delete a;
            undelete a;
        }
        catch(Exception e)
        {
            System.assert(false,'Problems creating and removing Person Accounts: '+e.getMessage());
        }
    } 
    // 8. Tests that Permission channel and Permission fields functionality on Person Accounts 
    static testMethod void createPersonAccountRecord() 
    {
        UTIL_TestFactory.setUpOrg();
        // a person account can have a role created in the Transactional Account Contact Role table but it is not required
        try
        {
            Account a = UTIL_TestFactory.createPersonAccount();
            a.Email_Address__c='test@postnord.dk';           
            a.Permission_Channel__pc='Test_Data';
            a.Permission__pc=true;
            a.FirstName = 'TestFirstName';
            a.LastName = 'TestLastName';
            a.External_Provider_Party_ID__c='0011232832';
            a.Functional_Inbox_Email__c='test_insert@test.com';
            a.PN_Mark_As_Synced__c=false;
            a.External_Provider_Party_Parent_ID__c='12345678';
            a.External_Provider_Duplicate__c=true;
            a.MOD_Modtager_Number__c = '12345678';
            a.MOD_Interessent_Number__c='2345667890';
            insert a; 
                     
            a.Permission_Channel__pc='Test_Data1';
            a.FirstName = 'TestFirstName1';
            a.LastName = 'TestLastName1';
            a.Permission__pc=false;
            a.External_Provider_Party_ID__c='743764843';
            a.Functional_Inbox_Email__c='test_update@test.com';
            a.PN_Mark_As_Synced__c=true;
            a.External_Provider_Party_Parent_ID__c='123456789';
            a.Duplicate_checked__c=true;
            a.MODTager_Duplicate_checked__c=true;
            a.MOD_Modtager_Number__c = '1234567';
            a.MODInteressent_Duplicate_checked__c=true;
            a.MOD_Interessent_Number__c='23456678';
            update a;

        }
        catch(Exception e)
        {
            System.assert(false,'Problems creating and removing Person Accounts: '+e.getMessage());
        }
    }    
}