/**************************************************************************
 * Description  : Apex Class for all the account related business functions
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       17/09/2019      Initial implementation
 **************************************************************************/
public class MAS_AccountService {

    /**
     * @Description This method  calls google api and get the Phoneic text with ascii 
     * @author Samith Perera
     * @params recordId : accountId
     * @name name: accountName
     * @return string
     */
    public static string translateNonAscii(string recordId, string name) {

        String translate = null;
        System.debug(' translateNonAscii 1'+name);
        //REQUEST VALIDATION
        //Remove special characters before send them to google translate API       
        string accounttName = MAS_UtilityHelper.removeSpecialCharactersBeforeTranslate(Name);

        //Call-Out
        translate = MAS_WebServiceCallOut.googleTranslateAPI(recordId, accounttName);

        //RESPONSE VALIDATION
        //Still there could be non ascii characters which should be removed after the translation
        translate = MAS_UtilityHelper.removeNonAsciiwithOtherChars(translate);

        return translate;
    }
    
    /**
     * @Description This method calls google api and get the Phoneic text with ascii 
     * @author Samith Perera
     * @params recordId : accountId
     * @return VOID
     */
    @future(callout=true)
    public static void translateNonAscii(list<Id> recordIds) {

        String translate = null;
        list<Account> toUpdateList = new list<Account>();
        list<ActionLog__c> logList = new list<ActionLog__c>();
        
        for (Account acc : [SELECT Id, Name FROM Account WHERE Id=: recordIds]){
            try {
                //REQUEST VALIDATION
                //Remove special characters before send them to google translate API       
                string accounttName = MAS_UtilityHelper.removeSpecialCharactersBeforeTranslate(acc.Name);

                //Call-Out
                translate = MAS_WebServiceCallOut.googleTranslateAPI(acc.Id, accounttName);

                //COLLECT RESPONSE 
                logList.add(MAS_ActionLog.createLog('MAS_AccountService','translateNonAscii', MAS_Constant.ACTION_LOG_TYPE_TRANSLATE, MAS_Constant.ACTION_LOG_SOURCE_SF, MAS_Constant.ACTION_LOG_TRAGET_GOOGLE, MAS_Constant.ACTION_LOG_STATUS_SUCCESS, MAS_Constant.CONTACT_DML_SUCCESS_MSG, acc, null, acc.Name, translate, null ));

                //RESPONSE VALIDATION
                //Still there could be non ascii characters which should be removed after the translation
                translate = MAS_UtilityHelper.removeNonAsciiwithOtherChars(translate);
                
                if(translate != null){
                    Account account = new Account (Id = acc.Id , Phonetic_Account_Name__c = translate);
                    toUpdateList.add(account);
                }
    
            } catch (Exception ex) {
                 logList.add(MAS_ActionLog.createLog('MAS_AccountService',
                    'translateNonAscii',
                    MAS_Constant.ACTION_LOG_TYPE_TRANSLATE,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_SF,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    acc,
                    null,
                    acc.Name,
                    translate ,
                    ex.getStackTraceString()));   
            }  
        }
        
        // Make trigger excecution stop
        MAS_UtilityHelper.isAccountTriggerRepeat = true;
        database.update (toUpdateList,false);
        database.insert (logList,false);
    }

