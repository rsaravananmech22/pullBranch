/**************************************************************************
 * Description  : Aura controller for the vat check
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       31/10/2019      Initial implementation
 **************************************************************************/
public class MAS_VatCheckAuraController {
    
    @AuraEnabled
    public static list<string> vatCheckWithVies(Id AccountId){
        
        list<string> status = new list<string>();
        MAS_ResponseDTO res= MAS_AccountService.vatcheckforAccount(AccountId, null);
          
        if(res.responseType == MAS_Constant.RESPONSE_TYPE_SUCCESS){
            status.add(MAS_Constant.RESPONSE_TYPE_SUCCESS);
        }else if(res.responseType == MAS_Constant.RESPONSE_TYPE_WARNING){
            status.add(MAS_Constant.RESPONSE_TYPE_WARNING);
        }else{
            status.add(MAS_Constant.RESPONSE_TYPE_ERROR);
        }
                
        status.add(res.responseMessage);
        system.debug('#####status'+ status);
        return status;
    }
}