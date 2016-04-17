/**
    About
    -----
    Description: Test class for the Person Account Merge Functionality
    Created for: Postnord Get2OneCRM Master template/Summer updates
    Create date: 10th March 2015
    
    Details
    -------
    
    Update History
    --------------
    Created 2015 March: B. Shridhar
    Updated 2015 April: B. Shridhar - Added the Case 8 to verify the merge button access 

    TEST CASES
    ----------
    1. Verify the Search functionality with all vaild input details

    2. Verify the Search functionality with invaild/incomplete input details

    3. Verify the Merge Functionlaity for valid merge selection

    4. Verify the Merge Functionlaity for valid merge selection

    5. Verify the FlagforReview Functionlality for valid flag selection

    6. Verify the FlagforReview Functionlality for invalid flag selection
    
    7. Verify the Exit functionality.

    8. Verify the Access to Merge button 
*/

@IsTest 
public class G2O_PersonAccountMerge_VFCx_TEST{
    
    static List<G2O_PersonAccountMerge_VFCx.AccountWrapper> awList= new List<G2O_PersonAccountMerge_VFCx.AccountWrapper>();  
    static Account personAccount;
    static ApexPages.StandardController sC;
    static G2O_PersonAccountMerge_VFCx PP;
    Static User runninguser;
   
    //CASE 1
    static testMethod  void test_SearchFunctionality_Positive() {
        
        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();        
        
        personAccountMerge.search();        
        
        system.assertEquals(2, personAccountMerge.potentialDuplicates.size(), 'Invalid search result: '+ personAccountMerge.potentialDuplicates.size());
                                   
    }    

    //CASE 2
    static testMethod  void test_SearchFunctionality1_Negative() {
        
        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();        
              
        personAccount.FirstName = 't';
        personAccount.LastName = 'te';        
        personAccount.Postal_Address_Street__c = 'St';
        personAccount.Postal_Address_City__c = 't';
        update personAccount;
        
        sC = new ApexPages.standardController(personAccount);
        personAccountMerge = new G2O_PersonAccountMerge_VFCx(sC);
        
        personAccountMerge.search();
        
        system.assertEquals('- At least 2 characters are required for First Name field,- At least 3 characters are required for Last Name field,- At least 3 characters are required for Postal Address Street field,', personAccountMerge.criteriaValidationErrorMessage, 'Invalid search details : '+ personAccountMerge.criteriaValidationErrorMessage);  
        
    }   
   
