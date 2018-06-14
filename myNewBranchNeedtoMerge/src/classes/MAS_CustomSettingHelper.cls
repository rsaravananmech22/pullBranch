/**************************************************************************
 * Description  : Apex Class for get custom settings by name
 * ========================================================================
 * History
 * ------------------------------------------------------------------------
 * VERSION     AUTHOR              DATE            DETAIL
      1.0      Samith Perera       22/09/2019      Initial implementation
 **************************************************************************/
public class MAS_CustomSettingHelper {

    /**
     * @Description This method read the custom setting from given name and return the value
     * @author Samith Perera
     * @params name : custom setting name
     * @return string value
     */
    public static string getConfigSettingValueByName(string name) {

        Configuration__c cs = Configuration__c.getInstance(name);
        return cs.Value__c;
    }


    /**
     * @Description This method read the custom setting (Fields_to_Sync_with_Mascus__c) to get field details for service calls
     * @author Dinesh W
     * @params name : Custom setting object filed name
     * @return list of settings values
     */
    public static List<String> getFieldstoSyncwithMascusSettingByObjectName(string objectToRead) {

        List<String> lstConfigValues = new List<String>();
        
        for (Fields_to_Sync_with_Mascus__c config : Fields_to_Sync_with_Mascus__c.getall().values()) {
            
            if(config.Object__c == objectToRead){
                lstConfigValues.Add(config.Name);
            }
        }

        return lstConfigValues;
    }

    /**
     * @Description This method read the custom setting (LeadFieldsToSync__c) to get field details for service calls
     * @author Malinda
     * @params name : Custom setting object filed name
     * @return list of settings values
     */
    public static  List<LeadFieldsToSync__c> getLeadFiledsToSync() {
        return LeadFieldsToSync__c.getall().values();
    }

}