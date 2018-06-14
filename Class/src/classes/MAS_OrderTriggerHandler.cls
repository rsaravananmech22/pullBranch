/**************************************************************************
 * Description  : Apex Trigger handler classs for Order
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR              DATE            DETAIL
      1.0      Samith Perera       20/11/2017      Initial implementation
 **************************************************************************/

public class MAS_OrderTriggerHandler {

    /**
    * @Description: This method activate the dealer credits orders from mascus
    * @author: Samith Perera
    * @params: newAccounts : new order values list
    *          oldAccounts : old order values list
    * @return: void
    */
    public static void makeOrderReadOnly(list<Order>newOrders, list<Order>oldOrders) {

        // Need normal order validation
        // once the activation is done
        // send customer notification
        // need to notify boomi
    }

    /**
     * @Description: This method activates the Update of the Commission Splitting Sales Rep (when Order Owner changes)
     * @author: Matthias Stroobants
     * @params: newOrders : new order values list
     *          oldOrderMap : old order map
     * @return: void
     */
    public static void updateCommissionSplittingsWhenOwnerChanged(list<Order>newOrders, Map<Id, Order> oldOrderMap) {
        Map<Id, Order> updatedOrderMap = new Map<Id, Order>();
        for (Order o : newOrders) {
            if (o.OwnerId != oldOrderMap.get(o.Id).OwnerId) {
                updatedOrderMap.put(o.Id, o);
            }
        }
        if (!Test.isRunningTest() && !updatedOrderMap.isEmpty())
            MAS_OrderService.updateCommissionSplittingSalesRep(updatedOrderMap);
    }

    public static void activateClonedOrders(List<Order> orders) {
        System.debug('TRIGGER');
        for (Order o : orders) {
            System.debug(o.Id);
            System.debug(o.IsClone());
            System.debug(o.IsPrePaid__c);
            System.debug(o.Status);
            if (o.isClone() && o.Status == MAS_Constant.ORDER_STATUS_ACTIVE && !o.Order_is_synced_with_Mascus__c
                    && !Test.isRunningTest()) {
                System.debug('CALL FUTURE METHOD');
                cloneCallout(o.Id, o.IsPrePaid__c);
            }
        }
    }

