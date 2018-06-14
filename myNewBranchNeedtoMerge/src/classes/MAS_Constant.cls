/**************************************************************************
 * Description  : Apex Class for store all the constants
 * ========================================================================
 * History/Comments                                                       
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       25/09/2019      Initial implementation
 **************************************************************************/
public class MAS_Constant {

    //Adyen
    public static final String ADYEN_PAYMENT_URL = 'AdyenPaymentUrl';
    public static final String ADYEN_KEY = 'AdyenKey';
    
    public static final String IS_ACCOUNT_TRIGGER_REPEAT = 'IsAccountTriggerRepeat';
    public static final String IS_CONTACT_TRIGGER_REPEAT = 'IsContactTriggerRepeat';
    public static final String IS_LEAD_TRIGGER_REPEAT = 'IsLeadTriggerRepeat';
    public static final String GOOGLE_TRANSLATE_URL = 'GoogleTranslateUrl';
    public static final String GOOGLE_API_KEY = 'GoogleAPIKey';

    //Account & contact status
    public static final String STATUS_ACTIVE = 'Active';
    public static final String STATUS_INACTIVE = 'Inactive';
    public static final String CONTACT_ROLE_INVOICING = 'Invoicing contact';
    public static final String STATUS_SUCCESS_MASCUS_WEB_SERVICE_RESPONSE= 'Success';
    
    //Order status
    public static final String ORDER_STATUS_ACTIVE = 'Activated'; //Activated
    public static final String ORDER_STATUS_DRAFT = 'Draft';
    public static final String ORDER_STATUS_REJECTED = 'Rejected';
    
    //Order Sourcce
    public static final String  ORDER_SOURCE_MASCUS_WEB = 'Mascus web';

    //Order Record Type
    public static final String ORDER_RECORD_TYPE_ACTIVATED = 'Approved order';
    public static final String ORDER_RECORD_TYPE_DRAFT = 'Order';

    //Error types
    public static final String RESPONSE_TYPE_ERROR = 'error';
    public static final String RESPONSE_TYPE_WARNING = 'warning';
    public static final String RESPONSE_TYPE_INFO = 'info';
    public static final String RESPONSE_TYPE_SUCCESS = 'success';

    //Vat service
    public static final String VAT_SERVICE_URL = 'VatServiceUrl';
    public static final String VAT_SERVICE_USER_NAME = 'VatServiceUserName';
    public static final String VAT_SERVICE_PASSWORD = 'VatServicePassword';
    public static final String VAT_SERVICE_RESONSE_SUCCESS= 'OK';

    //Mascus service username and password
    public static final String MASCUS_SERVICE_USER_NAME = 'MascusUserName';
    public static final String MASCUS_SERVICE_PASSWORD = 'MascusUserPassword';
    public static final String MASCUS_WEBSERVICE_URL = 'MascusWebServiceUrl';
    public static final String SYNC_WITH_MASCUS_SUCCESS_CODE = '200';
    public static final String ERROR_MESSAGE = 'Error Occured..!';

    //Contact field names, Error codes & Error messages
    public static final String CONTACT_OWNER_ID = 'OwnerId';
    public static final String CONTACT_EMAIL = 'Email';
    public static final String CONTACT_MAILING_STREET = 'MailingStreet';
    public static final String CONTACT_MAILING_CITY = 'MailingCity';
    public static final String CONTACT_MAILING_STATE = 'MailingState';
    public static final String CONTACT_MAILING_POSTAL_CODE = 'MailingPostalCode';
    public static final String CONTACT_MAILING_COUNTRY = 'MailingCountryCode';
    public static final String CONTACT_FIRST_NAME = 'FirstName';
    public static final String CONTACT_LAST_NAME = 'LastName';
    public static final String CONTACT_PHONE = 'Phone';
    public static final String CONTACT_CUSTOMER_ID = 'Mascus_contact_ID__c';
    public static final String CONTACT_ROLE = 'Contact_role__c';
    public static final String CONTACT_STATUS = 'Status__c';
    public static final String CONTACT_MASCUS_CONTACT_NUMBER = 'Mascus_Contact_Number__c';
    public static final String CONTACT_PHONE_PREFIX = 'Phone_Prefix__c';
    public static final String CONTACT_Bill_TO_CONTACT = 'bill to contact, ';
    public static final String CONTACT_SHIP_TO_CONTACT = 'ship to contact, ';
    public static final String CONTACT_SOLD_TO_CONTACT = 'sold to contact, ';
        
    public static final string PRICE_UNIT_OF_MEASURE_ONE_OFF = 'One-off';
    public static final string PRICE_UNIT_OF_MEASURE_MONTHLY = 'Monthly';  

    public static final String CONTACT_ERROR_CODE_100 = '100';
    public static final String CONTACT_ERROR_CODE_101 = '101';
    public static final String CONTACT_ERROR_CODE_102 = '102';
    public static final String CONTACT_ERROR_CODE_103 = '103';
    public static final String CONTACT_ERROR_CODE_104 = '104';
    public static final String CONTACT_ERROR_CODE_105 = '105';
    public static final String CONTACT_ERROR_CODE_106 = '106';
    public static final String CONTACT_ERROR_CODE_107 = '107';
    public static final String CONTACT_ERROR_CODE_108 = '108';
    public static final String CONTACT_ERROR_CODE_109 = '109';
    public static final String CONTACT_ERROR_CODE_110 = '110';
    public static final String CONTACT_ERROR_CODE_111 = '111';
    public static final String CONTACT_ERROR_CODE_112 = '112';
    public static final String CONTACT_ERROR_CODE_113 = '113';
    public static final String CONTACT_ERROR_CODE_114 = '114';
    public static final String CONTACT_ERROR_CODE_115 = '115';
    public static final String CONTACT_ERROR_CODE_116 = '116';
    public static final String CONTACT_ERROR_CODE_117 = '117';
    public static final String CONTACT_ERROR_CODE_118 = '118';
    public static final String CONTACT_ERROR_CODE_119 = '119';
    public static final String CONTACT_ERROR_CODE_120 = '120';
    public static final String CONTACT_ERROR_CODE_121 = '121';
    public static final String CONTACT_ERROR_CODE_122 = '122';
    public static final String CONTACT_ERROR_CODE_123 = '123';
    public static final String CONTACT_ERROR_CODE_124 = '124';
    public static final String CONTACT_ERROR_CODE_125 = '125';
    public static final String CONTACT_ERROR_CODE_126 = '126';
    public static final String CONTACT_ERROR_CODE_127 = '127';
    public static final String CONTACT_ERROR_CODE_128 = '128';
    public static final String CONTACT_ERROR_CODE_129 = '129';
    public static final String CONTACT_ERROR_CODE_130 = '130';
    public static final String CONTACT_ERROR_CODE_131 = '131';
    public static final String CONTACT_ERROR_CODE_132 = '132';
    public static final String CONTACT_ERROR_CODE_133 = '133';
    public static final String CONTACT_ERROR_CODE_134 = '134';
    public static final String CONTACT_ERROR_CODE_135 = '135';
    public static final String CONTACT_VALIDATION_SUCCESS_CODE = '0';
    public static final String CONTACT_DML_SUCCESS_CODE = '200';

