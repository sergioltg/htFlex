package br.com.htecon.util
{
	import mx.collections.IList;

	public class ArrayUtil
	{
		
		public static function forEachGroup(list:IList, functionGroup:Function, functionEach:Function, 
					functionEndGroup:Function):void {
			var size:int = list.length;
			var x:int = 0;
			var group:Object;
			while (x < size) {
				group = functionGroup(list.getItemAt(x));
				while (x < size && group == functionGroup(list.getItemAt(x))) {
					functionEach(list.getItemAt(x));					
					x++;
				} 
				functionEndGroup();
			}
			
		}
		
	}
}