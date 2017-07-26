package net.area80.a8real.data
{
	import net.area80.a8real.util.MapUtil;

	public class LatLng
	{
		private var latDegrees_:Number;
		private var lngDegrees_:Number;
		public static const EARTH_RADIUS:Number = 6378137;

		public function LatLng(latDegrees:Number, lngDegrees:Number, nowrap:Boolean = false)
		{
			if (!nowrap) {
				latDegrees = MapUtil.bound(latDegrees, -90, 90);
				lngDegrees = MapUtil.wrap(lngDegrees, -180, 180);
			}
			latDegrees_ = latDegrees;
			lngDegrees_ = lngDegrees;
			return;
		}

		public function latRadians():Number
		{
			return MapUtil.degreesToRadians(latDegrees_);
		}

		public function toUrlValue(param1:Number = 6):String
		{
			return quantize(lat(), param1) + "," + quantize(lng(), param1);
		}

		public function lng():Number
		{
			return lngDegrees_;
		}

		public function lat():Number
		{
			return latDegrees_;
		}

		public function angleFrom(fromLatLng:LatLng):Number
		{
			var latR:Number = latRadians();
			var fromLatR:Number = fromLatLng.latRadians();
			var diffLatR:Number = latR - fromLatR;
			var diffLngR:Number = lngRadians() - fromLatLng.lngRadians();
			return 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(diffLatR / 2), 2) + Math.cos(latR) * Math.cos(fromLatR) * Math.pow(Math.sin(diffLngR / 2), 2)));
		}

		public function toString():String
		{
			return "(" + this.lat() + ", " + this.lng() + ")";
		}

		public function lngRadians():Number
		{
			return MapUtil.degreesToRadians(lngDegrees_);
		}

		public function distanceFrom(param1:LatLng, param2:Number = 6378137):Number
		{
			return angleFrom(param1) * param2;
		}

		public function clone():LatLng
		{
			return new LatLng(lat(), lng(), true);
		}

		public function equals(param1:LatLng):Boolean
		{
			if (!param1) {
				return false;
			}
			return MapUtil.approxEquals(lat(), param1.lat()) && MapUtil.approxEquals(lng(), param1.lng());
		}

		private static function quantize(param1:Number, param2:Number):Number
		{
			var _loc_3:Number = NaN;
			_loc_3 = Math.pow(10, param2);
			return Math.round(param1 * _loc_3) / _loc_3;
		}

		public static function fromRadians(radianLat:Number, radianLng:Number, nowrap:Boolean = false):LatLng
		{
			return new LatLng(MapUtil.radiansToDegrees(radianLat), MapUtil.radiansToDegrees(radianLng), nowrap);
		}

		public static function fromObject(latlngObj:Object):LatLng
		{
			return latlngObj != null ? (new LatLng(latlngObj.lat(), latlngObj.lng())) : (null);
		}

		public static function fromUrlValue(uri:String):LatLng
		{
			var uris:Array = uri.split(",");
			return new LatLng(parseFloat(uris[0]), parseFloat(uris[1]));
		}
	}
}