    public static final String CONTACT_ERROR_MSG_100 = 'Missing AccountId';
    public static final String CONTACT_ERROR_MSG_101 = 'AccountId field length exceeded';
    public static final String CONTACT_ERROR_MSG_102 = 'Missing OwnerId';
    public static final String CONTACT_ERROR_MSG_103 = 'OwnerId field length exceeded';
    public static final String CONTACT_ERROR_MSG_104 = 'Missing Email';
    public static final String CONTACT_ERROR_MSG_105 = 'Email field length exceeded';
    public static final String CONTACT_ERROR_MSG_106 = 'Invalid email value';
    public static final String CONTACT_ERROR_MSG_107 = 'Missing MailingStreet';
    public static final String CONTACT_ERROR_MSG_108 = 'MailingStreet field length exceeded';
    public static final String CONTACT_ERROR_MSG_109 = 'Missing MailingCity';
    public static final String CONTACT_ERROR_MSG_110 = 'MailingCity field length exceeded';
    public static final String CONTACT_ERROR_MSG_111 = 'Missing MailingState';
    public static final String CONTACT_ERROR_MSG_112 = 'MailingState field length exceeded';
    public static final String CONTACT_ERROR_MSG_113 = 'Missing MailingPostalCode';
    public static final String CONTACT_ERROR_MSG_114 = 'MailingPostalCode field length exceeded';
    public static final String CONTACT_ERROR_MSG_115 = 'Missing mailing country code';
    public static final String CONTACT_ERROR_MSG_116 = 'Mailing country code field length exceeded';
    public static final String CONTACT_ERROR_MSG_117 = 'Missing FirstName';
    public static final String CONTACT_ERROR_MSG_118 = 'FirstName field length exceeded';
    public static final String CONTACT_ERROR_MSG_119 = 'Missing LastName';
    public static final String CONTACT_ERROR_MSG_120 = 'LastName field length exceeded';
    public static final String CONTACT_ERROR_MSG_121 = 'Missing Phone';
    public static final String CONTACT_ERROR_MSG_122 = 'Phone field length exceeded';
    public static final String CONTACT_ERROR_MSG_123 = 'Missing MascusCustomerId';
    public static final String CONTACT_ERROR_MSG_124 = 'MascusCustomerId field length exceeded';
    public static final String CONTACT_ERROR_MSG_125 = 'Upsert operation failed.';
    public static final String CONTACT_ERROR_MSG_126 = 'Missing ContactRole';
    public static final String CONTACT_ERROR_MSG_127 = 'ContactRole field length exceeded';
    public static final String CONTACT_ERROR_MSG_128 = 'Invalid ContactRole';
    public static final String CONTACT_ERROR_MSG_129 = 'Can not find related account';
    public static final String CONTACT_ERROR_MSG_130 = 'Contact country code can not be found';
    public static final String CONTACT_ERROR_MSG_131 = 'Contact status invalid';
    public static final String CONTACT_ERROR_MSG_132 = 'Mascus contact number field length exceeded';
    public static final String CONTACT_ERROR_MSG_133 = 'Phone prefix field length exceeded';
    public static final String CONTACT_ERROR_MSG_134 = 'Missing Phone prefix';
    public static final String CONTACT_ERROR_MSG_135 = 'DUPLICATES_DETECTED, You are creating a duplicate record. We recommend you use an existing record instead';
    public static final String CONTACT_DML_SUCCESS_MSG = 'RECORD SAVED SUCCESSFULLY';
    public static final String CONTACT_VALIDATION_SUCCESS_MSG = 'VALIDATION SUCCESS';
    public static final String CONTACT_ERROR_MSG_135_p1 = 'Please enter a correct address for the chosen ';
    public static final String CONTACT_ERROR_MSG_135_p2 = 'before the order gets activated';
    public static final String CONTACT_Dummy_Street = 'Dummystreet 1';
    public static final String CONTACT_Dummy_City = 'Dummycity';
    

    //Contact fields for outbound service call
    public static final String CONTACT_XML_FIELD_CONTACTS = 'contacts';
    public static final String CONTACT_XML_FIELD_CONTACT = 'contact';
    public static final String CONTACT_XML_CONTACT_MASCUSID = 'contact_mascusid';
    public static final String CONTACT_XML_CONTACT_SF_ID = 'contact_sfid';
    public static final String CONTACT_XML_CONTACT_PARENT_ACCOUNT_ID = 'parentaccount_mascusid';
    public static final String CONTACT_XML_CONTACT_FIRST_NAME = 'firstname';
    public static final String CONTACT_XML_CONTACT_LAST_NAME = 'lastname';
    public static final String CONTACT_XML_CONTACT_ACTION = 'action';
    public static final String CONTACT_XML_CONTACT_COUNTRY = 'country';
    public static final String CONTACT_XML_CONTACT_VISITING_ADDRESS = 'visitingaddress';
    public static final String CONTACT_XML_CONTACT_POSTAL_CODE = 'postalcode';
    public static final String CONTACT_XML_CONTACT_CITY = 'city';
    public static final String CONTACT_XML_CONTACT_PHONE = 'phone_number';
    public static final String CONTACT_XML_CONTACT_PHONE_PREFIX = 'phone_prefix';
    public static final String CONTACT_XML_CONTACT_EMAIL = 'email';
    public static final String CONTACT_XML_CONTACT_MODIFIER_SF_ID = 'modifier_sfid';
    public static final String CONTACT_XML_FIELD_UPDATE = 'update';

