package progressOnComponent.events
{
	import flash.events.Event;

	public class ShowProgressEvent extends Event
	{
		public static const SHOW_PROGRESS_EVENT:String = "showProgress";

		public var uniqueName:String;

		public function ShowProgressEvent(uniqueName:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.uniqueName = uniqueName;
			super(SHOW_PROGRESS_EVENT, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new ShowProgressEvent(uniqueName, bubbles, cancelable);
		}
	}
}
