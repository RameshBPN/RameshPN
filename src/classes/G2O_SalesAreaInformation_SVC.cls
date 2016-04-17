/**
    About
    -----
    Description: Service class for General Sales_Area_Information__c Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Sep 2013
    
    Details
    -------
    The trigger service class will reflect updates/inserts on G2O_Sales_Area_Information__c Obj.
     1.  
     2.  
     
    Update History
    --------------
    Created Sep 2013 - A.B.

    Issues / TODOs
    -------------- 
*/

public with sharing class G2O_SalesAreaInformation_SVC {
    
    public static Boolean doNotCreateSAIOnLE = false;
    public static Boolean doNotCreateSAIOnWS = false;

    
    /*1. Create new SAI record (copy of record created on LE) for all child Accounts of Legal Entity that have record type Work Site provided 
    that a SAI record containing a matching Sales_Area__c doesn’t not already exist for the Work Site.*/ 
    public static void copySalesAreaInformationFromLEOnWS(Set<Sales_Area_Information__c> newSAIRecords){
        
        Integer timeBefore = Limits.getCpuTime();
        system.debug('+++createSalesAreaInformationOnWS++'+newSAIRecords);
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
        
        Map<Id,List<Sales_Area_Information__c>> accIdToSAIListMap = new Map<Id,List<Sales_Area_Information__c>>();  //Holds accountId To related Sales Area Information Mapping.
        Map<Id,Set<Id>> lEIdToWSIdsMap = new Map<Id,Set<Id>>();                         //Holds LE Id To WS Id Mapping.
        Map<Id,Set<String>> wsIdToSaleAreaMap = new Map<Id,Set<String>>();              //Holds WS Id To Sales Area Mapping.
        Set<Id> wsIdSet = new Set<Id>();                                                //Holds WS Ids
        List<Sales_Area_Information__c> saiList = new List<Sales_Area_Information__c>();
        
        //Creating Account Id to the List of SAI records Mapping.
        for (Sales_Area_Information__c sai : newSAIRecords) {
                
                if(accIdToSAIListMap.containsKey(sai.Account__c)){ 
                    accIdToSAIListMap.get(sai.Account__c).add(sai);                 
                }else{
                    accIdToSAIListMap.put(sai.Account__c,new List<Sales_Area_Information__c> {sai});
                }
        }
        
        //Getting the WS related to LE's. 
        for(Account acc: [Select a.RecordTypeId, a.Parent.RecordTypeId, a.Parent.Id, a.ParentId, a.Id 
                          From Account a
                          WHERE a.ParentId IN:accIdToSAIListMap.keySet() AND a.Parent.RecordTypeId =:legalEntityRT AND a.RecordTypeId =:workSiteRT ]){
            
            wsIdSet.add(acc.Id);
            
            if(lEIdToWSIdsMap.containsKey(acc.Parent.Id)){   //Creating Account Id to the List of SAI records Mapping.
                lEIdToWSIdsMap.get(acc.Parent.Id).add(acc.Id);
            }else{
                lEIdToWSIdsMap.put(acc.Parent.Id,new Set<Id> {acc.Id});
            }
        }
        
        system.debug('+++lEIdToWSIdsMap1++++'+lEIdToWSIdsMap);
        //Getting the Sales Area Information related to WS.
        for(Sales_Area_Information__c sai: [Select s.Sales_Area__c, s.Account__r.ParentId, s.Account__c 
                                            From Sales_Area_Information__c s
                                            WHERE s.Account__c IN:wsIdSet]){
            
            if(wsIdToSaleAreaMap.containsKey(sai.Account__c)){   //Creating WS Id to the Set of related Sales Area.
                wsIdToSaleAreaMap.get(sai.Account__c).add(sai.Sales_Area__c);
            }else{
                wsIdToSaleAreaMap.put(sai.Account__c,new Set<String> {sai.Sales_Area__c});
            }
        }
        
        system.debug('+++wsIdToSaleAreaMap1++++'+wsIdToSaleAreaMap);
        //Creating copy of SAI record present on LE to its related WS only if no SAI record with the same Sales Area exist on WS.
        for(Id le: lEIdToWSIdsMap.keySet()){
            
            for(Id ws: lEIdToWSIdsMap.get(le)){
                
                if(accIdToSAIListMap.containsKey(le)){
                    
                    for(Sales_Area_Information__c sai: accIdToSAIListMap.get(le)){
                        system.debug('++++sai.Sales_Area__c1+++'+sai.Sales_Area__c);
                        if(wsIdToSaleAreaMap.containsKey(ws)){
                            
                            system.debug('++++sai.Sales_Area__c2+++'+sai.Sales_Area__c);
                            if(!wsIdToSaleAreaMap.get(ws).contains(sai.Sales_Area__c)){
                                //Create a SAI for this WS same as that of LE.
                                saiList.add(copySaleAreaInformation(sai,ws));
                            }
                            
                        }else{
                            system.debug('++++sai.Sales_Area__c3+++'+sai.Sales_Area__c);
                            //Create a SAI for this WS same as that of LE.
                            saiList.add(copySaleAreaInformation(sai,ws));
                        }
                    }
                }
            }

        }
        system.debug('+++saiList+++'+saiList);
        if(!saiList.isEmpty())doNotCreateSAIOnLE = true;    //This prevents LE's related to this WS get updated,thus prevents recursion.
        insert saiList;
        System.debug(Logginglevel.ERROR, 'CPU Time Used copySalesAreaInformationFromLEOnWS: ' + (Limits.getCpuTime() - timeBefore));
    }
    
    /*2. Creates new SAI record (copy of record created on WS) for the parent account (Legal Entity) of the Work Site provided that a 
      SAI record containing the Sales Area doesn’t not already exist on the Legal Entity.
      NOTE : If WS does not have a parent account, no action is required 
    */
    public static void copySalesAreaInformationFromWSOnLE(Set<Sales_Area_Information__c> newSAIRecords){
        Integer timeBefore = Limits.getCpuTime();
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
        
        Map<Id,List<Sales_Area_Information__c>> accIdToSAIListMap = new Map<Id,List<Sales_Area_Information__c>>();  //Holds accountId To related Sales Area Information Mapping.
        Map<Id,Set<Id>> leIdToWsIdsMap = new Map<Id,Set<Id>>();                         //Holds LE Id To WS Id Mapping.
        Map<Id,Set<String>> leIdToSaleAreaMap = new Map<Id,Set<String>>();              //Holds WS Id To Sales Area Mapping.
        
        Set<Id> leIdSet = new Set<Id>();                                                //Holds LE Ids
        Set<String> salesAreaCheckedSet = new Set<String>();
                                    
        List<Sales_Area_Information__c> saiList = new List<Sales_Area_Information__c>();
        
        
        //Creating Account Id to the List of SAI records Mapping.
        for (Sales_Area_Information__c sai : newSAIRecords) {
                
                if(accIdToSAIListMap.containsKey(sai.Account__c)){ 
                    accIdToSAIListMap.get(sai.Account__c).add(sai);                 
                }else{
                    accIdToSAIListMap.put(sai.Account__c,new List<Sales_Area_Information__c> {sai});
                }
        }
        
        //Getting the WS related to LE's. 
        for(Account acc: [Select a.RecordTypeId, a.Parent.RecordTypeId, a.Parent.Id, a.ParentId, a.Id 
                          From Account a
                          WHERE a.Id IN:accIdToSAIListMap.keySet() AND a.Parent.RecordTypeId =:legalEntityRT AND a.RecordTypeId =:workSiteRT ]){
            
            leIdSet.add(acc.Parent.Id);
            
            if(leIdToWsIdsMap.containsKey(acc.Parent.Id)){   
                leIdToWsIdsMap.get(acc.Parent.Id).add(acc.Id);
            }else{
                leIdToWsIdsMap.put(acc.Parent.Id,new Set<Id> {acc.Id});
            }
        }
        
        //Getting the Sales Area Information related to LE's.
        for(Sales_Area_Information__c sai: [Select s.Sales_Area__c, s.Account__r.ParentId, s.Account__c 
                                            From Sales_Area_Information__c s
                                            WHERE s.Account__c IN:leIdSet]){
            
            if(leIdToSaleAreaMap.containsKey(sai.Account__c)){                      //Creating LE Id to the Set of related Sales Area.
                leIdToSaleAreaMap.get(sai.Account__c).add(sai.Sales_Area__c);
            }else{
                leIdToSaleAreaMap.put(sai.Account__c,new Set<String> {sai.Sales_Area__c});
            }
        }
        
        for(Id le: leIdToWsIdsMap.keySet()){
            
            for(Id ws: leIdToWsIdsMap.get(le)){
                
                for(Sales_Area_Information__c sai: accIdToSAIListMap.get(ws)){
                    
                    String key = String.ValueOf(le) + String.ValueOf(sai.Sales_Area__c);
                    
                    if(leIdToSaleAreaMap.containsKey(le)){
                                               
                        if(!leIdToSaleAreaMap.get(le).contains(sai.Sales_Area__c) && !salesAreaCheckedSet.contains(key)){
                            
                            /*Adding the Sales Area to a set for which a SAI is created on LE, as LE may be related to different WS assoicated to same sales area.
                            Thus preventing multiple SAI creation on LE with the same Sales Area.*/
                            salesAreaCheckedSet.add(key);
                            
                            system.debug(Logginglevel.INFO,'77++sai+++'+sai);
                            system.debug(Logginglevel.INFO,'77++le+++'+le);
                            //Create a SAI for this LE same as that of WS.
                            saiList.add(copySaleAreaInformation(sai,le));
                        }
                        
                    }else if(!salesAreaCheckedSet.contains(key)){
                        
                        /*Adding the Sales Area to a set for which a SAI is created on LE, as LE may be related to different WS assoicated to same sales area.
                        Thus preventing multiple SAI creation on LE with the same Sales Area.*/
                        salesAreaCheckedSet.add(key);
                        
                        //Create a SAI for this LE same as that of WS if LE don't have any Sales Area Information.
                        saiList.add(copySaleAreaInformation(sai,le));
                    }
                    
                }
                
            }
        }
        system.debug(Logginglevel.INFO,'77++saiList+++'+saiList);
        if(!saiList.isEmpty()){
            doNotCreateSAIOnWS = true;          //This prevents all other Work Sites in this hierarchy(related to thi LE) to get updated.
        }
        insert saiList;
        System.debug(Logginglevel.ERROR, 'CPU Time Used copySalesAreaInformationFromWSOnLE: ' + (Limits.getCpuTime() - timeBefore));
    }
    
    
    /*3. Synchronises a selected number of fields between the worksites sales area information 
        and the LE parents sales area information*/ 
    public static void syncSalesAreaInformationOnWS(list<Sales_Area_Information__c> newSAIList){
    	Integer timeBefore = Limits.getCpuTime();
        System.debug(LoggingLevel.info,'@@ Synching Sales area fields from LE to WS');
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();

        map<Id,list<Sales_Area_Information__c>> accIdToSAIListMap = new map<Id,list<Sales_Area_Information__c>>();  //Holds accountId To related Sales Area Information Mapping.
        map<Id,list<Sales_Area_Information__c>> wsIdToSAIListMap = new map<Id,list<Sales_Area_Information__c>>();               //Holds WS Id To Sales Area Mapping.
        set<Id> wsIdSet = new set<Id>();                                                //Holds WS Ids
        list<Sales_Area_Information__c> SAIsToUpdate = new list<Sales_Area_Information__c>();
        map<Id,set<Id>> lEIdToWSIdsMap = new map<Id,set<Id>>();                         //Holds LE Id To WS Id Mapping.

        //Creating Account Id to the List of SAI records Mapping.               
        for(Sales_Area_Information__c SAI : newSAIList){    
            if(accIdToSAIListMap.containsKey(sai.Account__c)){ 
                accIdToSAIListMap.get(sai.Account__c).add(sai);                 
            }
            else{
                accIdToSAIListMap.put(sai.Account__c,new List<Sales_Area_Information__c> {sai});
            }
        }
        
        //Getting the WS related to LE's. 
        for(Account acc : [Select RecordTypeId, Parent.RecordTypeId, Parent.Id, ParentId, Id 
                          From Account
                          WHERE ParentId IN:accIdToSAIListMap.keySet() AND Parent.RecordTypeId =:legalEntityRT AND RecordTypeId =:workSiteRT ]){
            
            wsIdSet.add(acc.Id);
            
            if(lEIdToWSIdsMap.containsKey(acc.Parent.Id)){   
                lEIdToWSIdsMap.get(acc.Parent.Id).add(acc.Id);
            }else{
                lEIdToWSIdsMap.put(acc.Parent.Id,new Set<Id> {acc.Id});
            }
        }
        
        //Getting the Sales Area Information related to WS.
        for(Sales_Area_Information__c SAI : [Select Sales_Area__c, Account__r.ParentId, Account__c 
                                            From Sales_Area_Information__c 
                                            WHERE Account__c IN:wsIdSet]){
            
            if(wsIdToSAIListMap.containsKey(SAI.Account__c)){   //Creating WS Id to the Set of related Sales Area.
                wsIdToSAIListMap.get(SAI.Account__c).add(SAI);
            }else{
                wsIdToSAIListMap.put(SAI.Account__c,new list<Sales_Area_Information__c> {SAI});
            }
        }
        
        for(Sales_Area_Information__c parentSAI : newSAIList){
            if(lEIdToWSIdsMap.get(parentSAI.account__c) != null){
                for(id childAccountId : lEIdToWSIdsMap.get(parentSAI.account__c)){
                    if(wsIdToSAIListMap.get(childAccountId) != null){
                        for(Sales_Area_Information__c childSAI : wsIdToSAIListMap.get(childAccountId)){
                            if(childSAI.Sales_Area__c == parentSAI.Sales_Area__c){
                                childSAI.Sales_Office_Name__c = parentSAI.Sales_Office_Name__c;
                                childSAI.Competitor__c = parentSAI.Competitor__c;
                                childSAI.Sales_Group_Name__c = parentSAI.Sales_Group_Name__c;
                                childSAI.External_Partner__c = parentSAI.External_Partner__c;
                                childSAI.External_Partner_Type__c = parentSAI.External_Partner_Type__c;
                                SAIsToUpdate.add(childSAI);
                            }
                        }
                    }
                }
            }
        }
        update SAIsToUpdate;
        System.debug(Logginglevel.ERROR, 'CPU Time Used syncSalesAreaInformationOnWS: ' + (Limits.getCpuTime() - timeBefore));
    }

    /*4. Updates LE Sales Area when a WS Sales Area changes type to customer */ 
    public static void syncSalesAreaInformationOnLE(list<Sales_Area_Information__c> newSAIList, map<id,Sales_Area_Information__c> oldSAIMAp){
    	Integer timeBefore = Limits.getCpuTime();
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();

        map<Id,list<Sales_Area_Information__c>> accIdToSAIListMap = new map<Id,list<Sales_Area_Information__c>>();  //Holds accountId To related Sales Area Information Mapping.
        map<Id,list<Sales_Area_Information__c>> wsIdToSAIListMap = new map<Id,list<Sales_Area_Information__c>>();               //Holds WS Id To Sales Area Mapping.
        set<Id> wsIdSet = new set<Id>();    
        set<Id> leIdSet = new set<Id>();
        set<Sales_Area_Information__c> SAIsToUpdate = new set<Sales_Area_Information__c>();
        set<Sales_Area_Information__c> triggerSet = new set<Sales_Area_Information__c>();
        set<id> triggerId = new set<Id>();
        triggerSet.addAll(newSAIList);
        for(Sales_Area_Information__c sai : triggerSet){
        	triggerId.add(sai.id);
        }

        map<Id,set<Id>> wSIdToLEIdsMap = new map<Id,set<Id>>();

        //Creating Account Id to the List of SAI records Mapping.               
        for(Sales_Area_Information__c SAI : newSAIList){    
	        if(SAI.Type__c == 'Customer' && SAI.Type__c != oldSAIMAp.get(SAI.id).Type__c){        	
	            if(wsIdToSAIListMap.containsKey(sai.Account__c)){ 
	                wsIdToSAIListMap.get(sai.Account__c).add(sai);                  
	            }
	            else{
	                wsIdToSAIListMap.put(sai.Account__c,new List<Sales_Area_Information__c> {sai});
	            }
	        }
        }
        
        //Getting the WS related to the SAI. 
        for(Account acc : [Select RecordTypeId, ParentId, Id 
                          From Account
                          WHERE id IN:wsIdToSAIListMap.keySet() AND RecordTypeId =:workSiteRT ]){           
            leIdSet.add(acc.parentId);
            
            if(wSIdToLEIdsMap.containsKey(acc.id)){   
                wSIdToLEIdsMap.get(acc.id).add(acc.parentId);
            }else{
                wSIdToLEIdsMap.put(acc.Id,new Set<Id> {acc.parentId});
            }
        }
        
        //Getting the Sales Area Information related to LE.
        for(Sales_Area_Information__c SAI : [Select Sales_Area__c, Sales_Group_Name__c, Sales_Office_Name__c, Account__c 
                                            From Sales_Area_Information__c 
                                            WHERE Account__c IN:leIdSet]){
            
            if(accIdToSAIListMap.containsKey(SAI.Account__c)){   //Creating WS Id to the Set of related Sales Area.
                accIdToSAIListMap.get(SAI.Account__c).add(SAI);
            }else{
                accIdToSAIListMap.put(SAI.Account__c,new list<Sales_Area_Information__c> {SAI});
            }
        }
        
        for(Sales_Area_Information__c childSAI : newSAIList){
            if(childSAI.Type__c == 'Customer' && childSAI.Type__c != oldSAIMAp.get(childSAI.id).Type__c){
	            if(wSIdToLEIdsMap.get(childSAI.account__c) != null){
	                for(id parentAccountId : wSIdToLEIdsMap.get(childSAI.account__c)){
	                    if(accIdToSAIListMap.get(parentAccountId) != null){
	                        for(Sales_Area_Information__c parentSAI : accIdToSAIListMap.get(parentAccountId)){
	                            if(childSAI.Sales_Area__c == parentSAI.Sales_Area__c){
	                                if(parentSAI.Sales_Office_Name__c != null){
		                                childSAI.Sales_Office_Name__c = parentSAI.Sales_Office_Name__c;                            	
	                                }
	                                if(parentSAI.Sales_Group_Name__c != null){
		                                childSAI.Sales_Group_Name__c = parentSAI.Sales_Group_Name__c;                            	
	                                }
	
	                                if(!triggerId.contains(parentSAI.id)){
	
										
		                                parentSAI.Type__c = childSAI.Type__c;
			                            SAIsToUpdate.add(parentSAI);                    	
	                                }
	                                else{
	                                	for(Sales_Area_Information__c sai : triggerSet){
	                                		if(sai.id == parentSAI.id){
	                                			sai.Type__c = childSAI.Type__c;
	                                		}
	                                	}
	                                }
	                            }
	                        }
	                    }
	                }
	            }
            }
        }
        if(SAIsToUpdate.size() > 0){
	        list<Sales_Area_Information__c> SAIsToUpdateList = new list<Sales_Area_Information__c>();
			SAIsToUpdateList.addAll(SAIsToUpdate);
        	update SAIsToUpdateList;      	
        }
		System.debug(Logginglevel.ERROR, 'CPU Time Used syncSalesAreaInformationOnLE: ' + (Limits.getCpuTime() - timeBefore));
    }
    
    //Creates a copy of the Sales Area Information ,saIToCopy: is the SAI record to be copied, idTo: is the Account Id to which the new SAI has to be associated.
    private static Sales_Area_Information__c copySaleAreaInformation(Sales_Area_Information__c saiToCopy, Id idTo){
        
        Sales_Area_Information__c sai = new Sales_Area_Information__c();
        
        sai = saiToCopy.clone(false, true);
        sai.Account__c = idTo;
        
        return sai;
        
    }
    
    public static void validateExtSAIExistsOnWS(Set <Sales_Area_Information__c> newSAIs) {
    	System.debug(LoggingLevel.info,'*** START: <G2O_SalesAreaInformation_SVC>.<validateExtSAIExistsOnWS>');
    	Integer timeBefore = Limits.getCpuTime();
    	
    	String extensionRT = UTIL_Meta.getAccountExtensionRT();
	
    	//Create a list of all the Account Ids that will be used to query for all of the Extensions
    	List<Id> extensionIds = new List<Id>();
    	for (Sales_Area_Information__c SAI : newSAIs) {
			extensionIds.add(SAI.Account__c);
    	}

    	//Map of all the extension Ids mapped to the extensions
    	Map<id,Account> ExtIdToExtMap = new Map<Id,Account>([SELECT Id, ParentId FROM Account WHERE Id IN: extensionIds AND RecordTypeId =: extensionRT]);
    	
    	//Only run this if there are any extensions returned in the SOQL that are getting all the SAI Accounts since the validation is only valid for extensions
    	if (ExtIdToExtMap.size() > 0) {
	    	//Create a map of the extensions and a list of their SAIs
	    	Map<Account, List<Sales_Area_Information__c>> extensionToSAIListMap = new Map<Account, List<Sales_Area_Information__c>>();
	    	for (Sales_Area_Information__c SAI: newSAIs) {
				if (extensionToSAIListMap.containsKey(ExtIdToExtMap.get(SAI.Account__c))) {
					extensionToSAIListMap.get(ExtIdToExtMap.get(SAI.Account__c)).add(SAI);
				} else {
					extensionToSAIListMap.put(ExtIdToExtMap.get(SAI.Account__c), new List<Sales_Area_Information__c> {SAI});
				}
	    	}
	    	
	    	//Create a map of the extension Id to Parent Id
	    	Map<Id, Id> extIdToWsIdMap = new Map<Id, Id>();
	    	for (Account ext: ExtIdToExtMap.values()) {
				extIdToWsIdMap.put(ext.Id, ext.ParentId);
	    	}
	    	
	    	//Create a map of Work Site Ids and a list of their SAIs
	    	Map<Id, List<Sales_Area_Information__c>> wsIdToSAIListMap = new Map<Id, List<Sales_Area_Information__c>>();
	    	for(Sales_Area_Information__c SAI: [SELECT Id, Account__c, Sales_Area__c FROM Sales_Area_Information__c WHERE Account__c IN: extIdToWsIdMap.values() AND Type__c =: 'Customer']) {
				if (wsIdToSAIListMap.containsKey(SAI.Account__c)) {
					wsIdToSAIListMap.get(SAI.Account__c).add(SAI);
				} else {
					wsIdToSAIListMap.put(SAI.Account__c, new List<Sales_Area_Information__c> {SAI});
				}
	    	}
	    	
	    	//Do the validation
	    	for (Account extension : extensionToSAIListMap.keySet()) {
	    		//For every new SAI on the extension...
	    		for (Sales_Area_Information__c extSAI : extensionToSAIListMap.get(extension)) {
	    			//A boolean that will tell if the SAI exists in the parent WS SAI list or not
	    			Boolean parentWSHoldsCorrespondingSAI = false;
	    			//...check if the corresponding SAI exists on the parent WS SAI list
	    			for (Sales_Area_Information__c wsSAI: wsIdToSAIListMap.get(extIdToWsIdMap.get(extension.Id))) {
	    				if (extSAI.Sales_Area__c == wsSAI.Sales_Area__c) {
	    					parentWSHoldsCorrespondingSAI = true;
	    					//Break the inmost for loop since we have a match
	    					break;
	    				}
	    			}
	    			//Throw an error if the parent WS does not hold a corresponding SAI
	    			if (!parentWSHoldsCorrespondingSAI) {
	    				extSAI.addError(Label.Parent_WS_does_not_have_corresponding_SAI);
	    			}
	    		}
	    	}
    	}
    	
    	System.debug(Logginglevel.ERROR, 'CPU Time Used validateExtSAIExistsOnWS: ' + (Limits.getCpuTime() - timeBefore));
    	System.debug(LoggingLevel.info,'*** END: <G2O_SalesAreaInformation_SVC>.<validateExtSAIExistsOnWS>');
    }
}