package br.com.htecon.criteria
{
	import mx.collections.ArrayCollection;

	public class HtCriteria
	{
		
		public static const JOINTYPE_INNERJOIN:String = "INNERJOIN";
		public static const JOINTYPE_FULLJOIN:String = "FULLJOIN";
		public static const JOINTYPE_LEFTJOIN:String = "LEFTJOIN";
		
		private var restrictions:ArrayCollection;
		private var aliases:ArrayCollection;
		private var orders:ArrayCollection;
		
		public function HtCriteria()
		{
			restrictions = new ArrayCollection();
			aliases = new ArrayCollection();
			orders = new ArrayCollection();
		}
		
		public function createAlias(associationPath: String, joinType:String = JOINTYPE_INNERJOIN):HtCriteria {
			aliases.addItem(associationPath + ":" + joinType);
			return this;
		}
		
		public function addRestrictions(restrictions:Criterion):HtCriteria {
			this.restrictions.addItem(restrictions);
			return this;
		}
		
		public function addOrder(order:Order):HtCriteria {
			orders.addItem(order);
			return this;
		}
		
		public function clearRestrictions():void {
			restrictions.removeAll();
		}
		
		public function clearAliases():void {
			aliases.removeAll();
		}
		
		public function clearOrders():void {
			orders.removeAll();
		}
		
		public function toString():String {
			var result:String = "";
			for each (var alias:String in aliases) {
				if (result != "") {
					result+=";";
				}
				result+="alias:" + alias;
			}
			for each (var object1:Object in restrictions) {
			  if (result != "") {
				  result+=";";
			  }
			  result+=object1.toString();
			}
			for each (var object2:Object in orders) {
				if (result != "") {
					result+=";";
				}
				result+=object2
					.toString();
			}
			
			return result;
		}
		
	}
}