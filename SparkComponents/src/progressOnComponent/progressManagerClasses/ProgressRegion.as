package progressOnComponent.progressManagerClasses {
	import mx.core.Container;
	import mx.core.UIComponent;

	public class ProgressRegion {
		public var uniqueName:String;
		public var targetRegion:Container;

		public var progressSpinner:ProgressSpinner;
		public var modal:UIComponent;

		public var isVisible:Boolean;

		public var triggerCount:int = 0;

		public function ProgressRegion(uniqueName:String,
				targetRegion:Container) {
			this.uniqueName = uniqueName;
			this.targetRegion = targetRegion;
		}
	}
}
