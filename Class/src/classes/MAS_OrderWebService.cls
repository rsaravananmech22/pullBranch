/**************************************************************************
 * Description  : Apex Class for account sync from madcus to SF
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       23/09/2019      Initial implementation
 **************************************************************************/
global class MAS_OrderWebService {

    /**
     * @Description : This SOAP web service method is used for upsert order
     * @author : Samith Perera
     * @params request : Order request DTO
     * @return : Response DTO
     */
    webservice static MAS_ResponseDTO upsertOrder(MAS_OrderRequestDTO orderRequestDto){
        
        //Request validation
        MAS_ResponseDTO response = MAS_OrderService.validateOrderFromMascus(orderRequestDto);
        
        //Request Process & other validation rules fire during save
        if(response.responseCode.equals(MAS_Constant.ORDER_VALIDATION_SUCCESS_CODE)){
            response = MAS_OrderService.upsertOrderFromMascus(orderRequestDto);
        }else{

            MAS_ActionLog.createErrorLog('MAS_OrderWebService',
                        'upsertOrder',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        response.responseMessage,
                        null,
                        orderRequestDto.order_MascusGUID,
                        JSON.serialize(orderRequestDto),
                        JSON.serialize(response),
                        null
            );
        }

        //Response
        return response;
        
    }
    
    global class MAS_OrderRequestDTO{
        webservice String order_MascusOrderNumber { get; set; } 
        webservice String order_MascusGUID  { get; set; }
        webservice String order_BillToAccount { get; set; }
        webservice String order_BillToContact { get; set; }
        webservice String order_Name { get; set; }
        webservice String order_AuthorizedPayment { get; set; }
        webservice String order_Owner { get; set; }
        webservice String order_BillFromLegalEntity { get; set; }
        webservice String order_SoldToAccount { get; set; }
        webservice String order_MascusOrderNumbeForPayment { get; set; }
        webservice boolean order_AutoActivate { get; set; }
        webservice Date order_StartDate { get; set; }
        webservice Date order_BillingStartDate { get; set; }
        webservice boolean order_IsPaid { get; set; }
        webservice String order_Status { get; set; }
        webservice String order_Currency { get; set; }
        webservice list<OrderRequestItemsDTO> orderRequestItems { get; set; }
    }

    global class OrderRequestItemsDTO{
        webservice String orderItem_ProductCode { get; set; }
        webservice integer order_Item_Quantity { get; set; }
        webservice string orderItem_Currency { get; set; }
        webservice Date orderItem_StartDate { get; set; }
        webservice Date orderItem_EndDate { get; set; }
        webservice string orderItem_PriceUnitofMesaure { get; set; }
        webservice double orderItem_unitPrice { get; set; }
    }
}