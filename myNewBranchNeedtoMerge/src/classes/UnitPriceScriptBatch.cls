// temporary class to calculate the unit price of the order products
// Created by Artash Manoucharjan ABSI.nl
global class UnitPriceScriptBatch implements Database.Batchable<sObject> {    // 
    
    /* Schedule this class with:
UnitPriceScriptBatch be = new UnitPriceScriptBatch();
database.executeBatch(be,1);    // # records in batch   WORKS WITH 1 RECORD IN BATCH !!!!!
*/
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'Select id,name,Legacy_Revenue__c,CurrencyIsoCode,'+
            ' (Select id,Product2Id,Legacy_Sales_Share__c,ListPrice,UnitPrice,Legal_entity_sales_share__c,order.Legacy_Revenue__c,Description,Overwrite_price__c '+
            ' FROM OrderItems WHERE Overwrite_price__c=true AND UnitPrice=0)'+
            ' FROM ORDER '+
            'WHERE status = \'Draft\' AND Mascus_Sale_Legacy_ID__c != \'\' AND Name != \'Outstanding Invoice Conversion\'';
//            +'AND id=\'8018E0000013V9jQAE\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Order> OrderListInitial) {
        
        system.debug('OrderListInitial.size BEFORE Delete = '+OrderListInitial.size());
        
        List<Order> OrderList = new List<Order>();
        for(Order order: OrderListInitial){
            
            system.debug('TEST2');
            system.debug('order.OrderItems.isEmpty()'+order.OrderItems.isEmpty());
            
            if(!order.OrderItems.isEmpty()){  // more then 0 products in Order
                boolean orderWithUnitPriceAlreadyCalculated = false;             // already calculated orders
                boolean currecyEqual = true;        // order currency must be the same as the product currency that is saved in product Description 
                for(OrderItem oi: order.OrderItems){
                    if(oi.UnitPrice!=0){
                        orderWithUnitPriceAlreadyCalculated=true;
                    }
                    if(order.CurrencyIsoCode!=oi.Description && oi.Legal_entity_sales_share__c!=null){    // check currency only for sales share orders
                        currecyEqual=false;
                    }
                    
                }
                system.debug('orderWithUnitPriceAlreadyCalculated='+orderWithUnitPriceAlreadyCalculated);
                system.debug('currecyEqual='+currecyEqual);
                if(!orderWithUnitPriceAlreadyCalculated && currecyEqual){ // order can be calculated
                    OrderList.add(order);
                }
            }
        }
        system.debug('OrderList.size After Delete = '+OrderList.size());

        system.debug('OrderList.size()'+OrderList.size());
        //              return;
        
        // process each batch of records
        ///////////////////////////////////////////////// 
        
        //1. Fill in Legacy Sales Share of missing Product
        
        Map<id,OrderItem> orderItemToUpdateMap = new Map<id,OrderItem>();  // items without Legacy_Sales_Share__c
        
        For(Order o: OrderList){
            
            Map<String,double> product2IdLegacySalesMap = new Map<String,double>();         //key = itemID+Product2ID   , value = item.Legacy_Sales_Share__c
            product2IdLegacySalesMap.clear();
            
            
            for(OrderItem item: o.OrderItems){
                
                system.debug('item.Legacy_Sales_Share__c='+item.Legacy_Sales_Share__c);
                system.debug('item.id='+item.id);
                
                
                if(item.Legal_entity_sales_share__c!=null){       
                    String keyString = String.valueOf(item.Product2Id);
                    if(!product2IdLegacySalesMap.containsKey(keyString)){
                        product2IdLegacySalesMap.put(keyString,item.Legacy_Sales_Share__c);
                    }else{ // already in the map
                        product2IdLegacySalesMap.put(keyString,product2IdLegacySalesMap.get(keyString)+item.Legacy_Sales_Share__c);   // add legacy sales shares
                    }
                    double test = product2IdLegacySalesMap.get(keyString);
                    system.debug('Test48= '+test);
                }else{
                    orderItemToUpdateMap.put(item.id,item);
                }
            }
            
            for(OrderItem item: orderItemToUpdateMap.Values()){  //  run through  Order Items with empty legacys  AND insert Legacy_Sales_Share__c
                
                double sumLegacysOverig = 0;
                String keyString = String.valueOf(item.Product2Id);
                system.debug('keyString ='+keyString);
                system.debug('product2IdLegacySalesMap.size()='+product2IdLegacySalesMap.size());
                system.debug('product2IdLegacySalesMap ='+product2IdLegacySalesMap);
                if(product2IdLegacySalesMap.containsKey(keyString)){
                    System.debug('Test61');
                    sumLegacysOverig = product2IdLegacySalesMap.get(keyString);
                }
                system.debug('sumLegacysOverig ='+sumLegacysOverig);
                system.debug('o.Legacy_Revenue__c='+o.Legacy_Revenue__c);
                system.debug('item.id='+item.id);
                item.Legacy_Sales_Share__c = item.order.Legacy_Revenue__c - sumLegacysOverig;
                system.debug('item.Legacy_Sales_Share__c='+item.Legacy_Sales_Share__c);
            }
        }
        
        if(!orderItemToUpdateMap.isEmpty()){
                        system.debug('orderItemToUpdateMap = '+orderItemToUpdateMap);
            update orderItemToUpdateMap.values();       //Legacy_Sales_Share__c of ALL OrderItems are filled in !!!!!!!!!!!!
        }
        
        
        
        ////////2. Calculate Unit price 
        
        Set<Id> orderIdsSet = new Set<ID>();
        for(Order order: OrderList){
            orderIdsSet.add(order.id); // put all order ids of the batch in the set , to retrive the Orders after Legacy_Sales_Share__c are inserted  
        }
            

        
        List<Order> orderList2 = [Select id,name,Legacy_Revenue__c,CurrencyIsoCode,
                                  (Select id,Product2Id,Legacy_Sales_Share__c,ListPrice,UnitPrice,Legal_entity_sales_share__c,Description,Overwrite_price__c 
                                   FROM OrderItems WHERE Overwrite_price__c=true AND UnitPrice=0 )
                                  FROM ORDER 
                                  WHERE id in :orderIdsSet]; 
        system.debug('orderList2.size()='+orderList2.size());
        List<OrderItem> orderItemsToUpdateList = new List<OrderItem>();
        
        
        for(Order ord: orderList2){
            // next order if there are no products for the order
            if(orderList2.isEmpty()){
                continue;
            }
            
            
            Map<String,double> accountIdListPriceAllProducts = new Map<String,decimal>();     // key = String of ID   // cuz there are empty accounts
            Map<OrderItem,Id> orderItemsToUpdate = new Map<OrderItem,String>();
            
            for(OrderItem item: ord.OrderItems){
                
                system.debug('item.Legacy_Sales_Share__c = '+item.Legacy_Sales_Share__c);
                String idAccountString = 'DefaultIDAccount';
                if(item.Legal_entity_sales_share__c!=null){
                    idAccountString = string.valueOf(item.Legal_entity_sales_share__c);
                }
                
                // Entity not in the map
                if(!accountIdListPriceAllProducts.containsKey(idAccountString)){
                    if(item.ListPrice!=0){  // using list price if not 0
                        system.debug('Test95');
                        accountIdListPriceAllProducts.put(idAccountString,item.ListPrice); 
                    }else{ // if list price is 0 we will use Legacy Sales Share to calculate the unit price
                        system.debug('Test98');
                        system.debug('item.Legacy_Sales_Share__c='+item.Legacy_Sales_Share__c);
                        accountIdListPriceAllProducts.put(idAccountString,item.Legacy_Sales_Share__c); 
                    }
                    
                    //Entity already in the map, adding up the listpijs
                }else{  
                    if(item.ListPrice!=0){ // using list price if not 0
                        accountIdListPriceAllProducts.put(idAccountString,accountIdListPriceAllProducts.get(idAccountString)+item.ListPrice);
                    }else{ // if list price is 0 we will use Legacy Sales Share to calculate the unit price
                        accountIdListPriceAllProducts.put(idAccountString,accountIdListPriceAllProducts.get(idAccountString)+item.Legacy_Sales_Share__c);
                    }
                    
                }
                orderItemsToUpdate.put(item,idAccountString);
                //                system.debug('accountIdListPriceAllProducts='+accountIdListPriceAllProducts);
                
            }
            
            for(OrderItem oItem: orderItemsToUpdate.Keyset()){
                
                String idAccountString = 'DefaultIDAccount';
                if(oitem.Legal_entity_sales_share__c!=null){
                    idAccountString = string.valueOf(oitem.Legal_entity_sales_share__c);
                }
                
                                system.debug('accountIdListPriceAllProducts='+accountIdListPriceAllProducts);
                
                Decimal ListPriceAllProducts = accountIdListPriceAllProducts.get(idAccountString);
                //                system.debug('ListPriceAllProducts ='+ListPriceAllProducts);
                
                if(oItem.ListPrice!=0){  // use listprice if not 0
                    system.debug('R123 ='+oItem.id);
                    system.debug('oItem.ListPrice ='+oItem.ListPrice);
                    system.debug('ListPriceAllProducts ='+ListPriceAllProducts);
                    system.debug('oItem.Legacy_Sales_Share__c ='+oItem.Legacy_Sales_Share__c);
                    oItem.UnitPrice = oItem.ListPrice / ListPriceAllProducts * oItem.Legacy_Sales_Share__c;
                }else{ // else use Legacy_Sales_Share__c 
                    system.debug('R126 ='+oItem.id);
                    system.debug('oItem.Legacy_Sales_Share__c = '+oItem.Legacy_Sales_Share__c);
                    system.debug('oItem.ListPriceAllProducts = '+ ListPriceAllProducts);
                    oItem.UnitPrice = oItem.Legacy_Sales_Share__c / ListPriceAllProducts * oItem.Legacy_Sales_Share__c;
                }
                
                
                oItem.UnitPrice = oItem.UnitPrice.SetScale(2);
                
                system.debug('OrderID ='+ord.id);                
                system.debug(' oItem.id ='+ oItem.id);
                system.debug(' oItem.UnitPrice ='+ oItem.UnitPrice);
                orderItemsToUpdateList.add(oItem);
            }    
        }
        
        //        system.debug('updateList = ' + orderItemsToUpdateList);
        update orderItemsToUpdateList;
        
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}