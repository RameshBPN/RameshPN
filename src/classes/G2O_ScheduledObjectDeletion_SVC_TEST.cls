/**
    About
    -----
    Description: This class is used to test G2O_ScheduledObjectDeletion_SVC
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: September 2013
    
    Details
    -------
    This Class test the functionality of G2O_ScheduledObjectDeletion_SVC class.
    1. Test that Apex Callout Logs are cleaned up
    2. Test the Apex Callout Log grace period
    3. Test that Apex Error Logs are cleaned up
    4. Test the Apex Error Log grace period
    5. Test that Outbound Notifications are cleaned up
    6. Test the Outbound Notification grace period
    7. Stress test the object deletion job
    8. Negative test if deletes are made with no permissions to delete
    
    Update History
    --------------
    Created September 2013 - K.E.A.J.
    Updated May 2014 - T.R.
    
    Issues / TODOs 
    --------------
    
*/
@isTest
private class G2O_ScheduledObjectDeletion_SVC_TEST{

    //A.T.T.R.I.B.U.T.E.S
    static list<ApexCalloutLog__c> calloutLogList = new list<ApexCalloutLog__c>();
    static list<ApexErrorLog__c> errorLogList = new list<ApexErrorLog__c>();
    static list<Outbound_Notification__c> outboundNotificationList = new list<Outbound_Notification__c>();
    static list<sObject> sObjectList = new list<sObject>();
    static scheduledJobParameters__C scheduledJobParameters;

    //1. Test that Apex Callout Logs are cleaned up
    static testMethod void testApexCalloutLogCleanup() {

        // Arrange
        UTIL_TestFactory.setUpOrg();
        createCalloutLogData();
        
        // Act
        Test.StartTest(); 
        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC();
        aclcBatch.deleteApexCalloutLog();
        Test.StopTest();
        
        //Assert
        system.assertEquals(0, [SELECT count() FROM ApexCalloutLog__c], 'Expected all the logs to be deleted');
    }

	//2. Test the Apex Callout Log grace period
    static testMethod void testApexCalloutLogGracePeriod() {
    	
    	// Arrange
        UTIL_TestFactory.setUpOrg();
        createCalloutLogData(); 
        
        //Set the grace period so the records are not deleted
        scheduledJobParameters.apexCalloutLogGracePeriod__c = '3';
        update scheduledJobParameters;
        
       // Act
        Test.StartTest(); 
        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC(); 
        aclcBatch.deleteApexCalloutLog();
        Test.StopTest(); 
        
        //Assert
        system.assertEquals(200, [SELECT count() FROM ApexCalloutLog__c], 'Did not expect all the logs to be deleted');    
    }

	//3. Test that Apex Error Logs are cleaned up
    static testMethod void testApexErrorLogCleanup() {
        
        // Arrange
        UTIL_TestFactory.setUpOrg();
        createErrorLogData();

        // Act
        Test.StartTest(); 
        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC();
        aclcBatch.deleteApexErrorLog();        
        Test.StopTest();
        
        //Assert
        system.assertEquals(0, [SELECT count() FROM ApexErrorLog__c], 'Expected all the logs to be deleted');
    }

	//4. Test the Apex Error Log grace period
    static testMethod void testApexErrorLogGracePeriod() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        createErrorLogData(); 
        scheduledJobParameters.ApexErrorLoggracePeriod__c = '3';
        update scheduledJobParameters;
        
		// Act
        Test.StartTest(); 
        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC(); 
        aclcBatch.deleteApexErrorLog();
        Test.StopTest(); 
        
