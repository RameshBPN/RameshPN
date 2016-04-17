/**
    About
    -----
    Description: This class is used to test that the field values are correctly formatted
    
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: September 2013
    
    Details
    -------
    
    /-- ACCOUNT --/ 
    SE - Validation of workflow reformatting Postal Address Postal Code (xxxxx -> xxx xx)
    SE - Validation of workflow reformatting Visiting Address Postal Code (xxxxx -> xxx xx)
    SE - Validation of the Swedish Postal Address Postal Code
    SE - Validation of the Visiting Address Postal Code
    
    DK - Corporate Registration Number checksum validation
    SE - Corporate Registration Number checksum validation
    NO - Corporate Registration Number checksum validation

    DK - VAT Number checksum validation
    SE - VAT Number checksum validation
    FI - VAT Number checksum validation
    
    /-- BANK DETAILS --/
    
    FI - Bank Account Number checksum validation
    
    Update History
    --------------
    Created Sept 2013 - T.R.

 */
@isTest
private class G2O_UseCase_FieldValuesFormatting_TEST {
    
    //SE - Validation of workflow reformatting Postal Address Postal Code (xxxxx -> xxx xx)
    static testMethod void PostalAddressPostalCodeReformattingSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_Postal_Code__c SEPostalCode = new Swedish_Postal_Code__c();
        SEPostalCode.Name = '120 61';
        SEPostalCode.City__c = 'STOCKHOLM';
        SEPostalCode.Postal_Address_Country__c = 'SE';
        insert SEPostalCode;
        
