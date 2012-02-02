package br.com.htecon.security
{
	import mx.collections.ArrayCollection;

	public class HtAuthorization
	{
		
		public static const instance:HtAuthorization = new HtAuthorization();
		
		public static const ROLE_SAVE:String = "SALVAR";
		public static const ROLE_DELETE:String = "EXCLUIR";
		
		public var active:Boolean = false;
		
		private var roles:ArrayCollection = new ArrayCollection();
		
		public function HtAuthorization()
		{
		}
		
		public function setRole(object:String, role:String):void {
			roles.addItem(object + ";" + role);			
		}
		
		public function clearRoles():void {
			roles.removeAll();
		}
		
		public function isInRole(object:String, role:String):Boolean {
			if (!active) {
				return true;
			}
			for each (var item:String in roles) {
				var itens:Array = item.split(";");
				if (itens[0] == object && itens[1] == role) {
					return true;				
				}
			}
			return false;
		}		
		
	}
}