/**
    About
    -----
    Description: Service class for General account Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    The trigger service class will reflect updates/inserts on Account Obj.
     1.  Maintain Extension Addresses : Copy the worksite address to extensions. Called when a worksite is updated.
     2.  Apply involved party numbering
     3.  Apply search first naming (double metaphone + short name)
     4.  Reflaggning accounts that were/are/will become duplicate of the accounts in the trigger
     5.  Set Delete Flag on child records.
     6.  Maintain Extension Addresses of Extensions with the related Worksite on Extension Inserts.
     7.  Copies the AccountTeamMember from the LE to the WS
     8.  Copies the new Account Id to accounts where PAR Parent ID equals PAR ID (After Insert)
     9.  Copies the new Account Id to accounts where PAR ID equals PAR Parent ID.
     10. Copies the new Account Id to accounts where PAR Parent ID equals PAR ID and removes children connection if any
     11. Create the Sales Area Information for the Accounts Created for LE & WS.
     12. Updates Functional Inbox_Email of account on the related contacts.
     13. Deletes PossibleDuplicateAccount__c record on deletion of related account record.
     14. Method to handle account field updates if "Do Not Update Automatically" is set.
     15a. Method to update fields on WS accounts when certain fields are updated on a LE account
     15b. Method to update fields on WS accounts when parent is either set or changed
     16. Method to copy Postal Address Country to Registration country for LE, WS and Extension accounts
     
    Update History
    --------------
    Created March 2013 - A.B.
    Refactored March 2013 - M.E.
    Updated May 2013 - R.M.
    Updated May 2014-Richa Tripathi
    Updated Aug 2014 - M.E. - Errors supressed for DML in: flagToRecheckDuplicates,flagToRecheckPARDuplicates and checkForDuplicate, as errors where interfering with API calls
      Updated Jan 2016 - Shridhar B - Updated the methods applyInvolvedPartyId, deleteInvolvedPartyIdRecord - for the New PN Internal customer range
      Updated Jan 2016 - Shridhar B - Created the methods applyPNInternalPartyIds, delayedDeletePNInternalInvolvedPartyID - for the New PN Internal customer range


    Issues / TODOs
    --------------  
*/

