package progressOnComponent.progressManagerClasses {
	import flash.events.EventDispatcher;

	[Style(name="spinnerColor", type="uint", format="Color", inherit="no")]
	[Style(name="spinnerRate", type="Number", inherit="no")]
	[Style(name="spinnerMaxLightnessPercent", type="Number", inherit="no")]
	[Style(name="spinnerMinLightnessPercent", type="Number", inherit="no")]
	[Style(name="spinnerInnerDiameter", type="Number", inherit="no")]
	[Style(name="spinnerSegmentWidth", type="Number", inherit="no")]
	[Style(name="spinnerSegmentCount", type="Number", inherit="no")]

	public class ProgressManager {
		private static var _progressManagerImpl:ProgressManagerImpl = ProgressManagerImpl.getInstance();

		public static function addProgressRegion(progressRegion:ProgressRegion):void {
			_progressManagerImpl.addProgressRegion(progressRegion);
		}

		public static function removeProgressRegion(uniqueName:String):void {
			_progressManagerImpl.removeProgressRegion(uniqueName);
		}

		public static function showModal(uniqueName:String,
				playAnimation:Boolean = true):void {
			_progressManagerImpl.showModal(uniqueName, playAnimation);
		}

		public static function hideModal(uniqueName:String,
				playAnimation:Boolean = true):void {
			_progressManagerImpl.hideModal(uniqueName, playAnimation);
		}

		//		public static function getEventDispatcher():EventDispatcher {
		//			return _progressManagerImpl as EventDispatcher;
		//		}
	}
}
