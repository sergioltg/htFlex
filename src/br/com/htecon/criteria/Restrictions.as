package br.com.htecon.criteria
{
	import br.com.htecon.util.Util;

	public class Restrictions
	{
		
		public function Restrictions()
		{
			throw new Error("Cannot create instances of Restrictions");
		}
		
		public static function eq(propertyName:String, value:Object):SimpleExpression {
			return new SimpleExpression(propertyName, value, CriteriaSpecification.EQ);
		}
		
		public static function gt(propertyName:String, value:Object):SimpleExpression {
			return new SimpleExpression(propertyName, value, CriteriaSpecification.GT);			
		}
		
		public static function ge(propertyName:String, value:Object):SimpleExpression {
			return new SimpleExpression(propertyName, value, CriteriaSpecification.GE);			
		}
		
		public static function lt(propertyName:String, value:Object):SimpleExpression {
			return new SimpleExpression(propertyName, value, CriteriaSpecification.LT);		
		}
		
		public static function le(propertyName:String, value:Object):SimpleExpression {
			return new SimpleExpression(propertyName, value, CriteriaSpecification.LE);		
		}
		
		public static function like(propertyName:String, value:String, matchMode:String):SimpleExpression {
			return new SimpleExpression(propertyName, value, CriteriaSpecification.LIKE, matchMode);		
		}
		
		public static function ne(propertyName:String, value:Object):SimpleExpression {
			return new SimpleExpression(propertyName, value, CriteriaSpecification.NE);
		}		
		
	}
}