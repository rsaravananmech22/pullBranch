@isTest
public class ContactService_Test {

	//Public so it can also be called from other test classes
	@testSetup public static void createData() {
		//Create custom settings used in trigger handlers
		Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c='false'), true);
		Configuration__c c2 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_API_KEY, Value__c='AIzaSyA8RD5_jz_Mint_NTOlDhMqdfX5pAel7NI'), true);
		Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='true'), true);
        
		Contact con1 = (Contact)MAS_TestDataFactory.createSObject(new Contact(LastName = 'Liyanage', Phonetic_Contact_First_Name__c = 'Phonetic name will be updated shortly', Phonetic_Contact_Last_Name__c = 'Liyanage', Mascus_contact_ID__c = '003440024200344002420034400242003440024298'), true);
		Contact con2 = (Contact)MAS_TestDataFactory.createSObject(new Contact(LastName = 'Liyanage', Phonetic_Contact_First_Name__c = 'Virath', Phonetic_Contact_Last_Name__c = 'Phonetic name will be updated shortly', Mascus_contact_ID__c = '003440024200344002420034400242003440024299'), true);
		//Create a contact for the customer account
		//Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=con.Id), true);	
		//
		Configuration__c c4 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_USER_NAME, Value__c='mascusserviceusername@test'), true);
		Configuration__c c5 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_PASSWORD, Value__c='mascusservicepassword@test'), true);
        Configuration__c c6 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_WEBSERVICE_URL, Value__c='http://build-e1.mascus.com/api/mascussf.asmx'), true);
        
        //Create a customer account and a legal entity
		Account a = (Account)MAS_TestDataFactory.createSObject(new Account(), true);
		Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Legal Entity', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);	
		        
        //Create a Lead
		Lead l = (Lead)MAS_TestDataFactory.createSObject(new Lead(LastName='Liyanage', Mascus_contact_ID__c = '003440024200344002420034400242003440024298'), true);

        //Create a order
        //Order o = (Order)MAS_TestDataFactory.createSObject(new Order(), true);
    }

	@isTest static void testTranslateNonAscii() {
		Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_TRANSLATE_URL, Value__c='https://www.googleapis.com/language/translate/v2'), true);  

        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Contact","detectedSourceLanguage": "en"}]}}';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));

        MAS_ContactService.translateNonAscii(strResponce, 'Virath');
        Test.stopTest();

        List<Contact> lstContact = [ Select Id, Name, Phonetic_Contact_First_Name__c, Phonetic_Contact_Last_Name__c from Contact ];

        System.assert(lstContact != null);
        System.assertEquals(lstContact[0].Phonetic_Contact_Last_Name__c , 'Liyanage');
	}

	@isTest static void testTranslateNonAsciiWithAndWithoutError() {

        Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_TRANSLATE_URL, Value__c='https://www.googleapis.com/language/translate/v2'), true);  
        List<Id> lstIds = new List<Id>();
          
        for (Contact con : [ SELECT Id FROM Contact ]){
            lstIds.add(con.Id);
        } 
		    
        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Contact","detectedSourceLanguage": "en"}]}}';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_ContactService.translateNonAscii(lstIds);
        Test.stopTest();

        List<Contact> lstContact = [ Select Id, Name, Phonetic_Contact_First_Name__c, Phonetic_Contact_Last_Name__c from Contact ];

        System.assert(lstContact != null);
        System.assertEquals(lstContact[0].Phonetic_Contact_Last_Name__c , 'Liyanage');
    }

    @isTest static void testContactamesToPhoneticBatch() {       

        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Contact","detectedSourceLanguage": "en"}]}}';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_ContactNamesToPhoneticBatch batch = new MAS_ContactNamesToPhoneticBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        List<Contact> lstContact = [ Select Id, Name, Phonetic_Contact_First_Name__c, Phonetic_Contact_Last_Name__c from Contact ];
        System.assert(lstContact != null);
        System.assertEquals(lstContact[0].Phonetic_Contact_Last_Name__c , 'Liyanage');
    }

    @isTest static void testContactNamesToPhoneticBatchWithLastNameException() {       

        Contact cont = (Contact)MAS_TestDataFactory.createSObject(new Contact(LastName = 'Áwaon', FirstName='FirstName',  Mascus_contact_ID__c = '2420034400242003440024240024298'), true);

        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Áwaon","detectedSourceLanguage": "en"}]}}';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_ContactNamesToPhoneticBatch batch = new MAS_ContactNamesToPhoneticBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        List<Contact> lstContact = [ Select Id, Name, Phonetic_Contact_First_Name__c, Phonetic_Contact_Last_Name__c from Contact ];
        System.assert(lstContact != null);
    }

   @isTest static void testContactNamesToPhoneticBatchWithFirstNameException() {       

        Contact cont = (Contact)MAS_TestDataFactory.createSObject(new Contact(LastName = 'LastName', FirstName='Áwaon',  Mascus_contact_ID__c = '24200344002420034400242003440'), true);

        String strResponce =  '{"data": { "translations": [ {  "translatedText": "Áwaon","detectedSourceLanguage": "en"}]}}';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MAS_HttpCalloutMockImpl(200,
                                                 'Complete', 
                                                 strResponce ,
                                                 null));
        MAS_ContactNamesToPhoneticBatch batch = new MAS_ContactNamesToPhoneticBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        List<Contact> lstContact = [ Select Id, Name, Phonetic_Contact_First_Name__c, Phonetic_Contact_Last_Name__c from Contact ];
        System.assert(lstContact != null);
    }

	@isTest static void testValidateContactFromMascus(){

        MAS_ContactWebService.MAS_ContactRequestDTO req = new MAS_ContactWebService.MAS_ContactRequestDTO();
		req.contact_MascusGUID = '003440024200344002420034400242003440024298';
		string strMascusNumber =  [ SELECT Id, Mascus_Customer_Number__c FROM Account LIMIT 1].Mascus_Customer_Number__c;
        
        Test.startTest();
        MAS_ResponseDTO response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_100);
        
        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_Status = MAS_Constant.STATUS_INACTIVE ; 
        req.contact_AccountId = 'M0000000';
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_123);
        
        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_MascusGUID = '003440024200344002420034400242003440024298';
        req.contact_Status = MAS_Constant.STATUS_INACTIVE ; 
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_125);
        
        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_MascusGUID = '003440024200344002420034400242003440024298';
        req.contact_AccountId = 'M0000000';
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_129);
        
        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_MascusGUID = '003440024200344002420034400242003440024298';
        req.contact_AccountId = strMascusNumber;
        req.contact_Email = 'virath@wrong';
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_107);
        
        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_MascusGUID = '003440024200344002420034400242003440024298';
        req.contact_AccountId = strMascusNumber;
        req.contact_Email = 'virath@absi.be';
       	req.contact_MailingStreet = '55/8';
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_109);
        
        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_MascusGUID = '003440024200344002420034400242003440024298';
        req.contact_AccountId = strMascusNumber;
        req.contact_Email = 'virath@absi.be';
       	req.contact_MailingStreet = '55/8';
        req.contact_MailingCity = 'Battaramulla';
        
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_113);
        
        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_MascusGUID = '003440024200344002420034400242003440024298';
        req.contact_AccountId = strMascusNumber;
        req.contact_Email = 'virath@absi.be';
       	req.contact_MailingStreet = '55/8';
        req.contact_MailingCity = 'Battaramulla';
        req.contact_MailingZipOrPostalCode = '10120';
            
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_115);

        req = new MAS_ContactWebService.MAS_ContactRequestDTO();
        req.contact_MascusGUID = '003440024200344002420034400242003440024298';
        req.contact_AccountId = strMascusNumber;
        req.contact_Email = 'virath@absi.be';
       	req.contact_MailingStreet = '55/8';
        req.contact_MailingCity = 'Battaramulla';
        req.contact_MailingZipOrPostalCode = '10120';
        req.contact_Mailing_Country = 'LK';
        req.contact_FirstName = 'Virath';
        req.contact_LastName = 'Liyanage';
        req.contact_PhoneNumber = '0714240084';
        req.contact_Role = 'IT';
        req.contact_MascusContactNumber = '00000';
		req.contact_PhonePrefix = 'LK';
        
        response = MAS_ContactWebService.upsertContact(req);
        
        System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_125);
        system.debug(response.responseMessage + 'VC ###' + response.responseCode);
        Test.stopTest();

        System.assert(response != null);
    }

	@isTest static void testUpsertContactFromMascus(){

        MAS_ContactWebService.MAS_ContactRequestDTO req = new MAS_ContactWebService.MAS_ContactRequestDTO();
		req.contact_MascusGUID = '003440024200344002420034400242003440024298';
            
        Test.startTest();
        MAS_ResponseDTO response = MAS_ContactService.upsertContactFromMascus(req);
        
        req.contact_MascusGUID = '003440024200344002420034400242003440024300';
        req.contact_Status = MAS_Constant.STATUS_ACTIVE;
        req.contact_AccountId = [ SELECT Id, Mascus_Customer_Number__c FROM Account LIMIT 1].Mascus_Customer_Number__c;
        req.contact_Email = 'virath@absi.be';
       	req.contact_MailingStreet = '55/8';
        req.contact_MailingCity = 'Battaramulla';
        req.contact_MailingZipOrPostalCode = '10120';
        req.contact_Mailing_Country = 'LK';
        req.contact_FirstName = 'Virath';
        req.contact_LastName = 'Liyanage';
        req.contact_PhoneNumber = '0714240084';
        req.contact_Role = 'IT';
        req.contact_MascusContactNumber = '00000';
		req.contact_PhonePrefix = 'LK';
        
        response = MAS_ContactService.upsertContactFromMascus(req);
        
        Test.stopTest();

        System.assert(response != null);
		System.assertEquals(response.responseCode , MAS_Constant.CONTACT_ERROR_CODE_125);
    }
    
    @isTest static void testSyncContactWithMascusWeb() {
        List<Id> lstId = new List<Id>();
        List<Contact> lstContact = [ SELECT Id FROM Contact ];
        
        for(Contact con : lstContact) 
            lstId.add(con.Id);
       
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
        MAS_ContactService.syncContactWithMascusWeb(lstId);
        Test.stopTest();
        
        List<Contact> lstContactResult = [ SELECT Id from Contact where Mascus_Sync_Status__c =:MAS_Constant.STATUS_SYNCED ];
        System.assert(lstContactResult != null);
        System.assert(lstContactResult.size() > 0 );
        
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_NEED_TO_BE_SYNCED));
        MAS_ContactService.syncContactWithMascusWeb(lstId);
	}
    
    @isTest static void testSyncContactWithMascusWebWithError(){
        List<Id> lstId = new List<Id>();
        List<Contact> lstContact = [ SELECT Id FROM Contact ];
        
        for(Contact con : lstContact) 
            lstId.add(con.Id);
       
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl());
        MAS_ContactService.syncContactWithMascusWeb(lstId);
        Test.stopTest();
	}
    
    @isTest static void testSyncLeadContactWithAndWithoutError(){
        
        List<Lead> lstContactsExport = [ SELECT Id, Name, LastName, Mascus_contact_ID__c FROM Lead ];
        String strJson = JSON.serialize(lstContactsExport);

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
        MAS_ContactService.syncLeadContactWithMascus(strJson);
        Test.stopTest();
        
        lstContactsExport = [ SELECT Id, Name FROM Lead ];
        strJson = JSON.serialize(lstContactsExport);
        
        Test.setMock(WebServiceMock.class, new MAS_WebServiceMockImpl(MAS_Constant.STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE));
        MAS_ContactService.syncLeadContactWithMascus(strJson);
	}
    
    @isTest static void testValidateContactForOrder(){
           
    	List<Id> lstContactIds = New List<Id>();
        
        for(Contact con: [ SELECT Id, LastName FROM Contact ])
            lstContactIds.add(con.Id);
            
        Test.startTest();
        MAS_ResponseDTO response = MAS_ContactService.validateContactForOrder(lstContactIds); 
        Test.stopTest();
    }
    
    @isTest static void testValidateMailingAddressForOrder(){
           
    	Map<Id,String> mapContactIds = New Map<Id,String>();
        
        for(Contact con: [ SELECT Id, LastName FROM Contact ])
            mapContactIds.put(con.Id, con.LastName);
            
        Test.startTest();
        MAS_ResponseDTO response = MAS_ContactService.validateMailingAddressForOrder(mapContactIds); 
        Test.stopTest();
    }

    public static testmethod void testMAS_ContactNamesToPhoneticScheduler(){
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        System.schedule('TestSchedule', CRON_EXP, new MAS_ContactNamesToPhoneticScheduler());  
        Test.stopTest();
        List<Contact> lstContact = [ Select Id FROM Contact ];
        System.assert(lstContact != null);
    } 

}