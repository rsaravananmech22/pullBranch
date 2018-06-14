/**************************************************************************
 * Description  : Apex Trigger for orderItem 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       19/09/2019      Initial implementation
 **************************************************************************/
trigger OrderItem on OrderItem (before insert, before update,  after insert, after update, after delete, after undelete) {

    if (Trigger.isBefore) {

        if(Trigger.IsInsert){
            MAS_OrderItemTriggerHandler.validateOrderItems(Trigger.new, true);
        }else if(Trigger.IsUpdate){
            MAS_OrderItemTriggerHandler.validateOrderItems(Trigger.new, false);
        }else{

        }
    
    } else if (Trigger.isAfter) {

        if(Trigger.IsInsert){
            MAS_OrderItemTriggerHandler.createCommissionSplitting(Trigger.newMap.keySet());
        }else if(Trigger.IsUpdate){
            MAS_OrderItemTriggerHandler.syncOrderItemWithMascus(Trigger.new, Trigger.old);
        }else if(Trigger.Isdelete){
            
        }else{
            
        } 
    }
}