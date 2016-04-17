/**
    About
    -----
    Description: before insert Trigger on EmailMessage 
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2015
    
    Filters:
    -------
        1. Add all the Incoming EmailMessages to check duplicate Email message
        
    Update History
    --------------
    Created August 2015-Ramesh Botlagunta
    
    Issues / TODOs
    --------------  
    
*/
trigger EmailMessage_BeforeInsert on EmailMessage (before insert) {
    List<EmailMessage> incomingMails=new List<EmailMessage>();    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    
           if(UTIL_OrgSettings.isDuplicateEmailMessagesBlockingEnabled()) {                                   
               // Filter 1
               for(EmailMessage emailMSG: trigger.new){
                   if(emailMSG.Incoming){
                         incomingMails.add(emailMSG);                                       
                   }                                    
               }               
               // Exectue logic in a service class       
               // Filter 1
               if(!incomingMails.isEmpty()){
                   G2O_EmailMessage_SVC.checkForDuplicateMailsAndBlock(incomingMails);
               }
           }                    
    }
}