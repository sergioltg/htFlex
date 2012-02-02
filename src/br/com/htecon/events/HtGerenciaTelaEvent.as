package br.com.htecon.events
{
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.core.UIComponent;

	public class HtGerenciaTelaEvent extends Event
	{
		public static const TELA:String = "TELA";
		
		public var tela:UIComponent;
		
		public function HtGerenciaTelaEvent(type:String, tela:UIComponent, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			this.tela = tela;
			super(type, bubbles, cancelable);
		}
		
	}
}