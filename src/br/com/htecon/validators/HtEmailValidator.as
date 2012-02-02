package br.com.htecon.validators
{
	import mx.validators.EmailValidator;

	public class HtEmailValidator extends EmailValidator implements IValidator
	{
		
		private var _title:String;		
		
		public function HtEmailValidator()
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