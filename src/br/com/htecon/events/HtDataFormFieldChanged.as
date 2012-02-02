package br.com.htecon.events
{
	
	import br.com.htecon.controls.HtDataFormItem;
	
	import flash.events.Event;

	public class HtDataFormFieldChanged extends Event
	{
		public static const FIELD_CHANGED:String = "fieldChanged";
	
		public var formItem:HtDataFormItem;
	
		public function HtDataFormFieldChanged(type:String, formItem:HtDataFormItem, bubbles:Boolean = true, cancelable:Boolean = false)
   		{
			this.formItem = formItem;
			super(type, bubbles, cancelable);
		}
	}
}