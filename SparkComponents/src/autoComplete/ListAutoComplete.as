package autoComplete {
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import mx.core.ScrollPolicy;
	import mx.utils.OnDemandEventDispatcher;

	import spark.components.List;
	import spark.components.Scroller;

	/**
	 * This list is used in AutoCompleteSkin.
	 * keyDownHandler is overridden so that the list can handle keyboard events for navigation.
	 */
	public class ListAutoComplete extends List {

		override protected function keyDownHandler(event:KeyboardEvent):void {
			super.keyDownHandler(event);
			if (!dataProvider || !layout || event.isDefaultPrevented()) {
				return;
			}
			adjustSelectionAndCaretUponNavigation(event);
		}

		override protected function partAdded(partName:String,
				instance:Object):void {
			super.partAdded(partName, instance);
			if (instance is Scroller) {
				//do not show horizontal scroll bar.
				scroller.setStyle('horizontalScrollPolicy', ScrollPolicy.OFF);
			}
		}
	}
}