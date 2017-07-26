package net.area80.a8real.data.direction
{

	import net.area80.a8real.data.LatLng;

	public class RouteData
	{
		public var boundsNE:LatLng;
		public var boundsSW:LatLng;
		public var copyrights:String = "";
		public var legs:Vector.<Leg> = new Vector.<Leg>;
		public var overviewPolylineEncodedPoints:String = "";
		public var summary:String;


		public function RouteData()
		{
		}

		public static function fromObject(obj:Object):RouteData
		{
			var r:RouteData = new RouteData();
			r.boundsNE = new LatLng(obj.bounds.northeast.lat, obj.bounds.northeast.lng);
			r.boundsSW = new LatLng(obj.bounds.southwest.lat, obj.bounds.southwest.lng);
			r.copyrights = obj.copyrights;

			r.overviewPolylineEncodedPoints = obj.overview_polyline.points;
			r.summary = obj.summary;

			for (var i:int = 0; i < obj.legs.length; i++) {
				r.legs.push(Leg.fromObject(obj.legs[i]));
			}

			return r;
		}
	}
}
