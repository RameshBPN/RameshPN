/**
    About
    -----
    Description: This class is used to test Opportunity_SVC and corresponging triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
    
    Update History
    --------------
    Created April 2013 - C.H.F.
    Updated May 2013 - R.M.
    Updated the line numbers 75, 146,186 to address the test failure on the field Total_Contract_Value__c 
    
    Issues / TODOs
    --------------
    
*/
@isTest(seeAllData=true) // Because of Products
private class G2O_Opportunity_SVC_TEST {

    static Account objAcc{get;set;}
    static Opportunity objOpp{get;set;}
    static Product2 productNew{get;set;}
    static PricebookEntry pricebookEntryNew{get;set;}
    static List<OpportunityLineItem> oppLineItemListNew;
    static List<Quote> quoteListNew;

    static testMethod void testMassCreateAssets() {
        // Arrange
       
        UTIL_TestFactory.setUpOrg();
        
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Opportunity opp = UTIL_TestFactory.createOpportunity();
        opp.AccountId = account.Id;
        insert opp;
       
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
        
        PricebookEntry pricebookEntry = UTIL_TestFactory.createPricebookEntry();
        pricebookEntry.Product2Id = product.Id;
        insert pricebookEntry;
        
        List<OpportunityLineItem> oppLineItemList = new  List<OpportunityLineItem>();
        for(Integer i = 0; i < 200 ; i ++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            oppLineItem.OpportunityId = opp.Id;
            oppLineItem.PricebookEntryId = pricebookEntry.Id;
            oppLineItem.Product_Status__c = 'Won';
            oppLineItem.Reason_Won__c = 'Price';
            oppLineItemList.add(oppLineItem);
        }
        insert oppLineItemList;
        
        
        // Act
        Integer numberOfAssetsBeforeUpdate = [SELECT COUNT() FROM Asset WHERE Opportunity__c = :opp.Id];

        opp.StageName       = 'Closed Won';
        opp.Reason_Won__c   = 'Price';
        opp.Total_Contract_Value__c = 12345;
        update opp;
        
        Integer numberOfAssetsWon = [SELECT COUNT() FROM Asset WHERE Opportunity__c = :opp.Id];
        
        // Assert
        System.assertEquals(0, numberOfAssetsBeforeUpdate);
        System.assertEquals(200, numberOfAssetsWon);
    }
    
    public static void init() { 

        UTIL_TestFactory.setUpOrg();
        objAcc = new Account();
        objAcc = UTIL_TestFactory.createAccount();
        insert objAcc;
        
        objOpp = new Opportunity();
        objOpp = UTIL_TestFactory.createOpportunity();
        objOpp.AccountId = objAcc.Id;
        
        productNew = new Product2();
        productNew = UTIL_TestFactory.createProduct();
        productNew.Assortment__c =  'Assortment__c';
        productNew.Business_Area_Name__c = 'Business_Area_Name__c';
        productNew.Dummy_Three_ID__c =  '123456789';
        productNew.Dummy_Three_Name__c  = 'Dummy_Three_Name__c';
        productNew.Logistics_Product_Category__c =  'LogiProductCat';
        productNew.Logistics_Service_Area__c =  'Logistics_Ser';
        productNew.Product_Type__c  = 'Product_Type__c';
        productNew.Sales_Area__c =  '0123456789';
        productNew.Name =   'Name';
        insert productNew;
        
        pricebookEntryNew = UTIL_TestFactory.createPricebookEntry();
        pricebookEntryNew.Product2Id = productNew.Id;
        insert pricebookEntryNew;
     
    }

