@isTest
global class MAS_HttpCalloutMockImpl implements HttpCalloutMock {

 		protected Integer code;
		protected String status;
		protected String bodyAsString;
		protected Blob bodyAsBlob;
		protected Map<String, String> responseHeaders;

		global MAS_HttpCalloutMockImpl(Integer code, String status, String body, Map<String, String> responseHeaders) {
			System.debug('MAS_HttpCalloutMockImpl');
			this.code = code;
			this.status = status;
			this.bodyAsString = body;//JSON.serialize(body);
			this.bodyAsBlob = null;
			this.responseHeaders = responseHeaders;

		}

	/*	global InfoProHttpCalloutMock(Integer code, String status, Blob body, Map<String, String> responseHeaders) {
			this.code = code;
			this.status = status;
			this.bodyAsBlob = body;
			this.bodyAsString = null;
			this.responseHeaders = responseHeaders;
		} */

	    global HTTPResponse respond(HTTPRequest req) {
			
	        HttpResponse resp = new HttpResponse();
			resp.setStatusCode(code);
			resp.setStatus(status);
			if (bodyAsBlob != null) {
				resp.setBodyAsBlob(bodyAsBlob);
			} else {
				resp.setBody(bodyAsString);
			}

			if (responseHeaders != null) {
			     for (String key : responseHeaders.keySet()) {
				resp.setHeader(key, responseHeaders.get(key));
			     }
			}
			return resp;
	    }

  /*  // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {

		// Optionally, only send a mock response for a specific endpoint
        // and method.
        id userId = UserInfo.getUserId();
        string username = UserInfo.getUserName();
        string siret = '54205118000066';
        //http://ws-test.comm-back.fr/ws/getSocieteByKey/siret/54205118000066?user_id=1&org_id=1&username=user_test
        system.debug('ws01' + req.getEndpoint());
        System.assertEquals(InforProConstants.INFOPRO_SERVICE + InforProConstants.URL_COMPANY_BY_KEY + siret + '?' + InforProConstants.PARAM_USERNAME + username + '&' + InforProConstants.PARAM_USERID + userId , req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status": 200,"message": "","result": {"id": 516574,"raisonSociale": "TOTAL","adresse": "2 PLACE JEAN MILLIER","codePostal": "92400","ville": "COURBEVOIE","siret": "54205118000066","codeNaf": "7010Z","nafLibelle": "Activit\u00e9s des si\u00e8ges sociaux","tvaIntra": "FR59 542051180","tel": "0147444546","fax": null,"siteWeb": "www.total.com","ca": 9166082000,"anneeCa": "Thu Jan 01 00:00:00 CET 2015","nbEffectifNational": 6027,"typeEtablissement": "Si\u00e8ge","dateMaj": "2017-11-23T12:36:55Z"}}');
        res.setStatusCode(200);
        return res;
    } */

}