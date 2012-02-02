package br.com.htecon.controls
{
	import br.com.htecon.controls.cadastro.HtCadastroDialog;
	import br.com.htecon.controls.consulta.ImageEditarGrid;
	import br.com.htecon.controls.events.HtButtonBarClickEvent;
	import br.com.htecon.controls.events.HtDialogEvent;
	import br.com.htecon.data.HtEntity;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;

	[Event(name="CLICKEDBUTTONEDITAR", type="flash.events.Event")]
	public class HtDataGridDialog extends HtDataGrid
	{		
		
		private var indexEditing: int;
		
		public var dialogClass: Class;		
		
		protected var dialogObject: HtCadastroDialog;
		
		public function HtDataGridDialog()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		}		
		
		public function editar():void {
			indexEditing = selectedIndex;
			var entityEdit: HtEntity = HtEntity(ObjectUtil.copy(selectedItem));
			if (!entityEdit.isStatusInsert()) {
				entityEdit.setStatusUpdate();
			}
			createDialog().entity = entityEdit;			
		}
		
		override public function newRecordByButtonBar():void {
			indexEditing = -1;
			
			createDialog().entity = getNewEntity();			
		}
		
		
		protected function createDialog(): HtCadastroDialog {
			var titleWindow:TitleWindow = TitleWindow(PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, TitleWindow, true));
			
			if (dialogObject == null) {
				dialogObject = new dialogClass();
				dialogObject.addEventListener(HtDialogEvent.DIALOG_OK, dialogObjectOkHandler, false, 0, true);				
			}
			titleWindow.title = dialogObject.label;
			titleWindow.addChild(dialogObject);
			PopUpManager.centerPopUp(titleWindow);
			return dialogObject;
		}
		
		
		private function colunaEditarClickHandler(event:Event):void {
			if (dialogClass != null) {
				editar();
				event.stopPropagation();
			}
		}
		
		private function dialogObjectOkHandler(event: HtDialogEvent):void {
			var lista:ArrayCollection = ArrayCollection(dataProvider);			
			if (indexEditing == -1) {
				lista.addItem(event.entity);
			} else {
				lista.setItemAt(event.entity, indexEditing);						
			}			
		}
		
		override public function set columns(value:Array):void
		{
			var columnsTemp:ArrayCollection=new ArrayCollection(value);
			var columnEditar:DataGridColumn=new DataGridColumn("editar");
			columnEditar.headerText="";
			columnEditar.width=20;
			columnEditar.editable=false;
			columnEditar.sortable=false;
			var classFactory: ClassFactory = new ClassFactory(ImageEditarGrid);
			// parou de funcionar na versao release 4.0
//			classFactory.properties = {clickFunction:colunaEditarClickHandler};
			
			addEventListener("CLICKEDBUTTONEDITAR", colunaEditarClickHandler);
			
			columnEditar.itemRenderer = classFactory;
			
			columnsTemp.addItem(columnEditar);
			
			super.columns=columnsTemp.toArray();
		}		
		
	}
}