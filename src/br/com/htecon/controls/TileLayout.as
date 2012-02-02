package br.com.htecon.controls
{
	import mx.containers.utilityClasses.BoxLayout;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;

	public class TileLayout extends BoxLayout
	{

		private var cellWidth:Number;

		/**
		 *  @private
		 *  Cached value from findCellSize() call in measure(),
		 *  so that updateDisplaylist() doesn't also have to call findCellSize().
		 */
		private var cellHeight:Number;

		private var _tileHeight:Number;

		[Bindable("resize")]
		[Inspectable(category="General")]

		/**
		 *  Height of each tile cell, in pixels.
		 *  If this property is <code>NaN</code>, the default, the height
		 *  of each cell is determined by the height of the tallest child.
		 *  If you set this property, the specified value overrides
		 *  this calculation.
		 *
		 *  @default NaN
		 */
		public function get tileHeight():Number
		{
			return _tileHeight;
		}

		/**
		 *  @private
		 */
		public function set tileHeight(value:Number):void
		{
			_tileHeight=value;

			target.invalidateSize();
		}


		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public function TileLayout()
		{
			super();
		}


		public function findCellSize():void
		{
			// If user explicitly supplied both a tileWidth and
			// a tileHeight, then use those values.
			var heightSpecified:Boolean=!isNaN(tileHeight);
			if (heightSpecified)
			{
				cellHeight=tileHeight;
				return;
			}

			// Reset the max child width and height
			var maxChildHeight:Number=0;

			// Loop over the children to find the max child width and height.
			var n:int=target.numChildren;
			for (var i:int=0; i < n; i++)
			{
				var child:IUIComponent=IUIComponent(target.getChildAt(i));

				if (!child.includeInLayout)
					continue;

				var height:Number=child.getExplicitOrMeasuredHeight();
				if (height > maxChildHeight)
					maxChildHeight=height;
			}

			// If user explicitly specified either width or height, use the
			// user-supplied value instead of the one we computed.
			cellHeight=heightSpecified ? tileHeight : maxChildHeight;
		}

		/**
		 *  @private
		 *  Assigns the actual size of the specified child,
		 *  based on its measurement properties and the cell size.
		 */
		private function setChildSize(child:IUIComponent):void
		{
			var childWidth:Number;
			var childHeight:Number;
			var childPref:Number;
			var childMin:Number;

			if (child.percentWidth > 0)
			{
				// Set child width to be a percentage of the size of the cell.
				childWidth=Math.min(cellWidth, cellWidth * child.percentWidth / 100);
			}
			else
			{
				// The child is not flexible, so set it to its preferred width.
				childWidth=child.getExplicitOrMeasuredWidth();

				// If an explicit tileWidth has been set on this Tile,
				// then the child may extend outside the bounds of the tile cell.
				// In that case, we'll honor the child's width or minWidth,
				// but only if those values were explicitly set by the developer,
				// not if they were implicitly set based on measurements.
				if (childWidth > cellWidth)
				{
					childPref=isNaN(child.explicitWidth) ? 0 : child.explicitWidth;

					childMin=isNaN(child.explicitMinWidth) ? 0 : child.explicitMinWidth;

					childWidth=(childPref > cellWidth || childMin > cellWidth) ? Math.max(childMin, childPref) : cellWidth;
				}
			}

			if (child.percentHeight > 0)
			{
				childHeight=Math.min(cellHeight, cellHeight * child.percentHeight / 100);
			}
			else
			{
				childHeight=child.getExplicitOrMeasuredHeight();

				if (childHeight > cellHeight)
				{
					childPref=isNaN(child.explicitHeight) ? 0 : child.explicitHeight;

					childMin=isNaN(child.explicitMinHeight) ? 0 : child.explicitMinHeight;

					childHeight=(childPref > cellHeight || childMin > cellHeight) ? Math.max(childMin, childPref) : cellHeight;
				}
			}

			child.setActualSize(childWidth, childHeight);
		}

		/**
		 *  @private
		 *  Compute how much adjustment must occur in the x direction
		 *  in order to align a component of a given width into the cell.
		 */
		public function calcHorizontalOffset(width:Number, horizontalAlign:String):Number
		{
			var xOffset:Number;

			if (horizontalAlign == "left")
				xOffset=0;

			else if (horizontalAlign == "center")
				xOffset=(cellWidth - width) / 2;

			else if (horizontalAlign == "right")
				xOffset=(cellWidth - width);

			return xOffset;
		}

		/**
		 *  @private
		 *  Compute how much adjustment must occur in the y direction
		 *  in order to align a component of a given height into the cell.
		 */
		public function calcVerticalOffset(height:Number, verticalAlign:String):Number
		{
			var yOffset:Number;

			if (verticalAlign == "top")
				yOffset=0;

			else if (verticalAlign == "middle")
				yOffset=(cellHeight - height) / 2;

			else if (verticalAlign == "bottom")
				yOffset=(cellHeight - height);

			return yOffset;
		}

		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			// The measure function isn't called if the width and height of
			// the Tile are hard-coded. In that case, we compute the cellWidth
			// and cellHeight now.
			if (isNaN(cellWidth) || isNaN(cellHeight))
				findCellSize();

			var vm:EdgeMetrics=target.viewMetricsAndPadding;

			var paddingLeft:Number=target.getStyle("paddingLeft");
			var paddingTop:Number=target.getStyle("paddingTop");

			var horizontalGap:Number=target.getStyle("horizontalGap");
			var verticalGap:Number=target.getStyle("verticalGap");

			var horizontalAlign:String=target.getStyle("horizontalAlign");
			var verticalAlign:String=target.getStyle("verticalAlign");

			var xPos:Number=paddingLeft;
			var yPos:Number=paddingTop;

			var xOffset:Number;
			var yOffset:Number;

			var n:int=target.numChildren;
			var i:int;
			var child:IUIComponent;

			var xEnd:Number=Math.ceil(unscaledWidth) - vm.right;

			for (i=0; i < n; i++)
			{
				child=IUIComponent(target.getChildAt(i));

				if (!child.includeInLayout)
					continue;

				if (child.percentWidth > 0)
				{
					cellWidth=(xEnd - xPos) * child.percentWidth / 100 - 1;
					child.width=cellWidth;
				}
				else
				{
					cellWidth=child.width;
				}

				// Calculate the offsets to align the child in the cell.
				xOffset=Math.floor(calcHorizontalOffset(child.width, horizontalAlign));
				yOffset=Math.floor(calcVerticalOffset(child.height, verticalAlign));

				child.move(xPos + xOffset, yPos + yOffset);

				xPos+=(cellWidth + horizontalGap);

				if (child is HtDataFormItem)
				{
					if ((child as HtDataFormItem).breakLine)
					{
						yPos+=(cellHeight + verticalGap);
						xPos=paddingLeft;
					}
				}
			}

			// Clear the cached cell size, because if a child's size changes
			// it will be invalid. These cached values are only used to
			// avoid recalculating in updateDisplayList() the same values
			// that were just calculated in measure().
			// They should not persist across invalidation/validation cycles.
			// (An alternative approach we tried was to clear these
			// values in an override of invalidateSize(), but this gets called
			// called indirectly by setChildSize() and child.move() inside
			// the loops above. So we had to save and restore cellWidth
			// and cellHeight around these calls in the loops, which is ugly.)
			cellWidth=NaN;
			cellHeight=NaN;
		}

	}
}