package filteredTextInputDemo {

	import flash.events.KeyboardEvent;

	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.ITextExporter;
	import flashx.textLayout.conversion.ITextImporter;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.TextScrap;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.TextRange;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	import flashx.textLayout.tlf_internal;

	import spark.components.TextInput;
	import spark.events.TextOperationEvent;

	/**
	 * Converts all text into uppercase. 3 chars "r", "w", "p" is special - they can be ebtered in lowercase with Shift key.
	 * @author idanilov
	 */
	public class TextInputFilter {
		private static const exeptionChars:Array = ["r", "w", "p"];

		private var textInput:TextInput;
		private var shiftKey:Boolean = false;

		public function TextInputFilter(textInput:TextInput) {
			this.textInput = textInput;
			configureListeners();
		}

		private function configureListeners():void {
			textInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler,
					false, 0);
			textInput.addEventListener(TextOperationEvent.CHANGING,
					textChangingHandler, false, 0);
		}

		private function keyDownHandler(e:KeyboardEvent):void {
			shiftKey = e.shiftKey;
		}

		private function textChangingHandler(e:TextOperationEvent):void {
			if (e.operation is InsertTextOperation) {
				processInsert(e);
			} else if (e.operation is PasteOperation) {
				processPaste(e);
			}
		}

		private function processInsert(e:TextOperationEvent):void {
			var insOp:InsertTextOperation = InsertTextOperation(e.operation);
			var correctedTextValue:String = correct(insOp.text);
			insOp.text = correctedTextValue;
		}

		private function processPaste(e:TextOperationEvent):void {
			var pasteOp:PasteOperation = PasteOperation(e.operation);
			var scrap:TextScrap = pasteOp.textScrap;

			var plainTextImporter:ITextImporter = TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
			var plainTextExporter:ITextExporter = TextConverter.getExporter(TextConverter.PLAIN_TEXT_FORMAT);
			var pastedText:String =  String(plainTextExporter.export(scrap.tlf_internal::textFlow,
					ConversionType.STRING_TYPE));
			//trace(">>> PASTE :" + pastedText);
			var correctedTexFlow:TextFlow = plainTextImporter.importToFlow(pastedText.toUpperCase());
			pasteOp.textScrap = TextScrap.createTextScrap(new TextRange(correctedTexFlow,
					0, pastedText.length));
		}

		private function correct(str:String):String {
			var result:String;
			if (shiftKey) {
				result = correctChars(str);
			} else {
				result = str.toUpperCase();
			}
			return result;
		}

		private function correctChars(str:String):String {
			if (!str) {
				return str;
			}
			var result:String = "";
			for (var i:int = 0; i < str.length; i++) {
				var strChar:String = str.charAt(i);
				if (isRestrictedChar(strChar)) {
					result += strChar.toLowerCase();
				} else {
					result += strChar.toUpperCase();
				}
			}
			return result;
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