/**************************************************************************
 * Description  : Apex Class for common methods & static varibales
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       19/09/2019      Initial implementation
 **************************************************************************/

public class MAS_UtilityHelper {

    // Static varibales 
    public static boolean isAccountTriggerRepeat = false;
    public static boolean isContactTriggerRepeat = false;
    public static boolean isLeadTriggerRepeat = false;

    /**
      * @Description This method decides parameter(text) contains non ascii values or not
      * @author Samith Perera
      * @params text : string
      * @return boolean(true or false)
      */
    public static boolean isNonAscii (string text){
        if(Pattern.matches('^.*[^\\x00-\\x7F].*$', text))
            return true;
        else
                return false;
    }

    /**
     * @Description This method removes accents and non ascii characters in the parameter(paramString)
     * @author Samith Perera
     * @params paramString : translated text from google
     * @return string
     */
    public static String removeNonAsciiwithOtherChars(String paramString){

        String resultString = paramString;

        if(containsCaps(resultString))
            resultString=replaceAccentuatedCaps(resultString);
        else if(containsSimple(resultString))
            resultString=replaceAccentuatedSimple(resultString);

        resultString = resultString.replaceall('[^\\x00-\\x7F]', '');

        return resultString.trim();
    }

    /**
     * @Description This method checks parameter contains special charcters with CAPS 
     * @author Samith Perera
     * @params text : translated text from google
     * @return boolean(true or false)
     */
    public static Boolean containsCaps(String text){
        return Pattern.matches('^.*[ÀÁÃÄÅÈÉÊËÝŸÙÚÛÜÌÍÎÏÒÓÔÕÖØÇÑ].*$', text);
    }

    /**
     * @Description This method replaces all accentuated CAPS and replace with alpha characters
     * @author Samith Perera
     * @params text : translated text from google
     * @return boolean(true or false)
     */
    public static String replaceAccentuatedCaps(String text){
        String resultString=text;

        resultString=resultString.replaceAll('[ÀÁÃÄÅ]','A');
        resultString=resultString.replaceAll('[ÈÉÊË]','E');
        resultString=resultString.replaceAll('[ÝŸ]','Y');
        resultString=resultString.replaceAll('[ÙÚÛÜ]','U');
        resultString=resultString.replaceAll('[ÌÍÎÏ]','I');
        resultString=resultString.replaceAll('[ÒÓÔÕÖØ]','O');
        resultString=resultString.replaceAll('Ç','C');
        resultString=resultString.replaceAll('Ñ','N');

        return resultString;
    }

    /**
    * @Description This method checks parameter contains special charcters with simple
    * @author Samith Perera
    * @params paramString : translated text from google
    * @return boolean(true or false)
    */
    public static Boolean containsSimple(String text){
        return Pattern.matches('^.*[a-zãáàâäçéèêëíìîïñõôóòöûúùüş].*$', text);
    }

    /**
     * @Description This method replaces all accentuated simple characters and replace with alpha characters
     * @author Samith Perera
     * @params text : translated text from google
     * @return boolean(true or false)
     */
    public static String replaceAccentuatedSimple(String text){
        String resultString=text;

        resultString=resultString.replaceAll('[ãáàâä]','a');
        resultString=resultString.replaceAll('[ç]','c');
        resultString=resultString.replaceAll('[éèêë]','e');
        resultString=resultString.replaceAll('[íìîï]','i');
        resultString=resultString.replaceAll('[ñ]','n');
        resultString=resultString.replaceAll('[õôóòö]','o');
        resultString=resultString.replaceAll('[ûúùü]','u');
        resultString=resultString.replaceAll('[ş]','s');

        return resultString;
    }

    /**
     * @Description This method replaces only few special charcters before send them to google trnaslate API
     * @author Samith Perera
     * @params accName : account name
     * @return boolean(true or false)
     */
    public static string removeSpecialCharactersBeforeTranslate(string accName){

        accName = accName.replace('•', '');
        accName = accName.replace('（', '');
        accName = accName.replace('）', '');
        accName = accName.replace('(', ' ');
        accName = accName.replace(')', ' ');
        accName = accName.replace('&', 'and');
        accName = accName.replace('\'', ' ');
        accName = accName.trim();
        accName = accName.replace(' ', '%20');

        return accName;
    }

    /**
     * @Description This method replaces only few special charcters, Traditional way of replacing special characters
     * @author Samith Perera
     * @params ins : translated text from google
     * @return boolean(true or false)
     */
    public static String clean(String ins) {
        //String minmaj = "ÀÂÄÇÉÈÊËÎÏÛÜÔÖaàâäbcçdeéèêëfghiîïjklmnoôöpqrstuùûüvwxyz";        
        //String maj    = "AAACEEEEIIUUOOAAAABCCDEEEEEFGHIIIJKLMNOOOPQRSTUUUUVWXYZ";
        String acc = '°()§<>%^¨*$€£`#/?=@"•«»，’赛';
        String maj = '                            ';

        String out = '';
        for (Integer i = 0 ; i < ins.length() ; i++) {
            String car = ins.substring(i, i+1);
            Integer idx = acc.indexOf(car);
            if (idx != -1){
                out += maj.substring(idx, idx+1);
            } else {
                out += car;
            }
        }

        return out.trim();
    }

