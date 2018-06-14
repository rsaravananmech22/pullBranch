global class ExternalDataConnection extends DataSource.Connection {

    global ExternalDataConnection(DataSource.ConnectionParams connectionParams) {}
    
    // Variables used throughout the class
    private Account accRecord;
    private Integer recordLimit = 100;
    private String summaryExternalId;
    private String globalMascusCustomerId;    
    private Boolean accountQueried = false;

    // Declare the external objects for this DataSource
    override global List<DataSource.Table> sync() {

        List<DataSource.Table> tables = new List<DataSource.Table>();
        List<DataSource.Column> transactionSummary;
        List<DataSource.Column> transactionDetail;
        List<DataSource.Column> outstandingBalance;
        
        // Transaction Summary Object
        transactionSummary = new List<DataSource.Column>();
        transactionSummary.add(DataSource.Column.url('DisplayUrl'));
        transactionSummary.add(DataSource.Column.text('ExternalId'));
        transactionSummary.add(DataSource.Column.text('CurrencyIsoCode'));
        transactionSummary.add(DataSource.Column.text('Transaction Type'));
        transactionSummary.add(DataSource.Column.text('Transaction Number'));
        transactionSummary.add(DataSource.Column.text('Transaction ID'));
        transactionSummary.add(DataSource.Column.text('Transaction Date'));
        transactionSummary.add(DataSource.Column.number('Original Amount', 18, 2));
        transactionSummary.add(DataSource.Column.number('Remaining Amount', 18, 2));
        transactionSummary.add(DataSource.Column.text('Status'));
        transactionSummary.add(DataSource.Column.text('Due Date'));
        transactionSummary.add(DataSource.Column.number('Days Late', 18, 0));
        transactionSummary.add(DataSource.Column.text('Invoice Sent Date'));
        transactionSummary.add(DataSource.Column.text('Print Flag', 2));
        transactionSummary.add(DataSource.Column.text('Comments'));
        transactionSummary.add(DataSource.Column.text('Mascus Customer Number'));   // Unique Identifier used to get all related records
        transactionSummary.add(DataSource.Column.text('Mascus Customer ID'));       // Unique Identifier used to link Summary with Account
        transactionSummary.add(DataSource.Column.textArea('Attachment Base64'));
        
        tables.add(DataSource.Table.get('Transaction Summary', 'Transaction Number', transactionSummary));
        
        // Transaction Detail Object
        transactionDetail = new List<DataSource.Column>();
        transactionDetail.add(DataSource.Column.text('ExternalId'));
        transactionDetail.add(DataSource.Column.url('DisplayUrl'));
        transactionDetail.add(DataSource.Column.text('Transaction ID'));    // Unique Identifier used to get all related records
        transactionDetail.add(DataSource.Column.text('Transaction Line ID'));
        transactionDetail.add(DataSource.Column.number('Line Number', 18, 0));
        transactionDetail.add(DataSource.Column.text('Item'));
        transactionDetail.add(DataSource.Column.text('Description'));
        transactionDetail.add(DataSource.Column.text('Unit Of Measure'));
        transactionDetail.add(DataSource.Column.number('Quantity', 18, 0));
        transactionDetail.add(DataSource.Column.number('Unit Selling Price', 18, 2));
        transactionDetail.add(DataSource.Column.number('Amount', 18, 2));
        transactionDetail.add(DataSource.Column.text('Order Number'));
        transactionDetail.add(DataSource.Column.text('Order Product Number'));
        transactionDetail.add(DataSource.Column.text('Bill From Date'));
        transactionDetail.add(DataSource.Column.text('Bill To Date'));
        transactionDetail.add(DataSource.Column.text('Link To Order'));

        tables.add(DataSource.Table.get('Transaction Detail', 'Description', transactionDetail));

        // Outstanding Balance Object
        outstandingBalance = new List<DataSource.Column>();
        outstandingBalance.add(DataSource.Column.url('DisplayUrl'));
        outstandingBalance.add(DataSource.Column.text('ExternalId'));
        outstandingBalance.add(DataSource.Column.text('CurrencyIsoCode'));
        outstandingBalance.add(DataSource.Column.text('Mascus Customer Number'));   // Unique Identifier used to get all related records
        outstandingBalance.add(DataSource.Column.text('Mascus Customer ID'));       // Unique Identifier used to link Summary with Account
        outstandingBalance.add(DataSource.Column.number('Total Remaining Amount', 18, 2));
        outstandingBalance.add(DataSource.Column.number('0-30 Days', 18, 2));
        outstandingBalance.add(DataSource.Column.number('30-60 Days', 18, 2));
        outstandingBalance.add(DataSource.Column.number('60-90 Days', 18, 2));
        outstandingBalance.add(DataSource.Column.number('Greater than 90 Days', 18, 2));
        
        tables.add(DataSource.Table.get('Outstanding Balance', 'Mascus Customer Number', outstandingBalance));

        return tables;
    }

    override global DataSource.TableResult query(DataSource.QueryContext context) {

        Integer offset = context != null ? context.offset : null;
        String queryMoreToken = context != null ? context.queryMoreToken : null;
        String tableSelected = context != null && context.tableSelection != null ? context.tableSelection.tableSelected : null;
        DataSource.Filter filter = context != null && context.tableSelection != null ? context.tableSelection.filter : null;        
        List<DataSource.Order> order = context != null && context.tableSelection != null ? context.tableSelection.order : null;
        
        String url = (tableSelected == 'Transaction Summary' ? 'getTransactionSummary' : (tableSelected == 'Transaction Detail' ? 'getTransactionLineDetail' : 'getOutstandingBalance' ));
        
        RequestWrapper requestParameters = new RequestWrapper();

        // Apply Sort Order
        if (tableSelected == 'Transaction Summary') {
            //requestParameters.sortColumn = (order.size() > 0 && order[0].columnName != 'ExternalId') ? order[0].columnName : 'Status';
            //requestParameters.sortOrder = (order.size() > 0 && order[0].columnName != 'ExternalId') ? (order[0].direction == DataSource.OrderDirection.ASCENDING ? 'ASCENDING' : 'DESCENDING') : 'DESCENDING';
            requestParameters.sortColumn = 'Status';
            requestParameters.sortOrder = 'DESCENDING';
        }

        requestParameters.offset = String.valueOf((offset != null ? offset : 0));
        
        // Apply Filters and Sub-Filters
        if (filter != null && filter.type == DataSource.FilterType.EQUALS && filter.columnValue instanceOf String) {            
            
            if (filter.columnName == 'Mascus Customer Number' || filter.columnName == 'Mascus Customer ID') {
                // Used for Transaction Summary
                getAccountDetails((String)filter.columnValue);
                requestParameters.filterByUniqueID = accRecord != null ? accRecord.Mascus_Customer_Number__c : (String)filter.columnValue;

            } else if (filter.columnName == 'ExternalId') {
                // Used for both Summary and Detail
                requestParameters.filterByExternalID = ((String)filter.columnValue).substringBefore(':');
                requestParameters.filterByUniqueID = ((String)filter.columnValue).substringAfter(':');

            } else if (filter.columnName == 'Transaction ID') {
                // Used for Transaction Detail
                summaryExternalId = (String)filter.columnValue;
                requestParameters.filterByUniqueID = ((String)filter.columnValue).substringBefore(':');
            }
        } else if (filter != null && filter.columnName == null && filter.subfilters.size() > 0) {
            
            for (Integer i = 0; i < filter.subfilters.size(); i++) {
                
                if (filter.subfilters[i].columnName == 'Mascus Customer Number' || filter.subfilters[i].columnName == 'Mascus Customer ID') {
                    // Used for Transaction Summary
                    getAccountDetails((String)filter.subfilters[i].columnValue);
                    requestParameters.filterByUniqueID = accRecord != null ? accRecord.Mascus_Customer_Number__c : (String)filter.subfilters[i].columnValue;
                
                } else if (filter.subfilters[i].columnName == 'ExternalId') {
                    // Used for both Summary and Detail
                    requestParameters.filterByExternalID = ((String)filter.subfilters[i].columnValue).substringBefore(':');
                    requestParameters.filterByUniqueID = ((String)filter.subfilters[i].columnValue).substringAfter(':');
                
                } else if (filter.subfilters[i].columnName == 'Transaction ID') {
                    // Used for Transaction Detail
                    summaryExternalId = (String)filter.subfilters[i].columnValue;
                    requestParameters.filterByUniqueID = ((String)filter.subfilters[i].columnValue).substringBefore(':');
                }
            }
        }//requestParameters.filterbyUniqueID='M0065763';

        if (context != null && context.tableSelection != null && context.tableSelection.columnsSelected != null && 
            context.tableSelection.columnsSelected.size() == 1 && context.tableSelection.columnsSelected.get(0).aggregation == DataSource.QueryAggregation.COUNT) {
            
            Map<String, Object> countRow = new Map<String, Object>();    
            List<Map<String, Object>> countResponse = new List<Map<String, Object>>();
            List<Map<String,Object>> rows = getRecords(url, requestParameters, tableSelected);
            
            countRow.put(context.tableSelection.columnsSelected.get(0).columnName, rows.size());
            countResponse.add(countRow);

            DataSource.TableResult results = DataSource.TableResult.get(context,countResponse);
            results.queryMoreToken = rows.size() == recordLimit ? String.valueOf(recordLimit) : NULL;

            return results;

        } else {

            List<Map<String,Object>> rows = getRecords(url, requestParameters, tableSelected);
            
            DataSource.TableResult results = DataSource.TableResult.get(true, null, context.tableSelection.tableSelected, rows);
            results.queryMoreToken = rows.size() == recordLimit ? String.valueOf(recordLimit) : NULL;
            
            return results;
        }                
    }


    public List<Map<String, Object>> getRecords(String url, RequestWrapper postBody, String tableSelected) {
        
        List<Map<String, Object>> rows = new List<Map<String, Object>>();

        try{
            String body = getResponse(url, postBody).getBody();
            
            if (body != null && body != '') {

                Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);

                // Check errors
                Map<String, Object> error = (Map<String, Object>)responseBodyMap.get('error');
                if (error != null) {
                
                    List<Object> errorsList = (List<Object>)error.get('errors');
                    Map<String, Object> errors = (Map<String, Object>)errorsList[0];
                    String messages = (String)errors.get('message');
                    throw new DataSource.OAuthTokenExpiredException(messages);
                }

                if (tableSelected == 'Transaction Summary') {
                    List<Object> sItems = (List<Object>)responseBodyMap.get('Transactions');
                    if (sItems != null) {
                        for (Integer i=0; i < sItems.size(); i++) {
                            Map<String, Object> item = (Map<String, Object>)sItems[i];
                            rows.add(createSummaryRows(item));
                        }
                    }
                } else if (tableSelected == 'Transaction Detail') {
                    Map<String, String> orderNumberToIdMap = new Map<String, String>();
                    List<Object> sItems = (List<Object>)responseBodyMap.get('TransactionDetails');
                    if (sItems != null) {
                        for (Integer i=0; i < sItems.size(); i++) {
                            Map<String, Object> item = (Map<String, Object>)sItems[i];
                            orderNumberToIdMap.put((String)item.get('Contract_Number'), null);
                        }

                        for (Order ord: [SELECT Id, Mascus_Order_Number__c, Mascus_Order_Id__c FROM Order WHERE Mascus_Order_Number__c IN :orderNumberToIdMap.keySet()]) {
                            orderNumberToIdMap.put(ord.Mascus_Order_Number__c, ord.Id);
                        }

                        for (Integer i=0; i< sItems.size(); i++) {
                            Map<String, Object> item = (Map<String, Object>)sItems[i];
                            rows.add(createDetailRows(item, orderNumberToIdMap.get((String)item.get('Contract_Number'))));
                        }
                    }
                } else if (tableSelected == 'Outstanding Balance') {
                    List<Object> sItems = (List<Object>)responseBodyMap.get('OutstandingBalance');
                    if (sItems != null) {
                        for (Integer i=0; i < sItems.size(); i++) {
                            Map<String, Object> item = (Map<String, Object>)sItems[i];
                            rows.add(createBalanceRows(item));
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Exception Message==' + e.getMessage());
            throw new DataSource.OAuthTokenExpiredException(Label.LBL_ERR_ExternalDataSources);
        }
        return rows;
    }

    // Helper method to populate a row based on source data
    // The item argument maps to the data that represents a row.
    // Returns an updated map with the External ID and Display URL values.    
    public Map<String, Object> createSummaryRows(Map<String, Object> item) {

        // Grab the MascusCustomerID for records queried using ExternalID'
        if (!accountQueried && accRecord == null && globalMascusCustomerId == null && item != null && item.containsKey('Mascus_Customer_Number')) {
            getAccountDetails((String)item.get('Mascus_Customer_Number'));
        }

        Map<String, Object> row = new Map<String, Object>();
        for ( String key : item.keySet() ) {
            row.put('ExternalId', item.get('Transaction_ID') + ':' + item.get('Mascus_Customer_Number'));
            row.put('Transaction Type', item.get('Transaction_Type'));
            row.put('Transaction Number', item.get('Transaction_Number'));
            row.put('Transaction ID', item.get('Transaction_ID'));
            row.put('Transaction Date', item.get('Transaction_Date') != null ? ((String)item.get('Transaction_Date')).substringBefore(' ') : item.get('Transaction_Date'));
            row.put('CurrencyIsoCode', item.get('Currency'));
            row.put('Original Amount', item.get('Original_Amount'));
            row.put('Remaining Amount', item.get('Remaining_Amount'));
            row.put('Status', item.get('Status'));
            row.put('Due Date', item.get('Due_Date') != null ? ((String)item.get('Due_Date')).substringBefore(' ') : item.get('Due_Date'));
            row.put('Days Late', item.get('Days_Late'));
            row.put('Invoice Sent Date', item.get('Print_Date') != null ? ((String)item.get('Print_Date')).substringBefore(' ') : item.get('Print_Date'));
            row.put('Print Flag', item.get('Print_Flag'));
            row.put('Comments', item.get('Comments'));
            row.put('Mascus Customer Number', item.get('Mascus_Customer_Number'));
            row.put('Mascus Customer ID', globalMascusCustomerId);
            row.put('Attachment Base64', item.get('Attachment_Base64'));
        }
        return row;
    }

    public Map<String, Object> createDetailRows(Map<String, Object> item, String mascusOrderId) {
        
        Map<String, Object> row = new Map<String, Object>();
        for ( String key : item.keySet() ){
            row.put('ExternalId', item.get('Transaction_Line_ID') + ':' + item.get('Transaction_ID'));
            row.put('Transaction ID', summaryExternalId);
            row.put('Transaction Line ID', item.get('Transaction_Line_ID'));
            row.put('Line Number', item.get('Line_Number'));
            row.put('Item', item.get('Item'));
            row.put('Description', item.get('Description'));
            row.put('Unit Of Measure', item.get('Unit_Of_Measure'));
            row.put('Quantity', item.get('Quantity'));
            row.put('Unit Selling Price', item.get('Unit_Selling_Price'));
            row.put('Amount', item.get('Amount'));
            row.put('Order Number', item.get('Contract_Number'));
            row.put('Order Product Number', item.get('Contract_Line_Number'));
            row.put('Bill From Date', item.get('Bill_From_Date') != null ? ((String)item.get('Bill_From_Date')).substringBefore(' ') : item.get('Bill_From_Date'));
            row.put('Bill To Date', item.get('Bill_To_Date') != null ? ((String)item.get('Bill_To_Date')).substringBefore(' ') : item.get('Bill_To_Date'));
            row.put('Link To Order', mascusOrderId);
            //row.put('Link To Order', '6787');            
        }
        return row;
    }

    public Map<String, Object> createBalanceRows(Map<String, Object> item) {

        // Grab the MascusCustomerID for records queried using ExternalID'
        if (!accountQueried && accRecord == null && globalMascusCustomerId == null && item != null && item.containsKey('Mascus_Customer_Number')) {
            getAccountDetails((String)item.get('Mascus_Customer_Number'));
        }

        Map<String, Object> row = new Map<String, Object>();
        for ( String key : item.keySet() ) {
            row.put('ExternalId', item.get('Mascus_Customer_Number'));
            row.put('CurrencyIsoCode', item.get('Currency'));
            row.put('Mascus Customer Number', item.get('Mascus_Customer_Number'));
            row.put('Mascus Customer ID', globalMascusCustomerId);
            row.put('Total Remaining Amount', item.get('Total_Remaining_Amount'));
            row.put('0-30 Days', item.get('Remaining_Amount0-30'));
            row.put('30-60 Days', item.get('Remaining_Amount30-60'));
            row.put('60-90 Days', item.get('Remaining_Amount60-90'));
            row.put('Greater than 90 Days', item.get('Remaining_Amount>90'));
        }
        return row;
    }

    // Helper method to make the HTTP GET call. Returns the response from the external system.
    public HttpResponse getResponse(String url, RequestWrapper postBody) {

        Http httpProtocol = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST'); 
        req.setTimeout(120000);
        req.setBody(JSON.serialize(postBody));
        req.setEndpoint('callout:ExternalDataBoomi/' + url); // Using named credentials to keep the keys and endpoints secure
        req.setHeader('Content-Type', 'application/json');
        HttpResponse response = httpProtocol.send(req);
        return response;
    }

    // Set Mascus Customer Id
    private void getAccountDetails(String uniqueIdentifier) {
        
        if (!accountQueried && uniqueIdentifier != null) {
            
            List<Account> accounts= [SELECT Id, Mascus_Customer_Number__c, Mascus_Customer_Id__c FROM Account 
                                    WHERE Mascus_Customer_Number__c = :uniqueIdentifier OR Mascus_Customer_Id__c = :uniqueIdentifier LIMIT 1];

            if ( accounts.size() > 0 ){
                accRecord = accounts[0];
                globalMascusCustomerId = accRecord.Mascus_Customer_Id__c;
            }
        }
    }

    private class RequestWrapper {        
        private String filterByUniqueID;
        private String filterByExternalID;
        private String sortColumn;
        private String sortOrder;
        private String offset;
    }
}