package br.com.htecon.controls.consulta
{
	import br.com.htecon.controls.HtButtonBar;
	import br.com.htecon.controls.HtDataForm;
	import br.com.htecon.controls.HtDataFormItem;
	import br.com.htecon.controls.HtDataGridColumn;
	import br.com.htecon.controls.HtDataGridColumnDate;
	import br.com.htecon.controls.HtDataGridColumnDateTime;
	import br.com.htecon.controls.HtDataGridColumnNumber;
	import br.com.htecon.controls.collapsepanel.CollapseFilterPanel;
	import br.com.htecon.controls.events.HtButtonBarClickEvent;
	import br.com.htecon.skin.RodapeGrid;
	import br.com.htecon.util.Processando;
	
	import flash.events.KeyboardEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.Spacer;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.TextInput;
	
	use namespace mx_internal;
	

	/**
	 *  Classe de consulta em que cria os componentes, podendo ser herdada e adicionado as colunas da grid
	 *  
	 */
		
	
	public class HtConsultaGrid extends HtConsultaBasica
	{		
		protected var panelFilter:CollapseFilterPanel;
		
		protected var formFilter:HtDataForm;
		
		private var processando:Processando;
		
		private var labelCount:Label;

		private var spacer:Spacer;
		
		private var columnsAdd:Array;
		
		private var montarTituloPelasColunas:Boolean;
		
		public function HtConsultaGrid()
		{
			super();
			
			
			percentHeight = 100;
			width = 500;
			
			panelFilter = new CollapseFilterPanel();
			panelFilter.open();
			panelFilter.addEventListener(KeyboardEvent.KEY_DOWN, 
				function(event:KeyboardEvent):void {if (event.keyCode == 13) {consultarInterno()}});
			panelFilter.addEventListener(HtButtonBarClickEvent.BUTTON_CLICKED, 
				function(event: HtButtonBarClickEvent):void {trataBotao(event.button)});
			
			panelFilter.visible = false;
			panelFilter.percentWidth = 100;
			panelFilter.setStyle("paddingBottom", "6");
			
			spacer = new Spacer();
			spacer.height = 6;
			
			containerPrincipal = new VBox();
			containerPrincipal.setStyle("verticalGap", "0");
			containerPrincipal.percentWidth = 100;
			containerPrincipal.percentHeight = 100;
			containerPrincipal.setStyle("paddingLeft", "6");
			containerPrincipal.setStyle("paddingRight", "6");
			containerPrincipal.setStyle("paddingTop", "6");
			containerPrincipal.setStyle("paddingBottom", "6");
			containerPrincipal.horizontalScrollPolicy = "off";
			containerPrincipal.verticalScrollPolicy = "off";
			
			dataGridConsulta = new DataGrid();
			
			dataGridConsulta.percentHeight = 100;
			dataGridConsulta.percentWidth = 100;
			
			labelCount = new Label();
			labelCount.percentWidth = 100;
			labelCount.setStyle("paddingTop", "9");
			labelCount.setStyle("paddingRight", "10");
			labelCount.setStyle("color", "#363636");
			labelCount.setStyle("textAlign", "right");
			
			BindingUtils.bindSetter(changedDataProvider, dataGridConsulta, "dataProvider");
			
			buttonBar = new HtButtonBar();
			buttonBar.setStyle("paddingTop", -1);
			buttonBar.setStyle("paddingBottom", 0);
			buttonBar.buttons = [];
		}
		
		private function changedDataProvider(value:Object):void {
			if (value != null) {
				labelCount.text = "Total de registros: " + value.length;
			} else {
				labelCount.text = "Total de registros: 0";
			}
		}
		
		override protected function createChildren():void {
            super.createChildren();
			
			if (columnsAdd != null) {
				dataGridConsulta.columns = columnsAdd;
			}
			
			if (montarTituloPelasColunas) {
				montaFiltroPelasColunasInterno();
			}
            
			containerPrincipal.addChild(panelFilter);
			containerPrincipal.addChild(spacer);
			containerPrincipal.addChild(dataGridConsulta);
			
			var rodape:SkinnableContainer = new SkinnableContainer();
			rodape.percentWidth = 100;
			rodape.addElement(buttonBar);
			rodape.addElement(labelCount);
			rodape.setStyle("skinClass", RodapeGrid);
			containerPrincipal.addChild(rodape);
            
            addChild(containerPrincipal);
  		}
		
		override protected function limpar():void {
			super.limpar();
			if (formFilter != null) {
				formFilter.clear();
				formFilter.setFocus();
			}
		}
		
		private function montaFiltroPelasColunasInterno():void {
			formFilter = new HtDataForm();
			formFilter.percentHeight = 100;
			formFilter.percentWidth = 100;
			
			var sumHeight:int = 0;
			
			for (var n:int; n < dataGridConsulta.columnCount; n++) {
				var dg:DataGridColumn = DataGridColumn(dataGridConsulta.columns[n]);				
				
				var dataFormItem:HtDataFormItem = new HtDataFormItem();
				
				dataFormItem.percentHeight = 20;
				dataFormItem.percentWidth = 100;
				dataFormItem.label = dg.headerText + ":";
				var textInput: TextInput = new TextInput();
				if (dg.mx_internal::explicitWidth) {
					textInput.width = dg.width;					
				} else {
					textInput.percentWidth = 100;
				}
				dataFormItem.addChild(textInput);
				dataFormItem.dataField = dg.dataField;
				formFilter.addChild(dataFormItem);
				
				sumHeight+= 26;
			}
			
			formFilter.dataProvider = filter;
			
			panelFilter.addElement(formFilter);
			
			//panelFilter.height = sumHeight + 40;
			panelFilter.visible = true;
		}
		
		protected function montaFiltroPelasColunas():void {
			if (columnsAdd != null) {
				montarTituloPelasColunas = true;
				return;
			}
			montaFiltroPelasColunasInterno();			
		}
		
		
		protected function addColumn(field:String, headerText:String, classdg:Class = null):DataGridColumn {
			if (classdg == null) {
				classdg = DataGridColumn;				
			}
			var dg:DataGridColumn = new classdg(field);
			dg.headerText = headerText;
			
			if (columnsAdd == null) {
				columnsAdd = new Array();
			}
			
			columnsAdd.push(dg);
			
			return dg;
		}
		
		protected function addHtColumn(field:String, headerText:String):DataGridColumn {
			return addColumn(field, headerText, HtDataGridColumn);
		}
		
		protected function addHtColumnDate(field:String, headerText:String):DataGridColumn {
			return addColumn(field, headerText, HtDataGridColumnDate);
		}
		
		protected function addHtColumnDateTime(field:String, headerText:String):DataGridColumn {
			return addColumn(field, headerText, HtDataGridColumnDateTime);
		}
		
		protected function addHtColumnNumber(field:String, headerText:String):DataGridColumn {
			return addColumn(field, headerText, HtDataGridColumnNumber);
		}
		
		protected function setFormFilter(visualelement:IVisualElement):void {
			panelFilter.visible = true;
			panelFilter.addElement(visualelement);			
		}
		
		
	}

}