    /**
     * @Description : This method is used to validate the Account request from mascus
     * @author : Dinesh
     * @params request : Request as a DTO (Account DTO)
     * @return : MAS_ResponseDTO (DTO)
     */
    public static MAS_ResponseDTO validateAccountFromMascus(MAS_AccountWebService.MAS_AccountRequestDTO req) {


        //Create new response object
        MAS_ResponseDTO response = new MAS_ResponseDTO();

        //Get the details of the fields of Account object
        Map < String, Schema.SObjectField > accountFields = Account.getsObjectType().getDescribe().fields.getMap();
        
        //Variables to store field lengths for comparison
        Integer fieldLength = 0;
        Integer requestFieldLength = 0;

        /**
         * @Field : Account Customer ID
         * @Required : Yes
         * **/
        if (req.account_MascusCustomerId != null && !String.isEmpty(req.account_MascusCustomerId)) {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_MASCUS_CUSTOMER_ID).getDescribe().getLength();
            requestFieldLength = req.account_MascusCustomerId.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_121, MAS_Constant.ACCOUNT_ERROR_MSG_121);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_120, MAS_Constant.ACCOUNT_ERROR_MSG_120);
        }


        /**
        * @Field : Status__c
        * @Required : No
        * **/
        if(req.account_Status != null && !String.isEmpty(req.account_Status)) {

            //Get status picklist values into a map
            Map<String,String> accountStatusPickListMap = new Map<String,String>();

            List<Schema.PicklistEntry> accountStatusPicklst = accountFields.get(MAS_Constant.ACCOUNT_STATUS).getDescribe().getPicklistValues();
            if(accountStatusPicklst != null && !accountStatusPicklst.isEmpty()) {
                for(Schema.PicklistEntry pck : accountStatusPicklst) {
                    accountStatusPickListMap.put(pck.getValue(),pck.getValue());
                }
            }
            
            if(accountStatusPickListMap.isEmpty() || !accountStatusPickListMap.containsKey(req.account_Status)) {
                //Picklist value miss-matching
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_131,MAS_Constant.ACCOUNT_ERROR_MSG_131);
            }
            
            if(req.account_Status == MAS_Constant.STATUS_INACTIVE){
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_VALIDATION_SUCCESS_CODE,MAS_Constant.ACCOUNT_VALIDATION_SUCCESS_MSG);
            }
        }


        /**
         * @Field : Account Name
         * @Required : Yes
         * **/
        if (req.account_Name != null && !String.isEmpty(req.account_Name) && req.account_Name != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_NAME).getDescribe().getLength();
            requestFieldLength = req.account_Name.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_102, MAS_Constant.ACCOUNT_ERROR_MSG_102);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_101, MAS_Constant.ACCOUNT_ERROR_MSG_101);
        }

        /**
         * @Field : Account Source
         * @Required : Yes
         * **/
        if (req.account_Source != null && !String.isEmpty(req.account_Source) && req.account_Source != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_SOURCE).getDescribe().getLength();
            requestFieldLength = req.account_Source.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_130, MAS_Constant.ACCOUNT_ERROR_MSG_130);
            }

        } else {
             return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_104, MAS_Constant.ACCOUNT_ERROR_MSG_104);
        }

        /**
         * @Field : Account Industry
         * @Required : Optional
         * **/
        if (req.account_Industry != null && !String.isEmpty(req.account_Industry) && req.account_Industry != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_INDUSTRY).getDescribe().getLength();
            requestFieldLength = req.account_Industry.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_105, MAS_Constant.ACCOUNT_ERROR_MSG_105);
            }
        }

        /**
         * @Field : Account Billing Street
         * @Required : Yes
         * **/
        if (req.account_BillingStreet != null && !String.isEmpty(req.account_BillingStreet) && req.account_BillingStreet != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_BILLING_STREET).getDescribe().getLength();
            requestFieldLength = req.account_BillingStreet.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_107, MAS_Constant.ACCOUNT_ERROR_MSG_107);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_106, MAS_Constant.ACCOUNT_ERROR_MSG_106);
        }

        /**
         * @Field : Account Billing City
         * @Required : Yes
         * **/
        if (req.account_BillingCity != null && !String.isEmpty(req.account_BillingCity) && req.account_BillingCity != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_BILLING_CITY).getDescribe().getLength();
            requestFieldLength = req.account_BillingCity.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_109, MAS_Constant.ACCOUNT_ERROR_MSG_109);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_108, MAS_Constant.ACCOUNT_ERROR_MSG_108);
        }

        /**
         * @Field : Account Billing state
         * @Required : Optional
         * **/
        if (req.account_BillingStateOrProvince != null && !String.isEmpty(req.account_BillingStateOrProvince) && req.account_BillingStateOrProvince != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_BILLING_STATE).getDescribe().getLength();
            requestFieldLength = req.account_BillingStateOrProvince.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_110, MAS_Constant.ACCOUNT_ERROR_MSG_110);
            }
        }

        /**
         * @Field : Account Billing Postal Code
         * @Required : Yes
         * **/
        if (req.account_BillingZipOrPostalCode != null && !String.isEmpty(req.account_BillingZipOrPostalCode) && req.account_BillingZipOrPostalCode != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_BILLING_POSTAL_CODE).getDescribe().getLength();
            requestFieldLength = req.account_BillingZipOrPostalCode.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_112, MAS_Constant.ACCOUNT_ERROR_MSG_112);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_111, MAS_Constant.ACCOUNT_ERROR_MSG_111);
        }

        /**
         * @Field : Account Billing Country
         * @Required : Yes
         * **/
        if (req.account_BillingCountry != null && !String.isEmpty(req.account_BillingCountry) && req.account_BillingCountry != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_BILLING_COUNTRY).getDescribe().getLength();
            requestFieldLength = req.account_BillingCountry.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_114, MAS_Constant.ACCOUNT_ERROR_MSG_114);
            }
            
            string billingCountry = null;
            Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
               if(f.getValue() == req.account_BillingCountry){
                    billingCountry = f.getLabel();
                    continue; 
                }
            }
            
            if(billingCountry == null){
                 return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_118, MAS_Constant.ACCOUNT_ERROR_MSG_118);
            }else{
                req.account_BillingCountry =  billingCountry;
            }
            
      
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_113, MAS_Constant.ACCOUNT_ERROR_MSG_113);
        }

         /**
         * @Field : Account Billing Phone
         * @Required : Yes
         * **/
       if (req.account_PhoneNumber != null && !String.isEmpty(req.account_PhoneNumber) && req.account_PhoneNumber != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_PHONE).getDescribe().getLength();
            requestFieldLength = req.account_PhoneNumber.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_116, MAS_Constant.ACCOUNT_ERROR_MSG_116);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_115, MAS_Constant.ACCOUNT_ERROR_MSG_115);
        }

        /**
         * @Field : Account Email for Invoicing
         * @Required : Yes
         * **/
        if (req.account_EmailForInvoicing != null && !String.isEmpty(req.account_EmailForInvoicing)) {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_EMAIL_FOR_INVOICING).getDescribe().getLength();
            requestFieldLength = req.account_EmailForInvoicing.length();
            if (requestFieldLength > fieldLength) //{
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_127, MAS_Constant.ACCOUNT_ERROR_MSG_127);
            //}else if(!MAS_UtilityHelper.validateEmail(req.account_EmailForInvoicing)){
                //return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_128, MAS_Constant.ACCOUNT_ERROR_MSG_128);
            //}
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_126, MAS_Constant.ACCOUNT_ERROR_MSG_126);
        }

        /**
         * @Field : Account Classification
         * @Required : Yes
         * **/
        if (req.account_Classification != null && !String.isEmpty(req.account_Classification) && req.account_Classification != 'null'){ 
            
            //Get contact role picklist value as a map
            List<Schema.PicklistEntry> lstPickListValues = accountFields.get(MAS_Constant.ACCOUNT_CLASIFICATION).getDescribe().getPicklistValues();
            
            //Map for clasification picklist validation
            Map<String,String> mapAccClasificationPickListValues = new Map<String,String>();
            
            if(lstPickListValues != null && !lstPickListValues.isEmpty()) {
                for(Schema.PicklistEntry pck : lstPickListValues) {
                    mapAccClasificationPickListValues.put(pck.getValue(),pck.getValue());
                }
            }

            if(mapAccClasificationPickListValues.isEmpty() || !mapAccClasificationPickListValues.containsKey(req.account_Classification)) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_125, MAS_Constant.ACCOUNT_ERROR_MSG_125);
            }

        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_117, MAS_Constant.ACCOUNT_ERROR_MSG_117);
        }

        /**
         * @Field : Account VAT number
         * @Required : Optional
         * **/
        if (req.account_VATNumber != null && !String.isEmpty(req.account_VATNumber) && req.account_VATNumber != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_VAT_NUMBER).getDescribe().getLength();
            requestFieldLength = req.account_VATNumber.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_122, MAS_Constant.ACCOUNT_ERROR_MSG_122);
            }
        }

        /**
         * @Field : Account Private tax number
         * @Required : Optional
         * **/
        if (req.account_PrivateTaxNumber != null && !String.isEmpty(req.account_PrivateTaxNumber) && req.account_PrivateTaxNumber != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_PRIVATE_TAX_NUMBER).getDescribe().getLength();
            requestFieldLength = req.account_PrivateTaxNumber.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_123, MAS_Constant.ACCOUNT_ERROR_MSG_123);
            }
        }

        /**
         * @Field : Account Mascus customer number
         * @Required : Optional
         * **/
        if (req.account_MascusCustomerNumber != null && !String.isEmpty(req.account_MascusCustomerNumber)) {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_MASCUS_CUSTOMER_NUMBER).getDescribe().getLength();
            requestFieldLength = req.account_MascusCustomerNumber.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_139, MAS_Constant.ACCOUNT_ERROR_MSG_139);
            }
        }

        /**
         * @Field : Account phone prefix
         * @Required : Yes
         * **/
        if (req.account_PhonePrefix != null && !String.isEmpty(req.account_PhonePrefix) && req.account_PhonePrefix != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_PHONE_PREFIX).getDescribe().getLength();
            requestFieldLength = req.account_PhonePrefix.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_133, MAS_Constant.ACCOUNT_ERROR_MSG_133);
            }
        } else {
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_132, MAS_Constant.ACCOUNT_ERROR_MSG_132);
        }

        /**
         * @Field : Account parent
         * @Required : Optional
         * **/
        if (req.account_Parent != null && !String.isEmpty(req.account_Parent) && req.account_Parent != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_PARENT_ID).getDescribe().getLength();
            requestFieldLength = req.account_Parent.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_142, MAS_Constant.ACCOUNT_ERROR_MSG_142);
            }
            else{
                List <Account> lstParentAccounts = [SELECT Id from Account WHERE Mascus_Customer_Number__c =: req.account_Parent];
                if (!lstParentAccounts.isEmpty()) {
                    req.account_Parent  = lstParentAccounts[0].Id;
                }else{
                    return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_142, MAS_Constant.ACCOUNT_ERROR_MSG_142);
                }
            }
        }

        /**
         * @Field : Account shipping street
         * @Required : Optional
         * **/
        if (req.account_ShippingStreet != null && !String.isEmpty(req.account_ShippingStreet) && req.account_ShippingStreet != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_SHIPPING_STREET).getDescribe().getLength();
            requestFieldLength = req.account_ShippingStreet.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_134, MAS_Constant.ACCOUNT_ERROR_MSG_134);
            }
        }

        /**
         * @Field : Account shipping city
         * @Required : Optional
         * **/
        if (req.account_ShippingCity != null && !String.isEmpty(req.account_ShippingCity) && req.account_ShippingCity != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_SHIPPING_CITY).getDescribe().getLength();
            requestFieldLength = req.account_ShippingCity.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_135, MAS_Constant.ACCOUNT_ERROR_MSG_135);
            }
        }

        /**
         * @Field : Account shipping state
         * @Required : Optional
         * **/
        if (req.account_ShippingState != null && !String.isEmpty(req.account_ShippingState) && req.account_ShippingState != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_SHIPPING_STATE).getDescribe().getLength();
            requestFieldLength = req.account_ShippingState.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_136, MAS_Constant.ACCOUNT_ERROR_MSG_136);
            }
        }

        /**
         * @Field : Account shipping postal code
         * @Required : Optional
         * **/
        if (req.account_ShippingPostalCode != null && !String.isEmpty(req.account_ShippingPostalCode) && req.account_ShippingPostalCode != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_SHIPPING_POSTAL_CODE).getDescribe().getLength();
            requestFieldLength = req.account_ShippingPostalCode.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_137, MAS_Constant.ACCOUNT_ERROR_MSG_137);
            }
        }

         /**
         * @Field : Account shipping country
         * @Required : Optional
         * **/
        if (req.account_ShppingCountry != null && !String.isEmpty(req.account_ShppingCountry) && req.account_ShppingCountry != 'null') {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_SHIPPING_COUNTRY).getDescribe().getLength();
            requestFieldLength = req.account_ShppingCountry.length();
            if (requestFieldLength > fieldLength) {
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_138, MAS_Constant.ACCOUNT_ERROR_MSG_138);
            }

            string shippingCountry = null;
            Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
               if(f.getValue() == req.account_ShppingCountry){
                    shippingCountry = f.getLabel();
                    continue; 
                }
            }
            
            if(shippingCountry == null){
                 return MAS_UtilityHelper.addResponseStatus(MAS_Constant.ACCOUNT_ERROR_CODE_140, MAS_Constant.ACCOUNT_ERROR_MSG_140);
            }else{
                req.account_ShppingCountry =  shippingCountry;
            }
        }

        response.responseCode = MAS_Constant.ACCOUNT_VALIDATION_SUCCESS_CODE;
        response.responseMessage = MAS_Constant.ACCOUNT_VALIDATION_SUCCESS_MSG;

        return response;
    }

    /**
     * @Description : This method is used to upsert Account request from mascus
     * @author : Dinesh
     * @params request : Request response DTO
     * @return : Boolean
     */
    public static MAS_ResponseDTO upsertAccountFromMascus(MAS_AccountWebService.MAS_AccountRequestDTO req) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        Account account = new Account();
        boolean isInsert = true;

        try {
           
            if(req.account_MascusCustomerNumber != null && req.account_MascusCustomerNumber != ''){
                List <Account> lstAccounts = [SELECT Id from Account WHERE Mascus_Customer_Number__c =: req.account_MascusCustomerNumber];
                if (!lstAccounts.isEmpty()) {
                    account.Id = lstAccounts[0].Id;
                    isInsert = false;
                }
            }

            if(req.account_Status == MAS_Constant.STATUS_INACTIVE){
                account.Status__c = req.account_Status;
            }else{
                account.Name = req.account_Name;
                account.AccountSource = req.account_Source;
                account.Industry = req.account_Industry;
                account.BillingStreet = req.account_BillingStreet;
                account.BillingCity = req.account_BillingCity;
                //account.BillingState = req.account_BillingStateOrProvince;
                account.BillingPostalCode = req.account_BillingZipOrPostalCode;
                account.BillingCountry = req.account_BillingCountry;
                account.Phone = req.account_PhoneNumber;
                account.Email_for_invoicing__c = req.account_EmailForInvoicing;
                account.Classification__c = req.account_Classification;
                account.Mascus_customer_ID__c = req.account_MascusCustomerId; 
                account.VAT_Number__c = req.account_VATNumber;
                account.Private_Tax_Number__c = req.account_PrivateTaxNumber;
                account.Phone_Prefix__c = req.account_PhonePrefix;
                account.ShippingStreet = req.account_ShippingStreet;
                account.ShippingCity = req.account_ShippingCity;
                //account.ShippingState = req.account_ShippingState;
                account.ShippingPostalCode = req.account_ShippingPostalCode;
                account.ShippingCountry = req.account_ShppingCountry;
                
                if(req.account_Parent != null && req.account_Parent != 'null')
                     account.ParentId  = req.account_Parent;

                if(req.account_Owner != null && req.account_Owner != ''){
                    string ownerId  = MAS_UtilityHelper.getUserIdFromMascus(req.account_Owner);
                    if(ownerId != null && ownerId != '')
                        account.ownerId = ownerId;
                }
            }

            //upsert account & eforce not to run duplicate rules
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult sr;
            
            if(isInsert)
                sr = Database.insert(account, dml);
            else
                sr = Database.update(account, dml);

            if (sr.isSuccess()) {

                account = [SELECT Id, Mascus_Customer_Number__c FROM Account WHERE Id =: account.Id LIMIT 1];

                response.responseCode = MAS_Constant.ACCOUNT_DML_SUCCESS_CODE;
                response.responseMessage = MAS_Constant.ACCOUNT_DML_SUCCESS_MSG;
                response.responseResult = new list<MAS_ResponseDTO.ResponseData>();
                response.responseResult.add(MAS_UtilityHelper.addResponseResult('Mascus_Customer_Number__c',account.Mascus_Customer_Number__c));
            }else{
                system.debug(sr.getErrors()[0].getMessage());
                response.responseCode = MAS_Constant.ACCOUNT_ERROR_CODE_124;
                response.responseMessage = MAS_Constant.ACCOUNT_ERROR_MSG_124 + sr.getErrors()[0].getMessage();
            }

        } catch (Exception ex) {
            response.responseCode = MAS_Constant.ACCOUNT_ERROR_CODE_124;
            response.responseMessage = MAS_Constant.ACCOUNT_ERROR_MSG_124 + ' : ' + ex.getMessage() + ' : Line No : ' + ex.getLineNumber(); 

            //Add log
            MAS_ActionLog.createErrorLog('MAS_AccountService',
                        'upsertAccountFromMascus',
                        isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        ex.getMessage(),
                        account,
                        req.account_MascusCustomerId,
                        JSON.serialize(req),
                        JSON.serialize(response),
                        ex.getStackTraceString()
            );
        }

        //Add log
        if(response.responseCode.equals(MAS_Constant.ACCOUNT_DML_SUCCESS_CODE)){
            MAS_ActionLog.createErrorLog('MAS_AccountService',
                        'upsertAccountFromMascus',
                        isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                        MAS_Constant.CONTACT_DML_SUCCESS_MSG,
                        account,
                        req.account_MascusCustomerId,
                        JSON.serialize(req),
                        JSON.serialize(response),
                        null
            );
        }

        return response;
    }

    /**
     * @Description   This method is used for sync accout with mascus
     * @author : Dinesh
     * @params 
     * @return VOID
     */
    @future(callout=true)
    public static void syncAccountWithMascusWeb(list<Id>recordIds) {
       
        list<Account> toUpdateList = new list<Account>();
        list<ActionLog__c> logList = new list<ActionLog__c>();
        String accountStringXml;

        string sessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();
        
        for (Account acc : [SELECT Id, Name, VAT_Number__c, BillingCountry, BillingStreet, 
                            BillingPostalCode, BillingCity, BillingState, 
                            Phone, Email_for_invoicing__c, Website, Mascus_customer_ID__c, BillingCountryCode,
                            Parent.Mascus_customer_ID__c, Classification__c, Mascus_Customer_Number__c, LastModifiedById,
                            LastModifiedBy.Mascus_User_Number__c, Phone_Prefix__c, ShippingCountryCode, ShippingStreet,
                            ShippingPostalCode, ShippingCity, ShippingState, OwnerId, Owner.Mascus_User_Number__c, Status__c
                            FROM Account 
                            WHERE Id=: recordIds]){
            try { 
                    //Create xml
                    accountStringXml = generateAccountUpdateXml(acc);

                    //Call out
                    servicesMascusComApi2.ArrayOfString returnArrayString = new servicesMascusComApi2.ArrayOfString();
                    returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(sessionId, accountStringXml, acc);

                    List<String> response = returnArrayString.string_x;
    
                    //Collect logs
                    if(response.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)){

                        acc.Mascus_Sync_Status__c = MAS_Constant.STATUS_SYNCED;
                        acc.Mascus_Sync_Status_Description__c = response.get(1);
                        acc.Mascus_customer_ID__c = response.get(2);
                        
                        logList.add(MAS_ActionLog.createLog('MAS_AccountService',
                        'syncAccountWithMascusWeb',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                        MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                        response.get(0),
                        acc,
                        null,
                        accountStringXml,
                        string.valueof(returnArrayString),
                        null ));
                    }else{

                        acc.Mascus_Sync_Status__c = MAS_Constant.STATUS_NEED_TO_BE_SYNCED;
                        acc.Mascus_Sync_Status_Description__c = response.get(1);

                        logList.add(MAS_ActionLog.createLog('MAS_AccountService',
                        'syncAccountWithMascusWeb',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        null,
                        acc,
                        null,
                        accountStringXml,
                        string.valueof(returnArrayString),
                        null ));
                    }

                    toUpdateList.add(acc);
                
                }catch (Exception ex) {

                    //Add log
                     logList.add(MAS_ActionLog.createLog('MAS_AccountService',
                                'syncAccountWithMascusWeb',
                                MAS_Constant.ACTION_LOG_TYPE_INSERT,
                                MAS_Constant.ACTION_LOG_SOURCE_SF,
                                MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                                MAS_Constant.ACTION_LOG_STATUS_FAILED,
                                ex.getMessage(),
                                acc,
                                null,
                                accountStringXml,
                                null,
                                ex.getStackTraceString()
                    ));
                }
        }

        // Make trigger excecution stop
        MAS_UtilityHelper.isAccountTriggerRepeat = true;
        database.update(toUpdateList,false);
        database.insert (logList,false);        
    }

    /**
    * @Description: Sync Lead Fields with Mascus Account
    * @author: Malinda
    * @params: List of Leads
    * @return: VOID
    */
    @future(callout=true)
    public static void syncLeadAccountWithMascus(String strJsonString) {
        
        Account acc = null;
        list<Account> toUpdateList = new list<Account>();
        list<ActionLog__c> logList = new list<ActionLog__c>();
        Map<String,Account> mapAccounts = new Map<String,Account>();
        set<String> setMascusIds = new  Set<String>();
        List<Lead> lstLeads = (List<Lead>) JSON.deserialize(strJsonString, List<Lead>.class);
        String accountStringXml;

        if(lstLeads != null && !lstLeads.isEmpty()) {

            for(Lead lead : lstLeads) {
                setMascusIds.add(lead.Mascus_Account_ID__c);
            }

            //Get Accounts
            for(Account acc1 : [SELECT Id, Name, VAT_Number__c, BillingCountry, BillingStreet,
                                BillingPostalCode, BillingCity, BillingState,
                                Phone, Email_for_invoicing__c, Website, Mascus_customer_ID__c, BillingCountryCode,
                                Parent.Mascus_customer_ID__c, Classification__c, Mascus_Customer_Number__c, LastModifiedById,
                                LastModifiedBy.Mascus_User_Number__c, Phone_Prefix__c, ShippingCountryCode, ShippingStreet,
                                ShippingPostalCode, ShippingCity, ShippingState, OwnerId, Owner.Mascus_User_Number__c
                                FROM Account WHERE Mascus_customer_ID__c IN: setMascusIds ]) {
                mapAccounts.put(acc1.Mascus_customer_ID__c,acc1);

            }

            string sessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();
            
            for(Lead lead : lstLeads) {

                try {

                    acc = mapAccounts.get(lead.Mascus_Account_ID__c);
                    acc.Name = lead.Company == null ? acc.Name : lead.Company;
                    acc.Phone_Prefix__c = lead.Phone_Prefix__c == null ? acc.Phone_Prefix__c : lead.Phone_Prefix__c;
                    acc.Phone = lead.Phone == null ? acc.Phone : lead.Phone;
                    acc.BillingStreet  = lead.Street == null ? acc.BillingStreet : lead.Street;
                    acc.BillingState = lead.State == null ? acc.BillingState : lead.State;
                    acc.BillingPostalCode = lead.PostalCode == null ?  acc.BillingPostalCode : lead.PostalCode;
                    acc.BillingCountryCode = lead.CountryCode == null ? acc.BillingCountryCode : lead.CountryCode;

                    //Create xml
                    accountStringXml = generateAccountUpdateXml(acc);

                    //Call out
                    servicesMascusComApi2.ArrayOfString returnArrayString = new servicesMascusComApi2.ArrayOfString();
                    returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(sessionId, accountStringXml, acc);

                    List<String> response = returnArrayString.string_x;
            
                    //Collect logs
                    if(response.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)){
                        //Nothing to update
                        logList.add(MAS_ActionLog.createLog('MAS_AccountService',
                        'SyncLeadAccountWithMascus',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                        MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                        response.get(0),
                        lead,
                        null,
                        accountStringXml,
                        string.valueof(returnArrayString),
                        null ));
                    }else{

                        logList.add(MAS_ActionLog.createLog('MAS_AccountService',
                        'SyncLeadAccountWithMascus',
                        MAS_Constant.ACTION_LOG_TYPE_INSERT,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        null,
                        lead,
                        null,
                        accountStringXml,
                        string.valueof(returnArrayString),
                        null ));
                    }

                    toUpdateList.add(acc);

                }catch (Exception ex) {

                    //Add log
                    MAS_ActionLog.createErrorLog('MAS_AccountService',
                                'SyncLeadAccountWithMascus',
                                MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                                MAS_Constant.ACTION_LOG_SOURCE_SF,
                                MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                                MAS_Constant.ACTION_LOG_STATUS_FAILED,
                                ex.getMessage(),
                                lead,
                                null,
                                accountStringXml,
                                null,
                                ex.getStackTraceString()
                    );
                }
            }
        }

        // Make trigger excecution stop
        //MAS_UtilityHelper.isAccountTriggerRepeat = true;
        //database.update(toUpdateList,false);
        database.insert (logList,false);

    }

    /**
     * @Description: Generate the XML formatted account request data for outbound service call
     * @author: Dinesh W
     * @params: account : Account object       
     * @return: XML formatted string
     */
    public static String generateAccountUpdateXml(Account account){
        
        system.debug(account);
        system.debug(account.Parent.Mascus_customer_ID__c);
        //Create new XML DOM document
        DOM.Document xmlDocument = new DOM.Document();
        //Creates the XML root element
        dom.XmlNode accountsNode = xmlDocument.createRootElement(MAS_Constant.ACCOUNT_XML_FIELD_ACCOUNTS, null, null);
        //Create XML child element
        dom.XmlNode accountNode = accountsNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_ACCOUNT, null, null);

        string mascus_Customer_Id;
        if(account.Mascus_customer_ID__c == null){
            mascus_Customer_Id = '';
        }else{
            mascus_Customer_Id = account.Mascus_customer_ID__c;
        }
        
        string parent_Mascus_Customer_Id;
        if(account.Parent.Mascus_customer_ID__c == null){
            parent_Mascus_Customer_Id = '';
        }else{
            parent_Mascus_Customer_Id = account.Parent.Mascus_customer_ID__c;
        }

        string status;
        if(account.Status__c == MAS_Constant.STATUS_ACTIVE){
            status = MAS_Constant.ACCOUNT_XML_FIELD_UPDATE;
        }else{
            status = MAS_Constant.ACCOUNT_XML_FIELD_DELETE;
        }
        
        //Create XML elements
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_MASCUS_ID, null, null).addTextNode(String.isBlank(mascus_Customer_Id) ? '' : mascus_Customer_Id);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_SFDC_ID, null, null).addTextNode(account.Mascus_Customer_Number__c == null ? '' : account.Mascus_Customer_Number__c);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_PARENT_MASCUS_ID, null, null).addTextNode(account.Parent.Mascus_customer_ID__c==null ? '' : account.Parent.Mascus_customer_ID__c);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_NAME, null, null).addTextNode(account.Name);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_ACTION, null, null).addTextNode(status);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_VATNUMBER, null, null).addTextNode(account.VAT_Number__c == null ? '' : account.VAT_Number__c);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_COUNTRY, null, null).addTextNode(account.BillingCountryCode == null ? '' : account.BillingCountryCode);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_SHIPPING_COUNTRY, null, null).addTextNode(account.ShippingCountryCode == null ? '' : account.ShippingCountryCode);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_VISITING_ADDRESS, null, null).addTextNode(account.BillingStreet == null ? '' : account.BillingStreet);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_POSTAL_CODE, null, null).addTextNode(account.BillingPostalCode == null ? '' : account.BillingPostalCode);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_CITY, null, null).addTextNode(account.BillingCity == null ? '' : account.BillingCity);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_STATE, null, null).addTextNode(account.BillingState == null ? '' : account.BillingState);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_SHIPPING_ADDRESS, null, null).addTextNode(account.ShippingStreet == null ? '' : account.ShippingStreet);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_SHIPPING_POSTAL_CODE, null, null).addTextNode(account.ShippingPostalCode == null ? '' : account.ShippingPostalCode);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_SHIPPING_CITY, null, null).addTextNode(account.ShippingCity == null ? '' : account.ShippingCity);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_SHIPPING_STATE, null, null).addTextNode(account.ShippingState == null ? '' : account.ShippingState); 
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_MASCUSCONTACT_MASCUS_ID, null, null).addTextNode(account.Owner.Mascus_User_Number__c == null ? '' : account.Owner.Mascus_User_Number__c); 
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_MAINCONTACT_SFID, null, null).addTextNode(''); //Hardcoded for testing : TODO
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_PHONE_PREFIX, null, null).addTextNode(account.Phone_Prefix__c == null ? '' : account.Phone_Prefix__c); 
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_PHONE, null, null).addTextNode(account.Phone == null ? '' : account.Phone);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_EMAIL, null, null).addTextNode(account.Email_for_invoicing__c == null ? '' : account.Email_for_invoicing__c);
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_WEBSITE, null, null).addTextNode(account.Website == null ? '' : account.Website); 
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_ACCOUNT_CLASSIFICATION, null, null).addTextNode(account.Classification__c == null ? '' : account.Classification__c); 
        accountNode.addChildElement(MAS_Constant.ACCOUNT_XML_FIELD_MODIFIER_SFID, null, null).addTextNode(account.LastModifiedBy.Mascus_User_Number__c == null ? '' : account.LastModifiedBy.Mascus_User_Number__c); 
        

        //Create XML string from the XML document
        String accountRequestXml =  xmlDocument.toXmlString();
        return accountRequestXml;
    }

    /**
     * @Description: Vat check for account
     * @author: Samith Perera
     * @params: accountID : Account Id       
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO vatcheckforAccount(Id accountID, Order orderObj){
        MAS_ResponseDTO response = new MAS_ResponseDTO();
        
        // Query Account 
        Account acc = [SELECT Id, 
        					  Name, 
        					  VAT_Number__c, 
        					  Valid_for_international_TAX__c, 
        					  Valid_for_Local_TAX__c,
                              BillingCountryCode, 
                              ShippingCountryCode, 
                              Classification__c, 
                              Valid_VAT__c 
                       FROM Account 
                       WHERE Id=: accountID];
        
        system.debug('acc record: ' + acc);
        
        // Skip VAT validation if valid local or valid international checkboxes are checked 
        if(acc.Valid_for_international_TAX__c ||  acc.Valid_for_Local_TAX__c){
            response.responseMessage  = Label.LBL_SUCS_ACC_VATValidLocalInternational;
            response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
            return response;
        }
        
        //Do not call VIES api when activating order if valid_vat is set 
        if(orderObj != null && acc.Valid_VAT__c){
        	response.responseMessage = Label.LBL_SUCS_ACC_VATValSuccess;
	        response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;	        
	        return response;
        }
        
        // EU member check - Custom setting
        string countryCode = (orderObj == null ? acc.BillingCountryCode : orderObj.BillingCountryCode);        
        boolean isEuCountry = false;
        
        for(EU_Member_Country__c euCountry : EU_Member_Country__c.getall().values()){
            if(euCountry.Country_Code__c.equals(countryCode)){
                isEuCountry = true;
                break;
            }
        }

        if(!isEuCountry){
        	if(orderObj == null){
            	response.responseMessage = Label.LBL_ERR_ACC_CountryEU;
            	response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
        	}else{
        		response.responseMessage = Label.LBL_SUCS_ACC_VATValSuccess;
	            response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
        	}
            return response;
        }
        
        system.debug('countryCode: ' + countryCode);   
        
        // Vat number should not be blank
        if(acc.VAT_Number__c == null){
            response.responseMessage  = Label.LBL_ERR_ACC_VATEmpty;
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            return response;
        }
        
        // Account Billing Country is required for VAT check        
        if(acc.BillingCountryCode == null){
            response.responseMessage  = Label.LBL_ERR_ACC_CusCountry;
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            return response;
        }        
        
        Account legalEntity = null;
        string legalEntityBillingCountryCode = null;
        string legalEntityVatNumber  = null;                
       
       	system.debug(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ACCOUNT_ACCOUNT_TYPE_LEGAL_ENTITY));
        
        if(orderObj == null){
        	Account internalLegalEntity = null;
        	Account licensee = null;
	        List<Account> legalEntities = [SELECT Id, 
	        					  VAT_Number__c, 
	        					  BillingCountryCode, 
	        					  Classification__c, 
	        					  Type 
	                        FROM Account 
	                        WHERE BillingCountryCode =: countryCode
	                        AND RecordType.Name =: MAS_Constant.ACCOUNT_ACCOUNT_RECORD_TYPE];
	                        
			if(legalEntities.size() > 0){
				for(Account le : legalEntities){
					if(le.Type == MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ACCOUNT_ACCOUNT_TYPE_LEGAL_ENTITY)){
						internalLegalEntity = le;
					}
					else if(le.Type == MAS_Constant.ACCOUNT_ACCOUNT_TYPE_LICENSEE){
						licensee = le;
					}
				}
			}
			
			if(internalLegalEntity != null)
				legalEntity = internalLegalEntity;
			else if(licensee != null)
				legalEntity = null;
			else{				 
				Map<String, String> mapCountryNameToLegalEntityName = new Map<String, String>();
				String legalEntityName = '';
				
				for(CountriesWithNoLegalEntity__mdt c : [Select MasterLabel, InternalLegalEntityName__c, CountryCode__c From CountriesWithNoLegalEntity__mdt Where CountryCode__c =: countryCode OR CountryCode__c = null ]){
					mapCountryNameToLegalEntityName.put(c.CountryCode__c, c.InternalLegalEntityName__c);
				}
				
				if(mapCountryNameToLegalEntityName.containsKey(countryCode)){
					legalEntityName = mapCountryNameToLegalEntityName.get(countryCode);
				}else{
					legalEntityName = mapCountryNameToLegalEntityName.get(null);
				}
				
				legalEntity = [SELECT Id, 
									  VAT_Number__c, 
									  BillingCountryCode, 
									  Classification__c, 
									  Type 
									  FROM Account 
									  WHERE Name =: legalEntityName limit 1];
			}				                        
        }else{
        	legalEntity = orderObj.Bill_from_legal_entity__r;
        }
             
        if(legalEntity == null){ //'No legal entity found'
        	response.responseMessage  = Label.LBL_ERR_ACC_NoLegalEntity;
            response.responseType =  MAS_Constant.RESPONSE_TYPE_ERROR;
            return response;             	
        }else if(legalEntity.VAT_Number__c == null){ //'Legal entity vat number can not be empty';
        	response.responseMessage = Label.LBL_ERR_ACC_NoLegalEntityVAT; 
            response.responseType =  MAS_Constant.RESPONSE_TYPE_ERROR;
            return response;
        }else{
        	legalEntityBillingCountryCode  = legalEntity.BillingCountryCode;
         	legalEntityVatNumber = legalEntity.VAT_Number__c;
        }
        
        system.debug('legalEntityBillingCountryCode: ' + legalEntityBillingCountryCode);      
        system.debug('legalEntityVatNumber: ' + legalEntityVatNumber);
        
        try {
            // Fill vat request
            MAS_VATRequestDTO vatRequestDTO = new MAS_VATRequestDTO();
            vatRequestDTO.tax_type = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ACCOUNT_ACCOUNT_TAX_TYPE_VAT);
            vatRequestDTO.tax_number = acc.VAT_Number__c.right(acc.VAT_Number__c.length() - 2);
            vatRequestDTO.country_code = acc.BillingCountryCode;
            vatRequestDTO.test_mode = Boolean.valueOf(MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.ACCOUNT_ACCOUNT_TEST_MODE));
            vatRequestDTO.requester_country_code = legalEntityBillingCountryCode;           	
            vatRequestDTO.requester_tax_number = legalEntityVatNumber.right(legalEntityVatNumber.length() - 2);
            			
            system.debug('####VATDTO: ' + vatRequestDTO);

            // Callout
            string viesResponse = MAS_WebServiceCallOut.mascusVatServiceInvoke(vatRequestDTO);

            system.debug('####Response from VIES: '+ viesResponse);
            
            MAS_VATResponseDTO vatResponseDTO = (MAS_VATResponseDTO)JSON.deserialize(viesResponse, MAS_VATResponseDTO.class);

            if(vatResponseDTO != null && vatResponseDTO.request_status == MAS_Constant.VAT_SERVICE_RESONSE_SUCCESS){
                
                VAT_response_check__c vatResponseCheck  = new VAT_response_check__c();
                
                vatResponseCheck.Request_Date__c =  Date.today();
                vatResponseCheck.Request_ID__c = vatResponseDTO.request_id;
                vatResponseCheck.Request_Status__c = vatResponseDTO.request_status;
                vatResponseCheck.Trader_Address__c = vatResponseDTO.trader_address;
                vatResponseCheck.Trader_Company_Type__c = vatResponseDTO.trader_company_type;
                vatResponseCheck.Trader_Name__c = vatResponseDTO.trader_name;
                vatResponseCheck.Valid__c = Boolean.valueOf(vatResponseDTO.valid);
                vatResponseCheck.VAT_Number__c = vatResponseDTO.tax_number;
                vatResponseCheck.Customer_ID__c = AccountId;
                
                insert vatResponseCheck;        

                if(!Boolean.valueOf(vatResponseDTO.valid)){
                    acc.Valid_VAT__c = false;
                    response.responseMessage = Label.LBL_ERR_ACC_InvalidVATReCheck;
                    response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                }else{         	                	                	
                	if(vatResponseDTO.trader_name != acc.Name && !acc.Valid_VAT__c){
                		response.responseMessage = Label.LBL_ERR_ACC_VATAccountName; //'Please update the account name and re-check VAT';
                        response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;                		
                	}else{
                		acc.Valid_VAT__c = true;                		
	                    acc.VAT_Request_ID__c = vatResponseDTO.request_id; 
	                    response.responseMessage = Label.LBL_SUCS_ACC_VATValSuccess;
	                    response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
                	}
                }
            }else{
                acc.Valid_VAT__c = false;
                response.responseMessage = Label.LBL_ERR_ACC_InvalidVAT;
                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
            }
                
            update acc;
            

        }catch (Exception ex) {
            //Add log
            system.debug(ex.getMessage());
            MAS_ActionLog.createErrorLog('MAS_AccountService',
                        'vatcheckforAccount',
                        MAS_Constant.ACTION_LOG_TYPE_VATCHECK,
                        MAS_Constant.ACTION_LOG_SOURCE_SF,
                        MAS_Constant.ACTION_LOG_TRAGET_BOOMI,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        ex.getMessage(),
                        acc,
                        null,
                        null,
                        null,
                        ex.getStackTraceString()
            );

            response.responseMessage = Label.LBL_ERR_ACC_GenError;
            response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
        }
        
        return response;
    }


    /**
     * @Description: Phonetic name check for related acounts
     * @author: Samith Perera
     * @params: list<Id> : AccountIds       
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO validateAccountForOrder(list<Id> accountIdList){

        MAS_ResponseDTO response  = new MAS_ResponseDTO();

        for(Account accObj : [ SELECT Id, Phonetic_Account_Name__c, Status__c from Account WHERE Id=: accountIdList]){

            if (accObj.Phonetic_Account_Name__c == null || accObj.Phonetic_Account_Name__c == '' ){

                response.responseMessage  = Label.LBL_ERR_ACC_PHONETIC_NAME_EMPTY;
                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                return response;
            }

            if (accObj.Status__c!= MAS_Constant.STATUS_ACTIVE){

                response.responseMessage  = Label.LBL_ERR_ACC_PHONETIC_ACCOUNTS_INACTIVE;
                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                return response;
            }
        }

        response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
        return response;
    }
    
}