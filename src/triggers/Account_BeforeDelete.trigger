/**
    About
    -----
    Description: Before Update Trigger on Account
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Filters:
    -------
        1. Prevent deletes on accounts that has not been soft deleted (Deletion_Flag__c)
        2. Deletes PAR created PossibleDuplicateAccount__c records on deletion of related account record.
        3. Updates the duplicate flags on non PAR duplicates on a deletion 
        
    Update History
    --------------
    Created May 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    Updated April 2014 -Richa Tripathi

    Issues / TODOs
    --------------  
    
*/
trigger Account_BeforeDelete on Account (before delete) {
    
    map<Id,Account> duplicateAccounts = new map<Id,Account>();
    set<id> possibleDuplicateAccounts = new set<id>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        
        String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();           
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
        String privatePersonRT = UTIL_Meta.getPersonAccountRT();

        // Creating Lists and Maps based on filter criteria 
        for (Account a : trigger.old) {
            
            // Filter 1
            if(a.Deletion_Flag__c == false && !a.IsPersonAccount) {
                a.addError('Can\'t delete accounts that has not been soft deleted (Deletion_Flag__c) first');
            }

            //Filter 2
            possibleDuplicateAccounts.add(a.id);
            
            //Filter 3
            if(a.recordTypeId == legalEntityRT || a.recordTypeId == workSiteRT || a.recordTypeId == privatePersonRT){
                duplicateAccounts.put(a.id, a);
            }
        }
        
        // Exectue logic in a service class
        
        // Filter 2
        if(!possibleDuplicateAccounts.isEmpty()){
		    G2O_Account_SVC.deletePossibleDuplicates(possibleDuplicateAccounts);
        }
        
        // Filter 3
        if(!duplicateAccounts.isEmpty()){
        	G2O_Account_SVC.removeDuplicateFlagOnDelete(duplicateAccounts);
        }
    }
}