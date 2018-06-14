global class MAS_OracleOrder_HTTPClient {
  
      @future (callout=true)
      global static void doHTTPPost(String bodyJson,string orderid,string CurrencyCode) 
      {      
      		HttpRequest req = new HttpRequest();
            HTTPResponse res= new HTTPResponse();
            req.setMethod('POST');
            req.setEndpoint('callout:DellBoomi');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setBody(bodyJson);
            Http http = new Http();
            
            //Insert actionlog
            ActionLog__c ActionLog=new ActionLog__c();
            ActionLog.ActionType__c='INSERT';
            ActionLog.OrderId__c=orderid;
            ActionLog.Request_Data__c=bodyJson;
            ActionLog.Response_Data__c= res.getbody(); 
            ActionLog.Source__c = MAS_Constant.ACTION_LOG_SOURCE_SF;            
            ActionLog.Target__c= MAS_Constant.ACTION_LOG_SOURCE_ORACLE;
              
          if(String.isEmpty(CurrencyCode)){
            ActionLog.CurrencyIsoCode='EUR';
          }
          else
          {
          ActionLog.CurrencyIsoCode=CurrencyCode;
          }                            
          
          //update order Need_sync_with_Oracle__c  on failure
          List<Order> GetOrder=[SELECT Id,Need_sync_with_Oracle__c FROM Order WHERE id=:orderid];
          if(GetOrder.size()>0)
          {
            GetOrder[0].Need_sync_with_Oracle__c=true;
          }              
            
            try 
            {
              
              res = http.send(req);
              
              if(res.getStatusCode()!=200)
              {
                ActionLog.Status__c = MAS_Constant.ACTION_LOG_STATUS_FAILED;                                
                Update GetOrder;
              }
              else{
              	ActionLog.Status__c = MAS_Constant.ACTION_LOG_STATUS_EVENT_FIRED;              	
              }
              
              Actionlog.Response_Data__c = res.getbody();
              Insert ActionLog;
              
            }catch (System.CalloutException e) 
            {
              
              Actionlog.Response_Data__c=e.getMessage();
              ActionLog.Status__c = MAS_Constant.ACTION_LOG_STATUS_FAILED;
              Insert ActionLog;
              Update GetOrder;
            }
     }
}