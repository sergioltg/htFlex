package br.com.htecon.controls
{
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;

	public class HtForm extends VBox
	{
		
		public function passaParametro(psName:String, psValue:Object):void {
			
		}
		
		public function closed():void {
		}
		
		
		public function close():void {
			closed();
			if (parent is TitleWindow) {
				PopUpManager.removePopUp(IFlexDisplayObject(parent));
			} else {
				PopUpManager.removePopUp(this);
			}
		}
		
	}
}