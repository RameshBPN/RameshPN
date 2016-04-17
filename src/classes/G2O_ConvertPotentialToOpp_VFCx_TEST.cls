/**
    About
    -----
    Description: This class is used to test ConvertPotentialToOpportunity_VFCx
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
    1. Tests that a Potential is correctly converted into the appropiate Opportunity.
    2. Tests that all the product lines are added to the Opportunity when the Potential is converted
    
    
    Update History
    --------------
    Created April 2013 - C.H.F.
    Merged Sprint03_ConvertPotentialToOpp_TEST into the class, and added structure - K.E.A.J
    
    Issues / TODOs
    --------------
    
*/
@isTest(seeAllData=true) //Because of Products
private class G2O_ConvertPotentialToOpp_VFCx_TEST {

    // Tests that a Potential is correctly converted into the appropiate Opportunity.
    static testMethod void correctOppCreated() {
        
        // Arrange
        UTIL_TestFactory.setupOrg();
        
        Pricebook2 pricebook = new Pricebook2(Name = 'pricebook', IsActive = true);
        insert pricebook;
        
        Map<String,SalesAreaPricebookMapping__c> mappings = SalesAreaPricebookMapping__c.getAll();
        if(!mappings.isEmpty()) delete mappings.values();
        
        SalesAreaPricebookMapping__c mapping = new SalesAreaPricebookMapping__c();
        mapping.Name = '1000';
        mapping.PricebookId__c = pricebook.Id;
        insert mapping;
        
        Potential__c potential = UTIL_TestFactory.createPotential();
        potential.CurrencyIsoCode = 'SEK';
        potential.RecordTypeId = UTIL_Meta.getBrevePotentialRT();
        potential.Sales_Area__c = '1000';
        insert potential;
        
        PricebookEntry pricebookEntry = UTIL_TestFactory.createPricebookEntry(pricebook.Id);
        insert pricebookEntry;
        
        Potential_Product_Line__c potentialProductLine1 = UTIL_TestFactory.createPotentialProductLine();
        potentialProductLine1.Product__c = pricebookEntry.Product2Id;
        potentialProductLine1.Potential_Header_Record__c = potential.Id;
        potentialProductLine1.Edited_Potential__c = 100;
        insert potentialProductLine1;
        
        Potential_Product_Line__c potentialProductLine2 = UTIL_TestFactory.createPotentialProductLine();
        potentialProductLine2.Product__c = pricebookEntry.Product2Id;
        potentialProductLine2.Potential_Header_Record__c = potential.Id;
        potentialProductLine2.Calculated_Potential__c = 50;
        insert potentialProductLine2;
        
        // Act
        Test.startTest();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(potential);
        G2O_ConvertPotentialToOpportunity_VFCx extensions = new G2O_ConvertPotentialToOpportunity_VFCx(controller);
        
        // The user presses the buttom "Convert to Opportunity" on Potensial page
        PageReference currentPage = extensions.convertToOpportunity();
        
        Test.stopTest();
        
        //Assert
        
        Potential__c potentialAfterConvert = [SELECT Id, Status__c
                                              FROM Potential__c
                                              WHERE Id = :potential.Id];
        
        Opportunity convertedOpportunity = [SELECT Id, AccountId, Potential__c, CloseDate
                                            FROM Opportunity
                                            WHERE Potential__c = :potential.Id];
                                            
        List<OpportunityLineItem> convertedOppLineItems = [SELECT Id, Opportunity_Value__c
                                                           FROM OpportunityLineItem
                                                           WHERE OpportunityId = :convertedOpportunity.Id];                                     
                                            
        PageReference correctPage = new PageReference('/' + convertedOpportunity.Id);
        
        System.assertEquals(correctPage.getURL(), currentPage.getURL(), 'The currentPage should be pointing to the converted Opportunity');
        System.assertEquals(potential.Id, convertedOpportunity.Potential__c, 'The converted Opportunity should have the potential__c it came from in its Potential__c field');
        System.assertEquals(potential.Customer__c, convertedOpportunity.AccountId, 'The Potentials customer should have turned into the Opportunities Account');
        System.assertEquals(2, convertedOppLineItems.size(), 'There should be 2 line items on the Opportunity, there is: ' + convertedOppLineItems.size());
    }
    
