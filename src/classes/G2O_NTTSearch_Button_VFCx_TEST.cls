/**
    About
    -----
    Description: This class is used to test NTTSearch_Button_VFCx.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    This Class test the functionality of NTTSearch_Button_VFCx class.
    1.createCaseTest:Test the NTTSearch_Button functionality.

    -----------------------
        
    Update History
    --------------
    Created April 2013 - A.B.
    
    Issues / TODOs
    --------------  
*/

@isTest()
private class G2O_NTTSearch_Button_VFCx_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static CaseProduct__c caseProd ;
    static Case cas;
    static Id rTypeId;
    //A.T.T.R.I.B.U.T.E.S
    
    //1. Test the NTTSearch_Button functionality.
    static testMethod void updateCaseTest(){
        
        // Creating test data.
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsNTT');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        
        createData();
        
        System.assertEquals('85829178741SE', [Select Id,Item_Id__c from CaseProduct__c].Item_Id__c);
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        PageReference pageRef = Page.G2O_NTTSearch_Button;
        pageRef.getParameters().put('id', caseProd.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardController theController = new ApexPages.standardController(caseProd);
        G2O_NTTSearch_Button_VFCx ext = new G2O_NTTSearch_Button_VFCx(theController);
        system.debug('+++cas+++'+cas);
        ext.nttUpdate();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(6, [SELECT COUNT() FROM NTT_History__c]);
    }

    //creating test data
    public static void createData() {
        rTypeId=[Select r.Name, r.Id, r.DeveloperName From RecordType r where r.DeveloperName='Item_Search'].Id;
        
        cas=UTIL_TestFactory.createCase();
        cas.Status='For Approval';
        cas.Priority='Medium';
        cas.Origin='Telefon';
        //cas.Sender__c = 'TEST';
        cas.Sender_Name__c = 'TEST';
        cas.Sender_Postal_Address_Street__c = 'TEST';
        cas.Sender_Postal_Address_Postal_Code__c = 'TEST';
        cas.Sender_Postal_Address_Country__c = 'DK';
        cas.Sender_Postal_Address_City__c = 'TEST';
        cas.Sender_Postal_Address_C_O__c = 'TEST';
        //cas.Receiver__c = 'TEST';
        cas.Receiver_Postal_Address_Street__c = 'TEST';
        cas.Receiver_Postal_Address_Postal_Code__c = 'TEST';
        cas.Receiver_Postal_Address_Country__c = 'DK';
        cas.Receiver_Postal_Address_City__c = 'TEST';
        cas.Receiver_Postal_Address_C_O__c = 'TEST';
        insert cas;
        
        caseProd=UTIL_TestFactory.createCaseProd();
        caseProd.Item_Id__c='85829178741SE';
        caseProd.Status__c='For Approval';
        caseProd.Case__c=cas.Id;
        insert caseProd;
        
    }

}