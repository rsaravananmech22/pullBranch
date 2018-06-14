/**************************************************************************
 * Description  : Apex service for contact related business functions
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       09/10/2017      Initial implementation
 **************************************************************************/
public class MAS_ContactService {

    /**
     * @Description This method  calls google api and get the Phoneic text with ascii 
     * @author Samith Perera
     * @params recordId : contactId
     * @name name: conatactName
     * @return string
     */
    public static string translateNonAscii(string recordId, string name){
        
       String translate = null;
        
       //REQUEST VALIDATION
       //Remove special characters before send them to google translate API       
       string contactName = MAS_UtilityHelper.removeSpecialCharactersBeforeTranslate(Name);
       
       //Call-Out
       translate = MAS_WebServiceCallOut.googleTranslateAPI(recordId, contactName);                  

       //RESPONSE VALIDATION
       //Still there could be non ascii characters which should be removed after the translation
       translate = MAS_UtilityHelper.removeNonAsciiwithOtherChars(translate);  
       return translate;
    
    }
    
    /**
     * @Description This method  calls google api and get the Phoneic text with ascii 
     * @author Samith Perera
     * @params recordId : contactId
     * @return VOID
     */
    @future(callout=true)
    public static void translateNonAscii(list<Id> recordIds){
        
        String translateFirstName, translateLastName, state;
        list<contact> toUpdateList = new list<contact>();
        list<ActionLog__c> logList = new list<ActionLog__c>();
        
       for(Contact con :[SELECT Id, FirstName, LastName, Phonetic_Contact_First_Name__c, Phonetic_Contact_Last_Name__c FROM Contact WHERE Id =: recordIds ]){
           
            translateFirstName = null;
            translateLastName = null;
            state = null;
           
           try{
                if(con.Phonetic_Contact_First_Name__c == null || con.Phonetic_Contact_First_Name__c.equals(Label.MAS_MSG_Phonetic_Name_Update)){   
                    state = MAS_Constant.STATE_FIRSTNAME;

                    //REQUEST VALIDATION
                    //Remove special characters before send them to google translate API       
                    string contactFirstName = MAS_UtilityHelper.removeSpecialCharactersBeforeTranslate(con.FirstName);
                    
                    //Call-Out
                    translateFirstName = MAS_WebServiceCallOut.googleTranslateAPI(con.Id, contactFirstName); 

                    //COLLECT REQUEST/RESPONSE
                    logList.add(MAS_ActionLog.createLog('MAS_ContactService','translateNonAscii', MAS_Constant.ACTION_LOG_TYPE_TRANSLATE, MAS_Constant.ACTION_LOG_SOURCE_SF, MAS_Constant.ACTION_LOG_TRAGET_GOOGLE, MAS_Constant.ACTION_LOG_STATUS_SUCCESS, MAS_Constant.CONTACT_DML_SUCCESS_MSG, con, null, con.FirstName, translateFirstName, null ));

                    //RESPONSE VALIDATION
                    //Still there could be non ascii characters which should be removed after the translation
                    translateFirstName = MAS_UtilityHelper.removeNonAsciiwithOtherChars(translateFirstName);

                    if(translateFirstName != null)
                        con.Phonetic_Contact_First_Name__c = translateFirstName;
                }
               
               if(con.Phonetic_Contact_Last_Name__c == null || con.Phonetic_Contact_Last_Name__c.equals(Label.MAS_MSG_Phonetic_Name_Update)){   
                    state = MAS_Constant.STATE_LASTNAME;

                    //REQUEST VALIDATION
                    //Remove special characters before send them to google translate API       
                    string contactLastName = MAS_UtilityHelper.removeSpecialCharactersBeforeTranslate(con.LastName);

                    //Call-Out
                    translateLastName = MAS_WebServiceCallOut.googleTranslateAPI(con.Id, contactLastName);

                    //COLLECT REQUEST/RESPONSE
                    logList.add(MAS_ActionLog.createLog('MAS_ContactService','translateNonAscii',MAS_Constant.ACTION_LOG_TYPE_TRANSLATE, MAS_Constant.ACTION_LOG_SOURCE_SF, MAS_Constant.ACTION_LOG_TRAGET_GOOGLE, MAS_Constant.ACTION_LOG_STATUS_SUCCESS, MAS_Constant.CONTACT_DML_SUCCESS_MSG, con, null, con.LastName, translateLastName, null ));

                    //RESPONSE VALIDATION
                    //Still there could be non ascii characters which should be removed after the translation
                    translateLastName = MAS_UtilityHelper.removeNonAsciiwithOtherChars(translateLastName);

                    if(translateLastName != null)
                        con.Phonetic_Contact_Last_Name__c = translateLastName;
                }
               
                toUpdateList.add(con);
              
           }catch(Exception ex){
		   system.debug('VC' +  ex.getMessage() + ', Line: ' + ex.getLineNumber() + ', Trace: ' + ex.getStackTraceString());
                logList.add(MAS_ActionLog.createLog('MAS_ContactService',
                    'translateNonAscii',
                    MAS_Constant.ACTION_LOG_TYPE_TRANSLATE,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_SF,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    ex.getMessage(),
                    con,
                    null,
                    state == MAS_Constant.STATE_FIRSTNAME ? con.FirstName : con.LastName,
                    state == MAS_Constant.STATE_FIRSTNAME ? translateFirstName : translateLastName ,
                    ex.getStackTraceString()));
           }
       }
       
        //Make trigger excecution stop
        MAS_UtilityHelper.isContactTriggerRepeat = true;
        database.update (toUpdateList,false);
        database.insert (logList,false);
    }
    
