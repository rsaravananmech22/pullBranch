({
    doInit : function(cmp, event, helper) {
        var action = cmp.get("c.checkOrderIsActivated");
        action.setParams({ recordId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var IsActivated = response.getReturnValue();
                cmp.set("v.IsActivated", IsActivated);
            }else if (state === "INCOMPLETE") {
				 cmp.set("v.IsActivated", false);
            }else if (state === "ERROR") {
                cmp.set("v.IsActivated", false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                          
                    }
                } else {
                     
                }
            }
        });
        $A.enqueueAction(action);
	},
    
	handleClick : function(cmp, event, helper) {
        var action = cmp.get("c.productTerminatePlatformEvent");
        action.setParams({ recordId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var arrObj = response.getReturnValue();
                toastEvent.setParams({
                    "title": arrObj[0],
                    "message": arrObj[1],
                    "type" : arrObj[0]
                });
                toastEvent.fire();
            }else if (state === "INCOMPLETE") {
				 
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                         
                    }
                } else {
                     
                }
            }
        });
        $A.enqueueAction(action);
	}
})