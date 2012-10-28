package confirmation {
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;

	import spark.components.PopUpAnchor;

	import window.Window;

	public class WindowPopUpAnchor extends PopUpAnchor {
		override public function set popUp(value:IFlexDisplayObject):void {
			if (!(value is Window)) {
				throw new Error("popUp must be Window");
			}
			removePopUpListeners();
			super.popUp = value;
			addPopUpListeners();
		}

		private function get popUpWindow():Window {
			return Window(popUp);
		}

		private function addPopUpListeners():void {
			popUpWindow.addEventListener(CloseEvent.CLOSE, closeHandler);
		}

		private function removePopUpListeners():void {
			if (popUpWindow) {
				popUpWindow.removeEventListener(CloseEvent.CLOSE, closeHandler);
			}
		}

		private function closeHandler(event:CloseEvent):void {
			displayPopUp = false;
		}

	}
}
