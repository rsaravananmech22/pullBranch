/**************************************************************************
 * Description  : Test class for MAS_Leads
 *
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
    1.0        Kavinda Inusha    01/12/2018      Initial implementation
 **************************************************************************/
@isTest
public class LeadService_Test {

    private static final String STRING_300;
    private static final String STRING_10;
    
    static{
        STRING_300 = MAS_UtilityHelper.generateRandomString(300);
        STRING_10 = MAS_UtilityHelper.generateRandomString(10);
    }
   
    //Public so it can also be called from other test classes
	@testSetup public static void createData() {
		//Create custom settings used in trigger handlers
		Configuration__c c1 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_CONTACT_TRIGGER_REPEAT, Value__c='false'), true);
		Configuration__c c2 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_API_KEY, Value__c='AIzaSyA8RD5_jz_Mint_NTOlDhMqdfX5pAel7NI'), true);
		Configuration__c c2b = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.GOOGLE_TRANSLATE_URL, Value__c='https://www.googleapis.com/language/translate/v2'), true);
		Configuration__c c3 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_ACCOUNT_TRIGGER_REPEAT, Value__c='true'), true);
        
		Contact con1 = (Contact)MAS_TestDataFactory.createSObject(new Contact(LastName = 'Liyanage', Phonetic_Contact_First_Name__c = 'Phonetic name will be updated shortly', Phonetic_Contact_Last_Name__c = 'Liyanage', Mascus_contact_ID__c = STRING_10), true);
		Contact con2 = (Contact)MAS_TestDataFactory.createSObject(new Contact(LastName = 'Liyanage', Phonetic_Contact_First_Name__c = 'Virath', Phonetic_Contact_Last_Name__c = 'Phonetic name will be updated shortly', Mascus_contact_ID__c = '003440024200344002420034400242003440024299'), true);
		//Create a contact for the customer account
		//Contact c = (Contact)MAS_TestDataFactory.createSObject(new Contact(AccountId=con.Id), true);	
		//
		Configuration__c c4 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_USER_NAME, Value__c='mascusserviceusername@test'), true);
		Configuration__c c5 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_SERVICE_PASSWORD, Value__c='mascusservicepassword@test'), true);
        Configuration__c c6 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.MASCUS_WEBSERVICE_URL, Value__c='http://build-e1.mascus.com/api/mascussf.asmx'), true);
        Configuration__c c7 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.LEAD_STATUS_OPEN, Value__c='http://build-e1.mascus.com/api/mascussf.asmx'), true);
        Configuration__c c8 = (Configuration__c)MAS_TestDataFactory.createSObject(new Configuration__c(Name=MAS_Constant.IS_LEAD_TRIGGER_REPEAT, Value__c='false'), true);
        //Create a customer account and a legal entity
		Account a = (Account)MAS_TestDataFactory.createSObject(new Account(Mascus_customer_ID__c = STRING_10), true);
		Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name='Legal Entity', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);	
		        
        //Create a Lead
		Lead l = (Lead)MAS_TestDataFactory.createSObject(new Lead(LastName='Liyanage', Mascus_Account_ID__c = STRING_10, Mascus_contact_ID__c = STRING_10 ), true);
		update l;
        //Create a order
        //Order o = (Order)MAS_TestDataFactory.createSObject(new Order(), true);

        List<LeadFieldsToSync__c> lstLeadFieldsToSync =  new List<LeadFieldsToSync__c>();
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Mascus_Account_ID__c' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Company' , Object__c = 'Account' , SyncWithAccountContact__c = false));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Status' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Mobile_Prefix__c' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Mascus_Lead_Number__c' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'PostalCode' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'LastName' , Object__c = 'Contact' , SyncWithAccountContact__c = false));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'State' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Mascus_contact_ID__c' , Object__c = 'Contact' , SyncWithAccountContact__c = false));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Street' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'MobilePhone' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        lstLeadFieldsToSync.add(new LeadFieldsToSync__c(Name = 'Country' , Object__c = 'Account' , SyncWithAccountContact__c = true));
        INSERT lstLeadFieldsToSync;
    }

    @isTest static void testValidateLeadFromMascus(){

        MAS_LeadWebservice.MAS_LeadRequestDTO req = new MAS_LeadWebservice.MAS_LeadRequestDTO();

        Test.startTest();

        MAS_ResponseDTO response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_101);

        req.Lead_CompanyName = STRING_300; // MAX = 255
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_102);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_104);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Fake Value';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_103);

        
        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_300; // MAX = 80
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_105);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_106);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_300; // MAX = 255
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_107);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_108);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix =STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_300; // MAX = 40
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_109);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Fake Value';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_110);
        
        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_111);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_300; // MAX = 255
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_112);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_300; // MAX = 80
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_113);

        req.Lead_CompanyName =STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_114);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber =STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_114);  

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix =STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_300; // MAX = 20
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_115); 

         req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_116);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = STRING_300; // MAX = 80 
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_117);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'Invalid_Country';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_124);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_118);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_300; // MAX = 200 
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_119);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_300; // MAX = 30 
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_120);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_10; // MAX = 30 
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_121);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_10; // MAX = 30  
        req.Lead_MascusContactGUID = STRING_300; // MAX = 200  
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_122);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_10; // MAX = 30  
        req.Lead_MascusContactGUID = STRING_10; // MAX = 200  
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_125);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_10; // MAX = 30  
        req.Lead_MascusContactGUID = STRING_10; // MAX = 200  
        req.Lead_City =  STRING_300; // MAX = 40  
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_126);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_10; // MAX = 30  
        req.Lead_MascusContactGUID = STRING_10; // MAX = 200  
        req.Lead_City = STRING_10; // MAX = 40  
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_127);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_10; // MAX = 30  
        req.Lead_MascusContactGUID = STRING_10; // MAX = 200  
        req.Lead_City = STRING_10; // MAX = 40  
        req.Lead_Email = 'kavinda.wickramasingha@absi.be';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_123);

        req.Lead_CompanyName = STRING_10; // MAX = 255
        req.Lead_Classification = 'Business account';
        req.Lead_LastName = STRING_10; // MAX = 80
        req.Lead_MobilePrefix = STRING_10; // MAX = 255
        req.Lead_MobileNumber = STRING_10; // MAX = 40
        req.Lead_source = 'Advertisement';
        req.Lead_Street = STRING_10; // MAX = 255
        req.Lead_State = STRING_10; // MAX = 80 
        req.Lead_PostalCode = STRING_10; // MAX = 20 
        req.Lead_Country = 'BE';
        req.Lead_MascusAccountGUID = STRING_10; // MAX = 200 
        req.Lead_MascusLeadNumber =  STRING_10; // MAX = 30  
        req.Lead_MascusContactGUID = STRING_10; // MAX = 200  
        req.Lead_City = STRING_10; // MAX = 40  
        req.Lead_Email = 'kavinda.wickramasingha@absi.be';
        req.Lead_Status = 'omitted';
        response = MAS_LeadWebService.upsertLead(req);
        System.assertEquals(response.responseCode , MAS_Constant.LEAD_ERROR_CODE_123);
        
        
                system.debug(STRING_10);
        // To be need to continue vith OrderItem Discount 30% validation error.
        // And also need clean and optimize test class

        Test.stopTest();

    }

    @isTest static void deleteLead_Test()
    {
        Lead l2 = (Lead)MAS_TestDataFactory.createSObject(new Lead(LastName='TEst_LeadName', Mascus_Account_ID__c = 'TestLead', Mascus_contact_ID__c = 'TestLead' ), true);
        delete l2;
        
        System.assertEquals(0, [SELECT Count() FROM Lead WHERE LastName='TEst_LeadName']);
        
    }

    @isTest static void testSyncLeadsWithMascus_Generate_Accounts_Contacts()
    {
        Lead leadObj = (Lead)MAS_TestDataFactory.createSObject(new Lead(LastName='TestLead', Mascus_Account_ID__c = 'TestLead', Mascus_contact_ID__c = 'TestLead', Company = 'CMS'), true);
        leadObj.Company = 'ABSI';
		UPDATE leadObj;
        Test.startTest();
        leadObj.Company = 'SLK';
		UPDATE leadObj;
        Test.stopTest();
        leadObj = [ SELECT Id, Name, Company FROM Lead WHERE Company = 'SLK' LIMIT 1 ];
        System.assertEquals(leadObj.Company, 'SLK');
    }

}