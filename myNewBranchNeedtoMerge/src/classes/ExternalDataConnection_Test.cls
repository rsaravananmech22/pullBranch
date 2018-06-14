@isTest(seeAllData=false)
public with sharing class ExternalDataConnection_Test {
	
	testmethod static void externalDataConnectionTransactionSummary() {

		Test.startTest();

		ExternalDataConnection edc = new ExternalDataConnection(null);
		edc.sync();

		// Generate a query context ////////////////////////////////
		DataSource.QueryContext context = new DataSource.QueryContext();
		context.offset = 0;
		context.queryMoreToken = null;

		DataSource.Filter filterClass = new DataSource.Filter();
		filterClass.columnName = 'Mascus Customer Number';
		filterClass.columnValue = 'M000111111';
		filterClass.tableName = 'Transaction Summary';
		filterClass.type = DataSource.FilterType.EQUALS;

		DataSource.TableSelection table = new DataSource.TableSelection();
		table.tableSelected = 'Transaction Summary';
		table.filter = filterClass;

		context.tableSelection = table;
		////////////////////////////////////////////////////////////

		Test.setMock(HttpCalloutMock.class, new ExternalDataConnection_Test.MockHttpResponseGenerator());		
		// Execute the query WITH mock
		DataSource.TableResult summaryRecords = edc.query(context);
		System.assert(summaryRecords.totalSize == 10);
		System.assertEquals('ID0', summaryRecords.rows[0].get('Transaction ID'), 'Incorrect Transaction ID');
		System.assertEquals('ID5', summaryRecords.rows[5].get('Transaction ID'), 'Incorrect Transaction ID');
		System.assertEquals('ID9', summaryRecords.rows[9].get('Transaction ID'), 'Incorrect Transaction ID');

		// New query context //////////////////////////////////////
		filterClass.columnName = 'ExternalID';
		filterClass.columnValue = '1:M000111111';
		table.filter = filterClass;
		////////////////////////////////////////////////////////////

		summaryRecords = edc.query(context);
		System.assert(summaryRecords.totalSize == 1);

		// Adding Sub-Filter ///////////////////////////////////////
		DataSource.Filter filterClass2 = new DataSource.Filter();
		filterClass2.columnName = 'Mascus Customer Number';
		filterClass2.columnValue = 'M000111111';
		filterClass2.tableName = 'Transaction Summary';
		filterClass2.type = DataSource.FilterType.EQUALS;

		DataSource.Filter filterClass3 = new DataSource.Filter();
		filterClass3.subfilters = new List<DataSource.Filter>{filterClass2};
		table.filter = filterClass3;
		////////////////////////////////////////////////////////////
		summaryRecords = edc.query(context);
		System.assert(summaryRecords.totalSize == 10);

		Test.stopTest();
	}

	testmethod static void externalDataConnectionTransactionDetail() {

		Test.startTest();

		ExternalDataConnection edc = new ExternalDataConnection(null);
		edc.sync();

		// Generate a query context ////////////////////////////////
		DataSource.QueryContext context = new DataSource.QueryContext();
		context.offset = 0;
		context.queryMoreToken = null;

		DataSource.Filter filterClass = new DataSource.Filter();
		filterClass.columnName = 'Transaction ID';
		filterClass.columnValue = '1:M000111111';
		filterClass.tableName = 'Transaction Detail';
		filterClass.type = DataSource.FilterType.EQUALS;

		DataSource.TableSelection table = new DataSource.TableSelection();
		table.tableSelected = 'Transaction Detail';
		table.filter = filterClass;

		context.tableSelection = table;
		////////////////////////////////////////////////////////////

		Test.setMock(HttpCalloutMock.class, new ExternalDataConnection_Test.MockHttpResponseGenerator());
		// Execute the query WITH mock
		DataSource.TableResult detailRecords = edc.query(context);
		System.assert(detailRecords.totalSize == 10);
		System.assert(detailRecords.rows[0].get('Transaction Line ID') == 'LineID0');
		System.assert(detailRecords.rows[5].get('Transaction Line ID') == 'LineID5');
		System.assert(detailRecords.rows[9].get('Transaction Line ID') == 'LineID9');

		// New query context ///////////////////////////////////////
		filterClass.columnName = 'ExternalID';
		filterClass.columnValue = '1:12345';
		table.filter = filterClass;
		////////////////////////////////////////////////////////////

		detailRecords = edc.query(context);
		System.assert(detailRecords.totalSize == 1);

		// Adding Sub-Filter ///////////////////////////////////////
		DataSource.Filter filterClass2 = new DataSource.Filter();
		filterClass2.columnName = 'ExternalID';
		filterClass2.columnValue = '1:M000111111';
		filterClass2.tableName = 'Transaction Detail';
		filterClass2.type = DataSource.FilterType.EQUALS;

		DataSource.Filter filterClass3 = new DataSource.Filter();
		filterClass3.subfilters = new List<DataSource.Filter>{filterClass2};
		table.filter = filterClass3;
		////////////////////////////////////////////////////////////

		detailRecords = edc.query(context);
		System.assert(detailRecords.totalSize == 1);

		// Adding Sub-Filter ///////////////////////////////////////
		filterClass2.columnName = 'Transaction ID';
		filterClass3.subfilters = new List<DataSource.Filter>{filterClass2};
		table.filter = filterClass3;
		////////////////////////////////////////////////////////////

		detailRecords = edc.query(context);
		System.assert(detailRecords.totalSize == 10);

		Test.stopTest();
	}

	testmethod static void externalDataConnectionColumnSelection() {

		Test.startTest();

		ExternalDataConnection edc = new ExternalDataConnection(null);
		edc.sync();

		// Generate a query context ////////////////////////////////
		DataSource.QueryContext context = new DataSource.QueryContext();
		context.offset = 0;
		context.queryMoreToken = null;

		DataSource.ColumnSelection selection = new DataSource.ColumnSelection();
		selection.tableName = 'Transaction Detail';
		selection.aggregation = DataSource.QueryAggregation.COUNT;

		DataSource.TableSelection table = new DataSource.TableSelection();
		table.tableSelected = 'Transaction Detail';
		table.columnsSelected = new List<DataSource.ColumnSelection>{selection};

		context.tableSelection = table;
		////////////////////////////////////////////////////////////

		Test.setMock(HttpCalloutMock.class, new ExternalDataConnection_Test.MockHttpSuccessGenerator());
		// Execute the query WITH mock
		DataSource.TableResult detailRecords = edc.query(context);
		system.debug(detailRecords);
		System.assert(detailRecords.totalSize == 1);
		System.assert(!detailRecords.rows[0].containsKey('Transaction Line ID'));

		Test.stopTest();
	}

	testmethod static void externalDataConnectionOutstandingBalance() {

		Test.startTest();

		ExternalDataConnection edc = new ExternalDataConnection(null);
		edc.sync();

		// Generate a query context ////////////////////////////////
		DataSource.QueryContext context = new DataSource.QueryContext();
		context.offset = 0;
		context.queryMoreToken = null;

		DataSource.Filter filterClass = new DataSource.Filter();
		filterClass.columnName = 'Mascus Customer Number';
		filterClass.columnValue = 'M000111111';
		filterClass.tableName = 'Outstanding Balance';
		filterClass.type = DataSource.FilterType.EQUALS;

		DataSource.TableSelection table = new DataSource.TableSelection();
		table.tableSelected = 'Outstanding Balance';
		table.filter = filterClass;

		context.tableSelection = table;
		////////////////////////////////////////////////////////////

		Test.setMock(HttpCalloutMock.class, new ExternalDataConnection_Test.MockHttpResponseGenerator());
		// Execute the query WITH mock
		DataSource.TableResult balanceRecords = edc.query(context);
		
		System.assert(balanceRecords.totalSize == 1);
		System.assert(balanceRecords.rows[0].get('Total Remaining Amount') == 600);
		System.assert(balanceRecords.rows[0].get('30-60 Days') == 100);
		System.assert(balanceRecords.rows[0].get('60-90 Days') == 200);
		System.assert(balanceRecords.rows[0].get('Greater than 90 Days') == 300);

		Test.stopTest();
	}

	testmethod static void testExternalDataProvider() {

		Test.startTest();

		ExternalDataProvider edp = new ExternalDataProvider();

		List<DataSource.Capability> capability = edp.getCapabilities();
		List<DataSource.AuthenticationCapability> authCapability = edp.getAuthenticationCapabilities();
		
		edp.getConnection(null);

		Test.stopTest();
	}
	
	public class MockHttpResponseGenerator implements HttpCalloutMock {
	    // Implement this interface method
	    public HTTPResponse respond(HTTPRequest req) {
	        
	    	String responseBody;

	        if (req.getEndpoint() == 'callout:ExternalDataBoomi/getTransactionSummary') {
	        	if (req.getBody().contains('"filterByExternalID":null') || !req.getBody().contains('filterByExternalID')) {
	        		responseBody = JSON.serialize(new TransactionSummaryJSON(10, 'M000111111')).replaceAll('CurrencyCode', 'Currency');	
	        	} else {
		        	responseBody = JSON.serialize(new TransactionSummaryJSON(1, 'M000111111')).replaceAll('CurrencyCode', 'Currency');
		        }
	        } else if (req.getEndpoint() == 'callout:ExternalDataBoomi/getTransactionLineDetail') {
	        	if (req.getBody().contains('"filterByExternalID":null') || !req.getBody().contains('filterByExternalID')) {
		        	responseBody = JSON.serialize(new TransactionDetailJSON(10, 'M000111111'));
		        } else {
		        	responseBody = JSON.serialize(new TransactionDetailJSON(1, 'M000111111'));
		        }
	        } else if (req.getEndpoint() == 'callout:ExternalDataBoomi/getOutstandingBalance') {
	        	responseBody = JSON.serialize(new OutstandingBalanceJSON()).replace('30_60', '30-60').replace('60_90', '60-90').replace('Amount90', 'Amount>90');
	        }

	        System.assertEquals('POST', req.getMethod());
	        
	        // Create a fake response
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody(responseBody);
	        res.setStatusCode(200);
	        return res;
	    }
	}

	public class MockHttpSuccessGenerator implements HttpCalloutMock {
	    // Implement this interface method
	    public HTTPResponse respond(HTTPRequest req) {
    		HttpResponse res = new HttpResponse();
    		res.setStatusCode(200);
	        return res;
	    }
	}

	private class TransactionSummaryJSON {
		private List<TransactionSummary> Transactions;

		private TransactionSummaryJSON(Integer numberOfRecords, String mascusCustomerNumber) {
			Transactions = new List<TransactionSummary>();

			for (Integer i = 0; i < numberOfRecords; i++) {
				Transactions.add(new TransactionSummary(i, mascusCustomerNumber));
			}
		}
	}

	private class TransactionSummary {
		private String Transaction_Type;
        private String Transaction_Number;
        private String Transaction_ID;
        private String Transaction_Date;
        private String CurrencyCode;
        private String Original_Amount;
        private String Remaining_Amount;
        private String Status;
        private String Due_Date;
        private String Days_Late;
        private String Print_Date;
        private String Print_Flag;
        private String Comments;
        private String Mascus_Customer_Number;
        private String Attachment_Base64;

        private TransactionSummary(Integer transactionNumber, String mascusCustomerNumber) {
	        Transaction_Type = 'Test Transaction Type';
	        Transaction_Number = String.valueOf(transactionNumber);
	        Transaction_ID = String.valueOf('ID' + transactionNumber);
	        Transaction_Date = String.valueOf(System.today().addMonths(transactionNumber * -1));
	        CurrencyCode = 'EUR';
	        Original_Amount = String.valueOf(100 * transactionNumber);
	        Remaining_Amount = String.valueOf((100 * transactionNumber) - transactionNumber);
	        Status = 'Test Transaction Status';
	        Due_Date = String.valueOf(System.today().addMonths(transactionNumber * -1));
	        Days_Late = String.valueOf(0 + transactionNumber);
	        Print_Date = String.valueOf(System.today());
	        Print_Flag = 'N';
	        Comments = 'Test Transaction Comment';
	        Mascus_Customer_Number = mascusCustomerNumber;
	        Attachment_Base64 = 'Test Transaction Attachment';
        }
	}

	private class TransactionDetailJSON {
		private List<TransactionDetail> TransactionDetails;

		private TransactionDetailJSON(Integer numberOfRecords, String orderNumber) {
			TransactionDetails = new List<TransactionDetail>();

			for (Integer i = 0; i < numberOfRecords; i++) {
				TransactionDetails.add(new TransactionDetail(i, orderNumber));
			}
		}
	}

	private class TransactionDetail {
		private String Transaction_ID;
        private String Transaction_Line_ID;
        private String Line_Number;
        private String Item;
        private String Description;
        private String Unit_Of_Measure;
        private String Quantity;
        private String Unit_Selling_Price;
        private String Amount;
        private String Contract_Number;
        private String Contract_Line_Number;
        private String Bill_From_Date;
        private String Bill_To_Date;

        private TransactionDetail(Integer detailNumber, String orderNumber) {
	        Transaction_ID = String.valueOf('ID' + detailNumber);
	        Transaction_Line_ID = String.valueOf('LineID' + detailNumber);
	        Line_Number = String.valueOf(detailNumber);
	        Item = 'Amazing Item ' + detailNumber;
	        Description = 'Amazing Description ' + detailNumber;
	        Unit_Of_Measure = 'Monthly';
	        Quantity = String.valueOf(detailNumber * 1);
	        Unit_Selling_Price = String.valueOf(detailNumber * 10);
	        Amount = String.valueOf((detailNumber * 1) * (detailNumber * 10));
	        Contract_Number = orderNumber;
	        Contract_Line_Number = String.valueOf(1000 + detailNumber);
	        Bill_From_Date = String.valueOf(System.today());
	        Bill_To_Date = String.valueOf(System.today().addMonths(detailNumber));
        }
	}

	private class OutstandingBalanceJSON {
		private List<OutstandingBalance> OutstandingBalance;

		private OutstandingBalanceJSON() {
			OutstandingBalance = new List<OutstandingBalance>();
			OutstandingBalance.add(new OutstandingBalance());
		}
	}

	private class OutstandingBalance {
		private Decimal Total_Remaining_Amount;
        private Decimal Remaining_Amount30_60;
        private Decimal Remaining_Amount60_90;
        private Decimal Remaining_Amount90;

        private OutstandingBalance() {
	        Total_Remaining_Amount = 600;
	        Remaining_Amount30_60 = 100;
	        Remaining_Amount60_90 = 200;
	        Remaining_Amount90 = 300;
        }
	}
}