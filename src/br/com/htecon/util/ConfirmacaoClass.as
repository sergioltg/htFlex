package br.com.htecon.util
{
	import flash.display.DisplayObject;
	
	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;

	public class ConfirmacaoClass extends TitleWindow
	{
		
		[Bindable]
		public var text:String;
		
		public var clickYes:Function;
		public var clickNo:Function;		
		
		public function ConfirmacaoClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
		}
		
		private function createCompleteHandler(event:FlexEvent):void {
			PopUpManager.centerPopUp(this);
		}
		
		public function confirm(response:String):void
		{
			if ("Yes" == response) {
				if (clickYes != null) {
					clickYes();
					clickYes = null;
				}
			} else {
				if (clickNo != null) {
					clickNo();
					clickNo = null;
				}				
			}
			PopUpManager.removePopUp(this);
		}
		
		public static function open(text:String, functionYes:Function, functionNo:Function = null):void {
			var confirmacao:Confirmacao = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, Confirmacao, true) as Confirmacao;
			confirmacao.text = text;
			confirmacao.clickYes = functionYes;
			confirmacao.clickNo = functionNo;
		} 
		
		
	}
}