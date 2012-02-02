package br.com.htecon.controls.tree.controls
{
	import mx.skins.halo.CheckBoxIcon;
	
	public class CheckBoxIndeterminateIcon extends CheckBoxIcon{
		
		
		 /**
        * Método sobrescrito para desenhar o quadrado no meio do CheckBox.
        * Chamado diretamente pela API do Flex.
        * 
        * @w - Largura
        * @h - Altura
        * */
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			
			drawRoundRect(
				3, 3, w - 6, h - 6, 0,
				[ 0x666666, 0x666666 ], [ 0xFFFFFF, 0xFFFFFF ],
				verticalGradientMatrix(1, 1, w - 2, h - 2)); 
			
		}
		
	}
	
}