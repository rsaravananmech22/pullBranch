@isTest
public class MAS_TestDataFactory {

    public static SObject createSObject(SObject sObj) {
        // Check what type of object we are creating and add any defaults that are needed.
        String objectName = String.valueOf(sObj.getSObjectType());
        // Construct the default values class. Salesforce doesn't allow '__' in class names
        String defaultClassName = 'MAS_TestDataFactory.' + objectName.replaceAll('__(c|C)$|__', '') + 'Defaults';
        // If there is a class that exists for the default values, then use them
        if (Type.forName(defaultClassName) != null) {
            sObj = createSObject(sObj, defaultClassName);
        }
        return sObj;
    }

    public static SObject createSObject(SObject sObj, Boolean doInsert) {
        SObject retObject = createSObject(sObj);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }

    public static SObject createSObject(SObject sObj, String defaultClassName) {
        // Create an instance of the defaults class so we can get the Map of field defaults
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            Throw new TestFactoryException('Invalid defaults class.');
        }
        FieldDefaults defaults = (FieldDefaults)t.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }

    public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
        SObject retObject = createSObject(sObj, defaultClassName);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
        return createSObjectList(sObj, numberOfObjects, (String)null);
    }

    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, (String)null);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }

    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, defaultClassName);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
        SObject[] sObjs = new SObject[] {};
        SObject newObj;

        // Get one copy of the object
        if (defaultClassName == null) {
            newObj = createSObject(sObj);
        } else {
            newObj = createSObject(sObj, defaultClassName);
        }

        // Get the name field for the object
        String nameField = nameFieldMap.get(String.valueOf(sObj.getSObjectType()));
        if (nameField == null) {
            nameField = 'Name';
        }

        // Clone the object the number of times requested. Increment the name field so each record is unique
        for (Integer i = 0; i < numberOfObjects; i++) {
            SObject clonedSObj = newObj.clone(false, true);
            clonedSObj.put(nameField, (String)clonedSObj.get(nameField) + ' ' + i);
            sObjs.add(clonedSObj);
        }
        return sObjs;
    }

    private static void addFieldDefaults(SObject sObj, Map<Schema.SObjectField, Object> defaults) {
        // Loop through the map of fields and if they are null on the object, fill them.
        for (Schema.SObjectField field : defaults.keySet()) {
            if (sObj.get(field) == null) {
                sObj.put(field, defaults.get(field));
            }
        }
    }

    // When we create a list of SObjects, we need to
    private static Map<String, String> nameFieldMap = new Map<String, String> {
        'Contact' => 'LastName',
        'Case' => 'Subject'
    };

    public class TestFactoryException extends Exception {}

    // Use the FieldDefaults interface to set up values you want to default in for all objects.
    public interface FieldDefaults {
        Map<Schema.SObjectField, Object> getFieldDefaults();
    }

    // To specify defaults for objects, use the naming convention [ObjectName]Defaults.
    // For custom objects, omit the __c from the Object Name

    public class AccountDefaults implements FieldDefaults {

        public Map<Schema.SObjectField, Object> getFieldDefaults() {

            return new Map<Schema.SObjectField, Object> {
                Account.Name => 'Test Account',
                Account.Classification__c => 'Business account',
                Account.BillingStreet => 'Meir 1',
                Account.BillingPostalCode => '2000',
                Account.BillingCity => 'Antwerp',
                Account.BillingCountry => 'India',
                Account.BillingState => 'Delhi',
                Account.ShippingStreet => 'Meir 1',
                Account.ShippingPostalCode => '2000',
                Account.ShippingCity => 'Antwerp',
                Account.ShippingCountry => 'Belgium',
                Account.Phonetic_Account_Name__c => Label.MAS_MSG_Phonetic_Name_Update,
                Account.RecordTypeId => Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId()
            };
        }
    }

    public class ContactDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Contact.FirstName => 'First',
                Contact.LastName => 'Last',
                Contact.Contact_role__c => 'Invoicing contact',
                Contact.MailingStreet => 'Meir 1',
                Contact.MailingPostalCode => '2000',
                Contact.MailingCity => 'Antwerp',
                Contact.MailingCountry => 'Belgium'
            };
        }
    }

    public class OpportunityDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Opportunity.Name => 'Test Opportunity',
                Opportunity.StageName => 'Closed Won',
                Opportunity.CloseDate => System.today()
            };
        }
    }

    public class CaseDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Case.Subject => 'Test Case'
            };
        }
    }

    public class OrderDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            // Id legalEntityAccId  = createLegalEntityAccount();
            // Id accountId = createAccount();

            return new Map<Schema.SObjectField, Object> {
                Order.EffectiveDate => Date.today().addyears(-2).adddays(-1),
                Order.Billing_start_date__c => Date.today(),
                Order.Billing_Cycle_preference__c => 'Monthly',
                Order.Invoicing_preference__c => 'E-mail',
                Order.Invoicing_rule__c => 'In arrears',
                Order.Payment_method__c => 'By invoice',
                Order.Payment_term__c => '30 days net',
                Order.Status => MAS_Constant.ORDER_STATUS_DRAFT,
                Order.Pricebook2Id => Test.getStandardPricebookId()//,
                // Order.AccountId => accountId,
                // Order.Bill_from_legal_entity__c =>  legalEntityAccId,
                // Order.Sold_to_Account__c => accountId
            };
        }

        private Id createLegalEntityAccount() {
            Account legalEntity = (Account)MAS_TestDataFactory.createSObject(new Account(Name = 'Legal Entity', Type = 'Internal legal entity' , VAT_Number__c = 'VAT-000001', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Mascus legal entity').getRecordTypeId()), true);
            return legalEntity.Id;
        }

        private Id createAccount() {
            Account acc = (Account)MAS_TestDataFactory.createSObject(new Account(), true);
            return acc.Id;
        }
    }

    public class OrderItemDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                OrderItem.Quantity => 1,
                OrderItem.Price_unit_of_measure__c => 'Monthly',
                OrderItem.UnitPrice => 10,
                OrderItem.EndDate => Date.today() + 30,
                OrderItem.Next_billing_date__c => Date.today() + 10
            };
        }
    }

    public class Product2Defaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Product2.Name => 'Test Product'
            };
        }
    }

    public class PricebookEntryDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                PricebookEntry.IsActive => true,
                PricebookEntry.Pricebook2Id => Test.getStandardPricebookId(),
                PricebookEntry.UnitPrice => 10
            };
        }
    }

    public class LeadDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Lead.FirstName => 'First',
                Lead.LastName => 'Last',
                Lead.Status => 'In Progress',
                Lead.Mobile_Prefix__c => '7',
                Lead.MobilePhone => '00012355666',
                Lead.Classification__c => 'Business account',
                Lead.Company => 'Test Company'
            };
        }
    }

    public class Pricebook2Defaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Pricebook2.IsActive => true,
                Pricebook2.Name => 'Mascus WEB EUR'
            };
        }
    }

    public class UserDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                User.FirstName => 'Test',
                User.LastName => 'User',
                User.Email => 'test@cloudtest.rbaenv.com',
                User.Username => 'Test@cloudtest.rbaenv.com',
                User.Alias => 'testcom',
                User.EmailEncodingKey => 'UTF-8',
                User.LocaleSidKey => 'en_US',
                User.LanguageLocaleKey => 'en_US',
                User.TimeZoneSidKey => 'America/Los_Angeles'
            };
        }
    }

    public class ProfileDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            Profile prof = [Select Id from Profile where Name = 'Standard User' limit 1];
            return new Map<Schema.SObjectField, Object> {
                Profile.Id => prof.Id
            };
        }
    }

}