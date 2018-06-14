({
	vatCheck : function(component) {
		// Get a reference to the vatCheckWithVies() function defined in the Apex controller
		var action = component.get("c.vatCheckWithVies");
        action.setParams({
            "AccountId": component.get("v.recordId")
        });
        
        // Register the callback function
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            //console.log(data);
            var msg = data[1];
            var status = data[0];
            
            // Set the component attributes using values returned by the API call
            component.set("v.myText", status);
            component.set("v.meessage", msg);

        });
        
        // Invoke the service
        $A.enqueueAction(action);
	}
})