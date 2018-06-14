@isTest
global class MAS_MockHttpResponseFailGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='false'), true);
        System.assertEquals('callout:DellBoomi', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('<soapenv:Envelope xmlns:soapenv=\'http://schemas.xmlsoap.org/soap/envelope/\'><soapenv:Body><notificationsResponse xmlns=\'http://soap.sforce.com/2005/09/outbound\'><Ack>true</Ack></notificationsResponse></soapenv:Body></soapenv:Envelope>');
        res.setStatusCode(400);
        return res;
    }
     
}