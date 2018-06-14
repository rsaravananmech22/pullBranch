// testing the temporary class UnitPriceScriptBatch
// Created by Artash Manoucharjan ABSI.nl
@IsTest
public class UnitPriceScriptBatch_Test {
    
    @isTest private static void testScript(){
        OrderService_Test.createData();
        
        List<Order> orderList = [Select id,Legacy_Revenue__c,
                                 (Select id,Product2Id,Legacy_Sales_Share__c,ListPrice,UnitPrice,Legal_entity_sales_share__c FROM OrderItems)
                                 from Order
                  //               WHERE status = 'Draft' AND Mascus_Sale_Legacy_ID__c != '' AND Name != 'Outstanding Invoice Conversion'
                                 Limit 1];
        // WHERE status = \'Draft\' AND Mascus_Sale_Legacy_ID__c != \'\' AND Name != \'Outstanding Invoice Conversion\'';
        // 
        // 
        system.debug('orderList.size()='+orderList.size()); 
        
        for(Order o:orderList){
            o.Legacy_Revenue__c = 1000;
            o.Status = 'Draft';
            o.Mascus_Sale_legacy_ID__c='O00000824';
            for(OrderItem item: o.OrderItems){
                item.Description=o.CurrencyIsoCode;
                item.Legacy_Sales_Share__c = 200;
            }
        }
        update orderList;
        
        List<Order> orderListUpdated = [Select id,Legacy_Revenue__c,CurrencyIsoCode,
                                 (Select id,Product2Id,Legacy_Sales_Share__c,ListPrice,UnitPrice,Legal_entity_sales_share__c,Description FROM OrderItems)
                                 from Order
                                 WHERE status = 'Draft' AND Mascus_Sale_Legacy_ID__c != '' AND Name != 'Outstanding Invoice Conversion'
                                 Limit 1];
        
        system.debug('orderListUpdated.size()='+orderListUpdated.size()); 
        
        system.debug('order.OrderItems.size()'+orderListUpdated[0].OrderItems.size());
        
        List<OrderItem> oiList = new List<OrderItem>();
        
        for(Order order: orderListUpdated){
            system.debug('order.CurrencyIsoCode='+order.CurrencyIsoCode);
            for(OrderItem oi: order.OrderItems){
                oi.Description = order.CurrencyIsoCode;
                oi.UnitPrice = 0.0;
                oi.Overwrite_price__c=true;
                system.debug('oi.Product2Id'+oi.Product2Id);
                system.debug('oi.ListPrice'+oi.ListPrice);
                system.debug('oi.UnitPrice'+oi.UnitPrice);
                system.debug('oi.Description'+oi.Description);
                oiList.add(oi);
            }
        }
        
        
        update oiList;
        system.debug('');
        
        
      
        
        Test.startTest();
        
        List<Order> orderListUpdated2 = [Select id,Legacy_Revenue__c,CurrencyIsoCode,
                                        (Select id,Product2Id,Legacy_Sales_Share__c,ListPrice,UnitPrice,Legal_entity_sales_share__c,order.Legacy_Revenue__c,Description,Overwrite_price__c FROM OrderItems)
                                        from Order
                                        WHERE status = 'Draft' AND Mascus_Sale_Legacy_ID__c != '' AND Name != 'Outstanding Invoice Conversion'
                                        Limit 1];
        system.debug('orderListUpdated2='+orderListUpdated2[0].orderItems);
        
        
        
        
        UnitPriceScriptBatch obj = new UnitPriceScriptBatch();
        DataBase.executeBatch(obj);
        
        obj.execute(null,orderListUpdated2);
        
        Test.stopTest();
        
        List<Order> orderList2 = [Select id,Legacy_Revenue__c,
                                  (Select id,Product2Id,Legacy_Sales_Share__c,ListPrice,UnitPrice,Legal_entity_sales_share__c 
                                   FROM OrderItems)
                                  FROM Order LIMIT 1];
        
        for(Order ord: orderList2){
            
            Map<id,decimal> accountIdListPriceAllProducts = new Map<id,decimal>();
            Map<OrderItem,Id> orderItemsToUpdate = new Map<OrderItem,Id>();
            
            for(OrderItem oItem: ord.OrderItems){
                system.debug('test34 ='+oItem);
                system.debug('oItem.Legacy_Sales_Share__c ='+oItem.Legacy_Sales_Share__c);
//                oItem.UnitPrice = oItem.ListPrice / ListPriceAllProducts * oItem.Legacy_Sales_Share__c;
            system.assertEquals(oItem.ListPrice/oItem.ListPrice*oItem.Legacy_Sales_Share__c, oItem.UnitPrice);
            
            }
        }
    }
}