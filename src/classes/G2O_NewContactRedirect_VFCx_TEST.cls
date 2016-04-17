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
public with sharing class G2O_NewContactRedirect_VFCx_TEST {
	

    static String RecordTypeId; 

    static testMethod void testRedirectContactCreatePostNordEmployee() {
		UTIL_TestFactory.setUpOrg();
		Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
		get2OneCrm.New_Contact_Main_Flow_Record_Types__c = 'Contact_Person';
		update get2OneCrm; 
        // Use Case: Redirects the user to Customer Create for PostNord Employee
        
        // Arrange
        Account account = new Account(); 
        RecordTypeId = UTIL_Meta.getPersonAccountRT();  // queries RecordType for Person Account
        
        //ACT
        Test.startTest();

        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeId);                   // put the recordTypeId in the variable
        ApexPages.standardController controller = new ApexPages.standardController(account);
        
        G2O_NewContactRedirect_VFCx  contactRedirect = new G2O_NewContactRedirect_VFCx(controller); 
        PageReference pr = contactRedirect.redirectContactCreate();                                                  // Redirect to customer Create for Person Account
        
        Test.stopTest();
        
        // Assert
        system.assert(!pr.getURL().toUpperCase().contains('G2O_CUSTOMERCREATECONTACT'));
    }

	// Use Case: Redirects the user to Contact Create for Contact Person    
    static testMethod void testRedirectContactCreateContactPerson() {
		UTIL_TestFactory.setUpOrg();
		Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
		get2OneCrm.New_Contact_Main_Flow_Record_Types__c = 'Contact_Person';
		update get2OneCrm; 
        
        // Arrange
        Contact contact = new Contact(); 
        RecordTypeId = UTIL_Meta.getContactPersonRT();  // queries RecordType for Work Site
        
        //ACT
        Test.startTest();

        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeId);                   // put the recordTypeId in the variable
        ApexPages.standardController controller = new ApexPages.standardController(contact);
        
        G2O_NewContactRedirect_VFCx  contactRedirect = new G2O_NewContactRedirect_VFCx(controller); 
        PageReference pr = contactRedirect.redirectContactCreate();							// Redirect to contact Create for Contact Person
        
        Test.stopTest();
        
        // Assert
	    system.assert(pr.getURL().toUpperCase().contains('G2O_CUSTOMERCREATECONTACT'));
    }
    
    /*
    * If the user has a default record type set (or only has 1 recordtype) then no
    * Recordtype is passed along in the URL to the page
    */
	static testMethod void testredirectContactCreateDefaultRecordType() {
		UTIL_TestFactory.setUpOrg();
		Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
		get2OneCrm.New_Contact_Main_Flow_Record_Types__c = 'Contact_Person';
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
	        
	        G2O_NewContactRedirect_VFCx  contactRedirect = new G2O_NewContactRedirect_VFCx(controller); 
	        pr = contactRedirect.redirectContactCreate();                                                  // Redirect to customer Create for Person Account
		}
        Test.stopTest();
        
        // Assert
	    system.assert(pr.getURL().toUpperCase().contains('G2O_CUSTOMERCREATECONTACT'));
    }
}