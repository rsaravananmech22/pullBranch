/**************************************************************************
 * Description  : Apex Trigger for contact 
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       09/10/2017      Initial implementation
 **************************************************************************/
trigger Contact on Contact (before insert, before update, after insert, after update) {
  
   if (Trigger.IsBefore){
        
        if(Trigger.IsInsert){

            MAS_ContactTriggerHandler.validateContact(Trigger.new);

            // Check if there are NON ASCII in the contact name, if found transalate with Google translate API
            MAS_ContactTriggerHandler.translateNonAscciToEnglish(Trigger.new, Trigger.old,true);
            
        }else if(Trigger.IsUpdate){
            // Check if there are NON ASCII in the contact name, if found transalate with Google translate API
            MAS_ContactTriggerHandler.translateNonAscciToEnglish(Trigger.new, Trigger.old,true);

            // Throw an exception if user tries to deactivate or change the contact role for Contact with active order
            MAS_ContactTriggerHandler.throwExceptionOnContactDeactivation(Trigger.newMap, Trigger.oldMap, true);
        }else{
            
            
        }
        
    }else if (Trigger.IsAfter){

        if(Trigger.IsInsert){
            // Check if there are NON ASCII in the contact name, if found transalate with Google translate API
            MAS_ContactTriggerHandler.translateNonAscciToEnglish(Trigger.new,Trigger.old,false);
            
            // Sync new contact record with mascuss admin
            MAS_ContactTriggerHandler.consumeMascusContactWebService(Trigger.new, Trigger.old);
            
        }else if(Trigger.IsUpdate){
            // Check if there are NON ASCII in the contact name, if found transalate with Google translate API
            MAS_ContactTriggerHandler.translateNonAscciToEnglish(Trigger.new,Trigger.old,false);
            
            // Sync edited contact record with mascuss admin
            MAS_ContactTriggerHandler.consumeMascusContactWebService(Trigger.new, Trigger.old);

            // Cancels active linked orders and clones them
            MAS_ContactTriggerHandler.cancelOrderOnContactNameChange(Trigger.new, Trigger.old);
            
        }else if(Trigger.Isdelete){
            
        }else{
            
        } 
    }

}