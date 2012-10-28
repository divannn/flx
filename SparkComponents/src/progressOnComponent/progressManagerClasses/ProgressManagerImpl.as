package progressOnComponent.progressManagerClasses {
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.core.Container;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;

	import progressOnComponent.events.HideProgressEvent;
	import progressOnComponent.events.ShowProgressEvent;

	public class ProgressManagerImpl extends EventDispatcher {
		private static var _instance:ProgressManagerImpl;

		private const HIDE:Number = 0;
		private const SHOW:Number = 1;
		private const DEFAULT_MODAL_TRANSPARENCY_COLOR:uint = 0xFFFFFF;
		private const DEFAULT_MODAL_TRANSPARNCY:Number = 0.5;
		private const DEFAULT_MODAL_TRANSPARNCY_DURATION:int = 400;
		private const DEFAULT_SPINNER_COLOR:uint = 0x999999;
		private const DEFAULT_SPINNER_RATE:Number = 50;
		private const DEFAULT_SPINNER_MAX_LIGHTNESS_PERCENT:Number = -70;
		private const DEFAULT_SPINNER_MIN_LIGHTNESS_PERCENT:Number = 70;
		private const DEFAULT_SPINNER_INNER_DIAMETER:Number = 0;
		private const DEFAULT_SPINNER_SEGMENT_WIDTH:Number = 2;
		private const DEFAULT_SPINNER_SEGMENT_COUNT:Number = 9;

		protected var isPlaying:Boolean;
		protected var progressRegionMap:Object = {};

		public function ProgressManagerImpl(singletonEnforcer:SingletonEnforcer) {
			super();
		}

		public static function getInstance():ProgressManagerImpl {
			if (!_instance) {
				_instance = new ProgressManagerImpl(new SingletonEnforcer())
			}
			return _instance;
		}

		public function addProgressRegion(progressRegion:ProgressRegion):void {
			if (!progressRegionMap[progressRegion.uniqueName]) {
				progressRegionMap[progressRegion.uniqueName] = progressRegion;
			}
		}

		public function removeProgressRegion(uniqueName:String):void {
			if (!progressRegionMap[uniqueName]) {
				return;
			}
			if (ProgressRegion(progressRegionMap[uniqueName]).isVisible) {
				hideModal(uniqueName, false);
			}
			delete progressRegionMap[uniqueName];
		}

		public function showModal(uniqueName:String,
				playAnimation:Boolean = false):void {

			if (!progressRegionMap[uniqueName]) {
				return;
			}

			var spinner:ProgressSpinner;
			var modal:UIComponent;
			var width:Number = 0;
			var height:Number = 0;
			var targetContainer:Container;
			var progressRegion:ProgressRegion;

			progressRegion = progressRegionMap[uniqueName];
			progressRegion.triggerCount++;

			if (progressRegion.isVisible) {
				return;
			}
			trace("+++ show glass");

			targetContainer = progressRegion.targetRegion;

			if (!targetContainer) {
				return;
			}

			width = targetContainer.width;
			height = targetContainer.height;

			if (!spinner) {
				spinner = new ProgressSpinner();
				spinner.name = "spinner";
				spinner.baseColor = getStyleValue("spinnerColor");
				spinner.rate = getStyleValue("spinnerRate");
				spinner.maxLightnessPercent = getStyleValue("spinnerMaxLightnessPercent");
				spinner.minLightnessPercent = getStyleValue("spinnerMinLightnessPercent");
				spinner.segmentCount = getStyleValue("spinnerSegmentCount");
				spinner.segmentWidth = getStyleValue("spinnerSegmentWidth");
				spinner.innerDiameter = getStyleValue("spinnerInnerDiameter");

				progressRegion.progressSpinner = spinner;
			}

			if (!modal) {
				modal = new UIComponent();
				modal.name = "modal";
				modal.id = uniqueName;
				modal.addChild(spinner);

				progressRegion.modal = modal;

				targetContainer.rawChildren.addChild(modal);
				targetContainer.addEventListener(Event.RESIZE,
						parentContainerResizeHandler);

				spinner.startSpin();
			}

			if (playAnimation) {
				modal.alpha = 0.0;
				animate(modal, SHOW);
			}

			progressRegion.isVisible = true;
			drawModal(uniqueName, width, height);

			dispatchEvent(new ShowProgressEvent(uniqueName));
		}

		public function hideModal(uniqueName:String,
				playAnimation:Boolean = false):void {

			if (!progressRegionMap[uniqueName]) {
				return;
			}
			var targetContainer:Container;
			var modal:UIComponent;
			var spinner:ProgressSpinner;
			var progressRegion:ProgressRegion;

			progressRegion = progressRegionMap[uniqueName];
			progressRegion.triggerCount--;

			if (!progressRegion.isVisible /*|| progressRegion.triggerCount != 0*/) {
				return;
			}
			trace("--- hide glass");


			spinner = progressRegion.progressSpinner;
			modal = progressRegion.modal;
			targetContainer = progressRegion.targetRegion;

			if (!playAnimation) {
				if (spinner) {
					spinner.stopSpin();
					modal.removeChild(spinner);
					spinner = null;
				}

				if (modal) {
					targetContainer.rawChildren.removeChild(modal);
					modal = null;
				}
			}

			animate(modal, HIDE);

			progressRegion.isVisible = false;
			progressRegion.modal = null;
			progressRegion.progressSpinner = null;

			dispatchEvent(new HideProgressEvent(uniqueName));
		}

		private function animate(target:UIComponent, type:Number):void {
			var fadeEffect:Fade;
			var duration:int = getStyleValue("modalTransparencyDuration");

			duration = duration == 0 ? DEFAULT_MODAL_TRANSPARNCY_DURATION : duration;

			if (type == SHOW && target) {
				isPlaying = true;

				fadeEffect = new Fade(target);
				fadeEffect.alphaTo = 1.0;
				fadeEffect.startDelay = 100;
				fadeEffect.duration = duration;
				fadeEffect.addEventListener(EffectEvent.EFFECT_END,
						in_effectEndHandler);
				fadeEffect.play();
			}

			if (type == HIDE && target) {
				isPlaying = true;

				fadeEffect = new Fade(target);
				fadeEffect.alphaTo = 0.0;
				fadeEffect.startDelay = 100;
				fadeEffect.duration = duration;
				fadeEffect.addEventListener(EffectEvent.EFFECT_END,
						out_effectEndHandler);
				fadeEffect.play();
			}
		}

		private function drawModal(uniqueName:String, width:Number,
				height:Number):void {
			var progressRegion:ProgressRegion;

			var modal:UIComponent;
			var spinner:ProgressSpinner;

			var graphics:Graphics;

			var modalColor:uint = getStyleValue("modalTransparencyColor");
			var modalAlpha:Number = getStyleValue("modalTransparency");

			progressRegion = progressRegionMap[uniqueName];
			modal = progressRegion.modal;
			spinner = progressRegion.progressSpinner;

			if (modal) {
				graphics = modal.graphics;
				graphics.clear();
				graphics.beginFill(modalColor, modalAlpha);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}

			if (spinner) {
				spinner.width = 25;
				spinner.height = 25;
				spinner.x = (width / 2) - (spinner.width / 2);
				spinner.y = (height / 2) - (spinner.height / 2);
			}

		}

		private function getStyleValue(property:String):* {
			var manager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;
			var styleDeclaration:CSSStyleDeclaration = manager.getStyleDeclaration(".ProgressManager");
			var styleValue:Object = styleDeclaration.getStyle(property);
			return styleValue;
		}

		private function parentContainerResizeHandler(event:Event):void {
			var targetContainer:Container = event.currentTarget as Container;
			var width:Number = targetContainer.width;
			var height:Number = targetContainer.height;
			var uniqueName:String;
			var modal:UIComponent = targetContainer.rawChildren.getChildByName("modal") as UIComponent;

			if (modal) {
				uniqueName = modal.id;
				drawModal(uniqueName, width, height);
			}
		}


		private function out_effectEndHandler(event:EffectEvent):void {
			var modal:UIComponent = event.effectInstance.target as UIComponent;
			var spinner:ProgressSpinner = modal.getChildAt(0) as ProgressSpinner;
			var parent:Container = modal.parent as Container;

			if (spinner) {
				spinner.stopSpin();
				modal.removeChild(spinner);
				spinner = null;
			}

			if (modal) {
				parent.rawChildren.removeChild(modal);
				modal = null;
			}

			isPlaying = false;
		}

		private function in_effectEndHandler(event:EffectEvent):void {
			isPlaying = false;
		}
	}
}

class SingletonEnforcer {
}
