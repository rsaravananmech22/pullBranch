@isTest(seeAllData=false)
public class OrderService_Test {
    public final static Integer NUMBER_OF_ORIGINAL_ORDERS = 5;

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
            //OrderItem oi = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today()+10,Last_billing_date__c=System.today().addMonths(2),Subscription_term_length__c = 'Fixed term'));
           //Changed data for last billing date as it looked incorrect in the above line (Next billing date is always greater than last billing date)
            OrderItem oi = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today()+10,Last_billing_date__c=System.today()-10,Subscription_term_length__c = 'Fixed term'));
            items.add(oi);
        }
        insert items;

        // Create one order line split for each order item
        /*List<OrderlineSplit__c> splits = new List<OrderlineSplit__c>();
        for(OrderItem oi : items){
            OrderlineSplit__c split = (OrderlineSplit__c)MAS_TestDataFactory.createSObject(new OrderlineSplit__c(OrderLine__c=oi.Id,Amount__c=10,User__c=UserInfo.getUserId(),SplitNumber__c=1));
            splits.add(split);
        }
        insert splits;*/

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
            CompanyName = 'ABSI',
            Title = 'SE',
            Alias = 'kavi',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        INSERT userObj;
    }
    
    @isTest static void accountNameChanges() {
        
        //Query the original 200 orders
        Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([ SELECT Id
                                                                    FROM Order]);

        //Activate 2 out of the 200 orders
        Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([  SELECT Id
                                                                    FROM Order
                                                                    LIMIT 1]);
        for(Order o : mapIdToCloningOrders.values()){
            o.Status = 'Activated';
            o.Activated__c = true;
        }
        update mapIdToCloningOrders.values();

         Test.startTest();

            //Change account name so that it should trigger cancelOrderOnAccountInformationChange()
            Account a = [   SELECT Id
                            FROM Account
                            LIMIT 1];
            a.Name = 'Changed Name';
            update a;

            //Verify the linked order items of the active orders have been cancelled with the correct reason
            /*System.assertEquals('Account information change', [   SELECT Cancellation_reason__c
                                                                FROM OrderItem
                                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                                LIMIT 1].Cancellation_reason__c);
            //Verify the linked order items of the active orders have a renewal type = Within Term
            System.assertEquals('Within Term', [SELECT Renewal_Type__c
                                                FROM OrderItem
                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                LIMIT 1].Renewal_Type__c);
            //Verify only 2 order items have a cancellation date filled in
            System.assertEquals(2, [SELECT count()
                                    FROM OrderItem
                                    WHERE cancellation_date__c != null]);
            //Verify the 2 active orders have been cloned => 4 activated orders now
            System.assertEquals(4, [    SELECT count()
                                        FROM Order WHERE Status = 'Activated']);
            //Verify the cloned orders have correct start dates = earliest renewal date of the cloned order items
            System.assertEquals(Date.today()+10, [SELECT EffectiveDate
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].EffectiveDate);
            System.assertEquals(Date.today()+10, [SELECT Billing_start_date__c
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].Billing_start_date__c);
            //Verify there are 2 cloned order items with end date today + 30
            Date inOneMonth = Date.today() + 30;
            System.assertEquals(2, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND EndDate = :inOneMonth]);
            //Verify non of the cloned order items have the renewal checkbox set to true
            System.assertEquals(0, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Renewal__c = true]);*/
            //Verify the cloned order items have all cancellation and renewal fields set to null
            String fieldsConcatenation;
            for(OrderItem oi : [SELECT cancellation_date__c, Cancellation_reason__c, cancellation_reason_description__c, Renewal_Type__c, Renewal_price__c, Renewal_date__c
                                FROM OrderItem
                                WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()]){
                fieldsConcatenation = fieldsConcatenation + String.valueOf(oi.cancellation_date__c) + oi.Cancellation_reason__c + oi.cancellation_reason_description__c + oi.Renewal_Type__c + oi.Renewal_price__c + String.valueOf(oi.Renewal_date__c);
            }
            fieldsConcatenation = fieldsConcatenation.replace('null', '');
            /*System.assertEquals('', fieldsConcatenation);
            //Verify the cloned orders have been activated
            System.assertEquals(2, [SELECT count()
                                    FROM Order
                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Status = 'Activated']);*/
            //Verify the original active orders' items have their end date set equal to the cancellation date
            Date inNineDays = Date.today() + 10;
            /*System.assertEquals(inNineDays, [ SELECT EndDate
                                                FROM OrderItem
                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                LIMIT 1].EndDate);*/
         Test.stopTest();
     }

    @isTest static void accountAddressChanges() {
        Integer number_of_orginals_to_clone = 1;
        //Query the original 200 orders
        Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([ SELECT Id
                                                                    FROM Order]);

        //Activate 2 out of the 200 orders
        Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([  SELECT Id
                                                                    FROM Order
                                                                    LIMIT :number_of_orginals_to_clone]);
        for(Order o : mapIdToCloningOrders.values()){
            o.Status = 'Activated';
            o.Activated__c = true;
        }
        update mapIdToCloningOrders.values();

         Test.startTest();

            //Change account address so that it should trigger cancelOrderOnAccountInformationChange()
            Account a = [   SELECT Id
                            FROM Account
                            LIMIT 1];
            a.BillingStreet = 'Changed Street';
            update a;

            //Verify the linked order items of the active orders have been cancelled with the correct reason
            /*System.assertEquals('Account information change', [   SELECT Cancellation_reason__c
                                                                FROM OrderItem
                                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                                LIMIT 1].Cancellation_reason__c);
            //Verify the linked order items of the active orders have a renewal type = Within Term
            System.assertEquals('Within Term', [SELECT Renewal_Type__c
                                                FROM OrderItem
                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                LIMIT 1].Renewal_Type__c);
            //Verify only 2 order items have a cancellation date filled in
            System.assertEquals(number_of_orginals_to_clone, [SELECT count()
                                    FROM OrderItem
                                    WHERE cancellation_date__c != null]);
            //Verify the 2 active orders have been cloned
            System.assertEquals(4, [    SELECT count()
                                        FROM Order WHERE Status = 'Activated']);
            //Verify the cloned orders have correct start dates = earliest renewal date of the cloned order items (today)
            System.assertEquals(Date.today() + 10, [SELECT EffectiveDate
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].EffectiveDate);
            System.assertEquals(Date.today() + 10, [SELECT Billing_start_date__c
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].Billing_start_date__c);*/
            //Verify there are 2 cloned order items with end date today + 30
            Date inOneMonth = Date.today() + 30;
            /*System.assertEquals(2, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND EndDate = :inOneMonth]);
            //Verify non of the cloned order items have the renewal checkbox set to true
            System.assertEquals(0, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Renewal__c = true]);*/
            //Verify the cloned order items have all cancellation and renewal fields set to null
            String fieldsConcatenation;
            for(OrderItem oi : [SELECT cancellation_date__c, Cancellation_reason__c, cancellation_reason_description__c, Renewal_Type__c, Renewal_price__c, Renewal_date__c
                                FROM OrderItem
                                WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()]){
                fieldsConcatenation = fieldsConcatenation + String.valueOf(oi.cancellation_date__c) + oi.Cancellation_reason__c + oi.cancellation_reason_description__c + oi.Renewal_Type__c + oi.Renewal_price__c + String.valueOf(oi.Renewal_date__c);
            }
            fieldsConcatenation = fieldsConcatenation.replace('null', '');
            /*System.assertEquals('', fieldsConcatenation);*/
            //Verify the cloned orders have been activated
            /*System.assertEquals(2, [SELECT count()
                                    FROM Order
                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Status = 'Activated']);*/
            //Verify the original active orders' items have their end date set equal to the cancellation date
            Date inNineDays = Date.today() + 10;
            /*System.assertEquals(inNineDays, [ SELECT EndDate
                                                FROM OrderItem
                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                LIMIT 1].EndDate);*/

            // Verify if the order line split has been cloned as well (10 originals + 2 cloned = 12)

         Test.stopTest();
        System.assertEquals(NUMBER_OF_ORIGINAL_ORDERS+number_of_orginals_to_clone, [SELECT count() FROM OrderlineSplit__c]);
     }

    @isTest static void contactNameChanges() {
        
        //Query the original 200 orders
        Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([ SELECT Id
                                                                    FROM Order]);

        //Activate 2 out of the 200 orders
        Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([  SELECT Id
                                                                    FROM Order
                                                                    LIMIT 1]);
        for(Order o : mapIdToCloningOrders.values()){
            o.Status = 'Activated';
            o.Activated__c = true;
        }
        update mapIdToCloningOrders.values();

         Test.startTest();
            //Change contact name so that it should trigger cancelOrderOnContactNameChange()
            Contact c = [   SELECT Id
                            FROM Contact
                            LIMIT 1];
            c.LastName = 'Changed Name';
            update c;

            //Verify the linked order items of the active orders have been cancelled with the correct reason
            /*System.assertEquals('Account information change', [   SELECT Cancellation_reason__c
                                                                FROM OrderItem
                                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                                LIMIT 1].Cancellation_reason__c);
            //Verify the linked order items of the active orders have a renewal type = Within Term
            System.assertEquals('Within Term', [SELECT Renewal_Type__c
                                                FROM OrderItem
                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                LIMIT 1].Renewal_Type__c);
            //Verify only 2 order items have a cancellation date filled in
            System.assertEquals(2, [SELECT count()
                                    FROM OrderItem
                                    WHERE cancellation_date__c != null]);
            //Verify the 2 active orders have been cloned
            System.assertEquals(4, [    SELECT count()
                                        FROM Order WHERE Status = 'Activated']);
            //Verify the cloned orders have correct start dates = earliest renewal date of the cloned order items (today + 10)
            System.assertEquals(Date.today() + 10, [SELECT EffectiveDate
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].EffectiveDate);
            System.assertEquals(Date.today() + 10, [SELECT Billing_start_date__c
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].Billing_start_date__c);*/
            //Verify there are 2 cloned order items with end date today + 30
            Date inOneMonth = Date.today() + 30;
            /*System.assertEquals(2, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND EndDate = :inOneMonth]);
            //Verify non of the cloned order items have the renewal checkbox set to true
            System.assertEquals(0, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Renewal__c = true]);*/
            //Verify the cloned order items have all cancellation and renewal fields set to null
            String fieldsConcatenation;
            for(OrderItem oi : [SELECT cancellation_date__c, Cancellation_reason__c, cancellation_reason_description__c, Renewal_Type__c, Renewal_price__c, Renewal_date__c
                                FROM OrderItem
                                WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()]){
                fieldsConcatenation = fieldsConcatenation + String.valueOf(oi.cancellation_date__c) + oi.Cancellation_reason__c + oi.cancellation_reason_description__c + oi.Renewal_Type__c + oi.Renewal_price__c + String.valueOf(oi.Renewal_date__c);
            }
            fieldsConcatenation = fieldsConcatenation.replace('null', '');
            /*System.assertEquals('', fieldsConcatenation);
            //Verify the cloned orders have been activated
            System.assertEquals(2, [SELECT count()
                                    FROM Order
                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Status = 'Activated']);*/
            //Verify the original active orders' items have their end date set equal to the cancellation date
            Date inNineDays = Date.today() + 10;
            /*System.assertEquals(inNineDays, [ SELECT EndDate
                                                FROM OrderItem
                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                LIMIT 1].EndDate);*/
         Test.stopTest();
     }

    @isTest static void orderItemPriceIncreaseWithinTermRenewal() {
        
        //Query the original 200 orders
        Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([ SELECT Id
                                                                    FROM Order]);

        //Get 4 out of the 200 orders, set their cancellation reason to 'Price increase' and renewal type to 'Within Term',
        //and activate the first and third order
        Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([  SELECT Id, (SELECT Next_billing_date__c FROM OrderItems)
                                                                    FROM Order
                                                                    LIMIT 4]);
        List<OrderItem> items = new List<OrderItem>();
        Integer count = 0;
        for(Order o : mapIdToCloningOrders.values()){
            for(OrderItem oi : o.OrderItems){
                oi.Renewal_date__c = oi.Next_billing_date__c;
                oi.cancellation_date__c = oi.Renewal_date__c - 1;
                oi.Cancellation_reason__c = 'Price increase';
                oi.Renewal_Type__c = 'Within Term';
                oi.ServiceDate = Date.today();
                oi.EndDate = Date.today().addMonths(12);
                items.add(oi);
            }
            if(Math.mod(count, 2) == 0){
                //Activate only the even orders
                o.Status = 'Activated';
                o.Activated__c = true;
            }
            count++;
        }
        update mapIdToCloningOrders.values();

         Test.startTest();
            //Update the order items so it starts the Order Product process that fires cloneOrder()
            update items;

            //Verify the 2 active orders have been cloned
            // System.assertEquals(4, [ SELECT count()
            //                          FROM Order WHERE Status = 'Activated']);
            // //Verify the cloned orders have correct start dates = earliest renewal date of the cloned order items (today + 10)
            // System.assertEquals(Date.today() + 10, [SELECT EffectiveDate
            //                                      FROM Order
            //                                      WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
            //                                      LIMIT 1].EffectiveDate);
            // System.assertEquals(Date.today() + 10, [SELECT Billing_start_date__c
            //                                      FROM Order
            //                                      WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
            //                                      LIMIT 1].Billing_start_date__c);
            // //Verify there are 2 cloned order items with end date today + 30
            // Date inOneMonth = Date.today() + 30;
            // System.assertEquals(2, [SELECT count()
            //                      FROM OrderItem
            //                      WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
            //                      AND EndDate = :inOneMonth]);
            // //Verify non of the cloned order items have the renewal checkbox set to true
            // System.assertEquals(0, [SELECT count()
            //                      FROM OrderItem
            //                      WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
            //                      AND Renewal__c = true]);
            // //Verify the cloned order items have all cancellation and renewal fields set to null
            // String fieldsConcatenation;
            // for(OrderItem oi : [SELECT cancellation_date__c, Cancellation_reason__c, cancellation_reason_description__c, Renewal_Type__c, Renewal_price__c, Renewal_date__c
            //                  FROM OrderItem
            //                  WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()]){
            //  fieldsConcatenation = fieldsConcatenation + String.valueOf(oi.cancellation_date__c) + oi.Cancellation_reason__c + oi.cancellation_reason_description__c + oi.Renewal_Type__c + oi.Renewal_price__c + String.valueOf(oi.Renewal_date__c);
            // }
            // fieldsConcatenation = fieldsConcatenation.replace('null', '');
            // System.assertEquals('', fieldsConcatenation);
            // //Verify the cloned orders have been activated
            // System.assertEquals(2, [SELECT count()
            //                      FROM Order
            //                      WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
            //                      AND Status = 'Activated']);
            // //Verify the original active orders' items have their end date set equal to the cancellation date
            // Date inNineDays = Date.today() + 10 - 1;
            // System.assertEquals(inNineDays, [    SELECT EndDate
            //                                  FROM OrderItem
            //                                  WHERE OrderId IN :mapIdToCloningOrders.keySet()
            //                                  LIMIT 1].EndDate);
         Test.stopTest();
     }

    @isTest static void orderItemPriceIncreaseExtendTermRenewal() {
        
        //Query the original 200 orders
        Map<Id, Order> mapIdToOriginalOrders = new Map<Id, Order>([ SELECT Id
                                                                    FROM Order]);

        //Get 4 out of the 200 orders, set their cancellation reason to 'Price increase' and renewal type to 'Within Term',
        //and activate the first and third order
        Map<Id, Order> mapIdToCloningOrders = new Map<Id, Order>([  SELECT Id, (SELECT Next_billing_date__c FROM OrderItems)
                                                                    FROM Order
                                                                    LIMIT 4]);
        List<OrderItem> items = new List<OrderItem>();
        Integer count = 0;
        for(Order o : mapIdToCloningOrders.values()){
            for(OrderItem oi : o.OrderItems){
                oi.Renewal_date__c = oi.Next_billing_date__c;
                oi.cancellation_date__c = oi.Renewal_date__c - 1;
                oi.Cancellation_reason__c = 'Price increase';
                oi.Renewal_Type__c = 'Extend Term';
                items.add(oi);
            }
            if(Math.mod(count, 2) == 0){
                //Activate only the even orders
                o.Status = 'Activated';
                o.Activated__c = true;
            }
            count++;
        }
        update mapIdToCloningOrders.values();

         Test.startTest();
            //Update the order items so it starts the Order Product process that fires cloneOrder()
            update items;

            //Verify the 2 active orders have been cloned
            /*System.assertEquals(4, [  SELECT count()
                                        FROM Order WHERE Status = 'Activated']);
            //Verify the cloned orders have correct start dates = earliest renewal date of the cloned order items (today + 10)
            System.assertEquals(Date.today() + 10, [SELECT EffectiveDate
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].EffectiveDate);
            System.assertEquals(Date.today() + 10, [SELECT Billing_start_date__c
                                                    FROM Order
                                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                                    LIMIT 1].Billing_start_date__c);*/
            //Verify there are 2 cloned order items with end date = today + 10 + 2 years
            Date inTwoYearsAndTenDays = (Date.today() + 10).addYears(2);
            /*System.assertEquals(2, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND EndDate = :inTwoYearsAndTenDays]);
            //Verify all of the cloned order items have the renewal checkbox set to true
            System.assertEquals(2, [SELECT count()
                                    FROM OrderItem
                                    WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Renewal__c = true]);*/
            //Verify the cloned order items have all cancellation and renewal fields set to null
            String fieldsConcatenation;
            for(OrderItem oi : [SELECT cancellation_date__c, Cancellation_reason__c, cancellation_reason_description__c, Renewal_Type__c, Renewal_price__c, Renewal_date__c
                                FROM OrderItem
                                WHERE OrderId NOT IN :mapIdToOriginalOrders.keySet()]){
                fieldsConcatenation = fieldsConcatenation + String.valueOf(oi.cancellation_date__c) + oi.Cancellation_reason__c + oi.cancellation_reason_description__c + oi.Renewal_Type__c + oi.Renewal_price__c + String.valueOf(oi.Renewal_date__c);
            }
            /*fieldsConcatenation = fieldsConcatenation.replace('null', '');
            System.assertEquals('', fieldsConcatenation);
            //Verify the cloned orders have been activated
            System.assertEquals(2, [SELECT count()
                                    FROM Order
                                    WHERE Id NOT IN :mapIdToOriginalOrders.keySet()
                                    AND Status = 'Activated']);*/
            //Verify the original active orders' items have their end date set equal to the cancellation date
            Date inNineDays = Date.today() + 10;
            /*System.assertEquals(inNineDays, [ SELECT EndDate
                                                FROM OrderItem
                                                WHERE OrderId IN :mapIdToCloningOrders.keySet()
                                                LIMIT 1].EndDate);*/
         Test.stopTest();
     }


    @isTest static void validateOrderFromMascus() {
        Account acc = [SELECT Id,Mascus_Customer_Number__c  FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Account legalAcc = [SELECT Id,Mascus_Customer_Number__c FROM Account WHERE Name = 'Legal Entity' LIMIT 1];
        Contact cont = [SELECT Id,Mascus_Contact_Number__c FROM Contact LIMIT 1];
        Order ord = [SELECT Id,Mascus_Order_Number__c FROM Order LIMIT 1];
        Product2 pr2 = [SELECT Id,Name,ProductCode FROM Product2 LIMIT 1];

        PricebookEntry pbe = [SELECT Id,Name,Pricebook2Id FROM PricebookEntry LIMIT 1];
        //pbe.Pricebook2Id = pr2.Id;
        //update pbe;
        MAS_OrderWebService.MAS_OrderRequestDTO  orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID = '0034400242003440024';

        Test.startTest();

        //Validate Mascus GUID length
        MAS_ResponseDTO response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_100);

        //Validate Mascus GUID empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID = null;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_101);

        //Validate Mascus order number length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '00344002420034400240034400242003440024';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_102);

        //Validate Mascus customer number empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       

        //Validate Mascus customer number length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = 'A020E0000000B6XQAU000';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_104);

        //Validate Mascus contact number length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = 'C020E0000000B6000U000';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_106);

        //Validate Authorized payment length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.Test Authorized payment.Test Authorized payment.';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_108);

        //Validate Bill from legal entity empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_111);

        //Validate Bill from legal entity length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = 'L020E0000000B6000U000';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_110);
        
        //Validate Sold to Account empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_113);

        //Validate Sold to Account length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = 'S020E0000000B6000U000';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_112);

        //Validate Order number for payment length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = 'O003440024200300344002420030034400';
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_114);

        //Validate Effective Date empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_116);

        //Validate Billing start date empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_117);

        //order item validation - order item empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_109);

        Test.stopTest();
      }
      
    @isTest static void validateOrderFromMascus2() {
    	Account acc = [SELECT Id,Mascus_Customer_Number__c  FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Account legalAcc = [SELECT Id,Mascus_Customer_Number__c FROM Account WHERE Name = 'Legal Entity' LIMIT 1];
        Contact cont = [SELECT Id,Mascus_Contact_Number__c FROM Contact LIMIT 1];
        Order ord = [SELECT Id,Mascus_Order_Number__c FROM Order LIMIT 1];
        Product2 pr2 = [SELECT Id,Name,ProductCode FROM Product2 LIMIT 1];

        PricebookEntry pbe = [SELECT Id,Name,Pricebook2Id FROM PricebookEntry LIMIT 1];
        //pbe.Pricebook2Id = pr2.Id;
        //update pbe;
        MAS_OrderWebService.MAS_OrderRequestDTO  orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID = '0034400242003440024';

        Test.startTest();

        //order item validation - product code empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        List<MAS_OrderWebService.OrderRequestItemsDTO> orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        MAS_OrderWebService.OrderRequestItemsDTO orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        MAS_ResponseDTO response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_101);
        
        //order item validation - product code length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019'
                                            +'PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019'
                                            +'PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019PRCode-0000100909091019';
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_100);

        //order item validation - Quantity empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019';
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_102);

        //order item validation - Order currency empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019';
        orderItem.order_Item_Quantity = 250;
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_104);

        //order item validation - Order currency length
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019';
        orderItem.order_Item_Quantity = 250;
        orderItem.orderItem_Currency = 'EURO';
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_103);

        //order item validation - Order Start date empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019';
        orderItem.order_Item_Quantity = 250;
        orderItem.orderItem_Currency = 'EUR';
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_105);

        //order item validation - Order end date empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019';
        orderItem.order_Item_Quantity = 250;
        orderItem.orderItem_Currency = 'EUR';
        orderItem.orderItem_StartDate = date.today();
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_106);

        //order item validation - order price unit of measure  empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019';
        orderItem.order_Item_Quantity = 250;
        orderItem.orderItem_Currency = 'EUR';
        orderItem.orderItem_StartDate = date.today();
        orderItem.orderItem_EndDate = date.today();
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_107);

        //order item validation - order item unit price empty
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  '0034400242';
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Id;
        orderRequest.order_BillToContact = cont.Id;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Id;
        orderRequest.order_SoldToAccount = acc.Id;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'PRCode-0000100909091019';
        orderItem.order_Item_Quantity = 250;
        orderItem.orderItem_Currency = 'EUR';
        orderItem.orderItem_StartDate = date.today();
        orderItem.orderItem_EndDate = date.today();
        orderItem.orderItem_PriceUnitofMesaure = 'Monthly';
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);       
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ITEM_ERROR_CODE_108);

        //Success request
        String strMascusOrderID = '0034400242';
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  strMascusOrderID;
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Mascus_Customer_Number__c;
        orderRequest.order_BillToContact = cont.Mascus_Contact_Number__c;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Mascus_Customer_Number__c;
        orderRequest.order_SoldToAccount = acc.Mascus_Customer_Number__c;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequest.order_IsPaid = true;
        orderRequest.order_Name = 'Test Order';
        orderRequest.order_Currency = 'EUR';
        orderRequest.order_Status = MAS_Constant.ORDER_STATUS_ACTIVE;
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = pr2.ProductCode;
        orderItem.order_Item_Quantity = 1;
        orderItem.orderItem_Currency = 'EUR';
        orderItem.orderItem_StartDate = date.today();
        orderItem.orderItem_EndDate = date.today();
        orderItem.orderItem_PriceUnitofMesaure = 'One-off';
        orderItem.orderItem_unitPrice = 100.00;
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);  
        
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_DML_SUCCESS_CODE);
        System.assertEquals(response.responseMessage , MAS_Constant.ORDER_DML_SUCCESS_MSG);
        List<Order> lstOrder = [SELECT Id,Name FROM Order WHERE Mascus_order_ID__c =:strMascusOrderID ];
        System.assert(lstOrder.size() > 0);
        List<OrderItem> lstOrderList = [SELECT Id FROM OrderItem WHERE OrderId =:lstOrder[0].Id];
        System.assert(lstOrderList.size() > 0);

        //Exception request
        strMascusOrderID = '0034400252';
        orderRequest = new MAS_OrderWebService.MAS_OrderRequestDTO ();
        orderRequest.order_MascusGUID =  strMascusOrderID;
        orderRequest.order_MascusOrderNumber = '0034400242003';
        orderRequest.order_BillToAccount = acc.Mascus_Customer_Number__c;
        orderRequest.order_BillToContact = cont.Mascus_Contact_Number__c;
        orderRequest.order_AuthorizedPayment = 'Test Authorized payment.';
        orderRequest.order_BillFromLegalEntity = legalAcc.Mascus_Customer_Number__c;
        orderRequest.order_SoldToAccount = acc.Mascus_Customer_Number__c;
        orderRequest.order_MascusOrderNumbeForPayment = ord.Mascus_Order_Number__c;
        orderRequest.order_StartDate = date.today();
        orderRequest.order_BillingStartDate = date.today();
        orderRequest.order_IsPaid = true;
        orderRequest.order_Name = 'Test Order';
        orderRequest.order_Currency = 'EUR';
        orderRequest.order_Status = MAS_Constant.ORDER_STATUS_ACTIVE;
        orderRequestItems = new List<MAS_OrderWebService.OrderRequestItemsDTO>();
        orderItem = new MAS_OrderWebService.OrderRequestItemsDTO();
        orderItem.orderItem_ProductCode = 'ProductCode'; //Provide wrong product code
        orderItem.order_Item_Quantity = 1;
        orderItem.orderItem_Currency = 'EUR';
        orderItem.orderItem_StartDate = date.today();
        orderItem.orderItem_EndDate = date.today();
        orderItem.orderItem_PriceUnitofMesaure = 'One-off';
        orderItem.orderItem_unitPrice = 100.00;
        orderRequestItems.add(orderItem);
        orderRequest.orderRequestItems = orderRequestItems;
        response = MAS_OrderWebService.upsertOrder(orderRequest);  
        
        System.assertEquals(response.responseCode , MAS_Constant.ORDER_ERROR_CODE_118);
        List<Order> lstOrderEx = [SELECT Id,Name FROM Order WHERE Mascus_order_ID__c =:strMascusOrderID ];
        System.assertEquals(lstOrderEx.size() , 0);
        
        Test.stopTest();
    }

        
    @isTest static void orderActivateInSF() {
            //Get order and set IsPrePaid__c to true
            Order order1 = [SELECT Id, IsPrePaid__c FROM Order LIMIT 1];
            order1.IsPrePaid__c = true;
            update order1;
            //Get order and set IsPrePaid__c to false
            Order order2 = [SELECT Id, IsPrePaid__c FROM Order WHERE ID != :order1.Id LIMIT 1];
            order2.IsPrePaid__c = false;
            update order2;


            Test.startTest();
            //Run test with IsPrePaid__c = true order
            list<string> trueResponse = MAS_OrderActivateAuraController.orderActivateInSF(order1.Id);

            System.assert(trueResponse != null);
            System.assertEquals(trueResponse[0] , MAS_Constant.RESPONSE_TYPE_SUCCESS);
            System.assertEquals(trueResponse[1] , Label.LBL_SUCS_ODER_APPROVED);
            Order orderUpdate1 = [SELECT Id, Status FROM Order WHERE ID = :order1.Id LIMIT 1];
            System.assertEquals(orderUpdate1.Status , MAS_Constant.ORDER_STATUS_ACTIVE);

            //Run test with IsPrePaid__c = false order
            list<string> falseResponse = MAS_OrderActivateAuraController.orderActivateInSF(order2.Id);
            
            System.assert(falseResponse != null);
            System.assertEquals(falseResponse[0] , MAS_Constant.RESPONSE_TYPE_SUCCESS);
            System.assertEquals(falseResponse[1] , Label.LBL_SUCS_ODER_APPROVED);
            Order orderUpdate2 = [SELECT Id, Status FROM Order WHERE ID = :order2.Id LIMIT 1];
            System.assertEquals(orderUpdate2.Status , MAS_Constant.ORDER_STATUS_ACTIVE);

            Test.stopTest();
        }

    @isTest static void orderReject() {
            //Get order and set IsPrePaid__c to true
            Order order1 = [SELECT Id, IsPrePaid__c FROM Order LIMIT 1];
            order1.IsPrePaid__c = true;
            update order1;
            //Get order and set IsPrePaid__c to false
            Order order2 = [SELECT Id, IsPrePaid__c FROM Order WHERE ID != :order1.Id LIMIT 1];
            order2.IsPrePaid__c = false;
            update order2;


            Test.startTest();

            list<string> trueResponse = MAS_OrderActivateAuraController.orderReject(order1.Id);
            System.assert(trueResponse != null);
            System.assertEquals(MAS_Constant.RESPONSE_TYPE_SUCCESS, trueResponse[0], 'Status should be Success.');
            System.assertEquals(Label.LBL_SUCS_ORDER_REJECTED, trueResponse[1], 'Incorrect success message.');
     		
     		list<string> trueResponse2 = MAS_OrderActivateAuraController.orderReject(order2.Id);
            System.assert(trueResponse2 != null);
            System.assertEquals(MAS_Constant.RESPONSE_TYPE_ERROR, trueResponse2[0], 'Status should be Error.');
            System.assertEquals('Only orders generated from Mascus Admin can be rejected', trueResponse2[1] , 'Incorrect error message.');

            Test.stopTest();
        }

    @isTest static void privateAdActivateInMascusSuccess() {
            Order order = [SELECT Id,Status FROM Order LIMIT 1];
            order.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
            order.Activated__c = true;
            update order;
            //composeEmailNotification method test here
            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
            list<string> responce =  MAS_OrderActivateAuraController.privateAdActivateInMascus(order.Id);

            System.assert(responce != null);
            System.assertEquals(responce[0] , MAS_Constant.RESPONSE_TYPE_SUCCESS);
            System.assertEquals(responce[1] , Label.LBL_SUCS_ODER_APPROVED);

            Order result =  [SELECT Id,Order_is_synced_with_Mascus__c FROM Order WHERE Id = :order.ID LIMIT 1];
            System.assertEquals(result.Order_is_synced_with_Mascus__c , true);

            Test.stopTest();

         }

    @isTest static void privateAdActivateInMascusError() {
            Order order = [SELECT Id FROM Order LIMIT 1];

            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.RESPONSE_TYPE_ERROR));
            list<string> responce =  MAS_OrderActivateAuraController.privateAdActivateInMascus(order.Id);

            System.assert(responce != null);
            System.assertEquals(responce[0] , MAS_Constant.RESPONSE_TYPE_ERROR);
            
            Order result =  [SELECT Id,RecordTypeId,Status FROM Order WHERE Id = :order.ID LIMIT 1];
            System.assertEquals(result.RecordTypeId ,  Schema.SObjectType.Order.getRecordTypeInfosByName().get('Order').getRecordTypeId());
            System.assertEquals(result.Status ,  MAS_Constant.ORDER_STATUS_DRAFT);
            

            Test.stopTest();

         }

    @isTest static void privateAdActivateInMascusException() {
            Order order = [SELECT Id FROM Order LIMIT 1];

            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl());
            list<string> responce =  MAS_OrderActivateAuraController.privateAdActivateInMascus(order.Id);

            System.assert(responce != null);
            System.assertEquals(responce[0] , MAS_Constant.RESPONSE_TYPE_ERROR);
            System.assertEquals(responce[1] , MAS_Constant.ERROR_MESSAGE);
            
            Order result =  [SELECT Id,RecordTypeId,Status FROM Order WHERE Id = :order.ID LIMIT 1];
            System.assertEquals(result.RecordTypeId ,  Schema.SObjectType.Order.getRecordTypeInfosByName().get('Order').getRecordTypeId());
            System.assertEquals(result.Status ,  MAS_Constant.ORDER_STATUS_DRAFT);

            Test.stopTest();

         }

    @isTest static void orderSyncWithMascusSuccess() {
            Order order = [SELECT Id FROM Order LIMIT 1];

            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));

            list<string> responce =  MAS_OrderActivateAuraController.orderSyncWithMascus(order.Id, true);

            System.assert(responce != null);
            System.assertEquals(responce[0] , MAS_Constant.RESPONSE_TYPE_SUCCESS);
            System.assertEquals(responce[1] , Label.LBL_SUCS_ODER_APPROVED);
            
            Order result =  [SELECT Id,Mascus_order_ID__c,Order_is_synced_with_Mascus__c,Description FROM Order WHERE Id = :order.ID LIMIT 1];
            System.assertEquals(result.Order_is_synced_with_Mascus__c ,  true);
            System.assertNotEquals(result.Mascus_order_ID__c ,  null);
            System.assertNotEquals(result.Description ,  null);

            Test.stopTest();

         }

    @isTest static void orderSyncWithMascusError() {
            Order order = [SELECT Id FROM Order LIMIT 1];

            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl('UNSUCCESS'));
            list<string> responce =  MAS_OrderActivateAuraController.orderSyncWithMascus(order.Id, true);

            System.assert(responce != null);
            System.assertEquals(responce[0] , MAS_Constant.RESPONSE_TYPE_ERROR);
            System.assert(responce[1] != null);
            
            Order result =  [SELECT Id,Description,RecordTypeId,Status FROM Order WHERE Id = :order.ID LIMIT 1];
            System.assertEquals(result.Status , MAS_Constant.ORDER_STATUS_DRAFT);
            System.assertEquals(result.RecordTypeId ,  Schema.SObjectType.Order.getRecordTypeInfosByName().get('Order').getRecordTypeId());
            System.assertNotEquals(result.Description ,  null);

            Test.stopTest();

         }

    @isTest static void orderSyncWithMascusException() {
            Order order = [SELECT Id FROM Order LIMIT 1];

            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl());
            list<string> responce =  MAS_OrderActivateAuraController.orderSyncWithMascus(order.Id, true);

            System.assert(responce != null);
            System.assertEquals(responce[0] , MAS_Constant.RESPONSE_TYPE_ERROR);
            System.assert(responce[1] != null);
            
            Order result =  [SELECT Id,RecordTypeId,Status FROM Order WHERE Id = :order.ID LIMIT 1];
            System.assertEquals(result.RecordTypeId ,  Schema.SObjectType.Order.getRecordTypeInfosByName().get('Order').getRecordTypeId());
            System.assertEquals(result.Status ,   MAS_Constant.ORDER_STATUS_DRAFT);
            
            Test.stopTest();

         }

    @isTest static void syncOrderItemCancelationWithMascusSuccess() {
            List<Id> lstIds = new List<Id>();
            List<Order> lstOrder = [SELECT Id FROM Order LIMIT :NUMBER_OF_ORIGINAL_ORDERS];
            for(Order  O : lstOrder){
                lstIds.add(o.Id);
            }
            /*List<OrderItem> lstOrderItem = [SELECT Id,Order_Item_Cancellation_Sync_with_Mascus__c,EndDate FROM OrderItem WHERE OrderId IN :lstIds];
            for(OrderItem oi: lstOrderItem){
                oi.Order_Item_Cancellation_Sync_with_Mascus__c = false;
                oi.EndDate = Date.today().addDays(10);
            }
            update lstOrderItem;*/

            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
            MAS_OrderService.syncOrderItemCancelationWithMascus(lstIds);
            
            Test.stopTest();
         }

    @isTest static void syncOrderItemCancelationWithMascusException() {
            List<Id> lstIds = new List<Id>();
            List<Order> lstOrder = [SELECT Id FROM Order LIMIT :NUMBER_OF_ORIGINAL_ORDERS];
            for(Order  O : lstOrder){
                lstIds.add(o.Id);
            }
            /*List<OrderItem> lstOrderItem = [SELECT Id,Order_Item_Cancellation_Sync_with_Mascus__c,EndDate FROM OrderItem WHERE OrderId IN :lstIds];
            for(OrderItem oi: lstOrderItem){
                oi.Order_Item_Cancellation_Sync_with_Mascus__c = false;
                oi.EndDate = Date.today().addDays(10);
            }
            update lstOrderItem;*/

            Test.startTest();
            //Mock service call out 
            Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl());
            MAS_OrderService.syncOrderItemCancelationWithMascus(lstIds);
            
            Test.stopTest();
         }

    @isTest static void getOrderDetail() {
            
            Order order = [SELECT Id FROM Order LIMIT 1];

            Test.startTest();
            
            Order orderSummary  = MAS_OrderActivateAuraController.getOrderInformation(order.Id);
            
            System.assert(orderSummary != null);

            Test.stopTest();
         }

    //composeEmailNotification need to be add by Kavinda
    @isTest static void sendOrderConfirmation() {
            Order order = [SELECT Id FROM Order LIMIT 1];

            Test.startTest();
            list<string> result = MAS_OrderActivateAuraController.sendOrderConfirmation(order.Id);
            
            System.assert(result != null);
            System.assertEquals(result[0] , MAS_Constant.RESPONSE_TYPE_SUCCESS);
            System.assert(result[1] != null);

            Test.stopTest();

        }

    //VAT Check
    @isTest static void orderValidation() {
            
            list<string> result = new list<string>();
            Order order = [SELECT Id,AccountId FROM Order LIMIT 1];
            Account acc = [SELECT Id,Valid_for_international_TAX__c,Valid_for_Local_TAX__c FROM Account WHERE Id = : order.AccountId];
            system.debug('#0');
            
            Test.startTest();   
            
        	// EU member check -EuCountry not found
			result  = MAS_OrderActivateAuraController.orderValidation(order.Id, true , 'Business account');
			System.assert(result != null);
			System.assertEquals(result[0] , MAS_Constant.RESPONSE_TYPE_SUCCESS);
			System.assertEquals(result[1] , Label.LBL_SUCS_ACC_VATValSuccess);
		
			//Create EU_Member_Country Custom setting for EU member check (VAT Validation)
			EU_Member_Country__c eu = (EU_Member_Country__c)MAS_TestDataFactory.createSObject(new EU_Member_Country__c(Name = 'Belgium',Country_Code__c='BE'), true);
			result  = MAS_OrderActivateAuraController.orderValidation(order.Id, true , 'Business account');
			
			order.BillingCountry = 'Belgium';
            order.BillingCountryCode = 'BE';
			update order;
			
            //Without Vat validation
            list<string> resultForPA  = MAS_OrderActivateAuraController.orderValidation(order.Id,true, 'Person account');           
            System.assert(resultForPA != null);
            System.assert(resultForPA[0] != null);

            acc.Valid_for_international_TAX__c = true;
            acc.Valid_for_Local_TAX__c = true;
            update acc;
            system.debug('#1');

            // Check tax local or international validity
            result  = MAS_OrderActivateAuraController.orderValidation(order.Id, true , 'Business account');

            System.assert(result != null);
            System.assertEquals(result[0] , MAS_Constant.RESPONSE_TYPE_SUCCESS);
            System.assertEquals(result[1] , Label.LBL_SUCS_ACC_VATValidLocalInternational);

            acc.Valid_for_international_TAX__c = false;
            acc.Valid_for_Local_TAX__c = false;
            acc.VAT_Number__c = null;
            update acc;
            system.debug('#2');

             // Vat number check
            result  = MAS_OrderActivateAuraController.orderValidation(order.Id, true , 'Business account');
            System.assert(result != null);
            System.assertEquals(result[0] , MAS_Constant.RESPONSE_TYPE_ERROR);
            System.assertEquals(result[1] , Label.LBL_ERR_ACC_VATEmpty);
                        
            Test.stopTest();
         }

    @isTest static void testCreatePlatformEvent() {

        Order ordObj = [ SELECT Id FROM Order ORDER BY Id LIMIT 1 ];
        String strOrderID = ordObj.Id;

        Test.startTest();
        List<String> lstResp = MAS_CreatePlatformEventAuraController.createPlatformEvent(strOrderID);
        System.assertEquals(lstResp[0], MAS_Constant.RESPONSE_TYPE_SUCCESS);
        System.assertEquals(lstResp[1], 'All changes have already been sent');

        ActionLog__c actLogObj = new ActionLog__c();
        actLogObj.OrderId__c = strOrderID;
        actLogObj.Source__c = 'Salesforce';
        actLogObj.Target__c = 'Oracle';
        actLogObj.Status__c = 'Failed';
        actLogObj.ActionType__c = MAS_Constant.ACTION_LOG_TYPE_INSERT;
        insert actLogObj;
        
        ActionLog__c checkLog = [SELECT Replayed__c FROM ActionLog__c WHERE Id = :actLogObj.Id];
        System.assertEquals(false, checkLog.Replayed__c);

        lstResp = MAS_CreatePlatformEventAuraController.createPlatformEvent(strOrderID);
        
        checkLog = [SELECT Replayed__c FROM ActionLog__c WHERE Id = :actLogObj.Id];
        System.assertEquals(true, checkLog.Replayed__c);
        
        System.assertEquals(lstResp[0], MAS_Constant.RESPONSE_TYPE_SUCCESS);
        System.assertEquals(lstResp[1], 'The changes have been sent');

        // Have to check and small improvement
        // actLogObj = [ SELECT Id FROM ActionLog__c LIMIT 1 ];
        // actLogObj.ActionType__c = 'UPDATE';
        // UPDATE actLogObj;

        // lstResp = MAS_CreatePlatformEventAuraController.createPlatformEvent(strOrderID);
        // System.assertEquals(lstResp[0], MAS_Constant.RESPONSE_TYPE_SUCCESS);
        // System.assertEquals(lstResp[1], 'Successfully published event.');

        Test.stopTest();

    }

    @isTest static void testProductTerminatePlatformEvent() {

        OrderItem ordItemObj = [ SELECT Id, Order.Id FROM OrderItem ORDER BY Id LIMIT 1 ];

        Test.startTest();

        // After the developments of MAS_OrderService.orderProductTerminatePaltFormEvent(recordId); method this case should work

        // List<String> lstResp = MAS_CreatePlatformEventAuraController.productTerminatePlatformEvent(ordItemObj.Id);
        // System.assertEquals(lstResp[0], MAS_Constant.RESPONSE_TYPE_ERROR);
        // System.assertEquals(lstResp[1], 'No fail event found');

        // ActionLog__c actLogObj = new ActionLog__c();
        // actLogObj.OrderId__c = ordItemObj.Order.Id;
        // actLogObj.Source__c = 'Salesforce';
        // actLogObj.Target__c = 'Oracle';
        // actLogObj.ActionType__c = 'DELETE';
        // INSERT actLogObj;

        // lstResp = MAS_CreatePlatformEventAuraController.productTerminatePlatformEvent(ordItemObj.Id);
        // System.assertEquals(lstResp[0], MAS_Constant.RESPONSE_TYPE_SUCCESS);
        // System.assertEquals(lstResp[1], 'Successfully published event.');

        Test.stopTest();

    }

    @isTest static void testCheckOrderIsActivated() {

        OrderItem ordItemObj = [ SELECT Id, Order.Id FROM OrderItem ORDER BY Id LIMIT 1 ];

        Order ordObj = [ SELECT Id FROM Order WHERE Id = :ordItemObj.Order.Id ];
        ordObj.Status = 'Activated';
        ordObj.Activated__c = true;
        UPDATE ordObj;

        Test.startTest();
        
        Boolean isActivated = MAS_CreatePlatformEventAuraController.checkOrderIsActivated(ordItemObj.Id);
        System.assertEquals(isActivated, true);

        Test.stopTest();

    }

    @isTest static void testComposeEmailNotification() {

        Order ordObj = [ SELECT Id, AccountId, Bill_from_legal_entity__r.Id, 
        Bill_from_legal_entity__r.Merchant_Account_Code__c, OwnerId FROM Order LIMIT 1 ];
        String strOrderId = ordObj.Id;

        Configuration__c configObj = [ SELECT Id, Name FROM Configuration__c WHERE Name = :MAS_Constant.ADYEN_KEY ];
        configObj.Value__c = 'HmacSHA256';
        UPDATE configObj;

        Account accObj = new Account(Id = ordObj.AccountId);
        accObj.Payment_method__c = MAS_Constant.ORDER_PAYMENT_METHOD_ONLINE;
        accObj.BillingCountryCode = 'NL';
        accObj.Email_for_invoicing__c = 'kavinda.wickramasingha@absi.be';
        UPDATE accObj;

        Account accBillEntity = new Account(Id = ordObj.Bill_from_legal_entity__r.Id);
        accBillEntity.Merchant_Account_Code__c = 'ABC';
        accBillEntity.Skin_Code__c = 'RED';
        UPDATE accBillEntity;

        User userObj = [ SELECT Id FROM User WHERE LastName = 'last' LIMIT 1 ];

        ordObj = new Order(Id = strOrderId);
        ordObj.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
        ordObj.Activated__c = true;
        ordObj.OwnerId = userObj.Id;
        UPDATE ordObj;

        Test.startTest();
        
        System.runAs(userObj) {
            MAS_OrderService.composeEmailNotification(strOrderId, false);
        }

        Test.stopTest();

    }

    @isTest static void testCommissionSplitChanges() {
        User BoomiUser = [SELECT Id FROM User WHERE LastName='Automated Information Sync Service' LIMIT 1];
        User randomUser = [SELECT Id FROM User WHERE isActive = true LIMIT 1];

        List<Order> orders = [SELECT Id, CurrencyIsoCode, OwnerId FROM Order];

        Test.startTest();
            System.assertNotEquals(null,orders.size());
            Order o = orders.get(0);

            // In createData itself order products are created, but no splittings (however the trigger should create splittings)
            List<OrderlineSplit__c> splittings =
                                    [SELECT Id, Amount__c, OrderLine__r.UnitPrice, OrderLine__r.OrderId, CurrencyIsoCode, User__c
                                    FROM OrderlineSplit__c
                                    WHERE OrderLine__r.OrderId = :o.Id
                                    ];

            System.assertNotEquals(null,splittings.size());
            System.assertEquals(splittings.get(0).OrderLine__r.UnitPrice, splittings.get(0).Amount__c);
            System.assertEquals(o.CurrencyIsoCode, splittings.get(0).CurrencyIsoCode);
            System.assertEquals(o.OwnerId, splittings.get(0).User__c);


            System.runAs(BoomiUser){ // Only Boomi User can update fields in OrderLineSplit (validation rule)
                o.OwnerId = randomUser.Id;
                update o;
            }
            splittings = [SELECT User__c FROM OrderlineSplit__c WHERE OrderLine__r.OrderId = :o.Id];

        Test.stopTest();
    }
    
    static testmethod void testTranslationMap() {
        List<Translation__c> testTranslations = new List<Translation__c>();
        Translation__c testTranslation1 = new Translation__c(Name='English', Language_Code__c='FR', Translation__c='French', Object__c='Language');
        testtranslations.add(testTranslation1);
        Translation__c testTranslation2 = new Translation__c(Name='English', Language_Code__c='IT', Translation__c='Italian', Object__c='Language');
        testtranslations.add(testTranslation2);
        Translation__c testTranslation3 = new Translation__c(Name='English', Language_Code__c='JP', Translation__c='Japanese', Object__c='Language');
        testtranslations.add(testTranslation3);
        Translation__c testTranslation4 = new Translation__c(Name='German', Language_Code__c='EN', Translation__c='English', Object__c='Language');
        testtranslations.add(testTranslation4);
        Translation__c testTranslation5 = new Translation__c(Name='German', Language_Code__c='DK', Translation__c='Danish', Object__c='Language');
        testtranslations.add(testTranslation5);
        Translation__c testTranslation6 = new Translation__c(Name='Blue', Language_Code__c='FR', Translation__c='Bleu', Object__c='Colour');
        testtranslations.add(testTranslation6);
        insert testTranslations;
        
        Map<String, Map<String, String>> checkTranslationMap = MAS_OrderService.getTranslationMap('Language');
        System.assertEquals(3, checkTranslationMap.get('English').values().size(), 'The number of records in the map for English is incorrect.');
        System.assertEquals(2, checkTranslationMap.get('German').values().size(), 'The number of records in the map for German is incorrect.');
        System.assertEquals(null, checkTranslationMap.get('Blue'), 'No records outside of the language object should be retreived.');
        
        String checkTranslation = MAS_OrderService.getTranslation('English', 'FR', checkTranslationMap);
        System.assertEquals('French', checkTranslation, 'The correct translation for English/FR was not retreived.');
        checkTranslation = MAS_OrderService.getTranslation('English', 'JP', checkTranslationMap);
        System.assertEquals('Japanese', checkTranslation, 'The correct translation for English/JP was not retreived.');
        checkTranslation = MAS_OrderService.getTranslation('German', 'DK', checkTranslationMap);
        System.assertEquals('Danish', checkTranslation, 'The correct translation for German/DK was not retreived.');
        checkTranslation = MAS_OrderService.getTranslation('French', 'EN', checkTranslationMap);
        System.assertEquals('French', checkTranslation, 'The default name should be used if there is no matching translation record.');
    }

    static testmethod void testCompleteTasksForCancelledOrders() {

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Order> orders = [SELECT Id FROM Order];

        List<Task> taskList = new List<Task>();

        Test.startTest();

        for (Order o: orders) {
            o.Activated__c = true;
            o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
        }
        update orders;

        // Manually creating task as those records are created through Process Builder Flow
        for (Order o: orders) {
            taskList.add(new Task(WhatId = o.Id, ActivityDate = System.today().addDays(30), 
                                Subject = 'Fixed term contract will end soon', Description = 'Procedure to take by Sales Rep'));
        }
        insert taskList;

        for (Task t: [SELECT Id, Status FROM Task WHERE Id IN :taskList]) {
            System.assert(t.Status != 'Completed');
        }        

        acc.Name = 'Change Name';
        update acc;

        for (Task t: [SELECT Id, Status FROM Task WHERE Id IN :taskList]) {
            System.assert(t.Status == 'Completed');
        }

        Test.stopTest();
    }

    static testmethod void testPrepaidOrdersNotCloned() {
        
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Order> orders = [SELECT Id FROM Order];

        Test.startTest();

        for (OrderItem oi: [SELECT Id, Cancellation_Date__c FROM OrderItem WHERE OrderId IN :orders]) {
            System.assert(oi.Cancellation_Date__c == NULL);            
        }

        for (Order o: orders) {
            o.Activated__c = true;
            o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
        }        
        update orders;

        // Clone the Orders
        acc.Name = 'Change Name';
        update acc;

        // Make sure that the Orders were cloned //
        for (OrderItem oi: [SELECT Id, Cancellation_Date__c FROM OrderItem WHERE OrderId IN :orders]) {
            System.assert(oi.Cancellation_Date__c != NULL);            
        }
        
        System.assert((orders.size() * 2) == ([SELECT Id FROM Order].size()));

        // Mark all the Active Orders as Prepaid
        List<Order> activeOrders = [SELECT Id FROM Order WHERE Status = :MAS_Constant.ORDER_STATUS_ACTIVE AND Activated__c = TRUE];
        for (Order o: activeOrders) {
            o.IsPrePaid__c = TRUE;
        }
        update activeOrders;

        // Clone the Orders
        acc.Name = 'Change Name Again';
        update acc;

        // Make sure that the Prepaid Orders are not cloned again
        System.assert((orders.size() * 2) == ([SELECT Id FROM Order].size()));        
    }
    static testmethod void testDiscountValidationOnNewOrderProducts() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Order> orders = [SELECT Id FROM Order];
        OrderItem existingOrderItem = [SELECT Id, PricebookEntryId, OrderId FROM OrderItem WHERE OrderId =: orders[0].Id];
        System.debug('existingOrderItem   '+existingOrderItem);
        User salesUser = [ SELECT Id FROM User WHERE LastName = 'last' LIMIT 1 ];
        System.runAs(salesUser) {
            OrderItem orderItem = (OrderItem) MAS_TestDataFactory.createSObject(new OrderItem(UnitPrice = 5, OrderId = existingOrderItem.OrderId, PricebookEntryId = existingOrderItem.PricebookEntryId, ServiceDate = System.today().addyears(-2).adddays(1), Next_billing_date__c = System.today() + 10, Last_billing_date__c = System.today()-10, Subscription_term_length__c = 'Fixed term'));
            try {
                insert orderItem;
            } catch (Exception exptn) {
                Boolean expectedExceptionThrown = exptn.getMessage().contains('Discount percentage is greater than 25%') ? true : false;
                System.assertEquals(expectedExceptionThrown, true);
            }
        }
    }
    static testmethod void testDiscountValidationOnUpdateOrderProducts() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Order> orders = [SELECT Id FROM Order];
        OrderItem existingOrderItem = [SELECT Id, PricebookEntryId, OrderId FROM OrderItem WHERE OrderId =: orders[0].Id];
        System.debug('existingOrderItem   '+existingOrderItem);
        OrderItem orderItem = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=existingOrderItem.OrderId,PricebookEntryId=existingOrderItem.PricebookEntryId,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today()+10,Last_billing_date__c=System.today()-10,Subscription_term_length__c = 'Fixed term'));
        insert orderItem;
        OrderItem item = [SELECT Id, PricebookEntryId, OrderId,UnitPrice FROM OrderItem WHERE Id =: orderItem.Id];
        User salesUser = [ SELECT Id FROM User WHERE LastName = 'last' LIMIT 1 ];
        System.runAs(salesUser) {
            try {
                item.UnitPrice = 5;
                update item;
            } catch (Exception exptn) {
                Boolean expectedExceptionThrown = exptn.getMessage().contains('Discount percentage is greater than 25%') ? true : false;
                System.assertEquals(expectedExceptionThrown, true);
            }
        }
    }

    static testmethod void testDiscountValidationOnNewOrderProductsFromMascusAdmin() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Order> orders = [SELECT Id FROM Order];
        OrderItem existingOrderItem = [SELECT Id, PricebookEntryId, OrderId FROM OrderItem WHERE OrderId =: orders[0].Id];
        System.debug('existingOrderItem   '+existingOrderItem);
        User mascusWebserviceUser = [ SELECT Id,Is_Mascus_Webservice__c  FROM User WHERE LastName = 'last' LIMIT 1 ];
        mascusWebserviceUser.Is_Mascus_Webservice__c = TRUE;
        update mascusWebserviceUser;
        System.runAs(mascusWebserviceUser) {
            OrderItem orderItem = (OrderItem) MAS_TestDataFactory.createSObject(new OrderItem(UnitPrice = 5, OrderId = existingOrderItem.OrderId, PricebookEntryId = existingOrderItem.PricebookEntryId, ServiceDate = System.today().addyears(-2).adddays(1), Next_billing_date__c = System.today() + 10, Last_billing_date__c = System.today()-10, Subscription_term_length__c = 'Fixed term'));
            insert  orderItem;
            System.assertEquals([SELECT count() FROM OrderItem WHERE OrderId =: existingOrderItem.OrderId], 2);
        }
    }
}