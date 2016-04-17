/**
        About
        -----
        Description: Product Whitespace Test class
        Created for: Postnord Get2OneCRM additional feature work
        Create date: Sept 2014
        
        Details / Methods
        -----------------
                
        Update History
        --------------
        Created Sept 2014 - M.E.
        
        Issues / TODOs
 
 */

@isTest (seeAllData=true)   
private class G2O_ProductWhitespace_VFCx_TEST {
    public static Opportunity[] opps = new Opportunity[]{};
    public static Account acc = new Account();
    public static Account legalEntity = new Account();
    public static List<OpportunityLineItem> oppLineItemList = new  List<OpportunityLineItem>();
    public static Product_Filter_List__c[] pfl = new Product_Filter_List__c[]{};

    static testMethod void testWhitespace(){
        setup();
        Test.startTest();
        opps[0].Total_Contract_Value__c = 1;
        opps[1].Total_Contract_Value__c = 1;
        opps[0].StageName = UTIL_OrgSettings.opportunityStage_ClosedLost();
        opps[1].StageName = UTIL_OrgSettings.opportunityStage_ClosedWon();
        update opps;

        PageReference pageRef = Page.G2O_ProductWhitespace;
        pageRef.getParameters().put('id', acc.Id);
        pageRef.getParameters().put('debug', 'true');
        Test.setCurrentPage(pageRef);
        ApexPages.standardController theController = new ApexPages.standardController(acc);
        G2O_ProductWhitespace_VFCx whitespace = new G2O_ProductWhitespace_VFCx(theController);
        // no assert applied as the debug is only for developers and may be legitimately removed

        // Try to generate using a legal entity (should result in whitespace remaining as null (not set))
        pageRef = Page.G2O_ProductWhitespace;
        pageRef.getParameters().put('id', legalEntity.Id);
        Test.setCurrentPage(pageRef);
        theController = new ApexPages.standardController(legalEntity);
        try
        {
            // This should fail
            whitespace = new G2O_ProductWhitespace_VFCx(theController);
            System.assert(false,'Legal entity should not be able to initialise the page, this is only for work sites');
        } catch (exception e) {
            // This should fail. CONTINUE.
        }
        
        // Now use the worksite and generate the whitespace
        pageRef = Page.G2O_ProductWhitespace;
        pageRef.getParameters().put('id', acc.Id);
        Test.setCurrentPage(pageRef);
        theController = new ApexPages.standardController(acc);
        whitespace = new G2O_ProductWhitespace_VFCx(theController);
        whitespace.theAccount.Whitespace_StartDate__c = Date.today().addMonths(-1);
        whitespace.theAccount.Whitespace_EndDate__c = Date.today().addMonths(1);
        system.assert(whitespace.whitespace != null, 'Could not initialise. Code error.');

        system.assert(whitespace.productFilterList.size()>0, 'Test data error. Product filter list is empty');

        whitespace.showWhitespace();
        system.assert(whitespace.hascounted, 'Page has not counted the visit');

        system.assert(whitespace.whitespace!=null && whitespace.whitespace.size()>0,'White space grid has not picked up the line items created for testing');

		// goback / cancel as well as launching the whitespace
        theController = new ApexPages.standardController(acc);
        whitespace = new G2O_ProductWhitespace_VFCx(theController);
        System.assertEquals(false,whitespace.showResults,'Screen should not be showing the results until the search has executed');
        whitespace.showWhitespace();
        System.assert(whitespace.showResults,'Screen should be showing the results');
        whitespace.goBack();
        System.assertEquals(false,whitespace.showResults,'Screen should not be showing the results after the user hits "previous"');
        whitespace.cancel();
        Test.stopTest();
	}

    static void setUp() {
        // Arrange for a set of oppps and line items to ensure that the stages are correctly grouped and gaps show
        UTIL_TestFactory.setUpOrg();
        
        legalEntity = UTIL_TestFactory.createAccount();
        legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        insert legalEntity;

        System.debug(LoggingLevel.ERROR, '### legalEntity created: '+legalEntity);

        acc = UTIL_TestFactory.createAccount();
        acc.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        acc.ParentId = legalEntity.Id;
        insert acc;

        System.debug(LoggingLevel.ERROR, '### acc created: '+acc);
        
        Opportunity opp = UTIL_TestFactory.createOpportunity();
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();
        insert opp;
       
        Opportunity opp2 = UTIL_TestFactory.createOpportunity();
        opp2.AccountId = acc.Id;
        opp2.CloseDate = Date.today();
        insert opp2;
        
        Opportunity opp3 = UTIL_TestFactory.createOpportunity();
        opp3.AccountId = acc.Id;
        opp3.CloseDate = Date.today();
        insert opp3;

        opps.add(opp);
        opps.add(opp2);
        opps.add(opp3);

        System.debug(LoggingLevel.ERROR, '### opps created: '+opps);

        Product2 product = UTIL_TestFactory.createProduct();
        product.Assortment__c                   =   'Assortment__c';
        product.Business_Area_Name__c           =   'Business_Area_Name__c';
        product.Dummy_Three_ID__c               =   '123456789';
        product.Dummy_Three_Name__c             =   'Dummy_Three_Name__c';
        product.Logistics_Product_Category__c   =   'LogiProductCat';
        product.Logistics_Service_Area__c       =   'Logistics_Ser';
        product.Product_Type__c                 =   'Product_Type__c';
        product.Sales_Area__c                   =   '0123456789';
        product.Name                            =   'Name';
        insert product;
        
        System.debug(LoggingLevel.ERROR, '### product created: '+product);

        PricebookEntry pricebookEntry = UTIL_TestFactory.createPricebookEntry();
        pricebookEntry.Product2Id = product.Id;
        insert pricebookEntry;
        
        System.debug(LoggingLevel.ERROR, '### pricebookEntry created: '+pricebookEntry);

        oppLineItemList = new  List<OpportunityLineItem>();
        for(Integer i = 0; i < 30 ; i ++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            if (i<30) {
                oppLineItem.OpportunityId = opps[0].Id;
                oppLineItem.Product_Family__c = 'family0';
            }
            if (i<20) {
                oppLineItem.OpportunityId = opps[1].Id;
                oppLineItem.Product_Family__c = 'family1';
            }
            if (i<10) {
                oppLineItem.OpportunityId = opps[2].Id;
                oppLineItem.Product_Family__c = 'family2';
            }
            oppLineItem.PricebookEntryId = pricebookEntry.Id;
            oppLineItem.Product_Status__c = 'Won'; // statuses need to be taken from the custom settings
            oppLineItem.Reason_Won__c = 'Price';
            oppLineItemList.add(oppLineItem);
        }
        insert oppLineItemList;

        System.debug(LoggingLevel.ERROR, '### oppLineItemList created: '+oppLineItemList);

        // Product filter list
        pfl = new Product_Filter_List__c[]{};
        for (Integer i = 0; i<3; i++)
        {
            Product_Filter_List__c pf = new Product_Filter_List__c();
            pf.ProductFamily__c = 'family'+i;
            pf.Select__c = true;
            pfl.add(pf);
        }
        insert pfl;

        System.debug(LoggingLevel.ERROR, '### Product filter list created: '+pfl);
    }
	
}