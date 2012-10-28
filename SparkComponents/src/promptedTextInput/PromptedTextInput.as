package promptedTextInput {

	import flash.events.FocusEvent;

	import spark.components.Label;
	import spark.components.TextInput;

	public class PromptedTextInput extends TextInput {

		public function PromptedTextInput() {
			super();
		}

		[SkinPart(required="true")]
		public var promptView:Label;

		private var _prompt:String;
		private var promptChanged:Boolean;

		[Bindable]
		public function get prompt():String {
			return _prompt;
		}

		public function set prompt(v:String):void {
			if (_prompt !== v) {
				_prompt = v;
				promptChanged = true;
				invalidateProperties();
			}
		}

		override public function set text(val:String):void {
			super.text = val;
			if (promptView && text == "") {
				promptView.visible = true;
			}
		}

		override protected function commitProperties():void {
			super.commitProperties();
			if (promptChanged) {
				if (promptView) {
					promptView.text = prompt;
				}
				promptChanged = false;
			}
		}

		override protected function partAdded(partName:String,
				instance:Object):void {
			super.partAdded(partName, instance);
			if (instance == textDisplay) {
				textDisplay.addEventListener(FocusEvent.FOCUS_IN,
						onFocusInHandler);
				textDisplay.addEventListener(FocusEvent.FOCUS_OUT,
						onFocusOutHandler);
			}
			if (instance == promptView) {
				promptView.text = prompt;
			}
		}

		override protected function partRemoved(partName:String,
				instance:Object):void {
			super.partRemoved(partName, instance);
			if (instance == textDisplay) {
				this.textDisplay.removeEventListener(FocusEvent.FOCUS_IN,
						onFocusInHandler);
				this.textDisplay.removeEventListener(FocusEvent.FOCUS_OUT,
						onFocusOutHandler);
			}
		}

		private function onFocusInHandler(event:FocusEvent):void {
			if (promptView) {
				promptView.visible = false;
			}
		}

		private function onFocusOutHandler(event:FocusEvent):void {
			if (promptView) {
				promptView.visible = (text == "");
			}
		}

	}
}