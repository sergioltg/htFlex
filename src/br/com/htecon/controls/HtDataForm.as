package br.com.htecon.controls
{
	import br.com.htecon.controls.consulta.HtCampoConsulta;
	import br.com.htecon.events.HtDataFormFieldChanged;
	import br.com.htecon.validators.IValidator;
	
	import com.farata.controls.DataForm;
	import com.farata.controls.dataFormClasses.DataFormItem;
	import com.farata.controls.dataFormClasses.DataFormItemEditor;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	
	use namespace mx_internal;
	
	/**
	 *  Classe de form, com funcoes especificas de validacao, focus. 
	 * Eventos: fieldChanged é disparado quando algum input dentro do form é alterado, para isso 
	 * é usado focus_in e focus_out e disparado caso o valor foi alterado
	 *  
	 */	

	[Event(name="fieldChanged", type="br.com.htecon.events.HtDataFormFieldChanged")]	
	public class HtDataForm extends DataForm implements IDataForm
	{
		protected var items:Array=new Array();
		
		public var lastValidators:Array;
		
		private var _lastFocus: DisplayObject;	
		
		public function HtDataForm()
		{
			super();
			
//			mx_internal::layoutObject=new TileLayout();
//			mx_internal::layoutObject.target=this;

//			invalidateDisplayList();
			
			addEventListener(FocusEvent.FOCUS_IN, focusInHandlerForm, false, 0, true);
			addEventListener(FocusEvent.FOCUS_OUT, focusOutHandlerForm, false, 0, true);			
		}
		
		/**
		 *  Ao sair do campo guarda o ultimo focus e o valor para ser verificado no focus_in
		 *  Caso o item seja um combobox adiciona um evento para quando selecionar o 
		 * combo ja execute o evento fieldChanged ao inves de disparar somente na saida do campo  
		 */
		private function focusInHandlerForm(event:FocusEvent):void {
			_lastFocus = null;
			var focusItem : DisplayObject = DisplayObject(focusManager.getFocus());
			if (focusItem && focusItem.parent is HtDataFormItem && focusItem) {
				var dataFormItem: HtDataFormItem = HtDataFormItem(focusItem.parent);
				if (dataFormItem.data) {
					dataFormItem.lastValue = dataFormItem.data[dataFormItem.dataField];
					
					_lastFocus = focusItem;
					
					if (DataFormItemEditor(dataFormItem.itemEditor).dataSourceObject is ComboBox) {
						dataFormItem.addEventListener("dataChanged", dataFormItemDatachangedHandler, false, 0, true);
					}
				}
			}		
		}
		
		private function dataFormItemDatachangedHandler(event:Event):void {
			focusOutHandlerForm(event);
		}		
		
		/**
		 *  Compara com o valor obitido no focus_in, caso seja alterado dispara o vento fieldChanged
		 *  
		 */
		private function focusOutHandlerForm(event:Event):void {
			if (_lastFocus) {			
				var dataFormItem: HtDataFormItem = HtDataFormItem(_lastFocus.parent);
				if (DataFormItemEditor(dataFormItem.itemEditor).dataSourceObject is ComboBox && event is FocusEvent) {
					dataFormItem.removeEventListener("dataChanged", dataFormItemDatachangedHandler, false);
				}				
				if (dataFormItem.lastValue != dataFormItem.data[dataFormItem.dataField]) {
					dataFormItem.lastValue = dataFormItem.data[dataFormItem.dataField];
					dispatchEvent(new HtDataFormFieldChanged(HtDataFormFieldChanged.FIELD_CHANGED, dataFormItem));
				}
			}	
		}		

		override protected function createChildren():void
		{
			super.createChildren();
			enumerateChildren(this);
		}

		private function enumerateChildren(parent:Object):void
		{
			// Se for HtCampoConsulta, insere evento para depois disparar os fieldChange
			if (parent is HtCampoConsulta)
			{
				DataFormItem(parent.parent).addEventListener("dataChanged", dataChanged, false, 0, true);				
			} else if (parent is HtDataFormItem) {
				items.push(parent);				
			}

			if (parent is Container)
			{
				var children:Array=parent.getChildren();
				for (var i:int=0; i < children.length; i++)
				{
					enumerateChildren(children[i]);
				}
			}
		}
		
		private function dataChanged(event:Event):void {
			dispatchEvent(new HtDataFormFieldChanged(HtDataFormFieldChanged.FIELD_CHANGED, event.target as HtDataFormItem));
		}

		public function isEmpty():Boolean {
			var isempty:Boolean = true;
			for (var i:int=0; i<items.length; i++)	{
				if (DataFormItem(items[i]).data != "") {
					isempty = false;
					break;
				}
  			}
  			
  			return isempty;			
		}		
		
		public function getDataProviderItem():Object {
			return ArrayCollection(dataProvider).getItemAt(0);
		}
		
		public function clear():void {
			for (var i:int=0; i<items.length; i++)	{
				var item:DataFormItemEditor = DataFormItem(items[i]).itemEditor as DataFormItemEditor;
				if (item.dataSourceObject is DateField) {
					item.data = null;
					if (DataFormItem(items[i]).dataField != null) {
						DataFormItem(items[i]).data[DataFormItem(items[i]).dataField] = null;
					} else {
						DateField(item.dataSourceObject).data = null;
					}
				} else {
					if (item.dataSourceObject is HtCampoConsulta) {
						HtCampoConsulta(item.dataSourceObject).clear();
					}
					item.data = null;
					if (DataFormItem(items[i]).dataField != null) {
						DataFormItem(items[i]).data[DataFormItem(items[i]).dataField] = null;
					}					
				}
  			}
		}
		
		public function isValid():Boolean {
			lastValidators = validateAll();
			return lastValidators.length == 0;
		}
		
		public function getErrors():String {
			var result:String = "";
			for (var x:int; x < lastValidators.length; x++) {
				var v : ValidationResultEvent = lastValidators[x];
				if (v.currentTarget is IValidator) {
					if (result != "") {
						result+="\n";
					}
					result+= IValidator(v.currentTarget).title + ": " + v.message;
				}
			}
			
			return result;
		}
		
		/**
		 *  Seta o focus no primeiro item com erro
		 *  
		 */
		public function focusFirstInvalid():void {
			if (lastValidators && lastValidators.length > 0) {
				var v : ValidationResultEvent = lastValidators[0];
				UIComponent(Validator(v.currentTarget).source).setFocus();
			}			
		}
		
		override public function validateAll(suppressEvents:Boolean=false):Array {
				var _validators :Array = validators;
				var result:Array = [];
				for (var i:int=0; i < _validators.length;i++) {
						if ( _validators[i].enabled ) {
							var v : * = _validators[i].validate();
							if ( v.type != ValidationResultEvent.VALID)
								result.push( v );
							}
					}
				return result;
		}		
		
		override public function set dataProvider(value:Object):void {
			if (value == null) {
				clear();
			}
			super.dataProvider = value;
		}
		
		/**
		 *  Seta focus no primeiro item do form que nao seja readonly
		 *  
		 */
		override public function setFocus():void {
			for (var n:int = 0; n < items.length; n++) {
				if (!DataFormItem(items[n]).readOnly && DataFormItem(items[n]).enabled) {		
					var item:DataFormItemEditor = DataFormItem(items[n]).itemEditor as DataFormItemEditor;
					item.dataSourceObject.setFocus();
					break;
				}
			}
		}
		
	}
}