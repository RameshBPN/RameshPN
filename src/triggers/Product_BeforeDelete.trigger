/**
    About
    -----
    Description: Before Delete Trigger on Product2
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Filters:
    -------
        1.  Delete records from Customer_Service_Product__c when a record from  Product2 is deleted. No filter needed.
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  
    
*/
trigger Product_BeforeDelete on Product2 (before delete) {
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    // Execute logic in a service class
	    
	    // Filter 1
	    G2O_Product_SVC.deleteCustomerService(trigger.old);
    }
}