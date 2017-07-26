package com.gridtt.framework.component.graph.bargraph.asset
{

	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import net.area80.color.ColorUtils;

	public class InfoItem extends Sprite
	{
		public function InfoItem(_color:uint, _name:String)
		{
			super();
			var textFormat:TextFormat = new TextFormat("Helvetica Neue", 12, 0xfcfcfc);
			var tf:TextField = new TextField();
			tf.defaultTextFormat = textFormat;
			tf.text = _name;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = 18;
			tf.y = -tf.height*.5;
			addChild(tf);

			var colors:Array = [_color, ColorUtils.darken(_color, .3)];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x3, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(18, 18, 0, -18*.5, -18*.5);
			//			graphics.lineStyle(1, ColorUtils.darken(barGraphSubData.color, .6));
			graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
//			graphics.drawRoundRect(-18*.5, -18*.5, 18, 18, 4, 4);
			graphics.drawRect(-9, -9, 18, 18);
			graphics.endFill();
		}
	}
}
