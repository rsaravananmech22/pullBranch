/**************************************************************************
 * Description  : Apex queue classs for contact sync with mascus
 * Copyright ABSI. All rights reserved. 
 * ========================================================================
 * History                                                            
 * ------------------------------------------------------------------------                                                            
 * VERSION     AUTHOR              DATE            DETAIL                                      
      1.0      Samith Perera       09/10/2017      Initial implementation
 **************************************************************************/
public class MAS_ContactConsumeMasAdminQueue implements Queueable, Database.AllowsCallouts {
	private list<contact> conList;
    private List<Queueable> queables;
    
    public MAS_ContactConsumeMasAdminQueue(list<contact> cList, list<Queueable> qList) {
        this.conList = cList;
        this.queables = qList;
    }
    
    public void execute(QueueableContext context) {
        
        list<contact> toUpdateList = new list<contact>();
        for(contact con : conList){
            // Consume webservice from mascus 
        	toUpdateList.add(con);
        }
         
        MAS_UtilityHelper.isContactTriggerRepeat = true;
        database.update (toUpdateList,false);
        
        if (queables.size() == 0) {
			return;
        }else{
        	queables.remove(0);
        }
        
        system.debug('---queables1:' + queables[0]);
		if(queables.size() != 0)
        	System.enqueueJob(queables[0]);
    }
}