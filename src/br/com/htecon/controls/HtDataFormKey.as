package br.com.htecon.controls
{
	import com.farata.controls.dataFormClasses.DataFormItem;
	
	import mx.core.ClassFactory;
	
	public class HtDataFormKey extends HtDataForm
	{
		
		private var _classFactory:ClassFactory;
		
		public function set classEntity(value:Class):void {
			_classFactory = new ClassFactory(value);
		}		

		// Return entity with only fields in the form		
		override public function getDataProviderItem():Object {
			var obj:Object = _classFactory.newInstance();
			
			for (var i:int=0; i<items.length; i++)	{
   				obj[DataFormItem(items[i]).dataField] = DataFormItem(items[i]).itemEditor["data"];
   			}			
			
			return obj;
		}		

	}
}