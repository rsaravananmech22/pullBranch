/**************************************************************************
 * Description  : Apex Trigger for ActionLog__c 
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
    1.0        Kavinda Inusha      30/01/2018      Initial implementation
 **************************************************************************/
trigger ActionLog on ActionLog__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    

    if ( Trigger.isBefore ) {

    }

    if ( Trigger.isAfter ) {

        if ( Trigger.isInsert ) {
            
            // Check if ActionLog status failed, if it true send email
            MAS_ActionLogTriggerHandler.sendActionLogFailureEmail(Trigger.new);
        	MAS_ActionLogTriggerHandler.emailIntegrationFailure(Trigger.new);
        }

    }


}