        //Assert
        system.assertEquals(200, [SELECT count() FROM ApexErrorLog__c], 'Did not expect all the logs to be deleted');    
    }

	//5. Test that Outbound Notifications are cleaned up
    static testMethod void testOutboundNotificationCleanup() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        createOutboundNotificationData();
        
        // Act
        Test.StartTest(); 
        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC();
        aclcBatch.deleteOutboundNotification();        
        Test.StopTest();
        
        //Assert
        system.assertEquals(0, [SELECT count() FROM Outbound_Notification__c], 'Expected all the logs to be deleted');
    }

	//6. Test the Outbound Notification grace period
    static testMethod void testOutboundNotificationGracePeriod() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        createOutboundNotificationData(); 
        scheduledJobParameters.outboundNotificationgracePeriod__c = '3';
        update scheduledJobParameters;
        
       	// Act
        Test.StartTest(); 
        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC(); 
        aclcBatch.deleteOutboundNotification();
        Test.StopTest(); 
        
        //Assert
        system.assertEquals(201, [SELECT count() FROM Outbound_Notification__c], 'Did not expect all the logs to be deleted');    
    }
    
    //7. Stress test the object deletion job
    static testMethod void testStressLoad() {
        // Arrange
        UTIL_TestFactory.setUpOrg();
        createStressData();
        
        // Act
        Test.StartTest(); 

        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC();
		aclcBatch.totalRows = 6000;
        aclcBatch.deleteApexCalloutLog();
        aclcBatch.deleteApexErrorLog();        
        Test.StopTest();
        
        //Assert
        system.assertEquals(0, [SELECT count() FROM ApexCalloutLog__c], 'Expected all the logs to be deleted');
        system.assertEquals(1, [SELECT count() FROM ApexErrorLog__c], 'Expected the 10001th record to still be in the system');
    }
    
    // 8. Negative test if deletes are made with no permissions to delete
    static testMethod void testNegativeResults() {
    	// Arrange
        UTIL_TestFactory.setUpOrg();
        createNegativeTestData();
        
        //Create an user that is able to create records but not delete them
        User u = UTIL_TestFactory.createUser('userWithNoPermissionToDelete@user.com', 'Integration Read Only User');
    	insert u;
    	
    	//Act
    	System.runAs(u){
	        Test.StartTest(); 
	        G2O_ScheduledObjectDeletion_SVC aclcBatch = new G2O_ScheduledObjectDeletion_SVC();
	        aclcBatch.deleteApexCalloutLog();
	        aclcBatch.deleteApexErrorLog();
	        aclcBatch.deleteOutboundNotification();
	        Test.StopTest();
    	}
        
        //Assert
        List<ApexCalloutLog__c> apexCalloutLogs = [SELECT Id FROM ApexCalloutLog__c];
        List<ApexErrorLog__c> apexErrorLogs = [SELECT Id FROM ApexErrorLog__c];
        List<Outbound_Notification__c> outboundNotifications = [SELECT Id FROM Outbound_Notification__c];
        
        system.assertNotEquals(0, apexCalloutLogs.size(), 'Incorrect number of apexCalloutLogs remaining');
        system.assertNotEquals(0, apexErrorLogs.size(), 'Incorrect number of apexErrorLogs remaining');
        system.assertNotEquals(0, outboundNotifications.size(), 'Incorrect number of outboundNotifications remaining');
    }
    
    //Creating test data.
    private static void createCalloutLogData() {
        
        //Creating CustomSetting.
        scheduledJobParameters = scheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.apexCalloutLoggracePeriod__c = '-1';
        scheduledJobParameters.apexCalloutLogDeletionActive__c = true;
        update scheduledJobParameters;
        
        for(integer i = 0; i < 200; i++){
            sObjectList.add(UTIL_TestFactory.createApexCalloutLog());                  
        }
    
        insert sObjectList;
    }

    //Creating test data.
    private static void createErrorLogData() {
        UTIL_TestFactory.setUpOrg();
        
        //Creating CustomSetting.
        scheduledJobParameters = scheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.apexErrorLoggracePeriod__c = '-3';
        scheduledJobParameters.apexErrorLogDeletionActive__c = true;
        update scheduledJobParameters;
        
        for(integer i = 0; i < 200; i++){
            sObjectList.add(UTIL_TestFactory.createApexErrorLog());                  
        }
    
        insert sObjectList;
    }

    //Creating test data.
    private static void createOutboundNotificationData() {
        UTIL_TestFactory.setUpOrg();
        
        //Creating CustomSetting.
        scheduledJobParameters = scheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.outboundNotificationgracePeriod__c = '-3';
        scheduledJobParameters.OutboundNotificationDeletionActive__c = true;
        update scheduledJobParameters;

		sObjectList = UTIL_TestFactory.createOutboundNotifications();                  
        insert sObjectList;
    }
                        
    // Creates enough records to make it impossible to delete in one execution
    private static void createStressData(){
        //Creating CustomSetting
        scheduledJobParameters = scheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.ApexCalloutLoggracePeriod__c = '-3';
        scheduledJobParameters.ApexErrorLoggracePeriod__c = '-3';
        scheduledJobParameters.apexCalloutLogDeletionActive__c = true;
        scheduledJobParameters.apexErrorLogDeletionActive__c = true;
        
        update scheduledJobParameters;
    	for(integer i = 0; i < 2000; i++){
            calloutLogList.add(UTIL_TestFactory.createApexCalloutLog());                  
        }
        for(integer i = 0; i < 2001; i++){
            errorLogList.add(UTIL_TestFactory.createApexErrorLog());                  
        }
    	insert calloutLogList;
        insert errorLogList; 
    }
    
    // Creates 200 records of each
    private static void createNegativeTestData(){
        //Creating CustomSetting
        scheduledJobParameters = scheduledJobParameters__c.getOrgDefaults();
        scheduledJobParameters.ApexCalloutLoggracePeriod__c = '-3';
        scheduledJobParameters.ApexErrorLoggracePeriod__c = '-3';
        scheduledJobParameters.OutboundNotificationGraceperiod__c = '-3';
        scheduledJobParameters.apexCalloutLogDeletionActive__c = true;
        scheduledJobParameters.apexErrorLogDeletionActive__c = true;
        scheduledJobParameters.OutboundNotificationDeletionActive__c = true;
        update scheduledJobParameters;
        
    	for(integer i = 0; i < 200; i++){
            sObjectList.add(UTIL_TestFactory.createApexCalloutLog());                  
        }
        for(integer i = 0; i < 200; i++){
            sObjectList.add(UTIL_TestFactory.createApexErrorLog());                  
        }
        for(integer i = 0; i < 200; i++){
        	Outbound_Notification__c obn = UTIL_TestFactory.createOutboundNotification();
            obn.Notification_Key__c = obn.Notification_Key__c + String.ValueOf(i);
            sObjectList.add(obn);                  
        }
        insert sObjectList;
    }
}