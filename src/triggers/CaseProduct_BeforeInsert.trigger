/**
    About
    -----
    Description: Before Insert Trigger on CaseProduct__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.Sets isPrimary field on caseproduct when a new caseproduct record is created based on filters.
        2.Calculates Sum_of_Freight__c field on CaseProduct__c.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger CaseProduct_BeforeInsert on CaseProduct__c (before insert) {
    
    Set<CaseProduct__c> newCaseProductsetSumOfFreight = new Set<CaseProduct__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    
	    // Creating Lists and Maps based on filter criteria
	    for(CaseProduct__c a : trigger.new) {
	    	
	        // Filter 2
	        if (a.Include_prices__c != null) {
	            newCaseProductsetSumOfFreight.add(a);
	        }
	    }
	    // Exectue logic in a service class
	
	    // Filter 1
	    G2O_CaseProduct_SVC.setPrimaryProductBeforeInsert(trigger.new);
	    
	    // Filter 2
	    G2O_CaseProduct_SVC.set_SumOfFreight(newCaseProductsetSumOfFreight);
    }
}