package com.gridtt.framework.style
{

	

	public class FontStyle
	{
		public static const FONT_WEIGHT_BOLD:String = "bold";
		public static const FONT_WEIGHT_NORMAL:String = "normal";

		public var fontFamily:String = "Helvetica Neue, Helvetica, Arial, Tahoma";
		public var fontSize:int = 27;
		public var fontWeight:String = "normal";
		public var color:int = 0x333333;
		public var whiteIcon:Boolean = true;
		public var italic:Boolean = false;
		public var embeded:Boolean = false;
		public var embedFont:String = "";
		public var leading:int = 0;

		//public var filters:Array = [];

		public function clone():FontStyle
		{
			var style:FontStyle = new FontStyle();
			style.fontFamily = this.fontFamily;
			style.fontSize = this.fontSize;
			style.fontWeight = this.fontWeight;
			style.leading = this.leading;
			style.embeded = this.embeded;
			style.embedFont = this.embedFont;
			style.color = this.color;
			style.whiteIcon = this.whiteIcon;
			style.italic = this.italic;
			//	style.filters = GridttUtils.cloneArray(this.filters, true);
			return style;
		}
	}
}
