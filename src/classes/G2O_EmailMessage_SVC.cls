/**
    About
    -----
    Description: Service class for EmailMessage Triggers 
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2015
    
    Details
    -------
    1.Find and block duplicate email messages in email to case-block duplicate auto response mails.
        
    Update History
    --------------
    Created August 2015 - Ramesh Botlagunta
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_EmailMessage_SVC {
    public static void checkForDuplicateMailsAndBlock(List<EmailMessage> incomingMails){
         System.debug(LoggingLevel.info,'*****START*****G2O_EmailMessage_SVC.checkForDuplicateMailsAndBlock');
           Set<String> fromAddressSet=new Set<String>();
           Set<String> toAddressSet=new Set<String>();
           Map<String,List<EmailMessage>> fromAddressMap=new Map<String,List<EmailMessage>>();
           DateTime msgStartDateTimeToCheckDuplicates,msgEndDateTimeToCheckDuplicates;
           for(EmailMessage emailMSG: incomingMails){
                          
                 fromAddressSet.add(String.valueOf(emailMSG.FromAddress));
                 toAddressSet.add(String.valueOf(emailMSG.ToAddress));
                 
                 if(UTIL_Apex.empty(msgStartDateTimeToCheckDuplicates)){
                     msgStartDateTimeToCheckDuplicates=emailMSG.MessageDate;
                 }
                 if(UTIL_Apex.empty(msgEndDateTimeToCheckDuplicates)){
                     msgEndDateTimeToCheckDuplicates=emailMSG.MessageDate;
                 }
                 if(msgStartDateTimeToCheckDuplicates>emailMSG.MessageDate){
                    msgStartDateTimeToCheckDuplicates=emailMSG.MessageDate;
                 }
                 if(msgEndDateTimeToCheckDuplicates<emailMSG.MessageDate){
                    msgEndDateTimeToCheckDuplicates=emailMSG.MessageDate;
                 }                                        
           }  
           
           Integer blockDuplicateMailsFromMinutes=UTIL_OrgSettings.numberOfMinutesToCheckForDuplicateEmailMessages();
           msgStartDateTimeToCheckDuplicates=msgStartDateTimeToCheckDuplicates.addMinutes(-blockDuplicateMailsFromMinutes);  
           for(EmailMessage emailMSG:[select id,FromAddress,ParentId,Incoming,Subject,TextBody,ToAddress from EmailMessage
                                             where FromAddress IN:fromAddressSet and MessageDate >=:msgStartDateTimeToCheckDuplicates 
                                             and MessageDate <=:msgEndDateTimeToCheckDuplicates and Incoming=true]){
                if(fromAddressMap.containsKey(String.valueOf(emailMSG.FromAddress))){
                    fromAddressMap.get(String.valueOf(emailMSG.FromAddress)).add(emailMSG);
                }
                else{
                    fromAddressMap.put(String.valueOf(emailMSG.FromAddress),new List<EmailMessage>{emailMSG});
                }
           }  
           //List<EmailMessage> emailMSGsToBlock=new List<EmailMessage>(); 
           Boolean isSubjectVerificationDisabled=UTIL_OrgSettings.isDuplicateEmailSubjectEnabled();//get it from custom Settings
           Boolean isBodyVerificationDisabled=UTIL_OrgSettings.isDuplicateEmailTextBodyEnabled();//get it from custom Settings
           String truncateSubjectFrom=UTIL_OrgSettings.CharacterToTruncateEmailSubject();//get it from custom Settings
           Set<Id> caseIdSet=new Set<Id>();        
           for(EmailMessage emailMSG: incomingMails){     
                 if(fromAddressMap.containsKey(String.valueOf(emailMSG.FromAddress))){
                      Boolean duplicateEMailFound=false;    
                      for(EmailMessage existingEmail:fromAddressMap.get(String.valueOf(emailMSG.FromAddress))){                         
                          //compare all possible fields and then stop inserting new case                       
                          /*if((!string.valueof(existingEmail.ParentId).equalsIgnoreCase(emailMSG.ParentId)) 
                              && (existingEmail.Subject == emailMSG.Subject) 
                              && (existingEmail.TextBody == emailMSG.TextBody)
                              && (!duplicateEMailFound)){
                                duplicateEMailFound=true;
                                //emailMSGsToBlock.add(emailMSG); 
                                caseIdSet.add(emailMSG.ParentId);                                                                                                      
                          }
                          */
                          if(!duplicateEMailFound){
                              if(!string.valueof(existingEmail.ParentId).equalsIgnoreCase(emailMSG.ParentId)){
                                  Boolean dupSubFound=false,dupBodyFound=false;
                                  if(!isSubjectVerificationDisabled){                                     
                                     if(!UTIL_Apex.empty(truncateSubjectFrom)){
                                         if((!UTIL_Apex.empty(emailMSG.Subject)) && (!UTIL_Apex.empty(existingEmail.Subject))){
                                             String subjectToVerify= UTIL_Apex.empty(emailMSG.Subject) ? '' :emailMSG.Subject;
                                             String existingEmailSubjectToVerify= UTIL_Apex.empty(existingEmail.Subject) ? '' :existingEmail.Subject;
                                             if((subjectToVerify.lastIndexOf(truncateSubjectFrom) > 0) 
                                                && (existingEmailSubjectToVerify.lastIndexOf(truncateSubjectFrom) > 0)){
                                                subjectToVerify=subjectToVerify.subString(0,subjectToVerify.lastIndexOf(truncateSubjectFrom));
                                                existingEmailSubjectToVerify=existingEmailSubjectToVerify.subString(0,existingEmailSubjectToVerify.lastIndexOf(truncateSubjectFrom));
                                                dupSubFound=(subjectToVerify == existingEmailSubjectToVerify) ? true:false;
                                             }
                                             else{
                                                dupSubFound=(existingEmail.Subject == emailMSG.Subject) ? true:false;
                                             }
                                          }
                                          else{
                                            dupSubFound=(existingEmail.Subject == emailMSG.Subject) ? true:false;
                                          }
                                     }
                                     else{
                                        dupSubFound=(existingEmail.Subject == emailMSG.Subject) ? true:false;
                                     }
                                  } 
                                  else{
                                     dupSubFound=true;
                                  }     
                                  if(!isBodyVerificationDisabled){
                                     dupBodyFound=(existingEmail.TextBody == emailMSG.TextBody) ? true:false;
                                  }    
                                  else{
                                     dupBodyFound=true;
                                  }
                                  if(dupSubFound && dupBodyFound){
                                     duplicateEMailFound=true;
                                     caseIdSet.add(emailMSG.ParentId); 
                                  }                     
                              }
                          } 
                       }                                                   
                 }             
           }
           if(!caseIdSet.isEmpty()){
               updateHasToStopAutoResponseFlagOnCase(caseIdSet);
           }    
           System.debug(LoggingLevel.info,'*****END*****G2O_EmailMessage_SVC.checkForDuplicateMailsAndBlock');               
    }
    private static void updateHasToStopAutoResponseFlagOnCase(Set<Id> caseIds){
          System.debug(LoggingLevel.info,'****STRAT******G2O_EmailMessage_SVC.updateHasToStopAutoResponseFlagOnCase');
          List<Case> caseListToUpdate=new List<Case>();
          for(Case c:[Select Id,Has_To_Stop_Auto_Response__c from Case where Id IN:caseIds]){
              c.Has_To_Stop_Auto_Response__c=true;
              caseListToUpdate.add(c);
          }
          if(!caseListToUpdate.isEmpty()){
             Database.update(caseListToUpdate,false);
          }
          System.debug(LoggingLevel.info,'****END******G2O_EmailMessage_SVC.updateHasToStopAutoResponseFlagOnCase');
    }  
}