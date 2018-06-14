/**************************************************************************
 * Description  : Aura controler to create a platform event
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       20/09/2017      Initial implementation
 **************************************************************************/
public class MAS_CreatePlatformEventAuraController {
	
    @AuraEnabled
    public static list<string> createPlatformEvent(Id recordId){
        
        list<string> status = new list<string>();
        MAS_ResponseDTO res = MAS_OrderService.orderUpsertPlatformEvent(recordId);
        status.add(res.responseType);       
        status.add(res.responseMessage);

        return status;
    }
    
    @AuraEnabled 
    public static Boolean checkOrderIsActivated(Id recordId){
       return  MAS_OrderService.getOrderStatusByOrderProId(recordId);
    }
    
}