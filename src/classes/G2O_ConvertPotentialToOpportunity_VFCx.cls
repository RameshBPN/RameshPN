/**
    About
    -----
    Description: A controller extention to Potential__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    Used to convert a Potensial to an Opportunity
        1. Takes the Potential Id and loads the Potential and related Potential Product Lines
        2. Creates an Opportunity and the related Opportunity Line Items
        3. Updates the Potential
        4. Redirects the new Opportunity page
    
    Methods:
    -------
        1. convertToOpportunity             :   Main methode. Called from buttom
        2. createOpportunity                :   Creates an Opportunity from the Potential
        3. createOpportunityLineItems       :   Creates Opportunity Line Items from the Potential Product Lines
        
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_ConvertPotentialToOpportunity_VFCx {

    private Potential__c potential;
    private Opportunity opportunity = new Opportunity();
    private List<Potential_Product_Line__c> potentialLineList = new List<Potential_Product_Line__c>();
    private List<OpportunityLineItem> opportunityLineList = new List<OpportunityLineItem>();
    
    public G2O_ConvertPotentialToOpportunity_VFCx(ApexPages.StandardController stdController) {
        this.potential = [SELECT Id, Customer__c, Status__c, CurrencyIsoCode, Sales_Area__c
                          FROM Potential__c
                          WHERE Id= :((Potential__c)stdController.getRecord()).Id ];
                          
        // Loads all the related Potential Product Lines
        this.potentialLineList = [SELECT Id, Calculated_Potential__c, Edited_Potential__c, Potential_Header_Record__c, Product__c
                                  FROM Potential_Product_Line__c
                                  WHERE Potential_Header_Record__c = : this.potential.Id];
    }
    
    // Main methode. Called from buttom
    public PageReference convertToOpportunity() {
        System.debug(logginglevel.Info, '### START ConvertPotentialToOpportunity_VFCx.convertToOpportunity()');
        
        try{
            createOpportunity();
    
            potential.Status__c = UTIL_OrgSettings.ConvertPotentialStatus();
            update potential;
            System.debug(logginglevel.Info, '### END ConvertPotentialToOpportunity_VFCx.convertToOpportunity()');
            return redirect('/' + opportunity.Id);
        }
        catch (PotentialException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UTIL_Error.report('ConvertPotentialToOpportunity', e);
            UTIL_Error.writeNow();
            return null;
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
            UTIL_Error.report('ConvertPotentialToOpportunity', e);
            UTIL_Error.writeNow();
            e.setMessage(Label.Error_from_Salesforce);
            return null;
        }
    }
    
    // Creates an Opportunity and Opportunity Line Items from the Potential
    private void createOpportunity() {
        System.debug(logginglevel.Info, '### START ConvertPotentialToOpportunity_VFCx.createOpportunity()');
		
        // Creates a Set of the Product IDs used to limit the PricebookEntry query.      
        Set<Id> pruductIdList = new Set<Id>();
        for(Potential_Product_Line__c ppl : potentialLineList) {
            pruductIdList.add(ppl.Product__c);
        }                    
        
        // Get the id of the pricebook to use. It is stored in custom settings, and based on Sales Area.
        Id priceBookId;
        
        Map<String,SalesAreaPricebookMapping__c> salesAreaPricebookMap = UTIL_OrgSettings.salesAreaPricebookMapping();
        
        for(String salesArea : salesAreaPricebookMap.keySet()) {
        	if(salesArea == potential.Sales_Area__c) {
        		priceBookId = salesAreaPricebookMap.get(salesArea).PricebookId__c;
        		break; // If we found a match, no need to keep looking
        	}
        }
        
        // If no pricebook is found, throw an error.
        if(UTIL_Apex.empty(priceBookId)) throw new PotentialException(System.Label.Error_Message_Potential_Pricebook);
        
        // Loads all the relavant PricebookEntrys
        List<PricebookEntry> pricebookEntryList = [SELECT Id, Pricebook2Id, Product2Id, IsActive
                                                   FROM PricebookEntry
                                                   WHERE Pricebook2Id = :priceBookId
                                                        AND IsActive = true
                                                        AND Product2Id = :pruductIdList
                                                        AND CurrencyIsoCode = :potential.CurrencyIsoCode limit 9999];
         
        // Is not all products is found in the pricebook, throw an error.                                                
        if(pruductIdList.size() != pricebookEntryList.size()) throw new PotentialException(System.Label.Error_Message_Potential_PricebookEntry);
        
        //Map with the Product2Id as key                                   
        Map<Id, PricebookEntry> productIdMap = new Map<Id, PricebookEntry>();
        for(PricebookEntry pricebookEntry : pricebookEntryList) {
            productIdMap.put(pricebookEntry.Product2Id,pricebookEntry);
        }
        
        // Create Opportunity
        opportunity.AccountId       = potential.Customer__c;
        opportunity.Potential__c    = potential.Id;
        opportunity.name            = UTIL_OrgSettings.ConvertPotentialName();
        opportunity.StageName       = UTIL_OrgSettings.ConvertPotentialStageName();
        opportunity.CloseDate       = Date.today().addMonths(UTIL_OrgSettings.ConvertPotentialCloseDate());
        opportunity.CurrencyIsoCode = potential.CurrencyIsoCode;
        
        insert opportunity;
        
        // Create Opportunity Line Items                         
        for(Potential_Product_Line__c ppl : potentialLineList) {
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = opportunity.Id;
            oppLineItem.PricebookEntryId = productIdMap.get(ppl.Product__c).Id;
            
            if(!UTIL_Apex.empty(ppl.Edited_Potential__c)) {
            	oppLineItem.Opportunity_Value__c = ppl.Edited_Potential__c;
            } else {
                oppLineItem.Opportunity_Value__c = ppl.Calculated_Potential__c;
            }
            opportunityLineList.add(oppLineItem);
        }
        insert opportunityLineList;
        System.debug(logginglevel.Info, '### END ConvertPotentialToOpportunity_VFCx.createOpportunity()');      
    }
    
    private PageReference redirect(String url) {
        PageReference pageRef = new PageReference(url);
        pageRef.setRedirect(true);
        return pageRef;
    }
	
	public class PotentialException extends Exception{}
	
}