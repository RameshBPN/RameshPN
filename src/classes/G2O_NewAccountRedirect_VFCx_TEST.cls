/**
    About
    -----
    Description: 
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: 
    
    Details
    -------
    
    Update History
    --------------
*/
@isTest
public with sharing class G2O_NewAccountRedirect_VFCx_TEST {
	

    static String RecordTypeId; 

    static testMethod void testRedirectCustomerCreatePersonAccount() {
		UTIL_TestFactory.setUpOrg();
		Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
		get2OneCrm.New_Customer_MOD_Flow_Record_Types__c = 'PersonAccount';
		get2OneCrm.New_Customer_Main_Flow_Record_Types__c = 'Work_Site,Legal_Entity,External_Partner,Competitor';
		get2OneCRM.New_Customer_MOD_Flow_Reg_Country__c = 'DK';
		get2OneCRM.New_Customer_MOD_Flow_WS_Type__c = 'TY99';
		update get2OneCrm; 
        // Use Case: Redirects the user to Customer Create for Private Person
        
        // Arrange
        Account account = new Account(); 
        RecordTypeId = UTIL_Meta.getPersonAccountRT();  // queries RecordType for Person Account
        
        //ACT
        Test.startTest();

        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeId);                   // put the recordTypeId in the variable
        ApexPages.standardController controller = new ApexPages.standardController(account);
        
        G2O_NewAccountRedirect_VFCx  customerRedirect = new G2O_NewAccountRedirect_VFCx(controller); 
        PageReference pr = customerRedirect.redirectCustomerCreate();                                                  // Redirect to customer Create for Person Account
        
        Test.stopTest();
        
        // Assert
        system.assert(pr.getURL().toUpperCase().contains('G2O_CUSTOMERSEARCH_MOD'));
    }
    
    static testMethod void testRedirectCustomerCreateNonPersonAccount() {
		UTIL_TestFactory.setUpOrg();
		Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
		get2OneCrm.New_Customer_MOD_Flow_Record_Types__c = 'PersonAccount';
		get2OneCrm.New_Customer_Main_Flow_Record_Types__c = 'Work_Site,Legal_Entity,External_Partner,Competitor';
		get2OneCRM.New_Customer_MOD_Flow_Reg_Country__c = 'DK';
		get2OneCRM.New_Customer_MOD_Flow_WS_Type__c = 'TY99';
		update get2OneCrm; 
        // Use Case: Redirects the user to Customer Create for Private Person
        
        // Arrange
        Account account = new Account(); 
        RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();  // queries RecordType for Work Site
        
        //ACT
        Test.startTest();

        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeId);                   // put the recordTypeId in the variable
        ApexPages.standardController controller = new ApexPages.standardController(account);
        
        G2O_NewAccountRedirect_VFCx  customerRedirect = new G2O_NewAccountRedirect_VFCx(controller); 
        PageReference pr = customerRedirect.redirectCustomerCreate();                                                  // Redirect to customer Create for Person Account
        
        Test.stopTest();
        
        // Assert
	    system.assert(pr.getURL().toUpperCase().contains('G2O_CUSTOMERSEARCH'));
	    system.assert(!pr.getURL().toUpperCase().contains('G2O_CUSTOMERSEARCH_MOD'));
    }
    
    static testMethod void testRedirectCustomerCreateUnknownRecordType() {
		UTIL_TestFactory.setUpOrg();
		Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
		get2OneCrm.New_Customer_MOD_Flow_Record_Types__c = 'PersonAccount';
		get2OneCrm.New_Customer_Main_Flow_Record_Types__c = 'Work_Site,Legal_Entity,External_Partner,Competitor';
		get2OneCRM.New_Customer_MOD_Flow_Reg_Country__c = 'DK';
		get2OneCRM.New_Customer_MOD_Flow_WS_Type__c = 'TY99';
		update get2OneCrm; 
        // Use Case: Redirects the user to Customer Create for Private Person
        
        // Arrange
        Account account = new Account(); 
        RecordTypeId = UTIL_Meta.getAccountWorkSiteRT() + 'test';
        
        //ACT
        Test.startTest();

        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeId);                   // put the recordTypeId in the variable
        ApexPages.standardController controller = new ApexPages.standardController(account);
        
        G2O_NewAccountRedirect_VFCx  customerRedirect = new G2O_NewAccountRedirect_VFCx(controller); 
        PageReference pr = customerRedirect.redirectCustomerCreate();                                                  // Redirect to customer Create for Person Account
        
        Test.stopTest();
        
        // Assert
	    system.assert(pr.getURL().toUpperCase().contains('001/E'), pr.getURL());
    }
    
    /*
    * If the user has a default record type set (or only has 1 recordtype) then no
    * Recordtype is passed along in the URL to the page
    */
	static testMethod void testRedirectCustomerCreateDefaultRecordType() {
		UTIL_TestFactory.setUpOrg();
		Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
		get2OneCrm.New_Customer_MOD_Flow_Record_Types__c = 'PersonAccount';
		get2OneCrm.New_Customer_Main_Flow_Record_Types__c = 'Work_Site,Legal_Entity,External_Partner,Competitor';
		get2OneCRM.New_Customer_MOD_Flow_Reg_Country__c = 'DK';
		get2OneCRM.New_Customer_MOD_Flow_WS_Type__c = 'TY99';
		update get2OneCrm; 

		User testUser = UTIL_TestFactory.createUser('testUser@postnord.se.testRedirect', 'Standard User');
		insert testUser;
        // Arrange
        Account account = new Account(); 
        
        //ACT
        Test.startTest();
		PageReference pr;
		system.runAs(testUser){
	        ApexPages.standardController controller = new ApexPages.standardController(account);
	        
	        G2O_NewAccountRedirect_VFCx  customerRedirect = new G2O_NewAccountRedirect_VFCx(controller); 
	        pr = customerRedirect.redirectCustomerCreate();                                                  // Redirect to customer Create for Person Account
		}
        Test.stopTest();
        
        // Assert
	    system.assert(pr.getURL().toUpperCase().contains('G2O_CUSTOMERSEARCH'));
	    system.assert(!pr.getURL().toUpperCase().contains('G2O_CUSTOMERSEARCH_MOD'));
    }
}