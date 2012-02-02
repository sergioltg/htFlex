package br.com.htecon.controls
{
	import br.com.htecon.controls.events.HtButtonBarClickEvent;
	import br.com.htecon.data.HtEntity;
	
	import com.farata.controls.DataGrid;
	
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	
	/**
	 *  Classe de grid, contendo algumas funcoes de inserir registro, deletar, sempre controlando o status da entidade
	 *  
	 */

	public class HtDataGrid extends com.farata.controls.DataGrid
	{
		private var lastValue:Object;
		
		private var factoryEntityClass: ClassFactory;
		public var entityClass: Class;		
		
		public var includeColumnStatus:Boolean = true;
		
		private var _buttonBar: HtButtonBar;
		public var antesNovoFunction:Function;		
		
		public function HtDataGrid()
		{
			super();

			addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, dataGridItemEditBeginning, false, 0, true);
			addEventListener(DataGridEvent.ITEM_EDIT_END, dataGridItemEditEnd, false, 0, true);
		}

		protected function dataGridItemEditBeginning(event:DataGridEvent):void
		{
			if (selectedItem != null && event.dataField != null)
			{
				lastValue=this.selectedItem[event.dataField];
			}
		}

		protected function dataGridItemEditEnd(event:DataGridEvent):void
		{
			
			var newValue:Object=this.itemEditorInstance[this.columns[event.columnIndex].editorDataField];

			if (lastValue != newValue)
			{
				var status:String=event.itemRenderer.data["status"];
				if (status != HtEntity.HT_STATUS_DELETED && status != HtEntity.HT_STATUS_INSERTED)
				{
					event.itemRenderer.data["status"]=HtEntity.HT_STATUS_UPDATED;
				}
			}
		}

		public function newRecord(value:Object):void
		{
			ArrayCollection(this.dataProvider).addItem(value);
			this.selectedIndex=ArrayCollection(this.dataProvider).length - 1;

			var focusedCell:Object=null;
			for (var x:int=0; x < columns.length; x++)
			{
				if ((columns[x] as DataGridColumn).editable)
				{
					focusedCell=new Object();
					focusedCell.columnIndex=x;
					break;
				}
			}
			validateNow();
			if (focusedCell != null) {
				focusedCell.rowIndex=this.selectedIndex;
				this.editedItemPosition=focusedCell;
			} else {
				if (this.verticalScrollBar) {
					this.verticalScrollPosition = this.verticalScrollBar.maxScrollPosition;
				}
			}
		}

		public function deleteRecord(index:int=-1):void
		{
			if (index == -1)
			{
				index=selectedIndex;
			}
			if (index == -1) {
				return;
			}
			var obj:Object=dataProvider[index];

			if (obj["status"] == HtEntity.HT_STATUS_INSERTED)
			{
				ArrayCollection(dataProvider).removeItemAt(index);
			}
			else
			{
				obj["status"]=HtEntity.HT_STATUS_DELETED;
				dataProvider.refresh();
			}

		}

		override public function set columns(value:Array):void
		{
			if (includeColumnStatus) {
				var columnsTemp:ArrayCollection=new ArrayCollection(value);
				var columnStatus:DataGridColumn=new DataGridColumn("status");
				columnStatus.headerText="";
				columnStatus.width=17;
				columnStatus.resizable = false;
				columnStatus.sortable = false;
				columnStatus.itemRenderer=new ClassFactory(ImageStatusGrid);
				columnStatus.editable=false;
	
				columnsTemp.addItemAt(columnStatus, 0);
	
				super.columns=columnsTemp.toArray();
			} else {
				super.columns = value;
			}
		}
		
		public function set buttonBar(value: HtButtonBar):void {
			_buttonBar = value;
			_buttonBar.addEventListener(HtButtonBarClickEvent.BUTTON_CLICKED, buttonBarHandler, false, 0, true);
			
		}
		
		public function get buttonBar():HtButtonBar {
			return _buttonBar;
		}
		
		private function buttonBarHandler(event: HtButtonBarClickEvent):void {
			if (event.button == HtButtonBar.NEW_BUTTON) {
				newRecordByButtonBar();
			} else if (event.button == HtButtonBar.DELETE_BUTTON) {
				deleteRecord();
			}
		}
		
		protected function getNewEntity():HtEntity {
			if (factoryEntityClass == null) {
				factoryEntityClass = new ClassFactory(entityClass);
			}			
			var entityNew: HtEntity = factoryEntityClass.newInstance();
			entityNew.setStatusInsert();
			if (antesNovoFunction != null) {
				antesNovoFunction(entityNew);
			}
			return entityNew;			
		}
		
		public function newRecordByButtonBar():void {
			newRecord(getNewEntity());			
		}		
			
	}
}