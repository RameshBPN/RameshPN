/**
    About
    -----
    Description: Before Update Trigger on Product2
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  Copy records from Product2 to Customer_Service_Product__c when a  Product2 record is update. No filter needed.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger Product_BeforeUpdate on Product2 (before update) {
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Execute logic in a service class
	    
	    // Filter 1
	    G2O_Product_SVC.copyProductBeforeUpdate(trigger.new,trigger.oldMap);
	    
    }
}