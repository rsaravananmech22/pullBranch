/**************************************************************************
 * Description  : Apex Class for all Callouts
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       25/09/2019      Initial implementation
 **************************************************************************/
public with sharing class MAS_WebServiceCallOut {
	
    /**
     * @Description This method calls the google translate API
     * @author Samith Perera
     * @params text : text to be translated
     * @return string (translated text)
     */
    public static string googleTranslateAPI(string recordId, string text){

        //if(!Test.isRunningTest()){      
            // Google Key
            string key = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.GOOGLE_API_KEY);
            // Generate google translate API url with prameters
            string url = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.GOOGLE_TRANSLATE_URL) +'?key='+key+'&target=en&q=' + text;
            
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            req.setMethod('GET');
            req.setEndPoint(url);
            HTTPResponse resp = http.send(req);
            String jsonResults = resp.getBody();
        
            // Create a json parser
            JSONParser parser = JSON.createParser(jsonResults);
            string translate = null;
            
            // Loop through the parser and find the maching token for 'translatedText'
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'translatedText')) {
                    parser.nextToken();
                    translate = parser.getText();
                }
            }
   
            return translate;
        //}else{
            //When running in test context, just return success response
            //return MAS_Constant.RESPONSE_TYPE_SUCCESS;
              
        //}
    }

    /**
     * @Description This method calls the mascus API and get the valid sessionId
     * @author Samith Perera
     * @return string (sessionId)
     */
    public static string mascusAPIAuthentication(){

        String username = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.MASCUS_SERVICE_USER_NAME);
        String password = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.MASCUS_SERVICE_PASSWORD);
        servicesMascusComApi2.mascussfSoap cApi = new servicesMascusComApi2.mascussfSoap();

        return cApi.OpenSession(username, password);
    }

    /**
     * @Description This method calls the mascus API and get the valid sessionId
     * @author Dinesh W
     * @return string (sessionId)
     */
    public static servicesMascusComApi2.ArrayOfString mascusServiceInvoke(string sessionId, string xmlBody, SObject obj){

        servicesMascusComApi2.mascussfSoap cApi = new servicesMascusComApi2.mascussfSoap();
        servicesMascusComApi2.ArrayOfString returnArrayString = new servicesMascusComApi2.ArrayOfString();

        if(obj == null ){
            returnArrayString = cApi.AdManagement(sessionId, xmlBody);
        }else if(obj instanceof  Account) {
            returnArrayString = cApi.ImportAccount(sessionId, xmlBody);
        }else if(obj instanceof Contact) {
            returnArrayString = cApi.ImportContact(sessionId, xmlBody);
        }else if(obj instanceof Order) {
            returnArrayString = cApi.ImportOrder(sessionId, xmlBody);
        }

        return returnArrayString;
    }

    /**
     * @Description This method calls the mascus vat validation service
     * @author Samith Perera
     * @return string (vat response)
     */
    public static string mascusVatServiceInvoke(MAS_VATRequestDTO vatDTO){

        string body  =  JSON.serialize(vatDTO);
        
        //Get vat service url from custom seting
        string url = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.VAT_SERVICE_URL);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        
        // Specify the required user name and password to access the endpoint
        // As well as the header and header information
        
        String username = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.VAT_SERVICE_USER_NAME);
        String password = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.VAT_SERVICE_PASSWORD);
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setTimeout(20000);
        req.setBody(body);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('##BODY'+ res.getBody());
        
        return res.getBody();
    }
    
}