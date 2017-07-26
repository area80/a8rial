package com.gridtt.framework.debug
{
	import com.gridtt.framework.ui.BaseUI;
	
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import spark.primitives.Line;
	
	public class LineGuide extends BaseUI
	{
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var vertical:Sprite;
		private var horizontal:Sprite;
		private var _color:int;
		
		public function LineGuide(color:int=0x4cffff)
		{
			super();
			
			vertical = new Sprite();
			horizontal = new Sprite();
			
			this._color = color;
			
			addChild(vertical);
			addChild(horizontal);
			
			
			
		}
		
		override public function get height():Number
		{
			// TODO Auto Generated method stub
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
			// TODO Auto Generated method stub
			super.height = value;
		}
		
		override public function get width():Number
		{
			// TODO Auto Generated method stub
			return super.width;
		}
		
		override public function set width(value:Number):void
		{
			// TODO Auto Generated method stub
			super.width = value;
		}
		
		
		public function get color():int
		{
			return _color;
		}

		public function set color(value:int):void
		{
			_color = value;
			invalid();
		}

		override public function get x():Number
		{
			return _x;
		}
		
		override public function set x(value:Number):void
		{
			_x = value;
			invalid();
		}
		
		override public function get y():Number
		{
			return _y;
		}
		
		override public function set y(value:Number):void
		{
			_y = value;
			invalid();
		}
		
		
		override protected function initStage(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, update);
			invalid();
			super.initStage(event);
		}
		
		override protected function removeFromStage(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE, update);
			super.removeFromStage(event);
		}
		
		
		override protected function update(event:Event=null):void
		{
			super.update(event);
			
			vertical.graphics.clear();
			horizontal.graphics.clear();
			horizontal.x = 0;
			horizontal.y = 0;
			vertical.x = 0;
			vertical.y = 0;
			
			if(x!=0) {
				drawLine(true, horizontal, stage.stageHeight);
				horizontal.x = int(x);
			}
			if(y!=0) {
				drawLine(false, vertical, stage.stageWidth);
				vertical.y = int(y);
			}
			
		}
		protected function drawLine (onVerticalDirection:Boolean, to:Sprite, size:int):void {
			to.graphics.lineStyle(1,_color,1,true,LineScaleMode.NONE);
			to.graphics.moveTo(0,0);
			if(onVerticalDirection) {
				to.graphics.lineTo(0,size);
			} else {
				to.graphics.lineTo(size,0);
			}
		}
		
	}
}