/**
    About
    -----
    Description: This class is used to test CaseRecordTypeRedirect_VFCx.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of CaseRecordTypeRedirect_VFCx class.
    1.redirectToSearchPage:Test the redirectToSearchPage method of CaseRecordTypeRedirect_VFCx class.
    
    Update History
    --------------
    Created March 2013 - A.B.
    
    Issues / TODOs
    --------------
    
*/ 

@isTest()
private class G2O_CaseRecordTypeRedirect_VFCx_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static Id rTypeId;
    static String retURL;
    static String rType;
    static String cancelURL;
    //A.T.T.R.I.B.U.T.E.S
        
    static testMethod void redirectToSearchPage(){
        
        // Arrange
        createData();
        
        // Act
        Test.startTest();
        Case casObj =new Case();
        PageReference pageRef = Page.G2O_CaseRecordTypeRedirect;
        Test.setCurrentPage(pageRef);
        
        //Creating the URL
        ApexPages.currentPage().getParameters().put('RecordType', rTypeId);
        
        ApexPages.standardController theController = new ApexPages.standardController(casObj);
        G2O_CaseRecordTypeRedirect_VFCx ext = new G2O_CaseRecordTypeRedirect_VFCx(theController);
        ext.rType = rTypeId;
        ext.redirect();
        Test.stopTest();
        
        // Assert
        System.assertEquals(rTypeId, ext.returnURL.getParameters().get('RecordType'));
        System.assertEquals('/apex/g2o_nttsearch?nooverride=1&RecordType='+rTypeId, ext.returnURL.getUrl());   
    }

    static testMethod void redirectToSearchPageWithNoRecordTypeParameter(){    
        // Arrange
        createData();
        
        User testUser = UTIL_TestFactory.createUser('testUser@postnord.se.testRedirect', 'Standard User');
		insert testUser;
        // Arrange
        Account account = new Account(); 
        
        // Act
        Test.startTest();
		G2O_CaseRecordTypeRedirect_VFCx ext;
		system.runAs(testUser){
	        Case casObj =new Case();
	        PageReference pageRef = Page.G2O_CaseRecordTypeRedirect;
	        Test.setCurrentPage(pageRef);
	        
	        ApexPages.standardController theController = new ApexPages.standardController(casObj);
	        ext = new G2O_CaseRecordTypeRedirect_VFCx(theController);
	        ext.redirect();
		}
        Test.stopTest();
        
        // Assert 
	    system.assert(ext.returnURL.getURL().toUpperCase().contains('G2O_NTTSEARCH'), ext.returnURL.getURL());
    }
        
    //Creating TestData.
    static void createData() {
        
        //Creating Custom Setting.
        Get2OneCRM__c g2OneCs =new Get2OneCRM__c();
        g2OneCs.NTT_Search_RecordTypes__c='Item_Search,General_Question';
        insert g2OneCs;
        
        //Getting the Developer Name from Custom Setting.
        String developerName = 'Item_Search';
         
        //Getting the recordTypeId.
        rTypeId=[Select r.Name, r.Id, r.DeveloperName From RecordType r where r.DeveloperName=:developerName Limit 1].Id;
                
    }
}