package br.com.htecon.controls.tree.renderers
{
	import br.com.htecon.controls.tree.controls.CheckBoxIndeterminate;
	
	import flash.events.Event;
	
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.utils.ObjectUtil;
	
	public class CheckIndeterminateTreeItemRenderer extends TreeItemRenderer{
		
		 /**
        * Instância do CheckBoxIndeterminate
        * */
		private var check:CheckBoxIndeterminate;
		
		/**
        * Constante de espaço entre o check, icon e label
        * */
		private const SPACE:Number = 17;
		
		/**
        * Propriedade que determina se o check está selecionado
        * */
		private var selected:Boolean = false;
		
		
		 /**
        * Método construtor
        * 
        * */
        
        public function CheckIndeterminateTreeItemRenderer() {
            super();
        }
        
         /**
        * Método sobrescrito da classe mx.controls.treeClasses.TreeItemRenderer
        * para retirar os ícones padrões do Tree e setar a proprieade data.
        * 
        * Esse método é chamado pela API de itemRenderer do Flex
        * 
        * @value - Object
        * */
        
        override public function set data(value:Object):void {
            super.data = value;
        }
     
       /**
        * Método sobrescrito da classe mx.controls.treeClasses.TreeItemRenderer
        * para adicionar a criação do CheckBoxIndeterminate
        * 
        * */
     
       override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if(super.data) {
                	
                    super.label.text =  TreeListData(super.listData).label;
                    
                    var node:XMLList = new XMLList(TreeListData(super.listData).item);
                    
                    //esses ifa foram necessários, pois não foi possivel fazer algum tipo de cast
                    //TODO: verificar novamente o cast
                    
                    var sel:Boolean = false;
                    if (node[0].@selected == "true"){
                    	sel = true;
                    }
                    var ind:Boolean = false;
                    if (node[0].@indeterminate == "true"){
                    	ind = true;
                    }
                    
                    this.check.indeterminate = ind;
                    this.check.selected = sel;
					this.check.y = height / 2 - this.check.height / 2;
					if (super.icon) {
	                    this.check.x = super.icon.x;
	                    
	                    super.icon.x = this.check.x + this.check.width + SPACE;
	                    super.label.x = super.icon.x + SPACE;
					} else {
						this.check.x = super.disclosureIcon.x;
						
						super.disclosureIcon.x = this.check.x + this.check.width + SPACE;
						super.label.x = super.disclosureIcon.x + SPACE;						
					}						
                 
            }
        }
        
        /**
        * Método sobrescrito da classe mx.controls.treeClasses.TreeItemRenderer
        * para adicionar a criação do CheckBoxIndeterminate
        * 
        * */
        
        override protected function createChildren():void{
        	super.createChildren();	
        	
        	check = new CheckBoxIndeterminate();
        	check.addEventListener("click", checkBoxClick);
        	addChild(check);
        	
        }
        
         /**
        * Método que trata o evento click do CheckBoxIndeterminate
        * 
        * @param event - flash.events.Event
        * */
        
        private function checkBoxClick(event:Event):void{
        	
        	var node:XMLList = new XMLList(TreeListData(super.listData).item);
            //atualiza o proprio checkBox
            node[0].@selected = String(event.currentTarget.selected);
            
            //caso nao tem filho nao seta indeterminate
            //caso contario da problema ao descelecionar nos pais com nivel > q 2
            if (node.children().length()){
	            node[0].@indeterminate = String(event.currentTarget.selected);
            }
            
            //atualiza todo o Tree
            recursiveCheck(node.children(),event.currentTarget.selected);
            recursiveIndeterminate(XMLList(node.parent()));
            
        }
        
         /**
        * Método seleciona e desseleciona os nos de forma recursiva
        * 
        * @param none - XMLList
        * @param selected - Boolen
        * */
        
        private function recursiveCheck(node:XMLList, selected:Boolean):void{
        	for each (var prop:XML in node) {
        		prop.@selected = selected;
        		
        		//se setar invalidate no ultimo no ele fica nesse estavo no selected false
        		if (prop.children().length()){
        			prop.@indeterminate = selected;
        		}
        		recursiveCheck(prop.children(),selected);
        	}
        }
        
        /**
        * Método que seta se os nos pais precisam estar com o estado indeterminate
        * 
        * @param none - XMLList
        * */
        
        private function recursiveIndeterminate(node:XMLList):void{
        	var obj:Object;
        	
        	//pode ser um no que nao tem pai, como o 1o
        	if (node.children().length()){
        		
        		obj = calculateNodes(node);
        	
        		//condicoes para setar o indeterminate
	        	if (node.children().length() == obj.trueCount){
	        		node.@selected = true;
	        		node.@indeterminate = false;
	        	}else if (node.children().length() == obj.falseCount){
	        		node.@selected = false;
	        		//se nao tiver nenhum indeterminate é pa não existe nenhum
	        		//nó abaixo checado
	        		if (obj.indeterminateCount){
	        			node.@indeterminate = true;
	        		}else{
	        			node.@indeterminate = false;
	        		}
	        	}else{
	        		node.@selected = false;
	        		node.@indeterminate = true;
	        	}
        		recursiveIndeterminate(XMLList(node.parent()));
        	}
        }
        
        /**
        * Método que calcula  o numero de nos filhos true, false de indeterminate 
        * de um determinda no
        * 
        * @param none - XMLList
        * */
        
        private function calculateNodes(node:XMLList):Object{
        	var obj:Object = new Object();
        	obj.falseCount = 0;
        	obj.trueCount = 0;
        	obj.indeterminateCount = 0;
        	
        	
        	//conta o numero de nos false, true e indeterminate
        	for each (var prop:XML in node.children()) {
        		if (prop.@selected == "false" || prop.@selected == undefined){
        			obj.falseCount = obj.falseCount + 1;
        		}else{
        			obj.trueCount = obj.trueCount + 1;
        		}
        		
        		if (prop.@indeterminate == "true"){
        			obj.indeterminateCount = obj.indeterminateCount + 1;
        		}
        	}
        	
        	return obj;
        }
        
        
        
        
        
        
        
        
        /**
        * Método que seta se os nos pais precisam estar com o estado indeterminate
        * 
        * @param none - XMLList
        * */
        
        private function recursiveIndeterminateDown(node:XMLList):void{
        	
        	
        	
        	for each (var prop:XML in node) {
        		prop.@selected = selected;
        		
        		
	        	var obj:Object;
	        	
	        	//pode ser um no que nao tem pai, como o 1o
	        	if (prop.children().length()){
	        		
	        		obj = calculateNodes(node);
	        	
	        		//condicoes para setar o indeterminate
		        	if (prop.children().length() == obj.trueCount){
		        		prop.@selected = true;
		        		prop.@indeterminate = false;
		        	}else if (prop.children().length() == obj.falseCount){
		        		prop.@selected = false;
		        		//se nao tiver nenhum indeterminate é pa não existe nenhum
		        		//nó abaixo checado
		        		if (obj.indeterminateCount){
		        			prop.@indeterminate = true;
		        		}else{
		        			prop.@indeterminate = false;
		        		}
		        	}else{
		        		prop.@selected = false;
		        		prop.@indeterminate = true;
		        	}
	        		recursiveIndeterminate(prop.children());
	        	}
	        }
        }
    }
}