    public static void setOrderOwner(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();

        for (Order order : orders) {
            if (order.AccountId != null) accountIds.add(order.AccountId);
            if (order.OwnerId != null) ownerIds.add(order.OwnerId);
        }

        Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Account.OwnerId FROM Account WHERE Id = :accountIds]);
        Map<Id, User> ownersMap = new Map<Id, User>([SELECT Id, Is_Mascus_Webservice__c FROM User WHERE Id = :ownerIds]);

        for (Order order : orders) {
            if (ownersMap.containsKey(order.OwnerId)) {
                if (ownersMap.get(order.OwnerId).Is_Mascus_Webservice__c) {
                    if (accountsMap.containsKey(order.AccountId)) order.OwnerId = accountsMap.get(order.AccountId).OwnerId;
                }
            }
        }
    }

    public static void updateAddressFieldsAndInvoiceInfo(List<Order> orders, Map<Id, Order> oldOrders, Boolean isInsert) {

        Set<Id> accountIds = new Set<Id>();

        for (Order o: orders) {
            if (isInsert || o.AccountId != oldOrders.get(o.Id).AccountId) {
                accountIds.add(o.AccountId);
            }
            if (isInsert || o.Sold_to_Account__c != oldOrders.get(o.Id).Sold_to_Account__c) {
                accountIds.add(o.Sold_to_Account__c);
            }
        }

        if (accountIds.size() > 0) {
            Map<Id, Account> accountDetails = new Map<Id, Account>([SELECT Id, ShippingPostalCode, ShippingCity, ShippingCountry, ShippingState, 
                                                                    ShippingStreet, BillingCity, BillingCountry, BillingPostalCode, BillingState, 
                                                                    BillingStreet, Billing_Cycle_preference__c, Invoicing_preference__c, Invoicing_rule__c,
                                                                    Payment_method__c, Payment_term__c FROM Account WHERE Id IN: accountIds]);
            for (Order o: orders) {

                Account accountDetail = accountDetails.containsKey(o.AccountId) ? accountDetails.get(o.AccountId) : null;
                Account soldToAccountDetail = accountDetails.containsKey(o.Sold_to_Account__c) ? accountDetails.get(o.Sold_to_Account__c) : null;
                
                if ((isInsert || o.Sold_to_Account__c != oldOrders.get(o.Id).Sold_to_Account__c) && soldToAccountDetail != null ) {

                    // Update sold to information on Order to be same as Account (for new Orders or on SoldToAccount change)
                    // This code will replace the Process Builder - "Update Sold to address on order"
                    o.SoldtoPostalcode__c = soldToAccountDetail.ShippingPostalCode;
                    o.Soldtocity__c = soldToAccountDetail.ShippingCity;
                    o.Soldtocountry__c = soldToAccountDetail.ShippingCountry;
                    o.Soldtostate__c = soldToAccountDetail.ShippingState;
                    o.Soldtostreet__c = soldToAccountDetail.ShippingStreet;
                }

                if ((isInsert || o.AccountId != oldOrders.get(o.Id).AccountId) && accountDetail != null) {

                    // Update billing address on Order to be same as Account (for new Orders or on AccountId change)
                    // This code will replace the Process Builder - "Update fields at order from bill to account1"
                    o.BillingCity = accountDetail.BillingCity;
                    o.BillingCountry = accountDetail.BillingCountry;
                    o.BillingPostalCode = accountDetail.BillingPostalCode;
                    o.BillingState = accountDetail.BillingState;
                    o.BillingStreet = accountDetail.BillingStreet;
                    
                    // Update invoicing info on Order to be same as Account if available
                    o.Billing_Cycle_preference__c = (accountDetail.Billing_Cycle_preference__c == null ? o.Billing_Cycle_preference__c : accountDetail.Billing_Cycle_preference__c);
                    o.Invoicing_preference__c = (accountDetail.Invoicing_preference__c == null ? o.Invoicing_preference__c : accountDetail.Invoicing_preference__c);
                    o.Invoicing_rule__c = (accountDetail.Invoicing_rule__c == null ? o.Invoicing_rule__c : accountDetail.Invoicing_rule__c);
                    o.Payment_method__c = (accountDetail.Payment_method__c == null ? o.Payment_method__c : accountDetail.Payment_method__c);
                    o.Payment_term__c = (accountDetail.Payment_term__c == null ? o.Payment_term__c : accountDetail.Payment_term__c);
                }
            }
        }
    }

    public static void activateOrderItemsOnOrderActivation(Map<Id, Order> newOrders, Map<Id, Order> oldOrders) {
        // Mark the activated flag on OrderItem on Order Activation to trigger Task Creation and Email alert through Process Builder FLOW
        Set<Id> ordersActivated = new Set<Id>();

        for (Order o: newOrders.values()) {            
            if (o.Activated__c && !oldOrders.get(o.Id).Activated__c && o.Status == MAS_Constant.ORDER_STATUS_ACTIVE && oldOrders.get(o.Id).Status != MAS_Constant.ORDER_STATUS_ACTIVE) {
                ordersActivated.add(o.Id);
            }
        }
        
        if (ordersActivated.size() > 0) {
            List<OrderItem> orderItems = [SELECT Id, Order.Owner.Email, Order.Sold_to_contact__r.Email FROM OrderItem WHERE OrderId IN :ordersActivated];

            for (OrderItem oi: orderItems) {
                oi.Activated__c = true;
                oi.Email_Address_Sales_Rep_Owner__c = oi.Order.Owner.Email;
                oi.Email_Address_Sold_to_Contact__c = oi.Order.Sold_to_contact__r.Email;
            }

            if (!orderItems.isEmpty()) {
                update orderItems;
            }
        }
    }

    @future(callout = true)
    private static void cloneCallout(Id orderId, Boolean prepaid) {
        System.debug('FUTURE');
        System.debug(orderId);
        System.debug(prepaid);
        if (prepaid) {
            MAS_ResponseDTO res = MAS_OrderService.orderPrivateAdActivateFromMascus(orderId, true, false);
        } else {
            MAS_ResponseDTO res = MAS_OrderService.syncOrderWithMascusWeb(orderId, false);
        }
    }

}