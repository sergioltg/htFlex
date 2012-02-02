package br.com.htecon.delegate
{
	import br.com.htecon.criteria.HtCriteria;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;
	

	public class BasicDelegate
	{		
		public static var BASIC_REMOTE:String = "basicRemote";
		
		protected var basicService:RemoteObject;
		
		public function BasicDelegate(destination: String = null) {
			basicService = new RemoteObject();
			basicService.destination = destination == null?BASIC_REMOTE:destination;
		}
		
		public function findAll(obj:Object, criteria:HtCriteria = null):AsyncToken
		{
			var criteriaString:String = null;
			if (criteria != null) {
				criteriaString = criteria.toString();
			}
			return basicService.findAll(obj, criteriaString);
		}
		
		public function saveAll(obj:ArrayCollection):AsyncToken
		{
 			return basicService.saveAll(obj);
		}	
		
		public function deleteAll(obj:ArrayCollection):AsyncToken {
			return basicService.deleteAll(obj);			
		}		
		
	}
}