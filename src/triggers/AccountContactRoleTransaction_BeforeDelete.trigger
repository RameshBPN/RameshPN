/**
    About
    -----
    Description: Before Insert Trigger on Contact
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Filters:
    -------
        1. Prevent deletion of account contact roles what are governed by external party for normal users.
        2. Prevent leaving contact:account relatinships being orphaned by checking a role isn't removed if it is the only record representing the Contact:Account relationships
        3. Add all the ACRTs that has got the ACRT Compound ID (should be all deletions not done by integrations)
        4. Try to replace account on contact with the newest account contact role, when deleted
        
    Update History
    --------------
    Created April May - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    -------------- 
    
*/
trigger AccountContactRoleTransaction_BeforeDelete on Account_Contact_Role_Transaction__c (before delete) {
    
    Id profileID = Userinfo.getProfileId();
    String profileName = UTIL_Meta.profileName(profileID);
    List<Account_Contact_Role_Transaction__c> deletedByNonIntegrationACRTs = new List<Account_Contact_Role_Transaction__c>();
    List<Id> contactIds = new List<Id>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
    	
	    // Creating Lists and Maps based on filter criteria
	    for (Account_Contact_Role_Transaction__c role : trigger.old) {
	        
	        // Filter 1
	        if (!G2O_AccountContactRole_SVC.allowDeleteOfACR && role.Is_governed_by_External_Party__c && !(profileName == UTIL_OrgSettings.Integration_Profile_Name() || profileName == UTIL_OrgSettings.Administrator_Profile_Name())) {
	            role.addError('Non integration or non admin users is not allowed to delete an ACR record that is governed by an external party');
	        }
	
	        // Filter 2
	        if (!G2O_AccountContactRole_SVC.allowDeleteOfACR && !role.Contact__r.Deletion_Flag__c && role.IsPrimary__c && !(profileName == UTIL_OrgSettings.Integration_Profile_Name() || profileName == UTIL_OrgSettings.Administrator_Profile_Name())) {
	            role.addError('Non integration or non admin users is not allowed to delete an ACR record if the contact references the account directly. A contact needs a minimum of one account contact role which should match its main account');
	        }
	        
	        // Filter 3
            if (UTIL_Apex.isSet(role.Account_Contact_Role_SFID__c) && 
            					!UTIL_Meta.isIntegrationUser(profileId) &&
            					role.Is_Work_Site_and_Contact_Person__c) {
                deletedByNonIntegrationACRTs.add(role);
            }
            
            // Filter 4
            if (UTIL_Apex.isSet(role.Account_Contact_Role_SFID__c)) {
                contactIds.add(role.Contact__c);
            }
	    }
	    
	    // Exectue logic in a service class
	    
	    //Filter 3
	    if (deletedByNonIntegrationACRTs.size() > 0) {
	    	G2O_OutboundNotification_SVC.createDeleteNotifications(deletedByNonIntegrationACRTs);
	    }
	    
	    //Filter 4
	    if (contactIds.size() > 0) {
	    	G2O_AccountContactRole_SVC.updateAccountOnContact(contactIds);
	    }
    }
}