package br.com.htecon.controls.events
{
	import flash.events.Event;
	
	public class HtButtonBarClickEvent extends Event
	{
		public static const BUTTON_CLICKED:String = "buttonClicked";
		
		public var button:String;
		
		public function HtButtonBarClickEvent(type:String, button:String, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			this.button = button;
			super(type, bubbles, cancelable);			
		}

	}
}