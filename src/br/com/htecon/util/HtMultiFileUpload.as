package br.com.htecon.util
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	[Event(name="uploadCompleted", type="flash.events.Event")]
	public class HtMultiFileUpload implements IEventDispatcher
	{
		
		private var dispatcher:EventDispatcher;
		
		private var processando:Processando;
		
		private var _items:ArrayCollection;
		private var _file:FileReference;
		private var _uploadURL:URLRequest;
		private var _variables:URLVariables;
		private var _campoNmArquivo: String;
		private var _campoFile: String;
		private var _index: int;
		
		public function set items(lista: ArrayCollection):void {
			_items = lista;
		}
		
		public function get items():ArrayCollection {
			return _items;
		}
		
		public function upload(url:String = "ServletUpload"):void {
			
			processando = Processando.show("Enviando arquivo", false);
			
			_variables = new URLVariables();
			
			_uploadURL = new URLRequest;
			_uploadURL.url = url;
			_uploadURL.method = URLRequestMethod.POST;
			
			_uploadURL.data = _variables;
			_uploadURL.contentType = "multipart/form-data; charset=iso-8859-1";
			
			_index = 0;
			
			uploadFiles();		
			
		}
		
		public function HtMultiFileUpload()
		{
			dispatcher = new EventDispatcher();			
		}
		
		private function uploadFiles():void{
			if (_index < _items.length){
				_file = FileReference(_items.getItemAt(_index)[campoFile]);
				if (_file != null) {
					_variables.nmArquivo = escape(_file.name);		
					_file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
					_file.addEventListener(Event.COMPLETE, completeHandler);
					_file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
					_file.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
					_file.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteHandler);
					_file.upload(_uploadURL);
				} else {
					_index++;
					uploadFiles();					
				}
			} else {
				processando.close();
				var uploadCompleted:Event = new Event("uploadCompleted");
				dispatchEvent(uploadCompleted);				
			}
		}
		
		private function progressHandler(event:ProgressEvent):void {
			processando.setText("Enviando arquivo " + (_index + 1) + ": " + event.bytesLoaded + " de " + event.bytesTotal);
			processando.setProgress(event.bytesLoaded / event.bytesTotal * 100, 100);
		}
		
		private function completeHandler(event:Event):void{
		
		}
		
		private function uploadCompleteHandler(event:DataEvent):void {
			_items.getItemAt(_index)[_campoNmArquivo] = event.data;
			_index++;
			uploadFiles();
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void{
			//trace("securityErrorHandler: " + event);
			processando.close();
			Alert.show(String(event),"Security Error",0);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			if (event.status != 200){
				processando.close();				
				Alert.show(String(event),"Error",0);
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void{
			//trace('And IO Error has occured:' +  event);
			processando.close();			
			mx.controls.Alert.show(String(event),"ioError",0);
		}

		public function get campoFile():String
		{
			return _campoFile;
		}

		public function set campoFile(value:String):void
		{
			_campoFile = value;
		}

		public function get campoNmArquivo():String
		{
			return _campoNmArquivo;
		}

		public function set campoNmArquivo(value:String):void
		{
			_campoNmArquivo = value;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}		
		
		public function dispatchEvent(evt:Event):Boolean{
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);			
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}		
		
	}
}