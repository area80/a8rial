package com.gridtt.framework.component.graph.bargraph.view
{
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphConfig;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphData;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import net.area80.utils.DrawingUtils;

	public class BarGraphGroup extends Sprite
	{
		private var barGraphData:BarGraphData;

		private var padding_left_right:Number; // percent of 1 group / each side

		private var _width:Number;
		private var _height:Number;

		private var bars:Vector.<Bar> = new Vector.<Bar>();
		private var bg:Sprite;

		public function BarGraphGroup($barGraphData:BarGraphData, $config:BarGraphConfig, $main:MainBarGraph)
		{
			super();
			barGraphData = $barGraphData;
			padding_left_right = $config.paddingGroup;
			if ($barGraphData.i%2==0) {
				bg = DrawingUtils.getRectSprite(100, 100, $config.bgColor1);
			} else {
				bg = DrawingUtils.getRectSprite(100, 100, $config.bgColor2);
			}
			addChild(bg);
			for (var i:uint = 0; i<=barGraphData.subData.length-1; i++) {
				var bar:Bar = new Bar(barGraphData.subData[i], $config, $main);
				addChild(bar);
				bars.push(bar);
			}

			var nameText:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat("Helvetica Neue", 12, 0x333333, true);
			nameText.defaultTextFormat = textFormat;
			nameText.text = barGraphData.name;
			nameText.autoSize = TextFieldAutoSize.LEFT;
			nameText.selectable = false;
			addChild(nameText);


			//set width
			for (i = 0; i<=barGraphData.subData.length-1; i++) {
				bars[i].x = padding_left_right+bars[0].width*i+bars[0].width*.5;
			}
			_width = padding_left_right*2+bars.length*bars[0].width;
			bg.width = _width;
			nameText.y = 10;
			nameText.x = (_width-nameText.width)*.5;
		}

		override public function set width($value:Number):void
		{
		}

		override public function set height($value:Number):void
		{
			_height = $value;
			for (var i:uint = 0; i<=barGraphData.subData.length-1; i++) {
				bars[i].height = _height;
			}
			if (bg) {
				bg.height = _height;
				bg.y = -_height;
			}
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function get height():Number
		{
			return _height;
		}
	}
}
