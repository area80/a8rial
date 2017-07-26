package net.area80.a8real.view.starling
{

	import net.area80.a8real.view.interfaces.IPolyLine;

	import starling.display.Shape;

	public class StarlingPolyline extends Shape implements IPolyLine
	{

		private var _scale:Number = 1;

		public function StarlingPolyline()
		{
			super();
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function beginToLine():void
		{
			graphics.lineStyle(12, 0x07a8f9, .5);
		}

		public function moveTo(x:Number, y:Number):void
		{
			graphics.moveTo(x, y);
		}

		public function endStroke():void
		{
			//
		}


		public function clear():void
		{
			graphics.clear();
		}

		public function lineTo(x:Number, y:Number):void
		{
			graphics.lineTo(x, y);
		}

		public function destroy():void
		{
			clear();
			dispose();

		}


	}
}
