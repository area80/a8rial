package com.gridtt.framework.component.graph.bargraph.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.gridtt.framework.component.graph.bargraph.asset.MajorLine;
	import com.gridtt.framework.component.graph.bargraph.asset.MinorLine;
	import com.gridtt.framework.component.graph.bargraph.asset.Popup;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphConfig;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphDataAll;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphSubData;
	import com.gridtt.framework.ui.BaseUI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import net.area80.utils.DrawingUtils;


	public class MainBarGraph extends BaseUI
	{
		public var contentWidth:Number;

		private var lineContainer:Sprite = new Sprite();
		private var arrowLeft:Sprite;
		private var arrowRight:Sprite;

		private var _width:Number = 500;
		private var _height:Number = 500;

		public var barGraphInfoVO:BarGraphDataAll;
		private var container:BarGraphContainer;
		private var padding_top:Number = 10;
		private var popup:Popup;

		/// move container
		private var maskMc:Sprite;
		private var direction:int = 0;
		private var velocity:Number = 0;
		private const MAX_VELOCITY:Number = 40;

		// line position
		private var numMajor:Number;
		private var numMinor:Number;
		private var majorLine:Vector.<MajorLine> = new Vector.<MajorLine>();
		private var minorLine:Vector.<MinorLine> = new Vector.<MinorLine>();

		private var textNameX:TextField;

		public function MainBarGraph($barGraphInfoVO:BarGraphDataAll, $width:Number, $height:Number, $arrowLeft:Sprite, $arrowRight:Sprite)
		{
			super();
			_width = $width;
			_height = $height;
			arrowLeft = $arrowLeft;
			arrowRight = $arrowRight;

			var startTime:Number = getTimer();
			barGraphInfoVO = $barGraphInfoVO; //new BarGraphDataAll($xml);
			container = new BarGraphContainer(barGraphInfoVO, this);
			addChildAt(container, 0);
			maskMc = DrawingUtils.getRectSprite(400, 400);
			maskMc.y = padding_top;
			addChild(maskMc);
			container.mask = maskMc;
			addChild(lineContainer);

			//axis-x name
			textNameX = new TextField();
			textNameX.defaultTextFormat = new TextFormat("Helvetica Neue", 12, 0x333333);
			textNameX.text = "("+barGraphInfoVO.config.unitX+")";
			textNameX.autoSize = TextFieldAutoSize.LEFT;
			addChild(textNameX);
			//axis-y name
			var textNameY:TextField = new TextField();
			textNameY.defaultTextFormat = new TextFormat("Helvetica Neue", 12, 0x333333);
			textNameY.text = "("+barGraphInfoVO.config.unitY+")";
			textNameY.autoSize = TextFieldAutoSize.LEFT;
			textNameY.x = -textNameY.width;
			textNameY.y = -textNameY.height;
			addChild(textNameY);


			///set line
			var config:BarGraphConfig = barGraphInfoVO.config;
			numMajor = (config.maxValue-config.minValue)/config.majorDiff+1; //+1 for count min line
			numMinor = config.majorDiff/config.minorDiff-1; //-1 for not count max line


			for (var i:uint = 0; i<=numMajor-1; i++) {
				var majorVal:Number = config.minValue+config.majorDiff*i;
				var majorPercent:Number = config.majorDiff*i/(config.maxValue-config.minValue);
				var major:MajorLine = new MajorLine(majorVal, majorPercent, barGraphInfoVO.config.lineColor);
				addChild(major);
				majorLine.push(major);
				if (i!=numMajor-1) {
					for (var j:Number = 1; j<=numMinor; j++) {
						var minorPercent:Number = majorPercent+config.minorDiff*j/(config.maxValue-config.minValue);
						var minor:MinorLine = new MinorLine(minorPercent, barGraphInfoVO.config.lineColor);
						addChild(minor);
						minorLine.push(minor);
					}
				}
			}

//			addInfo();
		}

		protected override function initStage(event:Event):void
		{
			super.initStage(event);
			arrowLeft.addEventListener(MouseEvent.MOUSE_DOWN, moveContainer);
			arrowRight.addEventListener(MouseEvent.MOUSE_DOWN, moveContainer);
		}

		public override function dispose():void
		{
			super.dispose();
			stopContainer();
			removeEventListener(Event.ENTER_FRAME, movingContainer);
			removeEventListener(Event.ENTER_FRAME, followMouse);
		}

		protected override function update(event:Event = null):void
		{
			super.update(event);
			lineContainer.graphics.clear();
			lineContainer.graphics.lineStyle(2, barGraphInfoVO.config.lineColor);
			//draw leftline
			lineContainer.graphics.moveTo(0, 0);
			lineContainer.graphics.lineTo(0, _height);
			//draw bottomline
			lineContainer.graphics.moveTo(0, _height);
			lineContainer.graphics.lineTo(contentWidth+padding_top, _height);

			textNameX.x = contentWidth;
			textNameX.y = _height;
		}


		/**
		 *
		 * move container
		 *
		 */


		protected function moveContainer(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stopContainer);
			var btn:Sprite = Sprite(event.currentTarget);
			if (btn==arrowLeft) {
				direction = 1;
			} else if (btn==arrowRight) {
				direction = -1;
			}
			addEventListener(Event.ENTER_FRAME, movingContainer);
		}

		private function movingContainer(e:Event):void
		{
			velocity += (direction*MAX_VELOCITY-velocity)*.2;
			container.x += velocity;
			if (velocity<.5&&velocity>-.5) {
				removeEventListener(Event.ENTER_FRAME, movingContainer);
				if (container.x>0||container.width<contentWidth) {
					TweenLite.to(container, .2, {x: 0, ease: Quad.easeOut});
				} else if (container.x+container.width<contentWidth) {
					TweenLite.to(container, .2, {x: contentWidth-container.width, ease: Quad.easeOut});
				}
			}
			if (container.x>0) {
				direction = 0;
				velocity *= .3;
			} else if (container.x+container.width<contentWidth) {
				direction = 0;
				velocity *= .3;
			}
		}

		protected function stopContainer(event:MouseEvent = null):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopContainer);
			direction = 0;
		}



		/**
		 *
		 * pooppup
		 *
		 */


		public function openPopup($barGraphSubData:BarGraphSubData):void
		{
			popup = new Popup($barGraphSubData);
			popup.mouseEnabled = false;
			popup.mouseChildren = false;
			addChild(popup);
			followMouse(null);
			addEventListener(Event.ENTER_FRAME, followMouse);
		}

		private function followMouse(e:Event):void
		{
			popup.x = mouseX;
			popup.y = mouseY;
		}

		public function closePopup():void
		{
			removeEventListener(Event.ENTER_FRAME, followMouse);
			removeChild(popup);
			popup = null;
		}



		/**
		 *
		 * width height
		 *
		 */

		override public function set width($value:Number):void
		{
			_width = $value;
			contentWidth = _width;

			maskMc.width = contentWidth;

			if (container.x>0||container.width<contentWidth) {
				container.x = 0;
			} else if (container.x+container.width<contentWidth) {
				container.x = contentWidth-container.width;
			}
			if (container.width<contentWidth) {
				arrowLeft.visible = false;
				arrowRight.visible = false;
				contentWidth = container.width;
			} else {
				arrowLeft.visible = true;
				arrowRight.visible = true;
			}
			invalid();
		}

		override public function set height($value:Number):void
		{
			_height = $value;
			container.height = _height-padding_top;
			container.y = _height;

			maskMc.height = _height+50;

			//////// major line /////////////
			for (var i:uint = 0; i<=numMajor-1; i++) {
				majorLine[i].y = container.height+padding_top-majorLine[i].percent*container.height;
				if (i!=numMajor-1) {
					for (var j:Number = 1; j<=numMinor; j++) {
						var _minorLine:MinorLine = minorLine[((i*numMinor)+j-1)];
						_minorLine.y = container.height+padding_top-_minorLine.percent*container.height;
					}
				}
			}
			invalid();
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
