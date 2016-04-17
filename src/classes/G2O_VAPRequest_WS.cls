/**
    About
    -----
    Description: Service for VAP: Can give you the route under certain conditions for certain product types
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    Depends on G2O_CINT_SoapIntegration->
    
    Use
        Set up an integration configuration in HTTP Integration Services (custom setting) called 'VAP'
        Code to use the service:
        
        // Create the connection
        G2O_VAPRequest_WS vap = new G2O_VAPRequest_WS();
        
        // Send the callout
        vap.send('some objectID - case etc.'');
        //or just vap.send() if you don't want to relate the result to a record
        
        // Use the result
        vap.result; // Now contains the resulting VAP information
        
        // If the result is null then check for errors
        vap.callout.errors; // Contains a list of ErrorContainer objects which will describe the problems with error codes etc.
        vap.callout.error; // The latest (Final) error is kept on .error for convenience
    
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------
    
*/

public class G2O_VAPRequest_WS extends G2O_CINT_SoapIntegration{
    
    public List<VAP_Team__c> result {get{result = result==null ? new List<VAP_Team__c>():result;return result;}set;}    // Will contain the result
    Case vapCase;
    
    /***** Constructor *****/
    public G2O_VAPRequest_WS(Case vapCase)
    {
        super('G2O_VAPRequest_WS', 'VAP');
        
        if (UTIL_Apex.empty(vapCase.Receiver__r.MOD_Address_Number__c)){
    		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Receiver__r.MOD_Address_Number__c');
    	}
    	
    	if (UTIL_Apex.empty(vapCase.Receiver_Postal_Address_Postal_Code__c)){
    		throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Receiver_Postal_Address_Postal_Code__c');
    	}
    	
        this.vapCase = vapCase;
        requestParameters.put('VAP_adresse_nr',vapCase.Receiver__r.MOD_Address_Number__c);
        requestParameters.put('VAP_postnr',vapCase.Receiver_Postal_Address_Postal_Code__c);
        requestParameters.put('VAP_dato',String.valueOf(Date.Today()).remove('-'));
    }
    
