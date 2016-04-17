/*
    About
    -----
    Description: Implementation class for the Person Account Merge Functionality
    Created for: Postnord Get2OneCRM Master template/Summer updates
    Create date: 10th march 2015
    
    Details
    -------
    Gives the functionality to Merge the Duplicate Person Accounts in salesforce and helps the users to maintain the Master Account Data
    
    Use Cases / Test cases
    1. Search the Duplicate Person Accounts
    2. Flag the Person Accounts for review in case of Duplicates
    3. Merge the Person Accounts to lock the Duplicates

    Note that access levels are set using the custom settings - 'PersonAccountMergeController'

    Update History
    --------------
    Created 2015 March: B.Shridhar
    Updated 2015 May : B Shridhar - Implemented the merge button access using Apex : method - 'showMergeButton '
    
*/
public class G2O_PersonAccountMerge_VFCx{
    
    // Page parameters 
    public String FirstName{get;set;}
    public String LastName{get;set;}
    public String PostalAddressStreet{get;set;}
    public String PostalAddressPostalCode{get;set;}
    public String PostalAddressCity{get;set;} 
    
    public String debugMessage {get;set;}
    public String criteriaValidationErrorMessage {get; set;}
    public String mergeValidationErrorMessage  {get; set;}
    public String flagForReviewValidationErrorMessage{get; set;}

    Boolean searchRequest = false;
    Boolean isUpdate = false;
    Boolean isInsert = false;
    
    Id selectedMasterId = null;
    final Decimal levenshteinThreshold = 50, commonWordsThreshold = 50;

    public Account acct{get;set;}
    public List<SelectOption> statusOptions {get;set;}
    
    //Custom Types
    public class AccountWrapper{
        
        public Boolean selected {get; set;}
        public Account acct {get; set;}
        public Boolean preCategorized {get; set;}
        
        public AccountWrapper(){}
        
        public AccountWrapper(Boolean pSelected, Account pAcct, Boolean pPreCategorized){
            
            this.selected = pSelected;
            this.acct = pAcct;
            this.preCategorized = pPreCategorized;
        }
        
    }   
    
    private Set<String> stripSearchTerms {
    
        get{            
            stripSearchTerms=stripSearchTerms==null 
            ? G2O_PersonAccountMergeStripSearchTerms__c.getAll().keySet()
            : stripSearchTerms; return stripSearchTerms;            
        } 
        set;        
    
    }
   
    public List<AccountWrapper> potentialDuplicates {
        
        get{        
            List<AccountWrapper> potentialDuplicatesList = new List<AccountWrapper>();
            if(searchRequest){
                searchRequest = false;
                System.debug('potentialDuplicates 1==='+ queryPotentialDuplicates());
                return this.potentialDuplicates = queryPotentialDuplicates();
           }
           else{
                System.debug('potentialDuplicates 2==='+ this.potentialDuplicates);
                return this.potentialDuplicates;
           }
        } 
        set;
        
    }
    
    private Set<String> thisAcctAddressParts {
        
        get{            
            return new Set<String>(strippedThisAcctAddress.split(' '));
        } 
        set;
        
    }
    
    private String strippedThisAcctAddress {        
        
        get{
            if(UTIL_Apex.empty(strippedThisAcctAddress)){
                strippedThisAcctAddress = this.acct.Postal_Address_Street__c;
                for(String stripSearchTerm : stripSearchTerms){
                    strippedThisAcctAddress.replace(' ' + stripSearchTerm, '');
                    strippedThisAcctAddress.replace(stripSearchTerm + ' ', '');
                }
            } 
            return strippedThisAcctAddress;
        } 
        set;
    
    }
    
    //Constructor
    public G2O_PersonAccountMerge_VFCx(ApexPages.StandardController stdController) {

        resetMessages();
                
        if(UTIL_Apex.empty(acct)){
            acct = new Account();
            statusOptions = new List<SelectOption>();
            Schema.DescribeFieldResult statusFieldDescription = Account.Postal_Address_Country__c.getDescribe();
            for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues()){
                statusOptions.add(new SelectOption( pickListEntry.getValue(),pickListEntry.getLabel()));
                // obtain and assign default value
                if (pickListEntry.getValue() == 'DK'){
                    acct.Postal_Address_Country__c = pickListEntry.getValue();
                }  
            } 
        }
        
