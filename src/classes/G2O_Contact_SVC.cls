/**
    About
    -----
    Description: Service class for General contact Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: November 2014
    
    Details
    -------
    The trigger service class will reflect updates/inserts on Contact Obj.
     1.  Maintain old values for a set of fields in Contact object if context user is an integration user or if the record is flagged
     to be processed as Integration User.
     
     
    Update History
    --------------
    Created November 2014 - Aref Alazzani.
    
    Issues / TODOs
    --------------  
*/
 
public with sharing class G2O_Contact_SVC {
	
	//1. Method to handle contact field updates if "Do Not Update Automatically" is set.
    public static void doNotUpdateAutomatically(List<Contact> contDoNotUpdateNewList , Map<Id,Contact> contDoNotUpdateOldMap){
        Integer timeBefore = Limits.getCpuTime();
        System.debug(logginglevel.Info, '### START Contact_SVC.DoNotUpdateAutomatically');
        
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Contact.FieldSets.doNotUpdateFieldsForIntegrationUsers.getFields(); 
            
        for(integer j=0; j<contDoNotUpdateNewList.size(); j++){
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                
                if(contDoNotUpdateNewList[j].get(fieldSet[i].getFieldPath()) != contDoNotUpdateOldMap.get(contDoNotUpdateNewList[j].id).get(fieldSet[i].getFieldPath())){
                    
                    String fieldAPIName = fieldSet[i].getFieldPath();
                    sObject contRec   = (sObject)contDoNotUpdateNewList[j];
                    
                    contRec.put(fieldAPIName,contDoNotUpdateOldMap.get(contDoNotUpdateNewList[j].id).get(fieldSet[i].getFieldPath()));
                    
                }
            }
                
        }
        System.debug(logginglevel.Info, '### END Contact_SVC.DoNotUpdateAutomatically');
    }
	
}