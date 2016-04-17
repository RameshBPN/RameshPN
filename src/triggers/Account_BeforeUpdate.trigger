/**
    About
    -----
    Description: Before Update Trigger on Account
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Filters / Actions
    -----------------
        1. Filters out the records where the field "PN_Mark_As_Synced" chages from false to true because it is updated by CINT
        2. Filters out the records that has been updated and has the PN_Mark_As_Synced field set to false
        3. Re-apply double metaphone on name change
        5. Automatic Account Parenting based on External Provider Party Id (PAR Id) 
        6. Automatic Account Parenting based on External Provider Party Parent Id (PAR Parent Id)
        7. Copies FunctionalInbox Email of account on to the related contacts Email based  on filters.
        8. Detect those accounts that need to be duplicate checked again for Duplicate_checked__c =true.
        9. Detect those accounts that need to be duplicate checked again for External_Provider_Duplicate__c =true.
    10. Detect those accounts that need to be duplicate checked again for MODTager_Duplicate_checked__c =true.
    11. Detect those accounts that need to be duplicate checked again for MODInteressent_Duplicate_checked__c =true.
    12. Restricts account updates on certain fields if Do Not Update Automatically flag is set to true.
    13. Maintain Extension Addresses on update of related Worksite Addresses.
    14.  Those accounts that need to have the Postal Address Country copied to Registration Country
    16. The accounts associated with relationships should not be marked for deletion.
    17. Invoice recipients associated with relationships should not be updated
    Actions:
    -------
    1. If the Permission channel is changed then the field Permission Channel Timestamp populated with date, time and user who edited the field Permission Channel.
    2. If the field Permission is changed then the field Permission Timestamp populated with date, time and user who edited the field Permission.
        
    Update History
    --------------
    Created March 2013 - C.H.F.
    Updated May 2013 - A.B
    Updated May 2013 - R.M
    Updated August 2013 - C.H.F. - Cleaned up
    Updated April 2014 -Richa Tripathi
    Updated June 2014 - Ramesh T N - Updated Action 1 and Action 2
    Updated June 2015 - Madhav Kakani - Fluido Denmark - Placed code for the Contact Center project to normalise phone numbers
    Issues / TODOs
    -------------- 
    
*/
trigger Account_BeforeUpdate on Account (before update) {
    
    List<Account> withFlagsToUpdate = new List<Account>();
    List<Account> withSyncToUpdate = new List<Account>();
    List<Account> nameChanged = new List<Account>();
    List<Account> externalProviderIDChanged = new List<Account>();
    Map<String, Account> parIDChangedNew = new Map<String, Account>();
    Map<String, Account> parentParIDChanged = new Map<String, Account>();
    Set<String> parIdChangedOldSet = new Set<String>();
    List<Account> functionalInboxList = new List<Account>();
    List<Account> accDuplicateCheckList = new List<Account>();
    map<id,Account> oldAccDuplicateCheckList = new map<id,Account>();
    List<Account> accDuplicateCheckPARList = new List<Account>();
    List<Account> accDoNotUpdateNewList = new List<Account>();
    Map<Id,Account> accDoNotUpdateOldMap = new Map<Id,Account>();
    List<Account> updateExtensionAddressesList = new List<Account>();
    Map<Id,Account> updateExtensionAddressesOldMap = new Map<Id,Account>();
    Set<Account> accountsWhereCountryShouldBeCopied = new Set<Account>();
    list<Account> accountsNotDupeChecked = new list<Account>();    
    list<Account> wsWithParent = new list<Account>();
    list<Account> accountsMarkedForDeletion= new list<Account>();
    list<Account> invoiceRecipientAccounts= new list<Account>();
    Map<Id,Account> invoiceRecipientAccountsOldMap= new Map<Id,Account>();
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        
        String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();           
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        String extensionRT = UTIL_Meta.getAccountExtensionRT();
        String externalPartnerRT = UTIL_Meta.getAccountExternalPartnerRT();
        String competitorRT = UTIL_Meta.getAccountCompetitorRT();
        String privatePersonRT = UTIL_Meta.getPersonAccountRT();
        String invoiceRecipientRT=UTIL_Meta.getAccountInvoiceRecipientRT();
        // Creating Lists and Maps based on filter criteria
        for (Account acc : trigger.new) {
            
            // Filter 1
            if (acc.PN_Mark_As_Synced__c && !trigger.oldMap.get(acc.Id).PN_Mark_As_Synced__c) {
                withFlagsToUpdate.add(acc);
            }
            
            // Filter 2
            else {
                withSyncToUpdate.add(acc);
            }
            
            // Filter 3
            if (!acc.IsPersonAccount && acc.Name != trigger.oldMap.get(acc.Id).Name)
            {
                nameChanged.add(acc);
            }
            if (acc.IsPersonAccount && (acc.FirstName != trigger.oldMap.get(acc.Id).FirstName || acc.LastName != trigger.oldMap.get(acc.Id).LastName))
            {
                nameChanged.add(acc);
            }
            
            // Filter 4
            if(acc.recordTypeId == workSiteRT && acc.parentId != trigger.oldMap.get(acc.id).parentId && acc.parentId != null){
                wsWithParent.add(acc);
            }
            
            // Filter 5
            if (acc.External_Provider_Party_ID__c != Trigger.oldMap.get(acc.id).External_Provider_Party_ID__c) {
                if(acc.External_Provider_Party_ID__c != null) {
                    parIDChangedNew.put(acc.External_Provider_Party_ID__c,acc);
                    if(Trigger.oldMap.get(acc.id).External_Provider_Party_ID__c != null) {
                        parIdChangedOldSet.add(Trigger.oldMap.get(acc.id).External_Provider_Party_ID__c);
                    }
                }
            }
            
            // Filter 6
            if (acc.External_Provider_Party_Parent_ID__c != null && acc.External_Provider_Party_Parent_ID__c != Trigger.oldMap.get(acc.id).External_Provider_Party_Parent_ID__c) {
                parentParIDChanged.put(acc.External_Provider_Party_Parent_ID__c, acc);
            }
            
            // Filter 7
            if(acc.Functional_Inbox_Email__c != Trigger.oldMap.get(acc.id).Functional_Inbox_Email__c){
                functionalInboxList.add(acc);
            }
            
            // Filter 8
            if( (acc.Duplicate_checked__c == true ) && (acc.recordTypeId == legalEntityRT ||acc.recordTypeId == workSiteRT || acc.recordTypeId == privatePersonRT  )&&((acc.RecordTypeId !=  Trigger.oldMap.get(acc.id).RecordTypeId) || (acc.Name !=  Trigger.oldMap.get(acc.id).Name) || (acc.Postal_Address_City__c !=  Trigger.oldMap.get(acc.id).Postal_Address_City__c) || (acc.Postal_Address_Country__c !=  Trigger.oldMap.get(acc.id).Postal_Address_Country__c))){
                if(oldAccDuplicateCheckList.get(acc.id) == null){
                    accDuplicateCheckList.add(acc);
                    oldAccDuplicateCheckList.put(acc.id, Trigger.oldMap.get(acc.id));
                }
            }
            
            // Filter 9
            if(acc.External_Provider_Duplicate__c == true && ((acc.RecordTypeId !=  Trigger.oldMap.get(acc.id).RecordTypeId) || (acc.External_Provider_Party_ID__c !=  Trigger.oldMap.get(acc.id).External_Provider_Party_ID__c))){
                accDuplicateCheckPARList.add(acc);
            }
            
            // Filter 10 
            if((acc.MODTager_Duplicate_checked__c == true) && (acc.recordTypeId == legalEntityRT ||acc.recordTypeId == workSiteRT || acc.recordTypeId == privatePersonRT  )&& ((acc.RecordTypeId !=  Trigger.oldMap.get(acc.id).RecordTypeId) || (acc.MOD_Modtager_Number__c !=Trigger.oldMap.get(acc.id).MOD_Modtager_Number__c ))){
                if(oldAccDuplicateCheckList.get(acc.id) == null){
                    accDuplicateCheckList.add(acc);
                    oldAccDuplicateCheckList.put(acc.id, Trigger.oldMap.get(acc.id));
                }
            }
            
            // Filter 11
            if((acc.MODInteressent_Duplicate_checked__c ==true )&& (acc.recordTypeId == legalEntityRT ||acc.recordTypeId == workSiteRT || acc.recordTypeId == privatePersonRT)&&((acc.RecordTypeId != Trigger.oldMap.get(acc.id).RecordTypeId) || (acc.MOD_Interessent_Number__c !=Trigger.oldMap.get(acc.id).MOD_Interessent_Number__c))){
                if(oldAccDuplicateCheckList.get(acc.id) == null){
                    accDuplicateCheckList.add(acc);
                    oldAccDuplicateCheckList.put(acc.id, Trigger.oldMap.get(acc.id));
                }
            }
            
            //Filter 12
            if((UTIL_Meta.isIntegrationUser(UserInfo.getProfileId()) || acc.Process_as_Integration_User__c == true) && acc.Do_Not_Update_Address_Automatically__c == true && (acc.RecordTypeId == workSiteRT || acc.RecordTypeId == legalEntityRT || acc.RecordTypeId == externalPartnerRT || acc.RecordTypeId == competitorRT )){
                accDoNotUpdateNewList.add(acc);
                accDoNotUpdateOldMap.put(acc.Id,Trigger.oldMap.get(acc.id));
            }
            
            // Filter 13
            if(acc.RecordTypeId == workSiteRT){
                updateExtensionAddressesList.add(acc);
                updateExtensionAddressesOldMap.put(acc.Id,Trigger.oldMap.get(acc.id));
            }
            //Filter 14
            if (UTIL_Apex.empty(acc.Registration_Country__c) && (acc.recordTypeId == legalEntityRT || acc.recordTypeId == workSiteRT || acc.recordTypeId == extensionRT)) {
                accountsWhereCountryShouldBeCopied.add(acc);
            }
            // Filter 15
            if(acc.recordTypeId == legalEntityRT ||acc.recordTypeId == workSiteRT || acc.recordTypeId == privatePersonRT){
                accountsNotDupeChecked.add(acc);
            }
            
            // Filter 16
            if(acc.IsPersonAccount){
                if (acc.Deletion_Flag__pc&& !trigger.oldMap.get(acc.Id).Deletion_Flag__pc) {
                    accountsMarkedForDeletion.add(acc);
                }
            }
            else{
                if (acc.Deletion_Flag__c&& !trigger.oldMap.get(acc.Id).Deletion_Flag__c) {
                    accountsMarkedForDeletion.add(acc);
                }
            }
            // Filter 17
            //(82,83,84)check with business and add the extra conditions here
            if(!UTIL_Meta.isSalesAdminUser(UserInfo.getProfileId())){
                Boolean accMarkedForDeletion=acc.IsPersonAccount ? (acc.Deletion_Flag__pc&& !trigger.oldMap.get(acc.Id).Deletion_Flag__pc) : (acc.Deletion_Flag__c&& !trigger.oldMap.get(acc.Id).Deletion_Flag__c);
                //Accounts marked for deletion can be ignored here bcoz it is already coverd by 'filter 16' 
                if(!accMarkedForDeletion){
                    if(acc.RecordTypeId == invoiceRecipientRT){
                        invoiceRecipientAccounts.add(acc);
                        invoiceRecipientAccountsOldMap.put(acc.Id,Trigger.oldMap.get(acc.id));
                    }
                }
            }
            // Action 1
            if (acc.IsPersonAccount && acc.Permission_Channel__pc!= Trigger.oldMap.get(acc.id).Permission_Channel__pc){
                acc.Permission_Channel_timestamp__pc = System.NOW().Format() + ', ' + UserInfo.getName();
            } 
            
            // Action 2 
            if (acc.IsPersonAccount && (acc.Permission__pc!= Trigger.oldMap.get(acc.id).Permission__pc)){
                acc.Permission_Time_stamp__pc = System.NOW().Format() + ', ' + UserInfo.getName();
            }

            // Action 3 - This code is for the Contact Center project placed by Fluido Denmark
            acc.CC_Phone__c = UTIL_Apex.NormalisePhone(acc.Phone, acc.Postal_Address_Country__c);
            acc.CC_Mobile__c = UTIL_Apex.NormalisePhone(acc.Mobile_Phone__c, acc.Postal_Address_Country__c);
        }
        
        // Exectue logic in a service class
        
        // Filter 1
        if (withFlagsToUpdate.size() > 0) {     
            G2O_TransactionSecurityFlags_SVC.updateTransactionSecurityFlags(withFlagsToUpdate);
        }
        
        // Filter 2
        if (withSyncToUpdate.size() > 0) {      
            G2O_TransactionSecurityFlags_SVC.setSynchronizedToFalse(withSyncToUpdate);
        }
        
        // Filter 3
        if (nameChanged.size() > 0) {      
            G2O_Account_SVC.applySerchFirstNaming(nameChanged);
            system.debug(logginglevel.error, 'nameChanged: ' + nameChanged[0].short_name__c);
        }
        
        // Filter 4
        if(wsWithParent.size() > 0){
            G2O_Account_SVC.setProjectFieldsOnWsParentChanges(wsWithParent);
        }
        // Filter 5
        if(parIDChangedNew != null && !parIDChangedNew.isEmpty()) {
            G2O_Account_SVC.externalPartyConnectExistingChildRecordsUpdate(parIDChangedNew, parIdChangedOldSet);
        }
        
        // Filter 6
        if(parentParIDChanged.size() > 0) {
            G2O_Account_SVC.externalPartyConnectExistingParentRecords(parentParIDChanged);  
        }
        
        //Filter 7
        if(functionalInboxList.size() > 0){
            G2O_Account_SVC.manageFunctionalInboxes(functionalInboxList);
        }
        
        // Filter 8
        if(accDuplicateCheckList.size() > 0){
            system.debug(logginglevel.error, 'flag post shortName__c: ' + accDuplicateCheckList[0].Short_Name__c);   
            G2O_Account_SVC.flagToRecheckDuplicates(accDuplicateCheckList,oldAccDuplicateCheckList, trigger.newMap);
            system.debug(logginglevel.error, 'post flag update: ' + accDuplicateCheckList[0].id + ' ' + accDuplicateCheckList[0].duplicate_checked__c);   
        }
        
        // Filter 9
        if(accDuplicateCheckPARList.size() > 0){
            G2O_Account_SVC.flagToRecheckPARDuplicates(accDuplicateCheckPARList,G2O_PossibleDuplicateAccount_SVC.PAR);
        }
        
        //Filter 12
        if(accDoNotUpdateNewList.size() > 0){
            G2O_Account_SVC.doNotUpdateAutomatically(accDoNotUpdateNewList,accDoNotUpdateOldMap);
        }
        
        //Filter 13
        if(updateExtensionAddressesList.size() > 0){
            G2O_Account_SVC.updateExtensionAddresses(updateExtensionAddressesList, updateExtensionAddressesOldMap);
        }
        
        //Filter 14
        if (accountsWhereCountryShouldBeCopied.size() > 0) {
            G2O_Account_SVC.copyPostalAddressCountryToRegistrationCountry(accountsWhereCountryShouldBeCopied);
        }
        //Filter 15
        if(accountsNotDupeChecked.size() > 0 && G2O_Account_SVC.DUPCHECK_RUNNING == false){
            G2O_Account_SVC.checkForDuplicate(accountsNotDupeChecked);
        }  
        //Filter 16
        if(accountsMarkedForDeletion.size() > 0 ){
            G2O_Account_SVC.checkForAssociatedRelationShips(accountsMarkedForDeletion);
        }    
        // Filter 17
        if(invoiceRecipientAccounts.size() > 0){
            G2O_Account_SVC.checkForRelatedRelationShipsAssociatedWithInvoiceRecipients(invoiceRecipientAccounts,invoiceRecipientAccountsOldMap);
        }        
    }
}