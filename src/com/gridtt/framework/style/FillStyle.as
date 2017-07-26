package com.gridtt.framework.style
{

	import com.gridtt.framework.util.GridttUtils;

	public class FillStyle
	{
		public static const NONE:int = -1;

		public var cornerRadius:Number = 0;
		public var colorTop:int = 0xFFFFFF;
		public var colorMiddle:int = -1;
		public var colorBottom:int = 0xE6E6E6;
		public var alphaTop:Number = 1;
		public var alphaMiddle:Number = 1;
		public var alphaBottom:Number = 1;
		public var filters:Array = [];

		public function FillStyle()
		{
		}

		public function set color(value:int):void
		{
			colorBottom = value;
			colorMiddle = NONE;
			colorTop = value;
		}

		public function set alpha(value:Number):void
		{
			alphaBottom = value;
			alphaMiddle = value;
			alphaTop = value;
		}

		public function clone():FillStyle
		{
			var style:FillStyle = new FillStyle();
			style.cornerRadius = this.cornerRadius;
			style.colorTop = this.colorTop;
			style.colorMiddle = this.colorMiddle;
			style.colorBottom = this.colorBottom;
			style.alphaTop = this.alphaTop;
			style.alphaMiddle = this.alphaMiddle;
			style.alphaBottom = this.alphaBottom;
			style.filters = GridttUtils.cloneArray(this.filters, true);
			return style;
		}
	}
}