    /**
     * @Description : This method is used to generate error response
     * @author : Malinda
     * @params strErrorCode : String, strErrorMessage : String
     * @return : MAS_ResponseDTO (DTO)
     */
    public static MAS_ResponseDTO addResponseStatus(String strErrorCode, String strErrorMessage) {

        MAS_ResponseDTO responseError = new MAS_ResponseDTO();
        responseError.responseCode = strErrorCode;
        responseError.responseMessage = strErrorMessage;

        return  responseError;

    }

    /**
 * @Description : This method is used to generate resulting data for webservice response
 * @author : Samith Perera
 * @params key : String, value : String
 * @return : MAS_ResponseDTO.ResponseData (DTO)
 */
    public static MAS_ResponseDTO.ResponseData addResponseResult(String key, String value) {

        MAS_ResponseDTO.ResponseData resData = new MAS_ResponseDTO.ResponseData();
        resData.key =key;
        resData.value = value;

        return  resData;

    }

    /**
     * @Description : This method is used to validate email values
     * @author : Malinda
     * @params strEmail : String
     * @return : Boolean
     */
    public static Boolean validateEmail(String strEmail) {

        Boolean res = true;
        String emailRegex = '^([^\\x20-\\x7E]|[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-])+@([^\\x20-\\x7E]|[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-])+\\.([^\\x20-\\x7E]|[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]){2,4}$';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(strEmail);

        if (!MyMatcher.matches())
            res = false;

        return res;
    }

    /**
     * @Description: Check if the Account update / insert happened from internal Salesforce
     * @author: Dinesh W
     * @params: Void
     * @return: Boolean
     */
    public static Boolean isInternalRequest(){
        Boolean status = false;
        //Check if the request has came from the service or not
        if(!String.valueOf(URL.getCurrentRequestUrl()).toLowerCase().contains('services/soap')){
            status = true;
        }
        return status;
    }

    /**
     * @Description: This method check if any required field has update (This is to make sure the Sync is required or not)
     * @author: Dinesh W
     * @params: newList : new  values list
     *          oldList : old  values list
     * @return: Boolean
     */
    public static Boolean isSyncRequiredForUpdate(list<SObject>newList, list<SObject>oldList, string ObajectName){
        //Get the required fields list from a custom setting and loop
        for(String field : MAS_CustomSettingHelper.getFieldstoSyncwithMascusSettingByObjectName(ObajectName)){
            //Check if any required field has updated
            for(Integer counter = 0; counter < newList.Size() ; counter++){
                if(newList[counter].get(field) != oldList[counter].get(field)){
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * @Description: Check Lead required fields to sync
     * @author: Malinda
     * @params: newList : new  values list
     *          oldList : old  values list
     * @return: Boolean
     */
    public static LeadFieldsToSync__c isSyncRequiredForLead(List<Lead> lstNewLeads,List<Lead> lstOldLeads) {
        List<LeadFieldsToSync__c> lstFields = MAS_CustomSettingHelper.getLeadFiledsToSync();
        LeadFieldsToSync__c filedObj = null;
        if(lstFields != null && !lstFields.isEmpty()) {
            for(LeadFieldsToSync__c lst : lstFields) {
                for(Integer counter = 0; counter < lstNewLeads.Size() ; counter++){
                    if(lstNewLeads[counter].get(lst.Name) != lstOldLeads[counter].get(lst.Name)){
                        filedObj = lst;
                    }
                }
            }
        }

        return filedObj;
    }


    /**
     * @Description Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
     * @author Robin De Bondt
     * @params String objectName, String whereClause             
     * @return String (SOQL query)
     */
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){

        String selects = '';

        if (whereClause == null || whereClause == ''){ return null; }

        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }

        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}

        }

        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
    }

