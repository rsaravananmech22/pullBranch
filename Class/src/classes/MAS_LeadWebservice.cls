/**************************************************************************
 * Description  : Data transfer object for the third party request
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR              DATE            DETAIL
      1.0      Malinda       24/11/2017      Initial implementation
 **************************************************************************/
global class MAS_LeadWebservice {

    webservice static MAS_ResponseDTO upsertLead(MAS_LeadRequestDTO leadRequestDTO) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();

        //Request validation
        response = MAS_LeadService.validateLeadFromMascus(leadRequestDTO);

        //Request Process
        if(response.responseCode == MAS_Constant.LEAD_VALIDATION_SUCCESS_CODE) {
            response = MAS_LeadService.upsertLeadFromMascus(leadRequestDTO);
        }else{

             MAS_ActionLog.createErrorLog('MAS_LeadWebservice',
                        'upsertLead',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        response.responseMessage,
                        null,
                        leadRequestDTO.Lead_MascusAccountGUID,
                        JSON.serialize(leadRequestDTO),
                        JSON.serialize(response),
                        null
            );
        }

        //Response
        return response;

    }

    global class MAS_LeadRequestDTO {

        //Required Fields
        webService String Lead_Status { get; set; } //Optional
        webService String Lead_CompanyName { get; set; }
        webService String Lead_Classification { get; set; } //Optional
        webService String Lead_LastName { get; set; }
        webService String Lead_FirstName { get; set; }
        webService String Lead_MobilePrefix { get; set; }
        webService String Lead_MobileNumber { get; set; }
        webService String Lead_source { get; set; } //Optional
        webService String Lead_Street{ get; set; }
        webService String Lead_State { get; set; } //Optional
        webService String Lead_PostalCode { get; set; }
        webService String Lead_Country{ get; set; }
        webService String Lead_MascusAccountGUID{ get; set; }
        webService String Lead_MascusContactGUID { get; set; }
        webService String Lead_MascusLeadNumber { get; set; } //Optional
        //Added by Amarendra-nagireddy on 12/14/2017-As part of bug # C248-39 
        webService String Lead_City { get; set; } //Optional
        webService String Lead_Email { get; set; } //Optional

    }
}