@isTest
private class ContactTriggerHandler_Test {
	
	@testSetup static void createData() {
    
        OrderService_Test.createData();
    }


	@isTest static void test_ThrowExceptionOnContactDeactivation() {
		
		Contact con = [SELECT Status__c, Contact_Role__c FROM Contact LIMIT 1];
		Order ord = [SELECT Status, Activated__c, Mascus_Order_Number__c FROM Order LIMIT 1];

		Test.startTest();

		ord.Status = 'Activated';
		ord.Activated__c = true;
		update ord;

		// Change status to Inactive from Active
		try {
			con.Status__c = 'Inactive';
			update con;
		} catch (Exception e) {
			System.assert(e.getMessage().contains(Label.LBL_ERR_CON_StatusChange + ' ' + ord.Mascus_Order_Number__c));
		}

		// Change ContactRole to IT from "Invoicing Contact"
		try {
			con.Contact_role__c = 'IT';
			update con;
		} catch (Exception e) {
			System.assert(e.getMessage().contains(Label.LBL_ERR_CON_ContactRoleChange + ' ' + ord.Mascus_Order_Number__c));
		}

		Test.stopTest();
	}
}