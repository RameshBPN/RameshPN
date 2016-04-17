/**
    About
    -----
    Description: This class is used to test Account_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of Account_SVC class Part 2 of 2.
    1.  updateExtensionAddressesTest:Test the updateExtensionAddresses method of Account_SVC class.
    2.  Test the updateExtensionAddresses method invoked by Account Before Insert Trigger.
    3.  Bulk test of copyAccountTeamMembers
    4.  Create Sales Area Information
    5.  copies the new Account Id to accounts where PAR Parent ID equals PAR ID after insert.
    6.  copies the new Account Id to accounts where PAR ID equals PAR Parent ID after insert.
    7.  copies the new Account Id to accounts where PAR Parent ID equals PAR ID and removes children connection if any
    8.  copies the new Account Id to accounts where PAR ID equals PAR Parent ID before update
    9.  Update some records where Parent PAR Id is matching
    10. Test Before Update Account trigger doNotUpdateAutomatically functionality: Fields are not updated if an integraion user updates the record & do not update flag is set as true.NonIntegration users are allowed to update the fields irrespective of the do not update flag.
    11.Test checkForDuplicates method of Account_SVC,When Duplicate_checked__c is set as true.
    12. Test the create short name function for B2B
    13. Test the create short name function for B2C
    14. Tests that when inserting a new WS to an existing LE the account teams should be copied from the LE to the new WS
    24. Test the functionality of updating of extension address from worksite to extension on extension creation.
    15. This test method tests that the Postal Address Country is copied to Registration Country when it should be
    16. This test method tests that the Postal Address Country is not copied to Registration Country when it should  not be
    17. Test duplicate account on insert and update for record type other then LE,WS PP
    18. Test duplicate account on update to prevent recursive problem.
    
    Update History
    --------------
    Created March 2013 - A.B.
    Updated May 2013 - R.M.
    Updated April 2014-Richa Tripathi
    
    Issues / TODOs
    --------------
    
*/
@isTest
public with sharing class G2O_Account_SVC_TEST_2 {
  //A.T.T.R.I.B.U.T.E.S
  
    static list<Account> lstLegalEntityAcc = new list<Account>();
    static List<Account> lstWorksiteAcc = new list<Account>();
    static List<Account> lstExtensionAcc;
    static List<Account> accountlst;
    static List<PossibleDuplicateAccount__c> possibleDuplicatelst;
    static Account legalEntityRec;
    static Account extensionRec;    //Record to be set as a Possible_Duplicate_Account__c for testing flagToRecheckDuplicates functionality.
    static Account workSiteRec;     //Record to be set as a ParentId.
    static Account accountPAR;
    static Account objAcc;
    
    static Id extrTypeId;
    static Id wrkrTypeId;
    static Id lerTypeId;
    static String RecordTypeLegalEntity;
    static String RecordTypeWorkSite;
    
    static List<sObject> lstWkAcc = new  List<sObject>();
    static List<sObject> lstExAcc = new  List<sObject>();
    static User usr;
    static ScheduledJobParameters__c scheduledParameters = new ScheduledJobParameters__c();
    
    static User adminUser;
    static User integrationUser;
    static List<Schema.FieldSetMember> fieldSet0 = new List<Schema.FieldSetMember>();
    static List<Schema.FieldSetMember> fieldSet1 = new List<Schema.FieldSetMember>();

    //A.T.T.R.I.B.U.T.E.S

  // 9. Test Before Update Account trigger doNotUpdateAutomatically functionality: Fields are not updated if an integraion user updates the record & 
    //    do not update flag is set as true.NonIntegration users are allowed to update the fields irrespective of the do not update flag.
    static testMethod void doNotUpdateAutomatically_Test1(){
        
        //Arrange
        createTestForDoNotUpdate();
        
        //Updating the Worksite Address field.
        for (Integer j = 0; j <lstWkAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet0.size(); i++) {
                String fieldAPIName = fieldSet0[i].getFieldPath();
                
                if(String.valueOf(fieldSet0[i].getType()).equalsIgnoreCase('STRING')){
                    lstWkAcc[j].put(fieldAPIName,'##0000##');
                }
            }   
        }
        
        // Act
        Test.startTest();
        system.runAs(integrationUser){
            
            system.debug(logginglevel.error,'before the update');
            update lstWkAcc;
            system.debug(logginglevel.error,'after the update');            
        }
        Test.stopTest();
        
        // Assert
        //1. For Use Case: Fields get updated on WokSite as the "Do not update Flag = "false".
        String query0 = 'SELECT ';
        for(Integer i=0; i<fieldSet0.size(); i++) { 
            query0 += fieldSet0[i].getFieldPath() +',';
        }
        query0 += ' Id From Account';
        query0 += ' WHERE '; 
        query0 += 'Id =\''+lstWkAcc[0].Id+'\''; 
        
        List<Account> wkAccRec0 = Database.query(query0);   // query to get SFDC records related to wkSite at index 0, where "Do not update" flag is set as false.
        
        
        //2. For Use Case: Fields are not updated on WokSite as the "Do not update Flag = "true".
        String query1 = 'SELECT ';
        for(Integer i=0; i<fieldSet0.size(); i++) { 
            query1 += fieldSet0[i].getFieldPath() +',';
        }
        query1 += ' Id From Account';
        query1 += ' WHERE '; 
        query1 += 'Id =\''+lstWkAcc[50].Id+'\''; 
        
        List<Account> wkAccRec1 = Database.query(query1);   // query to get SFDC records related to wkSite at index 0, where "Do not update" flag is set as false.
        
        
        //3. For Use Case: Fields get updated on the Extensions as the "Do not update Flag = "false".
        String query2 = 'SELECT ';
        for(Integer i=0; i<fieldSet1.size(); i++) { 
            query2 += fieldSet1[i].getFieldPath() +',';
        }
        query2 += ' Id From Account';
        query2 += ' WHERE '; 
        query2 += 'ParentId =\''+lstWkAcc[0].Id+'\''; 
        
        // query to get SFDC records
        List<Account> extensionAccRec2 = Database.query(query2);
        
        
        //4. For Use Case: Fields are not updated on the Extensions as the "Do not update Flag = "true".
        String query3 = 'SELECT ';
        for(Integer i=0; i<fieldSet1.size(); i++) { 
            query3 += fieldSet1[i].getFieldPath() +',';
        }
        query3 += ' Id From Account';
        query3 += ' WHERE '; 
        query3 += 'ParentId =\''+lstWkAcc[50].Id+'\''; 
        
        // query to get SFDC records
        List<Account> extensionAccRec3 = Database.query(query3);
        
        
        //Checking for the WorkSite Updates.
        for(Integer i=0; i<fieldSet0.size(); i++) {
            
            if(String.valueOf(fieldSet0[i].getType()) == 'STRING'){
                String fieldName = fieldSet0[i].getFieldPath();
                
                //1. WorkSite gets updated as Do not update is set as false.
                System.assertEquals('##0000##', lstWkAcc[0].get(fieldName));
                
                //2. WorkSite is not updated as Do not update is set as true.
                System.assertEquals('##5555##', wkAccRec1[0].get(fieldName));
            }
        }
        
        //Checking for the Extension Updates.
        for(Integer i=0; i<fieldSet1.size(); i++) {
            if(String.valueOf(fieldSet1[i].getType()) == 'STRING'){
                String fieldName = fieldSet1[i].getFieldPath();
                
                //1. Extension gets updated as Do not update is set as false.
                if(fieldName.containsIgnoreCase('VAT_Number__c')){
                    System.assertEquals('DK34943400', extensionAccRec2[0].get(fieldName));
                }
                else{
                    System.assertEquals('##0000##', extensionAccRec2[0].get(fieldName));
                }
                
                //2. Extension is not updated as Do not update is set as true.
                if(fieldName.containsIgnoreCase('VAT_Number__c')){
                    System.assertEquals('DK34943400', extensionAccRec3[0].get(fieldName));
                }
                else{
                    System.assertEquals('##9999##', extensionAccRec3[0].get(fieldName));                                
                }
            }
        } 
        
    }
    
    // 10. Test Before Update Account trigger doNotUpdateAutomatically functionality: Fields are not updated if an integraion user updates the record & 
    //    do not update flag is set as true.NonIntegration users are allowed to update the fields irrespective of the do not update flag.
    static testMethod void doNotUpdateAutomatically_Test2(){
        
        //Arrange
        createTestForDoNotUpdate();
        
        //Updating the Worksite Address field.
        for (Integer j = 0; j <lstWkAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet0.size(); i++) {
                String fieldAPIName = fieldSet0[i].getFieldPath();
                
                if(String.valueOf(fieldSet0[i].getType()).equalsIgnoreCase('STRING')){
                    lstWkAcc[j].put(fieldAPIName,'##0000##');
                }
            }   
        }
        
        // Act
        Test.startTest();
        system.runAs(adminUser){
            
            update lstWkAcc;
        }
        Test.stopTest();
        
        // Assert
        //1. For Use Case: Fields get updated on WokSite as the "Do not update Flag = "false".
        String query0 = 'SELECT ';
        for(Integer i=0; i<fieldSet0.size(); i++) { 
            query0 += fieldSet0[i].getFieldPath() +',';
        }
        query0 += ' Id From Account';
        query0 += ' WHERE '; 
        query0 += 'Id =\''+lstWkAcc[0].Id+'\''; 
        
        List<Account> wkAccRec0 = Database.query(query0);   // query to get SFDC records related to wkSite at index 0, where "Do not update" flag is set as false.
        
        
        //2. For Use Case: Fields are  updated on WokSite as the user is NonIntegration User irrespective of  "Do not update Flag is set = "true".
        String query1 = 'SELECT ';
        for(Integer i=0; i<fieldSet0.size(); i++) { 
            query1 += fieldSet0[i].getFieldPath() +',';
        }
        query1 += ' Id From Account';
        query1 += ' WHERE '; 
        query1 += 'Id =\''+lstWkAcc[50].Id+'\''; 
        
        List<Account> wkAccRec1 = Database.query(query1);   // query to get SFDC records related to wkSite at index 0, where "Do not update" flag is set as false.
        
        
        //3. For Use Case: Fields get updated on the Extensions as the "Do not update Flag = "false".
        String query2 = 'SELECT ';
        for(Integer i=0; i<fieldSet1.size(); i++) { 
            query2 += fieldSet1[i].getFieldPath() +',';
        }
        query2 += ' Id From Account';
        query2 += ' WHERE '; 
        query2 += 'ParentId =\''+lstWkAcc[0].Id+'\''; 
        
        // query to get SFDC records
        List<Account> extensionAccRec2 = Database.query(query2);
        
        
        //4. For Use Case: Fields are not updated on the Extensions as  "Do not update Flag = "true".
        String query3 = 'SELECT ';
        for(Integer i=0; i<fieldSet1.size(); i++) { 
            query3 += fieldSet1[i].getFieldPath() +',';
        }
        query3 += ' Id From Account';
        query3 += ' WHERE '; 
        query3 += 'ParentId =\''+lstWkAcc[50].Id+'\''; 
        
        // query to get SFDC records
        List<Account> extensionAccRec3 = Database.query(query3);
        
        
        //Checking for the WorkSite Updates.
        for(Integer i=0; i<fieldSet0.size(); i++) {
            
            if(String.valueOf(fieldSet0[i].getType()) == 'STRING'){
                String fieldName = fieldSet0[i].getFieldPath();
                
                //1. WorkSite gets updated as Do not update is set as false.
                System.assertEquals(lstWkAcc[0].get(fieldName),'##0000##');
                
                //2. WorkSite gets updated as the user is Non Integration User irrespective of Do not update is set as true.
                System.assertEquals(wkAccRec1[0].get(fieldName),'##0000##');
            }
        }
        
        //Checking for the Extension Updates.
        for(Integer i=0; i<fieldSet1.size(); i++) {
            if(String.valueOf(fieldSet1[i].getType()) == 'STRING'){
                String fieldName = fieldSet1[i].getFieldPath();
                
                //1. Extension gets updated as Do not update is set as false.
                if(fieldName.containsIgnoreCase('VAT_Number__c')){
                    System.assertEquals(extensionAccRec2[0].get(fieldName),'DK34943400');                   
                }
                else{
                    System.assertEquals(extensionAccRec2[0].get(fieldName),'##0000##');
                }    
                //2. Extension is not updated as Do not update is set as true.
                for(Integer j=0; j<fieldSet0.size(); j++){
                    if(fieldName == fieldSet0[j].getFieldPath()){
                        System.assertEquals(extensionAccRec3[0].get(fieldName),'##9999##', fieldName);
                    }
                }               

            }
        } 
        
    }
    
    static testMethod void flagToRecheckDuplicates_Test0(){
        
        List<Account> accList = new List<Account>();
        List<Account> updateAccList = new List<Account>();
        
        //Setup Org.
        UTIL_TestFactory.setUpOrg();
        
        //Creating custom settings.
        scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        //scheduledParameters.Duplicate_reason_Batch__c ='Similar Name / Address Fields';
        //scheduledParameters.Duplicate_reason_MOD_Intressent_Nr__c = 'MOD Intressent Number';
        //scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c = 'MOD Modtager Number';
        //scheduledParameters.Duplicate_reason_PAR__c = 'External provider party ID';
        update scheduledParameters;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
        
        integer accountSize = 16;
        
        //Creating Test Data
        for (Integer i = 0; i < accountSize; i++) {
            
            Account a = UTIL_TestFactory.createAccount();
            a.recordTypeId = wrkrTypeId;
            a.BillingCountry                    = 'Netherlands';
            a.Name                              = 'NOW ' + String.valueOf(System.now());
            a.Corporate_Registration_Number__c  = '82883711';
            a.Visiting_Address_Street__c        = '98989';
            a.Visiting_Address_Country__c       = 'DK';
            a.Visiting_Address_Postal_Code__c   = '2100';
            a.Visiting_Address_City__c          = 'Test City';
            a.Postal_Address_Street__c          = '7';
            a.Postal_Address_Country__c         = 'DK';
            a.Registration_Country__c           = 'DK';
            a.Postal_Address_Postal_Code__c     = '2100';
            a.Postal_Address_City__c            = 'Test City';
            a.Verified__c = 'N';
            accList.add(a);
        }
        
        for(integer i=0; i <accList.size(); i++){
            
            accList[i].Short_Name__c = 'ABCTest'+i;
            accList[i].MOD_Modtager_Number__c = '9999'+i;
            accList[i].MOD_Interessent_Number__c = '5555'+i;
            accList[i].External_Provider_Party_ID__c = '3333'+i;
            accList[i].Duplicate_checked__c = true;
            accList[i].MODTager_Duplicate_checked__c = true;
            if(i == 8 || i == 9){
                accList[i].Duplicate_checked__c = false;                
            }
        }
        
        insert accList;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        possibleDuplicatelst = new List<PossibleDuplicateAccount__c>();
        //Creating PossibleDuplicateAccount__c record.
        for(integer i=0; i< accountSize ;i++){
            PossibleDuplicateAccount__c possDuplicate = new PossibleDuplicateAccount__c();
            if(i == 0){
                possDuplicate.Account__c = accList[0].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[1].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c;
                possibleDuplicatelst.add(possDuplicate);
            }
            if(i == 1){
                possDuplicate.Account__c = accList[2].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[3].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c;
                possibleDuplicatelst.add(possDuplicate);
            }
            if(i == 2){
                possDuplicate.Account__c = accList[4].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[10].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c;
                possibleDuplicatelst.add(possDuplicate);                
            }
            if(i == 3){
                possDuplicate.Account__c = accList[11].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[5].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c;
                possibleDuplicatelst.add(possDuplicate);                
            }
            if(i == 4){
                possDuplicate.Account__c = accList[6].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[12].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c;
                possibleDuplicatelst.add(possDuplicate);                
            }
            if(i == 5){
                possDuplicate.Account__c = accList[13].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[7].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c;
                possibleDuplicatelst.add(possDuplicate);                
            }
            if(i == 6){
                possDuplicate.Account__c = accList[8].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[14].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c + ';' + scheduledParameters.Duplicate_reason_Batch__c;
                possibleDuplicatelst.add(possDuplicate);                
            }
            if(i == 7){
                possDuplicate.Account__c = accList[15].Id;
                possDuplicate.Possible_Duplicate_Account__c = accList[9].Id;
                //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c + ';' + scheduledParameters.Duplicate_reason_Batch__c;
                possibleDuplicatelst.add(possDuplicate);                
            }

        }
        insert possibleDuplicatelst;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        //Act
        for(integer i=0; i < 10; i++){
            
            //ShortName is updated.
            if(i == 0){
                accList[i].Short_Name__c = 'ABC'+i;
                updateAccList.add(accList[i]);
            }
            //ShortName & MOD_Modtager Number Updated.
            if(i > 2){
                accList[i].Short_Name__c = 'ABC'+i;
                accList[i].MOD_Modtager_Number__c = '7777'+i;
                updateAccList.add(accList[i]);
            }
        }
        update updateAccList;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        //Assert
        System.assertEquals(true, [SELECT Id, Duplicate_checked__c FROM Account WHERE Id = :updateAccList[0].id].Duplicate_checked__c);
        System.assertEquals(true, [SELECT Id, MODTager_Duplicate_checked__c FROM Account WHERE Id = :updateAccList[0].id].MODTager_Duplicate_checked__c);
        
        System.assertEquals(true, [SELECT Id, Duplicate_checked__c FROM Account WHERE Id = :updateAccList[1].id].Duplicate_checked__c);
        System.assertEquals(true, [SELECT Id, MODTager_Duplicate_checked__c FROM Account WHERE Id = :updateAccList[1].id].MODTager_Duplicate_checked__c);
    }

    //11. Test checkForDuplicates method of Account_SVC,When Duplicate_checked__c is set as true.
    static testMethod void flagToRecheckDuplicates_Test1() {
        
        // Arrange
        createData();
        lstWorksiteAcc = (list<Account>)lstWkAcc;
        lstextensionAcc = (list<Account>)lstExAcc;
        
        lstWorksiteAcc[0].Duplicate_checked__c=true;
        lstWorksiteAcc[0].Verified__c = 'N';
        lstextensionAcc[0].Duplicate_checked__c=true;
        lstextensionAcc[0].Verified__c = 'N';
        
        update lstWorksiteAcc[0];
        update lstextensionAcc[0];
        
        //Creating PossibleDuplicateAccount__c record.
        PossibleDuplicateAccount__c possDuplicate = new PossibleDuplicateAccount__c();
        possDuplicate.Account__c = lstWorksiteAcc[0].Id;
        possDuplicate.Possible_Duplicate_Account__c = extensionRec.Id;
        //possDuplicate.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Intressent_Nr__c;
        insert possDuplicate;
        
        // Act
        Test.startTest();
        lstWorksiteAcc[0].RecordTypeId = lerTypeId; //Changing the recordTypeId
        lstWorksiteAcc[0].ParentId = null;
        //lstWorksiteAcc[0].ParentId = lstWorksiteAcc[1].Id; //Extension must have a parent(WorkSite)

        update lstWorksiteAcc[0]; 
        Test.stopTest();
        
        // Assert                                                          
        System.assertEquals(false, [SELECT Id, Duplicate_checked__c FROM Account WHERE Id = :extensionRec.id].Duplicate_checked__c);
        System.assertEquals(false, [SELECT Id, Duplicate_checked__c FROM Account WHERE Id = :extensionRec.id].Duplicate_checked__c);
    }
    
    
    //12.  Test checkForDuplicates method of Account_SVC,When Duplicate_checked__c & MODTager_Duplicate_checked__c is set as true.
    static testMethod void flagToRecheckDuplicates_Test2(){
        
        // Arrange
        createData();
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        lstWorksiteAcc.add((Account)lstWkAcc[0]);
        lstWorksiteAcc.add((Account)lstWkAcc[1]);
        lstextensionAcc = (list<Account>)lstExAcc;
        possibleDuplicatelst = new list<PossibleDuplicateAccount__c>();

        //Get the Parent LE and set the VAT Number to match the new WS value
        String queryLE = 'SELECT Id From Account WHERE Id =\'' + lstWorksiteAcc[0].get('ParentId') + '\'';
        Account LE = Database.query(queryLE);
        LE.Registration_Country__c = 'DK';
        LE.Postal_Address_Country__c = 'DK';
        update LE;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        //************Duplicate_checked__c & MODTager_Duplicate_checked__c
        lstWorksiteAcc[0].Duplicate_checked__c = true;
        lstWorksiteAcc[0].MODTager_Duplicate_checked__c = true;
        lstWorksiteAcc[0].Verified__c = 'N';
        lstWorksiteAcc[0].MOD_Modtager_Number__c = '00001';
        lstWorksiteAcc[0].Short_Name__c = lstWorksiteAcc[0].Name;
        lstWorksiteAcc[0].MOD_Modtager_Number__c = '99991';
        lstWorksiteAcc[0].MOD_Interessent_Number__c = '55551';
        lstWorksiteAcc[0].External_Provider_Party_ID__c = '33331';
        lstWorksiteAcc[0].Postal_Address_City__c = 'DK City';
        lstWorksiteAcc[0].Postal_Address_Country__c = 'DK';
        lstWorksiteAcc[0].Registration_Country__c = 'DK';
        lstWorksiteAcc[0].Postal_Address_Postal_Code__c = '1234';
        
        lstextensionAcc[0].Duplicate_checked__c = true;
        lstextensionAcc[0].MODTager_Duplicate_checked__c = true;
        lstextensionAcc[0].Verified__c = 'N';
        lstextensionAcc[0].Deletion_Flag__c = true;
        lstextensionAcc[0].Short_Name__c = lstextensionAcc[0].Name;
        lstextensionAcc[0].MOD_Modtager_Number__c = '99992';
        lstextensionAcc[0].MOD_Interessent_Number__c = '55552';
        lstextensionAcc[0].External_Provider_Party_ID__c = '33332';
        lstextensionAcc[0].Postal_Address_City__c = 'DK City';
        lstextensionAcc[0].Postal_Address_Country__c = 'DK';
        lstextensionAcc[0].Registration_Country__c = 'DK';
        lstextensionAcc[0].Postal_Address_Postal_Code__c = '1234';
        //********************************************************
        
        //************Duplicate_checked__c,MODTager_Duplicate_checked__c & MODInteressent_Duplicate_checked__c.
        lstWorksiteAcc[1].Duplicate_checked__c = true;
        lstWorksiteAcc[1].MODTager_Duplicate_checked__c = true;
        lstWorksiteAcc[1].MODInteressent_Duplicate_checked__c =true;
        lstWorksiteAcc[1].Verified__c = 'N';
        lstWorksiteAcc[1].MOD_Modtager_Number__c = '00003';
        lstWorksiteAcc[1].Short_Name__c = lstWorksiteAcc[1].Name;
        lstWorksiteAcc[1].MOD_Modtager_Number__c = '99993';
        lstWorksiteAcc[1].MOD_Interessent_Number__c = '55553';
        lstWorksiteAcc[1].External_Provider_Party_ID__c = '33333';
        lstWorksiteAcc[1].Postal_Address_City__c = 'DK City';
        lstWorksiteAcc[1].Postal_Address_Country__c = 'DK';
        lstWorksiteAcc[1].Registration_Country__c = 'DK';
        lstWorksiteAcc[1].Postal_Address_Postal_Code__c = '1234';
                    
        lstextensionAcc[1].Deletion_Flag__c = true;
        lstextensionAcc[1].Duplicate_checked__c = true;
        lstextensionAcc[1].MODTager_Duplicate_checked__c = true;
        lstextensionAcc[1].MODInteressent_Duplicate_checked__c =true;
        lstextensionAcc[1].Verified__c = 'N';
        lstextensionAcc[1].Short_Name__c = lstextensionAcc[1].Name;
        lstextensionAcc[1].MOD_Modtager_Number__c = '99994';
        lstextensionAcc[1].MOD_Interessent_Number__c = '55554';
        lstextensionAcc[1].External_Provider_Party_ID__c = '33334';
        lstextensionAcc[1].Postal_Address_City__c = 'DK City';
        lstextensionAcc[1].Postal_Address_Country__c = 'DK';
        lstextensionAcc[1].Registration_Country__c = 'DK';
        lstextensionAcc[1].Postal_Address_Postal_Code__c = '1234';
        //********************************************************************
        
        update lstWorksiteAcc;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        update lstextensionAcc;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
                        
        //Creating PossibleDuplicateAccount__c record.
        PossibleDuplicateAccount__c possDuplicate0 = new PossibleDuplicateAccount__c();
        possDuplicate0.Account__c = lstWorksiteAcc[0].Id;
        possDuplicate0.Possible_Duplicate_Account__c = lstextensionAcc[0].Id;
        //possDuplicate0.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c;
        possibleDuplicatelst.add(possDuplicate0);
        
        //Creating PossibleDuplicateAccount__c record.
        PossibleDuplicateAccount__c possDuplicate1 = new PossibleDuplicateAccount__c();
        possDuplicate1.Account__c = lstWorksiteAcc[1].Id;
        possDuplicate1.Possible_Duplicate_Account__c = lstextensionAcc[1].Id;
        //possDuplicate1.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c+';'+scheduledParameters.Duplicate_reason_MOD_Intressent_Nr__c;
        possibleDuplicatelst.add(possDuplicate1);
        
        insert possibleDuplicatelst;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
            
        // Act
        Test.startTest();
        //delete extensionAcc;
        
        //AccountId List
        List<Id> worksiteIdList = new List<Id>();
        worksiteIdList.add(lstWorksiteAcc[0].Id);
        worksiteIdList.add(lstWorksiteAcc[1].Id);
        
        List<Account> updateworksitelst = [Select Short_Name__c,Postal_Address_City__c,Postal_Address_Country__c,MOD_Modtager_Number__c,MOD_Interessent_Number__c,
                                            External_Provider_Party_ID__c FROM Account WHERE id IN:worksiteIdList]; 
        
        updateworksitelst[0].MOD_Modtager_Number__c = '7777';
        updateworksitelst[1].MOD_Modtager_Number__c = '2222';
        //worksitelst[0].MOD_Modtager_Number__c = '7777';
        //worksitelst[1].MOD_Modtager_Number__c = '2222';
        update updateworksitelst;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        // Assert
        System.assertEquals(true, [SELECT Id, Duplicate_checked__c FROM Account WHERE Id = :updateworksitelst[0].id].Duplicate_checked__c);
        System.assertEquals(true, [SELECT Id, Duplicate_checked__c FROM Account WHERE Id = :lstWorksiteAcc[0].id].Duplicate_checked__c);
        System.assertEquals(true, [SELECT Id, MODTager_Duplicate_checked__c FROM Account WHERE Id = :updateworksitelst[0].id].MODTager_Duplicate_checked__c);
        System.assertEquals(true, [SELECT Id, MODTager_Duplicate_checked__c FROM Account WHERE Id = :lstWorksiteAcc[0].id].MODTager_Duplicate_checked__c);
        Test.stopTest();                                                           
        //System.assertEquals(0,[SELECT count() FROM PossibleDuplicateAccount__c]);
 
    }
    
    //13. Test deletePossibleDuplicates method of Account_SVC,if Checking Duplicate_checked__c is set as true.
    static testMethod void deletePossibleDuplicates_Test1(){
        
        //Arange
        createData();
        
        lstWorksiteAcc.add((Account)lstWkAcc[0]);
        lstextensionAcc = (list<Account>)lstExAcc;
        possibleDuplicatelst = new list<PossibleDuplicateAccount__c>();
        
        //Get the Parent LE and set the VAT Number to match the new WS value
        String queryLE = 'SELECT Id From Account WHERE Id =\'' + lstWorksiteAcc[0].get('ParentId') + '\'';
        Account LE = Database.query(queryLE);
        LE.Registration_Country__c = 'DK';
        LE.Postal_Address_Country__c = 'DK';
        update LE;
        
        //************Duplicate_checked__c & MODTager_Duplicate_checked__c
        lstWorksiteAcc[0].Duplicate_checked__c = true;
        lstWorksiteAcc[0].MODTager_Duplicate_checked__c = true;
        lstWorksiteAcc[0].Verified__c = 'N';
        lstWorksiteAcc[0].MOD_Modtager_Number__c = '00001';
        lstWorksiteAcc[0].Short_Name__c = lstWorksiteAcc[0].Name;
        lstWorksiteAcc[0].MOD_Modtager_Number__c = '99991';
        lstWorksiteAcc[0].MOD_Interessent_Number__c = '55551';
        lstWorksiteAcc[0].External_Provider_Party_ID__c = '33331';
        lstWorksiteAcc[0].Postal_Address_City__c = 'DK City';
        lstWorksiteAcc[0].Postal_Address_Country__c = 'DK';
        lstWorksiteAcc[0].Registration_Country__c = 'DK';
        lstWorksiteAcc[0].Postal_Address_Postal_Code__c = '1234';
        //worksitelst.add(worksiteAcc);
        
        lstextensionAcc[0].Duplicate_checked__c = true;
        lstextensionAcc[0].MODTager_Duplicate_checked__c = true;
        lstextensionAcc[0].Verified__c = 'N';
        lstextensionAcc[0].Deletion_Flag__c = true;
        lstextensionAcc[0].Short_Name__c = lstextensionAcc[0].Name;
        lstextensionAcc[0].MOD_Modtager_Number__c = '99992';
        lstextensionAcc[0].MOD_Interessent_Number__c = '55552';
        lstextensionAcc[0].External_Provider_Party_ID__c = '33332';
        lstextensionAcc[0].Postal_Address_City__c = 'DK City';
        lstextensionAcc[0].Postal_Address_Country__c = 'DK';
        lstextensionAcc[0].Registration_Country__c = 'DK';
        lstextensionAcc[0].Postal_Address_Postal_Code__c = '1234';
        //extensionlst.add(extensionAcc);
        //********************************************************
        
        update lstWorksiteAcc;
        update lstextensionAcc;
        
        //Creating PossibleDuplicateAccount__c record.
        PossibleDuplicateAccount__c possDuplicate0 = new PossibleDuplicateAccount__c();
        possDuplicate0.Account__c = lstWorksiteAcc[0].Id;
        possDuplicate0.Possible_Duplicate_Account__c = lstextensionAcc[0].Id;
        //possDuplicate0.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c;
        possibleDuplicatelst.add(possDuplicate0);
        
        insert possibleDuplicatelst;
        
        // Act
        Test.startTest();
        for(Account acc : lstextensionAcc){
            acc.Deletion_Flag__c = true;
        }
        update lstextensionAcc;
        
        delete lstextensionAcc;
        Test.stopTest();
        
        System.assertEquals(0, [SELECT count() FROM PossibleDuplicateAccount__c WHERE Possible_Duplicate_Account__c = :lstextensionAcc[0].id]);
    }
    
    //14. This method test that possibleduplicate records are not deletetd if an error occurred.
    static testMethod void deletePossibleDuplicates_Test2(){
        
        //Arange
        createData();
        
        lstWorksiteAcc.add((Account)lstWkAcc[0]);
        lstextensionAcc = (list<Account>)lstExAcc;
        possibleDuplicatelst = new list<PossibleDuplicateAccount__c>();
        
        //Get the Parent LE and set the VAT Number to match the new WS value
        String queryLE = 'SELECT Id From Account WHERE Id =\'' + lstWorksiteAcc[0].get('ParentId') + '\'';
        Account LE = Database.query(queryLE);
        LE.Registration_Country__c = 'DK';
        LE.Postal_Address_Country__c = 'DK';
        update LE;
        
        //************Duplicate_checked__c & MODTager_Duplicate_checked__c
        lstWorksiteAcc[0].Duplicate_checked__c = true;
        lstWorksiteAcc[0].MODTager_Duplicate_checked__c = true;
        lstWorksiteAcc[0].Verified__c = 'N';
        lstWorksiteAcc[0].MOD_Modtager_Number__c = '00001';
        lstWorksiteAcc[0].Short_Name__c = lstWorksiteAcc[0].Name;
        lstWorksiteAcc[0].MOD_Modtager_Number__c = '99991';
        lstWorksiteAcc[0].MOD_Interessent_Number__c = '55551';
        lstWorksiteAcc[0].External_Provider_Party_ID__c = '33331';
        lstWorksiteAcc[0].Postal_Address_City__c = 'DK City';
        lstWorksiteAcc[0].Postal_Address_Country__c = 'DK';
        lstWorksiteAcc[0].Registration_Country__c = 'DK';
        lstWorksiteAcc[0].Postal_Address_Postal_Code__c = '1234';
        //worksitelst.add(worksiteAcc);
        
        lstextensionAcc[0].Duplicate_checked__c = true;
        lstextensionAcc[0].MODTager_Duplicate_checked__c = true;
        lstextensionAcc[0].Verified__c = 'N';
        lstextensionAcc[0].Deletion_Flag__c = true;
        lstextensionAcc[0].Short_Name__c = lstextensionAcc[0].Name;
        lstextensionAcc[0].MOD_Modtager_Number__c = '99992';
        lstextensionAcc[0].MOD_Interessent_Number__c = '55552';
        lstextensionAcc[0].External_Provider_Party_ID__c = '33332';
        lstextensionAcc[0].Postal_Address_City__c = 'DK City';
        lstextensionAcc[0].Postal_Address_Country__c = 'DK';
        lstextensionAcc[0].Registration_Country__c = 'DK';
        lstextensionAcc[0].Postal_Address_Postal_Code__c = '1234';
        //extensionlst.add(extensionAcc);
        //********************************************************
        
        update lstWorksiteAcc;
        update lstextensionAcc;
        
        //Creating PossibleDuplicateAccount__c record.
        PossibleDuplicateAccount__c possDuplicate0 = new PossibleDuplicateAccount__c();
        possDuplicate0.Account__c = lstWorksiteAcc[0].Id;
        possDuplicate0.Possible_Duplicate_Account__c = lstextensionAcc[0].Id;
        //possDuplicate0.Duplicate_reason__c = scheduledParameters.Duplicate_reason_Batch__c+';'+scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c;
        possibleDuplicatelst.add(possDuplicate0);
        
        insert possibleDuplicatelst;
        
        // Act
        Test.startTest();
        for(Account acc : lstextensionAcc){
            acc.Deletion_Flag__c = false;
        }
        update lstextensionAcc;
        
        try{
            delete lstextensionAcc;
        }catch(EXCEPTION e){
            system.debug('++++e+++'+e);
        }
        
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM PossibleDuplicateAccount__c WHERE Possible_Duplicate_Account__c = :lstextensionAcc[0].id]);
    }
    
    // 15. This test method tests that the Postal Address Country is copied to Registration Country when it should be
    static testMethod void testPostalAddressCountryToRegistrationCountryCopyingPositive(){
        //Arrange & Act
        adminUser = UTIL_TestFactory.createAdmin('adminUser_owimrefowef@user.com');
        list<Account> leAccounts = new list<Account>();
        list<Account> nonLeAccounts = new list<Account>();
        System.runAs(adminUser) {
            test.startTest();
            //Test for Legal Entity
            Account legalEntity = UTIL_TestFactory.createAccount();
            legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            legalEntity.Registration_Country__c = '';
            legalEntity.Postal_Address_Country__c = 'BA';
            leAccounts.add(legalEntity);

            //Test for Extension
            Account legalEntityExt = UTIL_TestFactory.createAccount();
            legalEntityExt.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            leAccounts.add(legalEntityExt);
            
            insert leAccounts;
            //Test for Work Site
            Account workSite = UTIL_TestFactory.createAccount();
            workSite.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSite.Registration_Country__c = '';
            workSite.Postal_Address_Country__c = 'BA';
            nonLeAccounts.add(workSite);
            
            Account workSiteExt = UTIL_TestFactory.createAccount();
            workSiteExt.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSiteExt.ParentId = legalEntityExt.Id;
            nonLeAccounts.add(workSiteExt);
            
            insert nonLeAccounts;
            
            Sales_Area_Information__c wsSAI = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c =: workSiteExt.Id];
            wsSAI.Type__c = 'Customer';
            update wsSAI;
            
            Account extension = UTIL_TestFactory.createAccount();
            extension.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            extension.Parent = workSiteExt;
            extension.Registration_Country__c = '';
            extension.Postal_Address_Country__c = 'BA';
            insert extension;
            test.stopTest();
            //Assert
            Account insertedLegalEntity = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: legalEntity.Id];
            Account insertedWorkSite = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: workSite.Id];
            Account insertedExtension = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: extension.Id];
            
            System.assertEquals(insertedLegalEntity.Postal_Address_Country__c, insertedLegalEntity.Registration_Country__c, 'The Postal Address Country was not copied to Registration Country');
            System.assertEquals(insertedWorkSite.Postal_Address_Country__c, insertedWorkSite.Registration_Country__c, 'The Postal Address Country was not copied to Registration Country');
            System.assertEquals(insertedExtension.Postal_Address_Country__c, insertedExtension.Registration_Country__c, 'The Postal Address Country was not copied to Registration Country');
        }
    }

    // 16. This test method tests that the Postal Address Country is not copied to Registration Country when it should  not be
    static testMethod void testPostalAddressCountryToRegistrationCountryCopyingNegative(){
        //Arrange & Act

        User adminTestUser = UTIL_TestFactory.createAdmin('adminUser_owimrqwdqwefowef@user.com');
        Test.startTest();
        System.runAs(adminTestUser) {
            //Test for Legal Entity
            Account legalEntity = UTIL_TestFactory.createAccount();
            legalEntity.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            legalEntity.Registration_Country__c = 'DK';
            legalEntity.Postal_Address_Country__c = 'BA';
            legalEntity.Postal_Address_PO_Box__c = 'Box 123';
            insert legalEntity;
            
            //Test for Work Site
            Account workSite = UTIL_TestFactory.createAccount();
            workSite.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSite.Registration_Country__c = 'DK';
            workSite.Postal_Address_Country__c = 'BA';
            workSite.Postal_Address_PO_Box__c = 'Box 123';
            insert workSite;
            
            //Test for Extension
            Account legalEntityExt = UTIL_TestFactory.createAccount();
            legalEntityExt.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
            insert legalEntityExt;
            
            Account workSiteExt = UTIL_TestFactory.createAccount();
            workSiteExt.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            workSiteExt.ParentId = legalEntityExt.Id;
            insert workSiteExt;
            
            Sales_Area_Information__c wsSAI = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c =: workSiteExt.Id];
            wsSAI.Type__c = 'Customer';
            update wsSAI;
            
            Account extension = UTIL_TestFactory.createAccount();
            extension.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            extension.Parent = workSiteExt;
            extension.Registration_Country__c = 'DK';
            extension.Postal_Address_Country__c = 'BA';
            extension.Postal_Address_PO_Box__c = 'Box 123';
            
            //Test for External Partner
            Account externalPartner = UTIL_TestFactory.createAccount();
            externalPartner.RecordTypeId = UTIL_Meta.getAccountExternalPartnerRT();
            externalPartner.Registration_Country__c = '';
            externalPartner.Postal_Address_Country__c = 'BA';

            test.stopTest();            
            //Test for Competitor
            Account competitor = UTIL_TestFactory.createAccount();
            competitor.RecordTypeId = UTIL_Meta.getAccountCompetitorRT();
            competitor.Registration_Country__c = '';
            competitor.Postal_Address_Country__c = 'BA';
            
            List<Account> accountsToInsert = new List<Account>();
            accountsToInsert.add(extension);
            accountsToInsert.add(externalPartner);
            accountsToInsert.add(competitor);
            insert accountsToInsert;

            //Assert
            Account insertedLegalEntity = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: legalEntity.Id];
            Account insertedWorkSite = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: workSite.Id];
            Account insertedExtension = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: extension.Id];
            Account insertedExternalPartner = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: externalPartner.Id];
            Account insertedCompetitor = [SELECT Id, Postal_Address_Country__c, Registration_Country__c FROM Account WHERE Id =: competitor.Id];
            
            System.assertNotEquals(legalEntity.Postal_Address_Country__c, legalEntity.Registration_Country__c, 'The Postal Address Country was copied to Registration Country but it should not');
            System.assertNotEquals(workSite.Postal_Address_Country__c, workSite.Registration_Country__c, 'The Postal Address Country was copied to Registration Country but it should not');
            System.assertNotEquals(extension.Postal_Address_Country__c, extension.Registration_Country__c, 'The Postal Address Country was not copied to Registration Country but it should not');
            System.assertNotEquals(insertedExternalPartner.Postal_Address_Country__c, insertedExternalPartner.Registration_Country__c, 'The Postal Address Country was copied to Registration Country but it should not');
            System.assertNotEquals(insertedCompetitor.Postal_Address_Country__c, insertedCompetitor.Registration_Country__c, 'The Postal Address Country was copied to Registration Country but it should not');
        }
    }
    
    // Test inserting a list of accounts all duplicates
    static testMethod void testDuplicateOnInsert(){
        UTIL_TestFactory.setUpOrg();
        
        list<Account> duplicateAccounts = createDuplicateTestData();
        test.startTest();
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        system.assertEquals(false,G2O_Account_SVC.DUPCHECK_RUNNING);
        insert duplicateAccounts;
        test.stopTest();
        
        duplicateAccounts = [select id, ModInteressentDuplicate__c, ModModtagerDuplicate__c, AddressDuplicate__c from Account where recordTypeId = :UTIL_Meta.getAccountWorkSiteRT()];
        for(Account acc : duplicateAccounts){
            system.assertEquals(true, acc.ModInteressentDuplicate__c, duplicateAccounts);
            system.assertEquals(true, acc.ModModtagerDuplicate__c, duplicateAccounts);
            system.assertEquals(true, acc.AddressDuplicate__c, acc);
        }
    }
    
    
    // Test inserting a list of accounts matching an already existing account
    static testMethod void testDuplicateOnInsertWithOneException(){
        UTIL_TestFactory.setUpOrg();
        
        list<Account> duplicateAccounts = createDuplicateTestData();
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        system.assertEquals(false,G2O_Account_SVC.DUPCHECK_RUNNING);
        Account acct = duplicateAccounts[0];
        duplicateAccounts.remove(0);
        test.startTest();
        system.assertEquals(false, acct.ModInteressentDuplicate__c);
        system.assertEquals(false, acct.ModModtagerDuplicate__c);
        system.assertEquals(false, acct.AddressDuplicate__c);
        insert acct;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        system.assertEquals(false,G2O_Account_SVC.DUPCHECK_RUNNING);
        acct = [select id, ModInteressentDuplicate__c, ModModtagerDuplicate__c, AddressDuplicate__c from Account Where id = :acct.id];      
        system.assertEquals(false, acct.ModInteressentDuplicate__c, acct);
        system.assertEquals(false, acct.ModModtagerDuplicate__c, acct);
        system.assertEquals(false, acct.AddressDuplicate__c, acct);

        insert duplicateAccounts;
        test.stopTest();
        
        duplicateAccounts = [select id, MOD_Modtager_Number__c, MOD_Interessent_Number__c, ModInteressentDuplicate__c, ModModtagerDuplicate__c, AddressDuplicate__c from Account where recordTypeId = :UTIL_Meta.getAccountWorkSiteRT()];
        for(Account acc : duplicateAccounts){
            system.assertEquals(true, acc.ModInteressentDuplicate__c, duplicateAccounts);
            system.assertEquals(true, acc.ModModtagerDuplicate__c);
            system.assertEquals(true, acc.AddressDuplicate__c);

        }
    }

    // Test inserting a list of accounts matching an already existing account
    static testMethod void testDuplicateOnUpdate(){
        UTIL_TestFactory.setUpOrg();
        
        list<Account> duplicateAccounts = createDuplicateTestData();
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        system.assertEquals(false,G2O_Account_SVC.DUPCHECK_RUNNING);
        Account acct = duplicateAccounts[0];
        String duplicateModtagerNumber = acct.MOD_Modtager_Number__c;
        acct.MOD_Modtager_Number__c = '1';
        duplicateAccounts.remove(0);
        test.startTest();
        system.assertEquals(false, acct.ModInteressentDuplicate__c);
        system.assertEquals(false, acct.ModModtagerDuplicate__c);
        system.assertEquals(false, acct.AddressDuplicate__c);
        insert acct;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        system.assertEquals(false,G2O_Account_SVC.DUPCHECK_RUNNING);
        acct = [select id, ModInteressentDuplicate__c, ModModtagerDuplicate__c, AddressDuplicate__c from Account Where id = :acct.id];      
        system.assertEquals(false, acct.ModInteressentDuplicate__c);
        system.assertEquals(false, acct.ModModtagerDuplicate__c);
        system.assertEquals(false, acct.AddressDuplicate__c);

        insert duplicateAccounts;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        system.assertEquals(false,G2O_Account_SVC.DUPCHECK_RUNNING);
        acct = [select id, ModInteressentDuplicate__c, ModModtagerDuplicate__c, AddressDuplicate__c from Account Where id = :acct.id];      
        system.assertEquals(false, acct.ModModtagerDuplicate__c);
        acct.MOD_Modtager_Number__c = duplicateModtagerNumber;
        update acct;
        test.stopTest();
        
        duplicateAccounts = [select id, MOD_Modtager_Number__c, MOD_Interessent_Number__c, ModInteressentDuplicate__c, ModModtagerDuplicate__c, AddressDuplicate__c from Account where recordTypeId = :UTIL_Meta.getAccountWorkSiteRT()];
        for(Account acc : duplicateAccounts){
            system.assertEquals(true, acc.ModInteressentDuplicate__c, duplicateAccounts);
            system.assertEquals(true, acc.ModModtagerDuplicate__c);
            system.assertEquals(true, acc.AddressDuplicate__c);
        }
    }
        
    //Test data for Do Not Update Functionality.
    static void createTestForDoNotUpdate(){
        
        UTIL_TestFactory.setUpOrg();
        adminUser = UTIL_TestFactory.createAdmin('testAdmin@get2One.com');
        integrationUser = UTIL_TestFactory.createIntegrationUser('testIntegration@get2One.com');
        
        wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
        extrTypeId= UTIL_Meta.getAccountExtensionRT();
        lerTypeId  = UTIL_Meta.getAccountLegalEntityRT();
        
        fieldSet0 = SObjectType.Account.FieldSets.doNotUpdateFieldsForIntegrationUsers.getFields();
        fieldSet1 = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
    
        //***Creating Legal Entity****
        Account legalEntity = UTIL_TestFactory.createAccount();
        legalEntity.RecordTypeId = lerTypeId;
        legalEntity.Postal_Address_Country__c = 'BA';
        legalEntity.Registration_Country__c = 'BA';
        legalEntity.VAT_Number__c = 'DK34943400';
        insert legalEntity;
    
        //***Creating Work Site****
        for(Integer i = 0; i < 100; i++){
            
            sObject accRec    = UTIL_TestFactory.createAccount();
            accRec.put('RecordTypeId',wrkrTypeId);
            accRec.put('ParentId', legalEntity.Id);
            
            if(i < 50){
                accRec.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',true);//Setting the Do not update Address fields.
            }
            lstWkAcc.add(accRec);
        }
        //Updating WorkSites fields as ##5555#.
        for (Integer j = 0; j <lstWkAcc.size(); j++) {

            
            for(Integer i=0; i<fieldSet0.size(); i++) {
                String fieldAPIName = fieldSet0[i].getFieldPath();
                
                system.debug('+++lstWorksiteAcc77+++'+(fieldSet0[i].getType()));
                if(String.valueOf(fieldSet0[i].getType()) == 'STRING'){
                    lstWkAcc[j].put(fieldAPIName,'##5555##');
                }
            }  
            lstWkAcc[j].put('Postal_Address_Country__c','BA'); 
            lstWkAcc[j].put('Registration_Country__c','BA');
            lstWkAcc[j].put('Visiting_Address_Country__c','BA');
            lstWkAcc[j].put('VAT_Number__c', 'DK34943400');            
            
        }
        insert lstWkAcc;
        
        //Update all SAIs on WSs to Customer to pass Extension validation rule
        List<Sales_Area_Information__c> wsSAIs = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c IN: lstWkAcc];
        for (Sales_Area_Information__c SAI : wsSAIs) {
            SAI.Type__c = 'Customer';
        }
        update wsSAIs;
    
        //***Creating Extensions****
        for(Integer i = 0; i < 100; i++){
            
            sObject accRec    = UTIL_TestFactory.createAccount();
            accRec.put('RecordTypeId',extrTypeId);
            accRec.put('ParentId',lstWkAcc[i].Id);
            accRec.put('Postal_Address_Country__c','BA');
            accRec.put('Registration_Country__c','BA');
            
            if(i < 50){
                accRec.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',true);//Setting the Do not update Address fields.
            }
            lstExAcc.add(accRec);
        }
        
        //Updating Extensions fields as ##9999#.
        for (Integer j = 0; j < lstExAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet1.size(); i++) {
                String fieldAPIName = fieldSet1[i].getFieldPath();

                system.debug('+++lstWorksiteAcc77+++'+(fieldSet1[i].getType()));
                if(String.valueOf(fieldSet1[i].getType()) == 'STRING'){
                    lstExAcc[j].put(fieldAPIName,'##9999##');
                }
            }   
        }
        system.runAs(integrationUser){
            insert lstExAcc;
        }
    }
    
    //creating test data.
    static void createData() {
        
        UTIL_TestFactory.setUpOrg();
        
        //Creating custom settings.
        scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        //scheduledParameters.Duplicate_reason_Batch__c ='Similar Name / Address Fields';
        //scheduledParameters.Duplicate_reason_MOD_Intressent_Nr__c = 'MOD Intressent Number';
        //scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c = 'MOD Modtager Number';
        //scheduledParameters.Duplicate_reason_PAR__c = 'External provider party ID';
        update scheduledParameters;
        
        usr = UTIL_TestFactory.createAdmin('test@get2One.com');
        
        wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
        extrTypeId = UTIL_Meta.getAccountExtensionRT();
        lerTypeId  = UTIL_Meta.getAccountLegalEntityRT();
        
        List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
        fieldSet = SObjectType.Account.FieldSets.maintainFieldsFromWorkSiteToExtension.getFields();
        
        //***Creating Legal Entity****
        Account legalEntity = UTIL_TestFactory.createAccount();
        legalEntity.RecordTypeId = lerTypeId;
        legalEntity.Postal_Address_Country__c = 'BA';
        legalEntity.Registration_Country__c = 'BA';
        legalEntity.VAT_Number__c = 'DK34943400';
        
        //Possible duplicate LE
        legalEntityRec = UTIL_TestFactory.createAccount();
        legalEntityRec.RecordTypeId = lerTypeId;
        
        //Put the LEs in a list to keep down the SOQL queries
        List<Account> listOfLegalEntites = new List<Account>();
        listOfLegalEntites.add(legalEntity);
        listOfLegalEntites.add(legalEntityRec);
        insert listOfLegalEntites;
        
        //***Creating Work Sites****
        for(Integer i = 0; i < 199; i++){
            
            String externalProviderId = String.ValueOf('22:7654'+i);
            sObject accRec    = UTIL_TestFactory.createAccount();
            accRec.put('ParentId', legalEntity.Id);
            accRec.put('RecordTypeId',wrkrTypeId);
            accRec.put('External_Provider_Party_ID__c',externalProviderId);
            
            if(i < 100){
                accRec.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',true);//Setting the Do not update Address fields.
            }
            lstWkAcc.add(accRec);
        }
        
        for (Integer j = 0; j <lstWkAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldAPIName = fieldSet[i].getFieldPath();
                
                system.debug(Logginglevel.INFO,'+++lstWorksiteAcc77+++'+(fieldSet[i].getType()));
                if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
                    lstWkAcc[j].put('Postal_Address_Country__c','BA');
                    lstWkAcc[j].put('Registration_Country__c','BA');
                    lstWkAcc[j].put(fieldAPIName,'##7777##');
                    lstWkAcc[j].put('Name','##7777##');                    
                    lstWkAcc[j].put('VAT_Number__c', 'DK34943400');
                }
            }   
        }
        
        //Possible Duplicte WS. To be set as a parent Account.
        workSiteRec =  UTIL_TestFactory.createAccount();
        workSiteRec.RecordTypeId = wrkrTypeId;
        workSiteRec.ParentId = legalEntityRec.Id;
        
        //Put the WSs in a list to keep down the SOQL queries
        List<sObject> listOfWorkSites = new List<sObject>();
        listOfWorkSites.addAll(lstWkAcc);
        listOfWorkSites.add(workSiteRec);
        insert listOfWorkSites;
        
        //Update all SAIs on WSs to Customer to pass Extension validation rule
        List<Sales_Area_Information__c> wsSAIs = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c IN: listOfWorkSites];
        for (Sales_Area_Information__c SAI : wsSAIs) {
            SAI.Type__c = 'Customer';
        }
        update wsSAIs;
        
        //***Creating Extensions****
        for(Integer i = 0; i < 199; i++){
            
            sObject accRec    = UTIL_TestFactory.createAccount();
            accRec.put('RecordTypeId',extrTypeId);
            accRec.put('ParentId',lstWkAcc[i].Id);
            String externalProviderId = String.ValueOf('22:7655'+i);
            accRec.put('External_Provider_Party_ID__c',externalProviderId);
            
            if(i < 100){
                accRec.put('Do_Not_Update_Address_Automatically__c',false);//Setting the Do not update Address fields.
            }else{
                accRec.put('Do_Not_Update_Address_Automatically__c',true);//Setting the Do not update Address fields.
            }
            lstExAcc.add(accRec);
        }
        
        for (Integer j = 0; j < lstExAcc.size(); j++) {
            
            for(Integer i=0; i<fieldSet.size(); i++) {
                String fieldAPIName = fieldSet[i].getFieldPath();

                system.debug(Logginglevel.INFO,'+++lstWorksiteAcc77+++'+(fieldSet[i].getType()));
                if(String.valueOf(fieldSet[i].getType()) == 'STRING'){
                    lstExAcc[j].put('Postal_Address_Country__c','BA');
                    lstExAcc[j].put('Registration_Country__c','BA');
                    lstExAcc[j].put(fieldAPIName,'##9999##');
                    lstExAcc[j].put('Name','##9999##');
                    lstExAcc[j].put('VAT_Number__c', 'DK34943400');
                }
            }   
        }
        
        //Creating an extension to be set as a Possible_Duplicate__c fields.
        extensionRec = UTIL_TestFactory.createAccount();
        extensionRec.RecordTypeId = extrTypeId;
        extensionRec.ParentId = workSiteRec.Id;
        
        //Put the EXTs in a list to keep down the SOQL queries
        List<sObject> listOfExtensions = new List<sObject>();
        listOfExtensions.addAll(lstExAcc);
        listOfExtensions.add(extensionRec);
        insert listOfExtensions;
    }
    
    
    private static list<Account> createDuplicateTestData(){
        
        lerTypeId = UTIL_Meta.getAccountLegalEntityRT();
        wrkrTypeId = UTIL_Meta.getAccountWorkSiteRT();
        String fieldValue = 'tst001';
        
        //Creating CustomSetting.
        ScheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        //ScheduledParameters.Duplicate_reason_Batch__c = 'Other';
        //ScheduledParameters.Duplicate_reason_MOD_Intressent_Nr__c = 'MOD Intressent Number';
        //ScheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c = 'MOD Modtager Number';
        //ScheduledParameters.Duplicate_reason_PAR__c = 'External provider party ID';
        ScheduledParameters.AccountBatchJobInterval__c = '2';
        ScheduledParameters.AccountBatchHeapLimit__c = '7549747';
        ScheduledParameters.AccountBatchJobSize__c = '200';
        ScheduledParameters.AccountBatchDmlRowsLimit__c = '7000';
        
        //Creating WS so as to associate extensions.
        Account leAccount = UTIL_TestFactory.createAccount();
        leAccount.RecordTypeId = lerTypeId;
        insert leAccount;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        list<Account> lstAcc = new list<Account>();
        //Inserting accounts with RecordType as Extension
        for (Integer i = 0; i < 10; i++) {
            
            Account acc =  UTIL_TestFactory.createAccount();
            acc.Name = fieldValue;
            acc.short_name__c = fieldValue;
            acc.MOD_Modtager_Number__c = '12345678';
            acc.MOD_Interessent_Number__c = '87654321';
            lstAcc.add(acc);
        }
        return lstAcc;
    }

   // 17.Test duplicate account on insert and update for record type other then LE,WS PP
    static testMethod void testDuplicateOnAccountRecordTypes(){
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        
        List<Account> checkDuplicateToAccount = new List<Account>();
       
        for(RecordType accountRT :[select id,isPersonType from RecordType where sobjectType = 'Account']){
            if(accountRT.IsPersonType){
                Account acc = UTIL_TestFactory.createPersonAccount();
                acc.recordTypeId = accountRT.id;
                checkDuplicateToAccount.add(acc);
            }
            else{
                Account acc1 =  UTIL_TestFactory.createAccount();
                acc1.recordTypeId = accountRT.id;
                //Validation rules for extension has to be passed
                if(accountRT.id == UTIL_Meta.getAccountExtensionRT()) {
                    //Insert LE
                    Account accountLE = UTIL_TestFactory.createAccount();
                    accountLE.recordTypeId = UTIL_Meta.getAccountLegalEntityRT();
                    insert accountLE;
                    
                    //Insert WS
                    Account accountWS = UTIL_TestFactory.createAccount();
                    accountWS.recordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                    accountWS.ParentId = accountLE.Id;
                    insert accountWS;
                    
                    //Make SAI and WS to a Customer
                    Sales_Area_Information__c SAI = [SELECT Id FROM Sales_Area_Information__c WHERE Account__c = :accountWS.Id];
                    SAI.Type__c = 'Customer';
                    update SAI;
                    
                    acc1.ParentId = accountWS.Id;
                }
                checkDuplicateToAccount.add(acc1);
            }
        }
        
        //Act
        Test.startTest();
        insert checkDuplicateToAccount;
        
        for(Account a :[select Duplicate_checked__c , MODTager_Duplicate_checked__c ,MODInteressent_Duplicate_checked__c, RecordTypeId from Account]){
            if(a.recordTypeId == UTIL_Meta.getAccountLegalEntityRT() || a.recordTypeId == UTIL_Meta.getAccountWorkSiteRT()|| a.recordTypeId == UTIL_Meta.getPersonAccountRT()){
                //Asserts
                system.assertEquals(true, a.Duplicate_checked__c,'Account should be duplicate checked but it is not');
                system.assertEquals(true, a.MODTager_Duplicate_checked__c,'Account should be duplicate checked but it is not');
                system.assertEquals(true, a.MODInteressent_Duplicate_checked__c,'Account should be duplicate checked but it is not');
            }
            else{
                system.assertEquals(false, a.Duplicate_checked__c, 'Account should not be duplicate checked but is');
                system.assertEquals(false, a.MODTager_Duplicate_checked__c,'Account should not be duplicate checked but is');
                system.assertEquals(false, a.MODInteressent_Duplicate_checked__c,'Account should not be duplicate checked but is');
            }
        }
        update checkDuplicateToAccount;
        test.stopTest();
        
        for(Account a :[select Duplicate_checked__c , MODTager_Duplicate_checked__c ,MODInteressent_Duplicate_checked__c, RecordTypeId from Account]){
            if(a.recordTypeId == UTIL_Meta.getAccountLegalEntityRT()|| a.recordTypeId == UTIL_Meta.getAccountWorkSiteRT()|| a.recordTypeId == UTIL_Meta.getPersonAccountRT()){
                system.assertEquals(true, a.Duplicate_checked__c,'Account should be duplicate checked but it is not');
                system.assertEquals(true, a.MODTager_Duplicate_checked__c,'Account should be duplicate checked but it is not');
                system.assertEquals(true, a.MODInteressent_Duplicate_checked__c,'Account should be duplicate checked but it is not');
            }
            else{
                system.assertEquals(false, a.Duplicate_checked__c,'Account should not be duplicate checked but is');
                system.assertEquals(false, a.MODTager_Duplicate_checked__c,'Account should not be duplicate checked but is');
                system.assertEquals(false, a.MODInteressent_Duplicate_checked__c,'Account should not be duplicate checked but is');
            }
        }  
    } 
    
    //18. Test duplicate account on update to prevent recursive problem.
    static testMethod void replicateSelfReferenceError() {
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
  
        //Create 2 accounts
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            Account a = UTIL_TestFactory.createAccount();
            a.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
            a.Name = 'TESTNAME';
            a.Postal_Address_City__c = 'Copenhagen';
            a.Postal_Address_Country__c = 'DK';
            accounts.add(a);
        }
        
        //Act
        insert accounts;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        //Disable triggers to create test data
        DisableAutomation__c disableAutomation = DisableAutomation__c.getOrgDefaults();
        disableAutomation.Disable_All_Triggers__c = true;
        upsert disableAutomation;
        
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        //Assert
        System.assertEquals(true, UTIL_OrgSettings.isTriggersDisabled(), 'Triggers are not disabled');
        
        Account accountA = [SELECT Id, Duplicate_checked__c, MODInteressent_Duplicate_checked__c, MODTager_Duplicate_checked__c From Account WHERE Id = :accounts[0].Id];
        Account accountB = [SELECT Id, Duplicate_checked__c, MODInteressent_Duplicate_checked__c, MODTager_Duplicate_checked__c From Account WHERE Id = :accounts[1].Id];

        List<Account> accountsToUpdate = new List<Account>();
        accountA.Duplicate_checked__c = true;
        accountA.MODInteressent_Duplicate_checked__c = true;
        accountA.MODTager_Duplicate_checked__c = true;
        accountA.AddressDuplicate__c = false;
        accountsToUpdate.add(accountA);
        
        accountB.Duplicate_checked__c = false;
        accountB.MODInteressent_Duplicate_checked__c = false;
        accountB.MODTager_Duplicate_checked__c = false;
        accountsToUpdate.add(accountB);
        update accountsToUpdate;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
      
        
        //Activate triggers again to gain all functionality
        disableAutomation.Disable_All_Triggers__c = false;
        
        upsert disableAutomation;
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        
        
        System.assertEquals(false, UTIL_OrgSettings.isTriggersDisabled(), 'Triggers are disabled');
        
        //Update one of the accounts
        accountA.Postal_Address_City__c = 'City2';
        G2O_Account_SVC.DUPCHECK_RUNNING = false;
        system.assertEquals(false,G2O_Account_SVC.DUPCHECK_RUNNING);
        
        Test.startTest();
        update accountA;
        Test.stopTest();
        
        //asserts
        system.assertEquals(true, accountA.Duplicate_checked__c);
        system.assertEquals(true, accountA.MODTager_Duplicate_checked__c);
        system.assertEquals(true, accountA.MODInteressent_Duplicate_checked__c);
        
    }
}