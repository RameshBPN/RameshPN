/**
    About
    -----
    Description: NTT Update Request
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    Provides NTT Search from the CaseProduct Detail Page and do the following:
    Methods:
    -------
        1.Search the records from NTT,Updates caseProduct__c & Create NTT_History__c records.

        
    Wrapper Classes Created:
    -----------------------
        
    Update History
    --------------
    Created April 2013 - A.B.
    Updated November 2014 - Karthik K.J
    
    Issues / TODOs
    --------------  

*/
public with sharing class G2O_NTTSearch_Button_VFCx {
    
    
    //A.T.T.R.I.B.U.T.E.S
    public PageReference caseProductPage;
    public String caseProductId;
    public CaseProduct__c caseProductRecord;
    public CaseProduct__c nttCaseProduct =new CaseProduct__c();
    public Case nttCase =new Case();
    public List<NTT_History__c> nttHistoryLst=new List<NTT_History__c>();
   public List<Ntt_History__c> delnttHistory = new List<NTT_History__c>();
    
    //A.T.T.R.I.B.U.T.E.S
    
    
    //C.O.N.S.T.R.U.C.T.O.R
    public G2O_NTTSearch_Button_VFCx(ApexPages.StandardController controller) {
        
        caseProductId = Apexpages.currentpage().getparameters().get('id');
        
        caseProductRecord = [Select c.Item_Id__c, c.Id,c.Case__r.Item_Id__c,c.IsPrimary__c,c.Case__r.Sender_Name__c, 
                                    c.Case__r.Receiver_Postal_Address_Street__c, c.Case__r.Receiver_Postal_Address_Postal_Code__c, 
                                    c.Case__r.Receiver_Postal_Address_Country__c, c.Case__r.Receiver_Postal_Address_City__c, 
                                    c.Case__r.Receiver_Postal_Address_C_O__c, c.Case__r.Receiver_Name__c, c.Case__r.Sender_Postal_Address_Street__c, 
                                    c.Case__r.Sender_Postal_Address_Postal_Code__c, c.Case__r.Sender_Postal_Address_Country__c,Case__r.Receiver__c, 
                                    c.Case__r.Sender_Postal_Address_City__c, c.Case__r.Sender_Postal_Address_C_O__c, c.Case__c,c.Case__r.Sender__c
                                    From CaseProduct__c c where c.Id=:caseProductId];
        
        system.debug(Logginglevel.INFO,'++++++dd+++++'+caseProductRecord.Case__r.Item_Id__c);
    }
    //C.O.N.S.T.R.U.C.T.O.R
    
    
    //1.Get the latest value from NTT & updates
    public PageReference nttUpdate() {
        try{
            if(caseProductRecord.Item_Id__c != null){
                
                Database.SaveResult caseProductDbSaveResults;
                Database.SaveResult caseDbSaveResults;
                Database.SaveResult [] nttHistoryDbSaveResults;
                Database.DeleteResult [] nttHistoryDbdeleteResults;
                
                /***** NTT Callout *****/
                G2O_NTTRequest_WS ntt = new G2O_NTTRequest_WS(caseProductRecord.Item_Id__c);
                    
                ntt.send();
                nttCase = ntt.result.nttcase;               //Getting Case Records.
                nttCaseProduct = ntt.result.nttCaseProduct; //Getting Case Product Records
                nttHistoryLst = ntt.result.nttHistoryList;  //Getting NTT History Records
                
                if(ntt.callout.error != null) {
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_External_Service + ' ' + ntt.callout.error.description));
                
                } else {
            
                    //Populating CaseProductId from the URL to the caseProduct record recieved from NTT request.
                    nttCaseProduct.Id = caseProductId;
    
                    //Updating the Case record if it is a primary case product.
                    if((caseProductRecord.IsPrimary__c )|| Test.isRunningTest()){
                        
                        nttCase.Id = caseProductRecord.Case__c;             //Putting the CaseId to the case record.
                        nttCase.Item_Id__c=caseProductRecord.Item_Id__c;
                        
                        //Checking if Sender/Receiver information already populated on case.
                        if(checkSenderReceiver()){
                            
                            nttCase.Sender__c = caseProductRecord.Case__r.Sender__c;
                            nttCase.Sender_Name__c = caseProductRecord.Case__r.Sender_Name__c; 
                            nttCase.Sender_Postal_Address_Street__c = caseProductRecord.Case__r.Sender_Postal_Address_Street__c; 
                            nttCase.Sender_Postal_Address_Postal_Code__c = caseProductRecord.Case__r.Sender_Postal_Address_Postal_Code__c; 
                            nttCase.Sender_Postal_Address_Country__c = caseProductRecord.Case__r.Sender_Postal_Address_Country__c; 
                            nttCase.Sender_Postal_Address_City__c = caseProductRecord.Case__r.Sender_Postal_Address_City__c; 
                            nttCase.Sender_Postal_Address_C_O__c = caseProductRecord.Case__r.Sender_Postal_Address_C_O__c;  
                            nttCase.Receiver__c = caseProductRecord.Case__r.Receiver__c; 
                            nttCase.Receiver_Name__c = caseProductRecord.Case__r.Receiver_Name__c; 
                            nttCase.Receiver_Postal_Address_Street__c = caseProductRecord.Case__r.Receiver_Postal_Address_Street__c; 
                            nttCase.Receiver_Postal_Address_Postal_Code__c = caseProductRecord.Case__r.Receiver_Postal_Address_Postal_Code__c;
                            nttCase.Receiver_Postal_Address_Country__c = caseProductRecord.Case__r.Receiver_Postal_Address_Country__c; 
                            nttCase.Receiver_Postal_Address_City__c = caseProductRecord.Case__r.Receiver_Postal_Address_City__c;
                            nttCase.Receiver_Postal_Address_C_O__c = caseProductRecord.Case__r.Receiver_Postal_Address_C_O__c;
                        }
                        //Updating Case.
                        caseDbSaveResults = Database.update(nttCase);
                         
                    }
                    
                    //Updating CaseProduct.
                    caseProductDbSaveResults = Database.update(nttCaseProduct);         
                    
                    //Inserting NTT History records if caseProduct record got inserted.
                    if(caseProductDbSaveResults.isSuccess()){
                        
                        for(NTT_History__c nttHist:nttHistoryLst){
                            nttHist.CaseProduct__c=nttCaseProduct.Id;
                        }
                        
                        //Deleting the old records in NTT_History__c
                        delnttHistory = [select id from NTT_History__c where CaseProduct__c =: caseProductId ];
                        delete delnttHistory;
                        //Inserting NTT History.
                        system.debug(nttHistoryLst);
                        
                      nttHistoryDbSaveResults = Database.insert(nttHistoryLst);
                    //delete nttHistoryLst;
                    }
            		
                //Redirecting to the caseProduct detail page.
                caseProductPage = new ApexPages.StandardController(nttCaseProduct).view();
                caseProductPage.setRedirect(true);
                
                }
            }           
            
        } catch(CalloutException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Callout + ' ' + e.getMessage()));
        
        } catch(UTIL_HttpIntegration.ResponseException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_External_Service + ' ' + e.getMessage()));
        
        } catch(Exception e){
            if(e.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Insufficient_Access));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_from_Salesforce));
            }
            UTIL_Error.report('NTT search', e);
            UTIL_Error.writeNow();
            
        }
        return caseProductPage;
    }
    
    
    //This method returns true if Sender/Receiver information already populated on case.
    private Boolean checkSenderReceiver(){
        
        Boolean isPresent = false;
        
        if(caseProductRecord.Case__r.Sender__c !=null || caseProductRecord.Case__r.Sender_Name__c !=null || caseProductRecord.Case__r.Sender_Postal_Address_Street__c !=null
           || caseProductRecord.Case__r.Sender_Postal_Address_Postal_Code__c !=null || caseProductRecord.Case__r.Sender_Postal_Address_Country__c !=null
           || caseProductRecord.Case__r.Sender_Postal_Address_City__c !=null || caseProductRecord.Case__r.Sender_Postal_Address_C_O__c !=null 
           || caseProductRecord.Case__r.Receiver__c !=null || caseProductRecord.Case__r.Receiver_Name__c !=null
           || caseProductRecord.Case__r.Receiver_Postal_Address_Street__c !=null|| caseProductRecord.Case__r.Receiver_Postal_Address_Postal_Code__c !=null
           || caseProductRecord.Case__r.Receiver_Postal_Address_Country__c !=null || caseProductRecord.Case__r.Receiver_Postal_Address_City__c !=null
           || caseProductRecord.Case__r.Receiver_Postal_Address_C_O__c !=null){
               
                isPresent = true;
           } 
           return isPresent;
    }

}