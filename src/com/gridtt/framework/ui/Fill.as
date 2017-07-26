package com.gridtt.framework.ui
{

	import com.gridtt.framework.style.FillStyle;

	import flash.display.GradientType;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class Fill extends BaseUI
	{

		private var _style:FillStyle;
		private var _width:Number = 0;
		private var _height:Number = 0;

		public function Fill(style:FillStyle)
		{
			super();
			this.style = style;
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

		override public function get height():Number
		{
			return _height;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			invalid();
		}

		public function set style(value:FillStyle):void
		{
			_style = value;
			invalid();
		}

		public function get style():FillStyle
		{
			return _style;
		}

		override protected function update(event:Event = null):void
		{
			filters = _style.filters;
			graphics.clear();
			if (_style.colorTop==_style.colorBottom&&_style.alphaTop==_style.alphaBottom&&_style.alphaBottom==style.alphaMiddle&&style.colorMiddle==FillStyle.NONE) {
				graphics.beginFill(_style.colorTop, _style.alphaTop);
			} else {

				var mat:Matrix = new Matrix();
				mat.createGradientBox(width, height, Math.PI/2);



				if (_style.colorMiddle!=FillStyle.NONE) {
					graphics.beginGradientFill(GradientType.LINEAR, [_style.colorTop, _style.colorMiddle, _style.colorBottom], [_style.alphaTop, _style.alphaMiddle, _style.alphaBottom], [0, 128, 255], mat);
				} else {
					graphics.beginGradientFill(GradientType.LINEAR, [_style.colorTop, _style.colorBottom], [_style.alphaTop, _style.alphaBottom], [0, 255], mat);
				}

			}
			graphics.drawRoundRect(0, 0, width, height, _style.cornerRadius*2, _style.cornerRadius*2);
		}



	}
}
