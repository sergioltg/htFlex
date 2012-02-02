package br.com.htecon.controls
{
	import com.farata.controls.DateField;
	
	import mx.controls.DateField;
	import mx.events.CalendarLayoutChangeEvent;
	
	public class HtDateField extends com.farata.controls.DateField
	{
		
		public var _mySelectedDate:Date; 		
		
		public function HtDateField() {
			super();
			
			setStyle("textInputClass", HtDateMaskedtInput);
			
			addEventListener(CalendarLayoutChangeEvent.CHANGE, onChange);
			
			
			yearNavigationEnabled = true;
			formatString = "DD/MM/YYYY";
		}
		
		private  function onChange(e:CalendarLayoutChangeEvent):void{
			if (e.newDate) {
				e.newDate = new Date(e.newDate.fullYearUTC, e.newDate.monthUTC, e.newDate.dateUTC, 12,0,0);  
				selectedDate = e.newDate;  
				//nova linha  
				this.text = mx.controls.DateField.dateToString(e.newDate,"DD/MM/YYYY");
			}
		}  
		
		
		override public function set data(value:Object):void	{
			if (parent is HtDataFormItem) {
				if (HtDataFormItem(parent).dataField != null) {
					HtDataFormItem(parent).data[HtDataFormItem(parent).dataField] = value;
				}
			}
			super.data = value;
		}
		
		override public function set selectedDate(value:Date):void{
			_mySelectedDate = value;  
			super.selectedDate = _mySelectedDate;  
			this.text = mx.controls.DateField.dateToString(_mySelectedDate,"DD/MM/YYYY");			 
		}  
		
		[Bindable("change")]  
		[Bindable("valueCommit")]  
		[Bindable("close")]  
		[Inspectable(category="General")]  
		override public function get selectedDate():Date{
			return _mySelectedDate;  
		}
		
	}
	
	
	
}