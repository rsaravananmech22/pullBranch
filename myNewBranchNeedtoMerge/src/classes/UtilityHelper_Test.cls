/**************************************************************************
 * Description : Apex Unit Test Class for common methods & static varibales
 * Class : MAS_UtilityHelper
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR              DATE            DETAIL
      1.0      Daniel Blaauw      20/01/2018      Initial implementation
 **************************************************************************/

@IsTest
private class UtilityHelper_Test {
    private static String NO_ASCII_STRING= '';
    private static String ASCII_STRING = '';
    private static final String EMAIL_GOOD = 'sfdc@absi.be';
    private static final String EMAIL_FALSE = 'NotAnEmail';
    private static final String OBJECT_NAME = 'Contact';
    private static final String FIELD_NAME = 'Email';
	private static final Contact OLD_CONTACT = new Contact(email='sfdc@absi.be');
    private static final Contact NEW_CONTACT_SAME = new Contact(email='sfdc@absi.be');
    private static final Contact NEW_CONTACT_CHANGED = new Contact(email='sfdc@absi.nl');

    private static final Lead OLD_LEAD = new Lead(email='sfdc@absi.be');
    private static final Lead NEW_LEAD_CHANGED = new Lead(email='sfdc@absi.nl');
	private static final Lead NEW_LEAD_SAME = new Lead(email='sfdc@absi.be');
   
    private static final String OBJECT_CREATEABLE_TEST = 'Contact';
    private static final String WHERE_CLAUSE_CREATEABLE_TEST = 'id = 2';

    private static final String CUSTOM_METADATA_TEST = 'Currency_With_minimum_payment_Amount__mdt';
    private static final String WHERE_CLAUSE_TEST = 'id != null';
    
    private static final String FAKE_MASCUS_ID = 'FAKE_111111111111';
    
    private static final String EU_CHECK_COUNTRY_CODE_EU = 'NL';
    private static final String EU_CHECK_COUNTRY_CODE_US = 'US';
    
    private static final Decimal CURRENCY_FORMAT_VAL = 100000.02;
    private static final String CURRENCY_FORMAT_EN_EU = '100.000,02';
    private static final String CURRENCY_FORMAT_EN_US = '100,000.02';
        
    private static final String[] NON_EU_CURRENCY = new String[]{'CAD','GBP','USD'};
    private static final String EU_CURRENCY = 'EUR';
    
    private static final String COUNTRY_CODE_NL = 'NL';
    private static final String COUNTRY_CODE_FAKE = 'FAKE';
    
