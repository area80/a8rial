package com.gridtt.framework.component.graph.bargraph.asset
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphSubData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

//	[Embed(source = "embed/graphAsset.swf", symbol = "popup")]
	public class Popup extends Sprite
	{
//		public var popupBg:Sprite;
		public var textBox:TextField = new TextField();
//		public var colorTag:Sprite;
		public var barGraphSubData:BarGraphSubData;

		public function Popup($barGraphSubData:BarGraphSubData)
		{
			super();
			barGraphSubData = $barGraphSubData;

//			var ctrns:ColorTransform = new ColorTransform();
//			ctrns.redOffset = ColorUtils.getR(barGraphSubData.color);
//			ctrns.greenOffset = ColorUtils.getG(barGraphSubData.color);
//			ctrns.blueOffset = ColorUtils.getB(barGraphSubData.color);
//			colorTag.transform.colorTransform = ctrns;

			textBox.defaultTextFormat = new TextFormat("Helvetica Neue", 14, 0xfcfcfc);
			textBox.text = barGraphSubData.name+' : '+barGraphSubData.value;
			textBox.autoSize = TextFieldAutoSize.LEFT;
			textBox.y = -28-textBox.height*.5;
			addChild(textBox);
//			popupBg.width = 70+textBox.width;

			graphics.beginFill(0x333333);
			graphics.drawRoundRect(-20, -40, 40+textBox.width, 25, 4, 4);
			graphics.moveTo(0, -10);
			graphics.lineTo(-5, -15);
			graphics.lineTo(5, -15);
			graphics.endFill();

			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}

		protected function initStage(event:Event):void
		{
			scaleX = scaleY = 0;
			TweenLite.to(this, .2, {scaleX: 1, scaleY: 1, ease: Back.easeOut});
		}

	}
}
