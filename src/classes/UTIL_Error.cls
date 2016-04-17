/**
	About
	-----
	Description: Handle apex errors, sending alerts etc. to admins as reqired and defined by custom settings
	Created for: Postnord Get2OneCRM Master/DK
	Create date: Jan 2013
	
	Details / Methods
	-----------------
	Custom exception types
	Error handling, standard alerts and logging
	
	Update History
	--------------
	Created Jan 2013 - M.E.
	First Compile March 2013 - M.E.
	
	Issues / TODOs
	--------------
*/
public with sharing class UTIL_Error 
{
	public static ApexErrorLog__c[] reports = new ApexErrorLog__c[]{};
	
	public static void report(Exception e)
	{
		report('Handled Exception',e);
	}
	public static void report(String title, Exception e)
	{
		//ADD EXCEPTION TYPE BEHAVIOURS HERE. ALL INHERIT FROM EXCEPTION SO WE CAN EXTEND
		report(title,e.getMessage() + '\r\n' + e.getStackTraceString(),null);
	}
	public static void report(String title, String description)
	{
		report(title,description,null);
	}
	public static void report(String title)
	{
		report(title,null,null);
	}
	
	public static void report(String code, String description, String location)
	{
		ApexErrorLog__c log = new ApexErrorLog__c();
		log.Timestamp__c = Datetime.now();
		log.Error_Code__c = code==null ? null :code.length()>254 ? code.substring(0,250)+'...' : code;
		log.Error_Description__c = description==null ? null : description.length()>32760 ? description.substring(0,32760)+'...' : description;
		log.Location__c = location==null ? null :location.length()>254 ? location.substring(0,250)+'...' : location;
		reports.add(log);
		System.debug(logginglevel.error,'*** Error Reported: '+code+' \n '+location+' \n '+description);
		sendAlert(log);
	}
	
	@future
	public static void write()
	{
		upsertReportedLogs();
	}
	public static void writeNow()
	{
		upsertReportedLogs();
	}
	static void upsertReportedLogs()
	{
		try
		{
			if (logErrors())
			{
				upsert reports;
			}
			else
			{
				System.debug(logginglevel.info,'*** Could not Log error(s): Logging is deactivated');
			}
		}
		catch(Exception e)
		{
			System.debug(logginglevel.error,'*** Could not Log error(s): '+e.getMessage());
		}
		reports = new ApexErrorLog__c[]{};
	}
	
	static void sendAlert(ApexErrorLog__c log)
	{
		if (alertErrors())
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(errorAlertRecipients());
			mail.setSubject('Apex Handled Error : ' + log.Error_Code__c);
			mail.setPlainTextBody(log.Error_Code__c+'\n'+log.Location__c+'\n'+log.Error_Description__c+'\n'+log.Timestamp__c);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			System.debug(logginglevel.info,'*** Error alert sent to:  '+errorAlertRecipients());
		}
		else
		{
			System.debug(logginglevel.info,'*** Error alerts not sent: deactivated');
		}
	}
	
	/**** Custom Settings ****/
    // Tell code if errors should be logged
	public static boolean logErrors()
    {
        return (boolean)customSettings('Log_Errors__c',true);
    }
    
    // Tell code if errors should be logged
	public static boolean alertErrors()
    {
        return (boolean)customSettings('Send_Error_Alerts__c',false);
    }
    
    // List of user emails to receive email alerts for errors when the alert errors flag is set
	public static list<string> errorAlertRecipients()
    {
    	list<String> mails = new list<String>();
        String mailString = (String)customSettings('Error_Alert_Recipients__c','');
        if (mailString!=null && mailString!='' && mailString.indexOf('@')!=-1)
        {
        	mails = mailString.split(',');
        	Set<String> mailSet = new Set<String>();
        	mailSet.addAll(mails);
        
        	for(String mail : mailSet)
        	{
        		// Validate email address
    			String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
				Pattern emailPattern = Pattern.compile(emailRegex);
				Matcher emailMatch = emailPattern.matcher(mail);
        		if (!emailMatch.matches())
        		{
        			mailSet.remove(mail);
        		}
        	}
        	mails = new list<String>();
        	mails.addAll(mailSet);
        }
    	return mails;
    }
    
    // Get custom settings from Apex_Development_Settings__c object
    static Object customSettings(String field, Object defaultValue)
    {
        Object value = customSettings(field);
        return value == null ? defaultValue : value;
    }
    static Object customSettings(String field)
    {
        Object value = Apex_Development_Settings__c.getOrgDefaults().get(field);
        return value;
    }
    
}