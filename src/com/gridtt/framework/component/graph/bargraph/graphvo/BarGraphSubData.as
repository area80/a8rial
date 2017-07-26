package com.gridtt.framework.component.graph.bargraph.graphvo
{

	/**
	 * Property of each bar
	 * @author EXIT
	 *
	 */
	public class BarGraphSubData
	{
		public var name:String;
		public var value:Number;
		public var color:uint;

		public function BarGraphSubData($name:String, $color:uint, $value:Number)
		{
			name = $name;
			color = $color;
			value = $value;
		}
	}
}
