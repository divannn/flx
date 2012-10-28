package autoComplete {

	import flash.events.Event;

	public class AutoCompleteEvent extends Event {

		public var data:Object;
		public static const SELECT:String = "select";

		public function AutoCompleteEvent(type:String, mydata:Object,
				bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			data = mydata;
		}

		override public function clone():Event {
			return new AutoCompleteEvent(type, data);
		}
	}
}