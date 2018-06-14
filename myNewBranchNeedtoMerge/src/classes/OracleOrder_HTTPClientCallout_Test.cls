@isTest
private class OracleOrder_HTTPClientCallout_Test {
      @testSetup public static void createData() {
		//Create custom settings used in trigger handlers
		Test.startTest();
		Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='false'), true);
		Configuration__c c2 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c='false'), true);		
		Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACTIONLOG_TO_EMAIL_ADDRESSES, Value__c='test@test.com'), true);
		//Create a customer account and a legal entity
		Account insertacc=new Account(ShippingStreet='Meir 1',
		                      ShippingCity='Antwerp',
		                      ShippingPostalCode='2000',
		                      ShippingState='Haryana',
		                      ShippingCountry='India',
                              Billing_Cycle_preference__c='Monthly',
		                      Invoicing_preference__c='Mail',
		                      Invoicing_Rule__c='In advance',
		                      Payment_method__c='By Invoice',
		                      Payment_term__c='Immediately');
		Account a = (Account)MAS_TestDataFactory.createSObject(insertacc, true);
		Account legalEntityacc=new Account(Name='Legal Entity', 
		                      RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId(),
		                      ShippingStreet='Meir 1',
		                      ShippingCity='Antwerp',
		                      ShippingPostalCode='2000',
		                      ShippingState='Bihar',
		                      ShippingCountry='India',
                              BillingCountry='India',
		                      BillingState='Bihar',
		                      Billing_Cycle_preference__c='Monthly',
		                      Invoicing_preference__c='Mail',
		                      Invoicing_Rule__c='In advance',
		                      Payment_method__c='By Invoice',
		                      Payment_term__c='Immediately',
                              type='Internal legal entity'
		                      );
		Account legalEntity = (Account)MAS_TestDataFactory.createSObject(legalEntityacc,true);
		//Create a contact for the customer account
		Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=a.Id), true);
		//Create a list of 200 orders
		Order[] oList = (Order[])MAS_TestDataFactory.createSObjectList(new Order(AccountId=a.Id, Bill_from_legal_entity__c=legalEntity.Id, Sold_to_Account__c=a.Id, BillToContactId=c.Id, Sold_to_contact__c=c.Id), 10, true);
		//Create one product and a price book entry for it
		Product2 p = (Product2)MAS_TestDataFactory.createSObject(new Product2(), true);
		PricebookEntry pbe = (PricebookEntry)MAS_TestDataFactory.createSObject(new PricebookEntry(Product2Id=p.Id), true);
		//Create one order items per order
		List<OrderItem> items = new List<OrderItem>();
		for(Order o : oList){
			OrderItem oi = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id, PricebookEntryId=pbe.Id,Subscription_term_length__c='Fixed term'));
			items.add(oi);
		}
		insert items;
		Test.stopTest();
	}
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MAS_MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        
       //Query the original 200 orders
		Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([	SELECT Id 
																	FROM Order]);
        system.debug(mapIdToOriginalOrders);
		//Activate 2 out of the 200 orders
		Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([	SELECT Id,status 
																	FROM Order 
																	LIMIT 2]);
		system.debug(mapIdToCloningOrders);
       for(Order o : mapIdToCloningOrders.values()){
			system.debug(o);
			o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
            o.Activated__c = true;
		}
		update mapIdToCloningOrders.values();
       List<Order_Platform_Event__e> insertevents=new List<Order_Platform_Event__e>();
		for(order o:[select id,status from order where Status = 'Activated'])
        {
        MAS_OracleOrder_HTTPClient.doHTTPPost('test',o.id,'EUR');
        }
        
        
    }
     @isTest static void CalloutFailureCase() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MAS_MockHttpResponseFailGenerator());
                
       //Query the original  orders
		Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([	SELECT Id 
																	FROM Order]);
        system.debug(mapIdToOriginalOrders);
		//Activate 2 out of the  orders
		Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([	SELECT Id,status 
																	FROM Order 
																	LIMIT 2]);
		system.debug(mapIdToCloningOrders);
       for(Order o : mapIdToCloningOrders.values()){
			o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
            o.Activated__c = true;
		}
		update mapIdToCloningOrders.values();
       List<Order_Platform_Event__e> insertevents=new List<Order_Platform_Event__e>();
         List<order> orderlist=[select id,status from order where Status = 'Activated'];
		for(order o:orderlist)
        {
        MAS_OracleOrder_HTTPClient.doHTTPPost('test',o.id,'EUR');
        }
        MAS_OracleOrder_HTTPClient.doHTTPPost('test',orderlist[0].id,'');
         
        
    }
}