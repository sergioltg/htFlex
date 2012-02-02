package br.com.htecon.util
{
	import br.com.htecon.controls.consulta.HtConsultaBasica;
	import br.com.htecon.controls.consulta.HtConsultaGridSelectedEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	[Event(name="itemSelected", type="br.com.htecon.controls.consulta.HtConsultaGridSelectedEvent")]	
	public class HtOpenConsultaGrid implements IEventDispatcher
	{
		
		public var consultaGrid:Class;
		private var dispatcher:EventDispatcher;
		public var allowMultipleSelection = false;
		
		public function HtOpenConsultaGrid()
		{
			dispatcher = new EventDispatcher();			
		}		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}		
		
		public function dispatchEvent(evt:Event):Boolean{
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);			
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
		
		public function openConsulta(abrirConsultando:Boolean = false):void {
			var consultaTitleWindow:TitleWindow = TitleWindow(PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, TitleWindow, true));
			
			var consulta:HtConsultaBasica = new consultaGrid();
			consulta.estadoSelecionar = true;
			consulta.estadoEditar = false;
			consulta.abrirConsultando = false;
			consulta.dataGridConsulta.allowMultipleSelection = allowMultipleSelection; 
			consulta.addEventListener(HtConsultaGridSelectedEvent.ITEM_SELECTED, consultaItemSelectedHandler, false, 0, true);			
			
			consultaTitleWindow.width = consulta.width + 28;
			consultaTitleWindow.height = 500;
			consultaTitleWindow.addChild(consulta);
			consultaTitleWindow.title = consulta.label;
			
			PopUpManager.centerPopUp(consultaTitleWindow);
		}	
		
		private function consultaItemSelectedHandler(event:HtConsultaGridSelectedEvent):void {
			dispatcher.dispatchEvent(new HtConsultaGridSelectedEvent(HtConsultaGridSelectedEvent.ITEM_SELECTED, event.item));
		}
		
	}
}