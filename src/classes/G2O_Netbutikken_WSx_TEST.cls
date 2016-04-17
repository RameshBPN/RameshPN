/**
    About
    -----
    Description: This class is used to test Netbutikken_WS
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
    
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_Netbutikken_WSx_TEST {

    static testMethod void testGenerateCustomerPoolB2B() {
        UTIL_TestFactory.createGet2OneCrm();
        // Act
        List<Account> accountList = G2O_Netbutikken_WSx.generateCustomerPool(200, 'B2B');
        
        Id b2bRecordTypeId = [SELECT Id
                              FROM RecordType
                              WHERE DeveloperName='B2B_Webshop_Placeholder' AND sObjectType = 'Account'].Id;
        
        // Assert                     
        System.assertEquals(200, accountList.size());
        System.assertEquals('B2B Webshop', accountList[0].Name);
        System.assertEquals(b2bRecordTypeId, accountList[0].RecordTypeId);
        System.assertEquals(false, UTIL_Apex.empty(accountList[0].Involved_Party_ID__c));
    }
    
    static testMethod void testGenerateCustomerPoolB2C() {
        UTIL_TestFactory.createGet2OneCrm();
       // Act
        List<Account> accountList = G2O_Netbutikken_WSx.generateCustomerPool(200, 'B2C');
        
        Id b2bRecordTypeId = [SELECT Id
                              FROM RecordType
                              WHERE DeveloperName='B2C_Webshop_Placeholder' AND sObjectType = 'Account'].Id;
        
        // Assert                     
        System.assertEquals(200, accountList.size());
        System.assertEquals('B2C Webshop', accountList[0].LastName);
        System.assertEquals(b2bRecordTypeId, accountList[0].RecordTypeId);
        System.assertEquals(false, UTIL_Apex.empty(accountList[0].Involved_Party_ID__c));
    }
    
    static testMethod void testGenerateCustomerPoolToInvalidQuantity() {
        UTIL_TestFactory.createGet2OneCrm();
        // Act
        List<Account> negativ = G2O_Netbutikken_WSx.generateCustomerPool(-5, 'B2B');
        List<Account> toHigh = G2O_Netbutikken_WSx.generateCustomerPool(500, 'B2B');
        List<Account> zero = G2O_Netbutikken_WSx.generateCustomerPool(0, 'B2B');
        
        Integer numberOfAccounts = [SELECT COUNT() FROM Account];
        
        // Assert
        System.assertEquals(0, negativ.size());
        System.assertEquals(200, toHigh.size());
        System.assertEquals(0, zero.size());
        System.assertEquals(200, numberOfAccounts);
    }
    
    static testMethod void testGenerateCustomerPoolAccountInvalidType() {
        UTIL_TestFactory.createGet2OneCrm();
        // Act
        List<Account> accountList = G2O_Netbutikken_WSx.generateCustomerPool(2, 'unvalid');
        
        Integer numberOfAccounts = [SELECT COUNT() FROM Account];
        
        // Assert
        System.assertEquals(0, accountList.size());
        System.assertEquals(0, numberOfAccounts);
    }
    
    static testMethod void testGenerateCustomerPoolSalesArea() {
        UTIL_TestFactory.createGet2OneCrm();
        // Act
        List<Account> accountList = G2O_Netbutikken_WSx.generateCustomerPool(2, 'B2B');
        
        Integer numberOfAccounts = [SELECT COUNT() FROM Account];
        Integer numberOfSalesAreaInformation = [SELECT COUNT() FROM Sales_Area_Information__c];
        
        // Assert
        System.assertEquals(2, numberOfAccounts);
        System.assertEquals(2, numberOfSalesAreaInformation);
    }
}