    //Account field Names, Error codes & Error messages
    public static final String ACCOUNT_NAME = 'Name';
    public static final String ACCOUNT_OWNER_ID = 'OwnerId';
    public static final String ACCOUNT_SOURCE = 'AccountSource';
    public static final String ACCOUNT_INDUSTRY = 'Industry';
    public static final String ACCOUNT_BILLING_STREET = 'BillingStreet';
    public static final String ACCOUNT_BILLING_CITY = 'BillingCity';
    public static final String ACCOUNT_EMAIL_FOR_INVOICING = 'Email_for_invoicing__c';
    public static final String ACCOUNT_BILLING_STATE = 'BillingState';
    public static final String ACCOUNT_BILLING_POSTAL_CODE = 'BillingPostalCode';
    public static final String ACCOUNT_BILLING_COUNTRY = 'BillingCountryCode';
    public static final String ACCOUNT_PHONE = 'Phone';
    public static final String ACCOUNT_COUNTRY_CODE = 'BillingCountryCode';
    public static final String ACCOUNT_MASCUS_CUSTOMER_ID = 'Mascus_customer_ID__c';
    public static final String ACCOUNT_VAT_NUMBER = 'VAT_Number__c';
    public static final String ACCOUNT_PRIVATE_TAX_NUMBER = 'Private_Tax_Number__c';
    public static final String ACCOUNT_CLASIFICATION = 'Classification__c';
    public static final String ACCOUNT_STATUS = 'Status__c';
    public static final String ACCOUNT_PHONE_PREFIX = 'Phone_Prefix__c';
    public static final String ACCOUNT_SHIPPING_STREET = 'ShippingStreet';
    public static final String ACCOUNT_SHIPPING_CITY = 'ShippingCity';
    public static final String ACCOUNT_SHIPPING_STATE = 'ShippingState';
    public static final String ACCOUNT_SHIPPING_POSTAL_CODE = 'ShippingPostalCode';
    public static final String ACCOUNT_PARENT_ID = 'ParentId';
    public static final String ACCOUNT_SHIPPING_COUNTRY = 'ShippingCountry';
    public static final String ACCOUNT_MASCUS_CUSTOMER_NUMBER = 'Mascus_Customer_Number__c';

    public static final String ACCOUNT_ACCOUNT_TYPE_LEGAL_ENTITY = 'AccountTypeLegalEntity';
    public static final String ACCOUNT_ACCOUNT_TYPE_LICENSEE = 'Licensee';
    public static final String ACCOUNT_ACCOUNT_TAX_TYPE_VAT = 'TaxTypeVat';
    public static final String ACCOUNT_ACCOUNT_TEST_MODE = 'IsTestMode';
    public static final String ACCOUNT_ACCOUNT_RECORD_TYPE = 'Mascus Legal Entity';
    
    public static final String ACCOUNT_ERROR_CODE_101 = '101';
    public static final String ACCOUNT_ERROR_CODE_102 = '102';
    public static final String ACCOUNT_ERROR_CODE_103 = '103';
    public static final String ACCOUNT_ERROR_CODE_104 = '104';
    public static final String ACCOUNT_ERROR_CODE_105 = '105';
    public static final String ACCOUNT_ERROR_CODE_106 = '106';
    public static final String ACCOUNT_ERROR_CODE_107 = '107';
    public static final String ACCOUNT_ERROR_CODE_108 = '108';
    public static final String ACCOUNT_ERROR_CODE_109 = '109';
    public static final String ACCOUNT_ERROR_CODE_110 = '110';
    public static final String ACCOUNT_ERROR_CODE_111 = '111';
    public static final String ACCOUNT_ERROR_CODE_112 = '112';
    public static final String ACCOUNT_ERROR_CODE_113 = '113';
    public static final String ACCOUNT_ERROR_CODE_114 = '114';
    public static final String ACCOUNT_ERROR_CODE_115 = '115';
    public static final String ACCOUNT_ERROR_CODE_116 = '116';
    public static final String ACCOUNT_ERROR_CODE_117 = '117';
    public static final String ACCOUNT_ERROR_CODE_118 = '118';
    public static final String ACCOUNT_ERROR_CODE_119 = '119';
    public static final String ACCOUNT_ERROR_CODE_120 = '120';
    public static final String ACCOUNT_ERROR_CODE_121 = '121';
    public static final String ACCOUNT_ERROR_CODE_122 = '122';
    public static final String ACCOUNT_ERROR_CODE_123 = '123';
    public static final String ACCOUNT_ERROR_CODE_124 = '124';
    public static final String ACCOUNT_ERROR_CODE_125 = '125';
    public static final String ACCOUNT_ERROR_CODE_126 = '126';
    public static final String ACCOUNT_ERROR_CODE_127 = '127';
    public static final String ACCOUNT_ERROR_CODE_128 = '128';
    public static final String ACCOUNT_ERROR_CODE_129 = '129';
    public static final String ACCOUNT_ERROR_CODE_130 = '130';
    public static final String ACCOUNT_ERROR_CODE_131 = '131';
    public static final String ACCOUNT_ERROR_CODE_132 = '132';
    public static final String ACCOUNT_ERROR_CODE_133 = '133';
    public static final String ACCOUNT_ERROR_CODE_134 = '134';
    public static final String ACCOUNT_ERROR_CODE_135 = '135';
    public static final String ACCOUNT_ERROR_CODE_136 = '136';
    public static final String ACCOUNT_ERROR_CODE_137 = '137';
    public static final String ACCOUNT_ERROR_CODE_138 = '138';
    public static final String ACCOUNT_ERROR_CODE_139 = '138';
    public static final String ACCOUNT_ERROR_CODE_140 = '140';
    public static final String ACCOUNT_ERROR_CODE_141 = '141';
    public static final String ACCOUNT_ERROR_CODE_142 = '142';
    public static final String ACCOUNT_ERROR_CODE_143 = '143';
    public static final String ACCOUNT_VALIDATION_SUCCESS_CODE = '0';
    public static final String ACCOUNT_DML_SUCCESS_CODE = '200';

