/**************************************************************************
 * Description  : Apex Trigger handler classs for Lead
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR       DATE            DETAIL
    1.0        Malinda      29/11/2017      Initial implementation
 **************************************************************************/
public class MAS_LeadTriggerHandler {

    /**
    * @Description: This method consumes mascus Lead webservice and create/modify accounts/contacts in the mascus DB.
    * @author: Malinda
    * @params: newLeads : new Lead values list
    *          oldLeads : old Lead values list
    *          isBefore : before or after trigger
    * @return: void
    */
    public static void syncLeadsWithMascus(List<Lead> lstNewLeads, List<Lead> lstOldLeads) {
        
        if(MAS_UtilityHelper.isLeadTriggerRepeat
                || Boolean.valueOf(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.IS_LEAD_TRIGGER_REPEAT))
                || system.isBatch()){
            return;
        }

        Set<String> setMascusAccounts  = new Set<String>();
        Set<String> setMascusContacts  = new Set<String>();
        Map<String, Id> mapAccounts = new Map<String, Id>();
        Map<String, Id> mapContacts = new Map<String, Id>();
        List<Id> lstContactIds = new List<Id>();
        List<Lead> lstAccountsExport = new List<Lead>();
        List<Lead> lstContactsExport = new List<Lead>();

        for(Lead lead : lstNewLeads) {
        	if(lead.IsConverted) {
        		continue;
        	}
        	
            if(lead.Mascus_Account_ID__c == null){
                setMascusAccounts.add('Number');
            }else{
                setMascusAccounts.add(lead.Mascus_Account_ID__c);       
            }
            
            if(lead.Mascus_contact_ID__c == null){
                setMascusContacts.add('Number');
            }else{
                setMascusContacts.add(lead.Mascus_contact_ID__c);
            }
        }


        for(Account acc : [SELECT Id, Mascus_customer_ID__c FROM Account WHERE Mascus_customer_ID__c IN: setMascusAccounts]) {
            mapAccounts.put(acc.Mascus_customer_ID__c,acc.Id);
        }

        for(Contact con : [SELECT Id, Mascus_contact_ID__c FROM Contact WHERE Mascus_contact_ID__c IN: setMascusContacts]) {
            mapContacts.put(con.Mascus_contact_ID__c,con.Id);
        }

        if(MAS_UtilityHelper.isInternalRequest()){
            if(Trigger.isAfter && Trigger.isUpdate) {
                for(Lead lead : lstNewLeads) {
                    //Check field status
                    LeadFieldsToSync__c filedObj = MAS_UtilityHelper.isSyncRequiredForLead(lstNewLeads, lstOldLeads);
                    if(filedObj != null && filedObj.SyncWithAccountContact__c) {
                        if(mapAccounts != null && !mapAccounts.isEmpty() && mapContacts != null && !mapContacts.isEmpty()) {
                            //Both
                            lstAccountsExport.add(lead);
                            lstContactsExport.add(lead);
                        }
                    }
                    else {
                        if(filedObj != null && filedObj.Object__c == MAS_Constant.LEAD_OUTBOUND_OBJECT_TYPE_ACCOUNT) {
                            //fill Account lists
                            lstAccountsExport.add(lead);
                        }
                        else if(filedObj != null && filedObj.Object__c == MAS_Constant.LEAD_OUTBOUND_OBJECT_TYPE_CONTACT) {
                            //fill Contact lists
                            lstContactsExport.add(lead);
                        }
                    }
                }
            }
        }

        //Sending callouts
        if(!lstAccountsExport.isEmpty()) {
            if(!Test.isRunningTest()){
                String strJson = JSON.serialize(lstAccountsExport);
                MAS_AccountService.syncLeadAccountWithMascus(strJson);
            }
        }

        if(!lstContactsExport.isEmpty()) {
            if(!Test.isRunningTest()) {
                String strJson = JSON.serialize(lstContactsExport);
                MAS_ContactService.syncLeadContactWithMascus(strJson);
            }
        }

    }
    
    public static void validateDelete(List<Lead> leads) {
    	Map<Id, List<Lead>> leadCreatorIdMap = new Map<Id, List<Lead>>();
    	
    	for(Lead l : leads) {
    		if(leadCreatorIdMap.get(l.CreatedById) == null) {
    			leadCreatorIdMap.put(l.CreatedById, new List<Lead>());
    		}
    		leadCreatorIdMap.get(l.CreatedById).add(l);
    	}
    	
    	List<User> webserviceUsers = [SELECT Id FROM User WHERE Id IN :leadCreatorIdMap.keyset() AND Is_Mascus_Webservice__c = true];
    	
    	for(User u : webserviceUsers) {
    		for(Lead l : leadCreatorIdMap.get(u.Id)) {
    			l.addError('You cannot delete a lead that was created from Mascus Admin.');
    		}
    	}
    }

}