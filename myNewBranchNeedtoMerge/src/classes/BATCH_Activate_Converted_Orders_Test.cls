/******************************************************
 * Description      : APEX TEST class for MAS BATCH Activate Converted Orders
 * @author          : MATTHIAS STROOBANTS
 * @since           : 2018-01-30
 * Copyright 2018 ABSI. All rights reserved.
 ******************************************************/

@isTest(seeAllData=false)
private class BATCH_Activate_Converted_Orders_Test {

    static testMethod void Test_Activate_Converted_Order_OutstandingInvoiceConversion() {
        OrderService_Test.createData();

        // Delete all orders on the account, but one, since we only want one order for this scenario

        Test.startTest();
        Account a = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Order o = [SELECT Id, Status, Mascus_Sale_legacy_ID__c FROM Order WHERE AccountId =:a.Id LIMIT 1];
        o.Mascus_Sale_legacy_ID__c = '12345';
        o.Status = 'Draft';
        o.Name = 'Outstanding Invoice Conversion';
        update o;

        System.assertEquals('Draft',o.Status);
        Database.executeBatch(new MAS_BATCH_Activate_Converted_Orders(true,10),1);
        Test.stopTest();

        o = [SELECT Id, Status, Mascus_Sale_legacy_ID__c FROM Order WHERE Name = 'Outstanding Invoice Conversion' LIMIT 1];
        System.assertEquals('Activated',o.Status);

    }

    static testMethod void Test_Activate_Converted_Order_Not_OutstandingInvoiceConversion() {
        OrderService_TEST.createData();

        // Delete all orders on the account, but one, since we only want one order for this scenario
        Integer ordersToDelete = OrderService_Test.NUMBER_OF_ORIGINAL_ORDERS - 1;
        List<Order> ordersLinkedToAccount = [SELECT Status, Id FROM Order WHERE Sold_to_Account__r.Name = 'Test Account' LIMIT :ordersToDelete];
        delete ordersLinkedToAccount;

        Test.startTest();
        Account a = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        List<Order> orderList = [SELECT Id, Status, Mascus_Sale_legacy_ID__c FROM Order WHERE AccountId =:a.Id];
        System.assertEquals(1,orderList.size());
        orderList[0].Name = 'test';
        orderList[0].Mascus_Sale_legacy_ID__c = '12345';
        orderList[0].Status = 'Draft';
        update orderList[0];

        System.assertEquals('Draft',orderList[0].Status);
        Database.executeBatch(new MAS_BATCH_Activate_Converted_Orders(false,10),1);
        Test.stopTest();

        orderList = [SELECT Id, Status, Mascus_Sale_legacy_ID__c FROM Order WHERE Id =:orderList[0].Id];
        System.assertEquals('Activated',orderList[0].Status);

    }
}