@isTest
public class TestUtility {
    
    public static Account newAccount(String name) {
        return new Account(
            Name = name
            , Phone_Prefix__c = '1',
             phone='1919191919',
            Industry='Other',
            Classification__c='Person account',
            Customer_priority__c='Low'
            
        );
    }
    public static Product2 newProduct(String name){
        return new Product2(
            Name = name
            , IsActive = true
        );
    }
    public static Pricebook2 newPricebook(String name){
        return new Pricebook2(
            Name = name
            , IsActive = true
        );
    }
    public static PricebookEntry newPricebookEntry(Id pricebookId, Id productId, Double unitPrice){
        return new PricebookEntry(
            Pricebook2Id = pricebookId
            , Product2Id = productId
            , UnitPrice = unitPrice 
            , IsActive = true
        );
    }
}