/**
    About
    -----
    Description: This class is used to test G2O_InboundMessageLog_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2015
        
    Update History
    --------------
    Created August 2015 - Ramesh Botlagunta
    
    Issues / TODOs
    --------------   
*/
@isTest
private class G2O_InboundMessageLog_SVC_TEST {

    static testMethod void logInboundMessages() {        

        UTIL_TestFactory.setupOrg();        
        insert (new Log_Inbound_Messages__c(SetupOwnerId=UserInfo.getUserId(),Log_Messages__c=True));        
        G2O_InboundMessageLog_SVC.isthisCalledfromInboundMessageLogtest = true;
        
        List<sObject> soListToUpdate=new List<sObject>();
        
        Account a=UTIL_TestFactory.createAccount();
        insert a;
        
        a.Name='Inbound Message Test Account';        
        update a;
        
        Contact c = new Contact();
        c.LastName = 'NOW ' + String.valueOf(System.now());
        c.FirstName = 'NOW ' + String.valueOf(System.now());
        c.Contact_Person_Type__c = 'Lead Contact Person (TBD)';
        c.Language__c = 'EN';
        c.Verified__c = 'N';
        c.AccountId = a.Id;
        insert c;
        
        c.LastName=c.LastName+'upadte';
        update c;
        
        //Account Contact Role Transaction
        Account_Contact_Role_Transaction__c acrt = [Select SystemModstamp, Secondary_Position_3__c, Secondary_Position_2__c, 
                                                    Secondary_Position_1__c, Primary_Position__c, PN_Synchronized__c, 
                                                    PN_Synchronization_Error__c, PN_Synchronization_ErrorReasonCode__c, 
                                                    PN_Mark_As_Synced__c, Name, Last_PN_Synchronized_Date__c, 
                                                    LastModifiedDate, LastModifiedById, Is_Governed_by_External_Party__c, 
                                                    IsPrimary__c, IsDeleted, Id, External_Provider_Relationship_ID__c, 
                                                    CurrencyIsoCode, CreatedDate, CreatedById, Contact__c, 
                                                    Account__c, Account_Contact_Role_SFID__c
                                                    From Account_Contact_Role_Transaction__c
                                                    WHERE Account__c = :a.Id AND Contact__c = :c.Id
                                                    LIMIT 1];
        acrt.Department__c='Post Nord';
        update acrt;
       
        //bank details
        Bank_Details__c bankDetail = new Bank_Details__c(); 
        Bank_Key__c bankKey = UTIL_TestFactory.createBankKey();   
        insert bankKey;    
        bankDetail.Account__c = a.Id;       
        bankDetail.Bank_Key__c = bankKey.Id;
        bankDetail.Bank_Country__c = bankKey.Country__c;
        bankDetail.Bank_Account__c = '1234567890';
        insert bankDetail;
        
        //Credit Information
        Credit_Information__c creditInformation = new Credit_Information__c();
        creditInformation.Account__c = a.Id;
        insert creditInformation;
        
        creditInformation.Credit_Rating__c='1';
        update creditInformation;
        
        //Relationship
        Relationship__c rel=UTIL_TestFactory.createRelationship();
        insert rel;
        
        
        User testAdmin=UTIL_TestFactory.createAdmin('InboundMessageLogTestAdmin@test.com');
        
        System.runAs(testAdmin) {
              List<Inbound_Message_Log__c> imlList=new List<Inbound_Message_Log__c>();
              for(Inbound_Message_Log__c iml:[select id from Inbound_Message_Log__c where Account__c=:a.Id]){
                  imlList.add(iml);
              }
              System.assert(imlList.size() > 0);
        }
    }   
}