/**
        About
        -----
        Description: NTT Search
        Created for: Postnord Get2OneCRM Master template/DK
        Create date: April 2013
        
        Details / Methods
        -----------------
        Detail Steps:
        -------------
        Provides NTT Search and do the following:
        Methods:
        -------
                1.Search the records from NTT.
                2.Create new case,caseProduct__c & NTT_History__c record.
                3.Creates new caseProduct__c & NTT_History__c for the existing Case.
                
        Wrapper Classes Created:
        -----------------------
                
        Update History
        --------------
        Created April 2013 - A.B.
        
        Issues / TODOs
        --------------  
*/
public with sharing class G2O_NTTSearch_VFCx {
    
            
    //A.T.T.R.I.B.U.T.E.S
    public String itemId{get;set;}
    
    //public static boolean notIsDirty=false;
    
    public Id rType;
    public Id parentCaseId;
    public Id caseId {get;set;}
    
    public CaseProduct__c nttCaseProduct{get;set;}
    public CaseProduct__c objCaseProd{get;set;}
    public Case nttCase;
    
    public Boolean bolSrchHdr{get;set;}
    public Boolean bolHstryHdr{get;set;}
    public Boolean bolSP{get;set;}
    public Boolean bolFP{get;set;}
    
    public List<NTT_History__c> nttHistoryLst {get;set;}
    //A.T.T.R.I.B.U.T.E.S
        
        
   //C.O.N.S.T.R.U.C.T.O.R
    public G2O_NTTSearch_VFCx (ApexPages.StandardSetController controller) {
        
        bolSP                                   = true;
        bolFP                                   = false;
        rType                                   = ApexPages.currentPage().getParameters().get('RecordType');
        caseId                                  = ApexPages.currentPage().getParameters().get('id');
        parentCaseId                            = ApexPages.currentPage().getParameters().get('def_parent_id');
            
        nttCase =new Case();
        nttCaseProduct =new CaseProduct__c();
        nttHistoryLst =new List<NTT_History__c>();
    }
    //C.O.N.S.T.R.U.C.T.O.R       


    //1.Search the records from NTT by sending an NTT call out.
    public PageReference doItemSearch() {
            
        bolSP        = false;
        bolFP        = true;
            
        /***** NTT Callout *****/
        try{
            G2O_NTTRequest_WS ntt = new G2O_NTTRequest_WS(itemId);
            ntt.send();
            
            //Getting Case Records
            nttCase=ntt.result.nttcase;
        
            //Getting NTT History Records
            nttHistoryLst=ntt.result.nttHistoryList;

            //Getting Case Product Records
            nttCaseProduct=ntt.result.nttCaseProduct;
            
            if(ntt.callout.error != null) {
            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_External_Service + ' ' + ntt.callout.error.description));
            	
            	// Add item id if the call fails so the user can save the case for later use
           		nttCase.Item_Id__c = itemId;
            	nttCaseProduct.Item_Id__c = itemId;
            } 
            
        } catch(CalloutException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Callout + ' ' + e.getMessage()));
        	
        	// Add item id if the call fails so the user can save the case for later use
           	nttCase.Item_Id__c = itemId;
            nttCaseProduct.Item_Id__c = itemId;
        
        } catch(UTIL_HttpIntegration.ResponseException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_External_Service + ' ' + e.getMessage()));
        	
        	// Add item id if the call fails so the user can save the case for later use
           	nttCase.Item_Id__c = itemId;
           	nttCaseProduct.Item_Id__c = itemId;
        
        } catch(Exception e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
            UTIL_Error.report('NTT search', e);
            UTIL_Error.writeNow();
            
            // Add item id if the call fails so the user can save the case for later use
           	nttCase.Item_Id__c = itemId;
            nttCaseProduct.Item_Id__c = itemId;
            
        }
        return null;
    }
        
        
    //2.Create New case,caseProduct__c & NTT_History__c
    public PageReference createCase() {
                
        PageReference casePage;
        Database.SaveResult caseProductDbSaveResults;
        Database.SaveResult caseDbSaveResults;
        Database.SaveResult [] nttHistoryDbSaveResults;
        try{
            
            
            //Creating Case
            if(rType == null){
                rType = UTIL_Meta.getCaseItemSearchRT();
            }
            nttCase.RecordTypeId = rType;
            nttCase.ParentId = parentCaseId;
            caseDbSaveResults = Database.insert(nttCase);

            //Creating Case Products
            if(caseDbSaveResults.isSuccess()){
                    //notIsDirty=true;
                    nttCaseProduct.Case__c=nttCase.Id;
                    caseProductDbSaveResults = Database.insert(nttCaseProduct);
            }
                        
            //Creating NTT History
            if(caseProductDbSaveResults.isSuccess()){
                    for(NTT_History__c nttHist:nttHistoryLst){
                            nttHist.CaseProduct__c=nttCaseProduct.Id;
                    }
                    nttHistoryDbSaveResults = Database.insert(nttHistoryLst);
                    
                    //Redirecting to the standard case detail page.
                    casePage = new ApexPages.StandardController(nttCase).view();
                    casePage.setRedirect(true);
            }
        }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
                UTIL_Error.report('Create case', e);
            	UTIL_Error.writeNow();
        }
        return casePage;
    }       
        
    //3.Creates new caseProduct__c & NTT_History__c for the existing Case.
    public PageReference updateCase() {
        G2O_Case_SVC.createCP = true;   //Setting the Flag so that no caseproduct is created due to triggers.
                
        PageReference casePage;
        Database.SaveResult caseProductDbSaveResults;
        Database.SaveResult [] nttHistoryDbSaveResults;
        try{

            system.debug('+++9nttCase+++'+nttCase);
            system.debug('+++NTTCaseItemId+++'+nttCase.Item_Id__c);
            system.debug('+++NTTCase+++'+nttCase.Sender_Name__c);
            system.debug('+++caseId+++'+caseId);
  
            //Creating Case Products.
            if(caseId != null) {
            	
            	//Update Case only if the CaseProduct is primary(If No existing CaseProduct present for the Case.)
            	List<CaseProduct__c> primaryCP = [Select c.IsPrimary__c, c.Id, c.Case__c From CaseProduct__c c WHERE c.Case__c =:caseId AND c.IsPrimary__c =true Limit 1];
                
                if(primaryCP.isEmpty()){
	                nttCase.Id = caseId;
                	update nttCase;
                }
                nttCaseProduct.Case__c = caseId;
            }
            
            //Inserting caseproduct.
            caseProductDbSaveResults = Database.insert(nttCaseProduct);
            
            system.debug(Logginglevel.INFO,'++++caseProductDbSaveResults+++'+caseProductDbSaveResults);
                        
            //Creating NTT History if caseproduct is inserted.
            if(caseProductDbSaveResults.isSuccess()){
                    for(NTT_History__c nttHist:nttHistoryLst){
                            nttHist.CaseProduct__c=nttCaseProduct.Id;
                    }
                    //Inserting NTT History.
                    nttHistoryDbSaveResults = Database.insert(nttHistoryLst);
                    
                    //Redirecting to the standard case detail page.
                    casePage = new ApexPages.StandardController(nttCase).view();
                    casePage.setRedirect(true);
            }
        }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
                nttCase.id = null;
                UTIL_Error.report('Update case', e);
            	UTIL_Error.writeNow();
        }
        return casePage;
    }  
}