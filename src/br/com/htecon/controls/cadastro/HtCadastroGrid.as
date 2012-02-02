package br.com.htecon.controls.cadastro
{
	import br.com.htecon.controls.HtButtonBar;
	import br.com.htecon.controls.HtDataGrid;
	import br.com.htecon.data.HtEntity;
	import br.com.htecon.skin.RodapeGrid;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Panel;
	import mx.containers.VBox;
	
	import spark.components.SkinnableContainer;
	
	public class HtCadastroGrid extends HtCadastroBasico
	
	{		
		public var dataGrid:HtDataGrid;
		private var _filter:HtEntity;
		
		public var panelFilter:Panel;		
		
		public var vbox:VBox;
		
		private var _abrirConsultando: Boolean;
		
		protected var novaEntidade:Object;
		
		public function HtCadastroGrid()
		{
			super();
			
			panelFilter = new Panel();
			
			panelFilter.visible = false;
			panelFilter.height = 0;
			panelFilter.percentWidth = 100;
			panelFilter.setStyle("headerVisible", "false");
			panelFilter.setStyle("headerHeight", "0");
			panelFilter.setStyle("borderStyle", "none");
			panelFilter.setStyle("borderThickness","0");
			panelFilter.setStyle("dropShadowEnabled","false");			
			
			vbox = new VBox();
			
			vbox.percentHeight = 100;
			vbox.percentWidth = 100;
			vbox.setStyle("verticalGap", "0");
			vbox.setStyle("paddingLeft", 6);
			vbox.setStyle("paddingRight", 6);	
			vbox.setStyle("paddingBottom", 6);
			vbox.setStyle("paddingTop", 6);
			
			dataGrid = new HtDataGrid();
			dataGrid.editable = true;			
		
			dataGrid.percentHeight = 100;
			dataGrid.percentWidth = 100;
			
			buttonBar = new HtButtonBar();
			buttonBar.setStyle("paddingTop", -1);
			buttonBar.setStyle("paddingBottom", 0);
			buttonBar.buttons = [HtButtonBar.SAVE_BUTTON, HtButtonBar.NEW_BUTTON, 
				HtButtonBar.DELETE_BUTTON, HtButtonBar.RESTORE_BUTTON]; 
			
			init();			
		}
		
		override protected function trataBotao(button:String) : void {
			super.trataBotao(button);
		    if (button == HtButtonBar.NEW_BUTTON) {
				novoInterno();
			} else if (button == HtButtonBar.DELETE_BUTTON) {
				deletarInterno();
			} else if (button == HtButtonBar.RESTORE_BUTTON) {
				consultarInterno();
			}		
		}
		
		override protected function createChildren():void {
            super.createChildren();
            
            vbox.addChild(panelFilter);
            vbox.addChild(dataGrid);
            
			var rodape:SkinnableContainer = new SkinnableContainer();
			rodape.percentWidth = 100;
			rodape.addElement(buttonBar);
			rodape.setStyle("skinClass", RodapeGrid);
			vbox.addChild(rodape);
            
            addChild(vbox);
            
			BindingUtils.bindSetter(bindSelectedIndex, dataGrid, "selectedIndex");
			BindingUtils.bindProperty(dataGrid, "dataProvider", controller, "data");			
			
			if (_abrirConsultando) {
				consultarInterno();
			}			
                        
  		}
  		
		private function bindSelectedIndex(index:int):void {
			buttonBar.enableButton(HtButtonBar.DELETE_BUTTON, index != -1);	
		}
		
		protected function antesDeletar():Boolean
		{
			return true;
		}
		
		protected function deletarInterno():void
		{
			if (antesDeletar())
			{
				deletar();
			}
		}		
		
		protected function deletar():void {
			dataGrid.deleteRecord();			
		}
		
		protected function novoInterno():void
		{
			if (antesNovo())
			{
				novo();
				depoisNovo();
			}
		}		
		
		protected function novo():void {
			novaEntidade = controller.getNewEntity();
			novaEntidade["status"] = HtEntity.HT_STATUS_INSERTED;
			dataGrid.newRecord(novaEntidade);
		}
		
		protected function depoisNovo():void {
			
		}
		
		protected function antesNovo():Boolean
		{
			return true;
		}		
		
   		protected function init():void {
  			
  		}
		
		protected function antesConsultar():Boolean {
			return true;
		}
		
		public function consultarInterno():void {
			if (antesConsultar()) {
				_filter = controller.getNewEntity();
				prepareFilter(_filter);				
				consultar();
			}
		}
		
		public function consultar():void {			
			controller.startProcessando();			
			controller.find(_filter);
		}
		
		
		protected function prepareFilter(obj: HtEntity):void {
			
		}		
  		
		
		public function get abrirConsultando():Boolean
		{
			return _abrirConsultando;
		}
		
		public function set abrirConsultando(value:Boolean):void
		{
			_abrirConsultando = value;
		}		
		
	}
}
