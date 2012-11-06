
package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;

	public class PrintDisplayList
	{
		private static var nestLevel:int = 0;
		private static var tabChar:String = " ";
		
		public static function printHierarchyUp(comp:DisplayObject):void {
			nestLevel = 0;
			trace("--------------------------------------- display list up hierarchy for: " + getQualifiedClassName(comp));
			hierarchyUp(comp);
		}
		
		private static function hierarchyUp(comp:DisplayObject):void {
			if (!comp) {
				return;
			}
			hierarchyUp(comp.parent);
			var tabPrefix:String = repeat(tabChar, nestLevel++);
			trace(tabPrefix + getQualifiedClassName(comp) + "|" + comp.name);
		}
		
		public static function printHierarchyDown(comp:DisplayObjectContainer):void {
			nestLevel = 0;
			trace("--------------------------------------- display list down hierarchy for: " + getQualifiedClassName(comp));
			hierarchyDown(comp);
		}
		
		private static function hierarchyDown(comp:DisplayObjectContainer):void {
			if (!comp) {
				return;
			}
			var tabPrefix:String = repeat(tabChar, nestLevel);
			for (var j:int = 0; j < comp.numChildren; j++) {
				var nextChild:DisplayObject = comp.getChildAt(j);
				trace(tabPrefix + getQualifiedClassName(nextChild) + "|" + nextChild.name);
				if (nextChild is DisplayObjectContainer) {
					nestLevel++;
					hierarchyDown(DisplayObjectContainer(nextChild));
					nestLevel--;
				}
			}
		}
		
		private static function repeat(tabChar:String, tabCount:int):String {
			var result:String = "";
			var tabSize:int = 4;
			for (var i:int = 0; i < tabCount*tabSize; i++) {
				result += tabChar;
			}
			return result;
		}

	}
}