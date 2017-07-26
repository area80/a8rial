package net.area80.a8real.controller
{
	import flash.geom.Point;

	import net.area80.a8real.A8realMap;

	public class InteractiveController
	{
		private var receiver:A8realMap;
		private var prevPoint:Point = new Point();
		private var multitouchRadius:Number = 0;
		private var initZoom:Number = 0;
		private var spdPoint:Point = new Point();

		public function InteractiveController(receiver:A8realMap)
		{
			this.receiver = receiver;
		}

		public function multiTouchStart(centerX:Number, centerY:Number, radius:Number):void
		{
			multitouchRadius = radius;
			
			
			singleTouchSart(centerX, centerY);
		}

		public function multiTouchMove(centerX:Number, centerY:Number, radius:Number):void
		{
			singleTouchDrag(centerX, centerY);

			var scale:Number = ((radius - multitouchRadius) / 256) * 2;
			receiver.zoom = (initZoom + scale);
		}

		public function multitouchEnd():void
		{
			singleTouchEnd();
		}

		public function singleTouchEnd():void
		{
			receiver.releaseUpdate();
			if (spdPoint.x != 0 || spdPoint.y != 0) {
				//trace("end" + spdPoint.x + ":" + spdPoint.y);
				receiver.setLocalXYInertia(spdPoint.x, spdPoint.y);
			}
		}

		public function framePassBy():void
		{
			spdPoint.x *= .7;
			spdPoint.y *= .7;
			if (spdPoint.x < 0.01)
				spdPoint.x = 0;
			if (spdPoint.y < 0.01)
				spdPoint.y = 0;
		}

		public function click(x:Number, y:Number):void
		{
			receiver.clickAtLocalXY(x, y);
		}

		public function singleTouchSart(x:Number, y:Number):void
		{
			initZoom = receiver.zoom;
			
			spdPoint.x = 0;
			spdPoint.y = 0;

			prevPoint.x = x;
			prevPoint.y = y;
			receiver.holdUpdate();
			receiver.setLocalXYInertia(0, 0);
		}

		public function singleTouchDrag(x:Number, y:Number):void
		{
			spdPoint.x += (x - prevPoint.x) * .2;
			spdPoint.y += (y - prevPoint.y) * .2;

			receiver.moveByLocalXY(x - prevPoint.x, y - prevPoint.y);

			prevPoint.x = x;
			prevPoint.y = y;
		}

	}
}
