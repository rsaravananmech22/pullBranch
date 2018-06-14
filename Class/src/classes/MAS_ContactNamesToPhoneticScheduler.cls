/**************************************************************************
 * Description  : Apex schdule class for execute AccountNamesToPhoneticBatch
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       27/09/2019      Initial implementation
 **************************************************************************/
global class MAS_ContactNamesToPhoneticScheduler implements Schedulable {
    
    // Execute at regular intervals
    global void execute(SchedulableContext ctx){
      
      MAS_ContactNamesToPhoneticBatch batch = new MAS_ContactNamesToPhoneticBatch();
      Database.executebatch(batch, 100);
    }
}