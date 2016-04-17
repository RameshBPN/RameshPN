/**
    About
    -----
    Description: This class is used to test AccountTeamMemberSync_BATCH
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: August 2013
    
    Details
    -------
    This Class test the functionality of AccountTeamMemberSync_BATCH class.
    1. Test correct copying of data for method of AccountTeamMemberSync_BATCH class.
	2. Test correct error flags being raised upon an invalid custom setting
	3. Test correct cloning of AccountTeamMember to Worksite account when created on Legal Entity Accounts
     
    Update History
    --------------
    Created September 2013 - K.E.A.J.
    
    Issues / TODOs 
    --------------
     
*/
@isTest
private class G2O_AccountTeamMemberSync_BATCH_TEST {

    //A.T.T.R.I.B.U.T.E.S
    static final string TeamRole = 'PDK BE - Customer Responsible'; // Should potentially be fetched from a custom setting
    static final string TeamRole2 = 'PDK LO - Customer Responsible'; // Should potentially be fetched from a custom setting
    static final string nonExistingTeamRole = 'nonExistingTeamRoleForTest';
    static list<Account> accountList = new list<Account>();
    static list<AccountTeamMember> atmList = new list <AccountTeamMember>();
    static list<User> userList = new list<User>();
    static AccountTeamMember atm;
    static AccountTeamMember atm2;
    static Account parentLEAccount;
    static User user;
    static ScheduledJobParameters__c scheduledParameters;
   
    static testMethod void TestAccountTeamMemberSync_BATCH() {
               
        // Arrange
        //Creating Testdata.
        UTIL_TestFactory.setUpOrg();
        createData();
        
        // Act
        String scheduleTimeStr = calculateCronFrequency(1);
        Test.StartTest();
        String jobId = System.schedule('AccountTeamMemberSync_BATCH1092', scheduleTimeStr, new G2O_AccountTeamMemberSync_BATCH_SCH());
 
      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, StartTime, PreviousFireTime, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		system.assertNotEquals(null, ct);
		
      	// Verify the job has not run
     	System.assertEquals(0, ct.TimesTriggered);
	
      	// Verify the next time the job will run (jobs doesn't take seconds into consideration so these are nulled)
      	System.assertEquals(System.now().addHours(1).addSeconds(-1 * system.now().second()),ct.NextFireTime);
        scheduledParameters.AccountTeamMemberSyncJobId__c = ct.id;
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh);        	
        Test.StopTest();

        //Assert
        accountList = [SELECT id, PDK_BE_Cust_Resp_Name__c, PDK_LO_Cust_Resp_Name__c, PDK_BE_Cust_Resp_Email__c, PDK_LO_Cust_Resp_Email__c FROM Account];
        userList = [SELECT id, name, email, username FROM User WHERE id IN :userList LIMIT 3];
        
