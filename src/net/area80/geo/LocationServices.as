package net.area80.geo
{
	
	import flash.events.GeolocationEvent;
	import flash.events.StatusEvent;
	import flash.sensors.Geolocation;
	
	public class LocationServices extends AbstractLocationService
	{
		protected var geo:Geolocation;
		
		public function LocationServices (){
			if (Geolocation.isSupported) {
				_support = true;
				geo = new Geolocation();
				geo.addEventListener(StatusEvent.STATUS, onStatus);
				geo.addEventListener(GeolocationEvent.UPDATE, onGeoUpdate);
			} else {
				_support = false;
			}
		}
		
		override public function set requestedUpdateInterval(milliseconds:Number):void {
			if( geo )
			geo.setRequestedUpdateInterval(milliseconds);
			super.requestedUpdateInterval = milliseconds;
		}
		
		protected function onGeoUpdate(event:GeolocationEvent):void
		{
			if (!_isConnected) {
				geo.setRequestedUpdateInterval(10000);
			}
			_lat = event.latitude;
			_lng = event.longitude;
			_accuracy = event.horizontalAccuracy;
			_alt = event.altitude;
			
			_isConnected = true;
			locationChange();
		}
		override public function dispose():void {
			if(geo) {
				geo.removeEventListener(StatusEvent.STATUS, onStatus);
				geo.removeEventListener(GeolocationEvent.UPDATE, onGeoUpdate);
			}
		}
		
		protected function onStatus(event:StatusEvent):void{
			_muted = geo.muted;
			SIGNAL_STATUS.dispatch(this);
		}
		
		override public function get isSupport():Boolean{
			return Geolocation.isSupported;
		}
		
		override public function get isMuted():Boolean{
			if (!geo) return false;
			return geo.muted;
		}
	}
}

