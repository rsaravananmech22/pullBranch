/*************************************************************************
 * Description  : Apex Batch for trasnslate existing contact names to
                  english
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       09/10/2017      Initial implementation
 **************************************************************************/
global class MAS_ContactNamesToPhoneticBatch implements Database.Batchable<SObject>,Database.AllowsCallouts, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id, FirstName, LastName, Phonetic_Contact_First_Name__c , Phonetic_Contact_Last_Name__c
                                         FROM contact 
                                         WHERE Phonetic_Contact_First_Name__c = NULL 
                                         OR Phonetic_Contact_Last_Name__c = NULL
                                         OR Phonetic_Contact_First_Name__c =: Label.MAS_MSG_Phonetic_Name_Update
                                         OR Phonetic_Contact_Last_Name__c =: Label.MAS_MSG_Phonetic_Name_Update 
                                         LIMIT 50000]);
    }
    
    global void execute(Database.BatchableContext context, list<contact> contactList) {
      
      list<ActionLog__c> logList = new list<ActionLog__c>();
      String state;

      for(Contact con  : contactList){
           state = null;
           try{  
                if(MAS_UtilityHelper.isNonAscii(con.FirstName)){
                    state = MAS_Constant.STATE_FIRSTNAME;
                    con.Phonetic_Contact_First_Name__c = MAS_ContactService.translateNonAscii(con.Id, con.FirstName);
                }else{
                    con.Phonetic_Contact_First_Name__c = con.FirstName;
                }

                if(MAS_UtilityHelper.isNonAscii(con.LastName)){
                    state = MAS_Constant.STATE_LASTNAME;
                    con.Phonetic_Contact_Last_Name__c = MAS_ContactService.translateNonAscii(con.Id, con.LastName);
                }else{
                    con.Phonetic_Contact_Last_Name__c = con.LastName;
                }

             }catch(Exception ex){

                logList.add(MAS_ActionLog.createLog('MAS_ContactNamesToPhoneticBatch',
                      'execute',
                       MAS_Constant.ACTION_LOG_TYPE_TRANSLATE,
                       MAS_Constant.ACTION_LOG_SOURCE_SF,
                       MAS_Constant.ACTION_LOG_TRAGET_GOOGLE,
                       MAS_Constant.ACTION_LOG_STATUS_FAILED,
                       ex.getMessage(),
                       con,
                       null,
                       state == MAS_Constant.STATE_FIRSTNAME ? con.FirstName : con.LastName,
                       state == MAS_Constant.STATE_FIRSTNAME ? con.Phonetic_Contact_First_Name__c : con.Phonetic_Contact_Last_Name__c ,
                       null )); 
             }
      }
       
      // Stop Calling the google translate API from trigger       
      MAS_UtilityHelper.isContactTriggerRepeat = true;
      Database.SaveResult[] results = Database.update(contactList, false);
     

      for (integer idx = 0; idx < results.size(); idx++) {
            if (results[idx].isSuccess()) {
                //Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + results[idx].getId());
            }else {
                // Operation failed, so get all errors                
                for(Database.Error err : results[idx].getErrors()) {
                    
                    // Save errors in the Salesforce
                    Contact con = new Contact(id = contactList[idx].Id);
                    logList.add(MAS_ActionLog.createLog('MAS_ContactService',
                      'translateNonAscii',
                      MAS_Constant.ACTION_LOG_TYPE_TRANSLATE,
                      MAS_Constant.ACTION_LOG_SOURCE_SF,
                      MAS_Constant.ACTION_LOG_TRAGET_GOOGLE,
                      MAS_Constant.ACTION_LOG_STATUS_FAILED,
                      err.getMessage(),
                      con,
                      null,
                      null,
                      null,
                      null )
                    );
                }
            }
      }

      // Insert Errors
      Database.insert (logList,false);

    }
    
    global void finish(Database.BatchableContext context) {

        // Get's the ID of the AsyncApexJob representing this batch job from Database.BatchableContext and 
        // query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a =  [ SELECT  Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedById
                      FROM  AsyncApexJob 
                      WHERE   Id =: context.getJobId() 
                    ];
                    
        // Send's an e-mail to the Apex job's submitter to notify the completion of the Apex Job. 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         
        String[] toAddresses = new String[] {'samith@absi.be'};
        mail.setToAddresses(toAddresses);
        //mail.setTargetObjectId(a.CreatedById);
        mail.setSaveAsActivity(false);
        mail.setSubject('Contact Names to Phonetic - ' + a.Status);
          
        String body = 'The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
          
        mail.setPlainTextBody(body);
          
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}