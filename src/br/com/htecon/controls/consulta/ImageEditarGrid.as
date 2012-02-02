package br.com.htecon.controls.consulta
{

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Image;

	public class ImageEditarGrid extends Image
	{
		[Embed(source="/assets/edit.png")]
		[Bindable]
		private var imageEditar:Class;
		
		public var clickFunction:Function;
		
		public function ImageEditarGrid() {
			super();
			
			addEventListener(MouseEvent.CLICK, imageEditarclickHandler, false, 0, true);
		}
		
		private function imageEditarclickHandler(event:MouseEvent):void {
			dispatchEvent(new Event("CLICKEDBUTTONEDITAR", true, true));
//			clickFunction(event);
		}
		
		override public function set data(value:Object):void
		{
			source = imageEditar;
			super.data=value;
		}		
		
	}

}