    public static final String ACCOUNT_ERROR_MSG_101 = 'Account name cannot be null';
    public static final String ACCOUNT_ERROR_MSG_102 = 'Account name max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_103 = 'Account owner cannot be null';
    public static final String ACCOUNT_ERROR_MSG_104 = 'Account source cannot be null';
    public static final String ACCOUNT_ERROR_MSG_105 = 'Account industry max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_106 = 'Account billing street cannot be null';
    public static final String ACCOUNT_ERROR_MSG_107 = 'Account billing street max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_108 = 'Account billing city cannot be null';
    public static final String ACCOUNT_ERROR_MSG_109 = 'Account billing city max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_110 = 'Account billing State max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_111 = 'Account billing postal code cannot be null';
    public static final String ACCOUNT_ERROR_MSG_112 = 'Account billing postal code max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_113 = 'Account billing country code cannot be null';
    public static final String ACCOUNT_ERROR_MSG_114 = 'Account billing country code max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_115 = 'Account phone cannot be null';
    public static final String ACCOUNT_ERROR_MSG_116 = 'Account phone max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_117 = 'Account classification cannot be null';
    public static final String ACCOUNT_ERROR_MSG_118 = 'Account billing country code cannot be found';
    public static final String ACCOUNT_ERROR_MSG_119 = 'Account billing country code length exceeded';
    public static final String ACCOUNT_ERROR_MSG_120 = 'Account mascus customer id cannot be null';
    public static final String ACCOUNT_ERROR_MSG_121 = 'Account mascus customer id code length exceeded';
    public static final String ACCOUNT_ERROR_MSG_122 = 'Account VAT number max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_123 = 'Private Tax number max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_124 = 'Upsert operation failed';
    public static final String ACCOUNT_ERROR_MSG_125 = 'Invalid clasification value';
    public static final String ACCOUNT_ERROR_MSG_126 = 'Account email for invoicing cannot be null';
    public static final String ACCOUNT_ERROR_MSG_127 = 'Account email for invoicing max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_128 = 'Account email for invoicing - invalid email format';
    public static final String ACCOUNT_ERROR_MSG_129 = 'Account owner max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_130 = 'Account source max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_131 = 'Account status invalid';
    public static final String ACCOUNT_ERROR_MSG_132 = 'Account phone prefix cannot be null';
    public static final String ACCOUNT_ERROR_MSG_133 = 'Account phone prefix max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_134 = 'Account shipping street max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_135 = 'Account shipping city max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_136 = 'Account shipping state max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_137 = 'Account shipping postal code max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_138 = 'Account shipping country max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_139 = 'Account mascus customer number max length exceeded';
    public static final String ACCOUNT_ERROR_MSG_140 = 'Account shipping country code can not be found';
    public static final String ACCOUNT_ERROR_MSG_141 = 'Account shipping country code cannot be null';
    public static final String ACCOUNT_ERROR_MSG_142 = 'Account parent id cannot be null';
    public static final String ACCOUNT_ERROR_MSG_143 = 'Parent account can not be found';

    public static final String ACCOUNT_VALIDATION_SUCCESS_MSG = 'VALIDATION SUCCESS';
    public static final String ACCOUNT_DML_SUCCESS_MSG = 'RECORD SAVED SUCCESSFULLY';

    //Account fields for outbound service call
    public static final String ACCOUNT_XML_FIELD_ACCOUNTS = 'accounts';
    public static final String ACCOUNT_XML_FIELD_ACCOUNT = 'account';
    public static final String ACCOUNT_XML_FIELD_MASCUS_ID = 'account_mascusid';
    public static final String ACCOUNT_XML_FIELD_SFDC_ID = 'account_sfid';
    public static final String ACCOUNT_XML_FIELD_PARENT_MASCUS_ID = 'parentaccount_mascusid';
    public static final String ACCOUNT_XML_FIELD_NAME = 'name';
    public static final String ACCOUNT_XML_FIELD_ACTION = 'action';
    public static final String ACCOUNT_XML_FIELD_COUNTRY = 'billing_country';
    public static final String ACCOUNT_XML_FIELD_SHIPPING_COUNTRY = 'shipping_country ';
    public static final String ACCOUNT_XML_FIELD_VATNUMBER = 'vatnumber';
    public static final String ACCOUNT_XML_FIELD_VISITING_ADDRESS = 'billing_street';
    public static final String ACCOUNT_XML_FIELD_POSTAL_CODE = 'billing_postalcode';
    public static final String ACCOUNT_XML_FIELD_CITY = 'billing_city';
    public static final String ACCOUNT_XML_FIELD_STATE = 'billing_region ';
    public static final String ACCOUNT_XML_FIELD_SHIPPING_ADDRESS = 'shipping_street';
    public static final String ACCOUNT_XML_FIELD_SHIPPING_POSTAL_CODE = 'shipping_postalcode';
    public static final String ACCOUNT_XML_FIELD_SHIPPING_CITY = 'shipping_city';
    public static final String ACCOUNT_XML_FIELD_SHIPPING_STATE = 'shipping_region';
    public static final String ACCOUNT_XML_FIELD_MASCUSCONTACT_MASCUS_ID = 'mascuscontact_mascusid';
    public static final String ACCOUNT_XML_FIELD_MAINCONTACT_SFID = 'maincontact_sfid';
    public static final String ACCOUNT_XML_FIELD_PHONE_PREFIX = 'phone_prefix';
    public static final String ACCOUNT_XML_FIELD_PHONE = 'phone_number';
    public static final String ACCOUNT_XML_FIELD_EMAIL = 'email';
    public static final String ACCOUNT_XML_FIELD_WEBSITE = 'website';
    public static final String ACCOUNT_XML_FIELD_INSERT = 'insert';
    public static final String ACCOUNT_XML_FIELD_UPDATE = 'update';
    public static final String ACCOUNT_XML_FIELD_DELETE = 'delete';
    public static final String ACCOUNT_XML_FIELD_ACCOUNT_CLASSIFICATION = 'account_classification';
    public static final String ACCOUNT_XML_FIELD_MODIFIER_SFID = 'modifier_sfid';

