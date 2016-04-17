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
public with sharing class UTIL_Error_TEST {	
	static testMethod void createErrorLog(){
		system.assertEquals(0, [Select count() From ApexErrorLog__c]);
		UTIL_TestFactory.setUpOrg();
		UTIL_Error.report('Error Code');
		UTIL_Error.writeNow();
		system.assertEquals(1, [Select count() From ApexErrorLog__c]);
		UTIL_Error.report('Error Code 2', 'Error Description for Error Code 2');
		UTIL_Error.report('Error Code 3', 'Error Description for Error Code 3', 'in createErrorLogTest');
		try{
			integer i = 5/0;	
		}
		catch(Exception e){
			UTIL_Error.report(e);
			UTIL_Error.report('Exception Caught', e);
		}
		test.startTest();
		UTIL_Error.write();
		test.stopTest();
		system.assertEquals(5, [Select count() From ApexErrorLog__c]);
		system.assertEquals(1, [Select count() From ApexErrorLog__c Where Error_Code__c = 'Error Code']);
		system.assertEquals(1, [Select count() From ApexErrorLog__c Where Error_Code__c = 'Error Code 2']);
		system.assertEquals(1, [Select count() From ApexErrorLog__c Where Error_Code__c = 'Error Code 3' And Location__c = 'in createErrorLogTest']);
	}	
	
	static testMethod void testRecipientFetching(){
		UTIL_TestFactory.setUpOrg();
        Apex_Development_Settings__c apexDevSet = Apex_Development_Settings__c.getOrgDefaults();
		apexDevSet.Error_Alert_Recipients__c = 'abc@test.com,def@test.com';
		upsert apexDevSet;
		list<String> recipients = UTIL_Error.errorAlertRecipients();
		system.assertEquals(2, recipients.size(), recipients);
		set<String> recipientsSet = new set<String>();
		recipientsSet.addAll(recipients);
		system.assert(recipientsSet.contains('abc@test.com'));
		system.assert(recipientsSet.contains('def@test.com'));	
	}

}