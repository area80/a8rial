package com.gridtt.framework.style
{

	public class ButtonStyle
	{
		public var font:FontStyle = new FontStyle();
		public var fill:FillStyle = new FillStyle();
		public var padding:int = 8;

		public function clone(cloneFill:Boolean = true):ButtonStyle
		{
			var style:ButtonStyle = new ButtonStyle();
			style.font = this.font.clone();
			if (cloneFill)
				style.fill = this.fill.clone();
			style.padding = this.padding;
			return style;
		}

	}
}
