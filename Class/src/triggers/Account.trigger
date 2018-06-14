/**************************************************************************
 * Description  : Apex Trigger for account 
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       19/09/2019      Initial implementation
 **************************************************************************/
trigger Account on Account(Before insert, Before update, After insert, After update)
{
   if (Trigger.IsBefore){
        
        if(Trigger.IsInsert){
            // Check if there are NON ASCII in the account name, if found transalate with Google translate API
            MAS_AccountTriggerHandler.translateNonAscciToEnglish(Trigger.new, Trigger.old,true);
            
            // Update Account fields on Lead conversion that are not supported by OOB Lead Conversion Mappings
            MAS_AccountTriggerHandler.updateAccountOnLeadConvert(Trigger.new, Trigger.old, true);

        }else if(Trigger.IsUpdate){
            // Check if there are NON ASCII in the account name, if found transalate with Google translate API
            MAS_AccountTriggerHandler.translateNonAscciToEnglish(Trigger.new, Trigger.old,true);
            
        }else{
            
            
        }
        
    }else if (Trigger.IsAfter){
        
        if(Trigger.IsInsert){
            // Check if there are NON ASCII in the account name, if found transalate with Google translate API
            MAS_AccountTriggerHandler.translateNonAscciToEnglish(Trigger.new,Trigger.old,false);
            
            // Sync new account record with mascuss admin
            MAS_AccountTriggerHandler.syncAccountWithMascus(Trigger.new, Trigger.old);
            
        }else if(Trigger.IsUpdate){
            // Check if there are NON ASCII in the account name, if found translate with Google translate API
            MAS_AccountTriggerHandler.translateNonAscciToEnglish(Trigger.new,Trigger.old,false);
            
            // Sync edited account record with mascus admin
            MAS_AccountTriggerHandler.syncAccountWithMascus(Trigger.new, Trigger.old);

            // Cancels active linked orders and clones them
            MAS_AccountTriggerHandler.cancelOrderOnAccountInformationChange(Trigger.new, Trigger.old);
            
        }else if(Trigger.Isdelete){
            
        }else{
            
        } 
    }
}