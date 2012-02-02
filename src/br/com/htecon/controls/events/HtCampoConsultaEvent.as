package br.com.htecon.controls.events
{
	import flash.events.Event;

	public class HtCampoConsultaEvent extends Event
	{
		
		public static var ITEMSELECTED:String = "itemSelected";
		public static var ITEMCLEARED:String = "itemCleared";	
		
		
		public function HtCampoConsultaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}