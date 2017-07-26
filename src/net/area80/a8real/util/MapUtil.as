package net.area80.a8real.util
{

	import net.area80.a8real.calculation.LatLngBounds;

	public class MapUtil
	{
		public static const FLOAT_ERROR_MARGIN:Number = 1e-09;

		public function MapUtil()
		{
			return;
		}



		public static function degreesToRadians(param1:Number):Number
		{
			return param1 * (Math.PI / 180);
		}

		public static function bound(value:Number, min:Number = NaN, max:Number = NaN):Number
		{
			if (!isNaN(min)) {
				value = Math.max(value, min);
			}
			if (!isNaN(max)) {
				value = Math.min(value, max);
			}
			return value;
		}

		public static function calculateLatLngBounds(latlngs:Array):LatLngBounds
		{

			if (latlngs != null && latlngs.length > 0) {
				var bounds:LatLngBounds = new LatLngBounds();
				var i:uint = 0;
				while (i < latlngs.length) {

					bounds.extend(latlngs[i]);
					i = i + 1;
				}
				return bounds;
			} else {
				return null;
			}
		}

		public static function wrapHalfOpen(value:Number, min:Number, max:Number):Number
		{
			while (value >= max) {

				value = value - (max - min);
			}
			while (value < min) {

				value = value + (max - min);
			}
			return value;
		}


		public static function wrap(value:Number, min:Number, max:Number):Number
		{
			while (value > max) {

				value = value - (max - min);
			}
			while (value < min) {

				value = value + (max - min);
			}
			return value;
		}

		public static function wrapPeriod(param1:Number, param2:Number, param3:Number, param4:Number):Number
		{
			while (param1 > param3) {

				param1 = param1 - param4;
			}
			while (param1 < param2) {

				param1 = param1 + param4;
			}
			return param1;
		}

		public static function getBooleanOrDefault(param1:Object, param2:String, param3:Boolean = false):Boolean
		{
			if (param1.hasOwnProperty(param2)) {
				return param1[param2] as Boolean;
			}
			return param3;
		}

		public static function hasNonNullProperty(param1:Object, param2:String):Boolean
		{
			if (param1.hasOwnProperty(param2)) {
				return param1[param2] != null;
			}
			return false;
		}

		public static function copyObject(param1:Object, param2:Object):void
		{
			var _loc_3:Object = null;
			for (_loc_3 in param2) {

				param1[_loc_3] = param2[_loc_3];
			}
			return;
		}



		public static function approxEquals(param1:Number, param2:Number, param3:Number = 1e-09):Boolean
		{
			return Math.abs(param1 - param2) <= param3;
		}

		public static function radiansToDegrees(param1:Number):Number
		{
			return param1 / (Math.PI / 180);
		}

		public static function cloneObject(param1:Object):Object
		{
			var _loc_2:Object = null;
			var _loc_3:Object = null;
			_loc_2 = new Object();
			for (_loc_3 in param1) {

				_loc_2[_loc_3] = param1[_loc_3];
			}
			return _loc_2;
		}


	}
}
