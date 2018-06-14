({
	sendOrderRequest : function(component) {
		
		var action = component.get("c.createPlatformEvent");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        
        // Register the callback function
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            //console.log(data);
            var msg = data[1];
            var status = data[0];
            
            component.set("v.myText", status);
            component.set("v.meessage", msg);

        });
        
        // Invoke the service
        $A.enqueueAction(action);
	}
})