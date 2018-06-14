trigger Revenue on Revenue__c (before insert) {
    
    if(Trigger.isBefore) {
    	if(Trigger.isInsert) {
    		RevenueTriggerHandler.setCountry(Trigger.new);
    	}
    }
}