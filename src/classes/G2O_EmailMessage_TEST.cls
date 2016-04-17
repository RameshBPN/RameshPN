@isTest
private class G2O_EmailMessage_TEST{
     public testMethod Static void testCheckForDuplicateMailsAndBlock(){
     
         Email_To_Case_Settings__c ecs=new Email_To_Case_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(),Name = UserInfo.getName(),
                                                                     Disable_Checking_Subject__c=false,Disable_Checking_TextBody__c=false,Character_To_Truncate_Email_Subject__c=':',
                                                                     Block_Duplicate_Email_Messages__c=true,Minutes_To_Block_Duplicate_Email_Message__c=10);
        
         upsert ecs;
         Case firstCase = UTIL_TestFactory.createCase();
         insert firstCase;
         
         DateTime firstEmailTime=DateTime.now();
         firstEmailTime.addMinutes(-1);
         EmailMessage firstCaseEmail = new EmailMessage(FromAddress = 'test@abc.com',Incoming = true,ToAddress = 'test@abc.com',
                                              Subject = 'Test Email',TextBody = 'Test',ParentId = firstCase.Id,MessageDate = firstEmailTime);
         
         insert firstCaseEmail;
         
         Case secondCase = UTIL_TestFactory.createCase();
         insert secondCase;
         
         DateTime secondEmailTime=DateTime.now();
         EmailMessage secondCaseEmail = new EmailMessage(FromAddress = 'test@abc.com',Incoming = true,ToAddress = 'test@abc.com',
                                              Subject = 'Test Email',TextBody = 'Test',ParentId = secondCase.Id,MessageDate = secondEmailTime);
         
        insert secondCaseEmail;  
         
         Case  updatedSecondCase=[SELECT Id,Has_To_Stop_Auto_Response__c FROM Case WHERE Id=:secondCase.Id LIMIT 1];  
         System.assertEquals(updatedSecondCase.Has_To_Stop_Auto_Response__c,true);   
     }
}