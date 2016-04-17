/**
    About
    -----
    Description: Update Transaction Security Flags on cutomer objects
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: March 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------
    Used by different triggers to update Transaction Security Flags on the customer objects
        1. Receives a list of sObjects to update from the triggers
        2. Does the updates

    
    Methods:
    -------
        1. updateTransactionSecurityFlags               : Takes a list of sObjects and updates the Transaction Security Flags for all sObjects in the list
        2. setSynchronizedToFalse                       : Takes a list of sObjects and clear the PN_Synchronized__c flag for all sObjects in the list
        
    Update History
    --------------
    Created March 2013 - C.H.F.
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_TransactionSecurityFlags_SVC {
    
    static Boolean blockUpdateTransactionSecurityFlags = false; // Used to block recursion
    
    // Takes a list of sObjects and updates the Transaction Security Flags for all sObjects in the list
    public static void updateTransactionSecurityFlags (List<sObject> genericObjectList) {
        System.debug(logginglevel.Info, '### START TransactionSecurityFlags_SVC.updateTransactionSecurityFlags ('+genericObjectList+')');
        
        if(!blockUpdateTransactionSecurityFlags) {
            blockUpdateTransactionSecurityFlags = true;

                
                for (sObject o : genericObjectList) {
                    o.put('PN_Mark_As_Synced__c', false);
                    o.put('PN_Synchronized__c', true);
                    o.put('Last_PN_Synchronized_Date__c', Datetime.now());
                }

        }       
        
        System.debug(logginglevel.Info, '### END TransactionSecurityFlags_SVC.updateTransactionSecurityFlags');
    }
    
    // Takes a list of sObjects and clear the PN_Synchronized__c flag for all sObjects in the list
    public static void setSynchronizedToFalse (List<sObject> genericObjectList ) {
        System.debug(logginglevel.Info, '### START TransactionSecurityFlags_SVC.setSynchronizedToFalse ('+genericObjectList+')');
    
            for (sObject o : genericObjectList) {
                o.put('PN_Synchronized__c', false);
            }

        System.debug(logginglevel.Info, '### END TransactionSecurityFlags_SVC.setSynchronizedToFalse');
    }   
}