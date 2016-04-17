/**
    About
    -----
    Description: Test class for the Trigger - Attachment_BeforeDelete
    Created for: Postnord Get2OneCRM Master template/Summer updates
    Create date: 29th April 2015
    
    Details
    -------
    
    Update History
    --------------
    Created 2015 April: B. Shridhar

    TEST CASES
    ----------
    1. Verify the delete access on the Attachments for the users non CS users and CS users with Profile- CS Standard User PDK-BE and 
    
*/ 

@isTest
public class Attachment_BeforeDelete_Test{

    //Declare Variables
    static Attachment accountAttachment, caseAttachment;
    static Database.DeleteResult result;

    //CASE 1 
    static testMethod void testDeleteAccessOnAttachment(){
        
        init();
        //Scenario 1 - Running user with 'CS Standard User PDK-BE' profile
        User user_PDKBE_Profile = UTIL_TestFactory.createUser('testPDKBEUser@test.com',(String)Get2OneCRM__c.getOrgDefaults().get('CS_Standard_User_PDK_BE_Profile_Name__c') );
        insert user_PDKBE_Profile;
        
        System.runAs(user_PDKBE_Profile){
            result = Database.delete(accountAttachment, false);
            if(!result.isSuccess())
                system.assertEquals('insufficient access rights on object id',result.Errors[0].getMessage(), 'invalid result'+ result );
            
            result = Database.delete(caseAttachment, false);
            system.assertEquals(false,result.isSuccess(), 'invalid result'+ result );
            system.assertEquals(LABEL.Insufficient_Access_to_delete_the_Attachemnts_on_Cases,result.Errors[0].getMessage(), 'invalid result'+ result );
            
        }
        
        //Scenario 2 - running user with non - 'CS Standard User PDK-BE' profile
        User testAdminUser = UTIL_TestFactory.createAdmin('testAdminUser@test.com');
        insert testAdminUser;
        
        System.runAs(testAdminUser){
            result = Database.delete(caseAttachment, false); 
            system.assertEquals(true,result.isSuccess(), 'invalid result'+ result );
            
        }
        
    } 
    
    static void init(){
    
        UTIL_TestFactory.setupOrg();  
        
        Account testAccount = UTIL_TestFactory.createAccount();
        insert testAccount;
        
        Case testCase =  UTIL_TestFactory.createCase();
        insert testCase;
                
        accountAttachment = UTIL_TestFactory.createAttachment();
        accountAttachment.body = Blob.valueof('test body2');
        accountAttachment.ParentId = testAccount.id;
        insert accountAttachment;
        
        caseAttachment = UTIL_TestFactory.createAttachment();
        caseAttachment.body = Blob.valueof('test body2');
        caseAttachment.ParentId = testCase.id;
        insert caseAttachment;
        
    }

}