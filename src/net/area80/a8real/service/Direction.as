package net.area80.a8real.service
{

	import flash.net.URLVariables;

	import net.area80.a8real.data.direction.RouteData;
	import net.area80.utils.FileActivity;

	public class Direction
	{
		public function Direction(originlat:Number, originlng:Number, deslat:Number, deslng:Number, cb:Function)
		{
			FileActivity.loadJSON("http://maps.googleapis.com/maps/api/directions/json?origin=" + originlat + "," + originlng + "&destination=" + deslat + "," + deslng + "&sensor=false", function(o:*):void
			{
				if (o.routes) {
					var i:int;
					var j:int;
					if (o.routes.length > 0) {
						var r:RouteData = RouteData.fromObject(o.routes[0]);
					}
					cb(r);
				}
			}, null, "GET");

		}
	}
}
