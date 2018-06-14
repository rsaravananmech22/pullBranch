/**************************************************************************
 * Description  : Apex Class for Vat service requesst
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       23/09/2019      Initial implementation
 **************************************************************************/
public class MAS_VATRequestDTO {
	public string tax_type {get; set;}
    public string tax_number {get; set;}
    public string country_code {get; set;}
    public boolean test_mode {get; set;}
    public string requester_country_code {get; set;}
    public string requester_tax_number {get; set;}
}