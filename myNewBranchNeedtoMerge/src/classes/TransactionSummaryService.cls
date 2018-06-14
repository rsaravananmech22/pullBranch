public with sharing class TransactionSummaryService {
	
	@TestVisible
	private static List<Transaction_Summary__x> mockSummaryRecords = new List<Transaction_Summary__x>();

	@AuraEnabled
	public static String pdfAttachment(String recordId) {

		recordId = (recordId != null ? String.escapeSingleQuotes(recordId) : null);
		String query = 'SELECT ID, Attachment_Base64__c FROM Transaction_Summary__x WHERE ID = :recordId';

		List<Transaction_Summary__x> summaryRecords = Test.isRunningTest() ? new List<Transaction_Summary__x>() : Database.query(query);

		for (Transaction_Summary__x ts: summaryRecords) {
			if (ts.Attachment_Base64__c != null) {
				return ts.Attachment_Base64__c;
			}
		}
		return (Test.isRunningTest() ? (mockSummaryRecords.size() > 0 ? mockSummaryRecords[0].Attachment_Base64__c : null) : null);
	}
}