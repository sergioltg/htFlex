package br.com.htecon.controls.cadastro
{
	import br.com.htecon.controller.HtDbController;
	import br.com.htecon.controller.events.HtControllerCallBackEvent;
	import br.com.htecon.controls.HtButtonBar;
	import br.com.htecon.controls.IDataForm;
	import br.com.htecon.controls.consulta.HtConsultaBasica;
	import br.com.htecon.data.HtEntity;
	import br.com.htecon.security.HtAuthorization;
	import br.com.htecon.util.ConfirmacaoClass;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;
	
	/**
	 *  Classe para o cadastro Edit, por padrao a segunda pagina de uma tela de consulta, com funcoes de voltar, 
	 *  excluir, e salvar, feito para trabalhar com um registro apenas
	 *  
	 */	
	[ResourceBundle("resourcesHtFlex")]
	public class HtCadastroEdit extends HtCadastroBasico
	{	
		//  Identifica se a entidade ja esta carregada, caso nao o carregamento da entidade no momento de editar sera feito pelas classes filhas, assim que 
		// a entidade estiver carregada, sera executado o iniciaTela
		protected var loadedEntity:Boolean = false;
		
		
		/**
		 *  Retorno do controller
		 *  
		 */
		override protected function controllerHandler(event:HtControllerCallBackEvent):void
		{
			super.controllerHandler(event);
			if (event.action == HtDbController.ACTION_DELETE) {
				Alert.show("Registro excluído com sucesso", "Aviso");
				if (parent is HtConsultaBasica) {
					HtConsultaBasica(parent).consultar();
				}
				voltar();
			} else if (event.action == HtDbController.ACTION_SAVE) {
				if (parent is HtConsultaBasica) {
					HtConsultaBasica(parent).registroSalvo(controller.entity);
				}
			} else if (event.action == HtDbController.ACTION_FIND) {
				// Caso seja lazyEditing, como foi carregado a entidade, chamar o iniciatelaInterno
				trace("htdbcontroller actionfind");
				
				loadedEntity = true;
				iniciaTelaInterno();
			}
		}
		
		override protected function trataBotao(button: String):void {
			super.trataBotao(button);
			switch (button)
			{
				case HtButtonBar.DELETE_BUTTON:
					deletarInterno();
					break;
				case HtButtonBar.NEW_BUTTON:
					novoInterno();
					break;
				case HtButtonBar.BACK_BUTTON:
					voltar();
					break;		
			}			
		}

		override protected function salvar():void {
			if (controller.entity) {
				if (controller.entity.status != HtEntity.HT_STATUS_INSERTED) {
					controller.entity.status = HtEntity.HT_STATUS_UPDATED;
				}
			}
			super.salvar();			
		}
		
		protected function antesDeletar():Boolean
		{
			return true;
		}
		
		protected function depoisNovo():void {
			
		}
		
		protected function antesNovo():Boolean
		{
			return true;
		}
		
		protected function antesEditar():Boolean
		{
			return true;
		}
		

		protected function deletarInterno():void
		{
			if (!HtAuthorization.instance.isInRole(getNameClassSecurity(), HtAuthorization.ROLE_DELETE)) {
				Alert.show("Você não tem permissão para excluir");
				return;
			}			
			
			if (antesDeletar())
			{
				ConfirmacaoClass.open("Deseja excluir o registro?", function():void {deletar()});
			}
		}
		
		protected function deletar():void
		{
			controller.startProcessando();
			controller.deleteRecord();
		}
		

		protected function novoInterno():void
		{
			if (antesNovo())
			{
				novo();
				depoisNovo();
				iniciaTelaInterno();
			}
		}
		
		protected function novo():void
		{
			if (controller) {
				controller.newRecord();
			}
			loadedEntity  = true;   
		}
		
		protected function editarInterno(entity: HtEntity):void {
			loadedEntity = false;
			editar(entity);
			iniciaTelaInterno();
		}
		
		// Esse método será sobrescrito pelas classes filhas quando lazyEditing for utilizado, dando um find na tabela e carregando 
		// a entidade a ser alterada
		protected function editar(entity: HtEntity):void {
			controller.entity = HtEntity(ObjectUtil.copy(entity));
			loadedEntity = true;
		}
		
		protected function voltar():void {
			if (parent is HtConsultaBasica) {
				HtConsultaBasica(parent).showTelaConsulta();				
			}			
		}
		
		override public function passaParametro(psName:String, psValue:Object):void {
			if (psName == "registro") {
				if (psValue == null) {
					novoInterno();
				} else {
					editarInterno(HtEntity(psValue));
				}
			}			
		}
		
		public function showErrosForm(dataForm:IDataForm):void {
			Alert.show(resourceManager.getString("resourcesHtFlex", "errosnoForm") + "\n\n" + dataForm.getErrors(), "Aviso", Alert.OK, null, function():void {dataForm.focusFirstInvalid();});
		}
		
		
		override protected function iniciaTelaInterno():void {
			// So ira chamar o iniciaTelaInterno quando a entidade ja estiver carregada
			if (loadedEntity) {
				super.iniciaTelaInterno();
			}
		}			
		
		
	}
}