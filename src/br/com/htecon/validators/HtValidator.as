package br.com.htecon.validators
{
	import mx.validators.Validator;
	
	public class HtValidator extends Validator implements IValidator
	{
		
		private var _title:String;
		
		public function HtValidator()
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