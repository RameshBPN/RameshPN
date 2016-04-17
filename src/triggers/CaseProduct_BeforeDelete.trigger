/**
    About
    -----
    Description: Before Delete Trigger on CaseProduct__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1. Sets the Product-Article on CaseProduct,Also if there is no further caseproduct for the case then update case with blank productArticle & ItemId value.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated July  2013 - A.B.-Refactored
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger CaseProduct_BeforeDelete on CaseProduct__c (before delete) {
    
    CaseProduct__c[] setPrimaryProduct = new CaseProduct__c[]{};
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Creating Lists and Maps based on filter criteria
	    for(CaseProduct__c casPro:trigger.old){
	        
	        //Filter 1
	        If(casPro.IsPrimary__c){
	            setPrimaryProduct.add(casPro);
	        }
	    }
	    // Execute logic in a service class
	    
	    // Filter 1
	    G2O_CaseProduct_SVC.setPrimaryProductBeforeDelete(setPrimaryProduct);
    }
}