package com.gridtt.framework.component.graph.bargraph.graphvo
{

	public class BarGraphConfig
	{
		public var title:String;
		public var type:String; //stack , cluster
		public var unitX:String;
		public var unitY:String;
		public var maxValue:Number;
		public var minValue:Number;
		public var majorDiff:Number;
		public var minorDiff:Number;
		public var lineColor:Number;
		public var bgColor1:Number;
		public var bgColor2:Number;
		public var barWidth:Number;
		public var paddingGroup:Number;
		public var paddingBar:Number;

		public var barInfos:Vector.<BarInfo> = new Vector.<BarInfo>();

		public function BarGraphConfig()
		{
		}
	}
}
