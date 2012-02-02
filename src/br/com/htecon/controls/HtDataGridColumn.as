package br.com.htecon.controls
{
	import com.farata.controls.dataGridClasses.DataGridColumn;
	
	public class HtDataGridColumn extends DataGridColumn
	{
		
		private var nestedDatafield:String;
		public var sortAs:String = "";
		
		public function HtDataGridColumn(columnName:String = null) {
			super();
			
			sortCompareFunction = mySortCompareFunction;
			
			if (columnName)
			{
				if (columnName.indexOf(".") != -1) {
					nestedDatafield = columnName;					
				} else {
					dataField = columnName;
				}
				headerText = columnName;
				
			}
		}
		
		override public function itemToLabel(data:Object):String
		{
			if (nestedDatafield)
			{ 
				var currentData:Object = getNestedData(data, getFields());
				if (currentData == null) {
					currentData = "";
				}
				var label:String;
				if (currentData is String)
					label = String(currentData);
				
				try
				{
					label = currentData.toString();
				}
				catch(e:Error)
				{
					return "";
				}
				
				return label;
			}
			
			return super.itemToLabel(data);
		}
		
		
		protected function getNestedData( data:Object, fields:Array):Object 
		{
			if (data) {
				for each(var f:String in fields){
					data = data[f];
					if (data == null) {
						break;
					}
				}
			}
			return data;
		}
		
		protected function getFields():Array {
			var dataFieldSplit:String = nestedDatafield?nestedDatafield:dataField;
			return dataFieldSplit.split(".");			
		}
				
		private function mySortCompareFunction(obj1:Object, obj2:Object):int{  
			var fields:Array = getFields();			
			var currentData1:Object = getNestedData(obj1, fields);  
			var currentData2:Object = getNestedData(obj2, fields);
			
			if ( !currentData1 && !currentData2 )
				return 0;
			
			if ( !currentData1 )
				return 1;
			
			if ( !currentData2 )
				return -1;
			
			if (sortAs == "int") {
				if (currentData1 is String) {
					currentData1 = parseInt(String(currentData1));
				}
				if (currentData2 is String) {
					currentData2 = parseInt(String(currentData2));
				}
			}
			
			if(currentData1 is int && currentData2 is int){  
				var int1:int = int(currentData1);  
				var int2:int = int(currentData2);  
				return (int1>int2)?-1:1;  
			}
			if(currentData1 is Number && currentData2 is Number){  
				var num1:Number = Number(currentData1);  
				var num2:Number = Number(currentData2);  
				return (num1>num2)?-1:1;  
			}
			if(currentData1 is String && currentData2 is String){  
				currentData1 = String(currentData1);  
				currentData2 = String(currentData2);  
				return (currentData1>currentData2)?-1:1;  
			}  
			if(currentData1 is Date && currentData2 is Date){  
				var date1:Date = currentData1 as Date;  
				var date2:Date = currentData2 as Date;  
				var date1Timestamp:Number = currentData1.getTime();  
				var date2Timestamp:Number = currentData2.getTime();  
				return (date1Timestamp>date2Timestamp)?-1:1;  
			}  
			
			return 0;  
		}      		
				

	}
}