package br.com.htecon.validators
{
	import mx.validators.NumberValidator;

	public class HtNumberValidator extends NumberValidator implements IValidator
	{
		
		private var _title:String;		
		
		public function HtNumberValidator()
		{
			super();
		}
		
		public function get title():String {
			return _title;
		}
		
		public function set title(value:String):void {
			_title = value;
		}
				
	}
}