/**
    About
    -----
    Description: Before Insert Trigger on Account
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters:
    -------
        1.  Detect those accounts that need invovled party id's assigning
        2.  All: Encode the accounts with search first short cuts for the name (no spaces, and metaphone version)    
        3.  Maintain Extension Addresses with the related Worksite Addresses on Extension creation.
        4.  Those accounts that need to have the Postal Address Country copied to Registration Country
        
    Actions:
    -------
    1. If the Permission channel is filled out then the field Permission Channel Timestamp populated with date, time and user who edited the field Permission Channel.
    2. If the field Permission is filled out then the field Permission Timestamp populated with date, time and user who edited the field Permission.
         
    Update History
    --------------
    Created March 2013 - M.E.
    Updated April 2013 - C.H.F.
    Updated May 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    Updated April 2014-Richa Tripathi
    Updated June 2014 - Ramesh T N - Updated Action 1 and Action 2
    Updated June 2015 - Madhav Kakani - Fluido Denmark - Placed code for the Contact Center project to normalise phone numbers

    Issues / TODOs
    --------------  
    
*/
trigger Account_BeforeInsert on Account (before insert) {
    
    Account[] actsWithNoInvolvedPartyId = new Account[]{};
    Account[] updateExtensionAddressesList = new Account[]{};
    list<Account> accountsNotDupeChecked = new list<Account>();
    Set<Account> accountsWhereCountryShouldBeCopied = new Set<Account>();
    list<Account> wsWithParent = new list<Account>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        
        //Get the record types
        String lerTypeId = UTIL_Meta.getAccountLegalEntityRT();
        String wsrTypeId = UTIL_Meta.getAccountWorkSiteRT();
        String extrTypeId = UTIL_Meta.getAccountExtensionRT();
        String pprTypeId = UTIL_Meta.getPersonAccountRT();

        // Creating Lists and Maps based on filter criteria
        for(Account a : Trigger.new)
        {
            // Filter 1
            if (a.Involved_Party_ID__c==null)
            {
                actsWithNoInvolvedPartyId.add(a);
            }
            
            // Filter 3
            if (a.RecordTypeId == extrTypeId && a.ParentId != null && a.Do_Not_Update_Address_Automatically__c ==false)
            {
                updateExtensionAddressesList.add(a);
            }
            // Filter 4
            if (UTIL_Apex.empty(a.Registration_Country__c) && (a.recordTypeId == lerTypeId || a.recordTypeId == wsrTypeId || a.recordTypeId == extrTypeId)) {
                accountsWhereCountryShouldBeCopied.add(a);
            }
            
            // Filter 5
            if(a.recordTypeId == wsrTypeId && a.parentId != null){
                wsWithParent.add(a);
            }
            
            // Filter 6
            if ((!a.duplicate_checked__c || !a.MODInteressent_Duplicate_checked__c || !a.Modtager_Duplicate_Checked__c) && (a.recordTypeId == lerTypeId || a.recordTypeId == wsrTypeId || a.recordTypeId == pprTypeId)){
                accountsNotDupeChecked.add(a);
            }

            // Action 1
            if (a.IsPersonAccount && (String.isNotblank(a.Permission_Channel__pc))){
                a.Permission_Channel_timestamp__pc = System.NOW().Format() + ', ' + UserInfo.getName();
            } 
            
            // Action 2
            if (a.IsPersonAccount && a.Permission__pc == TRUE && a.Permission__pc != null){
                a.Permission_Time_stamp__pc = System.NOW().Format() + ', ' + UserInfo.getName();
            }

            // Action 3 - This code is for the Contact Center project placed by Fluido Denmark
            a.CC_Phone__c = UTIL_Apex.NormalisePhone(a.Phone, a.Postal_Address_Country__c);
            a.CC_Mobile__c = UTIL_Apex.NormalisePhone(a.Mobile_Phone__c, a.Postal_Address_Country__c);
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        G2O_Account_SVC.applyInvolvedPartyId(actsWithNoInvolvedPartyId);
        
        // Filter 2
        G2O_Account_SVC.applySerchFirstNaming(Trigger.new);
        
        // Filter 3
        G2O_Account_SVC.updateExtensionAddresses(updateExtensionAddressesList);
        
        // Filter 4
        if (accountsWhereCountryShouldBeCopied.size() > 0) {
            G2O_Account_SVC.copyPostalAddressCountryToRegistrationCountry(accountsWhereCountryShouldBeCopied);
        }
        
        // Filter 5
        if (wsWithParent.size() > 0){
            G2O_Account_SVC.setProjectFieldsOnWsParentChanges(wsWithParent);
        }
        
        //Filter 6 
        if (accountsNotDupeChecked.size() > 0){
            G2O_Account_SVC.checkForDuplicate(accountsNotDupeChecked);
        }
    }
}