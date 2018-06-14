@isTest
private class OrderTriggerHandler_Test {

    public final static Integer NUMBER_OF_ORIGINAL_ORDERS = 5;

    @testSetup public static void testSetup() {

        Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name = MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c = 'true'), true);
        Configuration__c c2 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name = MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c = 'true'), true);

        Profile p = (Profile)MAS_TestDataFactory.createSObject(new Profile(), false);
        User regularUser = (User)MAS_TestDataFactory.createSObject(new User(ProfileId = p.Id), false);

        Profile sysAdminP = [Select id from Profile where Name = 'System Administrator' limit 1];
        User adminUser = (User)MAS_TestDataFactory.createSObject(new User(ProfileId = sysAdminP.Id, LastName = 'User1', Email = 'test1@cloudtest.rbaenv.com', UserName = 'Test1@cloudtest.rbaenv.com', Alias = 'test1com'), false);
        User mascusUser = (User)MAS_TestDataFactory.createSObject(new User(ProfileId = sysAdminP.Id, LastName = 'User2', Email = 'test2@cloudtest.rbaenv.com', UserName = 'Test2@cloudtest.rbaenv.com', Alias = 'test2com', Is_Mascus_Webservice__c = true), false);
        mascusUser.Is_Mascus_Webservice__c = true;
        insert new List<User> {regularUser, adminUser, mascusUser};

        System.runAs(regularUser) {
            Account a = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Test Account', Email_for_invoicing__c = 'Emailforinvoicing@test.com'), true);
            Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId = a.Id), true);
        }

        Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Legal Entity', Type = 'Internal legal entity', HMAC_Key__c = '4A4B4C', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);
        
        Account a = Get_Test_Account();
        Contact c = Get_Test_Contact();

        //Create a list of orders
        Order[] oList = (Order[])MAS_TestDataFactory.createSObjectList(new Order(AccountId=a.Id, Bill_from_legal_entity__c=legalEntity.Id, Sold_to_Account__c=a.Id, BillToContactId=c.Id, Sold_to_contact__c=c.Id, CurrencyIsoCode = 'EUR'), NUMBER_OF_ORIGINAL_ORDERS, true);
        //Create one product and a price book entry for it
        Product2 pro = (Product2)MAS_TestDataFactory.createSObject(new Product2(ProductCode =MAS_Constant.PRIVATE_AD), true);
        //Pricebook2 pb2 = (Pricebook2)MAS_TestDataFactory.createSObject(new Pricebook2(), true);
        PricebookEntry pbe = (PricebookEntry)MAS_TestDataFactory.createSObject(new PricebookEntry(Product2Id=pro.Id , CurrencyIsoCode='EUR'), true);
        
        //Create one order items per order
        List<OrderItem> items = new List<OrderItem>();
        for(Order o : oList){
            OrderItem oi = (OrderItem)MAS_TestDataFactory.createSObject(new OrderItem(OrderId=o.Id,PricebookEntryId=pbe.Id,ServiceDate=System.today().addyears(-2).adddays(1),Next_billing_date__c=System.today()+10,Last_billing_date__c=System.today().addMonths(2),Subscription_term_length__c = 'Fixed term'));
            items.add(oi);
        }
        insert items;
    }

    @isTest static void Test_Order_Creation_Owner_Mascus_Webservice() {

        Account a = Get_Test_Account();
        Account legalEntity = Get_Legal_Entity_Account();
        Contact c = Get_Test_Contact();

        Order o = (Order)MAS_TestDataFactory.createSObject(new Order(AccountId = a.Id, Bill_from_legal_entity__c = legalEntity.Id, Sold_to_Account__c = a.Id,
                  BillToContactId = c.Id, Sold_to_contact__c = c.Id, CurrencyIsoCode = 'EUR'), false);
        User regularUser = Get_Test_User();
        User mascusUser = Get_Mascus_Webservice_Test_User();

        Test.startTest();
        System.runAs(mascusUser) {
            Insert o;
        }
        Test.stopTest();

        o = Get_Test_Order();
        System.assertEquals(o.OwnerId, regularUser.Id, 'Error - The order owner Id is not regular user.');

    }

    @isTest static void Test_Order_Creation_Owner_Not_Mascus_Webservice() {

        Account a = Get_Test_Account();
        Account legalEntity = Get_Legal_Entity_Account();
        Contact c = Get_Test_Contact();

        User regularUser = Get_Test_User();
        User adminUser = Get_Test_Admin_User();
        User mascusUser = Get_Mascus_Webservice_Test_User();

        a.OwnerId = regularUser.Id;
        c.OwnerId = regularUser.Id;

        update a;
        Update c;

        a = Get_Test_Account();
        c = Get_Test_Contact();

        Test.startTest();
        System.runAs(adminUser) {
            Order o = (Order)MAS_TestDataFactory.createSObject(new Order(AccountId = a.Id, Bill_from_legal_entity__c = legalEntity.Id, Sold_to_Account__c = a.Id,
                      BillToContactId = c.Id, Sold_to_contact__c = c.Id, CurrencyIsoCode = 'EUR'), false);
            Insert o;
        }
        Test.stopTest();

        ORder o = Get_Test_Order();
        System.assertEquals(o.OwnerId, adminUser.Id, 'Error - The order owner Id is not admin user.');
    }

    @isTest static void Test_UpdateAddressFieldsAndInvoiceInfo() {

        Account acc = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Test Account1', Email_for_invoicing__c = 'Emailforinvoicing@test.com', BillingCity = 'Vancouver', BillingCountry = 'Canada', BillingState = 'British Columbia', BillingStreet = 'xyz St',BillingPostalCode = '233232'), true);
        Contact con = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId = acc.Id, FirstName = 'FirstName', LastName = 'LastName', MailingCity = 'Vancouver', MailingStreet = 'xyz st', MailingPostalCode = '123232'), true);

        
        Test.startTest();

        acc = [SELECT ShippingPostalCode, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, BillingCity, BillingCountry, BillingState,
                BillingStreet, BillingPostalCode FROM Account WHERE Id = :acc.Id];

        List<Order> orders = Get_Test_Order_With_Items();
        for (Order o: orders) {
            o.Sold_to_Account__c = acc.Id;
            o.AccountId = acc.Id;
            o.BillToContactId = con.Id;
            o.Sold_to_contact__c = con.Id;
        }
        update orders;

        for (Order o: [SELECT SoldtoPostalcode__c, Soldtocity__c, Soldtocountry__c, Soldtostate__c, Soldtostreet__c, BillingCity, BillingCountry, BillingState,
                        BillingStreet, BillingPostalCode FROM Order WHERE Total_Number_Of_Products__c > 0 ]) {

            System.assert(o.SoldtoPostalcode__c == acc.ShippingPostalCode);
            System.assert(o.Soldtocity__c == acc.ShippingCity);
            System.assert(o.Soldtocountry__c == acc.ShippingCountry);
            System.assert(o.Soldtostate__c == acc.ShippingState);
            System.assert(o.Soldtostreet__c == acc.ShippingStreet);
            System.assert(o.BillingCity == acc.BillingCity);
            System.assert(o.BillingCountry == acc.BillingCountry);
            System.assert(o.BillingPostalCode == acc.BillingPostalCode);
            System.assert(o.BillingState == acc.BillingState);
            System.assert(o.BillingStreet == acc.BillingStreet);
        }
        
        Test.stopTest();
    }

    @isTest static void Test_activateOrderItemsOnOrderActivation() {

        Test.startTest();

        List<Order> orders = Get_Test_Order_With_Items();
        for (Order o: orders) {
            o.Activated__c = true;
            o.Status = 'Activated';
        }
        update orders;

        List<OrderItem> orderItems = [SELECT Activated__c, Email_Address_Sales_Rep_Owner__c, Email_Address_Sold_to_Contact__c, Order.Owner.Email, 
                                        Order.Sold_to_contact__r.Email FROM OrderItem WHERE OrderId IN :orders];

        for (OrderItem oi: orderItems) {
            System.assert(oi.Activated__c == true);
            System.assert(oi.Email_Address_Sales_Rep_Owner__c == oi.Order.Owner.Email);
            System.assert(oi.Email_Address_Sold_to_Contact__c == oi.Order.Sold_to_contact__r.Email);
        }

        Test.stopTest();
    }

    private static User Get_Test_User() {
        return [SELECT Id, LastName, Email, UserName  FROM User WHERE Is_Mascus_Webservice__c = false AND UserName = 'test@cloudtest.rbaenv.com'];
    }

    private static User Get_Test_Admin_User() {
        return [SELECT Id, LastName, Email, UserName FROM User WHERE Is_Mascus_Webservice__c = false AND UserName = 'test1@cloudtest.rbaenv.com'];
    }

    private static User Get_Mascus_Webservice_Test_User() {
        Return [SELECT Id, UserName, LastNAme FROM User WHERE Is_Mascus_Webservice__c = true AND LastName = 'User2'];
    }

    private static Account Get_Test_Account() {
        Return [Select Id, OwnerId from Account WHERE Name = 'Test Account'];
    }

    private static Account Get_Legal_Entity_Account() {
        Return [Select Id, OwnerId from Account WHERE Name = 'Legal Entity'];
    }

    private static Contact Get_Test_Contact() {
        Return [Select Id, OwnerId from Contact];
    }

    private static Order Get_Test_Order() {
        Return [Select Id, OwnerId from Order WHERE Total_Number_Of_Products__c = 0];
    }

    private static List<Order> Get_Test_Order_With_Items() {
        return [SELECT Id FROM Order WHERE Total_Number_Of_Products__c > 0];
    }

}