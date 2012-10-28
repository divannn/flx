package delegateDispatcher {
	import flash.events.Event;

	/**
	 * @author idanilov
	 */
	public class ModelEvent extends Event {
		public static const EVENT_TYPE:String = "sometype";

		public var msg:String;

		public function ModelEvent(msg:String) {
			super(EVENT_TYPE, false, false);
			this.msg = msg;
		}
	}
}