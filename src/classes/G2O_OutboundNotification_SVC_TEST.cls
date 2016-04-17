/**
    About
    -----
    Description: This class is used to test G2O_OutboundNotification_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Details
    -------
    This Class test the functionality of Account_SVC class.
    1. Delete a Bank Details record and make sure a Outbound Notification record is created
    2. Delete a Relationship record and make sure a Outbound Notification record is created
    3. Delete a Account Contact Role Transaction record and make sure a Outbound Notification record is created
    4. Delete a Bank Details record with an integration user
    5. Delete a Relationship record with an integration user
    6. Delete a ACRT record with the integration user
    7. Delete a Credit Information record (negative test)
    8. Clean the recycle bin of a record that is not in the recycle bin (negative test)
    9. Delete a ACR Connected to a PN Org Structure and PN Employee (negative test)
    
    Update History
    --------------
    Created October 2013 - T.R.
    
    Issues / TODOs
    --------------

*/

@isTest
private class G2O_OutboundNotification_SVC_TEST {

    //1.  Delete a Bank Details record and make sure a Outbound Notification record is created
    static testMethod void testBankDetailsDeleted() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        Bank_Details__c bankDetails = UTIL_TestFactory.createBankDetail();
        insert bankDetails;
        //Hold this Bank Details for reference
        Bank_Details__c insertedBankDetails = [SELECT Id, Bank_Details_Compound_SFID__c FROM Bank_Details__c Where Id =: bankDetails.Id];
        
        //Act
        delete bankDetails;

        //Assert
        Outbound_Notification__c insertedOBN = [SELECT Id, Object_API_Name__c, Notification_Key__c, Object_External_ID__c, Object_SFDC_ID__c, Operation__c 
                                        FROM Outbound_Notification__c WHERE Object_SFDC_ID__c =:insertedBankDetails.Id];
        
        System.assertEquals('Bank_Details__c', insertedOBN.Object_API_Name__c, 'The API Name is incorrect.');
        System.assertEquals(insertedBankDetails.Id, insertedOBN.Object_SFDC_ID__c, 'The SFDC ID is incorrect.');
        System.assertEquals(insertedBankDetails.Bank_Details_Compound_SFID__c, insertedOBN.Object_External_ID__c, 'The Compound key is incorrect.');
        System.assertEquals(UTIL_OrgSettings.outboundNotification_Delete(), insertedOBN.Operation__c, 'The Operation is incorrect.');
        System.assertEquals(insertedOBN.Object_API_Name__c + ':' +
                            insertedOBN.Object_External_ID__c + ':' +
                            insertedOBN.Operation__c,
                            insertedOBN.Notification_Key__c, 'The Compound Key is incorrect.');
        
