/**
    About
    -----
    Description:Class for General Product2 Triggers
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
     1. Copy records from Product2 to Customer_Service_Product__c when new Product2 records are created.
     2. Copy records from Product2 to Customer_Service_Product__c when a  Product2 record is update.
     3. Delete records from Customer_Service_Product__c when a record from  Product2 is deleted.
     
    Update History
    --------------
    Created April 2013 - A.B.
    
    Issues / TODOs
    --------------
*/
public with sharing class G2O_Product_SVC {
    
    //1.Copy records from Product2 to Customer_Service_Product__c when new Product2 records are created.
    public static void copyProductBeforeInsert(List<Product2> newProducts, Map<Id, Product2> newProductMap){
        
        try{
            //Getting field mapping between Customer_Service_Product__c & Product2 Object from CustomSetting.
            List<CustomerServiceProductMapping__c> cSProdMappingLst= UTIL_OrgSettings.CustomerServiceProductMapping();
            List<sObject> cSLst = new List<sObject>();
        	
        	system.debug('++cSProdMappingLst++'+cSProdMappingLst);
        	
            for(Product2 newProduct:newProducts){
                sObject cSProduct =  Customer_Service_Product__c.SObjectType.newSObject();
                
                //Populating the respective fields values as per the mapping fromProduct2 to Customer_Service_Product__c.
                for(CustomerServiceProductMapping__c cSMapping:cSProdMappingLst){
                    cSProduct.put(cSMapping.Name,newProduct.get(cSMapping.Product2Field__c));
                }
                if(cSProduct!=null)
                cSLst.add(cSProduct);
            }
            system.debug('+++cSLst+++'+cSLst);
            if(!cSLst.isEmpty())
            insert cSLst;

        }catch(Exception e){
			UTIL_Error.report('Handled Exception',' An error occured when trying to copy Product on insert. Error is: ' + e,'G2O_Product_SVC');                 
			UTIL_Error.writeNow();      
            system.debug(Logginglevel.INFO,'+++EXCEPTION+++'+e);
        }
        
    }
    
    
    //2.Copy records from Product2 to Customer_Service_Product__c when a  Product2 record is update.
    public static void copyProductBeforeUpdate(List<Product2> newProducts, Map<Id, Product2> oldProductMap){
        
        try{
        	
            //Getting field mapping between Customer_Service_Product__c & Product2 Object from CustomSetting.
            List<CustomerServiceProductMapping__c> cSProdMappingLst= UTIL_OrgSettings.CustomerServiceProductMapping();
            
            List<sObject> cSLst = new List<sObject>();
            
            Map<String, Product2> globalIdToProductMap = new Map<String, Product2>();
            Map<String, Customer_Service_Product__c> globalIdToCsMap = new Map<String, Customer_Service_Product__c>();
            
            //Creating a map of Global_ID__c & product2 records.
            for(Product2 newprod:newProducts){
                globalIdToProductMap.put(newprod.Global_ID__c,newprod);
            }
            
            //Getting the related Customer_Service_Product__c records based on Global_ID__c field.
            for(Customer_Service_Product__c cSProd:[Select c.Id,c.Global_ID__c From Customer_Service_Product__c c where c.Global_ID__c IN:globalIdToProductMap.keySet()]){
                
                if(!UTIL_Apex.empty(cSProd.Global_ID__c)){
                    globalIdToCsMap.put(cSProd.Global_ID__c,cSProd);
                }
            }
            
            system.debug(Logginglevel.INFO,'+++globalIdToCsMap+++'+globalIdToCsMap);
            
            for(Product2 prod:newProducts){
                
                sObject cSProduct    = Customer_Service_Product__c.SObjectType.newSObject();
                sObject newprod      = (sObject)prod;
                sObject oldprod      = (sObject)oldProductMap.get(prod.Id);
                sObject cSProductRec;
                
                //Checking if any update happened.
                if(isProductUpdated(newprod,oldprod,cSProdMappingLst)){
                    
                    if(globalIdToCsMap.containsKey(prod.Global_ID__c)){
                        cSProductRec = (sObject)globalIdToCsMap.get(prod.Global_ID__c); //Getting the customer Service Product present in the System for the globalId.
                    }
                    //Populating the respective fields values as per the mapping from Product2 to Customer_Service_Product__c.
                    for(CustomerServiceProductMapping__c cSMapping:cSProdMappingLst){
                            cSProduct.put(cSMapping.Name,prod.get(cSMapping.Product2Field__c));
                    }
                    system.debug(Logginglevel.INFO,'+++test+++'+cSProductRec);
                    if(cSProductRec!=null)
                    cSProduct.put('id',cSProductRec.id);
                    
                    if(cSProduct!=null && cSProductRec!=null)
                    cSLst.add(cSProduct);
                }
            }
            system.debug(Logginglevel.INFO,'+++++cSLst++'+cSLst);
            if(!cSLst.isEmpty())
            update cSLst;
            
        }catch(Exception e){
        	UTIL_Error.report('Handled Exception',' An error occured when trying to copy Product on update. Error is: ' + e,'G2O_Product_SVC');                 
			UTIL_Error.writeNow();      
            system.debug(Logginglevel.INFO,'+++EXCEPTION+++'+e);
        }
    }
    
    //3.Delete records from Customer_Service_Product__c when a record from  Product2 is deleted.
    public static void deleteCustomerService(List<Product2> oldProducts){
        
        try{
            set<String> globalIdSet = new set<String>();
            List<Customer_Service_Product__c> cSLst = new List<Customer_Service_Product__c>();
            
            //Getting the Global_ID__c that got deleted.
            for(Product2 oldProd:oldProducts){
                if(!UTIL_Apex.empty(oldProd.Global_ID__c)){
                    globalIdSet.add(oldProd.Global_ID__c);
                }
            }
            
            //Getting the related Customer_Service_Product__c records based on Global_ID__c.
            cSLst=[Select c.Id From Customer_Service_Product__c c where c.Global_ID__c IN:globalIdSet];
            system.debug(Logginglevel.INFO,'+++++cSLst++++'+cSLst.size());
            
            if(!cSLst.isEmpty())
            delete cSLst;
            
        }catch(Exception e){
			UTIL_Error.report('Handled Exception',' An error occured when trying to delete product. Error is: ' + e,'G2O_Product_SVC');                 
			UTIL_Error.writeNow();      
            system.debug(Logginglevel.INFO,'+++EXCEPTION+++'+e);
        }
    }
    
    //Identifies if any of the Product field is changed.
    private static Boolean isProductUpdated(sObject newprod, sObject oldprod,List<CustomerServiceProductMapping__c> cSProdMappingLst){
        
        boolean bolIsUpdated = false;
        
        for(CustomerServiceProductMapping__c cSMapping:cSProdMappingLst){
            if(newprod.get(cSMapping.Product2Field__c)!=oldprod.get(cSMapping.Product2Field__c)){
                bolIsUpdated=true;
                break;
            }
        }
        system.debug(Logginglevel.INFO,'++++bolIsUpdated+++'+bolIsUpdated);
        return bolIsUpdated;
    }
}