/**
	About
	-----
	Description: Visual Force Controller for the PreChatForm page
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: April 2014
		
	Description
	-----------
	1. Checks the incoming IP against the list of blocked IP custom settings
	
	Update History
	--------------
	Created April 2014 - T.R.
*/
public with sharing class G2O_PreChatForm_VFC {
    public boolean blockedUser {get;set;}
    public String ipAddress {get;set;}
    
    // 1. Checks the incoming IP against the list of blocked IP custom settings
    public G2O_PreChatForm_VFC()
    {
        // Check the incoming IP against the custom settings list and mark if the user should be allowed access to live agent or not
        blockedUser = false;
        ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        LiveAgent_Blocked_IPs__c blockedIp = LiveAgent_Blocked_IPs__c.getValues(ipAddress); // Should be in OrgSettings: UTIL_OrgSettings.blockedLiveAgentIp(ipAddress)
        if (blockedIp!=null)
        {
            blockedUser = true;
        }
    }
}