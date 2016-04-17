/**
    About
    -----
    Description: After Insert Trigger on CaseProduct__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  Updates the case with the primary products,product-article field & ItemId.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated July  2013 - A.B. - Refactored
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger CaseProduct_AfterInsert on CaseProduct__c (after insert) {

    CaseProduct__c[] primaryCaseProducts = new CaseProduct__c[]{};
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    
	    // Creating Lists and Maps based on filter criteria
	    for(CaseProduct__c cp:trigger.new){
	        
	        // Filter 1
	        if(cp.IsPrimary__c){
	            primaryCaseProducts.add(cp);
	        }   
	    }
	    
	    // Execute logic in a service class
	    
	    // Filter 1
	    G2O_CaseProduct_SVC.setCaseArticleAfterInsert(primaryCaseProducts);
    }
}