    static testMethod void updateMassOppLineItemsQuoteStatusToClosedWon() {
        
        // Use Case: All Opportunity Line items & Quote Status is changed.
        
        // Arrange
        init();
        system.debug(logginglevel.warn, '#### Opps being updated pre insert: ' + objOpp);
        insert objOpp;
        system.debug(logginglevel.warn, '#### Opps being updated pre stage change: ' + [select Lead_ID__c, Start_Date__c , closeDate, stagename from opportunity where id = :objOpp.id]);

        objOpp.StageName = 'Negotiate & Close Deal';
        update objOpp;
        
        String oppStageNameBeforeUpdate = objOpp.StageName;
        
        oppLineItemListNew = new  List<OpportunityLineItem>();
        for(Integer i = 0; i < 200 ; i ++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            oppLineItem.OpportunityId = objOpp.Id;
            oppLineItem.PricebookEntryId = pricebookEntryNew.Id;
            oppLineItem.Product_Status__c = 'In progress';
            oppLineItemListNew.add(oppLineItem);
        }
        system.debug(logginglevel.warn, '#### Opps being updated pre OLI insert: ' + [select Lead_ID__c, Start_Date__c , closeDate, stagename from opportunity where id = :objOpp.id]);
        
        insert oppLineItemListNew;
        
        // Act
        Integer noOfOppLineItemsStatusInProgressBefore =  [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'In progress'];
        
        objOpp.StageName = 'Closed Won';
        objOpp.Reason_Won__c = 'Price';
        objOpp.Total_Contract_Value__c = 12345;
        update objOpp;
        
        oppLineItemListNew = [Select Id, Product_status__c from OpportunityLineItem where OpportunityId =:objOpp.Id];
        
        // Assert
        System.assertEquals(oppStageNameBeforeUpdate, 'Negotiate & Close Deal');
        System.assertEquals(200, noOfOppLineItemsStatusInProgressBefore);
        System.assertEquals(objOpp.StageName, 'Closed Won');
        System.assertEquals(oppLineItemListNew[0].Product_status__c, 'Won');
    }
    
    static testMethod void updateMassMixedStatusClosedWon() {
        
        // Arrange
        init();
        objOpp.StageName = 'Negotiate & Close Deal';
        insert objOpp;
        
        String oppStageNameBeforeUpdate = objOpp.StageName;
        
        oppLineItemListNew = new  List<OpportunityLineItem>();
        for(Integer i = 0; i < 200 ; i ++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            oppLineItem.OpportunityId = objOpp.Id;
            oppLineItem.PricebookEntryId = pricebookEntryNew.Id;
            if(i == 0 || i < 100) {
                oppLineItem.Product_Status__c = 'In progress';
            } else {
                oppLineItem.Product_Status__c = 'Lost';
            }
            oppLineItemListNew.add(oppLineItem);
        }
        insert oppLineItemListNew;
        
        // Act
        
        Integer noOfOppLineItemsStatusInProgressBefore =  [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'In progress'];
        
        objOpp.StageName = 'Closed Won';
        objOpp.Reason_Won__c = 'Price';
        objOpp.Total_Contract_Value__c = 12345;
        update objOpp;
        
        oppLineItemListNew = [Select Id, Product_status__c from OpportunityLineItem where OpportunityId =:objOpp.Id];
       
        // Assert
        System.assertEquals(oppStageNameBeforeUpdate, 'Negotiate & Close Deal');
        System.assertEquals(100, noOfOppLineItemsStatusInProgressBefore);
        System.assertEquals(objOpp.StageName, 'Closed Won');
        System.assertEquals(100,[SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'Won']);
        System.assertEquals(0,[SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'In progress']);
        System.assertEquals(100,[SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'Lost']);


    }
    
     static testMethod void updateMassOppLineItemsQuoteStatusToClosedLost() {
        
        // Use Case: All Opportunity Line items & Quote Status is changed.
        
        // Arrange
        init();
        objOpp.StageName = 'Negotiate & Close Deal';
        insert objOpp;
        
        String oppStageNameBeforeUpdate = objOpp.StageName;
        
        oppLineItemListNew = new  List<OpportunityLineItem>();
        for(Integer i = 0; i < 200 ; i ++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            oppLineItem.OpportunityId = objOpp.Id;
            oppLineItem.PricebookEntryId = pricebookEntryNew.Id;
            oppLineItem.Product_Status__c = 'In progress';
            oppLineItemListNew.add(oppLineItem);
        }
        insert oppLineItemListNew;
            
        // Act
        Integer noOfOppLineItemsStatusInProgressBefore =  [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'In progress'];
        
        objOpp.StageName = 'Closed Lost';
        objOpp.Reason_Lost__c = 'Price';
        update objOpp;
        
        oppLineItemListNew = [Select Id, Product_status__c from OpportunityLineItem where OpportunityId =:objOpp.Id];
        
        // Assert
        System.assertEquals(oppStageNameBeforeUpdate, 'Negotiate & Close Deal');
        System.assertEquals(200, noOfOppLineItemsStatusInProgressBefore);
        System.assertEquals(objOpp.StageName, 'Closed Lost');
        System.assertEquals(oppLineItemListNew[0].Product_status__c, 'Lost');
    }

