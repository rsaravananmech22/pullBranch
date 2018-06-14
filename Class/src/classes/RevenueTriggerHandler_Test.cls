@isTest
private class RevenueTriggerHandler_Test {

	@testSetup public static void createData() { 
        
        //Create custom settings used in trigger handlers
        Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='false'), true);
        Configuration__c c2 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c='false'), true);        
        
        //Create a customer account and a legal entity
        Account a = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Test Account',Email_for_invoicing__c='Emailforinvoicing@test.com'), true);
        Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Legal Entity',Type = 'Internal legal entity', HMAC_Key__c='4A4B4C', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true); 
        
        //Create a contact for the customer account
        Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=a.Id), true);
        //Create a list of 200 orders
        Order[] oList = (Order[])MAS_TestDataFactory.createSObjectList(new Order(AccountId=a.Id, Bill_from_legal_entity__c=legalEntity.Id, Sold_to_Account__c=a.Id, BillToContactId=c.Id, Sold_to_contact__c=c.Id, CurrencyIsoCode = 'EUR'), 1, true);
        //Create one product and a price book entry for it
        Product2 p = (Product2)MAS_TestDataFactory.createSObject(new Product2(ProductCode =MAS_Constant.PRIVATE_AD), true);
        //Pricebook2 pb2 = (Pricebook2)MAS_TestDataFactory.createSObject(new Pricebook2(), true);
        PricebookEntry pbe = (PricebookEntry)MAS_TestDataFactory.createSObject(new PricebookEntry(Product2Id=p.Id , CurrencyIsoCode='EUR'), true);
        
        //Create one order items per order
        List<OrderItem> items = new List<OrderItem>();
        for(Order o : oList){
            OrderItem oi = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today()+10,Last_billing_date__c=System.today().addMonths(2),Subscription_term_length__c = 'Fixed term'));
            items.add(oi);
        }
        insert items;
    }
	
    static testMethod void testSetCountry() {
        Order checkOrder = [SELECT BillingCountry FROM Order LIMIT 1];
        System.assertNotEquals(null, checkOrder.BillingCountry, 'Order requires a country for test');
        
        List<OrderItem> orderProducts = [SELECT Id FROM OrderItem WHERE OrderId = :checkOrder.Id];
        
        List<Revenue__c> newRevenues = new List<Revenue__c>();
        for(OrderItem orderProduct : orderProducts) {
        	Revenue__c revenue = new Revenue__c(Order_Product__c=orderProduct.Id, Amount__c = 1, Name='Test');
        	newRevenues.add(revenue);
        }
        insert newRevenues;
        
        List<Revenue__c> checkRevenues = [SELECT Country__c FROM Revenue__c];
        System.assertNotEquals(0, checkRevenues.size(), 'No revenue records to test were created.');
        for(Revenue__c checkRevenue : checkRevenues) {
        	System.assertEquals(checkOrder.BillingCountry, checkRevenue.Country__c, 'Country on the revenue does not match the country on the order.');
        }
    }
}