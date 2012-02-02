package br.com.htecon.controls
{
	import br.com.htecon.data.HtEntity;
	
	import mx.controls.Image;

	public class ImageStatusGrid extends Image
	{
		[Embed(source="/assets/blank.png")]
		[Bindable]
		private var imageBlank:Class;
				
		[Embed(source="/assets/deleteGrid.png")]
		[Bindable]
		private var imageDelete:Class;
		
		[Embed(source="/assets/addGrid.png")]
		[Bindable]
		private var imageInsert:Class;
		
		[Embed(source="/assets/editGrid.png")]
		[Bindable]
		private var imageUpdate:Class;
		
		override public function set data(value:Object):void
		{			
			source = imageBlank;
			if (value != null)
			{
				super.data=value;				
				if (data["status"] == HtEntity.HT_STATUS_DELETED) {
					source = imageDelete;
				} else if (data["status"] == HtEntity.HT_STATUS_INSERTED) {
					source = imageInsert;					
				} else if (data["status"] == HtEntity.HT_STATUS_UPDATED) {
					source = imageUpdate;
				}
			}
		}
	}

}