/**************************************************************************
 * Description  : Apex Class for Websercice resposne object
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       23/09/2019      Initial implementation
 **************************************************************************/
global class MAS_ResponseDTO {
    webservice String responseCode { get; set; }
    webservice String responseMessage { get; set; }
    webservice String responseType { get; set; }
    webservice list<ResponseData> responseResult { get; set; }
    
    global class ResponseData{
        webservice String key { get; set; }
        webservice String value { get; set; }
    }
    
}