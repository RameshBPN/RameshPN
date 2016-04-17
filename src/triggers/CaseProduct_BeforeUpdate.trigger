/**
    About
    -----
    Description: Before Update Trigger on CaseProduct__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.Sets isPrimary field on caseproduct when caseproduct record is updated based on filters.
        2.Calculates Sum_of_Freight__c field on CaseProduct__c.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated July  2013 - A.B. - Refactored
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
*/
trigger CaseProduct_BeforeUpdate on CaseProduct__c (before update) {
    
    Set<CaseProduct__c> newCaseProductSetPrimary = new Set<CaseProduct__c>();
    Map<Id,CaseProduct__c> oldCaseProductMapSetPrimary = new Map<Id,CaseProduct__c>();
    Set<CaseProduct__c> newCaseProductsetSumOfFreight = new Set<CaseProduct__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    
	    // Creating Lists and Maps based on filter criteria
	    for(CaseProduct__c a : trigger.new) {
	    	
	        //Filter 1
	        if(a.IsPrimary__c != trigger.oldMap.get(a.Id).IsPrimary__c) {
	            
	            newCaseProductSetPrimary.add(a);
	            oldCaseProductMapSetPrimary.put(a.Id,trigger.oldMap.get(a.Id));
	        }
	        
	        // Filter 2
	        if (true) {
	            newCaseProductsetSumOfFreight.add(a);
	        }
	    	
	    }
	    
	    // Exectue logic in a service class
	        
	    // Filter 1
	    G2O_CaseProduct_SVC.setPrimaryProductBeforeUpdate(newCaseProductSetPrimary,oldCaseProductMapSetPrimary);
	    
	    // Filter 2
	    G2O_CaseProduct_SVC.set_SumOfFreight(newCaseProductsetSumOfFreight);
    }
}