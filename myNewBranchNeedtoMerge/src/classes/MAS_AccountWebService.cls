/**************************************************************************
 * Description  : Apex Class for account sync from madcus to SF
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       23/09/2019      Initial implementation
 **************************************************************************/
global class MAS_AccountWebService {


    /**
     * @Description : This SOAP web service method is used to upsert Account
     * @author : Dinesh
     * @params request : Account request DTO
     * @return : Response DTO
     */
	webservice static MAS_ResponseDTO upsertAccount(MAS_AccountRequestDTO accountRequestDto){
		
		//Request validation
		MAS_ResponseDTO response = MAS_AccountService.validateAccountFromMascus(accountRequestDto);
		system.debug(response);
		//Request Process
		if(response.responseCode.equals(MAS_Constant.ACCOUNT_VALIDATION_SUCCESS_CODE)){
			response = MAS_AccountService.upsertAccountFromMascus(accountRequestDto);
		}else{

			 MAS_ActionLog.createErrorLog('MAS_AccountWebService',
                        'upsertAccount',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        response.responseMessage,
                        null,
                        accountRequestDto.account_MascusCustomerId,
                        JSON.serialize(accountRequestDto),
                        JSON.serialize(response),
                        null
            );
		}

		//Response
		return response;
	}

	global class MAS_AccountRequestDTO{
		webservice String account_Name { get; set; }
		webservice String account_Source { get; set; }
		webservice String account_Industry { get; set; }
		webservice String account_BillingStreet { get; set; }
		webservice String account_BillingCity { get; set; }
		webservice String account_BillingStateOrProvince { get; set; }
		webservice String account_BillingZipOrPostalCode { get; set; }
		webservice String account_BillingCountry { get; set; }
		webservice String account_Classification { get; set; }
		webservice String account_MascusCustomerId { get; set; }
		webservice String account_VATNumber { get; set; }
		webservice String account_PrivateTaxNumber { get; set; }
		webservice String account_Status { get; set; }
		webservice String account_EmailForInvoicing { get; set; }
		webservice String account_PhoneNumber { get; set; } // requred
		webservice String account_LegalEntityCurrency { get; set; } 
		webservice String account_Owner { get; set; }
		webservice String account_MascusCustomerNumber  { get; set; } // optional  Mascus_Customer_Number__c
		webservice String account_PhonePrefix { get; set; } // requred Phone_Prefix__c
		webservice String account_ShippingStreet { get; set; } // optional ShippingStreet 
		webservice String account_ShippingCity { get; set; } // optional ShippingCity
		webservice String account_ShippingState { get; set; } // optional ShippingState 
		webservice String account_ShippingPostalCode { get; set; } // optional ShippingPostalCode 
		webservice String account_ShppingCountry { get; set; } // optional ShippingCountry
		webservice String account_Parent { get; set; } 

	}
}