/**
 * Created by malinda on 18-Dec-17.
 */

global class MAS_ActionLog {
    /*
        A Public Method that can be utilized by
        other Apex Classes to create a record into
        the Apex Debug Log object stating the Error
        or Information.
    */
    public static ActionLog__c createLog(string className, string methodNmae, string actionType, string strSource, string strTarget, string strStatus, string strMessage, sObject obj, string strReferenceId, string strRequestData, string strResponseData, string strStackTrace){
        
        ActionLog__c apexlog = new ActionLog__c();
   
        apexlog.Class__c = className;
        apexlog.Method__c = methodNmae;
        apexlog.ActionType__c = actionType;
        apexlog.Message__c = strMessage;
        apexlog.Reference_Id__c = strReferenceId;
        apexlog.Request_Data__c = strRequestData;
        apexlog.Response_Data__c = strResponseData;
        apexlog.Source__c = strSource;
        apexlog.Stack_Trace__c = strStackTrace;
        apexlog.Status__c = strStatus;
        apexlog.Target__c = strTarget;

        if(obj instanceof  Account) {
            Account acc = (Account)obj;
            apexlog.AccountId__c = acc.Id;
        }else if(obj instanceof Contact) {
            Contact con = (Contact)obj;
            apexlog.ContactId__c = con.Id;
        }else if(obj instanceof Order) {
            Order ord = (Order)obj;
            apexlog.OrderId__c = ord.Id;
        }
                   
        return apexlog;
    }

    /*
        A Public Method that can be utilized by
        other Apex Classes to create a record into
        the Apex Debug Log object stating the Error
        or Information.
    */
    public static void createErrorLog(string className, string methodNmae, string actionType, string strSource, string strTarget, string strStatus, string strMessage, sObject obj, string strReferenceId, string strRequestData, string strResponseData, string strStackTrace){
        
        ActionLog__c apexlog = new ActionLog__c();

        try{

            if(
                (Limits.getDMLRows() < Limits.getLimitDMLRows()) && 
                (Limits.getDMLStatements() < Limits.getLimitDMLStatements())
                 
            )
            {
                  
                    apexlog.Class__c = className;
                    apexlog.Method__c = methodNmae;
                    apexlog.ActionType__c = actionType;
                    apexlog.Message__c = strMessage;
                    apexlog.Reference_Id__c = strReferenceId;
                    apexlog.Request_Data__c = strRequestData;
                    apexlog.Response_Data__c = strResponseData;
                    apexlog.Source__c = strSource;
                    apexlog.Stack_Trace__c = strStackTrace;
                    apexlog.Status__c = strStatus;
                    apexlog.Target__c = strTarget;

                    if(obj instanceof  Account) {
                        Account acc = (Account)obj;
                        apexlog.AccountId__c = acc.Id;
                    }else if(obj instanceof Contact) {
                        Contact con = (Contact)obj;
                        apexlog.ContactId__c = con.Id;
                    }else if(obj instanceof Order) {
                        Order ord = (Order)obj;
                        apexlog.OrderId__c = ord.Id;
                    }else if(obj instanceof Lead) {
                        Lead lead = (Lead)obj;
                        apexlog.LeadId__c = lead.Id;
                    }
    
                //Database.insert(apexDebuglog, FALSE);
                insert apexlog;

            }
            else{
                System.debug('ABSI-The Governor Limits have already been exhausted and hence failed to create a Log!');
            }
        }
        catch(DMLException ex){

            System.debug('ABSI-Something fatal has occurred and hence failed to create a Log! Error:' + ex.getMessage());
        }
    }

     /*
        A Public Method that can be utilized by
        other Apex Classes to send emails with failure actionlog response to people, groups, users, etc...
    */
    public static Boolean sendEmailWithActiveLog(Id idActionLog){
        
        try{

            ActionLog__c actLogObj = [ SELECT Id, Name, Message__c, Stack_Trace__c FROM ActionLog__c WHERE Id = :idActionLog ];
        
            List<String> lstEmailList = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ACTIONLOG_TO_EMAIL_ADDRESSES).split(',');

            EmailTemplate emailTemplate = [ SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE name =:MAS_Constant.ACTION_LOG_EMAIL_TEMPLATE_EN  ];
            String strMailHtmlBody = emailTemplate.HtmlValue;
            String strPlainBody = emailTemplate.Body;

            strMailHtmlBody =  strMailHtmlBody.replace('[RECIPIENT_NAME]', MAS_Constant.ACTION_LOG_EMAIL_TEMPLATE_RECIPIENT_NAME);
            strMailHtmlBody =  strMailHtmlBody.replace('[ID]', '<a href=\"' + System.URL.getSalesforceBaseURL().toExternalForm() + '/' + idActionLog + '\" >' + idActionLog + '</a>');
            strMailHtmlBody =  strMailHtmlBody.replace('[MESSAGE]', actLogObj.Message__c);
            strMailHtmlBody =  strMailHtmlBody.replace('[STACKTRACE]', actLogObj.Stack_Trace__c);
            strMailHtmlBody =  strMailHtmlBody.replace('[SENDER_NAME]', MAS_Constant.ACTION_LOG_EMAIL_TEMPLATE_SENDER_NAME);

            strPlainBody =  strPlainBody.replace('[RECIPIENT_NAME]', MAS_Constant.ACTION_LOG_EMAIL_TEMPLATE_RECIPIENT_NAME);
            strPlainBody =  strPlainBody.replace('[ID]', idActionLog);
            strPlainBody =  strPlainBody.replace('[MESSAGE]', actLogObj.Message__c);
            strPlainBody =  strPlainBody.replace('[STACKTRACE]', actLogObj.Stack_Trace__c);
            strPlainBody =  strPlainBody.replace('[SENDER_NAME]', MAS_Constant.ACTION_LOG_EMAIL_TEMPLATE_SENDER_NAME);

            Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
            emailObj.setToAddresses(lstEmailList);
            emailObj.setSubject(emailTemplate.Subject);
            emailObj.setHtmlBody(strMailHtmlBody);
            emailObj.setPlainTextBody(strPlainBody);
            emailObj.setSaveAsActivity(false);

            Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailObj});

            return true;
        
        }catch(Exception ex){
            System.debug('ABSI-Something fatal has occurred and hence failed to send email with activelog failure response! Error:' + ex.getMessage());
            return false;
        }
    }


}