public class MAS_BATCH_Order_Cancellation implements Database.Batchable<sObject>{
	
    
	String query = 'SELECT OrderId FROM OrderItem WHERE Order.Status = \'Activated\' AND EndDate = Today AND Subscription_term_length__c = \'Good till cancelled\' AND cancellation_date__c = null';
	
	public MAS_BATCH_Order_Cancellation() {
		
	}
	
	public Database.QueryLocator start(Database.BatchableContext BC) {
        
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<OrderItem> scope) {
        
		List<Id> orderIds = new List<Id>();
		for(OrderItem oi : scope){
			orderIds.add(oi.OrderId);
		}
		if(orderIds.size() > 0){
			System.debug(orderIds.size() + ' orders will be processed because of end day approaching.');
			MAS_OrderService.cancelOriginalOrderItems(orderIds, 'product_info_change'); 
        }    
	}
	
	public void finish(Database.BatchableContext BC) {
		
	}
	
}