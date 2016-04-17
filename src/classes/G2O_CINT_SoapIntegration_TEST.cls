/**
    About
    -----
    Description: This class is used to test G2O_CINT_SoapIntegration
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: October 2013
    
    Details
    -------
    1. 
        
    Update History
    --------------
    Created October 2013 - C.H.F.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_CINT_SoapIntegration_TEST {

    static testMethod void testCreateXMLBody() {
    	
    	// Arrange
    	UTIL_TestFactory.setUpOrg();
    	
    	G2O_CINT_SoapIntegration soap = new G2O_CINT_SoapIntegration('G2O_CINT_SoapIntegration_TEST','VAP');
    	
    	soap.requestParameters.put('nameTEST','valueTEST');
    	soap.sequenceRequestParameters.put('nameTESTs', new List<String>{'valueTEST1', 'valueTEST2'});
    	
    	String correctXml = ''+
			'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://new.webservice.namespace" xmlns:wsse="http://schemas.xmlsoap.org/ws/2002/04/secext" >\r\n'+
			'<soapenv:Body>\r\n'+
			'			<ns:ItemLocation>\r\n'+
			'			<!-- Several specification blocks could be used but will be merged together as one block -->\r\n'+
			'				<ns:Specification>\r\n'+
			'					<!-- Property without sequence is interpreted as single value element, mulitple existence of same attribute will overwrite (undefined behaviour) -->\r\n'+
			'					<ns:Property>\r\n'+
			'						<ns:NameValue name="nameTEST">valueTEST</ns:NameValue>\r\n'+
			'					</ns:Property>\r\n'+
			'					<!-- Property without sequence is interpreted as single value element, mulitple existence of same attribute will overwrite (undefined behaviour) -->\r\n'+
			'					<ns:Property sequence="1">\r\n'+
			'						<ns:NameValue name="nameTESTs">valueTEST1</ns:NameValue>\r\n'+
			'					</ns:Property>\r\n'+
			'					<!-- Property without sequence is interpreted as single value element, mulitple existence of same attribute will overwrite (undefined behaviour) -->\r\n'+
			'					<ns:Property sequence="2">\r\n'+
			'						<ns:NameValue name="nameTESTs">valueTEST2</ns:NameValue>\r\n'+
			'					</ns:Property>\r\n'+
			'			</ns:Specification>\r\n'+
			'				<!-- Defines the request variant for the specified system, if omitted, the default variant is used -->\r\n'+
			'				<ns:Type>TEST</ns:Type>\r\n'+
			'			</ns:ItemLocation>\r\n'+
			'	</soapenv:Body>\r\n'+
			'</soapenv:Envelope>\r\n';
    	
    	
    	// Act
    	String xml = soap.createXMLBody();
    	
    	System.debug(Logginglevel.ERROR, correctXml);
    	System.debug(Logginglevel.ERROR, xml);
    	
    	// Assert
    	System.assert(xml == correctXml, 'The XML was not created correctly');
    	

    }
    
    static testMethod void testHandleResponseErrorsCINT() {
    	
    	// Arrange
    	UTIL_TestFactory.setUpOrg();
    	
    	G2O_CINT_SoapIntegration soap = new G2O_CINT_SoapIntegration('G2O_CINT_SoapIntegration_TEST','VAP');
    	
		soap.callout = new UTIL_HttpIntegration.CalloutResult();
		String xml = '<?xml version="1.0"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><SOAP-ENV:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema"><ItemLocation xmlns="http://new.webservice.namespace">-<UserArea><Message xmlns="" xmlns:NS1="http://www.w3.org/2001/XMLSchema-instance" NS1:type="xsd:string">Internal CINT Error</Message><MsgCode xmlns="" xmlns:NS1="http://www.w3.org/2001/XMLSchema-instance" NS1:type="xsd:string">100</MsgCode></UserArea></ItemLocation></SOAP-ENV:Body></SOAP-ENV:Envelope>';
		soap.callout.xml = new UTIL_XmlDom(xml);
    	
    	// Act
    	soap.handleResponseErrors();
    	
    	// Assert
    	System.assertEquals('100', soap.callout.error.errCode);
        System.assertEquals('Internal CINT Error', soap.callout.error.description);
    	
    	

    }
    
    static testMethod void testHandleResponseErrorsSOAP() {
    	
    	// Arrange
    	UTIL_TestFactory.setUpOrg();
    	
    	G2O_CINT_SoapIntegration soap = new G2O_CINT_SoapIntegration('G2O_CINT_SoapIntegration_TEST','VAP');
    	
		soap.callout = new UTIL_HttpIntegration.CalloutResult();
		String xml = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">-<SOAP-ENV:Body>-<SOAP-ENV:Fault><faultcode>SOAP-ENV:Server</faultcode><faultstring>Problem connecting to service at host: "10.121.110.181" , port: "9,090". Make sure the service is running.</faultstring><faultactor>DefaultRole</faultactor><detail><tibco:myFaultDetail xmlns:tibco="http://tibcouri/">SDFSDFSD</tibco:myFaultDetail></detail></SOAP-ENV:Fault></SOAP-ENV:Body></SOAP-ENV:Envelope>';
		soap.callout.xml = new UTIL_XmlDom(xml);
    	
    	// Act
    	soap.handleResponseErrors();
    	
    	// Assert
    	System.assertEquals('SOAP-ENV:Server', soap.callout.error.errCode);
        System.assertEquals('Problem connecting to service at host: "10.121.110.181" , port: "9,090". Make sure the service is running.', soap.callout.error.description);
    	
    	

    }
    
}