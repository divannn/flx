package util {

	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	import mx.utils.StringUtil;

	public class PrintDisplayList {
		private var tabCount:int;
		private var tabChar:String = " ";

		public function printHierarchy(comp:DisplayObject):void {
			trace("--------------------------------------- display list hierarchy for: " + getQualifiedClassName(comp));
			hierarchy(comp);
		}

		private function hierarchy(comp:DisplayObject):void {
			if (!comp) {
				return;
			}
			hierarchy(comp.parent);
			var tabPrefix:String = StringUtil.repeat(tabChar, tabCount++);
			trace(tabPrefix + getQualifiedClassName(comp));
		}

	}
}