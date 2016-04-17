/**
    About
    -----
    Description: After Update Trigger on Relationship__c
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Mai 2013
    
    Filters:
    -------
        1. Deletes records with the Mark_For_Delete__c flag set to true
        
    Update History
    --------------
    Created Mai 2013 - C.H.F.
    Updated August 2013 - C.H.F. - Cleaned up
    
    Issues / TODOs
    --------------  

*/
trigger SalesAreaInformation_AfterUpdate on Sales_Area_Information__c (after update) {
    List<Sales_Area_Information__c> relevantFieldsChanged = new List<Sales_Area_Information__c>();
    
    if(!UTIL_OrgSettings.isTriggersDisabled()) {    // Allow users to disable Triggers.
        
        // Creating Lists and Maps based on filter criteria
        for (Sales_Area_Information__c Sales_Area_Information : trigger.new) {
        
            // Filter 1 
            if (Sales_Area_Information.Sales_Group_Name__c != trigger.oldMap.get(Sales_Area_Information.id).Sales_Group_Name__c ||
                Sales_Area_Information.Sales_Office_Name__c != trigger.oldMap.get(Sales_Area_Information.id).Sales_Office_Name__c ||
                Sales_Area_Information.Competitor__c != trigger.oldMap.get(Sales_Area_Information.id).Competitor__c ||
                Sales_Area_Information.External_Partner__c != trigger.oldMap.get(Sales_Area_Information.id).External_Partner__c ||
                Sales_Area_Information.External_Partner_Type__c != trigger.oldMap.get(Sales_Area_Information.id).External_Partner_Type__c) 
                {
                relevantFieldsChanged.add(Sales_Area_Information); 
            }   
        }
        
        // Execute logic in a service class
        
        // Filter 1
        if(relevantFieldsChanged.size() > 0){
            G2O_SalesAreaInformation_SVC.syncSalesAreaInformationOnWS(relevantFieldsChanged);   
        }
        
        //Log Inbound Messages 
        if(Log_Inbound_Messages__c.getInstance().Log_Messages__c){
            G2O_InboundMessageLog_SVC.logInboundMessages(Trigger.new,Trigger.oldMap);
        }
    }
}