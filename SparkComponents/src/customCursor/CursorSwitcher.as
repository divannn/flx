package customCursor {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	public class CursorSwitcher {
		private var uiComp:UIComponent;

		private var cursorImage:Class;
		private var cursorId:int = CursorManager.NO_CURSOR;

		public function CursorSwitcher(uiComp:UIComponent, cursorImage:Class) {
			this.uiComp = uiComp;
			this.cursorImage = cursorImage;
		}

		public function install():void {
			uninstall();
			uiComp.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			uiComp.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
		}

		public function uninstall():void {
			removeCursor();
			uiComp.removeEventListener(MouseEvent.ROLL_OVER, mouseOver);
			uiComp.removeEventListener(MouseEvent.ROLL_OUT, mouseOut);
		}

		private function mouseOver(e:MouseEvent):void {
			trace("=over");
			setCursor();
		}

		private function mouseOut(e:MouseEvent):void {
			trace("=out");
			removeCursor();
		}

		private function setCursor():void {
			if (cursorId != CursorManager.NO_CURSOR &&
					cursorId == CursorManager.getInstance().currentCursorID) {
				return;
			}
			if (cursorImage) {
				cursorId = CursorManager.getInstance().setCursor(cursorImage,
						CursorManagerPriority.MEDIUM, -10, -10);
			} else {
				removeCursor();
			}
		}

		private function removeCursor():void {
			if (cursorId != CursorManager.NO_CURSOR) {
				CursorManager.getInstance().removeCursor(cursorId);
			}
			cursorId = CursorManager.NO_CURSOR;
		}
	}
}