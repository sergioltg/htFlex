package br.com.htecon.controls
{
	import com.adobe.flex.extras.controls.MaskedTextInput;
	
	import flash.events.FocusEvent;
	
	public class HtDateMaskedtInput extends MaskedTextInput
	{
		public function HtDateMaskedtInput()
		{
			super();
			
			inputMask = "DD/MM/YYYY";
			saveMask = true;
		}
		
	}
}