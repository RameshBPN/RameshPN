/**
    About
    -----
    Description: This class is used to test G2O_CustomerSearch_MOD_VFCx
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of MODValidateAccount_VFCx class.
	1. Test for CreatePrivate person when MOD Tager/Interessent,ExternalProvider PartyId is present & Country is 'DK'.
	2. Test for CreatePrivate person when MOD Tager/Interessent is present but no matching SFDC records exists & Country is 'DK'.
	3. Test for CreatePrivate person for Country as 'SE'.
	4. MODValidate B2C Test for DK.
	5. MODValidate B2C Test for SE.
	6. MODValidate B2B Test for DK.
	7. MODValidate B2B Test for SE.
    
    Update History
    --------------
    Created JUNE 2013 - R.M.
    Refactored JUNE 2013 - A.B.
    Refactored AUG 2013 - M.E.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_CustomerSearch_MOD_VFCx_TEST {
    
    static Account personAcc0;
    static Account personAcc1;
    static Account personAcc2; 
    static Account personAcc3;
    static Account personAcc4;
    static Account businessAcc0;
    static Account businessAcc1;
    static Account businessAcc2;
    static Account businessAcc3;
    static Account businessParentAcc;

	static StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
	    
  /*1. businessAcc0:    BusinessAccount with MOD_Modtager_Number__c,MOD_Interessent_Number__c & External_Provider_Party_ID__c number present.
    2. businessAcc1:    BusinessAccount with no MOD_Modtager_Number__c,MOD_Interessent_Number__c.
    3. businessAcc2:    BusinessAccount with same MOD_Modtager_Number__c & MOD_Interessent_Number__c as 'businessAcc0'.
    4.  businessAcc2:   BusinessAccount non 'DK' Postal_Address_Street__c.
    5. businessParentAcc:BusinessAccount of recordType LegalEntity.
    */
    //Creating Business Account.
    public static void CreateBusinessAccTestData() {
        
        //Creating Custom Setting.
		createCustomSettings();
            
        businessParentAcc = new Account();
        businessParentAcc = UTIL_TestFactory.createAccount();
        businessParentAcc.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        insert businessParentAcc;
        
        list<Account> businessAccs = new list <Account>();
        
        businessAcc0 = new Account();
        businessAcc0 = UTIL_TestFactory.createAccount();
        businessAcc0.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        businessAcc0.ParentId = businessParentAcc.Id;
        businessAcc0.Name = 'Name0';
        businessAcc0.Phone = '55550';
        businessAcc0.Postal_Address_PO_Box__c = 'PostBox0';
        businessAcc0.Postal_Address_Country__c = 'DK';
        businessAcc0.Postal_Address_City__c = 'PostCity0';
        businessAcc0.Postal_Address_Postal_Code__c = '2670';
        businessAcc0.MOD_Modtager_Number__c = '123456';
        businessAcc0.MOD_Interessent_Number__c = '6789';
        businessAcc0.External_Provider_Party_ID__c = '45454';
        businessAccs.add(businessAcc0);
        
        businessAcc1 = new Account();
        businessAcc1 = UTIL_TestFactory.createAccount();
        businessAcc1.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        businessAcc1.ParentId = businessParentAcc.Id;
        businessAcc1.Name = 'Name1';
        businessAcc1.Phone = '55551';
        businessAcc1.Postal_Address_PO_Box__c = 'PostBox1';
        businessAcc1.Postal_Address_Country__c = 'DK';
        businessAcc1.Postal_Address_City__c = 'PostCity1';
        businessAcc1.Postal_Address_Postal_Code__c = '2670';
        businessAccs.add(businessAcc1);
        
        businessAcc2 = new Account();
        businessAcc2 = UTIL_TestFactory.createAccount();
        businessAcc2.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        businessAcc2.ParentId = businessParentAcc.Id;
        businessAcc2.Name = 'Name2';
        businessAcc2.Phone = '55552';
        businessAcc2.Postal_Address_PO_Box__c = 'PostBox2';
        businessAcc2.Postal_Address_Country__c = 'DK';
        businessAcc2.Postal_Address_City__c = 'PostCity2';
        businessAcc2.Postal_Address_Postal_Code__c = '2670';
        businessAcc2.MOD_Modtager_Number__c = '123456';
        businessAcc2.MOD_Interessent_Number__c = '6789';
        businessAccs.add(businessAcc2);
        
        businessAcc3 = new Account();
        businessAcc3 = UTIL_TestFactory.createAccount();
        businessAcc3.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        businessAcc3.ParentId = businessParentAcc.Id;
        businessAcc3.Name = 'Name3';
        businessAcc3.Phone = '55553';
        businessAcc3.Postal_Address_PO_Box__c = 'PostBox3';
        businessAcc3.Postal_Address_Country__c = 'DK';
        businessAcc3.Postal_Address_City__c = 'PostCity3';
        businessAcc3.Postal_Address_Postal_Code__c = '2670';
        businessAcc3.MOD_Modtager_Number__c = '123456';
        businessAcc3.MOD_Interessent_Number__c = '6789';
        businessAccs.add(businessAcc3);
        
        insert businessAccs;
    }
    
 	/* 					
 	1. personAcc0  :    PersonAccount with MOD_Modtager_Number__c,MOD_Interessent_Number__c,External_Provider_Party_ID__c number present Postal_Address_Country__c='DK'.
    2. personAcc1  :    PersonAccount with no MOD_Modtager_Number__c,MOD_Interessent_Number__c & External_Provider_Party_ID__c number.
    3  personAcc2  :    PersonAccount with same MOD_Modtager_Number__c & MOD_Interessent_Number__c  number as 'personAcc0',No External_Provider_Party_ID__c & Postal_Address_Country__c='DK'.
    4  personAcc3  :    PersonAccount with non 'DK' Postal_Address_Street__c.
    */
    //Creating Person Account.
    public static void CreatePersonAccTestData(){
        
        createCustomSettings();
                
        personAcc0 = new Account();
        personAcc0.Postal_Address_House_Number__c   = '00';
        personAcc0.LastName                         = 'TestLast0';
        personAcc0.FirstName                        = 'TestFirst0';
        personAcc0.Phone                            = '764840';
        personAcc0.PersonEmail                      = 'test0@mail.com'; 
        personAcc0.Email_Address__c					= 'test0@mail.com';
        personAcc0.Postal_Address_PO_Box__c         = '00';
        personAcc0.Postal_Address_Country__c         = 'DK';
        personAcc0.Postal_Address_City__c           = 'Test City 0';
        personAcc0.Postal_Address_Postal_Code__c    = '1234';
        personAcc0.MOD_Modtager_Number__c           = '123456';
        personAcc0.MOD_Interessent_Number__c        = '654321';
        personAcc0.External_Provider_Party_ID__c	= '2468';
        personAcc0.RecordTypeId                     = UTIL_Meta.getPersonAccountRT();
        insert personAcc0;
    }
    
    static void settings()
	{
		UTIL_TestFactory.setUpOrg();
		
		successfulMock.setStaticResource('TestMockResponsMOD');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');        
	}
	
    static void CreateCustomSettings(){
    	
        List<GenericURLHacking__c> genericURLList = new List<GenericURLHacking__c>();
        
        GenericURLHacking__c genericURL1 = new GenericURLHacking__c();
        genericURL1.Name = 'MOD_Modtager_Number__c';
        genericURL1.URL_Field_Id__c ='00Ng0000000KxLV';
        genericURL1.Feature_Name__c = 'Account';
        genericURLList.add(genericURL1);
        
        GenericURLHacking__c genericURL2 = new GenericURLHacking__c();
        genericURL2.Name ='MOD_Interessent_Number__c';
        genericURL2.URL_Field_Id__c ='00Ng0000000KxLW';
        genericURL2.Feature_Name__c = 'Account';
        genericURLList.add(genericURL2);
        
        GenericURLHacking__c genericURL3 = new GenericURLHacking__c();
        genericURL3.Name = 'External_Provider_Party_ID__c';
        genericURL3.URL_Field_Id__c ='00Ng0000000KxKy';
        genericURL3.Feature_Name__c = 'Account';
        genericURLList.add(genericURL3);
        	
        GenericURLHacking__c genericURL4 = new GenericURLHacking__c();
        genericURL4.Name = 'ParentAccountId';
        genericURL4.URL_Field_Id__c ='acc3_lkid';
        genericURL4.Feature_Name__c = 'Account';
        genericURLList.add(genericURL4);        	

        GenericURLHacking__c genericURL5 = new GenericURLHacking__c();
        genericURL5.Name = 'ParentAccountName';
        genericURL5.URL_Field_Id__c ='acc3';
        genericURL5.Feature_Name__c = 'Account';
        genericURLList.add(genericURL5); 
         
        GenericURLHacking__c genericURL6 = new GenericURLHacking__c();
        genericURL6.Name = 'VAT_Number__c';
        genericURL6.URL_Field_Id__c ='00Ng0000000KxMW';
        genericURL6.Feature_Name__c = 'Account';
        genericURLList.add(genericURL6); 

        GenericURLHacking__c genericURL7 = new GenericURLHacking__c();
        genericURL7.Name = 'Corporate_Registration_Number__c';
        genericURL7.URL_Field_Id__c ='00Ng0000000KxKh';
        genericURL7.Feature_Name__c = 'Account';
        genericURLList.add(genericURL7); 
                			
        insert genericURLList;
    }
    
    static testMethod void testCreateUnverifiedAccount() 
    {
    	settings();
		//Set up the org with default settings
		CreateCustomSettings();
		
		businessParentAcc = new Account();
        businessParentAcc = UTIL_TestFactory.createAccount();
        businessParentAcc.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        insert businessParentAcc;
        
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('xRecordType', UTIL_Meta.getAccountWorkSiteRT());

        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);

        // Verify that page creates an account with record type of worksite
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountWorkSiteRT());
		
		// New Worksite
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('externalNew', 'true');
		ApexPages.currentPage().getParameters().put('xRecordType', UTIL_Meta.getAccountWorkSiteRT());
		ApexPages.currentPage().getParameters().put('xParentId', businessParentAcc.id);
		ApexPages.currentPage().getParameters().put('xRecordType', UTIL_Meta.getAccountWorkSiteRT());
		ApexPages.currentPage().getParameters().put('xVAT_Number__c', 'DK34943400');
		ApexPages.currentPage().getParameters().put('xCorporate_Registration_Number__c', '34943400');

        Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, successfulMock);
        
        controller = new ApexPages.standardController(new Account());
		customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);

        // Verify that page creates an account with record type of worksite
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getAccountWorkSiteRT());
        
        // Create Unverified
        
        PageReference unv = customerSearch.createUnverified();
        System.assert(unv.getUrl().indexOf('/' + Account.SObjectType.getDescribe().getKeyPrefix() + '/e')!=-1,'Account edit page not landed on when creating an unverified worksite');
        System.assert(unv.getParameters().keySet().size()>0,'Account edit page not provieded account details on when creating an unverified worksite: '+unv.getParameters());       
    }

    static testMethod void testCreateUnverifiedPersonAccount() 
    {
		//Set up the org with default settings
		CreateCustomSettings();
		
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getPersonAccountRT());
		        
        Account acc = new Account();
        acc.recordTypeId = UTIL_Meta.getPersonAccountRT();

        ApexPages.standardController controller = new ApexPages.standardController(acc);
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);

        // Verify that page creates an account with record type of personaccount
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getPersonAccountRT());
		
		// New Worksite
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getPersonAccountRT());
        Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, successfulMock);

        acc = new Account();
        acc.recordTypeId = UTIL_Meta.getPersonAccountRT();        
        controller = new ApexPages.standardController(acc);
		customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);

        // Verify that page creates an account with record type of PersonAccount
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getPersonAccountRT());
        
        // Create Unverified
        PageReference unv = customerSearch.createUnverified();
        System.assert(unv.getUrl().indexOf('/' + Account.SObjectType.getDescribe().getKeyPrefix() + '/e')!=-1,'Account edit page not landed on when creating an unverified worksite');
        System.assert(unv.getParameters().keySet().size()>0,'Account edit page not provieded account details on when creating an unverified worksite: '+unv.getParameters());       
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
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
 		customerSearch.theAccount.Name = 'AccountName';
		customerSearch.theAccount.Postal_Address_City__c = 'Greve';
		customerSearch.theAccount.Postal_Address_Postal_Code__c = '2670';
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(0, customerSearch.allSfdcResults.size());
    }
    
	// Search SFDC for results
    static testMethod void testSearchSFDC(){
    	//Set up the org with default settings
		settings();
		CreateBusinessAccTestData();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
 		system.assertEquals(1, [select count() from Account where recordTypeId=:UTIL_Meta.getAccountWorkSiteRT() AND (Name = 'Name0' OR Short_Name__c = 'Name0' OR Metaphone_Primary_Encoding__c = 'NM') AND (Name = 'Name0' OR (Postal_Address_City__c = 'PostCity0' AND Postal_Address_Postal_Code__c = '2670')) Limit 9999]);
 		customerSearch.theAccount.Name = 'Name0';
		customerSearch.theAccount.Postal_Address_City__c = 'PostCity0';
		customerSearch.theAccount.Postal_Address_Postal_Code__c = '2670';
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(1, customerSearch.sfdcResults.size());
    }

	// Search SFDC for results
    static testMethod void testSearchSFDCPersonAccount(){
    	//Set up the org with default settings
		settings();
		CreatePersonAccTestData();
		
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getPersonAccountRT());
		        
        Account acc = new Account();
        acc.recordTypeId = UTIL_Meta.getPersonAccountRT();

        ApexPages.standardController controller = new ApexPages.standardController(acc);
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);

        // Verify that page creates an account with record type of personaccount
        System.assertEquals(customerSearch.theAccount.Name, null);
        System.assertEquals(customerSearch.theAccount.RecordTypeId, UTIL_Meta.getPersonAccountRT());
		
		test.startTest();
		system.assertEquals(true, customerSearch.isPersonAccount);
 		Test.setMock(HttpCalloutMock.class, successfulMock);
        customerSearch.theAccountContact.LastName = 'TestLast0';
        customerSearch.theAccountContact.FirstName = 'TestFirst0';		
		customerSearch.theAccount.Postal_Address_City__c = 'Test City 0';
		customerSearch.theAccount.Postal_Address_Postal_Code__c = '1234';
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(1, customerSearch.sfdcResults.size());
    }
    
	// Search SFDC for results
    static testMethod void testSearchMOD(){
    	//Set up the org with default settings
		settings();
		CreateBusinessAccTestData();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		system.assertEquals('', customerSearch.alertMessage);     		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
 		system.assertEquals(1, [select count() from Account where recordTypeId=:UTIL_Meta.getAccountWorkSiteRT() AND (Name = 'Name0' OR Short_Name__c = 'Name0' OR Metaphone_Primary_Encoding__c = 'NM') AND (Name = 'Name0' OR (Postal_Address_City__c = 'PostCity0' AND Postal_Address_Postal_Code__c = '2670')) Limit 9999]);
 		customerSearch.theAccount.Name = 'Name0';
		customerSearch.theAccount.Postal_Address_City__c = 'PostCity0';
		customerSearch.theAccount.Postal_Address_Postal_Code__c = '2670';
		customerSearch.theAccount.Postal_Address_Country__c = 'DK';
		customerSearch.theAccount.Postal_Address_House_Number__c	=	'10 A';
        customerSearch.theAccount.Postal_Address_Postal_Code__c		=	'1234';
        customerSearch.theAccount.Postal_Address_Street__c			=	'Street';
        customerSearch.theAccount.Corporate_Registration_Number__c	=	'34943400';
        customerSearch.theAccount.Work_Site_Registration_Number__c	=	'7515465';
        customerSearch.theAccount.Postal_Address_City__c			=	'City';
		system.assertEquals('', customerSearch.alertMessage);
		customerSearch.doSearch();
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(1, customerSearch.sfdcResults.size());
		system.assertEquals(10, customerSearch.modResults.size());
		system.assertEquals('', customerSearch.alertMessage);
		customerSearch.selectedModIntrNr = customerSearch.modResults[1].MOD_Interessent_Number__c;
		customerSearch.selectedModModtagNr = customerSearch.modResults[1].MOD_Modtager_Number__c;
		system.assertEquals('', customerSearch.alertMessage);		
		customerSearch.selectModResult();
		system.assertEquals('', customerSearch.alertMessage);		
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
    }
      
	// Search SFDC for results with parameters passed on from PAR Search
    static testMethod void testSearchSFDCWithPassedParameters(){
    	//Set up the org with default settings
		settings();
		CreateBusinessAccTestData();
		
		businessAcc1.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
		businessAcc1.Corporate_Registration_Number__c = '34943400';
		businessAcc1.VAT_Number__c = 'DK34943400';
		businessAcc1.ParentId = null;
		update businessAcc1;
		
		businessAcc0.Corporate_Registration_Number__c = '34943400';
		businessAcc0.VAT_Number__c = 'DK34943400';
		businessAcc0.Parentid = businessAcc1.id;
		update businessAcc0;
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountWorkSiteRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
		ApexPages.currentPage().getParameters().put('externalNew', 'true');
		ApexPages.currentPage().getParameters().put('xName', 'Name0');
		ApexPages.currentPage().getParameters().put('xPostal_Address_City__c', 'PostCity0');
		ApexPages.currentPage().getParameters().put('xPostal_Address_Code__c', '2670');
		test.startTest(); 
		ApexPages.currentPage().getParameters().put('xParentId', [select id from Account WHERE name = 'Name1'].id);
		ApexPages.currentPage().getParameters().put('xRecordType', UTIL_Meta.getAccountWorkSiteRT());
		ApexPages.currentPage().getParameters().put('xVAT_Number__c', 'DK34943400');
		ApexPages.currentPage().getParameters().put('xCorporate_Registration_Number__c', '34943400');
		
       
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		

 		Test.setMock(HttpCalloutMock.class, successfulMock);
 		system.assertEquals(1, [select count() from Account where recordTypeId=:UTIL_Meta.getAccountWorkSiteRT() AND (Name = 'Name0' OR Short_Name__c = 'Name0' OR Metaphone_Primary_Encoding__c = 'NM') AND (Name = 'Name0' OR (Postal_Address_City__c = 'PostCity0' AND Postal_Address_Postal_Code__c = '2670')) Limit 9999]);
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(1, customerSearch.sfdcResults.size());
		system.assertEquals('Name0', customerSearch.sfdcResults[0].Name);
    }

	// Search SFDC for results with a visiting address passed from PAR, this should be interpreted as a Postal Address
    static testMethod void testSearchSFDCWithPassedVisitingAddress(){
    	//Set up the org with default settings
		settings();
		CreateBusinessAccTestData();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
		ApexPages.currentPage().getParameters().put('externalNew', 'true');
		ApexPages.currentPage().getParameters().put('xName', 'Name0');
		ApexPages.currentPage().getParameters().put('xVisiting_Address_City__c', 'PostCity0');
		ApexPages.currentPage().getParameters().put('xVisiting_Address_Postal_Code__c', '2670');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		
		test.startTest();
 		Test.setMock(HttpCalloutMock.class, successfulMock);
 		system.assertEquals(1, [select count() from Account where recordTypeId=:UTIL_Meta.getAccountWorkSiteRT() AND (Name = 'Name0' OR Short_Name__c = 'Name0' OR Metaphone_Primary_Encoding__c = 'NM') AND (Name = 'Name0' OR (Postal_Address_City__c = 'PostCity0' AND Postal_Address_Postal_Code__c = '2670')) Limit 9999]);
		customerSearch.doSearch();
		test.stopTest();
		
		// The alert message isn't null when no error has happened, but simply blank
		system.assertEquals('', customerSearch.alertMessage);
		system.assertEquals(1, customerSearch.sfdcResults.size());
    }

	// Search SFDC for results with a visiting address passed from PAR, this should be interpreted as a Postal Address
    static testMethod void testCancelSearch(){
    	//Set up the org with default settings
		settings();
		CreateBusinessAccTestData();
		
        // New Legal Entity
		PageReference pageRef = Page.G2O_CustomerSearch;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('RecordType', UTIL_Meta.getAccountLegalEntityRT());
		ApexPages.currentPage().getParameters().put('ent', 'Account');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
		ApexPages.currentPage().getParameters().put('externalNew', 'true');
		ApexPages.currentPage().getParameters().put('xName', 'Name0');
		ApexPages.currentPage().getParameters().put('xVisiting_Address_City__c', 'PostCity0');
		ApexPages.currentPage().getParameters().put('xVisiting_Address_Postal_Code__c', '2670');
        
        ApexPages.standardController controller = new ApexPages.standardController(new Account());
		G2O_CustomerSearch_MOD_VFCx  customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		
		test.startTest();
 		system.assertEquals(1, [select count() from Account where recordTypeId= :UTIL_Meta.getAccountWorkSiteRT() AND (Name = 'Name0' OR Short_Name__c = 'Name0' OR Metaphone_Primary_Encoding__c = 'NM') AND (Name = 'Name0' OR (Postal_Address_City__c = 'PostCity0' AND Postal_Address_Postal_Code__c = '2670')) Limit 9999]);
		PageReference cancelPage = customerSearch.cancelSearch();
		system.assert(cancelPage.getURL().containsIgnoreCase(Account.SObjectType.getDescribe().getKeyPrefix()));
        
        controller = new ApexPages.standardController(new Account());
		customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		customerSearch.theAccount = businessAcc0;
		cancelPage = customerSearch.cancelSearch();
		system.assert(cancelPage.getURL().containsIgnoreCase(businessAcc0.id));

		test.stopTest();		
    }
    
    //Test that the fields that should not be overwritten are not overwritten if they already exist
    static testMethod void testFieldUpdatesOnEnrichAccount() {
    	//Arrange
    	UTIL_TestFactory.setUpOrg();
    	
    	//Create an Person Account that will be MOD enriched
    	Account existingAccount = UTIL_TestFactory.createPersonAccount();
    	insert existingAccount;
    	
    	//Create the MOD Result account that the user wants to enrich the existing account with
    	sObject modResultAccount = UTIL_TestFactory.createPersonAccount();
    	modResultAccount.put('RecordTypeId', UTIL_Meta.getPersonAccountRT());
    	
    	//Create the list of FieldSetMembers
    	List<Schema.FieldSetMember> enrichFieldsFieldSetOverwrite = SObjectType.Account.FieldSets.CustomerSearch_MOD_EnrichFields.getFields();
    	
    	//Set the fields values on the MOD result to be able to validate the update
    	for(Schema.FieldSetMember f : enrichFieldsFieldSetOverwrite) {
    		if(String.valueOf(f.getType()) == 'STRING'){
	    		String theFieldPath = f.fieldPath;
	    		//Special rule for the Postal Code since it has to pass some validation rules
	    		if (theFieldPath == 'Postal_Address_Postal_Code__c') {
	    			modResultAccount.put(theFieldPath, '9999');
	    		}
	    		//Exclude Name since it is a Person Account
	    		else if (theFieldPath != 'Name') {
	    			modResultAccount.put(theFieldPath, modResultAccount.get(theFieldPath) + '999');
	    		}
    		}
    	}
    	insert modResultAccount;
    	
    	//Create a existing account reference where we can compare the values towards since the existing account will be enriched
    	Account existingAccountReference = existingAccount.clone(false, false);
    	insert existingAccountReference;
    	
    	//Setup the customer search page with controller
        ApexPages.standardController controller = new ApexPages.standardController(existingAccount);
		G2O_CustomerSearch_MOD_VFCx customerSearch = new G2O_CustomerSearch_MOD_VFCx(controller);
		customerSearch.selectedModResult = (Account)modResultAccount;
		customerSearch.accountIdToEnrich = existingAccount.Id;		
		customerSearch.allSfdcModMatches.put(existingAccount.Id, existingAccount);

    	//Act
    	//Enrich the Person Account with the MOD result
    	customerSearch.enrichExistingCustomer();
    	
    	//Assert
    	//Query for the enriched record
    	String query = 'SELECT ';
        for(Schema.FieldSetMember f : enrichFieldsFieldSetOverwrite) {  
            query += f.getFieldPath() +',';
        }
        query += ' Id From Account';
        query += ' WHERE '; 
        query += 'Id =\'' + existingAccount.Id+'\'';
        
        //Query for the enriched account record
        sObject enrichedAccount = Database.query(query);

    	//Make sure that the fields that should be overwritten are
    	for(Schema.FieldSetMember f : enrichFieldsFieldSetOverwrite) {
    		if(String.valueOf(f.getType()) == 'STRING'){
	    		String theFieldPath = f.fieldPath;
	    		//Ignore the Name field comparison since it is a Person Account tested
	    		if(theFieldPath != 'Name') {
	    			System.assertEquals(modResultAccount.get(theFieldPath), enrichedAccount.get(theFieldPath), 'The account field was not enriched but it should');
	    		}
    		}
    	}
    }
}