/**
    About
    -----
    Description:Class for General CaseProduct__c Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
     1. Sets isPrimary field on caseproduct when a new caseproduct record is created based on filters.
     2. Sets isPrimary field on caseproduct when caseproduct record is updated based on filters.
     3. Sets the Product-Article on CaseProduct,if there is no further caseproduct for the case then update case with blank productArticle & ItemId value.
     4. Updates the case with the primary products,product-article field & ItemId when a primary caseproduct is updated.
     5. Updates the case with the primary products,product-article field & ItemId when a new primary caseproduct is created.
     6. This is called from Before Insert/Update Trigger,this Calculates Sum_of_Freight__c field on CaseProduct__c. 
     
    Update History
    --------------
    Created April 2013 - A.B.
    Updated July  2013 - A.B.-Refactored
    
    --------------  
*/
public with sharing class G2O_CaseProduct_SVC {
    
    //1. This is called from Before Insert Trigger,this sets the isPrimary field to false for an existing 
    //   primary caseproduct,If an another case product is inserted with isPrimary as true. 
    //   Also If no caseproduct record exists on the case then it makes it the primary caseproduct.
    public static void setPrimaryProductBeforeInsert(List<CaseProduct__c> newCaseProduct){
        
        System.debug(LoggingLevel.info,'*** START: <CaseProduct_SVC>.<setPrimaryProductBeforeInsert>');
        
        try{
            set<Id> caseIdSet =new set<Id>();
            set<Id> caseIdReviewedSet  =new set<Id>();
            List<CaseProduct__c> caseProductOldLst =new List<CaseProduct__c>();
            
            Map<Id,List<CaseProduct__c>> caseIdToCaseProductsMap =new Map<Id,List<CaseProduct__c>>();   //Holds caseId to list of all CaseProduct mapping.
            Map<Id,CaseProduct__c> caseIdToNewPrimaryCaseProductMap =new Map<Id,CaseProduct__c>();      //Holds caseId to primary caseProduct mapping.
            Map<Id,CaseProduct__c> caseIdToOldPrimaryCaseProductMap =new Map<Id,CaseProduct__c>();      //Holds caseId to old primary caseProduct mapping.
            system.debug(Logginglevel.INFO,'+newCaseProduct+++'+newCaseProduct);
            
            for(CaseProduct__c caseProduct:newCaseProduct){
                caseIdSet.add(caseProduct.Case__c);
                
                if(caseIdToCaseProductsMap.containsKey(caseProduct.Case__c)){
                    caseIdToCaseProductsMap.get(caseProduct.Case__c).add(caseProduct);
                }else{
                    caseIdToCaseProductsMap.put(caseProduct.Case__c,new List<CaseProduct__c> {caseProduct});
                }
                
                
                //Checking if the caseProduct is primary or not.
                if(caseProduct.isPrimary__c){
                    system.debug(Logginglevel.INFO,'++++isPrimary__c++'+caseProduct.isPrimary__c);
                    if(!caseIdToNewPrimaryCaseProductMap.containsKey(caseProduct.Case__c)){
                        caseIdToNewPrimaryCaseProductMap.put(caseProduct.Case__c,caseProduct);  //Getting the caseId to a primary New case product Map.
                    }
                }
            }
            
            system.debug(Logginglevel.INFO,'++++caseIdToCaseProductsMap+++'+caseIdToCaseProductsMap);
            
            //Getting primary CaseProducts related to caseIds already present in the system.
            for(CaseProduct__c casPro:[Select c.Id,c.Item_Id__c,c.isPrimary__c, c.Case__c From CaseProduct__c c where c.Case__c IN:caseIdSet AND isPrimary__c=true]){
                
                system.debug(Logginglevel.INFO,'+++casPro+++'+casPro.Item_Id__c);
                system.debug(Logginglevel.INFO,'+++casPro+++'+casPro.isPrimary__c);
                
                if(!caseIdToOldPrimaryCaseProductMap.containsKey(casPro.Case__c)){
                    caseIdToOldPrimaryCaseProductMap.put(casPro.Case__c,casPro);
                }
            }
            
            system.debug(Logginglevel.INFO,'++++caseIdToOldPrimaryCaseProductMap+++'+caseIdToOldPrimaryCaseProductMap);
            
            for(CaseProduct__c casePro:newCaseProduct){
                CaseProduct__c oldCasePro =new CaseProduct__c();
                List<CaseProduct__c> newCaseProLst = new List<CaseProduct__c>();
                CaseProduct__c newCasePro = new CaseProduct__c();                               //Hard Insert:if there is existing primary case product record & new primary case product for the same case.
                if(caseIdToOldPrimaryCaseProductMap.containsKey(casePro.Case__c) && caseIdToNewPrimaryCaseProductMap.containsKey(casePro.Case__c) && (casePro.isPrimary__c)){
                    system.debug(Logginglevel.INFO,'++++INSIDE INTO++');
                    if(!caseIdReviewedSet.contains(casePro.Case__c)){                           
                        oldCasePro=caseIdToOldPrimaryCaseProductMap.get(casePro.Case__c);
                        oldCasePro.isPrimary__c=false;
                        caseProductOldLst.add(oldCasePro);
                        caseIdReviewedSet.add(casePro.Case__c);                                 //This set prevents duplicate isprimary case product.
                        casePro.isPrimary__c=true;                                              //Setting the new caseProduct as primary & old as secondary.
                    }else{
                        casePro.isPrimary__c=false;
                    }
                }else if(!caseIdToOldPrimaryCaseProductMap.containsKey(casePro.Case__c) && caseIdToNewPrimaryCaseProductMap.containsKey(casePro.Case__c) && (casePro.isPrimary__c)){    //Condition: if there is no existing primary case product record & new record with isprimary is inserted.
                    system.debug(Logginglevel.INFO,'++++INSIDE INTO RIP++');
                    casePro.isPrimary__c=true;
                }else if(!caseIdToOldPrimaryCaseProductMap.containsKey(casePro.Case__c) && (!casePro.isPrimary__c)){        //Getting created for the first time,No Primary product present
                    system.debug(Logginglevel.INFO,'++Inside Here6++');
                    newCasePro=caseIdToCaseProductsMap.get(casePro.Case__c)[0];             //Condition: if there is no existing primary case product record &  no isprimary set for caseproduct of the case,assigning the first from the list as isprimary.
                    newCasePro.isPrimary__c=true;
                }
            }
            system.debug(Logginglevel.INFO,'++Inside Here newCaseProduct++'+newCaseProduct);
            
            if(caseProductOldLst.size()>0){
                system.debug(Logginglevel.INFO,'++++caseProduct232OldLst+++'+caseProductOldLst);
                update caseProductOldLst;
            }
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <CaseProduct_SVC>.<setPrimaryProductBeforeInsert>');
    }
    
    
    //2. This is called from Before Update Trigger,this sets the isPrimary field to false for an existing primary caseproduct 
    //   if an another caseproduct related to same case is updated with isPrimary set as true.
    public static void setPrimaryProductBeforeUpdate(Set<CaseProduct__c> newCaseProduct,Map<Id,CaseProduct__c> oldCaseProductMap){
        
        System.debug(LoggingLevel.info,'*** START: <CaseProduct_SVC>.<setPrimaryProductBeforeUpdate>');
        system.debug(Logginglevel.INFO,'FLAG:+++++7setArticle_BU INSIDE+++++'+G2O_Case_SVC.setArticle);
        system.debug(Logginglevel.INFO,'FLAG:+++++7createCP_BU INSIDE+++++'+G2O_Case_SVC.createCP);
        
        try{
            set<Id> caseIdSet =new set<Id>();
            set<Id> caseProductIdSet =new set<Id>();
            Map<Id,CaseProduct__c> caseIdToPrimaryOldCaseProductMap =new Map<Id,CaseProduct__c> ();
            List<CaseProduct__c> caseProductOldLst =new List<CaseProduct__c>();     //Holds caseproduct records that are set as isPrimary=false coz a new caseproduct related to same case is set as isprimary.
            
            for(CaseProduct__c caseProduct:newCaseProduct){
                
                if(caseProduct.IsPrimary__c && !oldCaseProductMap.get(caseProduct.Id).IsPrimary__c){    //New record not equal to old.
                    caseIdSet.add(caseProduct.case__c);                                                 //CaseId of the records getting updated as primary.
                    caseProductIdSet.add(caseProduct.Id);                                               //Caseproduct Id set that are set as primary product
                    system.debug(Logginglevel.INFO,'++++Inside Here++'+caseIdSet);
                }
                if(oldCaseProductMap.get(caseProduct.Id).IsPrimary__c && !caseProduct.IsPrimary__c){    //Getting those records that are updated from primary to secondary case products.
                    caseIdToPrimaryOldCaseProductMap.put(caseProduct.case__c,caseProduct);
                }
            }
    
            //Getting the existing Case Products related to caseId that are set true to check if there is exisiting primary product related to same case,thus updating the existing case as false.
            for(CaseProduct__c casProd:[Select c.Id,c.Item_Id__c,c.isPrimary__c, c.Case__c From CaseProduct__c c where c.Case__c IN:caseIdSet and c.isPrimary__c=true]){
    
                if(!caseIdToPrimaryOldCaseProductMap.containsKey(casProd.Case__c) && !caseProductIdSet.contains(casProd.Id)){
                    casProd.IsPrimary__c=false;
                    caseProductOldLst.add(casProd);
                    system.debug(Logginglevel.INFO,'++++caseProductOldLst2++'+caseProductOldLst);
                }
            }
            if(!caseProductOldLst.isEmpty())
            update caseProductOldLst;
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <CaseProduct_SVC>.<setPrimaryProductBeforeUpdate>');
    }
    
    
    //3. This is called from Before Delete Trigger,this sets the Product-Article on CaseProduct.
    //   Also if there is no further caseproduct for the case then update case with blank productArticle & ItemId value. 
    public static void setPrimaryProductBeforeDelete (List<CaseProduct__c> oldCaseProduct){
        
        System.debug(LoggingLevel.info,'*** START: <CaseProduct_SVC>.<setPrimaryProductBeforeDelete>');
        
        system.debug(Logginglevel.INFO,'FLAG:+++++8setArticle_BU INSIDE+++++'+G2O_Case_SVC.setArticle);
        system.debug(Logginglevel.INFO,'FLAG:+++++8createCP_BU INSIDE+++++'+G2O_Case_SVC.createCP);
        try{
            set<Id> caseIdSet =new set<Id>();
            set<Id> caseWithNoCaseProductSet = new set<Id>();               //Holds CaseId that need to be updated with null Product/Article
         
            Map<Id,CaseProduct__c> caseIdToCaseProductMap =new Map<Id,CaseProduct__c> ();
            
            List<Case> casesToUpdateLst = new List<Case>();
            List<CaseProduct__c> caseProductLst =new List<CaseProduct__c>();
            
            for(CaseProduct__c casPro:oldCaseProduct){
                caseIdSet.add(casPro.case__c);
                
            }
            
            //Getting records for the caseId from CaseProduct__c which are not primary.
            for(CaseProduct__c casProd:[Select c.Id,c.Item_Id__c,c.isPrimary__c,c.Case__r.Product_Article__c, c.Case__c From CaseProduct__c c where c.Case__c IN:caseIdSet AND c.isPrimary__c!=true]){
                if(!caseIdToCaseProductMap.containsKey(casProd.Case__c)){
                    caseIdToCaseProductMap.put(casProd.Case__c,casProd);
                }
            }
            
            for(Id caseId:caseIdSet){
                if(caseIdToCaseProductMap.containsKey(caseId)){
                    CaseProduct__c casProduct =caseIdToCaseProductMap.get(caseId);
                    casProduct.IsPrimary__c=true;
                    caseProductLst.add(casProduct);
                }else{
                    caseWithNoCaseProductSet.add(caseId);   //CaseId with no caseProducts.
                }
            }
            system.debug(Logginglevel.INFO,'++++caseProductLst+++++'+caseProductLst);
            if(!caseProductLst.isEmpty())
            update caseProductLst;
            
            //updating Case with blank values if no related CaseProduct__c is left.
            for(Case caseRec:[Select c.Item_Id__c,c.Product_Article__c, c.Id From Case c where c.Id IN:caseWithNoCaseProductSet]){
                caseRec.Item_Id__c=null;
                caseRec.Alternate_Item_Id__c=null;
                caseRec.Sender__c=null;
                caseRec.Sender_Name__c=null;
                caseRec.Sender_Postal_Address_C_O__c=null;
                caseRec.Sender_Postal_Address_Street__c=null;
                caseRec.Sender_Postal_Address_Postal_Code__c=null;
                caseRec.Sender_Postal_Address_City__c=null;
                caseRec.Sender_Postal_Address_Country__c=null;
                caseRec.Sender_Contact_Telephone__c=null;
                caseRec.Sender_Contact_Name__c=null;
                caseRec.Sender_Contact_email__c=null;
                caseRec.Sender_Contact_Mobile__c=null;
                caseRec.Receiver_Name__c=null;
                caseRec.Receiver_Postal_Address_C_O__c=null;
                caseRec.Receiver_Postal_Address_Street__c=null;
                caseRec.Receiver_Postal_Address_Postal_Code__c=null;
                caseRec.Receiver_Postal_Address_City__c=null;
                caseRec.Receiver_Postal_Address_Country__c=null;
                caseRec.CN08_Priority__c=null;
                caseRec.Retailer__c=null;
                caseRec.Receiver_Contact_Telephone__c=null;
                caseRec.Receiver_Contact_Mobile__c=null;
                caseRec.Receiver_contact_email__c=null;
                caseRec.COD_Amount__c=null;
                caseRec.Value__c=null;
                caseRec.Account_Number__c=null;
                caseRec.Account_Type__c=null;
                caseRec.Product_Article__c=null;
                
                casesToUpdateLst.add(caseRec);
            }
            if(!casesToUpdateLst.isEmpty())
            update casesToUpdateLst;            //Updating cases with blank Product/Article field.
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <CaseProduct_SVC>.<setPrimaryProductBeforeDelete>');
    }
    
    
    //4. This is called from After Update Trigger,this updates the case with the primary products,product-article field & ItemId.
    public static void setCaseArticleAfterUpdate(List<CaseProduct__c> newCaseProduct){
        
        System.debug(LoggingLevel.info,'*** START: <CaseProduct_SVC>.<setCaseArticleAfterUpdate>');
        
        system.debug(Logginglevel.INFO,'FLAG:+++++9setArticle_BU INSIDE+++++'+G2O_Case_SVC.setArticle);
        system.debug(Logginglevel.INFO,'FLAG:+++++9createCP_BU INSIDE+++++'+G2O_Case_SVC.createCP);
        
        try{
            if(!G2O_Case_SVC.setArticle){
                Map<Id,CaseProduct__c> caseIdToCustomerServiceProductMap =new Map<Id,CaseProduct__c> ();
                List<Case> caseLst =new List<Case>();
                
                for(CaseProduct__c caseProduct:newCaseProduct){
                    
                    caseIdToCustomerServiceProductMap.put(caseProduct.Case__c,caseProduct);
                    
                }
                
                system.debug(Logginglevel.INFO,'++++caseIdToCustomerServiceProductMap.keySet()++'+caseIdToCustomerServiceProductMap.keySet());
                //Getting the case for the filtered caseIds & updating the Customer_Service_Product__c & Item_Id__c from caseProduct.
                for(Case cas:[Select c.Product_Article__c,c.Item_Id__c, c.Id From Case c where c.Id IN:caseIdToCustomerServiceProductMap.keySet()]){
                    system.debug(Logginglevel.INFO,'+++++++cas++++'+cas);
                    cas.Product_Article__c=caseIdToCustomerServiceProductMap.get(cas.Id).Customer_Service_Product__c;
                    cas.Item_Id__c=caseIdToCustomerServiceProductMap.get(cas.Id).Item_Id__c;
                    caseLst.add(cas);
                }
                if(!caseLst.isEmpty())
                update caseLst;
            }
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <CaseProduct_SVC>.<setCaseArticleAfterUpdate>');
    }
    
    //5. This is called from After Insert Trigger,this updates the case with the primary products,product-article field & ItemId.
    public static void setCaseArticleAfterInsert(List<CaseProduct__c> newCaseProduct){
        
        System.debug(LoggingLevel.info,'*** START: <CaseProduct_SVC>.<setCaseArticleAfterInsert>');
        try{
            system.debug(Logginglevel.INFO,'+++++++G2O_Case_SVC.setArticle++++'+G2O_Case_SVC.setArticle);
            if(!G2O_Case_SVC.setArticle){
                
                G2O_Case_SVC.createCP = true;   //This prevents creation of caseproduct again,use case: when case is updated with the  itemId or product article for the first time.
                
                Map<Id,CaseProduct__c> caseIdToCustomerServiceProductMap =new Map<Id,CaseProduct__c> ();
                List<Case> caseLst =new List<Case>();
                
                for(CaseProduct__c caseProduct:newCaseProduct){
                    //Checking if caseProduct is primary.
                    caseIdToCustomerServiceProductMap.put(caseProduct.Case__c,caseProduct);
                    
                }
                system.debug(Logginglevel.INFO,'+++++++caseIdToCustomerServiceProductMap.keySet()++++'+caseIdToCustomerServiceProductMap.keySet());
                //Getting the case records for the filtered caseIds.
                for(Case cas:[Select c.Product_Article__c, c.Id From Case c where c.Id IN:caseIdToCustomerServiceProductMap.keySet()]){
                    system.debug(Logginglevel.INFO,'+++++++cas++++'+cas);
                    cas.Product_Article__c=caseIdToCustomerServiceProductMap.get(cas.Id).Customer_Service_Product__c;
                    cas.Item_Id__c=caseIdToCustomerServiceProductMap.get(cas.Id).Item_Id__c;
                    caseLst.add(cas);
                }
                
                system.debug(Logginglevel.INFO,'+++caseLst+++'+caseLst);
                if(!caseLst.isEmpty())
                update caseLst;
            }
        }catch(Exception e){
            system.debug(Logginglevel.INFO,'++++++EXCEPTION+++++'+e);
        }
        System.debug(LoggingLevel.info,'*** END: <CaseProduct_SVC>.<setCaseArticleAfterInsert>');
    }
    
    //6. This is called from Before Insert/Update Trigger,this populates Sum_of_Freight__c field.
    public static void set_SumOfFreight(Set<CaseProduct__c> newCaseProduct){
        
        System.debug(LoggingLevel.info,'*** START: <CaseProduct_SVC>.<set_SumOfFreight>');

        Map<String,SAPGetPrices__c> sapGetPricesMap= UTIL_OrgSettings.SAPGetPrices();   //Getting Label to API names mapping from custom setting.
            
        for(CaseProduct__c cp:newCaseProduct){
            
            sObject cPsObject = cp;
            Decimal sumOfFreight=0;
            List<String> pickValLst = new List<String>();           //Holds selected picklist values of Include_prices__c field.
            
            if(!UTIL_Apex.empty(cp.Include_prices__c)){
                pickValLst = cp.Include_prices__c.split(';');       //Fields selected in Multiselect picklist Include_prices__c.
            } else {
                cPsObject.put('Sum_of_Freight__c',null);
            }

            //Populating Sum_of_Freight__c fields value by adding the values.
            for(String pickVal:pickValLst){
                
                if(sapGetPricesMap.containsKey(pickVal)){
                    if(cPsObject.get((sapGetPricesMap.get(pickVal).Include_Prices_PickVal__c))!=null){
                         sumOfFreight = sumOfFreight + (Decimal)cPsObject.get((sapGetPricesMap.get(pickVal).Include_Prices_PickVal__c));
                    }
                }
            }
            if(sumOfFreight!=0){
                cPsObject.put('Sum_of_Freight__c',sumOfFreight);
            }else{
                cPsObject.put('Sum_of_Freight__c',null);
            }
        }
        System.debug(LoggingLevel.info,'*** END: <CaseProduct_SVC>.<set_SumOfFreight>');
    }
    
}