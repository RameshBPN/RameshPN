/*
    About
    -----
    Description: Before Update Trigger on Opportunity 
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Oct  2015
    
    Has to be in AfterUpdate because of some roll-up summary fields triggered on stage name change (to prevent recursion)
    
    Filters:
    -------
        1.Opportunities where the StageName changes to Closed Lost/Won,then update HasToResetSalesGroupAndOffice flag to true
        
    Update History
    --------------
    
    Issues / TODOs
    --------------  
*/
trigger Opportunity_BeforeUpdate  on Opportunity (before update) {
    List<Opportunity> oppList_HasToSetSalesGroupAndOffice = new List<Opportunity>();
    if(!UTIL_OrgSettings.isTriggersDisabled()) { 
        for(Opportunity opp : Trigger.new)
        {
            //Filter 1
            if((opp.StageName == 'Closed Lost' && trigger.oldmap.get(opp.Id).StageName != 'Closed Lost') 
               || (opp.StageName == 'Closed Won' && trigger.oldmap.get(opp.Id).StageName != 'Closed Won')){
               oppList_HasToSetSalesGroupAndOffice.add(opp); 
            } 
            else{
              opp.HasToResetSalesGroupAndOffice__c=false;
            } 
        }
    }
    // Filter 1
    if(oppList_HasToSetSalesGroupAndOffice.size() > 0) {
       G2O_Opportunity_SVC.updateHasToResetSalesGroupAndOfficeFlag(oppList_HasToSetSalesGroupAndOffice);
    }
}