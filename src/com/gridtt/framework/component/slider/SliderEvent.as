package com.gridtt.framework.component.slider
{

	import flash.events.Event;

	public class SliderEvent extends Event
	{
		public static const PRESS:String = "press";
		public static const RELEASE:String = "release";
		public static const CHANGE:String = "change";

		public var value:Number;

		public function SliderEvent(type:String, value:Number)
		{
			this.value = value;
			super(type, false, false);
		}
	}
}