public with sharing class G2O_Account_SVC {

    public static List<ID> accDupCheckList = new List<ID>();//add all the account for checking duplicate
    public static boolean DUPCHECK_RUNNING = false;
    // 1. Maintain Extension Addresses of Extensions with the related Worksite on worksite update.
    public static void updateExtensionAddresses(List<Account> newAccounts,Map<Id, Account> oldAccountMap){
        Integer timeBefore = Limits.getCpuTime();
        System.debug(LoggingLevel.info,'*** START: <Account_SVC>.<updateExtensionAddresses>');
        try{
            
            system.debug(Logginglevel.INFO,'++newAccounts++'+newAccounts.size());
            system.debug(Logginglevel.INFO,'++newAccounts++'+newAccounts);
            
            List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
            fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
            
            List<sObject> extensionTobeUpdatedList = new List<sObject>();
            Map<Id, Account> newAccountMap = new Map<Id, Account>();
            set<Id> setAccId =new set<Id> ();
            
            //Filtering the records if any of the Address field from the field set is updated.
            for(Account worksiteAcc:newAccounts) {
                
                if(isWorksiteAddUpdated(worksiteAcc,oldAccountMap.get(worksiteAcc.Id),fieldSet) ){
                    
                    setAccId.add(worksiteAcc.Id);
                    newAccountMap.put(worksiteAcc.Id,worksiteAcc);
                }
            }
            
            for(Account extensionAcc:[Select Id,ParentId From Account where ParentId IN:setAccId  AND RecordType.DeveloperName='Extension' AND Do_Not_Update_Address_Automatically__c = false]){

                Account workSiteAcc = newAccountMap.get(extensionAcc.ParentId);
                
                //Copying address fields from Worksite to related Extensions.
                extensionTobeUpdatedList.add(copyAddressFields(extensionAcc,workSiteAcc,fieldSet));
            }
            
            update extensionTobeUpdatedList;
            
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++Exception+++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <Account_SVC>.<updateExtensionAddresses>');
    }
    
    //Identifies if any of the account address field present in the field set is changed.
    public static Boolean isWorksiteAddUpdated(Account newAccount,Account oldAccount,List<Schema.FieldSetMember> fieldSet){
        
        Boolean isUpdated = false;
        
        for(Integer i=0; i<fieldSet.size(); i++) {
            if(newAccount.get(fieldSet[i].getFieldPath()) != oldAccount.get(fieldSet[i].getFieldPath())){
                isUpdated = true;
                break;
            }
        }
        
        return isUpdated;
    }
    
    //Copies address fields from Worksite to related Extensions.
    public static sObject copyAddressFields(Account extensionAcc,Account workSiteAcc,List<Schema.FieldSetMember> fieldSet){
        Integer timeBefore = Limits.getCpuTime();
        sObject accRecord    = Account.SObjectType.newSObject();
        sObject wkSiteAcc    = (sObject)workSiteAcc;
        
        for(Integer i=0; i<fieldSet.size(); i++) {
            
            String fieldName = fieldSet[i].getFieldPath();
            system.debug(Logginglevel.INFO,'++fieldName+++'+fieldName);
            accRecord.put(fieldName,wkSiteAcc.get(fieldSet[i].getFieldPath()));
        }
        
        if(accRecord != null){
            accRecord.put('Id',extensionAcc.Id);
        }
        return accRecord;
    }
    
    
    // 2. Apply invovled party numbering
    public static void applyInvolvedPartyId(Account[] accs)
    {   Integer timeBefore = Limits.getCpuTime();
        Account[] externalAccs = new Account[]{};
        Account[] internalAccs = new Account[]{};
        Account[] pnInternalAccs = new Account[]{};    
        
        for (Account a: accs)
        {
            if (UTIL_Apex.empty(a.Involved_Party_ID__c))
            {
                if (a.External_or_Internal__c == LABEL.Customer_Type_Internal) {
                    internalAccs.add(a);                
                } else if((a.External_or_Internal__c == LABEL.Customer_Type_PN_DK) || (a.External_or_Internal__c == LABEL.Customer_Type_PN_SE)){ 
                    pnInternalAccs.add(a);                
                } else {
                    externalAccs.add(a);                
                }
            }
        }
        if(!internalAccs.isEmpty())
            applyInternalPartyIds(internalAccs);
        if(!externalAccs.isEmpty())   
            applyExternalPartyIds(externalAccs);
        if(!pnInternalAccs.isEmpty())   
            applyPNInternalPartyIds(pnInternalAccs);
     
    }
    
    static void applyExternalPartyIds(Account[]accs)
    {
        System.debug(LoggingLevel.info,'@@ Applying external involved party Ids');
        //Create the range numbers in the database, reserving the range
        Involved_Party_ID_Range__c[] externalNumbers = new Involved_Party_ID_Range__c[]{};
        for (Account a : accs)
        {
            Involved_Party_ID_Range__c r = new Involved_Party_ID_Range__c();
            externalNumbers.add(r);
        }
        insert externalNumbers;
        Set<ID> externalIds = new Set<ID>();
        for (Involved_Party_ID_Range__c r : externalNumbers)
        {
            externalIds.add(r.Id);
        }
        externalNumbers = [select id,name from Involved_Party_ID_Range__c where id in :externalIds];
        
        // Apply to accounts
        for (integer i=0; i<externalNumbers.size(); i++)
        {
            accs[i].Involved_Party_ID__c = externalNumbers[i].Name;
        }
        System.debug(LoggingLevel.info,'@@ Done applying external involved party Ids');
    }
    
    static void applyInternalPartyIds(Account[]accs)
    {
        System.debug(LoggingLevel.info,'@@ Applying internal involved party Ids');
        //Create the range numbers in the database, reserving the range
        Internal_Involved_Party_ID_Range__c[] internalNumbers = new Internal_Involved_Party_ID_Range__c[]{};
        for (Account a : accs)
        {
            Internal_Involved_Party_ID_Range__c r = new Internal_Involved_Party_ID_Range__c();
            internalNumbers.add(r);
        }
        insert internalNumbers;
        Set<ID> internalIds = new Set<ID>();
        for (Internal_Involved_Party_ID_Range__c r : internalNumbers)
        {
            internalIds.add(r.Id);
        }
        internalNumbers = [select id,name from Internal_Involved_Party_ID_Range__c where id in :internalIds];
        
        // Apply to accounts
        for (integer i=0; i<internalNumbers.size(); i++)
        {
            accs[i].Involved_Party_ID__c = internalNumbers[i].Name;
            system.debug(logginglevel.info, '@@ Account type '+accs[i].External_or_Internal__c+' party number '+accs[i].Involved_Party_ID__c);
        }
        System.debug(LoggingLevel.info,'@@ Done applying internal involved party Ids');
    }
    
    static void applyPNInternalPartyIds(Account[]accs)
    {
        System.debug(LoggingLevel.info,'@@ Applying PN internal involved party Ids');
        //Create the range numbers in the database, reserving the range
        PN_Internal_Involved_Party_ID_Range__c[] pnInternalNumbers = new PN_Internal_Involved_Party_ID_Range__c[]{};
        for (Account a : accs)
        {
            PN_Internal_Involved_Party_ID_Range__c r = new PN_Internal_Involved_Party_ID_Range__c();
            pnInternalNumbers.add(r);
        }
        insert pnInternalNumbers;
        Set<ID> pnInternalIds = new Set<ID>();
        for (PN_Internal_Involved_Party_ID_Range__c r : pnInternalNumbers)
        {
            pnInternalIds.add(r.Id);
        }
        pnInternalNumbers = [select id,name from PN_Internal_Involved_Party_ID_Range__c where id in :pnInternalIds];
        
        // Apply to accounts
        for (integer i=0; i<pnInternalNumbers.size(); i++)
        {
            accs[i].Involved_Party_ID__c = pnInternalNumbers[i].Name;
            system.debug(logginglevel.info, '@@ Account type '+accs[i].External_or_Internal__c+' party number '+accs[i].Involved_Party_ID__c);
        }
        System.debug(LoggingLevel.info,'@@ Done applying PN internal involved party Ids');
    }
    
    // Method for removing the Party ID objects after the account has been created
    public static void deleteInvolvedPartyIdRecord(list<Account> accList){
        Integer timeBefore = Limits.getCpuTime();
        System.debug(LoggingLevel.info,'@@ Deleting Involved partyId Record');
        list<string> externalPartyIdList = new list<string>();
        list<string> internalPartyIdList = new list<string>();
         list<string> pnInternalPartyIdList = new list<string>();        
        
        for(Account acc : accList){
             if (acc.External_or_Internal__c == LABEL.Customer_Type_Internal){
                 internalPartyIdList.add(acc.Involved_Party_ID__c);
             } else if((acc.External_or_Internal__c == LABEL.Customer_Type_PN_DK ) || (acc.External_or_Internal__c == LABEL.Customer_Type_PN_SE)){
                 pnInternalPartyIdList.add(acc.Involved_Party_ID__c);
             } else {
                 externalPartyIdList.add(acc.Involved_Party_ID__c);
             }
        }   
        if(externalPartyIdList.size() > 0){
            delayedDeleteInvolvedPartyIdRecord();
        }
        if(internalPartyIdList.size() > 0){
            delayedDeleteInternalInvolvedPartyID();
        }
        if(pnInternalPartyIdList.size() > 0){
            delayedDeletePNInternalInvolvedPartyID();
        }
        System.debug(LoggingLevel.info,'@@ Done Involved partyId Record');      
    }
    
    @future 
    public static void delayedDeleteInvolvedPartyIdRecord(){
        Integer timeBefore = Limits.getCpuTime();
        try{
            delete [select id from Involved_Party_ID_Range__c limit 10000];          
        }
        catch(DMLException e){
            system.debug(loggingLevel.INFO, 'Deletion of involved party id range object failed, object was already deleted. Error was: ' + e);
        }
    }
    
    @future
    public static void delayedDeleteInternalInvolvedPartyID(){
        Integer timeBefore = Limits.getCpuTime();
        try{
            delete [select id from Internal_Involved_Party_ID_Range__c limit 10000];                        
        }
        catch(DMLException e){
            system.debug(loggingLevel.INFO, 'Deletion of internal involved party id range object failed, object was already deleted. Error was: ' + e);
        }
    }
    
    @future
    public static void delayedDeletePNInternalInvolvedPartyID(){
        Integer timeBefore = Limits.getCpuTime();
        try{
            delete [select id from PN_Internal_Involved_Party_ID_Range__c limit 10000];                        
        }
        catch(DMLException e){
            system.debug(loggingLevel.INFO, 'Deletion of internal involved party id range object failed, object was already deleted. Error was: ' + e);
        }
    }
    
    // 3. Apply search first naming
    public static void applySerchFirstNaming(Account[] accs)
    {
        for (Account a: accs)
        {
            applySerchFirstNaming(a);
        }
    }
    public static void applySerchFirstNaming(Account a)
    {
        applySerchFirstNaming(a, a.isPersonAccount);
    }
    public static void applySerchFirstNaming(Account a, Boolean isPersonAccount)
    {
        Integer timeBefore = Limits.getCpuTime();
        // Set double metaphone
        UTIL_DoubleMetaphone.encode(a);
        
        // Set Shortname
        String newName = '';
        if (!isPersonAccount)
        {
            newName = a.name;
        } else {
            newName = a.FirstName + ' ' + a.Lastname;
        }
        if(newName == null) newName = '';
        newname = newName.replace(' ','');
        newname = newName.replace('?','');
        newname = newName.replace('!','');
        newname = newName.replace('.','');
        newname = newName.replace('&','');
        newname = newName.replace(',','');
        newname = newName.replace(':','');
        newname = newName.replace(';','');
        newname = newName.replace('-','');
        newname = newName.replace('_','');
        newname = newName.replace('*','');
        a.Short_Name__c = newName;        
    }
    
    //4. Reflaggning accounts that were/are/will become duplicate of the accounts in the trigger
    public static void flagToRecheckDuplicates(list<Account> accList ,map<id,Account> oldAccMap, map<id,Account> newAccMap){
        Integer timeBefore = Limits.getCpuTime();
        Set<String> duplicateKeySet = new  Set<String>();
        Set<String> modTagerSet = new  Set<String>();
        Set<String> modInteressentSet = new  Set<String>();
        list<Account> accModModtagerList = new list<Account>();
        list<Account> accModInteressentList = new list<Account>();
        list<Account> accOtherList = new list<Account>();
        map<String,list<Account>> accOtherDupeMap = new map<String,list<Account>>();
        map<String,list<Account>> accModInteressentDupeMap = new map<String,list<Account>>();
        map<String,list<Account>> accModModtagerDupeMap = new map<String,list<Account>>();
        
        map<id,Account> accountsToUpdate = new map<id,Account>();
        Account oldAccount;
        for(Account acc : accList){
           //Adding account in list to prevent duplicates
            accDupCheckList.add(acc.id);
            oldAccount = oldAccMap.get(acc.id);
            //If the name or the postal address city or country has changed
            if(acc.Short_Name__c  != oldAccount.Short_Name__c  || acc.Postal_Address_Country__c != oldAccount.Postal_Address_Country__c || acc.Postal_Address_City__c != oldAccount.Postal_Address_City__c){
                acc.AddressDuplicate__c = false;
                acc.Duplicate_Checked__c = false;
                duplicateKeySet.add(oldAccount.duplicateKey__c);
            }
            //If the MOD Modtager number has changed
            if(acc.MOD_Modtager_Number__c != oldAccount.MOD_Modtager_Number__c){
                acc.ModModtagerDuplicate__c = false;
                acc.MODTager_Duplicate_checked__c = false;
                if(oldAccount.MOD_Modtager_Number__c != null){
                    modTagerSet.add(oldAccount.MOD_Modtager_Number__c);
                }
            }
            //If the MOD Interessent number has changed
            if(acc.MOD_Interessent_Number__c != oldAccount.MOD_Interessent_Number__c){
                acc.ModInteressentDuplicate__c = false;
                acc.MODInteressent_Duplicate_checked__c = false;
                if(oldAccount.MOD_Interessent_Number__c != null){
                    modInteressentSet.add(oldAccount.MOD_Interessent_Number__c);
                }
            }
        }
        
        String queryString = duplicateSelectString(duplicateKeySet, modTagerSet, modInteressentSet, accList);
        if(queryString == null){
            return;
        }
        
        for(Account acc : Database.query(queryString)){
            //If the queried account is not part of the method input (not in initial trigger)
            if(oldAccMap.get(acc.id) == null || newAccMap.get(acc.id) == null){
                if(duplicateKeySet.contains(acc.duplicateKey__c)){
                    if(accOtherDupeMap.get(acc.recordTypeId + acc.duplicateKey__c) != null){
                        accOtherDupeMap.get(acc.recordTypeId + acc.duplicateKey__c).add(acc);
                    }                   
                    else{
                        accOtherDupeMap.put(acc.recordTypeId + acc.duplicateKey__c, new list<Account>{acc});
                    }
                }
                if(modTagerSet.contains(acc.Mod_Modtager_Number__c)){
                    if(accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c) != null){
                        accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c).add(acc);
                    }                   
                    else{
                        accModModtagerDupeMap.put(acc.recordTypeId + acc.MOD_Modtager_Number__c, new list<Account>{acc});
                    }
                }
                if(modInteressentSet.contains(acc.Mod_Interessent_Number__c)){
                    if(accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c) != null){
                        accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c).add(acc);
                    }                   
                    else{
                        accModInteressentDupeMap.put(acc.recordTypeId + acc.MOD_Interessent_Number__c, new list<Account>{acc});
                    }
                }
            }
        }
        
        system.debug(LoggingLevel.Info, 'other map:'  + accOtherDupeMap);
        system.debug(LoggingLevel.Info, 'Modtager map:' + accModModtagerDupeMap);
        system.debug(LoggingLevel.Info, 'Interesent map:' + accModInteressentDupeMap);
        
        Account updateAcc;
        for(String key : accOtherDupeMap.keySet()){
            //If there is only one match - meaning that second account is no longer a dupe
            if(accOtherDupeMap.get(key).size() == 1){
                updateAcc = accOtherDupeMap.get(key)[0];
                updateAcc.AddressDuplicate__c = false;
                if(accountsToUpdate.get(updateAcc.id) == null){
                    accountsToUpdate.put(updateAcc.id, updateAcc);
                }
            }
        }
        for(String key : accModModtagerDupeMap.keySet()){
            if(accModModtagerDupeMap.get(key).size() == 1){
                updateAcc = accModModtagerDupeMap.get(key)[0];
                updateAcc.ModModtagerDuplicate__c = false;
                if(accountsToUpdate.get(updateAcc.id) == null){
                    accountsToUpdate.put(updateAcc.id, updateAcc);
                }
            }           
        }
        for(String key : accModInteressentDupeMap.keySet()){
            if(accModInteressentDupeMap.get(key).size() == 1){
                updateAcc = accModInteressentDupeMap.get(key)[0];
                updateAcc.ModInteressentDuplicate__c = false;
                if(accountsToUpdate.get(updateAcc.id) == null){
                    accountsToUpdate.put(updateAcc.id, updateAcc);
                }
            }           
        }
        system.debug(LoggingLevel.Info, '@@@@ Accounts to reflag:' + accountsToUpdate.size() + ' ' + accountsToUpdate);
        
        try
        {
            update accountsToUpdate.values();
        } catch (Exception e) {
            UTIL_Error.report(e);
            UTIL_Error.writeNow();
        }
    }        

    //4. Reflagging those accounts that have had key changes made for the batch (AccountDuplicateCheck_Batch) to process them again as part of the 
    //    standard duplicate checking schedule. Updates the Duplicate_reason__c field or deletes the PossibleDuplicateAccount__c record.
    public static void flagToRecheckPARDuplicates(List<Account> acc,String reason){
        Integer timeBefore = Limits.getCpuTime();
        System.debug(LoggingLevel.info,'*** START: <Account_SVC>.<flagToRecheckDuplicates>'+acc+'++++++'+reason);
        
        Map<Id,Account> accIdToAccMap = new Map<Id,Account>();
        
        for(Account a:acc){
            accIdToAccMap.put(a.Id,a);
        }
        
        List<sObject> lstToUpdateAccount = new List<sObject>();
        List<PossibleDuplicateAccount__c> lstToDelPossibleDupAccount = new List<PossibleDuplicateAccount__c>();
        List<PossibleDuplicateAccount__c> lstToUpdatePossibleDupAccount = new List<PossibleDuplicateAccount__c>();
        
        String duplicateReason = getDuplicateReason(reason);
        String duplicateCheck  = getDuplicateCheckField(reason);
        
        for(PossibleDuplicateAccount__c possDupAcc : [Select Possible_Duplicate_Account__c, Id,Duplicate_reason__c, Account__c 
                                                    From PossibleDuplicateAccount__c 
                                                    WHERE (Possible_Duplicate_Account__c IN:accIdToAccMap.keySet() OR Account__c IN:accIdToAccMap.keySet()) limit 9999] ){
            
            sObject accRecord1 =  Account.SObjectType.newSObject();
            sObject accRecord2 =  Account.SObjectType.newSObject();
            system.debug(logginglevel.warn, '====> duplicate reason: ' + possDupacc.Duplicate_reason__c + ' dup re: ' + duplicateReason);
            if(possDupAcc.Duplicate_reason__c == duplicateReason){
                lstToDelPossibleDupAccount.add(possDupAcc);
                if(accIdToAccMap.containsKey(possDupAcc.Account__c)){
                    accRecord1 = accIdToAccMap.get(possDupAcc.Account__c);
                    accRecord1.put(duplicateCheck,false);
                }
                if(accIdToAccMap.containsKey(possDupAcc.Possible_Duplicate_Account__c)){
                    accRecord2 = accIdToAccMap.get(possDupAcc.Possible_Duplicate_Account__c);
                    accRecord2.put(duplicateCheck,false);
                }
            }else if(possDupAcc.Duplicate_reason__c!=null && possDupAcc.Duplicate_reason__c.contains(duplicateReason+';')){
                //Removes duplicateReason;
                possDupAcc.Duplicate_reason__c = possDupAcc.Duplicate_reason__c.remove(duplicateReason+';');
                lstToUpdatePossibleDupAccount.add(possDupAcc);
                
                if(accIdToAccMap.containsKey(possDupAcc.Account__c)){
                    accRecord1 = accIdToAccMap.get(possDupAcc.Account__c);
                    accRecord1.put(duplicateCheck,false);
                }else{
                    accRecord1.put('Id',possDupAcc.Account__c);
                    accRecord1.put(duplicateCheck,false);
                    lstToUpdateAccount.add(accRecord1);
                }
                if(accIdToAccMap.containsKey(possDupAcc.Possible_Duplicate_Account__c)){
                    accRecord2 = accIdToAccMap.get(possDupAcc.Possible_Duplicate_Account__c);
                    accRecord2.put(duplicateCheck,false);
                }else{
                    accRecord2.put('Id',possDupAcc.Possible_Duplicate_Account__c);
                    accRecord2.put(duplicateCheck,false);
                    lstToUpdateAccount.add(accRecord2);
                }

                
            }else if(possDupAcc.Duplicate_reason__c!=null && possDupAcc.Duplicate_reason__c.contains(duplicateReason)){                
                //Removes ;duplicateReason
                possDupAcc.Duplicate_reason__c = possDupAcc.Duplicate_reason__c.remove(';'+duplicateReason);
                lstToUpdatePossibleDupAccount.add(possDupAcc);
                                
                if(accIdToAccMap.containsKey(possDupAcc.Account__c)){
                    accRecord1 = accIdToAccMap.get(possDupAcc.Account__c);
                    accRecord1.put(duplicateCheck,false);
                }else{
                    accRecord1.put('Id',possDupAcc.Account__c);
                    accRecord1.put(duplicateCheck,false);
                    lstToUpdateAccount.add(accRecord1);
                }
                if(accIdToAccMap.containsKey(possDupAcc.Possible_Duplicate_Account__c)){
                    accRecord2 = accIdToAccMap.get(possDupAcc.Possible_Duplicate_Account__c);
                    accRecord2.put(duplicateCheck,false);
                }else{
                    accRecord2.put('Id',possDupAcc.Possible_Duplicate_Account__c);
                    accRecord2.put(duplicateCheck,false);
                    lstToUpdateAccount.add(accRecord2);
                }
            }
        }
        
        try
        {
            update lstToUpdateAccount;
            update lstToUpdatePossibleDupAccount;
            delete lstToDelPossibleDupAccount;
        } catch (Exception e) {
            UTIL_Error.report(e);
            UTIL_Error.writeNow();
        }
        
        System.debug(LoggingLevel.info,'*** END: <Account_SVC>.<flagToRecheckDuplicates>');
    }
    
    //4. Reflagging those accounts that have had key changes made for the batch (AccountDuplicateCheck_Batch) to process them again as part of the 
    //    standard duplicate checking schedule. Updates the Duplicate_reason__c field or deletes the PossibleDuplicateAccount__c record.
    public static void removeDuplicateFlagOnDelete(map<id, Account> accMap){
        Integer timeBefore = Limits.getCpuTime();

        Set<String> duplicateKeySet = new  Set<String>();
        Set<String> modTagerSet = new Set<String>();
        Set<String> modInteressentSet = new Set<String>();
        list<Account> accModModtagerList = new list<Account>();
        list<Account> accModInteressentList = new list<Account>();
        list<Account> accOtherList = new list<Account>();
        map<String,list<Account>> accOtherDupeMap = new map<String,list<Account>>();
        map<String,list<Account>> accModInteressentDupeMap = new map<String,list<Account>>();
        map<String,list<Account>> accModModtagerDupeMap = new map<String,list<Account>>();
        
        map<id,Account> accountsToUpdate = new map<id,Account>();
        for(Account acc : accMap.values()){
            if(acc.addressDuplicate__c){
                duplicateKeySet.add(acc.duplicateKey__c);
            }
            if(acc.ModModtagerDuplicate__c){
                modTagerSet.add(acc.MOD_Modtager_Number__c);

            }
            if(acc.ModInteressentDuplicate__c){
                modInteressentSet.add(acc.MOD_Interessent_Number__c);
            }
        }
        for(Account acc : [Select duplicateKey__c, AddressDuplicate__c, duplicate_checked__c, Short_Name__c, Postal_Address_Country__c, Postal_Address_City__c,External_Provider_Party_ID__c, 
                                    Id,RecordTypeId, MOD_Modtager_Number__c, ModModtagerDuplicate__c, ModInteressentDuplicate__c, MOD_Interessent_Number__c FROM Account 
                                    WHERE duplicateKey__c IN:duplicateKeySet OR MOD_Modtager_Number__c IN:modTagerSet OR MOD_Interessent_Number__c IN:modInteressentSet limit 50000]){
            if(accMap.get(acc.id) == null){
                if(duplicateKeySet.contains(acc.duplicateKey__c)){
                    if(accOtherDupeMap.get(acc.recordTypeId + acc.duplicateKey__c) != null){
                        accOtherDupeMap.get(acc.recordTypeId + acc.duplicateKey__c).add(acc);
                    }                   
                    else{
                        accOtherDupeMap.put(acc.recordTypeId + acc.duplicateKey__c, new list<Account>{acc});
                    }
                }
                if(modTagerSet.contains(acc.Mod_Modtager_Number__c)){
                    if(accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c) != null){
                        accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c).add(acc);
                    }                   
                    else{
                        accModModtagerDupeMap.put(acc.recordTypeId + acc.MOD_Modtager_Number__c, new list<Account>{acc});
                    }
                }
                if(modInteressentSet.contains(acc.Mod_Interessent_Number__c)){
                    if(accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c) != null){
                        accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c).add(acc);
                    }                   
                    else{
                        accModInteressentDupeMap.put(acc.recordTypeId + acc.MOD_Interessent_Number__c, new list<Account>{acc});
                    }
                }
            }
        }       
        Account updateAcc;
        for(String key : accOtherDupeMap.keySet()){
            if(accOtherDupeMap.get(key).size() == 1){
                updateAcc = accOtherDupeMap.get(key)[0];
                updateAcc.AddressDuplicate__c = false;
                if(accountsToUpdate.get(updateAcc.id) == null){
                    accountsToUpdate.put(updateAcc.id, updateAcc);
                }
            }
        }
        for(String key : accModModtagerDupeMap.keySet()){
            if(accModModtagerDupeMap.get(key).size() == 1){
                updateAcc = accModModtagerDupeMap.get(key)[0];
                updateAcc.ModModtagerDuplicate__c = false;
                if(accountsToUpdate.get(updateAcc.id) == null){
                    accountsToUpdate.put(updateAcc.id, updateAcc);
                }
            }           
        }
        for(String key : accModInteressentDupeMap.keySet()){
            if(accModInteressentDupeMap.get(key).size() == 1){
                updateAcc = accModInteressentDupeMap.get(key)[0];
                updateAcc.ModInteressentDuplicate__c = false;
                if(accountsToUpdate.get(updateAcc.id) == null){
                    accountsToUpdate.put(updateAcc.id, updateAcc);
                }
            }           
        }       
        update accountsToUpdate.values();
    }
        
    // 5. Set Deletion_Flag__c to true on child records
    public static void setDeletionFlagOnChildRecords (Account[] accs) {
        Integer timeBefore = Limits.getCpuTime();
        Contact[] contactList = [SELECT Id, Deletion_Flag__c FROM Contact WHERE AccountId IN :accs];
        Credit_Information__c[] creditInformationList = [SELECT Id, Deletion_Flag__c FROM Credit_Information__c WHERE Account__c IN :accs];

        for (Contact contact : contactList) {
            contact.Deletion_Flag__c = true;
        }
        for (Credit_Information__c creditInformation : creditInformationList) {
            creditInformation.Deletion_Flag__c = true;
        }
        
        update contactList; 
        update creditInformationList;
    }
    
    // 6. Maintain Extension Addresses of Extensions with the related Worksite on Extension Inserts.
    public static void updateExtensionAddresses(List<Account> newAccounts){
        Integer timeBefore = Limits.getCpuTime();
        System.debug(LoggingLevel.info,'*** START: <G2O_Account_SVC>.<updateExtensionAddresses>');
        try{
            
            //Getting the WorkSiteRecordTypeId
            String wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
            
            List<Account> lstAcc =new List<Account>();
            List<String> workSiteIdList = new List<String>();
            
            Map<String,Set<Account>> worksiteIdToExtensionMap = new Map<String,Set<Account>>();
            
            //Getting the fields from FieldSet that need to be copied from WorkSites To Extensions.
            List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
            fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields(); 
            
            //Creating the WorkSiteId To Extension Mapping.
            for(Account extensionAcc:newAccounts) {
                
                if(worksiteIdToExtensionMap.containsKey(extensionAcc.ParentId)){
                    worksiteIdToExtensionMap.get(extensionAcc.ParentId).add(extensionAcc);
                }else{
                    worksiteIdToExtensionMap.put(extensionAcc.ParentId,new Set<Account> {extensionAcc});
                }
            }
            
            workSiteIdList.addAll(worksiteIdToExtensionMap.keySet());
            
            //Creating the query string.
            String query = 'select Id';
            for(Schema.FieldSetMember f : fieldSet) {
                query += ','+f.fieldPath;
            }
            
            String whereQuery = ' from Account where recordTypeId =:wrkrTypeId AND Id IN:workSiteIdList';
            query += whereQuery;
            
            //Getting the WorkSite/WorkSite field values for the inserted extension so that the values can be copied to extensions.
            for(Account worksiteAcc : Database.query(query)){
                
                if(worksiteIdToExtensionMap.containsKey(worksiteAcc.Id)){
                    
                    for(Account extAcc : worksiteIdToExtensionMap.get(worksiteAcc.Id)){
                        sObject extRec    = (sObject)extAcc;
                        
                        //Copying address fields from Worksite to related Extensions.
                        for(Integer i=0; i<fieldSet.size(); i++) {
                            String fieldName = fieldSet[i].getFieldPath();
                            extRec.put(fieldName,worksiteAcc.get(fieldSet[i].getFieldPath()));
                        }
                    }
                }
            }
        }catch(Exception e){
            system.debug('++++Exception+++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <G2O_Account_SVC>.<updateExtensionAddresses>');
    }
    
    
    // 7. Copies the AccountTeamMember from the LE to the WS
    public static void copyAccountTeamMembers(List<Account> newAccounts) {
        Integer timeBefore = Limits.getCpuTime();
        System.debug(logginglevel.Info, '### START Account_SVC.copyAccountTeamMembers ('+newAccounts+')');
        
        Map<Id, List<Account>> legalEntityWorkSiteMap = new Map<Id, List<Account>>();
        
        for (Account a : newAccounts) {
            if(legalEntityWorkSiteMap.containsKey(a.parentId)) {
                legalEntityWorkSiteMap.get(a.parentId).add(a);
            } else {
                legalEntityWorkSiteMap.put(a.parentId, new List<Account>{a});
            }
        }
        
        List<AccountTeamMember> accountTeamMemberList = [SELECT Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel
                                                         FROM AccountTeamMember
                                                         WHERE AccountId IN :legalEntityWorkSiteMap.keySet()];
        
        List<AccountTeamMember> newAccountTeamMemberList = new List<AccountTeamMember>();
        
        for(AccountTeamMember atm : accountTeamMemberList) {
            for(Account a : legalEntityWorkSiteMap.get(atm.AccountId)) {
                AccountTeamMember newAtm = atm.clone(false, true, false, false);
                newAtm.AccountId = a.Id;
                newAccountTeamMemberList.add(newAtm);
            }
            
        }
        if(newAccountTeamMemberList.size() > 0)insert newAccountTeamMemberList;
        
        System.debug(logginglevel.Info, '### END Account_SVC.copyAccountTeamMembers');
    }
    
    //8. copies the new Account Id to accounts where PAR Parent ID equals PAR ID.
    // Parameters: Map<String, Account> where String is External Provider Party Id 
    public static void externalPartyConnectExistingChildRecords(Map<String, Account> externalPartyConnectWithAccount) {
        Integer timeBefore = Limits.getCpuTime();
        System.debug(logginglevel.Info, '### START Account_SVC.externalPartyConnectExistingChildRecords ('+externalPartyConnectWithAccount+')');
        list<Account> existingAccount = new list<Account>();
        
        // querying all accounts where Parent PAR Id in the PAR Id and assigning the account of the PAR id with matching Parent PAR Id
        for (Account chkParentParId : [SELECT Id, Name, External_Provider_Party_Id__c, External_Provider_Party_Parent_ID__c FROM Account WHERE External_Provider_Party_Parent_ID__c IN: externalPartyConnectWithAccount.keySet() limit 99999]) {
            if(chkParentParId.External_Provider_Party_Parent_ID__c == externalPartyConnectWithAccount.get(chkPARENTParId.External_Provider_Party_Parent_ID__c).External_Provider_Party_Id__c) {
                chkParentParId.ParentId = externalPartyConnectWithAccount.get(chkParentParId.External_Provider_Party_Parent_ID__c).Id;
                existingAccount.add(chkParentParId);
            }
        }
        
        // updating the accounts if any matching record is found
        update existingAccount;
        
        // Remove the old children related to PAR Id
        System.debug(logginglevel.Info, '### END Account_SVC.externalPartyConnectExistingChildRecords ('+externalPartyConnectWithAccount+')');
    } 
    
    //9. copies the new Account Id to accounts where PAR ID equals PAR Parent ID.
    // Parameters: Map<String, Account> where String is External Provider Party Parent Id 
    public static void externalPartyConnectExistingParentRecords(Map<String, Account> externalPartyConnectWithAccount) {
        Integer timeBefore = Limits.getCpuTime();
        System.debug(logginglevel.Info, '### START Account_SVC.externalPartyConnectExistingParentRecords ('+externalPartyConnectWithAccount+')');
        list<Account> existingAccount = new list<Account>();
        
        // querying all accounts where PAR Id in the PAR Parent Id and assigning the account of the PAR Parent id with matching PAR Id
        for(Account chkParId: [SELECT Id, Name, External_Provider_Party_Id__c, External_Provider_Party_Parent_ID__c FROM Account WHERE External_Provider_Party_Id__c IN: externalPartyConnectWithAccount.keyset() limit 99999]) {
            if(chkParId.External_Provider_Party_Id__c == externalPartyConnectWithAccount.get(chkParId.External_Provider_Party_Id__c).External_Provider_Party_Parent_ID__c) {
                chkParId.ParentId = externalPartyConnectWithAccount.get(chkParId.External_Provider_Party_Id__c).Id;
                existingAccount.add(chkParId);
            }
        }
        
        // updating the accounts if any matching record is found
        update existingAccount;        
    }
    
    
    //10. copies the new Account Id to accounts where PAR Parent ID equals PAR ID and removes children connection if any
    // Parameters: Map<String, Account> where String is External Provider Party Parent Id 
    public static void externalPartyConnectExistingChildRecordsUpdate(Map<String, Account> parIDChangedNew, Set<String> parIdChangedOldSet) {
        Integer timeBefore = Limits.getCpuTime();
        System.debug(logginglevel.Info, '### START Account_SVC.externalPartyConnectExistingChildRecordsUpdate ('+parIDChangedNew+ parIdChangedOldSet +')');
        list<String> existingAccount = new list<String>();
        list<Account> existingAccountAll = new list<Account>();
        list<Account> existingAccountUpdate = new list<Account>();
        map<String, List<Account>> parIdToListAccountMap = new map<String, List<Account>>(); 
        
        // adding old and new Par Ids in the list
        existingAccount.addAll(parIDChangedNew.KeySet());
        existingAccount.addAll(parIdChangedOldSet);
        System.debug(Logginglevel.INFO,'@@ existingAccount @@' +existingAccount);
         
        // querying all accounts where Parent PAR Id in the PAR Id and assigning it to map to add or remove connections further
        for (Account chkParentParId : [SELECT Id, Name, External_Provider_Party_Id__c, External_Provider_Party_Parent_ID__c FROM Account WHERE External_Provider_Party_Parent_ID__c IN: existingAccount limit 99999]) {

            existingAccountAll = parIdToListAccountMap.get(chkParentParId.External_Provider_Party_Parent_ID__c);
            if(existingAccountAll == null)  {
                existingAccountAll = new list<Account>();
            }
            if(!parIdToListAccountMap.containskey(chkParentParId.External_Provider_Party_Parent_ID__c)) {               // if map does not contain the External_Provider_Party_Parent_ID__c
                existingAccountAll.add(chkParentParId);
                parIdToListAccountMap.put(chkParentParId.External_Provider_Party_Parent_ID__c, existingAccountAll);             // put the External_Provider_Party_Parent_ID__c and the whole list 
            } else {
                 existingAccountAll.add(chkParentParId);
            }
        }
        
        // running the keyset values to add a connection or remove it depending on parIdChangedOldSet & parIDChangedNew map
        for(String parIds : parIdToListAccountMap.KeySet()) {
            
            // running values of the map
            for(Account accRec : parIdToListAccountMap.get(parIds)) {
                
                // Check if the trigger old contains the value of External_Provider_Party_Parent_ID__c
                if(parIdChangedOldSet.contains(parIds)) {
                    accRec.ParentId = null;                         // remove old connection of the Parent
                    existingAccountUpdate.add(accRec);
                } else {
                    // Check if the trigger new contains the value of External_Provider_Party_Parent_ID__c
                    if(parIDChangedNew.containsKey(parIds)) {
                        accRec.ParentId = parIDChangedNew.get(parIds).Id;           // assign the trigger.new account to its parent with matching External_Provider_Party_Parent_ID__c
                        existingAccountUpdate.add(accRec);
                    }
                }   
            }
            
        }
        
        // updating the accounts if any matching record is found
        update existingAccountUpdate;

        System.debug(logginglevel.Info, '### END Account_SVC.externalPartyConnectExistingChildRecords ('+parIDChangedNew+ parIdChangedOldSet +')');
    } 
    
    
    //11. Create the Sales Area Information for the Accounts Created for LE & WS.
    public static void createSalesAreaInformation(Map<Id, Account> newInfoForAccountCreated, Set<Id> newAccountCreated) {
        Integer timeBefore = Limits.getCpuTime();
        List<Sales_Area_Information__c> lstSalesAreaInserted = new List<Sales_Area_Information__c>();
        Map<Id, User> mapUserInfo = new Map<Id, User>();
        
        // query all the users and get all the Sales Area information for the particular User
        for(User u: [Select Id, Name, Sales_Area1__c From User where Id IN: newAccountCreated limit 50000]) {
            if(u.Sales_Area1__c != null && u.Sales_Area1__c != '') {
                mapUserInfo.put(u.id, u);
            }
        }
        
        // run all the accounts which are inserted
        System.debug(Logginglevel.INFO,'@@ newInfoForAccountCreated @@' +newInfoForAccountCreated.keySet());
        for(ID acc: newInfoForAccountCreated.keyset()) {
            if(mapUserInfo != null && !mapUserInfo.isEmpty()) {
                // Check if the user id is equal to the account inserted User Id
                if(mapUserInfo.get(newInfoForAccountCreated.get(acc).CreatedById).Id == newInfoForAccountCreated.get(acc).CreatedById) {
                    // create Sales Area information
                    Sales_Area_Information__c createInformation = new Sales_Area_Information__c();
                    createInformation.Sales_Area__c = mapUserInfo.get(newInfoForAccountCreated.get(acc).CreatedById).Sales_Area1__c;
                    createInformation.Account__c = acc;
                    createInformation.Is_First_SAI__c = true;
                    lstSalesAreaInserted.add(createInformation);
                }
            }
        }   
        
        // Insert sales area information
        if(lstSalesAreaInserted != null && !lstSalesAreaInserted.isEmpty()) {
            list<Database.SaveResult> srList = Database.insert(lstSalesAreaInserted, false);
            
            //If there are any errors that is handled here
            for (integer i = 0; i < srList.size(); i++) {
                if (!srList[i].isSuccess()) {
                    for(Database.Error err : srList[i].getErrors()) {
                        //Since the SAI valiation rule error is thrown on the SAI we want to present the error nice to the user (without the stack trace)
                        if (err.getMessage().contains(Label.Parent_WS_does_not_have_corresponding_SAI)) {
                            newInfoForAccountCreated.get((lstSalesAreaInserted[i].Account__c)).addError(Label.Parent_WS_does_not_have_corresponding_SAI);
                        }
                    }
                }
            }
        }
    }
    
    //12. Updates Functional Inbox_Email of account on the related contacts.
    public static void manageFunctionalInboxes(List<Account> newAccountLst) {
        Integer timeBefore = Limits.getCpuTime();
        Map<Id,String> accIdToFunctionalInboxMap = new Map<Id,String>();
        List<Contact> conToUpdateLst = new List<Contact>();

        Id rTypeId = UTIL_Meta.getContactPostNordEmployeeRT();
        
        for(Account acc :newAccountLst){
            
            accIdToFunctionalInboxMap.put(acc.Id,acc.Functional_Inbox_Email__c);
        }
        
        //Copying the Functional Inbox from accounts to contacts.
        for(Contact con : [Select c.Id,c.RecordTypeId, c.Is_Org_Unit_Contact__c, c.AccountId From Contact c 
                            Where c.AccountId IN:accIdToFunctionalInboxMap.keySet() 
                            AND c.Is_Org_Unit_Contact__c = true AND c.RecordTypeId=:rTypeId]){
                               
            con.Email = accIdToFunctionalInboxMap.get(con.AccountId);
            conToUpdateLst.add(con);
        }
        
        update conToUpdateLst;
    }
    
    //13. Deletes PossibleDuplicateAccount__c record on deletion of related account record.
    public static void deletePossibleDuplicates(Set<Id> possibleDuplicateAccounts){
        Integer timeBefore = Limits.getCpuTime();
        List<PossibleDuplicateAccount__c> PossibleDuplicateAccDeleteLst = new List<PossibleDuplicateAccount__c>();
        
        for(PossibleDuplicateAccount__c possDuplicate: [Select p.Possible_Duplicate_Account__c, p.Account__c From PossibleDuplicateAccount__c p
                                                            Where p.Possible_Duplicate_Account__c IN: possibleDuplicateAccounts]){
            PossibleDuplicateAccDeleteLst.add(possDuplicate);
        }
        
        delete PossibleDuplicateAccDeleteLst;
        
    }
    
    
    //14. Method to handle account field updates if "Do Not Update Automatically" is set.
    public static void doNotUpdateAutomatically(List<Account> accDoNotUpdateNewList , Map<Id,Account> accDoNotUpdateOldMap){
        Integer timeBefore = Limits.getCpuTime();
        System.debug(logginglevel.Info, '### START Account_SVC.DoNotUpdateAutomatically');
        
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Account.FieldSets.doNotUpdateFieldsForIntegrationUsers.getFields(); 
            
        for(integer j=0; j<accDoNotUpdateNewList.size(); j++){
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                
                if(accDoNotUpdateNewList[j].get(fieldSet[i].getFieldPath()) != accDoNotUpdateOldMap.get(accDoNotUpdateNewList[j].id).get(fieldSet[i].getFieldPath())){
                    
                    //accDoNotUpdateNewList[j].get(fieldSet[i].getFieldPath()) = accDoNotUpdateOldMap.get(accDoNotUpdateNewList[j].id).get(fieldSet[i].getFieldPath());
                    String fieldAPIName = fieldSet[i].getFieldPath();
                    sObject accRec   = (sObject)accDoNotUpdateNewList[j];
                    
                    accRec.put(fieldAPIName,accDoNotUpdateOldMap.get(accDoNotUpdateNewList[j].id).get(fieldSet[i].getFieldPath()));
                    
                }
            }
                
        }
        System.debug(logginglevel.Info, '### END Account_SVC.DoNotUpdateAutomatically');
    }
    
    //15a. Method to update fields on WS accounts when certain fields are updated on a LE account
    public static void synchProjectFieldsBetweenWSwithLE(List<Account> legalEntityAccountNewList , Map<Id,Account> legalEntityAccountOldMap){
        Integer timeBefore = Limits.getCpuTime();
        
        string workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
        map<id, Account> relevantLEAccount = new map<id, Account>();
        list<Account> accountsToUpdate = new list<Account>();
       
        // Filter out LE account where any of the relevant fields has been updated
        for(Account acc : legalEntityAccountNewList){
            if(acc.Legal_Entity_Primary_Ind_Group_77__c != legalEntityAccountOldMap.get(acc.id).Legal_Entity_Primary_Ind_Group_77__c ||
                    acc.Legal_Entity_Primary_Ind_Group_8__c != legalEntityAccountOldMap.get(acc.id).Legal_Entity_Primary_Ind_Group_8__c ||
                    acc.Legal_Entity_Primary_Industry__c != legalEntityAccountOldMap.get(acc.id).Legal_Entity_Primary_Industry__c){
                relevantLEAccount.put(acc.id, acc);         
            }
        }
        
        accountsToUpdate = [select  id, parentid from Account where parentid IN :relevantLEAccount.keySet() and recordtypeid = :workSiteRT];
        
        for(Account acc : accountsToUpdate){
            acc.Legal_Entity_Primary_Ind_Group_77__c = relevantLEAccount.get(acc.parentId).Legal_Entity_Primary_Ind_Group_77__c;
            acc.Legal_Entity_Primary_Ind_Group_8__c = relevantLEAccount.get(acc.parentId).Legal_Entity_Primary_Ind_Group_8__c;
            acc.Legal_Entity_Primary_Industry__c = relevantLEAccount.get(acc.parentId).Legal_Entity_Primary_Industry__c;
        }        
        
        list<Database.SaveResult> srList = Database.update(accountsToUpdate, false);
        
        for (integer i = 0; i < srList.size(); i++) {
            if (!srList[i].isSuccess()) { 
                // Operation failed, so get all errors                
                for(Database.Error err : srList[i].getErrors()) {
                    UTIL_Error.report('Handled Exception',' An error occured when trying to update Account:' + accountsToUpdate[i].id + ' Error is: ' + err,'AccountTeamMemberSync_BATCH');                 
                }  
            } 
        }
        if(UTIL_Error.reports.size() > 0){
            UTIL_Error.writeNow();      
        }
    }

    //15b. Method to set certain fields on the WorkSite when it is created, gains a parent or is reparented
    public static void setProjectFieldsOnWsParentChanges(list<Account> wsList){
        
        set<id> leIdSet = new set<id>();
        map<id,Account> leMap = new map<id,Account>();
        string workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
        map<id, Account> relevantLEAccount = new map<id, Account>();
        list<Account> accountsToUpdate = new list<Account>();
       
        // Finds the ids for all relevant LE's
        for(Account acc : wsList){
            if(acc.parentid != null){
                leIdSet.add(acc.parentId);
            }
        }
        
        leMap = new map<id,Account>([select id, Legal_Entity_Primary_Ind_Group_77__c, Legal_Entity_Primary_Ind_Group_8__c, Legal_Entity_Primary_Industry__c from Account Where Id IN :leIdSet]);

        for(Account acc : wsList){
            if(acc.parentId != null){
                acc.Legal_Entity_Primary_Ind_Group_77__c = leMap.get(acc.parentId).Legal_Entity_Primary_Ind_Group_77__c;
                acc.Legal_Entity_Primary_Ind_Group_8__c = leMap.get(acc.parentId).Legal_Entity_Primary_Ind_Group_8__c;
                acc.Legal_Entity_Primary_Industry__c = leMap.get(acc.parentId).Legal_Entity_Primary_Industry__c;
            }
        }
    }
        
    //16. Method to copy Postal Address Country to Registration country for LE, WS and Extension accounts
    public static void copyPostalAddressCountryToRegistrationCountry(Set<Account> accountsWithCountryToCopy){
        System.debug(logginglevel.Info, '### START Account_SVC.copyPostalAddressCountryToRegistrationCountry');
        Integer timeBefore = Limits.getCpuTime();

        //Copy the Postal Address Country to Registration Country
        for (Account a : accountsWithCountryToCopy) { 
            a.Registration_Country__c = a.Postal_Address_Country__c;
        } 
        System.debug(logginglevel.Info, '### END Account_SVC.copyPostalAddressCountryToRegistrationCountry');      
    }    
        
    //Get the duplicate reason from custom setting.
    private static String getDuplicateReason(String reason){
        
        String duplicateReason;
        if(reason == G2O_PossibleDuplicateAccount_SVC.PAR){
            duplicateReason = G2O_PossibleDuplicateAccount_SVC.PAR;
        } else {
            duplicateReason = 'ILLEGAL REASON';
        }
        return duplicateReason;
    }
    
    //Get the duplicate reason from custom setting.
    private static String getDuplicateCheckField(String reason){
        
        String DuplicateCheckField;
        if(reason == G2O_PossibleDuplicateAccount_SVC.MOD_INTRESSENT){
            
            DuplicateCheckField = 'MODInteressent_Duplicate_checked__c';
            
        }else if(reason == G2O_PossibleDuplicateAccount_SVC.MOD_MODTAGER){
            
            DuplicateCheckField = 'MODTager_Duplicate_checked__c';
            
        }else if(reason == G2O_PossibleDuplicateAccount_SVC.PAR){
            
            DuplicateCheckField = 'External_Provider_Duplicate__c';
            
        }else if(reason==G2O_PossibleDuplicateAccount_SVC.BATCH) {
            
            DuplicateCheckField = 'Duplicate_checked__c';
            
        }
        return DuplicateCheckField;
    }
    
    //Check if the accounts has got any duplicates and mark those as dupes in that case
    public static void checkForDuplicate(list<Account> accountList){    
        map<id,Account> accountMap = new map<id, Account>();
        for(Account acc : accountList){
            if(acc.id != null){
                 //Adding account in the list to prevent dulicates.
                accDupCheckList.add(acc.id);
                accountMap.put(acc.id, acc);
            }
        }
        Set<String> duplicateKeySet = new  Set<String>();
        Set<String> modTagerSet = new  Set<String>();
        Set<String> modInteressentSet = new  Set<String>();
        list<Account> accModModtagerList = new list<Account>();
        list<Account> accModInteressentList = new list<Account>();
        list<Account> accOtherList = new list<Account>();
        map<String,list<Account>> accOtherDupeMap = new map<String,list<Account>>();
        map<String,list<Account>> accModInteressentDupeMap = new map<String,list<Account>>();
        map<String,list<Account>> accModModtagerDupeMap = new map<String,list<Account>>();
        
        map<id,Account> accountsToUpdate = new map<id,Account>();
        System.debug(LoggingLevel.Info, '@@@@ List of accounts to check:' + accountList.size());
        for(Account acc : accountList){
            //If there are accounts that should be dupe checked
            if(!acc.duplicate_checked__c || !acc.Modtager_Duplicate_Checked__c || !acc.MODInteressent_Duplicate_checked__c){
                DUPCHECK_RUNNING = true;
            }
            if(!acc.duplicate_checked__c){
                //The short name that the formula field is using to generate the duplicateKey is updated in an earlier trigger method
                // therefore it will not correctly reflect the current value at this point in the execution,
                // sadly this means we have to hard code the content of the formula field here
                duplicateKeySet.add(acc.Short_Name__c + acc.Postal_Address_Country__c + acc.Postal_Address_City__c);
                if(accOtherDupeMap.get(acc.recordTypeId + acc.Short_Name__c + acc.Postal_Address_Country__c + acc.Postal_Address_City__c) != null){
                    accOtherDupeMap.get(acc.recordTypeId + acc.Short_Name__c + acc.Postal_Address_Country__c + acc.Postal_Address_City__c).add(acc);
                }                   
                else{
                    accOtherDupeMap.put(acc.recordTypeId + acc.Short_Name__c + acc.Postal_Address_Country__c + acc.Postal_Address_City__c, new list<Account>{acc});
                }           
            }
            if(!acc.Modtager_Duplicate_Checked__c && acc.MOD_Modtager_Number__c != null){
                modTagerSet.add(acc.MOD_Modtager_Number__c);
                if(accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c) != null){
                    accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c).add(acc);
                }
                else{
                    accModModtagerDupeMap.put(acc.recordTypeId + acc.MOD_Modtager_Number__c, new list<Account>{acc});
                }
            }
            if(!acc.MODInteressent_Duplicate_checked__c && acc.MOD_Interessent_Number__c != null){
                modInteressentSet.add(acc.MOD_Interessent_Number__c);
                if(accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c) != null){
                    accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c).add(acc);
                }                   
                else{
                    accModInteressentDupeMap.put(acc.recordTypeId + acc.MOD_Interessent_Number__c, new list<Account>{acc});
                }
            }
        }
        String queryString = duplicateSelectString(duplicateKeySet, modTagerSet, modInteressentSet, accountList);       

        if(queryString == null){
            return;
        }
        list<Account> tempDupeList = Database.query(queryString);
        /*[Select duplicateKey__c, AddressDuplicate__c, duplicate_checked__c, Short_Name__c, Postal_Address_Country__c, Postal_Address_City__c,External_Provider_Party_ID__c, 
                                        Id,RecordTypeId, MOD_Modtager_Number__c, ModModtagerDuplicate__c, ModInteressentDuplicate__c, MOD_Interessent_Number__c FROM Account 
                                        WHERE duplicateKey__c IN:duplicateKeySet OR MOD_Modtager_Number__c IN:modTagerSet OR MOD_Interessent_Number__c IN:modInteressentSet limit 50000];*/
        system.debug(LoggingLevel.Info, '@@@@ Query returned:' + tempDupeList.size() + ' ' + tempDupeList);
        
        if(tempDupeList.size() > 49999){
            // Add error for full data set, manual check is needed for duplicates           
        }
        else{
            for(Account acc : tempDupeList){
                //If the account is not already in method input parameters
                if(accountMap.get(acc.id) == null){
                    if(duplicateKeySet.contains(acc.duplicateKey__c)){
                        accOtherList.add(acc);
                    }
                    if(modTagerSet.contains(acc.Mod_Modtager_Number__c)){
                        accModModtagerList.add(acc);
                    }
                    if(modInteressentSet.contains(acc.Mod_Interessent_Number__c)){
                        accModInteressentList.add(acc);
                    }
                }
            }

            for(Account acc : accOtherList){
                if(accOtherDupeMap.get(acc.recordTypeId + acc.duplicateKey__c) != null){
                    accOtherDupeMap.get(acc.recordTypeId + acc.duplicateKey__c).add(acc);
                }                   
                else{
                    accOtherDupeMap.put(acc.recordTypeId + acc.duplicateKey__c, new list<Account>{acc});
                }
            }
        
            for(Account acc : accModModtagerList){
                if(accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c) != null){
                    accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c).add(acc);
                }                   
                else{
                    accModModtagerDupeMap.put(acc.recordTypeId + acc.MOD_Modtager_Number__c, new list<Account>{acc});
                }
            }
        
            for(Account acc : accModInteressentList){
                if(accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c) != null){
                    accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c).add(acc);
                }                   
                else{
                    accModInteressentDupeMap.put(acc.recordTypeId + acc.MOD_Interessent_Number__c, new list<Account>{acc});
                }
            }           
        }
        for(Account acc : accountList){
            // Here we also replace duplicateKey with the content of it, because it wont be updated on the account from the trigger
            //If the account is in the otherDupeMap
            if(accOtherDupeMap.get(acc.recordTypeId + acc.Short_Name__c + acc.Postal_Address_Country__c + acc.Postal_Address_City__c) != null){
                //If the account has got more than one dupe
                if(accOtherDupeMap.get(acc.recordTypeId + acc.Short_Name__c + acc.Postal_Address_Country__c + acc.Postal_Address_City__c).size() > 1){
                    //Loop over the dupe accounts
                    for(Account innerAcc : accOtherDupeMap.get(acc.recordTypeId + acc.Short_Name__c + acc.Postal_Address_Country__c + acc.Postal_Address_City__c)){
                        //If the inner account is not part of the list of accounts that came in as parameters to the method and if the account is not marked as a address duplicate
                        if(innerAcc.id != null && accountMap.get(innerAcc.id) == null && innerAcc.AddressDuplicate__c == false){                        
                            innerAcc.AddressDuplicate__c = true;
                            if(accountsToUpdate.get(innerAcc.id) == null){
                                accountsToUpdate.put(innerAcc.id, innerAcc);
                            }
                        }                   
                    }   
                    acc.AddressDuplicate__c = true;
                }
                else{
                    acc.AddressDuplicate__c = false;        
                }
            }
            acc.Duplicate_Checked__c = true;
            if(accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c) != null){ 
                if(accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c).size() > 1){
                    for(Account innerAcc : accModModtagerDupeMap.get(acc.recordTypeId + acc.MOD_Modtager_Number__c)){
                        if(innerAcc.id != null && accountMap.get(innerAcc.id) == null && innerAcc.ModModtagerDuplicate__c == false){
                            innerAcc.ModModtagerDuplicate__c = true;
                            if(accountsToUpdate.get(innerAcc.id) == null){
                                accountsToUpdate.put(innerAcc.id, innerAcc);
                            }
                        }
                    }
                    acc.MODTager_Duplicate_checked__c = true;
                    acc.ModModtagerDuplicate__c = true;
                }
                else{
                    acc.ModModtagerDuplicate__c = false;                
                }
            }
            acc.MODTager_Duplicate_checked__c = true;
            
            if(accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c) != null){
                if(accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c).size() > 1){
                    for(Account innerAcc : accModInteressentDupeMap.get(acc.recordTypeId + acc.MOD_Interessent_Number__c)){
                        if(innerAcc.id != null && accountMap.get(innerAcc.id) == null && innerAcc.ModInteressentDuplicate__c == false){                 
                            innerAcc.ModInteressentDuplicate__c = true;
                            if(accountsToUpdate.get(innerAcc.id) == null){
                                accountsToUpdate.put(innerAcc.id, innerAcc);
                            }
                        }
                    }
                    acc.MODInteressent_Duplicate_checked__c = true;
                    acc.ModInteressentDuplicate__c = true;
                }
                else{
                    acc.ModInteressentDuplicate__c = false;             
                }
            }
            acc.MODInteressent_Duplicate_checked__c = true;
                        
        }
        system.debug(logginglevel.Error, '@@@@ Accounts to update:' + accountsToUpdate.size() + ' ' + accountsToUpdate);
         // We are comparing if an account is in accDupCheckList then it should not be in accountsToUpdate.
        for(Account a :accountsToUpdate.values()){
            for(ID a1 : accDupCheckList){
                if(a.id == a1){
                    accountsToUpdate.remove(a.id);
                }
            }
        }
        
        // Perform the update and supress any errors to logs in order to avoid causing issues with other transactions
        try
        {
            update accountsToUpdate.values();
        } catch (Exception e) {
            UTIL_Error.report(e);
            UTIL_Error.writeNow();
        }
    }
    
    // Delete old involved party ids
    // >> Called when an account is physically deleted only
    public static void deleteInvolvedPartyIds(map<id,Account> deletedAccountsById)
    {   
        Integer timeBefore = Limits.getCpuTime();
        
        map<String,Account> externalAccsByIVPID = new map<String,Account>();
        map<String,Account> internalAccsByIVPID = new map<String,Account>();
        map<String,Account> pnInternalAccsByIVPID = new map<String,Account>();
        
        // Remove any records that are not set as IsDeleted
        for (ID accId : deletedAccountsById.keySet())
        {
            Account a = deletedAccountsById.get(accId);
            if (!a.Deletion_Flag__c || UTIL_Apex.empty(a.Involved_Party_ID__c))
            {
                deletedAccountsById.remove(accId);
            } else {
                if (a.External_or_Internal__c == LABEL.Customer_Type_Internal){
                    internalAccsByIVPID.put(a.Involved_Party_ID__c,a);
                } else if((a.External_or_Internal__c == LABEL.Customer_Type_PN_DK) || (a.External_or_Internal__c == LABEL.Customer_Type_PN_SE)){
                    pnInternalAccsByIVPID.put(a.Involved_Party_ID__c,a);
                } else {
                    externalAccsByIVPID.put(a.Involved_Party_ID__c,a);
                } 
            }
        }

        // Lookup and remove the numbers that we have collected
        if (externalAccsByIVPID.size()>0)
        {
            Involved_Party_ID_Range__c[] externalNumbers = [select id,name from Involved_Party_ID_Range__c where name in :externalAccsByIVPID.keySet()];
            delete externalNumbers;
        }
        if (internalAccsByIVPID.size()>0)
        {
            Internal_Involved_Party_ID_Range__c[] internalNumbers = [select id,name from Internal_Involved_Party_ID_Range__c where name in :internalAccsByIVPID.keySet()];
            delete internalNumbers;
        }
        if (pnInternalAccsByIVPID.size()>0)
        {            
            PN_Internal_Involved_Party_ID_Range__c[] pnInternalNumbers = [select id,name from PN_Internal_Involved_Party_ID_Range__c where name in :pnInternalAccsByIVPID.keySet()];
            delete pnInternalNumbers;
        }
        
    }
    
    public static void assignLEToWS(Map<Id, Id> mapForAssigningLEToWS){
        List<Account> accList = new List<Account>();
        for(Id accToBeUpdated : mapForAssigningLEToWS.keySet()){
            accList.add(new Account(Id=accToBeUpdated, ParentId=mapForAssigningLEToWS.get(accToBeUpdated)));                
        }
        if(accList.size() > 0){
            update accList;
        }
    }
    
    // creates the select string for duplicate selection
    private static String duplicateSelectString(set<string> duplicateKeySet, set<String> modTagerSet, set<String> modInteressentSet, list<Account> accountList){
        String querySelect = 'Select duplicateKey__c, AddressDuplicate__c, duplicate_checked__c, Short_Name__c, Postal_Address_Country__c, Postal_Address_City__c,External_Provider_Party_ID__c, Id,RecordTypeId, MOD_Modtager_Number__c, ModModtagerDuplicate__c, ModInteressentDuplicate__c, MOD_Interessent_Number__c FROM Account';
        String duplicateSelect = ' duplicateKey__c IN:duplicateKeySet';
        String MODModtagerSelect = ' MOD_Modtager_Number__c IN :modTagerSet';
        String MODInteressentSelect = ' MOD_Interessent_Number__c IN:modInteressentSet';
        boolean hasWhere = false;
        if(duplicateKeySet != null && duplicateKeySet.size() > 0){
            if(!hasWhere){
                querySelect += ' WHERE ';
                hasWhere = true;
            }
            querySelect += duplicateSelect;
        }
        if(modTagerSet != null && modTagerSet.size() > 0){
            if(!hasWhere){
                querySelect += ' WHERE ';
                hasWhere = true;
            }
            else{
                querySelect += ' OR ';              
            }
            querySelect += MODModtagerSelect;           
        }
        if(modInteressentSet != null && modInteressentSet.size() > 0){
            if(!hasWhere){
                querySelect += ' WHERE ';
                hasWhere = true;
            }
            else{
                querySelect += ' OR ';                              
            }
            querySelect += MODInteressentSelect;            
        }
        querySelect += ' limit 50000';
        if(!hasWhere){
            for(Account acc : accountList){
                acc.Duplicate_Checked__c = true;
                acc.AddressDuplicate__c = false;
                acc.MODTager_Duplicate_checked__c = true;
                acc.ModModtagerDuplicate__c = false;
                acc.MODInteressent_Duplicate_checked__c = true;
                acc.ModInteressentDuplicate__c = false;
            }           
            //If no where clause is put into the select, no data limitation is being done and no duplicates are relevant
            return null;
        }
        system.debug(logginglevel.Info, '@@@@ duplicateKeySet:' + duplicateKeySet);
        system.debug(logginglevel.Info, '@@@@ Select is:' + querySelect);  
        return querySelect;     
    }
    private static Map<String,Integer> getAggRelationshipsCountMap(List<String> accIds,Boolean arePrimary){
          Map<String,Integer> aggRelationshipsCountMap = new Map<String,Integer>();
          String relationshipsGroupBy=arePrimary ? 'Account__c' : 'Related_Account__c';
          String soqlQuery = 'select '+relationshipsGroupBy+',';
                soqlQuery += ' COUNT(Id) NUMBER_OF_RELATIONS '; 
                soqlQuery += ' from Relationship__c ';
                soqlQuery += ' where '+relationshipsGroupBy+' in :accIds';
                soqlQuery += ' group by  '+relationshipsGroupBy;
        
          for(AggregateResult aggRelationships :Database.query(soqlQuery)){
             String key=String.valueOf(aggRelationships.get(relationshipsGroupBy));
             Integer relationsCount=Integer.valueOf(aggRelationships.get('NUMBER_OF_RELATIONS'));
             aggRelationshipsCountMap.put(key,relationsCount);          
          }
        return aggRelationshipsCountMap;
    }
    public static void checkForAssociatedRelationShips(List<Account> accountsMarkedForDeletion){
          List<String> accIds = new List<String>();
          for(Account acc:accountsMarkedForDeletion){
              accIds.add(acc.Id);
          }
          Map<String,Integer> aggRelatedRelationshipsCountMap = getAggRelationshipsCountMap(accIds,false);
          Map<String,Integer> aggPrimaryRelationshipsCountMap = getAggRelationshipsCountMap(accIds,true);
          for(Account acc:accountsMarkedForDeletion){
              Integer primaryRelations=aggPrimaryRelationshipsCountMap.containsKey(acc.Id) ? aggPrimaryRelationshipsCountMap.get(acc.Id) : 0;
              Integer relatedRelations=aggRelatedRelationshipsCountMap.containsKey(acc.Id) ? aggRelatedRelationshipsCountMap.get(acc.Id) : 0;
              
              Boolean accHasReleationships=aggRelatedRelationshipsCountMap.containsKey(acc.Id) ? 
                                           ((aggRelatedRelationshipsCountMap.get(acc.Id) > 0) ? true 
                                           :(aggPrimaryRelationshipsCountMap.containsKey(acc.Id) ? 
                                           ((aggPrimaryRelationshipsCountMap.get(acc.Id) > 0) ? true : false) :false)): false; 
              if((primaryRelations > 0) || (relatedRelations > 0 )){
                   acc.addError(System.Label.Account_has_active_relationships_and_can_not_be_marked_for_deletion);
              }              
          }
          system.debug(logginglevel.Info, '@@@@ aggRelatedRelationshipsCountMap:' + aggRelatedRelationshipsCountMap);
    }
    public static void checkForRelatedRelationShipsAssociatedWithInvoiceRecipients(List<Account> invoiceRecipientAccounts,Map<Id,Account> invoiceRecipientAccountsOldMap){
          List<String> relatedAccIds = new List<String>();
          for(Account acc:invoiceRecipientAccounts){
              relatedAccIds.add(acc.Id);
          }
          Map<String,Integer> aggRelatedRelationshipsCountMap = getAggRelationshipsCountMap(relatedAccIds,false);
          List<Account> IRs_hasMoreThanOneRelationship=new List<Account>();
          for(Account acc:invoiceRecipientAccounts){
              if(aggRelatedRelationshipsCountMap.containsKey(acc.Id)){
                  if(aggRelatedRelationshipsCountMap.get(acc.Id) > 1)
                  IRs_hasMoreThanOneRelationship.add(acc);
              }              
          }
          checkForTheModifiedInvoiceRecipients(IRs_hasMoreThanOneRelationship,invoiceRecipientAccountsOldMap);          
          system.debug(logginglevel.Info, '@@@@ aggRelatedRelationshipsCountMap:' + aggRelatedRelationshipsCountMap);
    }
    private static void checkForTheModifiedInvoiceRecipients(List<Account> IRs_hasMoreThanOneRelationship,Map<Id,Account> invoiceRecipientAccountsOldMap){
        Map<String, Schema.SObjectField> accountFieldMap=UTIL_Meta.getFieldMap('Account');
        List<Schema.SObjectField> fieldList=new List<Schema.SObjectField>();
        fieldList.addAll(accountFieldMap.values());
        for(Account IR_Acc:IRs_hasMoreThanOneRelationship){
            
            sObject new_SObject=IR_Acc; 
            Id sObjectId=(ID) new_sObject.get('Id');
            if(invoiceRecipientAccountsOldMap.containsKey(sObjectId)){
               sObject old_Sobject = invoiceRecipientAccountsOldMap.get(sObjectId);
               for(Schema.SObjectField sfield:fieldList){
                   if(new_sObject.get(sfield.getDescribe().getname()) != old_sObject.get(sfield.getDescribe().getname())){  
                       IR_Acc.addError(System.Label.Invoice_recipient_has_relationships_and_can_not_be_updated);
                       break;
                   }
               }
            }
            
        }
    }
}