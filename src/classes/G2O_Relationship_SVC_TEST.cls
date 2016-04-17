/**
    About
    -----
    Description: This class is used to test RelationshipValidation_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2013
    
    Details
    -------
    This Class test the functionality of RelationshipValidation_SVC class.
    1. Test validateSalesAreaOnRelationship method of RelationshipValidation_SVC class.

    
    Update History
    --------------
    Created August 2013 - K.E.A.J.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Relationship_SVC_TEST {

    static List<Sales_Area_Information__c> salesAreaInformationLst = new List<Sales_Area_Information__c>();
    static Account account;
    static list<Account> irAccounts;
    static final String salesArea = '0540';//Sales area for testing
    static testMethod void validateSalesAreaOnRelationshipTest() {
        createData();
        //Relationship__c relationship = UTIL_TestFactory.createRelationship();
        
        Relationship__c relationship = new Relationship__c();
        
        relationship.Sales_Area__c =  [Select Sales_Area1__c from User Where id = :UserInfo.getUserId()].Sales_Area1__c;
                
        relationship.Account__c = salesAreaInformationLst[0].Account__c;
        relationship.Related_Account__c = salesAreaInformationLst[1].Account__c;
        relationship.Relationship_Type__c = 'RE';
        Test.startTest();
        
        // Testing when none of the Accounts match the Relationship
        relationship.Sales_Area__c = '9999';
        try{
            insert relationship;
            system.assert(false);
        }
        catch(Exception e){
            //Assert error message to match error for both M-D and related account missing Sales area information
            system.assert(e.getMessage().contains(Label.Selected_Sales_Area_is_not_present_on_either_account), 'Expected error for both Accounts lacking sales area information, got: ' + e.getMessage());
        } 

        // Testing when the M-D Accounts sales information doesn't match the Relationship
        relationship.Sales_Area__c = salesArea;
        try{
            insert relationship;
            system.assert(false);
        }
        catch(Exception e){
            //Assert error message to match error for M-D account missing Sales area information
            system.assert(e.getMessage().contains(Label.New_Relation_Sales_Area_doesn_t_match_Master_Accounts),e.getMessage() + '  || ' + Label.New_Relation_Sales_Area_doesn_t_match_Master_Accounts);
        }
 
        // Testing when the related Accounts sales information doesn't match the Relationship       
        relationship.Sales_Area__c = '1000';
        try{
            insert relationship;
            system.assert(false);
        }
        catch(Exception e){
            //Assert error message to match error for related account missing Sales area information
            system.assert(e.getMessage().contains(Label.New_Relation_Sales_Area_doesn_t_match_Detail_Accounts), e.getMessage());
        }

        // Testing when both accounts has correct Sales Area Information
        relationship.Related_Account__c = salesAreaInformationLst[2].Account__c;
        try{
            insert relationship;
            system.assert(true);
        }
        catch(Exception e){
            system.assert(false, e.getMessage());
        }
        Test.stopTest();
    }

   static testMethod void validateOnSalesAreaInformationNonCustomerTest() {
        createNonCustomerData();
        Relationship__c relationship = new Relationship__c();
        
        relationship.Sales_Area__c =  [Select Sales_Area1__c from User Where id = :UserInfo.getUserId()].Sales_Area1__c;
                
        relationship.Account__c = salesAreaInformationLst[0].Account__c;
        relationship.Related_Account__c = salesAreaInformationLst[1].Account__c;
        relationship.Relationship_Type__c = 'RE';
        
        Test.startTest();
        
        // Testing when the related Accounts sales information object has been deleted doesn't match the Relationship       
        relationship.Sales_Area__c = '1000';
        relationship.Related_Account__c = salesAreaInformationLst[2].Account__c;
        try{
            insert relationship;
            system.assert(false);
        }
        catch(Exception e){
            system.assert(e.getMessage().contains(Label.New_Relation_Sales_Area_doesn_t_match_Detail_Accounts));
        }
 
        salesAreaInformationLst[2].Type__c = 'External Partner';
        update salesAreaInformationLst[2];
        try{
            insert relationship;
            system.assert(false);
        }
        catch(Exception e){
            system.assert(e.getMessage().contains(Label.New_Relation_Sales_Area_doesn_t_match_Detail_Accounts));
        }
        
        salesAreaInformationLst[2].Type__c = 'Competitor';
        update salesAreaInformationLst[2];
        try{
            insert relationship;
            system.assert(false);
        }
        catch(Exception e){
            system.assert(e.getMessage().contains(Label.New_Relation_Sales_Area_doesn_t_match_Detail_Accounts));
        }  
        
        salesAreaInformationLst[2].Type__c = 'Customer';
        update salesAreaInformationLst[2];
        try{
            insert relationship;
            system.assert(true);
        }
        catch(Exception e){
            system.assert(false);
        }      
        Test.stopTest();
    }

    // Test that a relationship is allowed when one or more of its sources are Invoice Recipients
    static testMethod void validateOnSalesAreaInformationInvoiceRecipientTest() {
        createData();


        
        Relationship__c relationship = new Relationship__c();
        Test.startTest();       
        createInvoiceData();
        relationship.Sales_Area__c =  [Select Sales_Area1__c from User Where id = :UserInfo.getUserId()].Sales_Area1__c;             
        relationship.Account__c = salesAreaInformationLst[0].Account__c;
        relationship.Related_Account__c = salesAreaInformationLst[1].Account__c;
        relationship.Relationship_Type__c = 'RE';
        Sales_Area_Information__c sai = [SELECT id, account__c From Sales_Area_Information__c Where Sales_Area__c =:salesArea and Account__r.RecordTypeId = :UTIL_META.getAccountWorkSiteRT() LIMIT 1];
        sai.type__c = 'Customer';
        update sai;
        // Testing when the M-D Accounts is an Invoice Recipient Account
        relationship = UTIL_TestFactory.createRelationship();
        relationship.Sales_Area__c = salesArea;
        relationship.Account__c = sai.account__c;
        relationship.Related_Account__c = salesAreaInformationLst[1].Account__c;
        try{
            insert relationship;
            system.assert(true);
        }
        catch(Exception e){
            system.assert(false, 'This was not expected to fail, ' + e);
        }
        Test.stopTest(); 
    }

    // Test that a relationship is allowed without salesarea on the related account if the Relationship_type__c is 'Customers customer'
    static testMethod void validateRelatedAccountOnTypeCustomersCustomerTest() {
        createData();
        Test.startTest();
        createInvoiceData();
        Relationship__c relationship = UTIL_TestFactory.createRelationship();
        relationship.Account__c = irAccounts[0].id;
        relationship.Related_Account__c = irAccounts[1].id;

         
        // Tests that even though the related account doesn't have a valid sales area it passes validation when type is Customers customer
        relationship = UTIL_TestFactory.createRelationship();
        relationship.Account__c = irAccounts[0].id;
        relationship.Related_Account__c = salesAreaInformationLst[1].Account__c;
        relationship.Relationship_Type__c = 'Customers customer';
        relationship.Sales_Area__c = '1000';
        try{
            insert relationship;
            system.assert(true);
        }
        catch(Exception e){
            system.assert(false, 'This was not expected to fail, ' + e);
        }

        Test.stopTest();
    }

    // Test that a relationship is allowed without salesarea on the related account if the Relationship_type__c is 'Customer by partner'
    static testMethod void validateRelatedAccountOnTypeCustomerByPartnerTest() {
        createData();

        Test.startTest();
        createInvoiceData();
        Relationship__c relationship = UTIL_TestFactory.createRelationship();
        relationship.Account__c = irAccounts[0].id;
        relationship.Related_Account__c = irAccounts[1].id;
        
        // Tests that even though the related account doesn't have a valid sales area it passes validation when type is Customer by partner
        relationship = UTIL_TestFactory.createRelationship();
        relationship.Account__c = irAccounts[0].id;
        relationship.Related_Account__c = salesAreaInformationLst[1].Account__c;
        relationship.Relationship_Type__c = 'Customer by partner';
        relationship.Sales_Area__c = '1000';
        try{
            insert relationship;
            system.assert(true);
        }
        catch(Exception e){
            system.assert(false, 'This was not expected to fail, ' + e);
        }

        Test.stopTest();
    }
    
    // Test that multiple payers with the same sales area on an account cannot be created
    static testMethod void validateOnlyOnePayerPerSalesAreaMultipleInsertFails() {
        
        //Arrange
        createData();

        Test.startTest();
        createInvoiceData();
        
        List<Relationship__c> relationshipList = new List<Relationship__c>();
        //Create 2 payers with the same sales area
        for (Integer i = 0; i < 2; i++) {
            Relationship__c relationship = UTIL_TestFactory.createRelationship();
            relationship.Account__c = salesAreaInformationLst[0].Account__c;
            relationship.Related_Account__c = irAccounts[i].id;
            relationship.Sales_Area__c = '1000';
            relationship.Distribution_Channel__c = '10';
            relationship.Division__c = '00';
            relationship.Relationship_Type__c = UTIL_OrgSettings.RelationshipTypePayer(); //RG = Payer
            relationshipList.add(relationship);
        }

        //Act & Assert
        try {
            insert relationshipList;
            System.assert(false, 'Insertion of multiple payers with the same Sales Area on the same account passed, it should not.');
        } catch(Exception e) {
            System.assert(e.getMessage().contains(Label.Only_One_Payer_Per_Sales_Area), 'Insertion of payers failed insertion due to an unexpected exception: ' + e.getMessage());
        }
    }
    
    // Test that multiple payers with the same sales area on an account cannot be created
    static testMethod void validateOnlyOnePayerPerSalesAreaSingleInsertFails() {
        
        //Arrange
        createData();

        Test.startTest();
        createInvoiceData();
        
        List<Relationship__c> relationshipList = new List<Relationship__c>();
        //Create 2 payers with the same sales area
        for (Integer i = 0; i < 2; i++) {
            Relationship__c relationship = UTIL_TestFactory.createRelationship();
            relationship.Account__c = salesAreaInformationLst[0].Account__c;
            relationship.Related_Account__c = irAccounts[i].id;
            relationship.Sales_Area__c = '1000';
            relationship.Distribution_Channel__c = '10';
            relationship.Division__c = '00';
            relationship.Relationship_Type__c = UTIL_OrgSettings.RelationshipTypePayer(); //RG = Payer
            relationshipList.add(relationship);
        }
        
        //Insert the first Payer
        insert relationshipList[0];

        //Act & Assert
        try {
            insert relationshipList[1];
            System.assert(false, 'Insertion of an payer on existing sales area passed, it should not.');
        } catch(Exception e) {
            System.assert(e.getMessage().contains(Label.Only_One_Payer_Per_Sales_Area), 'Insertion of payers failed insertion due to an unexpected exception: ' + e.getMessage());
        }
    }
    
    // Test that multiple payers with the different sales areas on an account can be created
    static testMethod void validateOnlyOnePayerPerSalesAreaPositiveTest() {
        
        //Arrange
        createData();

        Test.startTest();
        createInvoiceData();
        
        List<Relationship__c> relationshipList = new List<Relationship__c>();
        
        //Create 2 payers with the different sales area
        for (Integer i = 0; i < 2; i++) {
            Relationship__c relationship = UTIL_TestFactory.createRelationship();
            relationship.Account__c = salesAreaInformationLst[i].Account__c;
            relationship.Related_Account__c = irAccounts[i].id;
            relationship.Distribution_Channel__c = '10';
            relationship.Division__c = '00';
            relationship.Relationship_Type__c = UTIL_OrgSettings.RelationshipTypePayer(); //RG = Payer
            relationshipList.add(relationship);
        }
        
        relationshipList[0].Sales_Area__c = '1000';
        relationshipList[1].Sales_Area__c = salesArea;

        //Act
        insert relationshipList;

        System.assertEquals(2, [SELECT count() FROM Relationship__c Where Id IN: relationshipList], 'Both the payer relationships were not inserted.');
    }
                    
    static void createData() {

        UTIL_TestFactory.setUpOrg();
                    
        User u = UTIL_TestFactory.createUser('relationshipValidation@Test.User', 'Standard User');
        u.Sales_Area1__c = '1000';
        insert u;
        
        // Running as test user to avoid automatically created Sales Area Information to conflict with test data
        system.runAs(u){
            
            //Creating legal entity account as parent account
            account = UTIL_TestFactory.createAccount();
            account.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert account;
            
            list<Account> accountLst = new list<Account>();
            list<id> accountId = new list<id>();

            //Creating SalesAreaInformation which indirectly creates accounts
            salesAreaInformationLst.add(UTIL_TestFactory.createSalesAreaInformation());
            salesAreaInformationLst.add(UTIL_TestFactory.createSalesAreaInformation());
            salesAreaInformationLst.add(UTIL_TestFactory.createSalesAreaInformation());
            delete [select id from Sales_Area_Information__c];
            
            salesAreaInformationLst[0].Sales_Area__c = '1000';
            salesAreaInformationLst[1].Sales_Area__c = salesArea;
            salesAreaInformationLst[2].Sales_Area__c = '1000';

            insert salesAreaInformationLst;              
            accountLst = [SELECT id from Account where id != :account.id];
            
            for(Account acc : accountLst){
                acc.ParentId = account.Id;
                accountId.add(account.id);
            }
            
            update accountLst;
            salesAreaInformationLst[0].Type__c = 'Customer';
            salesAreaInformationLst[1].Type__c = 'Customer';
            salesAreaInformationLst[2].Type__c = 'Customer';
            
            update salesAreaInformationLst;
        }
    }

    static void createNonCustomerData() {

        UTIL_TestFactory.setUpOrg();
            
                
        User u = UTIL_TestFactory.createUser('relationshipValidation@Test.User', 'Standard User');
        u.Sales_Area1__c = '1000';
        insert u;
        
        // Running as test user to avoid automatically created Sales Area Information to conflict with test data
        // 
        system.runAs(u){
            
            //Creating legal entity account as parent account
            account = UTIL_TestFactory.createAccount();
            account.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert account;

            list<Account> accountLst = new list<Account>();
            list<id> accountId = new list<id>();
            
            //Creating SalesAreaInformation which indirectly creates accounts
            salesAreaInformationLst.add(UTIL_TestFactory.createSalesAreaInformation());
            salesAreaInformationLst.add(UTIL_TestFactory.createSalesAreaInformation());
            salesAreaInformationLst.add(UTIL_TestFactory.createSalesAreaInformation());
 
            delete [select id from Sales_Area_Information__c];            
            salesAreaInformationLst[0].Sales_Area__c = '1000';
            salesAreaInformationLst[1].Sales_Area__c = salesArea;
            salesAreaInformationLst[2].Sales_Area__c = '1000';

            insert salesAreaInformationLst;              
            accountLst = [SELECT id from Account where id != :account.id];
            
            for(Account acc : accountLst){
                acc.ParentId = account.Id;
                accountId.add(account.id);
            }
            update accountLst;            

            salesAreaInformationLst[0].Type__c = 'Customer';
            salesAreaInformationLst[1].Type__c = 'Customer';
            salesAreaInformationLst[2].Type__c = 'Prospect';
            
            update salesAreaInformationLst;          
        }
    }
        
    // For invoice Accounts SAI is not created.
    static void createInvoiceData() {

        String invoiceRecipientRT = UTIL_Meta.getAccountInvoiceRecipientRT();        
        
        list<id> accountId = new list<id>();
        irAccounts = new list<Account>();
        
        irAccounts.add(UTIL_TestFactory.createAccount());
        irAccounts.add(UTIL_TestFactory.createAccount());
        irAccounts.add(UTIL_TestFactory.createAccount());
                    
        irAccounts[0].recordTypeId = invoiceRecipientRT;
        irAccounts[1].recordTypeId = invoiceRecipientRT;
        irAccounts[2].recordTypeId = invoiceRecipientRT;
        
        insert irAccounts;
    }
}