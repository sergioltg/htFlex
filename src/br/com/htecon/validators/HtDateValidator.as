package br.com.htecon.validators
	
{
	
	import mx.validators.DateValidator;
	
	public class HtDateValidator extends DateValidator
		
	{
		
		public function HtDateValidator()
			
		{
			super();
			inputFormat = "DD/MM/YYYY";
			allowedFormatChars = "/";
		}		
		
		override protected function getValueFromSource():Object
		{
			if (source)
			{
				return source["text"]; 
			} else {
				return super.getValueFromSource();
			}
		}
		
/*		override protected function doValidation(value:Object):Array {
			
			if (value.text == null) {
				return new Array();
			}
			
			var results:Array = super.doValidation(value.text);
			
			
			
				
			//results.push(new ValidationResult(true, null, "Erro",
					
				//"Número do CPF inválido!"));
				
			
			return results;
			
		} */
		
		
		
	}
	
}
