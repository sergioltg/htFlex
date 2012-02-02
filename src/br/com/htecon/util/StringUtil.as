package br.com.htecon.util
{
	import mx.utils.StringUtil;
	
	public class StringUtil
	{
		
		public static function padr(source:String, carac:String, size:int):String {
			var total:int = size - source.length;
			if (total > 0) {
			  source += mx.utils.StringUtil.repeat(carac, total);				
			}
			return source;
		}
		
		public static function padl(source:String, carac:String, size:int):String {
			var total:int = size - source.length;
			if (total > 0) {
				source = mx.utils.StringUtil.repeat(carac, total) + source;				
			}
			return source;
		}		
		
		public static function isEmpty(value:String) {
			return value == null || value == ''; 
		}
		
		
	}
}