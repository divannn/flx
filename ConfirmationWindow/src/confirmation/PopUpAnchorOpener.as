package confirmation {
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.core.UIComponent;

	import spark.components.PopUpAnchor;

	/**
	 * Open PopUpAnchor by trigger event. Default trigger event is MouseEvent.CLICK.
	 */
	public class PopUpAnchorOpener {

		private var _anchor:PopUpAnchor;

		public function set anchor(value:PopUpAnchor):void {
			_anchor = value;
		}

		private var _trigger:UIComponent;

		public function set trigger(value:UIComponent):void {
			removeTriggersListeners();
			_trigger = value;
			addTriggersListeners();
		}

		private var triggerEvent:String = MouseEvent.CLICK;

		private function removeTriggersListeners():void {
			if (_trigger) {
				_trigger.removeEventListener(triggerEvent, triggerEventHandler);
			}
		}

		private function addTriggersListeners():void {
			if (_trigger) {
				_trigger.addEventListener(triggerEvent, triggerEventHandler);
			}
		}

		private function triggerEventHandler(event:Event):void {
			_anchor.displayPopUp = true;
		}
	}
}
