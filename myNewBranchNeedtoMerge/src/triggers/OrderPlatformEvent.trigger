trigger OrderPlatformEvent on Order_Platform_Event__e (after insert) {
    system.debug('****TRIG_Order_Platform_Event Starts');
    List<ID> OrderIDs=new List<ID>();
    for(Order_Platform_Event__e events : trigger.new)
    {
      OrderIDs.add(events.Order_ID__c);
    }
    system.debug('OrderIDs'+OrderIDs);
    Map<id,Order> OrderMap=new Map<id,Order>();
    
    for(Order O:[select id,Bill_from_legal_entity__r.type from order where id in :OrderIDs])
    { 
      OrderMap.put(O.id,O);
    }
    
    
    for(Order_Platform_Event__e event : trigger.new){
   
       system.debug('create Json generator test class');
        
      if(OrderMap.get(event.Order_ID__c).Bill_from_legal_entity__r.type=='Internal legal entity')
      {
      system.debug('create Json generator');
    JSONGenerator request = JSON.createGenerator(true);
    
    //start request
    request.writeStartObject();
    
    //start data object
    request.writeFieldName('data');
    
    //start completing data object
    request.writeStartObject();
    request.writeStringField('schema','czZ3ptlY20aCjB3TzH8qSg');
        
        
    //start completing payload
    request.writeFieldName('payload');
    request.writeStartObject();
    
    if (event.Order_Owner_FirstName__c != NULL ) request.writeStringField('Order_Owner_FirstName__c', event.Order_Owner_FirstName__c);
if (event.Order_Product_Legal_entity_sales_share__c != NULL ) request.writeStringField('Order_Product_Legal_entity_sales_share__c', event.Order_Product_Legal_entity_sales_share__c);
if (event.Order_Status__c != NULL ) request.writeStringField('Order_Status__c', event.Order_Status__c);
if (event.Order_Product_Discount__c != NULL ) request.writeStringField('Order_Product_Discount__c', event.Order_Product_Discount__c);
if (event.Contact_Phonetic_Last_Name__c != NULL ) request.writeStringField('Contact_Phonetic_Last_Name__c', event.Contact_Phonetic_Last_Name__c);
if (event.Order_Number__c != NULL ) request.writeStringField('Order_Number__c', event.Order_Number__c);
if (event.Account_BillingCity__c != NULL ) request.writeStringField('Account_BillingCity__c', event.Account_BillingCity__c);
if (event.Mailing_Country__c != NULL ) request.writeStringField('Mailing_Country__c', event.Mailing_Country__c);
if (event.Account_Phone_Prefix__c != NULL ) request.writeStringField('Account_Phone_Prefix__c', event.Account_Phone_Prefix__c);
if (event.Order_Product_Start_Date__c != NULL ) request.writeDateField('Order_Product_Start_Date__c', event.Order_Product_Start_Date__c);
if (event.Contact_Mailing_CountryCode__c != NULL ) request.writeStringField('Contact_Mailing_CountryCode__c', event.Contact_Mailing_CountryCode__c);
if (event.CreatedById != NULL ) request.writeStringField('CreatedById', event.CreatedById);
if (event.Order_Bundle_pricing__c != NULL ) request.writeBooleanField('Order_Bundle_pricing__c', event.Order_Bundle_pricing__c);
if (event.Order_Invoicing_rule__c != NULL ) request.writeStringField('Order_Invoicing_rule__c', event.Order_Invoicing_rule__c);
if (event.Order_Mascus_Order_Number__c != NULL ) request.writeStringField('Order_Mascus_Order_Number__c', event.Order_Mascus_Order_Number__c);
if (event.Order_Payment_method_reference__c != NULL ) request.writeStringField('Order_Payment_method_reference__c', event.Order_Payment_method_reference__c);
if (event.Order_ID__c != NULL ) request.writeStringField('Order_ID__c', event.Order_ID__c);
if (event.Account_BillingStreet__c != NULL ) request.writeStringField('Account_BillingStreet__c', event.Account_BillingStreet__c);
if (event.Order_Owner_LastName__c != NULL ) request.writeStringField('Order_Owner_LastName__c', event.Order_Owner_LastName__c);
if (event.Mailing_Postal_Code__c != NULL ) request.writeStringField('Mailing_Postal_Code__c', event.Mailing_Postal_Code__c);
if (event.Order_Product_Line__c != NULL ) request.writeStringField('Order_Product_Line__c', event.Order_Product_Line__c);
if (event.Contact_Phone__c != NULL ) request.writeStringField('Contact_Phone__c', event.Contact_Phone__c);
if (event.Contact_Phonetic_First_Name__c != NULL ) request.writeStringField('Contact_Phonetic_First_Name__c', event.Contact_Phonetic_First_Name__c);
if (event.Order_Product_End_Date__c != NULL ) request.writeDateField('Order_Product_End_Date__c', event.Order_Product_End_Date__c);
if (event.Order_Billing_Cycle_Preference__c != NULL ) request.writeStringField('Order_Billing_Cycle_Preference__c', event.Order_Billing_Cycle_Preference__c);
if (event.Account_Mascus_Customer_Number__c != NULL ) request.writeStringField('Account_Mascus_Customer_Number__c', event.Account_Mascus_Customer_Number__c);
if (event.Account_DUNS_number__c != NULL ) request.writeStringField('Account_DUNS_number__c', event.Account_DUNS_number__c);
if (event.Action__c != NULL ) request.writeStringField('Action__c', event.Action__c);
if (event.Account_Classification__c != NULL ) request.writeStringField('Account_Classification__c', event.Account_Classification__c);
if (event.Mailing_City__c != NULL ) request.writeStringField('Mailing_City__c', event.Mailing_City__c);
if (event.Contact_First_Name__c != NULL ) request.writeStringField('Contact_First_Name__c', event.Contact_First_Name__c);
if (event.Contact_Salutation__c != NULL ) request.writeStringField('Contact_Salutation__c', event.Contact_Salutation__c);
if (event.Order_Product_Unit_Price__c != NULL ) request.writeStringField('Order_Product_Unit_Price__c', event.Order_Product_Unit_Price__c);
if (event.CreatedDate != NULL ) request.writeDateTimeField('CreatedDate', event.CreatedDate);
if (event.Account_Website__c != NULL ) request.writeStringField('Account_Website__c', event.Account_Website__c);
if (event.Order_Invoice_header_information__c != NULL ) request.writeStringField('Order_Invoice_header_information__c', event.Order_Invoice_header_information__c);
if (event.Order_Product_Quantity__c != NULL ) request.writeNumberField('Order_Product_Quantity__c', event.Order_Product_Quantity__c);
if (event.Account_BillingPostalCode__c != NULL ) request.writeStringField('Account_BillingPostalCode__c', event.Account_BillingPostalCode__c);
if (event.Order_Start_Date__c != NULL ) request.writeDateTimeField('Order_Start_Date__c', event.Order_Start_Date__c);
if (event.Order_Product_Price_unit_of_measure__c != NULL ) request.writeStringField('Order_Product_Price_unit_of_measure__c', event.Order_Product_Price_unit_of_measure__c);
if (event.Contact_Last_Name__c != NULL ) request.writeStringField('Contact_Last_Name__c', event.Contact_Last_Name__c);
if (event.Account_Phone__c != NULL ) request.writeStringField('Account_Phone__c', event.Account_Phone__c);
if (event.Order_Sold_to_contact__c != NULL ) request.writeStringField('Order_Sold_to_contact__c', event.Order_Sold_to_contact__c);
if (event.Order_Product_Cancellation_date__c != NULL ) request.writeDateField('Order_Product_Cancellation_date__c', event.Order_Product_Cancellation_date__c);
if (event.Account_Local_TAX_Number__c != NULL ) request.writeStringField('Account_Local_TAX_Number__c', event.Account_Local_TAX_Number__c);
if (event.Account_BillingState__c != NULL ) request.writeStringField('Account_BillingState__c', event.Account_BillingState__c);
if (event.Contact_Email__c != NULL ) request.writeStringField('Contact_Email__c', event.Contact_Email__c);
if (event.Mailing_State__c != NULL ) request.writeStringField('Mailing_State__c', event.Mailing_State__c);
if (event.Account_BillingCountryCode__c != NULL ) request.writeStringField('Account_BillingCountryCode__c', event.Account_BillingCountryCode__c);
if (event.Mailing_Street__c != NULL ) request.writeStringField('Mailing_Street__c', event.Mailing_Street__c);
if (event.Order_Product_cancellation_reason_descri__c != NULL ) request.writeStringField('Order_Product_cancellation_reason_descri__c', event.Order_Product_cancellation_reason_descri__c);
if (event.Order_Product_Cancellation_reason__c != NULL ) request.writeStringField('Order_Product_Cancellation_reason__c', event.Order_Product_Cancellation_reason__c);
if (event.Order_Product_Line_Description__c != NULL ) request.writeStringField('Order_Product_Line_Description__c', event.Order_Product_Line_Description__c);
if (event.Contact_Phone_Prefix__c != NULL ) request.writeStringField('Contact_Phone_Prefix__c', event.Contact_Phone_Prefix__c);
if (event.Account_Type_of_Business__c != NULL ) request.writeStringField('Account_Type_of_Business__c', event.Account_Type_of_Business__c);
if (event.Account_Private_Tax_Number__c != NULL ) request.writeStringField('Account_Private_Tax_Number__c', event.Account_Private_Tax_Number__c);
if (event.Order_Name__c != NULL ) request.writeStringField('Order_Name__c', event.Order_Name__c);
if (event.Account_BillingStateCode__c != NULL ) request.writeStringField('Account_BillingStateCode__c', event.Account_BillingStateCode__c);
if (event.Account_Email_for_invoicing__c != NULL ) request.writeStringField('Account_Email_for_invoicing__c', event.Account_Email_for_invoicing__c);
if (event.Order_Product_Code__c != NULL ) request.writeStringField('Order_Product_Code__c', event.Order_Product_Code__c);
if (event.Order_Invoicing_preference__c != NULL ) request.writeStringField('Order_Invoicing_preference__c', event.Order_Invoicing_preference__c);
if (event.Account_BillingCountry__c != NULL ) request.writeStringField('Account_BillingCountry__c', event.Account_BillingCountry__c);
if (event.Order_Account_Name__c != NULL ) request.writeStringField('Order_Account_Name__c', event.Order_Account_Name__c);
if (event.Order_Sold_to_Account__c != NULL ) request.writeStringField('Order_Sold_to_Account__c', event.Order_Sold_to_Account__c);
if (event.Account_Name__c != NULL ) request.writeStringField('Account_Name__c', event.Account_Name__c);
if (event.Order_Reference_Number__c != NULL ) request.writeStringField('Order_Reference_Number__c', event.Order_Reference_Number__c);
if (event.Order_Bill_To_Contact__c != NULL ) request.writeStringField('Order_Bill_To_Contact__c', event.Order_Bill_To_Contact__c);
if (event.Order_Product_Subscription_term_length__c != NULL ) request.writeStringField('Order_Product_Subscription_term_length__c', event.Order_Product_Subscription_term_length__c);
if (event.Order_Payment_Token__c != NULL ) request.writeStringField('Order_Payment_Token__c', event.Order_Payment_Token__c);
if (event.Contact_Mascus_Contact_Number__c != NULL ) request.writeStringField('Contact_Mascus_Contact_Number__c', event.Contact_Mascus_Contact_Number__c);
if (event.Order_Bill_from_legal_entity__c != NULL ) request.writeStringField('Order_Bill_from_legal_entity__c', event.Order_Bill_from_legal_entity__c);
if (event.Order_Payment_method__c != NULL ) request.writeStringField('Order_Payment_method__c', event.Order_Payment_method__c);
if (event.Order_Payment_term__c != NULL ) request.writeStringField('Order_Payment_term__c', event.Order_Payment_term__c);
if (event.Order_Billing_start_date__c != NULL ) request.writeDateTimeField('Order_Billing_start_date__c', event.Order_Billing_start_date__c);
if (event.Currency_Iso_Code__c != NULL ) request.writeStringField('Currency_Iso_Code__c', event.Currency_Iso_Code__c);
if (event.Account_EU_VAT_Number__c != NULL ) request.writeStringField('Account_EU_VAT_Number__c', event.Account_EU_VAT_Number__c);
if (event.Account_Phonetic_Name__c != NULL ) request.writeStringField('Account_Phonetic_Name__c', event.Account_Phonetic_Name__c);
if (event.Order_Owner__c != NULL ) request.writeStringField('Order_Owner__c', event.Order_Owner__c);
//Added by Amarendra on 12/19/2017
if (event.Order_Authorized_payment__c != NULL ) request.writeStringField('Order_Authorized_payment__c', event.Order_Authorized_payment__c);

    
    request.writeEndObject();
    //end payload
    
    //start completing event
    request.writeFieldName('event');
    request.writeStartObject();
    request.writeStringField('replayId',event.ReplayId);
    request.writeEndObject();
    //end event
    
    request.writeEndObject();
    //end data object
    
    request.writeStringField('channel','/event/Order_Platform_Event__e');
    
    request.writeEndObject();
    //end request
    
    String pretty = request.getAsString();
   
          if(!test.isRunningTest()){
                MAS_OracleOrder_HTTPClient.doHTTPPost(pretty,event.Order_ID__c,event.Currency_Iso_Code__c);  
              }
        
    }
   
  }
        
}