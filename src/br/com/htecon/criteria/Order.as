package br.com.htecon.criteria
{
	public class Order
	{
		
		public var ascending:Boolean;
		public var propertyName:String;
		
		public function Order(propertyName:String, ascending:Boolean) {
			super();
			this.propertyName = propertyName;
			this.ascending = ascending;
		}		
		
		public static function asc(propertyName:String):Order
		{
			return new Order(propertyName, true);
		}
		
		public static function desc(propertyName:String):Order
		{
			return new Order(propertyName, false);
		}
		
		public function toString():String
		{
			return "Order:" + propertyName + ":" + ascending;
		}		
		
		
	}
}