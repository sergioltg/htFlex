package br.com.htecon.controls
{
	import br.com.htecon.controls.consulta.HtCampoConsulta;
	import br.com.htecon.controls.events.HtCampoConsultaEvent;
	import br.com.htecon.validators.HtValidator;
	
	import com.farata.controls.dataFormClasses.DataFormItem;
	import com.farata.controls.dataFormClasses.DataFormItemEditor;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	[Event(name="dataChanged", type="flash.events.Event")]
	public class HtDataFormItem extends DataFormItem
	{
		
		
		public var lastValue: String;
		private var _resourceName: String;
		private var _resourceBundle: String = "resources";
		private var _requiredValidator:Boolean;
		private var requiredValidatorChanged:Boolean;
		
		private var _requiredMessage:String;
		private var requiredMessageChanged:Boolean;
		
		private var validatorRequired:HtValidator;
		
		public function HtDataFormItem() {
			super();
			_breakLine = true;
		}

		override protected function createChildren():void
		{
			super.createChildren();
			if (this.getChildren().length > 0)
			{
				itemEditor.addEventListener(Event.CHANGE, dataChangeHandler, false, 0, true);
				itemEditor.addEventListener(FlexEvent.VALUE_COMMIT, dataChangeHandler, false, 0, true);

//				var child:DisplayObject=this.getChildAt(0);
// TODO fazer focusIn no consulta
//				if (child is HtCampoConsulta)
//				{
//					child.addEventListener(HtCampoConsultaEvent.ITEMSELECTED, itemSelectedHandler, false, 0, true);
//				}
//				else 
//				if (this.getChildAt(0) is UIComponent)
//				{
//					child.addEventListener(FocusEvent.FOCUS_IN, focusInHandlerChild, false, 0, true);

//				}
			}

		}

		private function dataChangeHandler(evt:Event):void
		{
			if (evt.target["data"] !== undefined)
			{
				dispatchEvent(new Event("dataChanged"));
			}
		}

		private function focusInHandlerChild(evt:Event):void
		{
			dispatchEvent(new Event("focusIn"));
		}
		
		private function itemSelectedHandler(evt:HtCampoConsultaEvent):void
		{
			dispatchEvent(new Event("focusChanged"));
		}
		
		private var _breakLine:Boolean;
		
		public function set breakLine(value:Boolean):void {
			_breakLine = value;			
		}
		
		public function get breakLine():Boolean {
			return _breakLine;
		}		
		
		override public function set data(value:Object):void {
			if (dataField != null) {
				// Trata nestedFields
				if (dataField.indexOf(".") != -1) {
					var fields:Array = dataField.split(".");
					for each(var f:String in fields){
						value = value[f];
						if (value == null) {
							break;
						}
					}
				}
				
				var item:DataFormItemEditor = itemEditor as DataFormItemEditor;
				if (item.dataSourceObject is HtCampoConsulta) {
					HtCampoConsulta(item.dataSourceObject).data = value;
				}				
				
				super.data = value;			
			}		
		}
		
		

		public function get resourceBundle():String
		{
			return _resourceBundle;
		}

		public function set resourceBundle(value:String):void
		{
			_resourceBundle = value;
		}

		public function get resourceName():String
		{
			return _resourceName;
		}

		public function set resourceName(value:String):void
		{
			_resourceName = value;
			this.label = resourceManager.getString(_resourceBundle, _resourceName) + ":";
		}

		public function get requiredValidator():Boolean
		{
			return _requiredValidator;
		}

		public function set requiredValidator(value:Boolean):void
		{
			requiredValidatorChanged = true;
			_requiredValidator = value;
			invalidateProperties();
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (requiredValidatorChanged || requiredMessageChanged) {
				requiredValidatorChanged  = false;
				requiredMessageChanged = false;
				if (!validatorRequired) {
					validatorRequired = new HtValidator();
					validators = [validatorRequired];
				}
				validatorRequired.required = requiredValidator;
				validatorRequired.title = requiredMessage;
			}
			
		}

		public function get requiredMessage():String
		{
			return _requiredMessage;
		}

		public function set requiredMessage(value:String):void
		{
			_requiredMessage = value;
			requiredMessageChanged = true;
		}


	}
}