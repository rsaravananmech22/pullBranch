@isTest
public with sharing class ActionLog_Test {
	
	//Public so it can also be called from other test classes
	@testSetup public static void createData() {
		Configuration__c config = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACTIONLOG_TO_EMAIL_ADDRESSES, Value__c='kavinda.wickramasingha@absi.digital,samith.thilina@absi.be'), true);
	}

	@isTest static void sendActionLogFailureEmail(){
		ActionLog__c actLog = new ActionLog__c();
		actLog.Message__c = 'Test Message';
		actLog.Stack_Trace__c = 'NullPointer Exception';
		actLog.Status__c = 'Failed';

		Test.startTest();
		INSERT actLog;
		Test.stopTest();

		actLog = [ SELECT Id, Status__c FROM ActionLog__c WHERE Id = :actLog.id ];
		System.assertEquals(actLog.Status__c, 'Failed');
	}

}