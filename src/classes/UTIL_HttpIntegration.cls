/**
	About
	-----
	Description: Virtual class for implementing HTTP Integration Services. 
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: Jan 2013
	
	Details / Methods
	-----------------
	Purpose
		To use as the base class for implementing an ESB SOAP or XML based RESTful web service request solution. Provides reporting, error handling, retries and custom setting configuration management.
	
	Set up / Use
		Default settings for this script are set up in HTTP_Integration_Settings__c
		Each custom integration setting may be set manually or loaded from HTTP_Integration_Services__c
		Extend this class through your ESB, override: createXMLBody, handleResponse. Optionaly overwrite handleResponseErrors if the standard error handling does not fit your implementation.
		To consume, create new service, then send(); Returns a calloutResult object with all info re. errors, responses etc.
	
	Logging
		All callouts are logged into the Apex Callout Log. If an sObject Id is provieded when calling the service, the log will attempt to update any related lists of the same type to allow callout results to be displayed on a related list on the parent record.
	
	Error Reporting
		Errors are shown in the Apex Callout Log, and appended to the errorList on the returned Callout object
		Default error codes
			The service has a default ser of errors that may get returned.
			These are mapped to types and descriptions.
			User friendly values are shown via picklists (to allow translation of the piclist values into user friendly error messages)
		Custom error codes, (ie per service) 
			Defined by using the addErrorListener method to register each meaningful error code
			A custom setting is set on each integration to define the location in the response XML that will contain any error codes and the descritions (respectively). 
			When an error code that is registered via addErrorListener is found in a response, it's description is looked up from any value given or the XML node given and reported to the Log.
			The * wild card may be used to catch any error reported by the response if desired.
		
		This code could be modified for Json however does not support it in this version.
	
	Dependendies
		Custom settings: HTTP_Integration_Settings__c, HTTP_Integration_Services__c
		XMLDom class for XML parsing unless code statement limits are being hit by very large files.
		UTIL_Apex class for short cut functions
	
	DML and @future in Callout Logging:
		In @future methods, DML may not be allowed in an http request, so WriteCalloutLog must be called explicitly to execute the log DML. 
	
	Testing and Mock requests
		For tests, use the standard seting of a Mock document on the test method.
		Whe running testing (but not in a test class) a develoepr can set the public string opt_MockDocument to the name of a Mock document and that will be returned instead.

	Update History
	--------------
	Created Jan 2013 - M.E.
	First Compile March 2013 - M.E.
	Testing June 2013 - C.F.H.
	Added force mock support for testing Sept 2013 - M.E.
	
	Issues / TODOs
	--------------
*/

