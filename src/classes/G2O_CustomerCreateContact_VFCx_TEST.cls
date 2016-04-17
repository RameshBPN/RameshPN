/**
    About
    -----
    Description: This class is used to test Customer contact creation
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: September 2013

    Details
    -------
	1. Tests that parameters filled out in the search window is correctly transfered to the new contact screen
		when creating an unverified customer
	2. Tests that when verified account details are entered, the search also gets results from PAR
	3. Tests that when an unverified account is selected, the search does NOT get results from PAR
	4. Tests that pagination works correctly
	5. Tests that creating/adding accounts found in a PAR search to Salesforce works as intended
	    
    Update History
    --------------
    Created September 2013 - K.E.A.J.
    Merged sprint tests into class September 2013 - K.E.A.J
    
    Issues / TODOs
    --------------

	    
*/
@isTest
private class G2O_CustomerCreateContact_VFCx_TEST {

	static Account account;
	static list<Account> accountList;	
	static list<Contact> contactList;
	static Contact contact;
	static List<GenericURLHacking__c> generalHackinglst;
	static StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
	
	// 1. Tests that parameters filled out in the search window is correctly transfered to the new contact screen when creating an unverified customer
	static testMethod void contactCreateUnverified() {
    	
		UTIL_TestFactory.setUpOrg();
        initSingleContact();
        insert generalHackinglst;
        
        // Act
		Test.startTest();
		
		ApexPages.currentPage().getParameters().put('accId', account.Id);			// putting values in the parameters
		 
		ApexPages.StandardController controller = new ApexPages.StandardController(contact); 
		G2O_CustomerCreateContact_VFCx createContact = new G2O_CustomerCreateContact_VFCx(controller);
		createContact.theContact.accountId = account.Id;
		createContact.theContact.FirstName = 'testFirstName';
		createContact.theContact.lastName = 'testLastName';

		system.assertEquals(0, ApexPages.getMessages().size(), 'expected no errors to occur, got this: ' + ApexPages.getMessages());
		Test.setCurrentPage(createContact.createUnverified());		
		Test.stopTest();
		
		// Assert
		system.assertEquals(account.Id, createContact.theContact.accountId, 'The account defined on the Contact page should match the account made');
		system.assertEquals(0, ApexPages.getMessages().size(), 'expected no errors to occur, got this: ' + ApexPages.getMessages());
		system.assertEquals('testFirstName', ApexPages.currentPage().getParameters().get('name_firstcon2'), 'The firstname should have been carried over to the new customer view');
		system.assertEquals('testLastName', ApexPages.currentPage().getParameters().get('name_lastcon2'), 'The last name should have been carried over to the new customer view');
		system.assertEquals(account.Name, ApexPages.currentPage().getParameters().get('con4_lkold'), 'The account name should have been carried over to the new customer view');
		system.assertEquals(account.id, ApexPages.currentPage().getParameters().get('con4_lkid'), 'The account id should have been carried over to the new customer view');	
    }
    
