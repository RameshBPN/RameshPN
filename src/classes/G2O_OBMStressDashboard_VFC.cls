/**
    About
    -----
    Description: This controller creates multiple accounts with connected objects to test that
    CINT is able to handle the amount of OBMs
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    createTestRecords() - will create the number of records that the user has entered
    deleteTestRecords() - will delete all the records that the test has created
    
    Update History
    --------------
    Created April 2013 - T.R.
    
    Issues / TODOs
    --------------

*/

public with sharing class G2O_OBMStressDashboard_VFC {
    
    //The captcha the user will enter
    public String userCaptcha { get; set; }
    
    //This value will default all the inputTexts
    public Integer defaultNrOfRecords = 0;
    
    //This value will default all the inputCheckboxes
    public boolean defaultCheckboxes = false;
    
    //The name that all the Accounts will get, this is used to identify all the records when the deletion is done
    public String accountName = 'OBM_Stress_Name';
    
    //The Suburb field value to identify all the OBM Stress Dashboard Accounts
    public String obmStressSuburb = 'OBM_STRESS_SUBURB_e8f3CrwU';
    
    //Get the running user
    User runningUser = [SELECT Id, Sales_Area1__c From User Where Id =: UserInfo.getUserId()];
    
    //All the fields that are shown on the visual force page
    public Integer nrOfLEs {
        get {
            if (nrOfLEs == null) {
                nrOfLEs = defaultNrOfRecords;
            }
            return nrOfLEs;
        }
        set;
    }
    
    public Integer nrOfWSs {
        get {
            if (nrOfWSs == null) {
                nrOfWSs = defaultNrOfRecords;
            }
            return nrOfWSs;
        }
        set;
    }
    
    public Integer nrOfExts {
        get {
            if (nrOfExts == null) {
                nrOfExts = defaultNrOfRecords;
            }
            return nrOfExts;
        }
        set;
    }
    
    public Integer nrOfPPs {
        get {
            if (nrOfPPs == null) {
                nrOfPPs = defaultNrOfRecords;
            }
            return nrOfPPs;
        }
        set;
    }
    
    public Integer nrOfContacts {
        get {
            if (nrOfContacts == null) {
                nrOfContacts = defaultNrOfRecords;
            }
            return nrOfContacts;
        }
        set;
    }
    
    public Integer nrOfIRs {
        get {
            if (nrOfIRs == null) {
                nrOfIRs = defaultNrOfRecords;
            }
            return nrOfIRs;
        }
        set;
    }
    
    public Integer nrOfBDs {
        get {
            if (nrOfBDs == null) {
                nrOfBDs = defaultNrOfRecords;
            }
            return nrOfBDs;
        }
        set;
    }
    
    public boolean addAdditionalSAIToLEs {
        get {
                if (addAdditionalSAIToLEs == null) {
                    addAdditionalSAIToLEs = defaultCheckboxes;
                }
            return addAdditionalSAIToLEs;
        }           
        set;
    }
    
    public boolean addAdditionalSAIToWSs {
        get {
                if (addAdditionalSAIToWSs == null) {
                    addAdditionalSAIToWSs = defaultCheckboxes;
                }
            return addAdditionalSAIToWSs;
        }
        set;
    }
    
    public boolean addCIToWSs {
        get {
                if (addCIToWSs == null) {
                    addCIToWSs = defaultCheckboxes;
                }
            return addCIToWSs;
        }       
        set;
    }
    
    public Integer nrOfLeOBMs {
        get {
            if (nrOfLEs > 0) {
                //Legal Entity + Sales Area Information
                return nrOfLEs * 2;
            } else {
                return 0;
            }
        }
        set;
    }
    
    public Integer nrOfAddedSAIsToLeOBMs {
        get {
            if (addAdditionalSAIToLEs == true) {
                return nrOfLEs;
            } else {
                return 0;
            }
        }
        set;
    }
    
    public Integer nrOfWsOBMs {
        get {
            if (nrOfWSs > 0) {
                //1 Legal Entity + nr of WSs
                return 2 + nrOfWSs * 2;
            } else {
                return 0;
            }
        }
        set;
    }
    
    public Integer nrOfExtOBMs {
        get {
            if (nrOfExts > 0) {
                //Extension + Sales Area Information * nr of Worksites
                return nrOfWSs * nrOfExts * 2;
            } else {
                return 0;
            }
        }
        set;
    }
    
    public Integer nrOfAddedSAIsToWsOBMs {
        get {
            if (addAdditionalSAIToWSs == true && nrOfWSs > 0) {
                return 1 + nrOfWSs;
            } else {
                return 0;
            }
        }
        set;
    }
      
    public Integer nrOfPpOBMs {
        get {
            return nrOfPPs * 2;
        }
        set;
    }
    
    public Integer nrOfContactOBMs {
        get {
            return nrOfContacts * 2 * nrOfWSs;
        }
        set;
    }
    
    public Integer nrOfIROBMs {
        get {
            if (nrOfWSs > 0) {
                return nrOfIRs + nrOfIRs * nrOfWSs;
            } else {
                return 0;
            }
        }
        set;
    }

    public Integer nrOfCIOBMs {
        get {
            if (addCIToWSs == true) {
                return nrOfWSs;
            } else {
                return 0;
            }
        }
        set;
    }
    
    public Integer nrOfBDOBMs {
        get {
            return nrOfBDs * nrOfWSs;
        }
        set;
    }
    
    public Integer totalNrOfOBMs {
        get {
            return nrOfLeOBMs + nrOfAddedSAIsToLeOBMs + nrOfWsOBMs + nrOfAddedSAIsToWsOBMs + 
            nrOfPpOBMs + nrOfContactOBMs + nrOfIROBMs + nrOfCIOBMs + nrOfBDOBMs + nrOfExtOBMs;
        }
        set;
    }
    
    public PageReference createTestRecords(){
        
        list<Sales_Area_Information__c> saiJoinedList = new list<Sales_Area_Information__c>();
        list<Account> accJoinedList = new list<Account>();
        list<Account> accountsLE;
        list<Account> accountsWS;
        list<Account> accountsExt;
        list<Account> IRs;
        
        if ((UTIL_Meta.isEnvironmentSandbox() || Test.isRunningTest()) && 
            userCaptcha == UTIL_OrgSettings.OBMStressDashboardCaptcha()) {
                
                if (nrOfLEs > 0) {
                    //Create Legal Entities
                    accountsLE = new List<Account>();
                    for (Integer i=0; i < nrOfLEs; i++) {
                        Account a = getNewAccount();
                        a.Name = AccountName + '_LE_' + String.valueOf(i+1);
                        a.Postal_Address_Suburb__c = obmStressSuburb;
                        a.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
                        accountsLE.add(a);
                        accJoinedList.add(a);
                    }
                }   
                if (nrOfWSs > 0) {
                    //Creating legal entity account as parent account for the WS Created
                    Account legalEntityAccount = getNewAccount();
                    legalEntityAccount.Name = AccountName + '_LE_FOR_WS';
                    legalEntityAccount.Postal_Address_Suburb__c = obmStressSuburb;
                    legalEntityAccount.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
                    insert legalEntityAccount;
            
                    //Create worksites
                    accountsWS = new List<Account>();
                    for (Integer i=0; i < nrOfWSs; i++) {
                        Account a = getNewAccount();
                        a.Name = AccountName + '_WS_' + String.valueOf(i+1);
                        a.Postal_Address_Suburb__c = obmStressSuburb;
                        a.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                        a.ParentId = legalEntityAccount.id;
                        accountsWS.add(a);
                        accJoinedList.add(a);                   
                    }
                    
                    //Create Invoice Recipients and Relationships
                    IRs = new List<Account>();
                    for (Integer i=0; i < nrOfIRs; i++) {
                        Account IR = getNewAccount();
                        IR.RecordTypeId = UTIL_Meta.getAccountInvoiceRecipientRT();
                        IR.Name = AccountName + '_IR_' + String.valueOf(i+1);
                        legalEntityAccount.Postal_Address_Suburb__c = obmStressSuburb;
                        IRs.add(IR);
                        accJoinedList.add(IR);
                    }
                }
                if (nrOfPPs > 0) {
                    List<Account> accountsPP = new List<Account>();
                    for (Integer i=0; i < nrOfPPs; i++) {
                        Account a = getNewAccount();
                        a.RecordTypeId = UTIL_Meta.getPersonAccountRT();
                        a.FirstName = accountName;
                        a.LastName = accountName + '_PP_' + String.valueOf(i+1);
                        a.Postal_Address_Suburb__c = obmStressSuburb;
                        accountsPP.add(a);
                        accJoinedList.add(a);
                    }
                }
                insert accJoinedList;

                if (nrOfLEs > 0) {          
                    //Create additional SAI for LE if requested
                    if (addAdditionalSAIToLEs == true) {
                        List<Sales_Area_Information__c> SAIsForLEs = new List<Sales_Area_Information__c>();
                        for (Integer i=0; i < accountsLE.size(); i++) {
                            Sales_Area_Information__c SAI = getNewSAI();
                            SAI.Account__c = accountsLE[i].Id;
                            saiJoinedList.add(SAI);
                        }
                    }     
                }
                
                if (nrOfWSs > 0) {              
                    //Make sure the SAI created to the WS is a Customer (so relationships can be added)
                    List<Sales_Area_Information__c> existingSAIs = [SELECT Id From Sales_Area_Information__c Where Account__r.Id IN: accountsWS];
                    for(Sales_Area_Information__c SAI: existingSAIs) {
                        SAI.Type__c = 'Customer';
                        saiJoinedList.add(SAI);
                    }
    
                    //Create Additional Sales Area Information
                    if (addAdditionalSAIToWSs == true) {
                        List<Sales_Area_Information__c> SAIsForWSs = new List<Sales_Area_Information__c>();
                        for (Integer i=0; i < accountsWS.size(); i++) {
                            Sales_Area_Information__c SAI = getNewSAI();
                            SAI.Account__c = accountsWS[i].Id;
                            saiJoinedList.add(SAI);
                        }
                    }
                }
                upsert saiJoinedList;
                
                //Create extensions after WS SAIs have been updated to Customers for validation rule
                if (nrOfExts > 0) {
                    accountsExt = new List<Account>();
                    for (Integer i=0; i < nrOfWSs; i++) {
                        for (Integer j=0; j < nrOfExts; j++) {
                            Account a = getNewAccount();
                            a.RecordTypeId = UTIL_Meta.getAccountExtensionRT();
                            a.Name = accountName;
                            a.Postal_Address_Suburb__c = obmStressSuburb;
                            a.ParentId = accountsWS[i].Id;
                            accountsExt.add(a);
                        }
                    }
                insert accountsExt;
                }
                
                if (nrOfWSs > 0) {
                    //Create contacts (and ACRTs)
                    List<Contact> contacts = new List<Contact>();
                    for (Integer i=0; i < nrOfContacts; i++) {
                        for (Integer j=0; j < nrOfWSs; j++) {
                            Contact c = getNewContact();
                            c.AccountId = accountsWS[j].Id;
                            contacts.add(c);
                        }
                    }
                    insert contacts;
                        
                    //Create Relationships
                    List<Relationship__c> relationships = new List<Relationship__c>();
                    for (Integer i=0; i < accountsWS.size(); i++) {
                        for (Integer j=0; j < nrOfIRs; j++) {
                            Relationship__c r = getNewRel();
                            r.Account__c = accountsWS[i].Id;
                            r.Related_Account__c = IRs[j].Id;
                            r.Sales_Area__c = runningUser.Sales_Area1__c;
                            r.Relationship_Type__c = 'RE';
                            relationships.add(r);
                        }
                    }
                    insert relationships;
                        
                    //Create Credit Informations
                    if (addCIToWSs == true) {
                        List<Credit_Information__c> CIs = new List<Credit_Information__c>();
                        for (Integer i=0; i < accountsWS.size(); i++) {
                            Credit_Information__c CI = getNewCI();
                            CI.Account__c = accountsWS[i].Id;
                            CIs.add(CI);
                        }
                        insert CIs;
                    }
        
                    //Create Bank Details
                    if (nrOfBDs > 0) {
                        List<Bank_Details__c> BDs = new List<Bank_Details__c>();
                        for (Integer i=0; i < accountsWS.size(); i++) {
                            for (Integer j=0; j < nrOfBDs; j++) {
                                Bank_Details__c BD = getNewBD();
                                BD.Account__c = accountsWS[i].Id;
                                BD.Bank_Account__c = '1231231' + String.valueOf(j);
                                BDs.add(BD);
                            }
                        }
                        insert BDs;
                    }
                }
                //Let the user know how many records have been created.
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'You have created ' + totalNrOfOBMs + ' records. Please remember to remove them.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are either in production environment or the text from the custom setting is not correct.'));
            }
        //Stay on the same page
        return null;
    }
    
    public PageReference setTopSegment () {
        if ((UTIL_Meta.isEnvironmentSandbox() || Test.isRunningTest()) && 
            userCaptcha == UTIL_OrgSettings.OBMStressDashboardCaptcha()) {
            //Get all the SAIs that are connected to the OBM Stress Dashboard accounts and set the Top Segment to Z01 - KA
            List<Sales_Area_Information__c> SAIsToUpdate = [SELECT Id FROM Sales_Area_Information__c Where Account__r.Postal_Address_Suburb__c =: obmStressSuburb];
            for (Sales_Area_Information__c SAI : SAIsToUpdate) {
                SAI.Top_Segment__c = 'Z01';
            }
            update SAIsToUpdate;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Top Segment updated on ' + SAIsToUpdate.size() + ' Sales Area Informations.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are either in production environment or the text from the custom setting is not correct.'));
            }
        return null;
    }
    
    public PageReference deleteTestRecords(){
        
        /**
            Deletes:
            Accounts
            Invoice Recipients
            Contacts
            ACRT
            Relationships
            SAIs
            CIs
            BDs
        */
        //This can not be run in production environment, the user has to enter the correct captcha to run this
        if ((UTIL_Meta.isEnvironmentSandbox() || Test.isRunningTest()) && 
            userCaptcha == UTIL_OrgSettings.OBMStressDashboardCaptcha()) {
        
            //This will remove all the records since the accounts is the same and all the other objects are child objects to the accounts
            //List<Account> accountsToDelete = [SELECT Id FROM Account Where Name =: AccountName OR LastName =: AccountName];
            List <Account> accountsToDelete = [SELECT Id FROM Account WHERE Postal_Address_Suburb__c =: obmStressSuburb];
            
            for (Account a: accountsToDelete) {
                a.Deletion_Flag__c = true;
            }
            update accountsToDelete;
            delete accountsToDelete;
            
            //Notify user that the records have been deleted
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All the records were deleted.'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are either in production environment or the text from the custom setting is not correct.'));
        }
        
        //Stay on the same page
        return null;    
    }
    
    /*******************************
            TEST CASE CREATOR 
    *******************************/
    
    //Message to show the user of the test case creation/deletion status
    public String testCaseMessage { get; set; }
    
    //The captcha the user will enter in the Test Case captcha textbox
    public String testCaseuserCaptcha { get; set; }
    
    public List<Account> resultAccounts {
        get {
            if (resultAccounts == null) {
                resultAccounts = new List<Account>();
            }
            return resultAccounts;
        }       
        set;
    }
        
    public List<TestCase> testCases {
        get {
            if (testCases == null) {
                testCases = new List<TestCase>();
                testCases.add(new TestCase('Test Case 1', '1 Legal Entity'));
                testCases.add(new TestCase('Test Case 2', '1 Legal Entity, 1 Work Site'));
                testCases.add(new TestCase('Test Case 3', '1 Legal Entity, 1 Work Site, 1 Extension'));
                testCases.add(new TestCase('Test Case 4', '1 Legal Entity, 1 Work Site, 2 Sales Areas, 1 Credit Informations, 2 Bank Details, 1 Relationship (Invoice Recipient) to Account (Invoice Recipient)'));
                testCases.add(new TestCase('Test Case 5', '1 Legal Entity, 1 Work Site, 2 Sales Areas, 1 Credit Informations, 2 Bank Details,' +
                                           ' 6 Relationship (2 IRs to Accounts (Invoice Recipient), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)'));
                testCases.add(new TestCase('Test Case 6', '1 Legal Entity, 1 Work Site, 2 Sales Areas, 1 Credit Informations, 2 Bank Details, 1 Relationship to Account (Work Site)'));
                testCases.add(new TestCase('Test Case 7', '1 Legal Entity, 1 Work Site, 2 Sales Areas, 1 Credit Informations, 2 Bank Details,' +
                                           ' 6 Relationship (2 IRs to Accounts (IR and Work Site), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)'));
                testCases.add(new TestCase('Test Case 8', '1 Legal Entity, 1 Work Site, 2 Sales Areas, 1 Credit Informations, 2 Bank Details,' +
                                           ' 6 Relationship (2 IRs to Accounts (Work Sites), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)'));
                testCases.add(new TestCase('Test Case 9', '1 B2B Webshop Placeholder'));
                testCases.add(new TestCase('Test Case 10', '1 B2C Webshop Placeholder'));
                testCases.add(new TestCase('Test Case 11', '1 Work Site, 1 Contact'));
                testCases.add(new TestCase('Test Case 12', '1 Work Site, 2 Contacts'));
                testCases.add(new TestCase('Test Case 13', '2 Work Site, 2 Contacts, 4 ACRs'));
                testCases.add(new TestCase('Test Case 14', '1 Legal Entity, 1 Work Site, 1 Relationship between Work Site and Legal Entity (Relationship between WS and LE through the Relationship object)'));
                testCases.add(new TestCase('Test Case 15', '1 Legal Entity, 1 Work Site, 1 Relationship between Work Site and Work Site (Circular case on the same WS)'));
            }
            return testCases;
        }
        set; 
    }

    public PageReference createTestCases() {

        //The maps that will hold the TestCase to accounts
        Map<Integer, Account> testCaseToLE = new Map<Integer, Account>();
        Map<Integer, Account> testCaseToWS = new Map<Integer, Account>();
        Map<Integer, List<Account>> testCaseToRelatedAccounts = new Map<Integer, List<Account>>();
        
        //This list of accounts will hold all Legal Entities
        List <Account> accountsLE = new List<Account>();
        
        //This list will hold all the accounts that will need to be customers
        List <Account> accountsWSCustomer = new List<Account>();
        
        //This list will hold all the accounts that are not needed to reference (Work Sites, Extension, B2B Webshop, B2C Webshop) (all Prospects)
        List <Account> accountsChildren = new List<Account>();
        
        //The list of accounts Related to the main Accounts
        List <Account> accountsRelatedAccounts = new List<Account>();
        
        //The running user is updated to get the correct Sales Area
        runningUser = [SELECT Id, Sales_Area1__c From User Where Id =: UserInfo.getUserId()];
        
        //This can not be run in production environment, the user has to enter the correct captcha to run this
        if ((UTIL_Meta.isEnvironmentSandbox() || Test.isRunningTest()) && 
            testCaseuserCaptcha == UTIL_OrgSettings.OBMStressDashboardCaptcha()) {
        
            resultAccounts = new List<Account>();
            
            /* Create all Legal Entity records */
            for (Integer i = 0; i < testCases.size(); i++) {
                if (testCases[i].selected == true) {
                    //Test Case 1-8, 14-15
                    if (i < 8 || i == 13 || i == 14) { 
                        Account LE = getNewAccount();
                        LE.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
                        LE.Name = 'TEST_CASE_' + String.valueOf(i+1) + '_LE';
                        resultAccounts.add(LE);
                        accountsLE.add(LE);
                        testCaseToLE.put(i, LE);
                    }
                }
            }
            insert accountsLE;

            /* Create all Work Site records */
            for (Integer i = 1; i < testCases.size(); i++) {
                if (testCases[i].selected == true) {
                    //Test Case 2-8
                    if (i < 8) {
                        Account WS = getNewAccount();
                        WS.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                        WS.Name = 'TEST_CASE_' + String.valueOf(i+1) + '_WS';
                        WS.ParentId = testCaseToLE.get(i).Id;
                        resultAccounts.add(WS);
                        accountsWSCustomer.add(WS);
                        testCaseToWS.put(i, WS);
                    }
                    //Test Case 11-12
                    if (i == 10 || i == 11) {
                        Account WS = getNewAccount();
                        WS.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                        WS.Name = 'TEST_CASE_' + String.valueOf(i+1) + '_WS';
                        resultAccounts.add(WS);
                        accountsChildren.add(WS);
                        testCaseToWS.put(i, WS);
                    }
                    //Test Case 13
                    if (i == 12) {
                        for (Integer j = 0; j < 2; j++) {
                            Account WS = getNewAccount();
                            WS.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                            WS.Name = 'TEST_CASE_' + String.valueOf(i+1) + '_WS' + String.valueOf(j+1);
                            resultAccounts.add(WS);
                            accountsChildren.add(WS);
                            //Since there will be 2 Worksites for Test Case 13 well put them in the TestCase to Account map as 121 and 122
                            testCaseToWS.put(i + 109 + j, WS);
                        }
                    }
                    //Test Case 14-15
                    if (i == 13 || i == 14) {
                        Account WS = getNewAccount();
                        WS.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                        WS.Name = 'TEST_CASE_' + String.valueOf(i+1) + '_WS';
                        WS.ParentId = testCaseToLE.get(i).Id;
                        resultAccounts.add(WS);
                        accountsWSCustomer.add(WS);
                        testCaseToWS.put(i, WS);
                    }
                }
            }
            
            /* Create all Related Account records */
            for (Integer i = 0; i < testCases.size(); i++) {
                if (testCases[i].selected == true) {
                    //Create a list of the related Accounts that will be held in a map to the test cases
                    List<Account> relatedAccountsForMap = new List<Account>();
                    
                    //Test Case 4 - 1 Invoice Recipient
                    if (i == 3) {
                        Account relatedAccount = getNewAccount();
                        relatedAccount.RecordTypeId = UTIL_Meta.getAccountInvoiceRecipientRT();
                        relatedAccount.Name = 'TEST_CASE_4_REL_IR';
                        accountsRelatedAccounts.add(relatedAccount);
                        resultAccounts.add(relatedAccount);
                        relatedAccountsForMap.add(relatedAccount);
                    } 
                    //Test Case 5 - 2 IRs to Accounts (Invoice Recipient), 2 Payers, 2 Customer by Partners
                    else if (i == 4) { 
                        for (Integer j = 0; j < 6; j++) {
                            Account relatedAccount = getNewAccount();
                            if (j < 2) { //Create 2 Invoice Recipient Relations
                                relatedAccount.RecordTypeId = UTIL_Meta.getAccountInvoiceRecipientRT();
                                relatedAccount.Name = 'TEST_CASE_5_REL_IR' + String.valueOf(j+1);
                            } else { //Create Worksites that will be used to connect Payers and Customer by Partners to
                                relatedAccount.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                                relatedAccount.Name = 'TEST_CASE_5_REL_WS' + String.valueOf(j-1);
                                relatedAccount.ParentId = testCaseToLE.get(i).Id;
                            }
                            resultAccounts.add(relatedAccount);
                            accountsRelatedAccounts.add(relatedAccount);
                            relatedAccountsForMap.add(relatedAccount);
                        }
                    }
                    //Test Case 6 - 1 Relationship to Account (Work Site)
                    else if (i == 5) {
                        Account relatedAccount = getNewAccount();
                        relatedAccount.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                        relatedAccount.Name = 'TEST_CASE_6_REL_WS';
                        relatedAccount.ParentId = testCaseToLE.get(i).Id;
                        resultAccounts.add(relatedAccount);
                        accountsRelatedAccounts.add(relatedAccount);
                        relatedAccountsForMap.add(relatedAccount);
                    }
                    //Test Case 7 - 6 Relationship (2 Invoice Recipients to Accounts (Invoice Recipient and Work Site), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)
                    else if (i == 6) { 
                        for (Integer j = 0; j < 6; j++) {
                            Account relatedAccount = getNewAccount();
                            if (j < 1) { //Create 1 Invoice Recipient Relationship
                                relatedAccount.RecordTypeId = UTIL_Meta.getAccountInvoiceRecipientRT();
                                relatedAccount.Name = 'TEST_CASE_7_REL_IR' + String.valueOf(j+1);
                            } else { //Create Worksites that will be used to connect to Invoice Recipient Account, Payers and Customer by Partners
                                relatedAccount.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                                relatedAccount.Name = 'TEST_CASE_7_REL_WS' + String.valueOf(j);
                                relatedAccount.ParentId = testCaseToLE.get(i).Id;
                            }
                            resultAccounts.add(relatedAccount);
                            accountsRelatedAccounts.add(relatedAccount);
                            relatedAccountsForMap.add(relatedAccount);
                        }
                    }
                    //Test Case 8 - 6 Relationship (2 Invoice Recipients to Accounts (Work Sites), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)
                    else if (i == 7) {
                        for (Integer j = 0; j < 6; j++) {
                            Account relatedAccount = getNewAccount();
                            relatedAccount.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                            relatedAccount.Name = 'TEST_CASE_8_REL_WS' + String.valueOf(j+1);
                            relatedAccount.ParentId = testCaseToLE.get(i).Id;
                            resultAccounts.add(relatedAccount);
                            accountsRelatedAccounts.add(relatedAccount);
                            relatedAccountsForMap.add(relatedAccount);
                        }
                    }
                    //Add the list of related accounts to the test case related accounts map
                    testCaseToRelatedAccounts.put(i, relatedAccountsForMap);
                }
            }
            
            List<Account> accountsToConvertToCustomer = new List<Account>();
            accountsToConvertToCustomer.addAll(accountsWSCustomer);
            accountsToConvertToCustomer.addAll(accountsRelatedAccounts);
            insert accountsToConvertToCustomer;
            
            /* Set the existing SAIs on the Worksites to Customer */
            List<Sales_Area_Information__c> existingSAIs = [SELECT Id, Sales_Area__c FROM Sales_Area_Information__c WHERE Account__c IN: accountsToConvertToCustomer];
            for (Sales_Area_Information__c SAI: existingSAIs) {
                SAI.Type__c = 'Customer';
            }
            update existingSAIs;
            
            /* Create all other account records, do this after the SAI on WS has been set to Custoemr to pass Extension validation rule */
            for (Integer i = 0; i < testCases.size(); i++) {
                if (testCases[i].selected == true) {
                    //Test Case 3 - Extension
                    if (i == 2) { 
                        Account extension = getNewAccount();
                        extension.RecordTypeId = UTIL_Meta.getAccountExtensionRT();
                        extension.Name = 'TEST_CASE_' + String.valueOf(i+1) + '_EXT';
                        extension.ParentId = testCaseToWS.get(i).Id;
                        resultAccounts.add(extension);
                        accountsChildren.add(extension);
                    }
                    //Test Case 9 - 1 B2B Webshop Placeholder
                    if (i == 8) { 
                        Account webshopB2B = getNewAccount();
                        webshopB2B.RecordTypeId = UTIL_Meta.getAccountB2BWebshopPlaceHolderRT();
                        webshopB2B.Name = 'TEST_CASE_9_B2B';
                        resultAccounts.add(webshopB2B);
                        accountsChildren.add(webshopB2B);
                    }
                    //Test Case 10 - 1 B2C Webshop Placeholder
                    if (i == 9) { 
                        Account webshopB2C = getNewAccount();
                        webshopB2C.RecordTypeId = UTIL_Meta.getAccountB2CWebshopPlaceHolderRT();
                        webshopB2C.LastName = 'TEST_CASE_10_B2C';
                        webshopB2C.FirstName = 'TEST_CASE_10_B2C';
                        resultAccounts.add(webshopB2C);
                        accountsChildren.add(webshopB2C);
                    }
                }
            }
            insert accountsChildren;
            
            /* Create an additional Sales Area Information on all the Work Sites */
            List<Sales_Area_Information__c> additionalSAIs = new List<Sales_Area_Information__c>();
            for (Integer i = 0; i < accountsToConvertToCustomer.size(); i++) {
                Sales_Area_Information__c SAI = getNewSAI();
                SAI.Account__c = accountsToConvertToCustomer[i].Id;
                SAI.Sales_Area__c = getAdditionalDKSAI();
                SAI.PostNord_Company_Name__c = getAdditionalDKSAI();
                additionalSAIs.add(SAI);
            }
            insert additionalSAIs;
            
            /* Create a Credit Information on all the Worksites */
            List<Credit_Information__c> additionalCIs = new List<Credit_Information__c>();
            for (Integer i = 0; i < accountsWSCustomer.size(); i++) {
                Credit_Information__c CI = getNewCI();
                CI.Account__c = accountsWSCustomer[i].Id;
                additionalCIs.add(CI);
            }
            insert additionalCIs;
            
            /* Create a Bank Detail on all the Worksites */
            List<Bank_Details__c> additionalBDs = new List<Bank_Details__c>();
            for (Integer i = 0; i < accountsWSCustomer.size(); i++) {
                Bank_Details__c BD = getNewBD();
                BD.Account__c = accountsWSCustomer[i].Id;
                additionalBDs.add(BD);
            }
            insert additionalBDs;
            
            /* Create Relationships */
            List<Relationship__c> relationships = new List<Relationship__c>();
            for (Integer i = 3; i < testCases.size(); i++) {
                if (testCases[i].selected == true) {
                    //Get the array of related Accounts to the specific test case
                    List<Account> relatedAccounts = testCaseToRelatedAccounts.get(i);
                    
                    //Test Case 4 - 1 Invoice Recipient
                    if (i == 3) {
                        Relationship__c rel = getNewRel();
                        rel.Relationship_Type__c = 'RE'; //Invoice Recipient
                        rel.Sales_Area__c = runningUser.Sales_Area1__c;
                        rel.Account__c = TestCaseToWS.get(i).Id;
                        rel.Related_Account__c = relatedAccounts[0].Id;
                        relationships.add(rel);
                    }
                    
                    //Test Case 5 - 6 Relationship (2 Invoice Recipients to Account (Invoice Recipient), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)
                    if (i == 4) {
                        for (Integer j = 0; j < relatedAccounts.size(); j++) {
                            Relationship__c rel = getNewRel();
                            rel.Account__c = TestCaseToWS.get(i).Id;
                            rel.Related_Account__c = relatedAccounts[j].Id;
                            
                            //Set the Sales Area, every second 1000 and 4000
                            if (Math.mod(j, 2) == 0) {
                                rel.Sales_Area__c = runningUser.Sales_Area1__c;
                            } else {
                                rel.Sales_Area__c = getAdditionalDKSAI();
                            }
                    
                            //Set the Relationship Type
                            if (j < 2) {
                                rel.Relationship_Type__c = 'RE'; //Invoice Recipient
                            } else if (j < 4) {
                                rel.Relationship_Type__c = 'RG'; //Payer
                            } else {
                                rel.Relationship_Type__c = 'Customer by Partner';
                            }
                            relationships.add(rel);
                        }
                    }
                    //Test Case 6 - 1 Relationship to Account (Work Site)
                    else if (i == 5) {
                        Relationship__c rel = getNewRel();
                        rel.Sales_Area__c = runningUser.Sales_Area1__c;
                        rel.Account__c = TestCaseToWS.get(i).Id;
                        rel.Related_Account__c = relatedAccounts[0].Id;
                        rel.Relationship_Type__c = 'RE'; //Invoice Recipient
                        relationships.add(rel);
                    }
                    //Test Case 7 - 6 Relationship (2 Invoice Recipients to Accounts (Invoice Recipient and Work Site), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)
                    else if (i == 6) { 
                        for (Integer j = 0; j < 6; j++) {
                            //Set Relationship Sales Areas
                            Relationship__c rel = getNewRel();
                            if (Math.mod(j, 2) == 0 || j < 2) { //Set IR relations to User Sales Area and Payer and Customer by Partner to every second
                                rel.Sales_Area__c = runningUser.Sales_Area1__c;
                            } else {
                                rel.Sales_Area__c = getAdditionalDKSAI();
                            }
                            
                            rel.Account__c = testCaseToWS.get(i).Id;
                            rel.Related_Account__c = relatedAccounts[j].Id;
                            if (j < 2) {
                                rel.Relationship_Type__c = 'RE'; //Invoice Recipient
                            } else if (j < 4) {
                                rel.Relationship_Type__c = 'RG'; //Payer
                            } else {
                                rel.Relationship_Type__c = 'Customer by Partner';
                            }
                            relationships.add(rel);
                        }
                    }
                    //Test Case 8 - 6 Relationship (2 Invoice Recipients to Accounts (Work Sites), 2 Payers, 2 Customer by Partners (SAI 1000 & 4000 for all relationship types)
                    else if (i == 7) { 
                        for (Integer j = 0; j < 6; j++) {
                            Relationship__c rel = getNewRel();
                            if (Math.mod(j, 2) == 0) { //Set every second Relationship Sales Area to 1000 and 4000
                                rel.Sales_Area__c = runningUser.Sales_Area1__c;
                            } else {
                                rel.Sales_Area__c = getAdditionalDKSAI();
                            }
                        
                            rel.Account__c = testCaseToWS.get(i).Id;
                            rel.Related_Account__c = relatedAccounts[j].Id;
                            if (j < 2) {
                                rel.Relationship_Type__c = 'RE'; //Invoice Recipient
                            } else if (j < 4) {
                                rel.Relationship_Type__c = 'RG'; //Payer
                            } else {
                                rel.Relationship_Type__c = 'Customer by Partner';
                            }
                            //Add the relationship to the list of relationships to be inserted
                            relationships.add(rel);
                        }
                    }
                    //Test Case 14 - 1 Relationship between Work Site and Legal Entity (Relationship between WS and LE through the Relationship object)
                    else if (i == 13) {
                        Relationship__c rel = getNewRel();
                        rel.Sales_Area__c = runningUser.Sales_Area1__c;
                        rel.Account__c = TestCaseToWS.get(i).Id;
                        rel.Related_Account__c = TestCaseToLE.get(i).Id;
                        rel.Relationship_Type__c = 'RE'; //Invoice Recipient
                        relationships.add(rel);
                    }
                    //Test Case 15 - 1 Relationship between Work Site and Work Site (Circular case on the same WS)
                    else if (i == 14) {
                        Relationship__c rel = getNewRel();
                        rel.Sales_Area__c = runningUser.Sales_Area1__c;
                        rel.Account__c = TestCaseToWS.get(i).Id;
                        rel.Related_Account__c = TestCaseToWS.get(i).Id;
                        rel.Relationship_Type__c = 'RE'; //Invoice Recipient
                        relationships.add(rel);
                    }
                }
            }
            insert relationships;
            
            /* Create all Contact records */
            List<Contact> contacts = new List<Contact>();
            for (Integer i = 0; i < testCases.size(); i++) {
                if (testCases[i].selected == true) {
                    //Test Case 11
                    if (i == 10) { 
                        Contact contact = getNewContact();
                        contact.FirstName = 'TEST_CASE_' + String.valueOf(i+1);
                        contact.LastName = 'TEST_CASE_' + String.valueOf(i+1) + '_CONTACT';
                        contact.AccountId = testCaseToWS.get(i).Id;
                        contacts.add(contact);
                    }
                    //Test Case 12
                    else if (i == 11) {
                        for (Integer j = 0; j < 2; j++) {
                            Contact contact = getNewContact();
                            contact.FirstName = 'TEST_CASE_' + String.valueOf(i+1);
                            contact.LastName = 'TEST_CASE_' + String.valueOf(i+1) + '_CONTACT' + String.valueOf(j+1);
                            contact.AccountId = testCaseToWS.get(i).Id;
                            contacts.add(contact);
                        }
                    }
                    //Test Case 13
                    else if (i == 12) {
                        for (Integer j = 0; j < 2; j++) {
                            Contact contact = getNewContact();
                            contact.FirstName = 'TEST_CASE_' + String.valueOf(i+1);
                            contact.LastName = 'TEST_CASE_' + String.valueOf(i+1) + '_CONTACT' + String.valueOf(j+1);
                            contact.AccountId = testCaseToWS.get(i + 109).Id;
                            contacts.add(contact);
                        }
                    }
                }
            }
            insert contacts;
            
            /* Create additional ACRs */
            List<Account_Contact_Role_Transaction__c> ACRs = new List<Account_Contact_Role_Transaction__c>();
            for (Integer i = 0; i < testCases.size(); i++) {
                if (testCases[i].selected == true) {
                    //Test Case 13
                    if (i == 12) {
                        for (Contact c : contacts) {
                            Account_Contact_Role_Transaction__c ACR = new Account_Contact_Role_Transaction__c();
                            ACR.Account__c = testCaseToWS.get(i + 110).Id;
                            ACR.Contact__c = c.Id;
                            ACRs.add(ACR);
                        }
                    }
                }
            }
            insert ACRs;
            
            //Sort the results list the is shown to the user
            resultAccounts.sort();
            
            //Remove the message shown to the user
            testCaseMessage = null;
            
        } else {
            testCaseMessage = 'You are either in production environment or the text from the custom setting is not correct.';
        }

        //Stay on the same page
        return null;
    }
    
    public PageReference deleteTestCases() {

    //This can not be run in production environment, the user has to enter the correct captcha to run this
        if ((UTIL_Meta.isEnvironmentSandbox() || Test.isRunningTest()) && 
        testCaseuserCaptcha == UTIL_OrgSettings.OBMStressDashboardCaptcha()) {
            List <Account> testCaseAccounts = [SELECT Id FROM Account WHERE Postal_Address_Suburb__c =: 'TEST_CASE_SUBURB'];
            
            for (Account a: testCaseAccounts) {
                a.Deletion_Flag__c = true;
            }
            update testCaseAccounts;
            
            testCaseMessage = 'You have deleted ' + testCaseAccounts.size() + ' accounts.';
            delete testCaseAccounts;
            resultAccounts.clear();
        } else {
            testCaseMessage = 'You are either in production environment or the text from the custom setting is not correct.';
        }
        
        //Stay on the same page
        return null;
    }
    
    /* Private Methods */
    
    //Create a new account
    private Account getNewAccount() {
        Account a = new Account();
        a.Registration_Country__c = 'DK';
        a.Language__c = 'da';
        a.Postal_Address_Suburb__c = 'TEST_CASE_SUBURB'; //This is used to identify all the test case records
        a.Postal_Address_City__c = 'Copenhagen';
        a.Postal_Address_Postal_Code__c = '1234';
        a.Postal_Address_Country__c = 'DK';
        a.Work_Site_Type__c = 'TY99';
        a.Type = 'Prospect';
        a.External_or_Internal__c = 'External';
        a.Verified__c = 'N';
        a.Extension_Type__c = 'Additional Order Number';
        return a;
    }
    
    //Create a new SAI with a DK SAI that the user does not have
    private Sales_Area_Information__c getNewSAI() {
        Sales_Area_Information__c SAI = new Sales_Area_Information__c();
        SAI.Sales_Area__c = getAdditionalDKSAI();
        SAI.Distribution_Channel__c = '10';
        SAI.Division__c = '00';
        SAI.Type__c = 'Customer';
        SAI.PostNord_Company_Name__c = getAdditionalDKSAI();
        SAI.VAT_Country__c = 'DK';
        return SAI;
    }
    
    //Return a SAI that is not set on the running User
    private String getAdditionalDKSAI() {
        if (runningUser.Sales_Area1__c == '1000') {
            return '4000';
        } else {
            return '1000';
        }
    }
    
    //Create a new CI
    private Credit_Information__c getNewCI() {
        Credit_Information__c CI = new Credit_Information__c();
        CI.Credit_Control_Area__c = '1000';
        return CI;
    }
    
    //Create a new Relationship
    private Relationship__c getNewRel() {
        Relationship__c rel = new Relationship__c();
        rel.Distribution_Channel__c = '10';
        rel.Division__c = '00';
        return rel;
    }
    
    //Create a new Bank Details
    private Bank_Details__c getNewBD() {
        Bank_Key__c bankKey = getNewBankKey();
        insert bankKey;
        Bank_Details__c BD = new Bank_Details__c();
        BD.Bank_Key__c = bankKey.Id;
        BD.Bank_Account__c = '1231231';
        BD.Bank_Country__c = bankKey.Country__c;
        return BD;
    }
    
    //Create a new Bank Key
    private Bank_Key__c getNewBankKey() {
        Bank_Key__c bankKey = new Bank_Key__c();
        bankKey.Name = '40';
        bankKey.Bank_City__c = '4760 VORDINGBORG';
        bankKey.Bank_Street__c = 'ALGADE 78, POSTBOX 111';
        bankKey.Country__c = 'DK';
        bankKey.Bank_Name__c = 'NORDEA BANK DANMARK A/S';
        return bankKey;
    }
    
    //Create a new Contact
    private Contact getNewContact() {
        Contact c = new Contact();
        c.FirstName = AccountName;
        c.LastName = AccountName;
        c.Contact_Person_Type__c = 'Postnord Created';
        c.Verified__c = 'N';
        c.Language__c = 'da';
        return c;
    }
    
    /* Wrapper Classes */
    
    //Wrapper class for a Test Case
    public class testCase {
        public Boolean selected { get; set; }
        public String name { get; set; }
        public String description { get; set; }
        
        //Constructor
        public testCase(String n, String d) {
            name = n;
            description = d;
            selected = false;
        }
    }
}