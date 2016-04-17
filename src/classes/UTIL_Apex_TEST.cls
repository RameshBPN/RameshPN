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
public with sharing class UTIL_Apex_TEST {
	
	static testMethod void testEmpty() {
		UTIL_TestFactory.setupOrg();
		Object testObject;
		String testString;
		Integer testInteger;
		Decimal testDecimal;
		Boolean testBoolean;
		
		system.assertEquals(true, UTIL_Apex.empty(testObject));
		system.assertEquals(true, UTIL_Apex.empty(testString));
		system.assertEquals(true, UTIL_Apex.empty(testInteger));
		system.assertEquals(true, UTIL_Apex.empty(testDecimal));
		system.assertEquals(true, UTIL_Apex.empty(testBoolean));
		system.assertEquals(false, UTIL_Apex.isSet(testObject));
		system.assertEquals(false, UTIL_Apex.isSet(testString));
		system.assertEquals(false, UTIL_Apex.isSet(testInteger));
		system.assertEquals(false, UTIL_Apex.isSet(testDecimal));
		system.assertEquals(false, UTIL_Apex.isSet(testBoolean));
		
		testObject = new Account();
		testString = 'testString';
		testInteger = 1;
		testDecimal = 1.1;
		testBoolean = true;
		
		system.assertEquals(false, UTIL_Apex.empty(testObject));
		system.assertEquals(false, UTIL_Apex.empty(testString));
		system.assertEquals(false, UTIL_Apex.empty(testInteger));
		system.assertEquals(false, UTIL_Apex.empty(testDecimal));
		system.assertEquals(false, UTIL_Apex.empty(testBoolean));				
		system.assertEquals(true, UTIL_Apex.isSet(testObject));
		system.assertEquals(true, UTIL_Apex.isSet(testString));
		system.assertEquals(true, UTIL_Apex.isSet(testInteger));
		system.assertEquals(true, UTIL_Apex.isSet(testDecimal));
		system.assertEquals(true, UTIL_Apex.isSet(testBoolean));		
	}	
	
	static testMethod void testToListToSet(){
		UTIL_TestFactory.setupOrg();
		list<Id> idList = new list<Id>();
		list<String> stringList = new list<String>();
		list<sObject> sobjectList = new list<sObject>();
		set<Id> idSet;
		set<String> stringSet;
		set<Sobject> sobjectSet = new set<sObject>();
		
		for(Integer i = 0; i < 10; i++){
			sobjectList.add(UTIL_TestFactory.createAccount());
		}
		insert sobjectList;
		
		for(sobject sobj : sobjectList){
			idList.add(sobj.id);
			idList.add(sobj.id);
			stringList.add('test' + sobj.id);
			stringList.add('test' + sobj.id);
		}

		idSet = UTIL_Apex.toSet(idList);
		stringSet = UTIL_Apex.toSet(stringList);
		
		system.assertEquals(idList.size() / 2, idSet.size());
		system.assertEquals(stringList.size() / 2, stringSet.size());
		
		sobjectSet.addAll(sobjectList);
		sobjecTList = null;
		sobjectList = UTIL_Apex.toList(sobjectSet);
		idList = UTIL_Apex.toList(idSet);
		stringList = UTIL_Apex.toList(stringSet);
		
		system.assertEquals(sobjectSet.size(), sobjectList.size());
		system.assertEquals(idSet.size(), idList.size());
		system.assertEquals(stringSet.size(), stringList.size());
	}
	
	/** Not in use
	static testMethod void testSerialize(){
		UTIL_TestFactory.setUpOrg();
		Account acc = UTIL_TestFactory.createAccount();
		insert acc;
		Contact con = UTIL_TestFactory.createContact();
		con.Activities__c = 'Seasonal Greeting;DR magazine;Other Marketing Activities';
		con.Accountid = acc.id;
		insert con;		
		
		set<String> stringSet = new set<String>();
		stringSet.add('Seasonal Greeting');
		stringSet.add('DR magazine');
		stringSet.add('Other Marketing Activities');
		
		system.assertEquals( '\'Seasonal Greeting\',\'DR magazine\',\'Other Marketing Activities\'', UTIL_Apex.serializeWithQuotes(con.Activities__c), 'Expected the data to have been serialized');
		system.assertEquals( '\'Other Marketing Activities\',\'Seasonal Greeting\',\'DR magazine\'', UTIL_Apex.serializeWithQuotes(stringSet), 'Expected the data to have been serialized');
		system.assertEquals(3, UTIL_Apex.deserializeMultiSelect(con.Activities__c).size(), 'Expected a list containing the 3 entries');		
	}
	*/
	
	static testMethod void testOrderList(){
		UTIL_TestFactory.setUpOrg();		
		list<Account> accountList = new list<Account>();
		for(Integer i = 0; i < 10; i++){
			accountList.add(UTIL_TestFactory.createAccount());
			accountList[i].Name = i + ' test Name';
		}
		insert accountList;
		
		system.assertEquals('9 test Name', accountList[9].Name);
		system.assertEquals('0 test Name', accountList[0].Name);

		UTIL_Apex.orderList(accountList, 'Name', 'desc');
		system.assertEquals('0 test Name', accountList[9].Name);
		system.assertEquals('9 test Name', accountList[0].Name);
	}
	
	static testMethod void testConvertStringToInt(){
		UTIL_TestFactory.setUpOrg();
		String testString = 'A1B2C3D4E5a1b2c3d4';
		system.assertEquals(123451234,UTIL_Apex.convertStringToInt(testString));
		String testString2 = 'abcdef';
		system.assertEquals(0,UTIL_Apex.convertStringToInt(testString2));		
	}
	
	/** Not in use
	static testMethod void testValidateEmail(){
		string almostAnEmail ='abcdef';
		string anEmail = 'test@testersen.test';
		
		system.assertEquals(false, UTIL_Apex.validateEmail(almostAnEmail));
		almostAnEmail ='abcdef@cdef';
		system.assertEquals(false, UTIL_Apex.validateEmail(almostAnEmail));
		almostAnEmail ='abcdef@cdef@cdef';
		system.assertEquals(false, UTIL_Apex.validateEmail(almostAnEmail));
		almostAnEmail ='abcdef.com';
		system.assertEquals(false, UTIL_Apex.validateEmail(almostAnEmail));
		almostAnEmail ='abcdef.com.com';
		system.assertEquals(false, UTIL_Apex.validateEmail(almostAnEmail));
		system.assertEquals(true, UTIL_Apex.validateEmail(anEmail));
		
	}
	*/
	
	//Test recycle bin emptying
    static testMethod void testEmptyRecycleBinWithARecordInRecycleBin() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        Bank_Details__c bankDetail = UTIL_TestFactory.createBankDetail();
        insert bankDetail;

        //Act
        delete bankDetail;

        try {	
    		UTIL_Apex.emptyRecycleBin(new List<Id>{bankDetail.Id});
        } catch (Exception e) {
        	System.debug('Exception: ' + e);
        	System.assert(false, 'An unexpected error was thrown.');
        }
        
        //Assert
        List<ApexErrorLog__c> errors = [SELECT Id, Error_Code__c FROM ApexErrorLog__c];
        System.assertEquals(1, errors.size(), 'Incorrect number of errors.');
        System.assertEquals('EmptyRecycleBin', errors[0].Error_Code__c, 'Incorrect error code.');
    }	 
	
    static testMethod void testEmptyRecycleBinWithNoRecordInRecycleBin() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        Account account = UTIL_TestFactory.createAccount();
       	insert account;

        //Act
        try {	
    		UTIL_Apex.emptyRecycleBin(new List<Id>{account.Id});
        } catch (Exception e) {
        	System.debug('Exception: ' + e);
        	System.assert(false, 'An unexpected error was thrown.');
        }
        
        //Assert
        List<ApexErrorLog__c> errors = [SELECT Id, Error_Code__c FROM ApexErrorLog__c];
        System.assertEquals(1, errors.size(), 'Incorrect number of errors.');
        System.assertEquals('EmptyRecycleBin', errors[0].Error_Code__c, 'Incorrect error code.');
    }
    
    static testMethod void testEmptyRecycleBinWithNoRecordsToRecycle() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();

        //Act
        try {	
    		UTIL_Apex.emptyRecycleBin(new List<Id>());
        } catch (Exception e) {
        	System.debug('Exception: ' + e);
        	System.assert(e.getMessage().contains('MISSING_ARGUMENT: emptyRecycleBin called with a batch of 0 ids to undelete; must specify at least 1 id'), 'An unexpected error was thrown: ' + e.getMessage());
        }
    }
}