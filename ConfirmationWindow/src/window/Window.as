package window {
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;

	import spark.components.TitleWindow;

	public class Window extends TitleWindow {

		private var _clickOutsideAutoClose:Boolean = true;

		public function get clickOutsideAutoClose():Boolean {
			return _clickOutsideAutoClose;
		}

		public function set clickOutsideAutoClose(value:Boolean):void {
			_clickOutsideAutoClose = value;
		}

		public function Window() {
			addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,
					mouseDownOutsideHandler);
			addEventListener(CloseEvent.CLOSE, closeHandler);
			//			addEventListener(DialogEvent.OK, okClickedHandler);
			//			addEventListener(DialogEvent.CANCEL, cancelClickedHandler);
		}

		private function mouseDownOutsideHandler(event:FlexMouseEvent):void {
			if (clickOutsideAutoClose) {
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}
		}

		//		private function okClickedHandler(event:DialogEvent):void {
		//			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		//		}
		//
		//		private function cancelClickedHandler(event:DialogEvent):void {
		//			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		//		}

		public function open(modal:Boolean = false):void {
			PopUpManager.addPopUp(this,
					UIComponent(FlexGlobals.topLevelApplication), modal);
			PopUpManager.centerPopUp(this);
			setFocus();
		}

		protected function close():void {
			PopUpManager.removePopUp(this);
		}

		private function closeHandler(event:CloseEvent):void {
			close();
		}
	}
}
