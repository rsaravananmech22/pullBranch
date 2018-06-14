/**************************************************************************
 * Description  : Apex Trigger handler classs for contact 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       09/10/2017      Initial implementation
 **************************************************************************/
public class MAS_ContactTriggerHandler {
    
    private static List<Queueable> queables {get; set;}
    
    /**
     * @Description: This method decides which contact names should be translated from google API
     *              and translate them to phonetic field
     * @author: Samith Perera
     * @params: newContacts : new contact values list
     *          oldContacts : old contact values list
     *          isBefore : before or after trigger
     * @return: void
     */
    public static void translateNonAscciToEnglish(list<Contact>newContacts, list<Contact>oldContacts, boolean isBefore){
        if(MAS_UtilityHelper.isContactTriggerRepeat 
          || Boolean.valueOf(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.IS_CONTACT_TRIGGER_REPEAT))
          || system.isBatch()) // DO not remove
            return;
        
        //Before triggers            
        if(isBefore){            
          for (Integer i = 0; i < newContacts.size(); i++) {                   
              if(newContacts[i].Phonetic_Contact_First_Name__c == null 
                 || (oldContacts != null && newContacts[i].FirstName != oldContacts[i].FirstName)){                      
                  
                  // Check non ascii from regex
                  boolean CheckFirstname= (string.isempty(newContacts[i].FirstName)||newContacts[i].FirstName==' ')?false:MAS_UtilityHelper.isNonAscii(newContacts[i].FirstName);
                  if(CheckFirstname){
                      newContacts[i].Phonetic_Contact_First_Name__c = Label.MAS_MSG_Phonetic_Name_Update;
                  }else{
                      newContacts[i].Phonetic_Contact_First_Name__c = newContacts[i].FirstName;
                  }
              }
              
              if(newContacts[i].Phonetic_Contact_Last_Name__c == null 
                 || (oldContacts != null && newContacts[i].LastName != oldContacts[i].LastName)){                      
                  
                  // Check non ascii from regex
                  if(MAS_UtilityHelper.isNonAscii(newContacts[i].LastName)){
                      newContacts[i].Phonetic_Contact_Last_Name__c = Label.MAS_MSG_Phonetic_Name_Update;
                  }else{
                      newContacts[i].Phonetic_Contact_Last_Name__c = newContacts[i].LastName;
                  }
              }       
          } 
        // After triggers    
        }else{
            list<Id> toUpdateconList = new List<Id>();           
            
            for(Contact con : newContacts){             
                // Collect all contacts which should be trnaslated via google API          
                if(con.Phonetic_Contact_First_Name__c == null
                    || con.Phonetic_Contact_Last_Name__c == null
                    || con.Phonetic_Contact_First_Name__c == Label.MAS_MSG_Phonetic_Name_Update 
                    || con.Phonetic_Contact_Last_Name__c == Label.MAS_MSG_Phonetic_Name_Update){

                    toUpdateconList.add(con.Id);
                }
            }
            
            // Add contact list into fture method/queue
            if(toUpdateconList.size() > 0){
                MAS_ContactService.translateNonAscii(toUpdateconList);
            }
        }  
    }
    
    /**
     * @Description: This method consumes mascus contact webservice and create/modidy contatcs in the mascus DB.
     * @author: Samith Perera
     * @params: newContacts : new contact values list
     *          oldContacts : old contact values list
     *          isBefore : before or after trigger
     * @return: void
     */
    public static void consumeMascusContactWebService(list<Contact>newContacts, list<Contact>oldContacts){
        if(MAS_UtilityHelper.isContactTriggerRepeat 
          || Boolean.valueOf(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.IS_CONTACT_TRIGGER_REPEAT))
          || system.isBatch())
            return;

        boolean isNewRecord = false;
        if(oldContacts == null){
            isNewRecord = true;
        }
             
        List<Id> contactToSync = new List<Id>();
        
        if(MAS_UtilityHelper.isInternalRequest()){
          for (Contact con : newContacts) {
              if(isNewRecord){
                  contactToSync.add(con.Id);
              }else if(MAS_UtilityHelper.isSyncRequiredForUpdate(newContacts, oldContacts, 'Contact')){
                  contactToSync.add(con.Id);
              }
          }
        }

        if(contactToSync.size() > 0){
          if(!Test.isRunningTest()){
              MAS_ContactService.syncContactWithMascusWeb(contactToSync);
          }
        }
    }
    

    /**
     * @Description: This method sends contact related orders to the cancelOriginalOrderItems method
     * @author: Robin De Bondt
     * @params: newContacts : new contact values list
     *          oldContacts : old contact values list
     * @return: void
     */
    public static void cancelOrderOnContactNameChange(list<Contact>newContacts, list<Contact>oldContacts){
        
        Set<Id> contactIds = new Set<Id>();

        for (Integer i = 0; i < newContacts.size(); i++) {                   
            if(
              //When contact name changes
              newContacts[i].FirstName != oldContacts[i].FirstName
              || newContacts[i].LastName != oldContacts[i].LastName
              || newContacts[i].Suffix != oldContacts[i].Suffix
              ){                      
                contactIds.add(newContacts[i].Id);
            }
        }   

        //Get all active orders with non cancelled products linked through the std BillToContact or Sold_to_contact__c field and pass their Id's
        Map<Id, Order> mapOrderIdToOrder = new Map<Id, Order>([ SELECT Id 
                                                                FROM Order 
                                                                WHERE Status = 'Activated' 
                                                                AND (BillToContactId IN :contactIds OR Sold_to_contact__c IN :contactIds)
                                                                AND Number_of_non_cancelled_Products__c > 0]);
        List<Id> orderIdList = new List<Id>();
        orderIdList.addAll(mapOrderIdToOrder.keySet()); 
        if(orderIdList.size() > 0){
          System.debug(orderIdList.size() + ' orders will be processed because of contact name changes.');
          MAS_OrderService.cancelOriginalOrderItems(orderIdList, 'account_info_change'); 
        }     
    }

    public static void validateContact(list<Contact>newContacts){
       for (Contact con : newContacts) {
          //con.addError('Overlap');
       }
    }

    public static void throwExceptionOnContactDeactivation(Map<Id, Contact> newContacts, Map<Id, Contact> oldContacts, boolean isBefore){
        
        Map<Id, String> contactActiveOrderMapRoleChange = new Map<Id, String>();
        Map<Id, String> contactActiveOrderMapStatusChange = new Map<Id, String>();

        for (Order o: [SELECT Id, Order_State__c, BillToContactId, BillToContact.Name, Mascus_Order_Number__c FROM Order 
                      WHERE BillToContactId IN : newContacts.keySet() AND Order_State__c != '' AND Order_State__c != 'Fully Cancelled']) {

            If (newContacts.get(o.BillToContactId).Status__c != MAS_Constant.STATUS_ACTIVE && oldContacts.get(o.BillToContactId).Status__c == MAS_Constant.STATUS_ACTIVE) {

                if (contactActiveOrderMapStatusChange.containsKey(o.BillToContactId)) {
                    contactActiveOrderMapStatusChange.put(o.BillToContactId, contactActiveOrderMapStatusChange.get(o.BillToContactId) + ', ' + o.Mascus_Order_Number__c);
                } else {
                    contactActiveOrderMapStatusChange.put(o.BillToContactId, o.Mascus_Order_Number__c);
                }
                
            } 

            if (newContacts.get(o.BillToContactId).Contact_Role__c != MAS_Constant.CONTACT_ROLE_INVOICING && oldContacts.get(o.BillToContactId).Contact_Role__c == MAS_Constant.CONTACT_ROLE_INVOICING) {
                
                if (contactActiveOrderMapRoleChange.containsKey(o.BillToContactId)) {
                    contactActiveOrderMapRoleChange.put(o.BillToContactId, contactActiveOrderMapRoleChange.get(o.BillToContactId) + ', ' + o.Mascus_Order_Number__c);
                } else {
                    contactActiveOrderMapRoleChange.put(o.BillToContactId, o.Mascus_Order_Number__c);
                }
            }
        }

        for(Contact c: newContacts.values()){
            if (contactActiveOrderMapRoleChange.containsKey(c.Id)) {
                c.Contact_role__c.addError(Label.LBL_ERR_CON_ContactRoleChange + ' ' + contactActiveOrderMapRoleChange.get(c.Id));
            } 

            if (contactActiveOrderMapStatusChange.containsKey(c.Id)) {
                c.Status__c.addError(Label.LBL_ERR_CON_StatusChange + ' ' + contactActiveOrderMapStatusChange.get(c.Id));
            }
        }                        
    }
}