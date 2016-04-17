/**
    About
    -----
    Description: This class is used to test NTTSearch_VFCx.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of NTTSearch_VFCx class.
    1.createCaseTest:Test the doItemSearch & createCase method of NTTSearch_VFCx class.
    2.updateCaseTest:Test the doItemSearch & updateCase method of NTTSearch_VFCx class.
    
    Update History
    --------------
    Created April 2013 - A.B.
    
    Issues / TODOs
    --------------
    
*/
@isTest()
private class G2O_NTTSearch_VFCx_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static Id rTypeId;
    
    static Case cas;
    static Account acc; 
    static NTT_History__c nttHistry;
    
    static List<CaseProduct__c> caseProdLst = new List<CaseProduct__c>();
    static List<NTT_History__c> nttHistryLst =new List<NTT_History__c>();
    //A.T.T.R.I.B.U.T.E.S
    
    
    //1.Test Method to test createCase functionality.
    static testMethod void testCreateCase(){
        
        // Creating test data.
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsNTT');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        createData();
        
        System.assertEquals(1, [Select count() from CaseProduct__c]);
        System.assertEquals(1, [Select count() from Case]);
        System.assertEquals(1, [Select count() from NTT_History__c]);
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        PageReference pageRef = Page.G2O_NTTSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController theController = new ApexPages.StandardSetController(caseProdLst);
        
        G2O_NTTSearch_VFCx objExt = new G2O_NTTSearch_VFCx(theController); 
        objExt.itemId=caseProdLst[0].Item_Id__c;
        objExt.rType=rTypeId; 
        objExt.doItemSearch();      
        objExt.createCase();
        Test.stopTest();
        
        // Assert
        System.assertEquals(2, [Select count() from CaseProduct__c]);
        System.assertEquals(2, [Select count() from Case]);
        System.assertEquals(7, [Select count() from NTT_History__c]);
    }
    
     //2.Test Method to test update Case functionality.
    static testMethod void testUpdateCase1(){
        
        // Creating test data.
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsNTT');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        createData();
        
        System.assertEquals(1, [Select count() from CaseProduct__c]);
        System.assertEquals(1, [Select count() from Case]);
        System.assertEquals(1, [Select count() from NTT_History__c]);
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        PageReference pageRef = Page.G2O_NTTSearch;
        Test.setCurrentPage(pageRef);
        
        //Creating the URL
        ApexPages.currentPage().getParameters().put('id', cas.id);
        
        ApexPages.StandardSetController theController = new ApexPages.StandardSetController(caseProdLst);
        G2O_NTTSearch_VFCx objExt = new G2O_NTTSearch_VFCx(theController);
         
        objExt.itemId=caseProdLst[0].Item_Id__c;
        objExt.rType=rTypeId; 
        objExt.doItemSearch();      
        objExt.updateCase();
        Test.stopTest();
        
        // Assert
        System.assertEquals(2, [Select count() from CaseProduct__c]);
        System.assertEquals(1, [Select count() from Case]);
        System.assertEquals(7, [Select count() from NTT_History__c]);
    }
    
    //3. Test error handeling
    static testMethod void testErrorHandeling(){
        
        // Creating test data.
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsNTT');
        successfulMock.setStatusCode(400); // Simulate error
        successfulMock.setHeader('Content-Type', 'text/xml');
        createData();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        PageReference pageRef = Page.G2O_NTTSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController theController = new ApexPages.StandardSetController(caseProdLst);
        
        G2O_NTTSearch_VFCx objExt = new G2O_NTTSearch_VFCx(theController); 
        objExt.itemId=caseProdLst[0].Item_Id__c;
        objExt.rType=rTypeId; 
        objExt.doItemSearch();      
        objExt.createCase();
        Test.stopTest();
        
        // Assert
        System.assert(ApexPages.hasMessages(), 'No error was added to page');
    }
    
    //4. Test ResponseException handeling
    static testMethod void testResponseException(){
        
        // Creating test data.
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponseErrorNTT_noItem');
        errorMock.setStatusCode(200);
        errorMock.setHeader('Content-Type', 'text/xml');
        createData();
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, errorMock);
        PageReference pageRef = Page.G2O_NTTSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController theController = new ApexPages.StandardSetController(caseProdLst);
        
        G2O_NTTSearch_VFCx objExt = new G2O_NTTSearch_VFCx(theController); 
        objExt.itemId=caseProdLst[0].Item_Id__c;
        objExt.rType=rTypeId; 
        objExt.doItemSearch();      
        objExt.createCase();
        Test.stopTest();
        
        // Assert
        System.assert(ApexPages.hasMessages(), 'No error was added to page');
    }
    
    //Creating test data
    public static void createData() {
        
        rTypeId = UTIL_Meta.getCaseItemSearchRT();
        CaseProduct__c caseProd=new CaseProduct__c();
        
        acc=UTIL_TestFactory.createAccount();
        acc.Postal_Address_C_O__c='2100 KJ';
        acc.Involved_Party_ID__c='978777';
        insert acc;
        
        cas=UTIL_TestFactory.createCase();
        cas.Status='For Approval';
        cas.Priority='Medium';
        cas.Origin='Telefon';
        insert cas;
        
        caseProd=UTIL_TestFactory.createCaseProd();
        caseProd.Item_Id__c='85829178741SE';
        caseProd.Status__c='For Approval';
        caseProd.Case__c=cas.Id;
        caseProdLst.add(caseProd);
        insert caseProdLst;
        
        nttHistry=UTIL_TestFactory.createNTTHistry();
        nttHistry.CaseProduct__c=caseProd.Id;
        nttHistry.Item_Id__c=caseProd.Item_Id__c;
        nttHistry.Event_Time__c=system.now();
        nttHistryLst.add(nttHistry);

        insert nttHistryLst;
    }
}