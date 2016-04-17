/**
    About
    -----
    Description:Class for General NTT_History__c Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details
    -------
     1. Sets the IsLatest__c  flag to true for the latest Tracking Event.
     
    Update History
    --------------
    Created May 2013 - A.B.
    
    Issues / TODOs
    --------------  
*/
public with sharing class G2O_NTTHistory_SVC {
    
    
    // 1. This is called from NTTHistory_BeforeInsert trigger,
    //    This sets the IsLatest__c  flag to true for the latest Tracking Event.
    public static void setLatestTrackingEvent(List<NTT_History__c> newNTTHistory){
        
        System.debug(LoggingLevel.info,'*** START: <NTTHistory_SVC>.<setPrimaryProductBeforeInsert>');
        try{
        	
            List<NTT_History__c> nttHistoryLst =new List<NTT_History__c>();                 //Holds old NTT_History__c records where IsLatest__c is set as false.
            
            Map<Id,NTT_History__c> cPIdToNewNTTHistoryMap =new Map<Id,NTT_History__c>();    //Holds caseProduct Id to new latest NTTHistory records mapping.
            Map<Id,NTT_History__c> cPIdToOldNTTHistoryMap =new Map<Id,NTT_History__c>();    //Holds caseProduct Id to old latest NTTHistory records mapping.
            
            
            //Preparing a Map holding the caseProduct to the latest tracking event.
            for(NTT_History__c nttHistory:newNTTHistory){
                
                if(cPIdToNewNTTHistoryMap.containsKey(nttHistory.CaseProduct__c)){
                	
                    if(nttHistory.Event_Time__c > cPIdToNewNTTHistoryMap.get(nttHistory.CaseProduct__c).Event_Time__c){
                        cPIdToNewNTTHistoryMap.remove(nttHistory.CaseProduct__c);       //Removing the record if more recent NTT record for the same caseproduct is found.
                        cPIdToNewNTTHistoryMap.put(nttHistory.CaseProduct__c,nttHistory);
                    }
                }else{

                    cPIdToNewNTTHistoryMap.put(nttHistory.CaseProduct__c,nttHistory);
                }
            }
            
            //Setting existing Tracking events IsLatest__c flag as false.
            for(NTT_History__c nttH:[Select n.IsLatest__c, n.Id, n.Event_Time__c, n.CaseProduct__c FROM NTT_History__c n WHERE n.CaseProduct__c IN:cPIdToNewNTTHistoryMap.KeySet() AND n.IsLatest__c=true]){
                nttH.IsLatest__c=false;
                nttHistoryLst.add(nttH);
            }
            
            //Setting New Tracking events IsLatest__c flag as true.
            for(Id cPId:cPIdToNewNTTHistoryMap.KeySet()){
                NTT_History__c newNTTHis = cPIdToNewNTTHistoryMap.get(cPId);
                newNTTHis.IsLatest__c=true;
            }
            
            if(!nttHistoryLst.isEmpty())
            update nttHistoryLst;           //Updating the old NTT History records with IsLatest__c as false.
            
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <NTTHistory_SVC>.<setPrimaryProductBeforeInsert>');
        
    }

}