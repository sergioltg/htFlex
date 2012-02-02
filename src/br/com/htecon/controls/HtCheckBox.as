package br.com.htecon.controls
{
	import com.farata.printing.pdf.xdp.IXdpObject;
	import com.farata.printing.pdf.xdp.XdpUtil;
	import com.farata.resources.ResourceBase;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.CheckBox;
	import mx.controls.listClasses.BaseListData;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;

	use namespace mx_internal;

	public class HtCheckBox 
		extends mx.controls.CheckBox 
		implements IXdpObject {

		private var allow3rdState:Boolean=false;
		private var _3rdState:Boolean=false;
		public var onValue:Object=true;
		public var offValue:Object=false;
		private var _value:*;
		public var updateable:Boolean = true;

	public function HtCheckBox() {
		super();
		addEventListener(MouseEvent.CLICK, onClick);
		addEventListener(Event.CHANGE, onChange);
	}

	private function onClick (event:MouseEvent):void {
		dispatchEvent(new Event(Event.CHANGE));
	}

	private function onChange(event:Event):void {
 		if (listData && listData.hasOwnProperty("columnIndex")) {
 			// convenience: some people tend to forget rendererIsEditor :)
 			var dg:Object = listData.owner;
 			if(!dg)
 				return;
 			var columns:Array = dg["columns"] as Array;

 			if(!columns)
 				return;

 			var dgc:Object = columns[listData["columnIndex"]];

 			if(!dgc)
 				return;
 			if (dgc.editable)
 				dgc.rendererIsEditor = true;
 			// data
  			data[listData["dataField"]] = value;
			var evt:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.UPDATE, -1, -1, [data]);

			if(listData.owner && listData.owner["dataProvider"])
				listData.owner["dataProvider"].dispatchEvent(evt);
			dispatchEvent(new FlexEvent (FlexEvent.VALUE_COMMIT));
 		}
	}

		public function set text(o:Object):void {
			value = o;
		}
		public function get text():Object {
			return value;
		}

	    [Bindable("valueCommit")]
		public function set value(val:*) :void {
			_value = val;
			invalidateProperties();
			dispatchEvent(new FlexEvent (FlexEvent.VALUE_COMMIT));
		}
		
		public function get value():Object  {
			_value = (allow3rdState && _3rdState)?undefined:selected?onValue:offValue;
		   return (allow3rdState && _3rdState)?undefined:selected?onValue:offValue;
		}
		
		override protected function commitProperties():void {
			if (_value!==undefined)
				selected = (_value == onValue);
			  _3rdState = _value == undefined;
			super.commitProperties();
		}

	    [Bindable("dataChange")]
		override public function set data(item:Object):void {
			if( item!=null && listData.hasOwnProperty("dataField"))
			{
				value = item[listData["dataField"]];
				label = "";
			}
			super.data = item;
		}

		override public function set listData(value:BaseListData):void {
			super.listData = value;
		}
		
 		/**
	     *  @private
    	 */
	    override protected function keyDownHandler(event:KeyboardEvent):void {
	        if (!updateable)
	            return;
	         super.keyDownHandler(event);
	    }
	    
      	override protected function keyUpHandler(event:KeyboardEvent):void {
	        if (!updateable)
	            return;
	        super.keyUpHandler(event);
	    }

	    override protected function mouseDownHandler(event:MouseEvent):void {
        	if (!updateable)
            	return;
	        super.mouseDownHandler(event);
    	}

    	override protected function mouseUpHandler(event:MouseEvent):void {
	        if (!updateable)
	            return;
	
	        super.mouseUpHandler(event);
	    }
	    
	    override protected function clickHandler(event:MouseEvent):void {
	        if (!updateable)
	            return;
	
	        super.clickHandler(event);
	    }
	
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void {
	
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (currentIcon) {
				var style:String = getStyle("textAlign");
				if ((!label) && (style=="center") ) {
					currentIcon.x = (unscaledWidth - currentIcon.measuredWidth)/2;
				}
				currentIcon.visible = !(allow3rdState &&_3rdState);
			}
		}
/*
	 	mx_internal override function setSelected(newValue:Boolean):void {
	    	if (selected != newValue) {
	    		super.setSelected(newValue);
	    		value = selected?onValue:offValue;
	    	}
	    }
*/
		private var _resource:Object;
		public function get resource():Object
		{
			return _resource;
		}

		public function set resource(value:Object):void {
			_resource = value;
			var objInst:*  = ResourceBase.getResourceInstance(value);
			if(objInst)
				objInst.apply(this);
		}

		////////////////////////////////////////////////////////////////////////////
		// IXdpObject
		public  function get xdpContent():Object {
			var bandId:String = null;
			if (parent.hasOwnProperty("bandId")) {
				bandId = parent["bandId"];
			}
			var o:XML =    
			<field  x={convert(x)} w={convert(width)} h={convert(height)}>
	            <ui>
	               <checkButton  allowNeutral="1">
	                  <border>
	                     <edge stroke="lowered"/>
	                     <fill/>
	                  </border>
	               </checkButton>
	            </ui>
	            <value>
	               <text>{value}</text>
	            </value>
	             <para vAlign="middle" hAlign="center"/>
	
	            <items>
	               <text>{onValue}</text>
	               <text>{offValue}</text>
	               <text></text>
	            </items>
	            <caption placement="bottom"/>
	           <border>
	                 <!--fill>
	                    <color value={rgb(getStyle("backgroundColor"))}/>
	                 </fill-->
	                 <edge presence="hidden"/>
	                 <edge presence={ (bandId =="H" || bandId =="D")?"visible":"hidden"}/>
	                 <edge presence="hidden"/>
	                 <edge presence="hidden"/>
	              </border>
	         </field>;
			/*
			o = applyStdData(o);
			typeface={getStyle("fontFamily")+"pt"}
			for each(var cell:XdpBaseObject in cells) {
				o.appendChild(cell.xdpContent);
			}
			*/
			return o;
		}
	
		private function convert(value:Number) : String {
			return  XdpUtil.px2pt(value) + "pt";
		}

	}

}
