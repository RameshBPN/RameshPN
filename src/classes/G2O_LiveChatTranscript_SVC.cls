/**
    About
    -----  
    Description:Class for Live Chat Transcript Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Created  April 2013 - Richa Tripathi
    
    Details
    -------
    1.  Method takes the Visitor IP Address from Live Chat Transcripts Object and insert a Visitor IP Address in custom settings when BlockIP is checked On Live chat Transcripts Object.
    2.  Method delete the Visitor IP Address from custom settings when on update Block IP field is unchecked.
    
    Update History
    --------------
    Created April 2013 - Richa Tripathi
   
    Issues / TODOs: 
    --------------  
*/
public with sharing class G2O_LiveChatTranscript_SVC{
    
    // 1.  Method takes the Visitor IP Address from Live Chat Transcripts Object and insert a Visitor IP Address in custom settings when BlockIP is checked On Live chat Transcripts Object.
    public static void addIPToBlockList(Set<LiveChatTranscript> liveChatSet){
    
    System.debug(LoggingLevel.info,'*** START: <G2O_LiveChatTranscript_SVC>.<addIPToBlockList>');
     
        try{
            List<LiveAgent_Blocked_IPs__c> liveagentToInsertList = new List<LiveAgent_Blocked_IPs__c>();    //Holds IpAddress which has to be inserted.
            LiveAgent_Blocked_IPs__c liveBlockedIps;
            for(LiveChatTranscript lc : liveChatSet){
                liveBlockedIps = new LiveAgent_Blocked_IPs__c();
                liveBlockedIps.name = lc.IpAddress;
                liveagentToInsertList.add(liveBlockedIps);
            }
            insert liveagentToInsertList;
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        
    System.debug(LoggingLevel.info,'*** END: <G2O_LiveChatTranscript_SVC>.<addIPToBlockList>');
    }
    
    // 2.  Method delete the Visitor IP Address from custom settings when on update Block IP field is unchecked.
    public static void removeIPFromBlockList(Set<LiveChatTranscript> liveChatSet){
    
    System.debug(LoggingLevel.info,'*** START: <G2O_LiveChatTranscript_SVC>.<removeIPFromBlockList>');
    
        try{
            List<LiveAgent_Blocked_IPs__c> liveagentToDeleteList = new List<LiveAgent_Blocked_IPs__c>();    //Holds Live Chat Visitor Name which has to be deleted.
            Set<String> addresses = new Set<String>();                                                     //Holds Visitor IP Address to Live Chat Transcripts.
            for(LiveChatTranscript lc : liveChatSet){
                addresses.add(lc.IpAddress);
            }
            //deleting a visitor ip address from custom settings when block ip field is unchecked.
            liveagentToDeleteList = [SELECT Name FROM LiveAgent_Blocked_IPs__c where name IN:addresses];
            delete liveagentToDeleteList;
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        } 

    System.debug(LoggingLevel.info,'*** END: <G2O_LiveChatTranscript_SVC>.<removeIPFromBlockList>');
    }
}