/**************************************************************************
 * Description  : Apex Batch for trasnslate existing Account names to
                  english
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       20/09/2017      Initial implementation
 **************************************************************************/
global class MAS_AccountNamesToPhoneticBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
   

   global Database.QueryLocator start(Database.BatchableContext BC){
       
      return Database.getQueryLocator([SELECT Id, Name, Phonetic_Account_Name__c
                                         FROM Account 
                                         WHERE Phonetic_Account_Name__c = NULL 
                                         OR Phonetic_Account_Name__c =: Label.MAS_MSG_Phonetic_Name_Update
                                         LIMIT 50000]);                                       
   }

   global void execute(Database.BatchableContext BC, List<Account> accountList){ 

      list<ActionLog__c> logList = new list<ActionLog__c>();

       for(Account acc  : accountList){
          try{

               if(MAS_UtilityHelper.isNonAscii(acc.Name)){
                  acc.Phonetic_Account_Name__c = MAS_AccountService.translateNonAscii(acc.Id, acc.Name);
               }else{
                  acc.Phonetic_Account_Name__c = acc.Name;
               }

           }catch(Exception ex){
              logList.add(MAS_ActionLog.createLog('MAS_ContactNamesToPhoneticBatch',
                'execute',
                MAS_Constant.ACTION_LOG_TYPE_TRANSLATE,
                MAS_Constant.ACTION_LOG_SOURCE_SF,
                MAS_Constant.ACTION_LOG_TRAGET_GOOGLE,
                MAS_Constant.ACTION_LOG_STATUS_FAILED,
                ex.getMessage(),
                acc,
                null,
                acc.Name,
                acc.Phonetic_Account_Name__c,
                ex.getStackTraceString())
              );
           }
       }
       //Only for test run, throw an exception when upadte the list
       if(Test.isRunningTest()){  
            for(Account acc  : accountList){
                if(acc.Name == 'Test Áccount') {
                    accountList[0].Phonetic_Account_Name__c = 'Test Áccount';
                }           
            }
       }
       //Stop Calling the google translate API from trigger       
       MAS_UtilityHelper.isAccountTriggerRepeat = true;
       Database.SaveResult[] results = Database.update(accountList, false);


        for (integer idx = 0; idx < results.size(); idx++) {
            if (results[idx].isSuccess()) {
                //Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + results[idx].getId());
            }else {
                // Operation failed, so get all errors                
                for(Database.Error err : results[idx].getErrors()) {
                    // Save errors in the Salesforce
                    Account acc = new Account(id = accountList[idx].Id);

                    logList.add(MAS_ActionLog.createLog('MAS_ContactNamesToPhoneticBatch',
                                'execute',
                                MAS_Constant.ACTION_LOG_TYPE_TRANSLATE,
                                MAS_Constant.ACTION_LOG_SOURCE_SF,
                                MAS_Constant.ACTION_LOG_TRAGET_GOOGLE,
                                MAS_Constant.ACTION_LOG_STATUS_FAILED,
                                err.getMessage(),
                                acc,
                                null,
                                null,
                                null,
                                null)
                              );
                }
            }
        }

      // Insert Errors
      Database.insert (logList,false);
      
   }
	
   global void finish(Database.BatchableContext BC){ 

      // Get's the ID of the AsyncApexJob representing this batch job from Database.BatchableContext and 
      // query the AsyncApexJob object to retrieve the current job's information.
      AsyncApexJob a =  [ SELECT  Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedById
                  FROM  AsyncApexJob 
                  WHERE   Id =: BC.getJobId() 
                ];
                
      // Send's an e-mail to the Apex job's submitter to notify the completion of the Apex Job. 
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     
      String[] toAddresses = new String[] {'samith@absi.be'};
      mail.setToAddresses(toAddresses);
      //mail.setTargetObjectId(a.CreatedById);
      mail.setSaveAsActivity(false);
      mail.setSubject('Account Names to Phonetic - ' + a.Status);
      
      String body = 'The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
      
      mail.setPlainTextBody(body);
      
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
}