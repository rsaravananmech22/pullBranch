/**************************************************************************
 * Description  : Apex Class for account sync from madcus to SF
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR              DATE            DETAIL
      1.0      Samith Perera       18/11/2017     Initial implementation
 **************************************************************************/
public class MAS_OrderService {

    /**
     * @Description : This method is used to validate the Account request from mascus
     * @author : Samith Perera
     * @params request : Request as a DTO (Account DTO)
     * @return : MAS_ResponseDTO (DTO)
     */
    public static MAS_ResponseDTO validateOrderFromMascus(MAS_OrderWebService.MAS_OrderRequestDTO req) {


        //Create new response object
        MAS_ResponseDTO response = new MAS_ResponseDTO();
        //Get the details of the fields of Account object
        Map <String, Schema.SObjectField > orderFields = order.getsObjectType().getDescribe().fields.getMap();
        Map <String, Schema.SObjectField > productFields = product2.getsObjectType().getDescribe().fields.getMap();
        Map <String, Schema.SObjectField > orderItemFields = OrderItem.getsObjectType().getDescribe().fields.getMap();

        //Variables to store field lengths for comparison
        Integer fieldLength = 0;
        Integer requestFieldLength = 0;

        /**
         * @Field : Mascus order ID
         * @Required : Yes
         * **/
        if (req.order_MascusGUID != null && !String.isEmpty(req.order_MascusGUID)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_MASCUS_GUID).getDescribe().getLength();
            requestFieldLength = req.order_MascusGUID.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_100, MAS_Constant.ORDER_ERROR_MSG_100);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_101, MAS_Constant.ORDER_ERROR_MSG_101);
        }//

        /**
         * @Field : Mascus order number***
         * @Required : Yes
         * **/
        if (req.order_MascusOrderNumber != null && !String.isEmpty(req.order_MascusOrderNumber)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_MASCUS_NUMBER).getDescribe().getLength();
            requestFieldLength = req.order_MascusOrderNumber.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_102, MAS_Constant.ORDER_ERROR_MSG_102);
            }
        }

        /**
         * @Field : Mascus_customer_number
         * @Required : Yes
         * **/
        if (req.order_BillToAccount != null && !String.isEmpty(req.order_BillToAccount)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_BILLTO_ACCOUNT).getDescribe().getLength();
            requestFieldLength = req.order_BillToAccount.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_104, MAS_Constant.ORDER_ERROR_MSG_104);
            }
        }

        /**
         * @Field : Mascus_contact_number
         * @Required : No
         * **/
        if (req.order_BillToContact != null && !String.isEmpty(req.order_BillToContact)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_BILLTO_CONTACT).getDescribe().getLength();
            requestFieldLength = req.order_BillToContact.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_106, MAS_Constant.ORDER_ERROR_MSG_106);
            }
        }

        /**
         * @Field : Authorized_payment__c
         * @Required : Yes
         * **/
        if (req.order_AuthorizedPayment != null && !String.isEmpty(req.order_AuthorizedPayment)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_AUTHIRIZED_PAYMENT).getDescribe().getLength();
            requestFieldLength = req.order_AuthorizedPayment.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_108, MAS_Constant.ORDER_ERROR_MSG_108);
            }
        }

        /**
         * @Field : Bill_from_legal_entity__c
         * @Required : Yes
         * **/
        if (req.order_BillFromLegalEntity != null && !String.isEmpty(req.order_BillFromLegalEntity)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_BILL_FROM_LEGAL_ENTITY).getDescribe().getLength();
            requestFieldLength = req.order_BillFromLegalEntity.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_110, MAS_Constant.ORDER_ERROR_MSG_110);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_111, MAS_Constant.ORDER_ERROR_MSG_111);
        }

        /**
         * @Field : Sold_to_Account__c
         * @Required : Yes
         * **/
        if (req.order_SoldToAccount != null && !String.isEmpty(req.order_SoldToAccount)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_SOLD_TO_ACCOUNT).getDescribe().getLength();
            requestFieldLength = req.order_SoldToAccount.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_112, MAS_Constant.ORDER_ERROR_MSG_112);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_113, MAS_Constant.ORDER_ERROR_MSG_113);
        }

        /**
         * @Field : Mascus order number for payment******
         * @Required : No
         * **/
        if (req.order_MascusOrderNumbeForPayment != null && !String.isEmpty(req.order_MascusOrderNumbeForPayment)) {
            fieldLength = orderFields.get(MAS_Constant.ORDER_MASCUS_NUMBER).getDescribe().getLength();
            requestFieldLength = req.order_MascusOrderNumbeForPayment.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_114, MAS_Constant.ORDER_ERROR_MSG_114);
            }
        }

        /**
         * @Field : EffectiveDate
         * @Required : yes
         * **/
        if (req.order_StartDate == null ) {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_116, MAS_Constant.ORDER_ERROR_MSG_116);
        }

        /**
         * @Field : Billing_start_date__c
         * @Required : yes
         * **/
        if (req.order_BillingStartDate == null ) {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ERROR_CODE_117, MAS_Constant.ORDER_ERROR_MSG_117);
        }

        //order item validation
        if (req.orderRequestItems != null) {

            for (MAS_OrderWebService.OrderRequestItemsDTO item : req.orderRequestItems) {

                //Product code
                if (item.orderItem_ProductCode != null) {
                    fieldLength = productFields.get(MAS_Constant.ORDER_ITEM_PRODUCT_CODE).getDescribe().getLength();
                    requestFieldLength = item.orderItem_ProductCode.length();
                    if (requestFieldLength > fieldLength) {
                        return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_100, MAS_Constant.ORDER_ITEM_ERROR_MSG_100);
                    }
                } else {
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_101, MAS_Constant.ORDER_ITEM_ERROR_MSG_101);
                }

                //order quantity
                if (item.order_Item_Quantity != null ) {
                    fieldLength = orderItemFields.get(MAS_Constant.ORDER_ITEM_QUANTITY).getDescribe().getLength();
                } else {
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_102, MAS_Constant.ORDER_ITEM_ERROR_MSG_102);
                }

                //order currancy
                if (item.orderItem_Currency != null ) {
                    fieldLength = orderItemFields.get(MAS_Constant.ORDER_ITEM_CURRENCY).getDescribe().getLength();
                    requestFieldLength = item.orderItem_Currency.length();
                    if (requestFieldLength > fieldLength) {
                        return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_103, MAS_Constant.ORDER_ITEM_ERROR_MSG_103);
                    }
                    req.order_Currency = item.orderItem_Currency;
                } else {
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_104, MAS_Constant.ORDER_ITEM_ERROR_MSG_104);
                }

                //order start date
                if (item.orderItem_StartDate == null ) {
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_105, MAS_Constant.ORDER_ITEM_ERROR_MSG_105);
                }

                //order end date
                if (item.orderItem_EndDate == null ) {
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_106, MAS_Constant.ORDER_ITEM_ERROR_MSG_106);
                }

                //order price unit of measure
                if (item.orderItem_PriceUnitofMesaure == null ) {
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_107, MAS_Constant.ORDER_ITEM_ERROR_MSG_107);
                }

                //order item unit price
                if (item.orderItem_unitPrice == null ) {
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_108, MAS_Constant.ORDER_ITEM_ERROR_MSG_108);
                }
            }

        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ORDER_ITEM_ERROR_CODE_109, MAS_Constant.ORDER_ITEM_ERROR_MSG_109);
        }

        response.responseCode = MAS_Constant.ORDER_VALIDATION_SUCCESS_CODE;
        response.responseMessage = MAS_Constant.ORDER_VALIDATION_SUCCESS_MSG;

        return response;
    }

    /**
     * @Description : This method is used to upsert Account request from mascus
     * @author : Samith Perera
     * @params request : Request response DTO
     * @return : Boolean
     */
    public static MAS_ResponseDTO upsertOrderFromMascus(MAS_OrderWebService.MAS_OrderRequestDTO req) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        Order orderObject = new Order ();
        boolean isInsert = true;

        if (req.order_MascusOrderNumber != null & req.order_MascusOrderNumber != '') {
            List <Order> orderList = [ SELECT Id, Status from Order WHERE Mascus_Order_Number__c = : req.order_MascusOrderNumber ];
            if (!orderList.isEmpty()) {
                orderObject.Id = orderList[0].Id;
                isInsert = false;
            }
        }

        Savepoint sp;

        try {

            // Get the payment method from exising dealer credit order
            if (req.order_MascusOrderNumbeForPayment != null && !req.Order_IsPaid) {
                List <Order> orderPaymentList = [SELECT Id, AccountId, BillToContactId, Payment_method__c, Payment_term__c, Sold_to_contact__c, Billing_Cycle_preference__c, Invoicing_preference__c, Invoicing_rule__c  from Order WHERE Mascus_Order_Number__c = : req.order_MascusOrderNumbeForPayment]; //req.Order_MascusOrderNumber
                if (!orderPaymentList.isEmpty()) {
                    orderObject.Payment_method__c = orderPaymentList[0].Payment_method__c;
                    orderObject.Payment_term__c = orderPaymentList[0].Payment_term__c;
                    orderObject.Sold_to_contact__c =  orderPaymentList[0].Sold_to_contact__c;
                    orderObject.Billing_Cycle_preference__c =  orderPaymentList[0].Billing_Cycle_preference__c;
                    orderObject.Invoicing_preference__c =  orderPaymentList[0].Invoicing_preference__c;
                    orderObject.Invoicing_rule__c =  orderPaymentList[0].Invoicing_rule__c;
                    orderObject.AccountId =  orderPaymentList[0].AccountId;
                    orderObject.BillToContactId =  orderPaymentList[0].BillToContactId;
                }
            }

            // Private Ads
            if (req.Order_IsPaid) {
                orderObject.IsPrePaid__c = true;
                orderObject.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(MAS_Constant.ORDER_RECORD_TYPE_DRAFT).getRecordTypeId();
                orderObject.AccountId = MAS_UtilityHelper.getAccountIdFromMascus(req.Order_BillToAccount);
                orderObject.BillToContactId = MAS_UtilityHelper.getContactIdFromMascus(req.Order_BillToContact);
            }

            orderObject.Mascus_order_ID__c = req.Order_MascusGUID;
            orderObject.Bill_from_legal_entity__c = MAS_UtilityHelper.getAccountIdFromMascus(req.Order_BillFromLegalEntity);
            orderObject.Authorized_payment__c = req.Order_AuthorizedPayment;
            orderObject.Sold_to_Account__c = MAS_UtilityHelper.getAccountIdFromMascus(req.Order_SoldToAccount);
            orderObject.EffectiveDate = req.Order_StartDate;
            orderObject.Billing_start_date__c = req.Order_BillingStartDate;
            orderObject.CurrencyIsoCode = req.order_Currency;
            orderObject.Pricebook2Id = MAS_UtilityHelper.getPriceBookId(req.order_Currency);//01s0E0000009Ljg';
            orderObject.Name = req.order_Name; //MAS_Constant.ORDER_NAME_CREATE + Date.today();
            orderObject.Status = MAS_Constant.ORDER_STATUS_DRAFT;
            orderObject.Activated__c = false;
            orderObject.Order_source__c = MAS_Constant.ORDER_SOURCE_MASCUS_WEB;

            system.debug('orderObject.Pricebook2Id-' + orderObject.Pricebook2Id);
            sp = Database.setSavepoint();

            //save order sa draft mode
            upsert orderObject;

            //order products
            set<string> productCodeSet = new set<string>();
            for (MAS_OrderWebService.OrderRequestItemsDTO odItem : req.orderRequestItems) {
                productCodeSet.add(odItem.orderItem_ProductCode);
            }


            map<string, Id> productIdMap = new map<string, Id>();
            for (Product2 prod : [SELECT Id, ProductCode  FROM Product2 WHERE ProductCode IN : productCodeSet]) {
                productIdMap.put(prod.ProductCode , prod.Id);
            }

            list<PricebookEntry> pricebookentryList = new list<PricebookEntry>();
            for (PricebookEntry pb : [SELECT Id, Pricebook2Id, Product2Id, CurrencyIsoCode
            FROM PricebookEntry
            WHERE Pricebook2Id  = : orderObject.Pricebook2Id
            AND Product2Id IN : productIdMap.values ()
            AND CurrencyIsoCode = : orderObject.CurrencyIsoCode ]) { //order.CurrencyIsoCode
                pricebookentryList.add(pb);
            }

            list<OrderItem> toInsertOrderItems = new list<OrderItem>();

            //Loop order items
            for (MAS_OrderWebService.OrderRequestItemsDTO item : req.orderRequestItems) {

                OrderItem oItem = new OrderItem();
                oItem.Quantity = item.order_Item_Quantity;
                oItem.ServiceDate = item.orderItem_StartDate;
                oItem.Price_unit_of_measure__c = item.orderItem_PriceUnitofMesaure;
                oItem.UnitPrice = item.orderItem_unitPrice;
                oItem.OrderId = orderObject.Id;
                Id productId =  productIdMap.get(item.orderItem_ProductCode);
                oItem.PricebookEntryId = getPriceBookEntryId(pricebookentryList, orderObject.Pricebook2Id, orderObject.CurrencyIsoCode, productId);
                toInsertOrderItems.add(oItem);
            }

            //Insert order items
            insert toInsertOrderItems;


            ////////START///// (not satisfied with the fix ,dont know who did this, need to change this ASAP)
            // Private AD, insert hardcoded data
            Order privateAdOrder = [SELECT Id, BillToContactId,
            (SELECT Id, PricebookEntry.Product2.ProductCode FROM OrderItems)
            FROM order
            WHERE id = : orderObject.Id];

            if (!privateAdOrder.OrderItems.isEmpty()) {
                if (privateAdOrder.OrderItems[0].PricebookEntry.Product2.ProductCode.startsWithIgnoreCase(MAS_Constant.PRIVATE_AD)) {
                    privateAdOrder.Payment_method__c  = MAS_Constant.PAYMENT_METHOD;
                    privateAdOrder.Payment_term__c = MAS_Constant.PAYMENT_TERM;
                    privateAdOrder.Billing_Cycle_preference__c = MAS_Constant.BILLING_CYCLE_PREFERENCE;
                    privateAdOrder.Invoicing_preference__c = MAS_Constant.INVOICING_PREFERENCE;
                    privateAdOrder.Invoicing_rule__c  = MAS_Constant.INVOICING_RULE;
                    privateAdOrder.Sold_to_contact__c = privateAdOrder.BillToContactId;
                }
            }
            upsert privateAdOrder;
            ////////END//////


            //Make order activate for dealer credits
            if (req.order_Status.Equals(MAS_Constant.ORDER_STATUS_ACTIVE)) {
                //Fetch the activated record type
                orderObject.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
                orderObject.Activated__c = true;
                orderObject.Order_is_synced_with_Mascus__c = true;
                upsert orderObject;
            }

            orderObject = [SELECT Id, Mascus_Order_Number__c FROM Order WHERE Id = : orderObject.Id LIMIT 1];

            response.responseCode = MAS_Constant.ORDER_DML_SUCCESS_CODE;
            response.responseMessage = MAS_Constant.ORDER_DML_SUCCESS_MSG;
            response.responseResult = new list<MAS_ResponseDTO.ResponseData>();
            response.responseResult.add(MAS_UtilityHelper.addResponseResult('Mascus_Order_Number__c', orderObject.Mascus_Order_Number__c));

        } catch (Exception ex) {
            Database.rollback(sp);
            response.responseCode = MAS_Constant.ORDER_ERROR_CODE_118;
            response.responseMessage = MAS_Constant.ORDER_ERROR_MSG_118 + ' : ' + ex.getMessage() + ' : Line No : ' + ex.getLineNumber();

            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'upsertOrderFromMascus',
                    isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                    MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                    MAS_Constant.ACTION_LOG_TRAGET_SF,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage().substring(0, MAS_UtilityHelper.getMaxLengthForActionLogMessage(ex.getMessage())),
                    null,
                    req.order_MascusGUID,
                    JSON.serialize(req),
                    JSON.serialize(response),
                    ex.getStackTraceString()
            );
        }

        //Add log
        if (response.responseCode.equals(MAS_Constant.ORDER_DML_SUCCESS_CODE)) {
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'upsertOrderFromMascus',
                    isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                    MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                    MAS_Constant.ACTION_LOG_TRAGET_SF,
                    MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                    MAS_Constant.CONTACT_DML_SUCCESS_MSG,
                    orderObject,
                    req.order_MascusGUID,
                    JSON.serialize(req),
                    JSON.serialize(response),
                    null
            );
        }

        return response;
    }

    /**
     * @Description : This method is used to upsert Account request from mascus
     * @author : Samith Perera
     * @params request : Request response DTO
     * @return : Boolean
     */
    public static Id getPriceBookEntryId (list<PricebookEntry> pricebookentryList, Id pricebook2Id, string currencyIsoCode, Id productId) {

        for (PricebookEntry pbe : pricebookentryList) {

            if (pbe.Pricebook2Id == pricebook2Id
                    && pbe.Product2Id  == productId
                    && pbe.CurrencyIsoCode == currencyIsoCode) {

                return pbe.Id;
            }
        }

        return null;
    }

    /**
     * @Description: This method consumes vat webservice
     * @author: Samith Perera
     * @params: orderId : order Id
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO vatCheck(Id orderId) {

        Order orderObject  =  [ SELECT Id, Name, Sold_to_Account__c, Bill_from_legal_entity__c,
                Bill_from_legal_entity__r.VAT_Number__c, Bill_from_legal_entity__r.BillingCountryCode,
                BillingCountryCode
        FROM Order
        WHERE Id = : orderId ];

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        Boolean status  =  false;
        list<Id> idList = new list<Id>();

        try {
            // Tax/Vat validation
            response = MAS_AccountService.vatcheckforAccount(orderObject.Sold_to_Account__c, orderObject);

        } catch (Exception ex) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ERROR_MESSAGE;
            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'vatCheck',
                    MAS_Constant.ACTION_LOG_TYPE_VATCHECK,
                    MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                    MAS_Constant.ACTION_LOG_TRAGET_BOOMI,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    orderObject,
                    null,
                    null,
                    JSON.serialize(response),
                    ex.getStackTraceString()
            );
        }

        return response;
    }

    /**
     * @Description: This method consumes mascus order webservice and create/modify orders in the mascus DB. Also do the private ad activation
     * @author: Samith Perera
     * @params: orderId : order Id
     *          isApprove : true/false
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO orderActivateFromSF(Id orderId, boolean isApprove) {

        Order orderObject  =  [ SELECT Id, Name, IsPrePaid__c, Account.Mascus_customer_ID__c, Mascus_order_ID__c,
                BillToContactId, AccountId, OwnerId, Sold_to_Account__c, Account.Payment_method__c,
                OrderNumber, Status, EffectiveDate, Mascus_Order_Number__c, Account.Mascus_Customer_Number__c,
                Account.Name, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity,
                Account.BillingCountry, Account.BillingAddress,
        (SELECT Id, PricebookEntry.Product2.ProductCode, Product2.Name, PricebookEntry.Product2.Bucket_quantity__c,
                ServiceDate, EndDate, Quantity, Price_unit_of_measure__c
        FROM OrderItems)
        FROM Order
        WHERE Id = : orderId ];

        MAS_ResponseDTO response = new MAS_ResponseDTO();

        try {
            //Rejected order
            if(!isApprove) {
                if(orderObject.IsPrePaid__c) {
                    String recordTypeForActivatedOrder = MAS_Constant.ORDER_RECORD_TYPE_ACTIVATED;
                    orderObject.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(recordTypeForActivatedOrder).getRecordTypeId();
                    orderObject.Status = MAS_Constant.ORDER_STATUS_REJECTED;
                    update orderObject;

                    response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                    response.responseMessage  = Label.LBL_SUCS_ORDER_REJECTED;
                }
                else {
                    response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                    response.responseMessage  = 'Only orders generated from Mascus Admin can be rejected';
                }
            } else {
                // Order activation
                orderObject.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
                orderObject.Activated__c = true;
                update orderObject;

                // CAN NOT CALL PRODUCT ACTIVATION TO MASCUSS FROM HERE, BECAUSE OF SF UNCOMMITED WORK PENDDING EXCEPTION
                // SPLIT IT INTO ANOTHER METHOD, NAMLY syncOrderWithMascusWeb()

                response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                response.responseMessage  = Label.LBL_SUCS_ODER_APPROVED;
                response.responseResult = new list<MAS_ResponseDTO.ResponseData>();
                //Private ads
                if(orderObject.IsPrePaid__c) {
                    response.responseResult.add(MAS_UtilityHelper.addResponseResult('IsPrePaid', 'true'));
                }
                else {
                    response.responseResult.add(MAS_UtilityHelper.addResponseResult('IsDealerCredits', 'true'));
                }
            }

        } catch (Exception ex) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ERROR_MESSAGE + ', ' + ex.getMessage();

            if (!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                //Add log
                MAS_ActionLog.createErrorLog('MAS_OrderService',
                        'orderActivateFromSF',
                        MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        ex.getMessage(),
                        orderObject,
                        null,
                        null,
                        null,
                        ex.getStackTraceString()
                );
            }
        }

        return response;
    }

    /**
      * @Description : This method is used to send order info for approval
      * @author : Malinda
      * @params : Order : orderObj, Boolean : isApprove
      * @return : List<String> lstMascusResponse
      */
    public static MAS_ResponseDTO orderPrivateAdActivateFromMascus(Id orderId, Boolean isApprove, Boolean sendEmail) {

        Order orderObj  =  [ SELECT Id, Status, Mascus_order_ID__c, OwnerId, Account.Send_order_confirmation__c, Account.Payment_method__c
        FROM Order
        WHERE Id = : orderId ];

        system.debug('####getAdApprovalFromMascus' + orderObj);

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        list<String> mascusResponseList;
        string actionType = null;
        string strXmlRequest = null;
        servicesMascusComApi2.ArrayOfString returnArrayString;

        try {
            string strSessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();

            //Create xml
            strXmlRequest = generateAdApprovalRequest(orderObj, isApprove);

            //Call out
            returnArrayString = new servicesMascusComApi2.ArrayOfString();
            returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(strSessionId, strXmlRequest, null);
            mascusResponseList = returnArrayString.string_x;

            if (mascusResponseList.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)) {

                actionType =  MAS_Constant.ACTION_LOG_STATUS_SUCCESS;
                response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                response.responseMessage = Label.LBL_SUCS_ODER_APPROVED;

                // Order Update
                orderObj.Order_is_synced_with_Mascus__c = true;
                orderObj.Description = mascusResponseList.get(1);

                // Email & Adyen URL
                /*if (sendEmail) {
                    composeEmailNotification(orderObj.Id, false);
                }*/
            } else {

                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                response.responseMessage =  mascusResponseList.get(1);
                actionType =  MAS_Constant.ACTION_LOG_STATUS_SUCCESS;

                // Order update to draft
                orderObj.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(MAS_Constant.ORDER_RECORD_TYPE_DRAFT).getRecordTypeId();
                orderObj.Status = MAS_Constant.ORDER_STATUS_DRAFT;
                orderObj.Activated__c = false;

                sendOrderErrorEmail(orderObj.Mascus_Order_Number__c, 'Mascus Admin');
            }

            update orderObj;

            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'getAdApprovalFromMascus',
                    MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    actionType,
                    response.responseMessage,
                    orderObj,
                    null,
                    strXmlRequest,
                    string.valueof(returnArrayString),
                    null
            );
        } catch (Exception ex) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ERROR_MESSAGE;
            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'getAdApprovalFromMascus',
                    MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    orderObj,
                    null,
                    strXmlRequest,
                    string.valueof(returnArrayString),
                    ex.getStackTraceString()
            );

            //Keep the order status as draft
            orderObj.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(MAS_Constant.ORDER_RECORD_TYPE_DRAFT).getRecordTypeId();
            orderObj.Status = MAS_Constant.ORDER_STATUS_DRAFT;
            orderObj.Activated__c = false;
            update orderObj;

            sendOrderErrorEmail(orderObj.Mascus_Order_Number__c, 'Mascus Admin');
        }

        return response;
    }

    /**
     * @Description: Generate the XML formatted Ad approval request data for outbound service call
     * @author: Malinda
     * @params: Order : order object
     * @return: XML formatted string
     */
    public static String generateAdApprovalRequest(Order order, Boolean isApprove) {

        //Create new XML DOM document
        DOM.Document xmlDocument = new DOM.Document();
        //Creates the XML root element
        dom.XmlNode actionNode = xmlDocument.createRootElement(MAS_Constant.ORDER_XML_AD_FIELD_ACTION, null, null);
        actionNode.addChildElement(MAS_Constant.ORDER_XML_AD_FIELD_ACTION_TYPE, null, null).addTextNode(isApprove ? MAS_Constant.ORDER_XML_AD_STATUS_APPROVE : MAS_Constant.ORDER_XML_AD_STATUS_REJECT);
        actionNode.addChildElement(MAS_Constant.ORDER_XML_AD_FIELD_MASCUS_ORDER_ID, null, null).addTextNode(order.Mascus_order_ID__c == null ? '-' : order.Mascus_order_ID__c);
        actionNode.addChildElement(MAS_Constant.ORDER_XML_AD_FIELD_MODIFIER_ID, null, null).addTextNode(order.OwnerId == null ? '-' : order.OwnerId);

        //Create XML string from the XML document
        String RequestXml =  xmlDocument.toXmlString();
        return RequestXml;

    }

    /**
     * @Description : This method is used to send order to mascus
     * @author : Samith Perera
     * @params : Order : orderObj
     * @return : List<String> lstMascusResponse
     */

    public static MAS_ResponseDTO syncOrderWithMascusWeb(Id orderId, Boolean sendEmail) {

        Order orderObj  =  [ SELECT Id, Name, IsPrePaid__c, Account.Mascus_customer_ID__c, Mascus_order_ID__c,
                BillToContactId, AccountId, OwnerId, Sold_to_Account__c, Account.Payment_method__c,
                OrderNumber, Status, EffectiveDate, Mascus_Order_Number__c, Account.Mascus_Customer_Number__c,
                Account.Name, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity,
                Account.BillingCountry, Account.BillingAddress, Sold_to_Account__r.Mascus_Customer_Number__c, LastModifiedById, LastModifiedBy.Mascus_User_Number__c, Add_to_sub_companies__c,
        (SELECT Id, PricebookEntry.Product2.ProductCode, Product2.Name, ServiceDate, EndDate, Quantity, Price_unit_of_measure__c, cancellation_date__c, PricebookEntry.Product2.Bucket_quantity__c,
                Product2.Bucket_quantity__c
        FROM OrderItems)
        FROM Order
        WHERE Id = : orderId ];

        MAS_ResponseDTO response = new MAS_ResponseDTO();

        //C248-345
        for (OrderItem oi : orderObj.OrderItems) {
            if (oi.Product2.Name == MAS_Constant.ORDER_PRODUCT_NAME_CB || oi.PricebookEntry.Product2.ProductCode == MAS_Constant.ORDER_PRODUCT_CODE_CB) {
                response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                response.responseMessage = Label.LBL_SUCS_ODER_APPROVED;
                return response;
            }
        }

        list<String> mascusResponseList;

        string actionType = null;
        servicesMascusComApi2.ArrayOfString returnArrayString = null;
        String strXmlRequest = null;

        try {
            String strSessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();

            //Create xml
            strXmlRequest = generateOrderRequest(orderObj);

            //Call out
            returnArrayString = new servicesMascusComApi2.ArrayOfString();
            returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(strSessionId, strXmlRequest, orderObj);
            mascusResponseList = returnArrayString.string_x;

            if (mascusResponseList.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)) {

                //Order update
                orderObj.Mascus_order_ID__c = mascusResponseList.get(2);
                orderObj.Order_is_synced_with_Mascus__c = true;
                orderObj.Description = mascusResponseList.get(1);

                response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                response.responseMessage = Label.LBL_SUCS_ODER_APPROVED;
                actionType =  MAS_Constant.ACTION_LOG_STATUS_SUCCESS;

                //ADYEN EMAIL ,FUTURE Method
                if (sendEmail) {
                    composeEmailNotification(orderObj.Id, false);
                }
            } else {

                // Order update to draft
                orderObj.Description = mascusResponseList.get(1);
                orderObj.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(MAS_Constant.ORDER_RECORD_TYPE_DRAFT).getRecordTypeId();
                orderObj.Status = MAS_Constant.ORDER_STATUS_DRAFT;
                orderObj.Activated__c = false;

                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                response.responseMessage =  mascusResponseList.get(1);
                actionType =  MAS_Constant.ACTION_LOG_STATUS_FAILED;

                sendOrderErrorEmail(orderObj.Mascus_Order_Number__c, 'Mascus Admin');
            }

            update orderObj;

            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'syncOrderWithMascusWeb',
                    MAS_Constant.ACTION_LOG_TYPE_INSERT,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    actionType,
                    response.responseMessage,
                    orderObj,
                    null,
                    strXmlRequest,
                    string.valueof(returnArrayString),
                    null
            );
        } catch (Exception ex) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ERROR_MESSAGE +  ' : '  + ex.getMessage();

            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'syncOrderWithMascusWeb',
                    MAS_Constant.ACTION_LOG_TYPE_INSERT,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    orderObj,
                    null,
                    strXmlRequest,
                    string.valueof(returnArrayString),
                    ex.getStackTraceString()
            );

            //Keep the order status as draft
            orderObj.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(MAS_Constant.ORDER_RECORD_TYPE_DRAFT).getRecordTypeId();
            orderObj.Status = MAS_Constant.ORDER_STATUS_DRAFT;
            orderObj.Activated__c = false;
            update orderObj;

            sendOrderErrorEmail(orderObj.Mascus_Order_Number__c, 'Mascus Admin');
        }

        return response;
    }

    public static MAS_ResponseDTO syncOrderRejectWithMascusWeb(Id orderId) {
        Order orderObject = [SELECT Mascus_Order_ID__c, OwnerId FROM Order WHERE Id = :orderId];

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
        response.responseMessage  = Label.LBL_SUCS_ORDER_REJECTED;

        list<String> mascusResponseList;
        string actionType = null;
        servicesMascusComApi2.ArrayOfString returnArrayString = null;
        String strXmlRequest = null;

        try {
            String strSessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();

            //Create xml
            strXmlRequest = generateAdApprovalRequest(orderObject, false);

            //Call out
            returnArrayString = new servicesMascusComApi2.ArrayOfString();
            returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(strSessionId, strXmlRequest, null);
            mascusResponseList = returnArrayString.string_x;

            if (mascusResponseList.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)) {
                orderObject.Order_is_synced_with_Mascus__c = true;
                orderObject.Description = mascusResponseList.get(1);
                response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                response.responseMessage = Label.LBL_SUCS_ORDER_REJECTED;
                actionType =  MAS_Constant.ACTION_LOG_STATUS_SUCCESS;
            }
            else {
                orderObject.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(MAS_Constant.ORDER_RECORD_TYPE_DRAFT).getRecordTypeId();
                orderObject.Description = mascusResponseList.get(1);
                orderObject.Status = MAS_Constant.ORDER_STATUS_DRAFT;
                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                response.responseMessage =  mascusResponseList.get(1);
                actionType =  MAS_Constant.ACTION_LOG_STATUS_FAILED;
            }

            update orderObject;

            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'syncOrderRejectWithMascusWeb',
                    MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    actionType,
                    response.responseMessage,
                    orderObject,
                    null,
                    strXmlRequest,
                    string.valueof(returnArrayString),
                    null
            );

        } catch(Exception ex) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ERROR_MESSAGE +  ' : '  + ex.getMessage();

            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'syncOrderRejectWithMascusWeb',
                    MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    orderObject,
                    null,
                    strXmlRequest,
                    string.valueof(returnArrayString),
                    ex.getStackTraceString()
            );
            orderObject.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(MAS_Constant.ORDER_RECORD_TYPE_DRAFT).getRecordTypeId();
            orderObject.Status = MAS_Constant.ORDER_STATUS_DRAFT;
            update orderObject;
        }

        return response;
    }

    /**
     * @Description: Generate the XML formatted Order request data for outbound service call
     * @author: Malinda
     * @params: Order : order object
     * @return: XML formatted string
     */
    public static String generateOrderRequest(Order order) {

        //Create new XML DOM document
        DOM.Document xmlDocument = new DOM.Document();
        //Creates the XML root element
        dom.XmlNode ordersNode = xmlDocument.createRootElement(MAS_Constant.ORDER_XML_FIELD_ORDERS, null, null);
        //Create XML child element
        dom.XmlNode orderNode = ordersNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_ORDER, null, null);
        //child nodes
        orderNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_ORDER_SF_ID, null, null).addTextNode(order.Mascus_Order_Number__c == null ? '-' : order.Mascus_Order_Number__c);
        orderNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_MASCUS_ORG_ID, null, null).addTextNode(order.Mascus_order_ID__c == null ? '-' : order.Mascus_order_ID__c); //order.Account.Mascus_customer_ID__c
        orderNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_ACCOUNT_SF_ID, null, null).addTextNode(order.Sold_to_Account__r.Mascus_Customer_Number__c == null ? '-' : order.Sold_to_Account__r.Mascus_Customer_Number__c);
        orderNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_ACTION, null, null).addTextNode(MAS_Constant.ORDER_XML_FIELD_UPDATE);
        orderNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_MODIFIER_SF_ID, null, null).addTextNode(order.LastModifiedBy.Mascus_User_Number__c == null ? '-' : order.LastModifiedBy.Mascus_User_Number__c);
        orderNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_ADD_TO_SUB_COMPANIES, null, null).addTextNode(order.Add_to_sub_companies__c == false ? 'false' : 'true');

        //If available, Adding order items
        if (order.OrderItems != null && !order.OrderItems.isEmpty()) {
            //child list
            dom.XmlNode productsNode = orderNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS, null, null);
            for (OrderItem oi : order.OrderItems) {

                dom.XmlNode productNode = productsNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCT, null, null);
                productNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS_PRODUCT_CODE, null, null).addTextNode(oi.PricebookEntry.Product2.ProductCode == null ? '' : oi.PricebookEntry.Product2.ProductCode);
                productNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS_PRODUCT_START_DATE, null, null).addTextNode(oi.ServiceDate == null ? '-' : String.valueOf(oi.ServiceDate));

                if (oi.cancellation_date__c == null) {
                    productNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS_PRODUCT_END_DATE, null, null).addTextNode(oi.EndDate == null ? '' : String.valueOf(oi.EndDate));
                } else {
                    productNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS_PRODUCT_END_DATE, null, null).addTextNode(String.valueOf(oi.cancellation_date__c));
                }

                if (oi.Price_unit_of_measure__c == MAS_Constant.PRICE_UNIT_OF_MEASURE_ONE_OFF) {
                    productNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS_PRODUCT_QUANTITY, null, null).addTextNode(oi.Quantity == null ? '0' : String.valueOf((Integer)oi.Quantity));
                } else {
                    Decimal quantity = oi.Product2.Bucket_quantity__c == null ? 1 : oi.Product2.Bucket_quantity__c;
                    quantity = quantity * oi.Quantity;
                    productNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS_PRODUCT_QUANTITY, null, null).addTextNode(String.valueOf((Integer)quantity));
                }

                productNode.addChildElement(MAS_Constant.ORDER_XML_FIELD_PRODUCTS_PRODUCT_UNIT_OF_MESURE, null, null).addTextNode(oi.Price_unit_of_measure__c == null ? '-' : oi.Price_unit_of_measure__c);
            }
        }
        //Create XML string from the XML document
        String RequestXml =  xmlDocument.toXmlString();
        return RequestXml;

    }

    /**
     * @Description : This method is used for order item cancelations
     * @author : Samith Perera
     * @params : Order : orderObj
     * @return : List<String> lstMascusResponse
     */
    @future(callout = true)
    public static void syncOrderItemCancelationWithMascus(List<Id> orderIds) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        list<ActionLog__c> logList = new list<ActionLog__c>();
        list<OrderItem> toUpdateList = new list<OrderItem>();
        list<String> mascusResponseList = null;

        boolean isSuccess = false;
        string strXmlRequest = null;
        servicesMascusComApi2.ArrayOfString returnArrayString = null;

        String strSessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();



        for (Order orderObj : [ SELECT Id, Name, IsPrePaid__c, Account.Mascus_customer_ID__c, Mascus_order_ID__c,
                BillToContactId, AccountId, OwnerId, Sold_to_Account__c, Account.Payment_method__c,
                OrderNumber, Status, EffectiveDate, Mascus_Order_Number__c, Account.Mascus_Customer_Number__c,
                Account.Name, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity,
                Account.BillingCountry, Account.BillingAddress, Sold_to_Account__r.Mascus_Customer_Number__c, LastModifiedById, LastModifiedBy.Mascus_User_Number__c, Add_to_sub_companies__c,
        (SELECT Id, PricebookEntry.Product2.ProductCode, Product2.Name, ServiceDate, EndDate, Quantity, Price_unit_of_measure__c, cancellation_date__c, Product2.Bucket_quantity__c, Order_Item_Cancellation_Sync_with_Mascus__c FROM OrderItems)
        FROM Order
        WHERE Id IN: orderIds ]) {
            try {
                //Create xml
                strXmlRequest = generateOrderRequest(orderObj);


                //Call out
                returnArrayString = new servicesMascusComApi2.ArrayOfString();
                returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(strSessionId, strXmlRequest, orderObj);
                mascusResponseList = returnArrayString.string_x;
                system.debug(mascusResponseList);
                system.debug(mascusResponseList.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
                if (mascusResponseList.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)) {
                    isSuccess = true;

                    //update cancelled product
                    for (OrderItem oi : orderObj.OrderItems) {
                        system.debug('Cancellation Date: ' + oi.cancellation_date__c);
                        system.debug('Cancellation Sync: ' + oi.Order_Item_Cancellation_Sync_with_Mascus__c);

                        if (oi.cancellation_date__c != null && !oi.Order_Item_Cancellation_Sync_with_Mascus__c) {
                            oi.Order_Item_Cancellation_Sync_with_Mascus__c = true;
                            toUpdateList.add(oi);
                        }
                    }
                }

                logList.add(MAS_ActionLog.createLog('MAS_OrderService',
                        'syncOrderItemCancelationWithMascus',
                        MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                        isSuccess ? MAS_Constant.ACTION_LOG_STATUS_SUCCESS : MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        null,
                        orderObj,
                        null,
                        strXmlRequest,
                        string.valueof(returnArrayString),
                        null ));
            } catch (Exception ex) {
                logList.add(MAS_ActionLog.createLog('MAS_OrderService',
                        'syncOrderItemCancelationWithMascus',
                        MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        ex.getMessage(),
                        orderObj,
                        null,
                        strXmlRequest,
                        string.valueof(returnArrayString),
                        ex.getStackTraceString() ));
            }
        }

        system.debug('toUpdateList: ' + toUpdateList);
        if (toUpdateList.size() > 0) {
            update toUpdateList;
        }
        database.insert (logList, false);
    }
    /**
     * @Description: Cancels the original order items with a specific reason
     * @author: Robin De Bondt
     * @params: List<Id> orderIds, String cancelReason
     * @return: void
     */
    public static void cancelOriginalOrderItems(List<Id> orderIds, String cancelReason) {

        //Query all creatable fields from the order items that are not one-off linked to the orders
        String soqlOrderItem = MAS_UtilityHelper.getCreatableFieldsSOQL('OrderItem', 'OrderId IN :orderIds AND cancellation_date__c = null');
        //Grab fields that are not creatable for some users but are required for the cloning logic
        if(!soqlOrderItem.contains('Last_billing_date__c')) {
            soqlOrderItem = soqlOrderItem.replace('FROM', ', Last_Billing_Date__c FROM');
        }
        if(!soqlOrderItem.contains('Next_billing_date__c')) {
            soqlOrderItem = soqlOrderItem.replace('FROM', ', Next_Billing_Date__c FROM');
        }
        if(!soqlOrderItem.contains('Order.IsPrePaid__c')) {
            soqlOrderItem = soqlOrderItem.replace('FROM', ', Order.IsPrePaid__c FROM');
        }
        List<OrderItem> orderItemsToCancel = (List<OrderItem>)Database.query(soqlOrderItem);

        Set<Id> orderIdsToBeCloned = new Set<Id>(); // a Set (unique Ids) which will contain all the Ids of the Orders that must be cloned
        List<OrderItem> orderItemsToBeUpdated = new List<OrderItem>(); // a List which will contain all the OrderItems to be updated

        //Loop through the order items
        for (OrderItem oi : orderItemsToCancel) {
            if (oi.Order.IsPrePaid__c) {
                continue;
            } else if(oi.Price_unit_of_measure__c == MAS_Constant.PRICE_UNIT_OF_MEASURE_ONE_OFF){
                if(oi.Last_billing_date__c != null){
                    continue;
                }
                else{
                    oi.cancellation_date__c = oi.ServiceDate;
                    oi.Renewal_date__c = oi.ServiceDate;
                }
            }else{//Monthly Product
                if(oi.Last_billing_date__c != null){
                    if(oi.Next_billing_date__c == null){ //Fully Invoiced
                        continue;
                    }else{ //Invoiced
                        oi.cancellation_date__c = oi.Last_billing_date__c;
                        oi.Renewal_date__c = oi.Next_billing_date__c;
                    }
                }else{//UnInvoiced
                    oi.cancellation_date__c = oi.ServiceDate;
                    oi.Renewal_date__c = oi.ServiceDate;
                }
            }

            if (cancelReason == 'account_info_change') {
                oi.Cancellation_reason__c = 'Account information change';
                oi.Renewal_Type__c = 'Within Term';
            } else if (cancelReason == 'product_info_change') {
                oi.Cancellation_reason__c = 'Product information change';
                oi.Renewal_Type__c = 'Extend Term';
            }

            orderItemsToBeUpdated.add(oi);
            orderIdsToBeCloned.add(oi.OrderId);
        }

        cloneOrdersAndOrderItems(orderIdsToBeCloned, orderItemsToBeUpdated);

        update orderItemsToBeUpdated;
    }

    private static void cloneOrdersAndOrderItems(Set<Id> orderIds, List<OrderItem> orderItemsToClone){
        Set<Id> originalOrderIds = null;

        //Query all creatable fields from the orders
        String soqlOrder = MAS_UtilityHelper.getCreatableFieldsSOQL('Order', 'Id IN :orderIds');

        //Remove auto number as it is considered a creatable field but should not be copied over on the clone
        String soqlOrderWithoutAutoNumber = soqlOrder.replace('Mascus_order_ID__c,', '');

        List<Order> ordersToClone = (List<Order>)Database.query(soqlOrderWithoutAutoNumber);

        Map<Id, List<OrderItem>> mapOriginalOrderIdToOrderItems = new Map<Id, List<OrderItem>>();
        for (OrderItem oi : orderItemsToClone) {
            if (oi.Cancellation_reason__c == 'Product information change' || oi.Cancellation_reason__c == 'Account information change' || oi.Cancellation_reason__c == 'Price increase') {
                if (!mapOriginalOrderIdToOrderItems.containsKey(oi.OrderId)) {
                    mapOriginalOrderIdToOrderItems.put(oi.OrderId, new List<OrderItem>());
                }
                mapOriginalOrderIdToOrderItems.get(oi.OrderId).add(oi);
            }
        }

        //Create a map of order id to its cloned record and insert the clones
        Map<Id, Order> mapOriginalOrderIdToClonedOrder = new Map<Id, Order>();

        for (Order o : ordersToClone) {
            if (mapOriginalOrderIdToOrderItems.containsKey(o.Id)) {
                Order clonedOrder = o.clone(false, true);
                //Status needs to be set to Draft when inserting new orders
                clonedOrder.Status = MAS_Constant.ORDER_STATUS_DRAFT;
                clonedOrder.Activated__c = false;
                clonedOrder.Mascus_order_ID__c = null;
                clonedOrder.Order_is_synced_with_Mascus__c = false;

                Date newStartDate;
                for (OrderItem oi : mapOriginalOrderIdToOrderItems.get(o.Id)) { //Calculate start date
                    if(oi.Next_Billing_Date__c != null && (newStartDate == null || oi.Next_Billing_Date__c < newStartDate)) {
                        newStartDate = oi.Next_Billing_Date__c;
                    }
                }
                if(newStartDate != null) {
                    clonedOrder.EffectiveDate = newStartDate;
                    clonedOrder.Billing_start_date__c = newStartDate;
                }

                mapOriginalOrderIdToClonedOrder.put(o.Id, clonedOrder);
            }
        }

        insert mapOriginalOrderIdToClonedOrder.values();

        if (orderItemsToClone.size() > 0) {

            //Clone every order item and update the order item with the cloned order id, then insert
            Map<Id, OrderItem> originalToClonedOrderItemMap = new Map<Id, OrderItem>();

            for (Id i : mapOriginalOrderIdToOrderItems.keySet()) {
                List<OrderItem> items = mapOriginalOrderIdToOrderItems.get(i);
                for (OrderItem oi : items) {
                    OrderItem clonedOrderItem = oi.clone(false, true);
                    clonedOrderItem.OrderId = mapOriginalOrderIdToClonedOrder.get(oi.OrderId).Id;

                    if(oi.Next_Billing_Date__c != null){
                        clonedOrderItem.ServiceDate = oi.Next_billing_date__c;
                    }

                    clonedOrderItem.Last_billing_date__c = null;
                    //If order item renewal type = extend term, we set the end date = ServiceDate + 2 years
                    //and flag the renewal checkbox

                    if (oi.Renewal_Type__c == 'Extend Term') {
                        clonedOrderItem.EndDate = clonedOrderItem.ServiceDate.addYears(2);
                        clonedOrderItem.Renewal__c = true;
                    } else {
                        clonedOrderItem.EndDate = oi.EndDate;
                    }
                    if (clonedOrderItem.Renewal_price__c != null) {
                        clonedOrderItem.UnitPrice = clonedOrderItem.Renewal_price__c;
                    }

                    clonedOrderItem.Renewal_Type__c = null;
                    clonedOrderItem.Renewal_price__c = null;
                    clonedOrderItem.Renewal_date__c = null;
                    clonedOrderItem.cancellation_date__c = null;
                    clonedOrderItem.Cancellation_reason__c = null;
                    clonedOrderItem.cancellation_reason_description__c = null;
                    clonedOrderItem.Isclonedorderproduct__c = true;
                    originalToClonedOrderItemMap.put(oi.Id, clonedOrderItem);
                }
            }

            insert originalToClonedOrderItemMap.values();   // insert the new orderItems
        }

        //For all inserted cloned orders, update their status to Activated, after requerying them to not overwrite processes
        List<Order> ordersToBeUpdated = new List<Order>();
        for (Order o : mapOriginalOrderIdToClonedOrder.values()) {
            o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
            o.Activated__c = true;
            ordersToBeUpdated.add(o);
        }

        update ordersToBeUpdated;

        completeTasksForCancelledOrders(new List<Id>(orderIds));
    }

    /**
     * @Description: Clones orders and their order items that have not yet been cancelled before
     * @author: Robin De Bondt
     * @params: List<Id> orderIds
     * @return: void
     */
    @InvocableMethod(label = 'Clone Orders and their Order Products')
    public static void cloneOrder(List<Id> orderIds) {

        try {
            Set<Id> originalOrderIds = null;

            //Query all creatable fields from the orders that have at least 1 non "one-off" product (since those should not be cloned)
            String soqlOrder = MAS_UtilityHelper.getCreatableFieldsSOQL('Order', 'Id IN :orderIds AND Number_of_non_one_off_Products__c > 0 AND IsPrePaid__c = FALSE');
            //Remove auto number as it is considered a creatable field but should not be copied over on the clone
            String soqlOrderWithoutAutoNumber = soqlOrder.replace('Mascus_order_ID__c,', '');
            List<Order> ordersToClone = (List<Order>)Database.query(soqlOrderWithoutAutoNumber);

            //Query all creatable fields from the order items that are not one-off linked to the orders
            String soqlOrderItem = MAS_UtilityHelper.getCreatableFieldsSOQL('OrderItem', 'OrderId IN :orderIds AND Price_unit_of_measure__c != \'One-off\' AND Isclonedorderproduct__c = false AND Order.IsPrePaid__c = FALSE');
            List<OrderItem> orderItemsToClone = (List<OrderItem>)Database.query(soqlOrderItem);
            System.debug(orderItemsToClone.size() + ' original order items will be cloned.');

            Map<Id, List<OrderItem>> originalOrderIdToOrderItemMap = new Map<Id, List<OrderItem>>();
            for (OrderItem oi : orderItemsToClone) {
                if (oi.Cancellation_reason__c == 'Product information change' || oi.Cancellation_reason__c == 'Account information change' || oi.Cancellation_reason__c == 'Price increase') {
                    if (!originalOrderIdToOrderItemMap.containsKey(oi.OrderId)) {
                        originalOrderIdToOrderItemMap.put(oi.OrderId, new List<OrderItem>());
                    }
                    originalOrderIdToOrderItemMap.get(oi.OrderId).add(oi);
                }
            }

            //Since we will want to set the cloned order start dates to the earliest renewal date of the original,
            //non "one-off" order items, we use a list of AggregateResult to get the minimum Renewal_date__c per OrderId
            List<AggregateResult> arList = [SELECT OrderId, MIN(Renewal_date__c) earliestRenewalDate
            FROM OrderItem
            WHERE OrderId IN :orderIds
            AND Price_unit_of_measure__c != 'One-off' AND Renewal_Date__c != null
            GROUP BY OrderId];

            //Create a map of order id to its cloned record and insert the clones
            Map<Id, Order> mapOriginalOrderIdToClonedOrder = new Map<Id, Order>();

            for (Order o : ordersToClone) {
                if (originalOrderIdToOrderItemMap.containsKey(o.Id)) {
                    Order clonedOrder = o.clone(false, true);
                    //Status needs to be set to Draft when inserting new orders
                    clonedOrder.Status = MAS_Constant.ORDER_STATUS_DRAFT;
                    clonedOrder.Activated__c = false;
                    clonedOrder.Mascus_order_ID__c = null;
                    clonedOrder.Order_is_synced_with_Mascus__c = false;
                    mapOriginalOrderIdToClonedOrder.put(o.Id, clonedOrder);

                }

            }
            //Use the AggregateResult list to get the earliest renewal date of the original order items
            //and set the EffectiveDate and Billing_start_date__c equal to that
            for (AggregateResult ar : arList) {
                Id orderId = (Id)ar.get('OrderId');
                if (originalOrderIdToOrderItemMap.containsKey(orderId)) {
                    Order clonedOrder = mapOriginalOrderIdToClonedOrder.get(orderId);
                    clonedOrder.EffectiveDate = (Date)ar.get('earliestRenewalDate');
                    clonedOrder.Billing_start_date__c = (Date)ar.get('earliestRenewalDate');
                }

            }

            insert mapOriginalOrderIdToClonedOrder.values();

            if (orderItemsToClone.size() > 0) {

                //Clone every order item and update the order item with the cloned order id, then insert
                Map<Id, OrderItem> originalToClonedOrderItemMap = new Map<Id, OrderItem>();

                for (Id i : originalOrderIdToOrderItemMap.keySet()) {
                    List<OrderItem> items = originalOrderIdToOrderItemMap.get(i);
                    for (OrderItem oi : items) {
                        OrderItem clonedOrderItem = oi.clone(false, true);
                        clonedOrderItem.OrderId = mapOriginalOrderIdToClonedOrder.get(oi.OrderId).Id;
                        //Set the ServiceDate equal to the renewal date of the original order item
                        clonedOrderItem.ServiceDate = oi.Renewal_date__c;
                        //If order item renewal type = extend term, we set the end date = ServiceDate + 2 years
                        //and flag the renewal checkbox

                        if (oi.Renewal_Type__c == 'Extend Term') {
                            clonedOrderItem.EndDate = clonedOrderItem.ServiceDate.addYears(2);
                            clonedOrderItem.Renewal__c = true;
                        } else {
                            clonedOrderItem.EndDate = oi.EndDate;
                        }
                        if (clonedOrderItem.Renewal_price__c != null) {
                            clonedOrderItem.UnitPrice = clonedOrderItem.Renewal_price__c;
                        }

                        clonedOrderItem.Renewal_Type__c = null;
                        clonedOrderItem.Renewal_price__c = null;
                        clonedOrderItem.Renewal_date__c = null;

                        if (oi.cancellation_date__c != null) { // if the order has been cancelled, change some fields of the cloned order
                            //Clear values from fields about cancellation and renewal from original order item
                            clonedOrderItem.cancellation_date__c = null;
                            clonedOrderItem.Cancellation_reason__c = null;
                            clonedOrderItem.cancellation_reason_description__c = null;
                        }
                        System.debug('Start date: ' + clonedOrderItem.ServiceDate);
                        System.debug('End date: ' + clonedOrderItem.EndDate);

                        originalToClonedOrderItemMap.put(oi.Id, clonedOrderItem);
                    }
                }
                insert originalToClonedOrderItemMap.values();   // insert the new orderItems

                //Query all creatable fields from the order commision splits linked to the order items
                /*originalOrderIds = originalToClonedOrderItemMap.keySet();
                String soqlOrderlineSplit = MAS_UtilityHelper.getCreatableFieldsSOQL('OrderlineSplit__c', 'OrderLine__c IN :originalOrderIds');
                List<OrderlineSplit__c> orderlineSplitToClone = (List<OrderlineSplit__c>)Database.query(soqlOrderlineSplit);

                if(orderlineSplitToClone.size() > 0){
                    List<OrderlineSplit__c> orderlineSplitToBeCreated = new List<OrderlineSplit__c>();
                    for(OrderlineSplit__c orderlineSplit : orderlineSplitToClone){
                        OrderlineSplit__c clonedOrderlineSplit = new OrderlineSplit__c();
                        clonedOrderlineSplit.OrderLine__c =  originalToClonedOrderItemMap.get(orderlineSplit.OrderLine__c).Id;
                        clonedOrderlineSplit.Amount__c = orderlineSplit.Amount__c;
                        clonedOrderlineSplit.User__c = orderlineSplit.User__c;
                        clonedOrderlineSplit.SplitNumber__c = orderlineSplit.SplitNumber__c;
                        orderlineSplitToBeCreated.add(clonedOrderlineSplit);
                    }
                    insert orderlineSplitToBeCreated;
                }*/
            }

            //For all order items from the original orders (excluding "one-off"), set their end date = cancellation date
            if (originalOrderIds != null) { // this is filled after order items are cloned
                List<OrderItem> originalOrderItemsToBeUpdated = new List<OrderItem>();
                for (OrderItem oi : [ SELECT cancellation_date__c, ServiceDate, Price_unit_of_measure__c
                FROM OrderItem
                WHERE Id IN :originalOrderIds]) {
                    if (oi.Price_unit_of_measure__c != 'One-off') {
                        if (oi.cancellation_date__c != null) {
                            oi.EndDate = oi.cancellation_date__c;
                        } else {
                            // set their endDate to the beginDate (=serviceDate)
                            oi.EndDate = oi.ServiceDate;
                        }
                        oi.Isclonedorderproduct__c = true;
                        originalOrderItemsToBeUpdated.add(oi);

                    }
                }
                update originalOrderItemsToBeUpdated;
            }

            //For all inserted cloned orders, update their status to Activated, after requerying them to not overwrite processes
            List<Order> ordersToBeUpdated = new List<Order>();
            for (Order o : [SELECT Status, Activated__c FROM Order WHERE Id IN :mapOriginalOrderIdToClonedOrder.values()]) {
                o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
                o.Activated__c = true;
                ordersToBeUpdated.add(o);
            }

            update ordersToBeUpdated;

            completeTasksForCancelledOrders(orderIds);

        } catch (Exception e) {
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'cloneOrder',
                    'INSERT',
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    'Customer',
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    'cloneOrder Failed',
                    null,
                    null,
                    null,
                    null,
                    e.getMessage());
        }

    }

    public static Order getOrderInformation(Id orderId) {
        return [SELECT Id, Name, IsPrePaid__c, Account.Mascus_customer_ID__c, Mascus_order_ID__c, Account.Mascus_Customer_Number__c, Bundle_pricing__c,
                BillToContactId, AccountId, OwnerId, Sold_to_Account__c, Account.Payment_method__c, Account.Email_for_invoicing__c, Account.BillingCountryCode,
                Account.Send_order_confirmation__c, OrderNumber, Status, EffectiveDate, Mascus_Order_Number__c, TotalAmount,
                Account.Name, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingCountry, Account.BillingAddress,
                Sold_to_Account__r.Name, Sold_to_Account__r.BillingStreet, Sold_to_Account__r.BillingPostalCode, Sold_to_Account__r.BillingCountryCode, Sold_to_Account__r.Classification__c,
                Sold_to_Account__r.BillingCity, Sold_to_Account__r.BillingCountry, Sold_to_Account__r.BillingAddress, Bill_from_legal_entity__r.Merchant_Account_Code__c,
                Bill_from_legal_entity__r.Name, Bill_from_legal_entity__r.BillingStreet, Bill_from_legal_entity__r.BillingPostalCode, Bill_from_legal_entity__r.Skin_Code__c, Bill_from_legal_entity__r.HMAC_Key__c,
                Bill_from_legal_entity__r.BillingCity, Bill_from_legal_entity__r.BillingCountry, Bill_from_legal_entity__r.Language_Code__c, Bill_from_legal_entity__r.BillingAddress, Bill_from_legal_entity__r.VAT_Validation__c,
                CurrencyIsoCode, Bill_from_legal_entity__r.BillingCountryCode, Bill_from_legal_entity__r.Send_order_confirmation__c, Owner.Name, Sold_to_contact__r.FirstName, Sold_to_contact__r.LastName,
        (SELECT Id, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Name, ServiceDate, EndDate, Quantity, Price_unit_of_measure__c, UnitPrice, TotalPrice, CurrencyIsoCode FROM OrderItems)
        FROM Order
        WHERE Id = : orderId];
    }

    /**
     * @Description: Compose Email notification
     * @author: Samith Perera
     * @params: order
     * @return: void
     */
    @future(callout = true)
    public static void composeEmailNotification(Id orderId, Boolean sendEmail) {

        Order orderObject = getOrderInformation(orderId);

        ActionLog__c log = new ActionLog__c ();
        String mailHtmlBody = null;

        try {

            if (orderObject.TotalAmount == 0) {
                return;
            }

            if (orderObject.Status != MAS_Constant.ORDER_STATUS_ACTIVE) {
                return;
            }

            if (sendEmail || orderObject.Bill_from_legal_entity__r.Send_order_confirmation__c) {
                EmailTemplate template = getOrderConfirmationEmailTemplate(orderObject);
                mailHtmlBody = generateEmail(orderObject, orderObject.OrderItems, template, true);

                string bccAddress = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ORDER_TO_EMAIL_ADDRESSES);
                list<string> bccAddresses  = new list<string>();
                if (bccAddress != null) {
                    bccAddresses.addAll(bccAddress.split(','));
                }

                list<string> toAddresses  = new list<string>();
                toAddresses.add(orderObject.Account.Email_for_invoicing__c);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                if(MAS_UtilityHelper.checkProductionId()) { //Customer email should only be added in the Production environment
                    email.setToAddresses(toAddresses);
                }
                // for testing of emails sent to invoicing email, add tester to custom setting Configuration Detail/OrderEmailToAddresses
                email.setBccAddresses(bccAddresses);
                email.setSubject(template.Subject);
                email.setHtmlBody(mailHtmlBody);
                email.setSaveAsActivity(false);

                // Sends the email
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                System.debug('######MailSent');

                MAS_ActionLog.createErrorLog('MAS_OrderService',
                        'composeEmailNotification',
                        'EMAIL',
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        'Customer',
                        MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                        'Email Sent',
                        orderObject,
                        null,
                        mailHtmlBody,
                        null,
                        null);

            }
        } catch (Exception ex) {
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'composeEmailNotification',
                    'EMAIL',
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    'Customer',
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    orderObject,
                    null,
                    mailHtmlBody,
                    null,
                    ex.getStackTraceString());
        }
    }

    /**
    * @Description: Compose Email notification
    * @author: Samith Perera
    * @params: order
    * @return: void
    * @Comments: this is test code / Need to be replaced
    */
    public static string composeAdyenUrl(Order orderObject) {
        //DBL 22-12-2017 Changed amount from 0 to 1
        //27-03-2017 amount is based on the order currency
        string amount = fetchPaymentAmountBasedOnOrderCurrency(orderObject.CurrencyIsoCode);
        string shipBeforeDate = datetime.now().adddays(30).format('yyyy-MM-dd');
        string sessionValidity = datetime.now().adddays(30).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'').replace(':', '\\:');
        string sessionValidityPairs = datetime.now().adddays(30).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        string SKINCODE = orderObject.Bill_from_legal_entity__r.Skin_Code__c;
        string HMAC_KEY =  orderObject.Bill_from_legal_entity__r.HMAC_Key__c;
        string shoperLocal =  MAS_UtilityHelper.getLocalByCountryCode(orderObject.Sold_to_Account__r.BillingCountryCode);

        string SECRET_MESSAGE = 'countryCode:currencyCode:merchantAccount:merchantReference:paymentAmount:recurringContract:sessionValidity:shipBeforeDate:shopperEmail:shopperLocale:shopperReference:skinCode:' + orderObject.Account.BillingCountryCode + ':' + orderObject.CurrencyIsoCode + ':' + orderObject.Bill_from_legal_entity__r.Merchant_Account_Code__c + ':' + orderObject.Mascus_Order_Number__c + ':' + amount + ':ONECLICK,RECURRING:' + sessionValidity + ':' + shipBeforeDate + ':' + orderObject.Account.Email_for_invoicing__c + ':' + shoperLocal + ':' + orderObject.Account.Mascus_Customer_Number__c + ':' + SKINCODE;

        map<string, string> pairs = new map<string, string>();

        //Fields from ADYEN
        pairs.put('countryCode', orderObject.Account.BillingCountryCode);
        pairs.put('currencyCode', orderObject.CurrencyIsoCode);
        pairs.put('merchantAccount', orderObject.Bill_from_legal_entity__r.Merchant_Account_Code__c);
        pairs.put('merchantReference', orderObject.Mascus_Order_Number__c);
        pairs.put('paymentAmount', amount);
        pairs.put('recurringContract', 'ONECLICK,RECURRING');
        pairs.put('sessionValidity', sessionValidityPairs);
        pairs.put('shipBeforeDate', shipBeforeDate);
        pairs.put('shopperEmail',  orderObject.Account.Email_for_invoicing__c);
        pairs.put('shopperLocale', shoperLocal);
        pairs.put('shopperReference', orderObject.Account.Mascus_Customer_Number__c);
        pairs.put('skinCode', SKINCODE);

        Blob mac = Crypto.generateMac(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ADYEN_KEY), Blob.valueOf(SECRET_MESSAGE), EncodingUtil.convertFromHex(HMAC_KEY));
        string signature = EncodingUtil.base64Encode(mac);

        pairs.put('merchantSig', signature);


        string queryString = null;

        for (string key : pairs.keyset()) {
            System.debug('########key-' + pairs.get(key));
            if (queryString != null) {
                queryString += key;
            } else {
                queryString = key;
            }

            queryString += '=';
            queryString += EncodingUtil.urlEncode(pairs.get(key), 'UTF-8');
            queryString += '&';
        }

        System.debug('########queryString-' + queryString);
        string paymentUrl = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ADYEN_PAYMENT_URL) + queryString;
        return paymentUrl;
    }

    /**
     * @Description: This method consumes mascus order webservice and create/modidy orders in the mascus DB.
     * @author: Samith Perera
     * @params: orderId : order Id
     *          isApprove : true/false
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO accountandContactValidation(Id orderId) {

        Order orderObject  =  [ SELECT Id, Name, IsPrePaid__c, Account.Mascus_customer_ID__c, Mascus_order_ID__c,
                BillToContactId, AccountId, OwnerId, Sold_to_Account__c, Account.Payment_method__c
        FROM Order
        WHERE Id = : orderId ];

        MAS_ResponseDTO response = null;
        Boolean status  =  false;
        list<Id> idList = new list<Id>();

        try {

            // Related account validation
            idList.add(orderObject.Sold_to_Account__c);
            idList.add(orderObject.AccountId);
            response = MAS_AccountService.validateAccountForOrder(idList);
            if (response.responseType == MAS_Constant.RESPONSE_TYPE_ERROR) {
                return response;
            }

            // Related contact validation
            idList.clear();
            idList.add(orderObject.BillToContactId);
            response = MAS_ContactService.validateContactForOrder(idList);
            if (response.responseType == MAS_Constant.RESPONSE_TYPE_ERROR) {
                return response;
            }

        } catch (Exception ex) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ERROR_MESSAGE + ' : ' + ex.getMessage() + ' : Line No : ' + ex.getLineNumber();
        }

        return response;
    }

    /**
     * @Description: This method validates the Billing start date when activating the order
     * @author: Artash Manoucharjan
     * @params: orderId : order Id
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO billingStartDateCheck(Id orderId) {
        // we retrieve only one orderproduct, with the lowest order product start date
        // if Order billing start date is greater than order product start date, return true
        // both of the fields must be filled in
        MAS_ResponseDTO response = new MAS_ResponseDTO();

        for (OrderItem od : [SELECT id, ServiceDate, order.Billing_start_date__c
        FROM OrderItem
        WHERE OrderId = :orderId
        order by ServiceDate]) {
            if (od.order.Billing_start_date__c != null  && od.ServiceDate != null) {
                if (od.order.Billing_start_date__c >= od.ServiceDate) {
                    // Billing start date NOT higher then minumum of the order product date, the order can't be approved
                    response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                    return response;
                }
            }
        }
        response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
        response.responseMessage = MAS_Constant.ORDER_ERROR_MSG_131;
        return response;
    }

    /**
     * @Description: This method validates if all products of the Order have Orderline Splits
     * @author: Artash Manoucharjan
     * @params: orderId : order Id
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO OrderlineSplitCheck(Id orderId) {
        // Retrieve the order items with Orderline splits
        // if one of the product doesn't have a orderline split the order can't be approved
        MAS_ResponseDTO response = new MAS_ResponseDTO();

        List<OrderItem> orderProducts = [Select id , OrderId, Order.Order_source__c, (SELECT Id FROM Orderline_Splits__r)
        FROM OrderItem
        WHERE OrderId = :orderId
        ];
        // orders from the webservice do not need orderlinessplites
        if (!orderProducts.isEmpty() && MAS_Constant.ORDER_SOURCE_MASCUS_WEB.equals(orderProducts[0].Order.Order_source__c)) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
            return response;
        }


        // check if all products have Orderline splits
        if (!orderProducts.isEmpty()) {
            for (OrderItem orderproduct : orderProducts) {
                // one of the products doens't have a Orderline Split, then Order can't be validated
                if (orderproduct.Orderline_Splits__r.isEmpty()) {
                    response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                    response.responseMessage = MAS_Constant.ORDER_ERROR_MSG_132;
                    return response;
                }
            }
        } else { // Order doesn't have any products
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ORDER_ERROR_MSG_132;
            return response;
        }

        // All products have Orderline splits
        response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
        return response;
    }


    /**
     * @Description: This method validates Contact's MailingAddress
     * @author: Artash Manoucharjan
     * @params: orderId : order Id
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO contactMailingValidation(Id orderId) {


        Order orderObject  =  [SELECT Id, BillToContactId, ShipToContactId, Sold_to_contact__c
        FROM Order
        WHERE Id = : orderId ];

        MAS_ResponseDTO response = null;
        Map<Id, String> idMap = new Map<Id, String>(); // id with corresponding type of contact: BILL,SHIP OR SOLD

        // contact validation
        idMap.clear();
        idMap.put(orderObject.BillToContactId, MAS_Constant.CONTACT_Bill_TO_CONTACT);
        idMap.put(orderObject.ShipToContactId, MAS_Constant.CONTACT_SHIP_TO_CONTACT);
        idMap.put(orderObject.Sold_to_contact__c, MAS_Constant.CONTACT_SOLD_TO_CONTACT);

        response = MAS_ContactService.validateMailingAddressForOrder(idMap);

        return response;
    }

    /**
     * @Description: This method creates a platform event
     * @author:Samith Perera
     * @params: orderId : order Id
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO orderUpsertPlatformEvent(Id orderId) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();

        List<ActionLog__c> logList = [ SELECT ActionType__c, Message__c, Replayed__c, Response_Data__c
        FROM ActionLog__c
        WHERE OrderId__c = : orderId
        AND Source__c = 'Salesforce'
        AND Target__c = 'Oracle'
        AND Status__c = 'Failed'
        AND ActionType__c IN ('INSERT', 'UPDATE', 'DELETE')
        AND Replayed__c = false ];

        Boolean hasInsertLog = false;
        Boolean hasUpdateLog = false;
        Boolean hasTerminateLog = false;

        if (logList.isEmpty()) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
            response.responseMessage = 'All changes have already been sent';
            return response;
        }
        else {
            for(ActionLog__c log : logList) {
                log.Replayed__c = true;
                if(log.ActionType__c.equals(MAS_Constant.ACTION_LOG_TYPE_INSERT)) {
                    if(!(log.Response_Data__c != null && log.Response_Data__c.contains('already exists'))) { //ignore error for order already existing
                        hasInsertLog = true;
                    }
                }
                else if(log.ActionType__c.equals(MAS_Constant.ACTION_LOG_TYPE_DELETE)) { //Message to distinguish events for termination
                    if(!(log.Response_Data__c != null && log.Response_Data__c.contains('already marked for termination'))) { //Ignore error regarding already terminated items
                        hasTerminateLog = true;
                    }
                }
                else {
                    hasUpdateLog = true;
                }
            }
        }

        Order orderObject  =  [ SELECT Id, Name,
                Account.BillingCity,
                Account.BillingCountryCode,
                Account.BillingCountry,
                Account.BillingPostalCode,
                Account.BillingStateCode,
                Account.BillingState,
                Account.BillingStreet,
                Account.Classification__c,
                Account.DUNS_number__c,
                Account.Vat_Number__c,
                Account.Email_for_invoicing__c,
                Account.Local_Tax_Number__c,
                Account.Mascus_Customer_Number__c,
                Account.Name,
                Account.Phone_prefix__c,
                Account.Phone,
                Account.Phonetic_Account_Name__c,
                Account.Private_Tax_Number__c,
                Account.Type_of_Business__c,
                Account.Website,
                BillToContact.Email,
                BillToContact.FirstName,
                BillToContact.LastName,
                BillToContact.MailingCountryCode,
                BillToContact.Mascus_Contact_Number__c,
                BillToContact.Phone_Prefix__c,
                BillToContact.Phone,
                BillToContact.Phonetic_Contact_First_Name__c,
                BillToContact.Phonetic_Contact_Last_Name__c,
                BillToContact.Salutation,
                BillToContact.MailingCity,
                BillToContact.MailingCountry,
                BillToContact.MailingPostalCode,
                BillToContact.MailingState,
                BillToContact.MailingStreet,
                Authorized_payment__c,
                BillToContact.Id,
                Bill_from_legal_entity__r.Name,
                Billing_Cycle_preference__c,
                Billing_start_date__c,
                Bundle_pricing__c,
                Invoice_header_information__c,
                Invoicing_preference__c,
                Invoicing_rule__c,
                Mascus_Order_Number__c,
                OrderNumber,
                Owner.FirstName,
                Owner.LastName,
                Payment_method__c,
                Payment_method_reference__c,
                Payment_term__c,
                OrderReferenceNumber,
                Sold_to_Account__r.Id,
                Sold_to_contact__r.Id,
                EffectiveDate,
                Status
        FROM Order
        WHERE Id = : orderId ];

        try {
            if (hasInsertLog) {
                Order_Platform_Event__e pEventInsert = new Order_Platform_Event__e();
                pEventInsert.Account_BillingCity__c = orderObject.Account.BillingCity;
                pEventInsert.Account_BillingCountryCode__c = orderObject.Account.BillingCountryCode;
                pEventInsert.Account_BillingCountry__c = orderObject.Account.BillingCountry;
                pEventInsert.Account_BillingPostalCode__c = orderObject.Account.BillingPostalCode;
                pEventInsert.Account_BillingStateCode__c = orderObject.Account.BillingStateCode;
                pEventInsert.Account_BillingState__c =  orderObject.Account.BillingState;
                pEventInsert.Account_BillingStreet__c =  orderObject.Account.BillingStreet;
                pEventInsert.Account_Classification__c = orderObject.Account.Classification__c;
                pEventInsert.Account_DUNS_number__c = orderObject.Account.DUNS_number__c;
                pEventInsert.Account_EU_VAT_Number__c = orderObject.Account.Vat_Number__c;
                pEventInsert.Account_Email_for_invoicing__c = orderObject.Account.Email_for_invoicing__c;
                pEventInsert.Account_Local_TAX_Number__c =  orderObject.Account.Local_Tax_Number__c;
                pEventInsert.Account_Mascus_Customer_Number__c = orderObject.Account.Mascus_Customer_Number__c;
                pEventInsert.Account_Name__c = orderObject.Account.Name;
                pEventInsert.Account_Phone_Prefix__c = orderObject.Account.Phone_prefix__c;
                pEventInsert.Account_Phone__c = orderObject.Account.Phone;
                pEventInsert.Account_Phonetic_Name__c = orderObject.Account.Phonetic_Account_Name__c;
                pEventInsert.Account_Private_Tax_Number__c = orderObject.Account.Private_Tax_Number__c;
                pEventInsert.Account_Type_of_Business__c = orderObject.Account.Type_of_Business__c;
                pEventInsert.Account_Website__c = orderObject.Account.Website;
                pEventInsert.Action__c = 'Create';
                pEventInsert.Contact_Email__c = orderObject.BillToContact.Email;
                pEventInsert.Contact_First_Name__c = orderObject.BillToContact.FirstName;
                pEventInsert.Contact_Last_Name__c = orderObject.BillToContact.LastName;
                pEventInsert.Contact_Mailing_CountryCode__c = orderObject.BillToContact.MailingCountryCode;
                pEventInsert.Contact_Mascus_Contact_Number__c = orderObject.BillToContact.Mascus_Contact_Number__c;
                pEventInsert.Contact_Phone_Prefix__c = orderObject.BillToContact.Phone_Prefix__c;
                pEventInsert.Contact_Phone__c = orderObject.BillToContact.Phone;
                pEventInsert.Contact_Phonetic_First_Name__c = orderObject.BillToContact.Phonetic_Contact_First_Name__c;
                pEventInsert.Contact_Phonetic_Last_Name__c = orderObject.BillToContact.Phonetic_Contact_Last_Name__c;
                pEventInsert.Contact_Salutation__c = orderObject.BillToContact.Salutation;
                pEventInsert.Mailing_City__c =  orderObject.BillToContact.MailingCity;
                pEventInsert.Mailing_Country__c = orderObject.BillToContact.MailingCountry;
                pEventInsert.Mailing_Postal_Code__c = orderObject.BillToContact.MailingPostalCode;
                pEventInsert.Mailing_State__c = orderObject.BillToContact.MailingState;
                pEventInsert.Mailing_Street__c = orderObject.BillToContact.MailingStreet;
                pEventInsert.Order_Authorized_payment__c = orderObject.Authorized_payment__c;
                pEventInsert.Order_Bill_To_Contact__c = orderObject.BillToContact.Id;
                pEventInsert.Order_Bill_from_legal_entity__c = orderObject.Bill_from_legal_entity__r.Name;
                pEventInsert.Order_Billing_Cycle_Preference__c = orderObject.Billing_Cycle_preference__c;
                pEventInsert.Order_Billing_start_date__c =  orderObject.Billing_start_date__c;
                pEventInsert.Order_Bundle_pricing__c = orderObject.Bundle_pricing__c;
                pEventInsert.Order_ID__c = orderObject.Id;
                pEventInsert.Order_Invoice_header_information__c = orderObject.Invoice_header_information__c;
                pEventInsert.Order_Invoicing_preference__c = orderObject.Invoicing_preference__c;
                pEventInsert.Order_Invoicing_rule__c = orderObject.Invoicing_rule__c;
                pEventInsert.Order_Mascus_Order_Number__c = orderObject.Mascus_Order_Number__c;
                pEventInsert.Order_Name__c = orderObject.Name;
                pEventInsert.Order_Number__c =  orderObject.OrderNumber;
                pEventInsert.Order_Owner_FirstName__c = orderObject.Owner.FirstName;
                pEventInsert.Order_Owner_LastName__c = orderObject.Owner.LastName;
                pEventInsert.Order_Payment_method__c =  orderObject.Payment_method__c;
                pEventInsert.Order_Payment_method_reference__c =  orderObject.Payment_method_reference__c;
                pEventInsert.Order_Payment_term__c = orderObject.Payment_term__c;
                pEventInsert.Order_Reference_Number__c =  orderObject.OrderReferenceNumber;
                pEventInsert.Order_Sold_to_Account__c = orderObject.Sold_to_Account__r.Id;
                pEventInsert.Order_Sold_to_contact__c = orderObject.Sold_to_contact__r.Id;
                pEventInsert.Order_Start_Date__c = orderObject.EffectiveDate;
                pEventInsert.Order_Status__c = orderObject.Status;

                Database.SaveResult srInsert = EventBus.publish(pEventInsert);
                if (!srInsert.isSuccess()) {
                    for (Database.Error err : srInsert.getErrors()) {
                        System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                    }
                    response.responseMessage = 'There was an error sending the insert request. Please try again later';
                    response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                    return response;
                }
            }

            if (hasUpdateLog) {
                Order_Platform_Event__e pEventUpdate = new Order_Platform_Event__e();
                pEventUpdate.Action__c = 'Update';
                pEventUpdate.Order_ID__c = orderObject.Id;
                pEventUpdate.Order_Mascus_Order_Number__c = orderObject.Mascus_Order_Number__c;
                pEventUpdate.Order_Payment_method__c =  orderObject.Payment_method__c;
                pEventUpdate.Order_Payment_method_reference__c =  orderObject.Payment_method_reference__c;

                Database.SaveResult srUpdate = EventBus.publish(pEventUpdate);
                if (!srUpdate.isSuccess()) {
                    for (Database.Error err : srUpdate.getErrors()) {
                        System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                    }
                    response.responseMessage = 'There was an error sending the update request. Please try again later';
                    response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                    return response;
                }
            }

            if(hasTerminateLog) {
                List<OrderItem> terminatedProducts = [SELECT Cancellation_Date__c, Cancellation_Reason__c, Product_Line__c
                FROM OrderItem
                WHERE OrderId = :orderId
                AND Cancellation_Date__c != null];

                for(OrderItem product : terminatedProducts) { //Replay all order items that have been terminated
                    Order_Platform_Event__e pEventTerminate = new Order_Platform_Event__e();
                    pEventTerminate.Action__c = 'Terminate';
                    pEventTerminate.Order_ID__c = orderObject.Id;
                    pEventTerminate.Order_Mascus_Order_Number__c = orderObject.Mascus_Order_Number__c;
                    pEventTerminate.Order_Number__c = orderObject.Mascus_Order_Number__c;
                    pEventTerminate.Order_Product_Cancellation_Date__c = product.Cancellation_Date__c;
                    pEventTerminate.Order_Product_Cancellation_Reason__c = product.Cancellation_Reason__c;
                    pEventTerminate.Order_Product_Line__c = product.Product_Line__c;

                    Database.SaveResult srTerminate = EventBus.publish(pEventTerminate);
                    if (!srTerminate.isSuccess()) {
                        for (Database.Error err : srTerminate.getErrors()) {
                            System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                        }
                        response.responseMessage = 'There was an error sending the terminate request. Please try again later';
                        response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                        return response;
                    }
                }
            }

            update logList;

        } catch (Exception ex) {
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            response.responseMessage = MAS_Constant.ERROR_MESSAGE;
            //Add log
            MAS_ActionLog.createErrorLog('MAS_OrderService',
                    'createPlatformEvent',
                    MAS_Constant.ACTION_LOG_TYPE_VATCHECK,
                    MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                    MAS_Constant.ACTION_LOG_TRAGET_BOOMI,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    orderObject,
                    null,
                    null,
                    JSON.serialize(response),
                    ex.getStackTraceString()
            );
        }

        response.responseMessage = 'The changes have been sent';
        response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
        return response;
    }

    /**
     * @Description: This method creates a platform event
     * @author:Kavinda Inusha
     * @params: orderId : order Id
     * @return: MAS_ResponseDTO
     */
    public static boolean getOrderStatusByOrderProId (Id orderItemId) {

        OrderItem od = [ SELECT Id, OrderId, Order.Status FROM OrderItem WHERE Id = : orderItemId];
        if (od.Order.Status == MAS_Constant.ORDER_STATUS_ACTIVE)
            return true;
        else
                return false;

    }

    /**
    * @Description: This method updates the commission splitting Sales Rep when the Order owner changes
    * @author: Matthias Stroobants
    * @params: orderIds : Set of Order Ids
    * @return: none
    */
    public static void updateCommissionSplittingSalesRep(Map<Id, Order> orderMap) {
        List<OrderlineSplit__c> splittings = [SELECT OrderLine__r.OrderId, User__c FROM OrderlineSplit__c WHERE OrderLine__r.OrderId IN :orderMap.keySet()];
        if (splittings != null && splittings.size() > 0) {
            for (OrderlineSplit__c splitting : splittings) {
                splitting.User__c = orderMap.get(splitting.OrderLine__r.OrderId).OwnerId;
            }
            update splittings;
        }

    }

    /**
    * @Description: This method creates a commission splitting when a new order item is created
    * @author: Matthias Stroobants
    * @params: orderIds : Set of Order Item Ids
    * @return: none
    */
    public static void createCommissionSplitting(Set<Id> orderItemIds) {
        List<OrderlineSplit__c> splittingsToAdd = new List<OrderlineSplit__c>();
        for (OrderItem oi : [SELECT Id, UnitPrice, Order.CurrencyIsoCode, Order.OwnerId
        FROM OrderItem
        WHERE Id IN :orderItemIds]) {
            OrderlineSplit__c newOrderlineSplit = new OrderlineSplit__c();
            newOrderlineSplit.OrderLine__c =  oi.Id;
            newOrderlineSplit.Amount__c = oi.UnitPrice;
            newOrderlineSplit.User__c = oi.Order.OwnerId;
            newOrderlineSplit.SplitNumber__c = 1;
            newOrderlineSplit.CurrencyIsoCode = oi.Order.CurrencyIsoCode;
            splittingsToAdd.add(newOrderlineSplit);
        }
        insert splittingsToAdd;

    }

    public static Map<String, Map<String, String>> getTranslationMap(String objectName) {
        Map<String, Map<String, String>> translationMap = new Map<String, Map<String, String>>();
        List<Translation__c> translations = [SELECT Name, Language_Code__c, Translation__c FROM Translation__c WHERE Object__c = :objectName];
        for (Translation__c translation : translations) {
            Map<String, String> languageCodeMap = translationMap.get(translation.Name);
            if (languageCodeMap == null) {
                languageCodeMap = new Map<String, String>();
            }
            languageCodeMap.put(translation.Language_Code__c, translation.Translation__c);
            translationMap.put(translation.Name, languageCodeMap);
        }
        return translationMap;
    }

    public static String getTranslation(String name, String languageCode, Map<String, Map<String, String>> translationMap) {
        if (translationMap.get(name) != null && translationMap.get(name).get(languageCode) != null) {
            return translationMap.get(name).get(languageCode);
        } else {
            return name;
        }
    }

    public static void sendOrderErrorEmail(String orderNumber, String integretionPoint) {
        string bccAddress = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ACTIONLOG_TO_EMAIL_ADDRESSES);
        list<string> bccAddresses  = new list<string>();
        if (bccAddress != null) {
            bccAddresses.addAll(bccAddress.split(','));
        }

        list<string> toAddresses  = new list<string>();
        toAddresses.add('mascus_int_support@ritchiebros.com');

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        if(MAS_UtilityHelper.checkProductionId()) { //Mascus Support email should only be added in the Production environment
            email.setToAddresses(toAddresses);
        }
        email.setBccAddresses(bccAddresses);
        email.setSubject('Failed to integrate order to ' + integretionPoint);
        email.setPlainTextBody(integretionPoint + ' integration failed for order ' + orderNumber);
        email.setSaveAsActivity(false);

        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        System.debug('######MailSent');
    }

    public static EmailTemplate getOrderConfirmationEmailTemplate(Order orderObject) {
        system.debug(orderObject);
        string languageCode = (orderObject.Bill_from_legal_entity__r.Language_Code__c != '') ? orderObject.Bill_from_legal_entity__r.Language_Code__c : 'EN';
        string tempName = 'OrderConfirmation_' + languageCode;
        EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body FROM EmailTemplate WHERE name =: tempName];
        return template;
    }

    public static String generateEmail(Order orderObject, List<OrderItem> orderItems, EmailTemplate template, Boolean includeAdyenLink) {

        boolean isEuCountry = false;
        string effectiveDate = null;
        string mailHtmlBody = template.HtmlValue;
        string languageCode = template.Name.right(2);
        Map<String, Map<String, String>> productTranslationMap = getTranslationMap('Product');
        Map<String, Map<String, String>> countryTranslationMap = getTranslationMap('Country');

        // DBL 22-12-2017 End
        isEuCountry = MAS_UtilityHelper.isEUCountryByCurrency(orderObject.CurrencyIsoCode);
        if (isEuCountry) {
            effectiveDate = string.valueof(orderObject.EffectiveDate.format());
        } else {
            effectiveDate = string.valueof(orderObject.EffectiveDate);
        }
        mailHtmlBody = mailHtmlBody.replace('[CUSTOMER_NAME]', orderObject.Sold_to_contact__r.FirstName + ' ' + orderObject.Sold_to_contact__r.LastName)
                .replace('[SALES_PERSON_NAME]', orderObject.Owner.Name)
                .replace('[ORDER_NUMBER]', orderObject.Mascus_Order_Number__c)
                .replace('[ORDER_ACTIVATED_DATE]', effectiveDate)

                .replace('[BILL_TO_ACCOUNT_NAME]', orderObject.Account.Name)
                .replace('[SOLD_TO_ACCOUNT_NAME]', orderObject.Sold_to_Account__r.Name)
                .replace('[BILL_FROM_LEGAL_ENTITY_NAME]', orderObject.Bill_from_legal_entity__r.Name)

                .replace('[BILL_TO_ACCOUNT_BILLING_STREET]', orderObject.Account.BillingStreet)
                .replace('[SOLD_ACCOUNT_BILLING_STREET]', orderObject.Sold_to_Account__r.BillingStreet)
                .replace('[BILL_FROM_LEGAL_ENTITY_BILLING_STREET]', orderObject.Bill_from_legal_entity__r.BillingStreet)

                .replace('[BILL_TO_ACCOUNT_BILLING_POSTAl_CODE]', orderObject.Account.BillingPostalCode)
                .replace('[BILL_TO_ACCOUNT_BILLING_CITY]', orderObject.Account.BillingCity)

                .replace('[SOLD_TO_ACCOUNT_BILLING_POSTAl_CODE]', orderObject.Sold_to_Account__r.BillingPostalCode)
                .replace('[SOLD_TO_ACCOUNT_BILLING_CITY]', orderObject.Sold_to_Account__r.BillingCity)

                .replace('[BILL_FROM_LEGAL_ENTITY_POSTAL_CODE]', orderObject.Bill_from_legal_entity__r.BillingPostalCode)
                .replace('[BILL_FROM_LEGAL_ENTITY_CITY]', orderObject.Bill_from_legal_entity__r.BillingCity)

                .replace('[BILL_TO_ACCOUNT_COUNTRY]', getTranslation(orderObject.Account.BillingCountry, languageCode, countryTranslationMap))
                .replace('[SOLD_TO_ACCOUNT_COUNTRY]', getTranslation(orderObject.Sold_to_Account__r.BillingCountry, languageCode, countryTranslationMap))
                .replace('[BILL_FROM_LEGAL_ENTITY_ACCOUNT_COUNTRY]', getTranslation(orderObject.Bill_from_legal_entity__r.BillingCountry, languageCode, countryTranslationMap));

        decimal totalMonthlySubscription = 0;
        decimal totalSetUp = 0;
        string orderItemComplteHtml = null;
        string strTotalMonthlySubscription = null;
        string strTotalSetUp = null;
        string strNetPrice = null;
        string orderitemHtml = null;
        Integer monthlyCount = 0;
        Integer oneOffCount = 0;

        for (OrderItem item: orderItems) {
            system.debug('SBD ' + item.Id);
            orderitemHtml = '<tr>';
            orderitemHtml += '<td><span><span>[PRODUCT_DESCRIPTION]</span></span></td>';
            orderitemHtml += '<td style="text-align: right;"><span><span>[UNIT_PRICE]</span></span></td>';
            orderitemHtml += '<td></td>';
            orderitemHtml += '<td><span><span>[PRICE_UNIT_OF_MEASURE]</span></span></td>';
            orderitemHtml += '<td><span><span>[START_DATE]</span></span></td>';
            orderitemHtml += '<td style="text-align: right;"><span><span>[PRICE]</span></span></td>';
            orderitemHtml += '</tr>';

            string startDate = null;
            decimal unitPrice = item.UnitPrice;
            string formatUnitPrice = null;
            decimal totPrice = item.UnitPrice * item.Quantity;
            string formatTotPrice = null;

            if (isEuCountry) {
                startDate = string.valueof(item.ServiceDate.format());
            } else {
                startDate = string.valueof(item.ServiceDate);
            }

            formatUnitPrice = MAS_UtilityHelper.getCurrencyFormat(unitPrice, isEuCountry);
            formatTotPrice = MAS_UtilityHelper.getCurrencyFormat(totPrice, isEuCountry);

            if (MAS_Constant.PRICE_UNIT_OF_MEASURE_MONTHLY.equals(item.Price_unit_of_measure__c)) {
                totalMonthlySubscription += item.TotalPrice;
            } else if (MAS_Constant.PRICE_UNIT_OF_MEASURE_ONE_OFF.equals(item.Price_unit_of_measure__c)) {
                totalSetUp += item.TotalPrice;
            }

            if (orderObject.Bundle_pricing__c) {

                if (MAS_Constant.PRICE_UNIT_OF_MEASURE_MONTHLY.equals(item.Price_unit_of_measure__c) && monthlyCount == 0) {

                    if (orderItemComplteHtml != null) {
                        orderItemComplteHtml += orderitemHtml.replace('[PRODUCT_DESCRIPTION]', getTranslation(item.PricebookEntry.Product2.Name, languageCode, productTranslationMap))
                                .replace('[UNIT_PRICE]', '')
                                .replace('[PRICE_UNIT_OF_MEASURE]', getTranslation(item.Price_unit_of_measure__c, languageCode, productTranslationMap))
                                .replace('[START_DATE]', '')
                                .replace('[PRICE]', '[MONTHLY]' + ' ' + item.CurrencyIsoCode);
                    } else {
                        orderItemComplteHtml = orderitemHtml.replace('[PRODUCT_DESCRIPTION]', getTranslation(item.PricebookEntry.Product2.Name, languageCode, productTranslationMap))
                                .replace('[UNIT_PRICE]', '')
                                .replace('[PRICE_UNIT_OF_MEASURE]', getTranslation(item.Price_unit_of_measure__c, languageCode, productTranslationMap))
                                .replace('[START_DATE]', '')
                                .replace('[PRICE]', '[MONTHLY]' + ' ' + item.CurrencyIsoCode);
                    }

                    monthlyCount += 1;
                } else if (MAS_Constant.PRICE_UNIT_OF_MEASURE_ONE_OFF.equals(item.Price_unit_of_measure__c) && oneOffCount == 0) {

                    if (orderItemComplteHtml != null) {
                        orderItemComplteHtml += orderitemHtml.replace('[PRODUCT_DESCRIPTION]', getTranslation(item.PricebookEntry.Product2.Name, languageCode, productTranslationMap))
                                .replace('[UNIT_PRICE]', formatUnitPrice + ' ' + item.CurrencyIsoCode)
                                .replace('[PRICE_UNIT_OF_MEASURE]', getTranslation(item.Price_unit_of_measure__c, languageCode, productTranslationMap))
                                .replace('[START_DATE]', '')
                                .replace('[PRICE]', '[ONE_OFF]' + ' ' + item.CurrencyIsoCode);
                    } else {
                        orderItemComplteHtml = orderitemHtml.replace('[PRODUCT_DESCRIPTION]', getTranslation(item.PricebookEntry.Product2.Name, languageCode, productTranslationMap))
                                .replace('[UNIT_PRICE]', formatUnitPrice + ' ' + item.CurrencyIsoCode)
                                .replace('[PRICE_UNIT_OF_MEASURE]', getTranslation(item.Price_unit_of_measure__c, languageCode, productTranslationMap))
                                .replace('[START_DATE]', '')
                                .replace('[PRICE]', '[ONE_OFF]' + ' ' + item.CurrencyIsoCode);
                    }

                    oneOffCount += 1;
                }
            } else {
                if (orderItemComplteHtml != null) {
                    orderItemComplteHtml += orderitemHtml.replace('[PRODUCT_DESCRIPTION]', getTranslation(item.PricebookEntry.Product2.Name, languageCode, productTranslationMap))
                            .replace('[UNIT_PRICE]', formatUnitPrice + ' ' + item.CurrencyIsoCode)
                            .replace('[PRICE_UNIT_OF_MEASURE]', getTranslation(item.Price_unit_of_measure__c, languageCode, productTranslationMap))
                            .replace('[START_DATE]', startDate)
                            .replace('[PRICE]', formatTotPrice + ' ' + item.CurrencyIsoCode);
                } else {
                    orderItemComplteHtml = orderitemHtml.replace('[PRODUCT_DESCRIPTION]', getTranslation(item.PricebookEntry.Product2.Name, languageCode, productTranslationMap))
                            .replace('[UNIT_PRICE]', formatUnitPrice + ' ' + item.CurrencyIsoCode)
                            .replace('[PRICE_UNIT_OF_MEASURE]', getTranslation(item.Price_unit_of_measure__c, languageCode, productTranslationMap))
                            .replace('[START_DATE]', startDate)
                            .replace('[PRICE]', formatTotPrice + ' ' + item.CurrencyIsoCode);
                }
            }
        }

        strTotalMonthlySubscription = MAS_UtilityHelper.getCurrencyFormat(totalMonthlySubscription, isEuCountry);
        strTotalSetUp = MAS_UtilityHelper.getCurrencyFormat(totalSetUp, isEuCountry);
        strNetPrice = MAS_UtilityHelper.getCurrencyFormat(totalMonthlySubscription + totalSetUp, isEuCountry);

        if (orderObject.Bundle_pricing__c) {
            if (monthlyCount > 0)
                orderItemComplteHtml = orderItemComplteHtml.replace('[MONTHLY]', strTotalMonthlySubscription);

            if (oneOffCount > 0)
                orderItemComplteHtml = orderItemComplteHtml.replace('[ONE_OFF]', strTotalSetUp);
        }
        // DBL 22-12-2017 Addition of [TOP_PARAGRAPH] and link translation:
        // Changed from Hardcode "Submit your payment details" to String setUpPaymentLink assigned on line 1124
        mailHtmlBody = mailHtmlBody.replace('[ORDER_ITEMS]', orderItemComplteHtml)
                .replace('[TOTAL_MONTHLY_SUBSCRIPTION]', strTotalMonthlySubscription + ' ' + orderObject.CurrencyIsoCode)
                .replace('[TOTAL_SETUP]', strTotalSetUp + ' ' + orderObject.CurrencyIsoCode)
                .replace('[NET_PRICE]', strNetPrice + ' ' + orderObject.CurrencyIsoCode);

        if(includeAdyenLink) {
            mailHtmlBody = mailHtmlBody.replace('[PAY_NOW_LINK]', composeAdyenUrl(orderObject));
        }
        else {
            mailHtmlBody = mailHtmlBody.replace('[PAY_NOW_LINK]', 'javascript:'); //Block link from redirecting user
        }

        return mailHtmlBody;
    }

    /**
     * @Description: This method queries minimum payment amount for Adyen Payment
     * @author:Neha Mishra
     * @params: orderCurrency : order.CurrencyISOCode
     * @return: String
     */
    public static String fetchPaymentAmountBasedOnOrderCurrency(String orderCurrency) {
        try {
            String whereClause = 'Currency_Code__c = '+'\''+orderCurrency+'\'';
            Currency_With_minimum_payment_Amount__mdt c = Database.query(MAS_UtilityHelper.getFieldswithWhereClauseSOQL('Currency_With_minimum_payment_Amount__mdt',whereClause));
            return c.Payment_Amount__c;
        }catch(Exception exptn) {
            System.debug('==#Custom Metadata '+ exptn.getMessage());
            throw new customException('Minimum amount for the order currency is not configured. Please contact your administrator');
        }
    }

    //This method is used to complete the tasks related to cancelled Orders
    public static void completeTasksForCancelledOrders(List<Id> orderIds) {

        List<Task> taskList = [SELECT Id FROM Task WHERE WhatId IN :orderIds];

        if (!taskList.isEmpty()) {

            for (Task t: taskList) {
                t.Status = 'Completed';
            }
            update taskList;
        }
    }
    /**
     * @Description: This method is used to stop user from giving a discount more than 25% if the overwrite checkbox is not checked
     * @author:Neha Mishra
     * @params: orderItemList : orderItem
     * @params: isInsert : OrderItem Trigger.isInsert
     * @return: void
     */
    public static void validateDiscountPercentageForOrderItems(List<OrderItem> orderItemList, Boolean isInsert){
        Set<OrderItem> itemsWithValidationError = new Set<OrderItem>();
        if(!MAS_UtilityHelper.isLoggedInWebServiceUser()) {
            if(isInsert) {
                itemsWithValidationError = checkForDiscountValidation(orderItemList);
            }
            else {
                for(OrderItem item : orderItemList) {
                    if (!item.IsOrderStatusActivated__c && item.UnitPrice < (0.75 * item.ListPrice) && !item.IsClonedorderproduct__c && !item.Overwrite_price__c) {
                        itemsWithValidationError.add(item);
                    }
                }
            }
        }

        if(!itemsWithValidationError.isEmpty()) {
            for (OrderItem item : itemsWithValidationError) {
                item.UnitPrice.addError('Warning: Discount percentage is greater than 25%');
            }
        }
    }

    @TestVisible
    private static Set<OrderItem> checkForDiscountValidation(List<OrderItem> orderItemList) {
        Map<Id, List<OrderItem>> pbeIdToOrderItemsMap = new Map<Id, List<OrderItem>>();
        Set<Id> pricebookEntryIdSet = new Set<Id>();
        for(OrderItem item : orderItemList) {
            pricebookEntryIdSet.add(item.PricebookEntryId);
            if(!pbeIdToOrderItemsMap.containsKey(item.PricebookEntryId)) {
                pbeIdToOrderItemsMap.put(item.PricebookEntryId, new List<OrderItem>{item});
            }
            else {
                pbeIdToOrderItemsMap.get(item.PricebookEntryId).add(item);
            }
        }
        return fetchDiscountErrorItemsBasedOnPricebookEntry(pbeIdToOrderItemsMap);
    }

    @TestVisible
    private static Set<OrderItem> fetchDiscountErrorItemsBasedOnPricebookEntry(Map<Id, List<OrderItem>> pbeIdToOrderItemsMap) {
        Set<OrderItem> itemsWithValidationError = new Set<OrderItem>();
        for(PricebookEntry pbe : [SELECT Id, UnitPrice FROM PricebookEntry WHERE Id IN: pbeIdToOrderItemsMap.keySet()]) {
            for(OrderItem item: pbeIdToOrderItemsMap.get(pbe.Id)){
                if(!item.IsOrderStatusActivated__c && item.UnitPrice < (0.75*pbe.UnitPrice)&& !item.IsClonedorderproduct__c && !item.Overwrite_price__c) {
                    itemsWithValidationError.add(item);
                }
            }
        }

        return itemsWithValidationError;
    }
    public class customException extends Exception {}
}