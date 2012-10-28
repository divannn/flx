package customTestInput {
	import flash.events.FocusEvent;
	import spark.components.TextInput;

	public class AHTextInput extends TextInput {
		//Declare the Additional SkinStates
		[SkinState("focused")];

		private var bfocused:Boolean;

		public function AHTextInput() {
			super();
		}

		//Add EventListeners to the textview for FocusEvent
		override protected function partAdded(partName:String,
				instance:Object):void {
			super.partAdded(partName, instance);
			if (instance == this.textDisplay) {
				trace("Adding textDisplay");
				this.textDisplay.addEventListener(FocusEvent.FOCUS_IN,
						onFocusInHandler);
				this.textDisplay.addEventListener(FocusEvent.FOCUS_OUT,
						onFocusOutHandler);
			}
		}

		//Clean up EventListeners and stuff...
		override protected function partRemoved(partName:String,
				instance:Object):void {
			super.partRemoved(partName, instance);
			if (instance == this.textDisplay) {
				this.textDisplay.removeEventListener(FocusEvent.FOCUS_IN,
						onFocusInHandler);
				this.textDisplay.removeEventListener(FocusEvent.FOCUS_OUT,
						onFocusOutHandler);
			}
		}

		//Leverage the new SkinState
		override protected function getCurrentSkinState():String {
			if (bfocused) {
				return "focused";
			} else {
				return super.getCurrentSkinState();
			}
		}

		//Handler for FocusIn Event
		private function onFocusInHandler(event:FocusEvent):void {
			bfocused = true;
			invalidateSkinState();
			trace("Getting focus");
		}

		//Handler for FocusOut
		private function onFocusOutHandler(event:FocusEvent):void {
			bfocused = false;
			invalidateSkinState();
			trace("Loosing focus");
		}
	}
}