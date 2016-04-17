/**
    About
    -----
    Description: This class contains Use case tests relating to the automatically assigned customer number
                 code functionality, some of them will test functionality implemented through validation rules and workflows.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2013
    
    Details
    -------
    1. doNotAllowCustomerRangeToChange tests that an account can't change between internal and external.
    2. insertAccountWithCustomerNumber tests that the Involved_Party_ID__c can contain both nubmers and texts, and that it is unique.
    3. updateAccountWithCustomerNumber tests that the value of the Involved_Party_ID__c field cannot change once set on an Account.
    4. insertAccountWithoutCustomerNumber tests than both an internal and external Account is correctly given a Involved_Party_ID and that the range of Id's is expanded everytime.
    
    Update History
    --------------
    Created August 2013 based on the Sprint02_CustomerNumbering_TEST class - K.E.A.J.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_UseCase_CustomerNumbering_TEST {

    // Tests that an account can't change between internal and external.
    // This is enforced in Validation rules
    static testMethod void doNotAllowCustomerRangeToChange()
    {
        UTIL_TestFactory.setUpOrg();
        // Customer rec types are defined if they are external or internal customers. As IDs are set, the definition of the account should also not be allowed to change as SAP/ERP has dependencies on the numering used.
        // Create an External 
        Account a = UTIL_Testfactory.createAccount();
        insert a;
        // Update to Internal (fail)
        a.External_or_Internal__c = 'Internal';
        try
        {
            update a;
            System.assert(false,'Account changed from External to Internal, this should not happen');
        }
        catch(exception e){}
        
        /* TODO: This comment needs to be removed when the users are able to create internal customers again.
        	Right now there is a validation rule blocking creation of internal customers.
        // Create an Internal 
        Account b = UTIL_Testfactory.createAccount();
        b.External_or_Internal__c = 'Internal';
        insert b;
        // Update to External (fail)
        b.External_or_Internal__c = 'External';
        try
        {
            update b;
            System.assert(false,'Account changed from Internal to External, this should not happen');
        }
        catch(exception e){} 
        */
    }
    
    // Tests that the Involved_Party_ID__c field can contain both numbers and text. This is enforced through field type
    // Tests that only one Account can have a specific Involved_Party_ID__c value. This is enforced by the field being unique
    static testMethod void insertAccountWithCustomerNumber() 
    {   
        UTIL_TestFactory.setUpOrg();
        // A customer number that is both numeric and alpha numeric - succeed
        Account a = UTIL_Testfactory.createAccount();
        String givenId = '12345testRecord';
        a.Involved_Party_ID__c = givenId;
        insert a;
        a = [select id, Involved_Party_ID__c from Account where Involved_Party_ID__c = :givenId limit 1]; // throws an error if not found //TODO: may not be required in test script?
        System.assert(a.Involved_Party_ID__c == givenId);
        
        // A customer number that already exists - fail
        Account b = UTIL_Testfactory.createAccount();
        b.Involved_Party_ID__c = givenId;
        try
        {
            insert b;
            System.assert(false,'Should not be possible to create a cusomter with an Involved Party ID that already exists');
        }
        catch(exception e){}
        
        /* TODO: This comment needs to be removed when the users are able to create internal customers again.
        	Right now there is a validation rule blocking creation of internal customers.
        // An internal customer (external is default so no need to specify in own test) with own number
        Account c = UTIL_TestFactory.createAccount();
        c.External_or_Internal__c = 'Internal';
        givenId = '7654anotherTest';
        c.Involved_Party_ID__c = givenId;
        insert c;
        c = [select id, Involved_Party_ID__c from Account where Involved_Party_ID__c = :givenId limit 1]; // throws an error if not found //TODO: may not be required in test script?
        System.assert(c.Involved_Party_ID__c == givenId);
        */
    }
    
    // Tests that the value of the Involved_Party_ID__c field cannot change once set on an Account. This is enforced through Validation rules.
    static testMethod void updateAccountWithCustomerNumber() {
        UTIL_TestFactory.setUpOrg();
        // Update a customer that already has a number (fail)
        Account a = UTIL_TestFactory.createAccount();
        a.Involved_Party_ID__c = '111111111';
        insert a;
        a.Involved_Party_ID__c = '111111111Overwrite';
        try
        {
            update a;
            System.assert(false,'Should not be able to overwrite an invovled party id!');
        }
        catch(exception e){}
    }
    
    // Tests than both an internal and external Account is correctly given a Involved_Party_ID 
    // and that the range of Id's is expanded everytime
    static testMethod void insertAccountWithoutCustomerNumber() 
    {
        UTIL_TestFactory.setUpOrg();
        
        // An external customer - ensure correct number range
        //Involved_Party_ID_Range__c[] extRange = [select id,name from Involved_Party_ID_Range__c];
        Account b = UTIL_TestFactory.createAccount();
        insert b;
        b = [select id,Involved_Party_ID__c,External_or_Internal__c from Account where id=:b.id ];

        Account secondaryBaccount = UTIL_TestFactory.createAccount();
        insert secondaryBaccount;
        secondaryBaccount = [select id,Involved_Party_ID__c,External_or_Internal__c from Account where id=:secondaryBaccount.id ];
        
        System.debug(logginglevel.info,'@@ Created external customer '+b);
        System.assert(b.Involved_Party_ID__c!=null && b.Involved_Party_ID__c!='','Invovled party ID was not set when inserting a new External customer');
        System.assert(secondaryBaccount.Involved_Party_ID__c!=null && secondaryBaccount.Involved_Party_ID__c!='','Invovled party ID was not set when inserting a new External customer');
        
        System.assert(Integer.valueOf(b.Involved_Party_ID__c)+1 == Integer.valueOf(secondaryBaccount.Involved_Party_ID__c),'External involved party number set, but the ranges have not increased. First Acc number: '+b.Involved_Party_ID__c+' Second Acc number: '+secondaryBaccount.Involved_Party_ID__c);
        
        /* TODO: This comment needs to be removed when the users are able to create internal customers again.
        	Right now there is a validation rule blocking creation of internal customers.
        Account a = UTIL_TestFactory.createAccount();
        a.External_or_Internal__c = 'Internal';
        insert a;
        a = [select id,Involved_Party_ID__c,External_or_Internal__c from Account where id=:a.id ];

        Account secondaryAaccount = UTIL_TestFactory.createAccount();
        secondaryAaccount.External_or_Internal__c = 'Internal';
        insert secondaryAaccount;
        secondaryAaccount = [select id,Involved_Party_ID__c,External_or_Internal__c from Account where id=:secondaryAaccount.id ];
        
        System.debug(logginglevel.info,'@@ Created internal customer '+a);
        System.assert(a.Involved_Party_ID__c!=null && a.Involved_Party_ID__c!='','Invovled party ID was not set when inserting a new internal customer');
        System.assert(secondaryAaccount.Involved_Party_ID__c!=null && secondaryAaccount.Involved_Party_ID__c!='','Invovled party ID was not set when inserting a new External customer');
        
        System.assert(Integer.valueOf(secondaryAaccount.Involved_Party_ID__c) == Integer.valueOf(a.Involved_Party_ID__c)+1,'Internal involved party number set, but the ranges have not increased. First Acc number: '+a.Involved_Party_ID__c+' Second Acc number: '+secondaryAaccount.Involved_Party_ID__c);
        */
        
        // A customer number that already exists (fail)
        Account c = UTIL_TestFactory.createAccount();
        c.Involved_Party_ID__c = b.Involved_Party_ID__c;
        try
        {
            insert c;
            System.assert(false,'Should not be able to insert an Account with an invovled party id that already exists');
        }
        catch(exception e){}
    }
    
    // Tests that when an account is deleted its number is never assigned to a new account (even though it is deleted from the table)
    static testMethod void deleteAccountWithoutCustomerNumber() 
    {
        UTIL_TestFactory.setUpOrg();
        
        integer extRange = [select count() from Involved_Party_ID_Range__c];
        Account b = UTIL_TestFactory.createAccount();
        insert b;
        b = [select id,Involved_Party_ID__c,External_or_Internal__c from Account where id=:b.id ];
        system.assert(b.Involved_Party_ID__c != null, 'Involved_Party_ID__c should have a value: ' + b.Involved_Party_ID__c);
        
        System.debug(logginglevel.info,'@@ Created external customer '+b);
        String preDeletesInvolvedPartyId = b.Involved_Party_ID__c;
        integer intRange1 = [select count() from Involved_Party_ID_Range__c];
        b.Deletion_Flag__c = true;
        update b;
        b = [select id,Involved_Party_ID__c,External_or_Internal__c from Account where id=:b.id ];
        system.assert(b.Involved_Party_ID__c != null, 'Involved_Party_ID__c should have a value: ' + b.Involved_Party_ID__c);
  
        delete b;
        system.assertEquals(0, [SELECT count() FROM Account WHERE id = :b.id]);

        Account c = UTIL_TestFactory.createAccount();
        insert c;
        c = [select id,Involved_Party_ID__c,External_or_Internal__c from Account where id=:c.id ];
        system.assertNotEquals(preDeletesInvolvedPartyId, c.Involved_Party_ID__c, 'The account was given the Involved_Party_ID of the deleted account, this is not desired functionality');
    }
}