    /***** Parse Result *****/
    public override void handleResponse()
    {
        // Check if there is errors
        if (callout.errors.size()==0)
        {
            // Split the respons into the parcel and letter part
            UTIL_XmlDom.Element parcelXml = callout.xml.getElementByTagName('Parcel_25');
            UTIL_XmlDom.Element letterXml = callout.xml.getElementByTagName('Letter_1478');
            
            UTIL_XmlDom.Element[] parcelResults = parcelXml.getElementsByTagName('ResultField');
            UTIL_XmlDom.Element[] letterResults = letterXml.getElementsByTagName('ResultField');
            
            // A map to store the returned values
            Map<String,String> parcelNameValuePairs = new Map<String,String>();
            Map<String,String> letterNameValuePairs = new Map<String,String>();
            
            for(UTIL_XmlDom.Element e : parcelResults){
            	parcelNameValuePairs.put(e.getElementByTagName('name').nodeValue,e.getElementByTagName('value').nodeValue);
            }
            
            for(UTIL_XmlDom.Element e : letterResults){
            	letterNameValuePairs.put(e.getElementByTagName('name').nodeValue,e.getElementByTagName('value').nodeValue);
            }
			

			List<String> parcelOrgsSearch = new List<String>();
			List<String> letterOrgsoSearch = new List<String>();
			
			// Fetches the MODInteressentNumber from the respons
			parcelOrgsSearch.add(parcelNameValuePairs.get('VAP_interessent_nr'));
			parcelOrgsSearch.add(parcelNameValuePairs.get('VAP_team_intr_nr'));
			parcelOrgsSearch.add(parcelNameValuePairs.get('VAP_anmeld_intr_nr'));
			letterOrgsoSearch.add(letterNameValuePairs.get('VAP_interessent_nr'));
			letterOrgsoSearch.add(letterNameValuePairs.get('VAP_team_intr_nr'));
			letterOrgsoSearch.add(letterNameValuePairs.get('VAP_anmeld_intr_nr'));
			
			// Fetches the accounts with matching orgIds
			List<Account> parcelAccountList = [SELECT Id, MOD_Interessent_Number__c, RecordTypeId
                                        	   FROM Account
                                        	   WHERE MOD_Interessent_Number__c IN :parcelOrgsSearch
                                        	   AND RecordTypeId = :UTIL_Meta.getAccountPostNordOrgStructureRT() LIMIT 1000];
			
			List<Account> letterAccountList = [SELECT Id, MOD_Interessent_Number__c, RecordTypeId
                                        	   FROM Account
                                        	   WHERE MOD_Interessent_Number__c IN :letterOrgsoSearch
											   AND RecordTypeId = :UTIL_Meta.getAccountPostNordOrgStructureRT() LIMIT 1000];
                                        	
			Map<String,String> parcelOrgsMap = new Map<String,String>();
			Map<String,String> letterOrgsMap = new Map<String,String>();
			
			for(Account a : parcelAccountList) {
				parcelOrgsMap.put(a.MOD_Interessent_Number__c, a.Id);
			}
			
			for(Account a : letterAccountList) {
				letterOrgsMap.put(a.MOD_Interessent_Number__c, a.Id);
			}
			
			// Creates 6 VAP Teams of different type. 3 for letter and 3 for parcel. Route Description and Route No is stored on all of them (they are always the same)
			VAP_Team__c parcelTeam = new VAP_Team__c();
			parcelTeam.Case__c = vapCase.Id;
            parcelTeam.VAP_Unit__c = parcelOrgsMap.get(parcelNameValuePairs.get('VAP_team_intr_nr'));
            parcelTeam.Parcel_Letter__c = 'Parcel Team';
            parcelTeam.Route_Description__c = parcelNameValuePairs.get('VAP_rutenavn');
            parcelTeam.Route_no__c = parcelNameValuePairs.get('VAP_rutekode');
			result.add(parcelTeam);
			
			VAP_Team__c letterTeam = new VAP_Team__c();
			letterTeam.Case__c = vapCase.Id;
            letterTeam.VAP_Unit__c = letterOrgsMap.get(letterNameValuePairs.get('VAP_team_intr_nr'));
            letterTeam.Parcel_Letter__c = 'Letter Team';
            letterTeam.Route_Description__c = letterNameValuePairs.get('VAP_rutenavn');
            letterTeam.Route_no__c = letterNameValuePairs.get('VAP_rutekode');
			result.add(letterTeam);
			
			VAP_Team__c parcelDistributionCenter = new VAP_Team__c();
			parcelDistributionCenter.Case__c = vapCase.Id;
            parcelDistributionCenter.VAP_Unit__c = parcelOrgsMap.get(parcelNameValuePairs.get('VAP_interessent_nr'));
            parcelDistributionCenter.Parcel_Letter__c = 'Parcel Distribution Center';
			result.add(parcelDistributionCenter);
			
			VAP_Team__c letterDistributionCenter = new VAP_Team__c();
			letterDistributionCenter.Case__c = vapCase.Id;
            letterDistributionCenter.VAP_Unit__c = letterOrgsMap.get(letterNameValuePairs.get('VAP_interessent_nr'));
            letterDistributionCenter.Parcel_Letter__c = 'Letter Distribution Center';
			result.add(letterDistributionCenter);
			
			VAP_Team__c parcelPickUpPlace = new VAP_Team__c();
			parcelPickUpPlace.Case__c = vapCase.Id;
            parcelPickUpPlace.VAP_Unit__c = parcelOrgsMap.get(parcelNameValuePairs.get('VAP_anmeld_intr_nr'));
            parcelPickUpPlace.Parcel_Letter__c = 'Parcel Pick-up Place';
			result.add(parcelPickUpPlace);
			
			VAP_Team__c letterPickUpPlace = new VAP_Team__c();
			letterPickUpPlace.Case__c = vapCase.Id;
            letterPickUpPlace.VAP_Unit__c = letterOrgsMap.get(letterNameValuePairs.get('VAP_anmeld_intr_nr'));
            letterPickUpPlace.Parcel_Letter__c = 'Letter Pick-up Place';
			result.add(letterPickUpPlace);
        }
    }
}