    //Orders field names, error codes and error messages
    public static final String ORDER_MASCUS_GUID = 'Mascus_order_ID__c';
    public static final String ORDER_MASCUS_NUMBER = 'Mascus_Order_Number__c';
    public static final String ORDER_BILLTO_ACCOUNT = 'AccountId';//'Mascus_Customer_Number__c';
    public static final String ORDER_BILLTO_CONTACT = 'BillToContactId';//'Mascus_Contact_Number__c';
    public static final String ORDER_NAME = 'Name';
    public static final String ORDER_AUTHIRIZED_PAYMENT = 'Authorized_payment__c';
    public static final String ORDER_START_DATE = 'EffectiveDate';
    public static final String ORDER_BILLING_START_DATE = 'Billing_start_date__c';
    public static final String ORDER_BILL_FROM_LEGAL_ENTITY = 'Bill_from_legal_entity__c';
    public static final String ORDER_SOLD_TO_ACCOUNT = 'Sold_to_Account__c';
    public static final String ORDER_SOLD_TO_CONTACT = 'Sold_to_contact__c';
    public static final String ORDER_BILLING_CYCLE_PREFERENCE = 'Billing_Cycle_preference__c';
    public static final String ORDER_INVOICE_PREFERENCE = 'Invoicing_preference__c';
    public static final String ORDER_INVOICE_RULE = 'Invoicing_rule__c';
    public static final String ORDER_PAYMENT_METHOD = 'Payment_method__c';
    public static final String ORDER_PAYMENT_TERM = 'Payment_term__c';
    public static final String ORDER_NAME_CREATE = 'MascusWeb-';
    public static final String ORDER_PAYMENT_METHOD_ONLINE = 'Online Payment Provider';

    // Private AD
    public static final String PRIVATE_AD = 'Private_ad';
    public static final String PAYMENT_METHOD = 'Online payment provider';
    public static final String PAYMENT_TERM ='Immediately';
    public static final String BILLING_CYCLE_PREFERENCE = 'Once off';
    public static final String INVOICING_PREFERENCE = 'E-mail';
    public static final String INVOICING_RULE = 'In advance';
    
    public static final String ORDER_TO_EMAIL_ADDRESSES = 'OrderEmailToAddresses';

    public static final String ORDER_ERROR_CODE_100 = '100';
    public static final String ORDER_ERROR_CODE_101 = '101';
    public static final String ORDER_ERROR_CODE_102 = '102';
    public static final String ORDER_ERROR_CODE_103 = '103';
    public static final String ORDER_ERROR_CODE_104 = '104';
    public static final String ORDER_ERROR_CODE_105 = '105';
    public static final String ORDER_ERROR_CODE_106 = '106';
    public static final String ORDER_ERROR_CODE_107 = '107';
    public static final String ORDER_ERROR_CODE_108 = '108';
    public static final String ORDER_ERROR_CODE_109 = '109';
    public static final String ORDER_ERROR_CODE_110 = '110';
    public static final String ORDER_ERROR_CODE_111 = '111';
    public static final String ORDER_ERROR_CODE_112 = '112';
    public static final String ORDER_ERROR_CODE_113 = '113';
    public static final String ORDER_ERROR_CODE_114 = '114';
    public static final String ORDER_ERROR_CODE_115 = '115';
    public static final String ORDER_ERROR_CODE_116 = '116';
    public static final String ORDER_ERROR_CODE_117 = '117';
    public static final String ORDER_ERROR_CODE_118 = '118';
    public static final String ORDER_ERROR_CODE_119 = '119';
    public static final String ORDER_ERROR_CODE_120 = '120';
    public static final String ORDER_ERROR_CODE_121 = '121';
    public static final String ORDER_ERROR_CODE_122 = '122';
    public static final String ORDER_ERROR_CODE_123 = '123';
    public static final String ORDER_ERROR_CODE_124 = '124';
    public static final String ORDER_ERROR_CODE_125 = '125';
    public static final String ORDER_ERROR_CODE_126 = '126';
    public static final String ORDER_ERROR_CODE_127 = '127';
    public static final String ORDER_ERROR_CODE_128 = '128';
    public static final String ORDER_ERROR_CODE_129 = '129';
    public static final String ORDER_ERROR_CODE_130 = '130';

    public static final String ORDER_DML_SUCCESS_CODE = '200';
    public static final String ORDER_VALIDATION_SUCCESS_CODE = '0';

