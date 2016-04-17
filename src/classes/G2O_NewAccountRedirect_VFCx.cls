/**
	About
	-----
	Description: Called on New Account. Redirects to correct flow for new account creation
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: July 2013
		
	Description
	-----------
	Two flows are launched based on the recrd types, the SFDC Search with MOD validate (DK only) for new person accounts and the SFDC Search with PAR Verify for all other main B2B accounts
	Flow direction is defined in custom settings: NewCustomerMODFlowRecordTypes and NewCustomerMainFlowRecordTypes where the developer names of the record types that should fire each respective flow are listed in CSV format
		Incoming URL samples
		New Work site https://c.cs17.visual.force.com/apex/G2O_NewAccountRedirect?retURL=%2F001%2Fo&RecordType=012g00000008WMK&ent=Account&save_new=1&sfdc.override=1
		New Person Account https://c.cs17.visual.force.com/apex/G2O_NewAccountRedirect?retURL=%2F001%2Fo&RecordType=012b0000000LCix&ent=Account&save_new=1&sfdc.override=1
		New Work site for LE https://c.cs17.visual.force.com/apex/G2O_CustomerSearch?RecordTypeName=Work_Site&ParentAccountId=001g0000004vJxn
		Note exsiting records do not go via this page. These go directly to the VF page via a button. Example URL: Mod Validate Existing Person Account https://c.cs17.visual.force.com/apex/G2O_CustomerSearch_MOD?id=001g0000006VWC0
		
	Update History
	--------------
	Rewritten July 13 M.E. (2days)
*/

public with sharing class G2O_NewAccountRedirect_VFCx {
		
	public G2O_NewAccountRedirect_VFCx(ApexPages.StandardController controller) {
	}
	
	public PageReference redirectCustomerCreate() {
		
		// get the record type id
		String recordTypeId = Apexpages.currentpage().getparameters().get('RecordType');

		// If no record type is being feed with to the page, then the user has either selected to always use the default record type
		// or the user only has 1 record type associated for the object in question.
		if(UTIL_Apex.empty(recordTypeId)) {
			//find all Account record types
			List<Schema.RecordTypeInfo> rtis = Schema.SObjectType.Account.RecordTypeInfos;
			Id defaultRecordTypeId;
			
			//Find the users default record type
			for(Schema.RecordTypeInfo rti : rtis) {
				if(rti.DefaultRecordTypeMapping) {
					recordTypeId = rti.RecordTypeId;
				}
			}
		}
		if(!UTIL_Apex.empty(recordTypeId)) {
			try
			{
				String recordTypeDeveloperName = [Select r.DeveloperName 
													From RecordType r where SobjectType =: 'Account' and Id=: recordTypeId limit 1].DeveloperName; 
				// Decide on which flow to use based on the record types listed under each custom setting: for MOD flow, or for the Main flow
				if (UTIL_OrgSettings.NewCustomerMODFlowRecordTypes().contains(recordTypeDeveloperName))
				{
					// Launch the MOD based customer search flow
					PageReference pr = Page.G2O_CustomerSearch_MOD;
					reflectUrlParameters(pr);
					// Adding the recordtype to the page parameter if not already present
					if(pr.getParameters().get('RecordType') == null){
						pr.getParameters().put('RecordType', recordTypeId);
					}
					return pr;
				} else if (UTIL_OrgSettings.NewCustomerMainFlowRecordTypes().contains(recordTypeDeveloperName)) {
					// Launch the main customer search flow
					//*
					// New PAR Search page
					PageReference pr = Page.G2O_CustomerSearch;
					reflectUrlParameters(pr);
					// Adding the recordtype to the page parameter if not already present
					if(pr.getParameters().get('RecordType') == null){
						pr.getParameters().put('RecordType', recordTypeId);
					}
					return pr;
				}
			} catch (exception e)
			{
				UTIL_Error.report(e);
			}
		}
		// Standard new page for all other record types
		PageReference pr = new PageReference('/' + Account.SObjectType.getDescribe().getKeyPrefix() + '/e');
		reflectURLParameters(pr);
		pr.getParameters().remove('save_new');
	    pr.getParameters().put('nooverride', '1');
	    return pr;
	}
	
	void reflectURLParameters(PageReference pr)
	{
		for (String key : ApexPages.currentPage().getParameters().keySet())
		{
			pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
		}
	}
}