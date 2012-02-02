package br.com.htecon.util
{
	public class Extenso
	{
		
		public static var ZERO:String = "zero";
		
		public static var unidades:Array  = [
			"", "um", "dois", "três", "quatro", "cinco", "seis", "sete", "oito", "nove", 
			"dez", "onze", "doze", "treze", "quatorze","quinze","dezesseis","dezessete","dezoito","dezenove"
		];
		
		public static var dezenas:Array  = [
			"","", "vinte", "trinta", "quarenta", "cinqüenta", "sessenta", "setenta", "oitenta", "noventa", "cem"
		];
		
		public static var centenas:Array  = [
			"", "cento", "duzentos", "trezentos", "quatrocentos", "quinhentos", "seiscentos", "setecentos", "oitocentos", "novecentos"
		];
		
		public static var SEPARADOR_MENOR:String  = " e ";	
		public static var SEPARADOR_MAIOR:String  = " , "; //2 espacos para ficar igual ao " e "
		
		public static var ordensSingular:Array = [
			"", "mil", "milhão", "bilhão", "trilhão", "quatrilhão", "quintilhão", "sextilhão", "setilhão", "octilhão", "nonilhão", 
			"decilhão", "undecilhão", "dodecilhão", "tredecilhão", "quatordecilhão", "quindecilhão", "sedecilhão", "septendecilhão"
		];
		
		public static var ordensPlural:Array = [
			"", "mil", "milhões", "bilhões", "trilhões", "quatrilhões", "quintilhões", "sextilhões", "setilhões", "octilhões", 
			"decilhões", "undecilhões", "dodecilhões", "tredecilhões", "quatordecilhões", "quindecilhões", "sedecilhões", "septendecilhões" 
		];
		
		public static var CEM:Number  = 1000;
		public static var NUMERO_MAXIMO:Number  = 999999999999999999999999999999999999999999999999999999;
		
		
		private static function unidadesF(numero:int): String  {
			if (numero == 0)
				return "";	
			return SEPARADOR_MENOR + unidades[numero];		
		}
		
		private static function dezenasF(numero:int):String  {
			if (numero == 0)
				return "";
			if (numero < 20)
				return unidadesF(numero);	
			return SEPARADOR_MENOR + dezenas[int(numero / 10)] + unidadesF(numero % 10);		
		}
		
		private static function centenasF(numero:int):String {
			if (numero == 0)
				return "";
			if (numero <= 100)
				return dezenasF(numero); 			
			return SEPARADOR_MAIOR + centenas[int(numero / 100)] + dezenasF(numero % 100);		
		}
		
		private static function ordens(numero:Number, grandeza:int): String {				
			if (numero == 0)
				return "";
			if (numero < 1000)
				return centenasF (numero);
			
			var menor:int = (numero % 1000);			
			var maior:Number  = numero / 1000;
			var proximoMenor:int  = (maior % 1000);		
			
			if (proximoMenor == 0)
				return ordens(maior,grandeza+1) + centenasF(menor);		
			if (proximoMenor == 1)
				return ordens(maior,grandeza+1) + " " + ordensSingular[grandeza] + centenasF(menor);
			return ordens(maior,grandeza+1) + " " + ordensPlural[grandeza] + centenasF(menor);					 			
		}
		
		public static function converte(numero:Number):String  {
			if (numero == 0) 
				return ZERO;
			return ordens(numero,1).substring(3);
		}
		
		
	}
}