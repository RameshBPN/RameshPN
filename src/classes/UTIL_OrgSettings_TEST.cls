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
public with sharing class UTIL_OrgSettings_TEST {
    
    static void createContactPositions(){
        list<ContactPositions__c> cp = new list<ContactPositions__c>();
        cp.add(new ContactPositions__c(name = 'test1',Country__c = 'DK', Description__c ='testDesc', Required__c = true, Language__c = 'EN'));
        cp.add(new ContactPositions__c(name = 'test2',Country__c = 'DK', Description__c ='testDesc2', Required__c = true, Language__c = 'EN'));
        cp.add(new ContactPositions__c(name = 'test3',Country__c = 'DK', Description__c ='testDesc3', Required__c = false, Language__c = 'EN'));
        upsert cp;
    }       
    public static testMethod void testRequiredContactPositions()
    {
        createContactPositions();
        list<string> requiredPositions = UTIL_OrgSettings.requiredContactPositions();
        system.assertEquals(2, requiredPositions.size());
        system.assertEquals('test1', requiredPositions[0]);
        system.assertEquals('test2', requiredPositions[1]);
    }

    /**** Get2OneCRM Custom Settings ****/
    public static testMethod void testOpportunityStage_ClosedLost()
    {   
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Opportunity_Stage_Closed_Lost__c = 'testValue';
        update get2one;
        String stage = UTIL_OrgSettings.opportunityStage_ClosedLost();
        system.assertEquals('testValue', stage); 
    }
    public static testMethod void testOpportunityStage_ClosedWon()
    {   
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Opportunity_Stage_Closed_Won__c = 'testValue';
        update get2one;
        String stage = UTIL_OrgSettings.opportunityStage_ClosedWon();
        system.assertEquals('testValue', stage); 
    }
    /* - TO REMOVE - DEPRECATED
    public static testMethod void testOpportunityStage_InProgress()
    {   
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Opportunity_Stage_Closed_Lost__c = 'testValue1';
        get2one.Opportunity_Stage_Closed_Won__c = 'testValue2';
        update get2one;
        system.assert(UTIL_OrgSettings.opportunityStage_InProgress('testValue1')); 
        system.assert(UTIL_OrgSettings.opportunityStage_InProgress('testValue2')); 
        system.assert(!UTIL_OrgSettings.opportunityStage_InProgress('not a status')); 
    }*/

    public static testMethod void testCustomerResponsibleRole()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Customer_Responsible_Role__c = 'testValue';
        update get2one;
        String role = UTIL_OrgSettings.customerResponsibleRole();
        system.assertEquals('testValue', role); 
    }
    
    public static testMethod void testNewCustomerMODFlowRecordTypes()
    {   
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.New_Customer_MOD_Flow_Record_Types__c = 'test1, test2, test3, test4;test5';
        update get2one;
        set<String> devNames = UTIL_OrgSettings.newCustomerMODFlowRecordTypes();
        system.assertEquals(4, devNames.size());
        system.assert(devNames.contains('test1'));  
        system.assert(devNames.contains('test2'));  
        system.assert(devNames.contains('test3'));  
        system.assert(devNames.contains('test4;test5'));    
    }
    
    public static testMethod void testNewCustomerMainFlowRecordTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.New_Customer_Main_Flow_Record_Types__c = 'test1, test2, test3, test4;test5';
        update get2one;
        set<String> devNames = UTIL_OrgSettings.NewCustomerMainFlowRecordTypes();
        system.assertEquals(4, devNames.size());
        system.assert(devNames.contains('test1'));
        system.assert(devNames.contains('test2'));
        system.assert(devNames.contains('test3'));
        system.assert(devNames.contains('test4;test5'));
    }

    public static testMethod void testNewContactMainFlowRecordTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.New_Contact_Main_Flow_Record_Types__c = 'test1, test2, test3, test4;test5';
        update get2one;
        set<String> devNames = UTIL_OrgSettings.NewContactMainFlowRecordTypes();
        system.assertEquals(4, devNames.size());
        system.assert(devNames.contains('test1'));
        system.assert(devNames.contains('test2'));
        system.assert(devNames.contains('test3'));
        system.assert(devNames.contains('test4;test5'));
    }
        
    public static testMethod void testLead_Receiver_Account_Team_Role()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.lead_Receiver_Account_Team_Role__c = 'testValue';
        update get2one;
        String role = UTIL_OrgSettings.lead_Receiver_Account_Team_Role();
        system.assertEquals('testValue', role);
    }
    
    public static testMethod void testLead_Allocated_to_Sales()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Lead_Allocated_to_Sales__c = 'testValue';
        update get2one;
        String lead = UTIL_OrgSettings.lead_Allocated_to_Sales();
        system.assertEquals('testValue', lead);     
    }
    
    public static testMethod void testNTT_locale_values()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.NTT_locale_values__c = 'testValue';
        update get2one;
        String nttLocaleValues = UTIL_OrgSettings.NTT_locale_values();
        system.assertEquals('testValue', nttLocaleValues);  
    }
    
    public static testMethod void testIntegration_Profile_Name()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Integration_Profile_Name__c = 'testName';
        update get2one;
        String integrationProfileName = UTIL_OrgSettings.integration_Profile_Name();
        system.assertEquals('testName', integrationProfileName);    
    }
    
    public static testMethod void testIntegration_CRM_Webservices_Profile_Name()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Integration_CRM_Webservices_Profile_Name__c = 'testName';
        update get2one;
        String integrationProfileName = UTIL_OrgSettings.integration_CRM_Webservices_Profile_Name();
        system.assertEquals('testName', integrationProfileName);    
    }
    
    public static testMethod void testAdministrator_Profile_Name()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Administrator_Profile_Name__c = 'testName';
        update get2one;
        String administratorProfileName = UTIL_OrgSettings.administrator_Profile_Name();
        system.assertEquals('testName', administratorProfileName);
    }
    
    public static testMethod void testWebshop_B2B_Name()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Webshop_B2B_Name__c = 'testName';
        update get2one;
        String B2BName = UTIL_OrgSettings.webshop_B2B_Name();
        system.assertEquals('testName', B2BName);
    }
    
    public static testMethod void testWebshop_B2C_Name()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Webshop_B2C_Name__c = 'testName';
        update get2one;
        String B2CName = UTIL_OrgSettings.webshop_B2C_Name();
        system.assertEquals('testName', B2CName);
    }
    
    public static testMethod void testWebshop_Origin()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Webshop_Origin__c = 'testName';
        update get2one;
        String ExternalSourceName = UTIL_OrgSettings.webshop_Origin();
        system.assertEquals('testName', ExternalSourceName);
    }
    
    public static testMethod void testContactName_StructuredCommunication()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.ContactName_StructuredCommunication__c = 'testName';
        update get2one;
        String ExternalSourceName = UTIL_OrgSettings.contactName_StructuredCommunication();
        system.assertEquals('testName', ExternalSourceName);
    }
    
    public static testMethod void testEventActivityCompletedDateTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.eventActivityCompletedDateTypes__c = 'test1,test2,test3,test4;test5';
        update get2one;
        set<String> EventTypes = UTIL_OrgSettings.eventActivityCompletedDateTypes();
        system.assertEquals(4, EventTypes.size());
        system.assert(EventTypes.contains('test1'));
        system.assert(EventTypes.contains('test2'));
        system.assert(EventTypes.contains('test3'));
        system.assert(EventTypes.contains('test4;test5'));
    }
    
    public static testMethod void testTaskActivityCompletedDateTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.taskActivityCompletedDateTypes__c = 'test1,test2,test3,test4;test5';
        update get2one;
        set<String> TaskTypes = UTIL_OrgSettings.taskActivityCompletedDateTypes();
        system.assertEquals(4, TaskTypes.size());
        system.assert(TaskTypes.contains('test1'));
        system.assert(TaskTypes.contains('test2'));
        system.assert(TaskTypes.contains('test3'));
        system.assert(TaskTypes.contains('test4;test5'));
    }
    
    public static testMethod void testTaskActivityDateTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.taskActivityDateTypes__c = 'test1,test2,test3,test4;test5';
        update get2one;
        set<String> TaskTypes = UTIL_OrgSettings.taskActivityDateTypes();
        system.assertEquals(4, TaskTypes.size());
        system.assert(TaskTypes.contains('test1'));
        system.assert(TaskTypes.contains('test2'));
        system.assert(TaskTypes.contains('test3'));
        system.assert(TaskTypes.contains('test4;test5'));
    }
    
    public static testMethod void testTaskNextCallListDateTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.taskNextCallListDateTypes__c = 'test1,test2,test3,test4;test5';
        update get2one;
        set<String> TaskTypes = UTIL_OrgSettings.taskNextCallListDateTypes();
        system.assertEquals(4, TaskTypes.size());
        system.assert(TaskTypes.contains('test1'));
        system.assert(TaskTypes.contains('test2'));
        system.assert(TaskTypes.contains('test3'));
        system.assert(TaskTypes.contains('test4;test5'));
    }
    
    public static testMethod void testTaskNotReachedCounterTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.taskNotReachedCounterTypes__c = 'test1,test2,test3,test4;test5';
        update get2one;
        set<String> TaskTypes = UTIL_OrgSettings.taskNotReachedCounterTypes();
        system.assertEquals(4, TaskTypes.size());
        system.assert(TaskTypes.contains('test1'));
        system.assert(TaskTypes.contains('test2'));
        system.assert(TaskTypes.contains('test3'));
        system.assert(TaskTypes.contains('test4;test5'));
    }
    
    public static testMethod void testAccountBatchHeapLimit()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.AccountBatchHeapLimit__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.accountBatchHeapLimit());  
    }
    
    public static testMethod void testAccountBatchDmlRowsLimit()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.AccountBatchDmlRowsLimit__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.AccountBatchDmlRowsLimit());           
    }
    
    public static testMethod void testAccountBatchJobInterval()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.AccountBatchJobInterval__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.AccountBatchJobInterval());    
    }
    
    public static testMethod void accountBatchJobSize()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.AccountBatchJobSize__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.accountBatchJobSize());    
    }
    
    public static testMethod void testAccountTeamMemberSyncSuccessTime()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        DateTime insertedTime = DateTime.now();
        scheduledJobParameters.AccountTeamMemberSyncSuccessTime__c = insertedTime;
        update scheduledJobParameters;
        system.assertEquals(insertedTime, UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime()); 
    }
    
    public static testMethod void testDeletionJobId(){  
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.deletionJobId__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.DeletionJobId());  
    }
    
    public static testMethod void testAccountTeamMemberSyncJobId(){ 
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.AccountTeamMemberSyncJobId__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.AccountTeamMemberSyncJobId()); 
    }
        
    public static testMethod void testApexCalloutLogDeletion()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.apexCalloutLogDeletionActive__c = true;
        update scheduledJobParameters;
        system.assertEquals(true, UTIL_OrgSettings.ApexCalloutLogDeletion());   
    }
    
    public static testMethod void testApexCalloutLogGraceperiod()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.apexCalloutLogGraceperiod__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.ApexCalloutLogGraceperiod());  

    }
    
    public static testMethod void testApexErrorLogDeletion()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.apexErrorLogDeletionActive__c = true;
        update scheduledJobParameters;
        system.assertEquals(true, UTIL_OrgSettings.ApexErrorLogDeletion()); 
    }


    public static testMethod void testApexErrorLogGraceperiod()
    {
        UTIL_TestFactory.setUpOrg();
        ScheduledJobParameters__c scheduledJobParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.apexErrorLogGraceperiod__c = 'testName';
        update scheduledJobParameters;
        system.assertEquals('testName', UTIL_OrgSettings.ApexErrorLogGraceperiod());    
    }
                            
    public static testMethod void testSwedishSalesAreas()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Swedish_Sales_Areas__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.swedishSalesAreas());
    }
    
    public static testMethod void testWorkSiteTypeHQ()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Work_Site_Type_HQ__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.workSiteTypeHQ());    
    }
    
    public static testMethod void testLeadStatus()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Lead_Status__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.leadStatus());    
    }
    
    public static testMethod void testLeadSalesAreaSAPcodes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Lead_Sales_Area_SAP_codes__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.leadSalesAreaSAPcodes());    
    }
    
    public static testMethod void testCaseRecordTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Case_RecordTypes__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.CaseRecordTypes());    
    }
    
    public static testMethod void testNTTSearchRecordTypes()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.NTT_Search_RecordTypes__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.NTTSearchRecordTypes());    
    }
    
    public static testMethod void testSalesUserProfileName()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Sales_User_Profile_Name__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.SalesUserProfileName());    
    }
    
    public static testMethod void testContactPersonTypefromPAR()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Contact_Person_Type_from_PAR__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.ContactPersonTypefromPAR());    
    }
    
    public static testMethod void testContactPersonTypefromLeadConvert()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Contact_Person_Type_from_LeadConvert__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.ContactPersonTypefromLeadConvert());    
    }
    
    public static testMethod void testNewCustomerMODFlowRegCountry()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.New_Customer_MOD_Flow_Reg_Country__c = 'te';
        update get2one;
        system.assertEquals('te', UTIL_OrgSettings.NewCustomerMODFlowRegCountry());    
    }
    
    public static testMethod void testNewCustomerMODFlowWSType()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.New_Customer_MOD_Flow_WS_Type__c = 'test';
        update get2one;
        system.assertEquals('test', UTIL_OrgSettings.NewCustomerMODFlowWSType());    
    }
    
    public static testMethod void testOBMStressDashboardCaptcha()
    {
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.OBM_Stress_Dashboard_Captcha__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.OBMStressDashboardCaptcha());    
    }
    
    public static testMethod void testRelationshipTypePayer()
	{
        UTIL_TestFactory.setUpOrg();
        Get2OneCRM__c get2one = Get2OneCRM__c.getOrgDefaults();
        get2one.Relationship_Type_Payer__c = 'testName';
        update get2one;
        system.assertEquals('testName', UTIL_OrgSettings.RelationshipTypePayer());    
    }
    
    static void createCustomerServiceProductMapping(){
        list<CustomerServiceProductMapping__c> cspm = new list<CustomerServiceProductMapping__c>();
        cspm.add(new CustomerServiceProductMapping__c(name = 'test1',Product2Field__c = 'testProd1'));
        cspm.add(new CustomerServiceProductMapping__c(name = 'test2',Product2Field__c = 'testProd2'));
        cspm.add(new CustomerServiceProductMapping__c(name = 'test3',Product2Field__c = 'testProd3'));
        upsert cspm;
    }
    
    static void createSAPGetPrices(){
        list<SAPGetPrices__c> sgp = new list<SAPGetPrices__c>();
        sgp.add(new SAPGetPrices__c(name = 'test1',Include_Prices_PickVal__c = 'ipp1'));
        sgp.add(new SAPGetPrices__c(name = 'test2',Include_Prices_PickVal__c = 'ipp2'));
        sgp.add(new SAPGetPrices__c(name = 'test3',Include_Prices_PickVal__c = 'ipp3'));
        upsert sgp;
    }

    static void createGenericURLHacking(){
        list<GenericURLHacking__c> guh = new list<GenericURLHacking__c>();
        guh.add(new GenericURLHacking__c(name = 'test1',Default_Value__c = 'def1', Feature_Name__c = 'Account', URL_Field_Id__c = 'testURL1'));
        guh.add(new GenericURLHacking__c(name = 'test2',Default_Value__c = 'def2', Feature_Name__c = 'Account', URL_Field_Id__c = 'testURL2'));
        guh.add(new GenericURLHacking__c(name = 'test3',Default_Value__c = 'def3', Feature_Name__c = 'Account', URL_Field_Id__c = 'testURL3'));
        upsert guh;
    }

    static void createSalesAreaToSegmentMapping(){
        list<SalesAreaToSegmentMapping__c> satsm = new list<SalesAreaToSegmentMapping__c>();
        satsm.add(new SalesAreaToSegmentMapping__c(name = 'test1',Interval__c = 'interval1', SalesArea__c = 'salesarea1', SubSegment__c = 'subsegment1', TopSegment__c = 'topsegment1'));
        satsm.add(new SalesAreaToSegmentMapping__c(name = 'test2',Interval__c = 'interval2', SalesArea__c = 'salesarea2', SubSegment__c = 'subsegment2', TopSegment__c = 'topsegment2'));
        satsm.add(new SalesAreaToSegmentMapping__c(name = 'test3',Interval__c = 'interval3', SalesArea__c = 'salesarea3', SubSegment__c = 'subsegment3', TopSegment__c = 'topsegment3'));
        upsert satsm;
    }

    static void createSalesAreaToFieldMapping(){
        list<SalesAreaToFieldMapping__c> satfm = new list<SalesAreaToFieldMapping__c>();
        satfm.add(new SalesAreaToFieldMapping__c(name = 'test1',
                                                Custom_Call_Interval__c = 'customcallinterval1', 
                                                Custom_Call_Interval_Value__c = 'intervalvalue1', 
                                                MaxNumber__c = 'maxnumber1', 
                                                Next_Call_List_Date__c = 'nextcalllistdate1', 
                                                Not_Reached_Counter__c = 'notreachedcounter1', 
                                                SubSegment__c = 'subsegment1', 
                                                TopSegment__c = 'topsegment1'));
        satfm.add(new SalesAreaToFieldMapping__c(name = 'test2',
                                                Custom_Call_Interval__c = 'customcallinterval2', 
                                                Custom_Call_Interval_Value__c = 'intervalvalue2', 
                                                MaxNumber__c = 'maxnumber2', 
                                                Next_Call_List_Date__c = 'nextcalllistdate2', 
                                                Not_Reached_Counter__c = 'notreachedcounter2', 
                                                SubSegment__c = 'subsegment2', 
                                                TopSegment__c = 'topsegment2'));
        satfm.add(new SalesAreaToFieldMapping__c(name = 'test3',
                                                Custom_Call_Interval__c = 'customcallinterval3', 
                                                Custom_Call_Interval_Value__c = 'intervalvalue3', 
                                                MaxNumber__c = 'maxnumber3', 
                                                Next_Call_List_Date__c = 'nextcalllistdate3', 
                                                Not_Reached_Counter__c = 'notreachedcounter3', 
                                                SubSegment__c = 'subsegment3', 
                                                TopSegment__c = 'topsegment3'));
        upsert satfm;
    }
                
    static void createLeadSalesArea(){
        list<Lead_Sales_Area__c> leadSalesArea = new list<Lead_Sales_Area__c>();
        leadSalesArea.add(new Lead_Sales_Area__c(name = 'test1',Text_value__c = 'textValue1'));
        leadSalesArea.add(new Lead_Sales_Area__c(name = 'test2',Text_value__c = 'textValue2'));
        leadSalesArea.add(new Lead_Sales_Area__c(name = 'test3',Text_value__c = 'textValue3'));
        upsert leadSalesArea;
    }
    
    static void createCintSOAPIntegrationSettings(){
        CINT_SOAP_Integration_Settings__c cintSettings= CINT_SOAP_Integration_Settings__c.getOrgDefaults();
        cintSettings.CINT_Custom_Error_Code__c = 'CINTcustomErrorCode';
        cintSettings.CINT_Custom_Error_Description__c = 'CINTcustomErrorDesc';
        cintSettings.SOAP_Error_Code__c = 'SOAPErrorCode';
        cintSettings.SOAP_Error_Description__c = 'SOAPErrorDesc';
        upsert cintSettings;
    }

    static void createAccountTeamMemberToAccountMapping(){
        list<AccountTeamMemberToAccountMapping__c> AccountTeamMemberToAccountMappings = new list<AccountTeamMemberToAccountMapping__c>();
        AccountTeamMemberToAccountMappings.add(new AccountTeamMemberToAccountMapping__c(name = 'test1',Account_Team_Member_Role__c = 'atmRole1',DestinationField__c = 'destination1',SourceField__c = 'source1'));
        AccountTeamMemberToAccountMappings.add(new AccountTeamMemberToAccountMapping__c(name = 'test2',Account_Team_Member_Role__c = 'atmRole2',DestinationField__c = 'destination2',SourceField__c = 'source2'));
        AccountTeamMemberToAccountMappings.add(new AccountTeamMemberToAccountMapping__c(name = 'test3',Account_Team_Member_Role__c = 'atmRole3',DestinationField__c = 'destination3',SourceField__c = 'source3'));
        upsert AccountTeamMemberToAccountMappings;
    }   

    static void createAccountTeamMemberRolesToSync(){
        list<AccountTeamMemberRolesToSync__c> AccountTeamMemberToAccountMappings = new list<AccountTeamMemberRolesToSync__c>();
        AccountTeamMemberToAccountMappings.add(new AccountTeamMemberRolesToSync__c(name = 'test1'));
        AccountTeamMemberToAccountMappings.add(new AccountTeamMemberRolesToSync__c(name = 'test2'));
        AccountTeamMemberToAccountMappings.add(new AccountTeamMemberRolesToSync__c(name = 'test3'));
        upsert AccountTeamMemberToAccountMappings;
    }
    
    static void createAccountTeamMemberBatchErrorList(){
        list<AccountTeamMemberBatchErrorList__c> AccountTeamMemberBatchErrorLists = new list<AccountTeamMemberBatchErrorList__c>();
        AccountTeamMemberBatchErrorLists.add(new AccountTeamMemberBatchErrorList__c(name = 'test1',AccountID__c = 'accountId1',ErrorTime__c = DateTime.now().addDays(1)));
        AccountTeamMemberBatchErrorLists.add(new AccountTeamMemberBatchErrorList__c(name = 'test2',AccountID__c = 'accountId2',ErrorTime__c = DateTime.now().addDays(2)));
        AccountTeamMemberBatchErrorLists.add(new AccountTeamMemberBatchErrorList__c(name = 'test3',AccountID__c = 'accountId3',ErrorTime__c = DateTime.now().addDays(3)));
        upsert AccountTeamMemberBatchErrorLists;
    }   

    static void createDisableAutomation(){
        DisableAutomation__c disableAutomation = DisableAutomation__c.getOrgDefaults();
        disableAutomation.Disable_All_Non_OBM_Workflows__c = true;
        disableAutomation.Disable_All_OBM_Workflows__c = true;
        disableAutomation.Disable_All_Triggers__c = true;
        disableAutomation.Suppress_AccountTeamMemberSync_Job__c = true;
        disableAutomation.Suppress_Deletion_Job__c = true;
        upsert disableAutomation;
    }   
        
    /**** CustomerServiceProductMapping__c Custom Settings ****/
    public static testMethod void testCustomerServiceProductMapping(){      
        createCustomerServiceProductMapping();
        list<CustomerServiceProductMapping__c> customerMapping = UTIL_OrgSettings.customerServiceProductMapping();
        system.assertEquals(3, customerMapping.size());
        system.assertEquals('test1', customerMapping[0].name);
        system.assertEquals('testProd1', customerMapping[0].Product2Field__c);      
        system.assertEquals('test2', customerMapping[1].name);
        system.assertEquals('testProd2', customerMapping[1].Product2Field__c);
        system.assertEquals('test3', customerMapping[2].name);
        system.assertEquals('testProd3', customerMapping[2].Product2Field__c);
    }
    
    /**** SAPGetPrices__c Custom Settings ****/
    public static testMethod void testSAPGetPrices(){
        createSAPGetPrices();
        map<String,SAPGetPrices__c> customerMapping = UTIL_OrgSettings.SAPGetPrices();
        system.assertEquals(3, customerMapping.keySet().size());
        system.assertEquals('ipp1', customerMapping.get('test1').Include_Prices_PickVal__c);        
        system.assertEquals('ipp2', customerMapping.get('test2').Include_Prices_PickVal__c);
        system.assertEquals('ipp3', customerMapping.get('test3').Include_Prices_PickVal__c);        
    }
    
    /**** GenericURLHacking__c Custom Settings ****/
    public static testMethod void testGenericURLHacking(){
        createGenericURLHacking();
        list<GenericURLHacking__c> urlHacking = UTIL_OrgSettings.genericURLHacking();
        system.assertEquals(3, urlHacking.size());
        system.assertEquals('test1', urlHacking[0].name);
        system.assertEquals('Account', urlHacking[0].Feature_Name__c);
        system.assertEquals('testURL1', urlHacking[0].URL_Field_Id__c);
        system.assertEquals('def1', urlHacking[0].Default_Value__c);

        system.assertEquals('test2', urlHacking[1].name);
        system.assertEquals('Account', urlHacking[1].Feature_Name__c);
        system.assertEquals('testURL2', urlHacking[1].URL_Field_Id__c);
        system.assertEquals('def2', urlHacking[1].Default_Value__c);

        system.assertEquals('test3', urlHacking[2].name);
        system.assertEquals('Account', urlHacking[2].Feature_Name__c);
        system.assertEquals('testURL3', urlHacking[2].URL_Field_Id__c);
        system.assertEquals('def3', urlHacking[2].Default_Value__c);
    }

    public static testMethod void testGenericURLHackingWithParameter(){
        createGenericURLHacking();
        Map<String, GenericURLHacking__c> urlHacking = UTIL_OrgSettings.GenericURLHacking('Account');
        system.assertEquals(3, urlHacking.size());
        system.assertEquals('testURL1', urlHacking.get('test1').URL_Field_Id__c);
        system.assertEquals('def1', urlHacking.get('test1').Default_Value__c);

        system.assertEquals('testURL2', urlHacking.get('test2').URL_Field_Id__c);
        system.assertEquals('def2', urlHacking.get('test2').Default_Value__c);

        system.assertEquals('testURL3', urlHacking.get('test3').URL_Field_Id__c);
        system.assertEquals('def3', urlHacking.get('test3').Default_Value__c);
    }
    
    /**** SalesAreaToSegmentMapping__c Custom Settings ****/
    public static testMethod void testSalesAreaToSegmentMapping(){
        
        createSalesAreaToSegmentMapping();
        list<SalesAreaToSegmentMapping__c> SalesAreaSegmentMapping = UTIL_OrgSettings.salesAreaToSegmentMapping();
        system.assertEquals(3, SalesAreaSegmentMapping.size());
        system.assertEquals('test1', SalesAreaSegmentMapping[0].name);
        system.assertEquals('interval1', SalesAreaSegmentMapping[0].Interval__c);
        system.assertEquals('salesarea1', SalesAreaSegmentMapping[0].SalesArea__c);
        system.assertEquals('subsegment1', SalesAreaSegmentMapping[0].SubSegment__c);
        system.assertEquals('topsegment1', SalesAreaSegmentMapping[0].TopSegment__c);

        system.assertEquals('test2', SalesAreaSegmentMapping[1].name);
        system.assertEquals('interval2', SalesAreaSegmentMapping[1].Interval__c);
        system.assertEquals('salesarea2', SalesAreaSegmentMapping[1].SalesArea__c);
        system.assertEquals('subsegment2', SalesAreaSegmentMapping[1].SubSegment__c);
        system.assertEquals('topsegment2', SalesAreaSegmentMapping[1].TopSegment__c);

        system.assertEquals('test3', SalesAreaSegmentMapping[2].name);
        system.assertEquals('interval3', SalesAreaSegmentMapping[2].Interval__c);
        system.assertEquals('salesarea3', SalesAreaSegmentMapping[2].SalesArea__c);
        system.assertEquals('subsegment3', SalesAreaSegmentMapping[2].SubSegment__c);
        system.assertEquals('topsegment3', SalesAreaSegmentMapping[2].TopSegment__c);
    }
    
    /**** SalesAreaToFieldMapping__c Custom Settings ****/
    public static testMethod void testSalesAreaToFieldMapping(){
                                                
        createSalesAreaToFieldMapping();
        Map<String, SalesAreaToFieldMapping__c> salesAreaFieldMapping = UTIL_OrgSettings.salesAreaToFieldMapping();
        system.assertEquals(3, salesAreaFieldMapping.size());
        system.assertEquals('customcallinterval1', salesAreaFieldMapping.get('test1').Custom_Call_Interval__c);
        system.assertEquals('intervalvalue1', salesAreaFieldMapping.get('test1').Custom_Call_Interval_Value__c);
        system.assertEquals('maxnumber1', salesAreaFieldMapping.get('test1').MaxNumber__c);
        system.assertEquals('nextcalllistdate1', salesAreaFieldMapping.get('test1').Next_Call_List_Date__c);
        system.assertEquals('notreachedcounter1', salesAreaFieldMapping.get('test1').Not_Reached_Counter__c);
        system.assertEquals('subsegment1', salesAreaFieldMapping.get('test1').SubSegment__c);
        system.assertEquals('topsegment1', salesAreaFieldMapping.get('test1').TopSegment__c);

        system.assertEquals('customcallinterval2', salesAreaFieldMapping.get('test2').Custom_Call_Interval__c);
        system.assertEquals('intervalvalue2', salesAreaFieldMapping.get('test2').Custom_Call_Interval_Value__c);
        system.assertEquals('maxnumber2', salesAreaFieldMapping.get('test2').MaxNumber__c);
        system.assertEquals('nextcalllistdate2', salesAreaFieldMapping.get('test2').Next_Call_List_Date__c);
        system.assertEquals('notreachedcounter2', salesAreaFieldMapping.get('test2').Not_Reached_Counter__c);
        system.assertEquals('subsegment2', salesAreaFieldMapping.get('test2').SubSegment__c);
        system.assertEquals('topsegment2', salesAreaFieldMapping.get('test2').TopSegment__c);

        system.assertEquals('customcallinterval3', salesAreaFieldMapping.get('test3').Custom_Call_Interval__c);
        system.assertEquals('intervalvalue3', salesAreaFieldMapping.get('test3').Custom_Call_Interval_Value__c);
        system.assertEquals('maxnumber3', salesAreaFieldMapping.get('test3').MaxNumber__c);
        system.assertEquals('nextcalllistdate3', salesAreaFieldMapping.get('test3').Next_Call_List_Date__c);
        system.assertEquals('notreachedcounter3', salesAreaFieldMapping.get('test3').Not_Reached_Counter__c);
        system.assertEquals('subsegment3', salesAreaFieldMapping.get('test3').SubSegment__c);
        system.assertEquals('topsegment3', salesAreaFieldMapping.get('test3').TopSegment__c);
    }
    
    /**** Lead Sales Area ****/
    public static testMethod void testGetSalesAreaTextValue(){
        createLeadSalesArea();
        String returnValue = UTIL_OrgSettings.getSalesAreaTextValue('test1');
        system.assertEquals('textValue1', returnValue);

        returnValue = UTIL_OrgSettings.getSalesAreaTextValue('test2');
        system.assertEquals('textValue2', returnValue);
        
        returnValue = UTIL_OrgSettings.getSalesAreaTextValue('test3');
        system.assertEquals('textValue3', returnValue);

        returnValue = UTIL_OrgSettings.getSalesAreaTextValue('nonesense');
        system.assertEquals('', returnValue);
    }
       
    public static testMethod void testCINTCustomErrorCode()
    {
        createCintSOAPIntegrationSettings();
        system.assertEquals('CINTcustomErrorCode',UTIL_OrgSettings.CINTCustomErrorCode());
    }
    public static testMethod void testCINTCustomErrorDescription()
    {
        createCintSOAPIntegrationSettings();
        system.assertEquals('CINTcustomErrorDesc',UTIL_OrgSettings.CINTCustomErrorDescription());
    }
    public static testMethod void testSOAPErrorDescription()
    {
        createCintSOAPIntegrationSettings();
        system.assertEquals('SOAPErrorDesc',UTIL_OrgSettings.SOAPErrorDescription());

    }
    public static testMethod void SOAPErrorCode()
    {
        createCintSOAPIntegrationSettings();
        system.assertEquals('SOAPErrorCode',UTIL_OrgSettings.SOAPErrorCode());
    }
        
    /**** AccountTeamMemberToAccountMapping__c Custom Settings ****/
    public static testMethod void testAccountTeamMemberToAccountMapping(){

        createAccountTeamMemberToAccountMapping();
        Map<String, AccountTeamMemberToAccountMapping__c> AccountTeamMemberToAccountMapping = UTIL_OrgSettings.AccountTeamMemberToAccountMapping();
        system.assertEquals(3, AccountTeamMemberToAccountMapping.size());
        system.assertEquals('atmRole1', AccountTeamMemberToAccountMapping.get('test1').Account_Team_Member_Role__c);
        system.assertEquals('destination1', AccountTeamMemberToAccountMapping.get('test1').DestinationField__c);
        system.assertEquals('source1', AccountTeamMemberToAccountMapping.get('test1').SourceField__c);

        system.assertEquals('atmRole2', AccountTeamMemberToAccountMapping.get('test2').Account_Team_Member_Role__c);
        system.assertEquals('destination2', AccountTeamMemberToAccountMapping.get('test2').DestinationField__c);
        system.assertEquals('source2', AccountTeamMemberToAccountMapping.get('test2').SourceField__c);

        system.assertEquals('atmRole3', AccountTeamMemberToAccountMapping.get('test3').Account_Team_Member_Role__c);
        system.assertEquals('destination3', AccountTeamMemberToAccountMapping.get('test3').DestinationField__c);
        system.assertEquals('source3', AccountTeamMemberToAccountMapping.get('test3').SourceField__c);
    }
    public static testMethod void testAccountTeamMemberToAccountMapping_ByRole(){
        // Ensure account team members are listed by Role
        createAccountTeamMemberToAccountMapping();
        Map<String, AccountTeamMemberToAccountMapping__c[]> accountTeamMemberToAccountMappingByRole = UTIL_OrgSettings.AccountTeamMemberToAccountMapping_ByRole();
        system.assertEquals(3, accountTeamMemberToAccountMappingByRole.size()); // 3 roles inserted
        for (String key : accountTeamMemberToAccountMappingByRole.keySet())
        {
            for (AccountTeamMemberToAccountMapping__c atm : accountTeamMemberToAccountMappingByRole.get(key))
            {
                system.assertEquals(key, atm.Account_Team_Member_Role__c);
            }
        }
    }



    /**** AccountTeamMemberToAccountMapping__c Custom Settings ****/
    public static testMethod void AccountTeamMemberRolesToSync(){

        createAccountTeamMemberRolesToSync();
        Map<String, AccountTeamMemberRolesToSync__c> AccountTeamMemberRolesToSync = UTIL_OrgSettings.AccountTeamMemberRolesToSync();
        system.assertEquals(3, AccountTeamMemberRolesToSync.size());
        system.assertNotEquals(null, AccountTeamMemberRolesToSync.get('test1'));
        system.assertNotEquals(null, AccountTeamMemberRolesToSync.get('test2'));
        system.assertNotEquals(null, AccountTeamMemberRolesToSync.get('test3'));
        
    }

    /**** AccountTeamMemberBatchErrorList__c Custom Settings ****/
    public static testMethod void AccountTeamMemberBatchErrorList(){
        createAccountTeamMemberBatchErrorList();
        Map<String, AccountTeamMemberBatchErrorList__c> AccountTeamMemberToAccountMapping = UTIL_OrgSettings.AccountTeamMemberBatchErrorList();
        system.assertEquals(3, AccountTeamMemberToAccountMapping.size());
        system.assertEquals('accountId1', AccountTeamMemberToAccountMapping.get('test1').AccountID__c);
        system.assertEquals(DateTime.now().addDays(1).day(), AccountTeamMemberToAccountMapping.get('test1').ErrorTime__c.day());

        system.assertEquals('accountId2', AccountTeamMemberToAccountMapping.get('test2').AccountID__c);
        system.assertEquals(DateTime.now().addDays(2).day(), AccountTeamMemberToAccountMapping.get('test2').ErrorTime__c.day());

        system.assertEquals('accountId3', AccountTeamMemberToAccountMapping.get('test3').AccountID__c);
        system.assertEquals(DateTime.now().addDays(3).day(), AccountTeamMemberToAccountMapping.get('test3').ErrorTime__c.day());
    }   
    
    /**DisableAutomation__c Custom Settings ****/
    public static testMethod void testIsTriggersDisabled(){
        createDisableAutomation();
        system.assertEquals(true, UTIL_OrgSettings.isTriggersDisabled());
    }
    
    public static testMethod void testIsNonOBMWorkflowsDisabled(){
        createDisableAutomation();
        system.assertEquals(true, UTIL_OrgSettings.isNonOBMWorkflowsDisabled());
    }
    
    public static testMethod void testIsOBMWorkflowsDisabled(){
        createDisableAutomation();
        system.assertEquals(true, UTIL_OrgSettings.isOBMWorkflowsDisabled());
    }        
    
    public static testMethod void testIsAccountTeamMemberSyncJobDisabled(){     
        createDisableAutomation();
        system.assertEquals(true, UTIL_OrgSettings.isAccountTeamMemberSyncJobDisabled());
    }   
    
    public static testMethod void testIsDeletionJobDisabled(){      
        createDisableAutomation();
        system.assertEquals(true, UTIL_OrgSettings.isDeletionJobDisabled());
    }  
}