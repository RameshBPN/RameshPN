/**
    About
    -----
    Description: Service class for PossibleDuplicateAccount Object.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Details
    -------
    The PossibleDuplicateAccount service class will reflect changes done on PossibleDuplicateAccount Obj.
     1. Creates PossibleDuplicateAccount__c records,identified based on:
        a. Short_Name__c,Postal_Address_City__c,Postal_Address_Country__c & Verified__c.
        b.MOD_Modtager_Number__c.
        c.MOD_Interessent_Number__c
        d.PAR
     
    Update History
    --------------
    Created June 2013 - A.B.
    
    Issues / TODOs
    --------------  
*/
public with sharing class G2O_PossibleDuplicateAccount_SVC {
    
    //A.T.T.R.I.B.U.T.E.S
    
    public static final String MOD_INTRESSENT = 'INTRESSENT';
    public static final String MOD_MODTAGER = 'MODTAGER';
    public static final String PAR = 'PAR';
    public static final String BATCH = 'OTHER';
    public static Set<Id> accountIdSet = new Set<Id>();
    public static Set<String> accountKeySet = new Set<String>();
    public static Map<Id,Set<Id>> accIdToFixedRepetitionMap = new Map<Id,Set<Id>>();
    static String duplicateReason;

    //A.T.T.R.I.B.U.T.E.S
        
        
    //1. Creates PossibleDuplicateAccount__c records. 
    public static void getPossibleDuplicateRecords(Map<Id,Set<Id>> accIdToSetOfDupeAccIdMap,String reason){
        
        system.debug('+++accIdToSetOfDupeAccIdMap+++'+accIdToSetOfDupeAccIdMap);
        system.debug('+++reason+++'+reason);
        system.debug('+++duplicateReason+++'+duplicateReason);
        
        Map<Id,Set<Id>> accIdToFixedFinalAccIdMap = new Map<Id,Set<Id>>();
        Set<sObject> updatePossibleDuplicateSet = new Set<sObject>();
        
        //Getting the reason for duplication from customsetting.
        getDuplicateReason(reason);
        
        //Removes the repetative key-value & value-key combination from the map.
        accIdToFixedRepetitionMap = getRepetitionFix(accIdToSetOfDupeAccIdMap);
        
        //Check if the incomming records already exist in PossibleDuplicateAccount__c obect in SFDC.
        existingPossibleDuplicateCheck(accIdToFixedFinalAccIdMap,updatePossibleDuplicateSet);
        
        //If the reason is PAR for rest of the reasons the method is called from the finish method of the Batch class. // TODO: Reword this, it makes no sense!
        
        upsertPossibleDuplicateAccounts(reason,accIdToFixedFinalAccIdMap,updatePossibleDuplicateSet);
    }
    
    
    //2. Creates PossibleDuplicateAccount__c records,This method is called from BATCH. 
    public static void getPossibleDuplicateRecords(Map<Id,Set<Id>> accIdToSetOfDupeAccIdMap,Map<Id,Set<Id>> accIdToFixedFinalAccIdMap,Set<sObject> updatePossibleDuplicateSet,String reason){
                
        //Getting the reason for duplication from customsetting.
        getDuplicateReason(reason);
        
        //Removes the repetative key-value & value-key combination from the map.
        accIdToFixedRepetitionMap = getRepetitionFix(accIdToSetOfDupeAccIdMap);
                
        //Check if the incomming records already exist in PossibleDuplicateAccount__c obect in SFDC.
        existingPossibleDuplicateCheck(accIdToFixedFinalAccIdMap,updatePossibleDuplicateSet);
                
    }
    
    
    //3. Update Account & PossibleDuplicateAccount__c records.
    public static void upsertPossibleDuplicateAccounts(String reason,Map<Id,Set<Id>> accIdToFixedFinalAccIdMap,Set<sObject> updatePossibleDuplicateSet){
        
        List<PossibleDuplicateAccount__c> possibleDuplicateAccountList = new List<PossibleDuplicateAccount__c>();
        List<Account> dupeCheckedAccLst = new List<Account>();
        getDuplicateReason(reason);
        
        //Setting the Duplicate checked Flag for PAR 
        if(reason == PAR){
            
            for(Id accId : accountIdSet){
                dupeCheckedAccLst.add(new Account(Id=accId, External_Provider_Duplicate__c = true));
            }
            //Updating Account records.
            database.Saveresult[] accountResult=Database.update(dupeCheckedAccLst, false);  
        }
        
        //Creating PossibleDuplicateAccount__c records.
        Map<Id,Set<Id>> accIdToFinalAccIdMap = new Map<Id,Set<Id>>();
        accIdToFinalAccIdMap = getRepetitionFix(accIdToFixedFinalAccIdMap);
        
        for(Id accId:accIdToFinalAccIdMap.keySet()){
            for(Id dupeAccId:accIdToFinalAccIdMap.get(accId)){
                
                if(dupeAccId!=null){
                    possibleDuplicateAccountList.add(new PossibleDuplicateAccount__c(Account__c = accId, Possible_Duplicate_Account__c = dupeAccId, Duplicate_reason__c=duplicateReason));
                    
                }
            }
        }
        
        //Creating new PossibleDuplicateAccount__c records.
        database.Saveresult[] possDupeInsertResult=Database.insert(possibleDuplicateAccountList, false);
        system.debug('+++++possDupeResult.Size()++++'+possDupeInsertResult.size());
        
        //Updating old PossibleDuplicateAccount__c records.
        database.Saveresult[] possDupeUpdateResult=Database.update(UTIL_Apex.toList(updatePossibleDuplicateSet), false);
        system.debug('+++++possDupeResult55.Size()++++'+possDupeUpdateResult.size());

    }
    
    
    //Removes the repetative key-value & value-key combination from the map.
    public static Map<Id,Set<Id>> getRepetitionFix(Map<Id,Set<Id>> accIdToSetOfDuplicateAccIdMap){
        
        Map<Id,Set<Id>> accIdToRepetitionFixMap = new Map<Id,Set<Id>>();
        accountKeySet = new Set<String>();
        accountIdSet = new Set<Id>();
        accIdToFixedRepetitionMap = new Map<Id,Set<Id>>();
        
        for(Id accId :accIdToSetOfDuplicateAccIdMap.keySet()){
            
            for(Id duplicateAccId: accIdToSetOfDuplicateAccIdMap.get(accId)){
                
                String accKey1 = accId+':'+duplicateAccId;
                String accKey2 = duplicateAccId+':'+accId;
                                
                if(!accountKeySet.contains(accKey1) && !accountKeySet.contains(accKey2) && (accId != duplicateAccId)){ 
                    
                    accountIdSet.add(accId);
                    accountIdSet.add(duplicateAccId);
                    accountKeySet.add(accKey1);
                    accountKeySet.add(accKey2);
                    
                    if(accIdToRepetitionFixMap.containsKey(accId)){
                        accIdToRepetitionFixMap.get(accId).add(duplicateAccId);
                    }else{
                        accIdToRepetitionFixMap.put(accId,new Set<Id> {duplicateAccId});
                    }
                }
                
            }
            
        }

        return accIdToRepetitionFixMap;
    }
    
    
    //Check if the incomming records already exist in PossibleDuplicateAccount__c obect in SFDC.
    public static void existingPossibleDuplicateCheck(Map<Id,Set<Id>> accIdToFixedFinalAccIdMap,Set<sObject> updatePossibleDuplicateSet){
        
        for(PossibleDuplicateAccount__c possDup: [Select p.Possible_Duplicate_Account__c, p.Duplicate_reason__c, p.Account__c From PossibleDuplicateAccount__c p WHERE (p.Account__c IN: accountIdSet OR p.Possible_Duplicate_Account__c IN: accountIdSet) limit 10000]){
                                                            
            String possibleDupAccKey1 = possDup.Account__c+':'+possDup.Possible_Duplicate_Account__c;
            String possibleDupAccKey2 = possDup.Possible_Duplicate_Account__c+':'+possDup.Account__c;
                                    
            for(Id accId :accIdToFixedRepetitionMap.keySet()){
                
                //CONDITION1.
                if((accId == possDup.Account__c) && accIdToFixedRepetitionMap.get(accId).contains(possDup.Possible_Duplicate_Account__c) ){
                    
                    updatePossibleDuplicate(possDup,updatePossibleDuplicateSet);
                    accIdToFixedRepetitionMap.get(accId).remove(possDup.Possible_Duplicate_Account__c);
                    
                }
                //CONDITION2.
                else if((accId == possDup.Possible_Duplicate_Account__c) && accIdToFixedRepetitionMap.get(accId).contains(possDup.Account__c)){
                    
                    updatePossibleDuplicate(possDup,updatePossibleDuplicateSet);
                    accIdToFixedRepetitionMap.get(accId).remove(possDup.Account__c);

                }
                //CONDITION3.
                else if ((accId != possDup.Account__c && accId != possDup.Possible_Duplicate_Account__c) && (accIdToFixedRepetitionMap.get(accId).contains(possDup.Account__c) && accIdToFixedRepetitionMap.get(accId).contains(possDup.Possible_Duplicate_Account__c))){
                    
                    updatePossibleDuplicate(possDup,updatePossibleDuplicateSet);
                    accIdToFixedRepetitionMap.get(accId).remove(possDup.Possible_Duplicate_Account__c);
                    accIdToFixedRepetitionMap.get(accId).remove(possDup.Account__c);

                }
                
            }
        }
                
        //Merge the new Map from new batch of records with the AccountDuplicateCheck_BATCH.accIdToFixedFinalAccIdMap Map.
        mergeMap(accIdToFixedRepetitionMap,accIdToFixedFinalAccIdMap);
        
    }
    
    //Updates the possible duplicate records with new Duplicate reason.
    public static void updatePossibleDuplicate(PossibleDuplicateAccount__c possDup,Set<sObject> updatePossibleDuplicateSet){
                
        //Collecting the possible duplicate records that already exist in SFDC & needs to be updated with the new duplication reason.
        if(possDup.Duplicate_reason__c != null && !possDup.Duplicate_reason__c.contains(duplicateReason)){
            possDup.Duplicate_reason__c = possDup.Duplicate_reason__c+';'+duplicateReason;
                        
        }else if(possDup.Duplicate_reason__c == null){
            
            possDup.Duplicate_reason__c = duplicateReason;
            
        }
        
        //Adding the PossibleDuplicateAccount__c to be updated.
        updatePossibleDuplicateSet.add((sObject)possDup);
        
    }
    
    
    //Merge the map passed as an argument with the accIdToFixedFinalAccIdMap Map
    public static void mergeMap(Map<Id,Set<Id>> accIdToFixedAccIdMap,Map<Id,Set<Id>> accIdToFixedFinalAccIdMap){
                
        for(Id accId :accIdToFixedAccIdMap.keySet()){
            
            for(Id accountId: accIdToFixedAccIdMap.get(accId)){

                if(accIdToFixedFinalAccIdMap.containsKey(accId)){
                    accIdToFixedFinalAccIdMap.get(accId).add(accountId);
                }else{
                    accIdToFixedFinalAccIdMap.put(accId,new Set<Id> {accountId});
                }
            }

        }

    }
    
    
    //Get the duplicate reason from custom setting.
    public static void getDuplicateReason(String reason){
		if(reason==PAR){
			duplicateReason = PAR;
		} else {
			duplicateReason = 'ILLEGAL REASON';
		}
    }
    
}