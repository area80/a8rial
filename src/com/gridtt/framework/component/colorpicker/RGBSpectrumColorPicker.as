package com.gridtt.framework.component.colorpicker
{

	import com.gridtt.framework.ui.BaseUI;
	import com.gridtt.framework.util.Dispatcher;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	public class RGBSpectrumColorPicker extends BaseUI
	{
		private var rgb:Bitmap;
		private var pointer:Sprite;
		private var _width:int;
		private var _height:int;
		private var _grayscaleWidth:int = 20;

		public var DispatcherColorChange:Dispatcher = new Dispatcher(Number);

		public function RGBSpectrumColorPicker(width:int, height:int, color:int = 0xFFFFFF)
		{

			super(); 

			this._width = width;
			this._height = height;

			rgb = new Bitmap();
			addChild(rgb);
			createPointer();

			invalid();
			setPointerByColor(color);

		}

		override public function get width():Number
		{

			return _width;

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

		override public function set width(value:Number):void
		{

			_width = value;
			invalid();

		}

		protected function createPointer():void
		{

			pointer = new Sprite();
			pointer.graphics.lineStyle(1, 0x7e7e7e, 1, true, LineScaleMode.NONE);
			pointer.graphics.drawCircle(0, 0, 8);
			pointer.filters = [new DropShadowFilter(.5, 90, 0xFFFFFF, 1, 1, 1, 1)];
			pointer.x = 10;
			pointer.y = 20;
			addChild(pointer);

		}

		override protected function initStage(event:Event):void
		{

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			super.initStage(event);

		}

		protected function mouseDownHandler(event:MouseEvent):void
		{

			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			setPointerColorAtXY(mouseX, mouseY);

		}

		protected function mouseUpHandler(event:MouseEvent):void
		{

			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}

		}

		protected function setPointerColorAtXY(mx:Number, my:Number):void
		{

			var px:Number = Math.max(0, Math.min(_width, mouseX));
			var py:Number = Math.max(0, Math.min(_height, mouseY));
			pointer.x = Math.max(0, Math.min(_width, mouseX));
			pointer.y = Math.max(0, Math.min(_height, mouseY));
			var color:int = getColorAtXY(px, py);
			DispatcherColorChange.dispatch(color);

		}

		override protected function removeFromStage(event:Event):void
		{

			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			super.removeFromStage(event);

		}

		protected function getColorAtXY(x:int, y:int):int
		{

			var px:Number = Math.max(0, Math.min(_width, mouseX));
			var py:Number = Math.max(0, Math.min(_height, mouseY));

			return rgb.bitmapData.getPixel(px, py);

		}

		public function setPointerByColor(color:int):void
		{

			updateIfInvalid();

			var i:int = 0;
			var j:int = 0;
			var cr:int = (color >> 16 & 0xFF);
			var cg:int = (color >> 8 & 0xFF);
			var cb:int = (color & 0xFF);
			var r:int;
			var g:int;
			var b:int;
			var treshold:int = 70;

		
			var s:Object = {score:treshold+1,x:0,y:0};

			for (i = 0; i < _width; i++) {
				var has:Boolean = false;
				for (j = 0; j < _height; j++) {
					var px:int = rgb.bitmapData.getPixel(i, j);
					r = (px >> 16 & 0xFF);
					g = (px >> 8 & 0xFF);
					b = (px & 0xFF);
					//	if (r == 255 && b==0) trace(r, ",", g, ",", b, "@", i, ",", j);
					if (r > cr - treshold && r < cr + treshold &&
					g > cg - treshold && g < cg + treshold &&
					b > cb - treshold && b < cb + treshold) {
						var score:Number = (Math.abs(cr-r) + Math.abs(cg-g) + Math.abs(cb-b))/3;
						if(score<s.score) {
							s.score = score;
							s.x = i;
							s.y = j;
						}
						
					}
				}
				
			}

			pointer.x = s.x;
			pointer.y = s.y;

		}

		protected function mouseMoveHandler(event:MouseEvent):void
		{

			setPointerColorAtXY(mouseX, mouseY);

		}

		protected function updateRgb():void
		{

			var w:int = _width - _grayscaleWidth;
			var h:int = _height;

			var nColorPercent:Number;
			var nRadians:Number;
			var r:Number;
			var g:Number;
			var b:Number;
			var nr:Number;
			var ng:Number;
			var nb:Number;
			var hRatio:Number;

			if (rgb.bitmapData) {
				rgb.bitmapData.dispose();
			}

			rgb.bitmapData = new BitmapData(_width, _height, false, 0x000000);
			var halfHeight:Number = _height * 0.5;

			for (var i:int = 0; i < _width; i++) {
				if (i < _width - _grayscaleWidth) {
					nColorPercent = i / _width - _grayscaleWidth;
					nRadians = (-360 * nColorPercent) * (Math.PI / 180);
					r = Math.cos(nRadians) * 127 + 128;
					g = Math.cos(nRadians + 2 * Math.PI / 3) * 127 + 128;
					b = Math.cos(nRadians + 4 * Math.PI / 3) * 127 + 128;
				} else {
					r = 128;
					g = 128;
					b = 128;
				}

				for (var j:int = 0; j < _height; j++) {
					nr = r;
					ng = g;
					nb = b;
					if (j < halfHeight) {
						hRatio = (1 - (j / halfHeight));
						nr = Math.min(255, nr + (255 - nr) * hRatio);
						ng = Math.min(255, ng + (255 - ng) * hRatio);
						nb = Math.min(255, nb + (255 - nb) * hRatio);
					} else if (j > halfHeight) {
						hRatio = 1 - ((j - halfHeight) / halfHeight);
						nr *= hRatio;
						ng *= hRatio;
						nb *= hRatio;
					}
					rgb.bitmapData.setPixel(i, j, (nr << 16 | ng << 8 | nb));

				}

			}

		}

		override protected function update(event:Event = null):void
		{

			updateRgb();
			super.update(event);

		}

		override public function dispose():void
		{
			if(rgb && rgb.bitmapData) {
				try {
					rgb.bitmapData.dispose();
				} catch (e:Error){}
			}
			super.dispose();
		}
		
	}
}
