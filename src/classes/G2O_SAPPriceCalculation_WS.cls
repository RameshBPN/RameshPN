/**
    About
    -----
    Description: Service for SAP Price Calculation
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Jan 2013
    
    Details / Methods
    -----------------
    Depends on G2O_CINT_SoapIntegration->
    
    Use
        Set up an integration configuration in HTTP Integration Services (custom setting) called 'SAPPriceCalculation'
        Code to use the service:
        
        // Create the connection
        G2O_SAPPriceCalculation_WS sapPriceCalc = new G2O_SAPPriceCalculation_WS(theCase, product);
        
        // Send the callout
        sapPriceCalc.send('some objectID - case etc.'');
        //or just sapPriceCalc.send() if you don't want to relate the result to a record
        
        // Use the result
        sapPriceCalc.result; // Now contains the resulting SAPPrice information
        
        // If the result is null then check for errors
        sapPriceCalc.callout.errors; // Contains a list of ErrorContainer objects which will describe the problems with error codes etc.
        sapPriceCalc.callout.error; // The latest (Final) error is kept on .error for convenience
    
    Update History
    --------------
    Created Jan 2013 - M.E.
    First Compile March 2013 - M.E.
    Updated April 2013 - C.H.F.
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_SAPPriceCalculation_WS extends G2O_CINT_SoapIntegration {
	
    public CaseProduct__c result;   // Will contain the result
    
    /***** Constructor *****/
    public G2O_SAPPriceCalculation_WS(CaseProduct__c caseProduct)
    {
        super('G2O_SAPPriceCalculation_WS', 'SAP_PriceCalculation');
        
        // Get all the fields we need for the request
        caseProduct = [SELECT Id, Name, Weight_Unit__c, Weight_Value__c, Distribution_Channel__c, Division__c,  Product_ID__c, Item_Id__c, Receiver_Customer_Number__c,
                              Additional_Service1__c, Additional_Service2__c, Additional_Service3__c, Additional_Service4__c,
                              Additional_Service1__r.Product_Article_ID__c, Additional_Service2__r.Product_Article_ID__c, Additional_Service3__r.Product_Article_ID__c,
                              Additional_Service4__r.Product_Article_ID__c, Case__r.Sender__r.Involved_Party_ID__c,
                              Customer_Service_Product__c, Customer_Service_Product__r.Sales_Area__c, Case__r.Sender_Postal_Address_Country__c, Type_of_franking__c,
                              Case__r.Sender_Postal_Address_Postal_Code__c, Case__r.Receiver_Postal_Address_Country__c, Case__r.Receiver_Postal_Address_Postal_Code__c
                       FROM CaseProduct__c
                       WHERE Id = :caseProduct.Id];
        
        result = caseProduct; // Set the result to the Case Product in question
        
        // Throw errors if mandatory data not supplied
        if (UTIL_Apex.empty(caseProduct.Case__r.Sender__c)){
    		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'caseProduct.Case__r.Sender__c',System.Label.Error_Message_No_Sender);
    	}
        
        if (UTIL_Apex.empty(caseProduct.Customer_Service_Product__c)){
    		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Customer_Service_Product__c',System.Label.Error_Message_Customer_Service_Product);
    	}
    	
    	if (!UTIL_Apex.empty(UTIL_OrgSettings.SwedishSalesAreas())
    			&& UTIL_OrgSettings.SwedishSalesAreas().contains(caseProduct.Customer_Service_Product__r.Sales_Area__c)
    			&& UTIL_Apex.empty(caseProduct.Item_Id__c)){
    		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Customer_Service_Product__r.Sales_Area__c',System.Label.Error_Message_Sales_Area_Sweden);
    	}                
		
		// All parameters (excluding null values)
		requestParameters.put('Quantity','1');
        if(!UTIL_Apex.empty(caseProduct.Customer_Service_Product__r.Sales_Area__c)) requestParameters.put('SalesOrganisation',caseProduct.Customer_Service_Product__r.Sales_Area__c);
        if(!UTIL_Apex.empty(caseProduct.Distribution_Channel__c)) requestParameters.put('DistributionChannel',caseProduct.Distribution_Channel__c);
        if(!UTIL_Apex.empty(caseProduct.Division__c)) requestParameters.put('Division',caseProduct.Division__c);
        if(!UTIL_Apex.empty(caseProduct.Product_ID__c)) requestParameters.put('Material',caseProduct.Product_ID__c);
        if(!UTIL_Apex.empty(caseProduct.Item_Id__c)) requestParameters.put('ItemId',caseProduct.Item_Id__c);
        if(!UTIL_Apex.empty(caseProduct.Weight_Unit__c)) requestParameters.put('WeightUnit',caseProduct.Weight_Unit__c);
        if(!UTIL_Apex.empty(caseProduct.Weight_Value__c)) requestParameters.put('Weight',String.valueOf(caseProduct.Weight_Value__c));
        
        if(!UTIL_Apex.empty(caseProduct.Case__r.Sender__r.Involved_Party_ID__c)) requestParameters.put('SoldToParty',caseProduct.Case__r.Sender__r.Involved_Party_ID__c);
        if(!UTIL_Apex.empty(caseProduct.Case__r.Sender_Postal_Address_Country__c)) requestParameters.put('SenderCountry',caseProduct.Case__r.Sender_Postal_Address_Country__c);
        if(!UTIL_Apex.empty(caseProduct.Case__r.Sender_Postal_Address_Postal_Code__c)) requestParameters.put('Senderpostalcode',caseProduct.Case__r.Sender_Postal_Address_Postal_Code__c);
        
        if(!UTIL_Apex.empty(caseProduct.Case__r.Receiver_Postal_Address_Country__c)) requestParameters.put('ReceiverCountry',caseProduct.Case__r.Receiver_Postal_Address_Country__c);
        if(!UTIL_Apex.empty(caseProduct.Case__r.Receiver_Postal_Address_Postal_Code__c)) requestParameters.put('Receiverpostalcode',caseProduct.Case__r.Receiver_Postal_Address_Postal_Code__c);
        
        if(!UTIL_Apex.empty(caseProduct.Type_of_franking__c)) requestParameters.put('Type_franking',caseProduct.Type_of_franking__c);

        if(caseProduct.Additional_Service1__c != null){
             requestParameters.put('ConditionTypeId1', caseProduct.Additional_Service1__r.Product_Article_ID__c);
        }
        
        if(caseProduct.Additional_Service2__c != null){
             requestParameters.put('ConditionTypeId2', caseProduct.Additional_Service2__r.Product_Article_ID__c);
        }
        
        if(caseProduct.Additional_Service3__c != null){
             requestParameters.put('ConditionTypeId3', caseProduct.Additional_Service3__r.Product_Article_ID__c);
        }
        
        if(caseProduct.Additional_Service4__c != null){
             requestParameters.put('ConditionTypeId4', caseProduct.Additional_Service4__r.Product_Article_ID__c);
        }       
    }
    
    /***** Parse Result *****/
    public override void handleResponse()
    {
        // Check if there is errors
        if (callout.errors.size()==0){
            
            if(callout.xml.getElementByTagName('NetValue') != null) {
            	result.Net_Value__c                 		=   Decimal.valueOf(callout.xml.getElementByTagName('NetValue').nodeValue);
            }
            if(callout.xml.getElementByTagName('GrossValue') != null) {
            	result.GrossValue__c                 		=  Decimal.valueOf(callout.xml.getElementByTagName('GrossValue').nodeValue);
            }
            if(callout.xml.getElementByTagName('DiscountAmount') != null) {
            	result.Discount_Amount__c            		=  Decimal.valueOf(callout.xml.getElementByTagName('DiscountAmount').nodeValue);
            }
            if(callout.xml.getElementByTagName('ShipmentAmount') != null) {
            	result.Portobel__c                   		=  Decimal.valueOf(callout.xml.getElementByTagName('ShipmentAmount').nodeValue);
            }
            if(callout.xml.getElementByTagName('Surcharges') != null) {
            	result.Surcharges__c                 		=  Decimal.valueOf(callout.xml.getElementByTagName('Surcharges').nodeValue);
            }
            if(callout.xml.getElementByTagName('SalespriceVAT') != null) {
            	result.VAT_on_Sales_Price__c         		=  Decimal.valueOf(callout.xml.getElementByTagName('SalespriceVAT').nodeValue);
            }
            if(callout.xml.getElementByTagName('Taxation') != null) {
            	result.Taxering__c                   		=  callout.xml.getElementByTagName('Taxation').nodeValue;
            }
            if(callout.xml.getElementByTagName('JointTaxation') != null) {
            	result.Samtax_ID__c                  		=  callout.xml.getElementByTagName('JointTaxation').nodeValue;
            }
            if(callout.xml.getElementByTagName('Currency') != null) {
            	result.CurrencyIsoCode               		=  callout.xml.getElementByTagName('Currency').nodeValue;
            }
            if(callout.xml.getElementByTagName('TotalNetValue') != null) {
            	result.Total_postage_amount_without_VAT__c	=  Decimal.valueOf(callout.xml.getElementByTagName('TotalNetValue').nodeValue);
            }
	        
	        
	        // We get the price for the additional service from two differenct fields, one for price ex. VAT and on with the VAT
	        UTIL_XmlDom.Element[] additionalServices = callout.xml.getElementsByTagName('AdditionalServices');
	        
	        // Linking the correct Additional service back to the correct field, here we get the VAT component of the price
	        for(UTIL_XmlDom.Element e : additionalServices) {
	        	if(!UTIL_Apex.empty(e.getElementByTagName('AdditionalService')) && (e.getElementByTagName('AdditionalService').nodeValue == result.Additional_Service1__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('AdditionalServiceVAT') != null && !UTIL_Apex.empty(e.getElementByTagName('AdditionalServiceVAT').nodeValue)) {
	        		 	result.Additional_service_1_VAT__c  =   Decimal.valueOf(e.getElementByTagName('AdditionalServiceVAT').nodeValue);
	        		 } else {
	        		 	result.Additional_service_1_VAT__c = 0;
	        		 }
	        	}
	        	
	        	if(!UTIL_Apex.empty(e.getElementByTagName('AdditionalService')) && (e.getElementByTagName('AdditionalService').nodeValue == result.Additional_Service2__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('AdditionalServiceVAT') != null && !UTIL_Apex.empty(e.getElementByTagName('AdditionalServiceVAT').nodeValue)) {
	        		 	result.Additional_service_2_VAT__c  =   Decimal.valueOf(e.getElementByTagName('AdditionalServiceVAT').nodeValue);
	        		 } else {
	        		 	result.Additional_service_2_VAT__c = 0;
	        		 }
	        	}
	        	
	        	if(!UTIL_Apex.empty(e.getElementByTagName('AdditionalService')) && (e.getElementByTagName('AdditionalService').nodeValue == result.Additional_Service3__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('AdditionalServiceVAT') != null && !UTIL_Apex.empty(e.getElementByTagName('AdditionalServiceVAT').nodeValue)) {
	        		 	result.Additional_service_3_VAT__c  =   Decimal.valueOf(e.getElementByTagName('AdditionalServiceVAT').nodeValue);
	        		 } else {
	        		 	result.Additional_service_3_VAT__c = 0;
	        		 }
	        	}
	        	
	        	if(!UTIL_Apex.empty(e.getElementByTagName('AdditionalService')) && (e.getElementByTagName('AdditionalService').nodeValue == result.Additional_Service4__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('AdditionalServiceVAT') != null && !UTIL_Apex.empty(e.getElementByTagName('AdditionalServiceVAT').nodeValue)) {
	        		 	result.Additional_service_4_VAT__c  =   Decimal.valueOf(e.getElementByTagName('AdditionalServiceVAT').nodeValue);
	        		 } else {
	        		 	result.Additional_service_4_VAT__c = 0;
	        		 }
	        	}
	        }
	        
	        UTIL_XmlDom.Element[] conditionTypes = callout.xml.getElementsByTagName('ConditionTypes');
	        
	        // Linking the correct ConditionTypes back to the correct field,  here we get the total price before VAT
	        for(UTIL_XmlDom.Element e : conditionTypes) {
	        	if(!UTIL_Apex.empty(e.getElementByTagName('ConditionType')) && (e.getElementByTagName('ConditionType').nodeValue == result.Additional_Service1__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('ConditionValue') != null && !UTIL_Apex.empty(e.getElementByTagName('ConditionValue').nodeValue)) {
	        		 	result.Price_on_Add_Service_1_before_VAT__c  =   Decimal.valueOf(e.getElementByTagName('ConditionValue').nodeValue);
	        		 } else {
	        		 	result.Price_on_Add_Service_1_before_VAT__c = 0;
	        		 }
	        	}
	        	if(!UTIL_Apex.empty(e.getElementByTagName('ConditionType')) && (e.getElementByTagName('ConditionType').nodeValue == result.Additional_Service2__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('ConditionValue') != null && !UTIL_Apex.empty(e.getElementByTagName('ConditionValue').nodeValue)) {
	        		 	result.Price_on_Add_Service_2_before_VAT__c  =   Decimal.valueOf(e.getElementByTagName('ConditionValue').nodeValue);
	        		 } else {
	        		 	result.Price_on_Add_Service_2_before_VAT__c = 0;
	        		 } 
	        		 
	        	}
	        	if(!UTIL_Apex.empty(e.getElementByTagName('ConditionType')) && (e.getElementByTagName('ConditionType').nodeValue == result.Additional_Service3__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('ConditionValue') != null && !UTIL_Apex.empty(e.getElementByTagName('ConditionValue').nodeValue)) {
	        		 	result.Price_on_Add_Service_3_before_VAT__c  =   Decimal.valueOf(e.getElementByTagName('ConditionValue').nodeValue);
	        		 } else {
	        		 	result.Price_on_Add_Service_3_before_VAT__c = 0;
	        		 }
	        	}
	        	if(!UTIL_Apex.empty(e.getElementByTagName('ConditionType')) && (e.getElementByTagName('ConditionType').nodeValue == result.Additional_Service4__r.Product_Article_ID__c)) {
	        		 if(e.getElementByTagName('ConditionValue') != null && !UTIL_Apex.empty(e.getElementByTagName('ConditionValue').nodeValue)) {
	        		 	result.Price_on_Add_Service_4_before_VAT__c  =   Decimal.valueOf(e.getElementByTagName('ConditionValue').nodeValue);
	        		 } else {
	        		 	result.Price_on_Add_Service_4_before_VAT__c = 0;
	        		 }
	        	}
	        }
        }        
    }
}