    /**
     * @Description Returns a dynamic SOQL statement with all the fields for an sObject/Custom Metadata Type
     * @author Neha Mishra
     * @params String objectName, String whereClause
     * @return String (SOQL query)
     */
    public static string getFieldswithWhereClauseSOQL(String objectName, String whereClause){

        String selects = '';

        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                selectFields.add(fd.getName());
            }
        }

        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}

        }
        return 'SELECT ' + selects + ' FROM ' + objectName +((whereClause == null || whereClause == '')?'':' WHERE ' + whereClause) ;
    }


    /**
      * @Description: Get AccountId from Mascus Id
      * @author: Malinda
      * @params: String : strMascusId
      * @return: Id
      */
    public static Id getAccountIdFromMascus(String strExtId) {
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE Mascus_Customer_Number__c =: strExtId];
        if(lstAccounts != null && !lstAccounts.isEmpty()) {
            return lstAccounts[0].Id;
        }
        else {
            return null;
        }

    }


    /**
      * @Description: Get AccountId from Mascus Id
      * @author: Malinda
      * @params: String : strMascusId
      * @return: Id
      */
    public static Id getUserIdFromMascus(String strExtId) {
        List<User> lstUsers = [SELECT Id FROM User WHERE Mascus_User_Number__c  =: strExtId];
        if(lstUsers != null && !lstUsers.isEmpty()) {
            return lstUsers[0].Id;
        }
        else {
            return null;
        }

    }


    /**
      * @Description: Get ContactId from Mascus Id
      * @author: Malinda
      * @params: String : strMascusId
      * @return: Id
      */
    public static Id getContactIdFromMascus(String strExtId) {
        List<Contact> lstContacts = [SELECT Id FROM Contact WHERE Mascus_Contact_Number__c =: strExtId];
        if(lstContacts != null && !lstContacts.isEmpty()) {
            return lstContacts[0].Id;
        }
        else {
            return null;
        }
    }

    /**
     * @Description: Compose Email notification,Patty gave this solution to implement
     * @author: Samith Perera
     * @params: order
     * @return: void
     */
    public static Id getPriceBookId(string currencyCode){
        if(Test.isRunningTest()){
            return Test.getStandardPricebookId();
        }
        string pName =  'Mascus WEB '+ currencyCode;
        return [SELECT Id,Name FROM Pricebook2 WHERE Name =: pName].Id;
    }

    /**
     * @Description: EU member check
     * @author: Samith Perera
     * @params: countryCode
     * @return: boolean
     */
    public static boolean euMemberCheckByCountryCode(string countryCode){
        for(EU_Member_Country__c euCountry : EU_Member_Country__c.getall().values()){
            if(euCountry.Country_Code__c.equals(countryCode)){
                return true;
            }
        }
        return false;
    }

    /**
     * @Description: Compose Email notification
     * @author: Samith Perera
     * @params: order
     * @return: void
     */
    public static string getCurrencyFormat(decimal currencyVal, boolean isEu){
        string value  = string.valueof(currencyVal.setScale(2));
        string formated = (decimal.valueOf(value==null||value.trim()==''?'0':value).setScale(2) + 0.001 ).format();
        formated = formated.substring(0,formated.length()-1);

        if(UserInfo.getLocale().contains('en') && isEu){
            formated = formated.replace('.', '-');
            formated = formated.replace(',', '.');
            formated = formated.replace('-', ',');
        }

        if(!UserInfo.getLocale().contains('en') && !isEu){
            formated = formated.replace('.', '-');
            formated = formated.replace(',', '.');
            formated = formated.replace('-', ',');
        }

        return formated;
    }

    /**
     * @Description: Common Format
     * @author: Samith Perera
     * @params: countryCode
     * @return: boolean
     */
    public static boolean isEUCountryByCurrency(string currencyVal){
        if(currencyVal != 'CAD' && currencyVal != 'GBP' && currencyVal != 'USD')
            return true;
        else
                return false;
    }

    /**
     * @Description: Get Local based on the countryIso
     * @author: Samith Perera
     * @params: countryCode
     * @return: boolean
     */
    public static string getLocalByCountryCode(string countryCode){
        Schema.PicklistEntry[] locales = Schema.SObjectType.User.fields.LocaleSidKey.PicklistValues;
        for (PicklistEntry locale : locales) {
            if(locale.isActive()) {
                if(locale.getValue().Contains('_' + countryCode))
                    return locale.getValue();
            }
        }
        return 'en_US';
    }

    /**
     * @Description: Get max length
     * @author: Samith Perera
     * @params: countryCode
     * @return: boolean
     */
    public static integer getMaxLengthForActionLogMessage(string msg){
        integer maxLen = 255;
        if(msg.length() < maxLen)
            maxLen = msg.length();

        return maxLen;
    }
    //DBL Moved from Test Class to Utility Class
    public static String generateRandomString(Integer len) {
        String CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), CHARS.length());
            randStr += CHARS.substring(idx, idx+1);
        }
        return randStr;
    }

    public static Boolean checkProductionId() {
        Id settingId = Org_Settings__c.getOrgDefaults().Production_Org_Id__c;
        Id currentId = UserInfo.getOrganizationId();
        return settingId == currentId;
    }

    /**
    * @Description: Check if the logged In user is Mascus Webservice User
    * @author: Neha Mishra
    * @params: Void
    * @return: Boolean
    */
    public static Boolean isLoggedInWebServiceUser(){
        Boolean isWebServiceUser = [Select Is_Mascus_Webservice__c From User Where Id = :UserInfo.getUserId()][0].Is_Mascus_Webservice__c;
        return isWebServiceUser;
    }
}