/**
    About
    -----
    Description: Service class for Triggers and Events surroundoing Account Contact Roles, especially Account_Contact_Role_Transaction__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    The service class will reflect every change from the ACRT custom object into the account contact role object to both B2B and B2C accounts and vice versa
	1. Create new roles based on a set of contacts
	2. Create new roles based on a list of accounts
	3. Create new roles based on an array of contacts
	4. Contact - account field changed on contact record - maps contact ids to old account ids
	5. Update the account on contacts
	6. Set the ACR compound id
        
    Update History
    --------------
    Created March 2013 - M.E.
    Updated May 2013 - M.E.  - ACRs only created if the Contact person Id is set
    Updated May 2013 - R.M - Created logic for ACR handling on Contact Create page & a private method to create ACR avoid code duplication.
    Updated June 2013 - C.H.F - Went through all the ACR code an updated/removed/added logic after new requirements and new understanding of the process (see work item 24 for details).
    Updated August 2013 - C.H.F - Postion fields moved from contact to ACR, added logic to handle duplicates and disabled deletion of ACR when account on contact is changed
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_AccountContactRole_SVC 
{   
    public static Boolean allowDeleteOfACR = false;             //If set to true it allow deletion of account contact role.
    
    //1. Create new roles based on a set of contacts
    public static void createRoles(Set<Contact> cs)
    {
        Contact[] csl = new Contact[]{};
        csl.addAll(cs);
        createRoles(csl);
    }
    
    //2. Create new roles based on a list of accounts
    public static void createRoles(List<Account> acctList)
    {
        Contact[] csl = [SELECT Id, Contact_Person_ID__c, accountId FROM Contact WHERE AccountId IN :acctList];
        createRoles(csl);
    }
    
    //3. Create new roles based on an array of contacts
    public static void createRoles(Contact[] cs)
    {
        Map<id,Contact[]> contactsByAccId = new Map<id,Contact[]>();
        for (Contact c : cs)
        {
            // We can only create ACRs if the contact has been given a contact person ID as this is part of the Key for integration
            // This ID is set by a field update workflow when inserting a contact
            if (!UTIL_Apex.empty(c.Contact_Person_ID__c))
            {
                Contact[] cts = new Contact[]{};
                if (contactsByAccId.containsKey(c.accountId))
                {
                    cts.addAll(contactsByAccId.get(c.accountId));
                }
                cts.add(c);
                contactsByAccId.put(c.accountId, cts);
            } else {
                throw new acrException('Contact is missing Contact Person ID');
            }
        }
        
        Account_Contact_Role_Transaction__c[] roles = new Account_Contact_Role_Transaction__c[]{};
        for (Account a : [select id,External_Provider_Party_ID__c, Involved_Party_ID__c from Account where id in :contactsByAccId.keySet()])
        {
            for (Contact c : contactsByAccId.get(a.id))
            {
                Account_Contact_Role_Transaction__c r = populateAcr(a, c);
                setKey(r, a.Involved_Party_ID__c, c.Contact_Person_ID__c);
                roles.add(r);
                
                
            }
        }
        upsert roles Account_Contact_Role_SFID__c;
        System.debug(Logginglevel.INFO,'@@ #AccountContactRole_SVC.createRoles()# Roles created '+roles);
    }
    
    // this private method is used to create ACR for trigger as well as Create Contact
    // Paramenters: particular account and its related contact
    // Returns a Account Contact Role
    private static Account_Contact_Role_Transaction__c populateAcr(Account a, Contact c) {
        
        Account_Contact_Role_Transaction__c r = new Account_Contact_Role_Transaction__c();
        r.Contact__c = c.id;
        r.Account__c = a.id;
        r.Ignore_ACR_Validation_Rules__c = true;
        return r;
    }
    
    // 4. Contact - account field changed on contact record - maps contact ids to old account ids
    public static void updateRoles(Map<Contact, Id> contactsWithOldAccountId)
    {
        Set<id> contactIds = new Set<id>();
        Set<String> compoundIds = new Set<String>();
        for (Contact c : contactsWithOldAccountId.keySet())
        {
            contactIds.add(c.Id);
            compoundIds.add(c.Id+':'+contactsWithOldAccountId.get(c));
        }
        
        Set<id> accountIds = new Set<id>();
        accountIds.addAll(contactsWithOldAccountId.values());
        
        Account_Contact_Role_Transaction__c[] rolesToRetire = new Account_Contact_Role_Transaction__c[]{};
        for (Account_Contact_Role_Transaction__c role : [select id,Contact__c, Account__c, Contact__r.accountId, Contact__r.Contact_Person_ID__c, Account__r.Involved_Party_ID__c 
                                                        from Account_Contact_Role_Transaction__c 
                                                        where Contact__c in :contactIds 
                                                        and Contact__r.accountId in :accountIds 
                                                        and Account__c in :accountIds])
        {
            if (compoundIds.contains(role.Contact__c+':'+role.Account__c))
            {
                rolesToRetire.add(role);
            }
        }
        createRoles(contactsWithOldAccountId.keySet());
    }
    
    // 5. Update the account on contacts
    //The method takes a list of contacts and changes the account field on the contacts to
    // the account with the most up to date ACR with the contact. It is used when the user deletes
    // the primary ACR on the contact.
    @future
    public static void updateAccountOnContact(List<Id> contactIds) {
        System.debug(logginglevel.Info, '### START AccountContactRole_SVC.updateAccountOnContact(' +contactIds+ ')');
        
        Account_Contact_Role_Transaction__c[] roles = [SELECT Id, Contact__c, Account__c, SystemModstamp
                                                       FROM Account_Contact_Role_Transaction__c
                                                       WHERE Contact__c IN :contactIds
                                                       AND IsPrimary__c = false
                                                       ORDER BY SystemModstamp DESC];
        
        System.debug(Logginglevel.ERROR, 'roles: ' + roles);                                               
        
        Contact[] contacts = [SELECT Id, AccountId
                              FROM Contact
                              WHERE Id IN :contactIds];
        
        System.debug(Logginglevel.ERROR, 'contacts: ' + contacts);  
        
        for(Contact c : contacts) {
            for(Account_Contact_Role_Transaction__c role : roles) {
                if(role.Contact__c == c.Id) {
                    c.AccountId = role.Account__c;
                    break; //takes the one with the newest SystemModstamp
                }
            }
        }
        System.debug(Logginglevel.ERROR, 'update contacts: ' + contacts);
        update contacts;                                               
        System.debug(logginglevel.Info, '### END AccountContactRole_SVC.updateAccountOnContact');                                              
    }

	// 6. Set the ACR compound id
    public static void setKey(Account_Contact_Role_Transaction__c role, String ipId, String cpId)
    {
        System.debug(Logginglevel.ERROR, 'ipId: ' + ipId);
        System.debug(Logginglevel.ERROR, 'cpId: ' + cpId);
        if (!UTIL_Apex.empty(cpId) && !UTIL_Apex.empty(ipId))
        {
            role.Account_Contact_Role_SFID__c = ipId + ':' + cpId;
        } else
        {
            role.Account_Contact_Role_SFID__c = null;
        }
        System.debug(Logginglevel.ERROR, 'role.Account_Contact_Role_SFID__c: ' + role.Account_Contact_Role_SFID__c);
    }
    
    public class acrException extends Exception {}
}