    public static final String ORDER_ERROR_MSG_100 = 'MascusGUID length exceeded';
    public static final String ORDER_ERROR_MSG_101 = 'MascusGUID cannot be null';
    public static final String ORDER_ERROR_MSG_102 = 'MascusOrderNumber max length exceeded';
    public static final String ORDER_ERROR_MSG_103 = 'MascusOrderNumber cannot be null';
    public static final String ORDER_ERROR_MSG_104 = 'BillToAccount max length exceeded';
    public static final String ORDER_ERROR_MSG_105 = 'BillToAccount cannot be null';
    public static final String ORDER_ERROR_MSG_106 = 'BillToContact max length exceeded';
    public static final String ORDER_ERROR_MSG_107 = 'BillToContact cannot be null';
    public static final String ORDER_ERROR_MSG_108 = 'AuthorizedPayment max length exceeded';
    public static final String ORDER_ERROR_MSG_109 = 'AuthorizedPayment cannot be null';
    public static final String ORDER_ERROR_MSG_110 = 'BillFromLegalEntity max length exceeded';
    public static final String ORDER_ERROR_MSG_111 = 'BillFromLegalEntity cannot be null';
    public static final String ORDER_ERROR_MSG_112 = 'SoldToAccount max length exceeded';
    public static final String ORDER_ERROR_MSG_113 = 'SoldToAccount cannot be null';
    public static final String ORDER_ERROR_MSG_114 = 'MascusOrderNumbeForPayment max length exceeded';
    public static final String ORDER_ERROR_MSG_115 = 'AutoActivate cannot be null';
    public static final String ORDER_ERROR_MSG_116 = 'StartDate cannot be null';
    public static final String ORDER_ERROR_MSG_117 = 'BillingStartDate cannot be null';
    public static final String ORDER_ERROR_MSG_118 = 'Upsert operation failed';
    public static final String ORDER_ERROR_MSG_119 = 'SoldToContact max length exceeded';
    public static final String ORDER_ERROR_MSG_120 = 'SoldToContact cannot be null';
    public static final String ORDER_ERROR_MSG_121 = 'BillingCyclePreference max length exceeded';
    public static final String ORDER_ERROR_MSG_122 = 'BillingCyclePreference cannot be null';
    public static final String ORDER_ERROR_MSG_123 = 'InvoicePreference max length exceeded';
    public static final String ORDER_ERROR_MSG_124 = 'InvoicePreference cannot be null';
    public static final String ORDER_ERROR_MSG_125 = 'InvoiceRule max length exceeded';
    public static final String ORDER_ERROR_MSG_126 = 'InvoiceRule cannot be null';
    public static final String ORDER_ERROR_MSG_127 = 'PaymentMethod max length exceeded';
    public static final String ORDER_ERROR_MSG_128 = 'PaymentMethod cannot be null';
    public static final String ORDER_ERROR_MSG_129 = 'PaymentTerm max length exceeded';
    public static final String ORDER_ERROR_MSG_130 = 'PaymentTerm cannot be null';
    public static final String ORDER_ERROR_MSG_131 = 'Billing start date should be greater than or equal to the minimum of the Order Product start dates';
    public static final String ORDER_ERROR_MSG_132 = 'Before you can activate an order, the commission split must be created';

    public static final String ORDER_VALIDATION_SUCCESS_MSG = 'VALIDATION SUCCESS';
    public static final String ORDER_DML_SUCCESS_MSG = 'RECORD SAVED SUCCESSFULLY';

    //Order fields for outbound service call
    public static final String ORDER_XML_AD_FIELD_ACTION = 'action';
    public static final String ORDER_XML_AD_FIELD_ACTION_TYPE = 'action_type';
    public static final String ORDER_XML_AD_FIELD_MASCUS_ORDER_ID = 'mascus_order_id';
    public static final String ORDER_XML_AD_FIELD_MODIFIER_ID = 'modifier_sfid';
    public static final String ORDER_XML_AD_STATUS_APPROVE = 'approve';
    public static final String ORDER_XML_AD_STATUS_REJECT = 'reject';

    public static final String ORDER_XML_FIELD_ORDERS = 'orders';
    public static final String ORDER_XML_FIELD_ORDER = 'order';
    public static final String ORDER_XML_FIELD_MASCUS_ORG_ID = 'mascus_org_id';
    public static final String ORDER_XML_FIELD_ACCOUNT_SF_ID = 'account_sfid';
    public static final String ORDER_XML_FIELD_ORDER_SF_ID = 'order_sfid';
    public static final String ORDER_XML_FIELD_MODIFIER_SF_ID = 'modifier_sfid';
    public static final String ORDER_XML_FIELD_ACTION = 'action';
    public static final String ORDER_XML_FIELD_ADD_TO_SUB_COMPANIES = 'add_to_sub_companies';
    public static final String ORDER_XML_FIELD_PRODUCTS = 'products';
    public static final String ORDER_XML_FIELD_PRODUCT = 'product';
    public static final String ORDER_XML_FIELD_PRODUCTS_PRODUCT_CODE = 'product_code';
    public static final String ORDER_XML_FIELD_PRODUCTS_PRODUCT_START_DATE = 'startdate';
    public static final String ORDER_XML_FIELD_PRODUCTS_PRODUCT_END_DATE = 'enddate';
    public static final String ORDER_XML_FIELD_PRODUCTS_PRODUCT_QUANTITY = 'quantity';
    public static final String ORDER_XML_FIELD_PRODUCTS_PRODUCT_UNIT_OF_MESURE = 'unit_of_measure';
    public static final String ORDER_XML_FIELD_UPDATE = 'update';

    //product 2
    public static final String ORDER_ITEM_PRODUCT_CODE = 'ProductCode';
    public static final String ORDER_ITEM_QUANTITY= 'Price_unit_of_measure__c';//'QuantityUnitOfMeasure';
    public static final String ORDER_ITEM_CURRENCY = 'CurrencyIsoCode';

    public static final String ORDER_ITEM_ERROR_CODE_100 = '100';
    public static final String ORDER_ITEM_ERROR_CODE_101 = '101';
    public static final String ORDER_ITEM_ERROR_CODE_102 = '102';
    public static final String ORDER_ITEM_ERROR_CODE_103 = '103';
    public static final String ORDER_ITEM_ERROR_CODE_104 = '104';
    public static final String ORDER_ITEM_ERROR_CODE_105 = '105';
    public static final String ORDER_ITEM_ERROR_CODE_106 = '106';
    public static final String ORDER_ITEM_ERROR_CODE_107 = '107';
    public static final String ORDER_ITEM_ERROR_CODE_108 = '108';
    public static final String ORDER_ITEM_ERROR_CODE_109 = '109';

