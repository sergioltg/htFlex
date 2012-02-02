
package br.com.htecon.controls {
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.controls.TextInput;
	import mx.formatters.NumberFormatter;

	/**
	 * Autor: Fabio da Silva
	 * 
	 * Classe para digitação de valores, moeda ou não.  
	 * Características:
	 * 		- É utilizado o locale da aplicação para formatação.
	 * 		- A alteração dos atributos: precision, useNegativeSign e useThousandsSeparator
	 * 			e a troca de locale da aplicação em runtime provoca a reformatação do valor atual.
	 * 		- Se useNegativeSign = true e for digitado "-" em qq parte da string, então o valor irá ficar negativo.
	 * 		- A alteração da propriedade text via código não provoca a sua formatação
	 * 		- IMPORTANTE: Por conveniência foi criada a propriedade value para ser utilizada no lugar de text.
	 * 			Setar text no MXML formata o valor passado, mas o mesmo não acontece qd setado via código, 
	 * 			por isso, usar value. 
	 */ 
	
	[Event(name="valueChange", type="flash.events.Event")] 
	[Event(name="propertiesNumberFormatChange", type="flash.events.Event")] 
	 
	public class HtNumericInput extends TextInput { 

		/** 
		 * NumberFormatter q será utilizado para formatar os valores deste objeto.
		 * Foi deixado public somente para q outros objetos possam formatar da mesma maneira q este objeto. 
		 */
		[Bindable(event="propertiesNumberFormatChange")]
		public var nf:NumberFormatter;
		private var _precision:uint = 2;
		private var _useNegativeSign:Boolean;
		private var _useThousandsSeparator:Boolean = true;
		private var _value:Object;
		
		private var precisionChanged:Boolean;
		private var onlyDigits:RegExp = new RegExp("[^\\d]", "g");
		private var useNegativeSignChanged:Boolean;
		private var useThousandsSeparatorChanged:Boolean;
		
		public static const PROPERTIES_NUMBER_FORMAT_CHANGE:String = "propertiesNumberFormatChange";
		public static const VALUE_CHANGE:String = "valueChange";

		public function HtNumericInput() {
			super();
			
	        this.nf = new NumberFormatter();
	        this.nf.precision = this._precision;
	        this.nf.useNegativeSign = this._useNegativeSign;
	        this.nf.useThousandsSeparator = this._useThousandsSeparator;
	        
			this.addEventListener(Event.CHANGE, this.formatHandler, false, 0, true);
			this.addEventListener(FocusEvent.FOCUS_IN, this.setCursor, false, 0, true);
			this.resourceManager.addEventListener(Event.CHANGE, this.formatHandler, false, 0, true);				

	        this.maxChars = 20;
	        this.restrict = "0-9";
	        this.setStyle("textAlign", "right");
//	        this.value = 0;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var formatChange:Boolean = (this.precisionChanged || this.useNegativeSignChanged || this.useThousandsSeparatorChanged); 
			
			if (this.precisionChanged) {
				this.precisionChanged = false;
				this.nf.precision = this.precision;
			}
			
			if (this.useNegativeSignChanged) {
				this.useNegativeSignChanged = false;
				this.nf.useNegativeSign = this.useNegativeSign;
				this.restrict = (this.useNegativeSign) ? "0-9\\-" : "0-9";
			}
			
			if (this.useThousandsSeparatorChanged) {
				this.useThousandsSeparatorChanged = false;
				this.nf.useThousandsSeparator = this.useThousandsSeparator 
			}
			
			if (formatChange) {
				this.value = this.text;
				this.dispatchEvent(new Event(HtNumericInput.PROPERTIES_NUMBER_FORMAT_CHANGE));
			}
		}
		
///////////////////////////////////////////////// Propriedades ////////////////////////////////////////////////		
		
		public function get precision():uint {
			return this._precision;
		}
		
		/** Seta o número de casas decimais. Default = 2 */
		[Inspectable(defaultValue=2)]
		public function set precision(value:uint):void {
			if (this.precision != value) {
				this._precision = value;
				this.precisionChanged = true;
				this.invalidateDisplayList();
			}
		}

		public function get useNegativeSign():Boolean {
			return this._useNegativeSign;
		}
		
		/** Se permite o uso de sinal negativo. Default = false */
		[Inspectable(defaultValue=false)]
		public function set useNegativeSign(value:Boolean):void {
			if (this.useNegativeSign != value) {
				this._useNegativeSign = value;
				this.useNegativeSignChanged = true;
				this.invalidateDisplayList();
			}
		}
		
		public function get useThousandsSeparator():Boolean {
			return this._useThousandsSeparator;
		}
		
		/** Se deve usar separador de milhar. Default = true. */
		[Inspectable(defaultValue=true)]
		public function set useThousandsSeparator(value:Boolean):void {
			if (this.useThousandsSeparator != value) {
				this._useThousandsSeparator = value;
				this.useThousandsSeparatorChanged = true;
				this.invalidateDisplayList();
			}
		} 

		public function get value():Object {
			return this._value;
		}
		
		[Bindable(event="valueChange")]
		public function set value(value:Object):void {
			this._value = this.toNumber(value);
			this.text = this.nf.format(this._value);   
			this.dispatchEvent(new Event(HtNumericInput.VALUE_CHANGE));
		}

/////////////////////////////////////////////////// Métodos ///////////////////////////////////////////////////		
		
		private function formatHandler(event:Event):void {
			this.value = this.text;

			this.setCursor(null);
		}
		
		/** Retorna uma String com só os dígitos de value. */
		public function returnDigits(value:Object):String {
			 return value.toString().replace(this.onlyDigits, "");
		}
		
	    private function setCursor(event:FocusEvent):void {
	        this.setSelection(this.length, this.length);
	    }
	    
	    /** 
	    * Converte value.toString() para Number, se value não for Number, desconsiderando 
	    * os caracteres q não são dígitos e respeitando as configurações.
	    * Se value == null então retorna 0. 
	    */
	    public function toNumber(value:Object):Number {
	    	if (value is Number) return new Number(value);

	    	var retorno:Number = 0;
	    	
			if (value != null) {
		        retorno = Number(this.returnDigits(value));

				// Se estiver marcado q pode ser usado sinal negativo e se encontrá-lo, então multiplica por -1
				if (this.useNegativeSign && value.toString().indexOf("-") > -1) retorno *= -1; 
			}

			return (retorno / Math.pow(10, this._precision));
	    }
		
		override public function set data(value:Object):void {
			super.data = value;
			this.value = listData ? this.toNumber(listData.label) : Number(data);
		}
	}
}