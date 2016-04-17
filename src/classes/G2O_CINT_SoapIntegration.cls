/**
	About
	-----
	Description: Virtual class to extend when requesting web services on the CINT ESB
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: Jan 2013
	
	Details / Methods
	-----------------
	Provides a template for a standard message format, logging and settings to be used for requests.

	Use
		This class is an implementation of the HTTPIntegration pattern for CINT to send SOAP messages over HTTP to the integration layer
		It is intended to provide a standard interaction approach for CINT web services based on an OAGIS message format
		1) Extend this class to give a service for a real time endpoint, such as VAP/MOD/NTT etc.
		2) Set up the intgration's settings in custom settings, and when creating a new request, give the integration name so that the base layer looks up the right settings.
		3) Call the service from your controller. The integration will be looked up from settings by name by the base class and this class will provide structure for the message. 
		4) If you require more control over the outgoing message, you can override the createXMLBody, getSoapMessage, getSoapHeader and getSoapBody methods in your extending class

	Testing and Mock requests
		Note that this script used to use xml passed in a static variable to test callouts. 
		MultiStaticResourceCalloutMock should be used instead in testing scenarios.

	Notes
		In CINT accross services, the only change in a request appart from autentication parameters, service name etc is the body, so createXML is overridden here
		For NTT type requests where the request has the authentication in the URL; create the http service let the base class fetch everything from the custom settings, then set the endpoint in code to the correct format ie url?id etc. before calling the send method
		If a service that requires more explicit manipulation of the body XML in the soap message, then that can be further overridden by the extending service class, OR copy this class if it's going to be used by several other integrations (use suitable naming conventions!)
	
	Update History
	--------------
	Created Jan 2013 - M.E.
	First Compile March 2013 - M.E.
	Updated May 2013 - C.H.F. :	Commented out UserArea, not needed for now
	Updated June 2013 - C.H.F.  : Commented out second constructors, not needed for now
	Updated August 2013 - C.H.F.  : Commented out header, not needed for now
	Updated August 2013 - C.H.F.  : Removed commented out code and put an empty check on related_sObjectId
	Updated October 2013 - C.H.F. : Added response rrrors handeling for CINT
	
	Issues / TODOs
	--------------		
*/
public virtual class G2O_CINT_SoapIntegration extends UTIL_HttpIntegration
{
	public String source = 'CINT Request Apex Code'; // Tells CINT what the source inside of salesforce produced the request. Not mandatory but should be set.
	public map<String,String> requestParameters = new map<String,String>(); //Stores the request parameters for the service
	public map<String,List<String>> sequenceRequestParameters = new map<String,List<String>>(); //Stores the request parameters for arrays of data
	
	String cintErrorCodeXMLPath = UTIL_OrgSettings.CINTCustomErrorCode();
	String cintErrorDescriptionXMLPath = UTIL_OrgSettings.CINTCustomErrorDescription();
	
	String soapErrorCodeXMLPath = UTIL_OrgSettings.SOAPErrorCode();
	String soapErrorDescriptionXMLPath = UTIL_OrgSettings.SOAPErrorDescription();
	
	/***** Constructors *****/
		public G2O_CINT_SoapIntegration(String source, String integrationName)
		{
			//Use the default behaviour and load the settings from custom settings table HTTP Integration Services
			super(integrationName);
			this.source = source;
		}
		
	/***** Implement message creation methods *****/
		// Place methods to allow flexible manipulation of the XML body here.
		// The basic method is createXMLBody(), implemented here as a start to the project but if required this can be overridden by the consuming class higher up
		public virtual override String createXMLBody()
		{
			return getSoapMessage();
		}
		
		public virtual String getSoapMessage()
		{			
			return ''+
			'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://new.webservice.namespace" xmlns:wsse="http://schemas.xmlsoap.org/ws/2002/04/secext" >\r\n'+
			getSoapBody() +
			'</soapenv:Envelope>\r\n';
		}
		
		public virtual String getSoapBody()
		{
			//This method will assemble the parameters for the request
			String body = '<soapenv:Body>\r\n'+
				'			<ns:ItemLocation>\r\n';
			if(!UTIL_Apex.empty(this.related_sObjectId))	{
				body += ''+
				'				<!-- ItemId takes a set of ID - These are copied to the response. Could be used for correlation purposes -->\r\n'+
				'				<ns:ItemId>\r\n'+
				'					<ns:Id>'+this.related_sObjectId.escapeXml()+'</ns:Id>\r\n'+
				'				</ns:ItemId>\r\n';
			}
			body += ''+
				'			<!-- Several specification blocks could be used but will be merged together as one block -->\r\n'+
				'				<ns:Specification>\r\n';
			for(String name : requestParameters.keySet()) {
				String value = requestParameters.get(name);
				body += ''+
				'					<!-- Property without sequence is interpreted as single value element, mulitple existence of same attribute will overwrite (undefined behaviour) -->\r\n'+
				'					<ns:Property>\r\n'+
				'						<ns:NameValue name="'+name+'">'+value.escapeXml()+'</ns:NameValue>\r\n'+
				'					</ns:Property>\r\n';
			}
			for(String name : sequenceRequestParameters.keySet()) {
				String[] values = sequenceRequestParameters.get(name);
				Integer i = 1;
				for(String value : values) {
					body += ''+
					'					<!-- Property without sequence is interpreted as single value element, mulitple existence of same attribute will overwrite (undefined behaviour) -->\r\n'+
					'					<ns:Property sequence="' + i + '">\r\n'+
					'						<ns:NameValue name="'+name+'">'+value.escapeXml()+'</ns:NameValue>\r\n'+
					'					</ns:Property>\r\n';
					i++;
				}
			}
			body +=	'			</ns:Specification>\r\n'+
				'				<!-- Defines the request variant for the specified system, if omitted, the default variant is used -->\r\n'+
				'				<ns:Type>'+this.provider.escapeXml()+'</ns:Type>\r\n'+
				'			</ns:ItemLocation>\r\n'+
				'	</soapenv:Body>\r\n';
				
				/// Include service - so that CINT can use it in the future if they wish (currently unused)
				/// We need to include Version__c - CINT now need to use this to return the version speciffied - IF we provide a version number. 
				
			return body;
		}
		
		public virtual override void handleResponseErrors() {
			// Analyse errors from the back end service
			super.handleResponseErrors();
			
			// Analyse CINT errors
			if (!UTIL_Apex.empty(callout.xml))
			{
				String errorCode = '';
				String errorDescription = '';
				
				// First we look for SOAP Errors
				if (!UTIL_Apex.empty(cintErrorCodeXMLPath) && !UTIL_Apex.empty(cintErrorDescriptionXMLPath))
				{
					errorCode = callout.xml.root.getValueBySimplePath(cintErrorCodeXMLPath);
					errorDescription = callout.xml.root.getValueBySimplePath(cintErrorDescriptionXMLPath);
					if (!UTIL_Apex.empty(errorCode) && !UTIL_Apex.empty(errorDescription))
					{
						// Record the custom error code and description
						callout.error = new ErrorContainer(errorCode,errorDescription);
					}
				}
				
				// Then we look for CINT custom errors
				if (!UTIL_Apex.empty(soapErrorCodeXMLPath) && !UTIL_Apex.empty(soapErrorDescriptionXMLPath))
				{
					errorCode = callout.xml.root.getValueBySimplePath(soapErrorCodeXMLPath);
					errorDescription = callout.xml.root.getValueBySimplePath(soapErrorDescriptionXMLPath);
					if (!UTIL_Apex.empty(errorCode) && !UTIL_Apex.empty(errorDescription))
					{
						// Record the custom error code and description
						callout.error = new ErrorContainer(errorCode,errorDescription);
					}
				}
			}
		}
}