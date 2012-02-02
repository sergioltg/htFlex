package br.com.htecon.controls.consulta
{
	import br.com.htecon.controller.HtDbController;
	import br.com.htecon.controller.events.HtControllerCallBackEvent;
	import br.com.htecon.controls.HtButtonBar;
	import br.com.htecon.controls.HtForm;
	import br.com.htecon.controls.cadastro.HtCadastroBasico;
	import br.com.htecon.controls.events.HtButtonBarClickEvent;
	import br.com.htecon.data.HtEntity;
	import br.com.htecon.security.HtAuthorization;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.core.ContextualClassFactory;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.HistoryManager;
	import mx.managers.IHistoryManagerClient;
	
	/**
	 *  Classe básica de consulta, podendo ser usada num htcampoconsulta ou independente 
	 *  
	 */
	
	[Event(name="itemSelected", type="HtConsultaGridSelectedEvent")]
	public class HtConsultaBasica extends HtForm implements IHistoryManagerClient
	{		
		[Bindable]
		public var dataGridConsulta:DataGrid;
		
		public var buttonBar:HtButtonBar;
		
		public var containerPrincipal:Container;
		
		private var _controller:HtDbController;
		
		private var _telaCadastro: HtCadastroBasico;
		
		private var _classFactoryTelaCadastro: ClassFactory;
		
	    public var filter:HtEntity;
		
		private var _estadoSelecionar: Boolean;
		
		private var _estadoEditar: Boolean;		
		
		private var _abrirConsultando: Boolean;
		
		public var alterando: Boolean;
		
		public var focusInicial: Object;
		
		private var _lastFormCadastro: HtForm;
		
		public function HtConsultaBasica()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void {
			HistoryManager.register(this);
			
			if (focusInicial != null) {
			  focusInicial.setFocus();
			}
			
			BindingUtils.bindSetter(bindSelectedIndex, dataGridConsulta, "selectedIndex");
			
			iniciaTela();
			
			if (HtAuthorization.instance.active && !HtAuthorization.instance.isInRole(this.className, HtAuthorization.ROLE_SAVE)) {
				buttonBar.removeButton(HtButtonBar.NEW_BUTTON);			
			}
			
		}
		
		protected function iniciaTela():void {
			
		}		
		
		public function iniciaEstadoSelecionar():void {
			buttonBar.addButton(HtButtonBar.SELECT_BUTTON);
			buttonBar.addButton(HtButtonBar.CLOSE_BUTTON, -1);			
		}

		public function iniciaEstadoEditar():void {
			buttonBar.addButton(HtButtonBar.NEW_BUTTON, -1);
			buttonBar.addButton(HtButtonBar.EDIT_BUTTON, -1);
			
			incluiColunaEditar();
		}
		
		protected function incluiColunaEditar():void {
			var columnsTemp:ArrayCollection=new ArrayCollection(dataGridConsulta.columns);
			var columnEditar:DataGridColumn=new DataGridColumn("editar");
			columnEditar.headerText="";
			columnEditar.width=20;
			columnEditar.editable=false;
			columnEditar.sortable=false;
			var classFactory: ContextualClassFactory = new ContextualClassFactory(ImageEditarGrid);
			// parou de funcionar na versao release 4.0
// 		    classFactory.properties = {clickFunction:colunaEditarClickHandler};
			columnEditar.itemRenderer = classFactory;
			
			addEventListener("CLICKEDBUTTONEDITAR", clickButtonEditarHandler);
			
			columnsTemp.addItem(columnEditar);
			
			dataGridConsulta.columns = columnsTemp.toArray();			
		}
		
		private function clickButtonEditarHandler(event:Event):void {
			editarInterno();
			event.stopPropagation();
		}
		
//		private function colunaEditarClickHandler(event:Event):void {
//			editarInterno();
//		}
		
	
		private function bindSelectedIndex(index:int):void {
			buttonBar.enableButton(HtButtonBar.SELECT_BUTTON, index != -1);
			buttonBar.enableButton(HtButtonBar.EDIT_BUTTON, index != -1);	
			
		}		
		
		private function buttonBarItemClick(event:HtButtonBarClickEvent):void {
			trataBotao(event.button);
		}
		
		protected function trataBotao(button: String):void {
			if (button == HtButtonBar.SELECT_BUTTON) {
				selecionar();
			} else if (button == HtButtonBar.FETCH_BUTTON) {
				consultarInterno();
			} else if (button == HtButtonBar.EDIT_BUTTON) {
				editarInterno();				
			} else if (button == HtButtonBar.NEW_BUTTON) {
				incluirInterno();
			} else if (button == HtButtonBar.CLEAR_BUTTON) {
				limpar();
			} else if (button == HtButtonBar.CLOSE_BUTTON) {				
				close();
			}
		}		
		
		protected function limpar():void {
			dataGridConsulta.dataProvider = null;
		}
		
		override protected function createChildren():void {
            super.createChildren();	
			
			buttonBar.addEventListener(HtButtonBarClickEvent.BUTTON_CLICKED, buttonBarItemClick, false, 0, true);
			
			if (_abrirConsultando) {
				consultarInterno();
			}
			
			if (_estadoEditar) {
				iniciaEstadoEditar();
			}			
			
			if (_estadoSelecionar) {
				iniciaEstadoSelecionar();
			}
			
			dataGridConsulta.doubleClickEnabled = true;	
			dataGridConsulta.addEventListener(MouseEvent.DOUBLE_CLICK, griddbclick, false, 0, true);			
  		}		
		
		private function griddbclick(event:MouseEvent):void {
			if (dataGridConsulta.selectedIndex != -1) {
				if (_estadoSelecionar) {
					selecionar();
				} else if (_estadoEditar) {
					editarInterno();
				}
			}
		}
		
		protected function selecionar():void {
			var object:Object;
			
			if( dataGridConsulta.allowMultipleSelection ){
				object = dataGridConsulta.selectedItems;
			}else{
				object = dataGridConsulta.selectedItem;
			}
			
			dispatchEvent(new HtConsultaGridSelectedEvent(HtConsultaGridSelectedEvent.ITEM_SELECTED, object));
			close();			
		}
		
		private function removeForm(event:CloseEvent):void {
			close();
		}		
  		
  		public function setData(data:ArrayCollection):void {
  			if (data != null) {
				processData(data);
				_abrirConsultando = false;
	  		}
  		}
		
		protected function antesConsultar():Boolean {
			return true;
		}
  		
  		public function consultarInterno():void {
			if (antesConsultar()) {
				prepareFilter(filter);				
				consultar();
			}
		}
		
		public function consultar():void {			
			controller.startProcessando();			
			controller.find(filter);
		}
		
		
		protected function prepareFilter(obj: HtEntity):void {
			
		}
		
		protected function antesIncluir():Boolean {
			return true;
		}
		
		public function registroSalvo(entity: HtEntity):void {
			if (alterando) {
				var lista:ArrayCollection = ArrayCollection(dataGridConsulta.dataProvider);
				var nIndiceChange:int = -1;
				for (var n:int = 0; n < lista.length; n++) {
					var entity2:HtEntity = HtEntity(lista.getItemAt(n));
					if (entity2.getId() == entity.getId()) {
						nIndiceChange = n;
						break;
					}
				}
				if (nIndiceChange != -1) {
					lista.setItemAt(entity, nIndiceChange);
				}
			}
		}
		
		protected function incluirInterno():void {
			alterando = false;
			if (antesIncluir()) {
				incluir();
			}
		}
		
		protected function incluir():void {
			getTelaCadastro().passaParametro("registro", null);
			showTelaCadastro(getTelaCadastro());
		}
		
		protected function chamaTelaPassandoEntity(entity:HtEntity):void {
			getTelaCadastro().passaParametro("registro", entity);
			showTelaCadastro(getTelaCadastro());			
		}
		
		protected function antesEditar():Boolean {
			return true;
		}		
		
		public function editarInterno():void {
			if (antesEditar()) {
				alterando = true;
				editar();
			}
		}
		
		protected function editar():void {
			getTelaCadastro().passaParametro("registro", dataGridConsulta.selectedItem);			
			showTelaCadastro(getTelaCadastro());			
		}

 		
		protected function processData(data:ArrayCollection):void {
			controller.data = data;
			dataGridConsulta.dataProvider = data;
		}
		
		public function showTelaCadastro(form: HtForm):void {
			
			_lastFormCadastro = form;
			
			var nAchou:int = -1;			
			for (var n:int = 0; n < numChildren; n++) {
				if (UIComponent(getChildAt(n)).className == form.className) {
					getChildAt(n).visible = true;
					UIComponent(getChildAt(n)).includeInLayout = true;
					nAchou = n;
				} else {
					getChildAt(n).visible = false;
					UIComponent(getChildAt(n)).includeInLayout = false;
				}
			}			
			if (nAchou == -1) {
				addChild(form);
			}
			
			HistoryManager.save();
		}	
		
		public function showTelaConsulta():void {
			for (var n:int = 0; n < numChildren; n++) {
				if (getChildAt(n) == containerPrincipal) {
					getChildAt(n).visible = true;
					UIComponent(getChildAt(n)).includeInLayout = true;
				} else {
					getChildAt(n).visible = false;
					UIComponent(getChildAt(n)).includeInLayout = false;
				}
			}
			HistoryManager.save();
		}		
		
		
		[Bindable(event="changeController")]		
		public function get controller():HtDbController {
			return _controller;        	
		}
		
		public function set controller(value:HtDbController):void {
			_controller = value;
			
			_controller.addEventListener(HtControllerCallBackEvent.CALLBACK, controllerHandler, false, 0, true);
			
			filter = _controller.getNewEntity();
			
			dispatchEvent(new Event("changeController"));
		}
		
		protected function controllerHandler(event:HtControllerCallBackEvent):void
		{
			if (event.action == HtDbController.ACTION_FIND) {
				processData(controller.data);
			}
		}
		
		public function set telaCadastro(tela:Class): void {
			_classFactoryTelaCadastro = new ClassFactory(tela);
		}
		
		protected function getTelaCadastro():HtCadastroBasico {
			if (_telaCadastro == null) {
				_telaCadastro = _classFactoryTelaCadastro.newInstance();					
			}
			_telaCadastro.percentHeight = 100;
			_telaCadastro.percentWidth = 100;
			return _telaCadastro;
		}

		public function get estadoSelecionar():Boolean
		{
			return _estadoSelecionar;
		}

		public function set estadoSelecionar(value:Boolean):void
		{
			_estadoSelecionar = value;
		}

		public function get estadoEditar():Boolean
		{
			return _estadoEditar;
		}

		public function set estadoEditar(value:Boolean):void
		{
			_estadoEditar = value;
		}

		public function get abrirConsultando():Boolean
		{
			return _abrirConsultando;
		}

		public function set abrirConsultando(value:Boolean):void
		{
			_abrirConsultando = value;
		}
		
		public function saveState():Object {
			if (!containerPrincipal.visible) {
				return {cadastro:true};
			} else {
				return null;
			}
		}
		
		public function loadState(state:Object):void {
			if (state == null) {
				showTelaConsulta();
			} else if (state.cadastro) {
				if (_lastFormCadastro != null) {
					_lastFormCadastro.visible = true;
					containerPrincipal.visible = false;
				}
			}
		}
		
		override public function closed():void {
			super.closed();
			
			if (_lastFormCadastro) {
				_lastFormCadastro.closed();
			}
			
			HistoryManager.unregister(this);			
		}
				
	}
}
