@isTest
global class MAS_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement HttpCalloutMock interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint.
        System.assertEquals('callout:DellBoomi', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('<soapenv:Envelope xmlns:soapenv=\'http://schemas.xmlsoap.org/soap/envelope/\'><soapenv:Body><notificationsResponse xmlns=\'http://soap.sforce.com/2005/09/outbound\'><Ack>true</Ack></notificationsResponse></soapenv:Body></soapenv:Envelope>');
        res.setStatusCode(200);
        return res;
    }
     
}