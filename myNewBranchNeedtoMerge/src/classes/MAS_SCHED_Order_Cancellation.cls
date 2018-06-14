public class MAS_SCHED_Order_Cancellation implements Schedulable {
	public void execute(SchedulableContext sc) {
		MAS_BATCH_Order_Cancellation b = new MAS_BATCH_Order_Cancellation();
		Database.executebatch(b);
	}
}