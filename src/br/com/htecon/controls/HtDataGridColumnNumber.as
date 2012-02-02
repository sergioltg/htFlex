package br.com.htecon.controls
{
	import br.com.htecon.util.Util;
	
	public class HtDataGridColumnNumber extends HtDataGridColumn
	{
		
		public function HtDataGridColumnNumber(columnName:String = null) {
			super(columnName);
		}		
		
		override public function itemToLabel(data:Object):String
		{
			if (labelFunction != null)
				return labelFunction(data, this);
			
			var value:Object = getNestedData(data, getFields());
			return  Util.formatNumber(value);
		}
		
	}
}