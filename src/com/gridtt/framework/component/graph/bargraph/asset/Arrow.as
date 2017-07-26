package com.gridtt.framework.component.graph.bargraph.asset
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Arrow extends Sprite
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";

		private var type:String;

		public function Arrow(_type:String)
		{
			super();
			type = _type;
			narmal();
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			buttonMode = true;
		}

		private function narmal():void
		{
			graphics.beginFill(0xcccccc);
			graphics.drawCircle(0, 0, 22);
			graphics.endFill();

			graphics.lineStyle(4, 0xFFFFFF);
			if (type==LEFT) {
				graphics.moveTo(4, -14);
				graphics.lineTo(-10, 0);
				graphics.lineTo(4, 14);
			} else {
				graphics.moveTo(-4, -14);
				graphics.lineTo(10, 0);
				graphics.lineTo(-4, 14);
			}
		}

		private function over():void
		{
			graphics.beginFill(0x888888);
			graphics.drawCircle(0, 0, 22);
			graphics.endFill();

			graphics.lineStyle(4, 0xFFFFFF);
			if (type==LEFT) {
				graphics.moveTo(4, -14);
				graphics.lineTo(-10, 0);
				graphics.lineTo(4, 14);
			} else {
				graphics.moveTo(-4, -14);
				graphics.lineTo(10, 0);
				graphics.lineTo(-4, 14);
			}
		}

		protected function onOver(event:MouseEvent):void
		{
			graphics.clear();
			over();
		}

		protected function onOut(event:MouseEvent):void
		{
			graphics.clear();
			narmal();
		}
	}
}
