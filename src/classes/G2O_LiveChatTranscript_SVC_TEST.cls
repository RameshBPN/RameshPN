/**
    About
    -----
    Description: This class is used to test G2O_LiveChatTranscript_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2014

    Details
    -------
    1. Tests adding of IP Address on Live Chat Transcripts update.
    2. Tests deletion of IP Address on Live Chat Transcripts update.
    
    Update History
    --------------
    Create date: April 2014 
   
    Issues / TODOs
    --------------        
*/
@isTest
public with sharing class G2O_LiveChatTranscript_SVC_TEST{
    
    // Test the old value is false and new value is true 
    static testMethod void addIPToBlockListTest(){
    
        //Arrange
        UTIL_TestFactory.setUpOrg();
        LiveChatTranscript liveChatTranscript = UTIL_TestFactory.createLiveChatTranscript();
        liveChatTranscript.IpAddress ='202.60.63.100';
        liveChatTranscript.Block_IP__c = false;
        insert liveChatTranscript;
        liveChatTranscript.Block_IP__c = true;
        
        //Act 
        Test.startTest();
        update liveChatTranscript;
        Test.stopTest();
        
        //Assert 
        LiveAgent_Blocked_IPs__c blockedIP = [SELECT Id, Name FROM LiveAgent_Blocked_IPs__c WHERE Name = '202.60.63.100'];
        System.assertEquals(liveChatTranscript.IpAddress, blockedIP.Name, 'The IP addresses does not match');
    
    }
    
    // Test the new value is false and old value is true 
    static testMethod void removeIPFromBlockList(){
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        LiveChatTranscript liveChatTranscript = UTIL_TestFactory.createLiveChatTranscript();
        liveChatTranscript.IpAddress ='120.80.40.00';
        liveChatTranscript.Block_IP__c = true;
        insert liveChatTranscript;
        liveChatTranscript.Block_IP__c = false;
        
        //Act
        Test.startTest();   
        update liveChatTranscript;
        Test.stopTest();  
        
        //Assert
        system.assertEquals(0,[select count() FROM LiveAgent_Blocked_IPs__c WHERE Name = '120.80.40.00']);
    
    }
    
}