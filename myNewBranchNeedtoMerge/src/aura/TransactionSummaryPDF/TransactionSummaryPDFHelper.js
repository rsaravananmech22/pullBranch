({
	getPDFAttachment : function(component) {
		
		var action = component.get("c.pdfAttachment");
		var id = component.get("v.recordId");
		action.setParams({
            "recordId": id
        });
		
		action.setCallback(this, function(response) {

			var state = response.getState();
			var attachmentContent = response.getReturnValue();

			if (attachmentContent != null && attachmentContent != ''){
				
				var hiddenElement = document.createElement('a');
				hiddenElement.href = 'data:application/octet-stream;base64,' + encodeURI(response.getReturnValue());
				hiddenElement.target = '_self';
				hiddenElement.download = 'TransactionSummary.pdf';
				document.body.appendChild(hiddenElement);
				hiddenElement.click();

				component.set("v.title", "SUCCESS!!");
				component.set("v.message", $A.get("$Label.c.LBL_DownloadPDF_Success"));

			} else if (state === 'SUCCESS' && (attachmentContent == undefined || attachmentContent == null || attachmentContent == '')) {
				component.set("v.title", "ERROR!!");
				component.set("v.message", $A.get("$Label.c.LBL_DownloadPDF_NotFound"));
			} else {
				component.set("v.title", "ERROR!!");
				component.set("v.message", $A.get("$Label.c.LBL_ERR_ExternalDataSources"));
			}		
		});
		$A.enqueueAction(action);
	}
})