        Swedish_City__c SECity = new Swedish_City__c();
        SECity.Name = 'Stockholm';
        SECity.Country__c = 'SE';
        insert SECity;
        
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Corporate_Registration_Number__c = '';
            account.Registration_Country__c = 'SE';
            account.Postal_Address_Country__c = 'SE';
            account.Postal_Address_Street__c = 'Test street';
            account.Postal_Address_City__c = 'Stockholm';
            accounts.add(account);
        }
        accounts[0].Postal_Address_Postal_Code__c = '12061';
        accounts[1].Postal_Address_Postal_Code__c = '1 2061';
        
        //Act
        insert accounts;
        
        //Assert
        for (Account a: [SELECT Id, Postal_Address_Postal_Code__c FROM Account WHERE Id IN: accounts]) {
            System.assertEquals(SEPostalCode.Name, a.Postal_Address_Postal_Code__c);
        }
    }
    
    //SE - Validation of the swedish Postal Address Postal Code
    static testMethod void PostalAddressPostalCodePositiveTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_Postal_Code__c SEPostalCode = new Swedish_Postal_Code__c();
        SEPostalCode.Name = '120 61';
        SEPostalCode.City__c = 'STOCKHOLM';
        SEPostalCode.Postal_Address_Country__c = 'SE';
        insert SEPostalCode;
        
        Swedish_City__c swedishCity = new Swedish_City__c();
        swedishCity.Name = 'Stockholm';
        swedishCity.Country__c = 'SE';
        insert swedishCity;
        
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Corporate_Registration_Number__c = '';
            account.Registration_Country__c = 'SE';
            account.Postal_Address_Country__c = 'SE';
            account.Postal_Address_Street__c = 'Test street';
            account.Postal_Address_City__c = 'Stockholm';
            accounts.add(account);
        }
        accounts[0].Postal_Address_Postal_Code__c = '12061';
        accounts[1].Postal_Address_Postal_Code__c = '120 61';
        accounts[2].Postal_Address_Postal_Code__c = '12 061';
        
        //Act
        insert accounts;
        
        //Assert
        for (Account a: [SELECT Id, Postal_Address_Postal_Code__c FROM Account WHERE Id IN :accounts]) {
            System.assertEquals(SEPostalCode.Name, a.Postal_Address_Postal_Code__c);
        }
    }
    
    static testMethod void PostalAddressPostalCodeNegativeTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_Postal_Code__c SEPostalCode = new Swedish_Postal_Code__c();
        SEPostalCode.Name = '120 61';
        SEPostalCode.City__c = 'STOCKHOLM';
        SEPostalCode.Postal_Address_Country__c = 'SE';
        insert SEPostalCode;
        
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 4; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'SE';
            account.Postal_Address_Country__c = 'SE';
            account.Postal_Address_Street__c = 'Test street';
            account.Postal_Address_City__c = 'Stockholm';
            accounts.add(account);
        }
        accounts[0].Postal_Address_Postal_Code__c = '1206';
        accounts[1].Postal_Address_Postal_Code__c = '1205611';
        accounts[2].Postal_Address_Postal_Code__c = '98765';
        accounts[3].Postal_Address_Postal_Code__c = '120610';
        
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
                    //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account WHERE Id IN : accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //SE - Validation of workflow reformatting Visiting Address Postal Code (xxxxx -> xxx xx)
    static testMethod void VisitingAddressPostalCodeReformattingSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_Postal_Code__c SEPostalCode = new Swedish_Postal_Code__c();
        SEPostalCode.Name = '120 61';
        SEPostalCode.City__c = 'Stockholm';
        SEPostalCode.Postal_Address_Country__c = 'SE';
        insert SEPostalCode;
        
        Swedish_City__c swedishCity = new Swedish_City__c();
        swedishCity.Name = 'Stockholm';
        swedishCity.Country__c = 'SE';
        insert swedishCity;
        
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Visiting_Address_Country__c = 'SE';
            account.Visiting_Address_Street__c = 'Test street';
            account.Visiting_Address_City__c = 'Stockholm';
            accounts.add(account);
        }
        accounts[0].Visiting_Address_Postal_Code__c = '12061';
        accounts[1].Visiting_Address_Postal_Code__c = '12 061';
        
        //Act
        insert accounts;
        
        //Assert
        for (Account a: [SELECT Id, Visiting_Address_Postal_Code__c FROM Account WHERE Id IN: accounts]) {
            System.assertEquals(SEPostalCode.Name, a.Visiting_Address_Postal_Code__c);
        }
    }
    
    //SE - Validation of the swedish Postal Address Postal Code
    static testMethod void VisitingAddressPostalCodePositiveTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_Postal_Code__c SEPostalCode = new Swedish_Postal_Code__c();
        SEPostalCode.Name = '120 61';
        SEPostalCode.City__c = 'Stockholm';
        SEPostalCode.Postal_Address_Country__c = 'SE';
        insert SEPostalCode;
        
        Swedish_City__c swedishCity = new Swedish_City__c();
        swedishCity.Name = 'Stockholm';
        swedishCity.Country__c = 'SE';
        insert swedishCity;
        
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Visiting_Address_Country__c = 'SE';
            account.Visiting_Address_Street__c = 'Test street';
            account.Visiting_Address_City__c = 'Stockholm';
            accounts.add(account);
        }
        accounts[0].Visiting_Address_Postal_Code__c = '12061';
        accounts[1].Visiting_Address_Postal_Code__c = '120 61';
        accounts[2].Visiting_Address_Postal_Code__c = '12 061';
        
        //Act
        insert accounts;
        
        //Assert
        for (Account a: [SELECT Id, Visiting_Address_Postal_Code__c FROM Account WHERE Id IN :accounts]) {
            System.assertEquals(SEPostalCode.Name, a.Visiting_Address_Postal_Code__c);
        }
    }
    
    static testMethod void VisitingAddressPostalCodeNegativeTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_Postal_Code__c SEPostalCode = new Swedish_Postal_Code__c();
        SEPostalCode.Name = '120 61';
        SEPostalCode.City__c = 'STOCKHOLM';
        SEPostalCode.Postal_Address_Country__c = 'SE';
        insert SEPostalCode;
        
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 4; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Visiting_Address_Country__c = 'SE';
            account.Visiting_Address_Street__c = 'Test street';
            account.Visiting_Address_City__c = 'Stockholm';
            accounts.add(account);
        }
        accounts[0].Visiting_Address_Postal_Code__c = '1206';
        accounts[1].Visiting_Address_Postal_Code__c = '1205611';
        accounts[2].Visiting_Address_Postal_Code__c = '98765';
        accounts[3].Visiting_Address_Postal_Code__c = '120610';
        
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
                    //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account WHERE Id IN : accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //DK - Corporate Registration Number checksum validation
    static testMethod void CorpRegNrPositiveTestCasesDK() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> validDKCorpRegNrs = new List<String> {
            '11554474',
            '14406042',
            '17913387',
            '28924879',
            '30667220',
            '33359586',
            '34943400',
            '35200150',
            '71352951',
            '82883711'
        };

        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'DK';
            account.Corporate_Registration_Number__c = validDKCorpRegNrs[i];
            accounts.add(account);
        }
        
        //Act
        insert accounts;
        
        //Assert
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        for (Integer i = 0; i < insertedAccounts.size(); i++) {
            System.assertNotEquals(insertedAccounts[i].Id, null);
        }
    }
    
    static testMethod void CorpRegNrNegativeTestCasesDK() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> invalidDKCorpRegNrs = new List<String> {
            '11554478',
            '14406046',
            '17913381',
            '28924873',
            '30667224',
            '33359580',
            '34943403',
            '35200152',
            '71352955',
            '82883719'
        };

        List <Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'DK';
            account.Corporate_Registration_Number__c = invalidDKCorpRegNrs[i];
            accounts.add(account);
        }
        
        //The Act - Assert is done for all of the Accounts here. It is done one by one since the exception on the first account would stop the batch and the other accounts would be ignored.
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
            //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //SE - Corporate Registration Number checksum validation
    static testMethod void CorpRegNrPositiveTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_City__c swedishCity = new Swedish_City__c();
        swedishCity.Name = 'Stockholm';
        swedishCity.Country__c = 'SE';
        insert swedishCity;
        
        List<String> validSECorpRegNrs = new List<String> {
            '5560642554',
            '5560605809',
            '5560142720',
            '5561286559',
            '5560923053',
            '1212121212',
            '0101013761',
            '8512024616',
            '1212129256',
            '9912318970'
        };

        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Postal_Address_City__c = 'Stockholm';
            account.Registration_Country__c = 'SE';
            account.Postal_Address_Country__c = 'SE';
            account.Postal_Address_Postal_Code__c = '';
            account.Postal_Address_Street__c = '';
            account.Corporate_Registration_Number__c = validSECorpRegNrs[i];
            accounts.add(account);
        }
        
        //Act
        insert accounts;
        
        //Assert
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        for (Integer i = 0; i < insertedAccounts.size(); i++) {
            System.assertNotEquals(insertedAccounts[i].Id, null);
        }
    }
    
    static testMethod void CorpRegNrNegativeTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> invalidSECorpRegNrs = new List<String> {
            '5560642557',
            '5560605803',
            '5560142721',
            '5561286553',
            '5560923058',
            '1212121219',
            '0101013764',
            '8512024615',
            '1212129251',
            '9912318977'
        };

        List <Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'SE';
            account.Corporate_Registration_Number__c = invalidSECorpRegNrs[i];
            accounts.add(account);
        }
        
        //The Act - Assert is done for all of the Accounts here. It is done one by one since the exception on the first account would stop the batch and the other accounts would be ignored.
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
            //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //5. NO - Corporate Registration Number checksum validation
    static testMethod void CorpRegNrPositiveTestCasesNO() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> validNOCorpRegNrs = new List<String> {
            '914787521',
            '911831392',
            '987838906',
            '943574537',
            '982771064',
            '995590271',
            '994498436',
            '984661185',
            '971130776',
            '966058102'
        };

        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'NO';
            account.Postal_Address_Country__c = 'NO';
            account.Corporate_Registration_Number__c = validNOCorpRegNrs[i];
            accounts.add(account);
        }
        
        //Act
        insert accounts;
        
        //Assert
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        for (Integer i = 0; i < insertedAccounts.size(); i++) {
            System.assertNotEquals(insertedAccounts[i].Id, null);
        }
    }
    
    static testMethod void CorpRegNrNegativeTestCasesNO() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> invalidNOCorpRegNrs = new List<String> {
            '914787524',
            '911831396',
            '987838902',
            '943574538',
            '982771060',
            '995590277',
            '994498432',
            '984661189',
            '971130774',
            '966058100'
        };

        List <Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'NO';
            account.Corporate_Registration_Number__c = invalidNOCorpRegNrs[i];
            accounts.add(account);
        }
        
        //The Act - Assert is done for all of the Accounts here. It is done one by one since the exception on the first account would stop the batch and the other accounts would be ignored.
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
            //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //DK - VAT Number checksum validation
    static testMethod void VATNrPositiveTestCasesDK() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> validDKVATNrs = new List<String> {
            'DK11554474',
            'DK14406042',
            'DK17913387',
            'DK28924879',
            'DK30667220',
            'DK33359586',
            'DK34943400',
            'DK35200150',
            'DK71352951',
            'DK82883711'
        };

        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'DK';
            account.VAT_Number__c = validDKVATNrs[i];
            accounts.add(account);
        }
        
        //Act
        insert accounts;
        
        //Assert
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        for (Integer i = 0; i < insertedAccounts.size(); i++) {
            System.assertNotEquals(insertedAccounts[i].Id, null);
        }
    }
    
    static testMethod void VATNrNegativeTestCasesDK() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> invalidDKVATNrs = new List<String> {
            'DK11554478',
            'DK14406046',
            'DK17913381',
            'DK28924873',
            'DK30667224',
            'DK33359580',
            'DK34943403',
            'DK35200152',
            'DK71352955',
            'DK82883719'
        };

        List <Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'DK';
            account.VAT_Number__c = invalidDKVATNrs[i];
            accounts.add(account);
        }
        
        //The Act - Assert is done for all of the Accounts here. It is done one by one since the exception on the first account would stop the batch and the other accounts would be ignored.
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
            //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //SE - VAT Number checksum validation
    static testMethod void VATNrPositiveTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        Swedish_City__c swedishCity = new Swedish_City__c();
        swedishCity.Name = 'Stockholm';
        swedishCity.Country__c = 'SE';
        insert swedishCity;
        
        List<String> validSEVATNrs = new List<String> {
            'SE556064255401',
            'SE556060580902',
            'SE556014272003',
            'SE556128655904',
            'SE556092305305',
            'SE121212121206',
            'SE010101376107',
            'SE851202461608',
            'SE121212925609',
            'SE991231897004'
        };

        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Postal_Address_Street__c = '';
            account.Postal_Address_Postal_Code__c = '';
            account.Postal_Address_City__c = 'Stockholm';
            account.Postal_Address_Country__c = 'SE';
            account.Registration_Country__c = 'SE';
            account.Corporate_Registration_Number__c = '';
            account.VAT_Number__c = validSEVATNrs[i];
            accounts.add(account);
        }
        
        //Act
        insert accounts;
        
        //Assert
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        for (Integer i = 0; i < insertedAccounts.size(); i++) {
            System.assertNotEquals(insertedAccounts[i].Id, null);
        }
    }
    
    static testMethod void VATNrNegativeTestCasesSE() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> invalidSEVATNrs = new List<String> {
            'SE991231897000',
            'SE556014272099',
            'SE556014272104',
            'SE556128655356',
            'SE556092305854',
            'SE121212121923',
            'SE010101376470',
            'SE851202461501',
            'SE121212925102',
            'SE991231897703'
        };

        List <Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'SE';
            account.VAT_Number__c = invalidSEVATNrs[i];
            accounts.add(account);
        }
        
        //The Act - Assert is done for all of the Accounts here. It is done one by one since the exception on the first account would stop the batch and the other accounts would be ignored.
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
            //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //FI - VAT Number checksum validation
    static testMethod void VATNrPositiveTestCasesFI() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> validFIVATNrs = new List<String> {
            'FI02425651',
            'FI02025949',
            'FI02351058',
            'FI01198995',
            'FI01189714',
            'FI02171372',
            'FI02355374',
            'FI02217975',
            'FI02343234',
            'FI18838549'
        };

        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'FI';
            account.Postal_Address_Country__c = 'FI';
            account.Postal_Address_Postal_Code__c = '';
            account.Postal_Address_Street__c = '';
            account.VAT_Number__c = validFIVATNrs[i];
            accounts.add(account);
        }
        
        //Act
        insert accounts;
        
        //Assert
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        for (Integer i = 0; i < insertedAccounts.size(); i++) {
            System.assertNotEquals(insertedAccounts[i].Id, null);
        }
    }
    
    static testMethod void VATNrNegativeTestCasesFI() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> invalidFIVATNrs = new List<String> {
            'FI02425655',
            'FI02025945',
            'FI02351052',
            'FI01198992',
            'FI01189719',
            'FI02171379',
            'FI02355378',
            'FI02217978',
            'FI02343232',
            'FI18838543'
        };

        List <Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 10; i++) {
            Account account = UTIL_TestFactory.createAccount();
            account.Registration_Country__c = 'FI';
            account.VAT_Number__c = invalidFIVATNrs[i];
            accounts.add(account);
        }
        
        //The Act - Assert is done for all of the Accounts here. It is done one by one since the exception on the first account would stop the batch and the other accounts would be ignored.
        //Act
        for (Integer i = 0; i < accounts.size(); i++) {
            try {
                insert accounts[i];
            }
            //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Account> insertedAccounts = [SELECT Id FROM Account Where Id IN: accounts];
        System.assertEquals(0, insertedAccounts.size());
    }
    
    //FI - Bank Account Number checksum validation
    static testMethod void BankAccountNrPositiveTestCasesFI() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> validFIBankAccountNumbers = new List<String> {
            '423432123456126',
            '80001416243',
            '55780420057243',
            '15723000308593',
            '3131301137553',
            '123432123456757',
            '423432123456753',
            '120030014209',
            '15715200020952',
            '16603000000540'
        };
        
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Bank_Key__c  bankKey = UTIL_TestFactory.createBankKey();
        bankKey.Country__c = 'FI';
        insert bankKey;

        List<Bank_Details__c> bankDetails = new List<Bank_Details__c>();
        for (Integer i = 0; i < 10; i++) {
            Bank_Details__c bankDetail = new Bank_Details__c();
            bankDetail.Account__c = account.Id;
            bankDetail.Bank_Country__c = bankKey.Country__c;
            bankDetail.Bank_Account__c = validFIBankAccountNumbers[i];
            bankDetail.Bank_Key__c = bankKey.Id;
            bankDetails.add(bankDetail);
        }
        
        //Act
        insert bankDetails;
        
        //Assert
        List<Bank_Details__c> insertedBankDetails = [SELECT Id FROM Bank_Details__c Where Id IN: bankDetails];
        for (Integer i = 0; i < insertedBankDetails.size(); i++) {
            System.assertNotEquals(insertedBankDetails[i].Id, null);
        }
    }
    
    static testMethod void BankAccountNrNegativeTestCasesFI() {
        //Arrange
        UTIL_TestFactory.createGet2OneCrm();
        
        List<String> invalidFIBankAccountNumbers = new List<String> {
            '80001670570362',
            '80001416246',
            '80001500010290',
            '15723000308598',
            '3131301137557',
            '18203000006500',
            '16303000011505',
            '120030014202',
            '15715200020958',
            '16603000000546'
        };
        
        Account account = UTIL_TestFactory.createAccount();
        insert account;
        
        Bank_Key__c  bankKey = UTIL_TestFactory.createBankKey();
        insert bankKey;
        
        List<Bank_Details__c> bankDetails = new List<Bank_Details__c>();
        for (Integer i = 0; i < 10; i++) {
            Bank_Details__c bankDetail = new Bank_Details__c();
            bankDetail.Account__c = account.Id;
            bankDetail.Bank_Country__c = 'FI';
            bankDetail.Bank_Account__c = invalidFIBankAccountNumbers[i];
            bankDetail.Bank_Key__c = bankKey.Id;
            bankDetails.add(bankDetail);
        }
        
        //The Act - Assert is done for all of the Bank Details. It is done one by one since the exception on the first account would stop the batch and the other accounts would be ignored.
        //Act
        for (Integer i = 0; i < bankDetails.size(); i++) {
            try {
                insert bankDetails[i];
            }
            //Assert
            catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                     e.getDmlStatusCode(0));
            }
        }
        
        List<Bank_Details__c> insertedBankDetails = [SELECT Id FROM Bank_Details__c Where Id IN: bankDetails];
        System.assertEquals(0, insertedBankDetails.size());
    }
}