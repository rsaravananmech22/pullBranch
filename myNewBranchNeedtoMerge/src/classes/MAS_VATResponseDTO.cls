/**************************************************************************
 * Description  : Apex Class for Vat service response
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       23/09/2019      Initial implementation
 **************************************************************************/
public class MAS_VATResponseDTO {
	 public string valid {get; set;}
     public string request_date {get; set;}
     public string tax_number {get; set;}
     public string country_code {get; set;}
     public string request_id {get; set;}
     public string request_status {get; set;}
     public string trader_address  {get; set;}
     public string trader_company_type {get; set;}
     public string trader_name {get; set;}
}