     static testMethod void updateMassOppLineItemsAlreadyLost() {
        
        // Use Case: Opportunity Line items that are already lost should have workflows run on them when the opportunity is closed lost
        // to ensure that their Sales Price is correct.
        
        // Arrange
        init();
        objOpp.StageName = 'Negotiate & Close Deal';
        insert objOpp;
        
        String oppStageNameBeforeUpdate = objOpp.StageName;
        
        oppLineItemListNew = new  List<OpportunityLineItem>();
        for(Integer i = 0; i < 200 ; i ++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            oppLineItem.OpportunityId = objOpp.Id;
            oppLineItem.PricebookEntryId = pricebookEntryNew.Id;
            oppLineItem.Product_Status__c = 'In progress';
            oppLineItem.Opportunity_Value__c = 150;
            oppLineItemListNew.add(oppLineItem);
        }
        insert oppLineItemListNew;
        
        for(OpportunityLineItem oli : oppLineItemListNew){
            oli.Product_Status__c = 'Lost';
            oli.Reason_Lost__c = 'Price';
        }
        update oppLineItemListNew;
        
        oppLineItemListNew = [select id, unitPrice, Opportunity_Value__c, Product_Status__c From OpportunityLineItem WHERE OpportunityId = :objOpp.id];
        for(OpportunityLineItem oli : oppLineItemListNew){
            system.assertEquals('Lost', oli.Product_Status__c);
            system.assertEquals(150, oli.Opportunity_Value__c);
            system.assertEquals(0, oli.unitPrice);
        }    
        
        // Act
        Integer noOfOppLineItemsStatusInProgressBefore =  [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'In progress'];
        
        objOpp.StageName = 'Closed Lost';
        objOpp.Reason_Lost__c = 'Price';
        update objOpp;
        
        oppLineItemListNew = [Select Id, unitPrice, Opportunity_Value__c, Product_status__c from OpportunityLineItem where OpportunityId =:objOpp.Id];
        
        // Assert
        for(OpportunityLineItem oli : oppLineItemListNew){
            system.assertEquals(oli.Opportunity_Value__c, oli.unitPrice);
        } 
    }
        
    static testMethod void updateMassMixedStatusClosedLost() {
        
        // Arrange
        init();
        objOpp.StageName = 'Negotiate & Close Deal';
        insert objOpp;
        
        String oppStageNameBeforeUpdate = objOpp.StageName;
        
        oppLineItemListNew = new  List<OpportunityLineItem>();
        for(Integer i = 0; i < 200 ; i ++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            oppLineItem.OpportunityId = objOpp.Id;
            oppLineItem.PricebookEntryId = pricebookEntryNew.Id;
            if(i == 0 || i < 100) {
                oppLineItem.Product_Status__c = 'In progress';
            } else {
                oppLineItem.Product_Status__c = 'Lost';
            }
            oppLineItemListNew.add(oppLineItem);
        }
        insert oppLineItemListNew;
        
        // Act
        
        Integer noOfOppLineItemsStatusInProgressBefore =  [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId =:objOpp.Id and Product_Status__c =: 'In progress'];
        
        objOpp.StageName = 'Closed Lost';
        objOpp.Reason_Won__c = 'Price';
        update objOpp;
        
        oppLineItemListNew = [Select Id, Product_status__c from OpportunityLineItem where OpportunityId =:objOpp.Id];
        
        // Assert
        System.assertEquals(oppStageNameBeforeUpdate, 'Negotiate & Close Deal');
        System.assertEquals(100, noOfOppLineItemsStatusInProgressBefore);
        System.assertEquals(objOpp.StageName, 'Closed Lost');
        System.assertEquals(oppLineItemListNew[0].Product_status__c, 'Lost');
    }
}