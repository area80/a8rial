package com.gridtt.framework.component.graph.bargraph.asset
{

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

//	[Embed(source = "embed/graphAsset.swf", symbol = "majorLine")]
	public class MajorLine extends Sprite
	{
		public var majorText:TextField = new TextField();
		public var value:Number;
		public var percent:Number;

		/**
		 *
		 * @param $value - the real value
		 * @param $percent - percent of this value / (max-min)
		 *
		 */
		public function MajorLine($value:Number, $percent:Number, $color:uint)
		{
			super();
			value = $value;
			percent = $percent;
			var textFormat:TextFormat = new TextFormat("Helvetica Neue", 12, 0x333333);
			majorText.defaultTextFormat = textFormat;
			majorText.text = (($value*100>>0)*0.01).toString();
			majorText.autoSize = TextFieldAutoSize.LEFT;
			majorText.x = -majorText.width-20;
			majorText.y = -majorText.height*.5;
			addChild(majorText);

			mouseEnabled = false;
			mouseChildren = false;

			graphics.lineStyle(2, $color);
			graphics.lineTo(-10, 0);
		}
	}
}
