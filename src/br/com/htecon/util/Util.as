package br.com.htecon.util
{
	import br.com.htecon.data.HtEntity;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.formatters.SwitchSymbolFormatter;
	
	public class Util
	{
		
		public static var dateFormat:DateFormatter = new DateFormatter();
		public static var numberFormat:NumberFormatter = new NumberFormatter();
		public static var numberFormat2:NumberFormatter = new NumberFormatter();
		
		public static var switchFormat:SwitchSymbolFormatter = new SwitchSymbolFormatter("#");		
		
		
		//Static block start

		numberFormat.decimalSeparatorFrom = ".";
		numberFormat.decimalSeparatorTo = ",";
		numberFormat.thousandsSeparatorFrom = ",";
		numberFormat.thousandsSeparatorTo = ".";
		numberFormat.useThousandsSeparator = true;
		numberFormat.precision = 2;
		
		numberFormat2.decimalSeparatorFrom = ",";
		numberFormat2.decimalSeparatorTo = ".";
		numberFormat2.thousandsSeparatorFrom = ".";
		numberFormat2.thousandsSeparatorTo = "";
		numberFormat2.useThousandsSeparator = false;
		numberFormat2.precision = 2;		

	    //Static block end
		
		public static function getAllChanged(data:ArrayCollection):ArrayCollection {
			var ret:ArrayCollection = new ArrayCollection;
			for each (var obj:Object in data) {
				if (obj["status"] == "U") {
					ret.addItem(obj);
				}
			}
			
			return ret;
			
		}
		
		public static function formatDate(data:Object):String {
			dateFormat.formatString = "DD/MM/YYYY";
			return dateFormat.format(data);
		}
		
		public static function formatDateTime(data:Object):String {
			dateFormat.formatString = "DD/MM/YYYY J:NN";
			return dateFormat.format(data);
		}
		
		public static function formatNumber(valor:Object):String {
			return numberFormat.format(valor);
		}
		
		public static function convertNumber(valor:String):String {
			return numberFormat2.format(valor);			
		}
		
		public static function showStringMaximum(valor:String, maximum:int):String {
			return valor.length < maximum?valor:valor.substr(0, maximum) + "...";
		}
		
		public static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));			
		}
		
		public static function updateArrayCollection(objUpdated: HtEntity, list: ArrayCollection):void {
			for (var x:int = 0; x < list.length; x++) {
				if (objUpdated.equals(list.getItemAt(x))) {
					list.setItemAt(objUpdated, x);
				}
			}
		}		
		
		public static function getElementsContainer(container:UIComponent, klass:Class):Array {
			var elements:Array = new Array();
			for (var n:int = 0; n < container.numChildren; n++) {
				var element: DisplayObject = container.getChildAt(n);
				if (element is klass) {
					elements.push(element);
				}
				if (element is UIComponent) {
					var array:Array = getElementsContainer(element as UIComponent, klass);
					for (var i:int = 0; i < array.length; i++) {
						elements.push(array[i]);
					}
				}
				
			}
			
			return elements;
			
		}
		
		public static function getDataExtenso(data:Date):String  {
			return Extenso.converte(data.getDate()) + " de " + getMesExtenso(data.getMonth()) + " de " + Extenso.converte(data.getFullYear());
		}
		
		public static function getHoraExtenso(hora:String):String  {
			var array:Array = hora.split(":");
			var horas:int = parseInt(array[0]);
			var minutos:int = parseInt(array[1]);
			var result:String = Extenso.converte(horas) + (horas > 1?" horas":" hora"); 
			if (minutos != 0) {
				result += " e " + Extenso.converte(minutos) + (minutos>1?" minutos":" minuto");				
			}
			
			return result;
		}
		
		
		public static function getMesExtenso(mes:int):String {
			return ["janeiro", "fevereiro", "março", "abril", "maio", "junho", 
				  "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"][mes];
		}	
		
		public static function stringIsNull(value:String):Boolean {
			return value == null || value == "";
		}

		public static function calculateHtmlPosition(htmlstr:String, pos:int):int
		{
			// we return -1 (not found) if the position is bad
			if (pos <= -1)
				return -1;
			
			// characters that appears when a tag starts
			var openTags:Array = ["<","&"];
			// characters that appears when a tag ends
			var closeTags:Array = [">",";"];
			// the tag should be replaced with
			// ex: &amp; is & and has 1 as length but normal 
			// tags have 0 length
			var tagReplaceLength:Array = [0,1];
			// flag to know when we are inside a tag
			var isInsideTag:Boolean = false;
			var cnt:int = 0;
			// the id of the tag opening found
			var tagId:int = -1;
			var tagContent:String = "";
			
			for (var i:int = 0; i < htmlstr.length; i++)
			{
				// if the counter passes the position specified
				// means that we reach the text position
				if (cnt>=pos) 
					break;
				// current char	
				var currentChar:String = htmlstr.charAt(i);
				// checking if the current char is in the open tag array
				for (var j:int = 0; j < openTags.length; j++)
				{
					if (currentChar == openTags[j])
					{
						// set flag
						isInsideTag = true;
						// store the tag open id
						tagId = j;
					}
				}
				if (!isInsideTag)
				{
					// increment the counter
					cnt++;
				} else {
					// store the tag content
					// needed afterwards to find new lines
					tagContent += currentChar;
				}
				if (currentChar == closeTags[tagId]) {
					// we ad the replace length 
					if (tagId > -1) cnt += tagReplaceLength[tagId];
					// if we encounter the </P> tag we increment the counter
					// because of new line character
					if (tagContent == "</P>") cnt++;
					// set flag 
					isInsideTag = false;
					// reset tag content
					tagContent = "";
				}
			}
			// return de position in html text
			return i;
		}	
		
		public static function validCpf(value:String):Boolean {			
			var digito:Array = new Array(); // array para os dígitos do CPF.			
			var aux:Number= 0;			
			var posicao:Number;			
			var i:Number;			
			var soma:Number;			
			var dv:Number;			
			var dvInformado:Number;			
			var CPF:String = value;
			
			// Retira os dígitos formatadores de CPF '.' e '-', caso existam.
			
			CPF.replace(".", "");
			
			CPF.replace("-", "");
			
			// Início da validação do CPF.
			
			/* Retira do número informado os dois últimos dígitos */
			
			dvInformado = parseInt(CPF.substr(9,2));
			
			/* Desmembra o número do CPF no array digito */
			
			for (var n:int=0; n <= 8; n++)				
			{				
				digito[n] = CPF.substr(n,1);				
			}		
			/* Calcula o valor do 10o. digito de verificação */
			
			posicao = 10;			
			soma = 0;			
			for (i=0; i  <= 8; i++)				
			{				
				soma = soma + digito[i] * posicao;				
				posicao--;				
			}
			
			digito[9] = soma % 11;			
			if (digito[9] < 2)				
			{				
				digito[9] = 0;				
			}				
			else				
			{				
				digito[9] = 11 - digito[9];				
			}
			
			/* Calcula o valor do 11o. digito de verificação */
			
			posicao = 11;			
			soma = 0;
			
			for (i=0; i <= 9; i++)				
			{				
				soma = soma + digito[i] * posicao;				
				posicao--;				
			}
			
			digito[10] = soma % 11;			
			if (digito[10] < 2)				
			{
				digito[10] = 0;
			}
			else
			{
				digito[10] = 11 - digito[10];
			}
			
			dv = digito[9] * 10 + digito[10];
			/* Verifica se o DV calculado é igual ao informado */
			if(dv != dvInformado)
			{
				return false;
			}
			
			return true;
		}
		
		public static function validCnpj(value:String):Boolean {
			var a:Array = new Array();			
			var b:Number = new Number;			
			var i:Number;			
			var x:Number;			
			var y:Number;			
			var c:Array = [6,5,4,3,2,9,8,7,6,5,4,3,2];			
			var CNPJ:String = value;			
			
			// Retira os dígitos formatadores de CNPJ '.' e '-', caso existam.
			
			CNPJ.replace(".", "");			
			CNPJ.replace("-", "");			
			CNPJ.replace("/", "");		
			
			for (i=0; i < 12; i++){
				a[i] = CNPJ.charAt(i);
				b += a[i] * c[i+1];
			}
			
			if ((x = b % 11) < 2) { a[12] = 0 } else { a[12] = 11-x }
				b = 0;
			
			for (y=0; y < 13; y++) {
				b += (a[y] * c[y]);
			}
			if ((x = b % 11) < 2) { a[13] = 0; } else { a[13] = 11-x; }
			if ((CNPJ.charAt(12) != a[12]) || (CNPJ.charAt(13) != a[13]))
			{				
				return false;
			}
			
			return true;
		}
		
		public static function formatarCpf(value:String):String {
			if (value == null) {
				return "";
			}
			return switchFormat.formatValue("###.###.###-##", value);			
		}
		
		
		public static function formatarCnpj(value:String):String {
			if (value == null) {
				return "";
			}
			return switchFormat.formatValue("##.###.###/####-##", value);			
		}		
		
		public static function retornaRecordCount(value:ArrayCollection):int {
			var result:int = 0;
			for each (var object:Object in value) {
				if (!HtEntity(object).isStatusDelete()) {
					result++;
				}
			}
			return result;
		}
		
		
	}
}