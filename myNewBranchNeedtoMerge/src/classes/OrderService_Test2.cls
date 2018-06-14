@isTest
private class OrderService_Test2 {
	public final static Integer NUMBER_OF_ORIGINAL_ORDERS = 1;

    //Public so it can also be called from other test classes
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
        Order[] oList = (Order[])MAS_TestDataFactory.createSObjectList(new Order(AccountId=a.Id, Bill_from_legal_entity__c=legalEntity.Id, Sold_to_Account__c=a.Id, BillToContactId=c.Id, Sold_to_contact__c=c.Id, CurrencyIsoCode = 'EUR'), NUMBER_OF_ORIGINAL_ORDERS, true);
        //Create one product and a price book entry for it
        Product2 p = (Product2)MAS_TestDataFactory.createSObject(new Product2(ProductCode =MAS_Constant.PRIVATE_AD), true);
        //Pricebook2 pb2 = (Pricebook2)MAS_TestDataFactory.createSObject(new Pricebook2(), true);
        PricebookEntry pbe = (PricebookEntry)MAS_TestDataFactory.createSObject(new PricebookEntry(Product2Id=p.Id , CurrencyIsoCode='EUR'), true);
        
        //Create one order items per order
        List<OrderItem> items = new List<OrderItem>();
        for(Order o : oList){        	
            //One-off
            OrderItem oi1 = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=null,Last_billing_date__c=System.today(),Price_unit_of_measure__c = 'One-off'));
            oi1.EndDate = null;
            
            //One-off
            OrderItem oi2 = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today().addDays(10),Last_billing_date__c=null,Price_unit_of_measure__c = 'One-off'));
            oi2.EndDate = null;
            
            //Monthly - Fully Invoiced
            OrderItem oi3 = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=null,Last_billing_date__c=System.today(),Subscription_term_length__c = 'Fixed term',Price_unit_of_measure__c = 'Monthly'));
            
            //Monthly - Invoiced
            OrderItem oi4 = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today().addDays(15),Last_billing_date__c=System.today(),Subscription_term_length__c = 'Fixed term',Price_unit_of_measure__c = 'Monthly'));
            
            //Monthly - UnInvoiced
            OrderItem oi5 = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today().addDays(15),Last_billing_date__c=null,Subscription_term_length__c = 'Fixed term',Price_unit_of_measure__c = 'Monthly'));
            
            items.add(oi1);
            items.add(oi2);
            items.add(oi3);
            items.add(oi4);
            items.add(oi5);
        }
        
        insert items;        

        //Create custom settings used in mascus API Authentication
        Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_USER_NAME, Value__c='mascusserviceusername@test'), true);
        Configuration__c c4 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_PASSWORD, Value__c='mascusservicepassword@test'), true);
        Configuration__c c6 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_WEBSERVICE_URL, Value__c='http://build-e1.mascus.com/api/mascussf.asmx'), true);

        //Create custom settings used in composeAdyenUrl 
        Configuration__c c7 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ADYEN_KEY, Value__c='aydnKey'), true);
        Configuration__c c8 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ADYEN_PAYMENT_URL, Value__c='  https://test.adyen.com/hpp/pay.shtml?'), true);
       
        //Create custom settings used in vatCheck 
        Configuration__c c9 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACCOUNT_ACCOUNT_TEST_MODE, Value__c='false'), true);
        Configuration__c c10 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.VAT_SERVICE_URL, Value__c='https://vatserviceurl/ws/simple/getTaxNumberValidity'), true);
        Configuration__c c11 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.VAT_SERVICE_USER_NAME, Value__c='vatusername'), true);
        Configuration__c c12 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.VAT_SERVICE_PASSWORD, Value__c='vatpassword'), true);
        Configuration__c c13 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACCOUNT_ACCOUNT_TAX_TYPE_VAT, Value__c='vat'), true);
        
        Configuration__c c14 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ORDER_TO_EMAIL_ADDRESSES, Value__c='test1@test.com,test2@test.com,test3@test.com'), true);
        Configuration__c c15 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACTIONLOG_TO_EMAIL_ADDRESSES, Value__c='test1@test.com,test2@test.com,test3@test.com'), true);

        User userObj = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'Test Company',
            Title = 'SE',
            Alias = 'kavi',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        INSERT userObj;
    }
    
    static testmethod void cancelOriginalOrderItemsTest() {
     	List<Order> orderList = [Select Id, (Select Id from OrderItems) From Order];     	
     	
     	for(Order o : orderList){
     		o.Status = 'Activated';
            o.Activated__c = true;
     	}
     	
     	update orderList;
     	
     	Set<Id> itemIds = new Set<Id>();
     	for(Order o : orderList){
	     	for(OrderItem oi : o.OrderItems){
	     		itemIds.add(oi.Id);
	     	}
     	}
     	
     	Test.startTest();
     	Account acc = [Select Id, BillingStreet from Account limit 1];     
     	acc.BillingStreet = 'Updated Street';
     
     	update acc;
     	Test.stopTest();
     	
     	List<OrderItem> orderItemsList = [Select Id, Cancellation_Date__c, Renewal_date__c, ServiceDate, Next_billing_date__c, Last_billing_date__c, Subscription_term_length__c, Price_unit_of_measure__c From OrderItem Where Id IN :itemIds];     	
     	
     	for(OrderItem oi : orderItemsList){    		
     		if(oi.Price_unit_of_measure__c == 'One-off'){
     			if(oi.Last_billing_date__c != null){
     				system.assertEquals(oi.Cancellation_Date__c, null);
     			}else{
     				system.assertEquals(oi.ServiceDate, oi.Cancellation_Date__c);
     				system.assertEquals(oi.ServiceDate, oi.Renewal_date__c);
     			}
     		}else{
     			if(oi.Last_billing_date__c != null){
     				if(oi.Next_billing_date__c == null){
     					system.assertEquals(oi.Cancellation_Date__c, null);
     				}else{
     					system.assertEquals(oi.Last_billing_date__c, oi.Cancellation_Date__c);
     					system.assertEquals(oi.Next_billing_date__c, oi.Renewal_date__c);
     				}
     			}else{
     				system.assertEquals(oi.ServiceDate, oi.Cancellation_Date__c);
     				system.assertEquals(oi.ServiceDate, oi.Renewal_date__c);
     			}     			
     		}
     	}
     }
}