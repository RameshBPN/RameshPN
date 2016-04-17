/**
    About
    -----
    Description: This class is used to test NTTSearch_Button_VFCx.
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    This Class test the functionality of PrintSaveEmail class.
    1.createCaseTest:Test the PrintSaveEmail Button functionality.

    -----------------------
        
    Update History
    --------------
    Created May 2013 - A.B.
    
    Issues / TODOs
    --------------  
*/

@isTest()
private with sharing class G2O_PrintSaveEmail_VFCx_TEST { 
    
    
    //A.T.T.R.I.B.U.T.E.S
    static Case cas;
    static Id rTypeId;
    static List<GenericURLHacking__c> genericURLCSettingLst =new List<GenericURLHacking__c> ();
    static Map<String,String> paramMap;
    //A.T.T.R.I.B.U.T.E.S
    
    //1. Test redirect method of PrintSaveEmail_VFCx class.
    static testMethod void PrintSaveEmailTest(){
        
        //Arrange
        CreateTestData();
        
        //Act
        PageReference pageRef = Page.G2O_PrintSaveEmail;
        pageRef.getParameters().put('id', cas.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardController theController = new ApexPages.standardController(cas);
        G2O_PrintSaveEmail_VFCx ext = new G2O_PrintSaveEmail_VFCx(theController);
        ext.redirect();
        paramMap = ext.pageRedirect.getParameters();
        
        //Assert
        System.assertEquals('abcd22@test.com', paramMap.get('p24'));
        
    }
    
    //Creating test data
    public static void CreateTestData() {
        
        rTypeId=[Select r.Name, r.Id, r.DeveloperName From RecordType r where r.DeveloperName='Item_Search'].Id;
        
        //Creating Custom Settings.
        GenericURLHacking__c genericCSetting1 = new GenericURLHacking__c();
        genericCSetting1.Name ='Id';
        genericCSetting1.Default_Value__c='';
        genericCSetting1.URL_Field_Id__c='p3_lkid';
        genericCSetting1.Feature_Name__c='PrintSaveEmail';
        genericURLCSettingLst.add(genericCSetting1);
        
        GenericURLHacking__c genericCSetting2 = new GenericURLHacking__c();
        genericCSetting2.Name ='AdditionalTo';
        genericCSetting2.Default_Value__c='abcd22@test.com';
        genericCSetting2.URL_Field_Id__c='p24';
        genericCSetting2.Feature_Name__c='  PrintSaveEmail';
        genericURLCSettingLst.add(genericCSetting2);
        
        GenericURLHacking__c genericCSetting3 = new GenericURLHacking__c();
        genericCSetting3.Name ='BCC';
        genericCSetting3.Default_Value__c='';
        genericCSetting3.URL_Field_Id__c='p5';
        genericCSetting3.Feature_Name__c='PrintSaveEmail';
        genericURLCSettingLst.add(genericCSetting3);
        
        insert genericURLCSettingLst;
        
        //Creating Case.
        cas=UTIL_TestFactory.createCase();
        cas.Status='For Approval';
        cas.Priority='Medium';
        cas.Origin='Telefon';
        insert cas;
        
        
    }
}