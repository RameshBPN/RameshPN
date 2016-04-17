/**
    About
    -----
    Description: Before Update Trigger on Live Chat Transcript
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013 .
    
    Filters:
    -------
        1. Checking Block IP new value is true and Block IP old value is false.
        2. Checking Block IP new value is false and Block IP old value is true   
    
    Update History
    --------------
     Created April 2013 - Richa Tripathi.
    
    Issues / TODOs
    --------------  
    
*/

trigger LiveChatTranscript_BeforeUpdate on LiveChatTranscript (before update) {

    Set<LiveChatTranscript> toInsertAddresses = new Set<LiveChatTranscript>();
    Set<LiveChatTranscript> toDeleteAddresses = new Set<LiveChatTranscript>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {  // Allow users to disable Triggers.
        
        for(LiveChatTranscript liveRec : Trigger.new){
        
            //Filter 1
            if(liveRec.Block_IP__c && Trigger.oldMap.get(liveRec.id).Block_IP__c==false && liveRec.IpAddress != null){
                toInsertAddresses.add(liveRec);
            }
            
            //Filter 2
            if(liveRec.Block_IP__c == false && Trigger.oldMap.get(liveRec.id).Block_IP__c && liveRec.IpAddress != null){
                toDeleteAddresses.add(Trigger.oldMap.get(liveRec.id));
            }
        }
        
        // Execute logic in a service class
    
        // Filter 1:
        if(toInsertAddresses.size()>0)  
            G2O_LiveChatTranscript_SVC.addIPToBlockList(toInsertAddresses);
            
        // Filter 2:
        if(toDeleteAddresses.size()>0)  
            G2O_LiveChatTranscript_SVC.removeIPFromBlockList(toDeleteAddresses);    
    }
}