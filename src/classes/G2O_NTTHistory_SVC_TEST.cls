/**
    About
    -----
    Description: This class is used to test NTTHistory_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of NTTHistory_SVC class.
    1.
    
    Update History
    --------------
    Created May 2013 - A.B.
    
    Issues / TODOs
    --------------
    
*/
@isTest
public with sharing class G2O_NTTHistory_SVC_TEST {
    
    
    //A.T.T.R.I.B.U.T.E.S
    static List<NTT_History__c> nttHistoryList;  //Holds list of NTT history records related to two caseproducts casePro1 & casePro2.
    
    static CaseProduct__c casePro1;                                             
    static CaseProduct__c casePro2;
    
    static NTT_History__c nttHistory1;
    static NTT_History__c nttHistory2;
    //A.T.T.R.I.B.U.T.E.S
    
    static testMethod void setLatestTrackingEventTest(){
        
        // Arrange
        createData();
        
        // Act
        Test.startTest();
        
        insert nttHistoryList;
        
        Test.stopTest();
                
        // Assert
        System.assertEquals(false,[Select Id,IsLatest__c From NTT_History__c where Id =: nttHistory1.Id].IsLatest__c);
        System.assertEquals(false,[Select Id,IsLatest__c From NTT_History__c where Id =: nttHistory2.Id].IsLatest__c);
        
        System.assertEquals(true,[Select Id,IsLatest__c From NTT_History__c where Id =: nttHistoryList[99].Id].IsLatest__c);
        System.assertEquals(true,[Select Id,IsLatest__c From NTT_History__c where Id =: nttHistoryList[200].Id].IsLatest__c);
        
    }
    
    //Creating test data.
    static void createData() {
        
        //Creating case.
        Case testCase1 =UTIL_TestFactory.createCase();
        insert testCase1;
        
        //Creating caseproducts.
        casePro1=UTIL_TestFactory.createCaseProd();
        casePro1.Case__c=testCase1.Id;
        
        casePro2=UTIL_TestFactory.createCaseProd();
        casePro2.Case__c=testCase1.Id;
        
        insert casePro1;
        insert casePro2;
        
        //Creating a single NTT History record.
        nttHistory1=UTIL_TestFactory.createNTTHistry();
        nttHistory1.Event_Description__c = 'test1';
        nttHistory1.CaseProduct__c=casePro1.Id;
        nttHistory1.Event_Time__c=system.now();
        
        nttHistory2=UTIL_TestFactory.createNTTHistry();
        nttHistory2.Event_Description__c = 'test2';
        nttHistory2.CaseProduct__c=casePro2.Id;
        nttHistory2.Event_Time__c=system.now();
        
        insert nttHistory1;
        insert nttHistory2;
        
        //Creating List of NTT History record.
        nttHistoryList = UTIL_TestFactory.createNTTHistrys();
        
        for(integer i=0;i<nttHistoryList.size();i++){
            
            nttHistoryList[i].Event_Description__c = 'WT'+i;
            nttHistoryList[i].Event_Time__c = system.now().addHours(i);
            
            if(i<100){
                nttHistoryList[i].CaseProduct__c=casePro1.Id;
                
            }else{
                nttHistoryList[i].CaseProduct__c=casePro2.Id;
            }
            
        }
    }
	
}