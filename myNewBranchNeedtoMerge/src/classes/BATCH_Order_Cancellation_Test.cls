@isTest
private class BATCH_Order_Cancellation_Test {

	@isTest static void goodTillCancelledItemsArriveAtEndDate() {
		//Create test data
		
		OrderService_Test.createData();
		//Query the original 200 orders
		Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([	SELECT Id 
																	FROM Order ]);
        system.debug('count'+[select count(id) from order]);
		//Query 100 orders and their order items
		Map<Id, Order> mapIdToOrdersToProcess = new Map<Id, Order>([SELECT Id, (SELECT Id,EndDate FROM OrderItems) 
																	FROM Order 
																	LIMIT 100]);		
		//Loop through the items and set their end date to today and Subscription term length to 'Good till cancelled'
		List<OrderItem> items = new List<OrderItem>();
       
		for(Order o : mapIdToOrdersToProcess.values()){
			for(OrderItem oi : o.OrderItems){
				//oi.EndDate = system.today();
				system.debug('EndDate'+oi.EndDate);
				oi.Subscription_term_length__c='Good till cancelled';	
				items.add(oi);
			}
	    	//Activate the orders
	    	o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
	        o.Activated__c = true;
		}
        
		update items;
        update mapIdToOrdersToProcess.values();
        
		//Kick off the batch process
		Test.startTest();
		MAS_BATCH_Order_Cancellation Order_Cancel = new MAS_BATCH_Order_Cancellation();
		ID batchId = Database.executeBatch(Order_Cancel);
		Test.stopTest();
        //  system.debug('query result'+[SELECT id,Cancellation_reason__c 
		// 													FROM OrderItem 
		// 													WHERE OrderId IN :mapIdToOrdersToProcess.keySet()]);
		
		System.debug('SOQL Executed : '+ Limits.getQueries());

		OrderItem orderItem = [	SELECT Id, Cancellation_reason__c, Renewal_Type__c
															FROM OrderItem 
															WHERE OrderId IN :mapIdToOrdersToProcess.keySet() 
															LIMIT 1];

		Order order = [	SELECT Id, EffectiveDate, Billing_start_date__c
											FROM Order
											WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
											LIMIT 1];													

		//Verify the linked order items of the active orders have been cancelled with the correct reason
		System.assertEquals('Product information change', orderItem.Cancellation_reason__c);
		//Verify the linked order items of the active orders have a renewal type = Extend Term
		System.assertEquals('Extend Term', orderItem.Renewal_Type__c);
		//Verify only 100 order items have a cancellation date filled in										
		/*System.assertEquals(10, [	SELECT count() 
									FROM OrderItem
									WHERE cancellation_date__c != null]);
		//Verify the 100 active orders have been cloned
		System.assertEquals(20, [	SELECT count() 
									FROM Order]);
		//Verify the cloned orders have correct start dates = earliest renewal date of the cloned order items (today)
		System.assertEquals(Date.today().adddays(10), order.EffectiveDate);

		System.assertEquals(Date.today().adddays(10), order.Billing_start_date__c);	*/

		//Verify there are 100 cloned order items with end date = today + 2 years
		/*Date inTwoYears = Date.today().addYears(2);
		System.assertEquals(100, [	SELECT count()
									FROM OrderItem
									WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
									AND EndDate = :inTwoYears]); 
		//Verify all of the cloned order items have the renewal checkbox set to true
		System.assertEquals(100, [	SELECT count()
									FROM OrderItem
									WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
									AND Renewal__c = true]); 
		//Verify the cloned order items have all cancellation and renewal fields set to null
		String fieldsConcatenation;
		for(OrderItem oi : [SELECT cancellation_date__c, Cancellation_reason__c, cancellation_reason_description__c, Renewal_Type__c, Renewal_price__c, Renewal_date__c
							FROM OrderItem
							WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()]){
			fieldsConcatenation = fieldsConcatenation + String.valueOf(oi.cancellation_date__c) + oi.Cancellation_reason__c + oi.cancellation_reason_description__c + oi.Renewal_Type__c + oi.Renewal_price__c + String.valueOf(oi.Renewal_date__c);
		}
		fieldsConcatenation = fieldsConcatenation.replace('null', '');
		System.assertEquals('', fieldsConcatenation);
		//Verify the cloned orders have been activated
		System.assertEquals(100, [	SELECT count()
									FROM Order
									WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
									AND Status = 'Activated']);
		//Verify the original active orders' items have their end date set equal to the cancellation date
		Date yesterday = Date.today() - 1;
		System.assertEquals(yesterday, [SELECT EndDate
										FROM OrderItem
										WHERE OrderId IN :mapIdToOrdersToProcess.keySet()
										LIMIT 1].EndDate);*/
       
		System.debug('SOQL Executed : '+ Limits.getQueries());

	}	
}