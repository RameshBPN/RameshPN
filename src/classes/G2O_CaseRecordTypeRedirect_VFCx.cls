/**
    About
    -----
    Description: Case RecordType Redirection
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    Redirects to a VF Page on creation of Case of type Item Search:
    
    Methods:
    -------
        1.Checks for the record type,set the url parameters & redirect it to NTTSearch page
            
    Wrapper Classes Created:
    -----------------------
        
    Update History
    --------------
    Created April 2013 - A.B.
    
    Issues / TODOs
    --------------  
*/

public with sharing class G2O_CaseRecordTypeRedirect_VFCx {
    
    //A.T.T.R.I.B.U.T.E.S
    private ApexPages.StandardController controller;
    public PageReference returnURL;
    public Map<String,String> param;
    public String retURL;
    public String rType;
    public String rTypeName;
    //A.T.T.R.I.B.U.T.E.S
    
    //C.O.N.S.T.R.U.C.T.O.R
    public G2O_CaseRecordTypeRedirect_VFCx(ApexPages.StandardController controller) {
        
        this.controller = controller;
        param = ApexPages.currentPage().getParameters();
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        rType = ApexPages.currentPage().getParameters().get('RecordType');
        
        system.debug(Logginglevel.INFO,'++++param+++'+param);
        system.debug(Logginglevel.INFO,'++++retURL+++'+retURL);
        system.debug(Logginglevel.INFO,'++++rType+++'+rType);

    }
    //C.O.N.S.T.R.U.C.T.O.R
    
    //1.Checks for the record type,set the url parameters & redirect it to NTTSearch page 
    public PageReference redirect() {
        
        if (recordTypeCheck()){                                 //Checking for valid recordType.           
            returnURL = Page.G2O_NTTSearch;
        }else{
            returnURL =  new PageReference('/500/e');
        }
        
        for (String p : param.keySet()){
             if (p!='save_new' && p!='sfdc.override'){
              returnURL.getParameters().put(p,param.get(p));    //Putting different URL parameters.
             }
        }
        returnURL.getParameters().put('nooverride','1');
        returnURL.setRedirect(true);  
        
        system.debug(Logginglevel.INFO,'+++++1returnURL1+++'+returnURL.getUrl());
        return returnURL;
    }
    
    
    //Checks recordType.
    private boolean recordTypeCheck(){
        
        String developerName = UTIL_OrgSettings.NTTSearchRecordTypes();
        Boolean isValid =false;
        if(UTIL_Apex.empty(rType)) {
			//find all Case record types
			List<Schema.RecordTypeInfo> rtis = Schema.SObjectType.Case.RecordTypeInfos;
			Id defaultRecordTypeId;
			
			//Find the users default record type
			for(Schema.RecordTypeInfo rti : rtis) {
				if(rti.DefaultRecordTypeMapping) {
					rType = rti.RecordTypeId;
				}
			}
		}
        if(!UTIL_Apex.empty(rType)){
            rTypeName=[Select r.Name, r.Id, r.DeveloperName From RecordType r where r.Id=:rType].DeveloperName; //Developer Name of the selected recordType.

            List<String> rTypLst = developerName.split(',');                                                    //Valid Developer Name from Custom Settings.
            
            for(String devName:rTypLst){
                if(rTypeName.equalsIgnoreCase(devName)){
                    isValid=true;
                    break;
                }
            }
        }
        return isValid;
    }
        
}