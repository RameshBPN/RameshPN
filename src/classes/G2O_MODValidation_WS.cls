/**
    About
    -----
    Description: Service for MOD: The MOD system contains every address in DK.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    Depends on G2O_CINT_SoapIntegration->
    For Mapping specification see CINT-MappingSpecification-SFDC-MOD-AddressDataRequest.xls on projectplace.
    
    Use
        Set up an integration configuration in HTTP Integration Services (custom setting) called 'MOD'
        Code to use the service:
        
        // Create the connection
        G2O_MODValidation_WS mod = new G2O_MODValidation_WS('parameters');
        
        // Send the callout
        mod.send('some objectID - case etc.'');
        //or just mod.send() if you don't want to relate the result to a record
        
        // Use the result
        mod.result; // Now contains the resulting MOD information
        
        // If the result is null then check for errors
        mod.callout.errors; // Contains a list of ErrorContainer objects which will describe the problems with error codes etc.
        mod.callout.error; // The latest (Final) error is kept on .error for convenience
    
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------  

*/

public with sharing class G2O_MODValidation_WS extends G2O_CINT_SoapIntegration
{
    public Account[] resultList = new Account[]{}; // Contains the response from Mod - a list of accounts
	public enum QueryType{B2B,B2C}
    
    /***** Constructor *****/
    public G2O_MODValidation_WS(Account modAccount, QueryType modType)
    {
        super('G2O_MODValidation_WS', 'MOD');
        
        // Throw errors if mandatory data not supplied
    	if (UTIL_Apex.empty(modAccount.Postal_Address_Street__c))
    	{
    		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Postal_Address_Street__c',System.Label.Error_Message_Postal_Street);
    	}
    	
    	requestParameters.put('StreetName',modAccount.Postal_Address_Street__c);
        
        if(modType == QueryType.B2C) {
        	if (UTIL_Apex.empty(modAccount.firstName) || UTIL_Apex.empty(modAccount.lastName))
        	{
        		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'FirstName,LastName',System.Label.Error_Message_FirstName_LastName);
        	}
        	requestParameters.put('FirstName',modAccount.firstName);
            requestParameters.put('LastName',modAccount.lastName);
        }
        
        if(modType == QueryType.B2B) {
        	if (UTIL_Apex.empty(modAccount.name))
        	{
        		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Name',System.Label.Error_Message_Name);
        	}
            requestParameters.put('Name',modAccount.name);
        }
        
        if (UTIL_Apex.empty(modAccount.Postal_Address_City__c) && UTIL_Apex.empty(modAccount.Postal_Address_Postal_Code__c))
    	{
    		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Postal_Address_City__c,Postal_Address_Postal_Code__c',System.Label.Error_Message_City_Postcode);
    	}
    	
        if(!UTIL_Apex.empty(modAccount.Postal_Address_City__c)) requestParameters.put('City',modAccount.Postal_Address_City__c);
        if(!UTIL_Apex.empty(modAccount.Postal_Address_Postal_Code__c)) requestParameters.put('PostalCode',modAccount.Postal_Address_Postal_Code__c);
        if(!UTIL_Apex.empty(modAccount.Postal_Address_House_Number__c)) requestParameters.put('HouseNumber',modAccount.Postal_Address_House_Number__c);
        if(!UTIL_Apex.empty(modAccount.Postal_Address_House_Letter__c)) requestParameters.put('HouseLetter',modAccount.Postal_Address_House_Letter__c);
        if(!UTIL_Apex.empty(modAccount.Postal_Address_House_Number_Supplement__c)) requestParameters.put('Floor',modAccount.Postal_Address_House_Number_Supplement__c);
        if(!UTIL_Apex.empty(modAccount.Postal_Address_Suburb__c)) requestParameters.put('Suburb',modAccount.Postal_Address_Suburb__c);
        if(!UTIL_Apex.empty(modAccount.Postal_Address_PO_Box__c)) requestParameters.put('PostBoxNumber',modAccount.Postal_Address_PO_Box__c);
        requestParameters.put('Date',String.valueOf(Date.today()));
    }
    
    /***** Parse Result *****/
    public override void handleResponse()
    {
        // Check the errors in callout.errors
        if (callout.errors.size()==0)
        {
            Integer recordcount = Integer.valueOf(callout.xml.getElementByTagName('recordcount').nodeValue);
            System.debug(Logginglevel.ERROR,'recordcount: ' + recordcount);
            
            UTIL_XmlDom.Element[] resultFieldElements = callout.xml.getElementsByTagName('ResultField');
            System.debug(Logginglevel.ERROR,'resultFieldElements: ' + resultFieldElements);
            
            List<Map<String,String>> nameValuePairsList = new List<Map<String,String>>();
            System.debug(Logginglevel.ERROR,'nameValuePairsList: ' + nameValuePairsList);
            
            for(Integer i = 0; i < recordcount; i++){
            	Map<String,String> nameValuePairsMap = new Map<String,String>();
            	for(UTIL_XmlDom.Element e : resultFieldElements){
            		if(Integer.valueOf(e.getElementByTagName('occ').nodeValue) == i){
            			nameValuePairsMap.put(e.getElementByTagName('name').nodeValue,e.getElementByTagName('value').nodeValue);
            		}
            	}
            	nameValuePairsList.add(nameValuePairsMap);
            }
            
            for(Integer i = 0; i < recordcount; i++){

	            Map<String,String> nameValuePairs = nameValuePairsList[i];
				System.debug(Logginglevel.ERROR,'nameValuePairs: ' + nameValuePairs);
            
				Account modAccount = new Account();
	          
	            modAccount.FirstName = nameValuePairs.get('MSMSAP_fornavn');
	            modAccount.LastName = nameValuePairs.get('MSMSAP_efternavn');
	            modAccount.Name = nameValuePairs.get('MSMSAP_adresseringsnavn'); // The name MOD returns is the work site name, but Name is a mandatory field so we fill both fields.
	            modAccount.Work_Site_Name__c =  nameValuePairs.get('MSMSAP_adresseringsnavn');
	            modAccount.MOD_Modtager_Number__c = nameValuePairs.get('MSMSAP_modtager_nr');
	            modAccount.MOD_Interessent_Number__c = nameValuePairs.get('MSMSAP_interessent_nr');
	            modAccount.MOD_Address_Number__c = nameValuePairs.get('MSMSAP_adresse_nr');
	            modAccount.Postal_Address_Street__c = nameValuePairs.get('MSMSAP_gadenavn');
	            modAccount.Postal_Address_House_Number__c = nameValuePairs.get('MSMSAP_hus_nr');
	            modAccount.Postal_Address_House_Letter__c = nameValuePairs.get('MSMSAP_hus_bogstav');	            
	            modAccount.Postal_Address_House_Number_Supplement__c = nameValuePairs.get('MSMSAP_etage');
	            modAccount.Postal_Address_Suburb__c = nameValuePairs.get('MSMSAP_stednavn');
	            modAccount.Postal_Address_Room_Number__c = nameValuePairs.get('MSMSAP_placering');
	            
	            if(!UTIL_Apex.empty(nameValuePairs.get('MSMSAP_postnr'))) {
	            	modAccount.Postal_Address_Postal_Code__c = nameValuePairs.get('MSMSAP_postnr');
	            }
	            if(!UTIL_Apex.empty(nameValuePairs.get('MSMSAP_postboks_postnr'))) {
	            	modAccount.Postal_Address_Postal_Code__c = nameValuePairs.get('MSMSAP_postboks_postnr');
	            }
	            if(!UTIL_Apex.empty(nameValuePairs.get('MSMSAP_stormodt_postnr'))) {
	            	modAccount.Postal_Address_Postal_Code__c = nameValuePairs.get('MSMSAP_stormodt_postnr');
	            }
	            
				modAccount.Postal_Address_PO_Box__c = nameValuePairs.get('MSMSAP_postboks_nr');
	            modAccount.Postal_Address_City__c = nameValuePairs.get('MSMSAP_bynavn');
	            modAccount.Postal_Address_C_O__c = nameValuePairs.get('MSMSAP_co_pr_navn');
	            if(nameValuePairs.get('MSMSAP_beskyttet') == 'J') modAccount.Secret_Address__c = true;
	            if(nameValuePairs.get('MSMSAP_beskyttet') == 'N') modAccount.Secret_Address__c = false;
	            
	            modAccount.Work_Site_Registration_Number__c = nameValuePairs.get('MSMSAP_prod_nr');
	            
	            resultList.add(modAccount);

            }

        }
    }
}