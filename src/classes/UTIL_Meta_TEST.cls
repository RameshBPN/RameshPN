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
public with sharing class UTIL_Meta_TEST {
	 
	 static testMethod void testRecordTypeFetching(){
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'B2B_Webshop_Placeholder' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountB2BWebshopPlaceHolderRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'B2C_Webshop_Placeholder' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountB2CWebshopPlaceHolderRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Competitor' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountCompetitorRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Extension' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountExtensionRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'External_Partner' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountExternalPartnerRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Invoice_Recipient' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountInvoiceRecipientRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Legal_Entity' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountLegalEntityRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'PostNord_Org_Structure' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountPostNordOrgStructureRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Work_Site' AND sObjectType = 'Account'].id, UTIL_Meta.getAccountWorkSiteRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Breve_Potential' AND sObjectType = 'Potential__c'].id, UTIL_Meta.getBrevePotentialRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Credit_check' AND sObjectType = 'Case'].id, UTIL_Meta.getcaseCreditCheckRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Item_Search' AND sObjectType = 'Case'].id, UTIL_Meta.getCaseItemSearchRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Returpost' AND sObjectType = 'Case'].id, UTIL_Meta.getcaseReturpostRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Contact_Person' AND sObjectType = 'Contact'].id, UTIL_Meta.getContactPersonRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'PostNord_Employee' AND sObjectType = 'Contact'].id, UTIL_Meta.getContactPostNordEmployeeRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'Customer_Assignment' AND sObjectType = 'Case'].id, UTIL_Meta.getCustomerAssignmentRT());
	 	system.assertEquals([SELECT id FROM RecordType WHERE developerName = 'PersonAccount' AND sObjectType = 'Account'].id, UTIL_Meta.getPersonAccountRT());
	 }
	 
	 static testMethod void testDescripeFetching(){
	 	UTIL_TestFactory.setUpOrg();
	 	system.assertEquals(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap(), UTIL_Meta.getFieldMap('Account'));
	 	
	 	Account acc = UTIL_TestFactory.createAccount();
	 	insert acc;
	 	system.assertEquals(Schema.getGlobalDescribe().get('Account'), UTIL_Meta.getObjectType(acc.id));
	 	
	 	Schema.DescribeFieldResult dfr = Account.Name.getDescribe();
		Schema.sObjectField sof = dfr.getSObjectField();
	 	system.assertEquals(dfr.getLabel(), UTIL_Meta.getFieldDescribe(sof).getLabel());
	 	system.assertEquals(dfr.getLabel(), UTIL_Meta.getFieldDescribe('Account', 'name').getLabel());
	 	system.assertEquals(dfr.getLabel(), UTIL_Meta.getFieldLabel('Account', 'Name'));
	 	
	 	system.assertEquals([SELECT id FROM Profile WHERE name = 'Integration User'].id,UTIL_Meta.profileId('Integration User'));
	 	system.assertEquals([SELECT id, name FROM Profile WHERE name = 'Integration User'].name,UTIL_Meta.profileName([SELECT id FROM Profile WHERE name = 'Integration User'].id));
	 	
	 	User integrationUser = UTIL_TestFactory.createIntegrationUser('integration@test.user');
	 	User nonIntegrationUser = UTIL_TestFactory.createUser('nonIntegration@test.user', 'System Administrator');
	 	insert integrationUser;
	 	insert nonIntegrationUser;
	 	system.assertEquals(false, UTIL_Meta.isIntegrationUser(nonIntegrationUser.ProfileId));
	 	system.assertEquals(true, UTIL_Meta.isIntegrationUser(integrationUser.ProfileId));
	 }
	 
	 static testMethod void testEnvironmentFetching(){
	 	System.assertEquals(URL.getSalesforceBaseUrl().getHost().left(2).equalsignorecase('cs'), UTIL_Meta.isEnvironmentSandbox());
	 }
}