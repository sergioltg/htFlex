package br.com.htecon.data
{
	public class HtEntity
	{	
		public static const HT_STATUS_INSERTED:String = "I";
		public static const HT_STATUS_UPDATED:String = "U";
		public static const HT_STATUS_DELETED:String = "R";
		
		private var _status:String;
		
		public function get status():String {
			return _status;
		}

		public function set status(value:String):void {
			_status = value;
		}
		
		public function getId():String {
			return null;			
		}
		
		public function get id():String {
			return getId();
		}
		
		public function equals(value:Object):Boolean {
		    var result: Boolean = false;
			if (value is HtEntity && value != null) {
				if (getId() == HtEntity(value).getId()) {
					result = true;
				}		
			}
			
			return result;
		}
		
		public function setId(value:String):void {
			
		}
		
		public function setStatusInsert():void {
			status = HT_STATUS_INSERTED;
		}
		
		public function setStatusUpdate():void {
			status = HT_STATUS_UPDATED;
		}
		
		public function setStatusDelete():void {
			status = HT_STATUS_DELETED;
		}		
		
		
		public function isStatusDelete():Boolean {
			return status == HT_STATUS_DELETED;
		}
		
		public function isStatusInsert():Boolean {
			return status == HT_STATUS_INSERTED;
		}		
		
	}
}