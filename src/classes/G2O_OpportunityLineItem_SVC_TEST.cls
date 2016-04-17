/**
    About
    -----
    Description: This class is used to test OpportunityLineItem_SVC and corresponging triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
    See also: Sprint03_MarketoProductField_TEST
    
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------
    
*/
@isTest(seeAllData=true) //Because of Products
private class G2O_OpportunityLineItem_SVC_TEST {
    
    static testMethod void deleteAllProducts () {
        // Arrange    	
    	UTIL_TestFactory.setUpOrg(); 
    	       
        Opportunity opp = UTIL_TestFactory.createOpportunity();
        insert opp;
        PricebookEntry pricebookEntry = UTIL_TestFactory.createPricebookEntry();
        insert pricebookEntry;
        OpportunityLineItem oppLineItem1 = UTIL_TestFactory.createOpportunityLineItem();
        oppLineItem1.OpportunityId = opp.Id;
        oppLineItem1.PricebookEntryId = pricebookEntry.Id;
        OpportunityLineItem oppLineItem2 = UTIL_TestFactory.createOpportunityLineItem();
        oppLineItem2.OpportunityId = opp.Id;
        oppLineItem2.PricebookEntryId = pricebookEntry.Id;
        
        
        
        // Act
        insert oppLineItem1;
        insert oppLineItem2;
        
        Opportunity oppAfterInsert = [SELECT Id, Marketo_Product_CSV__c
                                      FROM Opportunity
                                      WHERE Id = : opp.id
                                      LIMIT 1];
        delete oppLineItem1;
        delete oppLineItem2;
        
        Opportunity oppAfterDelete = [SELECT Id, Marketo_Product_CSV__c
                                      FROM Opportunity
                                      WHERE Id = : opp.id
                                      LIMIT 1];
        
        // Assert
        System.assertEquals('"productName","productName",', oppAfterInsert.Marketo_Product_CSV__c);
        System.assertEquals(true, UTIL_Apex.empty(oppAfterDelete.Marketo_Product_CSV__c));
    }
    
    static testMethod void correctFieldValueOnMassUpdate () {
        // Arrange
    	UTIL_TestFactory.setUpOrg();
    	
        Opportunity opp1 = UTIL_TestFactory.createOpportunity();
        Opportunity opp2 = UTIL_TestFactory.createOpportunity();
        insert opp1;
        insert opp2;
        
        PricebookEntry pricebookEntry = UTIL_TestFactory.createPricebookEntry();
        insert pricebookEntry;
        
        List<OpportunityLineItem> oppLineItemList = new  List<OpportunityLineItem>();
        
        for(Integer i = 0 ; i < 199 ; i++) {
            OpportunityLineItem oppLineItem = UTIL_TestFactory.createOpportunityLineItem();
            if(i<10){
                oppLineItem.OpportunityId = opp1.Id;
            } else  {
                oppLineItem.OpportunityId = opp2.Id;
            }
            oppLineItem.PricebookEntryId = pricebookEntry.Id;
            oppLineItemList.add(oppLineItem);
        }
        
        
        
        // Act
        insert oppLineItemList;
        
        Opportunity oppAfterInsert = [SELECT Id, Marketo_Product_CSV__c
                                      FROM Opportunity
                                      WHERE Id = : opp1.id
                                      LIMIT 1];
        
        // Assert
        System.assertEquals('"productName","productName","productName","productName","productName","productName","productName","productName","productName","productName",', oppAfterInsert.Marketo_Product_CSV__c);
        
    }
}