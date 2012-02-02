package br.com.htecon.controls
{
	import br.com.htecon.controls.events.HtButtonBarClickEvent;
	import br.com.htecon.controls.tree.renderers.CheckIndeterminateTreeItemRenderer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.BoxDirection;
	import mx.controls.ButtonBar;
	import mx.controls.buttonBarClasses.*;
	import mx.events.ItemClickEvent;
	
	/**
	 *  Classe de botoes, com botoes predefinidos, podendo ser adicionados novos botoes usando o metodo addButtonDef
	 *  
	 */	
	
	[Event(name="buttonClicked", type="br.com.htecon.controls.events.HtButtonBarClickEvent")]
	public class HtButtonBar extends ButtonBar
	{
		public static const BACK_BUTTON:String = "back";		
		public static const SELECT_BUTTON:String = "select";
		public static const SAVE_BUTTON:String = "save";
		public static const NEW_BUTTON:String = "new";
		public static const DELETE_BUTTON:String = "delete";
		public static const PRINT_BUTTON:String = "print";
		public static const CLOSE_BUTTON:String = "close";
		public static const RESTORE_BUTTON:String = "restore";
		public static const FETCH_BUTTON:String = "fetch";
		public static const CLEAR_BUTTON:String = "clear";
		public static const EDIT_BUTTON:String = "edit";
		
		private var buttonDefs:Array = [{type:SELECT_BUTTON, label:"Selecionar", icon:imageSelect},
			{type:BACK_BUTTON, label:"Voltar", icon:imageBack},
			{type:SAVE_BUTTON, label:"Salvar", icon:imageSave},
			{type:DELETE_BUTTON, label:"Excluir", icon:imageHorizontalDelete, iconVertical:imageDelete, labelVertical:""},
			{type:NEW_BUTTON, label:"Novo", icon:imagePageAdd, iconVertical:imageAdd, labelVertical:""},
			{type:CLOSE_BUTTON, label:"Fechar", icon:imageClose},
			{type:PRINT_BUTTON, label:"Imprimir", icon:imagePrint},
			{type:RESTORE_BUTTON, label:"Restaurar", icon:imageRestaurar},
			{type:FETCH_BUTTON, label:"Consultar", icon:imageSearch},
			{type:CLEAR_BUTTON, label:"Limpar", icon:imageClear},
			{type:EDIT_BUTTON, label:"Editar", icon:imageEdit, iconVertical:imageEdit, labelVertical:""}];	
		
		[Embed(source="/assets/save.png")]
		[Bindable]
		private static var imageSave:Class;
		
		[Embed(source="/assets/delete.png")]
		[Bindable]
		private static var imageDelete:Class;
		
		[Embed(source="/assets/cross.png")]
		[Bindable]
		private static var imageHorizontalDelete:Class;
		
		[Embed(source="/assets/page_add.png")]
		[Bindable]
		private static var imagePageAdd:Class;
		
		[Embed(source="/assets/add.png")]
		[Bindable]
		private static var imageAdd:Class;			
		
		[Embed(source="/assets/page_white_edit.png")]
		[Bindable]
		private static var imageEdit:Class;
		
		[Embed(source="/assets/close.png")]
		[Bindable]
		private static var imageClose:Class;
		
		[Embed(source="/assets/search.png")]
		[Bindable]
		private static var imageSearch:Class;	
		
		[Embed(source="/assets/print.png")]
		[Bindable]
		private static var imagePrint:Class;
		
		[Embed(source="/assets/erase.png")]
		[Bindable]
		private static var imageClear:Class;
		
		[Embed(source="/assets/back.png")]
		[Bindable]
		private static var imageBack:Class;	
		
		[Embed(source="/assets/select.png")]
		[Bindable]
		private static var imageSelect:Class;	
		
		[Embed(source="/assets/refresh.png")]
		[Bindable]
		private static var imageRestaurar:Class;	
		
		private var _buttons:Array;
		
		public function HtButtonBar()
		{
			super();
			
			setStyle("buttonWidth", 110);
			
			addEventListener(ItemClickEvent.ITEM_CLICK, buttonBarItemClick);
			
			setStyle("paddingBottom", 10);
			
			styleName = "myButtonBar";
		}
		
		public function addButtonDef(button:Object):void {
			buttonDefs.push(button);
		}
		
		private function buttonBarItemClick(event:ItemClickEvent):void {
			dispatchEvent(new HtButtonBarClickEvent(HtButtonBarClickEvent.BUTTON_CLICKED, 
				dataProvider[event.index].type));
		}		
		
		public function set buttons(value:Array):void {
			_buttons = value;
			
			createButtons();			
		}
		
		public function get buttons():Array {
			return _buttons;
		}		
		
		private function createButtons():void {
			var dp:ArrayCollection = new ArrayCollection();
			for each (var btn:String in _buttons) {				
				dp.addItem(getButtonDef(btn));
			}
			
			dataProvider = dp;
		}
		
		public function addButton(button:String, index:int = 0):void {
			
			var buttonsArray:ArrayCollection = ArrayCollection(dataProvider);
			// Verifica se o botao ja existe
			for each (var obj: Object in buttonsArray) {
				if (obj.type == button) {
					return;
				}
			}
			
			if (index == -1) {
				index = buttonsArray.length;
			}
			buttonsArray.addItemAt(getButtonDef(button), index);
			
		}
		
		public function enableButton(type:String, enabled:Boolean):void {
			var buttonB: ButtonBarButton = getButtonBarButton(type);
			if (buttonB != null) {
				buttonB.enabled = enabled;
			}
		}
		
		public function removeButton(type:String):void {
			var buttonsArray:ArrayCollection = ArrayCollection(dataProvider);			
			for (var x:int = 0; x < buttonsArray.length; x++) {
				if (dataProvider[x].type == type) {
					buttonsArray.removeItemAt(x);
					invalidateDisplayList();
					break;
				}				
			}
		}
		
		public function getButtonBarButton(type:String):ButtonBarButton {
			for (var x:int = 0; x < numChildren; x++) {
				if (dataProvider[x].type == type) {
					return getChildAt(x) as ButtonBarButton;
				}				
			}
			
			return null;
			
		}
		
		private function getButtonDef(type:String):Object {
			for (var n:int = 0; n < buttonDefs.length; n++) {
				if (buttonDefs[n].type == type) {
					return buttonDefs[n];
					break;
				}
			}
			
			return null;			
		}
		
		override public function set direction(value:String):void {
			iconField = value == BoxDirection.VERTICAL?"iconVertical":"icon";
			labelField = value == BoxDirection.VERTICAL?"labelVertical":"label";
			super.direction = value;
		}
		
	}
}