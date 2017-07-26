package com.gridtt.framework.ui
{

	import com.gridtt.framework.GridttFramework;
	import com.gridtt.framework.style.ButtonStyle;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Button extends BaseUI
	{
		public static const ALIGN_LEFT:String = "left";
		public static const ALIGN_RIGHT:String = "right";
		public static const ALIGN_CENTER:String = "center";

		private var _style:ButtonStyle;
		private var _height:Number = 0;
		private var _width:Number = 0;
		private var _color:Fill;
		private var _label:Label;
		private var _text:String;
		private var _textAlign:String = "left";

		private var _enabled:Boolean = false;
		private var _registrationPointAlignment:String = "left";


		public function Button(style:ButtonStyle, text:String = "",registrationPointAlignment:String = "left", textAlign:String = "center")
		{
			super();

			_textAlign = textAlign;
			_registrationPointAlignment = registrationPointAlignment;
			_style = style;

			_label = new Label(text,style.font);
			_label.resizeMode = Label.RESIZE_AUTO;
			_label.align = _textAlign;
			_label.y = style.padding;
			
			_label.baseLine = Label.BASELINE_MIDDLE;

			_color = new Fill(style.fill);

			addChild(_label);
			addChildAt(_color, 0);


			this.text = text;

			initInteractive();
		}
		public function autoSize():void {
			_label.resizeMode = Label.RESIZE_AUTO;
			invalid();
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value
			if (!value) {
				deInitInteractive();
				filters = GridttFramework.theme.buttonstate_disable_filter;
			} else {
				initInteractive();
				filters = [];
			}
		}

		protected function initInteractive():void
		{
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		protected function deInitInteractive():void
		{
			buttonMode = false;
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			filters = [];
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			filters = GridttFramework.theme.buttonstate_down_filter;
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			filters = [];
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			filters = GridttFramework.theme.buttonstate_over_filter;
		}

		public function set text(value:String):void
		{
			_text = value;
			_label.text = _text;
			
			invalid();
		}

		public function get text():String
		{
			return _text;
		}

		public function get label():Label
		{
			return _label;
		}


		public function set style(value:ButtonStyle):void
		{
			_style = value;			

			_label.setFontStyle(value.font);

			//label is realtime update
			_color.style = value.fill;
			_color.width = width;
			_color.height = height;

			invalid();
		}

		public function get style():ButtonStyle
		{
			return _style;
		}

		override public function set height(value:Number):void
		{
			invalid();
		}

		override public function get width():Number
		{
			label.updateIfInvalid();
			return _style.padding*2+label.width;
		}

		override public function get height():Number
		{
			label.updateIfInvalid();
			return _style.padding*2+label.height;
		}

		override public function set width(value:Number):void
		{
			_label.resizeMode = Label.RESIZE_AUTO_FIXWIDTH;
			label.width = value-_style.padding*2;
			_color.width = value;
			invalid();
			//trace(value);
		}

		protected override function update(event:Event = null):void
		{
			switch (_registrationPointAlignment) {

				case "left":
					_color.x = 0;
					label.x = _color.x+_style.padding;
					break;
				case "right":
					_color.x = -width;
					label.x = _color.x+_style.padding;
					break;
				case "center":
					_color.x = Math.round(-width*.5);
					label.x = _color.x+_style.padding;
					break;

			}
			_color.width = width;
			_color.height = height;
			_color.updateIfInvalid();
			label.updateIfInvalid();
			
			//trace(this.name + ">update>" + color.width);
		}

		override protected function initStage(event:Event):void
		{
			if (_enabled)
				initInteractive();
			super.initStage(event);
		}


		override protected function removeFromStage(event:Event):void
		{
			deInitInteractive();
			super.removeFromStage(event);
		}


	}
}
