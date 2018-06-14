@isTest(seeAllData=false)
public with sharing class OutstandingBalanceService_Test {
	
	@testSetup public static void createDate() {
		// Create custom settings used in trigger handlers
        Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='true'), true);

        // Create account record
		Account a = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Account',Email_for_invoicing__c='Emailforinvoicing@test.com', Phonetic_Account_Name__c = 'Phonetic name will be updated shortly'), true);        
	}

	testmethod static void testGetBalanceWithNull() {
		Test.startTest();

		List<Outstanding_Balance__x> balance = OutstandingBalanceService.getBalance(null);
		System.assert(balance.size() == 0);

		Test.stopTest();
	}

	testmethod static void testGetBalanceWithCustomer() {

		Test.startTest();

		Outstanding_Balance__x mockedRequest = new Outstanding_Balance__x(
	        Total_Remaining_Amount__c = 600,
	        X30_60_Days__c = 100,
	        X60_90_Days__c = 200, 
	        Greater_than_90_Days__c = 300
	    );

	    OutstandingBalanceService.mockSummaryRecords.add(mockedRequest);

		List<Outstanding_Balance__x> balance = OutstandingBalanceService.getBalance(null);
		System.assert(balance[0].Total_Remaining_Amount__c == 600);
		System.assert(balance[0].X30_60_Days__c == 100);
		System.assert(balance[0].X60_90_Days__c == 200);
		System.assert(balance[0].Greater_than_90_Days__c == 300);


		Account acc = [SELECT Id, Mascus_Customer_Number__c FROM ACCOUNT LIMIT 1];
	    
	    // This will return null because in test class the query to external object won't return any results
	    balance = OutstandingBalanceService.getBalance(acc.Id);
	    
		Test.stopTest();
	}
}