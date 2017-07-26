package net.area80.a8real.event
{

	import flash.events.Event;

	public class A8realMapEvent extends Event
	{
		public static const HOLD:String = "hold";
		public static const RELEASED:String = "released";
		public static const ZOOM_CHANGE:String = "zoomchange";
		public static const LATLNG_CHANGE:String = "latlngchange";

		public function A8realMapEvent(type:String)
		{
			super(type);
		}
	}
}
