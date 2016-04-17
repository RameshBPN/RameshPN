/**
    About
    -----
    Description: This class is used to test G2O_CustomerSearch_VFCx
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
    
    Update History
    --------------
    Created August 2013 - ME
    
    Issues / TODOs
    --------------
    
*/


@isTest
private class G2O_CustomerSearch_VFCx_TEST {

    static Account accountWS;
    static Account accountWS1;
    static Account accountLE;
    static list<Account> legalEntityAccountList = new list<Account>();
    static list<Account> workSiteAccountList = new list<Account>();
	static StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
    static String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
	static String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
    static List<GenericURLHacking__c> generalHackinglst;


	static testMethod void testNoParametersPassedToSite()
	{
		//Set up the org with default settings
		settings();
		
        // Verify that page creates a blank worksite record type account to search with/on
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountWorkSiteRT());
	}
	
    static testMethod void testCreateUnverifiedAccount() 
    {
		//Set up the org with default settings
		init();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);

        // Verify that page creates an account with record type of legal entity
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountLegalEntityRT());
		
		// New Worksite
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountWorkSiteRT());
        Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        controller = new ApexPages.standardController(new Account());
		customerSearch = new G2O_CustomerSearch_VFCx(controller);

        // Verify that page creates an account with record type of worksite
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountWorkSiteRT());
        
        customerSearch.theAccount.name = 'testName';
        customerSearch.theAccount.VAT_Number__c = 'SE123123123';
        customerSearch.theAccount.Corporate_Registration_Number__c = '123123123';
		        
        // Create Unverified
        PageReference unv = customerSearch.createUnverified();
        System.assert(unv.getUrl().indexOf('/' + Account.SObjectType.getDescribe().getKeyPrefix() + '/e')!=-1,'Account edit page not landed on when creating an unverified worksite');
        System.assert(unv.getParameters().keySet().size()>0,'Account edit page not provieded account details on when creating an unverified worksite: '+unv.getParameters());       
        System.assert(unv.getUrl().containsIgnoreCase('123123123'), unv.getURL());
        System.assert(unv.getUrl().containsIgnoreCase('TESTNAME'),  unv.getURL());
        
    }

    static testMethod void testContinueToMod() 
    {
		//Set up the org with default settings
		newTestInit();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);

        // Verify that page creates an account with record type of legal entity
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountLegalEntityRT());
		
		// New Worksite
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountWorkSiteRT());
        Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        controller = new ApexPages.standardController(new Account());
		customerSearch = new G2O_CustomerSearch_VFCx(controller);

        // Verify that page creates an account with record type of worksite
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountWorkSiteRT());
        
        // Create Unverified
        customerSearch.theAccount.Postal_Address_Country__c = 'DK';
		Id leId = [SELECT id FROM Account WHERE RecordTypeId = :UTIL_Meta.getAccountLegalEntityRT() LIMIT 1].id;
        customerSearch.theAccount.Parentid = leId;
        PageReference unv = customerSearch.createUnverified();
        System.assert(unv.getUrl().containsIgnoreCase('xParent'),'Expected to go to MOD search page');
        System.assert(unv.getUrl().containsIgnoreCase(leId),'Expected to go to MOD search page');
        System.assert(unv.getUrl().containsIgnoreCase('G2O_CustomerSearch_MOD'),'Expected to go to MOD search page');

    }
    
	static testMethod void testNewWSforLE()
	{
    	//Set up the org with default settings
		settings();
		Account parentAcc = UTIL_TestFactory.createAccount();
		parentAcc.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
		parentAcc.Name = 'Parent Account';
		parentAcc.External_Provider_Party_ID__c = '999999';
		insert parentAcc;
		
        // Check the page throws an error if a garbage ID is passed in the URL as ParentAccountId
		PageReference pageRef2 = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef2);
		ApexPages.currentPage().getParameters().put('ParentAccountId', 'garbage');
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
        G2O_CustomerSearch_VFCx customerSearch = new G2O_CustomerSearch_VFCx(controller);
        System.assertEquals(ApexPages.hasMessages(),true); // A handled error message is displayed
        
		// New Worksite
    	PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
		ApexPages.currentPage().getParameters().put('ParentAccountId', parentAcc.id);
        
        controller = new ApexPages.standardController(new Account());
		customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
        // Verify that page creates an account with parent details and record type of worksite
        System.assertEquals(customerSearch.theAccount.Name, parentAcc.Name);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountWorkSiteRT());
	}

	// At least one parameter must be supplied to the search, else it will give an error
    static testMethod void testSearchWithNoParameters(){
    	//Set up the org with default settings
		newTestInit();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
 		
		customerSearch.doSearch();
		test.stopTest();
		
		system.assertEquals(Label.Ext_Please_provide_at_least_one_search_term, customerSearch.alertMessage);
    }

	// Searching without results
    static testMethod void testSearchNoResult(){
    	//Set up the org with default settings
		settings();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
		customerSearch.DISABLE_WEBSERVICE = true;
 		Test.setMock(HttpCalloutMock.class, successfulMock);
		customerSearch.theAccount.Postal_Address_City__c = 'Lyngby';
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(0, customerSearch.searchResults.size());
    }
    
    // Search SFDC for results
    static testMethod void testSearchSFDC(){
    	//Set up the org with default settings
		newTestInit();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
		customerSearch.DISABLE_WEBSERVICE = true;
 		Test.setMock(HttpCalloutMock.class, successfulMock);
		customerSearch.theAccount.Postal_Address_City__c = 'Greve';
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(6, [select count() from account where Postal_Address_City__c = 'Greve']);
		system.assertEquals(2, customerSearch.searchResults.size());
    }
    
    // Search PAR for results
    static testMethod void testSearchPAR(){
    	//Set up the org with default settings
		newTestInit();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
		customerSearch.DISABLE_QUERY = true;
 		Test.setMock(HttpCalloutMock.class, successfulMock);
		customerSearch.theAccount.Postal_Address_City__c = 'doesnt matter had mockup';
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(2, customerSearch.searchResults.size());
    }
    
    // Search SFDC & PAR for results
    static testMethod void testSearchSFDCandPAR(){
    	//Set up the org with default settings
		newTestInit();
		
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
 		//customerSearch.DISABLE_WEBSERVICE = true;
		customerSearch.theAccount.Postal_Address_City__c = 'Greve';
 		system.debug([select id, Postal_Address_City__c from Account]);
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(3, customerSearch.searchResults.size());
		system.assertEquals(true , customerSearch.searchResults[0].isSFDC, customerSearch.searchResults[0]);
		system.assertEquals(false , customerSearch.searchResults[1].isSFDC, customerSearch.searchResults[1]);
		system.assertEquals(true , customerSearch.searchResults[2].isSFDC, customerSearch.searchResults[2]);
    }     
    
     // test that Pagination works correctly
    static testMethod void testPagination(){
    	//Set up the org with default settings
		newTestInit();
		createMassAccounts();
		
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
		customerSearch.theAccount.Postal_Address_City__c = 'Greve';
		customerSearch.doSearch();
		system.assertEquals(5, customerSearch.searchResults.size());
		system.assertEquals(false, customerSearch.searchResultsPagination.showPreviousButton);
		customerSearch.searchResultsPagination.next();
		system.assertEquals(5, customerSearch.searchResults.size());
		customerSearch.searchResultsPagination.last();
		system.assertEquals(false, customerSearch.searchResultsPagination.showNextButton);
		system.assertEquals(3, customerSearch.searchResults.size());
		customerSearch.searchResultsPagination.previous();
		system.assertEquals(5, customerSearch.searchResults.size());
		customerSearch.searchResultsPagination.first();
		system.assertEquals(5, customerSearch.searchResults.size());
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
    }        
    
	// Search and select a SFDC account, this should give an error since only PAR results can be selected
    static testMethod void testSelectNonValid(){
    	//Set up the org with default settings
		newTestInit();

		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
		customerSearch.theAccount.Postal_Address_City__c = 'Greve';
		customerSearch.doSearch();
		customerSearch.searchResults[2].selected = true;
		customerSearch.createSelected();			
		test.stopTest();
		
		system.assertEquals(Label.Ext_No_Selected_Worksite, customerSearch.alertMessage);
    } 
    
    // Search and select a PAR account, then create
    static testMethod void testSelectAndCreate(){
    	//Set up the org with default settings
		newTestInit();

		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
		customerSearch.theAccount.Postal_Address_City__c = 'Greve';
		customerSearch.doSearch();
		boolean selectedWorksite = false;
		for(G2O_CustomerSearch_VFCx.ResultWrapper wrap : customerSearch.searchResults){
			if(!wrap.isSFDC && wrap.hasChildren){
				wrap.childWorksites[0].selected = true;
				selectedWorksite = true;
			}
		}
		system.assert(selectedWorksite, 'a selectable worksite should have been found');
		customerSearch.createSelected();			
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
    }        
    
    // Search and select a PAR account, then create
    static testMethod void testBuildShortAddresse(){
    	//Set up the org with default settings
		newTestInit();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_VFCx  customerSearch = new G2O_CustomerSearch_VFCx(controller);
		
		test.startTest();
		customerSearch.DISABLE_WEBSERVICE = true;
 		Test.setMock(HttpCalloutMock.class, successfulMock);
		customerSearch.theAccount.Postal_Address_City__c = 'Greve';
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(6, [select count() from account where Postal_Address_City__c = 'Greve']);
		system.assertEquals(2, customerSearch.searchResults.size());
		system.assertEquals('7, 2100, Greve, DK', customerSearch.searchResults[0].address);
    }
   /* 
    static testMethod void testshowSearchResultPARAndSFDC() {
    	
    	// Use Case: get results for SFDC & PAR
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.Work_Site_Registration_Number__c = '9893893';
        accountWS.External_Provider_Party_ID__c = '1254658569';
        accountWS.External_Provider_Party_Parent_ID__c = '5849684189';
        insert accountWS;
        
        // ACT
        Test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        //customerSearchB2B.workSiteRegistrationNumber = accountWS.Work_Site_Registration_Number__c;
        //customerSearchB2B.externalProviderPartyId = accountWS.External_Provider_Party_ID__c;
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, '9893893');
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, '1254658569');
        System.assertEquals(customerSearchB2B.searched, true); 		//to check correct screens are getting displayed while performing certain operations
        system.assertEquals(customerSearchB2B.customersCreated, false);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);	//to check correct screens are getting displayed while performing certain operations
    }
    
    static testMethod void testSearchResultLegalEntityPresent() {
    	
    	// Use Case: No results from SFDC & PAR
    	
    	// Arrange
        init();
        accountLE.External_Provider_Party_ID__c = '5849684189';
        accountLE.Verified__c = 'N';
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.Work_Site_Registration_Number__c = '9893893';
      	accountWS.External_Provider_Party_ID__c = '1254658569';
        accountWS.External_Provider_Party_Parent_ID__c = '5849684189';
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        //customerSearchB2B.workSiteRegistrationNumber = accountWS.Work_Site_Registration_Number__c;
        //customerSearchB2B.externalProviderPartyId = accountWS.External_Provider_Party_ID__c;
        customerSearchB2B.doSearch();
        //customerSearchB2B.getAccountsSearchResult();
        //customerSearchB2B.showCreatedAccount();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, '9893893');
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, '1254658569');
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testSearchResultNoResultReturned() {
    	
    	// Use Case: No results from SFDC & PAR
    	
    	// Arrange
        init();
        accountLE.External_Provider_Party_ID__c = '5849684189';
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.Work_Site_Registration_Number__c = '9893893';
        accountWS.External_Provider_Party_ID__c = '98083';
        insert accountWS;
        
        // ACT
        Test.startTest();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        //customerSearchB2B.workSiteRegistrationNumber = accountWS.Work_Site_Registration_Number__c;
        //customerSearchB2B.externalProviderPartyId = accountWS.External_Provider_Party_ID__c;
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
		System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, '9893893');
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, '98083');
        //System.assertEquals(customerSearchB2B.showSearchResultBol, true);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerSearchShowSearchResultVariousCombinations() {
    	
    	// Use Case: for search checking various combinations: search on the basis of External Provider Party Id
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.External_Provider_Party_ID__c = '98083';
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
       // customerSearchB2B.externalProviderPartyId = accountWS.External_Provider_Party_ID__c;
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, '98083');        

//        System.assertEquals(customerSearchB2B.showSearchResultBol, true);
//        System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerShowSearchResultWHEREClause() {
    	
    	// Use Case: for searching checking various combinations: adding where clause
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, null);
        //System.assertEquals(customerSearchB2B.showSearchResultBol, true);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerShowSearchResultCorporateNumberNULL() {
    	
    	// Use Case: for searching checking various combinations: Corporate Registration NULL
    	
    	// Arrange
        init();
        
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.Corporate_Registration_Number__c = null;
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(accountWS.Corporate_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, null);
        //System.assertEquals(customerSearchB2B.showSearchResultBol, true);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerSearchShowResultCorpRegNumNVAT() {
    	
    	// Use Case: for searching checking various combinations: VAT number & Corporate Registration
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.Corporate_Registration_Number__c = '0920998';
        accountWS.VAT_Number__c = '987973';
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(accountWS.Corporate_Registration_Number__c, '0920998');
        System.assertEquals(accountWS.VAT_Number__c, '987973');
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, null);
        //System.assertEquals(customerSearchB2B.showSearchResultBol, true);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerSearchDisplayResult() {
    	
    	// Use Case: once the information is searched, show them the hierarchy of LE & WS
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.Corporate_Registration_Number__c = '0920998';
        accountWS.VAT_Number__c = '987973';
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(accountWS.Corporate_Registration_Number__c, '0920998');
        System.assertEquals(accountWS.VAT_Number__c, '987973');
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, null);
        //System.assertEquals(customerSearchB2B.showSearchResultBol, true);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerSearchDisplayResultWithWSTypeHQ() {
    	
    	// Use Case: once the information is searched, show them the hierarchy of LE & WS with WS Type HQ
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'HQ';
        accountWS.Corporate_Registration_Number__c = '0920998';
        accountWS.VAT_Number__c = '987973';
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        customerSearchB2B.doSearch();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(accountWS.Corporate_Registration_Number__c, '0920998');
        System.assertEquals(accountWS.VAT_Number__c, '987973');
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, null);
        //System.assertEquals(customerSearchB2B.showSearchResultBol, true);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerSearchPagination() {
    	
    	// Use Case: once the information is searched, show them the hierarchy of LE & WS with WS Type HQ
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'HQ';
        accountWS.Corporate_Registration_Number__c = '0920998';
        accountWS.VAT_Number__c = '987973';
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        customerSearchB2B.doSearch();
        customerSearchB2B.searchResultsPagination.first();
        customerSearchB2B.searchResultsPagination.next();
        customerSearchB2B.searchResultsPagination.previous();
        customerSearchB2B.searchResultsPagination.last();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(accountWS.Corporate_Registration_Number__c, '0920998');
        System.assertEquals(accountWS.VAT_Number__c, '987973');
        System.assertEquals(customerSearchB2B.theAccount.Work_Site_Registration_Number__c, null);
        System.assertEquals(customerSearchB2B.theAccount.External_Provider_Party_ID__c, null);
        //System.assertEquals(customerSearchB2B.showSearchResultBol, true);
        //System.assertEquals(customerSearchB2B.showCreateUnverifiedBol, false);
    }
    
    static testMethod void testCustomerSearchAccountsAndContactsCreated() {
    	
    	// Use Case: the selected WS are then Create Selected and accounts are inserted
    	
    	// Arrange
        init();
        insert accountLE;
        
        accountWS.ParentId = accountLE.Id;
        accountWS.Work_Site_Type__c = 'BR';
        accountWS.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        insert accountWS;
        
        // ACT
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.currentPage().getParameters().put('RecordTypeId', accountWS.RecordTypeId);
        ApexPages.StandardController controller = new ApexPages.StandardController(accountWS); 
        G2O_CustomerSearch_VFCx customerSearchB2B  = new G2O_CustomerSearch_VFCx(controller);
        customerSearchB2B.theAccount.RecordTypeId = accountWS.RecordTypeId;
        customerSearchB2B.doSearch();
        //customerSearchB2B.showCreatedAccount();
        //customerSearchB2B.getCustCreated();
        
        Test.stopTest();
        
        // Assert
        System.assertEquals(customerSearchB2B.theAccount.RecordTypeId, accountWS.RecordTypeId);
    }
    */
    static void settings()
	{
		UTIL_TestFactory.setUpOrg();
		
		successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');        
	}
	
	public static void newTestInit(){
		settings();
		Account acc;
		
		for(integer i = 0; i < 2; i++){
			acc = UTIL_TestFactory.createAccount();
			acc.recordTypeId = legalEntityRT;
			acc.Visiting_Address_City__c = 'Greve';
			acc.Postal_Address_City__c = 'Greve';
			legalEntityAccountList.add(acc);
		}		
		legalEntityAccountList[0].External_Provider_Party_ID__c = '111:100357275';
		insert legalEntityAccountList;
		
		for(integer i = 0; i < 4; i++){
			acc = UTIL_TestFactory.createAccount();
			acc.recordTypeId = workSiteRT;
			acc.ParentId = (i < 2) ? legalEntityAccountList[0].id : legalEntityAccountList[1].id;
			acc.Visiting_Address_City__c = 'Greve';
			acc.Postal_Address_City__c = 'Greve';
			workSiteAccountList.add(acc);
		}		
		
		insert workSiteAccountList;
	}
	
	public static void createMassAccounts(){
		Account acc;
		for(integer i = 0; i < 20; i++){
			acc = UTIL_TestFactory.createAccount();
			acc.recordTypeId = legalEntityRT;
			acc.Visiting_Address_City__c = 'Greve';
			acc.Postal_Address_City__c = 'Greve';
			legalEntityAccountList.add(acc);
		}
		
		upsert legalEntityAccountList;
	}
	
	public static void init() { 
    	
    	settings();
    	
        accountLE = new Account();
        accountLE = UTIL_TestFactory.createAccount();
        accountLE.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();   
        
        accountWS = new Account();
        accountWS = UTIL_TestFactory.createAccount();
        		
		generalHackinglst = new List<GenericURLHacking__c>();
		
		GenericURLHacking__c genericHacking = new GenericURLHacking__c();
		genericHacking.Name = 'Corporate_Registration_Number__c';
		genericHacking.URL_Field_Id__c = '00Ng0000000KxKh';
		genericHacking.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking);
		
		GenericURLHacking__c genericHacking1 = new GenericURLHacking__c();
		genericHacking1.Name = 'External_Provider_Party_ID__c';
		genericHacking1.URL_Field_Id__c = '98384p02';
		genericHacking1.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking1);
		
		GenericURLHacking__c genericHacking2 = new GenericURLHacking__c();
		genericHacking2.Name = 'Name';
		genericHacking2.URL_Field_Id__c = 'acc2';
		genericHacking2.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking2);
		
		GenericURLHacking__c genericHacking3 = new GenericURLHacking__c();
		genericHacking3.Name = 'Visiting_Address_City__c';
		genericHacking3.URL_Field_Id__c = '0983983003';
		genericHacking3.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking3);
		
		GenericURLHacking__c genericHacking5 = new GenericURLHacking__c();
		genericHacking5.Name = 'Visiting_Address_Country__c';
		genericHacking5.URL_Field_Id__c = '0983983003';
		genericHacking5.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking5);
		
		GenericURLHacking__c genericHacking6 = new GenericURLHacking__c();
		genericHacking6.Name = 'Visiting_Address_House_Number__c';
		genericHacking6.URL_Field_Id__c = '09283872';
		genericHacking6.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking6);
		
		
		GenericURLHacking__c genericHacking7 = new GenericURLHacking__c();
		genericHacking7.Name = 'Visiting_Address_Postal_Code__c';
		genericHacking7.URL_Field_Id__c = '98398332';
		genericHacking7.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking7);
		
		GenericURLHacking__c genericHacking8 = new GenericURLHacking__c();
		genericHacking8.Name = 'Visiting_Address_PO_Box__c';
		genericHacking8.URL_Field_Id__c = '872727';
		genericHacking8.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking8);
		
		GenericURLHacking__c genericHacking9 = new GenericURLHacking__c();
		genericHacking9.Name = 'Visiting_Address_Street__c';
		genericHacking9.URL_Field_Id__c = '82893';
		genericHacking9.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking9);
		
		genericURLHacking__c genericHacking10 = new GenericURLHacking__c();
		genericHacking10.Name = 'Postal_Address_Country__c';
		genericHacking10.URL_Field_Id__c = '0983983003';
		genericHacking10.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking10);
		
		GenericURLHacking__c genericHacking11 = new GenericURLHacking__c();
		genericHacking11.Name = 'Postal_Address_House_Number__c';
		genericHacking11.URL_Field_Id__c = '09283872';
		genericHacking11.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking11);
		
		
		GenericURLHacking__c genericHacking12 = new GenericURLHacking__c();
		genericHacking12.Name = 'Postal_Address_Postal_Code__c';
		genericHacking12.URL_Field_Id__c = '98398332';
		genericHacking12.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking12);
		
		GenericURLHacking__c genericHacking13 = new GenericURLHacking__c();
		genericHacking13.Name = 'Postal_Address_PO_Box__c';
		genericHacking13.URL_Field_Id__c = '872727';
		genericHacking13.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking13);
		
		GenericURLHacking__c genericHacking14 = new GenericURLHacking__c();
		genericHacking14.Name = 'Postal_Address_Street__c';
		genericHacking14.URL_Field_Id__c = '82893';
		genericHacking14.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking14);
		
		GenericURLHacking__c genericHacking15 = new GenericURLHacking__c();
		genericHacking15.Name = 'Postal_Address_City__c';
		genericHacking15.URL_Field_Id__c = '98374911787';
		genericHacking15.Feature_Name__c = 'Account';
		generalHackinglst.add(genericHacking15);
		
		insert generalHackinglst;
		
    }
}