        for(Account acc : accountList){
            system.assertEquals(userList[0].Name, acc.PDK_BE_Cust_Resp_Name__c, 'Expected the users name to be copied to the account field PDK_BE_Cust_Resp_Name__c');
            system.assertEquals(userList[1].Name, acc.PDK_LO_Cust_Resp_Name__c, 'Expected the users name to be copied to the account field PDK_LO_Cust_Resp_Name__c');
            system.assertEquals(userList[0].Email, acc.PDK_BE_Cust_Resp_Email__c, 'Expected the users email to be copied to the account field PDK_BE_Cust_Resp_Email__c');
            system.assertEquals(userList[1].Email, acc.PDK_LO_Cust_Resp_Email__c, 'Expected the users email to be copied to the account field PDK_LO_Cust_Resp_Email__c');
        }
        system.assertEquals(ct.startTime.addSeconds(-1*ct.startTime.second()),UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime().addSeconds(-1*UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime().second()), 'Expected the success time to be updated after a succesfull run');
    }

    static testMethod void TestRoleLimitation() {
        //Creating Testdata.
        UTIL_TestFactory.setUpOrg();
        createData();
        
        // Arrange
        map<String, AccountTeamMemberToAccountMapping__c> AccountTeamMemberToAccountMappingMap = AccountTeamMemberToAccountMapping__c.getAll();
		for(AccountTeamMemberToAccountMapping__c ATMTA : AccountTeamMemberToAccountMappingMap.values()){
			ATMTA.Account_Team_Member_Role__c = 'TosseRolle';
		}
		update AccountTeamMemberToAccountMappingMap.values();
		        
        // Act
        String scheduleTimeStr = calculateCronFrequency(1);
        Test.StartTest();
        String jobId = System.schedule('AccountTeamMemberSync_BATCH1092', scheduleTimeStr, new G2O_AccountTeamMemberSync_BATCH_SCH());
 
      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, StartTime, PreviousFireTime, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		system.assertNotEquals(null, ct);
		
      	// Verify the job has not run
     	System.assertEquals(0, ct.TimesTriggered);
	
      	// Verify the next time the job will run (jobs doesn't take seconds into consideration so these are nulled)
      	System.assertEquals(System.now().addHours(1).addSeconds(-1 * system.now().second()),ct.NextFireTime);
        scheduledParameters.AccountTeamMemberSyncJobId__c = ct.id;
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh);        	
        Test.StopTest();

        //Assert
        accountList = [SELECT id, PDK_BE_Cust_Resp_Name__c, PDK_LO_Cust_Resp_Name__c, PDK_BE_Cust_Resp_Email__c, PDK_LO_Cust_Resp_Email__c FROM Account];
        userList = [SELECT id, name, email, username FROM User WHERE id IN :userList LIMIT 3];
        
        for(Account acc : accountList){
            system.assertNotEquals(userList[0].Name, acc.PDK_BE_Cust_Resp_Name__c, 'Expected the users name not to be copied to the account field PDK_BE_Cust_Resp_Name__c');
            system.assertNotEquals(userList[1].Name, acc.PDK_LO_Cust_Resp_Name__c, 'Expected the users name not to be copied to the account field PDK_LO_Cust_Resp_Name__c');
            system.assertNotEquals(userList[0].Email, acc.PDK_BE_Cust_Resp_Email__c, 'Expected the users email not to be copied to the account field PDK_BE_Cust_Resp_Email__c');
            system.assertNotEquals(userList[1].Email, acc.PDK_LO_Cust_Resp_Email__c, 'Expected the users email not to be copied to the account field PDK_LO_Cust_Resp_Email__c');
        }
        system.assertEquals(ct.startTime.addSeconds(-1*ct.startTime.second()),UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime().addSeconds(-1*UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime().second()), 'Expected the success time to be updated after a succesfull run');
    }
    
    static testMethod void TestBanning_BATCH() {
        //Creating Testdata.
        UTIL_TestFactory.setUpOrg();
        createData(); 
        
        // Arrange
        system.debug(logginglevel.warn, '===> atm LIST: ' + atmList);
        UTIL_TestFactory.createAccountTeamMemberBatchErrorList(atmList, false);
        
        // Act
        Test.StartTest(); 
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh);  
        Test.StopTest();
        
        //Assert
        accountList = [SELECT id, PDK_BE_Cust_Resp_Name__c, PDK_LO_Cust_Resp_Name__c, PDK_BE_Cust_Resp_Email__c, PDK_LO_Cust_Resp_Email__c FROM Account];
        userList = [SELECT id, name, email, username FROM User WHERE id IN :userList LIMIT 3];
        
        for(Account acc : accountList){
            system.assertEquals(null, acc.PDK_BE_Cust_Resp_Name__c, 'no copy of data should have been made');
            system.assertEquals(null, acc.PDK_LO_Cust_Resp_Name__c, 'no copy of data should have been made');
            system.assertEquals(null, acc.PDK_BE_Cust_Resp_Email__c, 'no copy of data should have been made');
            system.assertEquals(null, acc.PDK_LO_Cust_Resp_Email__c, 'no copy of data should have been made');
        }
        system.assertEquals(atmsBh.startTime,UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime(), 'Expected the success time to be updated after a succesfull run');
    }

    static testMethod void TestunBanning_BATCH() {
        //Creating Testdata.
        UTIL_TestFactory.setUpOrg();
        createData();
        
        // Arrange
		scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledParameters.AccountTeamMemberSyncSuccessTime__c = datetime.now().addhours(2);
        update scheduledParameters;
        UTIL_TestFactory.createAccountTeamMemberBatchErrorList(atmList, true);
        
        // Act
        Test.StartTest(); 
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh);  
        Test.StopTest();
        
        //Assert
        accountList = [SELECT id, PDK_BE_Cust_Resp_Name__c, PDK_LO_Cust_Resp_Name__c, PDK_BE_Cust_Resp_Email__c, PDK_LO_Cust_Resp_Email__c FROM Account];
        userList = [SELECT id, name, email, username FROM User WHERE id IN :userList LIMIT 3];
        
        for(Account acc : accountList){
            system.assertEquals(userList[0].Name, acc.PDK_BE_Cust_Resp_Name__c, 'Expected the users name to be copied to the account field PDK_BE_Cust_Resp_Name__c');
            system.assertEquals(userList[1].Name, acc.PDK_LO_Cust_Resp_Name__c, 'Expected the users name to be copied to the account field PDK_LO_Cust_Resp_Name__c');
            system.assertEquals(userList[0].Email, acc.PDK_BE_Cust_Resp_Email__c, 'Expected the users email to be copied to the account field PDK_BE_Cust_Resp_Email__c');
            system.assertEquals(userList[1].Email, acc.PDK_LO_Cust_Resp_Email__c, 'Expected the users email to be copied to the account field PDK_LO_Cust_Resp_Email__c');
        }
        system.assertEquals(atmsBh.startTime,UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime(), 'Expected the success time to be updated after a succesfull run');
    }
        
    static testMethod void TestNonCompatibleFields() {
        
        //Creating Testdata.
        UTIL_TestFactory.setUpOrg();
        createData();
        
        // Arrange
        UTIL_TestFactory.createAccountTeamMemberToAccountMapping(TeamRole, 'User.IsActive', 'Ownerid');

        // Act
        Test.StartTest();
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh);
        Test.StopTest();
        
        //Assert
        accountList = [SELECT id, PDK_BE_Cust_Resp_Name__c, PDK_LO_Cust_Resp_Name__c, PDK_BE_Cust_Resp_Email__c, PDK_LO_Cust_Resp_Email__c FROM Account LIMIT 200];
        userList = [SELECT id, name, email, username FROM User WHERE id IN :userList LIMIT 3];
        
        system.assertEquals(4, [SELECT count() from ApexErrorLog__c], [SELECT id, Error_Description__c from ApexErrorLog__c]);
        system.assertNotEquals(atmsBh.startTime, UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime(), 'Expected the last success time to still match the previous value since the run failed');
    }  

    static testMethod void TestAccountTeamMemberCloningToWorkSite() {
        //Creating Testdata.
        UTIL_TestFactory.setUpOrg();
        createLEtoWSData();
        
        // Arrange
        
        // Act
        Test.StartTest(); 
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
        database.executebatch(atmsBh); 
        Test.StopTest();
        
        //Assert
        // Expecting the parent to have 1 AccountTeamMember more than the Worksites since 1 of them is created with an role not defined in the custom setting.
		system.assertEquals(3, [select count() from AccountTeamMember where accountId = :parentLEAccount.id], '3 AccountTeamMembers was created on the parent account');
		system.assertEquals(2, [select count() from AccountTeamMember where accountId = :accountList[0].id], 'Expected 2 of the AccountTeamMembers to be copied to the WS due to roles');
		system.assertEquals(2, [select count() from AccountTeamMember where accountId = :accountList[1].id], 'Expected 2 of the AccountTeamMembers to be copied to the WS due to roles');
		system.assertEquals(2, [select count() from AccountTeamMember where accountId = :accountList[2].id], 'Expected 2 of the AccountTeamMembers to be copied to the WS due to roles');
		system.assertEquals(2, [select count() from AccountTeamMember where accountId = :accountList[3].id], 'Expected 2 of the AccountTeamMembers to be copied to the WS due to roles');		
        system.assertEquals(atmsBh.startTime,UTIL_OrgSettings.AccountTeamMemberSyncSuccessTime(), 'Expected the success time to be updated after a succesfull run');
    }
     
    static testMethod void testCalculateFrequency(){
        //Creating Testdata.
        UTIL_TestFactory.setUpOrg();
        createData();
        
        // Act
        Test.StartTest(); 
        G2O_AccountTeamMemberSync_BATCH atmsBh = new G2O_AccountTeamMemberSync_BATCH();
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0 * * ?', atmsBh.calculateCronFrequency(24));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 * * ?', atmsBh.calculateCronFrequency(1));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,2,4,6,8,10,12,14,16,18,20,22 * * ?', atmsBh.calculateCronFrequency(2));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,3,6,9,12,15,18,21 * * ?', atmsBh.calculateCronFrequency(3));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,4,8,12,16,20 * * ?', atmsBh.calculateCronFrequency(4));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,5,10,15 * * ?', atmsBh.calculateCronFrequency(5));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,6,12,18 * * ?', atmsBh.calculateCronFrequency(6));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,7,14 * * ?', atmsBh.calculateCronFrequency(7));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,8,16 * * ?', atmsBh.calculateCronFrequency(8));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,9 * * ?', atmsBh.calculateCronFrequency(9));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,10 * * ?', atmsBh.calculateCronFrequency(10));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,11 * * ?', atmsBh.calculateCronFrequency(11));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0,12 * * ?', atmsBh.calculateCronFrequency(12));
		system.assertEquals('0 ' + DateTime.now().Minute() + ' 0 * * ?', atmsBh.calculateCronFrequency(13));
    }
    
    static void createData() {
        UTIL_TestFactory.setUpOrg();
        
        //Creating CustomSetting.
        scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledParameters.AccountBatchHeapLimit__c = '7549747';
        scheduledParameters.AccountBatchJobSize__c = '200';
        scheduledParameters.AccountBatchDmlRowsLimit__c = '7000';
        scheduledParameters.AccountTeamMemberSyncSuccessTime__c = datetime.now().addhours(-2);
        scheduledParameters.AccountTeamMemberFrequency__c = 1;        
        update scheduledParameters;
        
        UTIL_TestFactory.createAccountTeamMemberToAccountMapping();
        for(integer i = 0; i < 4; i++){
            accountList.add(UTIL_TestFactory.createAccount());      
        }
        insert accountList;
        
        for(integer i = 0; i < 3; i++){
            user = UTIL_TestFactory.createUser('AccountTeamMemberSyncTestUser' + i + '@AccountTeamMemberSyncTest.se', 'Standard User');
            user.Title = 'UserTitle ' + i;
            user.Email = 'AccountTeamMemberSyncTestUser' + i + '@AccountTeamMemberSyncTest.se';
            user.Phone = 'i';
            user.Team__c = 'UserTeam ' + i;
            userList.add(user); 
        }
        
        userList.add(UTIL_TestFactory.createUser('UserShouldNeverBePresent@AccountTeamMemberSyncTest.se', 'Standard User'));
        insert userList;
        
        for(integer j = 0; j < 3; j++){
            for(integer i = 0; i < accountList.size(); i++){
                atm = UTIL_TestFactory.createAccountTeamMember();
                atm.Accountid = accountList[i].id;
                if(j == 0){
                    atm.TeamMemberRole = TeamRole;
                }
                else if( j == 1){
                    atm.TeamMemberRole = TeamRole2;
                }
                else{
                    atm.TeamMemberRole = nonExistingTeamRole;
                }
                atm.Userid = userList[j].id;                            
                atmList.add(atm);       
            }
        }
        
        insert atmList;
        system.debug(logginglevel.warn, '===> atmList after insert: ' + [SELECT id, TeamMemberRole, createdDate FROM AccountTeamMember] + '   ' + DateTime.now());
    }
    
    static void createLEtoWSData(){
    	UTIL_TestFactory.setUpOrg();
        
        String legalEntityRT = UTIL_Meta.getAccountLegalEntityRT();
		String workSiteRT = UTIL_Meta.getAccountWorkSiteRT();
		
        //Creating CustomSetting.
        scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
        scheduledParameters.AccountBatchHeapLimit__c = '7549747';
        scheduledParameters.AccountBatchJobSize__c = '200';
        scheduledParameters.AccountBatchDmlRowsLimit__c = '7000';
        scheduledParameters.AccountTeamMemberSyncSuccessTime__c = datetime.now().addhours(-2);
        scheduledParameters.AccountTeamMemberFrequency__c = 1;        
        update scheduledParameters;
        
        UTIL_TestFactory.createAccountTeamMemberToAccountMapping();
        UTIL_TestFactory.createAccountTeamMemberRolesToSync();
		parentLEAccount = UTIL_TestFactory.createAccount();
		parentLEAccount.recordTypeId = legalEntityRT;    
        insert parentLEAccount;
        
        for(integer i = 0; i < 4; i++){
            accountList.add(UTIL_TestFactory.createAccount());
			accountList[i].parentid = parentLEAccount.id;
			accountList[i].RecordTypeId = workSiteRT; 
        }
        insert accountList;
        
        for(integer i = 0; i < 2; i++){
            user = UTIL_TestFactory.createUser('AccountTeamMemberSyncTestUser' + i + '@AccountTeamMemberSyncTest.se', 'Standard User');
            user.Title = 'UserTitle ' + i;
            user.Email = 'AccountTeamMemberSyncTestUser' + i + '@AccountTeamMemberSyncTest.se';
            user.Phone = 'i';
            user.Team__c = 'UserTeam ' + i;
            userList.add(user); 
        }
        
        userList.add(UTIL_TestFactory.createUser('UserShouldNeverBePresent@AccountTeamMemberSyncTest.se', 'Standard User'));
        insert userList;
        
        atm = UTIL_TestFactory.createAccountTeamMember();
        atm.TeamMemberRole = TeamRole;
        atm.AccountId = parentLEAccount.id;
        atm.UserId = userList[0].id;
        atmList.add(atm);
        
        atm = UTIL_TestFactory.createAccountTeamMember();
        atm.TeamMemberRole = TeamRole2;
        atm.AccountId = parentLEAccount.id;
        atm.UserId = userList[1].id;
        atmList.add(atm);

        atm = UTIL_TestFactory.createAccountTeamMember();
        atm.TeamMemberRole = 'bogusRole';
        atm.AccountId = parentLEAccount.id;
        atm.UserId = userList[2].id;
        atmList.add(atm);

        insert atmList;
    }
    
    private static String calculateCronFrequency(integer frequency){
		integer runsPrHour = 24 / frequency;
		if(runsPrHour < 1 || runsPrHour > 24){
			return 'Invalid Frequency';
		}

		String cronFrequency = '0 ' + DateTime.now().minute() + ' ';				
		for(integer i = 0; i < runsPrHour; i++){
			if(i > 0){
				cronFrequency += ',';
			}
			cronFrequency += ((i-1)+frequency);				
		}
		cronFrequency += ' * * ?';
		
		return cronFrequency;
	}
}