    private static final String LOG_MESSAGE = 'This Is A Test Message ! ';//25 char
    private static final Integer LOG_MESSAGE_MAX_LEN = 255;    
    private static final Integer LOG_MESSAGE_EXPECTED_LEN = 25;    
    
    
    @testSetup public static void createData()
    {
        Fields_to_Sync_with_Mascus__c idField = new Fields_to_Sync_with_Mascus__c();
        idField.Name = FIELD_NAME;
        idField.Object__c = OBJECT_NAME;
        insert idField;
        
        LeadFieldsToSync__c leadField = new LeadFieldsToSync__c();
        leadField.Name = FIELD_NAME;
        leadField.Object__c = OBJECT_NAME;
        insert leadField;

        Profile p = [select Id, Name from Profile where Name = 'Read Only'];
        User u = new User(
            UserName = 'sfdc@absi.be',
            FirstName = 'ABSI-First-Name',
            LastName = 'ABSI-Last-Name',
            Alias = 'absitest',
            Email = 'sfdc@absi.be',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocalesIdKey = 'en_US',
            TimezonesIdKey = 'America/Los_Angeles',
            ProfileId = p.Id
            );
        insert u;  
        MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='false'), true);
		MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c='false'), true);
        MAS_TestDataFactory.createSObject(new EU_Member_Country__c(Name = 'Netherlands',Country_Code__c='NL'), true);
    }


    @isTest static void isNonAscii_test (){
        String ASCII_STRING = '';
        for(Integer  i = 0; i <= 127; i++ )
        {
        	ASCII_STRING += String.fromCharArray(new Integer[]{ i });
        }
        String NO_ASCII_STRING = '';
        for(Integer  i = 128; i <= 255; i++ )
        {
            NO_ASCII_STRING += String.fromCharArray(new Integer[]{ i });
        }
        
        System.assertEquals(MAS_UtilityHelper.isNonAscii(ASCII_STRING),false);
        System.assertEquals(MAS_UtilityHelper.isNonAscii(NO_ASCII_STRING),true);
    }
    @isTest static void removeNonAsciiwithOtherChars_test () {
        System.assertEquals(MAS_UtilityHelper.removeNonAsciiwithOtherChars('ÀÁÃÄÅÈÉÊËÝŸÙÚÛÜÌÍÎÏÒÓÔÕÖØÇÑ'),'AAAAAEEEEYYUUUUIIIIOOOOOOCN');
         System.assertEquals(MAS_UtilityHelper.removeNonAsciiwithOtherChars('ãáàâäçéèêëíìîïñõôóòöûúùüş'),'aaaaaceeeeiiiinooooouuuus');
    }
    @isTest static void removeSpecialCharactersBeforeTranslate_test () {
        System.assertEquals(MAS_UtilityHelper.removeSpecialCharactersBeforeTranslate('• （ ） ( )&\' •'),'and');
    }
    @isTest static void clean_test () {
        System.assertEquals(MAS_UtilityHelper.clean('°()§<>%^¨*$€£`#/?=@"•«»，’赛ÀÂÄÇÉÈÊËÎÏÛÜÔÖaàâäbcçdeéèêëfghiîïjklmnoôöpqrstuùûüvwxyz'),'ÀÂÄÇÉÈÊËÎÏÛÜÔÖaàâäbcçdeéèêëfghiîïjklmnoôöpqrstuùûüvwxyz');
    }
    @isTest static void addResponseStatus_test () {
        MAS_ResponseDTO Test_Obj = MAS_UtilityHelper.addResponseStatus(ASCII_STRING,ASCII_STRING);
        System.assertEquals(Test_Obj.responseCode,ASCII_STRING);
        System.assertEquals(Test_Obj.responseMessage,ASCII_STRING);
    }
    @isTest static void addResponseResult_test () {
        MAS_ResponseDTO.ResponseData Test_Obj = MAS_UtilityHelper.addResponseResult(ASCII_STRING,ASCII_STRING);
        System.assertEquals(Test_Obj.key,ASCII_STRING);
        System.assertEquals(Test_Obj.value,ASCII_STRING);
    }
    @isTest static void validateEmail_test () {
        System.assertEquals(MAS_UtilityHelper.validateEmail(EMAIL_GOOD),true);
        System.assertEquals(MAS_UtilityHelper.validateEmail(EMAIL_FALSE),false);
    }
    @isTest static void isInternalRequest_test () { // DBL: This is a test for coverage, no methodology available to really test this, since we can't emulate outside stimuli....
        System.assertEquals(MAS_UtilityHelper.isInternalRequest(),true);
    }
    @isTest static void isSyncRequiredForUpdate_test () { 
        System.assertEquals(MAS_UtilityHelper.isSyncRequiredForUpdate(new Contact[]{NEW_CONTACT_SAME}, new Contact[]{OLD_CONTACT}, OBJECT_NAME),false);
        System.assertEquals(MAS_UtilityHelper.isSyncRequiredForUpdate(new Contact[]{NEW_CONTACT_CHANGED}, new Contact[]{OLD_CONTACT}, OBJECT_NAME),true);
    }
    @isTest static void isSyncRequiredForLead_test () { 
        // DBL: isSyncRequiredForLead does not work as specified in the comments
        System.assertEquals(MAS_UtilityHelper.isSyncRequiredForLead(new Lead[]{NEW_LEAD_SAME}, new Lead[]{OLD_LEAD}),null);
        System.assertEquals(MAS_UtilityHelper.isSyncRequiredForLead(new Lead[]{NEW_LEAD_CHANGED}, new Lead[]{OLD_LEAD}).name,FIELD_NAME);
    }
    @isTest static void getCreatableFieldsSOQL_test () { 
        // DBL: Just to test the getCreatableFieldsSOQL function, not the actual FLS!!
        System.assertEquals(MAS_UtilityHelper.getCreatableFieldsSOQL(OBJECT_CREATEABLE_TEST,''),null);
        
        System.assert(MAS_UtilityHelper.getCreatableFieldsSOQL(OBJECT_CREATEABLE_TEST,WHERE_CLAUSE_CREATEABLE_TEST).length() > 0 );
        
        User readOnlyUser = [SELECT id from User Where UserName = 'sfdc@absi.be'];
        System.runAs(readOnlyUser)
        {
            System.assertEquals(MAS_UtilityHelper.getCreatableFieldsSOQL(OBJECT_CREATEABLE_TEST,WHERE_CLAUSE_CREATEABLE_TEST),'SELECT  FROM '+ OBJECT_CREATEABLE_TEST + ' WHERE ' + WHERE_CLAUSE_CREATEABLE_TEST);
        }
    }
    @isTest static void getFieldswithWhereClauseSOQL_test () {
        // DBL: Just to test the getFieldswithWhereClauseSOQL function, not the actual FLS!!
        System.assert(MAS_UtilityHelper.getFieldswithWhereClauseSOQL(CUSTOM_METADATA_TEST,WHERE_CLAUSE_TEST).length() > 0 );

        User readOnlyUser = [SELECT id from User Where UserName = 'sfdc@absi.be'];
        System.runAs(readOnlyUser)
        {
            System.assertEquals(MAS_UtilityHelper.getFieldswithWhereClauseSOQL(CUSTOM_METADATA_TEST,WHERE_CLAUSE_TEST),'SELECT Id,DeveloperName,MasterLabel,Language,NamespacePrefix,Label,QualifiedApiName,Currency_Code__c,Payment_Amount__c FROM '+ CUSTOM_METADATA_TEST + ' WHERE ' + WHERE_CLAUSE_TEST);
        }
    }
    @isTest static void getAccountIdFromMascus_test () { 
        Account a = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Account',Email_for_invoicing__c='Emailforinvoicing@test.com', Phonetic_Account_Name__c = 'Phonetic name will be updated shortly'), true);
        Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Legal Entity',Type = 'Internal legal entity', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);	
        Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=a.Id), true);        
         
        String  ACCOUNT_SFDC_ID = a.id;
        a = [SELECT id,Mascus_Customer_Number__c FROM Account WHERE id=:ACCOUNT_SFDC_ID ];
        String ACCOUNT_MASCUS_ID = a.Mascus_Customer_Number__c;
        
        System.assertEquals(MAS_UtilityHelper.getAccountIdFromMascus(FAKE_MASCUS_ID),null);    
        System.assertEquals(MAS_UtilityHelper.getAccountIdFromMascus(ACCOUNT_MASCUS_ID),ACCOUNT_SFDC_ID);
    }
    @isTest static void getContactIdFromMascus_test () { 
        Account a = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Account',Email_for_invoicing__c='Emailforinvoicing@test.com', Phonetic_Account_Name__c = 'Phonetic name will be updated shortly'), true);
        Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Legal Entity',Type = 'Internal legal entity', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);	
        Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=a.Id), true);        
          

        String CONTACT_SFDC_ID = c.id;
        c = [SELECT id,Mascus_Contact_Number__c FROM Contact WHERE id=:CONTACT_SFDC_ID ];
        String  CONTACT_MASCUS_ID = c.Mascus_Contact_Number__c;
        
        System.assertEquals(MAS_UtilityHelper.getContactIdFromMascus(FAKE_MASCUS_ID),null);
        System.assertEquals(MAS_UtilityHelper.getContactIdFromMascus(CONTACT_MASCUS_ID),CONTACT_SFDC_ID);
    }
    @isTest static void getPriceBookId_test () { // Can't be tested due to code escapes when Test.isRunningTest()
        System.assertEquals(MAS_UtilityHelper.getPriceBookId('EUR'),Test.getStandardPricebookId());
    }
    @isTest static void euMemberCheckByCountryCode_test () { // Can't be tested due to code escapes when Test.isRunningTest()
        System.assertEquals(MAS_UtilityHelper.euMemberCheckByCountryCode(EU_CHECK_COUNTRY_CODE_EU),true);
        System.assertEquals(MAS_UtilityHelper.euMemberCheckByCountryCode(EU_CHECK_COUNTRY_CODE_US),false);
    }
    @isTest static void getCurrencyFormat_test () { 
        User readOnlyUser = [SELECT id from User Where UserName = 'sfdc@absi.be'];
        System.runAs(readOnlyUser)
        {
            System.assertEquals(MAS_UtilityHelper.getCurrencyFormat(CURRENCY_FORMAT_VAL,true),CURRENCY_FORMAT_EN_EU);
            System.assertEquals(MAS_UtilityHelper.getCurrencyFormat(CURRENCY_FORMAT_VAL,false),CURRENCY_FORMAT_EN_US);
        }
    }
    @isTest static void isEUCountryByCurrency_test () {
        for(String cur : NON_EU_CURRENCY)
        {
          System.assertEquals(MAS_UtilityHelper.isEUCountryByCurrency(cur),false);
        }
            
        System.assertEquals(MAS_UtilityHelper.isEUCountryByCurrency(EU_CURRENCY),true);
    }
    @isTest static void getLocalByCountryCode_test () {
        System.assertEquals(MAS_UtilityHelper.getLocalByCountryCode(COUNTRY_CODE_NL),'nl_NL'); 
        System.assertEquals(MAS_UtilityHelper.getLocalByCountryCode(COUNTRY_CODE_FAKE),'en_US');
    }
    @isTest static void getMaxLengthForActionLogMessage_test () { //DBL: Code in the method is not safe for messages bigger than 255 chars!
        System.assertEquals(MAS_UtilityHelper.getMaxLengthForActionLogMessage(LOG_MESSAGE),LOG_MESSAGE_EXPECTED_LEN); 
        String MaxMsgAndMore = '';
        for(Integer i =0; i<LOG_MESSAGE_MAX_LEN; i++)
        {
            // Add 255 Chars
            MaxMsgAndMore += 'A';
        }
        // and then some more 
         MaxMsgAndMore += LOG_MESSAGE;
        
        System.assertEquals(MAS_UtilityHelper.getMaxLengthForActionLogMessage(MaxMsgAndMore),LOG_MESSAGE_MAX_LEN); // Wrong return??
    }

    @isTest static void isLoggedInWebServiceUser_Test() {
        User readOnlyUser = [SELECT id from User Where UserName = 'sfdc@absi.be'];
        System.runAs(readOnlyUser)
        {
            System.assertEquals(False, MAS_UtilityHelper.isLoggedInWebServiceUser());
        }
    }

}