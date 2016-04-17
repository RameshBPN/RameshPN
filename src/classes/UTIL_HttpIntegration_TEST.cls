/**
	About
	-----
	Description: This class is used to test UTIL_HttpIntegration_TEST
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: March 2013
	
	Details
	-------
	
	Update History
	--------------
	Created March 2013 - C.H.F.
	
	Issues / TODOs
	--------------
			
*/
@isTest
private class UTIL_HttpIntegration_TEST {
	
	static testMethod void testAddErrorListener() {
		// Arrange
		UTIL_TestFactory.setUpOrg();
		UTIL_HttpIntegration utilHttp = new UTIL_HttpIntegration('VAP');
		
		// Act
		utilHttp.addErrorListener('errorCode1', UTIL_HttpIntegration.ErrorType.TECHNICAL);
		
		utilHttp.addErrorListener('errorCode2', 'description2', UTIL_HttpIntegration.ErrorType.BUSINESS);
		
		// Assert
		System.assert(UTIL_HttpIntegration.ErrorType.TECHNICAL == UTIL_HttpIntegration.ErrorCodeTypeMap.get('errorCode1'), 'The error code was not added to the map');
		System.assert(UTIL_HttpIntegration.ErrorType.BUSINESS == UTIL_HttpIntegration.ErrorCodeTypeMap.get('errorCode2'), 'The error code was not added to the map');
		System.assert('description2' == UTIL_HttpIntegration.CustomErrorCodeDescriptionMap.get('errorCode2'), 'The error description was not added to the map');
	}
	
	static testMethod void testSend1() {
		// Arrange
		UTIL_TestFactory.setUpOrg();
		StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockRespons');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Case c = UTIL_TestFactory.createCase();
        insert c;
		
		// Act and Assert
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        UTIL_HttpIntegration utilHttp = new UTIL_HttpIntegration('VAP');
        
        utilHttp.send(false);
        System.assert(0 == [SELECT COUNT() FROM ApexCalloutLog__c], 'There were Callout logs created');
        
        utilHttp.send(); // Should default to true
        System.assert(0 != [SELECT COUNT() FROM ApexCalloutLog__c], 'The was no Callout log created');
        
        System.assert(utilHttp.related_sObjectID == null);
        
        Test.stopTest();
	}
	
	static testMethod void testSend2() {
		// Arrange
		UTIL_TestFactory.setUpOrg();
		StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockRespons');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Case c = UTIL_TestFactory.createCase();
        insert c;
		
		// Act and Assert
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        UTIL_HttpIntegration utilHttp = new UTIL_HttpIntegration('VAP');
        
        utilHttp.send(c.Id);
        System.assert(utilHttp.related_sObjectID == c.Id, 'The callout was not related to a object Id');
        
        Test.stopTest();
	}
	
	static testMethod void testSend3() {
		// Arrange
		UTIL_TestFactory.setUpOrg();
		StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockRespons');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Case c = UTIL_TestFactory.createCase();
        insert c;
		
		// Act and Assert
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        UTIL_HttpIntegration utilHttp = new UTIL_HttpIntegration('VAP');
        
        utilHttp.send(c.id, false);
        
        utilHttp.send(c.id, true);
        System.assert(utilHttp.related_sObjectID == c.Id, 'The callout was not related to a object Id');
        
        Test.stopTest();
	}
	
	static testMethod void testMockResponse() {
		// Arrange
		UTIL_TestFactory.setUpOrg();
		StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockRespons');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Case c = UTIL_TestFactory.createCase();
        insert c;
		
		// Act and Assert
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        UTIL_HttpIntegration utilHttp = new UTIL_HttpIntegration('VAP');
        utilHttp.opt_MockDocument = 'TestMockRespons';
        
        utilHttp.send(c.id, false);
        
        utilHttp.send(c.id, true);
        System.assert(utilHttp.related_sObjectID == c.Id, 'The callout was not related to a object Id');
        
        Test.stopTest();
	}
	
	static testMethod void testExceptions() {
		// Arrange
		UTIL_TestFactory.setUpOrg();

		
		// Act and Assert
		Test.startTest();
        
        UTIL_HttpIntegration.MappingException mappingException			= new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR);
        mappingException = new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX');
        mappingException = new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX', 'XXX');
        System.assert(mappingException.getMessage() == 'XXX');
        
