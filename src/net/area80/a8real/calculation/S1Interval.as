package net.area80.a8real.calculation
{

	import net.area80.a8real.util.MapUtil;
	import net.area80.a8real.util.MapUtil;

	/**
	 * For Longtitude
	 *
	 */
	public class S1Interval extends Object
	{
		public var hi:Number;
		public var lo:Number;

		public function S1Interval(param1:Number, param2:Number)
		{
			if (param1==-Math.PI&&param2!=Math.PI) {
				lo = Math.PI;
			}
			if (param2==-Math.PI&&param1!=Math.PI) {
				hi = Math.PI;
			}
			lo = param1;
			hi = param2;
			return;
		}

		public function containsInterval(param1:S1Interval):Boolean
		{
			if (isInverted()) {
				if (param1.isInverted()) {
					return param1.lo>=lo&&param1.hi<=hi;
				}
				return (param1.lo>=lo||param1.hi<=hi)&&!isEmpty();
			} else {
				if (param1.isInverted()) {
					return isFull()||param1.isEmpty();
				}
				return param1.lo>=lo&&param1.hi<=hi;
			}
		}

		public function isEmpty():Boolean
		{
			return lo-hi==2*Math.PI;
		}

		public function contains(param1:Number):Boolean
		{
			if (param1==-Math.PI) {
				param1 = Math.PI;
			}
			if (isInverted()) {
				return (param1>=lo||param1<=hi)&&!isEmpty();
			}
			return param1>=lo&&param1<=hi;
		}

		public function span():Number
		{
			if (isEmpty()) {
				return 0;
			}
			if (isInverted()) {
				return 2*Math.PI-(lo-hi);
			}
			return hi-lo;
		}

		public function intersects(param1:S1Interval):Boolean
		{
			if (isEmpty()||param1.isEmpty()) {
				return false;
			}
			if (isInverted()) {
				return param1.isInverted()||param1.lo<=hi||param1.hi>=lo;
			}
			if (param1.isInverted()) {
				return param1.lo<=hi||param1.hi>=lo;
			}
			return param1.lo<=hi&&param1.hi>=lo;
		}

		public function center():Number
		{
			var _loc_1:Number = NaN;
			_loc_1 = (lo+hi)/2;
			if (isInverted()) {
				_loc_1 = _loc_1+Math.PI;
				_loc_1 = MapUtil.wrap(_loc_1, -Math.PI, Math.PI);
			}
			return _loc_1;
		}

		public function equals(param1:S1Interval):Boolean
		{
			if (isEmpty()) {
				return param1.isEmpty();
			}
			return Math.abs(param1.lo-lo)%2*Math.PI+Math.abs(param1.hi-hi)%2*Math.PI<=MapUtil.FLOAT_ERROR_MARGIN;
		}

		public function isFull():Boolean
		{
			return hi-lo==2*Math.PI;
		}

		public function extend(param1:Number):void
		{
			if (contains(param1)) {
				return;
			}
			if (isEmpty()) {
				hi = param1;
				lo = param1;
			} else if (distance(param1, lo)<distance(hi, param1)) {
				lo = param1;
			} else {
				hi = param1;
			}
			return;
		}

		public function isInverted():Boolean
		{
			return lo>hi;
		}

		public static function fromObject(param1:Object):S1Interval
		{
			if (param1==null) {
				return null;
			}
			return new S1Interval(param1.lo, param1.hi);
		}

		public static function distance(param1:Number, param2:Number):Number
		{
			var _loc_3:Number = NaN;
			_loc_3 = param2-param1;
			if (_loc_3>=0) {
				return _loc_3;
			}
			return param2+Math.PI-(param1-Math.PI);
		}
	}
}
