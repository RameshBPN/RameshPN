/**
    About
    -----
    Description: This class is used to test OBMStressTest_VFC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details
    -------
    This Class test the functionality of OBMStressTest_VFC class.
    
    1. createRecordsForOBM - This method will create a number of records
    2. removeRecordsForOBM - This method will remove the records that has been created by the test
                             To find the records to remove there is a specific Postal Address Suburb that the records get set
    3. setTopSegmentOnRecordsForOBM - Set Top Segment on all OBM Stress Dashboard SAI records
    4. createAllTestCases - This method will create all the test cases
    5. removeAllTestCaseRecords - This method will remove all the test case records
    
    Update History
    --------------
    Created May 2013 - T.R.
    
    Issues / TODOs
    --------------
    
*/

@isTest

private class G2O_OBMStressDashboard_VFC_TEST {

    static final String salesArea = '0540';//Sales area for testing
    
    static testMethod void createRecordsForOBM() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        user runAsUser = UTIL_TestFactory.createUser('OBMStressDashboard@test.user', 'system administrator');
        runAsUser.Sales_Area1__c = salesArea;
        insert runAsUser;
        system.runAs(runAsUser){
            G2O_OBMStressDashboard_VFC stressTest = new G2O_OBMStressDashboard_VFC();
            Integer nrOfRecordsToCreate = 5;
            
            //Set the number of records to create
            stressTest.defaultNrOfRecords = nrOfRecordsToCreate;
            stressTest.defaultCheckboxes = true;
            stressTest.userCaptcha = UTIL_OrgSettings.OBMStressDashboardCaptcha();
            
            //Act
            //Create records (run create method in VFC)
            test.startTest();
            stressTest.createTestRecords();
            test.stopTest();
            //Assert
            List<Account> accountsCreated = [SELECT Id, Name FROM Account WHERE Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Contact> contactsCreated = [SELECT Id, Name FROM Contact WHERE Account.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Account_Contact_Role_Transaction__c> ACRTsCreated = [SELECT Id, Name FROM Account_Contact_Role_Transaction__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Relationship__c> RelationshipsCreated = [SELECT Id, Name FROM Relationship__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Sales_Area_Information__c> SAIsCreated = [SELECT Id, Name FROM Sales_Area_Information__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Credit_Information__c> CIsCreated = [SELECT Id, Name FROM Credit_Information__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Bank_Details__c> BDsCreated = [SELECT Id, Name FROM Bank_Details__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            
            Integer totalNrOfRecords = accountsCreated.size() +
                                        contactsCreated.size() + 
                                        ACRTsCreated.size() +
                                        RelationshipsCreated.size() +
                                        SAIsCreated.size() +
                                        CIsCreated.size() +
                                        BDsCreated.size();
    
            //Make sure we have the correct number of records created
            System.assertEquals(totalNrOfRecords,
                                nrOfRecordsToCreate + 1 + nrOfRecordsToCreate + nrOfRecordsToCreate + nrOfRecordsToCreate + nrOfRecordsToCreate * nrOfRecordsToCreate   //Accounts ()#LE + 1 LE + #WS + #IR + #PP + #Ext)
                                + nrOfRecordsToCreate * nrOfRecordsToCreate //Contacts
                                + nrOfRecordsToCreate * nrOfRecordsToCreate //ACRT
                                + nrOfRecordsToCreate * nrOfRecordsToCreate //Relationship
                                + nrOfRecordsToCreate * 2 + 1 * 2 + nrOfRecordsToCreate * 2 + nrOfRecordsToCreate + nrOfRecordsToCreate * nrOfRecordsToCreate //SAIs (#LE + 1 LE + #WS + #PP + #Ext)
                                + nrOfRecordsToCreate   //Credit Information
                                + nrOfRecordsToCreate * nrOfRecordsToCreate);   //Bank Details
        }
    }

    static testMethod void removeRecordsForOBM() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User runAsUser = UTIL_TestFactory.createUser('OBMStressDashboard@test.user', 'System Administrator');
        runAsUser.Sales_Area1__c = salesArea;
        insert runAsUser;
        system.runAs(runAsUser){
            G2O_OBMStressDashboard_VFC stressTest = new G2O_OBMStressDashboard_VFC();
            Integer nrOfRecordsToCreate = 10;
            
            //Set the number of records to create
            stressTest.defaultNrOfRecords = nrOfRecordsToCreate;
            stressTest.defaultCheckboxes = true;
            stressTest.userCaptcha = UTIL_OrgSettings.OBMStressDashboardCaptcha();
            
            stressTest.createTestRecords();
            //Act
            //Create records (run create method in VFC)
            test.startTest();
            stressTest.deleteTestRecords();
            test.stopTest();

            //Assert
            List<Account> accountsCreated = [SELECT Id, Name FROM Account WHERE Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Contact> contactsCreated = [SELECT Id, Name FROM Contact WHERE Account.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Account_Contact_Role_Transaction__c> ACRTsCreated = [SELECT Id, Name FROM Account_Contact_Role_Transaction__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Relationship__c> RelationshipsCreated = [SELECT Id, Name FROM Relationship__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Sales_Area_Information__c> SAIsCreated = [SELECT Id, Name FROM Sales_Area_Information__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Credit_Information__c> CIsCreated = [SELECT Id, Name FROM Credit_Information__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
            List<Bank_Details__c> BDsCreated = [SELECT Id, Name FROM Bank_Details__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb];
                
            Integer totalNrOfRecords = accountsCreated.size() +
                                        contactsCreated.size() + 
                                        ACRTsCreated.size() +
                                        RelationshipsCreated.size() +
                                        SAIsCreated.size() +
                                        CIsCreated.size() +
                                        BDsCreated.size();
    
            //Make sure all the records that has been created have been removed
            System.assertEquals(0, totalNrOfRecords);
        }
    }
    
    static testMethod void setTopSegmentOnRecordsForOBM() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        User runAsUser = UTIL_TestFactory.createUser('OBMStressDashboard@test.user', 'System Administrator');
        runAsUser.Sales_Area1__c = salesArea;
        insert runAsUser;
        system.runAs(runAsUser){
            G2O_OBMStressDashboard_VFC stressTest = new G2O_OBMStressDashboard_VFC();
            Integer nrOfRecordsToCreate = 10;
            
            //Set the number of records to create
            stressTest.defaultNrOfRecords = nrOfRecordsToCreate;
            stressTest.defaultCheckboxes = true;
            stressTest.userCaptcha = UTIL_OrgSettings.OBMStressDashboardCaptcha();
            
            stressTest.createTestRecords();
            //Act
            //Create records (run create method in VFC)
            test.startTest();
            stressTest.setTopSegment();
            test.stopTest();

            //Assert
            List<Sales_Area_Information__c> SAIsCreated = [SELECT Id, Top_Segment__c FROM Sales_Area_Information__c WHERE Account__r.Postal_Address_Suburb__c =: stressTest.obmStressSuburb OR Account__r.Postal_Address_Suburb__c =:stressTest.obmStressSuburb];
    
            //Make sure all the top segments has been set
            for (Sales_Area_Information__c SAI : SAIsCreated) {
                System.assertEquals('Z01', SAI.Top_Segment__c, 'The Top Segment is not correctly set.');
            }
        }
    }

    static testMethod void createAllTestCases() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        //Create the test cases and select all of them to be created
        G2O_OBMStressDashboard_VFC stressTest = new G2O_OBMStressDashboard_VFC();
        stressTest.testCaseuserCaptcha = UTIL_OrgSettings.OBMStressDashboardCaptcha();
        for (Integer i = 0; i < stressTest.testCases.size(); i++) {
            stressTest.testCases[i].selected = true;
        }

        //Create test case records
        user runAsUser = UTIL_TestFactory.createUser('OBMStressDashboard@test.user', 'System Administrator');
        runAsUser.Sales_Area1__c = salesArea;
        insert runAsUser;
        
        //Act
        system.runAs(runAsUser){
            test.startTest();
            stressTest.createTestCases();
            test.stopTest();
        }
        
        //Assert
        List<Account> accountsCreated = [SELECT Id FROM Account WHERE Postal_Address_Suburb__c = 'TEST_CASE_SUBURB'];

        //Make sure accounts has been created and that accounts has been created and are shown on the page layout
        System.assertNotEquals(0, stressTest.resultAccounts.size(), 'No accounts were created');
        System.assertEquals(stressTest.resultAccounts.size(), accountsCreated.size(), 'All the created accounts are not shown');                     
    }
    
    static testMethod void removeAllTestCases() {
        //Arrange
        UTIL_TestFactory.setUpOrg();
        //Create the test cases and select all of them to be created
        G2O_OBMStressDashboard_VFC stressTest = new G2O_OBMStressDashboard_VFC();
        stressTest.testCaseuserCaptcha = UTIL_OrgSettings.OBMStressDashboardCaptcha();
        for (Integer i = 0; i < stressTest.testCases.size(); i++) {
            stressTest.testCases[i].selected = true;
        }
        
        User runAsUser = UTIL_TestFactory.createUser('OBMStressDashboard@test.user', 'System Administrator');
        runAsUser.Sales_Area1__c = salesArea;
        insert runAsUser;

        //Act
        system.runAs(runAsUser){
            //Create test case records
            test.startTest();
            stressTest.createTestCases();
            test.stopTest();
            
            stressTest.deleteTestCases();
        }
        
        //Assert
        List<Account> accountsCreated = [SELECT Id FROM Account WHERE Postal_Address_Suburb__c = 'TEST_CASE_SUBURB'];
        
        //Make sure all the accounts that has been created are shown on the page layout
        System.assertEquals(0, accountsCreated.size(), 'There are still Test Case Accounts remaining after the delete.');                     
    }
}