/**
    About
    -----
    Description: This class is used to test SAPGetPrices_VFCx.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details / Methods
    -----------------
    This Class test the functionality of NTTSearch_Button_VFCx class.

    -----------------------
        
    Update History
    --------------
    Created April 2013 - A.B.
    
    Issues / TODOs
    --------------  
*/
@isTest()
private class G2O_SAPGetPrices_VFCx_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static CaseProduct__c caseProd ;
    static Case cas;
    static Customer_Service_Product__c csp;
    //A.T.T.R.I.B.U.T.E.S
    
    //1. Test the SAP GetPrices functionality.
    static testMethod void getPricesTest(){
        User u = UTIL_TestFactory.createUser('SAPTestUser@test.test', 'Standard User');
        u.Sales_Area1__c = 'SA1234'; //Must mach that of the Customer_Service_Product__c
        insert u;
        
        // Creating test data.
        // Arrange
        System.runAs(u){
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsSAP');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        createData();
        
        System.assertEquals(null, [Select Id,Net_Value__c from CaseProduct__c].Net_Value__c);
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        PageReference pageRef = Page.G2O_SAPGetPrices;
        pageRef.getParameters().put('id', caseProd.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardController theController = new ApexPages.standardController(caseProd);
        G2O_SAPGetPrices_VFCx ext = new G2O_SAPGetPrices_VFCx(theController);
        ext.getPrices();
        Test.stopTest();
        //Assert
        System.assertEquals(11, [Select Id,Net_Value__c from CaseProduct__c].Net_Value__c);
        }
    }
    
    //2. Test error handeling
    static testMethod void getPricesTestError(){
        User u = UTIL_TestFactory.createUser('SAPTestUser@test.test', 'Standard User');
        u.Sales_Area1__c = 'SA1234'; //Must mach that of the Customer_Service_Product__c
        insert u;
        
        // Creating test data.
        // Arrange
        System.runAs(u){
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsSAP');
        successfulMock.setStatusCode(400);
        successfulMock.setHeader('Content-Type', 'text/xml');
        createData();
        
        System.assertEquals(null, [Select Id,Net_Value__c from CaseProduct__c].Net_Value__c);
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        PageReference pageRef = Page.G2O_SAPGetPrices;
        pageRef.getParameters().put('id', caseProd.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardController theController = new ApexPages.standardController(caseProd);
        G2O_SAPGetPrices_VFCx ext = new G2O_SAPGetPrices_VFCx(theController);
        ext.getPrices();
        Test.stopTest();
        //Assert
        System.assert(ApexPages.hasMessages(), 'No error was added to page');
        }
    }
    
    //3. Test exception handeling
    static testMethod void getPricesTestMappingException(){
        User u = UTIL_TestFactory.createUser('SAPTestUser@test.test', 'Standard User');
        u.Sales_Area1__c = 'SA1234'; //Must mach that of the Customer_Service_Product__c
        insert u;
        
        // Creating test data.
        // Arrange
        System.runAs(u){
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsSAP');
        successfulMock.setStatusCode(400);
        successfulMock.setHeader('Content-Type', 'text/xml');
        createData();
        caseProd.Customer_Service_Product__c = null; // This will cause an MappingException
        update caseProd;
        
        System.assertEquals(null, [Select Id,Net_Value__c from CaseProduct__c].Net_Value__c);
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        PageReference pageRef = Page.G2O_SAPGetPrices;
        pageRef.getParameters().put('id', caseProd.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardController theController = new ApexPages.standardController(caseProd);
        G2O_SAPGetPrices_VFCx ext = new G2O_SAPGetPrices_VFCx(theController);
        ext.getPrices();
        Test.stopTest();
        //Assert
        System.assert(ApexPages.hasMessages(), 'No error was added to page');
        }
    }
    
    //4. Test exception handeling
    static testMethod void getPricesTestException(){
        User u = UTIL_TestFactory.createUser('SAPTestUser@test.test', 'Standard User');
        u.Sales_Area1__c = 'SA1234'; //Must mach that of the Customer_Service_Product__c
        insert u;
        
        // Creating test data.
        // Arrange
        System.runAs(u){
        UTIL_TestFactory.setUpOrg();
        createData();
        caseProd.Customer_Service_Product__c = null; // This will cause an MappingException
        
        System.assertEquals(null, [Select Id,Net_Value__c from CaseProduct__c].Net_Value__c);
        
        // Act
        Test.startTest();
        PageReference pageRef = Page.G2O_SAPGetPrices;
        pageRef.getParameters().put('id', caseProd.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardController theController = new ApexPages.standardController(caseProd);
        G2O_SAPGetPrices_VFCx ext = new G2O_SAPGetPrices_VFCx(theController);
        ext.getPrices();
        Test.stopTest();
        //Assert
        System.assert(ApexPages.hasMessages(), 'No error was added to page');
        }
    }
    
    //5. Test go back
    static testMethod void getPricesTestGoBack(){
        User u = UTIL_TestFactory.createUser('SAPTestUser@test.test', 'Standard User');
        u.Sales_Area1__c = 'SA1234'; //Must mach that of the Customer_Service_Product__c
        insert u;
        
        // Creating test data.
        // Arrange
        System.runAs(u){
        UTIL_TestFactory.setUpOrg();
        createData();
        
        // Act
        Test.startTest();
        PageReference pageRef = Page.G2O_SAPGetPrices;
        pageRef.getParameters().put('id', caseProd.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardController theController = new ApexPages.standardController(caseProd);
        G2O_SAPGetPrices_VFCx ext = new G2O_SAPGetPrices_VFCx(theController);
        Pagereference goBackPage = ext.goBack();
        Test.stopTest();
        
        //Assert
        System.assert(('/' + caseProd.Id).contains(goBackPage.getUrl()) , 'Not on correct page');
        }
    }
    
    //creating test data
    public static void createData() {
        
        //Creating custom setting.
        SAPGetPrices__c sapGetPrices = new SAPGetPrices__c();
        sapGetPrices.Name='Net Value';
        sapGetPrices.Include_Prices_PickVal__c='Net_Value__c';
        insert sapGetPrices;
        
        csp = UTIL_TestFactory.createProductArticl();
        insert csp;
        
        Account sender = UTIL_TestFactory.createAccount();
        insert sender;
        
        cas=UTIL_TestFactory.createCase();
        cas.Status='For Approval';
        cas.Priority='Medium';
        cas.Origin='Telefon';
        cas.Sender__c=sender.Id;
        insert cas;
        
        caseProd=UTIL_TestFactory.createCaseProd();
        caseProd.Item_Id__c='725623';
        caseProd.Status__c='For Approval';
        caseProd.Include_Prices__c='Net Value';         //Setting the multi select picklist
        caseProd.Case__c=cas.Id;
        caseProd.Customer_Service_Product__c = csp.Id;
        insert caseProd;
        
    }

}