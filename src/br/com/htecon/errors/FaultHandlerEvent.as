package br.com.htecon.errors
{
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;

	public class FaultHandlerEvent extends Event
	{
		
		public static const FAULT_HANDLER:String = "FAULT_HANDLER";
		
		public var faultEvent:FaultEvent;
		
		public function FaultHandlerEvent(type:String, faultEvent:FaultEvent, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			this.faultEvent = faultEvent;
			super(type, bubbles, cancelable);
		}
		
	}
}