package br.com.htecon.controller
{
	import br.com.htecon.criteria.HtCriteria;
	import br.com.htecon.data.HtEntity;
	import br.com.htecon.delegate.BasicDelegate;
	
	import flash.utils.Endian;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.Swiz;

	public class HtDbController extends HtBasicController
	{
		
		public static var ACTION_SAVE:String = "ACTION_SAVE";
		public static var ACTION_DELETE:String = "ACTION_DELETE";
		public static var ACTION_FIND:String = "ACTION_FIND";
		
		[Bindable]
		private var _data:ArrayCollection;
		
		[Bindable]
		public var _entity:HtEntity;		
		
		private var _basicDelegate:BasicDelegate;
		
		private var _classFactoryfilter:ClassFactory;
		
		public var showMensagemSalvo:Boolean = true;
		
		public var criteria:HtCriteria = new HtCriteria();
		
		public function HtDbController(classEntity: Class = null, delegate:BasicDelegate = null) {
			if (classEntity != null) {
				this.classEntity = classEntity;
			}
			if (delegate != null) {
				basicDelegate = delegate;
			}			
		} 
		
		public function get basicDelegate():* {
			return _basicDelegate;        	
		}
		
		public function set basicDelegate(value:BasicDelegate):void {
			_basicDelegate = value;
		}
		
		public function get data():ArrayCollection {
			return _data;        	
		}
		
		[Bindable(event="changeEntity")]
		[Bindable(event="changeData")]		
		public function set data(value:ArrayCollection):void {
			_data = value;
			dispatchEvent(new Event("changeData"));
			if (value.length > 0) {
				_entity = HtEntity(data.getItemAt(0));
				dispatchEvent(new Event("changeEntity"));				
			}
		}
        
		[Bindable(event="changeEntity")]
		public function set entity(value:HtEntity):void {
			_entity = value;
			_data = new ArrayCollection([value]);
			
			dispatchEvent(new Event("changeEntity"));
		}		

		public function get entity():* {
			return _entity;        	
		}
		
		
		public function getNewEntity():HtEntity {
			return _classFactoryfilter.newInstance();
		}
		
		public function getBasicDelegate():BasicDelegate {
			if (_basicDelegate == null) {
				_basicDelegate = BasicDelegate(Swiz.getBean("basicDelegate"));
			}
			return _basicDelegate;
		}
		
				
		public function find(object:Object):void {
			executeService(ACTION_FIND, getBasicDelegate().findAll(object, criteria), resultFind);			
		}
		
		protected function findByAsyncToken(asynctoken:AsyncToken):void {
			executeService(ACTION_FIND, asynctoken, resultFind);
		}
		
		protected function resultFind(event:ResultEvent):void {
			var arrayData:ArrayCollection = event.result as ArrayCollection;
			
			data = arrayData;
		}		
		
		public function save():void {
			executeService(ACTION_SAVE, getBasicDelegate().saveAll(data), resultSave); 
		}
		
		protected function resultSave(event:ResultEvent):void {
			data = event.result as ArrayCollection;
			
			if (showMensagemSalvo) {
				Alert.show("Dados salvos com sucesso", "Aviso");
			}
		}		
		
		public function deleteRecord(entityDelete:HtEntity = null):void {
			var arrayDelete:ArrayCollection = new ArrayCollection();
			if (entityDelete == null) {
				arrayDelete.addItem(entity);
			} else {
				arrayDelete.addItem(entityDelete);
			}
			executeService(ACTION_DELETE, getBasicDelegate().deleteAll(arrayDelete), resultDelete); 						
		}
		
		protected function resultDelete(event:ResultEvent):void {
		}				
			
		public function newRecord():void {
			var newEnt:HtEntity = getNewEntity();
			newEnt.setStatusInsert();
		    entity = newEnt;
		}		

		public function get classEntity():Class
		{
			return _classFactoryfilter.generator;
		}

		public function set classEntity(value:Class):void
		{
			_classFactoryfilter = new ClassFactory(value);
		}

		
	}
}