    /**
     * @Description : This method is used to validate the contact request
     * @author : Malinda
     * @params request : Request as a DTO
     * @return : MAS_ResponseDTO (DTO)
     */
    public static MAS_ResponseDTO validateContactFromMascus(MAS_ContactWebService.MAS_ContactRequestDTO request) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        Integer fieldLength = 0;
        Integer requestFieldLength = 0;

        //Get Contact & account  fields with metadata
        Map<String, Schema.SObjectField> contactFields = Contact.getsObjectType().getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> accountFields = Account.getsObjectType().getDescribe().fields.getMap();
        
        /**
        * @Field : Mascus_contact_ID__c
        * @Required : Yes
        * **/
        if(request.contact_MascusGUID != null && !String.isEmpty(request.contact_MascusGUID)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_CUSTOMER_ID).getDescribe().getLength();
            requestFieldLength = request.contact_MascusGUID.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_124,MAS_Constant.CONTACT_ERROR_MSG_124);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_123,MAS_Constant.CONTACT_ERROR_MSG_123);
        }
        
        /**
        * @Field : Status__c
        * @Required : No
        * **/
        if(request.contact_Status != null && !String.isEmpty(request.contact_Status)) {

            //Get status picklist values into a map
            Map<String,String> contactStatusPickListMap = new Map<String,String>();

            List<Schema.PicklistEntry> contactStatusPicklst = contactFields.get(MAS_Constant.CONTACT_STATUS).getDescribe().getPicklistValues();
            if(contactStatusPicklst != null && !contactStatusPicklst.isEmpty()) {
                for(Schema.PicklistEntry pck : contactStatusPicklst) {
                    contactStatusPickListMap.put(pck.getValue(),pck.getValue());
                }
            }
            
            if(contactStatusPickListMap.isEmpty() || !contactStatusPickListMap.containsKey(request.contact_Status)) {
                //Picklist value miss-matching
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_131,MAS_Constant.CONTACT_ERROR_MSG_131);
            }
            
            if(request.contact_Status == MAS_Constant.STATUS_INACTIVE){
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_VALIDATION_SUCCESS_CODE,MAS_Constant.CONTACT_VALIDATION_SUCCESS_MSG);
            }
        }
        
        /**
        * @Field : Mascus_Customer_Number__c
        * @Required : Yes
        * **/
        if(request.contact_AccountId != null && !String.isEmpty(request.contact_AccountId)) {
            fieldLength = accountFields.get(MAS_Constant.ACCOUNT_MASCUS_CUSTOMER_NUMBER).getDescribe().getLength();
            requestFieldLength = request.contact_AccountId.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_101,MAS_Constant.CONTACT_ERROR_MSG_101);
            }else{

              list<Account> accList = [SELECT Id FROM Account WHERE Mascus_Customer_Number__c =: request.contact_AccountId];
              if(!accList.isEmpty()){
                request.contact_AccountId = accList[0].Id;
              }else{
                  return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_129,MAS_Constant.CONTACT_ERROR_MSG_129);
              }
            }  
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_100,MAS_Constant.CONTACT_ERROR_MSG_100);
        }

        /**
        * @Field : Email
        * @Required : Yes
        * **/
        if(request.contact_Email != null && !String.isEmpty(request.contact_Email)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_EMAIL).getDescribe().getLength();
            requestFieldLength = request.contact_Email.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_105,MAS_Constant.CONTACT_ERROR_MSG_105);
            }
            //else {
                //if(!MAS_UtilityHelper.validateEmail(request.contact_Email)) {
                    //Invalid email
                    //return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_106,MAS_Constant.CONTACT_ERROR_MSG_106);
                //}
            //}
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_104,MAS_Constant.CONTACT_ERROR_MSG_104);
        }

        /**
        * @Field : MailingStreet
        * @Required : Yes
        * **/
        if(request.contact_MailingStreet != null && !String.isEmpty(request.contact_MailingStreet)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_MAILING_STREET).getDescribe().getLength();
            requestFieldLength = request.contact_MailingStreet.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_108,MAS_Constant.CONTACT_ERROR_MSG_108);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_107,MAS_Constant.CONTACT_ERROR_MSG_107);
        }

        /**
        * @Field : MailingCity
        * @Required : Yes
        * **/
        if(request.contact_MailingCity != null && !String.isEmpty(request.contact_MailingCity)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_MAILING_STREET).getDescribe().getLength();
            requestFieldLength = request.contact_MailingCity.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_110,MAS_Constant.CONTACT_ERROR_MSG_110);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_109,MAS_Constant.CONTACT_ERROR_MSG_109);
        }

        /**
        * @Field : MailingPostalCode
        * @Required : Yes
        * **/
        if(request.contact_MailingZipOrPostalCode != null && !String.isEmpty(request.contact_MailingZipOrPostalCode)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_MAILING_POSTAL_CODE).getDescribe().getLength();
            requestFieldLength = request.contact_MailingZipOrPostalCode.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_114,MAS_Constant.CONTACT_ERROR_MSG_114);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_113,MAS_Constant.CONTACT_ERROR_MSG_113);
        }

        /**
        * @Field : MailingCountry
        * @Required : Yes
        * **/
        if(request.contact_Mailing_Country != null && !String.isEmpty(request.contact_Mailing_Country)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_MAILING_COUNTRY).getDescribe().getLength();
            requestFieldLength = request.contact_Mailing_Country.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_116,MAS_Constant.CONTACT_ERROR_MSG_116);
            }
            
            string mailingCountry = null;
            Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
               if(f.getValue() == request.contact_Mailing_Country){
                    mailingCountry = f.getLabel();
                    continue; 
                }
            }
            
            if(mailingCountry == null){
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_130, MAS_Constant.CONTACT_ERROR_MSG_130);
            }else{
                request.contact_Mailing_Country =  mailingCountry;
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_115,MAS_Constant.CONTACT_ERROR_MSG_115);
        }

        /**
        * @Field : FirstName
        * @Required : Yes
        * **/
        if(request.contact_FirstName != null && !String.isEmpty(request.contact_FirstName) && request.contact_FirstName!=' ') {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_FIRST_NAME).getDescribe().getLength();
            requestFieldLength = request.contact_FirstName.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_118,MAS_Constant.CONTACT_ERROR_MSG_118);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_117,MAS_Constant.CONTACT_ERROR_MSG_117);
        }

        /**
        * @Field : LastName
        * @Required : Yes
        * **/
        if(request.contact_LastName != null && !String.isEmpty(request.contact_LastName)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_LAST_NAME).getDescribe().getLength();
            requestFieldLength = request.contact_LastName.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_120,MAS_Constant.CONTACT_ERROR_MSG_120);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_119,MAS_Constant.CONTACT_ERROR_MSG_119);
        }

        /**
        * @Field : Phone
        * @Required : Yes
        * **/
        if(request.contact_PhoneNumber != null && !String.isEmpty(request.contact_PhoneNumber)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_PHONE).getDescribe().getLength();
            requestFieldLength = request.contact_PhoneNumber.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_122,MAS_Constant.CONTACT_ERROR_MSG_122);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_121,MAS_Constant.CONTACT_ERROR_MSG_121);
        }

        /**
        * @Field : Contact_role__c
        * @Required : Yes
        * **/
        if(request.contact_Role != null && !String.isEmpty(request.contact_Role)) {
            
            //Get contact role picklist values into a map
            Map<String,String> contactRolePickListMap = new Map<String,String>();
            List<Schema.PicklistEntry> contactRolePicklst = contactFields.get(MAS_Constant.CONTACT_ROLE).getDescribe().getPicklistValues();
            if(contactRolePicklst != null && !contactRolePicklst.isEmpty()) {
                for(Schema.PicklistEntry pck : contactRolePicklst) {
                    contactRolePickListMap.put(pck.getValue(),pck.getValue());
                }
            }
            if(contactRolePickListMap.isEmpty() || !contactRolePickListMap.containsKey(request.contact_Role)) {
                //Picklist value miss-matching
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_128,MAS_Constant.CONTACT_ERROR_MSG_128);
            }
  
        }
        //else {
            // Empty Value error
            //return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_126,MAS_Constant.CONTACT_ERROR_MSG_126);
        //}


        /**
        * @Field : Mascus_Contact_Number__c
        * @Required : No
        * **/
        if(request.contact_MascusContactNumber != null && !String.isEmpty(request.contact_MascusContactNumber)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_MASCUS_CONTACT_NUMBER).getDescribe().getLength();
            requestFieldLength = request.contact_MascusContactNumber.length();

            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_132,MAS_Constant.CONTACT_ERROR_MSG_132);
            }

        }

        /**
        * @Field : Phone_Prefix__c
        * @Required : Yes
        * **/
        if(request.contact_PhonePrefix != null && !String.isEmpty(request.contact_PhonePrefix)) {
            fieldLength = contactFields.get(MAS_Constant.CONTACT_PHONE_PREFIX).getDescribe().getLength();
            requestFieldLength = request.contact_PhonePrefix.length();

            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_133,MAS_Constant.CONTACT_ERROR_MSG_133);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.CONTACT_ERROR_CODE_134,MAS_Constant.CONTACT_ERROR_MSG_134);
        }
        
        //Validation Success
        response.responseCode = MAS_Constant.CONTACT_VALIDATION_SUCCESS_CODE;
        response.responseMessage = MAS_Constant.CONTACT_VALIDATION_SUCCESS_MSG;

        return response;

    }

    /**
     * @Description : This method is used to upsert contact
     * @author : Malinda
     * @params request : Request as a DTO
     * @return : Boolean
     */
    public static MAS_ResponseDTO upsertContactFromMascus(MAS_ContactWebService.MAS_ContactRequestDTO request) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        Contact contact = new Contact();
        boolean isInsert = true;

        try {

            if(request.contact_MascusContactNumber != null && request.contact_MascusContactNumber != ''){
                List<Contact> lstContacts = [SELECT Id FROM Contact WHERE Mascus_Contact_Number__c =: request.contact_MascusContactNumber];
                if(!lstContacts.isEmpty()) {
                    contact.Id = lstContacts[0].Id;
                    isInsert = false;
                }
            }
            
            if(request.contact_Status == MAS_Constant.STATUS_INACTIVE){
                contact.Status__c = request.contact_Status;
            }else{
                contact.AccountId = request.contact_AccountId;
                contact.Email = request.contact_Email;
                contact.MailingStreet = request.contact_MailingStreet;
                contact.MailingCity = request.contact_MailingCity;
                contact.MailingPostalCode = request.contact_MailingZipOrPostalCode;
                contact.MailingCountry = request.contact_Mailing_Country;
                contact.FirstName = request.contact_FirstName;
                contact.LastName = request.contact_LastName;
                contact.Phone = request.contact_PhoneNumber;
                contact.Mascus_contact_ID__c = request.contact_MascusGUID;                
                contact.Phone_Prefix__c = request.contact_PhonePrefix;

                if(request.contact_Role != null  && request.contact_Role != '')
                    contact.Contact_role__c = request.contact_Role;
            }

            //upsert contact & eforce not to run duplicate rules
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult sr;
            
            if(isInsert)
                sr = Database.insert(contact, dml);
            else
                sr = Database.update(contact, dml);

            if (sr.isSuccess()) {
                
                contact = [ SELECT Id, Mascus_Contact_Number__c FROM Contact WHERE Id =: contact.Id LIMIT 1 ];
                
                response.responseCode = MAS_Constant.CONTACT_DML_SUCCESS_CODE;
                response.responseMessage = MAS_Constant.CONTACT_DML_SUCCESS_MSG;
                response.responseResult = new list<MAS_ResponseDTO.ResponseData>();
                response.responseResult.add(MAS_UtilityHelper.addResponseResult('Mascus_Contact_Number__c', contact.Mascus_Contact_Number__c));
            }else{

                response.responseCode = MAS_Constant.CONTACT_ERROR_CODE_125;
                response.responseMessage = MAS_Constant.CONTACT_ERROR_MSG_125 + sr.getErrors()[0].getMessage();
            }

        }
        catch (Exception ex) {
            response.responseCode = MAS_Constant.CONTACT_ERROR_CODE_125;
            response.responseMessage = MAS_Constant.CONTACT_ERROR_MSG_125 + ' : ' + ex.getMessage() + ' : Line No : ' + ex.getLineNumber();
            
            //Add log
            MAS_ActionLog.createErrorLog('MAS_ContactService',
                        'upsertContactFromMascus',
                        isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        ex.getMessage(),
                        contact,
                        request.contact_MascusGUID,
                        JSON.serialize(request),
                        JSON.serialize(response),
                        ex.getStackTraceString()
            );
        }

        //Add log
        if(response.responseCode.equals(MAS_Constant.CONTACT_DML_SUCCESS_CODE)){
            MAS_ActionLog.createErrorLog('MAS_ContactService',
                        'upsertContactFromMascus',
                        isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                        MAS_Constant.CONTACT_DML_SUCCESS_MSG,
                        contact,
                        request.contact_MascusGUID,
                        JSON.serialize(request),
                        JSON.serialize(response),
                        null
            );
        }

        return response;
    }

    /**
     * @Description :This method is used to When account information is changed (created, modified or deleted) in SFDC,
     *                this interface is called to flow the changes to Mascus DB.
     * @author : Malinda
     * @return : void
     */
    @future(callout=true)
    public static void syncContactWithMascusWeb(list<Id> lstRecordIds) {
       

        list<Contact> toUpdateList = new list<Contact>();
        list<ActionLog__c> logList = new list<ActionLog__c>();
        String strContactXml;

        //Getting session id
        string strSessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();
        //Getting inserted contacts
        for(Contact con : [SELECT Id,Mascus_contact_ID__c,Mascus_Contact_Number__c,Account.Mascus_customer_ID__c,
                          FirstName,LastName,MailingCountry,MailingStreet,MailingPostalCode,MailingCity,Phone,Email,
                          MailingCountryCode, Phone_Prefix__c, LastModifiedById, LastModifiedBy.Mascus_User_Number__c
                          FROM Contact 
                          WHERE Id IN: lstRecordIds]) {

            try {
                //Create xml
                strContactXml = generateContactUpdateXml(con);
                
                //Call out
                servicesMascusComApi2.ArrayOfString returnArrayString = new servicesMascusComApi2.ArrayOfString();
                returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(strSessionId, strContactXml, con);

                List<String> response = returnArrayString.string_x;

                //Collect logs
                if(response.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)){
                    
                    con.Mascus_Sync_Status__c = MAS_Constant.STATUS_SYNCED;
                    con.Mascus_Sync_Status_Description__c = response.get(1);
                    con.Mascus_contact_ID__c = response.get(2);

                    logList.add(MAS_ActionLog.createLog('MAS_ContactService',
                    'syncContactWithMascusWeb',
                    MAS_Constant.ACTION_LOG_TYPE_INSERT,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                    response.get(0),
                    con,
                    null,
                    strContactXml,
                    string.valueof(returnArrayString),
                    null ));
                }else{
                    con.Mascus_Sync_Status__c = MAS_Constant.STATUS_NEED_TO_BE_SYNCED;
                    con.Mascus_Sync_Status_Description__c = response.get(1);
                    
                    logList.add(MAS_ActionLog.createLog('MAS_ContactService',
                    'syncContactWithMascusWeb',
                    MAS_Constant.ACTION_LOG_TYPE_INSERT,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    null,
                    con,
                    null,
                    strContactXml,
                    string.valueof(returnArrayString),
                    null ));
                }

                //update with mascus Id
                toUpdateList.add(con);
            }
            catch(Exception ex) {

                 //Add log
                 logList.add(MAS_ActionLog.createLog('MAS_ContactService',
                            'syncContactWithMascusWeb',
                            MAS_Constant.ACTION_LOG_TYPE_INSERT,
                            MAS_Constant.ACTION_LOG_SOURCE_SF,
                            MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                            MAS_Constant.ACTION_LOG_STATUS_FAILED,
                            ex.getMessage(),
                            con,
                            null,
                            strContactXml,
                            null,
                            ex.getStackTraceString()
                ));
            }

        }

        MAS_UtilityHelper.isContactTriggerRepeat = true;
        database.update(toUpdateList,false);
        database.insert (logList,false);
     
    }

    /**
    * @Description: Sync Lead Fields with Mascus Contact
    * @author: Malinda
    * @params: List of Leads
    * @return: VOID
    */
    @future(callout=true)
    public static void syncLeadContactWithMascus(String strJsonString) {

        list<ActionLog__c> logList = new list<ActionLog__c>();
        list<Contact> toUpdateList = new list<Contact>();
        Set<String> setMascusIds = new  Set<String>();
        Map<String,Contact> mapContacts = new Map<String,Contact>();
        Contact contact =  null;
        
        List<Lead> lstLeads = (List<Lead>) JSON.deserialize(strJsonString, List<Lead>.class);

        for(Lead lead : lstLeads) {
            setMascusIds.add(lead.Mascus_contact_ID__c);
        }

        //Getting inserted contacts
        for(Contact con : [SELECT Id,Mascus_contact_ID__c,Mascus_Contact_Number__c,Account.Mascus_customer_ID__c,
                          FirstName,LastName,MailingCountry,MailingStreet,MailingPostalCode,MailingCity,Phone,Email,
                          MailingCountryCode, Phone_Prefix__c, LastModifiedById, LastModifiedBy.Mascus_User_Number__c
                          FROM Contact WHERE Mascus_contact_ID__c IN: setMascusIds]) {

            mapContacts.put(con.Mascus_contact_ID__c,con);

        }
        //Getting session id
        string strSessionId = MAS_WebServiceCallOut.mascusAPIAuthentication();
        String strContactXml;

        for(Lead lead : lstLeads) {

            try {

                contact = mapContacts.get(lead.Mascus_contact_ID__c);
                contact.LastName = lead.LastName == null ? contact.LastName : lead.LastName;
                contact.Phone_Prefix__c = lead.Phone_Prefix__c == null ? contact.Phone_Prefix__c : lead.Phone_Prefix__c;
                contact.Phone = lead.Phone == null ? contact.Phone : lead.Phone;
                contact.MailingStreet = lead.Street ==  null ?  contact.MailingStreet :  lead.Street;
                contact.MailingState = lead.State == null ? contact.MailingState : lead.State;
                contact.MailingPostalCode = lead.PostalCode == null ?  contact.MailingPostalCode : lead.PostalCode;
                contact.MailingCountryCode = lead.CountryCode == null ? contact.MailingCountryCode : lead.CountryCode;

                //Create xml
                strContactXml = generateContactUpdateXml(contact);
                //Call out
                servicesMascusComApi2.ArrayOfString returnArrayString = new servicesMascusComApi2.ArrayOfString();
                returnArrayString = MAS_WebServiceCallOut.mascusServiceInvoke(strSessionId, strContactXml, contact);

                List<String> response = returnArrayString.string_x;

                //Collect logs
                if(response.get(0).equals(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE)){
                    //Nothing to update
                    logList.add(MAS_ActionLog.createLog('MAS_ContactService',
                    'syncLeadContactWithMascus',
                    MAS_Constant.ACTION_LOG_TYPE_INSERT,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                    response.get(0),
                    lead,
                    null,
                    strContactXml,
                    string.valueof(returnArrayString),
                    null ));
                }else{

                    logList.add(MAS_ActionLog.createLog('MAS_ContactService',
                    'syncLeadContactWithMascus',
                    MAS_Constant.ACTION_LOG_TYPE_INSERT,
                    MAS_Constant.ACTION_LOG_SOURCE_SF,
                    MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                    MAS_Constant.ACTION_LOG_STATUS_FAILED,
                    null,
                    lead,
                    null,
                    strContactXml,
                    string.valueof(returnArrayString),
                    null ));
                }

                toUpdateList.add(contact);

            }catch (Exception ex) {
                	//Add log
                    MAS_ActionLog.createErrorLog('MAS_ContactService',
                                'syncLeadContactWithMascus',
                                MAS_Constant.ACTION_LOG_TYPE_UPDATE,
                                MAS_Constant.ACTION_LOG_SOURCE_SF,
                                MAS_Constant.ACTION_LOG_TRAGET_MASCUS,
                                MAS_Constant.ACTION_LOG_STATUS_FAILED,
                                ex.getMessage(),
                                lead,
                                null,
                                strContactXml,
                                null,
                                ex.getStackTraceString()
                    );
            }

        }

        //MAS_UtilityHelper.isContactTriggerRepeat = true;
        //database.update(toUpdateList,false);
        database.insert (logList,false);
        
    }

     /**
     * @Description: Generate the XML formatted contact request data for outbound service call
     * @author: Malinda
     * @params: contact : Contact object     
     * @return: XML formatted string
     */
    public static String generateContactUpdateXml(Contact contact) {

        //Create new XML DOM document
        DOM.Document xmlDocument = new DOM.Document();
        //Creates the XML root element
        dom.XmlNode contactsNode = xmlDocument.createRootElement(MAS_Constant.CONTACT_XML_FIELD_CONTACTS, null, null);
        //Create XML child element
        dom.XmlNode contactNode = contactsNode.addChildElement(MAS_Constant.CONTACT_XML_FIELD_CONTACT, null, null);
        
        //Qucick fix to be removed
        string mascus_Contact_Id;
        if(contact.Mascus_contact_ID__c == null){
            mascus_Contact_Id = '';
        }else{
            mascus_Contact_Id = contact.Mascus_contact_ID__c;
        }

        //Create XML elements
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_MASCUSID, null, null).addTextNode(String.isBlank(mascus_Contact_Id) ? '' : mascus_Contact_Id);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_SF_ID, null, null).addTextNode(contact.Mascus_Contact_Number__c == null ? '' : contact.Mascus_Contact_Number__c);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_PARENT_ACCOUNT_ID, null, null).addTextNode(contact.Account.Mascus_customer_ID__c == null ? '' : contact.Account.Mascus_customer_ID__c);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_FIRST_NAME, null, null).addTextNode(contact.FirstName == null ? '' : contact.FirstName);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_LAST_NAME, null, null).addTextNode(contact.LastName == null ? '' : contact.LastName);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_ACTION, null, null).addTextNode(MAS_Constant.CONTACT_XML_FIELD_UPDATE == null ? '' : MAS_Constant.CONTACT_XML_FIELD_UPDATE);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_COUNTRY, null, null).addTextNode(contact.MailingCountryCode == null ? '' : contact.MailingCountryCode);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_VISITING_ADDRESS, null, null).addTextNode(contact.MailingStreet == null ? '':contact.MailingStreet); //optional field
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_POSTAL_CODE, null, null).addTextNode(contact.MailingPostalCode == null ? '':contact.MailingPostalCode); //optional field
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_CITY, null, null).addTextNode(contact.MailingCity == null ? '':contact.MailingCity); //optional field
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_PHONE, null, null).addTextNode(contact.Phone == null ? '' : contact.Phone);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_PHONE_PREFIX, null, null).addTextNode(contact.Phone_Prefix__c == null ? '' : contact.Phone_Prefix__c);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_EMAIL, null, null).addTextNode(contact.Email == null ? '' : contact.Email);
        contactNode.addChildElement(MAS_Constant.CONTACT_XML_CONTACT_MODIFIER_SF_ID, null, null).addTextNode(contact.LastModifiedBy.Mascus_User_Number__c == null ? '' : contact.LastModifiedBy.Mascus_User_Number__c);

        String contactRequestXml =  xmlDocument.toXmlString();
        return contactRequestXml;
    }

    /**
     * @Description: Phonetic name check for related contacts
     * @author: Samith Perera
     * @params: list<Id> : ContactsIds       
     * @return: boolean
     */
    public static MAS_ResponseDTO validateContactForOrder(list<Id> contactIdList){

        MAS_ResponseDTO response  = new MAS_ResponseDTO();

        for(Contact conObj : [ SELECT Id, Phonetic_Contact_First_Name__c, Status__c, Phonetic_Contact_Last_Name__c from Contact WHERE Id=: contactIdList]){

            if (conObj.Phonetic_Contact_First_Name__c == null 
                || conObj.Phonetic_Contact_First_Name__c == '' 
                || conObj.Phonetic_Contact_Last_Name__c == null 
                || conObj.Phonetic_Contact_Last_Name__c == ''){
                
                response.responseMessage  = Label.LBL_ERR_CONT_PHONETIC_NAME_EMPTY;
                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                return response;
            }

            if (conObj.Status__c != MAS_Constant.STATUS_ACTIVE){
                response.responseMessage  = Label.LBL_ERR_CONT_PHONETIC_CONTACTS_INACTIVE;
                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                return response;
            }

        }

        response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
        return response;
    }
    
        /**
     * @Description: MailingAddress check for related contacts
     * @author: Artash Manoucharjan
     * @params: Map<Id,String> : ContactsIds : Bill,Ship,Sold   
     * @return: MAS_ResponseDTO
     */
    public static MAS_ResponseDTO validateMailingAddressForOrder(Map<Id,String> contactIdMap){
        MAS_ResponseDTO response  = new MAS_ResponseDTO();
        
        for(Contact conObj : [ SELECT Id, MailingCity, MailingCountry, MailingPostalCode, MailingStreet  
                              FROM Contact 
                              WHERE Id=: contactIdMap.keySet()]){
            
            if(conObj.MailingCity==null || conObj.MailingCountry==null || conObj.MailingPostalCode==null || conObj.MailingStreet==null){
                response.responseMessage  = MAS_Constant.CONTACT_ERROR_MSG_135_p1 + contactIdMap.get(conObj.id) + MAS_Constant.CONTACT_ERROR_MSG_135_p2;
                response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                return response;
            }else{ // MailingAddress is filled in , check dummy MailingAddress
                if(MAS_Constant.CONTACT_Dummy_City.equals(conObj.MailingCity) && MAS_Constant.CONTACT_Dummy_Street.equals(conObj.MailingStreet)){
                    response.responseMessage  = MAS_Constant.CONTACT_ERROR_MSG_135_p1 + contactIdMap.get(conObj.id) + MAS_Constant.CONTACT_ERROR_MSG_135_p2;
                    response.responseType = MAS_Constant.RESPONSE_TYPE_ERROR;
                    return response;
                } 
            }
        } 
        
        response.responseType = MAS_Constant.RESPONSE_TYPE_SUCCESS;
        return response;
    }

}