    // Tests that all the product lines are added to the Opportunity when the Potential is converted
    static testMethod void testManyPotentialProductLines() {
        // Arrange
        UTIL_TestFactory.setupOrg();
        
        Pricebook2 pricebook = new Pricebook2(Name = 'pricebook', IsActive = true);
        insert pricebook;
        
        Map<String,SalesAreaPricebookMapping__c> mappings = SalesAreaPricebookMapping__c.getAll();
        if(!mappings.isEmpty()) delete mappings.values();
        
        SalesAreaPricebookMapping__c mapping = new SalesAreaPricebookMapping__c();
        mapping.Name = '1000';
        mapping.PricebookId__c = pricebook.Id;
        insert mapping;
        
        Potential__c potential = UTIL_TestFactory.createPotential();
        potential.CurrencyIsoCode = 'SEK';
        potential.RecordTypeId = UTIL_Meta.getBrevePotentialRT();
        potential.Sales_Area__c = '1000';
        insert potential;
        
        PricebookEntry pricebookEntry = UTIL_TestFactory.createPricebookEntry(pricebook.Id);
        insert pricebookEntry;
        
        List<Potential_Product_Line__c> potentialProductLineList = new List<Potential_Product_Line__c>();
        for(Integer i = 0; i < 200 ; i ++) {
            Potential_Product_Line__c potentialProductLine = UTIL_TestFactory.createPotentialProductLine();
            potentialProductLine.Product__c = pricebookEntry.Product2Id;
            potentialProductLine.Potential_Header_Record__c = potential.Id;
            potentialProductLine.Edited_Potential__c = 100;
            
            potentialProductLineList.add(potentialProductLine);
        }
        insert potentialProductLineList;
        
        // Act
        Test.startTest();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(potential);
        G2O_ConvertPotentialToOpportunity_VFCx extensions = new G2O_ConvertPotentialToOpportunity_VFCx(controller);
        
        // The user presses the buttom "Convert to Opportunity" on Potensial page
        PageReference currentPage = extensions.convertToOpportunity();
        
        Test.stopTest();
        
        //Assert
        
        Opportunity convertedOpportunity = [SELECT Id, AccountId, Potential__c
                                            FROM Opportunity
                                            WHERE Potential__c = :potential.Id];
                                            
        List<OpportunityLineItem> convertedOppLineItems = [SELECT Id
                                                           FROM OpportunityLineItem
                                                           WHERE OpportunityId = :convertedOpportunity.Id];                                     
                                            
        PageReference correctPage = new PageReference('/' + convertedOpportunity.Id);
        
        System.assertEquals(correctPage.getURL(), currentPage.getURL(), 'The currentPage should be pointing to the converted Opportunity');
        System.assertEquals(potential.Id, convertedOpportunity.Potential__c, 'The converted Opportunity should have the potential__c it came from in its Potential__c field');
        System.assertEquals(potential.Customer__c, convertedOpportunity.AccountId, 'The Potentials customer should have turned into the Opportunities Account');
        System.assertEquals(200, convertedOppLineItems.size(), 'There should be 200 line items on the Opportunity, there is: ' + convertedOppLineItems.size());
    }
    
	// Tests that correct error handling takes place when a product line is corrupt
    static testMethod void testCorruptProductLine() {
        // Arrange
        UTIL_TestFactory.setupOrg();
        
        Pricebook2 pricebook = new Pricebook2(Name = 'pricebook', IsActive = true);
        insert pricebook;
        
        Map<String,SalesAreaPricebookMapping__c> mappings = SalesAreaPricebookMapping__c.getAll();
        if(!mappings.isEmpty()) delete mappings.values();
        
        SalesAreaPricebookMapping__c mapping = new SalesAreaPricebookMapping__c();
        mapping.Name = '1000';
        mapping.PricebookId__c = pricebook.Id;
        insert mapping;
        
        Potential__c potential = UTIL_TestFactory.createPotential();
        potential.CurrencyIsoCode = 'SEK';
        potential.RecordTypeId = UTIL_Meta.getBrevePotentialRT();
        potential.Sales_Area__c = '1000';
        insert potential;
        
        PricebookEntry pricebookEntry = UTIL_TestFactory.createPricebookEntry(pricebook.Id);
        insert pricebookEntry;
        
        Potential_Product_Line__c potentialProductLine1 = UTIL_TestFactory.createPotentialProductLine();
        potentialProductLine1.Potential_Header_Record__c = potential.Id;
        potentialProductLine1.Edited_Potential__c = 100;
        insert potentialProductLine1;
        
        Potential_Product_Line__c potentialProductLine2 = UTIL_TestFactory.createPotentialProductLine();
        potentialProductLine2.Potential_Header_Record__c = potential.Id;
        potentialProductLine2.Calculated_Potential__c = 50;
        insert potentialProductLine2;
        
        // Act
        Test.startTest();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(potential);
        G2O_ConvertPotentialToOpportunity_VFCx extensions = new G2O_ConvertPotentialToOpportunity_VFCx(controller);
        
        // The user presses the buttom "Convert to Opportunity" on Potential page this is expected to fail
       	PageReference currentPage = extensions.convertToOpportunity();
 
        Test.stopTest();
        
        //Assert
        System.assert(ApexPages.hasMessages(),'Error was not added to the page');
    }
    
}