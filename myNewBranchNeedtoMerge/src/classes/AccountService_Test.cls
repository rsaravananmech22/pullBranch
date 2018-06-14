/**************************************************************************
 * Description  : Test class for MAS_Accounts
 *
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
    1.0        Tharaka De Silva    01/12/2018      Initial implementation
 **************************************************************************/

@isTest
public  class AccountService_Test {

    private static final String STRING_300;
    private static final String STRING_10;
    
    static{
        STRING_300 = MAS_UtilityHelper.generateRandomString(300);
        STRING_10 = MAS_UtilityHelper.generateRandomString(10);
    }
    
    //Public so it can also be called from other test classes
    @testSetup public static void createData() {
        
        //Create custom settings used in trigger handlers
        Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='true'), true);
        Configuration__c c2 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_API_KEY, Value__c='AIzaSyA8RD5_jz_Mint_NTOlDhMqdfX5pAel7NI'), true);
        
        Configuration__c c4 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_USER_NAME, Value__c='mascusserviceusername@test'), true);
        Configuration__c c5 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_PASSWORD, Value__c='mascusservicepassword@test'), true);
        Configuration__c c6 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_WEBSERVICE_URL, Value__c='http://build-e1.mascus.com/api/mascussf.asmx'), true);

        Configuration__c c7 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c='true'), true);
        Configuration__c c8 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACCOUNT_ACCOUNT_TYPE_LEGAL_ENTITY, Value__c='Internal legal entity'), true);

        Configuration__c c9 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACCOUNT_ACCOUNT_TEST_MODE, Value__c='false'), true);
        Configuration__c c10 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.VAT_SERVICE_URL, Value__c='https://vatserviceurl/ws/simple/getTaxNumberValidity'), true);
        Configuration__c c11 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.VAT_SERVICE_USER_NAME, Value__c='vatusername'), true);
        Configuration__c c12 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.VAT_SERVICE_PASSWORD, Value__c='vatpassword'), true);
        Configuration__c c13 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.ACCOUNT_ACCOUNT_TAX_TYPE_VAT, Value__c='vat'), true);

        Configuration__c c14 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_LEAD_TRIGGER_REPEAT, Value__c='false'), true);

        EU_Member_Country__c eu = (EU_Member_Country__c)MAS_TestDataFactory.createSObject(new EU_Member_Country__c(Name = 'Belgium',Country_Code__c='BE'), true);
        EU_Member_Country__c inida = (EU_Member_Country__c)MAS_TestDataFactory.createSObject(new EU_Member_Country__c(Name = 'INDIA',Country_Code__c='IN'), true);

        //Create a customer account and a legal entity
        // Account a = (Account)MAS_TestDataFactory.createSObject(new Account(), true);
        Account a = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Account',Email_for_invoicing__c='Emailforinvoicing@test.com', Phonetic_Account_Name__c = 'Phonetic name will be updated shortly'), true);
        // Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Legal Entity', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);
        Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Legal Entity',Type = 'Internal legal entity', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);   

        Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=a.Id), true);

        //Create a Lead
        Lead l = (Lead)MAS_TestDataFactory.createSObject(new Lead(), true);

        //Create a order
        // Order o = (Order)MAS_TestDataFactory.createSObject(new Order(), true);
        Order o = (Order)MAS_TestDataFactory.createSObject(new Order(AccountId=a.Id, Bill_from_legal_entity__c=legalEntity.Id, Sold_to_Account__c=a.Id, BillToContactId=c.Id, Sold_to_contact__c=c.Id), true);
    }

    @isTest static void testTranslateNonAscii() {

        Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_TRANSLATE_URL, Value__c='https://www.googleapis.com/language/translate/v2'), true);  
        List<Id> lstIds = new List<Id>();
          
        for (Account acc : [SELECT Id FROM Account]){
            lstIds.add(acc.Id);
        }     
        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Account","detectedSourceLanguage": "en"}]}}';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_AccountService.translateNonAscii(lstIds);
        Test.stopTest();

        List<Account> lstAccount = [Select Id,Name,Phonetic_Account_Name__c from Account];
        System.assert(lstAccount != null);
        System.assertEquals(lstAccount[0].Phonetic_Account_Name__c , 'Account');
    }

    @isTest static void testTranslateNonAsciiWithException() {

        List<Id> lstIds = new List<Id>();
          
        for (Account acc : [SELECT Id FROM Account]){
            lstIds.add(acc.Id);
        }     
        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Account","detectedSourceLanguage": "en"}]}}';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_AccountService.translateNonAscii(lstIds);
        Test.stopTest();

        List<Account> lstAccount = [Select Id,Name,Phonetic_Account_Name__c from Account];
        System.assert(lstAccount != null);
        System.assertNotEquals(lstAccount[0].Phonetic_Account_Name__c , 'Account');
        System.assertEquals(lstAccount[0].Phonetic_Account_Name__c , Label.MAS_MSG_Phonetic_Name_Update);
    }

    @isTest static void testUpsertAccountFromMascusInsert() {
         Account acc = [Select Id,Name,Mascus_Customer_Number__c from Account Limit 1];
         MAS_AccountWebService.MAS_AccountRequestDTO req = new MAS_AccountWebService.MAS_AccountRequestDTO();
         req.account_MascusCustomerId = '0000001';
         req.account_Name = 'This is test account name.';   
         req.account_Source = 'Test Account Source';    
         req.account_Industry = 'Test Account Industry.';
         req.account_BillingStreet = 'Test Account Billing Street';
         req.account_BillingCity = 'Test Account Billing City.';
         req.account_BillingStateOrProvince = 'Test Account Billing State Or Province.';
         req.account_BillingZipOrPostalCode = 'Test PostalCode.';
         req.account_BillingCountry = 'NE';
         req.account_PhoneNumber = 'Test Account Phone Number.';
         req.account_EmailForInvoicing = 'testaccountemailfroinvoicing@test.com';
         req.account_Classification = 'Person account';
         req.account_VATNumber = 'Test Account VAT Number.';
         req.account_PrivateTaxNumber = 'TaxNumber';
         req.account_MascusCustomerNumber = 'M01100300';
         req.account_PhonePrefix = '20';
         req.account_Parent = acc.Mascus_Customer_Number__c;
         req.account_ShippingStreet = 'Test Account Shipping Street.';
         req.account_ShippingCity = 'Test Shipping Street.';
         req.account_ShippingState = 'Test Account Shipping State.';
         req.account_ShippingPostalCode =  '20';
         req.account_ShppingCountry = 'NE';
       
         Test.startTest();
         MAS_ResponseDTO response = MAS_AccountWebService.upsertAccount(req);
         Test.stopTest();

         System.assert(response != null);
         System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_DML_SUCCESS_CODE);   
         System.assertEquals(response.responseMessage , MAS_Constant.ACCOUNT_DML_SUCCESS_MSG);  
         System.assert(response.responseResult != null); 
       
    }

    @isTest static void testUpsertAccountFromMascusError() {
         String strMascusCustomerID = 'b5a74548-44cd-46ba-b64e-41111f832755';
         Account acc = [Select Id,Name,Mascus_Customer_Number__c,Mascus_customer_ID__c from Account Limit 1];
         acc.Mascus_customer_ID__c = strMascusCustomerID ; 
         update acc;

         MAS_AccountWebService.MAS_AccountRequestDTO req = new MAS_AccountWebService.MAS_AccountRequestDTO();
         req.account_MascusCustomerId = strMascusCustomerID ;
         req.account_Name = 'This is test account name.';   
         req.account_Source = 'Test Account Source';    
         req.account_Industry = 'Test Account Industry.';
         req.account_BillingStreet = 'Test Account Billing Street';
         req.account_BillingCity = 'Test Account Billing City.';
         req.account_BillingStateOrProvince = 'Test Account Billing State Or Province.';
         req.account_BillingZipOrPostalCode = 'Test PostalCode.';
         req.account_BillingCountry = 'NE';
         req.account_PhoneNumber = 'Test Account Phone Number.';
         req.account_EmailForInvoicing = 'testaccountemailfroinvoicing@test.com';
         req.account_Classification = 'Person account';
         req.account_VATNumber = 'Test Account VAT Number.';
         req.account_PrivateTaxNumber = 'TaxNumber';
         req.account_MascusCustomerNumber = 'M01100300';
         req.account_PhonePrefix = '20';
         req.account_Parent = acc.Mascus_Customer_Number__c;
         req.account_ShippingStreet = 'Test Account Shipping Street.';
         req.account_ShippingCity = 'Test Shipping Street.';
         req.account_ShippingState = 'Test Account Shipping State.';
         req.account_ShippingPostalCode =  '20';
         req.account_ShppingCountry = 'NE';
      
         Test.startTest();
         MAS_ResponseDTO response = MAS_AccountWebService.upsertAccount(req);
         Test.stopTest();
         System.assert(response != null);
         System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_124);   
         System.assert(response.responseMessage != null);      
    }


     @isTest static void testUpsertAccountFromMascusInactive() {
         String strMascusCustomerID = 'b5a74548-44cd-46ba-b64e-41111f832755';
         Account acc = [Select Id,Name,Mascus_Customer_Number__c,Mascus_customer_ID__c from Account Limit 1];
         acc.Mascus_customer_ID__c = strMascusCustomerID ; 
         update acc;

         MAS_AccountWebService.MAS_AccountRequestDTO req = new MAS_AccountWebService.MAS_AccountRequestDTO();
         req.account_MascusCustomerId = strMascusCustomerID ;
         req.account_Status =  MAS_Constant.STATUS_INACTIVE ; 

         Test.startTest();
         MAS_ResponseDTO response = MAS_AccountWebService.upsertAccount(req);
         Test.stopTest();

         System.assert(response != null);
        // System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_DML_SUCCESS_CODE);   
        // System.assertEquals(response.responseMessage , MAS_Constant.ACCOUNT_DML_SUCCESS_MSG);  
        // System.assert(response.responseResult != null); 
     }

    @isTest static void testSyncAccountWithMascusWebSyncedSuccess() {
        List<Id> lstId = new List<Id>();
        List<Account> lstAccount = [Select Id from Account];
        for(Account acc : lstAccount) {
            lstId.add(acc.Id);
        }

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
        MAS_AccountService.syncAccountWithMascusWeb(lstId);
        Test.stopTest();

        List<Account> lstAccountResult = [Select Id from Account where Mascus_Sync_Status__c =:MAS_Constant.STATUS_SYNCED ];
        System.assert(lstAccountResult != null);
        System.assert(lstAccountResult.size() > 0 );
    }

    @isTest static void testSyncAccountWithMascusWebSyncedFail() {
        List<Id> lstId = new List<Id>();
        List<Account> lstAccount = [Select Id from Account];
        for(Account acc : lstAccount) {
            lstId.add(acc.Id);
        }

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_NEED_TO_BE_SYNCED));
        MAS_AccountService.syncAccountWithMascusWeb(lstId);
        Test.stopTest();

        List<Account> lstAccountResult = [Select Id from Account where Mascus_Sync_Status__c =:MAS_Constant.STATUS_NEED_TO_BE_SYNCED ];
        System.assert(lstAccountResult != null);
        System.assert(lstAccountResult.size() > 0 );
    }

    @isTest static void testSyncAccountWithMascusWebSyncedException() {
        List<Id> lstId = new List<Id>();
        List<Account> lstAccount = [Select Id from Account];
        for(Account acc : lstAccount) {
            lstId.add(acc.Id);
        }

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl());
        MAS_AccountService.syncAccountWithMascusWeb(lstId);
        Test.stopTest();

        List<String> lstString = new List<String>();
        lstString.add(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE);
        lstString.add(MAS_Constant.STATUS_NEED_TO_BE_SYNCED);
        List<Account> lstAccountResult = [Select Id,Mascus_Sync_Status__c from Account where Mascus_Sync_Status__c not in :lstString];

        System.assert(lstAccountResult != null);
        System.assert(lstAccountResult.size() > 0 );
    }

    @isTest static void testSyncLeadAccountWithMascusSuccess() {

        List<Lead> lstAccountsExport = [Select Id,Name from Lead];
        String strJson = JSON.serialize(lstAccountsExport);

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
        MAS_AccountService.syncLeadAccountWithMascus(strJson);
        Test.stopTest();

    }

    @isTest static void testSyncLeadAccountWithMascusFail() {

        List<Lead> lstAccountsExport = [Select Id,Name from Lead];
        String strJson = JSON.serialize(lstAccountsExport);

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_NEED_TO_BE_SYNCED));
        MAS_AccountService.syncLeadAccountWithMascus(strJson);
        Test.stopTest();

    }

    @isTest static void testSyncLeadAccountWithMascusException() {

        List<Lead> lstAccountsExport = [Select Id,Name from Lead];
        String strJson = JSON.serialize(lstAccountsExport);

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl());
        MAS_AccountService.syncLeadAccountWithMascus(strJson);
        Test.stopTest();

    }

    @isTest static void testAccountVatCheck() {
         Account acc = [Select Id,Valid_for_international_TAX__c,Valid_for_Local_TAX__c,Classification__c,BillingCountryCode from Account Limit 1];
         Order ord = [Select Id,Bill_from_legal_entity__r.BillingCountryCode,Bill_from_legal_entity__r.VAT_Number__c,BillingCountryCode from Order Limit 1];

         acc.Valid_for_international_TAX__c = true;
         acc.Valid_for_Local_TAX__c = true;
         
         system.debug(acc);
         update acc;
         MAS_ResponseDTO response = new MAS_ResponseDTO();

         Test.startTest();

          //Check tax local or international validity
         response = MAS_AccountService.vatcheckforAccount(acc.Id , null);
         System.assert(response != null);
         System.assertEquals(response.responseType , MAS_Constant.RESPONSE_TYPE_SUCCESS);

          //If account is assciated with order, vat validation is a must
         acc.Valid_for_international_TAX__c = false;
         acc.Valid_for_Local_TAX__c = false;
         //acc.Valid_VAT__c = true;
         update acc;

         response = MAS_AccountService.vatcheckforAccount(acc.Id , null);
         System.assert(response != null);
         System.assertEquals(response.responseType , MAS_Constant.RESPONSE_TYPE_ERROR);

         // Vat number check
         acc.VAT_Number__c = null;
         update acc;

         response = MAS_AccountService.vatcheckforAccount(acc.Id , ord);
         System.assert(response != null);
         System.assertEquals(response.responseType , MAS_Constant.RESPONSE_TYPE_ERROR);

         // EU member check - Custom setting
         acc.Valid_VAT__c = false;
         acc.VAT_Number__c = 'VAT-000001';
         update acc;

         response = MAS_AccountService.vatcheckforAccount(acc.Id , null);
         System.assert(response != null);
         System.assertEquals(response.responseType , MAS_Constant.RESPONSE_TYPE_ERROR);

         acc.BillingCountryCode = 'CR';
         update acc;
         
         
         response = MAS_AccountService.vatcheckforAccount(acc.Id , null);
         System.assert(response != null);
         System.assertEquals(response.responseType , MAS_Constant.RESPONSE_TYPE_ERROR);

         //Provide Order 
         //Thrown an error because not set custom settings
         response = MAS_AccountService.vatcheckforAccount(acc.Id , ord);
         System.assert(response != null);
         System.assertEquals(response.responseType , MAS_Constant.RESPONSE_TYPE_ERROR);

         Test.stopTest();
    }

    @isTest static void testAccountVatCheckordernull(){
        Account acc = [Select Id,Valid_for_international_TAX__c,Valid_for_Local_TAX__c,Classification__c,BillingCountryCode from Account Limit 1];
         Order ord = [Select Id,Bill_from_legal_entity__r.BillingCountryCode,Bill_from_legal_entity__r.VAT_Number__c from Order Limit 1];
       
         acc.Valid_for_international_TAX__c = false;
         acc.Valid_for_Local_TAX__c = false;
         acc.VAT_Number__c='123456777';
         //acc.Classification__c='Business account';
         acc.BillingCountryCode='IN';
         system.debug(acc);
         update acc;
         Account acc2 = [Select Id,VAT_Number__c from Account where type='Internal legal entity' Limit 1];
         acc2.VAT_Number__c='123423423sd';
        update acc2;
         MAS_ResponseDTO response = new MAS_ResponseDTO();

         Test.startTest();
        response = MAS_AccountService.vatcheckforAccount(acc.Id , null);
        Test.stopTest();
    }


    @isTest static void testAccountNamesToPhoneticBatch() {       

        Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_TRANSLATE_URL, Value__c='https://www.googleapis.com/language/translate/v2'), true);  
        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Account","detectedSourceLanguage": "en"}]}}';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_AccountNamesToPhoneticBatch batch = new MAS_AccountNamesToPhoneticBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        List<Account> lstAccount = [Select Id,Name,Phonetic_Account_Name__c from Account where Name =: 'Account'];
        System.assert(lstAccount != null);
        System.assertEquals(lstAccount[0].Phonetic_Account_Name__c , 'Account');
    }


    @isTest static void testAccountNamesToPhoneticBatchWithException() {       

        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Account","detectedSourceLanguage": "en"}]}}';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_AccountNamesToPhoneticBatch batch = new MAS_AccountNamesToPhoneticBatch();
        Id batchId = Database.executeBatch(batch);     
        Test.stopTest();

        List<Account> lstAccount = [Select Id,Name,Phonetic_Account_Name__c from Account where Name =: 'Account'];
        System.assert(lstAccount != null);
        System.assertNotEquals(lstAccount[0].Phonetic_Account_Name__c , 'Áccount');
    }

    @isTest static void testAccountNamesToPhoneticBatchWithUpdateException() {       

        Account acc2 = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Test Áccount'), true);
        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Account","detectedSourceLanguage": "en"}]}}';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_AccountNamesToPhoneticBatch batch = new MAS_AccountNamesToPhoneticBatch();
        Id batchId = Database.executeBatch(batch);     
        Test.stopTest();

        List<Account> lstAccount = [Select Id,Name,Phonetic_Account_Name__c from Account where Name =: 'Test Áccount'];
        System.assert(lstAccount != null);
        System.assertNotEquals(lstAccount[0].Phonetic_Account_Name__c , 'Account');
        System.assertEquals(lstAccount[0].Phonetic_Account_Name__c , Label.MAS_MSG_Phonetic_Name_Update);
    }

    @isTest static void testValidateAccountFromMascus() {

        MAS_AccountWebService.MAS_AccountRequestDTO req = new MAS_AccountWebService.MAS_AccountRequestDTO();
        
       
        Test.startTest();

        req.account_MascusCustomerId = '';
        MAS_ResponseDTO response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_120);
        
        req.account_MascusCustomerId = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_121);

        req.account_MascusCustomerId = STRING_10;
        req.account_Status = 'Active';
        req.account_Name = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_101);

        req.account_Name = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_102);

        req.account_Name = STRING_10;
        req.account_Source = '';    
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_104);

        req.account_Source = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_130);

        req.account_Source = STRING_10;
        req.account_Industry = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_105);

        req.account_Industry = STRING_10;
        req.account_BillingStreet = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_106);

        req.account_BillingStreet = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_107);

        req.account_BillingStreet = STRING_10;
        req.account_BillingCity = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_108);

        req.account_BillingCity = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_109);

        req.account_BillingCity = STRING_10;
        req.account_BillingStateOrProvince = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_110);

        req.account_BillingStateOrProvince = STRING_10;
        req.account_BillingZipOrPostalCode = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_111);

        req.account_BillingZipOrPostalCode = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_112);

        req.account_BillingZipOrPostalCode = STRING_10;
        req.account_BillingCountry = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_113);

        req.account_BillingCountry = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_114);

        req.account_BillingCountry = '--';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_118);

        req.account_BillingCountry = 'NE';
        req.account_PhoneNumber = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_115);

        req.account_BillingCountry = 'NE';
        req.account_PhoneNumber = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_116);

        req.account_BillingCountry = 'NE';
        req.account_PhoneNumber = STRING_10;
        req.account_EmailForInvoicing = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_126);

        req.account_BillingCountry = 'NE';
        req.account_EmailForInvoicing = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_127);

        req.account_BillingCountry = 'NE';
        req.account_EmailForInvoicing = STRING_10;
        req.account_Classification = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_117);

        req.account_BillingCountry = 'NE';
        req.account_Classification = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_117);

        req.account_BillingCountry = 'NE';
        req.account_Classification = 'Business account';
        req.account_VATNumber = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_122);

        req.account_BillingCountry = 'NE';
        req.account_VATNumber = STRING_10;
        req.account_PrivateTaxNumber = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_123);

        req.account_BillingCountry = 'NE';
        req.account_PrivateTaxNumber = STRING_10;
        req.account_MascusCustomerNumber = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_139);

        req.account_BillingCountry = 'NE';
        req.account_MascusCustomerNumber = STRING_10;
        req.account_PhonePrefix = '';
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_132);

        req.account_BillingCountry = 'NE';
        req.account_PhonePrefix = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_133);

        req.account_BillingCountry = 'NE';
        req.account_PhonePrefix = STRING_10;
        req.account_Parent = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_142);

        req.account_BillingCountry = 'NE';
        req.account_Parent = STRING_10;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_142);

        req.account_BillingCountry = 'NE';
        req.account_Parent = '';
        req.account_ShippingStreet = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_134);

        req.account_BillingCountry = 'NE';
        req.account_ShippingStreet = STRING_10;
        req.account_ShippingCity = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_135);

        req.account_BillingCountry = 'NE';
        req.account_ShippingCity = STRING_10;
        req.account_ShippingState = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_136);

        req.account_BillingCountry = 'NE';
        req.account_ShippingState = STRING_10;
        req.account_ShippingPostalCode = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_137);

        req.account_BillingCountry = 'NE';
        req.account_ShippingPostalCode = STRING_10;
        req.account_ShppingCountry = STRING_300;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_138);

        req.account_BillingCountry = 'NE';
        req.account_ShppingCountry = STRING_10;
        response = MAS_AccountWebService.upsertAccount(req);
        System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_ERROR_CODE_140);

        // If we execute below codes this validate methods all passed and upsert will fire.

        // req.account_BillingCountry = 'NE';
        // req.account_ShppingCountry = 'NE';
        // response = MAS_AccountWebService.upsertAccount(req);
        // System.assertEquals(response.responseCode , MAS_Constant.ACCOUNT_VALIDATION_SUCCESS_CODE);

        Test.stopTest();

    }
    
    @isTest static void testValidateAccountForOrder(){

        List<Id> accIds=new List<Id>();
        List<Account> updateAccount=new List<Account>();
        for(Account acc:[SELECT Id,Phonetic_Account_Name__c,Status__c from Account])
        {
            acc.Phonetic_Account_Name__c=null;
            updateAccount.add(acc);
            accIds.add(acc.id);
        }
        update updateAccount;
        Test.startTest();
        MAS_ResponseDTO res=MAS_AccountService.validateAccountForOrder(accIds);
        Test.stopTest();
        system.assertEquals('Related accounts phonetic names can not be empty.', res.responseMessage);
        system.assertEquals('error', res.responseType);
    }
    
    @isTest static void testValidateInactiveAccountForOrder(){

        List<Id> accIds=new List<Id>();
        List<Account> updateAccount=new List<Account>();
        for(Account acc:[SELECT Id,Phonetic_Account_Name__c,Status__c from Account])
        {
            acc.Status__c='Inactive';
            updateAccount.add(acc);
            accIds.add(acc.id);
        }
        update updateAccount;
        Test.startTest();
        MAS_ResponseDTO res=MAS_AccountService.validateAccountForOrder(accIds);
        Test.stopTest();
        system.assertEquals('Related accounts are not active', res.responseMessage);
        system.assertEquals('error', res.responseType);
    }
    
    @isTest static void testValidateAccountForOrderSuccess(){

        List<Id> accIds=new List<Id>();
        
        for(Account acc:[SELECT Id,Phonetic_Account_Name__c,Status__c from Account])
        {
            accIds.add(acc.id);
        }
        Test.startTest();
        MAS_ResponseDTO res=MAS_AccountService.validateAccountForOrder(accIds);
        Test.stopTest();
       
    }
   
    public static String generateRandomString(Integer len) {
        String CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), CHARS.length());
        randStr += CHARS.substring(idx, idx+1);
        }
        return randStr; 
    }


}