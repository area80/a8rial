package net.area80.geo
{
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SimulateLocationServices extends AbstractLocationService
	{
		protected var hasStatus:Boolean = false;

		protected var _timer:Timer;
		protected var _accuracySwingRange:Number = 5;
		protected var _setAccuracy:Number = 5;
		protected var _speedKmPerHour:Number = 60;
		protected var _moveDirection:Number = 60;
		protected var _timeStamp:int = 0;
		
		public function SimulateLocationServices (){
			_support = true;
			setAccuracy(5);
			_timer = new Timer(_requestUpdateInterval);
			_timer.addEventListener(TimerEvent.TIMER, timerUpdateHandler);
			_timer.start();
		}
		
		public function initStartLocation (lat:Number,lng:Number, speedKmPerHour:Number = 60, accuracySwingRange:Number = 5):void {
			_lat = lat;
			_lng = lng;
			
			_speedKmPerHour = speedKmPerHour;
			_accuracySwingRange = accuracySwingRange;
		}
		public function get speedKmPerHour():Number {
			return _speedKmPerHour;
		}
		public function set speedKmPerHour(value:Number):void {
			_speedKmPerHour = value;
		}
		public function get accuracySwingRange():Number {
			return _accuracySwingRange;
		}
		public function set accuracySwingRange(value:Number):void {
			_accuracySwingRange = value;
		}
		public function get moveDirection():Number {
			return _moveDirection;
		}
		public function set moveDirection(value:Number):void {
			_moveDirection = value;
		}
		protected function timerUpdateHandler(event:TimerEvent):void
		{
			if(!hasStatus) {
				hasStatus = true;
				_muted = false;
				_timeStamp = new Date().getTime()/1000;
				
				SIGNAL_STATUS.dispatch(this);
				_isConnected = true;
			}
			var sim:Array = getSimulateLocation();
			_lat = sim[0];
			_lng = sim[1];
			_accuracy = sim[2];
			
			locationChange();
			_timeStamp = new Date().getTime()/1000;
			
		}
		public function setAccuracy(value:Number):void
		{
			_setAccuracy = value;
			_accuracy = value;
		}
		protected function getSimulateLocation():Array {
			var res:Array = [_lat,_lng,_setAccuracy];
			const kmperlng:Number = 111.32;
			var timeDiffInHour:Number = (int(new Date().getTime()/1000)-_timeStamp)/3600;
			var km:Number = _speedKmPerHour*timeDiffInHour;
			var lngChange:Number = km/kmperlng;
			res[0] += Math.sin(_moveDirection*Math.PI/180)*randomRatio(.9,lngChange);
			res[1] += Math.cos(_moveDirection*Math.PI/180)*randomRatio(.9,lngChange);
			res[2] += Math.random()*_accuracySwingRange;
			return res;
		}
		private function randomRatio(r:Number,value:Number):Number {
			return value*r+Math.random()*(1-r)*value;
		}
		
		override public function set requestedUpdateInterval(milliseconds:Number):void {
			_timer.delay = milliseconds;
			super.requestedUpdateInterval = milliseconds;
		}
		
		override public function get isSupport():Boolean{
			return true;
		}
		
		override public function get isMuted():Boolean{
			return false;
		}
		
		override public function dispose():void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, timerUpdateHandler);
		}
		
	}
}

