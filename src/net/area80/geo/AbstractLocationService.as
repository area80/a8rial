package net.area80.geo
{
	
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	public class AbstractLocationService
	{
		public var SIGNAL_LOCATIONCHANGE:Signal = new Signal(AbstractLocationService);
		/**
		 * Get Geostatus, here you can check mute status 
		 */
		public var SIGNAL_STATUS:Signal = new Signal(AbstractLocationService);
		
		protected var _lat:Number = 0;
		protected var _lng:Number = 0;
		protected var _alt:Number = 0;
		protected var _accuracy:Number = 0;
		
		protected var _muted:Boolean = true;
		protected var _support:Boolean = false;
		protected var _isInit:Boolean = false;
		protected var _isConnected:Boolean = false;

		protected var _requestUpdateInterval:Number = 10000;

		protected var prevLocation:Point;

		private var stampTime:int;

		private var _distancekm:Number = 0;
		private var _kmph:Number = 0;
		
		public function AbstractLocationService (){
			
		}
		
		/**
		 * True, if there are atleast one signal dispatched from Geolocation 
		 * @return 
		 * 
		 */
		public function isConnected():Boolean
		{
			return _isConnected;
		}
		
		public function get lat():Number
		{
			return _lat;
		}
		
		public function get lng():Number
		{
			return _lng;
		}
		public function get accuracy():Number
		{
			return _accuracy;
		}
		public function get altitude():Number
		{
			return _alt;
		}
		
		public function get isMuted():Boolean
		{
			return _muted;
		}
		/**
		 *  
		 * @return Kilometre per hour
		 * 
		 */
		public function get kmph ():Number {
			return _kmph;
		}
		/**
		 *  
		 * @return Distance in Kilometre
		 * 
		 */
		public function get distancekm ():Number {
			return _distancekm;
		}
		
		
		/**
		 * After initGeoLocation, you can ckeck if device is support or not  
		 * @return 
		 * 
		 */
		public function get isSupport():Boolean
		{
			return _support;
		}
		
		/**
		 * Used to set the time interval for updates, in milliseconds. The update interval is only used as a hint to conserve the battery power.
		 * The actual time between location updates may be greater or lesser than this value.
		 * Any change in the update interval using this method affects all registered update event listeners.
		 * The Geolocation class can be used without calling the setRequestedUpdateInterval method.
		 * In this case, the platform will return updates based on its default interval.
		 * Note: First-generation iPhones, which do not include a GPS unit, dispatch update events only occasionally.
		 * On these devices, a Geolocation object initially dispatches one or two update events.
		 * It then dispatches update events when information changes noticeably.
		 *
		 * * @param milliseconds 
		 */
		public function set requestedUpdateInterval(milliseconds:Number):void {
			_requestUpdateInterval = milliseconds;
		}
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get requestedUpdateInterval():Number {
			return _requestUpdateInterval;
		}
		public function dispose():void{
		
		}
		protected function locationChange():void {
			if(!prevLocation) {
				prevLocation = new Point(_lat,_lng);
			} else {
				const kmperlng:Number = 111.32;
				var cLocation:Point = new Point(_lat,_lng);
				var dist:Number = Math.abs(Point.distance(prevLocation,cLocation));
				dist = isNaN(dist)?0:dist;
				var d:int = int(new Date().getTime()/1000)-stampTime;
				_distancekm = dist*kmperlng;
				_kmph = (3600/d)*_distancekm;
				
				prevLocation.x = _lat;
				prevLocation.y = _lng;
			}
			stampTime = new Date().getTime()/1000;
			SIGNAL_LOCATIONCHANGE.dispatch(this);
		}
		
		
	}
}

