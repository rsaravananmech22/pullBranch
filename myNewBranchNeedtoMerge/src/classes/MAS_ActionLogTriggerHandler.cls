/**************************************************************************
 * Description  : Apex Trigger handler classs for MAS_ActionLogTrigger 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
    1.0        Kavinda Inusha      30/01/2018      Initial implementation
 **************************************************************************/
 public with sharing class MAS_ActionLogTriggerHandler {
	
	 /**
     * @Description: This method is check ActionLog status is Failed or not, if it is Failed this method will send a email
     * @author: Kavinda Inusha
     * @params: List<ActionLog__c> lstActionLog  - new ActionLog values list
     * @return: void
     */
    public static void sendActionLogFailureEmail(List<ActionLog__c> lstActionLog){

		for(ActionLog__c actLogObj : lstActionLog){
			if(String.valueOf(actLogObj.get(MAS_Constant.ACTION_LOG_FIELD_STATUS)).equalsIgnoreCase(MAS_Constant.ACTION_LOG_FIELD_STATUS_FAILED)){
				Boolean isSuccess = MAS_ActionLog.sendEmailWithActiveLog(actLogObj.Id);
			}
		}
		
	}
	
	public static void emailIntegrationFailure(List<ActionLog__c> actionLogs) {
		Set<Id> orderIds = new Set<Id>();
		
		for(ActionLog__c log : actionLogs) {
			if(log.Status__c == MAS_Constant.ACTION_LOG_STATUS_FAILED &&
				log.Source__c == MAS_Constant.ACTION_LOG_SOURCE_SF &&
				log.Target__c == MAS_Constant.ACTION_LOG_TRAGET_ORACLE &&
				log.ActionType__c == MAS_Constant.ACTION_LOG_TYPE_INSERT &&
				log.OrderId__c != null) {
				orderIds.add(log.OrderId__c);
			}
		}
		
		List<Order> ordersToEmail = [SELECT Status, Activated__c, Mascus_Order_Number__c, Owner.Email FROM Order WHERE Id IN :orderIds];
		List<Order> ordersToUpdate = new List<Order>();
		
		for(Order o : ordersToEmail) {
			MAS_OrderService.sendOrderErrorEmail(o.Mascus_Order_Number__c, MAS_Constant.ACTION_LOG_TRAGET_ORACLE);
		}
		
		update ordersToUpdate;
	}

}