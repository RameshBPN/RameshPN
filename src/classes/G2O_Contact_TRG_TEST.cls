/**
    About
    -----
    Description: This class is used to test the Before insert trigger on Contact.
    Created for: Created as part of MVU IM510061 and this  checks the below actions:
                    1. If the Permission channel is filled out then the field Permission Channel Timestamp populated with date, time 
                        and user who edited the field Permission Channel.
                    2. If the field Permission is filled out then the field Permission Timestamp populated with date, time 
                        and user who edited the field Permission.      

    
    Create date: June 2014
    
    Update History
    --------------
    Created 2014 2014 - Ramesh T N
    
        
    Issues / TODOs
    --------------
    
*/

@isTest
public Class G2O_Contact_TRG_TEST{ 
    static Account acc;
    static Contact con;
    
    public static testMethod void createCustomerConctactData(){
        UTIL_TestFactory.setUpOrg();
        initSingleContact();
    }   

    public static void initSingleContact() {
        UTIL_TestFactory.setUpOrg();    
        acc = new Account();
        acc = UTIL_TestFactory.createAccount();
        acc.Email_Address__c='test@postnord.dk';
        insert acc;
        
        con = UTIL_TestFactory.createcontact();
        con.AccountId = acc.Id;
        con.Email='test@postnord.dk';
        con.Permission_Channel__c='Test_Data';
        con.Permission__c = true; 
        insert con;
        
        con.Permission__c = false;
        con.Permission_Channel__c='Test_Data1';
        update con;
        
    }
}