package com.gridtt.framework.component.graph.bargraph.view
{
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphConfig;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphDataAll;

	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	import net.area80.utils.DrawingUtils;

	/**
	 * Container of all bar graph group
	 * registeration point is at bottom left
	 * @author EXIT
	 *
	 */
	public class BarGraphContainer extends Sprite
	{

		private var barGraphDataAll:BarGraphDataAll;
		private var groupBars:Vector.<BarGraphGroup> = new Vector.<BarGraphGroup>();
		private var config:BarGraphConfig;
		private var _width:Number = 0;
		private var _height:Number = 0;

		public function BarGraphContainer($barGraphDataAll:BarGraphDataAll, $main:MainBarGraph)
		{
			super();
			barGraphDataAll = $barGraphDataAll;
			config = barGraphDataAll.config;
			for (var i:Number = 0; i<=barGraphDataAll.datas.length-1; i++) {
				var groupBar:BarGraphGroup = new BarGraphGroup(barGraphDataAll.datas[i], config, $main);
				addChild(groupBar);
				groupBars.push(groupBar);
			}

			//set width
			for (i = 0; i<=barGraphDataAll.datas.length-1; i++) {
				if (i==0) {
					groupBars[i].x = 0;
				} else {
					groupBars[i].x = groupBars[(i-1)].width+groupBars[(i-1)].x;
				}
				_width += groupBars[i].width;
			}
		}

		override public function set width($value:Number):void
		{
		}

		override public function set height($value:Number):void
		{
			_height = $value;

			for (var i:uint = 0; i<=barGraphDataAll.datas.length-1; i++) {
				groupBars[i].height = _height;
			}

		}

		override public function get width():Number
		{
			return _width;
		}

		override public function get height():Number
		{
			return _height;
		}
	}
}