        UTIL_HttpIntegration.ResponseException responseException		= new UTIL_HttpIntegration.ResponseException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR);
        responseException = new UTIL_HttpIntegration.ResponseException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX');
        responseException = new UTIL_HttpIntegration.ResponseException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX', 'XXX');
        System.assert(responseException.getMessage() == 'XXX');
        
        UTIL_HttpIntegration.HeaderException headerException			= new UTIL_HttpIntegration.HeaderException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR);
        headerException = new UTIL_HttpIntegration.HeaderException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX');
        headerException = new UTIL_HttpIntegration.HeaderException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX', 'XXX');
        System.assert(headerException.getMessage() == 'XXX');
        
        UTIL_HttpIntegration.HTTPRequestException httpRequestException	= new UTIL_HttpIntegration.HTTPRequestException();
        httpRequestException = new UTIL_HttpIntegration.HTTPRequestException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX');
        httpRequestException = new UTIL_HttpIntegration.HTTPRequestException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR, 'XXX', 'XXX');
        System.assert(httpRequestException.getMessage() == 'XXX');
        
        Test.stopTest();
	}
	
	static testMethod void testHandleResponseErrors() {
		// Arrange
		UTIL_TestFactory.setUpOrg();
		UTIL_HttpIntegration utilHttp = new UTIL_HttpIntegration('VAP');
		utilHttp.errorCodeXMLPath = 'errorCode';
		utilHttp.errorDescriptionXMLPath = 'errorDesc';
		utilHttp.callout = new UTIL_HttpIntegration.CalloutResult();
		String xml = '<?xml version="1.0" encoding="UTF-8"?><error><errorCode>code1</errorCode><errorDesc>desc1</errorDesc></error>';
		utilHttp.callout.xml = new UTIL_XmlDom(xml);
		
		// Act
		utilHttp.handleResponseErrors();
		
		// Assert
		System.assertEquals('code1', utilHttp.callout.error.errCode);
        System.assertEquals('desc1', utilHttp.callout.error.description);
	}
	
	static testMethod void testWriteCalloutLog() {
		// Arrange
		UTIL_TestFactory.setUpOrg();
		UTIL_HttpIntegration utilHttp = new UTIL_HttpIntegration('VAP');
		Case c = UTIL_TestFactory.createCase();
        insert c;
        utilHttp.callout = new UTIL_HttpIntegration.CalloutResult();
        utilHttp.callout.related_sObjectID = c.Id;
        
		// Act
		utilHttp.writeCalloutLog();
		
		// Assert
		System.assert(0 != [SELECT COUNT() FROM ApexCalloutLog__c], 'The was no Callout log created');
		System.assert(c.Id == [SELECT WhatId__c FROM ApexCalloutLog__c][0].WhatId__c,'Id is not set correctly');
		System.assert(c.Id == [SELECT Case__c FROM ApexCalloutLog__c][0].Case__c,'Log is not related to correct object type');
	}

    static testMethod void canReportOnMutipleErrors() {
        UTIL_HttpIntegration.CalloutResult callout = new UTIL_HttpIntegration.Calloutresult();
		callout.error = new UTIL_HttpIntegration.ErrorContainer(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR);
		callout.error = new UTIL_HttpIntegration.ErrorContainer(UTIL_HttpIntegration.ErrorCode.TIMEOUT);
		String integrationName = 'Test Integration';
		
		System.assert(callout.errors.size()==2);
		System.assert(callout.errors[0].systemErrCode == UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR);
		System.assert(callout.errors[1].systemErrCode == UTIL_HttpIntegration.ErrorCode.TIMEOUT);
		
		if (callout.errors.size()>0)
		{
			ApexCalloutLog__c[] log = new ApexCalloutLog__c[]{};
			for(UTIL_HttpIntegration.ErrorContainer error : callout.errors)
			{
				// Record a log per error
				ApexCalloutLog__c logItem = new ApexCalloutLog__c();
				logItem.Source__c = integrationName;
				logItem.Request_Message__c = UTIL_Apex.empty(callout.request) ? '' : callout.request.getBody();
				logItem.Response_Message__c = UTIL_Apex.empty(callout.response) ? '' : callout.response.getBody();
				logItem.Request_Initiated__c = callout.calloutStart;
				logItem.Response_Final__c = callout.calloutFinalResponse;
				logItem.Response_Initial_Response__c = callout.calloutInitialResponse;
				logItem.System_Error_Code__c = ''+error.systemErrCode;
				logItem.Error_Code__c = error.errCode;
				logItem.Error_Type__c = error.errType;
				logItem.Error_Description__c = error.description;
				log.add(logItem);
			}
			upsert log;
			System.debug(log);
		} else
		{
			ApexCalloutlog__c logItem = new ApexCalloutLog__c();
			logItem.Source__c = integrationName;
			logItem.Request_Message__c = UTIL_Apex.empty(callout.request) ? '' : callout.request.getBody();
			logItem.Response_Message__c = UTIL_Apex.empty(callout.response) ? '' : callout.response.getBody();
			logItem.Request_Initiated__c = callout.calloutStart;
			logItem.Response_Final__c = callout.calloutFinalResponse;
			logItem.Response_Initial_Response__c = callout.calloutInitialResponse;
			upsert logItem;
			System.debug(logItem);
		}
    }
}