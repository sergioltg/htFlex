package br.com.htecon.controls.collapsepanel
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	
	/**
	 * Este container permite definir dois grupos de componentes, sendo que um deles
	 * sera minimizado e expandido de acordo com a propriedade mode. O outro grupo permanece visível
	 * 
	 * @author Thiago Felix
	 * 
	 */	
	
	[SkinState("open")]
	[SkinState("close")]
	[Event(name="open",type="flash.events.Event")]
	[Event(name="close",type="flash.events.Event")]
	[Event(name="modeChanged",type="flash.events.Event")]
	public class CollapsePanel extends SkinnableContainer
	{
		/**
		 * Container onde serão colocados os componentes que são minimizaveis
		 **/
		[SkinPart(required="true")]
		public var staticGroup:Group;
		
		/**
		 * Elemento que vai controlar o modo que o componente esta
		 **/
		[SkinPart(required="true")]
		public var changeModeElement:IEventDispatcher;
		
		
		public var staticChildren:Array;
		
		
		private var _mode:String;
		
		public function set mode(value:String):void
		{
			if(value == mode)
				return;
				
			if(value == CollapsePanelMode.CLOSE)
			{
				setModeAndFireEvent(value,CollapsePanelEvent.CLOSE_EVENT);
				invalidateSkinState();
			}
			else if(value == CollapsePanelMode.OPEN)
			{
				setModeAndFireEvent(value,CollapsePanelEvent.OPEN_EVENT);
				invalidateSkinState();
			}
		}
		/**
		 * Enum que determina como o componente deve estar, 
		 * os valores possíveis são "CollapsePanelMode.OPEN" e "CollapsePanelMode.CLOSE"
		 **/
		[Inspectable(enumeration="open,close")]
		[Bindable("modeChanged")]
		public function get mode():String
		{
			return _mode;
		}
		
		/**
		 * Flag que indica se o componente esta no estado de open
		 **/
		[Bindable("modeChanged")]
		public function get isOpen():Boolean
		{
			return mode == CollapsePanelMode.OPEN;
		}
		
		/**
		 * Flag que indica se o componente esta no estado de close
		 **/
		[Bindable("modeChanged")]
		public function get isClosed():Boolean
		{
			return !isOpen;
		}
		
		/**
		 * Metodo que altera o modo para open
		 **/
		public function open():void
		{
			mode = CollapsePanelMode.OPEN;
		}
		
		/**
		 * Metodo que altera o modo para close
		 **/
		public function close():void
		{
			mode = CollapsePanelMode.CLOSE;
		}
		
		private function setModeAndFireEvent(newMode:String,openTypEvent:String):void
		{
			_mode = newMode;
			dispatchEvent(new Event(CollapsePanelEvent.MODE_CHANGED_EVENT));
			dispatchEvent(new Event(openTypEvent));
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == changeModeElement)
			{
				changeModeElement.addEventListener(MouseEvent.CLICK,onToggleStateClick);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == changeModeElement)
			{
				changeModeElement.removeEventListener(MouseEvent.CLICK,onToggleStateClick);
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			for each(var element:IVisualElement in staticChildren)
			{
				staticGroup.addElement(element);
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if(enabled == false)
			{
				return super.getCurrentSkinState();
			}
			else if(isOpen)
			{
				return "open";
			}
			else
			{
				return "close";
			}
		}
		
		private function onToggleStateClick(event:MouseEvent):void
		{
			if(isOpen)
			{
				close();
			}
			else
			{
				open();
			}
			invalidateSkinState();
		}
	}
}