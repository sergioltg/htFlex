package br.com.htecon.controls.cadastro
{
	import br.com.htecon.controls.HtButtonBar;
	import br.com.htecon.controls.HtForm;
	import br.com.htecon.controls.IDataForm;
	import br.com.htecon.controls.events.HtButtonBarClickEvent;
	import br.com.htecon.controls.events.HtDialogEvent;
	import br.com.htecon.data.HtEntity;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	[Event(name="DIALOG_OK", type="br.com.htecon.controls.events.HtDialogEvent")]	
	public class HtCadastroDialog extends HtForm
	{
		
		public var buttonBar: HtButtonBar;
		
		private var hasCreated: Boolean = false;
		
		private var _entity:HtEntity;
		
		public function HtCadastroDialog() {

			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			
	    }
	
		private function creationCompleteHandler(event:FlexEvent):void{
			buttonBar.addEventListener(HtButtonBarClickEvent.BUTTON_CLICKED, buttonBarClickedHandler);
			
			if (!hasCreated) {
				hasCreated = true;
				iniciaTelaInterno();
			}
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			buttonBar.buttons = [HtButtonBar.SAVE_BUTTON, HtButtonBar.CLOSE_BUTTON];
		}
		
		protected function iniciaTelaInterno():void {			
			if (hasCreated) {
				iniciaTela();
			}
		}
		
		public function showErrosForm(dataForm:IDataForm):void {
			Alert.show(resourceManager.getString("resourcesHtFlex", "errosnoForm") + "\n\n" + dataForm.getErrors(), "Aviso", Alert.OK, null, function():void {dataForm.focusFirstInvalid();});
		}		
		
		protected function iniciaTela():void {
			
		}
		
		[Bindable(event="changeEntity")]
		public function set entity(value:HtEntity):void {
			this._entity = value;
			
			dispatchEvent(new Event("changeEntity"));
			
			iniciaTelaInterno();
		}
		
		public function get entity():HtEntity {
			return this._entity;
		}
		
		protected function antesSalvar():Boolean {
			return true;
		}
		
		protected function salvarInterno():void {
			if (antesSalvar()) {
				salvar();
			}
		}
		
		protected function salvar():void {
			dispatchEvent(new HtDialogEvent(HtDialogEvent.DIALOG_OK, entity));
			close();
		}
			
		protected function buttonBarClickedHandler(event:HtButtonBarClickEvent):void
		{
			if (event.button == HtButtonBar.SAVE_BUTTON) {
				salvarInterno();
			} else if (event.button == HtButtonBar.CLOSE_BUTTON) {
				close();
			}
		}		
		
	}
}