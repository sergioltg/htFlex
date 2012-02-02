package br.com.htecon.controls.collapsepanel
{
	import br.com.htecon.controls.HtButtonBar;
	import br.com.htecon.controls.events.HtButtonBarClickEvent;

	[Event(name="buttonClicked", type="br.com.htecon.controls.events.HtButtonBarClickEvent")]
	public class CollapseFilterPanel extends CollapsePanel
	{
		
		[SkinPart(required="true")]
		public var buttonBarFiltro:HtButtonBar;
		
		public function CollapseFilterPanel()
		{
			super();
			setStyle("skinClass", CollapseFilterSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == buttonBarFiltro)
			{
//				buttonBarFiltro.addEventListener(HtButtonBarClickEvent.BUTTON_CLICKED, buttonBarFilterClicked);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == buttonBarFiltro)
			{
//				buttonBarFiltro.removeEventListener(HtButtonBarClickEvent.BUTTON_CLICKED, buttonBarFilterClicked);
			}
		}
		
		private function buttonBarFilterClicked(event:HtButtonBarClickEvent):void {
			//dispatchEvent(new HtButtonBarClickEvent(HtButtonBarClickEvent.BUTTON_CLICKED, event.button));
		}
		
	}
}