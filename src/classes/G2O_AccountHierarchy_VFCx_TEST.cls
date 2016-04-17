/**
    About
    -----
    Description: This class is used to test G2O_CustomerSearch_MOD_VFCx
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of MODValidateAccount_VFCx class.
    1. Test for CreatePrivate person when MOD Tager/Interessent,ExternalProvider PartyId is present & Country is 'DK'.
    2. Test for CreatePrivate person when MOD Tager/Interessent is present but no matching SFDC records exists & Country is 'DK'.
    3. Test for CreatePrivate person for Country as 'SE'.
    4. MODValidate B2C Test for DK.
    5. MODValidate B2C Test for SE.
    6. MODValidate B2B Test for DK.
    7. MODValidate B2B Test for SE.
    
    Update History
    --------------
    Created JUNE 2013 - R.M.
    Refactored JUNE 2013 - A.B.
    Refactored AUG 2013 - M.E.
    
    Issues / TODOs
    --------------
    
*/
@isTest
public class G2O_AccountHierarchy_VFCx_TEST {
    
    static Account objGrandParentAcc;
    static Account objParentAcc;
    static Account objChildAccount;
    static List<Account> lstChildAccount;
    
    public static void init() {
        UTIL_TestFactory.setUpOrg();
        objGrandParentAcc = new Account();
        objGrandParentAcc = UTIL_TestFactory.createAccount();
        objGrandParentAcc.RecordTypeId = [Select Id from RecordType where DeveloperName =: 'Legal_Entity' and SObjectType=: 'Account' limit 1].Id;
        objGrandParentAcc.Group_Parent_Corporate_Registration_Nr__c = objGrandParentAcc.Corporate_Registration_Number__c;
        objGrandParentAcc.Group_Parent_Registration_Country__c = 'DK';
        insert objGrandParentAcc;
            
        objParentAcc = new Account();
        objParentAcc = UTIL_TestFactory.createAccount();
        objParentAcc.RecordTypeId = [Select Id from RecordType where DeveloperName =: 'Work_Site' and SObjectType=: 'Account' limit 1].Id;
        objParentAcc.Group_Parent_Corporate_Registration_Nr__c = objGrandParentAcc.Corporate_Registration_Number__c;
        objParentAcc.Level_in_Group__c = 4;
        objParentAcc.Group_Parent_Corporate_Registration_Nr__c = 'GRCR09';
        objParentAcc.Group_Parent_Registration_Country__c = 'DK';
        objParentAcc.Group_Parent_Legal_Name__c = 'GRLname09';      
        objParentAcc.ParentId = objGrandParentAcc.Id;
    }
    
    public static void init1() {
    UTIL_TestFactory.setUpOrg();
        objParentAcc = new Account();
        objParentAcc = UTIL_TestFactory.createAccount();
        objParentAcc.RecordTypeId = [Select Id from RecordType where DeveloperName =: 'Legal_Entity' and SObjectType=: 'Account' limit 1].Id;
        objParentAcc.Group_Parent_Corporate_Registration_Nr__c = 'CR09';
        objParentAcc.Level_in_Group__c = 4;
        objParentAcc.Ownership = '09893';
    }
    
    public static void init2() {
        UTIL_TestFactory.setUpOrg();
        objParentAcc = new Account();
        objParentAcc = UTIL_TestFactory.createAccount();
        objParentAcc.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        objParentAcc.Group_Parent_Corporate_Registration_Nr__c = 'CR09';
        objParentAcc.Level_in_Group__c = 4;
        objParentAcc.Ownership = '09893';
    }
    
    static testMethod void chkAccountHierarchyWithParentGroup() {
       
       // Arrange
       init();
       
       //Act
       insert objParentAcc;
       
       ApexPages.currentPage().getParameters().put('id', objParentAcc.Id);                          // putting values in the parameters
       ApexPages.StandardController controller = new ApexPages.StandardController(objParentAcc); 
       G2O_AccountHierarchy_VFCx objAccHierarchy = new G2O_AccountHierarchy_VFCx(controller);
       
       // Assert
       System.assert(true);
    }
    
