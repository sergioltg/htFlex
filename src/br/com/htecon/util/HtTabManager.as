package br.com.htecon.util
{
	import br.com.htecon.controls.HtForm;
	import br.com.htecon.delegate.BasicDelegate;
	import br.com.htecon.events.HtGerenciaTelaEvent;
	import br.com.htecon.events.HtTelaEvent;
	
	import flash.events.Event;
	
	import mx.containers.TabNavigator;
	import mx.core.Container;
	import mx.core.FlexGlobals;
	import mx.core.INavigatorContent;
	import mx.core.UIComponent;
	import br.com.htecon.util.modulo.HtGerenciaTelas;

	
	public class HtTabManager
	{
		public var _tabNavigator:TabNavigator;
		public var _gerenciaTelas:HtGerenciaTelas;
		
		public var param:Object;
		
		public function set gerenciaTelas(gerenciaTelas:HtGerenciaTelas):void {
			this._gerenciaTelas = gerenciaTelas;
			gerenciaTelas.addEventListener(HtGerenciaTelaEvent.TELA, openTelaHandler, false, 0, true);
		}

		public function set tabNavigator(tabNavigator:TabNavigator):void
		{
			_tabNavigator = tabNavigator;
			_tabNavigator.addEventListener(Event.CLOSE, 
				function(event:Event):void{
					_tabNavigator.removeChildAt(_tabNavigator.tabIndex);
				});
			
			var application:UIComponent = UIComponent(FlexGlobals.topLevelApplication);
			application.addEventListener(HtTelaEvent.OPEN, 
				function(event:HtTelaEvent):void{
					openTela(event.caminhoModulo, event.nmTela, event.param);	
				});
		}
		
		public function findPanel(tela:String):Container{
			var length:int = _tabNavigator.getChildren().length;
			if (length == 0) return null;
			
			// Varre filhos 
			for (var i:int=0; i < length; i++){
				var klass:String = Container(_tabNavigator.getChildAt(i)).className;
				
				// Faz comparação em lowerCase
				if (klass.toLocaleLowerCase() == tela.toLowerCase()) {
					return _tabNavigator.getChildAt(i) as Container;
				}
			}
			return null;
		}

		public function openTela(caminhoModulo:String, nmTela:String, param:Object):void{
			this.param = param;
			var container:Container = findPanel(nmTela);
			if (container == null){			
				_gerenciaTelas.callTela(caminhoModulo, nmTela);
			} else {
				_tabNavigator.selectedChild = container;
			}
		}
		
		private function openTelaHandler(event:HtGerenciaTelaEvent):void {
			if (param && event.tela is HtForm) {
				HtForm(event.tela).passaParametro("paramTela", param);
			}
			_tabNavigator.addChild(event.tela);
			_tabNavigator.selectedChild = INavigatorContent(event.tela);			
		}
			
		
	}
}