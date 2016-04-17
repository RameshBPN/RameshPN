/**
    About
    -----
    Description: Before Update Trigger on Sales_Area_Information__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Sep 2013
    
    Filters:
    -------
        1. Filters: All,No Filter for create SalesArea Information On WS.
        2. Filters: All,No Filter for create SalesArea Information On LE.
        3. Filters: All,No Filter for validation of Sales Area Information on Extension towards Sales Area Information on WS.
        
    Update History
    --------------
    Created Sep 2013 - A.B.
    
    Issues / TODOs
    --------------  
*/
trigger SalesAreaInformation_BeforeInsert on Sales_Area_Information__c (before insert) {
    
    set<Sales_Area_Information__c> createSAIOnWS = new set<Sales_Area_Information__c>();
    set<Sales_Area_Information__c> createSAIOnLE = new set<Sales_Area_Information__c>();
    set<Sales_Area_Information__c> createSAIOnExtForValidation = new set<Sales_Area_Information__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
	    	
	    for (Sales_Area_Information__c sai : trigger.new) {
	        
	        // Filter 1 : All,No Filter for this condition as Account.RecordTypeId can not be accessed in trigger.new.
	        if(!G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS){   //This prevents recursion.
	            createSAIOnWS.add(sai);
	        }
	        
	        // Filter 2 : All,No Filter for this condition as Account.RecordTypeId can not be accessed in trigger.new.
	        
	        if(!G2O_SalesAreaInformation_SVC.doNotCreateSAIOnLE){   //This prevents recursion.
	            createSAIOnLE.add(sai);
	        }
	        
	        // Filter 3 : All,No Filter for this condition as Account.RecordTypeId can not be accessed in trigger.new.
	        createSAIOnExtForValidation.add(sai);
	    }
	    
	    /*1. Create new SAI record (copy of record created on LE) for all child Accounts of Legal Entity that have record type Work Site provided 
	    that a SAI record containing a matching Sales_Area__c doesn’t not already exist for the Work Site.*/ 
	    if(!G2O_SalesAreaInformation_SVC.doNotCreateSAIOnWS){
	    	 system.debug(Logginglevel.INFO,'133++createSAIOnWS+++'+createSAIOnWS);
	        G2O_SalesAreaInformation_SVC.copySalesAreaInformationFromLEOnWS(createSAIOnWS);
	    }
	    /*2. Creates new SAI record (copy of record created on WS) for the parent account (Legal Entity) of the Work Site provided that a 
	      SAI record containing the Sales Area doesn’t not already exist on the Legal Entity.
	      NOTE : If WS does not have a parent account, no action is required 
	    */
	    if(!G2O_SalesAreaInformation_SVC.doNotCreateSAIOnLE){   //This prevents recursion.
	        G2O_SalesAreaInformation_SVC.copySalesAreaInformationFromWSOnLE(createSAIOnLE);
	    }
	    /*3. Validates that a corresponding SAI that will be created on the Extension exists on the parent WS as a Customer SAI
	    */
	    if(createSAIOnExtForValidation.size() > 0){
	        G2O_SalesAreaInformation_SVC.validateExtSAIExistsOnWS(createSAIOnExtForValidation);
	    }
    }
}