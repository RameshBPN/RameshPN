/**
    About
    -----
    Description: This class is used to test G2O_Contact_SVC. 
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: November 2014
    
    Details
    -------
    1. doNotUpdate_BeforeUpdate_Test - Test that integration user cannot .
    

    Update History
    --------------
    Created March 2013 - Aref Alazzani
    
    
    Issues / TODOs
    --------------
*/
@isTest
private class G2O_Contact_SVC_TEST {
	
	
	static User integrationUser;
	static User nonIntegrationUser;
	
	static List<Schema.FieldSetMember> restrictedFields = SObjectType.Contact.FieldSets.doNotUpdateFieldsForIntegrationUsers.getFields();
	
	static Account testAccount;
	static Contact testContact = new Contact();
	static Id testContactId {get{return testContact.Id;}set;}
	
    static testMethod void doNotUpdate_BeforeUpdate_Test() {
        
        InitiateTestData();
        
        if(restrictedFields.size()>0){
        		
        	String query = 'SELECT ';
	        for(Schema.FieldSetMember f : restrictedFields) {
	            query += f.getFieldPath() + ', ';
	        }
	        query += 'Id, Name FROM Contact where Id = :testContactId limit 1';
	        testContact =  Database.query(query);
		    
		    for(Schema.FieldSetMember restrictedField : restrictedFields){
		    	
		    	//This test code assume that at least one of the three
		    	//data types will be listed among restricted fields
		    	
		    	if(restrictedField.getType() == DisplayType.Email){
		    		
		    		testContact.put(restrictedField.getFieldPath() , 'test1234567890@test.com');
		    		
		    	} else if(restrictedField.getType() == DisplayType.String){
		    		
		    		testContact.put(restrictedField.getFieldPath() , 'Some different string');
		    	
		    	} else if(restrictedField.getType() == DisplayType.Integer){
		    		
		    		testContact.put(restrictedField.getFieldPath() , 1234);
		    	}
		    	
		    }
		        
	        
	        System.runAs(integrationUser){
	        	
	        	update testContact;
	        }
	        
	        Contact newContact = Database.query(query);
	        for(Schema.FieldSetMember restrictedField : restrictedFields){
		    	
		    	//This test code assume that at least one of the three
		    	//data types will be listed among restricted fields
		    	
		    	if(restrictedField.getLabel() != 'Id' && restrictedField.getLabel() != 'Name'){
		    		
		    		System.assertNotEquals(testContact.get(restrictedField.getFieldPath()), newContact.get(restrictedField.getFieldPath()));
		    		
		    	} 
		    	
		    }
	        
	        System.runAs(nonIntegrationUser){
	        	
	        	update testContact;
	        }
	        newContact = Database.query(query);
	        for(Schema.FieldSetMember restrictedField : restrictedFields){
		    	
		    	//This test code assume that at least one of the three
		    	//data types will be listed among restricted fields
		    	
		    	if(restrictedField.getLabel() != 'Id' && restrictedField.getLabel() != 'Name'){
		    		
		    		System.assertEquals(testContact.get(restrictedField.getFieldPath()), newContact.get(restrictedField.getFieldPath()));
		    		
		    	} 
		    	
		    }
        }
    }
    
    static void InitiateTestData(){
        
        List<User> testUsers= new List<User>();
        integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUserTest@postnord.se');
        testUsers.add(integrationUser);
        nonIntegrationUser = UTIL_TestFactory.createSalesUser('salesUserTest@postnord.se');
        testUsers.add(nonIntegrationUser);
        insert testUsers;
        
        testAccount = UTIL_TestFactory.createAccount();
        testAccount.Do_Not_Update_Address_Automatically__c = true;
        insert testAccount;
        
        testContact = UTIL_TestFactory.createContact();
        testContact.AccountId = testAccount.Id;
        insert testContact; 
    }

    // Contact Center project - Fluido Denmark - Test case to normalise phone numbers
    static testMethod void normalisePhoneNumbers() {
        // create country code custom settings
        Country_Calling_Codes__c cc = new Country_Calling_Codes__c();
        cc.Name = 'DK';
        cc.Code__c = '45';
        cc.Country__c = 'DENMARK';
        insert cc;
        
        UTIL_TestFactory.setUpOrg();

        // create a sample account
        Account acct = UTIL_TestFactory.createAccount();
        insert acct;
        system.assert(acct.Id != null);

        // create a sample contact
        Contact ct = UTIL_TestFactory.createContact();
        ct.AccountId = acct.Id;
        ct.Phone = '60602020';
        ct.MobilePhone = '50501010';
        insert ct;
        system.assert(ct.Id != null);
         
        Contact ctTmp = [SELECT Id, CC_Phone__c, CC_Mobile__c FROM Contact WHERE Id = :ct.Id];
        system.assert(ctTmp.Id != null);
        system.assertEquals(ctTmp.CC_Phone__c, '+4560602020');
        system.assertEquals(ctTmp.CC_Mobile__c, '+4550501010');
    }
}