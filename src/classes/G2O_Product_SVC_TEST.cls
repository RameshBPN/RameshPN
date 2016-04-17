/**
    About
    -----
    Description: This class is used to test Product_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of Product_SVC class.
    1. Test copyProductBeforeInsert method of Product_SVC class.
    2. Test copyProductBeforeUpdateTest method of Product_SVC class.
    3. Test deleteCustomerServiceTest method of Product_SVC class.
    
    Update History
    --------------
    Created April 2013 - A.B.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Product_SVC_TEST {
    
    static List<Product2> productLst = new List<Product2>();
    static Set<String> globalIdSet =new Set<String>();
    
    //1. Test copyProductBeforeInsert method of Product_SVC class.
    static testMethod void copyProductBeforeInsertTest() {
        
        // Arrange
        createData();
        
        //Act
        Test.startTest();
        insert productLst;
        Test.stopTest();
        
        // Assert
        system.debug('#####1####'+productLst[0].Global_ID__c);
        system.debug('#####2####'+productLst[0]);
        System.assertEquals(true,productLst[0].Id!=null);
    }
    
    //2. Test copyProductBeforeUpdateTest method of Product_SVC class.
    static testMethod void copyProductBeforeUpdateTest() {
        
        // Arrange
        createData();
        
        system.debug('++++productLst++++'+productLst);
        insert productLst;
        
        //Act
        system.debug('+++productLst[0].Global_ID__c+++'+productLst[0].Global_ID__c);
        system.debug('+++productLst[0].Global_ID__c+++'+productLst[0].Id);
        
        Product2 prod2 =[Select c.Global_ID__c From Product2 c where c.Id=:productLst[0].Id];
        
        List<Customer_Service_Product__c> KT =[Select c.Id,c.Active__c From Customer_Service_Product__c c where c.Global_ID__c=:prod2.Global_ID__c];
        
        boolean isActive =[Select c.Id,c.Active__c From Customer_Service_Product__c c where c.Global_ID__c=:prod2.Global_ID__c].Active__c;
        System.assertEquals(false,isActive);
        
        Test.startTest();
        for(Product2 prod:productLst){
            prod.IsActive=true;
        }
        
        update productLst;
        Test.stopTest();
        
        // Assert
        boolean isActiveNew =[Select c.Id,c.Active__c From Customer_Service_Product__c c where c.Global_ID__c=:prod2.Global_ID__c].Active__c;
        System.assertEquals(true,isActiveNew);
    }
    
    //3. Test deleteCustomerServiceTest method of Product_SVC class.
    static testMethod void deleteCustomerServiceTest() {
        
        // Arrange
        createData();
        insert productLst;
        //Act
        Test.startTest();
        
        for(Product2 product : productLst){
            globalIdSet.add(product.Global_ID__c);
        }
        
        System.assertEquals(201,[Select count() From Customer_Service_Product__c c where c.Global_ID__c IN:globalIdSet]);
        
        delete productLst;
        Test.stopTest();
        
        // Assert
        System.assertEquals(0,[Select count() From Customer_Service_Product__c c where c.Global_ID__c IN:globalIdSet]);
    }
    
    static void createData() {
        
        //Creating Custom Setting.
        List<CustomerServiceProductMapping__c> cSettingLst = new List<CustomerServiceProductMapping__c>();
        CustomerServiceProductMapping__c cS0 = new CustomerServiceProductMapping__c();
        cS0.Name='Active__c';
        cS0.Product2Field__c='IsActive';
        cSettingLst.add(cS0);
        
        CustomerServiceProductMapping__c cS2 = new CustomerServiceProductMapping__c();
        cS2.Name='Name';
        cS2.Product2Field__c='Name';
        cSettingLst.add(cS2);
        
        CustomerServiceProductMapping__c cS3 = new CustomerServiceProductMapping__c();
        cS3.Name='Product_Type__c';
        cS3.Product2Field__c='Product_Type__c';
        cSettingLst.add(cS3);
        
        CustomerServiceProductMapping__c cS4 = new CustomerServiceProductMapping__c();
        cS4.Name='Global_ID__c';
        cS4.Product2Field__c='Global_ID__c';
        cSettingLst.add(cS4);
        
        insert cSettingLst;
        
        //Inserting Products
        productLst=UTIL_TestFactory.createProducts();
        for(integer i=0;i<productLst.size();i++){
            productLst[i].isActive=false;
            productLst[i].Global_ID__c='2298#'+i;
            productLst[i].Name='3298#'+i;
            productLst[i].Product_Type__c='4298#';
        }
            
    }

}