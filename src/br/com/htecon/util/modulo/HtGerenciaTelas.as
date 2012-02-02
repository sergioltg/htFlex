package br.com.htecon.util.modulo
{
	import br.com.htecon.events.HtGerenciaTelaEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	
	public class HtGerenciaTelas implements IEventDispatcher
	{
		
		private var dispatcher:EventDispatcher;
		
		public var module:String;
		public var modulesLoaded:ArrayCollection;
		
		private var callingTela:String;
		private var callingModule:Object;
		
		/**
		 * hash de telas que são carregadas junto com o 
		 * carregamento inicial da aplicação.
		 * */
		public var hashTelas:Object;
		
		public function HtGerenciaTelas() {
			super();
			dispatcher = new EventDispatcher();
			modulesLoaded = new ArrayCollection();
		}
		
		/**
		 * Retorna a tela que esta importada na application.
		 * */
		private function getTela(  nmTela:String ):UIComponent{
			// Caso não tenha sido setado o hashTelas faz trace comunicando
			if(hashTelas == null){
				trace( 'Propriedade hashTelas da classe HtGerenciaTela.as não foi setada!' );
				return null;
			}
			
			var c:Class = hashTelas[nmTela.toLowerCase()] as Class;
			return new c() as UIComponent;
		}
		
		
		/**
		 * Pega instancia do modulo. Este metodo é chamado apenas a primeira vez que 
		 * o modulo é carregado.
		 * */
		public function getModuleInstance(e:Event):void {
			var sm:HtModuloFlex = callingModule["moduleInfo"].factory.create();
			callingModule["module"] = sm;
			sm.init();
			
			if (callingTela != null) {
				dispatchEvent(new HtGerenciaTelaEvent(HtGerenciaTelaEvent.TELA, sm.getTela(callingTela)));
				callingTela = null;
			}
		}
		
		
		/**
		 * Busca a tela desejada. Caso ela eteja em um modulo faz toca a logica
		 * de carregamento.
		 * */
		public function callTela( caminhoModulo:String, nmTela:String ):void {
			// Caso o caminho seja ""  ou null signitica que devesse pegar a tela 
			// que fo carregada junto com a application. 
			if ( caminhoModulo == null || caminhoModulo == "" ) {
				dispatchEvent(new HtGerenciaTelaEvent(HtGerenciaTelaEvent.TELA, getTela(nmTela)));
			} else {
				var module:HtModuloFlex = getModuleLoaded(caminhoModulo);
				
				// Caso o modulo esteja carregado.
				if (module != null) {
					dispatchEvent(new HtGerenciaTelaEvent(HtGerenciaTelaEvent.TELA, module.getTela(nmTela)));					
				
				// Caso o modulo não esteja carregado. Faz carregamento e tratamentos especiais.
				} else {
					var assetModule:IModuleInfo = ModuleManager.getModule(caminhoModulo + ".swf");
					assetModule.addEventListener("ready", getModuleInstance);
					assetModule.load(ApplicationDomain.currentDomain);
					var newModule:Object = new Object();
					newModule["name"] = caminhoModulo;
					newModule["moduleInfo"] = assetModule;
					callingTela = nmTela;
					callingModule = newModule;
					modulesLoaded.addItem(newModule);
				}
			}			
		}
		
		public function openModule(moduleName:String):void {
			var assetModule:IModuleInfo = ModuleManager.getModule("modules/" + moduleName + ".swf");
			assetModule.addEventListener("ready", getModuleInstance);
		assetModule.load(ApplicationDomain.currentDomain);
			var newModule:Object = new Object();
			newModule["name"] = moduleName;
			newModule["moduleInfo"] = assetModule;
			callingTela = null;
			callingModule = newModule;			
			modulesLoaded.addItem(newModule);			
		}
		
		private function getModuleLoaded(nameModule:String):HtModuloFlex {
			for each(var module:Object in modulesLoaded) {
				if (module["name"] == nameModule) {
					return module["module"]; 
				}
			}
			
			return null;
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