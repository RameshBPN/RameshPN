/**
    About
    -----
    Description: Service class for General Event Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Details
    -------
    The trigger service class will reflect updates/inserts on Event Obj.
     1. Set activity indicator on Account if the related Event is completed within last 14 days.
     2. Set Location from Account
     
    Update History
    --------------
    Created June 2013 - A.B.
    
    Issues / TODOs :
    --------------  
*/

public with sharing class G2O_Event_SVC {
    
    //A.T.T.R.I.B.U.T.E.S
    
    static Map<Id,Account> accIdToAccountMap = new Map<Id,Account>();   //Holds accountId To account mapping of the account related to the Task.
    static Set<Id> accIdSet = new Set<Id>();                            //Holds account Ids related to Events.
        
    //A.T.T.R.I.B.U.T.E.S
    
    
    //1. Set activity indicator on Account if the related Event is completed within last 14 days.
    public static void setActivityIndicator(List<Event> newEventList){
        
        System.debug(LoggingLevel.info,'*** START: <Event_SVC>.<setActivityIndicator>');
        List<Account> accList = new List<Account>();
        
        getAccounts(newEventList);
        
        //Setting the Indicator field with Todays date.
        for(Account accRecord : accIdToAccountMap.values()){
            for(Event e : newEventList) {
            	if(e.AccountId == accRecord.Id) {
            		if(accRecord.ActivityCompletedDate__c == null && e.StartDateTime.date() < Date.today().addDays(31)) {
            			accRecord.ActivityCompletedDate__c = e.StartDateTime.date();
            		} else if(accRecord.ActivityCompletedDate__c < e.StartDateTime.date() && e.StartDateTime.date() < Date.today().addDays(31)) {
            			accRecord.ActivityCompletedDate__c = e.StartDateTime.date();
            		}
            	}
            }
            accList.add(accRecord);
        }
        
        update accList;
        System.debug(LoggingLevel.info,'*** END: <Event_SVC>.<setActivityIndicator>');
    }
    
    // 2. Set Location based on account location
    public static void setLocation(List<Event> newEventList){
    	map<id, Event> eventsWithContact = new map<id, Event>();
    	map<id, Event> eventsWithAccount = new map<id, Event>();
    	for(Event e : newEventList){
    		if(e.Whatid != null && e.WhatId.getSObjectType() == Account.sObjectType){
    			eventsWithAccount.put(e.Whatid,e);
    		}
    		else if(e.whoId != null && e.WhoId.getSObjectType() == Contact.sObjectType){
				eventsWithContact.put(e.WhoId,e);
    		}
    	}
    	list<Account> relevantAccounts = [select id, Name, Postal_Address_Street__c, Postal_Address_Postal_Code__c, Postal_Address_House_Number__c, Postal_Address_City__c From Account Where Id IN :eventsWithAccount.keySet()];
		for(Account a : relevantAccounts){
			eventsWithAccount.get(a.id).Location = a.Name + ', ' + a.Postal_Address_Street__c + ' ' + a.Postal_Address_House_Number__c + ', ' + a.Postal_Address_Postal_Code__c + ' ' + a.Postal_Address_City__c;
		}
		
    	list<Contact> relevantContacts = [select id, AccountId, Account.Name, Account.Postal_Address_Street__c, Account.Postal_Address_Postal_Code__c, Account.Postal_Address_House_Number__c, Account.Postal_Address_City__c From Contact Where Id IN :eventsWithContact.keySet()];
		for(Contact c : relevantContacts){
			if(c.AccountId != null){
				eventsWithContact.get(c.id).location = c.Account.Name + ', ' +c.Account.Postal_Address_Street__c + ' ' + c.Account.Postal_Address_House_Number__c + ', ' + c.Account.Postal_Address_Postal_Code__c + ' ' + c.Account.Postal_Address_City__c;
			}
		}
    }
    
    
    //This util method populates Telesales_interval__c,SalesAreaToTaskFieldMapping__c custom settings & gets account related to tasks.
    private static void getAccounts(List<Event> newEventList){
                
        //Getting the account Ids related to tasks.
        for(Event e:newEventList){
            
            if(e.AccountId!=null){
                accIdSet.add(e.AccountId);      
            }
        }
        
        system.debug(Logginglevel.INFO,'++++accIdSet+++'+accIdSet);
        //Getting the account reccords.
        for(Account acc : [Select a.Id,a.ActivityCompletedDate__c From Account a Where Id IN:accIdSet ]){
            
            accIdToAccountMap.put(acc.Id,acc);
        }
    } 

}