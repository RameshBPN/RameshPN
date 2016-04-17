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
private class UTIL_DoubleMetaphone_TEST {
	static testMethod void basicClassFunction()
	{
		System.AssertEquals(null,UTIL_DoubleMetaphone.encode(''));//'' returns null
	}
	
	static testMethod void knownLanguageEncodingsForSpecialCases()
	{
		Test.startTest();
		UTIL_DoubleMetaphone.maxCodeLen = 4;
		UTIL_DoubleMetaphone.encode('');
		UTIL_DoubleMetaphone.encode('Czerny');
		UTIL_DoubleMetaphone.encode('SomethingCIA');
		UTIL_DoubleMetaphone.encode('Mac Caffrey');
		UTIL_DoubleMetaphone.encode('Mac Gregor');
		UTIL_DoubleMetaphone.encode('accident');
		UTIL_DoubleMetaphone.encode('accede');
		UTIL_DoubleMetaphone.encode('succeed');
		UTIL_DoubleMetaphone.encode('Michael');
		UTIL_DoubleMetaphone.encode('Mc Sweeny');
		UTIL_DoubleMetaphone.encode('Xavier');
		//-- -ges-, -gep-, -gel-, -gie- at beginning
		UTIL_DoubleMetaphone.encode('ges');
		UTIL_DoubleMetaphone.encode('ges');
		UTIL_DoubleMetaphone.encode('gep');
		UTIL_DoubleMetaphone.encode('gel');
		UTIL_DoubleMetaphone.encode('gie');
		//-- -ger-, -gy-
		UTIL_DoubleMetaphone.encode('ger');
		UTIL_DoubleMetaphone.encode('gy');
		//Italian 
		UTIL_DoubleMetaphone.encode('bacci');
		UTIL_DoubleMetaphone.encode('bertucci');
		UTIL_DoubleMetaphone.encode('CHAE');
		//-- Greek roots 
		UTIL_DoubleMetaphone.encode('chemistry');
		UTIL_DoubleMetaphone.encode('chorus');
		//-- Germanic Greek or otherwise ch for kh sound
		//ED
		UTIL_DoubleMetaphone.encode('Edgar');
		UTIL_DoubleMetaphone.encode('Edge');
		//AD
		UTIL_DoubleMetaphone.encode('Additional');
		UTIL_DoubleMetaphone.encode('adtonic');
		//Silent KN
		UTIL_DoubleMetaphone.encode('Know');
		//Mid word J
		UTIL_DoubleMetaphone.encode('Yjlus');
		//-- Parkers rule
		UTIL_DoubleMetaphone.encode('hugh');
		UTIL_DoubleMetaphone.encode('laugh');
		UTIL_DoubleMetaphone.encode('McLaughlin'); 
		UTIL_DoubleMetaphone.encode('cough');
		UTIL_DoubleMetaphone.encode('gough');
		UTIL_DoubleMetaphone.encode('rough');
		UTIL_DoubleMetaphone.encode('tough');
		//-- obvious Spanish 
		UTIL_DoubleMetaphone.encode('Jose');
		UTIL_DoubleMetaphone.encode('San Jacinto');
		// Welsh
		UTIL_DoubleMetaphone.encode('llanlloch');
		//Germanic 
		UTIL_DoubleMetaphone.encode('HEIM');
		UTIL_DoubleMetaphone.encode('HOEK');
		UTIL_DoubleMetaphone.encode('HOLM');
		UTIL_DoubleMetaphone.encode('HOLZ');
		UTIL_DoubleMetaphone.encode('VAN');
		UTIL_DoubleMetaphone.encode('VON');
		UTIL_DoubleMetaphone.encode('TION');
		UTIL_DoubleMetaphone.encode('Jungwrit');
		//-- Italian and Armenian 
		UTIL_DoubleMetaphone.encode('SIO');
		UTIL_DoubleMetaphone.encode('SIA');
		//-- german & anglicisations e.g. 
		UTIL_DoubleMetaphone.isDoubleMetaphoneEqual('smith','schmidt');
		UTIL_DoubleMetaphone.isDoubleMetaphoneEqual('snider','schneider');//Match
		//-- also -sz- in slavic language altho in hungarian it is pronounced s
		//-- french 
		UTIL_DoubleMetaphone.encode('resnais');
		UTIL_DoubleMetaphone.encode('artois');
		UTIL_DoubleMetaphone.encode('breaux');
		//-- Dutch origin e.g. 
		UTIL_DoubleMetaphone.encode('school');
		UTIL_DoubleMetaphone.encode('schooner');
		UTIL_DoubleMetaphone.encode('schermerhorn');
		UTIL_DoubleMetaphone.encode('schenker');
		//-- special caseor germanic --//
		//-- Polish 
		UTIL_DoubleMetaphone.encode('filipowicz');
		//-- Chinese pinyin e.g. 
		UTIL_DoubleMetaphone.encode('zhao');
		// Angelina 
		UTIL_DoubleMetaphone.encode('Zhang');
		//Special Cases
		UTIL_DoubleMetaphone.encode('DANGER');
		UTIL_DoubleMetaphone.encode('RANGER');
		UTIL_DoubleMetaphone.encode('MANGER');
		UTIL_DoubleMetaphone.encode('AGGI');
		UTIL_DoubleMetaphone.encode('OGGI');
		UTIL_DoubleMetaphone.encode('Bonnier');
		UTIL_DoubleMetaphone.encode('Kwin');
		UTIL_DoubleMetaphone.encode('marriage');
		UTIL_DoubleMetaphone.encode('island');
		UTIL_DoubleMetaphone.encode('isle');
		UTIL_DoubleMetaphone.encode('carlisle'); 
		UTIL_DoubleMetaphone.encode('carlysle');
		UTIL_DoubleMetaphone.encode('sugar-crystal');
		UTIL_DoubleMetaphone.encode('sugar');
		UTIL_DoubleMetaphone.encode('thomas');
		UTIL_DoubleMetaphone.encode('thames');
		UTIL_DoubleMetaphone.isDoubleMetaphoneEqual('Wasserman','Vasserman'); //match
		UTIL_DoubleMetaphone.isDoubleMetaphoneEqual('Uomo','Womo'); //match
		UTIL_DoubleMetaphone.isDoubleMetaphoneEqual('Arnow','Arnoff'); //match
		UTIL_DoubleMetaphone.encode('pILLOw');
		UTIL_DoubleMetaphone.encode('ILLA');
		UTIL_DoubleMetaphone.encode('ALLE');
		UTIL_DoubleMetaphone.encode('CHORE');
		Test.stopTest();
	}
	