    static testMethod void chkAccountHierarchyWithNoParentGroup() {
       
        // Arrange
        init1();
   
        //Act
        insert objParentAcc;
        
        String strRecordTypeId = [Select Id from RecordType where DeveloperName =: 'Work_Site' and SObjectType=: 'Account' limit 1].Id;
        lstChildAccount = new List<Account>();
        Account childAccount = UTIL_TestFactory.createAccount();
        childAccount.RecordTypeId = strRecordTypeId;
        childAccount.ParentId = objParentAcc.Id;
        childAccount.Level_in_Group__c = 4;
        childAccount.Group_Parent_Corporate_Registration_Nr__c = 'CR09';
        childAccount.Work_Site_Type__c = 'HQ';
        childAccount.Work_Site_Name__c = 'Test Name';
        lstChildAccount.add(childAccount);
        
        Account childAccount1 = UTIL_TestFactory.createAccount();
        childAccount1.RecordTypeId = strRecordTypeId;
        childAccount1.ParentId = objParentAcc.Id;
        childAccount1.Level_in_Group__c = 4;
        childAccount1.Group_Parent_Corporate_Registration_Nr__c = '8748';
        childAccount1.Work_Site_Type__c = 'HQ';
        childAccount1.Work_Site_Name__c = 'Test Name1';
        lstChildAccount.add(childAccount1);
        
        Account childAccount2 = UTIL_TestFactory.createAccount();
        childAccount2.ParentId = objParentAcc.Id;
        childAccount2.Level_in_Group__c = 4;
        childAccount2.Group_Parent_Corporate_Registration_Nr__c = '8748';
        childAccount2.Ownership = '09893';
        lstChildAccount.add(childAccount2);
        
        insert lstChildAccount;
        
       ApexPages.currentPage().getParameters().put('id', objParentAcc.Id);                          // putting values in the parameters
       ApexPages.StandardController controller = new ApexPages.StandardController(objParentAcc); 
       G2O_AccountHierarchy_VFCx objAccHierarchy = new G2O_AccountHierarchy_VFCx(controller);
       
       // Assert
       System.assert(true);
    }
    
    static testMethod void chkAccountHierarchyWithNoParentGroupLE() {
       
        // Arrange
        init1();
   
        //Act
        insert objParentAcc;
    
       ApexPages.currentPage().getParameters().put('id', objParentAcc.Id);                          // putting values in the parameters
       ApexPages.StandardController controller = new ApexPages.StandardController(objParentAcc); 
       G2O_AccountHierarchy_VFCx objAccHierarchy = new G2O_AccountHierarchy_VFCx(controller);
       
       // Assert
       System.assert(true);
    }
    
    static testMethod void chkAccountHierarchyWithNoParentGroupLEChild() {
       
        // Arrange
        init1();
   
        //Act
        insert objParentAcc;
        
        String strRecordTypeId = [Select Id from RecordType where DeveloperName =: 'Legal_Entity' and SObjectType=: 'Account' limit 1].Id;
        lstChildAccount = new List<Account>();
        Account childAccount = UTIL_TestFactory.createAccount();
        childAccount.RecordTypeId = strRecordTypeId;
        childAccount.Level_in_Group__c = 4;
        childAccount.Group_Parent_Corporate_Registration_Nr__c = 'CR09';
        objParentAcc.Ownership = '09893';
        lstChildAccount.add(childAccount);
        
        Account childAccount1 = UTIL_TestFactory.createAccount();
        childAccount1.RecordTypeId = strRecordTypeId;
        childAccount1.Level_in_Group__c = 4;
        childAccount1.Group_Parent_Corporate_Registration_Nr__c = '8748';
        childAccount1.Ownership = '09893';
        lstChildAccount.add(childAccount1);
        
        insert lstChildAccount;
    
        ApexPages.currentPage().getParameters().put('id', objParentAcc.Id);                         // putting values in the parameters
        ApexPages.StandardController controller = new ApexPages.StandardController(objParentAcc); 
        G2O_AccountHierarchy_VFCx objAccHierarchy = new G2O_AccountHierarchy_VFCx(controller);
       
       // Assert
       System.assert(true);
    }
    
    static testMethod void chkAccountHierarchyWithNoParentGroupChildWS() {
       
        // Arrange
        init2();
   
        //Act
        insert objParentAcc;
        
        String strRecordTypeId = [Select Id from RecordType where DeveloperName =: 'Work_Site' and SObjectType=: 'Account' limit 1].Id;
        lstChildAccount = new List<Account>();
        Account childAccount = UTIL_TestFactory.createAccount();
        childAccount.RecordTypeId = strRecordTypeId;
        childAccount.ParentId = objParentAcc.Id;
        childAccount.Level_in_Group__c = 4;
        childAccount.Group_Parent_Corporate_Registration_Nr__c = 'CR09';
        childAccount.Work_Site_Type__c = 'HQ';
        childAccount.Work_Site_Name__c = 'Test Name';
        lstChildAccount.add(childAccount);
        
        insert lstChildAccount;
        
        ApexPages.currentPage().getParameters().put('id', objParentAcc.Id);                         // putting values in the parameters
        ApexPages.StandardController controller = new ApexPages.StandardController(objParentAcc); 
        G2O_AccountHierarchy_VFCx objAccHierarchy = new G2O_AccountHierarchy_VFCx(controller);
       
       // Assert
       System.assert(true);
    }
}