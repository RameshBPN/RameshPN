/**
    About
    -----
    Description: A controller to do VAP Requests
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    
    Methods:
    -------
        1. doVapRequest             :   Calls the VAP service and saves the result
        
    Update History
    --------------
    Created May 2013 - C.H.F.
    
    Issues / TODOs
    --------------  
    
*/
global with sharing class G2O_VAPRequest_WSx {
    
    // webService being called from JavaScript in custom button
    webService static String doVapRequest (Id vapCaseId) {
        System.debug(logginglevel.Info, '### START VAPRequest_VFC.doVapRequest ('+vapCaseId+')');
        
        // Loads the fields to send
        Case vapCase = [SELECT Id, Receiver__r.MOD_Address_Number__c, Receiver_Postal_Address_Postal_Code__c
                        FROM Case
                        WHERE Id = :vapCaseId];
        
        G2O_VAPRequest_WS vap;
        // Calls the VAP service
        try{
            vap = new G2O_VAPRequest_WS(vapCase);
            vap.send(vapCase.Id);
        
        if(vap.callout.error != null) {
        	if(vap.callout.error.errCode == '-1405') {
        		return Label.Error_from_External_Service + ' ' + Label.Error_Message_for_1405;
        	} else {
            	return Label.Error_from_External_Service + ' ' + vap.callout.error.description;
        	}
        }
        
        // Load old VAP Teams
        VAP_Team__c[] oldVAPTeams = [SELECT Id FROM VAP_Team__c WHERE Case__c = :vapCaseId];
        
        delete oldVAPTeams;
        insert vap.result;
            
        } catch(CalloutException e){
            System.debug(logginglevel.Info, '### END VAPRequest_VFC.doVapRequest');
            return Label.Error_from_Callout + ' ' + e.getMessage();
        
        } catch(UTIL_HttpIntegration.MappingException e){
            System.debug(logginglevel.Info, '### END VAPRequest_VFC.doVapRequest');
            return Label.Error_Field_Missing + ' ' + e.fieldPath;
        
        } catch (Exception e) {
            System.debug(logginglevel.Info, '### END VAPRequest_VFC.doVapRequest');
            UTIL_Error.report('VAP Request', e);
            UTIL_Error.writeNow();
            return Label.Error_from_Salesforce;
            
        }
        
        System.debug(logginglevel.Info, '### END VAPRequest_VFC.doVapRequest');
        return ''; // No errors
        
        
    }

}