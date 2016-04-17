/**
    About
    -----
    Description: Before Insert Trigger on Contact
    Created for: Postnord Get2OneCRM MVU IM510061
    Create date: June 3 2014
    
    Filters:
    -------
    
    Actions:
    -------
    1. If the Permission channel is filled out then the field Permission Channel Timestamp populated with date, time and user who edited the field Permission Channel.
    2. If the field Permission is filled out then the field Permission Timestamp populated with date, time and user who edited the field Permission.      
        
        
    Update History
    --------------
    Updated June 2015 - Madhav Kakani - Fluido Denmark - Placed code for the Contact Center project to normalise phone numbers
        
    Issues / TODOs
    --------------  
*/

trigger Contact_BeforeInsert on Contact (before insert) {
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        for (Contact newContact : Trigger.new) {
            
            // Action 1
            if (String.isNotblank(newContact.Permission_Channel__c)){
                newContact.Permission_Channel_timestamp__c = System.NOW().Format() + ', ' + UserInfo.getName();
            }
            
            //Action2
            if (newContact.Permission__c == TRUE && newContact.Permission__c!= null ){
                newContact.Permission_Time_stamp__c = System.NOW().Format() + ', ' + UserInfo.getName();
            }                      

            // Action 3 - Placed code to normalise phone numbers for the Contact Center project - Fluido Denmark
            newContact.CC_Phone__c = UTIL_Apex.NormalisePhone(newContact.Phone, newContact.Account_Country__c);
            newContact.CC_Mobile__c = UTIL_Apex.NormalisePhone(newContact.MobilePhone, newContact.Account_Country__c);
        }
    }
}