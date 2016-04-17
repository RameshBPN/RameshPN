/**
    About
    -----
    Description: Case Print Save Email Redirection
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    This is the controller class for PrintSaveEmail page,performs redirection & populates fields when 'Print & Save Email' button is clicked.
    
    Methods:
    -------
        1.set the url parameters & redirect it to the standard email page.
            
    Wrapper Classes Created:
    -----------------------
        
    Update History
    --------------
    Created April 2013 - R.T.
    Refactored May 2013 - A.B.
    Issues / TODOs
    --------------  
*/
public Class G2O_PrintSaveEmail_VFCx {
    
    //A.T.T.R.I.B.U.T.E.S
    public Id caseId;
    public Map<String,GenericURLHacking__c> cSettingMap = new Map<String,GenericURLHacking__c>();
    public PageReference pageRedirect;
    //A.T.T.R.I.B.U.T.E.S
    
    
    //C.O.N.S.T.R.U.C.T.O.R
    public G2O_PrintSaveEmail_VFCx (ApexPages.StandardController controller) {
        
        caseId = ApexPages.currentPage().getParameters().get('Id');       
        system.debug(Logginglevel.INFO,'+++caseId'+caseId);
        
        //Filtering the required Dataset from Custom Setting based on functionality.
        for(GenericURLHacking__c cSetting: UTIL_OrgSettings.GenericURLHacking()){
            if(cSetting.Feature_Name__c=='PrintSaveEmail'){
                cSettingMap.put(cSetting.Name,cSetting);
            }
        }
    }
    //C.O.N.S.T.R.U.C.T.O.R
    
    
    //1. Populates the field from the custtom setting & redirects the page.
    public PageReference redirect() {
        
        //Getting the Field Id & value from custom settings.
        String value;       //Holds field value.
        String valueId;     //Holds field Id.
        String retURL = '/_ui/core/email/author/EmailAuthor?';
        
        //Getting the caseId field.
        String casId = cSettingMap.get('Id').URL_Field_Id__c;
        retURL += casId+'='+caseId;
        
        //Setting fieldId & values from Custom Settings
        for(String keyValue:cSettingMap.KeySet()){
            if(keyValue!='Id'){
                value = cSettingMap.get(keyValue).Default_Value__c;
                if(value==null) value='';
                valueId = cSettingMap.get(keyValue).URL_Field_Id__c;
            }
            retURL += '&' +valueId + '=' + value;
        }
        
        retURL += '&retURL=/'+caseId;
        pageRedirect =  new PageReference(retURL); 
        pageRedirect.setRedirect(true);
                 
        return pageRedirect;
    }    
}