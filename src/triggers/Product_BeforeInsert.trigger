/**
    About
    -----
    Description: Before Insert Trigger on Product2
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  Copy records from Product2 to Customer_Service_Product__c when new Product2 records are created. No filter needed.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger Product_BeforeInsert on Product2 (before insert) {
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Execute logic in a service class
	        
	    // Filter 1
	    G2O_Product_SVC.copyProductBeforeInsert(trigger.new,trigger.newMap);
    }
}