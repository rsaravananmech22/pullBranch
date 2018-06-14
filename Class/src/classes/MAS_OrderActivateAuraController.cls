/**************************************************************************
* Description  : Aura controller for the Order Activation
* ========================================================================
* History                                                            
* ------------------------------------------------------------------------                                                            
* VERSION       AUTHOR            		    DATE            DETAIL  
1.0             Samith Perera               17/11/2017      Initial implementation                                    
1.1             Artash Manoucharjan         17/11/2017      Changes
**************************************************************************/

public class MAS_OrderActivateAuraController {
    
    @AuraEnabled
    public static Order getOrderInformation(Id orderId) {
    	try{
			return MAS_OrderService.getOrderInformation(orderId);
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }
    
    @AuraEnabled
    public static EmailTemplate getOrderConfirmationEmailTemplate(Order orderObject) {
    	try{
    		return MAS_OrderService.getOrderConfirmationEmailTemplate(orderObject);
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }
    
    @AuraEnabled
    public static String generateEmail(Order orderObject, List<OrderItem> orderItems, EmailTemplate template) {
    	try{
			return MAS_OrderService.generateEmail(orderObject, orderItems, template, false);
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }
    
     /**
     * @Description : Order custom validations
     * @author : Samith Perera, Artash
     * @params : ID : OrderId
     * @return : List<String> message, error type
     */
    @AuraEnabled
    public static list<string> orderValidation(Id recordId, Boolean isVatValidation, String classification) {
    	try{
	        list<string> status = new list<string>();
	        MAS_ResponseDTO res = null;
	
	        // Order Billing start date must be >= the MINIMUM Order Product Start Date
	        res = MAS_OrderService.billingStartDateCheck(recordId); 
	        
	        
	        if(res.responseType == MAS_Constant.RESPONSE_TYPE_ERROR){
	            status.add(res.responseType);
	            status.add(res.responseMessage);
	            return status;
	        }
	
	        // Check if all products have Orderline Splits
	        res = MAS_OrderService.OrderlineSplitCheck(recordId); 
	        if(res.responseType == MAS_Constant.RESPONSE_TYPE_ERROR){
	            status.add(res.responseType);
	            status.add(res.responseMessage);
	            return status;
	        }
	
	        // Check related account & contact
	        res = MAS_OrderService.accountandContactValidation(recordId); 
	        if(res.responseType == MAS_Constant.RESPONSE_TYPE_ERROR){
	            status.add(res.responseType);
	            status.add(res.responseMessage);
	            return status;
	        }
	        
	        // Check related Contacts MailingAddress (null or dummy not accpeted)
	        res = MAS_OrderService.contactMailingValidation(recordId); 
	        if(res.responseType == MAS_Constant.RESPONSE_TYPE_ERROR){
	            status.add(res.responseType);
	            status.add(res.responseMessage);
	            return status;
	        }
	
	        /*Please do new validations here*/
	        
	        // Vat validation
	        if(isVatValidation && classification == 'Business account'){
	            
	            res = MAS_OrderService.vatCheck(recordId);            
	            status.add(res.responseType);
	            status.add(res.responseMessage);
	        }
	        else{
	            status.add(MAS_Constant.RESPONSE_TYPE_SUCCESS);
	        }
	            
	        return status;
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }

    /**
     * @Description : This method is used for activate the order in SF
     * @author : Samith Perera
     * @params : ID : OrderId
     * @return : List<String> message, error type
     */
    @AuraEnabled
    public static list<string> orderActivateInSF(Id recordId) {
    	try{
	        MAS_ResponseDTO res = MAS_OrderService.orderActivateFromSF(recordId, true);
	        list<string> status = new list<string>();
	
	        status.add(res.responseType);
	        status.add(res.responseMessage);
	
	        if(res.responseResult != null){
	            status.add(res.responseResult[0].key);
	        }
	
	        return status;
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }

    /**
     * @Description : This method is used for activate products in mascus
     * @author : Samith Perera
     * @params : ID : OrderId
     * @return : List<String> message, error type
     */
    @AuraEnabled
    public static list<string> privateAdActivateInMascus(Id recordId) {
    	try{
	        MAS_ResponseDTO res = MAS_OrderService.orderPrivateAdActivateFromMascus(recordId, true, false);
	        list<string> status = new list<string>();
	
	        status.add(res.responseType);
	        status.add(res.responseMessage);
	
	        return status;
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }

    /**
     * @Description : This method is used for sync the order with mascus
     * @author : Samith Perera
     * @params : ID : OrderId
     * @return : List<String> message, error type
     */
    @AuraEnabled
    public static list<string> orderSyncWithMascus(Id recordId, Boolean sendEmail) {
    	try{
	        MAS_ResponseDTO res = MAS_OrderService.syncOrderWithMascusWeb(recordId, sendEmail);
	        list<string> status = new list<string>();
	        
	        status.add(res.responseType);
	        status.add(res.responseMessage);
	
	        return status;
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }
    
    /**
     * @Description : This method is used for resend order confirmation (manually)
     * @author : Samith Perera
     * @params : ID : OrderId
     * @return : List<String> message, error type
     */
    @AuraEnabled
    public static list<string> sendOrderConfirmation(Id recordId) {
    	try{
	        list<string> status = new list<string>();
			
			MAS_OrderService.composeEmailNotification(recordId, true);
		    status.add(MAS_Constant.RESPONSE_TYPE_SUCCESS);
		    status.add('Email Sent');
		        
	        return status;
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }
      
    /**
     * @Description : This method is used for reject order
     * @author : Samith Perera
     * @params : ID : OrderId
     * @return : List<String> message, error type
     */
    @AuraEnabled
    public static list<string> orderReject(Id recordId) {
    	try{
	        MAS_ResponseDTO res = MAS_OrderService.orderActivateFromSF(recordId, false);
	        list<string> status = new list<string>();
	      
	        status.add(res.responseType);
	        status.add(res.responseMessage);
	        
	        return status;
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }
    
    @AuraEnabled
    public static list<string> orderSyncRejectWithMascus(Id recordId) {
    	try{
	        MAS_ResponseDTO res = MAS_OrderService.syncOrderRejectWithMascusWeb(recordId);
	        list<string> status = new list<string>();
	        
	        status.add(res.responseType);
	        status.add(res.responseMessage);
	
	        return status;
    	}
    	catch(Exception e) {
    		throw new AuraHandledException('Error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
    	}
    }
    
}