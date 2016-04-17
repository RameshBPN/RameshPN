/**
    About
    -----
    Description: This class is used to test G2O_Refire_VFC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Feb 2015
        
    Update History
    --------------
    Created Feb 2015
    
    Issues / TODOs
    --------------   
*/
@isTest
private class G2O_Refire_VFC_TEST {
    static Set<String> setupTestDataAndReturnInvolvedPartyIds()
    {
         UTIL_TestFactory.setupOrg();
        Account a=UTIL_TestFactory.createAccount();
        insert a;
        //contact
        Contact c = new Contact();
        c.LastName = 'NOW ' + String.valueOf(System.now());
        c.FirstName = 'NOW ' + String.valueOf(System.now());
        c.Contact_Person_Type__c = 'Lead Contact Person (TBD)';
        c.Language__c = 'EN';
        c.Verified__c = 'N';
        c.AccountId = a.Id;
        insert c;
        //Account Contact Role Transaction
        Account_Contact_Role_Transaction__c acrt = [Select SystemModstamp, Secondary_Position_3__c, Secondary_Position_2__c, 
                                                    Secondary_Position_1__c, Primary_Position__c, PN_Synchronized__c, 
                                                    PN_Synchronization_Error__c, PN_Synchronization_ErrorReasonCode__c, 
                                                    PN_Mark_As_Synced__c, Name, Last_PN_Synchronized_Date__c, 
                                                    LastModifiedDate, LastModifiedById, Is_Governed_by_External_Party__c, 
                                                    IsPrimary__c, IsDeleted, Id, External_Provider_Relationship_ID__c, 
                                                    CurrencyIsoCode, CreatedDate, CreatedById, Contact__c, 
                                                    Account__c, Account_Contact_Role_SFID__c
                                                    From Account_Contact_Role_Transaction__c
                                                    WHERE Account__c = :a.Id AND Contact__c = :c.Id
                                                    LIMIT 1];
        
        //bank details
        Bank_Details__c bankDetail = new Bank_Details__c(); 
        Bank_Key__c bankKey = UTIL_TestFactory.createBankKey();   
        insert bankKey;    
        bankDetail.Account__c = a.Id;       
        bankDetail.Bank_Key__c = bankKey.Id;
        bankDetail.Bank_Country__c = bankKey.Country__c;
        bankDetail.Bank_Account__c = '1234567890';
        insert bankDetail;
        
        //Credit Information
        Credit_Information__c creditInformation = new Credit_Information__c();
        creditInformation.Account__c = a.Id;
        insert creditInformation;
        
        //Relationship
        Relationship__c rel=UTIL_TestFactory.createRelationship();
        insert rel;
        
        Set<String> involvedPartyIdsSet=new Set<String>();
        for(Account acc:[SELECT Id, Involved_Party_Id__c FROM Account WHERE Id=:a.Id])
        {
             involvedPartyIdsSet.add(acc.Involved_Party_Id__c);
        }
        for(Account_Contact_Role_Transaction__c accCRT:[SELECT Id, Account_Contact_Role_SFID__c,Account__r.Involved_Party_Id__c FROM Account_Contact_Role_Transaction__c  WHERE Id=:acrt.Id])
        {
             involvedPartyIdsSet.add(accCRT.Account__r.Involved_Party_Id__c);
        }
        for(Bank_Details__c bDetails:[SELECT Id, Bank_Details_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Bank_Details__c WHERE Id=:bankDetail.Id])
        {
             involvedPartyIdsSet.add(bDetails.Account__r.Involved_Party_Id__c);
        }
        for(Contact con:[SELECT Id, Contact_Person_ID__c,Account.Involved_Party_Id__c FROM Contact WHERE Id=:c.Id])
        {
             involvedPartyIdsSet.add(con.Account.Involved_Party_Id__c);
        }
        for(Credit_Information__c creditInfo:[SELECT Id, Credit_Information_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Credit_Information__c WHERE Id=:creditInformation.Id])
        {
           involvedPartyIdsSet.add(creditInfo.Account__r.Involved_Party_Id__c);
        }
        for(Relationship__c relation:[SELECT Id, Relationship_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Relationship__c WHERE Id=:rel.Id])
        {
             involvedPartyIdsSet.add(relation.Account__r.Involved_Party_Id__c);
        }
        for(Sales_Area_Information__c salesAreaInfo:[SELECT Id, Sales_Area_Information_Compound_SFID__c,Account__r.Involved_Party_Id__c FROM Sales_Area_Information__c WHERE Account__r.Id=:a.Id])
        {
             involvedPartyIdsSet.add(salesAreaInfo.Account__r.Involved_Party_Id__c);
        }
        return involvedPartyIdsSet;
    }
    static testMethod void add_OR_Remove_Items() {
       
        PageReference pageRef = Page.G2O_Refire;
        Test.setCurrentPage(pageRef);
        G2O_Refire_VFC refire=new G2O_Refire_VFC();
        refire.numberOfItemsToAdd=1;
        refire.addItemsToRefireModelList();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {            
            refire.refireModelList[i].isSelected=true;           
        }       
        refire.removeItemsFromRefireModelList(); 
        System.assertEquals(refire.refireModelList.size(), 0);      
    }
    static testMethod void uploadInvolvedpartyFile() {
       
        List<String> refireIdsList=new List<String>();
        refireIdsList.addAll(setupTestDataAndReturnInvolvedPartyIds());
        
        PageReference pageRef = Page.G2O_Refire;
        Test.setCurrentPage(pageRef);
        G2O_Refire_VFC refire=new G2O_Refire_VFC();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {            
            refire.refireModelList[i].isSelected=true;           
        }       
        refire.removeItemsFromRefireModelList();
        String headerLabel=System.Label.Refire_Customer_Number_Header_In_CSV_File.replace(' ','');
        String involvedPartyFileString=headerLabel;
        for(String invPartyId:refireIdsList){
            involvedPartyFileString=involvedPartyFileString+'\n'+invPartyId;
        }    
        refire.involvedPartyFile=Blob.valueOf(involvedPartyFileString);
        refire.uploadInvolvedPartyFile();
        System.assertEquals(refire.refireModelList.size(), refireIdsList.size()); 
    }
    static testMethod void refireAllItems() {
       
        List<String> refireIdsList=new List<String>();
        refireIdsList.addAll(setupTestDataAndReturnInvolvedPartyIds());
        
        PageReference pageRef = Page.G2O_Refire;
        Test.setCurrentPage(pageRef);
        G2O_Refire_VFC refire=new G2O_Refire_VFC();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {            
            refire.refireModelList[i].isSelected=true;           
        }       
        refire.removeItemsFromRefireModelList();
        refire.numberOfItemsToAdd=refireIdsList.size();
        refire.addItemsToRefireModelList();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {                       
            refire.refireModelList[i].idToRefire=String.valueOf(refireIdsList[i]); 
            refire.refireModelList[i].operation='INSERT';          
        }
        refire.refireAllItems();
        System.debug('refire.number_Of_OBMs_ToUpsert........all='+refire.number_Of_OBMs_ToUpsert);
        System.assertEquals(refire.number_Of_OBMs_ToUpsert, 9);
    }
    static testMethod void refireTheSelectedItems() {
    
        List<String> refireIdsList=new List<String>();
        refireIdsList.addAll(setupTestDataAndReturnInvolvedPartyIds());
        
        PageReference pageRef = Page.G2O_Refire;
        Test.setCurrentPage(pageRef);
        G2O_Refire_VFC refire=new G2O_Refire_VFC();
        refire.numberOfItemsToAdd=1;
        refire.addItemsToRefireModelList();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {            
            refire.refireModelList[i].isSelected=true;           
        }
        refire.removeItemsFromRefireModelList();
        refire.numberOfItemsToAdd=refireIdsList.size();
        refire.addItemsToRefireModelList();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {            
            refire.refireModelList[i].isSelected=true;
            refire.refireModelList[i].idToRefire=String.valueOf(refireIdsList[i]);  
            refire.refireModelList[i].operation='INSERT';         
        }
        refire.refireTheSelectedItems();
        System.debug('refire.number_Of_OBMs_ToUpsert........='+refire.number_Of_OBMs_ToUpsert);
        System.assertEquals(refire.number_Of_OBMs_ToUpsert, 9);
    }
    static testMethod void testDefaults() {
    
        PageReference pageRef = Page.G2O_Refire;
        Test.setCurrentPage(pageRef);
        G2O_Refire_VFC refire=new G2O_Refire_VFC();
        
        SelectOption[] operationOptions=refire.operationOptions;
        
        Integer pageBlockTableDivSize=refire.pageBlockTableDivSize;       
    }
    static testMethod void resetAll() {
    
        PageReference pageRef = Page.G2O_Refire;
        Test.setCurrentPage(pageRef);
        G2O_Refire_VFC refire=new G2O_Refire_VFC();
        refire.resetAll();   
        System.assertEquals(refire.refireModelList.size(),0);     
    }
    static testMethod void findDuplicates() {
        List<String> refireIdsList=new List<String>();
        refireIdsList.addAll(setupTestDataAndReturnInvolvedPartyIds());
        PageReference pageRef = Page.G2O_Refire;
        Test.setCurrentPage(pageRef);
        G2O_Refire_VFC refire=new G2O_Refire_VFC();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {            
            refire.refireModelList[i].isSelected=true;           
        }       
        refire.removeItemsFromRefireModelList();
        refire.numberOfItemsToAdd=refireIdsList.size();
        refire.addItemsToRefireModelList();
        for(Integer i=0;i<refire.refireModelList.size();i++)
        {                       
            refire.refireModelList[i].idToRefire=String.valueOf(refireIdsList[0]); 
            refire.refireModelList[i].operation='INSERT';          
        }
        refire.refireAllItems();      
    }
}