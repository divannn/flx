package {
	import flash.display.Graphics;
	import flash.display.Sprite;

	import mx.core.UIComponent;

	public class Custom1 extends UIComponent {
		private static const DEFAULT_HEIGHT:Number = 200;
		private static const DEFAULT_WIDTH:Number = 200;

		private var _backgroundColor:uint = 0xff0000;

		private var _ellipse:Sprite;

		public function set backgroundColor(value:uint):void {
			if (_backgroundColor != value) {
				_backgroundColor = value;
				invalidateProperties();
			}
		}

		public function get backgroundColor():uint {
			return _backgroundColor;
		}

		override protected function createChildren():void {
			super.createChildren();
			_ellipse = new Sprite();
			addChild(_ellipse);
		}

		override protected function commitProperties():void {
			super.commitProperties();
			invalidateDisplayList();
		}

		override protected function measure():void {
			super.measure();
			measuredMinHeight = measuredHeight = DEFAULT_HEIGHT;
			measuredMinWidth = measuredWidth = DEFAULT_WIDTH;
		}

		override protected function updateDisplayList(unscaledWidth:Number,
				unscaledHeight:Number):void {
			trace("UDL " + unscaledWidth);
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			height = unscaledHeight;
			width = unscaledWidth;

			var g:Graphics = this.graphics;
			g.clear();
			g.lineStyle(1, 0x000000);
			g.beginFill(_backgroundColor, 1);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();

			drawChildren(unscaledWidth, unscaledHeight);
		}

		private function drawChildren(unscaledWidth:Number,
				unscaledHeight:Number):void {
			var eg:Graphics = _ellipse.graphics;
			eg.clear();
			eg.beginFill(0x0000ff, 1);
			eg.drawEllipse(0, 0, unscaledWidth, unscaledHeight);
			eg.endFill();
		}
	}
}