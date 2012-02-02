package br.com.htecon.criteria
{
	import br.com.htecon.util.Util;

	public class SimpleExpression implements Criterion
	{
		
		private var op:String;
		private var propertyName:String;
		private var value:Object;
		private var _ignoreCase:Boolean = false;
		private var matchMode:String;		
		
		public function SimpleExpression(propertyName:String, value:Object, op:String, matchMode:String = null)
		{
			super();
			this.propertyName = propertyName;
			this.value = value;
			this.matchMode = matchMode;
			this.op = op;
		}		
		
		public function ignoreCase():SimpleExpression {
			this._ignoreCase = true;
			return this;
		}
		
		private function getTypeValue():String {
			if (value is Date) {
				return "date";
			} else if (value is String) {
				return "string";
			} else if (value is int) {
				return "int";				
			} else if (value is Number) {
				return "number";
			} else				
				return "";			
		}
		
		private function GetStringValue():String {
			if (value is Date) {
				return Util.formatDate(value);
			} else return value.toString();
		}
		
		public function toString():String
		{
			return "SimpleExpression:" + op + ":" + propertyName + ":" + getTypeValue() + ":" + escape(GetStringValue()) + ":" + _ignoreCase + ":" + matchMode;
		}		
		
		
	}
}