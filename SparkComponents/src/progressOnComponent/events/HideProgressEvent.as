package progressOnComponent.events
{
	import flash.events.Event;

	public class HideProgressEvent extends Event
	{
		public static const HIDE_PROGRESS_EVENT:String = "hideProgress";
		
		public var uniqueName:String;

		public function HideProgressEvent(uniqueName:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.uniqueName = uniqueName;
			super(HIDE_PROGRESS_EVENT, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new HideProgressEvent(uniqueName, bubbles, cancelable);
		}
	}
}
