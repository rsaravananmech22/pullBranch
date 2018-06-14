({
    doInit: function(component, event, helper) {
        // Fetch the orderWrapper from the Apex controller
        component.set('v.approvespinner', true);
        helper.getOrderInformation(component);
    },

    approve: function(component, event, helper) {
        // Order activate from the Apex controller
        component.set('v.sendEmail', true);
        component.set('v.approvespinner', true);
        helper.orderApprove(component);
    },

    approveWithoutEmail: function(component, event, helper) {
        // Order activate from the Apex controller without email notification
        component.set('v.sendEmail', false);
        component.set('v.approvespinner', true);
        helper.orderApprove(component);
    },

    reject: function(component, event, helper) {
        // Order reject from the Apex controller
        component.set('v.approvespinner', true);
        helper.orderReject(component);
    }
    
})