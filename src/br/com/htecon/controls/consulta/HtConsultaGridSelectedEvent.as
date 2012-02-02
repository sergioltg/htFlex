package br.com.htecon.controls.consulta
{
	import flash.events.Event;
	
	public class HtConsultaGridSelectedEvent extends Event
	{
		
		public static const ITEM_SELECTED:String = "itemSelected";
		
		public var item:Object;
		
		public function HtConsultaGridSelectedEvent(type:String, item:Object, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			this.item = item;
			super(type, bubbles, cancelable);			
		}

	}
}