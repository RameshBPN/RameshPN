/**
    About
    -----
    Description: Service class for General Task Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Details
    -------
    The trigger service class will reflect updates/inserts on Task Obj.
     1. setNextCallListDate - Set Next Call List Date on related account of the task.
     2. setNextCallDate - Sets the next call date on related account record of the task.
     3. setNotReachedCounter - This Method sets the Not_Reached_Counter__c field.
     4. setActivityIndicator - Set activity indicator on Account if the related task is completed within last 14 days.
     5. populateCampaignFields - This method will populate the Related to Campaign and Comments field on the task
     
    Update History
    --------------
    Created June 2013 - A.B.
    --------------  
*/
public with sharing class G2O_Task_SVC {
    
    //A.T.T.R.I.B.U.T.E.S
    static Map<String,List<SalesAreaToSegmentMapping__c>> SalesAreaToSegmentMapping  = new Map<String,List<SalesAreaToSegmentMapping__c>>();    //Sales area To TelesalesInterval custom setting mapping.
    static Map<String,SalesAreaToFieldMapping__c> SalesAreaToFieldMapping = new Map<String,SalesAreaToFieldMapping__c>(); //Holds sales area to task field API mapping.
    static Map<Id,Account> accIdToAccountMap = new Map<Id,Account>();   //Holds accountId To account mapping of the account related to the Task.
    static Set<Id> accIdSet = new Set<Id>();                            //Holds account Ids related to tasks.
    static Integer interval;                                            //Holds interval value based on sales area of task & segment of related account.
    static List<sObject> sObjectList = new List<sObject>();
    
    //A.T.T.R.I.B.U.T.E.S
    
    //1. Set Next Call List Date on related account of the task.
   public static void setNextCallListDate(List<Task> newTaskList){
        
        System.debug(LoggingLevel.info,'*** START: <G2O_Task_SVC>.<setNextCallListDate>');
        
        getAccounts(newTaskList);
        
        for(Task tsk:newTaskList){
            if(tsk.AccountId!=null ){
                sObject accRecord =(sObject)accIdToAccountMap.get(tsk.AccountId);       
                
                //This method calculates the interval & next call list date.
                calculateInterval(accRecord,tsk.Sales_area__c);             
            }
        }
        
        update sObjectList;
        system.debug(Logginglevel.INFO,'+++sObjectList+++'+sObjectList);
        System.debug(LoggingLevel.info,'*** END: <G2O_Task_SVC>.<setNextCallListDate>');
    }
            
        
    //2. Sets the next contact date on related account of the task.
    public static void setActivityDate(List<Task> newTaskList){
        
        System.debug(LoggingLevel.info,'*** START: <G2O_Task_SVC>.<setActivityDate>');
        getAccounts(newTaskList);
        sObject accRecord;
        
        for(Task tsk:newTaskList){
            
            accRecord =(sObject)accIdToAccountMap.get(tsk.AccountId);       
			
            //Get the Next Call List Date based on the Sales Area and populate it with the Activity date.
            String nextCallListDate = SalesAreaToFieldMapping.get(tsk.Sales_area__c).Next_Call_List_Date__c;
            
            accRecord.put(nextCallListDate,(UTIL_Apex.empty(tsk.ActivityDate)? system.Today().addDays(1):tsk.ActivityDate));
            sObjectList.add(accRecord);
        }
        update sObjectList;
        System.debug(LoggingLevel.info,'*** END: <G2O_Task_SVC>.<setActivityDate>');
    }
    
    
    //3. This Method sets the Not_Reached_Counter__c field.
    public static void setNotReachedCounter(List<Task> newTaskList){
        
        System.debug(LoggingLevel.info,'*** START: <G2O_Task_SVC>.<setNotReachedCounter>');
        getAccounts(newTaskList);
        
        system.debug(Logginglevel.INFO,'++knewTaskListk+++'+newTaskList);
        system.debug(Logginglevel.INFO,'+++SalesAreaToFieldMapping1+++'+SalesAreaToFieldMapping);
        
        for(Task tsk:newTaskList){

            if(tsk.AccountId!=null ){
                
                sObject accRecord =(sObject)accIdToAccountMap.get(tsk.AccountId);
                String notReachedCounterField;
                Integer notReachedCounterValue;
                Integer maxNumber;
                
                if(SalesAreaToFieldMapping.containsKey(tsk.Sales_area__c)){ 
                    system.debug(Logginglevel.INFO,'+++tsk.Sales_area__c11+++'+tsk.Sales_area__c);               
                    notReachedCounterField = SalesAreaToFieldMapping.get(tsk.Sales_area__c).Not_Reached_Counter__c;
                    system.debug(Logginglevel.INFO,'++notReachedCounterField11++'+notReachedCounterField);
                    notReachedCounterValue = Integer.ValueOf(UTIL_Apex.empty(accRecord.get(notReachedCounterField))? 0 : accRecord.get(notReachedCounterField));
                    
                    //Get the Max from custom setting
                    maxNumber = Integer.ValueOf(UTIL_Apex.empty(SalesAreaToFieldMapping.get(tsk.Sales_area__c).MaxNumber__c) ? '0' : SalesAreaToFieldMapping.get(tsk.Sales_area__c).MaxNumber__c);
                }
                
                system.debug(Logginglevel.INFO,'+++notReachedCounterValue+++'+notReachedCounterValue);
                system.debug(Logginglevel.INFO,'+++maxNumber+++'+maxNumber);
                
                if(notReachedCounterValue < maxNumber){
                    system.debug(Logginglevel.INFO,'++++++1Insdi+++');
                    notReachedCounterValue = notReachedCounterValue +1;
                    accRecord.put(notReachedCounterField,notReachedCounterValue);
                    sObjectList.add(accRecord);
                    
                }else{
                    system.debug(Logginglevel.INFO,'++INSIDE22+++');
                    //This method calculates the interval & next call list date.
                    calculateInterval(accRecord,tsk.Sales_area__c);
                }
            }
        }
        update sObjectList;
        System.debug(LoggingLevel.info,'*** END: <G2O_Task_SVC>.<setNotReachedCounter>');
    }
    
    
    //4. Set activity indicator on Account if the related task is completed within last 14 days.
    public static void setActivityIndicator(List<Task> newTaskList){
        
        System.debug(LoggingLevel.info,'*** START: <G2O_Task_SVC>.<setActivityIndicator>');
        List<Account> accList = new List<Account>();
		
        getAccounts(newTaskList);
        
        //Setting the Indicator field
        for(Account accRecord : accIdToAccountMap.values()){
            for(Task t : newTaskList) {
            	if(t.AccountId == accRecord.Id) {
            		if(accRecord.ActivityCompletedDate__c == null && t.ActivityDate < Date.today()) {
            			accRecord.ActivityCompletedDate__c = t.ActivityDate;
            		} else if(accRecord.ActivityCompletedDate__c < t.ActivityDate && t.ActivityDate < Date.today()) {
            			accRecord.ActivityCompletedDate__c = t.ActivityDate;
            		} else if(t.ActivityDate >= Date.today()){
            			accRecord.ActivityCompletedDate__c = Date.today();
            		}
            	}
            }
            accList.add(accRecord);
        }
        
        update accList;
        System.debug(LoggingLevel.info,'*** END: <G2O_Task_SVC>.<setActivityIndicator>');
    }
    
    
    //This method populates Telesales_interval__c,SalesAreaToFieldMappingping__c custom settings & gets account related to tasks.
    private static void getAccounts(List<Task> newTaskList){
        
        //Getting SalesArea,Segment mapping from custom setting.
        for(SalesAreaToSegmentMapping__c teleSales:UTIL_OrgSettings.SalesAreaToSegmentMapping()){
            
            if(SalesAreaToSegmentMapping.containsKey(teleSales.SalesArea__c)){
                SalesAreaToSegmentMapping.get(teleSales.SalesArea__c).add(teleSales);
            }else{
                SalesAreaToSegmentMapping.put(teleSales.SalesArea__c,new List<SalesAreaToSegmentMapping__c> {teleSales});
            }
        }
        
        //Getting task fields API names from Custom Setting based on sales area.
        SalesAreaToFieldMapping = UTIL_OrgSettings.SalesAreaToFieldMapping();
        
        //Getting the account Ids related to tasks.
        for(Task tsk:newTaskList){
            
            if(tsk.AccountId!=null){
                accIdSet.add(tsk.AccountId);        //AB. Use Account Id insted of WhatId.
            }
        }
        
        system.debug(Logginglevel.INFO,'++++accIdSet+++'+accIdSet);
        //Getting the account reccords.
        for(Account acc : [Select a.Next_Call_List_Date_PDK_LO__c,a.Next_Call_List_Date_PDK_BE__c, a.Next_Call_List_Date_ME_SE__c, 
                            a.Next_Call_List_Date_LO_SE__c,a.Next_Call_List_Date_LO_NO__c, a.Next_Call_List_Date_LO_FI__c, 
                            a.ActivityCompletedDate__c, a.Next_Call_List_Date_LO_FI_DPD__c,a.Next_Call_List_Date_LO_DK__c,
                            
                            a.PDK_LO_Top_Segment__c,a.PDK_BE_Top_Segment__c,a.ME_SE_Top_Segment__c,
                            a.LO_SE_Top_Segment__c,a.LO_NO_Top_Segment__c,a.LO_FI_Top_Segment__c,
                            a.LO_FI_DPD_Top_Segment__c,a.LO_DK_Top_Segment__c,
                            
                            a.PDK_LO_Sub_Segment__c,a.PDK_BE_Sub_Segment__c,a.ME_SE_Sub_Segment__c,
                            a.LO_SE_Sub_Segment__c,a.LO_NO_Sub_Segment__c,a.LO_FI_Sub_Segment__c,
                            a.LO_FI_DPD_Sub_Segment__c ,a.LO_DK_Sub_Segment__c, 
                             
                            a.Not_reached_counter_PDK_LO__c, a.Not_reached_counter_PDK_BE__c, a.Not_reached_counter_ME_SE__c, 
                            a.Not_reached_counter_LO_SE__c, a.Not_reached_counter_LO_NO__c, a.Not_reached_counter_LO_FI__c, 
                            a.Not_reached_counter_LO_FI_DPD__c, a.Not_reached_counter_LO_DK__c,
                            
                            a.PDK_LO_custom_call_interval__c, a.PDK_BE_custom_call_interval__c, a.ME_SE_custom_call_interval__c,
                            a.LO_SE_custom_call_interval__c, a.LO_NO_custom_call_interval__c,a.LO_FI_custom_call_interval__c,
                            a.LO_FI_DPD_custom_call_interval__c, a.LO_DK_custom_call_interval__c 
                            From Account a Where Id IN:accIdSet ]){
            
            accIdToAccountMap.put(acc.Id,acc);
            system.debug('+++accIdToAccountMap++'+accIdToAccountMap);
        }
    }
    
    //This method calculates the Interval.
    private static void calculateInterval(sObject accRecord,String salesArea){
        
        system.debug(Logginglevel.INFO,'+++SalesAreaToFieldMapping+++'+SalesAreaToFieldMapping);
        system.debug(Logginglevel.INFO,'+++salesArea+++'+salesArea);

        
        //Get the Custom Call Interval,Top & Sub Segment Field Api Name from the CustomSetting.
        String customIntervalField = SalesAreaToFieldMapping.get(salesArea).Custom_Call_Interval__c;    
        String topSegmentField = SalesAreaToFieldMapping.get(salesArea).TopSegment__c;
        String subSegmentField = SalesAreaToFieldMapping.get(salesArea).SubSegment__c;
        Integer customIntervalValue;
        String accTopSegmentValue;
        String accSubSegmentValue;
            
        //Get the Custom Call Interval,Top & Sub Segment Field Value from Account.
        if(!UTIL_Apex.empty(accRecord.get(customIntervalField))){
            customIntervalValue = Integer.ValueOf(accRecord.get(customIntervalField));
        }
        if(!UTIL_Apex.empty(accRecord.get(topSegmentField))){
            accTopSegmentValue = String.ValueOf(accRecord.get(topSegmentField));
        }
        if(!UTIL_Apex.empty(accRecord.get(subSegmentField))){
            accSubSegmentValue = String.ValueOf(accRecord.get(subSegmentField));
        }
        
        //Checking if Custom Call Interval is present on the account.
        if(!UTIL_Apex.empty(customIntervalValue)){
            
            sObjectList.add(calculateNextCallListDate(salesArea,customIntervalValue,accRecord));
            
        }else if(UTIL_Apex.empty(accTopSegmentValue) && SalesAreaToFieldMapping.containsKey(salesArea)){        //If AccountTopSegment value is not present,get the interval from a custom setting.
            
            Integer customCallIntervalValue = Integer.ValueOf(UTIL_Apex.empty(SalesAreaToFieldMapping.get(salesArea).Custom_Call_Interval_Value__c) ? '0' :SalesAreaToFieldMapping.get(salesArea).Custom_Call_Interval_Value__c);
            sObjectList.add(calculateNextCallListDate(salesArea,customCallIntervalValue,accRecord));
            
            
        }else if(SalesAreaToSegmentMapping.containsKey(salesArea)){

            //Get the Top & Sub Segment value from Account and Sales Area from Task & Check the Interval in the custom setting.
            for(SalesAreaToSegmentMapping__c setting: SalesAreaToSegmentMapping.get(salesArea)){
                                        
                if(!UTIL_Apex.empty(setting.SubSegment__c) && !UTIL_Apex.empty(setting.TopSegment__c)){
                    
                    if((setting.TopSegment__c == accTopSegmentValue && setting.SubSegment__c == accSubSegmentValue && setting.SalesArea__c == salesArea )){
                        interval = Integer.ValueOf(UTIL_Apex.empty(setting.Interval__c) ? '0' :setting.Interval__c);
                        sObjectList.add(calculateNextCallListDate(salesArea,interval,accRecord));
                    }
                }else if(!UTIL_Apex.empty(setting.TopSegment__c)){
                    
                    if((setting.TopSegment__c == accTopSegmentValue && setting.SalesArea__c == salesArea )){
                        interval = Integer.ValueOf(UTIL_Apex.empty(setting.Interval__c) ? '0' :setting.Interval__c);
                        system.debug(Logginglevel.INFO,'++++interval+++'+interval);
                        sObjectList.add(calculateNextCallListDate(salesArea,interval,accRecord));
                    }
                }
            }
        }
    }
    
    //This method performs the Next_Call_List_Date calculation.
    private static sObject calculateNextCallListDate(String SalesArea,Integer Intval,sObject Acc){
                
        if(SalesAreaToFieldMapping.containsKey(SalesArea) && Intval!=0){
            
            String callListDateField = String.valueOf((SalesAreaToFieldMapping.get(SalesArea).Next_Call_List_Date__c));
            String notReachedCounterField = String.valueOf(SalesAreaToFieldMapping.get(SalesArea).Not_Reached_Counter__c);
            
            Date callListDateValue = Date.valueOf(Acc.get(callListDateField));
            
            callListDateValue =  system.Today();
            callListDateValue = (callListDateValue + 365/Intval);
            
            Acc.put(callListDateField,callListDateValue);
            Acc.put(notReachedCounterField,0);
        }
        return Acc;
    }
    
    //5. This method will populate the Related to Campaign and Comments field on the task
    public static void populateCampaignFields(Set<Task> taskList) {
    	System.debug(LoggingLevel.info,'*** START: <G2O_Task_SVC>.<populateCampaignFields>');
    	//Create a set of Contacts
    	Set<Id> contactIds = new Set<Id>();
    	for (Task task : taskList) {
    		contactIds.add(task.WhoId);
    	}
    	
    	//Query for all the relevant contacts
    	List<Contact> contactList = [SELECT Id, Campaign_Name__c, Campaign_Description__c FROM Contact WHERE Id IN: contactIds];
    	
    	//Create a set of campaign names to be used
    	Set<String> campaignNameList = new set<String>();
    	for (Contact contact : contactList) {
    		campaignNameList.add(contact.Campaign_Name__c);
    	}
    	
    	//Query for all the relevant campaigns
    	List<Campaign> campaignList = [SELECT Id, Name FROM Campaign WHERE Name IN: campaignNameList];
    	
    	//Create a map of Contact Ids to Contact
		Map<Id, Contact> contactIdToContact = new Map<Id, Contact>();
		for (Contact c : contactList) {
			contactIdToContact.put(c.Id, c);
    	}
    	
    	//Populate the task fields
    	for (Task task : taskList) {
    		task.Description = contactIdToContact.get(task.WhoId).Campaign_Description__c;
    		for (Campaign campaign : campaignList) {
    			if (contactIdToContact.get(task.WhoId).Campaign_Name__c == campaign.Name) {
    				task.WhatId = campaign.Id;
    			}
    		}
    	}
    	System.debug(LoggingLevel.info,'*** END: <G2O_Task_SVC>.<populateCampaignFields>');
    }
}