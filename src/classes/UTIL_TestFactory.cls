/**
    About
    -----
    Description: This class is used to create test data in objects
    Created for: ...
    Create date: ...
    
    Details
    -------
    Helper class used to create test data for objects used in test classes
    Pattern is to generate objects in memory. Inserting should be done by the calling class or when a method creates an object that requires child objects to exist joined by ID
    
    Update History
    --------------
    //Updated the Test case at line 870 to add the mandatory custom setting value 'Customer Responsible Role' to fix the Test case failures.
    Issues / TODOs
    --------------
       
*/

@isTest
public class UTIL_TestFactory {
    
    static Integer globalId = 1000000;
    
    static boolean setUpOrg_done = false;
    
    public static void setUpOrg()
    {
        if (!setUpOrg_done)
        {
            // Put in to this method all those standard items that would normally be loaded by default, ex custom settings
            createGet2OneCrm(); // load in the custom settings as standard
            createLeadSalesArea();
            createHttpIntegrationServices();
            createScheduledJobParameters();
            createCINTSOAPIntegrationSettings();
            createSalesAreaToFieldMapping();
            createSalesAreaToSegmentMapping();
        }
        setUpOrg_done = true;
    }
    
    public static User createUser(String uName, String profileName)
    {
        setUpOrg();
        User u = new User(
            username= uName,
            email ='test123456789QW@test.com',
            localeSidKey = 'en_US',
            languageLocaleKey = 'en_US',
            profileId=Util_Meta.profileId(profileName),
            lastname='test',
            TimeZoneSidKey='GMT',
            EmailEncodingKey='UTF-8',
            alias='ttk',
            Sales_Area1__c='1000');
        return u;
    }
 
    // Fetch role id
    public static UserRole getRoleId_HighestDanishSalesRole()
    {
        String HighestDanishSalesRoleName = 'PN DK Sales and Marketing';
        return [select id from UserRole where Name = :HighestDanishSalesRoleName limit 1];
    }
    
    
    // create account
    public static Account createAccount()
    {   
        Account a = new Account();
        a.recordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        a.BillingCountry                    = 'Netherlands';
        a.Name                              = 'NOW ' + String.valueOf(System.now());
        a.Corporate_Registration_Number__c  = '34943400';
        a.Visiting_Address_Street__c        = '98989';
        a.Visiting_Address_Country__c       = 'DK';
        a.Visiting_Address_Postal_Code__c   = '2100';
        a.Visiting_Address_City__c          = 'Test City';
        a.Postal_Address_Street__c          = '7';
        a.Postal_Address_Country__c         = 'DK';
        a.Postal_Address_Postal_Code__c     = '2100';
        a.Postal_Address_City__c            = 'Test City';
        a.EAN_Location_Number_1__c          = '123';
        a.EAN_Location_Number_2__c          = '456';        
        a.Language__c                       = 'DK';
        a.Registration_Country__c           = 'DK';
        return a;
    }
    
    public static Account createPersonAccount()
    {
        Account a = new Account();
        a.recordTypeId = UTIL_Meta.getPersonAccountRT();
        a.FirstName = 'Test';
        a.LastName = 'Testersson';
        a.BillingCountry                    = 'Netherlands';
        a.Visiting_Address_Street__c        = '98989';
        a.Visiting_Address_Country__c       = 'DK';
        a.Visiting_Address_Postal_Code__c   = '2100';
        a.Visiting_Address_City__c          = 'Test City';
        a.Postal_Address_Street__c          = '7';
        a.Postal_Address_Country__c         = 'DK';
        a.Postal_Address_Postal_Code__c     = '2100';
        a.Postal_Address_City__c            = 'Test City';
        a.EAN_Location_Number_1__c          = '123';
        a.EAN_Location_Number_2__c          = '456';    
        a.Language__c                       = 'DK';
        a.Registration_Country__c           = 'DK';
        return a;
    }
    
     public static AccountTeamMember createAccountTeamMember() {
        AccountTeamMember accountTeamMember = new AccountTeamMember();
        return accountTeamMember;
     }
    
