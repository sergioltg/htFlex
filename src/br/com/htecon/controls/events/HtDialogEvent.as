package br.com.htecon.controls.events
{
	import br.com.htecon.data.HtEntity;
	
	import flash.events.Event;
	
	public class HtDialogEvent extends Event
	{
		
		public static const DIALOG_OK:String = "DIALOG_OK";
		
		public var entity: HtEntity;
		
		public function HtDialogEvent(type:String, entity:HtEntity, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.entity = entity;
			super(type, bubbles, cancelable);
		}
	}
}