public virtual class UTIL_HttpIntegration {
	/***** General Integration Settings *****/
		
		public static String DEFAULT_TIMEOUT {get{return (String.valueOf(getHttpIntegrationSetting('Default_Timeout__c','30')));}set;} 	// Default timeout in seconds;
	 	public static String DEFAULT_SYSTEMID {get{return (String)getHttpIntegrationSetting('SystemID__c','SFDC');}set;}  		// Default system ID used by external systems to recognise sfdc
	    public static String DEFAULT_TIMESTAMP {get{return String.valueOfGmt(Datetime.now());} set;} 				// Timestamp for general use

		
    /***** Request / Response Parameters *****/
    
		// Request settings driven by custom settings
		public String	integrationName;				// The name of the integration, used to look up the settings from HTTP Integration Services
		public String 	systemId = DEFAULT_SYSTEMID;	// The system to be connected to
		public String 	timeout = DEFAULT_TIMEOUT;		// Time out (seconds)
		public Integer 	retries;						// Retries if timeout occurrs
		public String 	provider;						// The system to be connected to
		public String 	serviceName;					// The name of the service the system should provide
		public String 	serviceVersion;					// Version of the service we are connnecting to on the ESB
	 	public Boolean 	enabled = true;					// Flag to set if the integration is enabled or disabled
		public String 	userName;						// Username
		public String 	password;						// Password
		public String 	maxRecords = '100';				// Holds the max number of records to return
		public String 	clientCertName;					// Name of the client certificate to be sent
		public String 	soapAction;						// Type of SOAP Action to use
		public String 	host;							// The Host request-header field specifies the Internet host and port number of the resource being requested. The Host field value MUST represent the naming authority of the origin server or gateway given by the original URL. This allows the origin server or gateway to differentiate between internally-ambiguous URLs, such as the root "/" URL of a server for multiple host names on a single IP address.
		public String 	endpoint;						// End point URI of the request
		public String 	requestMethod;					// How the request will be sent, GET, POST etc.
		public Boolean 	requestKeepAlive;				// If the connected session shold be kept open or closed if the request gets stopped
		public String 	contentType;					// Message content type (default text/xml)
		public String	errorCodeXMLPath;				// General Path (Nodename@attribute) to node and attribute contining any standard error information (the error code)
		public String	errorDescriptionXMLPath;		// General Path (Nodename@attribute) to node and attribute contining any standard error information (a description)
		public String	GUID {get {return systemId + System.Userinfo.getUserId() + (DEFAULT_TIMESTAMP.replace(' ','').replace('-','').replace('/','').replace(':','')).substring(0,14);}set;} // Unique ref. SYSTEM ID + USER ID + 14-char numeric value from current timestamp
	 	public String	related_sObjectID;				// A reference point to log against
	 	//public String responseEnvelopeVersion;		// Version of the SOAP envelope to be returned - NOT USED IN THIS VERSION - PLACEHOLDER ONLY!
		
		// Response
		public CalloutResult callout; 											// The current callout, response and any errors reported
		public String[] responseErrorNodes = new String[]{}; 					// One or more nodes (Node names) that will contain error feedback in the response XML
	
		
    /***** Allow a Mock document to be used for testing/development *****/
    
	    BOOLEAN opt_ForceMockResponse {get{return opt_MockDocument!=null;}set;}	// FOR TESTS AND TESTING FIXED RESPONSES
	    public String opt_MockDocument {get;set;}	// SET WHEN THE TESTER OR DEV WISHES TO FORCE A SET XML RETURN VALUE WHEN SETTING THE MOCK RESULT IS NOT AVAILABLE , EX WHEN NOT IN A TEST SCRIPT
	
	
	/***** Private Variables *****/
	
		Map<Schema.sObjectType,String> calloutLogLookupFieldsByType = new Map<Schema.sObjectType,String>(); // Type, API Field Name. Map the descibe detail of the callout log object to allow logging to be correctly aligned to a related Salesforce record. Allows the callout result to be shown easily to the user. This assumes one lookup field of a certain type per record.
		
		
 	/***** Constructor *****/
 	
		// Automate loading of settings from HTTP Integration Services (Uses existing values if nothing is found or is empty)
		public UTIL_HttpIntegration(String integrationName)
		{
			
			system.debug(Logginglevel.INFO,'++++121+++'+String.valueOf(getHttpIntegrationSetting('Default_Timeout__c','30')));
			this.integrationName = integrationName;
			
			host 					=	(string)getServiceSetting(integrationName,'Host__c',host);										// Mandatory
			endpoint 				=	(string)getServiceSetting(integrationName,'Endpoint__c',endpoint);								// Mandatory
			provider 				=	(string)getServiceSetting(integrationName,'Provider__c',provider);								// Mandatory
			soapAction				=	(string)getServiceSetting(integrationName,'SOAPAction__c',soapAction);							// Mandatory
			serviceName 			= 	(string)getServiceSetting(integrationName,'Service_Name__c',serviceName);						// Optional (depends on the provider)
			serviceVersion 			= 	(string)getServiceSetting(integrationName,'Version__c',serviceVersion);							// Optional
			
			enabled 				=	(Boolean)getServiceSetting(integrationName,'Enabled__c',enabled);								// Optional
			
			clientCertName 			=	(string)getServiceSetting(integrationName,'ClientCertName__c',clientCertName);					// Mandatory, if no username/password
			userName 				=	(string)getServiceSetting(integrationName,'Username__c',userName);								// Mandatory, if no cert
			password 				=	(string)getServiceSetting(integrationName,'Password__c',password);								// Mandatory, if no cert
			
			requestMethod			=	(string)getServiceSetting(integrationName,'RequestMethod__c',requestMethod);					// Optional
			timeout 				= 	(string)getServiceSetting(integrationName,'Timeout__c',timeout);								// Optional
			requestKeepAlive 		=	(Boolean)getServiceSetting(integrationName,'RequestKeepAlive__c',requestKeepAlive);				// Optional
			contentType				= 	(string)getServiceSetting(integrationName,'ContentType__c',contentType);						// Optional
			
			errorCodeXMLPath		= 	(string)getServiceSetting(integrationName,'Error_Code_Path__c',errorCodeXMLPath);				// Optional
			errorDescriptionXMLPath	= 	(string)getServiceSetting(integrationName,'Error_Descripion_Path__c',errorDescriptionXMLPath);	// Optional
			
			maxRecords 				=	(string)getServiceSetting(integrationName,'Max_Records__c',maxRecords);							// Mandatory for PAR
			
			if(((Double)getServiceSetting(integrationName,'Max_Retries__c',0)) != null) {
				retries 			= 	((Double)getServiceSetting(integrationName,'Max_Retries__c',0)).intValue();					// Optional
			} else {
				retries 			=	0;
			}		
		}
		
		
	/***** Register, Create, Send and Handle Callout *****/
	
		// Add a new listener to register error codes 
		// This makes the code look for errors received by a service in the response XML (node defined in custom settings)
		// The error nodes for inspection are set in the custom settings for the integration
    	public void addErrorListener(String code, ErrorType typ)
		{
			ErrorCodeTypeMap.put(code,typ); // Add the error code to the type map, this will be used to lookup the error codes received
		}
    	public void addErrorListener(String code, String description, ErrorType typ)
		{
			ErrorCodeTypeMap.put(code,typ); // Add the error code to the type map, this will be used to lookup the error codes received
			CustomErrorCodeDescriptionMap.put(code,description); // Add the error code to the description map, useful if systems don't provide a description node in their response.
		}
		
		// Send the callout and return the result in a wrapper object including http error information
		// !!! Note the default is to write the result to a Log! If DML errors occurr, then pass in FALSE as an argument. (Ex. calling from insdide @future or async methods)
		public CalloutResult send()
		{
			return send(true);
		}
		public CalloutResult send(String related_sObjectId)
		{
			this.related_sObjectID = related_sObjectId;
			return send(true);
		}
		public CalloutResult send(String related_sObjectId, Boolean writeLog)
		{
			this.related_sObjectID = related_sObjectId;
			return send(writeLog);
		}
		public CalloutResult send(Boolean writeLog)
		{
			System.debug(Logginglevel.Error,'### Start send(): CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
	        System.debug(Logginglevel.info,'@@ Start Callout!');
	        callout = new CalloutResult(related_sObjectID);
	        System.debug(Logginglevel.info,'callout: ' + callout);
			Http http = new Http();
			
			try 
	        {
	        	// Create the request object and throw any errors if encountered, ex. mandatory information is missing
		    	callout.request = createHTTPRequest(createXmlBody());
	       		System.debug(Logginglevel.info,'@@ Request body: '+callout.request.getBody());
	       		
			    // Send the request and get the response (synchronously)
			    Integer tries = 0;
			    Boolean success = false;
	        	callout.calloutStart = Datetime.now();
			    while (tries<=retries && !success)
			    {
			    	tries ++;
			    	if (!opt_ForceMockResponse)
			    	{
			    		// If this is a live call, make the callout
			    		System.debug(Logginglevel.Error,'### Before callout: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
				    	callout.response = http.send(callout.request);
				    	System.debug(Logginglevel.Error,'### After callout: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
			    	} else {
			    		// If required, the script can force the return of a mock response, based no the name given in the opt_MockDocument variable 
				       	callout.response = new HttpResponse();
				       	callout.response.setStatusCode(200);
				       	callout.response.setStatus('Mock response requested');
			       		System.debug(Logginglevel.INFO,'@@ Looking up mock file: '+opt_MockDocument);
				       	try
				       	{
				    		StaticResource defaultResource = [Select  s.Body From StaticResource s where s.Name = :opt_MockDocument limit 1];
				    		if (defaultResource!=null && defaultResource.Body!=null)
				    		{
						        blob tempB = defaultResource.Body;
						       	callout.response.setBody(tempB.toString());
				    		}
				       	} catch (exception e) {
			       			System.debug(Logginglevel.INFO,'@@ Could not find mock file: '+opt_MockDocument+'; Exception: '+e.getMessage());
			       			callout.response.setStatusCode(408);
				       		callout.response.setStatus('Could not find mock response: '+opt_MockDocument+'; Exception: '+e.getMessage());
			       			callout.response.setBody('');
				       	}
			    	} 
			    	callout.calloutInitialResponse = UTIL_Apex.empty(callout.calloutInitialResponse) ? Datetime.now() : callout.calloutInitialResponse;
				    callout.calloutFinalResponse = Datetime.now();
				    System.debug(Logginglevel.info,'@@ Response body: '+callout.response.getBody());
				    try
				    {
				    	// Parse the returned document into XML
				    	System.debug(Logginglevel.Error,'### Before Parse the returned document into XML: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
				    	callout.xml = new UTIL_XMLDom( UTIL_Apex.empty(callout.response.getBody()) ? '' : callout.response.getBody());
				    	System.debug(Logginglevel.Error,'### After Parse the returned document into XML: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
				    }
				    catch(Exception e)
				    { 
				    	// XML is corrupt
					    callout.error = new ErrorContainer(ErrorCode.SERVICE_TYPE_NOT_SUPPORTED, CalloutStatus.NO_DATA);			    											    	
				    }
				    if (callout.response.getStatusCode()==408)
				    {
				    	// Timeout
						callout.error = new ErrorContainer(ErrorCode.TIMEOUT, CalloutStatus.NO_RESPONSE);
				    }
				    else
				    if (callout.response.getStatusCode()!=200)
				    {
				    	// Other Callout Error
				    	callout.error = new ErrorContainer(ErrorCode.CALLOUT_FAILURE, callout.response.getStatusCode() + ' ' + callout.response.getStatus());             
					}
					else
					{
						// Success
						success = true;
					}
			    }
			    if (!success)
			    {
				    if (callout.response.getStatusCode()==408)
				    {
				    	// Permanent Timeout
				    	callout.error = new ErrorContainer(ErrorCode.PERMANENT_TIMEOUT,callout.response.getStatusCode() + ' ' + callout.response.getStatus());
				    }
				    else
				    {
				    	// Callout Error, throw an error of type ResponseException, CalloutException. Status is not OK
				    	callout.error = new ErrorContainer(ErrorCode.PERMANENT_CALLOUT_FAILURE,callout.response.getStatusCode() + ' ' + callout.response.getStatus());
				    }
			    }
			    
			    // Handle response content errors
			    handleResponseErrors();
	        }
	        catch(HTTPRequestException e) 
	        {
	        	callout.error = new ErrorContainer(e.code);
	        }
	    	
	    	if (writeLog)
	    	{
	    		writeCalloutLog();
	    	}
	    	
	    	//Handle the response and parse the content
	    	handleResponse();
	    	
	    	System.debug(LoggingLevel.info, '@@ End performCallout!');
	    	System.debug(Logginglevel.Error,'### End send(): CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
	    	
			return callout;
		}
		
		HttpRequest createHTTPRequest(String body)
	    {
	    	System.debug(logginglevel.info, '@@ Start createHTTPRequest');
		    HttpRequest req = new HttpRequest();
		    
	    	// Check we have the mandatory parameters
			if (Util_Apex.empty(provider))
			{
				throw new HTTPRequestException (ErrorCode.MISSING_PROVIDER);
			}
			if (Util_Apex.empty(host))
			{
				throw new HTTPRequestException (ErrorCode.MISSING_HOST);
			}
			if (Util_Apex.empty(endpoint))
			{
				throw new HTTPRequestException (ErrorCode.MISSING_ENDPOINT);
			}
			if ((Util_Apex.empty(userName) || Util_Apex.empty(password)) && Util_Apex.empty(clientCertName))
			{
				throw new HTTPRequestException (ErrorCode.NO_CREDENTIALS);
			}
			
			// Build the request object
	    	if (UTIL_Apex.isSet(enabled))
	    	{
	    		if (UTIL_Apex.empty(body)) body='';
				Integer timeoutValue = UTIL_Apex.convertStringToInt(timeout);
				
		        req.setHeader('Content-Type', contentType);
		        req.setHeader('Host',host);
		        req.setHeader('SOAPAction', soapAction);
		        req.setHeader('Content-Length', String.valueOf(body.length()));
		        req.setHeader('Authorization', createBasicAuthentication());
		        if (UTIL_Apex.isSet(requestKeepAlive)) req.setHeader('Connection','Keep-Alive');
				//if (!UTIL_Apex.empty(clientCertName)) req.setClientCertificateName (clientCertName); // The client certificate name must match one already generated in salesforce
		        req.setEndpoint(endpoint);
		        req.setMethod(requestMethod == null ? 'GET' : requestMethod);
		        req.setTimeout(Integer.valueOf(timeoutValue+1)*1000);
		        req.setBody(body);
		        
		    	System.debug(logginglevel.info, '@@ Request object: '+req);
		    	System.debug(logginglevel.info, '@@ End createHTTPRequest');
	    	} else
	    	{
				throw new HTTPRequestException (ErrorCode.SERVICE_DISABLED);
	    	}
	        return req;
	    }
	    
	    // Creates a Base 64 encoded value of the password and username for the HTTP Basic authentication
	    String createBasicAuthentication() {
	    	 Blob b = Blob.valueOf(userName + ':' + password);
	    	 String encodedValue = EncodingUtil.base64Encode(b);
	    	
	    	return 'Basic ' + encodedValue;
	    }
		
		// Build Outbound Message (to override)
		public virtual String createXMLBody(){return null;}
		
		// Handle Response (to override)
		public virtual void handleResponse()
		{
			System.debug(LoggingLevel.info, '@@ '+callout.response.getBody());
		}
		
		// Handle Response Errors (to override as required)
		public virtual void handleResponseErrors()
		{
			if (!UTIL_Apex.empty(callout.xml))
			{
				// If a standard error location is identified in the integration's custom settings
				// then look for the node that might contain an error and automatically analyze the response and note the error.
				// If there is no standard locaiton we can't analyse automatically, so do nothing.
				String errorCode = '';
				String errorDescription = '';
				if (!UTIL_Apex.empty(errorCodeXMLPath))
				{
					errorCode = callout.xml.root.getValueBySimplePath(errorCodeXMLPath);
					if (!UTIL_Apex.empty(errorCode))
					{
						if (!UTIL_Apex.empty(errorDescriptionXMLPath))
						{
							errorDescription = callout.xml.root.getValueBySimplePath(errorDescriptionXMLPath);
						}
						if (errorDescription=='')
						{
							// Try the Custom Error Code Description Map
							if (CustomErrorCodeDescriptionMap.containsKey(errorCode))
							{
								// Try to search the document for a matching node on this value, or just use the value from the description map
								errorDescription = CustomErrorCodeDescriptionMap.get(errorCode);
								String xmlErrorDescription = callout.xml.root.getValueBySimplePath(errorDescription);
								if (xmlErrorDescription!='') errorDescription = xmlErrorDescription;
							} else {
								errorDescription = errorCode;
							}
						}
						// Record the custom error code and description
						callout.error = new ErrorContainer(errorCode,errorDescription);
					}
				}
			}
		}
		
		
	/**** Log Results ****/
	
		// Record the callout log history in a log table in Salesforce
		// Records mutiple rows for each error
		public void writeCalloutLog()
		{
			
			Database.DMLOptions dmo = new Database.DMLOptions();
			dmo.allowFieldTruncation = true;
				
			try {
				// Map the callout log fields that relate to other objects
				if (calloutLogLookupFieldsByType.isEmpty()) {
					Map<String, Schema.SObjectField> fieldMap = UTIL_Meta.getFieldMap('ApexCalloutLog__c');
					for (String fieldName : UTIL_Meta.getFieldMap('ApexCalloutLog__c').keySet()) {
						if (fieldName.indexOf('__c')!=-1) {
							Schema.sObjectField fld = UTIL_Meta.getFieldMap('ApexCalloutLog__c').get(fieldName);
							List <Schema.sObjectType> types = fld.getDescribe().getReferenceTo();
							if (types.size()>0) {
								for (Schema.sObjectType tp : types) {
									calloutLogLookupFieldsByType.put(tp, fieldName);
								}
							}
						}
					}
				}
			} catch (Exception e) {
				UTIL_Error.report('Error callout log fields that relate to other objects: '+e.getMessage());
			}
			
			try {
				// Record the lookup relationships on the logItem to allow users to see the logItem result on the related record
				String relatedFieldName = '';
				String sObjectId = callout.related_SObjectId;
				if (!UTIL_Apex.empty(sObjectId) && !calloutLogLookupFieldsByType.isEmpty()) {
					// Use the ID to identify the field that applies to the correct object type. Applies to custom fields, system fields are ignored
					Schema.SObjectType objType = UTIL_Meta.getObjectType(sObjectId);
					if (calloutlogLookupFieldsByType.containsKey(objType)) {
						relatedFieldName = calloutlogLookupFieldsByType.get(objType);
					}
				}
				
				// Record errors (handle mutiple if several are reported)
				if (callout.errors.size()>0) {
					ApexCalloutLog__c[] log = new ApexCalloutLog__c[]{};
					for(UTIL_HttpIntegration.ErrorContainer error : callout.errors) {
						// One log entry per error
						ApexCalloutLog__c logItem = new ApexCalloutLog__c();
						if (!UTIL_Apex.empty(sObjectId))
						{	
							logItem.WhatId__c = sObjectId;
							if (!UTIL_Apex.empty(relatedFieldName)) logItem.put(relatedFieldName, sObjectId);
						}
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
						logItem.setOptions(dmo);
						log.add(logItem);
					}
					
					upsert log;
					System.debug(Logginglevel.INFO,log);
				} else {
					ApexCalloutlog__c logItem = new ApexCalloutLog__c();
					if (!UTIL_Apex.empty(sObjectId))
					{	
						logItem.WhatId__c = sObjectId;
						if (!UTIL_Apex.empty(relatedFieldName)) logItem.put(relatedFieldName, sObjectId);
					}
					logItem.Source__c = integrationName;
					logItem.Request_Message__c = UTIL_Apex.empty(callout.request) ? '' : callout.request.getBody();
					logItem.Response_Message__c = UTIL_Apex.empty(callout.response) ? '' : callout.response.getBody();
					logItem.Request_Initiated__c = callout.calloutStart;
					logItem.Response_Final__c = callout.calloutFinalResponse;
					logItem.Response_Initial_Response__c = callout.calloutInitialResponse;
					logItem.setOptions(dmo);
					upsert logItem;
					System.debug(Logginglevel.INFO,logItem);
				}
			}
			catch (Exception e)
			{
				UTIL_Error.report(e);
			}
		}
		
		
	/**** Callout Result Class ****/
	
		public class CalloutResult {
			public String related_SObjectId;
	    	public HttpResponse response;
	    	public ErrorContainer[] errors{get {errors = errors == null ? new ErrorContainer[]{} : errors; return errors;}set;}
	    	public ErrorContainer error {
	    		get {
	    			return errors.size()>0 ? errors[errors.size()-1] : null;
	    		}set{
	    			errors.add(value);
	    		}
	    	}
	    	public HttpRequest request;
	    	public UTIL_XmlDom xml;
	    	public datetime calloutStart;
	    	public datetime calloutInitialResponse;
	    	public datetime calloutFinalResponse;
	    	
	    	public calloutResult()
	    	{
	    		this('');
	    	}
	    	public calloutResult(String related_SObjectId)
	    	{
	    		this.related_SObjectId = related_SObjectId;
	    	}
	    }
	
	
	/***** Exception Classes, Error Codes, Maps, Listeners and Wrapper Classes *****/
	
	    // Default Error Codes, types and status. 
	    //  Custom errors on an integration are added via the addErrorListener method
	    //  System errors are mapped directly to pick list values on Apex Callout Log to allow friendly error messages
    	public enum CalloutStatus {NOT_SENT, SENT, NO_RESPONSE, NO_DATA, FAILED, OK}
	    public enum ErrorCode {MISSING_CUSTOM_SETTING, MAPPING_ERROR, SERVICE_TYPE_NOT_SUPPORTED, SERVICE_DISABLED, CALLOUT_FAILURE, PERMANENT_CALLOUT_FAILURE, NO_CREDENTIALS, MISSING_ENDPOINT, MISSING_HOST, MISSING_PROVIDER, MISSING_SERVICENAME, TIMEOUT, PERMANENT_TIMEOUT, MISSING_PARAMETERS, UNKNOWN_ERROR}
		public enum ErrorType {BUSINESS, TECHNICAL, GENERIC}
	    
	    public class MappingException extends Exception {
	    		public ErrorCode code; 
	    		public ErrorType errorType {get{errorType= ErrorCodeTypeMap.containsKey(''+code) ? ErrorCodeTypeMap.get(''+code) : null; return errorType;} set;}
	    		public String fieldPath;
	    		public String message = '';
	    		public MappingException(ErrorCode errCode){code=errCode;} 
	    		public MappingException(ErrorCode errCode, String fieldPath){code=errCode;this.fieldPath = fieldPath;}
	    		public MappingException(ErrorCode errCode, String fieldPath, String message){code=errCode;this.fieldPath = fieldPath; this.message=message;}
	    		public override String getMessage()
	    		{
	    			return message;
	    		}
	    }
	    public class ResponseException extends Exception {
	    		public ErrorCode code; 
	    		public ErrorType errorType {get{errorType= ErrorCodeTypeMap.containsKey(''+code) ? ErrorCodeTypeMap.get(''+code) : null; return errorType;} set;}
	    		public String fieldPath;
	    		public String message = '';
	    		public ResponseException(ErrorCode errCode){code=errCode;} 
	    		public ResponseException(ErrorCode errCode, String fieldPath){code=errCode;this.fieldPath = fieldPath;}
	    		public ResponseException(ErrorCode errCode, String fieldPath, String message){code=errCode;this.fieldPath = fieldPath; this.message=message;}
	    		public override String getMessage()
	    		{
	    			return message;
	    		}
	    }
	    public class HeaderException extends Exception {
	    		public ErrorCode code; 
	    		public ErrorType errorType {get{errorType= ErrorCodeTypeMap.containsKey(''+code) ? ErrorCodeTypeMap.get(''+code) : null; return errorType;} set;}
	    		public String fieldPath;
	    		public String message = '';
	    		public HeaderException(ErrorCode errCode){code=errCode;} 
	    		public HeaderException(ErrorCode errCode, String fieldPath){code=errCode;this.fieldPath = fieldPath;}
	    		public HeaderException(ErrorCode errCode, String fieldPath, String message){code=errCode;this.fieldPath = fieldPath; this.message=message;}
	    		public override String getMessage()
	    		{
	    			return message;
	    		}
	    }
	    public class HTTPRequestException extends Exception {
	    		public ErrorCode code; 
	    		public ErrorType errorType {get{errorType= ErrorCodeTypeMap.containsKey(''+code) ? ErrorCodeTypeMap.get(''+code) : null; return errorType;} set;}
	    		public String fieldPath;
	    		public String message = '';
	    		public HTTPRequestException(ErrorCode errCode){code=errCode;} 
	    		public HTTPRequestException(ErrorCode errCode, String fieldPath){code=errCode;this.fieldPath = fieldPath;}
	    		public HTTPRequestException(ErrorCode errCode, String fieldPath, String message){code=errCode;this.fieldPath = fieldPath; this.message=message;}
	    		public override String getMessage()
	    		{
	    			return message;
	    		}
	    }
	    
		// Map the error codes to types in a way that can be extended by the custom implementation
	    public static Map<String,ErrorType> ErrorCodeTypeMap {get{
			if (ErrorCodeTypeMap==null)
    		{
    			ErrorCodeTypeMap= new Map<String,ErrorType>();
				ErrorCodeTypeMap.put(''+ErrorCode.MAPPING_ERROR, ErrorType.BUSINESS);
				ErrorCodeTypeMap.put(''+ErrorCode.SERVICE_TYPE_NOT_SUPPORTED, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.SERVICE_DISABLED, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.CALLOUT_FAILURE, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.PERMANENT_CALLOUT_FAILURE, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.NO_CREDENTIALS, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.MISSING_ENDPOINT, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.MISSING_HOST, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.MISSING_PROVIDER, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.MISSING_SERVICENAME, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.TIMEOUT, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.PERMANENT_TIMEOUT, ErrorType.TECHNICAL);
				ErrorCodeTypeMap.put(''+ErrorCode.MISSING_PARAMETERS, ErrorType.BUSINESS);
				ErrorCodeTypeMap.put(''+ErrorCode.UNKNOWN_ERROR, ErrorType.GENERIC);
				//Custom error codes can overwrite and append to this list
    		}
    		return ErrorCodeTypeMap;
		}set;}
		
		// Map custom error codes to descriptions (System error codes will be a picklist)
		public static Map<String,String> CustomErrorCodeDescriptionMap {get{
			CustomErrorCodeDescriptionMap = CustomErrorCodeDescriptionMap==null ? new Map<String,String>() : CustomErrorCodeDescriptionMap;
    		return CustomErrorCodeDescriptionMap;
		}set;}

	    // Error container
	    // Purpose: Given a code the container will look up the corresponding values from some source that will explain the issue to the user / log
	    // Method: System errors and types are ready mapped. Custom error codes and descriptions / types are be additionally mapped via the addEventListener method
	    // This allows error codes to be thrown by a service that gives feedback in a meaningful way.
	    public class ErrorContainer {
	    	
	    	public String status = ''+CalloutStatus.FAILED;
	    	public ErrorCode systemErrCode;
	    	public String errCode = '';
	    	public String errType {get{return String.ValueOf(ErrorCodeTypeMap.containsKey(errCode) ? ErrorCodeTypeMap.get(errCode) : ErrorType.GENERIC);}set;}
	    	public String description = '';
	    	
	    	// System error
	    	public ErrorContainer(ErrorCode systemErrCode){
	    		this.systemErrCode = systemErrCode;
	    		UTIL_Error.report(errType, status+':'+errCode+':'+description, 'HTTP Integration');
	    	}
		    	// System error with status enum
		    	public ErrorContainer(ErrorCode systemErrCode, CalloutStatus status){
		    		this.systemErrCode = systemErrCode;
		    		this.status = ''+status;
		    		UTIL_Error.report(errType, status+':'+errCode+':'+description, 'HTTP Integration');
		    	}
		    	// System error with custom description
		    	public ErrorContainer(ErrorCode systemErrCode, String description){
		    		this.systemErrCode = systemErrCode;
		    		this.description = description;
		    		UTIL_Error.report(errType, status+':'+errCode+':'+description, 'HTTP Integration');
		    	}
		    	// System error with status enum and custom description
		    	public ErrorContainer(ErrorCode systemErrCode, CalloutStatus status, String description){
		    		this.systemErrCode = systemErrCode;
		    		this.status = ''+status;
		    		this.description = description;
		    		UTIL_Error.report(errType, status+':'+errCode+':'+description, 'HTTP Integration');
		    	}
	    	// Custom error with custom description
	    	public ErrorContainer(String errCode, String description){
	    		this.errCode = errCode;
	    		this.description = description;
	    		UTIL_Error.report(errType, status+':'+errCode+':'+description, 'HTTP Integration');
	    	}
	    }

	
    /***** Custom settings helper methods *****/
    
	    static Object getHttpIntegrationSetting(String field, Object defaultValue)
	    {
	        Object value = getHttpIntegrationSetting(field);
	        return value == null ? defaultValue : value;
	    }
	    
	    static Object getHttpIntegrationSetting(String field)
	    {
	        Object value = HTTP_Integration_Settings__c.getOrgDefaults().get(field);
	        system.debug(Logginglevel.INFO,'++value++'+value);
	        return value;
	    }
	    
	    public static HTTP_Integration_Services__c getServiceSetting(String integrationName) {
	    	Map<String, HTTP_Integration_Services__c> httpIntegrationServicesMap = HTTP_Integration_Services__c.getAll();
	    	if(httpIntegrationServicesMap.containsKey(integrationName) && httpIntegrationServicesMap.get(integrationName) != null) {
	    		return httpIntegrationServicesMap.get(integrationName);
	    	} else {
	    		return null;
	    	}
	    }
	    
	    public static Object getServiceSetting(String integrationName, String fieldname, Object defaultValue) {	
			try{	
				
				Object value = HTTP_Integration_Services__c.getInstance(integrationName).get(fieldname);
			
				if (UTIL_Apex.empty(value)) {
					return defaultValue;
				}
				return value;
				
				} catch(Exception e) {
				throw new HTTPRequestException (ErrorCode.MISSING_CUSTOM_SETTING,'','Custom setting for the integration is not found (' + integrationName + ')');
			}
		}
}