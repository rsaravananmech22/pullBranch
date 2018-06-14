/**************************************************************************
 * Description  : Apex Trigger for Order 
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       20/11/2017      Initial implementation
 **************************************************************************/
trigger Order on Order(Before insert, Before update, After insert, After update, After delete, After undelete) {
    if (Trigger.IsBefore) {

        if (Trigger.IsInsert) {
            
            MAS_OrderTriggerHandler.setOrderOwner(trigger.new);
            MAS_OrderTriggerHandler.updateAddressFieldsAndInvoiceInfo(Trigger.new, Trigger.oldMap, true);

        } else if (Trigger.IsUpdate) {
            
            MAS_OrderTriggerHandler.updateAddressFieldsAndInvoiceInfo(Trigger.new, Trigger.oldMap, false);
            MAS_OrderTriggerHandler.activateClonedOrders(Trigger.new);
        
        }
        
    } else if (Trigger.IsAfter) {

        if (Trigger.IsInsert) {            
        
        } else if (Trigger.IsUpdate) {
        
            MAS_OrderTriggerHandler.activateOrderItemsOnOrderActivation(Trigger.newMap, Trigger.oldMap);
            MAS_OrderTriggerHandler.updateCommissionSplittingsWhenOwnerChanged(Trigger.new, Trigger.oldMap);
        
        }
    }
}