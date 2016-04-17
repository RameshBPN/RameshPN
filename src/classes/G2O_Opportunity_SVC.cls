/**
    About
    -----
    Description: Service class for Opportunity triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    
    Methods:
    -------
        1. createAssets                 :   Creates assets from all the products on the opportunity
        2. updateProductAndQuoteStatus  :   Updates Opportunity Line Items Product status & Quote status depending on Opportunities Stage Name
                                            Quote status updates has been scoped out of the project.
                                                
    Update History
    --------------
    Created March April 2013 - C.H.F.
    Updated May 2013 - R.M.
    
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_Opportunity_SVC {
    
    public static boolean ASSETS_CREATED = false;

    public static void createAssets (List<Opportunity> oppList) {
        System.debug(logginglevel.Info, '### START Opportunity_SVC.createAssets ('+oppList+')');
        
        // Loads all the realted OpportunityLineItem
        List<OpportunityLineItem> oppLineItemList = [SELECT Id, OpportunityId, Product_Status__c, Opportunity.AccountId, PricebookEntry.Product2Id,
                                                     PricebookEntry.Product2.Name, PricebookEntry.Product2.Product_Article_ID__c,
                                                     PricebookEntry.Product2.Product_Type__c, PricebookEntry.Product2.Dummy_Three_ID__c,
                                                     PricebookEntry.Product2.Dummy_Three_Name__c, PricebookEntry.Product2.Sales_Area__c,
                                                     PricebookEntry.Product2.Business_Area_Name__c, PricebookEntry.Product2.Assortment__c,
                                                     PricebookEntry.Product2.Logistics_Product_Category__c, PricebookEntry.Product2.Logistics_Service_Area__c,
                                                     PricebookEntry.Product2.Product_Group__c, PricebookEntry.Product2.Product_Level_4_Name__c
                                                     FROM OpportunityLineItem
                                                     WHERE OpportunityId = :oppList];
        
        List<Asset> assetList = new List<Asset>();
        // Creates assets from all the products on the opportunity                                           
        for(OpportunityLineItem oppLineItem : oppLineItemList) {
            if(oppLineItem.Product_Status__c == 'Won') {
                Asset asset = new Asset();
                
                asset.AccountId                     =   oppLineItem.Opportunity.AccountId;
                asset.Name                          =   oppLineItem.PricebookEntry.Product2.Name;
                asset.Product2Id                    =   oppLineItem.PricebookEntry.Product2.Id;
                asset.Assortment__c                 =   oppLineItem.PricebookEntry.Product2.Assortment__c;
                asset.Business_Area_Name__c         =   oppLineItem.PricebookEntry.Product2.Business_Area_Name__c;
                asset.Dummy_Three_ID__c             =   oppLineItem.PricebookEntry.Product2.Dummy_Three_ID__c;
                asset.Dummy_Three_Name__c           =   oppLineItem.PricebookEntry.Product2.Dummy_Three_Name__c;
                asset.Logistics_Product_Category__c =   oppLineItem.PricebookEntry.Product2.Logistics_Product_Category__c;
                asset.Logistics_Service_Area__c     =   oppLineItem.PricebookEntry.Product2.Logistics_Service_Area__c;
                asset.Opportunity__c                =   oppLineItem.OpportunityId;
                asset.Product_Type__c               =   oppLineItem.PricebookEntry.Product2.Product_Type__c;
                asset.Sales_Area__c                 =   oppLineItem.PricebookEntry.Product2.Sales_Area__c;
                
                assetList.add(asset);
            }
        }
        
        insert assetList;
        
        //Since the assets are already created dont run this again in the same execution context
        ASSETS_CREATED = TRUE;
        
        System.debug(logginglevel.Info, '### END Opportunity_SVC.createAssets');
    }
    
    // When opportunity is set to Closed Won, all related Opp Line Item with product status not lost should be set to Won
    public static void updateProductStatusClosedWon(List<Opportunity> oppList) {
        System.debug(logginglevel.Info, '### START Opportunity_SVC.updateProductStatusClosedWon ('+oppList+')');
        
        List<OpportunityLineItem> oppLineItemListUpdate = new List<OpportunityLineItem>();
        
        // Loads all the realted OpportunityLineItem
        List<OpportunityLineItem> oppLineItemList = [SELECT Id, OpportunityId, Product_Status__c, Opportunity.StageName, Opportunity.AccountId, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Product_Article_ID__c, PricebookEntry.Product2.Product_Type__c, PricebookEntry.Product2.Dummy_Three_ID__c, PricebookEntry.Product2.Dummy_Three_Name__c, PricebookEntry.Product2.Sales_Area__c, PricebookEntry.Product2.Business_Area_Name__c, PricebookEntry.Product2.Assortment__c, PricebookEntry.Product2.Logistics_Product_Category__c, PricebookEntry.Product2.Logistics_Service_Area__c, PricebookEntry.Product2.Product_Group__c, PricebookEntry.Product2.Product_Level_4_Name__c
                                                     FROM OpportunityLineItem
                                                     WHERE OpportunityId IN: oppList limit 50000];
                                                     
        // updates all the Opportunity Line Items with Product Status depending on Opportunity Stage Name
        // StageName : Closed Won - Not Lost to Won
        if(oppLineItemList != null && !oppLineItemList.isEmpty()) {
            for(OpportunityLineItem oppLineItem: oppLineItemList) {
                if(oppLineItem.Product_Status__c != 'Lost') {
                    oppLineItem.Product_Status__c = 'Won';
                    oppLineItemListUpdate.add(oppLineItem);
                }
            }
            
            if(oppLineItemListUpdate != null && !oppLineItemListUpdate.isEmpty()) {
                try {
                    update oppLineItemListUpdate;
                }
                catch(Exception ex) {
                    System.debug(Logginglevel.INFO,'@@ EXCEPTION @@' +String.valueOf(ex));
                }
            }
        }
        System.debug(logginglevel.Info, '### END Opportunity_SVC.updateProductStatusClosedWon');
    }
    
    // When opportunity is set to Closed Lost, all related Opp Line Item with product status not lost should be set to Lost
    public static void updateProductStatusClosedLost(List<Opportunity> oppList) {
        System.debug(logginglevel.Info, '### START Opportunity_SVC.updateProductStatusClosedLost ('+oppList+')');
        
        List<OpportunityLineItem> oppLineItemListUpdate = new List<OpportunityLineItem>();
        List<Quote> quoteListUpdate = new List<Quote>();
        
        // Loads all the related OpportunityLineItem
        List<OpportunityLineItem> oppLineItemList = [SELECT Id, OpportunityId, Product_Status__c, Opportunity.StageName, Opportunity.AccountId, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Product_Article_ID__c, PricebookEntry.Product2.Product_Type__c, PricebookEntry.Product2.Dummy_Three_ID__c, PricebookEntry.Product2.Dummy_Three_Name__c, PricebookEntry.Product2.Sales_Area__c, PricebookEntry.Product2.Business_Area_Name__c, PricebookEntry.Product2.Assortment__c, PricebookEntry.Product2.Logistics_Product_Category__c, PricebookEntry.Product2.Logistics_Service_Area__c, PricebookEntry.Product2.Product_Group__c, PricebookEntry.Product2.Product_Level_4_Name__c
                                                     FROM OpportunityLineItem
                                                     WHERE OpportunityId IN: oppList limit 50000];
        
        System.debug(Logginglevel.INFO,'@@ oppLineItemList @@' +oppLineItemList);                                            
        
        // updates all the Opportunity Line Items with Product Status depending on Opportunity Stage Name
        // StageName : Closed Lost - Not Lost to Lost
        if(oppLineItemList != null && !oppLineItemList.isEmpty()) {
            for(OpportunityLineItem oppLineItem: oppLineItemList) {
                System.debug(Logginglevel.INFO,'@@ oppLineItem.Product_Status__c @@' +oppLineItem.Product_Status__c);
                if(oppLineItem.Product_Status__c != 'Lost') {
                    oppLineItem.Product_Status__c = 'Lost';
                }
                oppLineItemListUpdate.add(oppLineItem);
            }
            
            if(oppLineItemListUpdate != null && !oppLineItemListUpdate.isEmpty()) {
                try {
                    update oppLineItemListUpdate;
                    System.debug(Logginglevel.INFO,'@@ oppLineItemListUpdate @@' +oppLineItemListUpdate);
                }
                catch(Exception ex) {
                    System.debug(Logginglevel.INFO,'@@ EXCEPTION @@' +String.valueOf(ex));
                }
            }
        }
        System.debug(logginglevel.Info, '### END Opportunity_SVC.updateProductStatusClosedLost');
    }
    //When Opportunities StageName changes to Closed Lost/Won,then update HasToResetSalesTeamAndArea flag to true
    public static void updateHasToResetSalesGroupAndOfficeFlag(List<Opportunity> oppList){
         for(Opportunity opp:oppList){
            opp.HasToResetSalesGroupAndOffice__c=true;
         }   
    }
}