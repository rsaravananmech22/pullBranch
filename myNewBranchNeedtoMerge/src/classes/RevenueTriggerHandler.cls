public class RevenueTriggerHandler {
	
	public static void setCountry(List<Revenue__c> revenues) {
		Set<Id> orderProductIds = new Set<Id>();
		Map<Id, List<Revenue__c>> orderProductRevenueMap = new Map<Id, List<Revenue__c>>();
		List<OrderItem> orderProducts = new List<OrderItem>();
		
		for(Revenue__c revenue : revenues) {
			orderProductIds.add(revenue.Order_Product__c);
			if(orderProductRevenueMap.get(revenue.Order_Product__c) == null) {
				orderProductRevenueMap.put(revenue.Order_Product__c, new List<Revenue__c>());
			}
			orderProductRevenueMap.get(revenue.Order_Product__c).add(revenue);
		}
		
		orderProducts = [SELECT Order.BillingCountry FROM OrderItem WHERE Id IN :orderProductIds];
		
		for(OrderItem orderProduct : orderProducts) {
			for(Revenue__c revenue : orderProductRevenueMap.get(orderProduct.Id)) {
				revenue.Country__c = orderProduct.Order.BillingCountry;
			}
		}
	}
	
}