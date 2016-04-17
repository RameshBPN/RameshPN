/**
    About
    -----
    Description: This class is used to test Integration #13. Product Information to CRM
                                            
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: June 2013
    
    Details
    -------
    
    Update History
    --------------
    Created June 2013 - T.R.
    
 */
 
@isTest
private class G2O_UseCase_ProductInformationToCRM_TEST {

    //This test method makes sure there is an external id on the Product2 object
    static testMethod void upsertProductWithGlobalId() {
        //Arrange
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        
        //Parent
        Product2 product = new Product2();
        product.Name = 'TEST_PRODUCT';
        product.Global_ID__c = 'TEST_123456';

        //Act
        System.runAs(integrationUser) {
            upsert product Global_ID__c;
        }
        
        //Assert
        Product2 upsertedProduct = [SELECT Id, Name, Global_ID__c FROM Product2 WHERE Id =: product.Id];
        System.assertEquals('TEST_PRODUCT', upsertedProduct.Name);
        System.assertEquals(true, UTIL_Apex.isSet(upsertedProduct.Global_ID__c));
    }
    
    //This test method makes sure there is an external id on the Additional Service object
    static testMethod void upsertAdditionalServiceWithGlobalId() {
        //Arrange
        User integrationUser = UTIL_TestFactory.createIntegrationUser('integrationUser@test.com');
        
        //Parent
        Additional_Service__c additionalService = new Additional_Service__c();
        additionalService.Name = 'TEST_AS';
        additionalService.Global_ID__c = 'TEST_98765';

        //Act
        System.runAs(integrationUser) {
            upsert additionalService Global_ID__c;
        }
        
        //Assert
        Additional_Service__c upsertedAdditionalService = [SELECT Id, Name, Global_ID__c FROM Additional_Service__c WHERE Id =: additionalService.Id];
        System.assertEquals('TEST_AS', upsertedAdditionalService.Name);
        System.assertEquals(true, UTIL_Apex.isSet(upsertedAdditionalService.Global_ID__c));
    }
}