package br.com.htecon.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	
	[Event(name="collapsedChanged", type="flash.events.Event")]	
	public class HtPanel extends Panel
	{
		
		[Embed(source="/assets/section_collapsed2.png")]
		[Bindable]
		private static var sectionCollaped:Class;
		
		[Embed(source="/assets/section_expanded2.png")]
		[Bindable]
		private static var sectionExpanded:Class;		
	
		public var buttonPadding:Number = 10;
		
		private var showButtonchanged:Boolean;
		private var maximizedchanged:Boolean;
		
		private var _showButton:Boolean = true;
		private var _maximized:Boolean = true;
		
		private var lastHeight: int;
		
		private var mybtn:Button;
		
		public function HtPanel() {
			super();
			
			mybtn = new Button();
			mybtn.styleName = "firstButton";
			mybtn.height = 23;
			mybtn.width = 22;
			mybtn.setStyle("icon", sectionExpanded);
			mybtn.setStyle("horizontalAlign", "center");
			
			mybtn.addEventListener( MouseEvent.CLICK, buttonClickHandler );			
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			if (!showButton) 
				return;
			
			rawChildren.addChild( mybtn );		
			
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			var x:int = width - ( mybtn.width + buttonPadding );
//			mybtn.width = mybtn.measuredWidth;
//			mybtn.height = mybtn.measuredHeight;
			mybtn.move( x, getHeaderHeight() / 2 - mybtn.height / 2 );
		}
		
		private function buttonClickHandler(event:MouseEvent):void
		{
			maximized = !maximized;			
		}

		public function get showButton():Boolean
		{
			return _showButton;
		}

		public function set showButton(value:Boolean):void
		{
			_showButton = value;
			showButtonchanged = true;
			invalidateProperties();			
		}

		public function get maximized():Boolean
		{
			return _maximized;
		}

		public function set maximized(value:Boolean):void
		{
			_maximized = value;
			maximizedchanged = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (showButtonchanged) {
				showButtonchanged = false;
				mybtn.visible = showButton;
				mybtn.includeInLayout = showButton;
			}
			
			if (maximizedchanged) {
				maximizedchanged = false;
				changeHeight();
				dispatchEvent(new Event("collapsedChanged"));				
			}

		}
		
		private function changeHeight():void {
			if (maximized) {
				if (lastHeight == 0) {
					lastHeight = height;
				} else {
					height = lastHeight;
				}
				mybtn.setStyle("icon", sectionExpanded);
			} else {
				lastHeight = height;
				height = getHeaderHeight();
				mybtn.setStyle("icon", sectionCollaped);				
			}
		}
		
		
		
	}
	
}