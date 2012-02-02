package br.com.htecon.util
{
	import br.com.htecon.controls.HtDataForm;
	import br.com.htecon.controls.IDataForm;
	import br.com.htecon.events.HtDataFormFieldChanged;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	/**
	 *  Classe para reunir vários forms e executar funcoes especificas tipo validacao
	 *  Pode se passar para a classe um container com os forms ou um array com os forms
	 * 
	 */
	
	[Event(name="fieldChanged", type="br.com.htecon.events.HtDataFormFieldChanged")]
	public class HtMultiDataFormValidate implements IEventDispatcher, IDataForm
	{
		
		public var forms:Array;
		private var _container:UIComponent;
		
		private var _lastFocus: DisplayObject;
		
		private var dispatcher:EventDispatcher;
		
		public function HtMultiDataFormValidate()
		{
			dispatcher = new EventDispatcher();
		}
		
		public function isValid():Boolean {
			var result:Boolean = true;
			
			for (var n:int = 0; n < getForms().length; n++) {
				var form:HtDataForm = getForms()[n] as HtDataForm;
				result = form.isValid() && result;
			}
			
			return result;
		}
		
		public function focusFirstInvalid():void {
			for (var n:int = 0; n < forms.length; n++) {
				var form:HtDataForm = forms[n] as HtDataForm;			
				if (form.lastValidators && form.lastValidators.length > 0) {
					form.focusFirstInvalid();
					break;
				}
			}
		}
		
		protected function getForms():Array {
			if (forms == null) {
				forms = Util.getElementsContainer(_container, HtDataForm);
			}
			return forms;
		}
		
		public function set container(objeto: UIComponent):void {
			this._container = objeto;
			
			if (this._container.initialized) {
				setEventsContainer(null);
			} else {
				this._container.addEventListener(FlexEvent.INITIALIZE, setEventsContainer, false, 0, true);
			}			
		}
		
		private function setEventsContainer(event:Event):void {
			for (var n:int = 0; n < getForms().length; n++) {
				var form:HtDataForm = getForms()[n] as HtDataForm;
				form.addEventListener(HtDataFormFieldChanged.FIELD_CHANGED, fieldChangedHandler, false, 0, true); 
			}			
		}
		
		private function fieldChangedHandler(event: HtDataFormFieldChanged):void {
			dispatchEvent(new HtDataFormFieldChanged(HtDataFormFieldChanged.FIELD_CHANGED, event.formItem));
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority);
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
		
		public function clear():void {
			for (var n:int = 0; n < getForms().length; n++) {
				var form:HtDataForm = getForms()[n] as HtDataForm;
				form.clear(); 
			}			
		}
		
		public function getErrors():String {
			var result:String = "";
			for (var n:int = 0; n < getForms().length; n++) {
				var form:HtDataForm = getForms()[n] as HtDataForm;
				var errors:String = form.getErrors();
				if (errors != "") {
					if (result != "") {
						result += "\n";
					}
					result += errors;
				}
			}
			return result;
		}
		
		public function setFocus():void {
			var form:HtDataForm = forms[0] as HtDataForm;
			form.setFocus();
		}
		
	}
}