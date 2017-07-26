package net.area80.a8real.data.direction
{

	import net.area80.a8real.data.LatLng;

	public class Leg
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
		public var endAddress:String;
		public var endLocation:LatLng;

		public var startAddress:String;
		public var startLocation:LatLng;

		public var steps:Vector.<Step> = new Vector.<Step>;

		public function Leg()
		{
		}

		public static function fromObject(obj:Object):Leg
		{
			var res:Leg = new Leg();
			res.distanceText = obj.distance.text;
			res.distance = obj.distance.value;
			res.durationText = obj.duration.text;
			res.duration = obj.duration.value;
			res.startLocation = new LatLng(obj.start_location.lat, obj.start_location.lng);
			res.endLocation = new LatLng(obj.end_location.lat, obj.end_location.lng);
			//
			for (var i:int = 0; i < obj.steps.length; i++) {
				res.steps.push(Step.fromObject(obj.steps[i]));
			}
			//
			res.startAddress = obj.start_address;
			res.endAddress = obj.end_address;
			return res;
		}
	}
}
