/**
 *  Tests the use case of pressing the VAP Request Button on Case
 * 
 *
 */
@isTest
private class G2O_VAPRequest_WSx_TEST {

    // This test mimic the pressing of the VAP Request button
    static testMethod void vapRequestButton() {
        
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsVAP');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        
        Account reciverAccount = UTIL_TestFactory.createAccount();
        reciverAccount.Is_MOD_Validated__c = true;
        reciverAccount.MOD_Address_Number__c = '123456789';
        reciverAccount.Postal_Address_Postal_Code__c = '1234';
        insert reciverAccount;
        
        Account distributionCenter = UTIL_TestFactory.createAccount();
        distributionCenter.Name = 'distributionCenter';
        distributionCenter.MOD_Interessent_Number__c = '624842017';
        distributionCenter.RecordTypeId = UTIL_Meta.getAccountPostNordOrgStructureRT();
        insert distributionCenter;
        
        Account distributionTeam = UTIL_TestFactory.createAccount();
        distributionTeam.Name = 'distributionTeam';
        distributionTeam.MOD_Interessent_Number__c = '612062752';
        distributionTeam.RecordTypeId = UTIL_Meta.getAccountPostNordOrgStructureRT();
        insert distributionTeam;
        
        Account pickUpPostOffice = UTIL_TestFactory.createAccount();
        pickUpPostOffice.Name = 'distributionCenter';
        pickUpPostOffice.MOD_Interessent_Number__c = '741576406';
        pickUpPostOffice.RecordTypeId = UTIL_Meta.getAccountPostNordOrgStructureRT();
        insert pickUpPostOffice;
        
        Case vapCase = UTIL_TestFactory.createCase();
        vapCase.Receiver__c = reciverAccount.Id;
        vapCase.Receiver_Postal_Address_Postal_Code__c = '1234';
        insert vapCase;
        
        VAP_Team__c v = new VAP_Team__c();
        v.Case__c = vapCase.Id; // The represent and old search
        
        // Act
        Test.setMock(HttpCalloutMock.class, successfulMock);
        Test.startTest();
        
        //Mimic  pressing the button
        String result = G2O_VAPRequest_WSx.doVapRequest(vapCase.Id);
        
        Test.stopTest();     
        
        // Assert
        List<VAP_Team__c> vapTeams = [SELECT Id, Parcel_Letter__c,Route_Description__c, Route_no__c, VAP_Unit__c FROM VAP_Team__c WHERE Case__c = :vapCase.Id];
                   
        System.assertEquals('', result); // No error is returned
        System.assertEquals(6, vapTeams.size()); // All 6 vap team is created, and the old was removed
        System.assertNotEquals(null, vapTeams[0].Parcel_Letter__c);
        System.assertNotEquals(null, vapTeams[0].Route_Description__c);
        System.assertNotEquals(null, vapTeams[0].Route_no__c);
        System.assertNotEquals(null, vapTeams[0].VAP_Unit__c);
        
    }
    
    static testMethod void vapRequestButtonError1405() {
        
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponsErrorVAP');
        errorMock.setStatusCode(200);
        errorMock.setHeader('Content-Type', 'text/xml');
        
        Account reciverAccount = UTIL_TestFactory.createAccount();
        reciverAccount.Is_MOD_Validated__c = true;
        reciverAccount.MOD_Address_Number__c = '123456789';
        reciverAccount.Postal_Address_Postal_Code__c = '1234';
        insert reciverAccount;
        
        Case vapCase = UTIL_TestFactory.createCase();
        vapCase.Receiver__c = reciverAccount.Id;
        vapCase.Receiver_Postal_Address_Postal_Code__c = '1234';
        insert vapCase;
        
        // Act
        Test.setMock(HttpCalloutMock.class, errorMock);
        Test.startTest();
        
        //Mimic  pressing the button
        String result = G2O_VAPRequest_WSx.doVapRequest(vapCase.Id);
        
        Test.stopTest();     
        
        // Assert
        System.assertNotEquals('', result); // An error is returned
        
    }
    
    static testMethod void vapRequestButtonErrorOther() {
        
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock errorMock = new StaticResourceCalloutMock();
        errorMock.setStaticResource('TestMockResponsVAP');
        errorMock.setStatusCode(400);
        errorMock.setHeader('Content-Type', 'text/xml');
        
        Account reciverAccount = UTIL_TestFactory.createAccount();
        reciverAccount.Is_MOD_Validated__c = true;
        reciverAccount.MOD_Address_Number__c = '123456789';
        reciverAccount.Postal_Address_Postal_Code__c = '1234';
        insert reciverAccount;
        
        Case vapCase = UTIL_TestFactory.createCase();
        vapCase.Receiver__c = reciverAccount.Id;
        vapCase.Receiver_Postal_Address_Postal_Code__c = '1234';
        insert vapCase;
        
        // Act
        Test.setMock(HttpCalloutMock.class, errorMock);
        Test.startTest();
        
        //Mimic  pressing the button
        String result = G2O_VAPRequest_WSx.doVapRequest(vapCase.Id);
        
        Test.stopTest();     
        
        // Assert
        System.assertNotEquals('', result); // An error is returned
        
    }
    
    static testMethod void vapRequestButtonMappingException() {
        
        // Arrange
        UTIL_TestFactory.setUpOrg();
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsVAP');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        
        Account reciverAccount = UTIL_TestFactory.createAccount();
        insert reciverAccount;
        
        Case vapCase = UTIL_TestFactory.createCase();
        vapCase.Receiver__c = reciverAccount.Id;
        vapCase.Receiver_Postal_Address_Postal_Code__c = '1234';
        insert vapCase;
        
        // Act
        Test.setMock(HttpCalloutMock.class, successfulMock);
        Test.startTest();
        
        //Mimic  pressing the button
        String result = G2O_VAPRequest_WSx.doVapRequest(vapCase.Id);
        
        Test.stopTest();     
        
        // Assert
        System.assertNotEquals('', result); // An error is returned
        
    }
    
    // This will thown an exeption since we don't use Test.setMock
    static testMethod void vapRequestButtonException() {
        
        // Arrange
        UTIL_TestFactory.setUpOrg();
        
        Account reciverAccount = UTIL_TestFactory.createAccount();
        reciverAccount.Is_MOD_Validated__c = true;
        reciverAccount.MOD_Address_Number__c = '123456789';
        reciverAccount.Postal_Address_Postal_Code__c = '1234';
        insert reciverAccount;
        
        Case vapCase = UTIL_TestFactory.createCase();
        vapCase.Receiver__c = reciverAccount.Id;
        vapCase.Receiver_Postal_Address_Postal_Code__c = '1234';
        insert vapCase;
        
        // Act
        Test.startTest();
        
        //Mimic  pressing the button
        String result = G2O_VAPRequest_WSx.doVapRequest(vapCase.Id);
        
        Test.stopTest();     
        
        // Assert
        System.assertNotEquals('', result); // An error is returned
        
    }
}