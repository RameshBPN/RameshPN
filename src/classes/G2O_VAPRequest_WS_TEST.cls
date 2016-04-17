/**
    About
    -----
    Description: This class is used to test G2O_VAPRequest_WS
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
    
    Update History
    --------------
    Created March 2013 - C.H.F.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_VAPRequest_WS_TEST {

    static testMethod void successfulResponseTest() {
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
        
        vapCase = [SELECT Id, Receiver__r.MOD_Address_Number__c, Receiver_Postal_Address_Postal_Code__c
				   FROM Case
				   WHERE Id = :vapCase.Id];
						
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        G2O_VAPRequest_WS vap = new G2O_VAPRequest_WS(vapCase);
        vap.send();
        Test.stopTest();
        
        // Assert
		System.assertNotEquals(null, vap.result);
		System.assertNotEquals(null, vap.result[0].Case__c);
		System.assertNotEquals(null, vap.result[0].VAP_Unit__c);
		System.assertNotEquals(null, vap.result[0].Parcel_Letter__c);
		System.assertNotEquals(null, vap.result[0].Route_Description__c);
		System.assertNotEquals(null, vap.result[0].Route_no__c);
    }

    static testMethod void errorResponseTest() {
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
        
        vapCase = [SELECT Id, Receiver__r.MOD_Address_Number__c, Receiver_Postal_Address_Postal_Code__c
				   FROM Case
				   WHERE Id = :vapCase.Id];
        
        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, errorMock);
        G2O_VAPRequest_WS vap = new G2O_VAPRequest_WS(vapCase);
        vap.send();
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, vap.callout.error);
        System.assertEquals('-1405', vap.callout.error.errCode);
        System.assertEquals('ORA-01405: fetched column value is NULL', vap.callout.error.description);
    }
    
    
}