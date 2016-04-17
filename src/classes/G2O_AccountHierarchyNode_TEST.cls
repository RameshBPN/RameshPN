/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class G2O_AccountHierarchyNode_TEST {
	static Opportunity opp;
	static Contact con;
	static DateTime startTestTime = DateTime.now();

    static testMethod void testBlankConstructor(){
    	testData();
    	
    	test.startTest();
    	G2O_AccountHierarchyNode testAHN = new G2O_AccountHierarchyNode();
		test.stopTest();
    	
    	system.assertEquals(null, testAHN.text);

    }
        
    static testMethod void testOpportunityConstructor(){
    	testData();
    	
    	test.startTest();
    	G2O_AccountHierarchyNode testAHN = new G2O_AccountHierarchyNode(opp);
		test.stopTest();

    	
    	system.assert(testAHN.text.contains(opp.Name));
    	system.assert(testAHN.text.contains(opp.Amount.format()));
    	system.assert(testAHN.text.contains(opp.CloseDate.format()));
    }

    static testMethod void testContactConstructor(){
    	testData();

    	test.startTest();    	
    	G2O_AccountHierarchyNode testAHN = new G2O_AccountHierarchyNode(con);
		test.stopTest();


    	system.assert(testAHN.text.contains(con.Title));
    	system.assert(testAHN.text.contains(con.Phone));
    	
    }    

    static testMethod void testChildrenFunctionality(){
    	testData();
    	
    	test.startTest();
    	G2O_AccountHierarchyNode testChildAHN = new G2O_AccountHierarchyNode(opp);

    	G2O_AccountHierarchyNode testAHN = new G2O_AccountHierarchyNode(con);
		system.assertEquals(false, testAHN.hasChildren());    	

		testAHN.addChildNode(testChildAHN);
		system.assertEquals(true, testAHN.hasChildren());    			
		test.stopTest();
    } 
        
    static void testData(){
        UTIL_TestFactory.setUpOrg();
            
		Account acc = UTIL_TestFactory.createAccount();
        acc.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
        insert acc;
        
        opp = UTIL_TestFactory.createOpportunity();
        opp.Account = acc;
        opp.Name = 'testOpportunityName';
        opp.Amount = 100;        
        opp.CloseDate = startTestTime.Date();
        insert opp;
        
        con = UTIL_TestFactory.createContact();
        con.FirstName = 'TestFirstName';
        con.LastName = 'testLastName';
        con.Accountid = acc.id;
        con.Title = 'testTitle';
        con.Phone = '123123123';
        con.Contact_Person_Type__c = 'Lead Contact Person';
        system.debug(logginglevel.WARN, 'wootwootwoot: ' + [SELECT Name From RecordType WHERE id = :con.Account.RecordTypeId]);
        insert con;     
    }
}