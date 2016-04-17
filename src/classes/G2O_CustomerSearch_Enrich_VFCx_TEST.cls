/**
    About
    -----
    Description: This class is used to test PAR Verify Button
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Update History
    --------------
    Created May 2013 - R.M.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_CustomerSearch_Enrich_VFCx_TEST {

    static Account accountPAR;
        
    public static void init() { 
        
        accountPAR  = new Account();
        accountPAR  = UTIL_TestFactory.createAccount();
        accountPAR.RecordTypeId = UTIL_Meta.getAccountWorksiteRT();
        accountPAR.Work_Site_Registration_Number__c = '88798';
        accountPAR.Postal_Address_House_Number__c = '67';
        accountPAR.Postal_Address_PO_Box__c = '7876';
        accountPAR.Postal_Address_Street__c = 'dk';
        accountPAR.Postal_Address_City__c = 'Test City';
        accountPAR.Postal_Address_Country__c = 'DK';
        accountPAR.Postal_Address_Postal_Code__c = '9894';
        accountPAR.Visiting_Address_Street__c = 'dk';
        accountPAR.Visiting_Address_City__c  = 'Test City';
        accountPAR.Visiting_Address_Postal_Code__c = '9894';
        accountPAR.Visiting_Address_Country__c = 'DK';
        accountPAR.Verified__c = 'Y';
        
        
        UTIL_TestFactory.setUpOrg();        
    }
    
    public static void init1() {    
        
        accountPAR  = new Account();
        accountPAR  = UTIL_TestFactory.createAccount();
        accountPAR.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        accountPAR.Work_Site_Registration_Number__c = '88798';
        accountPAR.Postal_Address_House_Number__c = '67';
        accountPAR.Postal_Address_PO_Box__c = '7876';
        accountPAR.Postal_Address_Street__c = 'dk';
        accountPAR.Postal_Address_City__c = 'Test City';
        accountPAR.Postal_Address_Country__c = 'DK';
        accountPAR.Postal_Address_Postal_Code__c = '9894';
        accountPAR.Visiting_Address_Street__c = 'dk';
        accountPAR.Visiting_Address_City__c = 'Test City';
        accountPAR.Visiting_Address_Postal_Code__c = '9894';
        accountPAR.External_Provider_Party_ID__c = '1254658569';
        accountPAR.Visiting_Address_Country__c  = 'DK';
        accountPAR.Verified__c = 'Y';
        
        UTIL_TestFactory.setUpOrg();
    }

    static testMethod void PARVerifyCreateDuplicateAccount() {
        
        // Use Case: for showing PAR Results for WS.
        
        // Arrange
        init();
        accountPAR.External_Provider_Party_ID__c = '1254658569';
        accountPAR.Verified__c = 'Y';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        // Act
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        ApexPages.currentPage().getParameters().put('strPARID', accountPAR.External_Provider_Party_ID__c);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount = accountPAR;
        parEnrich.recordTypeName = strRecordName;
        parEnrich.searchExternalProvider();
        
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.id);
//        System.assertEquals(strRecordName, parEnrich.recordTypeName);
        System.assertEquals(3, parEnrich.searchResults.size());
        System.assertEquals(parEnrich.theAccount.External_Provider_Party_ID__c, accountPAR.External_Provider_Party_ID__c);
    }

     
    static testMethod void PARVerifyPARIdEnrichWithLegalEntity() {
        
        // Use Case: When the PAR Id is not existing then we need to Enrich the Account and create Contacts
        
        // Arrange
        
        init();
        Account accountPARParent = new Account();
        accountPARParent = UTIL_TestFactory.createAccount();
        accountPARParent.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        accountPARParent.Work_Site_Registration_Number__c   = '88798';
        accountPARParent.Postal_Address_House_Number__c = '67';
        accountPARParent.Postal_Address_PO_Box__c = '7876';
        accountPARParent.Postal_Address_Street__c = 'dk';
        accountPARParent.Postal_Address_City__c = 'Test City';
        accountPARParent.Postal_Address_Country__c = 'DK';
        accountPARParent.Postal_Address_Postal_Code__c = '9894';
        accountPARParent.Visiting_Address_Street__c = 'dk';
        accountPARParent.Visiting_Address_City__c = 'Test City';
        accountPARParent.Visiting_Address_Postal_Code__c = '9894';
        accountPARParent.Visiting_Address_Country__c = 'DK';
        insert accountPARParent;
       
        accountPAR.Work_Site_Registration_Number__c = null;
        accountPAR.ParentId = accountPARParent.Id;
        //accountPAR.External_Provider_Party_ID__c = '1254658569';
        accountPAR.Verified__c = 'N';
        accountPAR.Work_Site_Type__c = 'BR';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        // Act
        Test.startTest();
              
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        ApexPages.currentPage().getParameters().put('strPARID', '1254658569');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount = accountPAR;
        parEnrich.recordTypeName = strRecordName;
        parEnrich.searchExternalProvider();
        
        System.assertEquals(3, parEnrich.searchResults.size());        
        parEnrich.selectedExternalId = parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c;
        parEnrich.enrichCustomerRecord();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.id);
//        System.assertEquals(strRecordName, parEnrich.recordTypeName);
        
        System.assertEquals(parEnrich.theAccount.External_Provider_Party_ID__c, accountPAR.External_Provider_Party_ID__c);
    }
    
    static testMethod void PARVerifyPARIdEnrichNoLegalEntityEnrich() {
        
        // Use Case: when no legal entity exists for WS and WS is enriched, create the LE with PAR data
        
        // Arrange
        init();    
        accountPAR.Work_Site_Registration_Number__c = null;
        accountPAR.Work_Site_Type__c = 'Head Office';
        accountPAR.Verified__c = 'N';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        // Act
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount = accountPAR;
        parEnrich.recordTypeName = strRecordName;
        system.assertEquals(true,parEnrich.noErrors);
        parEnrich.searchExternalProvider();
        system.assertEquals(true,parEnrich.noErrors);
        System.assertEquals(3, parEnrich.searchResults.size());        
        parEnrich.selectedExternalId = parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c;
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);
        system.assertEquals(1, [select count() from Account]);
        system.assertEquals(true,parEnrich.noErrors);
        parEnrich.enrichCustomerRecord();
        system.assertEquals(true,parEnrich.noErrors);
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);

        system.assertEquals(2, [select count() from Account], 'Expected a Legal entity to be created beyond the enriching of the WS');
        Account acc = [select External_Provider_Party_ID__c, Visiting_Address_City__c, id From Account Where id = :accountPAR.Id];
        Account accLE = [select External_Provider_Party_ID__c, Visiting_Address_City__c, id From Account Where recordtypeid = :UTIL_Meta.getAccountLegalEntityRT()];

        system.assertEquals(parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c, acc.External_Provider_Party_ID__c, accLE);
        system.assertEquals(parEnrich.searchResults[0].theAccount.Visiting_Address_City__c, accLE.Visiting_Address_City__c);
        system.assertEquals(parEnrich.searchResults[0].theAccount.Visiting_Address_City__c, acc.Visiting_Address_City__c);
    }

    static testMethod void PARVerifyPARIdEnrichNoLegalEntityEnrichCountryChange() {
        
        // Use Case: when no legal entity exists for WS and WS is enriched, create the LE with PAR data
        
        // Arrange
        init();    
        accountPAR.Work_Site_Registration_Number__c = null;
        accountPAR.Work_Site_Type__c = 'Head Office';
        accountPAR.Verified__c = 'N';
        accountPAR.Registration_Country__c = 'GB';
        accountPAR.Postal_Address_Country__c = 'GB';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        // Act
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount = accountPAR;
        parEnrich.recordTypeName = strRecordName;
        system.assertEquals(true,parEnrich.noErrors);
        parEnrich.searchExternalProvider();
        system.assertEquals(true,parEnrich.noErrors);
        System.assertEquals(3, parEnrich.searchResults.size());        
        parEnrich.selectedExternalId = parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c;
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);
        system.assertEquals(1, [select count() from Account]);
        system.assertEquals(true,parEnrich.noErrors);
        parEnrich.enrichCustomerRecord();
        system.assertEquals(true,parEnrich.noErrors);
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);

        system.assertEquals(2, [select count() from Account], 'Expected a Legal entity to be created beyond the enriching of the WS');
        Account acc = [select External_Provider_Party_ID__c, Visiting_Address_City__c, id From Account Where id = :accountPAR.Id];
        Account accLE = [select External_Provider_Party_ID__c, Visiting_Address_City__c, id From Account Where recordtypeid = :UTIL_Meta.getAccountLegalEntityRT()];

        system.assertEquals(parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c, acc.External_Provider_Party_ID__c, accLE);
        system.assertEquals(parEnrich.searchResults[0].theAccount.Visiting_Address_City__c, accLE.Visiting_Address_City__c);
        system.assertEquals(parEnrich.searchResults[0].theAccount.Visiting_Address_City__c, acc.Visiting_Address_City__c);
    }
    
    static testMethod void PARVerifyPARIdEnrichNoneHQNoLegalEntityEnrich() {
        
        // Use Case: when no legal entity exists for WS and WS is enriched, create the LE with PAR data
        
        // Arrange
        init();    
        accountPAR.Work_Site_Registration_Number__c = null;
        accountPAR.Work_Site_Type__c = 'Head Office';
        accountPAR.Verified__c = 'N';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        // Act
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount = accountPAR;
        parEnrich.recordTypeName = strRecordName;
        system.assertEquals(true,parEnrich.noErrors);
        parEnrich.searchExternalProvider();
        system.assertEquals(true,parEnrich.noErrors);
        System.assertEquals(3, parEnrich.searchResults.size());  
        integer j = 0;
        for(integer i = 0; i < parEnrich.searchResults.size(); i++){
            if(parEnrich.searchResults[i].theAccount.Work_Site_Name__c == 'PARTestWSCompany3'){
                system.debug(logginglevel.info,'===> selected external: ' + parEnrich.searchResults[i].theAccount.External_Provider_Party_ID__c);
                parEnrich.selectedExternalId = parEnrich.searchResults[i].theAccount.External_Provider_Party_ID__c;     
                j = i;
            }
        }
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);
        system.assertEquals(1, [select count() from Account]);
        system.assertEquals(true,parEnrich.noErrors);
        parEnrich.enrichCustomerRecord();
        system.assertEquals(true,parEnrich.noErrors);
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);

        system.assertEquals(3, [select count() from Account], 'Expected a Legal entity to be created beyond the enriching of the WS');
        Account acc = [select External_Provider_Party_ID__c, Visiting_Address_City__c, Work_Site_Type__c, id From Account Where id = :accountPAR.Id];
        Account accLE = [select External_Provider_Party_ID__c, Visiting_Address_City__c, id From Account Where recordtypeid = :UTIL_Meta.getAccountLegalEntityRT()];

        system.assertEquals('TY20', acc.Work_Site_Type__c, accLE);

        system.assertEquals(parEnrich.searchResults[j].theAccount.External_Provider_Party_ID__c, acc.External_Provider_Party_ID__c, parEnrich.searchResults + ' ' + j);
        system.assertEquals(parEnrich.searchResults[j].theAccount.Visiting_Address_City__c, accLE.Visiting_Address_City__c);
        system.assertEquals(parEnrich.searchResults[j].theAccount.Visiting_Address_City__c, acc.Visiting_Address_City__c);
    }
        
    static testMethod void PARVerifyPARIdEnrichNoLegalEntityFromSFDC() {
        
        // Use Case: When the PAR Id is not existing then we need to Enrich the Account and create contacts 
        
        // Arrange
        init();
        Account accountPARParent = new Account();
        accountPARParent = UTIL_TestFactory.createAccount();
        accountPARParent.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        accountPARParent.Work_Site_Registration_Number__c   = '88798';
        accountPARParent.Postal_Address_House_Number__c = '67';
        accountPARParent.Postal_Address_PO_Box__c = '7876';
        accountPARParent.Postal_Address_Street__c = 'dk';
        accountPARParent.Postal_Address_City__c = 'Test City';
        accountPARParent.Postal_Address_Country__c = 'DK';
        accountPARParent.Postal_Address_Postal_Code__c = '9894';
        accountPARParent.Visiting_Address_Street__c = 'dk';
        accountPARParent.Visiting_Address_City__c = 'Test City';
        accountPARParent.Visiting_Address_Postal_Code__c = '9894';
        accountPARParent.Visiting_Address_Country__c = 'DK';
        insert accountPARParent;
        
        accountPAR.Work_Site_Registration_Number__c = null;
        accountPAR.Verified__c = 'N';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        // Act
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        ApexPages.currentPage().getParameters().put('strPARID', 'NO200412983');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount = accountPAR;
        parEnrich.recordTypeName = strRecordName;
        parEnrich.searchExternalProvider();
        System.assertEquals(3, parEnrich.searchResults.size());        
        parEnrich.selectedExternalId = parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c;
        parEnrich.enrichCustomerRecord();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);

        system.assertEquals(3, [select count() from Account], 'Expected a Legal entity to be created beyond the enriching of the WS');
        Account acc = [select parentid,Postal_Address_Street__c,Postal_Address_City__c,Postal_Address_Country__c,Postal_Address_Postal_Code__c, External_Provider_Party_ID__c, Visiting_Address_City__c, id From Account Where recordtypeid = :UTIL_Meta.getAccountWorkSiteRT()];
        system.assertNotEquals(accountPARParent.id, acc.parentid);

        system.assertEquals(parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c, acc.External_Provider_Party_ID__c);
        system.assertEquals(parEnrich.searchResults[0].theAccount.Visiting_Address_City__c, acc.Visiting_Address_City__c);
        
         String theAddr = '';
         if (acc!=null)
         {
            theAddr += UTIL_Apex.isSet(acc.Postal_Address_Street__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(acc.Postal_Address_Street__c) : '';
            theAddr += UTIL_Apex.isSet(acc.Postal_Address_Postal_Code__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(acc.Postal_Address_Postal_Code__c) : '';
            theAddr += UTIL_Apex.isSet(acc.Postal_Address_City__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(acc.Postal_Address_City__c) : '';
            theAddr += UTIL_Apex.isSet(acc.Postal_Address_Country__c) ? (theAddr!='' ? ', ' : '' ) + UTIL_Apex.getStr(acc.Postal_Address_Country__c) : '';
         }
        system.assertEquals(theAddr, parEnrich.searchResults[0].address);
    }
    
    static testMethod void PARPagination(){
        
        // Use Case: To test Pagination
        
        // Arrange
        init();
        accountPAR.External_Provider_Party_ID__c    = '1254658569';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        // Act
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        ApexPages.currentPage().getParameters().put('strPARID', accountPAR.External_Provider_Party_ID__c);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount.Id = accountPAR.Id;
        parEnrich.recordTypeName = strRecordName;
        parEnrich.searchExternalProvider();
        parEnrich.searchResultsPagination.first();
        parEnrich.searchResultsPagination.last();
        parEnrich.searchResultsPagination.next();
        parEnrich.searchResultsPagination.previous();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);
//        System.assertEquals(strRecordName, parEnrich.recordTypeName);
        System.assertEquals(parEnrich.theAccount.External_Provider_Party_ID__c, accountPAR.External_Provider_Party_ID__c);
    }
    /*
    static testMethod void PARCompareTo(){
        init();
        Account accountPARParent = new Account();
        accountPARParent = UTIL_TestFactory.createAccount();
        accountPARParent.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
        accountPARParent.Work_Site_Registration_Number__c   = '88798';
        accountPARParent.Postal_Address_House_Number__c = '67';
        accountPARParent.Postal_Address_PO_Box__c = '7876';
        accountPARParent.Postal_Address_Street__c = 'dk';
        accountPARParent.Postal_Address_City__c = 'Test City';
        accountPARParent.Postal_Address_Country__c = 'DK';
        accountPARParent.Postal_Address_Postal_Code__c = '9894';
        accountPARParent.Visiting_Address_Street__c = 'dk';
        accountPARParent.Visiting_Address_City__c = 'Test City';
        accountPARParent.Visiting_Address_Postal_Code__c = '9894';
        accountPARParent.Visiting_Address_Country__c = 'DK';
        insert accountPARParent;
        
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        G2O_CustomerSearch_Enrich_VFCx.ResultWrapper rw = new G2O_CustomerSearch_Enrich_VFCx(accountPARParent);
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        
        parEnrich.compareTo(rw);
    }*/
    
    
    static testMethod void myUnitTestShowLEPARVerifyProcess() {
        
        // Use Case: Get PAR Results for LE
        
        // Arrange
        init1();
        accountPAR.External_Provider_Party_ID__c    = '1254658569';
        insert accountPAR;
        String strRecordName = [Select Name from RecordType where Id=: accountPAR.RecordTypeId limit 1].Name;
        
        StaticResourceCalloutMock successfulMock = new StaticResourceCalloutMock();
        successfulMock.setStaticResource('TestMockResponsPAR_CustomerSearch');
        successfulMock.setStatusCode(200);
        successfulMock.setHeader('Content-Type', 'text/xml');
        Test.setMock(HttpCalloutMock.class, successfulMock);
        
        // Act
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('strRecordTypeId', accountPAR.RecordTypeId);
        ApexPages.currentPage().getParameters().put('id', accountPAR.Id);
        ApexPages.currentPage().getParameters().put('strRecordTypeName', strRecordName);
        ApexPages.currentPage().getParameters().put('strPARID', accountPAR.External_Provider_Party_ID__c);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(accountPAR); 
        G2O_CustomerSearch_Enrich_VFCx parEnrich = new G2O_CustomerSearch_Enrich_VFCx(controller);
        parEnrich.theAccount = accountPAR;
        parEnrich.recordTypeName = strRecordName;
        parEnrich.searchExternalProvider();
        parEnrich.selectedExternalId = parEnrich.searchResults[0].theAccount.External_Provider_Party_ID__c;
        parEnrich.enrichCustomerRecord();
        
        Test.stopTest();
        
        //Assert
        System.assertEquals(accountPAR.Id, parEnrich.theAccount.Id);
//        System.assertEquals(strRecordName, parEnrich.recordTypeName);
        System.assertEquals(parEnrich.theAccount.External_Provider_Party_ID__c, accountPAR.External_Provider_Party_ID__c);
    }
}