public class NewOrder{

    public string accId {get;set;}
    public NewOrder(ApexPages.StandardController controller){
        Account accCon = (Account)controller.getrecord();
        accId = accCon.Id;
    }
}