    public static final String ORDER_ITEM_ERROR_MSG_100 = 'Order Item ProductCode length exceeded';
    public static final String ORDER_ITEM_ERROR_MSG_101 = 'Order Item ProductCode cannot be null';
    public static final String ORDER_ITEM_ERROR_MSG_102 = 'Order Item Quantity cannot be null';
    public static final String ORDER_ITEM_ERROR_MSG_103 = 'Order Item Currency length exceeded';
    public static final String ORDER_ITEM_ERROR_MSG_104 = 'Order Item Currency cannot be null';
    public static final String ORDER_ITEM_ERROR_MSG_105 = 'Order Item StartDate cannot be null';
    public static final String ORDER_ITEM_ERROR_MSG_106 = 'Order Item EndDate cannot be null';
    public static final String ORDER_ITEM_ERROR_MSG_107 = 'Order Item PriceUnitofMesaure cannot be null';
    public static final String ORDER_ITEM_ERROR_MSG_108 = 'Order Item unitPrice cannot be null';
    public static final String ORDER_ITEM_ERROR_MSG_109 = 'Order Items cannot be null';
    
    //order items
    public static final String ORDER_ITEM_START_DATE = 'ServiceDate';
    public static final String ORDER_ITEM_END_DATE = 'EndDate';

    //Lead field names, Error codes & Error messages
    public static final String LEAD_STATUS = 'Status';
    public static final String LEAD_COMPANY = 'Company';
    public static final String LEAD_CLASSIFICATION = 'Classification__c';
    public static final String LEAD_LASTNAME = 'LastName';
    public static final String LEAD_MOBILE_PREFIX = 'Mobile_Prefix__c';
    public static final String LEAD_MOBILE = 'MobilePhone';
    public static final String LEAD_SOURCE = 'LeadSource';
    public static final String LEAD_STREET = 'Street';
    public static final String LEAD_SATE = 'State';
    public static final String LEAD_POSTAL_CODE = 'PostalCode';
    public static final String LEAD_COUNTRY = 'Country';
    public static final String LEAD_MASCUS_ACCOUNT_GUID = 'Mascus_Account_ID__c';
    public static final String LEAD_MASCUS_LEAD_NUMBER = 'Mascus_Lead_Number__c'; //auto
    public static final String LEAD_MASCUS_CONTACT_GUID = 'Mascus_contact_ID__c';
    //Added by Amarendra on 12/14/2017 as part of bug#C248-39 
    public static final String Lead_City  = 'city';
    public static final String Lead_Email = 'Email';

    public static final String LEAD_STATUS_OPEN = 'LeadStatusOpen';
    public static final String LEAD_STATUS_Omitted = 'LeadStatusOmitted';

    public static final String LEAD_ERROR_CODE_100 = '100';
    public static final String LEAD_ERROR_CODE_101 = '101';
    public static final String LEAD_ERROR_CODE_102 = '102';
    public static final String LEAD_ERROR_CODE_103 = '103';
    public static final String LEAD_ERROR_CODE_104 = '104';
    public static final String LEAD_ERROR_CODE_105 = '105';
    public static final String LEAD_ERROR_CODE_106 = '106';
    public static final String LEAD_ERROR_CODE_107 = '107';
    public static final String LEAD_ERROR_CODE_108 = '108';
    public static final String LEAD_ERROR_CODE_109 = '109';
    public static final String LEAD_ERROR_CODE_110 = '110';
    public static final String LEAD_ERROR_CODE_111 = '111';
    public static final String LEAD_ERROR_CODE_112 = '112';
    public static final String LEAD_ERROR_CODE_113 = '113';
    public static final String LEAD_ERROR_CODE_114 = '114';
    public static final String LEAD_ERROR_CODE_115 = '115';
    public static final String LEAD_ERROR_CODE_116 = '116';
    public static final String LEAD_ERROR_CODE_117 = '117';
    public static final String LEAD_ERROR_CODE_118 = '118';
    public static final String LEAD_ERROR_CODE_119 = '119';
    public static final String LEAD_ERROR_CODE_120 = '120';
    public static final String LEAD_ERROR_CODE_121 = '121';
    public static final String LEAD_ERROR_CODE_122 = '122';
    public static final String LEAD_ERROR_CODE_123 = '123';
    public static final String LEAD_ERROR_CODE_124 = '124';
    public static final String LEAD_ERROR_CODE_125 = '125';
    public static final String LEAD_ERROR_CODE_126 = '126';
    public static final String LEAD_ERROR_CODE_127 = '127';
    public static final String LEAD_ERROR_CODE_128 = '128';

    public static final String LEAD_VALIDATION_SUCCESS_CODE = '0';
    public static final String LEAD_DML_SUCCESS_CODE = '200';

    public static final String LEAD_ERROR_MSG_100 = 'Invalid Lead Status';
    public static final String LEAD_ERROR_MSG_101 = 'CompanyName cannot be null';
    public static final String LEAD_ERROR_MSG_102 = 'CompanyName max length exceeded';
    public static final String LEAD_ERROR_MSG_103 = 'Invalid Classification Value';
    public static final String LEAD_ERROR_MSG_104 = 'LastName cannot be null';
    public static final String LEAD_ERROR_MSG_105 = 'LastName max length exceeded';
    public static final String LEAD_ERROR_MSG_106 = 'MobilePrefix cannot be null';
    public static final String LEAD_ERROR_MSG_107 = 'MobilePrefix max length exceeded';
    public static final String LEAD_ERROR_MSG_108 = 'MobileNumber cannot be null';
    public static final String LEAD_ERROR_MSG_109 = 'MobileNumber max length exceeded';
    public static final String LEAD_ERROR_MSG_110 = 'Invalid Lead Source';
    public static final String LEAD_ERROR_MSG_111 = 'Street cannot be null';
    public static final String LEAD_ERROR_MSG_112 = 'Street max length exceeded';
    public static final String LEAD_ERROR_MSG_113 = 'State max length exceeded';
    public static final String LEAD_ERROR_MSG_114 = 'PostalCode cannot be null';
    public static final String LEAD_ERROR_MSG_115 = 'PostalCode max length exceeded';
    public static final String LEAD_ERROR_MSG_116 = 'Country cannot be null';
    public static final String LEAD_ERROR_MSG_117 = 'Country max length exceeded';
    public static final String LEAD_ERROR_MSG_118 = 'MascusAccountGUID cannot be null';
    public static final String LEAD_ERROR_MSG_119 = 'MascusAccountGUID max length exceeded';
    public static final String LEAD_ERROR_MSG_120 = 'MascusLeadNumber max length exceeded';
    public static final String LEAD_ERROR_MSG_121 = 'Lead_MascusContactGUID cannot be null';
    public static final String LEAD_ERROR_MSG_122 = 'Lead_MascusContactGUID max length exceeded';
    public static final String LEAD_ERROR_MSG_123 = 'Upsert operation failed';
    public static final String LEAD_ERROR_MSG_124 = 'Lead country code cannot be found';
    public static final String LEAD_ERROR_MSG_125 = 'Lead city cannot be null';
    public static final String LEAD_ERROR_MSG_126 = 'city max length exceeded';
    public static final String LEAD_ERROR_MSG_127 = 'Email cannot be null';
    public static final String LEAD_ERROR_MSG_128 = 'DUPLICATES_DETECTED, You are creating a duplicate record. We recommend you use an existing record instead';

