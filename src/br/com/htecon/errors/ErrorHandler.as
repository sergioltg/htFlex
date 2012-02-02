package br.com.htecon.errors
{
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	
	import org.swizframework.Swiz;

	/**
	 * Classe para tratar o erro FaultEvent
	 * Dispara um evento que pode ser tratado pela aplicacao, caso este evento seja dado um preventDefault, esta classe
	 * considera que a aplicacao tratou o evento, caso contrario mostra o erro ao usuario
	 *
	 */	
	public class ErrorHandler
	{		
		public static const EVENT_FAULT_EVENT:String = "EVENT_FAULT_EVENT";
		
		public static function handleFaultEvent(event:FaultEvent):void {
			// Cria o evento para ser tratado pela aplicacao
			var eventHandler:FaultHandlerEvent = new FaultHandlerEvent(FaultHandlerEvent.FAULT_HANDLER, event, false, true);
			Swiz.dispatchEvent(eventHandler);
			
			// Caso o evento nao foi prevented na aplicacao, mostra a mensagem de erro			
			if (!eventHandler.isDefaultPrevented()) {
				if (event.fault.faultString.indexOf("exception.ConstraintViolationException") != -1) {
					Alert.show("Erro ao tentar excluir o registro. Existem dependências.", "Erro");
				} else {
					Alert.show(event.fault.faultString, "Mensagem");
				}
			}
		}
		
	}
}