package promptedTextInput2 {

	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import spark.components.Label;
	import spark.components.TextInput;

	// Extra skin states that we need to show prompt
	[SkinState("normalWithPrompt")]
	[SkinState("disabledWithPrompt")]

	public class PromptedTextInput2 extends TextInput {
		// Create a new skin part that will display our prompts
		[SkinPart(required="false")]
		public var promptDisplay:Label;

		private var _prompt:String; // Holds the value of the prompt text
		private var _promptChanged:Boolean; // Flag for the invalidation
		private var _inFocus:Boolean = false; // Flag used to know if in focus

		// New state constants
		static protected const NORMAL_WITH_PROMPT:String = 'normalWithPrompt';
		static protected const DISABLED_WITH_PROMPT:String = 'disabledWithPrompt';

		public function PromptedTextInput2() {
			super();
			this.addEventListener(FocusEvent.FOCUS_IN, onFocusHandler);
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusHandler);

			// sets the default skin
			setStyle("skinClass", PromptedTextInputSkin2);
		}

		[Bindable]
		public function get prompt():String {
			return _prompt;
		}

		public function set prompt(value:String):void {
			if (_prompt !== value) {
				_prompt = value;
				_promptChanged = true;
				invalidateProperties();
			}
		}

		/**
		 * Adding the prompt text to the label if it's available
		 */
		override protected function commitProperties():void {
			super.commitProperties();

			if (this._promptChanged) {
				if (promptDisplay) {
					promptDisplay.text = prompt;
				}
				_promptChanged = false;
			}
		}

		/**
		 * Changing the logic to add our new skin states
		 *
		 * @return The state that the skin should change to
		 */
		override protected function getCurrentSkinState():String {
			if (!_inFocus && text.length == 0) {
				if (enabled) {
					return NORMAL_WITH_PROMPT;
				} else {
					return DISABLED_WITH_PROMPT;
				}
			} else {
				return super.getCurrentSkinState();
			}
		}

		/**
		 * Listen to see if the prompt label is being created and add
		 * prompt text to it.
		 *
		 * @param partName:String
		 * @param instance:Object
		 */
		override protected function partAdded(partName:String,
				instance:Object):void {
			super.partAdded(partName, instance);
			if (instance == promptDisplay) {
				promptDisplay.text = prompt;
			}
		}

		/**
		 * Handles the focus event and sets our focus flag then
		 * invalidates the skin to change states appropriately
		 * @param e:FocusEvent
		 */
		private function onFocusHandler(e:FocusEvent):void {
			this._inFocus = (e.type == FocusEvent.FOCUS_IN);
			invalidateSkinState();
		}
	}

}