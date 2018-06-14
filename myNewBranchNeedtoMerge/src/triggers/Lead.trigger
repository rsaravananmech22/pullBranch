/**
 * Created by malinda on 29-Nov-17.
 */

trigger Lead on Lead (before insert, before update, after insert, after update, before delete) {

    if (Trigger.IsBefore){

        if(Trigger.IsInsert){


        }else if(Trigger.IsUpdate){


        }else if(Trigger.isDelete){
			MAS_LeadTriggerHandler.validateDelete(Trigger.old);
        }

    }else if (Trigger.IsAfter){

        if(Trigger.IsInsert){


        }else if(Trigger.IsUpdate){
            //Sync Accounts and Contacts with Mascus
            MAS_LeadTriggerHandler.syncLeadsWithMascus(Trigger.new, Trigger.old);

        }else if(Trigger.Isdelete){

        }else{

        }
    }

}