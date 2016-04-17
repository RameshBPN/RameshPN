/**
    About
    -----
    Description: Batch class for going through AccountTeamMembers and take appropiate actions
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: September 2013
    
    Details
    -------
    1. Finds AccountTeamMembers created since last run and copies fields to their Accounts.
    2. Finds AccountTeamMembers created since last run on LegalEntity Accounts and clones them onto any child WorkSite Accounts
    
    Update History 
    --------------
    Created September 2013 - K.E.A.J. 
    
    Issues / TODOs:
    --------------  
*/ 
global with sharing class G2O_AccountTeamMemberSync_BATCH implements Database.Batchable<sObject>, Database.stateful{

    //A.T.T.R.I.B.U.T.E.S
    global String querystring;
    global Boolean heapSizeReached = false;
    global DateTime startTime;    
    global boolean errorDuringRun = false; 
    global String legalEntityRT = UTIL_META.getAccountLegalEntityRT();
    global String WorksiteRT = UTIL_META.getAccountWorkSiteRT();
    global list<String> errorList = new list<String>();
    global list<String> debugList = new list<String>();
    global set<id> unDeletedIds = new set<id>();
    
    // A map to contain the data from the Custom setting in a more approachable way.
    global map<String, list<AccountTeamMemberToAccountMapping__c>> RolesToDataMap = new map<String, list<AccountTeamMemberToAccountMapping__c>>();
    global map<String, AccountTeamMemberToAccountMapping__c> atm2AccMap;
    global map<String, AccountTeamMemberRolesToSync__c> accTeamMemberRolesToSyncMap = UTIL_OrgSettings.AccountTeamMemberRolesToSync();
    global map<String, AccountTeamMemberBatchErrorList__c> accTeamMemberBatchErrorMap = UTIL_OrgSettings.AccountTeamMemberBatchErrorList();
    global list<AccountTeamMemberBatchErrorList__c> accTeamMemberBatchNewErrorList = new list<AccountTeamMemberBatchErrorList__c>();


    // 
    global map<String, dateTime> processedAccountRoleMap = new map<String, dateTime>();
     
    // A unique set of all sourcefields
    global set<String> sourceFieldSet = new set<String>();      
    
    public static final Integer LIMIT_HEAP_SIZE = Integer.ValueOf(UTIL_OrgSettings.AccountBatchHeapLimit());
    public static final Integer LIMIT_DML_ROWS = Integer.ValueOf(UTIL_OrgSettings.AccountBatchDmlRowsLimit());
    public static final DateTime TIME_SINCE_LAST_SUCCESS = UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime();   
   
   
    //C.O.N.S.T.R.U.C.T.O.R
    global G2O_AccountTeamMemberSync_BATCH(){
        // Fetch custom setting containing roles to check for and fields to copy from/to
        System.debug(logginglevel.warn, 'G2O_AccountTeamMemberSync_BATCH_SCH constructor'); 
        map<String,AccountTeamMemberToAccountMapping__c> atm2AccMap = UTIL_OrgSettings.AccountTeamMemberToAccountMapping();
        String atmRole;
        for(String str : atm2AccMap.keySet()){
            // Store variable to avoid getting from the map numerous times
            atmRole = atm2AccMap.get(str).Account_Team_Member_Role__c;
            
            if(RolesToDataMap.get(atmRole) == null){
                RolesToDataMap.put(atmRole, new list<AccountTeamMemberToAccountMapping__c>());
            }
            RolesToDataMap.get(atmRole).add(atm2AccMap.get(str));
            
            sourceFieldSet.add(atm2AccMap.get(str).SourceField__c);
        }   
        list<AccountTeamMemberBatchErrorList__c> ATMBatchErrorsToRemove = new list<AccountTeamMemberBatchErrorList__c>();
        for(AccountTeamMemberBatchErrorList__c error : accTeamMemberBatchErrorMap.values()){
            if(error.ErrorTime__c < DateTime.now().addDays(-1)){
                ATMBatchErrorsToRemove.add(error);
                unDeletedIds.add((id)error.name);
            }
        }
        delete ATMBatchErrorsToRemove;
        accTeamMemberBatchErrorMap = UTIL_OrgSettings.AccountTeamMemberBatchErrorList();

        startTime = dateTime.now();
        querystring = createSOQL();
    }
    
    //START METHOD
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug(logginglevel.warn, 'G2O_AccountTeamMemberSync_BATCH_SCH starting with query: ' + queryString + ' and Data: ' + Database.getQueryLocator(queryString)); 

        return Database.getQueryLocator(queryString);
    }
     
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<AccountTeamMember> accountTeamMemberLst){
        if(Limits.getHeapSize() < LIMIT_HEAP_SIZE) {
            //list<id> accountIds = new list<id>();
            map<id,Account> accountMap;
            list<AccountTeamMember> newATMList = new list<AccountTeamMember>();
            AccountTeamMember newATM;
            map<id, list<AccountTeamMember>> leParentAccountATM = new map<id, list<AccountTeamMember>>();
            map<id, list<AccountTeamMember>> parentAccountATM = new map<id, list<AccountTeamMember>>();
            map<id, list<Account>> parentAccountChildAccMap = new map<id, list<Account>>();
            map<id, Account> accountsToUpdate = new map<id, Account>();
            String previousSalesArea;
            id previousAccount;
            Account acc;

            // Making a map between Accounts and AccountTeamMember            
            for(AccountTeamMember ATM : accountTeamMemberLst){
                if(parentAccountATM.get(ATM.accountId) == null){
                    parentAccountATM.put(ATM.accountId, new list<AccountTeamMember>());
                }
                parentAccountATM.get(ATM.accountId).add(ATM); 
            }
    
                                       
            accountMap = new map<id,Account>([SELECT id, recordTypeId FROM Account WHERE id IN :parentAccountATM.keySet() OR ParentId IN :parentAccountATM.keySet() LIMIT 50000]);
            for(AccountTeamMember ATM : accountTeamMemberLst){
                // Filter 1 Update fields on account for Marketo
                if(RolesToDataMap.get(ATM.TeamMemberRole) != null && accTeamMemberBatchErrorMap.get(ATM.id) == null && accTeamMemberBatchErrorMap.get(ATM.accountid) == null){

                    if(processedAccountRoleMap.get(ATM.Accountid + ATM.TeamMemberRole) == null || processedAccountRoleMap.get(ATM.Accountid + ATM.TeamMemberRole) < ATM.createdDate){
                        for(AccountTeamMemberToAccountMapping__c atm2AccMap : RolesToDataMap.get(ATM.TeamMemberRole)){
                            // If the field is on a related object a different syntax is needed
                            try{
                                if(atm2AccMap.sourceField__c.contains('.')){
                                    accountMap.get(ATM.accountId).put(atm2AccMap.DestinationField__c,ATM.getSObject(atm2AccMap.sourceField__c.subString(0,atm2AccMap.sourceField__c.indexOf('.'))).get(atm2AccMap.sourceField__c.subString(atm2AccMap.sourceField__c.indexOf('.')+1)));
                                }
                                else{
                                    accountMap.get(ATM.accountId).put(atm2AccMap.DestinationField__c, ATM.get(atm2AccMap.sourceField__c));                              
                                }

                                processedAccountRoleMap.put(ATM.Accountid + ATM.TeamMemberRole, ATM.createdDate);
                            }
                            catch(SObjectException e){
                                errorDuringRun = true;
                                errorList.add('Non Compatible fields in Custom setting. Sourcefield: ' + atm2AccMap.sourceField__c + ' Doesnt match its destination field: ' + atm2AccMap.DestinationField__c + ' Error is: ' + e);
                            }
                        }
                        accountsToUpdate.put(ATM.accountId,accountMap.get(ATM.accountId));                   
                    }
                }
                // Filter 2 Populate changes to ATMs to the ATM's of children accounts
                if(accountMap.get(ATM.accountId).recordTypeId == legalEntityRT && accTeamMemberRolesToSyncMap.get(ATM.TeamMemberRole) != null){
                    if(leParentAccountATM.get(ATM.accountId) == null){
                        leParentAccountATM.put(ATM.accountId, new list<AccountTeamMember>());
                    }
                    leParentAccountATM.get(ATM.accountId).add(ATM);
                }
            }
            for(Account childAcc : [select id, parentId, name from Account WHERE Parentid IN :leParentAccountATM.keySet() AND RecordTypeid = :WorksiteRT]){
                if(parentAccountChildAccMap.get(childAcc.parentId) == null){
                    parentAccountChildAccMap.put(childAcc.parentId, new list<Account>());
                }
                parentAccountChildAccMap.get(childAcc.parentId).add(childAcc);
            }
            for(list<AccountTeamMember> parentATMList : leParentAccountATM.values()){

                for(AccountTeamMember ATM : parentATMList){       
                    if(parentAccountChildAccMap.get(ATM.Accountid) != null){
                        for(Account childAcc : parentAccountChildAccMap.get(ATM.Accountid)){
                            // Create ATM on the child accounts
                            newATM = ATM.clone(false, true, false, false);
                            newATM.Accountid = childAcc.id;
                            newATMList.add(newATM);
                        }
                    }
                }
            }
            try{
                // Creating a list to avoid having to poll the map repeatedely
                list<Account> accountsToUpdateList = accountsToUpdate.values();
                list<Database.SaveResult> srList = Database.update(accountsToUpdateList, false);

                for (integer i = 0; i < srList.size(); i++) {
                    if (!srList[i].isSuccess()) { 
                        errorDuringRun = true; 
                        system.debug(logginglevel.warn, 'ERROR: ' + srList[i]);
                        if(accountsToUpdateList[i] != null && parentAccountATM.get(accountsToUpdateList[i].id) != null){
                            for(AccountTeamMember failedATM : parentAccountATM.get(accountsToUpdateList[i].id)){
                                accTeamMemberBatchNewErrorList.add(new AccountTeamMemberBatchErrorList__c(name = failedATM.id,ErrorTime__c = DateTime.now(), accountid__c = failedATM.accountid));                          
                            }                           
                        }  
                        // Operation failed, so get all errors                
                        for(Database.Error err : srList[i].getErrors()) {
                            errorList.add(' An error occured when trying to update Account:' + accountsToUpdateList[i].id + ' Error is: ' + err);
                        }  
                    } 
                }
            } 
            catch(DMLException e){
                errorDuringRun = true;
                errorList.add(' An error occured when trying to update Accounts' + ' Error is: ' + e);
                
            }
            try{
                debugList.add('====> newATMList: ' + newATMList);
                insert newATMList; 
            }
            catch(DMLException e){
                errorDuringRun = true;
            }
            
        }
        //Sending mail -Reporting heap size issue.
        else{ 
            if(!heapSizeReached){
                UTIL_Error.report('Handled Exception','Maximum Heap Size Reached','AccountTeamMemberSync_BATCH');
                heapSizeReached = true;
            }
        }
    }
    
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){

            DateTime currentTime = System.now();
            for(String debug : debugList){
                system.debug(loggingLevel.warn, debug); 
            }
            ScheduledJobParameters__c scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
            if(!errorDuringrun){ 
                scheduledParameters.AccountTeamMemberSyncSuccessTime__c = startTime;
                
            }
            else{
                for(String error : errorList){
                    UTIL_Error.report('Handled Exception',error,'AccountTeamMemberSync_BATCH');                 
                }
                UTIL_Error.writeNow(); 
                update accTeamMemberBatchErrorMap.values();
                insert accTeamMemberBatchNewErrorList;
            }
            if(!Test.isRunningTest()){
                CronTrigger ct = [select id, NextFireTime From CronTrigger Where id = :scheduledParameters.AccountTeamMemberSyncJobId__c];
                if(ct.NextFireTime.addMinutes(-30) > DateTime.now().addHours(Integer.valueOf(scheduledParameters.AccountTeamMemberFrequency__c)) || 
                   ct.NextFireTime.addMinutes(30) < DateTime.now().addHours(Integer.valueOf(scheduledParameters.AccountTeamMemberFrequency__c))){
                        String scheduleT = calculateCronFrequency(Integer.valueOf(scheduledParameters.AccountTeamMemberFrequency__c));
                        String jobName = 'AccountTeamMemberSync_BATCH'+'_'+DateTime.now();
                        id jobId = System.schedule(jobName, scheduleT,new G2O_AccountTeamMemberSync_BATCH_SCH ());              
                        if(scheduledParameters.AccountTeamMemberSyncJobId__c != null){
                            system.abortJob((id)scheduledParameters.AccountTeamMemberSyncJobId__c);                 
                        }
                        scheduledParameters.AccountTeamMemberSyncJobId__c = jobId;
                }
            }
            update scheduledParameters;
    } 
    
    public String calculateCronFrequency(integer frequency){
        integer runsPrHour = 24 / frequency;
        if(runsPrHour < 1 || runsPrHour > 24){
            return 'Invalid Frequency';
        }

        String cronFrequency = '0 ' + DateTime.now().minute() + ' ';                
        for(integer i = 0; i < runsPrHour; i++){
            if(i > 0){
                cronFrequency += ',';
            }
            cronFrequency += ((i) * frequency);             
        }
        cronFrequency += ' * * ?';
        
        return cronFrequency;
    }   
    
    //Creating the query string.
    private String createSOQL(){
        
        String querystr = 'Select ';
        String roleLimitation = '';
        String sourceFields = '';
        
        // Adding all the AccountTeamMember fields to the sourceFieldSet, since the sourcefieldset
        // can contain fields on related objects also it is not enough to just ust the fields on ATM
        for(String atmField : AccountTeamMember.sObjectType.getDescribe().fields.getMap().keySet()){
            sourceFieldSet.add(atmField);
        }
        
        // Generating a list of needed fields on the AccountTeamMember object
        for(String sourceField : sourceFieldSet){
            if(sourceFields != ''){
                sourceFields += ', ';
            }
            sourceFields += sourceField;
        }
        
        querystr += sourceFields;
        querystr += ' FROM AccountTeamMember WHERE ';
        
        // merging the allowed roles for the different custom settings
        set<String> allowedRoles = new set<String>(RolesToDataMap.keySet());
        for(String teamRole : accTeamMemberRolesToSyncMap.keySet()){
            allowedRoles.add(teamRole);
        }
        // Generating a list of all limitations
        for(String RoleName : allowedRoles){
            if(roleLimitation != ''){
                roleLimitation += ' OR ';
            }
            else{
                roleLimitation += ' ( ';
            }
            roleLimitation += 'TeamMemberRole = \'' + RoleName + '\'';
        }
        
        querystr += roleLimitation;

        querystr += ') AND (CreatedDate > ' + TIME_SINCE_LAST_SUCCESS.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        if(unDeletedIds.size() > 0){
            querystr += 'OR id IN :unDeletedIds';
        }
        querystr += ') ORDER BY Accountid, TeamMemberRole, CreatedDate ASC';

        return querystr;
    }
}