/**************************************************************************
 * Description  : Apex queue classs for contact name translations
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       09/10/2017      Initial implementation
 **************************************************************************/
public class MAS_ContactGoogleTranslateQueue implements Queueable, Database.AllowsCallouts {
    private list<contact> conList;
    private List<Queueable> queables;
    
    public MAS_ContactGoogleTranslateQueue(list<contact> cList, list<Queueable> qList) {
        this.conList = cList;
        this.queables = qList;
    }
    
     /**
     * @Description: In the execute method it is still need to check which name has to be translated (First name/last name)
     * @author: Samith Perera
     * @params: context : QueueableContext
     * @return: void
     */
    public void execute(QueueableContext context) {
        list<contact> toUpdateList = new list<contact>();
        string translatedText;

        for(contact con :conList){
            contact toUpdateCon = new contact (Id = con.Id);
            
            if(con.Phonetic_Contact_First_Name__c == null || con.Phonetic_Contact_First_Name__c.equals(Label.MAS_MSG_Phonetic_Name_Update)){                
                //Call translate google API
                translatedText =  MAS_ContactService.translateNonAscii(con.Id, con.FirstName);
                if(translatedText != null)
            		    toUpdateCon.Phonetic_Contact_First_Name__c = translatedText;
            }
            
            if(con.Phonetic_Contact_Last_Name__c == null || con.Phonetic_Contact_Last_Name__c.equals(Label.MAS_MSG_Phonetic_Name_Update)){
                //Call translate google API
               	translatedText =  MAS_ContactService.translateNonAscii(con.Id, con.LastName);
                if(translatedText != null)
            		    toUpdateCon.Phonetic_Contact_Last_Name__c = translatedText;
            }
            
         	  toUpdateList.add(toUpdateCon);
        }
        
        //Make trigger excecution stop
        MAS_UtilityHelper.isContactTriggerRepeat = true;
        database.update (toUpdateList,false);

        if (queables.size() == 0)
			   return;
		    else
        	queables.remove(0);
        
        // excute the next job in the chain
    		if(queables != null && queables.size() != 0)
            	System.enqueueJob(queables[0]);
    
    }
}