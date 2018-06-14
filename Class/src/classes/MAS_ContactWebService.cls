/**************************************************************************
 * Description  : Data transfer object for the third party request
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR        DATE            DETAIL
      1.0      Malinda       30/10/2017      Initial implementation
 **************************************************************************/
global class MAS_ContactWebService {

    webservice static MAS_ResponseDTO upsertContact(MAS_ContactRequestDTO contactRequestDto) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();

        //Request validation
        response = MAS_ContactService.validateContactFromMascus(contactRequestDto);

        //Request Process
        if(response.responseCode == MAS_Constant.CONTACT_VALIDATION_SUCCESS_CODE) {
            //Validation Success 
            response = MAS_ContactService.upsertContactFromMascus(contactRequestDto);
        }else{

            MAS_ActionLog.createErrorLog('MAS_ContactService',
                        'upsertContact',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        response.responseMessage,
                        null,
                        contactRequestDto.contact_MascusGUID,
                        JSON.serialize(contactRequestDto),
                        JSON.serialize(response),
                        null
            );
        }

        //Response
        return response;
    }

    global class MAS_ContactRequestDTO {

        //Required Fields
        webService String contact_AccountId { get; set; }
        webService String contact_Email { get; set; }
        webService String contact_MailingStreet { get; set; }
        webService String contact_MailingCity { get; set; }
        webService String contact_MailingStateOrProvince { get; set; }
        webService String contact_MailingZipOrPostalCode { get; set; }
        webService String contact_Mailing_Country { get; set; }
        webService String contact_FirstName { get; set; }
        webService String contact_LastName { get; set; }
        webService String contact_Role { get; set; }
        webService String contact_Status { get; set; }
        webService string contact_MascusGUID { get; set; } 
        webService String contact_PhoneNumber { get; set; } 

        webService String contact_MascusContactNumber{ get; set; } // Optional  Mascus_Contact_Number__c
        webService String contact_PhonePrefix { get; set; } // Required  Phone_Prefix__c
        
    }

}