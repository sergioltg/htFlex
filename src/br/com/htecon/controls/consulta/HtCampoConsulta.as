package br.com.htecon.controls.consulta
{
	import br.com.htecon.controls.HtDataForm;
	import br.com.htecon.controls.events.HtCampoConsultaEvent;
	import br.com.htecon.delegate.BasicDelegate;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.TextInput;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.FocusManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.Swiz;
	
	import spark.components.Button;

	
	use namespace mx_internal;
	
	/**
	 *  Classe do htCampoConsulta, tendo varios campos e acessando uma tela de busca
	 *  
	 */
	
	[Event(name="itemSelected", type="br.com.htecon.controls.events.HtCampoConsultaEvent")]
	[Event(name="itemCleared", type="br.com.htecon.controls.events.HtCampoConsultaEvent")]	
	public class HtCampoConsulta extends UIComponent 	
	{
		private var _items:ArrayCollection = new ArrayCollection();
		private var _fieldPK:HtCampoConsultaItem;
		private var _basicDelegate:BasicDelegate;
		private var _classFactoryfilter:ClassFactory;
		
		private var _showOnlyPK:Boolean;
		
		private var _consultaGrid:Class;
		
		private var _consultaEditarHabilitado: Boolean;
		
		private var _propertyCache: String;
		
		private var _data: Object;
		
		private var _readOnly: Boolean;
		
		[Bindable]
		private var _objectSelected:Object;
		
		private var _hbox:HBox;
		
		private var buttonSearch:Button;
		
		// Desabilita procurar nextfocus, a princípio usado no findByPk
		public var disableNextFocus:Boolean;
		
		[Embed(source="/assets/search.png")]
		[Bindable]
		private static var imageSearch:Class;		
		
		// Desabilita os eventos do focus quando um campo eh emitido focusout
		private var desabilitaFocusEvents: Boolean;
		
		public function HtCampoConsulta()
		{
			super();
			
			this.percentWidth = 100;
			this.height = 23;
			
			_showOnlyPK = false;
			
		}
		
		/**
		 *  Cria os campos na tela de acordo com o array de htcampoconsultaitem informado 
		 *  
		 */
		override protected function createChildren():void
        {
            super.createChildren();
            
            _hbox = new HBox();
            
	        for (var i:int = 0; i < _items.length; i++) {
				var item: HtCampoConsultaItem = HtCampoConsultaItem(_items.getItemAt(i));
	        	if (_showOnlyPK && item != fieldPK) {
	        		continue;
	        	}
	        	_hbox.addChild(item.item);
				if (item.item is TextInput) {
					TextInput(item.item).editable = !_readOnly;
				}
				if (!item.visible) {
					item.item.visible = false;
					item.item.includeInLayout = false;
				}
	        }
	        
	        buttonSearch = new Button();
			buttonSearch.styleName = "botaoBusca";
	        buttonSearch.height = 23;
	        buttonSearch.width = 23;
			buttonSearch.enabled = !_readOnly;
			buttonSearch.useHandCursor = true;
			buttonSearch.buttonMode = true;
			
	        buttonSearch.addEventListener(MouseEvent.CLICK, buttonSearchclick, false, 0, true);
	        
	        _hbox.addChild(buttonSearch);
            
            addChild(_hbox);
            
        }
        
        private function buttonSearchclick(event:MouseEvent):void {
        	openConsulta(null);        	
        }
        
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            _hbox.width = unscaledWidth;
            _hbox.height = unscaledHeight;
        }
        
		override protected function measure():void 
        {
            super.measure();
            this.measuredWidth = 160;
            this.measuredHeight = _hbox.height;
        }
        
        protected function addField(field:HtCampoConsultaItem):void {
        	_items.addItem(field);
			field.item.setStyle("borderColor", "#B0B0B0");

			field.item.addEventListener(FocusEvent.FOCUS_IN, textInput_focusinHandler, false, 0, true);
			field.item.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusoutHandler, false, 0, true);
        }
        
		private function textInput_focusinHandler(event:FocusEvent):void {
			if (desabilitaFocusEvents) 
				return;
			getEpCampoConsultaItem(event.currentTarget).lastValue = TextInput(event.currentTarget).text;
        }
        
		private function textInput_focusoutHandler(event:FocusEvent):void {
			if (desabilitaFocusEvents) return;
			var field:HtCampoConsultaItem = getEpCampoConsultaItem(event.currentTarget);
			var tinput:TextInput = TextInput(event.currentTarget);
			if (tinput.text == "" && field.lastValue != "") {
				clear();
			} else if (tinput.text != field.lastValue) {
				desabilitaFocusEvents = true;
				changeField(field);
				
				field.lastValue = tinput.text;
			}			
        }
        
        private function getEpCampoConsultaItem(value:Object):HtCampoConsultaItem {
	        for each (var field:HtCampoConsultaItem in _items) {
	        	if (field.item == value) {
	        		return HtCampoConsultaItem(field);
	        	} 
	        }
	        
	        return null;
        }
        
        
        public function get fieldPK():HtCampoConsultaItem {
        	return _fieldPK;        	
        }
        
        public function set fieldPK(value:HtCampoConsultaItem):void {
        	_fieldPK = value;
        }
        
		public function get basicDelegate():BasicDelegate {
        	return _basicDelegate;        	
        }
        
        public function set basicDelegate(value:BasicDelegate):void {
        	_basicDelegate = value;
        }
        
		public function get classFactoryfilter():ClassFactory {
        	return _classFactoryfilter;        	
        }
        
        public function set classFactoryfilter(value:ClassFactory):void {
        	_classFactoryfilter = value;
        }
        
   		public function get consultaGrid():Class {
        	return _consultaGrid;
        }
        
        public function set consultaGrid(value:Class):void {
        	_consultaGrid = value;
        }
        
        protected function changeField(field:HtCampoConsultaItem):void {
			
        	var filter:Object = _classFactoryfilter.newInstance();
        	
        	filter[field.fieldName] = TextInput(field.item).text;
        	
        	prepareEntity(filter); 
        	
        	find(filter);        	        	        	
        }
        
        protected function prepareEntity(value:Object):void {
        	
        }
		
		public function findByPk():void {
			disableNextFocus = true;
			changeField(fieldPK);
		}
        
        public function find(value:Object):void {
			
        	Swiz.executeServiceCall(basicDelegate.findAll(value), onFindAllResult);        
        }
        
		protected function onFindAllResult(re:ResultEvent):void
		{
			processData(ArrayCollection(re.result));
			
			desabilitaFocusEvents = false;    		
		}
		
		public function clearInternal():void {
			for each (var field:HtCampoConsultaItem in _items) {
				TextInput(field.item).text = null;
				
				if (_propertyCache && _data && _data[_propertyCache]) {
					_data[_propertyCache][field.fieldName] = TextInput(field.item).text;
				}				
				
			}			
		}		
	
		public function clear():void {			
			clearInternal();
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
			
			dispatchEvent(new HtCampoConsultaEvent(HtCampoConsultaEvent.ITEMCLEARED));			
		}
		
		protected function processData(data:ArrayCollection):void {
			if (data.length == 0) {
				var thiz:HtCampoConsulta = this;
				Alert.show("Registro nao encontrado", "Aviso", 4, null, function():void {thiz.setFocus();});				
				clear();
			} else if (data.length == 1) {
				setRecordInternal(data.getItemAt(0));
			} else {
				openConsulta(data);
			}
		}
		
		public function setRecord(value:Object):void {
			_objectSelected = value;
			if (_propertyCache && _data) {
				if (!_data[_propertyCache]) {
					_data[_propertyCache] = _classFactoryfilter.newInstance();
				}
			}			
			for each (var field:HtCampoConsultaItem in _items) {
				TextInput(field.item).text = value[field.fieldName];
				field.lastValue = value[field.fieldName];				
				
				if (_propertyCache && _data) {
					_data[_propertyCache][field.fieldName] = TextInput(field.item).text;
				}
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
		}
		
		
		protected function setRecordInternal(value:Object):void {
			setRecord(value);
			
			dispatchEvent(new HtCampoConsultaEvent(HtCampoConsultaEvent.ITEMSELECTED));
			
			if (!disableNextFocus) {
				callLater(function():void {nextFocusComponent();});
			} else {
				disableNextFocus = false;
			}
		}
		
		private function nextFocusComponent():void {
			var focusableObjects:Array = FocusManager(focusManager).mx_internal::focusableObjects; 
			for (var x:int = 0; x < focusableObjects.length; x++) {
				if (focusableObjects[x] == buttonSearch) {
					if ((x+1) < focusableObjects.length) {
						if (focusableObjects[x+1] is UIComponent) {
							UIComponent(focusableObjects[x+1]).setFocus();
						}
					}
				}
			}
		}
			
		/**
		 *  Abre tela de consulta passando os dados consultados
		 *  
		 */
		private function openConsulta(data:ArrayCollection):void {
			var consultaTitleWindow:TitleWindow = TitleWindow(PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, TitleWindow, true));
			consultaTitleWindow.showCloseButton = true;
			
			var consulta:HtConsultaBasica = new _consultaGrid();
			prepareConsultaGrid(consulta);
			consulta.estadoSelecionar = true;
			consulta.estadoEditar = consultaEditarHabilitado;
			consulta.addEventListener(HtConsultaGridSelectedEvent.ITEM_SELECTED, selectRecord, false, 0, true);			
			consulta.setData(data);
			
			consultaTitleWindow.width = consulta.width + 28;
			consultaTitleWindow.height = 500;
			consultaTitleWindow.addChild(consulta);
			consultaTitleWindow.title = consulta.label;
			
			consultaTitleWindow.addEventListener(CloseEvent.CLOSE, function():void {consulta.close();});

  			
  			PopUpManager.centerPopUp(consultaTitleWindow);
		}
		
		protected function prepareConsultaGrid(consulta:HtConsultaBasica):void {
			
		}
		
		private function selectRecord(event:HtConsultaGridSelectedEvent):void {
			setRecordInternal(event.item);
		}			
		
		public function set showOnlyPK(value:Boolean):void {
			this._showOnlyPK = value;
		}
		
		public function get showOnlyPK():Boolean {
			return this._showOnlyPK;
		}
		
		public function get text():String {
			return fieldPK.item["text"];
		}
		
		public function set text(value:String):void {
			if (value == "") {
				clear();
			} else {
				fieldPK.item["text"] = value;
			}				
		}
		
		override public function setFocus():void {
			super.setFocus();
			fieldPK.item.setFocus();
		}
		
		public function get objectSelected():Object {
			return _objectSelected;
		}

		public function get consultaEditarHabilitado():Boolean
		{
			return _consultaEditarHabilitado;
		}

		public function set consultaEditarHabilitado(value:Boolean):void
		{
			_consultaEditarHabilitado = value;
		}
		
		public function set data(obj:Object):void {
			_data = obj;
			if (_data[fieldPK.fieldName] == null) {
				clearInternal();
			} else {
				if (_propertyCache && _data[_propertyCache] != null) {
					for each (var field:HtCampoConsultaItem in _items) {
						if (field != fieldPK) {
							TextInput(field.item).text = _data[_propertyCache][field.fieldName];
						}
					}				
				}
			}
		}

		public function set objectSelected(value:Object):void
		{
			_objectSelected = value;
		}

		public function get propertyCache():String
		{
			return _propertyCache;
		}

		public function set propertyCache(value:String):void
		{
			_propertyCache = value;
		}

		public function get readOnly():Boolean
		{
			return _readOnly;
		}

		public function set readOnly(value:Boolean):void
		{
			_readOnly = value;
			
			for (var i:int = 0; i < _items.length; i++) {
				var item: HtCampoConsultaItem = HtCampoConsultaItem(_items.getItemAt(i));
				if (item.item is TextInput) {
					TextInput(item.item).editable = !_readOnly;
				}				
			}
			
			if (buttonSearch) {
				buttonSearch.enabled = !_readOnly;
			}
		}

		
	}
}