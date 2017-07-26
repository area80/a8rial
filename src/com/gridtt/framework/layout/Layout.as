package com.gridtt.framework.layout
{

	import flash.display.Sprite;

	public class Layout extends Column
	{

		internal var change:Boolean = true;

		protected var _width:Number = 0;

		public function Layout(width:Number)
		{
			setLayout(this);
			this.width = width;
			super(LayoutSettings.GRID);
		}

		override public function set width(value:Number):void
		{
			_width = value;
			change = true;
		}

		override public function get width():Number
		{
			return _width;
		}

		public function updateIfNeeded():void
		{
			if (change) {
				forceUpdate();
			}
		}

		public function forceUpdate():void
		{
			tryResizeToWidth(_width);
			tryResizeToHeight();
			change = false;
		}


	}
}
