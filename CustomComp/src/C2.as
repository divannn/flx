package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	import mx.core.UIComponent;

	public class C2 extends UIComponent {

		private var square:Sprite = new Sprite();

		public function C2() {
			square.addEventListener(MouseEvent.CLICK, widen);
			square.graphics.beginFill(0xFF0000);
			square.graphics.drawRect(0, 0, 100, 100);
			addChild(square);
		}

		private function widen(event:MouseEvent):void {
			trace(square.scaleX);
			square.width += 10;
		}
	}
}