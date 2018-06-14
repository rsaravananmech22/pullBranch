public with sharing class OutstandingBalanceService {
	
	@TestVisible
	private static List<Outstanding_Balance__x> mockSummaryRecords = new List<Outstanding_Balance__x>();

	@AuraEnabled
	public static List<Outstanding_Balance__x> getBalance(String recordId) {

		List<Account> acc = [SELECT Mascus_Customer_Number__c FROM Account WHERE Id = :recordId LIMIT 1];

		if (acc.size() > 0 && acc[0].Mascus_Customer_Number__c != null) {

			String mascusCustomerNumber = acc[0].Mascus_Customer_Number__c;
			String query = 'SELECT CurrencyIsoCode, Total_Remaining_Amount__c, X0_30_Days__c, X30_60_Days__c, X60_90_Days__c, Greater_than_90_Days__c FROM Outstanding_Balance__x '
							+ 'WHERE Mascus_Customer_Number__c = :mascusCustomerNumber';

			List<Outstanding_Balance__x> balance = Test.isRunningTest() ? new List<Outstanding_Balance__x>() : Database.query(query);
			
			return balance;
		}
		
		return (Test.isRunningTest() ? mockSummaryRecords : new List<Outstanding_Balance__x>());
	}
}