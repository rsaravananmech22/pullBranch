@isTest(seeAllData=false)
public with sharing class TransactionSummaryService_Test {
	
	testmethod static void testPDFAttachment() {
		
		Test.startTest();

		Transaction_Summary__x mockedRequest = new Transaction_Summary__x(
	        Mascus_Customer_Number__c = 'M00011111',
	        Attachment_Base64__c = 'Mock Attchment'
	    );

		TransactionSummaryService.mockSummaryRecords.add(mockedRequest);

		String attachmentContent = TransactionSummaryService.pdfAttachment(null);
		System.assert(attachmentContent == 'Mock Attchment');

		Test.stopTest();
	}
}