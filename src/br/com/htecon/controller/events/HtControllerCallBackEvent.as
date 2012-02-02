package br.com.htecon.controller.events
{
	import mx.events.FlexEvent;

	public class HtControllerCallBackEvent extends FlexEvent
	{		
		public var action:String;
		
		public static const CALLBACK:String = "CALLBACK";
		
		public function HtControllerCallBackEvent(type:String, action:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.action = action;			
			super(type, bubbles, cancelable);
		}
		
	}
}