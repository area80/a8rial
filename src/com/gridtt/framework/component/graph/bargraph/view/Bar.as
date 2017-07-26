package com.gridtt.framework.component.graph.bargraph.view
{
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphConfig;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphSubData;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.area80.color.ColorUtils;

	public class Bar extends Sprite
	{
		private var barGraphSubData:BarGraphSubData;
		private var config:BarGraphConfig;
		private var main:MainBarGraph;

		private var _height:Number;
		private var fixWidth:Number = 50;
		private var barWidth:Number;

		private var colors:Array;
		private var alphas:Array;
		private var ratios:Array;

		private var textFieldValue:TextField;


		public function Bar($barGraphSubData:BarGraphSubData, $config:BarGraphConfig, $main:MainBarGraph)
		{
			super();
			barGraphSubData = $barGraphSubData;
			config = $config;
			main = $main;
			fixWidth = config.barWidth;
			barWidth = fixWidth-config.paddingBar*2;

			colors = [ColorUtils.brighten(barGraphSubData.color, .2), barGraphSubData.color, ColorUtils.darken(barGraphSubData.color, .3)];
			alphas = [1, 1, 1];
			ratios = [0x09, 0x10, 0xFF];

			textFieldValue = new TextField();
			textFieldValue.defaultTextFormat = new TextFormat("Helvetica Neue", 12, 0xcccccc);
			textFieldValue.text = String(barGraphSubData.value);
			textFieldValue.autoSize = TextFieldAutoSize.LEFT;
			textFieldValue.x = -textFieldValue.width*.5;
			textFieldValue.selectable = false;
			addChild(textFieldValue);


			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);
		}

		protected function over(event:MouseEvent):void
		{
			main.openPopup(barGraphSubData);
		}

		protected function out(event:MouseEvent):void
		{
			main.closePopup();
		}

		override public function set width($value:Number):void
		{
		}

		override public function set height($value:Number):void
		{
			_height = $value;
			var h:Number = _height*(barGraphSubData.value-config.minValue)/(config.maxValue-config.minValue);
			if (h<=0)
				h = 0;

			graphics.clear();

			var matr:Matrix = new Matrix();
			matr.createGradientBox(barWidth, h, 0, -barWidth*.5, -h);
			graphics.lineStyle(1, ColorUtils.darken(barGraphSubData.color, .4));
			graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
			graphics.drawRoundRect(-barWidth*.5, -h, barWidth, h, 0, 0); //8,8
			graphics.endFill();

			textFieldValue.y = -h-textFieldValue.height;
		}

		override public function get width():Number
		{
			return fixWidth;
		}

		override public function get height():Number
		{
			return _height;
		}
	}
}
