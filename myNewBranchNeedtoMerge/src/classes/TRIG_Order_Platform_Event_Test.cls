@istest
public class TRIG_Order_Platform_Event_Test {
    
   
   @testSetup public static void createData() {
		//Create custom settings used in trigger handlers
		Test.startTest();
		Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='false'), true);
		Configuration__c c2 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c='false'), true);
		//Create a customer account and a legal entity
		Account insertacc=new Account(ShippingStreet='Meir 1',
		                      ShippingCity='Antwerp',
		                      ShippingPostalCode='2000',
		                      ShippingState='Haryana',
		                      ShippingCountry='India',
                              Billing_Cycle_preference__c='Monthly',
		                      Invoicing_preference__c='Mail',
		                      Invoicing_Rule__c='In advance',
		                      Payment_method__c='By Invoice',
		                      Payment_term__c='Immediately');
		Account a = (Account)MAS_TestDataFactory.createSObject(insertacc, true);
		Account legalEntityacc=new Account(Name='Legal Entity', 
		                      RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId(),
		                      ShippingStreet='Meir 1',
		                      ShippingCity='Antwerp',
		                      ShippingPostalCode='2000',
		                      ShippingState='Haryana',
		                      ShippingCountry='India',
		                      BillingState='Haryana',
		                      Billing_Cycle_preference__c='Monthly',
		                      Invoicing_preference__c='Mail',
		                      Invoicing_Rule__c='In advance',
		                      Payment_method__c='By Invoice',
		                      Payment_term__c='Immediately',
                              type='Internal legal entity'
		                      );
		Account legalEntity = (Account)MAS_TestDataFactory.createSObject(legalEntityacc,true);
		//Create a contact for the customer account
		Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=a.Id), true);
		//Create a list of 200 orders
		Order[] oList = (Order[])MAS_TestDataFactory.createSObjectList(new Order(AccountId=a.Id, Bill_from_legal_entity__c=legalEntity.Id, Sold_to_Account__c=a.Id, BillToContactId=c.Id, Sold_to_contact__c=c.Id), 10, true);
		//Create one product and a price book entry for it
		Product2 p = (Product2)MAS_TestDataFactory.createSObject(new Product2(), true);
		PricebookEntry pbe = (PricebookEntry)MAS_TestDataFactory.createSObject(new PricebookEntry(Product2Id=p.Id), true);
		//Create one order items per order
		List<OrderItem> items = new List<OrderItem>();
		for(Order o : oList){
			OrderItem oi = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id, PricebookEntryId=pbe.Id,Subscription_term_length__c='Fixed term'));
            
			items.add(oi);
		}
		insert items;
		Test.stopTest();
	}
   @isTest static void activateorder() {
        Test.startTest();
       //Query the original 200 orders
		Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([	SELECT Id 
																	FROM Order]);
        system.debug(mapIdToOriginalOrders);
		//Activate 2 out of the 200 orders
		Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([	SELECT Id,status 
																	FROM Order 
																	LIMIT 2]);
		system.debug(mapIdToCloningOrders);
       for(Order o : mapIdToCloningOrders.values()){
			system.debug(o);
			o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
            o.Activated__c = true;
		}
		update mapIdToCloningOrders.values();
       List<Order_Platform_Event__e> insertevents=new List<Order_Platform_Event__e>();
		for(order o:[select id,status from order where Status = 'Activated'])
       {
           Order_Platform_Event__e insertevent=new Order_Platform_Event__e();
            insertevent.Order_Owner_FirstName__c='';
            insertevent.Order_Product_Legal_entity_sales_share__c=null;
            insertevent.Order_Status__c='Activated';
            insertevent.Order_Product_Discount__c=null;
            insertevent.Contact_Phonetic_Last_Name__c='Walree';
            insertevent.Order_Number__c='00000148';
            insertevent.Account_BillingCity__c='Breda';
            insertevent.Mailing_Country__c='Netherlands';
            insertevent.Account_Phone_Prefix__c='31';
            insertevent.Order_Product_Start_Date__c=null;
            insertevent.Contact_Mailing_CountryCode__c='NL';
            insertevent.Order_Bundle_pricing__c=false;
            insertevent.Order_Invoicing_rule__c='In arrears';
            insertevent.Order_Mascus_Order_Number__c='O00000049';
            insertevent.Order_Payment_method_reference__c='';
            insertevent.Order_ID__c=o.id;
            insertevent.Account_BillingStreet__c='Concordiastraat 20';
            insertevent.Order_Owner_LastName__c='ABSI';
            insertevent.Mailing_Postal_Code__c='4811 NB';
            insertevent.Order_Product_Line__c=null;
            insertevent.Contact_Phone__c='639211528';
            insertevent.Contact_Phonetic_First_Name__c='Christiaan';
            insertevent.Order_Product_End_Date__c=null;
            insertevent.Order_Billing_Cycle_Preference__c='Monthly';
            insertevent.Account_Mascus_Customer_Number__c='M00087471';
            insertevent.Account_DUNS_number__c='';
            insertevent.Action__c='Create';
            insertevent.Account_Classification__c='Person account';
            insertevent.Mailing_City__c='Breda';
            insertevent.Contact_First_Name__c='Christiaan';
            insertevent.Contact_Salutation__c='';
            insertevent.Order_Product_Unit_Price__c=null;
            insertevent.Account_Website__c='';
            insertevent.Order_Invoice_header_information__c='';
            insertevent.Order_Product_Quantity__c=null;
            insertevent.Account_BillingPostalCode__c='4811 NB';
            insertevent.Order_Start_Date__c=system.today();
            insertevent.Order_Product_Price_unit_of_measure__c=null;
            insertevent.Contact_Last_Name__c='Walree';
            insertevent.Account_Phone__c='639211528';
            insertevent.Order_Sold_to_contact__c='0035E00000LI2bDQAT';
            insertevent.Order_Product_Cancellation_date__c=null;
            insertevent.Account_Local_TAX_Number__c='';
            insertevent.Account_BillingState__c='';
            insertevent.Contact_Email__c='christiaan.van.walree1@absi.digital.test';
            insertevent.Mailing_State__c='';
            insertevent.Account_BillingCountryCode__c='NL';
            insertevent.Mailing_Street__c='Concordiastraat 20';
            insertevent.Order_Product_cancellation_reason_descri__c=null;
            insertevent.Order_Product_Cancellation_reason__c=null;
            insertevent.Order_Product_Line_Description__c=null;
            insertevent.Contact_Phone_Prefix__c='31';
            insertevent.Account_Type_of_Business__c='';
            insertevent.Account_Private_Tax_Number__c='';
            insertevent.Order_Name__c='';
            insertevent.Account_BillingStateCode__c='';
            insertevent.Account_Email_for_invoicing__c='christiaan.van.walree@absi.digital.test';
            insertevent.Order_Product_Code__c=null;
            insertevent.Order_Invoicing_preference__c='E-mail';
            insertevent.Account_BillingCountry__c='Netherlands';
            insertevent.Order_Account_Name__c=null;
            insertevent.Order_Sold_to_Account__c='0015E00000UrtcSQAR';
            insertevent.Account_Name__c='Walree';
            insertevent.Order_Reference_Number__c='';
            insertevent.Order_Bill_To_Contact__c='0035E00000LI2bDQAT';
            insertevent.Order_Product_Subscription_term_length__c=null;
            insertevent.Order_Payment_Token__c=null;
            insertevent.Contact_Mascus_Contact_Number__c='C00000018';
            insertevent.Order_Bill_from_legal_entity__c='Ritchie Bros BV';
            insertevent.Order_Payment_method__c='Online payment provider';
            insertevent.Order_Payment_term__c='30 days net';
            insertevent.Order_Billing_start_date__c=system.today();
            insertevent.Currency_Iso_Code__c=null;
            insertevent.Account_EU_VAT_Number__c=null;
            insertevent.Account_Phonetic_Name__c='Walree';
            insertevent.Order_Owner__c=null;
            Database.SaveResult sr = EventBus.publish(insertevent);
            

       }
		
       Test.stopTest();
    }
}