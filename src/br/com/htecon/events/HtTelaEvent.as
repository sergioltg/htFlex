package br.com.htecon.events
{
	
	import flash.events.Event;

	public class HtTelaEvent extends Event{
		
		public static const OPEN:String = "HtTelaEvent.openTela";
		public var nmTela:String;
		public var caminhoModulo:String;
		public var param:Object;
	
		public function HtTelaEvent(type:String, caminhoModulo:String, nmTela:String, param:Object = null, bubbles:Boolean = true, cancelable:Boolean = false){
   			this.caminhoModulo = caminhoModulo;
			this.nmTela = nmTela;
			this.param = param;
			
			super(type, bubbles, cancelable);
		}
	}
}