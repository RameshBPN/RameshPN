/**
    About
    -----
    Description: This class is used to test CaseProduct_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details
    -------
    This Class test the functionality of CaseProduct_SVC class.
    1. Test setPrimaryProductBeforeInsert functionality.
    2. Test setPrimaryProductBeforeUpdate functionality.
    3. Test setPrimaryProductBeforeDelete functionality on deleting primary caseproduct with caseproduct left to set as primary.
    4. Test setPrimaryProductBeforeDelete functionality on deleting primary caseproduct with no caseproduct left to set as primary.
    5. Test setCaseArticleAfterUpdate functionality.
    6. Test setCaseArticleAfterInsert functionality.
    7. Test Sum_of_Freight__c field calculation on Insert of a caseproduct record.
    8. Test Sum_of_Freight__c field calculation on Update of a caseproduct record.
    
    Update History
    --------------
    Created March 2013 - A.B.
    
    Issues / TODOs: 
    --------------
    
*/
@isTest
public with sharing class G2O_CaseProduct_SVC_TEST {
    
    
    //A.T.T.R.I.B.U.T.E.S
    static List<Case> caseLst = new List<Case>() ;                                                          //Holds case records.
    static List<CaseProduct__c> caseProductLst =new List<CaseProduct__c>();                                 //Holds caseProduct records.
    static List<CaseProduct__c> caseProductActionLst =new List<CaseProduct__c>();                           //Holds caseProduct records for test Actions.
    static List<CaseProduct__c> caseProductAssertLst =new List<CaseProduct__c>();                           //Holds caseProduct records for test Assert.
    static List<Customer_Service_Product__c> productArticleLst =new List<Customer_Service_Product__c>();    //Holds customer service product records.
    
    static Case testCase1 =new Case();
    static Case testCase2 =new Case();
    static Case testCase3 =new Case();
    
    static Customer_Service_Product__c testCSPro1;
    static Customer_Service_Product__c testCSPro2;
    
    static Set<Id> caseProductIdSet = new Set<Id>();
    
    static User sysAdmin;
    //A.T.T.R.I.B.U.T.E.S
    
    static testMethod void testMe(){
        
        Test.startTest();
                //Creating Custom Setting Get2OneCRM__c.
        Get2OneCRM__c g2OneCs =new Get2OneCRM__c();
        g2OneCs.Case_RecordTypes__c='Complaint';
        insert g2OneCs;
        
        //Creating Custom Setting SAPGetPrices__c.
        SAPGetPrices__c sapGetPrice1 = new SAPGetPrices__c();
        sapGetPrice1.Name='Net Value';
        sapGetPrice1.Include_Prices_PickVal__c='Net_Value__c';
        insert sapGetPrice1;
        
        SAPGetPrices__c sapGetPrice2 = new SAPGetPrices__c();
        sapGetPrice2.Name='Discount Amount';
        sapGetPrice2.Include_Prices_PickVal__c='Discount_Amount__c';
        insert sapGetPrice2;
        
        
        //Getting the Developer Name from Custom Setting.
        String developerName = UTIL_OrgSettings.CaseRecordTypes();
        //Getting the recordTypeId.
        Id rTypeId=[Select r.Name, r.Id, r.DeveloperName From RecordType r where r.DeveloperName=:developerName Limit 1].Id;
        
        
        //Creating Two different Cases.
        //1.Case FIRST will have one primary CaseProduct.
        //2.Case SECOND will have no primary CaseProduct.
        
        testCase1=UTIL_TestFactory.createCase();
        testCase1.Status='For Approval';
        testCase1.Priority='Medium';
        testCase1.RecordTypeId=rTypeId;
        testCase1.Item_Id__c='testCase1ItemId';
        
        testCase2=UTIL_TestFactory.createCase();
        testCase2.Status='For Approval';
        testCase2.Priority='Medium';
        testCase2.RecordTypeId=rTypeId;
        testCase2.Item_Id__c='testCase2ItemId';
        
        caseLst.add(testCase1);
        caseLst.add(testCase2);
        insert caseLst;
        Test.stopTest();
        
        System.assertEquals(true,[Select c.Id,c.IsPrimary__c,c.Case__c From CaseProduct__c c where c.Case__c =:caseLst[0].Id].IsPrimary__c);
        System.assertEquals(true,[Select c.Id,c.IsPrimary__c,c.Case__c From CaseProduct__c c where c.Case__c =:caseLst[1].Id].IsPrimary__c);
        
        System.assertEquals(caseLst[0].Item_Id__c,[Select c.Id,c.Item_Id__c,c.Case__c From CaseProduct__c c where c.Case__c =:caseLst[0].Id].Item_Id__c);
        System.assertEquals(caseLst[1].Item_Id__c,[Select c.Id,c.Item_Id__c,c.Case__c From CaseProduct__c c where c.Case__c =:caseLst[1].Id].Item_Id__c);
        
    }
    
    //1. Test setPrimaryProductBeforeInsert functionality.
    static testMethod void setPrimaryProductBeforeInsert(){
        
        // Arrange
        createTestData();
        
        // Act
        for(integer i=0;i<3;i++){
            CaseProduct__c cpRecord= new CaseProduct__c();
            cpRecord.Item_Id__c ='ABC'+i;
            if(i==0){
                cpRecord.IsPrimary__c=true;                     //Setting isPrimary true for the FIRST case already this case has one primary caseProduct.
                cpRecord.Case__c=caseLst[0].id;
            }else{
                cpRecord.Case__c=caseLst[1].id;                 //Second Case has no caseProducts,Inserting two caseProduct without setting isPrimary.
            }
            caseProductActionLst.add(cpRecord);
        }
        
        Test.startTest();
        insert caseProductActionLst;
        Test.stopTest();
        
        // Assert       
        
        //Asserting for CaseProduct set as True.
        System.assertEquals(true,[Select c.Id,c.IsPrimary__c,c.Case__c From CaseProduct__c c where c.Id =:caseProductActionLst[0].Id].IsPrimary__c);
        System.assertEquals(false,[Select c.Id,c.IsPrimary__c,c.Case__c From CaseProduct__c c where c.Id =:caseProductActionLst[1].Id].IsPrimary__c);       
    }
    
    //2. Test setPrimaryProductBeforeUpdate functionality.
    static testMethod void setPrimaryProductBeforeUpdate(){
        
        //List<CaseProduct__c> cpRecLst =new List<CaseProduct__c>();
        //List<CaseProduct__c> cpRecUpdateLst =new List<CaseProduct__c>();
        
        List<Id> caseIdLst = new List<Id>();
        set<Id> oldPrimarySet = new set<Id>();  //Holds ID of the existing primary product that must be set to false one a new primary is updated.
        
        // Arrange
        createTestData();
        
        //Getting set of existing primary products.
        for(CaseProduct__c cp:[Select c.Id,Item_Id__c,c.IsPrimary__c,c.Case__c From CaseProduct__c c where c.IsPrimary__c=true]){
            oldPrimarySet.add(cp.Id);
        }
        
        system.debug('++++oldPrimarySet+++'+oldPrimarySet);
        
        // Act
        Test.startTest();
        for(integer i=0;i<caseProductLst.size();i++){
            if(i==0 || i==5){
                caseProductLst[i].IsPrimary__c=true;
                system.debug('++++caseProductLst[i].Id+++'+caseProductLst[i].Id);
            }
        }

        update caseProductLst;
        Test.stopTest();
        
        // Assert
        caseProductAssertLst =[Select c.Id,Item_Id__c,c.IsPrimary__c,c.Case__c From CaseProduct__c c where c.isPrimary__c=true];
        system.debug('++++caseProductAssertLst+++'+caseProductAssertLst);
        System.assertEquals(false,oldPrimarySet.contains(caseProductAssertLst[0].Id));  //Asserting for CaseProduct is set to false as a new Primary caseProduct is made.
    }
    
    
    //3. Test setPrimaryProductBeforeDelete functionality when there are caseproduct left for case on primary caseproduct deleted.
    static testMethod void setPrimaryProductDeleteTestCase1(){
        
        //List<CaseProduct__c> cpRecLst =new List<CaseProduct__c>();
        List<CaseProduct__c> cpRecDeleteLst =new List<CaseProduct__c>();
        
        set<Id> cpNotPrimarySet = new set<Id>();
        
        // Arrange
        createTestData();
        
        // Act
        Test.startTest();
        
        for(CaseProduct__c cpRec:[Select c.Id,c.Item_Id__c,c.isPrimary__c, c.Case__c From CaseProduct__c c]){
            if(cpRec.isPrimary__c){
                cpRecDeleteLst.add(cpRec);
            }else{
                cpNotPrimarySet.add(cpRec.Id);
            }
        }
        delete cpRecDeleteLst;
        Test.stopTest();
        
        // Assert
        caseProductAssertLst =[Select c.Id,Item_Id__c,c.IsPrimary__c,c.Case__c From CaseProduct__c c where c.isPrimary__c=true];
        System.assertEquals(true,cpNotPrimarySet.contains(caseProductAssertLst[0].Id)); //Asserting for CaseProduct is set to false as a new Primary caseProduct is made.
        
    }
    
    //4. Test setPrimaryProductBeforeDelete functionality,when there are no caseproduct left for case on primary caseproduct deleted.
    static testMethod void setPrimaryProductDeleteTestCase2(){
        
        List<CaseProduct__c> cpRecDeleteLst =new List<CaseProduct__c>();
        List<CaseProduct__c> cpNotPrimarySet =new List<CaseProduct__c>();
        
        // Arrange
        createTestData();
        
        // Act
        Test.startTest();
        
        for(CaseProduct__c cpRec:[Select c.Id,c.Item_Id__c,c.isPrimary__c, c.Case__c From CaseProduct__c c]){
            if(cpRec.isPrimary__c){
                cpRecDeleteLst.add(cpRec);
            }else{
                cpNotPrimarySet.add(cpRec);
            }
        }
        delete cpNotPrimarySet;
        delete cpRecDeleteLst;
        Test.stopTest();
        
        // Assert
        System.assertEquals(null,[Select c.Item_Id__c From Case c where c.Id =:caseLst[1].Id].Item_Id__c);  //Asserting for CaseProduct is set to false as a new Primary caseProduct is made.
        
    }
    
    //5. Test setCaseArticleAfterUpdate functionality.
    static testMethod void setCaseArticleAfterUpdate(){
        
        List<CaseProduct__c> cPLst =new List<CaseProduct__c>();
        // Arrange
        createTestData();
        
        for(integer i=0;i<caseProductLst.size();i++){
            if(i==0 || i==5){
                caseProductLst[i].IsPrimary__c=true;
                caseProductLst[i].Customer_Service_Product__c=testCSPro1.Id;
                system.debug('++++caseProductLst[i].Id+++'+caseProductLst[i].Id);
                cPLst.add(caseProductLst[i]);
            }
        }
        G2O_Case_SVC.setArticle=false;
        
        Test.startTest();
        system.runAs(sysAdmin){
            update cPLst;
        }
        Test.stopTest();
        
        System.assertEquals(cPLst[0].Customer_Service_Product__c,[Select c.Product_Article__c From Case c where c.Id=:cPLst[0].Case__c].Product_Article__c);
    }
    
    
    //6. Test setCaseArticleAfterInsert functionality.
    static testMethod void setCaseArticleAfterInsert(){
        
        // Arrange
        createTestData();
        
        CaseProduct__c cp = new CaseProduct__c ();
        cp.IsPrimary__c=true;
        cp.Customer_Service_Product__c=testCSPro1.Id;
        cp.Case__c=testCase2.Id;
        G2O_Case_SVC.setArticle=false;
        
        Test.startTest();
        system.runAs(sysAdmin){
            insert cp;
        }
        Test.stopTest();
        
        System.assertEquals(cp.Customer_Service_Product__c,[Select c.Product_Article__c From Case c where c.Id=:cp.Case__c].Product_Article__c);
    }
    
    
    //7. Test Sum_of_Freight__c field calculation on Insert of a caseproduct record.
    static testMethod void setSumOfFreight_On_CpInsertTest(){
        
        // Arrange
        createTestData();
        
        //Assert
        System.assertEquals(100,[Select c.Id,c.Sum_of_Freight__c,c.Case__c From CaseProduct__c c where c.Id =:caseProductLst[0].Id].Sum_of_Freight__c);
        System.assertEquals(null,[Select c.Id,c.Sum_of_Freight__c,c.Case__c From CaseProduct__c c where c.Id =:caseProductLst[5].Id].Sum_of_Freight__c);
        
    }
    
    
    //8. Test Sum_of_Freight__c field calculation on Update of a caseproduct record.
    static testMethod void setSumOfFreight_On_CpUpdateTest(){
        
        // Arrange
        createTestData();
        
        //Act
        Test.startTest();
        caseProductLst[0].Include_Prices__c='Net Value';        //Removing one pick val from the multi select picklist.
        update caseProductLst;
        Test.stopTest();
        
        //Assert
        System.assertEquals(10,[Select c.Id,c.Sum_of_Freight__c,c.Case__c From CaseProduct__c c where c.Id =:caseProductLst[0].Id].Sum_of_Freight__c);
        System.assertEquals(null,[Select c.Id,c.Sum_of_Freight__c,c.Case__c From CaseProduct__c c where c.Id =:caseProductLst[5].Id].Sum_of_Freight__c);
    }   
            
    //Creating test data.
    public static void createTestData() {
        
        //Creating Custom Setting Get2OneCRM__c.
        Get2OneCRM__c g2OneCs =new Get2OneCRM__c();
        g2OneCs.Case_RecordTypes__c='Complaint';
        insert g2OneCs;
        
        //Creating Custom Setting SAPGetPrices__c.
        SAPGetPrices__c sapGetPrice1 = new SAPGetPrices__c();
        sapGetPrice1.Name='Net Value';
        sapGetPrice1.Include_Prices_PickVal__c='Net_Value__c';
        insert sapGetPrice1;
        
        SAPGetPrices__c sapGetPrice2 = new SAPGetPrices__c();
        sapGetPrice2.Name='Discount Amount';
        sapGetPrice2.Include_Prices_PickVal__c='Discount_Amount__c';
        insert sapGetPrice2;
        
        sysAdmin = UTIL_TestFactory.createAdmin('testCaseSysAdm@mail.com');
        sysAdmin.Sales_Area1__c = 'PDK BE';
        insert sysAdmin;
        
        //Getting the Developer Name from Custom Setting.
        String developerName = UTIL_OrgSettings.CaseRecordTypes();
        //Getting the recordTypeId.
        Id rTypeId=[Select r.Name, r.Id, r.DeveloperName From RecordType r where r.DeveloperName=:developerName Limit 1].Id;
        
        
        //Creating Two different Cases.
        //1.Case FIRST will have one primary CaseProduct.
        //2.Case SECOND will have no primary CaseProduct.
        
        testCase1=UTIL_TestFactory.createCase();
        testCase1.Status='For Approval';
        testCase1.Priority='Medium';
        testCase1.RecordTypeId=rTypeId;
        testCase1.Item_Id__c='testCase1ItemId';
        
        testCase2=UTIL_TestFactory.createCase();
        testCase2.Status='For Approval';
        testCase2.Priority='Medium';
        testCase2.RecordTypeId=rTypeId;
        testCase2.Item_Id__c='testCase2ItemId';
        
        caseLst.add(testCase1);
        caseLst.add(testCase2);
        insert caseLst;
        
        
        //Creating createProductArticle
        testCSPro1 = UTIL_TestFactory.createProductArticl();
        testCSPro1.Sales_Area__c = 'PDK BE';
        testCSPro1.Active__c = true;
        testCSPro1.Product_Type__c = 'Product Group';
        
        testCSPro2=UTIL_TestFactory.createProductArticl();
        testCSPro2.Global_ID__c ='22222';
        testCSPro2.Sales_Area__c = 'PDK BE';
        testCSPro2.Active__c = true;
        testCSPro2.Product_Type__c = 'Product Group';
        
        system.runAs(sysAdmin){
            insert testCSPro1;
            insert testCSPro2;
        }
        
        //Creating CaseProducts
        for (Integer i = 0; i < 10; i++) {
            CaseProduct__c casProd =new CaseProduct__c();
          
            casProd.Item_Id__c = 'XXP'+i;
            if(i<5){
                casProd.Case__c=caseLst[0].id;
                casProd.Net_Value__c=10;                                    //Setting price value to test SAP Get price functionality.
                casProd.Discount_Amount__c=90;                          //Setting price value to test SAP Get price functionality.
                casProd.Include_Prices__c='Net Value;Discount Amount';  //Putting values in the multiselect picklist,for SAP GetPrices functionality test.
            }else{
                casProd.Case__c=caseLst[1].id;
                
            }
            caseProductLst.add(casProd);
        }
        
        insert caseProductLst;
        
    }
    
}