    public static final String LEAD_VALIDATION_SUCCESS_MSG = 'VALIDATION SUCCESS';
    public static final String LEAD_DML_SUCCESS_MSG = 'RECORD SAVED SUCCESSFULLY';
    public static final String LEAD_OUTBOUND_OBJECT_TYPE_ACCOUNT = 'Account';
    public static final String LEAD_OUTBOUND_OBJECT_TYPE_CONTACT = 'Contact';
    public static final String STATE_FIRSTNAME = 'FIRST';
    public static final String STATE_LASTNAME = 'LAST';

    //Action log request types
    public static final String ACTION_LOG_TYPE_REQUEST = 'Request';
    public static final String ACTION_LOG_TYPE_RESPONSE = 'Response';
    public static final String STATUS_SYNCED = 'Synced';
    public static final String STATUS_NEED_TO_BE_SYNCED = 'Need to be synced';

    public static final String ACTION_LOG_TYPE_INSERT = 'INSERT';
    public static final String ACTION_LOG_TYPE_UPDATE = 'UPDATE';
    public static final String ACTION_LOG_TYPE_TRANSLATE = 'TRANSLATE';
    public static final String ACTION_LOG_TYPE_VATCHECK = 'VATCHECK';
    public static final String ACTION_LOG_TYPE_DELETE= 'DELETE';

    public static final String ACTION_LOG_SOURCE_SF = 'Salesforce';
    public static final String ACTION_LOG_SOURCE_MASCUS = 'Mascus';
    public static final String ACTION_LOG_SOURCE_ORACLE = 'Oracle';
    public static final String ACTION_LOG_SOURCE_GOOGLE = 'Google';

    public static final String ACTION_LOG_TRAGET_SF = 'Salesforce';
    public static final String ACTION_LOG_TRAGET_MASCUS = 'Mascus';
    public static final String ACTION_LOG_TRAGET_ORACLE = 'Oracle';
    public static final String ACTION_LOG_TRAGET_GOOGLE = 'Google';
    public static final String ACTION_LOG_TRAGET_BOOMI = 'Boomi';

    public static final String ACTION_LOG_STATUS_SUCCESS = 'Success';
    public static final String ACTION_LOG_STATUS_FAILED = 'Failed';
    public static final String ACTION_LOG_STATUS_EVENT_FIRED = 'Event Fired';

    public static final String ORDER_PRODUCT_NAME_CB = 'Conversion Balance';
    public static final String ORDER_PRODUCT_CODE_CB = 'Conversion_Balance';
    
    public static final String ORDER_PRODUCT_NAME_MASCUS_CREDITS = 'Mascus Credits';

     public static final String ACTION_LOG_STACK_TRACE_REVENUE_TO_BUDGET_p1 = 'Hi there,'+ '\n'+
        'There\'s been a fixable issue on Salesforce. You are recommended to pass this email on'+'\n'+
        'to your Salesforce Administrator/Support Team (if that is not yourself!).'+ '\n'+
        'Here\'s the match that was searched for, but not found:';
    public static final String ACTION_LOG_STACK_TRACE_REVENUE_TO_BUDGET_p2 = '\n'+ '\n'+'Notes:'+'\n'+
        '1, The usual issue is that the Revenue record hasn\'t managed to find an appropriate'+
        'match on the Budget object. The unique reference is made up from LegalEntity-'+
        'Product_Family-Year_of_Revenue- Month_of_Revenue and is listed in the “Requested Date” field.'+'\n'+
        '2, This process runs daily and only lists the first error for any given missing Budget (even'+
        'if there are many revenue records missing this Budget).'+'\n'+
        '3, When the Budget record is created, the associated Revenue records will be updated overnight.'+'\n'+
        '4, A new error will be generated each night if the appropriate Budget record is still missing.'+'\n'+
        '5, If you\'re wondering why there aren’t more alerts, ActionLogs are only created for the'+
        'current year budget-wise. Missing budgets for future years aren\'t logged.'+'\n'+
        'Best regards, Your Friendly Salesforce Bot';
    
    //Added by Kavinda Inusha on 30/01/2018
    //ActionLog field names / Custom settings to address field names
    public static final String ACTION_LOG_FIELD_STATUS = 'Status__c';
    public static final String ACTION_LOG_FIELD_STATUS_FAILED = 'Failed';
    public static final String ACTIONLOG_TO_EMAIL_ADDRESSES = 'ActionLogToEmails';
    public static final String ACTION_LOG_EMAIL_TEMPLATE_EN = 'ActionLogFailure_EN';
    public static final String ACTION_LOG_EMAIL_TEMPLATE_SENDER_NAME = 'Mascus Admin';
    public static final String ACTION_LOG_EMAIL_TEMPLATE_RECIPIENT_NAME = 'User';

}