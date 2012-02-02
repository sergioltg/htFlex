package br.com.htecon.controls.tree.controls
{
	import mx.controls.CheckBox;
	
	public class CheckBoxIndeterminate extends CheckBox{
		
		private var _indeterminate:Boolean = false;
		
		
		/**
        * Métodos construtor
        * 
        * */
		public function CheckBoxIndeterminate():void{
			setIndeterminate();
		}
		
		 /**
        * Métodos get e set da propriedade indeterminate
        * 
        * @b - Boolean
        * */
		public function set indeterminate(b:Boolean):void{
			this._indeterminate = b;
			setIndeterminate();
		}
		
		public function get indeterminate():Boolean{
			return this._indeterminate;
		}
		
		/**
        * Métodos privado que altera o visual do componente para
        * indeterminate ou volta para o estado normal, dependendo do
        * valor da propriedade indeterminate
        * 
        * */
		private function setIndeterminate():void{
			if (indeterminate){
				this.setStyle('upIcon', CheckBoxIndeterminateIcon);
				this.setStyle('overIcon', CheckBoxIndeterminateIcon);
				this.setStyle('downIcon', CheckBoxIndeterminateIcon);
			}else{
				this.setStyle('upIcon', undefined);
				this.setStyle('overIcon', undefined);
				this.setStyle('downIcon', undefined);
			}
			
		}
		
	}
}