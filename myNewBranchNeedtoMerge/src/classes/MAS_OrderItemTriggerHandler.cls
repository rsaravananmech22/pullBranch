/**************************************************************************
 * Description  : Apex TriggerHandler for order Item related functions
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR              DATE            DETAIL
     1.0       Samith Perera       24/11/2017      Initial implementation
 **************************************************************************/
public class MAS_OrderItemTriggerHandler {

    public static boolean doNotSyncOrderItemCancellation = false;
    
    public static void syncOrderItemWithMascus(list<OrderItem>newItems, list<OrderItem>oldItems){ 
    
        if(doNotSyncOrderItemCancellation) return;
        
        doNotSyncOrderItemCancellation = true;
        
        if(!System.isBatch()){
            
            list<Id> orderIds = new list<Id>();
    
            for (Integer i = 0; i < newItems.size(); i++) {  
    
                system.debug('######cancellation_date__c' +  newItems[i].cancellation_date__c);

                if(newItems[i].cancellation_date__c != null  && newItems[i].cancellation_date__c != oldItems[i].cancellation_date__c){                      
                    orderIds.add(newItems[i].orderId);
                }             
            } 
    
            if(orderIds.size() > 0){
                system.debug('######order' +  orderIds);
                if(!Test.isRunningTest()){
                    MAS_OrderService.syncOrderItemCancelationWithMascus(orderIds);
                }
            }
        }
    }

    public static void createCommissionSplitting(Set<Id> orderItemIds){
        MAS_OrderService.createCommissionSplitting(orderItemIds);
    }

    public static void validateOrderItems(List<OrderItem> orderItemList, Boolean isInsert) {
        // Map<Id, List<OrderItem>> pbeIdToorderItemsMap = new Map<Id, List<OrderItem>>();
        MAS_OrderService.validateDiscountPercentageForOrderItems(orderItemList, isInsert);
    }
    
}