    //CASE 3 
    static testMethod void test_MergeFunctionality_Positive() {    
        
        Boolean masterSelected = false;   
        
        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();        
        
        personAccountMerge.search();  
        
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){
            potentialDuplicate.selected = true;
            if(!masterSelected){
                potentialDuplicate.acct.Merge_Category__c = LABEL.Master_Category;
                masterSelected = true;
            }else {
                potentialDuplicate.acct.Merge_Category__c = LABEL.Locked_Down_Category;    
                potentialDuplicate.acct.Is_MOD_Validated__c = true; 
            }           
        }
        personAccountMerge.mergeContacts();
        system.assertEquals('', personAccountMerge.mergeValidationErrorMessage , 'Merge failed : '+ personAccountMerge.mergeValidationErrorMessage ); 
        
    }

    //CASE 4 
    static testMethod void test_MergeFunctionality_Negative() {    
        Boolean masterSelected = false;   
        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();        
        
        personAccountMerge.search();  
        
        //Scenario 1 : missingCategory 
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){
            potentialDuplicate.selected = true;      
            if(!masterSelected){
                potentialDuplicate.acct.Merge_Category__c = LABEL.Master_Category;
                masterSelected = true;
            }else {
                potentialDuplicate.acct.Merge_Category__c = '';    
                potentialDuplicate.acct.Is_MOD_Validated__c = true; 
            }        
        }
        personAccountMerge.mergeContacts();
        system.assertEquals('- All selected accounts must be categorized,', personAccountMerge.mergeValidationErrorMessage , 'Invalid Selection for Merge : '+ personAccountMerge.mergeValidationErrorMessage ); 
        
        //Scenario 2 : No selection of results
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){
            potentialDuplicate.acct.Merge_Category__c = LABEL.Master_Category;
            potentialDuplicate.selected = false;                 
        }
        personAccountMerge.mergeContacts();
        system.assertEquals('- You must select at least one customer to merge,', personAccountMerge.mergeValidationErrorMessage , 'Invalid Selection for Merge : '+ personAccountMerge.mergeValidationErrorMessage ); 

        //Scenario 3 : Multiple selection of Masters
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){
            potentialDuplicate.acct.Merge_Category__c = LABEL.Master_Category;
            potentialDuplicate.selected = true;
        }
        personAccountMerge.mergeContacts();
        system.assertEquals('- There must be exactly one Master for selected Accounts,', personAccountMerge.mergeValidationErrorMessage , 'Invalid Selection for Merge : '+ personAccountMerge.mergeValidationErrorMessage ); 
               
    }
    
    //CASE 5 
    static testMethod void test_flagForReview_Positive() {
    
        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();        
        
        personAccountMerge.search();  
        
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){
            potentialDuplicate.selected = true;            
            potentialDuplicate.acct.Merge_Category__c = LABEL.Locked_Down_Category;  
        }        
        personAccountMerge.flagForReview(); 
        system.assertEquals('', personAccountMerge.flagForReviewValidationErrorMessage , 'Flag for review failed : '+ personAccountMerge.flagForReviewValidationErrorMessage ); 
        
        
    }     

    //CASE 6 
    static testMethod void test_flagForReview_Negative() {
    
        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();        
        
        personAccountMerge.search();  
        
        //Scenario 1 : No selection of results       
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){           
            potentialDuplicate.acct.Merge_Category__c = LABEL.Locked_Down_Category;  
        }        
        personAccountMerge.flagForReview();  
        system.assertEquals('- You must select at least one customer to flag for review,', personAccountMerge.flagForReviewValidationErrorMessage , 'Invalid Selection for Merge : '+ personAccountMerge.flagForReviewValidationErrorMessage ); 
        
        //Scenario 2 : Selection of Master for Review      
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){
            potentialDuplicate.selected = true;            
            potentialDuplicate.acct.Merge_Category__c = LABEL.Master_Category;  
        }        
        personAccountMerge.flagForReview();    
        system.assertEquals('- Master cant be Flagged for Review,', personAccountMerge.flagForReviewValidationErrorMessage , 'Invalid Selection for Merge : '+ personAccountMerge.flagForReviewValidationErrorMessage ); 
        
        //Scenario 3 : Selection of Flagged result        
        for(G2O_PersonAccountMerge_VFCx.AccountWrapper potentialDuplicate : personAccountMerge.potentialDuplicates){
            potentialDuplicate.selected = true;            
            potentialDuplicate.acct.Merge_Category__c = LABEL.Locked_Down_Category; 
            potentialDuplicate.acct.Flagged_For_Review__c = true;
        }        
        personAccountMerge.flagForReview();    
        system.assertEquals('- Selected account already Flagged for Review,', personAccountMerge.flagForReviewValidationErrorMessage , 'Invalid Selection for Merge : '+ personAccountMerge.flagForReviewValidationErrorMessage ); 
        
    }   
   
    //CASE 7 
    static testMethod void test_Exit() {

        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();        
       
        pageRef =  personAccountMerge.exit();
        System.assertEquals('/'+personAccountMerge.acct.id, pageRef.getUrl(),'msg:'+ pageRef.getUrl());
        
    }
    
    //CASE 8 
    static testMethod void test_MergeButtonAccess() {
        
        PageReference pageRef = Page.G2O_PersonAccountMerge;
        Test.setCurrentPage(pageRef);
        
        G2O_PersonAccountMerge_VFCx  personAccountMerge = init();
        
        //Scenario 1 : Create an user with HideMergeButton = false    
        User testAdminUser = UTIL_TestFactory.createAdmin('testAdminUser@test.com'); 
        
        PersonAccountMergeController__c personAccountMergeController = new PersonAccountMergeController__c();
        personAccountMergeController.HideMergeButton__c = false;
        personAccountMergeController.SetupOwnerId = testAdminUser.id;
        personAccountMergeController.Name = 'PersonAccountMergeController (User)';        
        insert personAccountMergeController;

        System.runAs(testAdminUser){
            system.assertEquals(true, personAccountMerge.showMergeButton, 'Actual value obtained' + personAccountMerge.showMergeButton);
        } 
        
        //Scenario 2 : getting the access value for Org level 
        system.assertEquals(true, personAccountMerge.showMergeButton, 'Actual value obtained' + personAccountMerge.showMergeButton);
        
    }
    
     /* Data Set up for the Person Account Merge*/
    static G2O_PersonAccountMerge_VFCx init() {
        
        UTIL_TestFactory.setupOrg();
        
        personAccount =  UTIL_TestFactory.createPersonAccount();
        personAccount.Postal_Address_Street__c = 'Street';
        personAccount.Merge_Category__c = LABEL.Master_Category;
        insert personAccount;
        
        Account personAccount1 =  UTIL_TestFactory.createPersonAccount();
        personAccount1.Postal_Address_Street__c = 'street';
        insert personAccount1;
        
        Case case1 = UTIL_TestFactory.createCase();
        case1.AccountId = personAccount1.id;
        case1.ContactId = personAccount1.Contact_Person_ID__pc;  
        insert case1;
        
        Task task1 = UTIL_TestFactory.createTask();
        task1.WhatId= personAccount1.id;
        task1.WhoId = personAccount1.Contact_Person_ID__pc; 
        insert task1;
        
        Event event1 = UTIL_TestFactory.createEvent();
        event1.WhatId = personAccount1.id;                  
        event1.WhoId =  personAccount1.Contact_Person_ID__pc;                
        insert event1;
        
        Note notes = UTIL_TestFactory.createNote();
        notes.ParentId = personAccount1.id;     
        insert notes;        
        
        Attachment attachments= UTIL_TestFactory.createAttachment();
        attachments.ParentId = personAccount1.id;      
        attachments.body = Blob.valueof('test body');
        insert  attachments;                
                
        sC = new ApexPages.standardController(personAccount);
        return PP = new G2O_PersonAccountMerge_VFCx(sC); 
        
    } 

}