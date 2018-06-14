({
	getOutstandingBalance : function(component) {
		var action = component.get("c.getBalance");
		var id = component.get("v.recordId");
		action.setParams({
            "recordId": id
        });
		
		action.setCallback(this, function(response) {

			var state = response.getState();
			var balance = response.getReturnValue();

			if (state === "SUCCESS" && balance != null && balance != '') {
				component.set("v.balances", balance);
			}
		});
		$A.enqueueAction(action);
	}
})