    static testMethod void singleLettersAndBasicSyllables() {
    	Test.startTest();
        UTIL_DoubleMetaphone.maxCodeLen = 4;
        
        System.AssertEquals('SSR',UTIL_DoubleMetaphone.encode('CAESAR'));
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('CHIA'));
        System.AssertEquals('PP',UTIL_DoubleMetaphone.encode('bbb'));
        System.AssertEquals('N',UTIL_DoubleMetaphone.encode('KN'));
        System.AssertEquals('AR',UTIL_DoubleMetaphone.encode('aR')); //starts with vowel
        System.AssertEquals('MP',UTIL_DoubleMetaphone.encode('MB')); //drop B at end after M
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('CIA')); //CIA => X
        System.AssertEquals('TS',UTIL_DoubleMetaphone.encode('TCIA')); //CIA => X
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('CH')); //CH =>X
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('C')); //C =>K
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('CC')); //C =>K
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('CI')); //CI =>S
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('CE')); //CE =>S
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('CY')); //CY =>S
        System.AssertEquals('X',UTIL_DoubleMetaphone.encode('SCH')); //SCH =>SK
        System.AssertEquals('SKL',UTIL_DoubleMetaphone.encode('SCHOOL')); //SCH =>SK
        System.AssertEquals('J',UTIL_DoubleMetaphone.encode('DGE')); //DGE =>JJ
        System.AssertEquals('J',UTIL_DoubleMetaphone.encode('DGY')); //DGY =>JJK
        System.AssertEquals('J',UTIL_DoubleMetaphone.encode('DGI')); //DGI =>JJ
        System.AssertEquals('T',UTIL_DoubleMetaphone.encode('D')); //D =>T
        System.AssertEquals('F',UTIL_DoubleMetaphone.encode('F')); //F has no transform
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('GHA')); //GH Becomes K if at beginning
        System.AssertEquals('NT',UTIL_DoubleMetaphone.encode('GNED'));//Drop G if part of GNED and at end, D goes to T
        System.AssertEquals('N',UTIL_DoubleMetaphone.encode('GN'));//Drop G if part of GN and at end
        System.AssertEquals('NT',UTIL_DoubleMetaphone.encode('NIGHT'));//Drop GH if not followed by vowel
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('G'));//G => K otherwise
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('SOH'));//Drop H if after vowel but not before vowel
        System.AssertEquals('SH',UTIL_DoubleMetaphone.encode('SOHO'));//H stays if after vowel and before vowel
        System.AssertEquals('',UTIL_DoubleMetaphone.encode('H'));//H => H
        System.AssertEquals('A',UTIL_DoubleMetaphone.encode('I'));//I at beginning = I
        System.AssertEquals('J',UTIL_DoubleMetaphone.encode('J'));//J => J
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('CK'));//CK => K and K=>K
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('K'));//CK => K and K=>K
        System.AssertEquals('L',UTIL_DoubleMetaphone.encode('L'));//L=>L
        System.AssertEquals('M',UTIL_DoubleMetaphone.encode('M'));//M=>M
        System.AssertEquals('N',UTIL_DoubleMetaphone.encode('N'));//N=>N
        System.AssertEquals('F',UTIL_DoubleMetaphone.encode('PH'));//PH=>F
        System.AssertEquals('P',UTIL_DoubleMetaphone.encode('P'));//P=>PP
        System.AssertEquals('K',UTIL_DoubleMetaphone.encode('Q'));//Q=>K
        System.AssertEquals('R',UTIL_DoubleMetaphone.encode('R'));//R=>R
        System.AssertEquals('X',UTIL_DoubleMetaphone.encode('SH'));//SH=>X
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('SIO'));//SIO=>X
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('SIA'));//SIA=>X
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('S'));//S=>S
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('SCI'));//SCI=>S
        System.AssertEquals('X',UTIL_DoubleMetaphone.encode('TIA'));//TIA=>X
        System.AssertEquals('T',UTIL_DoubleMetaphone.encode('TIO'));//TIA=>X
        System.AssertEquals('0',UTIL_DoubleMetaphone.encode('TH'));//TIA=>X
        System.AssertEquals('X',UTIL_DoubleMetaphone.encode('TCH'));//T gets dropped and CH becomes X
        System.AssertEquals('T',UTIL_DoubleMetaphone.encode('T'));//T=>T
        System.AssertEquals('F',UTIL_DoubleMetaphone.encode('V'));//V=>F
        System.AssertEquals('A',UTIL_DoubleMetaphone.encode('WH'));//WH=>W
        System.AssertEquals('',UTIL_DoubleMetaphone.encode('W'));//W gets dropped if not followed by vowel
        System.AssertEquals('A',UTIL_DoubleMetaphone.encode('WA'));//WA=>W
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('X'));//X at beginning transforms to S
        System.AssertEquals('SKS',UTIL_DoubleMetaphone.encode('SAX'));//otherwise X transforms to KS
        System.AssertEquals('A',UTIL_DoubleMetaphone.encode('Y'));//Y gets dropped if not followed by vowel
        System.AssertEquals('AS',UTIL_DoubleMetaphone.encode('YES'));//otherwise it is a Y
        System.AssertEquals('S',UTIL_DoubleMetaphone.encode('Z'));//Z=>S
        Test.stopTest();
    }
}