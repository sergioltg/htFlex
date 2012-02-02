package br.com.htecon.validators
{
	import mx.validators.StringValidator;

	public class HtStringValidator extends StringValidator implements IValidator
	{
		
		private var _title:String;		
		
		public function HtStringValidator()
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