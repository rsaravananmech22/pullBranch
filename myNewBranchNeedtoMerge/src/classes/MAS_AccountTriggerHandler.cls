/**************************************************************************
 * Description  : Apex Trigger handler classs for account 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       19/10/2017      Initial implementation
 **************************************************************************/
public class MAS_AccountTriggerHandler {
	
	  private static List<Queueable> queables {get; set;}
    
    /**
     * @Description: This method decides which account names should be translated from google API
     *              and translate them to phonetic field
     * @author: Samith Perera
     * @params: newAccounts : new account values list
     *          oldAccounts : old account values list
     *          isBefore : before or after trigger
     * @return: void
     */
    public static void translateNonAscciToEnglish(list<Account>newAccounts, list<Account>oldAccounts, boolean isBefore){

        if(MAS_UtilityHelper.isAccountTriggerRepeat 
           || Boolean.valueOf(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT))
           || system.isBatch()){ // Do not remove system.isBatch()
               return;
           } 
            
        
        //Before triggers            
        if(isBefore){   
            system.debug('MAS_AccountTriggerHandler isBefore');
          for (Integer i = 0; i < newAccounts.size(); i++) {                   
              if(newAccounts[i].Phonetic_Account_Name__c == null 
                 || (oldAccounts != null && newAccounts[i].Name != oldAccounts[i].Name)){                      
                  
                  // Check non ascii from regex
                  if(MAS_UtilityHelper.isNonAscii(newAccounts[i].Name)){
                      newAccounts[i].Phonetic_Account_Name__c = Label.MAS_MSG_Phonetic_Name_Update;
                  }else{
                      newAccounts[i].Phonetic_Account_Name__c = newAccounts[i].Name;
                  }
              }
          } 
            
        // After triggers    
        }else{
            list<Id> toUpdateAccList = new List<Id>();           
            
            for(Account acc : newAccounts){             
                // Collect all contacts which should be trnaslated via google API          
                if(acc.Phonetic_Account_Name__c == null
                    || acc.Phonetic_Account_Name__c == Label.MAS_MSG_Phonetic_Name_Update ){

                    toUpdateAccList.add(acc.Id);
                }
            }
			
            // Add contact list into future method/queue
            if(toUpdateAccList.size() > 0){
                MAS_AccountService.translateNonAscii(toUpdateAccList);
            }
        }  
    
    }
    
    /**
     * @Description: This method consumes mascus account webservice and create/modify accounts in the mascus DB.
     * @author: Samith Perera
     * @params: newAccounts : new account values list
     *          oldAccounts : old account values list
     *          isBefore : before or after trigger
     * @return: void
     */
    public static void syncAccountWithMascus(list<Account>newAccounts, list<Account>oldAccounts){
        if(MAS_UtilityHelper.isAccountTriggerRepeat 
          || Boolean.valueOf(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT))
          || system.isBatch()){
              return;
          }
           
        boolean isNewRecord = false;
        
        if(oldAccounts == null)
          isNewRecord = true; //To be changed                  
    
        List<Id> accountIdsToSync = new List<Id>(); 

        if(MAS_UtilityHelper.isInternalRequest()){
            for (Account acc : newAccounts) {             
              // Need to be changed the hardcoded values
              if(acc.type != 'Internal legal entity' &&  acc.type != 'Partner' && acc.type != 'Licensee'){
                if(isNewRecord){
                  accountIdsToSync.add(acc.Id);
                }else if(MAS_UtilityHelper.isSyncRequiredForUpdate(newAccounts, oldAccounts, 'Account')){
                  accountIdsToSync.add(acc.Id);
                }
              }
            }
        }

        if(accountIdsToSync.size() > 0){
            System.debug('@mal-update-sent');
            if(!Test.isRunningTest()){
              MAS_AccountService.syncAccountWithMascusWeb(accountIdsToSync);
            }
        }
      
    }
    
    /**
     * @Description: This method sends account related orders to the cancelOriginalOrderItems method
     * @author: Robin De Bondt
     * @params: newAccounts : new account values list
     *          oldAccounts : old account values list
     *          isBefore : before or after trigger
     * @return: void
     */
    public static void cancelOrderOnAccountInformationChange(list<Account>newAccounts, list<Account>oldAccounts){
        
        Set<Id> accountIds = new Set<Id>();
        Id customerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();

        for (Integer i = 0; i < newAccounts.size(); i++) {                   
            if(
              //Only customer accounts can have orders that should be cancelled
              newAccounts[i].RecordTypeId == customerAccountRecordTypeId
              && (
              //When account name change  
              newAccounts[i].Name != oldAccounts[i].Name
              //or any of the billing or shipping address fields change
              || newAccounts[i].BillingStreet != oldAccounts[i].BillingStreet
              || newAccounts[i].BillingPostalCode != oldAccounts[i].BillingPostalCode
              || newAccounts[i].BillingCity != oldAccounts[i].BillingCity
              || newAccounts[i].BillingState != oldAccounts[i].BillingState
              || newAccounts[i].BillingCountry != oldAccounts[i].BillingCountry
              || newAccounts[i].ShippingStreet != oldAccounts[i].ShippingStreet
              || newAccounts[i].ShippingPostalCode != oldAccounts[i].ShippingPostalCode
              || newAccounts[i].ShippingCity != oldAccounts[i].ShippingCity
              || newAccounts[i].ShippingState != oldAccounts[i].ShippingState
              || newAccounts[i].ShippingCountry != oldAccounts[i].ShippingCountry
              || newAccounts[i].Email_for_invoicing__c != oldAccounts[i].Email_for_invoicing__c)
              ){                      
                accountIds.add(newAccounts[i].Id);
            }
        } 

        //Get all active orders with non cancelled products linked through the std account or Sold_to_Account__c field and pass their Id's
        Map<Id, Order> mapOrderIdToOrder = new Map<Id, Order>([ SELECT Id 
                                                                FROM Order 
                                                                WHERE Status = 'Activated' 
                                                                AND (AccountId IN :accountIds OR Sold_to_Account__c IN :accountIds)
                                                                AND Number_of_non_cancelled_Products__c > 0]);
        List<Id> orderIdList = new List<Id>();
        orderIdList.addAll(mapOrderIdToOrder.keySet());
        if(orderIdList.size() > 0){
          System.debug(orderIdList.size() + ' orders will be processed because of account information changes.');
          MAS_OrderService.cancelOriginalOrderItems(orderIdList, 'account_info_change');    
        }            
    }    

    /**
     * @Description: This method updates Shipping Address on Account when a Lead is converted
     * @author: Saurabh Oberoi
     * @params: newAccounts : new account values list
     *          oldAccounts : old account values list
     *          isBefore : before or after trigger
     * @return: void
     * @ticket: C248-663
     */
    public static void updateAccountOnLeadConvert(list<Account>newAccounts, list<Account>oldAccounts, boolean isBefore){
        
        for (Account acc: newAccounts) {

            if(acc.Converted_From_Lead__c){
                
                // Update shipping address same as billing address
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingState = acc.BillingState;
                acc.ShippingStateCode = acc.BillingStateCode;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingCountryCode = acc.BillingCountryCode;

                // Update CustomerPriority, UsedEquipmentInStock, 
                acc.Customer_priority__c = 'Medium';
                acc.Used_equipment_in_stock__c = '0';
                acc.OwnerId = UserInfo.getUserId();
            }
        }    
    }
}