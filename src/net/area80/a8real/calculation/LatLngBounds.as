package net.area80.a8real.calculation
{

	import net.area80.a8real.data.LatLng;
	import net.area80.a8real.util.MapUtil;
	import net.area80.a8real.calculation.R1Interval;
	import net.area80.a8real.calculation.S1Interval;
	import net.area80.a8real.util.MapUtil;

	public class LatLngBounds
	{
		private var lng_:S1Interval;
		private var lat_:R1Interval;
		private static const PI:Number = 3.14159;

		public function LatLngBounds(latlng1:LatLng = null, latlng2:LatLng = null)
		{
			if (latlng1 && !latlng2) {
				latlng2 = latlng1;
			}
			if (latlng1) {
				var validLat1:Number = MapUtil.bound(latlng1.latRadians(), (-PI) / 2, PI / 2);
				var validLat2:Number = MapUtil.bound(latlng2.latRadians(), (-PI) / 2, PI / 2);
				lat_ = new R1Interval(validLat1, validLat2);
				var lng1:Number = latlng1.lngRadians();
				var lng2:Number = latlng2.lngRadians();
				if (lng2 - lng1 >= PI * 2) {
					lng_ = new S1Interval(-PI, PI);
				} else {
					lng1 = MapUtil.wrap(lng1, -PI, PI);
					lng2 = MapUtil.wrap(lng2, -PI, PI);
					lng_ = new S1Interval(lng1, lng2);
				}
			} else {
				lat_ = new R1Interval(1, -1);
				lng_ = new S1Interval(PI, -PI);
			}
			return;
		}

		public function getNorthEast():LatLng
		{
			return LatLng.fromRadians(lat_.hi, lng_.hi);
		}

		public function containsLatLng(param1:LatLng):Boolean
		{
			return lat_.contains(param1.latRadians()) && lng_.contains(param1.lngRadians());
		}

		public function isFullLat():Boolean
		{
			return lat_.hi >= PI / 2 && lat_.lo <= (-PI) / 2;
		}

		public function isEmpty():Boolean
		{
			return lat_.isEmpty() || lng_.isEmpty();
		}

		public function getCenter():LatLng
		{
			return LatLng.fromRadians(lat_.center(), lng_.center());
		}

		public function intersects(param1:LatLngBounds):Boolean
		{
			return lat_.intersects(param1.lat_) && lng_.intersects(param1.lng_);
		}

		public function isFullLng():Boolean
		{
			return lng_.isFull();
		}

		public function union(param1:LatLngBounds):void
		{
			extend(param1.getSouthWest());
			extend(param1.getNorthEast());
			return;
		}

		public function getSouth():Number
		{
			return MapUtil.radiansToDegrees(lat_.lo);
		}

		public function clone():LatLngBounds
		{
			return new LatLngBounds(getSouthWest(), getNorthEast());
		}

		public function getNorthWest():LatLng
		{
			return LatLng.fromRadians(lat_.hi, lng_.lo);
		}

		public function extend(param1:LatLng):void
		{
			lat_.extend(param1.latRadians());
			lng_.extend(param1.lngRadians());
			return;
		}

		public function isLargerThan(param1:LatLngBounds):Boolean
		{
			var _loc_2:LatLng = null;
			var _loc_3:LatLng = null;
			_loc_2 = toSpan();
			_loc_3 = param1.toSpan();
			return _loc_2.lat() > _loc_3.lat() && _loc_2.lng() > _loc_3.lng();
		}

		public function getWest():Number
		{
			return MapUtil.radiansToDegrees(lng_.lo);
		}

		public function getSouthWest():LatLng
		{
			return LatLng.fromRadians(lat_.lo, lng_.lo);
		}

		public function getNorth():Number
		{
			return MapUtil.radiansToDegrees(lat_.hi);
		}

		public function toString():String
		{
			return "(" + getSouthWest() + ", " + getNorthEast() + ")";
		}

		public function getEast():Number
		{
			return MapUtil.radiansToDegrees(lng_.hi);
		}

		public function containsBounds(param1:LatLngBounds):Boolean
		{
			return lat_.containsInterval(param1.lat_) && lng_.containsInterval(param1.lng_);
		}

		public function getSouthEast():LatLng
		{
			return LatLng.fromRadians(lat_.lo, lng_.hi);
		}

		public function toSpan():LatLng
		{
			return LatLng.fromRadians(lat_.span(), lng_.span(), true);
		}

		public function equals(param1:LatLngBounds):Boolean
		{
			return lat_.equals(param1.lat_) && lng_.equals(param1.lng_);
		}

		public static function fromObject(param1:Object):LatLngBounds
		{
			if (param1 == null) {
				return null;
			}
			return new LatLngBounds(LatLng.fromObject(param1.getSouthWest()), LatLng.fromObject(param1.getNorthEast()));
		}
	}
}