    // 2. Tests that when verified account details are entered, the search also gets results from PAR
    static testMethod void contactSearchWithVerifiedAccountDetail() {
    	
        // Use Case: When an account has a PAR Id (means it is verified), 
        //it searches for results both from PAR & SFDC from Account Detail Page
        
        //Arrange
        init();
        
        // Act
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
		ApexPages.currentPage().getParameters().put('accId', account.Id);			// putting values in the parameters
		
		ApexPages.StandardController controller = new ApexPages.StandardController(contactList[0]); 
		G2O_CustomerCreateContact_VFCx createContact = new G2O_CustomerCreateContact_VFCx(controller);
		createContact.theContact.accountId = account.Id;
		createContact.findContacts();
		for(integer j = 0; j < createContact.searchResults.size(); j++){
			system.assertEquals(false, createContact.searchResults[j].selected , 'Contacts are assumed to initially be unselected');			
		}
		createContact.checkAll();
		for(integer j = 0; j < createContact.searchResults.size(); j++){
			system.assertEquals(true, createContact.searchResults[j].selected, 'Call to checkAll() should have made contacts on the current page selected');			
		}
		Test.stopTest();
		
		// Assert
		system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
		system.assertEquals(account.Id, createContact.theContact.accountId);
		system.assertNotEquals(null, createContact.searchResults, 'The search was expected to yield results');

		system.assertEquals(10, createContact.searchResults.size(), '10 contacts can be seen pr page, and is expected on page 1');
		integer parAccount = 0;
		for(integer i = 0; i < createContact.searchResultsPagination.numberOfPages; i++){
			for(integer j = 0; j < createContact.searchResults.size(); j++){
				if(!createContact.searchResults[j].exists){
					parAccount++;
				}	
			}
			createContact.searchResultsPagination.next();
		}
		system.assertEquals(3, parAccount, 'Test calls to PAR is expected to return 3 unique contacts');		
		system.assertEquals(4, createContact.searchResults.size(), '4 contacts is expected on the last page');		
		system.assertEquals(21, createContact.searchResultsPagination.numberOfPages, '21 pages are expected by the search');
		system.assertEquals(false, createContact.noResults, 'It was expected that there was results from the search');
    }
    
    // 3. Tests that when an unverified account is selected, the search does NOT get results from PAR
    static testMethod void contactSearchWithUnverifiedAccountDetail() {
    	
        // Use Case: When an account has no PAR Id (means it is verified), 
        // it searches for results from SFDC from Account Detail Page
        
        //Arrange
        init1();
        
        // Act
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
		ApexPages.currentPage().getParameters().put('accId', account.Id);			// putting values in the parameters
		
		ApexPages.StandardController controller = new ApexPages.StandardController(contactList[0]); 
		G2O_CustomerCreateContact_VFCx createContact = new G2O_CustomerCreateContact_VFCx(controller);
		createContact.theContact.accountId = account.Id;
		createContact.findContacts();
		
		Test.stopTest();
		
		// Assert
		system.assertEquals(201, [select count() from Contact]);
		system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
		System.assertEquals(account.Id, createContact.theContact.accountId);
		system.assertEquals(false, createContact.noResults, 'It was expected that there was results from the search');
		system.assertNotEquals(null, createContact.searchResults, 'The search was expected to yield results');
		system.assertEquals(21, createContact.searchResultsPagination.numberOfPages, 'Only 20 pages are expected since PAR should not have been queried');
		// Assumes that the Pagenation hardcoded in the controller remains on 10
		system.assertEquals(10, createContact.searchResults.size(), '10 contacts can be seen pr page, and is expected on page 1');

    }

	// 4. Tests that pagination works correctly
    static testMethod void contactSearchDisplayContactPagination() {
    	
        // Use Case: show results when search button is clicked with Pagination.
        
        //Arrange
        init();
        
        // Act
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
		ApexPages.currentPage().getParameters().put('accId', account.Id);			// putting values in the parameters
		
		ApexPages.StandardController controller = new ApexPages.StandardController(contactList[0]); 
		G2O_CustomerCreateContact_VFCx createContact = new G2O_CustomerCreateContact_VFCx(controller);
		createContact.theContact.accountId = account.Id;
		createContact.findContacts();
		createContact.searchResultsPagination.first();
		createContact.searchResultsPagination.last();
		createContact.searchResultsPagination.next();
		createContact.searchResultsPagination.previous();
		
		
		Test.stopTest();
		
		// Assert
		system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
		System.assertEquals(account.Id, createContact.theContact.accountId);
		system.assertEquals(false, createContact.noResults, 'It was expected that there was results from the search');
    }
	
	// 5. Tests that creating/adding accounts found in a PAR search to Salesforce works as intended
    static testMethod void contactSearchCreateContactsDetail() {
    	
        // Use Case: Create Contacts and Account Contact Roles from Account Detail Page
        
        //Arrange
        init();
        
        // Act
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, successfulMock);
		ApexPages.currentPage().getParameters().put('accId', account.Id);			// putting values in the parameters
		
