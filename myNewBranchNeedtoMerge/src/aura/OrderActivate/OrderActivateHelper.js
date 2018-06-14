({ 
    //Fetch the Order from the Apex controller
    getOrderInformation: function(component) {
        var action = component.get('c.getOrderInformation');
        action.setParams({
            orderId: component.get("v.recordId")
        });
        action.setCallback(this, function(actionResult) {
            component.set('v.order', actionResult.getReturnValue());
            this.getEmailTemplate(component);
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        	this.setSystemError(component, errors);
        }, 'ERROR');
        $A.enqueueAction(action);
    },
    
    getEmailTemplate: function(component) {
        var action = component.get('c.getOrderConfirmationEmailTemplate');
        action.setParams({
            orderObject: component.get("v.order")
        });
        action.setCallback(this, function(actionResult) {
            component.set('v.emailTemplate', actionResult.getReturnValue());
            this.getEmailBody(component);
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        }, 'ERROR');
        $A.enqueueAction(action);
    },
    
    getEmailBody: function(component) {
        var action = component.get('c.generateEmail');
        action.setParams({
            orderObject: component.get("v.order"),
            orderItems: component.get("v.order.OrderItems"),
            template: component.get("v.emailTemplate")
        });
        action.setCallback(this, function(actionResult) {
            component.set('v.approvespinner', false);
            component.set('v.emailBody', actionResult.getReturnValue());
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        }, 'ERROR');
        $A.enqueueAction(action);
    },

    //Order approve
    orderApprove: function(component) {
        var action = component.get('c.orderValidation'); //Vat check, BillingStartDate Check and orderlineSplit check
        action.setParams({
            recordId: component.get("v.recordId"),
            isVatValidation: component.get("v.order.Bill_from_legal_entity__r.VAT_validation__c"),
            classification: component.get("v.order.Sold_to_Account__r.Classification__c")
        });
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
	        var status = data[0];
	        var msg = data[1];
	        
	        if (status == 'success') {
	        	this.orderActivate(component);
            }else{
                component.set("v.errortype", status);
                component.set("v.message", msg);
                component.set('v.approvespinner', false);  
            }
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        	this.setSystemError(component, errors);
        }, 'ERROR');
        $A.enqueueAction(action);
    },
    
    orderActivate: function(component) {
        var action = component.get('c.orderActivateInSF');
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            var status = data[0];
            var msg = data[1];
            var isPaid = data[2];
            
            if (status == 'success' && isPaid == 'IsPrePaid') { 
            	this.privateAdApproval(component);
            }else if (status == 'success' && isPaid == 'IsDealerCredits'){
            	this.syncApproval(component);
            }else{
                component.set("v.errortype", status);
                component.set("v.message", msg);
                component.set('v.approvespinner', false);  
            }
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        	this.setSystemError(component, errors);
        }, 'ERROR');
        $A.enqueueAction(action);
    },
    
    privateAdApproval: function(component) {
        var action = component.get('c.privateAdActivateInMascus');
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            var status = data[0];
            var msg = data[1];
            component.set("v.errortype", status);
            component.set("v.message", msg);
            component.set('v.approvespinner', false);
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        	this.setSystemError(component, errors);
        }, 'ERROR');
        $A.enqueueAction(action);
    },
    
    syncApproval: function(component) {
        var action = component.get('c.orderSyncWithMascus');
        action.setParams({
            recordId: component.get("v.recordId"),
            sendEmail: component.get("v.sendEmail")
        });
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            var status = data[0];
            var msg = data[1];
            component.set("v.errortype", status);
            component.set("v.message", msg);
            component.set('v.approvespinner', false);
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        	this.setSystemError(component, errors);
        }, 'ERROR');
        $A.enqueueAction(action);
    },

    // Order reject
    orderReject: function(component) {
        var action = component.get('c.orderReject');
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
        	var data = response.getReturnValue();
            var status = data[0];
            var msg = data[1];
            if (status == 'success') {
            	this.syncReject(component);
			}
			else {
				component.set("v.errortype", status);
                component.set("v.message", msg);
                component.set('v.approvespinner', false);
			}
        }, 'SUCCESS');
        action.setCallback(this, function(actionResult) {
            alert('I am coming');
        	var errors = actionResult.getError();
        	this.setSystemError(component, errors);
        }, 'ERROR');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        $A.enqueueAction(action);
    },
    
    syncReject: function(component) {
    	var action = component.get('c.orderSyncRejectWithMascus');
		action.setParams({
		    recordId: component.get("v.recordId")
		});
		action.setCallback(this, function(response) {
			var data = response.getReturnValue();
            var status = data[0];
            var msg = data[1];
            component.set("v.errortype", status);
            component.set("v.message", msg);
            component.set('v.approvespinner', false);
		}, 'SUCCESS');
		action.setCallback(this, function(actionResult) {
        	var errors = actionResult.getError();
        	this.setSystemError(component, errors);
        }, 'ERROR');
		$A.enqueueAction(action);
    },
    
    setSystemError: function(component, errors) {
    	component.set('v.approvespinner', false);
        component.set("v.errortype", 'error');
        if (errors) {
            component.set("v.message",  errors[0].message);
        } else {
            component.set("v.message", "Unknown error");
        }
    }
})