        if(stdController.getRecord().id != null){
            this.acct = [Select FirstName, LastName, isPersonAccount, Postal_Address_City__c,Postal_Address_Country__c, Postal_Address_Postal_Code__c,
                         Postal_Address_Street__c from Account where isPersonAccount = true AND Id= :stdController.getRecord().id limit 1];
            
            FirstName= this.acct.Firstname;
            LastName = this.acct.lastname;
            PostalAddressStreet = this.acct.Postal_Address_Street__c;
            PostalAddressPostalCode = this.acct.Postal_Address_Postal_Code__c ;
            PostalAddressCity = this.acct.Postal_Address_City__c;

            potentialDuplicates = queryPotentialDuplicates();
        }

    }
    
    //Search the Potential Person Account Duplicates
    public void search(){
    
        if(!UTIL_Apex.empty(potentialDuplicates)){
                potentialDuplicates = null;
            }  
        
        resetMessages();
        if(validSearchCriteria()){
            searchRequest = true;
        }
        
    }
    
    //Query the Duplicate Person Accounts based on the search criteria
    List<AccountWrapper> queryPotentialDuplicates(){
    
        System.debug(LoggingLevel.info,'*** START: G2O_PersonAccountMerge_VFCx.queryPotentialDuplicates() :');
        
        List<AccountWrapper> result = new List<AccountWrapper>();
        
        if(validSearchCriteria()){
            String soqlString = 'Select Id, Name, FirstNAme, LastName, isPersonAccount, Flagged_For_Review__c, Involved_Party_ID__c,' +
                ' Postal_Address_Street__c, Postal_Address_Postal_Code__c, Merge_Category__c, Merge_Master__c, Postal_Address_City__c, Postal_Address_Country__c, ' +
                '  Merge_Master__r.Name, PersonEmail,Deletion_Flag__c,Is_MOD_Validated__c,MOD_Address_Number__c,MOD_Interessent_Number__c,MOD_Modtager_Number__c  ' +
                ' from Account where isPersonAccount = true ';
            
            if(!UTIL_Apex.empty(FirstName)){
                soqlString += ' AND FirstName like ' + '\'%' + FirstName + '%\'' ;
                soqlString += ' AND FirstName  != null '; 
            }
            
            if(!UTIL_Apex.empty(LastName)){
                soqlString += ' AND LastName like ' + '\'%' + LastName + '%\'' ;
                soqlString += ' AND LastName  != null ';
            }
            
            if(!UTIL_Apex.empty(PostalAddressStreet)){
                soqlString += 'AND Postal_Address_Street__c like ' + '\'%'  + PostalAddressStreet + '%\'' ;
                soqlString += ' AND Postal_Address_Postal_Code__c  != null ';
            }
 
            if(!UTIL_Apex.empty(PostalAddressPostalCode)){
                soqlString += 'AND Postal_Address_Postal_Code__c = ' + '\'' + PostalAddressPostalCode + '\'' ;
                soqlString += ' AND Postal_Address_Postal_Code__c  != null ';
            }

            if(!UTIL_Apex.empty(PostalAddressCity)){           
                soqlString += 'AND Postal_Address_City__c like ' + '\'%' + PostalAddressCity  + '%\'' ; 
            }
            
            if(!UTIL_Apex.empty(this.acct.Postal_Address_Country__c)){
                soqlString += 'AND Postal_Address_Country__c = ' + '\'' + this.acct.Postal_Address_Country__c+ '\'' ;
            }
            
            soqlString += ' Order by Merge_Search_Results_Order__c limit 100';

            System.debug(LoggingLevel.info,'soqlString :' + soqlString );

            System.debug(LoggingLevel.info,'Database.query(soqlString):' + Database.query(soqlString) );
            
            for(Account cAcct :Database.query(soqlString)){
                if( !UTIL_Apex.empty(this.acct.Postal_Address_Street__c)){
                    
                    if(!UTIL_Apex.empty(cAcct.Postal_Address_Street__c))
                        if(similarAddress(prepStreetAddressForComparison(cAcct.Postal_Address_Street__c))){
                            result.add(new AccountWrapper(false,cAcct,(!UTIL_Apex.empty(cAcct.Merge_Category__c))));
                        }
                } else{
                    result.add(new AccountWrapper(false,cAcct, (!UTIL_Apex.empty(cAcct.Merge_Category__c))));
                }
            }
            
            System.debug(LoggingLevel.info,'*** PotentialDuplicates() :' + result );
            
        }

        System.debug(LoggingLevel.info,'*** END: G2O_PersonAccountMerge_VFCx.queryPotentialDuplicates():');

        return result;
        
    }
    
    //Validate the inputs Serach fields before the Search of Duplicate Person Accounts
    private Boolean validSearchCriteria(){
        
        criteriaValidationErrorMessage = '';

        Boolean inCompleteCriteria = false;
        
        if( UTIL_Apex.empty(FirstName) && UTIL_Apex.empty(LastName) && UTIL_Apex.empty(PostalAddressStreet) && UTIL_Apex.empty(PostalAddressPostalCode)){
            criteriaValidationErrorMessage += LABEL.Atleast_One_Field_Should_Be_Specified ;
        }

        if(!UTIL_Apex.empty(FirstName)){
            FirstName = FirstName.trim();
            if(FirstName.length() < 2){
                criteriaValidationErrorMessage += LABEL.At_least_2_characters_are_required_for_FirstName_field ;
            }
        }
        
        if(!UTIL_Apex.empty(LastName)){
            LastName = LastName.trim();
            if(LastName.length() < 3){
                criteriaValidationErrorMessage += LABEL.At_least_3_characters_are_required_for_LastName_field ;
            }
        }        
        
        if(!UTIL_Apex.empty(PostalAddressStreet)){
            PostalAddressStreet = PostalAddressStreet.trim();
            if(PostalAddressStreet.length()  < 3){
                criteriaValidationErrorMessage += LABEL.At_least_3_characters_are_required_for_Postal_Address_Street_field ;
           }
        }
        
        if(!UTIL_Apex.empty(PostalAddressPostalCode)){
            PostalAddressPostalCode = PostalAddressPostalCode.trim();
            if(PostalAddressPostalCode.length() < 4 || PostalAddressPostalCode.length() > 4){
                criteriaValidationErrorMessage += LABEL.Exactly_4_characters_are_required_for_PostalCode_field ;
            }
        }
         
        if(UTIL_Apex.empty(PostalAddressCity)){
            PostalAddressCity = PostalAddressCity.trim();    
            criteriaValidationErrorMessage += LABEL.You_must_enter_a_value_for_Postal_Address_City;
        }    
        
        return criteriaValidationErrorMessage != ''? false:true;

    }

    private String prepStreetAddressForComparison(String streetAddress){
    
        for(String stripSearchTerm : stripSearchTerms){
            streetAddress.replace(' ' + stripSearchTerm, '');
            streetAddress.replace(stripSearchTerm + ' ', '');
        }
        return streetAddress;
        
    }
    
    private Boolean similarAddress(String streetAddress){
    
        system.debug('strippedThisAcctAddress====='+ strippedThisAcctAddress);
        //The if part is to cater for substring match
        if(streetAddress.contains(strippedThisAcctAddress)){
            return true;
        } else {
            if( getSimilarityBasedOnLevenshteinDistance(streetAddress) >= levenshteinThreshold || getSimilarityBasedOnCommonWords(streetAddress)  >= commonWordsThreshold )
                return true;
             else 
                return false;
        }
        
    }
    
    private Decimal getSimilarityBasedOnLevenshteinDistance(String streetAddress){
    
        //This part is for similarity based on chacter comparison using levenshtein distance comparison
        Decimal largerOfTwoLengthes = (streetAddress.length() > strippedThisAcctAddress.length()) ? streetAddress.length() : strippedThisAcctAddress.length();
        return ((Math.abs(streetAddress.length() - streetAddress.getLevenshteinDistance(strippedThisAcctAddress)))/largerOfTwoLengthes)*100;

    }

    private Decimal getSimilarityBasedOnCommonWords(String streetAddress){
        
        //This part is for similarity based on common words
        Set<String> streetAddressParts = new Set<String>(streetAddress.split(' '));
        Decimal largerOfTwoSizes = (streetAddressParts.size() > thisAcctAddressParts.size()) ? streetAddressParts.size() : thisAcctAddressParts.size();
        Decimal numberOfCommonAddressWords = 0;
        for(String streetAddressPart : streetAddressParts){
            if(thisAcctAddressParts.contains(streetAddressPart))
                numberOfCommonAddressWords++;
        }
        
        return (numberOfCommonAddressWords/largerOfTwoSizes)*100;
        
    }

    //Flag the search results for the Review
    public void flagForReview(){
    
        System.debug(LoggingLevel.info,'*** START: G2O_PersonAccountMerge_VFCx.flagForReview');
    
        List<Account> flaggedAccounts = new List<Account>();
        resetMessages();
        
        if(validFlaggedSelection()){
            for(AccountWrapper potentialDuplicate : potentialDuplicates){ 
                if(potentialDuplicate.selected){                        
                    potentialDuplicate.acct.Flagged_For_Review__c = true;
                    if(!UTIL_apex.empty(potentialDuplicate.acct.Merge_Category__c))
                        potentialDuplicate.acct.Merge_Category__c = '';                    
                }  
                flaggedAccounts.add(potentialDuplicate.acct);
                potentialDuplicate.selected=false;
            }  
            
            System.debug(LoggingLevel.info,'*** flaggedAccounts : ' + flaggedAccounts);
            
            update flaggedAccounts;               
            
        }    
        
        System.debug(LoggingLevel.info,'*** END: G2O_PersonAccountMerge_VFCx.flagForReview');
        
    }
        
    //Validate the Flagged selection before the Review
    private Boolean validFlaggedSelection(){

        flagForReviewValidationErrorMessage = '';
        
        Integer numberOfSelectedCustomers = 0, numberOfMasters = 0;
        Boolean flaggedEarlier= false;
        
        for(AccountWrapper potentialDuplicate : potentialDuplicates){

            if(potentialDuplicate.selected){
                numberOfSelectedCustomers++;
                if(potentialDuplicate.acct.Merge_Category__c == LABEL.Master_Category){
                    numberOfMasters++;   
                    potentialDuplicate.selected = false;                                     
                }   
                if(potentialDuplicate.acct.Flagged_For_Review__c == true){
                    flaggedEarlier= true;
                }                     
            }            
        }
        
        if(numberOfSelectedCustomers == 0){
            flagForReviewValidationErrorMessage += LABEL.You_must_select_at_least_one_customer_to_flag_for_review ;
        }
        if(numberOfMasters != 0 ){
            flagForReviewValidationErrorMessage += LABEL.Master_cant_be_Flagged_for_Review ;
        }   
        if(flaggedEarlier){
            flagForReviewValidationErrorMessage += LABEL.Selected_account_already_Flagged_for_Review ;
        }
               
         return flagForReviewValidationErrorMessage != ''? false:true;
        
    }  
    
    //Exit from the 'Person Account Merge' Vf page based on the Flow
    public PageReference exit(){
    
        if(this.acct.id != null)
            return new PageReference('/' + this.acct.id);
        else
            return new PageReference('/home/home.jsp');
            
    }
    
    //Merge the selected Duplicate Person Accoutns based on the selection   
    public void mergeContacts(){
        
        System.debug(LoggingLevel.info,'*** START: G2O_PersonAccountMerge_VFCx.mergeContacts');
        
        searchRequest = false;
        resetMessages();
        
        List<Account> lockedDownAccounts = new List<Account>();
        List<Account> updatedAccounts = new List<Account>();
        
        if(validSelectedMerge()){
            for(AccountWrapper potentialDuplicate : potentialDuplicates){
                if(potentialDuplicate.acct.Merge_Category__c == LABEL.Master_Category){
                    selectedMasterId = potentialDuplicate.acct.Id;
                }        
            }
                
            for(AccountWrapper potentialDuplicate : potentialDuplicates){
                
                if(potentialDuplicate.selected){
                    if(!potentialDuplicate.preCategorized){
                        potentialDuplicate.preCategorized = true;                            
                            
                        //Link Survivor or Locked-Down to Master
                        if(potentialDuplicate.acct.Merge_Category__c != LABEL.Master_Category)
                            potentialDuplicate.acct.Merge_Master__c = selectedMasterId;

                        if(potentialDuplicate.acct.Merge_Category__c == LABEL.Locked_Down_Category)
                            lockedDownAccounts.add(potentialDuplicate.acct);
                    }
                    updatedAccounts.add(potentialDuplicate.acct);
                    potentialDuplicate.selected = false;
                }     
            } 
            
            System.debug(LoggingLevel.info,'*** updatedAccounts : ' + updatedAccounts);
            
            update updatedAccounts;
            
            System.debug(LoggingLevel.info,'*** lockedDownAccounts: ' + lockedDownAccounts);
        
            if(!UTIL_Apex.empty(lockedDownAccounts) && !UTIL_Apex.empty(selectedMasterId))
                    migrateForLockedDownAccounts(lockedDownAccounts);          
        }        
        
        System.debug(LoggingLevel.info,'*** END: G2O_PersonAccountMerge_VFCx.mergeContacts()');
        
    }

    //Locked down the Person Accounts which duplicates and associate them to the Master.
    private void migrateForLockedDownAccounts(List<Account> lockedDownAccounts){
      
        System.debug(LoggingLevel.info,'*** START: G2O_PersonAccountMerge_VFCx.migrateForLockedDownAccounts');
        
        List<Account> updatelockedDownAccountsList = new List<Account>(); 
        List<Id> lockedDownAccountIds = new List<Id>();
        List<Case> updateChildCases = new List<Case>();
        List<Event> updateEventsList = new List<Event>();        
        List<Task> updateTasksList = new List<Task>();
        List<Note> notesList = new List<Note>();
        List<Note> updateNotesList = new List<Note>();
        List<Attachment> attachmentsList = new List<Attachment>();
        List<Attachment> updateAttachmentsList = new List<Attachment>();
        Integer lockedDownCount=0;
        
        Account masterAccount = [select id, Contact_Person_ID__pc, MOD_Address_Number__c, MOD_Interessent_Number__c, MOD_Modtager_Number__c,Is_MOD_Validated__c  from Account where id =:selectedMasterId];

        for(Account lockedAccount:lockedDownAccounts){
             if(lockedAccount.Is_MOD_Validated__c){                  
                   lockedDownCount=lockedDownCount+1;               
            }
        }
        
        for(Account lockedAccount:lockedDownAccounts){
             if(lockedDownCount < 2) {            
                if(lockedAccount.Is_MOD_Validated__c){    
                    if(!masterAccount.Is_MOD_Validated__c){
                        masterAccount.MOD_Address_Number__c = lockedAccount.MOD_Address_Number__c;
                        masterAccount.MOD_Interessent_Number__c = lockedAccount.MOD_Interessent_Number__c ;    
                        masterAccount.MOD_Modtager_Number__c = lockedAccount.MOD_Modtager_Number__c ;
                        masterAccount.Is_MOD_Validated__c = true;   
                    } 
                }                
             }   
             lockedAccount.Deletion_Flag__c = true; 
             lockedAccount.Is_MOD_Validated__c = false;
             lockedAccount.MOD_Address_Number__c = '';
             lockedAccount.MOD_Interessent_Number__c = '';
             lockedAccount.MOD_Modtager_Number__c = ''; 
             lockedDownAccountIds.add(lockedAccount.Id);
             updatelockedDownAccountsList.add(lockedAccount);             
             
        }
        
        update masterAccount;        
        
        update updatelockedDownAccountsList;
        
        for(Case childCase : [Select Id, ContactId, AccountId from Case where AccountId IN :lockedDownAccountIds]){
            childCase.AccountId = selectedMasterId;
            childCase.ContactId = masterAccount.Contact_Person_ID__pc;
            updateChildCases.add(childCase);   
            isUpdate = true;
        }
        
        if(!updateChildCases.isEmpty())  
            modifyRelatedObjects(updateChildCases);                      
        
        for(Event eventLocked : [SELECT AccountId, Category__c, Id, RecordTypeId, Status__c, WhatId, WhoId FROM Event where AccountId IN :lockedDownAccountIds]){
            eventLocked.WhatId= selectedMasterId;
            eventLocked.WhoId = masterAccount.Contact_Person_ID__pc;
            updateEventsList.add(eventLocked);
            isUpdate = true;
        }
        
        if(!updateEventsList.isEmpty())
            modifyRelatedObjects(updateEventsList);
        
        for(Task tasktLocked : [SELECT AccountId,Category__c,Id,RecordTypeId,Status,Status__c, WhatId, WhoId FROM Task where AccountId IN :lockedDownAccountIds]){
            tasktLocked.WhatId= selectedMasterId;
            tasktLocked.WhoId = masterAccount.Contact_Person_ID__pc;
            updateTasksList.add(tasktLocked);
            isUpdate = true;
        }
        
        if(!updateTasksList.isEmpty())
            modifyRelatedObjects(updateTasksList);
        
        notesList = [SELECT Body,CreatedById,CreatedDate,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,OwnerId,ParentId,SystemModstamp,Title FROM Note where ParentId IN :lockedDownAccountIds];
        for(Note noteLocked : notesList){
            Note N= noteLocked.clone(false,true,true,true);
            N.ParentId = selectedMasterId; 
            N.IsPrivate = false;   
            updateNotesList.add(N);
            isInsert = true;            
        }   
        
        if(!updateNotesList.isEmpty()){
            modifyRelatedObjects(updateNotesList);
            Database.Delete(notesList,false);            
        }
        
        attachmentsList = [SELECT Body,BodyLength,ContentType,Description,Id,IsPrivate,Name,ParentId FROM Attachment where ParentId IN :lockedDownAccountIds];
        for(Attachment attachmentLocked : attachmentsList ){
            Attachment A= attachmentLocked.clone(false,false,true,true);
            A.ParentId = selectedMasterId;            
            updateAttachmentsList.add(A);
            isInsert = true;
        }
        
        if(!updateAttachmentsList.isEmpty()){
            modifyRelatedObjects(updateAttachmentsList);
            Database.Delete(attachmentsList,false);            
        }
        
        System.debug(LoggingLevel.info,'*** updatelockedDownAccountsList :' + updatelockedDownAccountsList);
        System.debug(LoggingLevel.info,'*** masterAccount :' + masterAccount);
        
        System.debug(LoggingLevel.info,'*** END: G2O_PersonAccountMerge_VFCx.migrateForLockedDownAccounts');
        
    }
 
    //Validate the selected Person Accounts before the mere Begins
    private Boolean validSelectedMerge(){
        
        mergeValidationErrorMessage = '';
        
        Integer numberOfSelectedCustomers = 0, numberOfMasters = 0;
        Boolean missingCategory = false;
        
        for(AccountWrapper potentialDuplicate : potentialDuplicates){
            if(potentialDuplicate.selected){
                numberOfSelectedCustomers++;
                if(potentialDuplicate.acct.Merge_Category__c == LABEL.Master_Category)
                    numberOfMasters++;

                if(UTIL_Apex.empty(potentialDuplicate.acct.Merge_Category__c))
                    missingCategory = true;    
            }
        }

        if(numberOfSelectedCustomers == 0){
            mergeValidationErrorMessage += LABEL.You_must_select_at_least_one_customer_to_merge ;
        }
        if(numberOfMasters != 1 && UTIL_Apex.empty(mergeValidationErrorMessage)){
            mergeValidationErrorMessage += LABEL.There_must_be_exactly_one_Master_for_selected_Accounts ;
        }
        if(missingCategory){
            mergeValidationErrorMessage += LABEL.All_selected_accounts_must_be_categorized ;
        }        
        if(numberOfSelectedCustomers< 2 && potentialDuplicates.size() > 1 && UTIL_Apex.empty(mergeValidationErrorMessage)){
            mergeValidationErrorMessage += LABEL.Atleast_2_accounts_must_be_selected_for_Merge ;
        }
            
        return mergeValidationErrorMessage != ''? false:true;
        
    }
    
    //Reset the Page validation error messages
    public void resetMessages(){
        
        criteriaValidationErrorMessage = '';
        mergeValidationErrorMessage = '';
        flagForReviewValidationErrorMessage = '';      
          
    }
    
    private void modifyRelatedObjects(List<SObject> relatedObject){
        
        Database.SaveResult[] results ;
        
        if(isUpdate){
            results = Database.update(relatedObject,false);
            isUpdate=false;
        }    
        
        if(isInsert){
            results = Database.Insert(relatedObject,false);
            isInsert=false;
        }
        
        for(Database.SaveResult result: results){    
            if (!result.isSuccess()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, LABEL.Errors_have_been_occurred_during_the_reparenting_of_the_related_information));
                System.debug('\n  ERROR result: '+result.errors[0].message+'\n');
                System.debug(LoggingLevel.info,'*** result :' + result);
            }
        } 
        
    }
    
    //This attribute determine if users will have access to buttons and links in the panel
    public Boolean showMergeButton 
    {   
        get
        {       
            PersonAccountMergeController__c mergeButtonAccess = PersonAccountMergeController__c.getInstance(UserInfo.getUserId());
            if(UTIL_Apex.empty(mergeButtonAccess)){  
                return false;
            } else{
                return !(mergeButtonAccess.HideMergeButton__c);
            }
         }
        set;
    }  
    
}