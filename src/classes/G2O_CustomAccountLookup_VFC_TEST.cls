/**
    About
    -----
    Description: This class is used to test Custom Account Lookup
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Update History
    --------------
    Created May 2013 - R.M.
    Refactored Aug 2013 - ME
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_CustomAccountLookup_VFC_TEST {

    static Account account;
	
	public static void init() {	
		
		UTIL_TestFactory.setUpOrg();	
		account = UTIL_TestFactory.createAccount();
		account.Postal_Address_House_Number__c = '67';
		account.Postal_Address_PO_Box__c = '7876';
		account.Postal_Address_Street__c = 'dk';
		account.Postal_Address_City__c = 'Test City';
	}
	
	 static testMethod void testAccountSearch() {
    	
    	// Use Case: for searching account on look up
    	
        // Arrange
        init();
        account.Name = 'Test abc';
        insert account;
        
		// Act
		Test.startTest();
		
        ApexPages.currentPage().getParameters().put('lksrch', account.Name);
		
        G2O_CustomAccountLookup_VFC accountSearchLookup = new G2O_CustomAccountLookup_VFC();
        accountSearchLookup.searchString = account.Name;
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountSearchLookup.searchString, account.Name);
        System.assertEquals(accountSearchLookup.showSearchFilterButton, true);
        System.assertEquals(accountSearchLookup.showHideFilterButton, false);
        System.assertEquals(accountSearchLookup.showSearchFilter, false);
        System.assertEquals(accountSearchLookup.clearSearchFilter, false);
        System.assertEquals(accountSearchLookup.filteredByInformation, null);
    }
    
    static testMethod void testAccountSearchBasedOnKeyword() {
    	
    	// Use Case: performs keyword Search
    	
        // Arrange
        init();
        account.Name = 'Test abc';
        insert account;
        
		// Act
		Test.startTest();
		
		ApexPages.currentPage().getParameters().put('lksrch', account.Name);
        G2O_CustomAccountLookup_VFC accountSearchLookup = new G2O_CustomAccountLookup_VFC();
        accountSearchLookup.searchString = account.Name;
        accountSearchLookup.search();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountSearchLookup.searchString, account.Name);
        System.assertEquals(accountSearchLookup.showSearchFilterButton, true);
        System.assertEquals(accountSearchLookup.showHideFilterButton, false);
        System.assertEquals(accountSearchLookup.showSearchFilter, false);
        System.assertEquals(accountSearchLookup.clearSearchFilter, false);
        System.assertEquals(accountSearchLookup.filteredByInformation, null);
    }
    
    static testMethod void testAccountSearchShowFilters() {
    	
    	// Use Case: performs keyword Search and clicks on Show Filters
    	
        // Arrange
        init();
        account.Name = 'Test abc';
        insert account;
        
		// Act
		Test.startTest();
		
		ApexPages.currentPage().getParameters().put('lksrch', account.Name);
        G2O_CustomAccountLookup_VFC accountSearchLookup = new G2O_CustomAccountLookup_VFC();
        accountSearchLookup.searchString = account.Name;
        accountSearchLookup.search();
        accountSearchLookup.displayFilters();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountSearchLookup.searchString, account.Name);
        System.assertEquals(accountSearchLookup.showSearchFilterButton, false);
        System.assertEquals(accountSearchLookup.showHideFilterButton, true);
        System.assertEquals(accountSearchLookup.showSearchFilter, true);
        System.assertEquals(accountSearchLookup.clearSearchFilter, false);
        System.assertEquals(accountSearchLookup.filteredByInformation, null);
    }
    
    static testMethod void testAccountSearchHideFilters() {
    	
    	// Use Case: performs keyword Search and clicks on Hide Filters
    	
        // Arrange
        init();
        account.Name = 'Test abc';
        insert account;
        
		// Act
		Test.startTest();
		
		ApexPages.currentPage().getParameters().put('lksrch', account.Name);
        G2O_CustomAccountLookup_VFC accountSearchLookup = new G2O_CustomAccountLookup_VFC();
        accountSearchLookup.searchString = account.Name;
        accountSearchLookup.search();
        accountSearchLookup.hideFilters();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountSearchLookup.searchString, account.Name);
        System.assertEquals(accountSearchLookup.showSearchFilterButton, true);
        System.assertEquals(accountSearchLookup.showHideFilterButton, false);
        System.assertEquals(accountSearchLookup.showSearchFilter, false);
        System.assertEquals(accountSearchLookup.clearSearchFilter, false);
        System.assertEquals(accountSearchLookup.filteredByInformation, null);
    }
    
    static testMethod void testAccountSearchClearFilters() {
    	
    	// Use Case: performs keyword Search and clicks on Clear Filters
    	
        // Arrange
        init();
        account.Name = 'Test abc';
        account.Corporate_Registration_Number__c = '34943400';
        insert account;
        
		// Act
		Test.startTest();
		
		ApexPages.currentPage().getParameters().put('lksrch', account.Name);
        G2O_CustomAccountLookup_VFC accountSearchLookup = new G2O_CustomAccountLookup_VFC();
        accountSearchLookup.searchString = account.Name;
        accountSearchLookup.search();
        accountSearchLookup.hideFilters();
        accountSearchLookup.clearSearchFilters();
        
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountSearchLookup.searchString, account.Name);
        System.assertEquals(accountSearchLookup.clearSearchFilter, true);
        System.assertEquals(accountSearchLookup.filteredByInformation, null);
    }
    
	static testMethod void testAccountSearchApplyFilters() {
    	
		// Use Case: performs keyword Search and clicks on Apply Filters
    	
		// Arrange
		init();
		account.Name = 'Test abc';
		account.Corporate_Registration_Number__c = '34943400';
		insert account;
        
		// Act
		Test.startTest();
		
		ApexPages.currentPage().getParameters().put('lksrch', account.Name);
		G2O_CustomAccountLookup_VFC accountSearchLookup = new G2O_CustomAccountLookup_VFC();
		accountSearchLookup.account = [Select Id, Involved_Party_ID__c, Old_Customer_Number__c, Ella_Production_Customer_Number__c, Postal_Address_City__c, Postal_Address_Postal_Code__c, Corporate_Registration_Number__c, Name from Account where Id=:  account.Id limit 1];
		accountSearchLookup.searchString = account.Name;
		accountSearchLookup.showSearchFilter = true;
		accountSearchLookup.search();
		accountSearchLookup.getFormTag();
		accountSearchLookup.getTextBox();
		
		Test.stopTest();
        
		//Assert
		System.assertEquals(accountSearchLookup.searchString, account.Name);
		System.assertEquals(accountSearchLookup.showSearchFilter, true);
		System.assertEquals(accountSearchLookup.clearSearchFilter, false);
		System.assertEquals(accountSearchLookup.checkAccountValuesInFieldSet, false);
    }
}