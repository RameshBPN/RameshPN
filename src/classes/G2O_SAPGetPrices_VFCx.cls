/**
        About
        -----
        Description: GetPrices from SAP.
        Created for: Postnord Get2OneCRM Master template/DK
        Create date: April 2013
        
        Details / Methods
        -----------------
        Detail Steps:
        -------------
        Provides SAPGetPrices do the following:
        Methods:
        -------
                1.Get the prices from SAP.
                
        Wrapper Classes Created:
        -----------------------
                
        Update History
        --------------
        Created May 2013 - A.B.
        
        Issues / TODOs
        -------------- 
*/
public with sharing class G2O_SAPGetPrices_VFCx {
    
    //A.T.T.R.I.B.U.T.E.S
    public String cpId;
    private String querystring;
    private String queryClause;
    public PageReference cpPage;
    public CaseProduct__c sapCaseProduct;
    public List<String> sapGetPricesLst =new List<String>();
    //A.T.T.R.I.B.U.T.E.S

    
   //C.O.N.S.T.R.U.C.T.O.R
    public G2O_SAPGetPrices_VFCx(ApexPages.StandardController controller) {
        
        cpId    = Apexpages.currentpage().getparameters().get('id');
        sapCaseProduct =new CaseProduct__c(Id=cpId);
    }
    //C.O.N.S.T.R.U.C.T.O.R
    
    
    //1. Get the prices from SAP.
    public PageReference getPrices() {
        System.debug(logginglevel.Info, '### START G2O_SAPGetPrices_VFCx.getPrices');
        
        try{
            
            Database.SaveResult cpDbSaveResults;
            
            /***** SAP Callout *****/
            G2O_SAPPriceCalculation_WS sapPriceCalc = new G2O_SAPPriceCalculation_WS(sapCaseProduct);
            sapPriceCalc.send(cpId);
            sapCaseProduct = sapPriceCalc.result;
            
            if(sapPriceCalc.callout.error != null) {
            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_External_Service + ' ' + sapPriceCalc.callout.error.description));
            
            } else {
                //Updating CaseProduct.
                cpDbSaveResults = Database.update(sapCaseProduct);      
            
                //Redirecting to the caseProduct detail page.
                cpPage = new ApexPages.StandardController(sapCaseProduct).view();
                cpPage.setRedirect(true);
            }
            
        } catch(CalloutException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Callout + ' ' + e.getMessage()));
        
        } catch(UTIL_HttpIntegration.MappingException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Field_Missing + ' ' + e.getMessage()));
        
        } catch (Exception e) {
            UTIL_Error.report('SAPGetPrices', e);
            UTIL_Error.writeNow();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
            
        }
        System.debug(logginglevel.Info, '### END G2O_SAPGetPrices_VFCx.getPrices');
        return cpPage;
        
    }
    
     public PageReference goBack() {
        cpPage = new ApexPages.StandardController(sapCaseProduct).view();
        cpPage.setRedirect(true);
        return cpPage;       
     }

}