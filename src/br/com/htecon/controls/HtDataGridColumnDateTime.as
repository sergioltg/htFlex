package br.com.htecon.controls
{
	import br.com.htecon.util.Util;

	public class HtDataGridColumnDateTime extends HtDataGridColumn
	{
		
		public function HtDataGridColumnDateTime(columnName:String = null) {
			super(columnName);
		}
		
		override public function itemToLabel(data:Object):String
		{
			if (labelFunction != null)
				return labelFunction(data, this);			
			
			var value:Object = getNestedData(data, getFields());
			
			return Util.formatDateTime(value);			
		}
		
	}
}