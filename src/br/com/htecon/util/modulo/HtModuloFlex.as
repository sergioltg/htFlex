package br.com.htecon.util.modulo
{
	import mx.core.UIComponent;
	import mx.modules.Module;
	
	/**
	 * Classe que extende o Module flex adicionando logica de
	 * busca de tela.
	 * 
	 * Sempre que utiliza-la setar a propriedade hashTelas.
	 * */
	public class HtModuloFlex extends Module{
		
		public var hashTelas:Object;
		
		public function HtModuloFlex(){}
		
		/**
		 * Retorna a tela que esta importada na application.
		 * */
		public function getTela(  nmTela:String ):UIComponent{
			// Caso não tenha sido setado o hashTelas faz trace comunicando
			if(hashTelas == null){
				trace( 'Propriedade hashTelas da classe ' + this.className + ' não foi setada!' );
				return null;
			}
			
			var c:Class = hashTelas[nmTela.toLowerCase()] as Class;
			return new c() as UIComponent;
		}
		
		public function init():void {
			
		}
		
	}
}