    // Returns 200 accounts
    public static List<Account> createAccounts()
    {   
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < 201; i++) {
            accountList.add(createAccount());
        }
        return accountList;
    }
    
    // Create contact
    public static Contact createContact()
    {   
        Contact c = new Contact();
        c.LastName = 'NOW ' + String.valueOf(System.now());
        c.FirstName = 'NOW ' + String.valueOf(System.now());
        c.Contact_Person_Type__c = 'Lead Contact Person (TBD)';
        c.Language__c = 'EN';
        c.Verified__c = 'N';
        return c;
    }
    
    // Returns 200 contacts
    public static List<Contact> createContacts()
    {   
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < 201; i++) {
            contactList.add(createContact());
        }
        return contactList;
    }
    
    //Create Lead
    public static Lead createLead() {
        Lead lead = new Lead();
            lead.FirstName = 'FirstName:' + String.valueOf(DateTime.now());
            lead.LastName = 'LastName:' + String.valueOf(DateTime.now());
        
        return lead;
    }
    
    // Returns 200 Leads
    public static List<Lead> createLeads()
    {   
        List<Lead> leadList = new List<Lead>();
        for (Integer i = 0; i < 201; i++) {
            leadList.add(createLead());
        }
        return leadList;
    }
    
    //Create Opportunity
    public static Opportunity createOpportunity() {
        Opportunity opp = new Opportunity();
        Account acct = createAccount();
            acct.recordTypeId = UTIL_Meta.getAccountWorksiteRT();
            insert acct;
            opp.AccountId = acct.Id;
            opp.Start_Date__c = Date.today().addDays(5);
            opp.name = 'oppName';
            opp.lead_id__c = null;
            opp.StageName = 'Not Started';
            opp.CloseDate = Date.today().addDays(2);
            opp.CurrencyIsoCode = 'SEK';       
        return opp;
    }
    
    public static Opportunity createOpportunity(Account acct) {
        Opportunity opp = new Opportunity();
            opp.AccountId = acct.Id;
            opp.Start_Date__c = Date.today().addDays(5);
            opp.name = 'oppName';
            opp.lead_id__c = null;
            opp.StageName = 'Not Started';
            opp.CloseDate = Date.today().addDays(2);
            opp.CurrencyIsoCode = 'SEK';       
        return opp;
    }
    
    //Create Opportunity Team Member
    public static OpportunityTeamMember createOpportunityTeamMember() {
        OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
        oppTeamMember.TeamMemberRole = 'BE - Sponsor';
        return oppTeamMember;
    }
    
    //Create OpportunityLineItem
    public static OpportunityLineItem createOpportunityLineItem() {
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        
        return oppLineItem;
    }
    
    //Create Task
    public static Task createTask(){
        Task task = new Task();
        return task;
    }
    
    //Create Event
    public static Event createEvent(){
        Event event = new Event();
        event.DurationInMinutes = 1;
        event.ActivityDate = Date.today();
        event.ActivityDateTime = Datetime.now();
        return event;
    }
    
    //Create Events
    public static List<Event> createEvents(){
        
        List<Event> eventList = new List<Event>();
        for (Integer i = 0; i < 201; i++) {
            Event event = new Event();
            event.DurationInMinutes = 1;
            event.ActivityDate = Date.today();
            event.ActivityDateTime = Datetime.now();
            eventList.add(event);
        }

        return eventList;
    }
    
    //Create PricebookEntry
    public static PricebookEntry createPricebookEntry() {
        
        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE isStandard=true LIMIT 1];
        
        Product2 product = createProduct();
        insert product;
        
        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id        = standardPricebook.Id,
            Product2Id          = product.Id,
            IsActive            = true,
            UnitPrice           = 100,
            CurrencyIsoCode     = 'SEK'
        );
        
        return pricebookEntry;
    }
    
    public static PricebookEntry createPricebookEntry(Id pricebookId) {
        
        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE isStandard=true LIMIT 1];
        
        Product2 product = createProduct();
        insert product;
        
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id        = standardPricebook.Id,
            Product2Id          = product.Id,
            IsActive            = true,
            UnitPrice           = 100,
            CurrencyIsoCode     = 'SEK'
        );
        
        insert standardPricebookEntry;
        
        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id        = pricebookId,
            Product2Id          = product.Id,
            IsActive            = true,
            UnitPrice           = 100,
            CurrencyIsoCode     = 'SEK'
        );
        
        return pricebookEntry;
    }
    
    // Create Account Contact Role Transaction
   public static Account_Contact_Role_Transaction__c createAcrt()
    {   
        Account a = createAccount();
        insert a;
        Contact c = createContact();
        c.AccountId = a.Id;
        insert c;
        
        Account_Contact_Role_Transaction__c acrt = [Select SystemModstamp, Secondary_Position_3__c, Secondary_Position_2__c, Secondary_Position_1__c, Primary_Position__c, PN_Synchronized__c, PN_Synchronization_Error__c, PN_Synchronization_ErrorReasonCode__c, PN_Mark_As_Synced__c, Name, Last_PN_Synchronized_Date__c, LastModifiedDate, LastModifiedById, Is_Governed_by_External_Party__c, IsPrimary__c, IsDeleted, Id, External_Provider_Relationship_ID__c, CurrencyIsoCode, CreatedDate, CreatedById, Contact__c, Account__c, Account_Contact_Role_SFID__c
                                                    From Account_Contact_Role_Transaction__c
                                                    WHERE Account__c = :a.Id AND Contact__c = :c.Id
                                                    LIMIT 1];
        return acrt;
    }
    
    // Returns 200 Account Contact Role Transactions
   public static List<Account_Contact_Role_Transaction__c> createAcrts()
    {   
        Account a = createAccount();
        insert a;
        Contact[] cs = createContacts();
        
        for(Contact c : cs) {
            c.AccountId = a.Id;
        }
        insert cs;
        
        Account_Contact_Role_Transaction__c[] acrtList = [Select SystemModstamp, Secondary_Position_3__c, Secondary_Position_2__c, Secondary_Position_1__c, Primary_Position__c, PN_Synchronized__c, PN_Synchronization_Error__c, PN_Synchronization_ErrorReasonCode__c, PN_Mark_As_Synced__c, Name, Last_PN_Synchronized_Date__c, LastModifiedDate, LastModifiedById, Is_Governed_by_External_Party__c, IsPrimary__c, IsDeleted, Id, External_Provider_Relationship_ID__c, CurrencyIsoCode, CreatedDate, CreatedById, Contact__c, Account__c, Account_Contact_Role_SFID__c
                                                    From Account_Contact_Role_Transaction__c
                                                    WHERE Account__c = :a.Id];
        return acrtList;
    }
    
    // Create Bank Detail
    public static Bank_Details__c createBankDetail()
    {   
        Bank_Details__c bankDetail = new Bank_Details__c();
        Account acct = createAccount();
        insert acct;
        bankDetail.Account__c = acct.Id;
        
        Bank_Key__c bankKey = createBankKey();
        insert bankKey;
        
        bankDetail.Bank_Key__c = bankKey.Id;
        bankDetail.Bank_Country__c = bankKey.Country__c;
        bankDetail.Bank_Account__c = '1234567890';
        
        return bankDetail;
    }
    
    // Returns 200 Bank Details
    public static List<Bank_Details__c> createBankDetails()
    {   
        List<Bank_Details__c> bankDetailList = new List<Bank_Details__c>();
        Account acct = createAccount();
        insert acct;
        for (Integer i = 0; i < 201; i++) {
            Bank_Details__c bankDetail = new Bank_Details__c();
            bankDetail.Account__c = acct.Id;
            bankDetailList.add(bankDetail);
        }
        return bankDetailList;
    }
    
    // Create Bank Key
    public static Bank_Key__c createBankKey()
    {   
        Bank_Key__c bankKey = new Bank_Key__c();
        bankKey.Name = '40';
        bankKey.Bank_City__c = '4760 VORDINGBORG';
        bankKey.Bank_Street__c = 'ALGADE 78, POSTBOX 111';
        bankKey.Country__c = 'DK';
        bankKey.Bank_Name__c = 'NORDEA BANK DANMARK A/S';
        return bankKey;
    }
    
    // Create CreditInformation
    public static Credit_Information__c createCreditInformation()
    {   
        Credit_Information__c creditInformation = new Credit_Information__c();
        Account acct = createAccount();
        insert acct;
        creditInformation.Account__c = acct.Id;
        return creditInformation;
    }
    
    // Returns 200 CreditInformations
    public static List<Credit_Information__c> createcreditInformations()
    {   
        List<Credit_Information__c> creditInformationList = new List<Credit_Information__c>();
        Account acct = createAccount();
        insert acct;
        for (Integer i = 0; i < 201; i++) {
            Credit_Information__c creditInformation = new Credit_Information__c();
            creditInformation.Account__c = acct.Id;
            creditInformationList.add(creditInformation);
        }
        return creditInformationList;
    }
    
   //create Customer_Service_Product__c
    public static List<Customer_Service_Product__c> createProductArticle(){
        List<Customer_Service_Product__c> prodArticleLst = new List<Customer_Service_Product__c>();
        for (Integer i = 0; i < 201; i++) {
            Customer_Service_Product__c custServicePro =new Customer_Service_Product__c();
            custServicePro.Name='NOW ' + String.valueOf(System.now());
            custServicePro.Global_ID__c = String.valueOf(globalId);
            globalId = globalId + 1;
            prodArticleLst.add(custServicePro);
        }
        return prodArticleLst;
    }
    
    //create Customer_Service_Product__c
    public static Customer_Service_Product__c createProductArticl(){
        
        Customer_Service_Product__c custServicePro =new Customer_Service_Product__c();
        custServicePro.Name='NOW ' + String.valueOf(System.now());
        custServicePro.Global_ID__c = String.valueOf(globalId);
        globalId = globalId + 1;
        custServicePro.Active__c = true;
        custServicePro.Sales_Area__c = 'SA1234';
        custServicePro.Product_Type__c = 'Product';
        return custServicePro;
    }
    
    //create CaseProduct__c
    public static CaseProduct__c createCaseProd()
    {
        CaseProduct__c caseProd =new CaseProduct__c();
        return caseProd;
    }
    
    //create CaseProducts
    public static List<CaseProduct__c> createCaseProds()
    {
        List<CaseProduct__c> caseProdLst =new List<CaseProduct__c>();
        for (Integer i = 0; i < 201; i++) {
            CaseProduct__c casProd =new CaseProduct__c();
            caseProdLst.add(casProd);
        }
        return caseProdLst;
    }
    
    //create  NTT_History__c
    public static NTT_History__c createNTTHistry()
    {
        NTT_History__c nttHstry =new NTT_History__c();
        return nttHstry;
    }
    
    //create  NTT_History records
    public static List<NTT_History__c> createNTTHistrys()
    {
         List<NTT_History__c> nttHistryLst = new List<NTT_History__c>();
        for (Integer i = 0; i < 201; i++) {
            NTT_History__c nttHstry =new NTT_History__c();
            nttHistryLst.add(nttHstry);
        }
        return nttHistryLst;
    }
    
    //create  case
    public static Case createCase()
    {
        Case cases = new Case();
        return cases;
    }
    
    //create  cases
    public static List<Case> createCases()
    {
        List<Case> casLst = new List<Case>();
        for (Integer i = 0; i < 201; i++) {
            Case cas =new Case();
            casLst.add(cas);
        }
        return casLst;
    }
    
    //Create parent case
     public static List<Case> createParentCase()
    {
        List<Case> casLst = new List<Case>();
        Case cass = new case();
        insert cass;
        for (Integer i = 0; i < 201; i++) {
            Case cas =new Case();
            cas.ParentId = cass.Id;
            casLst.add(cas);
        }
    return casLst;
    }
    
    //Derefrence parent Case
    public static List<Case> deleteParentCase()
    {
        List<Case> casLst = new List<Case>();
        Case cass = new Case();
        Case delCase = new Case();
        insert delcase;
        insert cass;
        for (Integer i = 0; i < 201; i++) {
            Case cas =new Case();
            cas.ParentId = cass.Id;
            casLst.add(cas);
        }
       insert casLst;
        for(Integer i = 0; i<casLst.size(); i++)
        {
          casLst[i].ParentId = delCase.Id;
          //casLst.add(c);
        }
        
        return casLst;
    }
    
    //create PossibleDuplicateAccount__c record.
    public static PossibleDuplicateAccount__c createPossibleDuplicate()
    {
        PossibleDuplicateAccount__c PossDuplicate =new PossibleDuplicateAccount__c();
        return PossDuplicate;
    }
    
    //create  Product
    public static Product2 createProduct()
    {
        Product2 product = new Product2();
        product.IsActive = true;
        product.name = 'productName';
        product.Product_Type__c='testType';
        product.Global_ID__c=String.valueOf(globalId);
        globalId = globalId + 1;
        return product;
    }
    
    //Create  Products records.
    public static List<Product2> createProducts()
    {
       List<Product2> productLst = new List<Product2>();
       
        for (Integer i = 0; i < 201; i++) {
            Product2 product = new Product2();
            product.IsActive = true;
            product.name = 'productName';
            product.Product_Type__c='testType';
            product.Global_ID__c =String.valueOf(globalId);
            globalId = globalId + 1;
            productLst.add(product);
        }
        return productLst;
    }
    
    //Create Asset records.
    public static List<Asset> createAssets()
    {
       List<Asset> AssetLst = new List<Asset>();
       
        for (Integer i = 0; i < 201; i++) {
            Asset Asst = new Asset();
            Asst.Name ='testName'+i;
            AssetLst.add(Asst);
        }
        return AssetLst;
    }
    
    // Creates a relationship, sets the required fields that can be set without using DML
    // Returns the relationship
    public static Relationship__c createRelationshipDMLFree(){
        Relationship__c relationship = new Relationship__c();       
        relationship.Relationship_Type__c = 'RE';
        return relationship;
    }
    
    // Create Relationship, sets both MD account and related account
    // Has to use a DML call to find the correct Sales Area
    public static Relationship__c createRelationship()
    {   
        Account legalEntity = createAccount();
        legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        insert legalEntity;
        
        list<Account> acctLst = new list<Account>();
        for (Integer i = 0; i < 2; i++) {
            Account a = createAccount();
            UTIL_Meta.getAccountWorkSiteRT();
            a.ParentId = legalEntity.Id;
            acctLst.add(a);
        }
        insert acctLst;
        
        Relationship__c relationship = createRelationshipDMLFree();

        List<Sales_Area_Information__c> insertedSAIs = [SELECT Id, Sales_Area__c, Distribution_Channel__c, Division__c FROM Sales_Area_Information__c WHERE Account__r.Id IN :AcctLst];
        for (Sales_Area_Information__c SAI: insertedSAIs) {
            SAI.Type__c = 'Customer';
        }
        update insertedSAIs;
        
        relationship.Account__c = acctLst[0].Id;
        relationship.Related_Account__c = acctLst[1].Id;
        relationship.Distribution_Channel__c = insertedSAIs[0].Distribution_Channel__c;
        relationship.Division__c = insertedSAIs[0].Division__c;
        relationship.Sales_Area__c = insertedSAIs[0].Sales_Area__c;
        return relationship;
    }
    
    // Returns 200 Relationships, sets both MD account and related account
    // Has to use a DML call to find the correct Sales Area
    public static List<Relationship__c> createRelationships()
    {   
        Account legalEntity = createAccount();
        legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        insert legalEntity;
        
        list<Account> acctLst = new list<Account>();
        for (Integer i = 0; i < 2; i++) {
            Account a = createAccount();
            UTIL_Meta.getAccountWorkSiteRT();
            a.ParentId = legalEntity.Id;
            acctLst.add(a);
        }
        insert acctLst;
        
        List<Sales_Area_Information__c> insertedSAIs = [SELECT Id, Sales_Area__c, Distribution_Channel__c, Division__c FROM Sales_Area_Information__c WHERE Account__r.Id IN :AcctLst];
        for (Sales_Area_Information__c SAI: insertedSAIs) {
            SAI.Type__c = 'Customer';
        }
        update insertedSAIs;
        
        List<Relationship__c> relationshipList = new List<Relationship__c>();
        for (Integer i = 0; i < 201; i++) {
            Relationship__c relationship = new Relationship__c();
            relationship.Account__c = acctLst[0].Id;
            relationship.Related_Account__c = acctLst[1].Id;
            relationship.Sales_Area__c = insertedSAIs[0].Sales_Area__c;
            relationship.Distribution_Channel__c = insertedSAIs[0].Sales_Area__c;
            relationship.Division__c = insertedSAIs[0].Division__c;
            relationship.Relationship_Type__c = 'RE' + String.valueOf(i);
            relationshipList.add(relationship);
        }
        return relationshipList;
    }
    
    //Create a DML free Sales Area Information, need to be connected to an Account
    public static Sales_Area_Information__c createSalesAreaInformationDMLFree()
    {
        Sales_Area_Information__c SAI = new Sales_Area_Information__c();
        SAI.Sales_Area__c = '1000';
        SAI.Distribution_Channel__c = '10';
        SAI.Division__c = '00';
        SAI.PostNord_Company_Name__c = '1000';
        return SAI;
    }
    
    // Create Sales Area Information
    public static Sales_Area_Information__c createSalesAreaInformation()
    {   
        Sales_Area_Information__c salesAreaInformations = new Sales_Area_Information__c();
        Account acct = createAccount();
        insert acct;
        salesAreaInformations.Account__c = acct.Id;
        return salesAreaInformations;
    }
    
    // Returns 200 Sales Area Informations
    public static List<Sales_Area_Information__c> createSalesAreaInformations()
    {   
        List<Sales_Area_Information__c> salesAreaInformationsList = new List<Sales_Area_Information__c>();
        Account acct = createAccount();
        insert acct;
        for (Integer i = 0; i < 201; i++) {
            Sales_Area_Information__c salesAreaInformations = new Sales_Area_Information__c();
            salesAreaInformations.Account__c = acct.Id;
            salesAreaInformationsList.add(salesAreaInformations);
        }
        return salesAreaInformationsList;
    }

    // Create ApexErrorLog
    public static ApexErrorLog__c createApexErrorLog()
    {   
        ApexErrorLog__c apexErrorLog = new ApexErrorLog__c();
        apexErrorLog.Error_Code__c = '1234';
        apexErrorLog.Error_Description__c = 'Test error description';
        apexErrorLog.Timestamp__c = DateTime.now();
        return apexErrorLog;
    }

    // Create ApexErrorLog
    public static ApexCalloutLog__c createApexCalloutLog()
    {   
        ApexCalloutLog__c apexErrorLog = new ApexCalloutLog__c();
        apexErrorLog.Error_Code__c = '1234';
        apexErrorLog.Error_Description__c = 'Test error description';
        return apexErrorLog;
    }

    // Create outboundNotification
    public static Outbound_Notification__c createOutboundNotification()
    {   
        Outbound_Notification__c outboundNotification = new Outbound_Notification__c();
        outboundNotification.Last_PN_Synchronized_Date__c = DateTime.now();
        outboundNotification.Notification_Key__c = 'testKey' + DateTime.now();
        outboundNotification.Object_API_Name__c = 'Account';
        outboundNotification.Object_External_ID__c = 'testID';
        outboundNotification.Object_SFDC_ID__c = 'testSFDCid';
        outboundNotification.Operation__c = 'DELETE';
        outboundNotification.PN_Mark_as_Synced__c = true;
        outboundNotification.PN_Synchronized__c = true;
    
        return outboundNotification;
    }
    
    // Returns 201 outboundNotifications
    public static List<Outbound_Notification__c> createOutboundNotifications()
    {   
        List<Outbound_Notification__c> outboundNotificationList = new List<Outbound_Notification__c>();
        for (Integer i = 0; i < 201; i++) {
            Outbound_Notification__c outboundNotification = new Outbound_Notification__c();
            outboundNotification.Last_PN_Synchronized_Date__c = DateTime.now();
            outboundNotification.Notification_Key__c = 'testKey' + i + DateTime.now();
            outboundNotification.Object_API_Name__c = 'Account';
            outboundNotification.Object_External_ID__c = 'testID' + i;
            outboundNotification.Object_SFDC_ID__c = 'testSFDCid' + i;
            outboundNotification.Operation__c = 'DELETE';
            outboundNotification.PN_Mark_as_Synced__c = true;
            outboundNotification.PN_Synchronized__c = true;
            outboundNotificationList.add(outboundNotification);
        }
        return outboundNotificationList;
    }
            
    // Create Potential__c
    public static Potential__c createPotential()
    {   
        Potential__c potential = new Potential__c();
        Account acct = createAccount();
        insert acct;
        potential.Customer__c = acct.Id;
        potential.Status__c = 'Open';
        potential.Sales_Area__c = '1000';
        return potential;
    }
        
    // Create Potential Product Lines
    public static Potential_Product_Line__c createPotentialProductLine()
    {   
        Potential_Product_Line__c potentialProductLine = new Potential_Product_Line__c();
        return potentialProductLine;
    }
    
    // Create Outbound Notification records
    public static List<Outbound_Notification__c> createOutboundNotifications(Integer n)
    {   
        List<Outbound_Notification__c> outboundNotifications = new List<Outbound_Notification__c>();
        for (Integer i = 0; i < n; i++) {
            Outbound_Notification__c outboundNotification = new Outbound_Notification__c();
            outboundNotification.Object_API_Name__c = 'Test_Object__c';
            outboundNotification.Object_External_ID__c = '1:2:3:4' + String.valueOf(i);
            outboundNotification.Object_SFDC_ID__c = 'TEST';
            outboundNotification.Operation__c = 'DELETE';
            outboundNotification.Notification_Key__c = outboundNotification.Object_API_Name__c + ':' +
                                                        outboundNotification.Object_External_ID__c + ':' +
                                                        outboundNotification.Operation__c;                                                      
            outboundNotifications.add(outboundNotification);
        }
        return outboundNotifications;
    }

    // create users of varying types    
    public static User createIntegrationUser(String username)
    {
        createGet2OneCrm();
        String integrationProfileName = UTIL_OrgSettings.integration_Profile_Name();
        return createUser(username, integrationProfileName);
    }
    
    public static User createSalesUser(String username)
    {
        createGet2OneCrm();
        String salesUserProfileName = UTIL_OrgSettings.SalesUserProfileName();
        return createUser(username, salesUserProfileName);
    }
    
    public static User createAdmin(String username)
    {
        return createUser(username, 'System Administrator');
    }
    
    // create Custom Setting HTTP_Integration_Services__c
    public static void createHttpIntegrationServices()
    {   
        delete [select id from HTTP_Integration_Services__c limit 50000];
        list<HTTP_Integration_Services__c> HTTPIntegrationServicesList = new list<HTTP_Integration_Services__c>();    
        HTTP_Integration_Services__c VAP = new HTTP_Integration_Services__c();
        VAP.Name                        =   'VAP';
        VAP.Enabled__c                  =   true;
        VAP.Endpoint__c                 =   'http://test.test/test';
        VAP.Host__c                     =   'http://test.test';
        VAP.Provider__c                 =   'TEST';
        VAP.RequestMethod__c            =   'POST';
        VAP.UserName__c                 =   'user';
        VAP.Password__c                 =   'pass';
        VAP.Error_Code_Path__c          =   'id';
        VAP.Error_Descripion_Path__c    =   'explanation';
        HTTPIntegrationServicesList.add(VAP);
        
        HTTP_Integration_Services__c MOD = new HTTP_Integration_Services__c();
        MOD.Name                        =   'MOD';
        MOD.Enabled__c                  =   true;
        MOD.Endpoint__c                 =   'http://test.test/test';
        MOD.Host__c                     =   'http://test.test';
        MOD.Provider__c                 =   'TEST';
        MOD.RequestMethod__c            =   'POST';
        MOD.UserName__c                 =   'user';
        MOD.Password__c                 =   'pass';
        MOD.Error_Code_Path__c          =   'category';
        MOD.Error_Descripion_Path__c    =   'explanation';
        HTTPIntegrationServicesList.add(MOD);
        
        HTTP_Integration_Services__c NTT = new HTTP_Integration_Services__c();
        NTT.Name                        =   'NTT';
        NTT.Enabled__c                  =   true;
        NTT.Endpoint__c                 =   'http://test.test/test';
        NTT.Host__c                     =   'http://test.test';
        NTT.Provider__c                 =   'TEST';
        NTT.RequestMethod__c            =   'POST';
        NTT.UserName__c                 =   'user';
        NTT.Password__c                 =   'pass';
        NTT.Error_Code_Path__c          =   'faultCode';
        NTT.Error_Descripion_Path__c    =   'explanationText';
        HTTPIntegrationServicesList.add(NTT);
        
        HTTP_Integration_Services__c PAR_Account = new HTTP_Integration_Services__c();
        PAR_Account.Name                        =   'PAR_Account';
        PAR_Account.Enabled__c                  =   true;
        PAR_Account.Endpoint__c                 =   'http://test.test/test';
        PAR_Account.Host__c                     =   'http://test.test';
        PAR_Account.Provider__c                 =   'TEST';
        PAR_Account.RequestMethod__c            =   'POST';
        PAR_Account.UserName__c                 =   'user';
        PAR_Account.Password__c                 =   'pass';
        PAR_Account.Error_Code_Path__c          =   'FaulCode';
        PAR_Account.Error_Descripion_Path__c    =   'FaultMessage';
        HTTPIntegrationServicesList.add(PAR_Account);
        
        HTTP_Integration_Services__c PAR_Contact = new HTTP_Integration_Services__c();
        PAR_Contact.Name                        =   'PAR_Contact';
        PAR_Contact.Enabled__c                  =   true;
        PAR_Contact.Endpoint__c                 =   'http://test.test/test';
        PAR_Contact.Host__c                     =   'http://test.test';
        PAR_Contact.Provider__c                 =   'TEST';
        PAR_Contact.RequestMethod__c            =   'POST';
        PAR_Contact.UserName__c                 =   'user';
        PAR_Contact.Password__c                 =   'pass';
        PAR_Contact.Error_Code_Path__c          =   'FaulCode';
        PAR_Contact.Error_Descripion_Path__c    =   'FaultMessage';
        HTTPIntegrationServicesList.add(PAR_Contact);
        
        HTTP_Integration_Services__c SAP_PriceCalculation = new HTTP_Integration_Services__c();
        SAP_PriceCalculation.Name                        =   'SAP_PriceCalculation';
        SAP_PriceCalculation.Enabled__c                  =   true;
        SAP_PriceCalculation.Endpoint__c                 =   'http://test.test/test';
        SAP_PriceCalculation.Host__c                     =   'http://test.test';
        SAP_PriceCalculation.Provider__c                 =   'TEST';
        SAP_PriceCalculation.RequestMethod__c            =   'POST';
        SAP_PriceCalculation.UserName__c                 =   'user';
        SAP_PriceCalculation.Password__c                 =   'pass';
        SAP_PriceCalculation.Error_Code_Path__c          =   'severity';
        SAP_PriceCalculation.Error_Descripion_Path__c    =   'text';
        HTTPIntegrationServicesList.add(SAP_PriceCalculation);

        insert HTTPIntegrationServicesList;
    }
    
    // create Custom Setting Get2OneCRM
    public static void createGet2OneCrm()
    {   
        Get2OneCRM__c get2OneCrm = Get2OneCRM__c.getOrgDefaults();
        map<String, Schema.SobjectField> fieldMap = Schema.SObjectType.Get2OneCRM__c.fields.getMap();
        
        for(String fieldName : fieldMap.keySet()){
            if(fieldMap.get(fieldName).getDescribe().isUpdateable()){
                if(!fieldMap.get(fieldName).getDescribe().isDefaultedOnCreate()){
                    get2OneCrm.put(fieldName, null);
                }
            }
        }
        get2OneCrm.Lead_Status__c = 'Qualified by lead data,Qualified by customer call';
        get2OneCrm.Lead_Sales_Area_SAP_codes__c = '001';
        get2OneCrm.Lead_Receiver_Account_Team_Role__c = 'Customer Responsible';
        get2OneCrm.Lead_Allocated_to_Sales__c = 'Allocated to Sales';
        get2OneCrm.Webshop_B2B_Name__c = 'B2B Webshop';
        get2OneCrm.Webshop_B2C_Name__c = 'B2C Webshop';
        get2OneCrm.Webshop_Origin__c = 'Netbutikken';
        get2OneCrm.Sales_User_Profile_Name__c = 'Sales Standard User';
        get2OneCrm.Integration_Profile_Name__c = 'Integration User';
        get2OneCrm.Integration_CRM_Webservices_Profile_Name__c = 'Integration Exposed Webservices User';
        get2OneCrm.Administrator_Profile_Name__c = 'System Administrator';
        get2OneCrm.Case_RecordTypes__c='Complaint';
        get2OneCrm.taskNextCallListDateTypes__c = 'Completed';
        get2OneCrm.taskActivityDateTypes__c = 'Postponed';
        get2OneCrm.taskNotReachedCounterTypes__c = 'Not reached';
        get2OneCrm.taskActivityCompletedDateTypes__c = 'Telephone Contact,Follow up 1-1-1,To Do';
        get2OneCrm.eventActivityCompletedDateTypes__c ='Physical Meeting,Customer arrangement,Telephone meeting';
        get2OneCrm.ContactName_StructuredCommunication__c = 'Functional Inbox:';
        get2OneCrm.Contact_Person_Type_from_LeadConvert__c = 'Lead Contact Person';
        get2OneCrm.OBM_Stress_Dashboard_Captcha__c = 'THIS WILL CREATE/DELETE RECORDS AND SEND DATA TO EXTERNAL SYSTEMS';
        get2OneCrm.Outbound_Notification_Operation_Delete__c = 'DELETE';
        get2OneCrm.ConvertPotential_Status__c = 'Converted to Opportunity';
        get2OneCrm.ConvertPotential_StageName__c = 'Not Started';
        get2OneCrm.ConvertPotential_Name__c = 'Converted from Potential';
        get2OneCrm.ConvertPotential_CloseDate__c = 6;
        get2OneCrm.New_Contact_Main_Flow_Record_Types__c = 'Contact_Person';
        get2OneCrm.Relationship_Type_Payer__c = 'RG';
        get2OneCrm.Call_Contact_Task_Name__c = 'Campaign Task - Call Contact';
        get2OneCrm.Customer_Responsible_Role__c = 'Customer Responsible';
        
        upsert get2OneCrm;
    }
    
    // create Custom Setting CINT SOAP Integration Settings
    public static void createCINTSOAPIntegrationSettings()
    {   
        CINT_SOAP_Integration_Settings__c CINTSOAPIntegrationSettings = CINT_SOAP_Integration_Settings__c.getOrgDefaults();
        map<String, Schema.SobjectField> fieldMap = Schema.SObjectType.CINT_SOAP_Integration_Settings__c.fields.getMap();
        
        for(String fieldName : fieldMap.keySet()){
            if(fieldMap.get(fieldName).getDescribe().isUpdateable()){
                if(!fieldMap.get(fieldName).getDescribe().isDefaultedOnCreate()){
                    CINTSOAPIntegrationSettings.put(fieldName, null);
                }
            }
        }
        CINTSOAPIntegrationSettings.CINT_Custom_Error_Code__c = 'MsgCode';
        CINTSOAPIntegrationSettings.CINT_Custom_Error_Description__c = 'Message';
        CINTSOAPIntegrationSettings.SOAP_Error_Code__c = 'faultcode';
        CINTSOAPIntegrationSettings.SOAP_Error_Description__c = 'faultstring';

        upsert CINTSOAPIntegrationSettings;
    }
    
    // create Custom Setting ScheduledJobParameters
    public static void createScheduledJobParameters(){

        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        map<String, Schema.SobjectField> fieldMap = Schema.SObjectType.ScheduledJobParameters__c.fields.getMap();
        
        for(String fieldName : fieldMap.keySet()){
            if(fieldMap.get(fieldName).getDescribe().isUpdateable()){
                if(!fieldMap.get(fieldName).getDescribe().isDefaultedOnCreate()){
                    scheduledJobParameters.put(fieldName, null);
                }
            }
        }
        scheduledJobParameters.apexCalloutLogDeletionActive__c = true;
        scheduledJobParameters.apexCalloutLogGraceperiod__c = '3';
        scheduledJobParameters.apexErrorLogDeletionActive__c = true;
        scheduledJobParameters.apexErrorLogGraceperiod__c = '3';
        scheduledJobParameters.outboundNotificationDeletionActive__c  = true;
        scheduledJobParameters.outboundNotificationGraceperiod__c = '3';

        upsert scheduledJobParameters;
    }

    // create Custom Setting Lead Sales Area
    public static void createLeadSalesArea()
    {   
        Lead_Sales_Area__c leadSalesArea = new Lead_Sales_Area__c();
        leadSalesArea.Name          =   '001';
        leadSalesArea.Text_value__c =   'BE';

        insert leadSalesArea;
    }
    
    //Get Account record type by dev name
    public static Id getAccountRecordType(String devName)
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName =:devName].Id;
        return recordTypeId;
    }
    
    //Get Account record type by dev name
    public static Id getContactRecordType(String devName)
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName =:devName].Id;
        return recordTypeId;
    }
    
    // create Custom Setting AccountTeamMember To Account Mapping
    public static void createAccountTeamMemberToAccountMapping()
    {   
        list<AccountTeamMemberToAccountMapping__c> atm2AccMapList = new list <AccountTeamMemberToAccountMapping__c>(); 
        atm2AccMapList.add(new AccountTeamMemberToAccountMapping__c(Name = '1',
                                                                    Account_Team_Member_Role__c = 'PDK BE - Customer Responsible',
                                                                    SourceField__c = 'User.Name', 
                                                                    DestinationField__c = 'PDK_BE_Cust_Resp_Name__c'));
        atm2AccMapList.add(new AccountTeamMemberToAccountMapping__c(Name = '2',
                                                                    Account_Team_Member_Role__c = 'PDK BE - Customer Responsible',
                                                                    SourceField__c = 'User.Email', 
                                                                    DestinationField__c = 'PDK_BE_Cust_Resp_Email__c'));
        atm2AccMapList.add(new AccountTeamMemberToAccountMapping__c(Name = '3',
                                                                    Account_Team_Member_Role__c = 'PDK LO - Customer Responsible',
                                                                    SourceField__c = 'User.Name', 
                                                                    DestinationField__c = 'PDK_LO_Cust_Resp_Name__c'));
        atm2AccMapList.add(new AccountTeamMemberToAccountMapping__c(Name = '4',
                                                                    Account_Team_Member_Role__c = 'PDK LO - Customer Responsible',
                                                                    SourceField__c = 'User.Email', 
                                                                    DestinationField__c = 'PDK_LO_Cust_Resp_Email__c'));
        insert atm2AccMapList;
    }
    
    // create Custom Setting AccountTeamMember To Account Mapping
    public static void createAccountTeamMemberToAccountMapping(String AccountTeamMemberRole, String SourceField, String DestinationField){
        list<AccountTeamMemberToAccountMapping__c> atm2AccMapList = AccountTeamMemberToAccountMapping__c.getAll().values();
        integer highest = -1;
        for(AccountTeamMemberToAccountMapping__c atm2AccMap : atm2AccMapList){
            highest = (Integer.valueOf(atm2AccMap.Name) > highest) ? Integer.valueOf(atm2AccMap.Name) : highest;
        }
        insert new AccountTeamMemberToAccountMapping__c(Name = String.valueOf(highest+1), 
                                                        Account_Team_Member_Role__c = AccountTeamMemberRole, 
                                                        SourceField__c = SourceField, 
                                                        DestinationField__c = DestinationField );
    }
    
    // create Custom Setting AccountTeamMember To Account Mapping
    public static void createAccountTeamMemberRolesToSync(){   
        list<AccountTeamMemberRolesToSync__c> atmRoles2Sync = new list <AccountTeamMemberRolesToSync__c>(); 
        atmRoles2Sync.add(new AccountTeamMemberRolesToSync__c(Name = 'PDK BE - Customer Responsible'));
        atmRoles2Sync.add(new AccountTeamMemberRolesToSync__c(Name = 'PDK LO - Customer Responsible'));
        insert atmRoles2Sync;
    }
    
    // create Custom Setting AccountTeamMemberBatchErrorList__c
    public static void createAccountTeamMemberBatchErrorList(list<AccountTeamMember> atmList, boolean expired){ 
        list<AccountTeamMemberBatchErrorList__c> atmBatchErrors = new list<AccountTeamMemberBatchErrorList__c>();
        for(AccountTeamMember atm : atmList){
            atmBatchErrors.add(new AccountTeamMemberBatchErrorList__c(Name = atm.id, 
                                                      ErrorTime__c = expired ? dateTime.now().addDays(-30) : dateTime.now()));
        }
        insert atmBatchErrors;
    }
    
    // create Custom Setting Sales Area to Field Mapping
    public static void createSalesAreaToFieldMapping()
    {
        List<SalesAreaToFieldMapping__c> SalesAreaToFieldList = new List<SalesAreaToFieldMapping__c>();
        
        SalesAreaToFieldMapping__c salesAreaToFieldMapping1 = new SalesAreaToFieldMapping__c();
        salesAreaToFieldMapping1.Name = '4000';
        salesAreaToFieldMapping1.Custom_Call_Interval__c = 'PDK_LO_custom_call_interval__c';
        salesAreaToFieldMapping1.Custom_Call_Interval_Value__c = '5';
        salesAreaToFieldMapping1.MaxNumber__c = '1';
        salesAreaToFieldMapping1.Next_Call_List_Date__c ='Next_Call_List_Date_PDK_LO__c';
        salesAreaToFieldMapping1.Not_Reached_Counter__c ='Not_reached_counter_PDK_LO__c';
        salesAreaToFieldMapping1.SubSegment__c ='PDK_LO_Sub_Segment__c';
        salesAreaToFieldMapping1.TopSegment__c ='PDK_LO_Top_Segment__c';
        SalesAreaToFieldList.add(salesAreaToFieldMapping1);
        
        SalesAreaToFieldMapping__c salesAreaToFieldMapping2 = new SalesAreaToFieldMapping__c();
        SalesAreaToFieldMapping2.Name = '1000';
        salesAreaToFieldMapping2.Custom_Call_Interval__c = 'PDK_BE_custom_call_interval__c';
        salesAreaToFieldMapping2.Custom_Call_Interval_Value__c = '4';
        salesAreaToFieldMapping2.MaxNumber__c = '0';
        salesAreaToFieldMapping2.Next_Call_List_Date__c ='Next_Call_List_Date_PDK_BE__c';
        salesAreaToFieldMapping2.Not_Reached_Counter__c ='Not_reached_counter_PDK_BE__c';
        salesAreaToFieldMapping2.SubSegment__c ='PDK_BE_Sub_Segment__c';
        salesAreaToFieldMapping2.TopSegment__c ='PDK_BE_Top_Segment__c';
        SalesAreaToFieldList.add(salesAreaToFieldMapping2);
        
        upsert SalesAreaToFieldList Name;
    }
    
    // create Custom Setting Sales Area to Segment Mapping
    public static void createSalesAreaToSegmentMapping()
    {
        List<SalesAreaToSegmentMapping__c> SalesAreaToSegmentList = new List<SalesAreaToSegmentMapping__c>();
        
        SalesAreaToSegmentMapping__c salesAreaToSegmentMapping1 = new SalesAreaToSegmentMapping__c();
        salesAreaToSegmentMapping1.Name = '1';
        salesAreaToSegmentMapping1.Interval__c = '52';
        salesAreaToSegmentMapping1.SalesArea__c = '4000';
        salesAreaToSegmentMapping1.SubSegment__c = '1A';
        salesAreaToSegmentMapping1.TopSegment__c = 'KA';
        SalesAreaToSegmentList.add(salesAreaToSegmentMapping1);
        
        SalesAreaToSegmentMapping__c salesAreaToSegmentMapping2 = new SalesAreaToSegmentMapping__c();
        salesAreaToSegmentMapping2.Name = '2';
        salesAreaToSegmentMapping2.Interval__c = '3';
        salesAreaToSegmentMapping2.SalesArea__c = '4000';
        salesAreaToSegmentMapping2.SubSegment__c = '1B';
        salesAreaToSegmentMapping2.TopSegment__c = 'KA';
        SalesAreaToSegmentList.add(salesAreaToSegmentMapping2);
        
        SalesAreaToSegmentMapping__c salesAreaToSegmentMapping3 = new SalesAreaToSegmentMapping__c();
        salesAreaToSegmentMapping3.Name = '3';
        salesAreaToSegmentMapping3.Interval__c = '3';
        salesAreaToSegmentMapping3.SalesArea__c = '1000';
        salesAreaToSegmentMapping3.SubSegment__c = '1A';
        salesAreaToSegmentMapping3.TopSegment__c = 'KA';
        SalesAreaToSegmentList.add(salesAreaToSegmentMapping3);
        
        SalesAreaToSegmentMapping__c salesAreaToSegmentMapping4 = new SalesAreaToSegmentMapping__c(); //No subSegment value present.
        salesAreaToSegmentMapping4.Name = '4';
        salesAreaToSegmentMapping4.Interval__c = '3';
        salesAreaToSegmentMapping4.SalesArea__c = '1000';
        salesAreaToSegmentMapping4.SubSegment__c = '';
        salesAreaToSegmentMapping4.TopSegment__c = 'LA';
        SalesAreaToSegmentList.add(salesAreaToSegmentMapping4);
        
        insert SalesAreaToSegmentList;
    }
    
    //Create Campaign
    public static Campaign createCampaign() {
        Campaign campaign = new Campaign();
        campaign.Name = 'Campaign Name';
        return campaign;
    }
    
    //create LiveChatVisitor
    public static LiveChatVisitor createLiveChatVisitor()
    {
        LiveChatVisitor liveChat =new LiveChatVisitor();
        return liveChat;
    }
    
    //create LiveChatTranscript
    public static LiveChatTranscript createLiveChatTranscript()
    {   
        LiveChatTranscript liveChatTranscript = new LiveChatTranscript();
        LiveChatVisitor liveChat = createLiveChatVisitor();
        insert liveChat;
        liveChatTranscript.LiveChatVisitorId = liveChat.Id;
        return liveChatTranscript;
    }
    
    //create  Note
    public static Note createNote()
    {
        Note notes = new Note();
        notes.title = 'testTitle';
        return notes;
    }
    
    //create  Attachment
    public static Attachment createAttachment()
    {
       Attachment attachments= new Attachment();
       attachments.name = 'testAttachment';
       return attachments;
    }
}