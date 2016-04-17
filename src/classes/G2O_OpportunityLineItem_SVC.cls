/**
    About
    -----
    Description: Service class for OpportunityLineItem triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    
    Methods:
    -------
        1. updateMarketoProductField        :   Updates Marketo Product CSV field on related Opportunities
        
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_OpportunityLineItem_SVC {

    public static void updateMarketoProductField (List<OpportunityLineItem> oppLineItems) {
        System.debug(logginglevel.Info, '### START OpportunityLineItem_SVC.updateMarketoProductField ('+oppLineItems+')');
        
        List<Id> opportunityIds = new List<Id>();
        Map<Id, List<OpportunityLineItem>> oppLineItemOppIdMap = new Map<Id, List<OpportunityLineItem>>();
        
        // Creates a list of the Opportunity IDs to update
        for(OpportunityLineItem oppLineItem : oppLineItems) {
            opportunityIds.add(oppLineItem.OpportunityId);
        }
        
        // Loads all the OpportunityLineItem related to all the Opportunitis
        List<OpportunityLineItem> oppLineItemList = [SELECT Id, OpportunityId, Product_hame_hidden__c
                                                     FROM OpportunityLineItem
                                                     WHERE OpportunityId = :opportunityIds];
        
        // Loads all the Opportunitis related to all the OpportunityLineItem                                             
        List<Opportunity> oppList = [SELECT Id, Marketo_Product_CSV__c
                                     FROM Opportunity
                                     WHERE Id = :opportunityIds];
                                     
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(oppList);
        
        // Clear all the values (needed when all the OpportunityLineItem for one Opportunity is deleted)
        for(String oppId : oppMap.keySet()) {
            oppMap.get(oppId).Marketo_Product_CSV__c = '';
        }
        
        update oppMap.values();
        
        // Creates a Map with Opportunity IDs as keys and a list of related OpportunityLineItem as values
        for(OpportunityLineItem oppLineItem : oppLineItemList) {
            if(oppLineItemOppIdMap.containsKey(oppLineItem.OpportunityId)) {
                oppLineItemOppIdMap.get(oppLineItem.OpportunityId).add(oppLineItem);
            } else {
                oppLineItemOppIdMap.put(oppLineItem.OpportunityId, new List<OpportunityLineItem> {oppLineItem});
            }
        }                            
        
        // Loops through alle the OpportunityLineItem and updates the Marketo_Product_CSV__c on the Opportunity                                          
        for(String oppId : oppLineItemOppIdMap.keySet()) {
            String poduktCSV = '';
            for(OpportunityLineItem oppLineItem : oppLineItemOppIdMap.get(oppId)) {
                poduktCSV += '"' + oppLineItem.Product_hame_hidden__c + '",';
            }
            oppMap.get(oppId).Marketo_Product_CSV__c = poduktCSV;
        }
        update oppMap.values();
        
        System.debug(logginglevel.Info, '### END OpportunityLineItem_SVC.updateMarketoProductField');
    }

}