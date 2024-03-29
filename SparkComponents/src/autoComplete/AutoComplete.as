package autoComplete {

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.SandboxMouseEvent;

	import spark.components.Group;
	import spark.components.List;
	import spark.components.PopUpAnchor;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;

	[Event(name="select", type="autoComplete.AutoCompleteEvent")]

	[Event(name="enter", type="mx.events.FlexEvent")]

	[Event(name="change", type="spark.events.TextOperationEvent")]

	public class AutoComplete extends SkinnableComponent {

		public function AutoComplete() {
			super();
			//[ID]this.mouseEnabled = true;
			this.setStyle("skinClass", Class(AutoCompleteSkin));
			//[ID]this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut)
			collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,
					collectionChange);
		}

		public var maxRows:Number = 6;
		public var minChars:Number = 1;
		public var prefixOnly:Boolean = true;
		public var requireSelection:Boolean = false;

		[SkinPart(required="true", type="spark.components.Group")]
		public var dropDown:Group;
		[SkinPart(required="true", type="spark.components.PopUpAnchor")]
		public var popUp:PopUpAnchor;
		[SkinPart(required="true", type="spark.components.List")]
		public var list:List;
		[SkinPart(required="true", type="spark.components.TextInput")]
		public var inputTxt:TextInput;

		override protected function partAdded(partName:String,
				instance:Object):void {
			super.partAdded(partName, instance);

			if (instance == inputTxt) {
				inputTxt.addEventListener(FocusEvent.FOCUS_OUT,
						onTextFocusOutHandler);
				inputTxt.addEventListener(FocusEvent.FOCUS_IN,
						onTextFocusInHandler);
				inputTxt.addEventListener(TextOperationEvent.CHANGE,
						onTextChange);
				inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, onTextKeyDown);
				inputTxt.addEventListener(FlexEvent.ENTER, onTextEnter);
				inputTxt.text = _text;
			}
			if (instance == list) {
				list.dataProvider = collection;
				list.labelField = labelField;
				list.labelFunction = labelFunction;
				list.addEventListener(FlexEvent.CREATION_COMPLETE,
						onListClickListener);
				list.focusEnabled = false;
				list.requireSelection = requireSelection;
			}
			if (instance == dropDown) {
				dropDown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,
						mouseOutsideHandler);
				dropDown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,
						mouseOutsideHandler);
				dropDown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,
						mouseOutsideHandler);
				dropDown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,
						mouseOutsideHandler);
			}
		}

		private var collection:ListCollectionView = new ArrayCollection();

		public function set dataProvider(value:Object):void {
			if (value is Array) {
				collection = new ArrayCollection(value as Array);
			} else if (value is ListCollectionView) {
				collection = value as ListCollectionView;
				collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,
						collectionChange)
			}

			if (list) {
				list.dataProvider = collection;
			}

			filterData();
		}

		public function get dataProvider():Object {
			return collection;
		}

		private function collectionChange(event:CollectionEvent):void {
			if (event.kind == CollectionEventKind.RESET ||
					event.kind == CollectionEventKind.ADD) {
				filterData();
			}
		}

		private var _text:String = "";

		public function set text(t:String):void {
			_text = t;
			if (inputTxt) {
				inputTxt.text = t;
			}
		}

		public function get text():String {
			return _text;
		}

		private var _labelField:String;

		public function set labelField(field:String):void {
			_labelField = field;
			if (list) {
				list.labelField = field
			}
		}

		public function get labelField():String {
			return _labelField
		}
		;

		public function set labelFunction(func:Function):void {
			_labelFunction = func;
			if (list) {
				list.labelFunction = func
			}
		}

		public function get labelFunction():Function {
			return _labelFunction;
		}

		private var _labelFunction:Function;

		public var returnField:String;

		public function get selectedItem():Object {
			return _selectedItem;
		}

		public function set selectedItem(item:Object):void {
			_selectedItem = item;
			text = returnFunction(item)
		}

		private var _selectedItem:Object;

		public function get selectedIndex():int {
			return _selectedIndex;
		}
		private var _selectedIndex:int = -1;

		private function onTextChange(event:TextOperationEvent):void {
			_text = inputTxt.text;
			if (text.length >= minChars || text.length == 0) {
				filterData();
			}
			dispatchEvent(event);
		}

		public function filterData():void {
			if (!this.focusManager || this.focusManager.getFocus() != inputTxt) {
				return;
			}
			if (!popUp) {
				return;
			}

			collection.filterFunction = filterFunction;
			var customSort:Sort = new Sort();
			customSort.compareFunction = sortFunction;
			collection.sort = customSort;
			collection.refresh();

			if ((text == "" || collection.length == 0) && !forceOpen) {
				close();
			} else {
				show();
				if (requireSelection) {
					list.selectedIndex = 0;
				} else {
					list.selectedIndex = -1;
				}
				list.dataGroup.verticalScrollPosition = 0;
				list.dataGroup.horizontalScrollPosition = 0;
				list.height = Math.min(maxRows, collection.length) * 22 + 2;
				list.width = inputTxt.width * 1.5;
				list.validateNow();
			}
		}

		// default filter function 

		public function filterFunction(item:Object):Boolean {
			var label:String = itemToLabel(item).toLowerCase();
			// prefix mode
			if (prefixOnly) {
				if (label.search(text.toLowerCase()) == 0) {
					return true;
				} else {
					return false
				}
			}
			// infix mode
			else {
				if (label.search(text.toLowerCase()) != -1) {
					return true;
				}
			}
			return false;
		}

		public function itemToLabel(item:Object):String {
			if (item == null) {
				return "";
			}
			if (labelFunction != null) {
				return labelFunction(item);
			} else if (labelField && item[labelField]) {
				return item[labelField];
			} else {
				return item.toString();
			}
		}

		private function returnFunction(item:Object):String {
			if (item == null) {
				return "";
			}
			if (returnField) {
				return item[returnField];
			} else {
				return itemToLabel(item);
			}
		}

		// default sorting - alphabetically ascending
		public var sortFunction:Function = defaultSortFunction;

		public function defaultSortFunction(item1:Object, item2:Object,
				fields:Array = null):int {
			var label1:String = itemToLabel(item1);
			var label2:String = itemToLabel(item2);
			if (label1 < label2) {
				return -1;
			} else if (label1 == label2) {
				return 0;
			} else {
				return 1;
			}

		}

		private function onTextKeyDown(event:KeyboardEvent):void {
			if (popUp.displayPopUp) {
				switch (event.keyCode) {
					case Keyboard.UP:
					case Keyboard.DOWN:
					case Keyboard.END:
					case Keyboard.HOME:
					case Keyboard.PAGE_UP:
					case Keyboard.PAGE_DOWN:
						//[ID]inputTxt.selectRange(text.length, text.length)
						list.dispatchEvent(event)
						break;
					case Keyboard.ENTER:
						acceptCompletion();
						break;
					case Keyboard.TAB:
						if (requireSelection) {
							acceptCompletion();
						} else {
							close();
						}
						break;
					case Keyboard.ESCAPE:
						close();
						break;
				}
			}
		}

		private function onTextEnter(event:FlexEvent):void {
			if (popUp.displayPopUp && list.selectedIndex > -1) {
				return;
			}
			if (list.selectedIndex < 0) {
				_selectedItem = null;
			}
			dispatchEvent(event);
		}

		// this is a workaround to reset the Mouse cursor
		//[ID]		
		//		private function onMouseOut(event:MouseEvent):void {
		//			Mouse.cursor = MouseCursor.AUTO;
		//		}

		private function close():void {
			popUp.displayPopUp = false;
		}

		private function show():void {
			popUp.displayPopUp = true;
		}

		public function acceptCompletion():void {
			if (list.selectedIndex >= 0 && collection.length > 0) {
				_selectedIndex = list.selectedIndex;
				_selectedItem = collection.getItemAt(_selectedIndex);
				text = returnFunction(_selectedItem);
				//[ID]inputTxt.selectRange(inputTxt.text.length, inputTxt.text.length);
				var e:AutoCompleteEvent = new AutoCompleteEvent(AutoCompleteEvent.SELECT,
						_selectedItem);
				dispatchEvent(e);
			} else {
				_selectedIndex = list.selectedIndex = -1;
				_selectedItem = null;
			}
			close();
		}

		public var forceOpen:Boolean = false;

		private function onTextFocusInHandler(event:FocusEvent):void {
			if (forceOpen) {
				filterData();
			}
		}

		private function onTextFocusOutHandler(event:FocusEvent):void {
			close();
			//[ID]allow to leave entered text.
			//			if (collection.length == 0) {
			//				_selectedIndex = -1;
			//				selectedItem = null;
			//			}
		}

		private function mouseOutsideHandler(event:Event):void {
			if (event is FlexMouseEvent) {
				var e:FlexMouseEvent = event as FlexMouseEvent;
				if (inputTxt.hitTestPoint(e.stageX, e.stageY)) {
					return;
				}
			}
			close();
		}

		private function onListClickListener(event:Event):void {
			list.dataGroup.addEventListener(MouseEvent.CLICK, listItemClick);
		}

		private function listItemClick(event:MouseEvent):void {
			acceptCompletion();
			event.stopPropagation();
		}

		override public function set enabled(value:Boolean):void {
			super.enabled = value;
			if (inputTxt) {
				inputTxt.enabled = value;
			}
		}

	}

}