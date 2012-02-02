package br.com.htecon.controls
{
	import com.farata.controls.ComboBox;
	
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class HtComboBox extends ComboBox
	{
		override public function set value(val:Object):void
		{			
			super.value = val;
			if (val != null && dataProvider != null)
			{
				for (var i:int=0; i < dataProvider.length; i++)
				{
					if (val == dataProvider[i].data)
					{
						selectedIndex=i;
						return;
					}
				}
			}
			selectedIndex=-1;
		}

	}
}