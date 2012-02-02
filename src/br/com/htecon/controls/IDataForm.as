package br.com.htecon.controls
{
	public interface IDataForm
	{
		
		function isValid(): Boolean;
		function focusFirstInvalid():void;
		function clear():void;
		
		function getErrors():String;
		
		function setFocus():void;
		
	}
}