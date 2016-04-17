/**
    About
    -----
    Description: This class is used to test PossibleDuplicateAccount_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details
    -------
    This Class test the functionality of PossibleDuplicateAccount_SVC class.
    1.  Test createPossibleDuplicateRecords functionality/method of PossibleDuplicateAccount_SVC class.

    Update History
    --------------
    Created May 2013 - A.B.
    
    Issues / TODOs
    --------------
    
*/
@isTest
private class G2O_PossibleDuplicateAccount_SVC_TEST {
    
    //A.T.T.R.I.B.U.T.E.S
    static Map<Id,Set<Id>> accIdToLstDupeAccIdMap = new Map<Id,Set<Id>>();
    static List<Account> lstWorksiteAcc = new List<Account>();
    static Id wrkrTypeId;
    static PossibleDuplicateAccount__c testPossDuplicate1;
    static ScheduledJobParameters__c scheduledParameters;
    //A.T.T.R.I.B.U.T.E.S
    
    //1. Test createPossibleDuplicateRecords functionality/method of PossibleDuplicateAccount_SVC class.
    static testMethod void testCreatePossibleDupRecords(){
        
        Set<Id> accIdSet0 = new Set<Id>();
        Set<Id> accIdSet1 = new Set<Id>();
        Set<Id> accIdSet2 = new Set<Id>();
        Set<Id> accIdSet3 = new Set<Id>();
        Set<Id> accIdSet4 = new Set<Id>();      //holds AccountIds.
        
        //Arrange
        UTIL_TestFactory.setUpOrg();
        CreateTestData();
        //scheduledParameters.NextRunAccountDuplicateCheck__c = G2O_PossibleDuplicateAccount_SVC.PAR;
        update scheduledParameters;
        
        for(integer i=4; i<lstWorksiteAcc.size();i++){
            if(i!=4){
                accIdSet4.add(lstWorksiteAcc[i].Id); //Contains total of 9 accounts.
            }
        }
        accIdSet0.add(lstWorksiteAcc[1].Id);
        accIdSet1.add(lstWorksiteAcc[0].Id);
        accIdSet2.add(lstWorksiteAcc[3].Id);
        accIdSet3.add(lstWorksiteAcc[2].Id);
        
        //1. key-value pair of the Map at Index 0 & 1 are of the parttern AB & BA.Duplicates.Also for this combination already possibleduplicate record exists.
        //   No possible duplicate record should be created for this key value pair.
        
        //2. key-value pair of the Map at Index 2 & 3 are of the parttern YZ & ZY.Duplicates.No possibleduplicate record exists.
        //   One possible duplicate record should be created for this key value pair.
        
        //3. key-value pair of the Map at Index 4 is non Duplicate.No Duplicate record exists.
        //   Nine possible duplicate record should be created for this key value pair.
        
        //4. Therefore in total 1+194+1(existing)=196 possible duplicate record should be present in the end of procesing.
        
        accIdToLstDupeAccIdMap.put(lstWorksiteAcc[0].Id,accIdSet0);
        accIdToLstDupeAccIdMap.put(lstWorksiteAcc[1].Id,accIdSet1);
        accIdToLstDupeAccIdMap.put(lstWorksiteAcc[2].Id,accIdSet2);
        accIdToLstDupeAccIdMap.put(lstWorksiteAcc[3].Id,accIdSet3);
        accIdToLstDupeAccIdMap.put(lstWorksiteAcc[4].Id,accIdSet4);
        
        system.debug('+++++accIdToLstDupeAccIdMap+++'+accIdToLstDupeAccIdMap);
        //Act
        G2O_PossibleDuplicateAccount_SVC.getPossibleDuplicateRecords(accIdToLstDupeAccIdMap, G2O_PossibleDuplicateAccount_SVC.PAR);
        
        //Assert
        System.assertEquals(true,([Select External_Provider_Duplicate__c From Account  where Id =:lstWorksiteAcc[0].Id].External_Provider_Duplicate__c));
        System.assertEquals(true,([Select External_Provider_Duplicate__c From Account  where Id =:lstWorksiteAcc[1].Id].External_Provider_Duplicate__c));
        System.assertEquals(true,([Select External_Provider_Duplicate__c From Account  where Id =:lstWorksiteAcc[2].Id].External_Provider_Duplicate__c));
    
        //System.assertEquals('MOD Intressent Number;External provider party ID',([Select Id,Duplicate_reason__c From PossibleDuplicateAccount__c  where Possible_Duplicate_Account__c =:lstWorksiteAcc[1].Id AND Account__c =:lstWorksiteAcc[0].Id].Duplicate_reason__c));
        //System.assert([Select Id,Duplicate_reason__c From PossibleDuplicateAccount__c  where Possible_Duplicate_Account__c =:lstWorksiteAcc[1].Id AND Account__c =:lstWorksiteAcc[0].Id].Duplicate_reason__c.contains('MOD Intressent Number'));
        //System.assert([Select Id,Duplicate_reason__c From PossibleDuplicateAccount__c  where Possible_Duplicate_Account__c =:lstWorksiteAcc[1].Id AND Account__c =:lstWorksiteAcc[0].Id].Duplicate_reason__c.contains('External provider party ID'));
        
        //System.assertEquals(12,([Select count() From PossibleDuplicateAccount__c ]));
        System.assertEquals(199,([Select count() From Account  where External_Provider_Duplicate__c = true]));
        System.assertEquals(196,([Select count() From PossibleDuplicateAccount__c ]));
        System.assertEquals(199,([Select count() From Account  where External_Provider_Duplicate__c = true]));
    }
    
    
    //Creating test data.
    private static void CreateTestData(){
        
        //Getting the RecordTypeId.
        wrkrTypeId=UTIL_Meta.getAccountWorksiteRT();
        
        //Creating CustomSetting.
        scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        //scheduledParameters.Duplicate_reason_Batch__c = 'Other';
        //scheduledParameters.Duplicate_reason_MOD_Intressent_Nr__c = 'MOD Intressent Number';
        //scheduledParameters.Duplicate_reason_MOD_Modtager_Nr__c = 'MOD Modtager Number';
        //scheduledParameters.Duplicate_reason_PAR__c = 'External provider party ID';
        
        //Inserting accounts with RecordType as WorkSite
        /*lstWorksiteAcc=UTIL_TestFactory.createAccounts();
        for (Integer i = 0; i < lstWorksiteAcc.size(); i++) {
            lstWorksiteAcc[i].RecordTypeId = wrkrTypeId;
        }*/
        
        for (Integer i = 0; i < 199; i++) {
            Account acc = UTIL_TestFactory.createAccount();
            acc.Name='test'+i;
            acc.Short_Name__c = 'test'+i;
            acc.Postal_Address_City__c = 'test'+i;
            acc.Postal_Address_Country__c = 'test'+i;
            acc.Registration_Country__c = 'test'+i;
            acc.MOD_Modtager_Number__c = '12345678';
            acc.MOD_Interessent_Number__c = '87654321';
            acc.RecordTypeId = wrkrTypeId;
            lstWorksiteAcc.add(acc);
        }
        insert lstWorksiteAcc;
        
        //Inserting possible duplicate.
        //1. Account at Index 0 & 1 of lstWorksiteAcc exist as a Possible_Duplicate_Account__c record. 
        //2. If such combination sent for possible duplicate creation,then this Possible_Duplicate_Account__c record must update with Duplication Reason.
        testPossDuplicate1 = UTIL_TestFactory.createPossibleDuplicate();
        testPossDuplicate1.Account__c = lstWorksiteAcc[0].Id;
        testPossDuplicate1.Duplicate_reason__c ='MOD Intressent Number';
        testPossDuplicate1.Possible_Duplicate_Account__c =lstWorksiteAcc[1].Id;
        insert testPossDuplicate1;
    }
    

}