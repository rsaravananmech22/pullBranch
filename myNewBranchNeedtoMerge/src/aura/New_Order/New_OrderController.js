({
    createAccount: function (component) {
        var parentUrl = location.href;
        var createRecordEvent = $A.get('e.force:createRecord');
        var decodedUrl = decodeURIComponent(document.URL);
        var windowHash = window.location.href;
        var url = new URL(decodedUrl);
        var accId = url.searchParams.get($A.get("$Label.c.AccId"));
        var relVar = 'related';
        var todayDate = new Date();
        if (createRecordEvent) {
            createRecordEvent.setParams({
                'entityApiName': 'Order',
                'defaultFieldValues': {
                    'AccountId' : accId,
                    'Sold_to_Account__c': accId,
                    'EffectiveDate' : todayDate,
                    'Billing_start_date__c' : todayDate
                },
                'panelOnDestroyCallback': function(event) { 
                    if(!$A.util.isEmpty(accId)){
                        var urlEvent = $A.get("e.force:navigateToSObject");
                        urlEvent.setParams({
                            'recordId': accId,
                            'slideDevName': relVar
                        });
                        urlEvent.fire();
                    }
                    else{
                        var actionUrl = location.href;
                        if(parentUrl === actionUrl){
                            var navEvent = $A.get("e.force:navigateToList");
                            navEvent.setParams({
                                "listViewId": null,
                                "listViewName": 'Recent',
                                "scope": "Order"
                            });
                            navEvent.fire();
                        }
                        
                    } 
                    
                }
            });
            createRecordEvent.fire();
        } else {}
        
    }
})