package net.area80.a8real.data.direction
{

	import net.area80.a8real.data.LatLng;

	public class Step
	{
		public var distanceText:String;
		/**
		 * metre
		 */
		public var distance:Number;
		public var durationText:String;
		/**
		 * sec
		 */
		public var duration:Number;

		public var endLocation:LatLng;
		public var startLocation:LatLng;

		public var polylinePoints:String;
		public var travelMode:String;

		public var htmlInstructions:String;

		public function Step()
		{
		}

		public static function fromObject(obj:Object):Step
		{
			var res:Step = new Step();
			res.distanceText = obj.distance.text;
			res.distance = obj.distance.value;
			res.durationText = obj.duration.text;
			res.duration = obj.duration.value;
			res.startLocation = new LatLng(obj.start_location.lat, obj.start_location.lng);
			res.endLocation = new LatLng(obj.end_location.lat, obj.end_location.lng);
			//
			res.travelMode = obj.travel_mode;
			res.htmlInstructions = obj.html_instructions;
			return res;
		}
	}
}
