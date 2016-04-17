/**
    About
    -----
    Description: This class is used to test G2O_PreChatForm_VFC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
    1.Test the functionality of PreChat Form
    
    Update History
    --------------
    Created April 2014 - C.H.F.
    
    Issues / TODOs
    --------------
*/
@isTest
Public class G2O_PreChatForm_VFC_TEST {
    
    public static testmethod void preChatFormTest(){
        
        //Arrange
        LiveAgent_Blocked_IPs__c liveAgent = new LiveAgent_Blocked_IPs__c();  //Creating Custom Setting data
        liveAgent.name = '193.234.247.50';
        
        //Act
        Test.startTest();
        insert liveagent;
        Test.stopTest();
            
        //Initializing the VF Page
        PageReference myPageRef = Page.G2O_PreChatForm;
        Test.setCurrentPage(myPageRef);
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP','193.234.247.50');

        //Initializing the PreChatObj class
        G2O_PreChatForm_VFC  preChatObj = new G2O_PreChatForm_VFC ();
        
        //Assert
        System.AssertEquals(true,preChatObj.blockedUser);
        
    }
                              
}