/*   About
    -----
    Description: This class  will Test G2O_AccountTeamMemberSync_BATCH_SCH class
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: May 2013
    
    Details
    -------
    The G2O_AccountTeamMemberSync_BATCH_SCH_TEST class will Test G2O_AccountTeamMemberSync_BATCH_SCH class.
    1. Tests the account team member sync scheduling
     
    Update History
    --------------
    Created July 2013 - A.B.
    Updated April 2014 - T.R.
    
    Issues / TODOs
    --------------  
*/
@isTest
public with sharing class G2O_AccountTeamMemberSync_BATCH_SCH_TEST {    
    
    //A.T.T.R.I.B.U.T.E.S
    static final string TeamRole = 'PDK BE - Customer Responsible'; // Should potentially be fetched from a custom setting
    static final string TeamRole2 = 'PDK LO - Customer Responsible'; // Should potentially be fetched from a custom setting
    static final string nonExistingTeamRole = 'nonExistingTeamRoleForTest';
    static list<Account> accountList = new list<Account>();
    static list<AccountTeamMember> atmList = new list <AccountTeamMember>();
    static list<User> userList = new list<User>();
    static AccountTeamMember atm;
    static User user;
    
    //1. Tests the account team member sync scheduling
    private static testMethod void testAccountTeamMemberSync() {
        
        UTIL_TestFactory.setUpOrg();
        Createdata();
        
        String scheduleTimeStr = calculateCronFrequency(1);
        Test.StartTest();
        String jobId = System.schedule('AccountTeamMemberSync_BATCH1092', scheduleTimeStr, new G2O_AccountTeamMemberSync_BATCH_SCH());
 
      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		system.assertNotEquals(null, ct);
		
      	// Verify the job has not run
     	System.assertEquals(0, ct.TimesTriggered);
	
      	// Verify the next time the job will run (jobs doesn't take seconds into consideration so these are nulled)
      	System.assertEquals(System.now().addHours(1).addSeconds(-1 * system.now().second()),ct.NextFireTime);
 
        Test.StopTest();
    }
    
    //Creating test data.
    static void createData() {
        UTIL_TestFactory.setUpOrg();
        
        //Creating CustomSetting.
        ScheduledJobParameters__c scheduledParameters = ScheduledJobParameters__c.getOrgDefaults();
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
    
    //Concatenates batch apex class name with DateTime to run for Scheduling other batch apex classesin finish method.
    private static String getUniqueJobName(String batchApexName) {
        System.debug(Logginglevel.INFO,'batchApexName: ' + batchApexName);
        String uniqueJobName = batchApexName + '_' + System.now().format('yyyy-MM-dd_k:m:s');
        System.debug(Logginglevel.INFO,'uniqueJobName: ' + uniqueJobName);
        return uniqueJobName;
    }
}