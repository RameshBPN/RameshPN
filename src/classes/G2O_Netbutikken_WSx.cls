/**
    About
    -----
    Description: Web Service class used to generate accounts for Netbutiken
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details
    -------
     
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------  

*/
global class G2O_Netbutikken_WSx {
    
    webService static List<Account> generateCustomerPool (Integer quantity, String accountType) {
        System.debug(logginglevel.Info, '### START Netbutikken_WS.generateCustomerPool ('+quantity+','+accountType+')');
        
        List<Account> newAccounts = new List<Account>();
        
        // Limtis the quantity to 200 accounts per request.
        if(quantity > 200) quantity = 200;
        
        if(quantity < 0) quantity = 0;
        
        // If accountType doesn't match, returns emty list
        if(!(accountType == 'B2B' || accountType == 'B2C')) quantity = 0;
        
        if(quantity > 0) {

            Id b2cRecordTypeId = UTIL_Meta.getAccountB2CWebshopPlaceHolderRT();
            
            Id b2bRecordTypeId = UTIL_Meta.getAccountB2BWebshopPlaceHolderRT();    
            
            
            
            for(Integer i = 0; i < quantity; i++) {
                Account account = new Account();
                if(accountType == 'B2B') {
                    account.RecordTypeId = b2bRecordTypeId;
                    account.Name = UTIL_OrgSettings.webshop_B2B_Name();
                }
                if(accountType == 'B2C') {
                    account.RecordTypeId = b2cRecordTypeId;
                    account.LastName = UTIL_OrgSettings.webshop_B2C_Name();
                }
                newAccounts.add(account);
            }
            
            insert newAccounts;
            
            newAccounts = [SELECT Id, Name, LastName, RecordTypeId, Involved_Party_ID__c
                               FROM Account
                               WHERE Id IN :newAccounts];
        }
        System.debug(logginglevel.Info, '### END Netbutikken_WS.generateCustomerPool');
        return newAccounts;
    }

}