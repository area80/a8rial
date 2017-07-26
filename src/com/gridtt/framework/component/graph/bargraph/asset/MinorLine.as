package com.gridtt.framework.component.graph.bargraph.asset
{
	import flash.display.Sprite;

//	[Embed(source="embed/graphAsset.swf",symbol="minorLine")]
	public class MinorLine extends Sprite
	{
		public var percent:Number;

		public function MinorLine($percent:Number, $color:uint)
		{
			super();
			percent = $percent;

			graphics.lineStyle(1, $color);
			graphics.lineTo(-5, 0);
		}
	}
}
