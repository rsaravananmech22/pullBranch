/**************************************************************************
 * Description  : Apex service for Lead related business functions
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR              DATE            DETAIL
      1.0      Malinda      24/11/2017      Initial implementation
 **************************************************************************/
public class MAS_LeadService {

    /**
    * @Description : This method is used to validate the Lead request
    * @author : Malinda
    * @params request : Request as a DTO
    * @return : MAS_ResponseDTO (DTO)
    */
    public static MAS_ResponseDTO validateLeadFromMascus(MAS_LeadWebservice.MAS_LeadRequestDTO request) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        Integer fieldLength = 0;
        Integer requestFieldLength = 0;

        //Get Lead & Contact  fields with metadata
        Map<String, Schema.SObjectField> mapLeadFields = Lead.getsObjectType().getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> mapContactFields = Contact.getsObjectType().getDescribe().fields.getMap();

        /**
        * @Field : Company
        * @Required : Yes
        * **/
        if(request.Lead_CompanyName != null && !String.isEmpty(request.Lead_CompanyName)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_COMPANY).getDescribe().getLength();
            requestFieldLength = request.Lead_CompanyName.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_102,MAS_Constant.LEAD_ERROR_MSG_102);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_101,MAS_Constant.LEAD_ERROR_MSG_101);
        }

        /**
        * @Field : Classification__c
        * @Required : No
        * **/
        if(request.Lead_Classification != null && !String.isEmpty(request.Lead_Classification)) {
            //Get status picklist values into a map
            Map<String,String> mapLeadLeadClassificationPicklstPickList = new Map<String,String>();

            List<Schema.PicklistEntry> lstLeadClassificationPicklst = mapLeadFields.get(MAS_Constant.LEAD_CLASSIFICATION).getDescribe().getPicklistValues();
            if(lstLeadClassificationPicklst != null && !lstLeadClassificationPicklst.isEmpty()) {
                for(Schema.PicklistEntry pck : lstLeadClassificationPicklst) {
                    mapLeadLeadClassificationPicklstPickList.put(pck.getValue(),pck.getValue());
                }
            }

            if(mapLeadLeadClassificationPicklstPickList.isEmpty() || !mapLeadLeadClassificationPicklstPickList.containsKey(request.Lead_Classification)) {
                //Picklist value miss-matching
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_103,MAS_Constant.LEAD_ERROR_MSG_103);
            }
        }

        /**
        * @Field : LastName
        * @Required : Yes
        * **/
        if(request.Lead_LastName != null && !String.isEmpty(request.Lead_LastName)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_LASTNAME).getDescribe().getLength();
            requestFieldLength = request.Lead_LastName.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_105,MAS_Constant.LEAD_ERROR_MSG_105);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_104,MAS_Constant.LEAD_ERROR_MSG_104);
        }

        /**
        * @Field : Mobile_Prefix__c
        * @Required : Yes
        * **/
        if(request.Lead_MobilePrefix != null && !String.isEmpty(request.Lead_MobilePrefix)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_MOBILE_PREFIX).getDescribe().getLength();
            requestFieldLength = request.Lead_MobilePrefix.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_107,MAS_Constant.LEAD_ERROR_MSG_107);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_106,MAS_Constant.LEAD_ERROR_MSG_106);
        }

        /**
        * @Field : MobilePhone
        * @Required : Yes
        * **/
        if(request.Lead_MobileNumber != null && !String.isEmpty(request.Lead_MobileNumber)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_MOBILE).getDescribe().getLength();
            requestFieldLength = request.Lead_MobileNumber.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_109,MAS_Constant.LEAD_ERROR_MSG_109);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_108,MAS_Constant.LEAD_ERROR_MSG_108);
        }

        /**
        * @Field : LeadSource
        * @Required : No
        * **/
        if(request.Lead_source != null && !String.isEmpty(request.Lead_source)) {

            //Get status picklist values into a map
            Map<String,String> mapLeadSourcePickList = new Map<String,String>();

            List<Schema.PicklistEntry> lstLeadSourcePicklst = mapLeadFields.get(MAS_Constant.LEAD_SOURCE).getDescribe().getPicklistValues();
            if(lstLeadSourcePicklst != null && !lstLeadSourcePicklst.isEmpty()) {
                for(Schema.PicklistEntry pck : lstLeadSourcePicklst) {
                    mapLeadSourcePickList.put(pck.getValue(),pck.getValue());
                }
            }

            if(mapLeadSourcePickList.isEmpty() || !mapLeadSourcePickList.containsKey(request.Lead_source)) {
                //Picklist value miss-matching
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_110,MAS_Constant.LEAD_ERROR_MSG_110);
            }

        }

        /**
        * @Field : Street
        * @Required : Yes
        * **/
        if(request.Lead_Street != null && !String.isEmpty(request.Lead_Street)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_STREET).getDescribe().getLength();
            requestFieldLength = request.Lead_Street.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_112,MAS_Constant.LEAD_ERROR_MSG_112);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_111,MAS_Constant.LEAD_ERROR_MSG_111);
        }

        /**
        * @Field : State
        * @Required : No
        * **/
        if(request.Lead_State != null && !String.isEmpty(request.Lead_State)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_SATE).getDescribe().getLength();
            requestFieldLength = request.Lead_State.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_113,MAS_Constant.LEAD_ERROR_MSG_113);
            }
        }

        /**
        * @Field : PostalCode
        * @Required : Yes
        * **/
        if(request.Lead_PostalCode != null && !String.isEmpty(request.Lead_PostalCode)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_POSTAL_CODE).getDescribe().getLength();
            requestFieldLength = request.Lead_PostalCode.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_115,MAS_Constant.LEAD_ERROR_MSG_115);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_114,MAS_Constant.LEAD_ERROR_MSG_114);
        }

        /**
        * @Field : Country
        * @Required : Yes
        * **/
        if(request.Lead_Country != null && !String.isEmpty(request.Lead_Country)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_COUNTRY).getDescribe().getLength();
            requestFieldLength = request.Lead_Country.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_117,MAS_Constant.LEAD_ERROR_MSG_117);
            }

            string leadCountry = null;
            Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
                if(f.getValue() == request.Lead_Country){
                    leadCountry = f.getLabel();
                    continue;
                }
            }

            if(leadCountry == null){
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_124, MAS_Constant.LEAD_ERROR_MSG_124);
            }else{
                request.Lead_Country =  leadCountry;
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_116,MAS_Constant.LEAD_ERROR_MSG_116);
        }

        /**
        * @Field : Mascus_Account_ID__c
        * @Required : Yes
        * **/
        if(request.Lead_MascusAccountGUID != null && !String.isEmpty(request.Lead_MascusAccountGUID)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_MASCUS_ACCOUNT_GUID).getDescribe().getLength();
            requestFieldLength = request.Lead_MascusAccountGUID.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_119,MAS_Constant.LEAD_ERROR_MSG_119);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_118,MAS_Constant.LEAD_ERROR_MSG_118);
        }

        /**
        * @Field : Mascus_Lead_Number__c
        * @Required : No
        * **/
        if(request.Lead_MascusLeadNumber != null && !String.isEmpty(request.Lead_MascusLeadNumber)) {
            fieldLength = mapLeadFields.get(MAS_Constant.LEAD_MASCUS_LEAD_NUMBER).getDescribe().getLength();
            requestFieldLength = request.Lead_MascusLeadNumber.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_120,MAS_Constant.LEAD_ERROR_MSG_120);
            }
        }

        /**
        * @Field : Mascus_contact_ID__c
        * @Required : No
        * **/
        if(request.Lead_MascusContactGUID != null && !String.isEmpty(request.Lead_MascusContactGUID)) {
            fieldLength = mapContactFields.get(MAS_Constant.LEAD_MASCUS_CONTACT_GUID).getDescribe().getLength();
            requestFieldLength = request.Lead_MascusContactGUID.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_122,MAS_Constant.LEAD_ERROR_MSG_122);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_121,MAS_Constant.LEAD_ERROR_MSG_121);
        }
        
        //Added by amarendra on 12/14/2017 as part of Bug#C248-39
        
         /**
        * @Field : City
        * @Required : Yes
        * **/
        if(request.Lead_City!= null && !String.isEmpty(request.Lead_City)) {
            fieldLength = mapLeadFields.get(MAS_Constant.Lead_City).getDescribe().getLength();
            requestFieldLength = request.Lead_City.length();
            if(requestFieldLength > fieldLength) {
                //Field length error
                return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_126,MAS_Constant.LEAD_ERROR_MSG_126);
            }
        }
        else {
            // Empty Value error
            return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_125 ,MAS_Constant.LEAD_ERROR_MSG_125 );
        }
        
         /**
        * @Field : Email
        * @Required : Yes
        * **/
        if(request.Lead_Email==null || String.isEmpty(request.Lead_Email)) {
            
              return MAS_UtilityHelper.addResponseStatus(MAS_Constant.LEAD_ERROR_CODE_127,MAS_Constant.LEAD_ERROR_MSG_127);
        }
        
        
        //End of adding

        //Validation Success
        response.responseCode = MAS_Constant.LEAD_VALIDATION_SUCCESS_CODE;
        response.responseMessage = MAS_Constant.LEAD_VALIDATION_SUCCESS_MSG;

        return response;

    }

    /**
     * @Description : This method is used to upsert Lead
     * @author : Malinda
     * @params request : Request as a DTO
     * @return : response : MAS_ResponseDTO
     */
    public static MAS_ResponseDTO upsertLeadFromMascus(MAS_LeadWebservice.MAS_LeadRequestDTO request) {

        MAS_ResponseDTO response = new MAS_ResponseDTO();
        boolean isInsert = true;
        Lead lead = new Lead();

        try {

            
            //Added by Amarendra on 12/19/2017 as part of Bug#286
            if(request.Lead_Status=='omitted'){
                lead.Status = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.LEAD_STATUS_Omitted);
            }else{
                lead.Status = MAS_CustomSettingHelper.getConfigSettingValueByName(MAS_Constant.LEAD_STATUS_OPEN);
            }

            List<Lead> lstLeads = [SELECT Id,status FROM Lead WHERE Mascus_Account_ID__c =: request.Lead_MascusAccountGUID AND Mascus_contact_ID__c =: request.Lead_MascusContactGUID];
            if(lstLeads != null && !lstLeads.isEmpty()) {
                lead.Id = lstLeads[0].Id;
                isInsert = false;
                if((request.Lead_Status==null || String.isEmpty(request.Lead_Status)) || (request.Lead_Status!='omitted'&& request.Lead_Status!='open')){
                    lead.Status=lstLeads[0].status;
                }  
            }

            
            lead.Company = request.Lead_CompanyName;
            lead.Classification__c = request.Lead_Classification;
            lead.Firstname=request.Lead_FirstName;
            lead.LastName = request.Lead_LastName;
            lead.Mobile_Prefix__c = request.Lead_MobilePrefix;
            lead.MobilePhone = request.Lead_MobileNumber;
            lead.LeadSource = request.Lead_source;
            lead.Street = request.Lead_Street;
            lead.State = request.Lead_State;
            lead.PostalCode = request.Lead_PostalCode;
            lead.Country = request.Lead_Country;
            lead.Mascus_Account_ID__c = request.Lead_MascusAccountGUID;
            lead.Mascus_contact_ID__c = request.Lead_MascusContactGUID;
            //Added by Amarendra-nagireddy on 12/14/2017-As part of bug # C248-39 
            lead.Email=request.Lead_Email;
            lead.city=request.Lead_City;
            
            upsert lead;

            lead = [SELECT Mascus_Lead_Number__c FROM Lead WHERE Id =: lead.Id];

            response.responseCode = MAS_Constant.LEAD_DML_SUCCESS_CODE;
            response.responseMessage = MAS_Constant.LEAD_DML_SUCCESS_MSG;
            response.responseResult = new list<MAS_ResponseDTO.ResponseData>();
            response.responseResult.add(MAS_UtilityHelper.addResponseResult('Mascus_Lead_Number__c',lead.Mascus_Lead_Number__c));

        }
        catch (Exception ex) {
            if(ex.getMessage().contains('DUPLICATES_DETECTED, You\'re creating a duplicate record. We recommend you use an existing record instead'))
            {
             response.responseCode = MAS_Constant.LEAD_ERROR_CODE_128;
             response.responseMessage =MAS_Constant.LEAD_ERROR_MSG_128;
            }else
            {
            response.responseCode = MAS_Constant.LEAD_ERROR_CODE_123;
            response.responseMessage = MAS_Constant.LEAD_ERROR_MSG_123 + ' : ' + ex.getMessage() + ' : Line No : ' + ex.getLineNumber();
            }
            //Add log
            MAS_ActionLog.createErrorLog('MAS_LeadService',
                        'upsertLeadFromMascus',
                        isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_FAILED,
                        ex.getMessage(),
                        null,
                        request.Lead_MascusAccountGUID,
                        JSON.serialize(request),
                        JSON.serialize(response),
                        ex.getStackTraceString()
            );

        }

        //Add log
        if(response.responseCode.equals(MAS_Constant.LEAD_DML_SUCCESS_CODE)){
            MAS_ActionLog.createErrorLog('MAS_LeadService',
                        'upsertLeadFromMascus',
                        isInsert ? MAS_Constant.ACTION_LOG_TYPE_INSERT : MAS_Constant.ACTION_LOG_TYPE_UPDATE ,
                        MAS_Constant.ACTION_LOG_SOURCE_MASCUS,
                        MAS_Constant.ACTION_LOG_TRAGET_SF,
                        MAS_Constant.ACTION_LOG_STATUS_SUCCESS,
                        MAS_Constant.CONTACT_DML_SUCCESS_MSG,
                        lead,
                        request.Lead_MascusAccountGUID,
                        JSON.serialize(request),
                        JSON.serialize(response),
                        null
            );
        }

        return response;

    }

}