		ApexPages.StandardController controller = new ApexPages.StandardController(contactList[0]); 
		G2O_CustomerCreateContact_VFCx createContact = new G2O_CustomerCreateContact_VFCx(controller);
		createContact.theContact.accountId = account.Id;
		createContact.findContacts();
		for(integer i = 0; i < createContact.searchResultsPagination.numberOfPages; i++){
			createContact.searchResultsPagination.next();
		}
		createContact.checkAll();
		system.assertEquals(201, [select count() from Contact], 'Before changes are done 201 contacts are expected to be in the system');
		createContact.createContacts();
		
		
		Test.stopTest();
		
		// Assert
		// since they were present on the last page (pagesize = 10, 201 Salesforce accounts)
		system.assertEquals(204, [select count() from Contact], 'After selection and creation 201 contacts are expected to be in the system as 3 are added from PAR');
		System.assertEquals(account.Id, createContact.theContact.accountId);
		system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
    }
    
    // 6. Search with no returned results
    static testMethod void contactSearchNoResults(){
    	//Arrange
        initNoResult();
        
        // Act
		Test.startTest();
		ApexPages.currentPage().getParameters().put('accId', account.Id);			// putting values in the parameters
		ApexPages.StandardController controller = new ApexPages.StandardController(new Contact()); 
		G2O_CustomerCreateContact_VFCx createContact = new G2O_CustomerCreateContact_VFCx(controller);
		createContact.theContact.accountId = account.Id;
		createContact.findContacts();
		Test.stopTest();
		
		// Assert
		// There will be 2 errors, one because there is no valid mockup to call so no webservice call is made, 
		// and one because there is no results from the search
		system.assertEquals(2, ApexPages.getMessages().size(), ApexPages.getMessages());
		system.assertEquals('There are no results matching your search criteria. You can modify your search or Create Unverified contact.',ApexPages.getMessages()[1].getSummary());
    }

    public static void init() {		
		UTIL_TestFactory.setUpOrg();
        successfulMock.setStaticResource('TestMockResponsPAR_Contact');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        accountList = UTIL_TestFactory.createAccounts();
		
		account = new Account();
		account = UTIL_TestFactory.createAccount();
		account.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
		account.External_Provider_Party_ID__c = '114:201062515';
		insert account;
		
		contactList = new list<Contact>();
		contactList = UTIL_TestFactory.createContacts();
		for(integer i = 0; i < contactList.size(); i++){
			contactList[i].External_Provider_Party_ID__c = '672672' + i;
			contactList[i].AccountId = account.Id;
			contactList[i].FirstName = 'Test First name';
			contactList[i].LastName = 'NOW ' + String.valueOf(System.now());			
		}

		insert contactList;
		
		generalHackinglst = new List<GenericURLHacking__c>();
		
		GenericURLHacking__c genericHacking = new GenericURLHacking__c();
		genericHacking.Name = 'FirstName_Contact';
		genericHacking.Default_Value__c = 'FirstName';
		genericHacking.URL_Field_Id__c = 'name_firstcon2';
		genericHacking.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking);
		
		GenericURLHacking__c genericHacking1 = new GenericURLHacking__c();
		genericHacking1.Name = 'LastName_Contact';
		genericHacking1.Default_Value__c = 'LastName';
		genericHacking1.URL_Field_Id__c = 'name_lastcon2';
		genericHacking1.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking1);
		
		GenericURLHacking__c genericHacking2 = new GenericURLHacking__c();
		genericHacking2.Name = 'Account Name';
		genericHacking2.Default_Value__c = 'Account Name';
		genericHacking2.URL_Field_Id__c = 'con4_lkold';
		genericHacking2.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking2);
		
		GenericURLHacking__c genericHacking3 = new GenericURLHacking__c();
		genericHacking3.Name = 'Account Id';
		genericHacking3.Default_Value__c = 'Account Id';
		genericHacking3.URL_Field_Id__c = 'con4_lkid';
		genericHacking3.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking3);
	}

   public static void initNoResult() {		
		UTIL_TestFactory.setUpOrg();
        accountList = UTIL_TestFactory.createAccounts();
		
		account = new Account();
		account = UTIL_TestFactory.createAccount();
		account.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
		account.External_Provider_Party_ID__c = '987298793873';
		insert account;
				
		generalHackinglst = new List<GenericURLHacking__c>();
		
		GenericURLHacking__c genericHacking = new GenericURLHacking__c();
		genericHacking.Name = 'FirstName_Contact';
		genericHacking.Default_Value__c = 'FirstName';
		genericHacking.URL_Field_Id__c = 'name_firstcon2';
		genericHacking.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking);
		
		GenericURLHacking__c genericHacking1 = new GenericURLHacking__c();
		genericHacking1.Name = 'LastName_Contact';
		genericHacking1.Default_Value__c = 'LastName';
		genericHacking1.URL_Field_Id__c = 'name_lastcon2';
		genericHacking1.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking1);
		
		GenericURLHacking__c genericHacking2 = new GenericURLHacking__c();
		genericHacking2.Name = 'Account Name';
		genericHacking2.Default_Value__c = 'Account Name';
		genericHacking2.URL_Field_Id__c = 'con4_lkold';
		genericHacking2.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking2);
		
		GenericURLHacking__c genericHacking3 = new GenericURLHacking__c();
		genericHacking3.Name = 'Account Id';
		genericHacking3.Default_Value__c = 'Account Id';
		genericHacking3.URL_Field_Id__c = 'con4_lkid';
		genericHacking3.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking3);
	}
			
	public static void init1() {	

		UTIL_TestFactory.setUpOrg();		
        successfulMock.setStaticResource('TestMockResponsPAR_Contact');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        accountList = UTIL_TestFactory.createAccounts();

		account = new Account();
		account = UTIL_TestFactory.createAccount();
		account.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
		insert account;
		
		contactList = new list<Contact>();
		contactList = UTIL_TestFactory.createContacts();
		for(integer i = 0; i < contactList.size(); i++){
			contactList[i].External_Provider_Party_ID__c = '672672' + i;
			contactList[i].AccountId = account.Id;
			contactList[i].FirstName = 'Test First name';
			contactList[i].LastName = 'NOW ' + String.valueOf(System.now());			
		}

		insert contactList;
	}

	public static void initSingleContact() {		
		UTIL_TestFactory.setUpOrg();
		account = new Account();
		account = UTIL_TestFactory.createAccount();
		account.Corporate_Registration_Number__c = null;
		account.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
		account.External_Provider_Party_ID__c = '987298793873';
		insert account;
		
		contact = UTIL_TestFactory.createcontact();
		contact.External_Provider_Party_ID__c = '672672';
		contact.AccountId = account.Id;
		contact.FirstName = 'Test First name';
		contact.LastName = 'NOW ' + String.valueOf(System.now());			
		
		insert contact;

		generalHackinglst = new List<GenericURLHacking__c>();
		
		GenericURLHacking__c genericHacking = new GenericURLHacking__c();
		genericHacking.Name = 'FirstName_Contact';
		genericHacking.Default_Value__c = 'FirstName';
		genericHacking.URL_Field_Id__c = 'name_firstcon2';
		genericHacking.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking);
		
		GenericURLHacking__c genericHacking1 = new GenericURLHacking__c();
		genericHacking1.Name = 'LastName_Contact';
		genericHacking1.Default_Value__c = 'LastName';
		genericHacking1.URL_Field_Id__c = 'name_lastcon2';
		genericHacking1.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking1);
		
		GenericURLHacking__c genericHacking2 = new GenericURLHacking__c();
		genericHacking2.Name = 'Account.Name';
		genericHacking2.Default_Value__c = 'Account Name';
		genericHacking2.URL_Field_Id__c = 'con4_lkold';
		genericHacking2.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking2);
		
		GenericURLHacking__c genericHacking3 = new GenericURLHacking__c();
		genericHacking3.Name = 'Account.Id';
		genericHacking3.Default_Value__c = 'Account Id';
		genericHacking3.URL_Field_Id__c = 'con4_lkid';
		genericHacking3.Feature_Name__c = 'Contact';
		generalHackinglst.add(genericHacking3);
	}
}