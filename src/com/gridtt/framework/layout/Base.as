package com.gridtt.framework.layout
{

	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;

	internal class Base extends Sprite
	{
		protected var _content:DisplayObject;
		protected var _fixedHeight:Number = -1;
		protected var _layout:Layout;
		protected var _debugLine:Sprite;

		public function Base()
		{

		}

		public function get fixedHeight():Number
		{
			return _fixedHeight;
		}

		public function get heightIsFixed():Boolean
		{
			return (_fixedHeight >= 0);
		}

		public function set fixedHeight(value:Number):void
		{
			_fixedHeight = value;
			_layout.change = true;
		}

		public function clearFixedHeight():void
		{
			fixedHeight = -1;
			_layout.change = true;
		}

		public function attachContent(content:DisplayObject):void
		{
			_content = content;
			addChild(_content);
			_layout.change = true;
		}

		public function get content():DisplayObject
		{
			return _content;
		}

		public override function set width(value:Number):void
		{
			//do nothing
		}

		public override function set height(value:Number):void
		{
			//do nothing
		}

		public override function get width():Number
		{
			return (_content) ? _content.width : 0;
		}

		public override function get height():Number
		{
			if (_fixedHeight < 0) {
				return (_content) ? _content.height : 0;
			} else {
				return _fixedHeight;
			}
		}

		internal function tryResizeToHeight(value:Number = -1):void
		{
			if (_content) {
				_content.height = (heightIsFixed) ? _fixedHeight : Math.max(0, value);
			}
			if (_debugLine)
				_debugLine.height = (heightIsFixed) ? _fixedHeight : Math.max(0, value);
		}

		internal function tryResizeToWidth(value:Number):void
		{
			if (_content) {
				_content.width = Math.max(0, value);
			}
			if (_debugLine)
				_debugLine.width = Math.max(0, value);

		}

		internal function setLayout(value:Layout):void
		{
			_layout = value;
		}

		internal function createDebugLine(color:int):void
		{
			if (!_debugLine) {
				_debugLine = new Sprite();
				_debugLine.graphics.lineStyle(1, color, 1, false, LineScaleMode.NONE);
				_debugLine.graphics.drawRect(0, 0, 1000, 1000);
				addChildAt(_debugLine, 0);
			}
		}

		internal function removeDebugLine():void
		{
			if (_debugLine) {
				removeChild(_debugLine);
				_debugLine = null;
			}
		}



	}
}
