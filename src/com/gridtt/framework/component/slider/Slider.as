package com.gridtt.framework.component.slider
{

	import com.gridtt.framework.GridttFramework;
	import com.gridtt.framework.theme.BootstrapTheme;
	import com.gridtt.framework.theme.Theme;
	import com.gridtt.framework.ui.BaseUI;
	import com.gridtt.framework.ui.Button;
	import com.gridtt.framework.ui.Label;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	/**
	 * Dispatchs when slider value is changed.
	 * @eventType com.gridtt.framework.component.slider.SliderEvent
	 */
	[Event(name = "change", type = "com.gridtt.framework.component.slider.SliderEvent")]

	/**
	 * Dispatchs when slider is pressed.
	 * @eventType com.gridtt.framework.component.slider.SliderEvent
	 */
	[Event(name = "press", type = "com.gridtt.framework.component.slider.SliderEvent")]

	/**
	 * Dispatchs when slider is released.
	 * @eventType com.gridtt.framework.component.slider.SliderEvent
	 */
	[Event(name = "release", type = "com.gridtt.framework.component.slider.SliderEvent")]

	public class Slider extends BaseUI
	{


		private var theme:Theme;
		private var _width:Number = 300;
		private var bar:Sprite;
		private var dragger:Sprite;
		private var leftLabel:Label;
		private var rightLabel:Label;
		private var PADDING:int = 40;
		private var bg:Sprite;
		private var _showNumbers:Boolean = true;

		private var tstep:int = 0;
		private var cstep:int = 0;
		private var min:Number;
		private var max:Number;
		private var step:Number;
		private var hintBtn:Button;
		private var _height:Number = 10;

		private var isDown:Boolean;
		private var isOver:Boolean;
		private var _value:Number = 0;


		public function Slider(min:Number, max:Number, step:Number)
		{
			super(true, 20);

			tstep = Math.floor((max - min) / step)

			this.min = min;
			this.max = this.min + (tstep * step);
			this.step = step;

			_value = min;

			if (!GridttFramework.theme)
				GridttFramework.theme = new BootstrapTheme();

			if (GridttFramework.theme.isRatina)
				PADDING *= 2;

			theme = GridttFramework.theme;

			bg = new Sprite();
			bg.filters = theme.fill_well.filters;
			addChild(bg);

			bg.addEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);

			leftLabel = new Label(String(this.min), theme.font_normal_dark);
			leftLabel.resizeMode = Label.RESIZE_AUTO;
			leftLabel.registerationPoint = "center";
			leftLabel.align = "center";
			rightLabel = new Label(String(this.max), theme.font_normal_dark);
			rightLabel.resizeMode = Label.RESIZE_AUTO;
			rightLabel.registerationPoint = "center";
			rightLabel.align = "center";
			
			addChild(leftLabel);
			addChild(rightLabel);

			dragger = new Sprite();
			dragger.filters = theme.fill_white.filters;
			addChild(dragger);
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, outHandler);

			hintBtn = new Button(theme.button_inverse, String(this.min), Button.ALIGN_CENTER);
			addChild(hintBtn).name = "hintbtn";
			hintBtn.visible = false;

			updateDraggerToRatio(0);
			update();
		}

		protected function overHandler(event:MouseEvent):void
		{
			isOver = true;
			hintBtn.visible = true;
		}

		protected function outHandler(event:MouseEvent):void
		{
			isOver = false;
			if (!isDown && !isOver)
				hintBtn.visible = false;
		}

		protected function barDownHandler(event:MouseEvent):void
		{
			isDown = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updateDragger);
			stage.addEventListener(MouseEvent.MOUSE_UP, clearUpdate);
			updateDragger();


			dispatchEvent(new SliderEvent(SliderEvent.PRESS, value));
		}

		protected function clearUpdate(event:MouseEvent = null):void
		{

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateDragger);
			stage.removeEventListener(MouseEvent.MOUSE_UP, clearUpdate);

			if (isDown) {
				dispatchEvent(new SliderEvent(SliderEvent.RELEASE, value));
			}

			isDown = false;
			if (!isDown && !isOver)
				hintBtn.visible = false;
		}

		override public function dispose():void
		{
			clearUpdate();
			super.dispose();
		}


		private function updateDragger(event:MouseEvent = null):void
		{
			hintBtn.visible = true;
			var padd:Number = (_showNumbers) ? PADDING : 0;
			var ratio:Number = Math.max(0, Math.min(_width - padd * 2, mouseX - padd)) / (_width - padd * 2);
			updateDraggerToRatio(ratio);
		}

		public function get showNumbers():Boolean
		{
			return _showNumbers;
		}

		private function updateDraggerToRatio(ratio:Number, dispatch:Boolean = true):void
		{
			var padd:Number = (_showNumbers) ? PADDING : 0;
			dragger.x = padd + (_width - padd * 2) * ratio;

			var v:Number = Math.floor((min + Math.round(tstep * ratio) * step) * 1000) / 1000;
			hintBtn.x = dragger.x;

			if (_value != v) {
				_value = v;
				hintBtn.text = String(_value);
				if (dispatch)
					dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value));
			}
		}

		public function setValueWithoutDispatch(value:Number):void
		{
			var ratio:Number = (value - min) / (max - min);
			updateDraggerToRatio(Math.max(0, Math.min(max, ratio)), false);
		}

		public function set value(value:Number):void
		{
			var ratio:Number = (value - min) / (max - min);
			updateDraggerToRatio(Math.max(0, Math.min(max, ratio)));
		}

		public function get value():Number
		{
			return _value;
		}

		public function set showNumbers(value:Boolean):void
		{
			if (value != _showNumbers) {
				leftLabel.visible = value;
				rightLabel.visible = value;
				_showNumbers = value;
				invalid();
			}
		}

		private function updatebg():void
		{
			bg.graphics.clear();
			bg.graphics.beginFill(0xF5F5F5);
			bg.graphics.moveTo(0, 0);
			bg.graphics.drawRoundRect(0, 0, _width - ((_showNumbers) ? PADDING * 2 : 0), _height, _height);
			bg.x = (_showNumbers) ? PADDING : 0;


			dragger.graphics.beginFill(0xEEEEEE);
			dragger.graphics.drawCircle(0, 0, _height);

			dragger.y = _height * .5;
			hintBtn.y = -10 - hintBtn.height;
		}


		override protected function update(event:Event = null):void
		{
			leftLabel.x = PADDING * .5;
			leftLabel.name = "left";
			leftLabel.y = (_height - leftLabel.height) * .5;
			rightLabel.x = _width - PADDING * .5;
			rightLabel.y = (_height - rightLabel.height) * .5;
			updatebg();

		}

		override public function get height():Number
		{

			return _height;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			invalid();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			invalid();
		}

	}
}
