package com.gridtt.framework.ui
{

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class LoadingSpinner extends BaseUI
	{
		private var timer:Timer;
		private var slices:int;
		private var radius:int;
		private var size:int;
		private var long:int;
		private var color:int;

		public function LoadingSpinner(color:int = 0x666666, slices:int = 12, cradius:int = 6, size:int = 2, long:int = 9)
		{
			super();
			this.color = color;
			this.size = size;
			this.long = long;
			this.slices = slices;
			this.radius = cradius;
			draw();
		}


		private function onTimer(event:TimerEvent):void
		{
			rotation = (rotation + (360 / slices)) % 360;
		}

		private function draw():void
		{
			var i:int = slices;
			var degrees:int = 360 / slices;
			while (i--) {
				var slice:Shape = getSlice();
				slice.alpha = Math.max(0.2, 1 - (0.1 * i));
				var radianAngle:Number = (degrees * i) * Math.PI / 180;
				slice.rotation = -degrees * i;
				slice.x = Math.sin(radianAngle) * radius;
				slice.y = Math.cos(radianAngle) * radius;
				addChild(slice);
			}
		}

		private function getSlice():Shape
		{
			var slice:Shape = new Shape();
			slice.graphics.beginFill(color);
			slice.graphics.drawRoundRect(-1, 0, size, long, size, size);
			slice.graphics.endFill();
			return slice;
		}

		override protected function initStage(event:Event):void
		{
			timer = new Timer(65);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			timer.start();
			super.initStage(event);
		}

		override protected function removeFromStage(event:Event):void
		{
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
			super.removeFromStage(event);
		}

	}

}
