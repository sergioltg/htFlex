package br.com.htecon.controller
{
	import br.com.htecon.controller.events.HtControllerCallBackEvent;
	import br.com.htecon.errors.ErrorHandler;
	import br.com.htecon.util.Processando;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.Swiz;
	import org.swizframework.controller.AbstractController;
	
	/**
	 * Classe basica de controller.
	 *
    */
	
	public class HtBasicController extends AbstractController implements IEventDispatcher
	{
		
		private var dispatcher:EventDispatcher;				
		private var processando:Processando;
		
		
		public function HtBasicController() {
			dispatcher = new EventDispatcher();
		}
		
		
		/**
		 *  Mostra tela processando
		 *  
		*/
		public function startProcessando():void {
			processando = Processando.show();
		}

		/**
		 *  Fecha tela processando
		 *  
		 */
		public function endProcessando():void {
			if (processando != null) {
				processando.close();
				processando = null;
			}			
		}
		
		/**
		 *  executa um servico, callBackService fecha tela processando e response os dados para a funcao passada, caso
		 * de algum erro, fecha a tela processando e mostra o erro na tela
		 *  
		 */
		public function executeService(action:String, asyncToken:AsyncToken, callback:Function, calbackError:Function = null, params:Array = null):void {		
			executeServiceCall(asyncToken, callBackService, calbackError==null?callBackServiceError:calbackError, [action, callback, params]);
		}
		
		protected function callBackService(event:ResultEvent, action:String, callback:Function, params:Array):void {			
			endProcessando();
			
			if (callback != null) {
				if (params != null) {
					callback(event, params);
				} else {
					callback(event);
				}
			}
			
			dispatchEventSwiz(action);
		}
		
		protected function dispatchEventSwiz(action:String):void {
			// Retirar retorno eventos pelo Swiz - todo
			Swiz.dispatchEvent(new HtControllerCallBackEvent(getControllerCallBackEventName(), action));
			dispatcher.dispatchEvent(new HtControllerCallBackEvent(HtControllerCallBackEvent.CALLBACK, action));
		}
		
		protected function callBackServiceError(event:FaultEvent, action:String, callback:Function, params:Array):void {
			endProcessando();
			ErrorHandler.handleFaultEvent(event);
		}		
		
		/**
		 *  Retorna um nome para evento, isso eh usado para quando tiver multiplas instancias. 
		 * Por padrao o swiz deixa apenas uma instancia dos controllers e caso seja aberto uma duas instancias de uma mesma tela
		 * é necessário mudar no arquivo de configuracoes do swiz para gerar multiplas instancias
		 *  
		 */
		public function getControllerCallBackEventName():String {
			return getQualifiedClassName(this) + "_event";
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
		
	}
}