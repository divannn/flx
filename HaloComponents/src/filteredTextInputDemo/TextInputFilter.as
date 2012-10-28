package filteredTextInputDemo {

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;

	import mx.core.ITextInput;

	public class TextInputFilter {
		private static const exeptionChars:Array = ["r", "w", "p"];

		private var correctedTextValue:String = "";
		private var pos:int;
		private var textInput:ITextInput;
		private var shiftKey:Boolean = false;

		public function TextInputFilter(textInput:ITextInput) {
			this.textInput = textInput;
			configureListeners();
		}

		private function configureListeners():void {
			textInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler,
					false, 0, false);
			textInput.addEventListener(TextEvent.TEXT_INPUT, textInputHandler,
					false, 0, false);
			textInput.addEventListener(Event.CHANGE, changeHandler, false, 0,
					false);
		}

		private function keyDownHandler(e:KeyboardEvent):void {
			//trace("KEY");
			correctedTextValue = "";
			shiftKey = e.shiftKey;
		}

		private function textInputHandler(e:TextEvent):void {
			//trace("INPUT");
			pos = textInput.selectionAnchorPosition;
			if (shiftKey && isRestrictedChar(e.text)) {
				correctedTextValue = e.text.toLowerCase();
			} else {
				correctedTextValue = e.text.toUpperCase();
			}
		}

		private function changeHandler(e:Event):void {
			//trace("CHANGE");
			var prefix:String = textInput.text.substr(0, pos);
			var suffix:String = textInput.text.substr(pos + correctedTextValue.length,
					textInput.text.length - pos);
			//trace(prefix + "|" + correctedTextValue + "|" + suffix);
			//replace text.
			textInput.text = prefix + correctedTextValue + suffix;
			textInput.validateProperties();
		}

		private function isRestrictedChar(str:String):Boolean {
			if (!str || str.length > 1) {
				return false;
			}
			for each (var ch:String in exeptionChars) {
				if (str.toLowerCase() == ch.toLowerCase()) {
					return true;
				}
			}
			return false;
		}
	}
}