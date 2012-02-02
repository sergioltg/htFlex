package br.com.htecon.controls.cadastro
{
	import br.com.htecon.controller.HtDbController;
	import br.com.htecon.controller.events.HtControllerCallBackEvent;
	import br.com.htecon.controls.HtButtonBar;
	import br.com.htecon.controls.HtForm;
	import br.com.htecon.controls.consulta.HtConsultaBasica;
	import br.com.htecon.controls.events.HtButtonBarClickEvent;
	import br.com.htecon.security.HtAuthorization;
	import br.com.htecon.util.Util;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.swizframework.Swiz;
	
	/**
	 *  Classe de cadastro, fornecendo funcoes comuns para os cadastros
	 *  Apartir de um controller especificado nas telas filhas o componente consegue buscar os dados e salvar
	 *  
	 */
	public class HtCadastroBasico extends HtForm
	{
		public var buttonBar: HtButtonBar;
		
		private var hasCreated: Boolean = false;
		
		[Bindable]
		private var _controller:HtDbController;

		public function HtCadastroBasico()
		{
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);			
		}
		
		private function creationCompleteHandler(event:FlexEvent):void{
			if (buttonBar) {
				buttonBar.addEventListener(HtButtonBarClickEvent.BUTTON_CLICKED, buttonBarClickedHandler);
			}
			
			if (!hasCreated) {
				hasCreated = true;
				iniciaTelaInterno();
			}
			
			if (!HtAuthorization.instance.isInRole(getNameClassSecurity(), HtAuthorization.ROLE_SAVE)) {
				buttonBar.removeButton(HtButtonBar.SAVE_BUTTON);
				buttonBar.removeButton(HtButtonBar.NEW_BUTTON);				
			}
			
			if (!HtAuthorization.instance.isInRole(getNameClassSecurity(), HtAuthorization.ROLE_DELETE)) {
				buttonBar.removeButton(HtButtonBar.DELETE_BUTTON);			
			}			
			
		}
		
		protected function getNameClassSecurity():String {
			if (parent is HtConsultaBasica) {
				return HtConsultaBasica(parent).className;
			} else {
				return this.className;
			}
		}

		protected function controllerHandler(event:HtControllerCallBackEvent):void
		{
			if (event.action == HtDbController.ACTION_SAVE) {
				depoisSalvar();
			}
		}
		
		protected function depoisSalvar():void {
			
		}

		protected function buttonBarClickedHandler(event:HtButtonBarClickEvent):void
		{
			trataBotao(event.button);
		}
		
		protected function trataBotao(button: String):void {
			switch (button)
			{
				case HtButtonBar.SAVE_BUTTON:
					salvarInterno();
					break;
				case HtButtonBar.PRINT_BUTTON:
					imprimir();
					break;
				case HtButtonBar.CLEAR_BUTTON:
					limpar();
					break;				
			}			
		}

		protected function antesSalvar():Boolean
		{
			return true;
		}


		protected function salvarInterno():void
		{
			if (HtAuthorization.instance.active && !HtAuthorization.instance.isInRole(getNameClassSecurity(), HtAuthorization.ROLE_SAVE)) {
				Alert.show("Você não tem permissão para salvar");
				return;
			}
			
			
			if (antesSalvar())
			{
				salvar();	
			}
		}
		
		protected function salvar():void {
			controller.startProcessando();
			controller.save();			
		}
		
		protected function imprimir():void
		{
		}
		
		protected function limpar():void {
			
		}
		
		// A intencao do iniciaTelaInterno é ter um ponto quando a entidade ja esta carregada e pronta para editar o registro
		protected function iniciaTelaInterno():void {	
			if (hasCreated) {
				// Alguns combobox nao estavam se pintando de vermelho quando sao required,
				// Esse workaround tenta resolver isso
				var elements:Array = Util.getElementsContainer(this, UIComponent);
				for (var n:int = 0; n < elements.length; n++) {
					elements[n].errorString = elements[n].errorString; 
				}
				//
				callLater(function():void {iniciaTela()});
			}
		}		
		
		// Método que pode ser sobrescrito pelas classes filhas como um ponto para quando o registro estiver pronto para ser editado
		protected function iniciaTela():void {
						
		}

		[Bindable(event="changeController")]
		public function get controller():HtDbController {
			return this._controller;
		}		
		
		public function set controller(value:HtDbController):void {
			this._controller = value;
			_controller.addEventListener(HtControllerCallBackEvent.CALLBACK, controllerHandler, false, 0, true);
			dispatchEvent(new Event("changeController"));
		}		
		
	}
}