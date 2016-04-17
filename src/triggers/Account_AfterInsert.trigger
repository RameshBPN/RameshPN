/**
    About
    -----
    Description: Before Insert Trigger on Account
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1. Filters out WSs with the Parent field populated (connected to a LE).
        2. Filters External Provider Party ID for Automatic Account Parenting
        3. Filters External Provider Party Parent Id for Automatic Account Parenting
        4. Filters based on RecordType Legal Entity & Work Site for creating Sales Area Information
        5. Delete Involved Party Record for all Accounts
        
    Update History
    --------------
    Created April 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
        
*/
trigger Account_AfterInsert on Account (after insert) {
    List<Account> newWorksiteOnExistingLeList = new List<Account>();
    List<Account> newExtProviderAccountlst = new List<Account>();
    List<Account> newExtProviderAccountParentlst = new List<Account>();
    Map<String, Account> newExternalProviderIdInserted = new Map<String, Account>();
    Map<String, Account> newParentExternalProviderIdInserted = new Map<String, Account>();
    Map<Id, Account> newInfoForAccountCreated = new Map<Id, Account>();
    Set<Id> newAccountCreated = new Set<Id>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {	// Allow users to disable Triggers.
	    
	    String profileName = UTIL_Meta.profileName(UserInfo.getProfileId());
	    // Creating Lists and Maps based on filter criteria
	    for(Account a : trigger.new) {
	        
	        //Filter 1
	        if(a.ParentId != null && a.RecordTypeId == UTIL_Meta.getAccountWorksiteRT()) {
	            newWorksiteOnExistingLeList.add(a);
	        }
	        // Filter 2
	        if (a.External_Provider_Party_Id__c != null) {
	            newExternalProviderIdInserted.put(a.External_Provider_Party_Id__c, a);
	        }
	        // Filter 3
	        if (a.External_Provider_Party_Parent_ID__c != null) {
	            newParentExternalProviderIdInserted.put(a.External_Provider_Party_Parent_ID__c, a);
	        }
	        // Filter 4
	        if(a.RecordTypeId != UTIL_Meta.getAccountInvoiceRecipientRT() && a.RecordTypeId != UTIL_Meta.getAccountPostNordOrgStructureRT()) {
	            if(profileName != UTIL_OrgSettings.Integration_Profile_Name()) {
	                newInfoForAccountCreated.put(a.Id, a);
	                newAccountCreated.add(a.CreatedById); 
	            }
	        }
	    }
	    
	    // Exectue logic in a service class
	    
	    //Filter 1
	    if(newWorksiteOnExistingLeList.size() > 0) {
	        G2O_Account_SVC.copyAccountTeamMembers(newWorksiteOnExistingLeList);
	    }
	    
	    // Filter 2
	    if(newExternalProviderIdInserted != null && !newExternalProviderIdInserted.isEmpty()) {
	        G2O_Account_SVC.externalPartyConnectExistingChildRecords(newExternalProviderIdInserted);
	    }
	    
	    // Filter 3
	    if(newParentExternalProviderIdInserted != null && !newParentExternalProviderIdInserted.isEmpty()) {
	        G2O_Account_SVC.externalPartyConnectExistingParentRecords(newParentExternalProviderIdInserted);
	    }
	    
	    // Filter 4
	    if(newInfoForAccountCreated != null && !newInfoForAccountCreated.isEmpty()) {
	        G2O_Account_SVC.createSalesAreaInformation(newInfoForAccountCreated, newAccountCreated);  
	    }
	    
	    G2O_Account_SVC.deleteInvolvedPartyIdRecord(trigger.new);
    
    
    }
}