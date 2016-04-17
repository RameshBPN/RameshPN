/**
    About
    -----
    Description: Class for Relationship__c Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
     1. Validate that the Sales area on inserted Relationship__c are present on both M-D Account and related Account.
     2. Validate that only one Payer per Sales Area on an Account is inserted
     
    Update History
    --------------
    Created August 2013 - K.E.A.J.
    
    Issues / TODOs
    --------------  
*/
public with sharing class G2O_Relationship_SVC {
    
    // Checks that the Sales Area defined on the relationship is present on both M-D Account
    // And lookup Account, throws an error to the user if this is not the case.
    public static void validateSalesAreaOnRelationship(list<Relationship__c> relationshipList){
        System.Debug(logginglevel.info,'*** START: G2O_Relationship_SVC.validateSalesAreaOnRelationship');
        
        list<id> relevantAccounts = new list<id>();
        string invoiceRecipientRT = UTIL_Meta.getAccountInvoiceRecipientRT();
        // There is no check for null on the Sales_Area__c field on relationship since it is a required field
        for(Relationship__c relationship : relationshipList){       
            relevantAccounts.add(relationship.Account__c);
            relevantAccounts.add(relationship.Related_Account__c);
        }
        
        list<Sales_Area_Information__c> salesAreaInformationList = [SELECT id, Account__c, Sales_Area__c FROM Sales_Area_Information__c WHERE Account__c IN :relevantAccounts AND Type__c = 'Customer' LIMIT 50000];
        
        
        map<id,Account> accountMap = new map<id,Account>([SELECT id, recordTypeId from Account WHERE id IN :relevantAccounts LIMIT 50000]);
        
        for(Relationship__c relationship : relationshipList){
            Boolean mdSalesAreaInformationPresent = false;
            Boolean relationSalesAreaInformationPresent = false;

            // If the record type of the account is an Invoice Recipient a SAI is not needed
            if(accountMap.get(relationship.account__c).recordTypeId == invoiceRecipientRT){
            	mdSalesAreaInformationPresent = true;
            }
            if(accountMap.get(relationship.Related_Account__c).recordTypeId == invoiceRecipientRT 
            	|| relationship.Relationship_Type__c == 'Customers Customer' 
            	|| relationship.Relationship_Type__c == 'Customer by Partner'){
            	relationSalesAreaInformationPresent = true;
            }

            for(Sales_Area_Information__c salesAreaInformation : salesAreaInformationList){
                if(salesAreaInformation.account__c == relationship.Account__c 
                    && salesAreaInformation.Sales_Area__c == relationship.Sales_Area__c){
                    mdSalesAreaInformationPresent = true;
                }
                if(salesAreaInformation.account__c == relationship.Related_Account__c 
                    && salesAreaInformation.Sales_Area__c == relationship.Sales_Area__c){
                    relationSalesAreaInformationPresent = true;
                }
            }
            
            //If one or more SAI are missing, give the appropiate error
            if(!mdSalesAreaInformationPresent && !relationSalesAreaInformationPresent){
                relationship.addError(Label.Selected_Sales_Area_is_not_present_on_either_account);
            }else if(!mdSalesAreaInformationPresent){
                relationship.addError(Label.New_Relation_Sales_Area_doesn_t_match_Master_Accounts);
            }else if(!relationSalesAreaInformationPresent){
                relationship.addError(Label.New_Relation_Sales_Area_doesn_t_match_Detail_Accounts);
            }
        }
        System.Debug(logginglevel.info,'*** END: G2O_Relationship_SVC.validateSalesAreaOnRelationship');  
    }
    
    //This method will throw an error if the user tries to add a payer to a sales area where there already exists a payer on that sales area
    public static void validateOnlyOnePayerPerSalesArea(Set<Relationship__c> newPayerRelationshipsList) {
    	System.Debug(logginglevel.info,'*** START: G2O_Relationship_SVC.validateOnlyOnePayerPerSalesArea');
    	
    			
    	//Create a set of the account Ids that are connected to the relationships that are going to be inserted
    	set<Id> payerAccountIds = new set<Id>();
    	for (Relationship__c payer : newPayerRelationshipsList) {
    		payerAccountIds.add(payer.Account__c);
    	}
    	
    	//Get all the payers that exist on the accounts being inserted
    	list<Relationship__c> existingPayers = [SELECT Id, Account__c, Relationship_Type__c, Sales_Area__c, Distribution_Channel__c, Division__c FROM Relationship__c 
    														WHERE Account__c IN: payerAccountIds AND Relationship_Type__c =: UTIL_OrgSettings.RelationshipTypePayer()];
    	
    	for (Relationship__c newPayer : newPayerRelationshipsList) {
    		//First make sure no duplicates of Account-SalesArea-DistributionChannel-Division and Relationship Type Payer are inserted
    		for (Relationship__c otherInsertedPayer : newPayerRelationshipsList) {
    			if (newPayer != otherInsertedPayer &&
					newPayer.Account__c == otherInsertedPayer.Account__c &&
					newPayer.Sales_Area__c == otherInsertedPayer.Sales_Area__c &&
					newPayer.Distribution_Channel__c == otherInsertedPayer.Distribution_Channel__c &&
					newPayer.Division__c == otherInsertedPayer.Division__c) 
				{
					//Give an error to the duplicate payers
					otherInsertedPayer.addError(Label.Only_One_Payer_Per_Sales_Area);
					//Remove the duplicate payers from the list that is checked for duplicates since it is a duplicate and it will already give an error
					newPayerRelationshipsList.remove(otherInsertedPayer);
				}
			}
			
			//Add error to payers being inserted where there already is an payer on the sales area
			for (Relationship__c existingPayer : existingPayers) {
    			if (newPayer.Account__c == existingPayer.Account__c &&
					newPayer.Sales_Area__c == existingPayer.Sales_Area__c &&
					newPayer.Distribution_Channel__c == existingPayer.Distribution_Channel__c &&
					newPayer.Division__c == existingPayer.Division__c) 
				{
					newPayer.addError(Label.Only_One_Payer_Per_Sales_Area);
				}
    		}
		}

    	System.Debug(logginglevel.info,'*** END: G2O_Relationship_SVC.validateOnlyOnePayerPerSalesArea'); 
    }
}