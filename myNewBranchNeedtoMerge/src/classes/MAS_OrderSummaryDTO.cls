public with sharing class MAS_OrderSummaryDTO {
	public MAS_OrderSummaryDTO() {
		
	}

	@AuraEnabled public Order oderData{get;set;}
    @AuraEnabled public List<OrderDetail> orderProductsList {get;set;}
    @AuraEnabled public String  totalMonthlySubscription {get;set;}
    @AuraEnabled public String  totalSetUp {get;set;} 
    @AuraEnabled public String orderCurrency {get;set;} 
	@AuraEnabled public String totalNetValue {get;set;}

    public class OrderDetail{
 		@AuraEnabled public String  productName {get; set;}
 		@AuraEnabled public String  unitPrice {get; set;}
 		@AuraEnabled public String  unitofMeasure {get; set;}
 		@AuraEnabled public String  serviceDate {get; set;}
 		@AuraEnabled public String  totPrice {get;set;}
 		@AuraEnabled public String  orderCurrencyCode {get;set;}
    } 
}