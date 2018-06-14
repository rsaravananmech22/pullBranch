@isTest
private class AccountTriggerHandler_Test {
	
	@testSetup static void createData() {
    
        AccountService_Test.createData();
    }

	@isTest static void testUpdateAccountOnLeadConvert() {
        
        Lead myLead = [SELECT Id FROM Lead LIMIT 1];

        myLead.Street = 'Granville Street';
        myLead.City = 'Vancouver';
        myLead.StateCode = 'BC';
        myLead.CountryCode = 'CA';
        myLead.PostalCode = 'VJ5';
        update myLead;

        Test.startTest();
        
        // Convert the Lead
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.Id);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        Account acc = [SELECT Id, ShippingState, ShippingPostalCode, ShippingCity, Converted_From_Lead__c,
                              Customer_priority__c, Used_equipment_in_stock__c, OwnerId
                              FROM Account 
                              WHERE Converted_From_Lead__c = TRUE LIMIT 1];

        // Assert the values after lead conversion
        System.assert(acc.Converted_From_Lead__c == TRUE);
        System.assert(acc.ShippingState == 'British Columbia');
        System.assert(acc.ShippingPostalCode == 'VJ5');
        System.assert(acc.ShippingCity == 'Vancouver');
        System.assert(acc.Customer_priority__c == 'Medium');
        System.assert(acc.Used_equipment_in_stock__c == '0');
        System.assert(acc.OwnerId == UserInfo.getUserId());
        
        // Validation rule error if user tries to update the account and remove shipping info
        try {
            acc.ShippingCity = null;
            update acc;
        } catch(DMLException e) {
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }

        Test.stopTest();
    }	
}