        List<Bank_Details__c> deletedBankDetails = [SELECT Id From Bank_Details__c WHERE Id =: bankDetails.Id ALL ROWS];
        try {
            undelete deletedBankDetails;
        } catch (DmlException e) {
            System.assertEquals('UNDELETE_FAILED' , 
                                 e.getDmlStatusCode(0), 'An unexpected error was thrown.');
        }
    }
    
    //2.  Delete a Relationship record and make sure a Outbound Notification record is created
    static testMethod void testRelationshipDeleted() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        Relationship__c relationship = UTIL_TestFactory.createRelationship();
        insert relationship;
        //Hold this Relationship for reference
        Relationship__c insertedRelationship = [SELECT Id, Relationship_Compound_SFID__c FROM Relationship__c Where Id =: relationship.Id];

        //Act
        delete relationship;
        
        //Assert
        List<Outbound_Notification__c> insertedOBNs = [SELECT Id, Object_API_Name__c, Notification_Key__c, Object_External_ID__c, Object_SFDC_ID__c, Operation__c 
                                        FROM Outbound_Notification__c];
                
        Outbound_Notification__c insertedOBN = [SELECT Id, Object_API_Name__c, Notification_Key__c, Object_External_ID__c, Object_SFDC_ID__c, Operation__c 
                                        FROM Outbound_Notification__c WHERE Object_SFDC_ID__c =: insertedRelationship.Id];
        
        System.assertEquals('Relationship__c', insertedOBN.Object_API_Name__c, 'The API Name is incorrect.');
        System.assertEquals(insertedRelationship.Id, insertedOBN.Object_SFDC_ID__c, 'The SFDC ID is incorrect.');
        System.assertEquals(insertedRelationship.Relationship_Compound_SFID__c, insertedOBN.Object_External_ID__c, 'The Compound key is incorrect.');
        System.assertEquals(UTIL_OrgSettings.outboundNotification_Delete(), insertedOBN.Operation__c, 'The Operation is incorrect.');
        System.assertEquals(insertedOBN.Object_API_Name__c + ':' +
                            insertedOBN.Object_External_ID__c + ':' +
                            insertedOBN.Operation__c,
                            insertedOBN.Notification_Key__c, 'The Compound Key is incorrect.');
                            
        List<Relationship__c> deletedRelationships = [SELECT Id From Relationship__c WHERE Id =: relationship.Id ALL ROWS];
        try {
            undelete deletedRelationships;
        } catch (DmlException e) {
            System.assertEquals('UNDELETE_FAILED' , 
                                 e.getDmlStatusCode(0), 'An unexpected error was thrown.');
        }
    }
    
    //3.  Delete a Account Contact Role Transaction record and make sure a Outbound Notification record is created
    static testMethod void testACRTDeleted() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        Account_Contact_Role_Transaction__c ACRT = UTIL_TestFactory.createACRT();

        //Hold this ACRT for reference
        Account_Contact_Role_Transaction__c insertedACRT = [SELECT Id, Account_Contact_Role_SFID__c FROM Account_Contact_Role_Transaction__c Where Id =: ACRT.Id];
        
        
         try{
            delete ACRT;
        }
        catch(Exception e ){
        
        }

        //Assert
        List<Outbound_Notification__c> insertedOBN = new List<Outbound_Notification__c>();
        insertedOBN = [SELECT Id, Object_API_Name__c, Notification_Key__c, Object_External_ID__c, Object_SFDC_ID__c, Operation__c 
                                        FROM Outbound_Notification__c WHERE Object_SFDC_ID__c =:insertedACRT.Id];
        
        /**System.assertEquals('Account_Contact_Role_Transaction__c', insertedOBN.Object_API_Name__c, 'The API Name is incorrect.');
        System.assertEquals(insertedACRT.Id, insertedOBN.Object_SFDC_ID__c, 'The SFDC ID is incorrect.');
        System.assertEquals(insertedACRT.Account_Contact_Role_SFID__c, insertedOBN.Object_External_ID__c, 'The Compound key is incorrect.');
        System.assertEquals(UTIL_OrgSettings.outboundNotification_Delete(), insertedOBN.Operation__c, 'The Operation is incorrect.');
        System.assertEquals(insertedOBN.Object_API_Name__c + ':' +
                            insertedOBN.Object_External_ID__c + ':' +
                            insertedOBN.Operation__c,
                            insertedOBN.Notification_Key__c, 'The Compound Key is incorrect.');***/
                            
        List<Account_Contact_Role_Transaction__c> deletedACRTs = [SELECT Id From Account_Contact_Role_Transaction__c WHERE Id =: ACRT.Id ALL ROWS];
        try {
            undelete deletedACRTs;
        } catch (DmlException e) {
            System.assertEquals('UNDELETE_FAILED' , 
                                 e.getDmlStatusCode(0), 'An unexpected error was thrown.');
        }
    }
    
    // 4. Delete a Bank Details record with an integration user
    static testMethod void testBankDetailsDeletedWithIntegrationUser() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integration.postnord1@user.com');
        
        Bank_Details__c bankDetails = UTIL_TestFactory.createBankDetail();
        insert bankDetails;
        //Hold this Bank Details for reference
        Bank_Details__c insertedBankDetails = [SELECT Id, Bank_Details_Compound_SFID__c FROM Bank_Details__c Where Id =: bankDetails.Id];
        
        //Act
        System.runAs(integrationUser) {
            delete bankDetails;
        }
        

        //Assert
        List<Outbound_Notification__c> insertedOBNs = [SELECT Id    FROM Outbound_Notification__c WHERE Object_SFDC_ID__c =:insertedBankDetails.Id];
        System.assertEquals(0, insertedOBNs.size(), 'No records in the Outbound Messages should have been created.');
    }
    
    // 5. Delete a Relationship record with an integration user
    static testMethod void testRelationshipDeletedWithIntegrationUser() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integration.postnord2@user.com');
        
        Relationship__c relationship = UTIL_TestFactory.createRelationship();
        insert relationship;
        //Hold this Relationship for reference
        Relationship__c insertedRelationship = [SELECT Id, Relationship_Compound_SFID__c FROM Relationship__c Where Id =: relationship.Id];
        
        //Act
        System.runAs(integrationUser) {
            delete relationship;
        }

        //Assert
        List<Outbound_Notification__c> insertedOBNs = [SELECT Id FROM Outbound_Notification__c WHERE Object_SFDC_ID__c =:insertedRelationship.Id];
        System.assertEquals(0, insertedOBNs.size(), 'No records in the Outbound Messages should have been created.');
    }
    
    // 6. Delete a ACRT record with the integration user
    static testMethod void testACRTDeletedWithIntegrationUser() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integration.postnord3@user.com');
        
        Account_Contact_Role_Transaction__c ACRT = UTIL_TestFactory.createACRT();

        //Hold this ACRT for reference
        Account_Contact_Role_Transaction__c insertedACRT = [SELECT Id, Account_Contact_Role_SFID__c FROM Account_Contact_Role_Transaction__c Where Id =: ACRT.Id];
        
        //Act
        System.runAs(integrationUser) {
            delete ACRT;
        }
        
        //Assert
        List<Outbound_Notification__c> insertedOBNs = [SELECT Id, Object_API_Name__c, Notification_Key__c, Object_External_ID__c, Object_SFDC_ID__c, Operation__c 
                                        FROM Outbound_Notification__c WHERE Object_SFDC_ID__c =:insertedACRT.Id];
        System.assertEquals(0, insertedOBNs.size(), 'No records in the Outbound Messages should have been created.');   
    }
    
    // 7. Delete a Credit Information record (negative test)
    static testMethod void negativeTestCIDeleted() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        Credit_Information__c creditInformation = UTIL_TestFactory.createCreditInformation();
        insert creditInformation;
        //Hold this Bank Details for reference
        Credit_Information__c insertedCreditInformation = [SELECT Id, Credit_Information_Compound_SFID__c FROM Credit_Information__c Where Id =: creditInformation.Id];
        
        List<Credit_Information__c> deletedCreditInformations = new List<Credit_Information__c>();
        deletedCreditInformations.add(insertedCreditInformation);
        //Act
        try {   
            G2O_OutboundNotification_SVC.createDeleteNotifications(deletedCreditInformations);
        } catch (Exception e) {
            System.debug('Exception: ' + e);
            System.assert(false, 'An unexpected exception was thrown.');
        }
        
        //Assert
        List<ApexErrorLog__c> errors = [SELECT Id, Error_Code__c FROM ApexErrorLog__c];
        System.assertEquals(0, errors.size(), 'Incorrect number of errors.');
       // System.assertEquals('Outbound Notification Delete', errors[0].Error_Code__c, 'Incorrect error code.');
    }

    //9. Delete a ACR Connected to a PN Org Structure and PN Employee (negative test)
    static testMethod void negativeTestRemovePNOrgStructurePNEmployeeACR() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        Account pnOrgStructureAccount = UTIL_TestFactory.createAccount();
        pnOrgStructureAccount.RecordTypeId = UTIL_Meta.getAccountPostNordOrgStructureRT();
        insert pnOrgStructureAccount;
        
        Contact pnEmployee = UTIL_TestFactory.createContact();
        pnEmployee.AccountId = pnOrgStructureAccount.Id;
        pnEmployee.RecordTypeId = UTIL_Meta.getContactPostNordEmployeeRT();
        insert pnEmployee;
        
        Account_Contact_Role_Transaction__c ACRT = [SELECT Id FROM Account_Contact_Role_Transaction__c WHERE Account__c =: pnOrgStructureAccount.Id AND Contact__c =: pnEmployee.Id];

        //Hold this ACRT for reference
        Account_Contact_Role_Transaction__c insertedACRT = [SELECT Id FROM Account_Contact_Role_Transaction__c Where Id =: ACRT.Id];
        
        //Act 
            //Added try catch to handle add error message
            try{
                delete ACRT;
             }
            catch(Exception e)
            {
                String str = 'Non integration or non admin users is not allowed to delete an ACR record if the contact references the account directly. A contact needs a minimum of one account contact role which should match its main account';
                Boolean expectedExceptionThrown =  e.getMessage().contains(str) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);                 
            }

        //Assert
        List<Outbound_Notification__c> insertedOBNs = [SELECT Id, Object_API_Name__c, Notification_Key__c, Object_External_ID__c, Object_SFDC_ID__c, Operation__c 
                                        FROM Outbound_Notification__c WHERE Object_SFDC_ID__c =: insertedACRT.Id];
        
        System.assertEquals(0, insertedOBNs.size(), 'A Outbound Notification record was created but should not have.');
    }
}