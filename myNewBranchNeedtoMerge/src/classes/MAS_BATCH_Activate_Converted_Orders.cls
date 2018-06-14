/******************************************************
 * Description      : APEX Batch class used to Activate Converted Orders (coming from Boomi)
 * @author          : MATTHIAS STROOBANTS
 * @since           : 2018-01-26
 * Copyright 2018 ABSI. All rights reserved.
 ******************************************************/
global class MAS_BATCH_Activate_Converted_Orders implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    global Set<Id> accountIds;
    global Boolean activateOnlyOutstandingInvoiceConversions;
    global Integer maxOrdersToBeUpdated;


    global MAS_BATCH_Activate_Converted_Orders(Boolean activateOnlyOutstandingInvoiceConversions, Integer maxOrdersToBeUpdated){
        this.activateOnlyOutstandingInvoiceConversions = activateOnlyOutstandingInvoiceConversions;
		this.maxOrdersToBeUpdated = maxOrdersToBeUpdated;
        
        if(!activateOnlyOutstandingInvoiceConversions){
            this.accountIds = new Set<Id>();
            List<AggregateResult> aggResults = [SELECT Sold_to_Account__c accId, COUNT(Id) numOrders
            FROM Order
            WHERE Mascus_Sale_legacy_ID__c != null AND Name != 'Outstanding Invoice Conversion'
            GROUP BY Sold_to_Account__c
            HAVING COUNT(Id) = 1
            ];
            for(AggregateResult aggResult : aggResults){
                Id accountId = (Id) aggResult.get('accId');
                if(!this.accountIds.contains(accountId)) this.accountIds.add(accountId);
            }
        }

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Database.QueryLocator locator;

        if(!this.activateOnlyOutstandingInvoiceConversions){

            locator = Database.getQueryLocator(
            [SELECT Id, Status, Bill_from_legal_entity__r.VAT_validation__c, Sold_to_Account__r.Classification__c
            FROM Order
            WHERE AccountId IN :this.accountIds AND Status = 'Draft' AND Mascus_Sale_legacy_ID__c != null LIMIT :this.maxOrdersToBeUpdated]
            );
        }
        else{
            locator = Database.getQueryLocator(
            [SELECT Id, Status, Bill_from_legal_entity__r.VAT_validation__c, Sold_to_Account__r.Classification__c
            FROM Order
            WHERE Name = 'Outstanding Invoice Conversion' AND Status = 'Draft' AND Mascus_Sale_legacy_ID__c != null LIMIT :this.maxOrdersToBeUpdated]
            );
    
        }
        return locator;

    }

    global void execute(Database.BatchableContext BC, List<Sobject> scopeObjects) { // sObject is Order here
        for(Sobject scopeObject : scopeObjects){
            Order o = ((Order)scopeObject);
            if(!Test.isRunningTest()){
                List<String> data = MAS_OrderActivateAuraController.orderValidation(o.Id, false, o.Sold_to_Account__r.Classification__c);
                System.debug('Validation for order :'+ o + ' has result: ' + data);
                if(data[0]=='success'){
                    o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
                    o.Activated__c = true;
                }
            }
            else{
                o.Status = MAS_Constant.ORDER_STATUS_ACTIVE;
                o.Activated__c = true;
            }

        }

        update scopeObjects;
    }


    global void finish(Database.BatchableContext BC) {
        System.debug('Batch: MAS_BATCH_Activate_Converted_Orders finished');
    }
}