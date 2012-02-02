package br.com.htecon.controls.consulta
{
	import mx.core.UIComponent;
	
	public class HtCampoConsultaItem
	{
		private var _fieldName:String;
		private var _item:UIComponent;
		private var _visible:Boolean;
		public var lastValue:String;
		
		public function HtCampoConsultaItem(field:String, item:UIComponent)
		{
			super();
			_fieldName = field;
			_item = item;
			_visible = true;
		}		
		
	    public function get fieldName():String
	    {
	        return _fieldName;
	    }
	
	    public function set fieldName(value:String):void
	    {
	        _fieldName = value;
	    }
	    
	    public function get item():UIComponent
	    {
	        return _item;
	    }
	
	    public function set item(value:UIComponent):void
	    {
	        _item = value;
	    }
	    
	    public function get visible():Boolean
	    {
	        return _visible;
	    }
	
	    public function set visible(value:Boolean):void
	    {
	        _visible = value;
	    }
	    
	}
}