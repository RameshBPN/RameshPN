/*
 * Apex Trigger: CC_Agent_Interface_BeforeInsert
 *
 * Description:
 *   Trigger to set name to users full name and check
 *   for duplicates
 *
 * Change Log:
 *   2015-05-31  Peter Friberg  Initial Development
 *
 */

trigger CC_Agent_Interface_BeforeInsert on CC_Agent_Interface__c (before insert) {
    if(UTIL_OrgSettings.isTriggersDisabled()) return;

    Set<Id> user_ids = new Set<Id>();
    for (CC_Agent_Interface__c agent : Trigger.new) {
        if (!UTIL_Apex.empty(agent.User__c)) {
            user_ids.add(agent.User__c);
        }
    }

    Map<Id,User> users_by_id = new Map<Id,User>([SELECT Id, Name FROM User WHERE Id IN :user_ids]);

    for (CC_Agent_Interface__c agent : Trigger.new) {
        if (users_by_id.containsKey(agent.User__c)) {
            agent.name = users_by_id.get(agent.User__c).Name;
        }
    }

    // Check for duplicates
    Map<Id,CC_Agent_Interface__c> agents =
        new Map<Id,CC_Agent_Interface__c>([
            SELECT Id, Name, User__c
            FROM   CC_Agent_Interface__c
            WHERE  User__c IN :user_ids
            ORDER  BY User__c ASC]);

    Set<Id> old_user_ids = new Set<Id>();
    for (CC_Agent_Interface__c agent : agents.values()) {
        old_user_ids.add(agent.User__c);
    }

    for (CC_Agent_Interface__c agent :Trigger.new) {
        if (old_user_ids.contains(agent.User__c)) {
            agent.User__c.addError(Label.CC_Duplicates_Not_Allowed);
        }
    }
}