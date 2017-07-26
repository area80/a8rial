package net.area80.a8real.util
{

	import net.area80.a8real.data.LatLng;

	public class Polyline
	{

		public static function getEncodingLevelByZoom(zoom:int):int
		{
			if (zoom >= 0 && zoom <= 5) {
				return 0;
			} else if (zoom >= 6 && zoom <= 10) {
				return 1;
			} else if (zoom >= 11 && zoom <= 14) {
				return 2;
			} else if (zoom >= 15 && zoom <= 18) {
				return 3;
			} else {
				return 4;
			}
		}

		private var encodedPolyline:String;
		private var encodedLevels:String;
		private var _coordinates:Vector.<LatLng>;

		public function Polyline(encodedPolyline:String, encodedLevels:int)
		{
			this._coordinates = new Vector.<LatLng>();

			var sb:String = "";
			// The encodedLevels is a string of "B" of size length.
			for (var i:int = 0; i < encodedLevels; i++) {
				sb += 'B';
			}

			this.encodedLevels = sb;
			this.encodedPolyline = encodedPolyline;
			this.decodeLine();
		}

		public function get length():int
		{
			return this._coordinates.length;
		}

		/**
		 *
		 * @return the encodedPolyline
		 */
		public function getEncodedPolyline():String
		{
			return encodedPolyline;
		}

		/**
		 *
		 * @return the encodedLevels
		 */
		public function getEncodedLevels():String
		{
			return encodedLevels;
		}

		/**
		 * @return an iterator for the list of GeoPoints.
		 */
		public function get coordinates():Vector.<LatLng>
		{
			return _coordinates;
		}

		/**
		 * This method is rewritten from Google's polyline utility which is written
		 * in Javascript. Decodes the class' encodedPolyline and stores the
		 * GeoPoints in the list of coordinates.
		 * See: http://code.google.com/apis/maps/documentation/include/polyline.js
		 */
		private function decodeLine():void
		{
			// Clear all stored coordinates.
			_coordinates = new Vector.<LatLng>;

			var len:int = encodedPolyline.length;
			var index:int = 0;
			var lat:int = 0;
			var lng:int = 0;

			// Decode polyline according to Google's polyline decoder utility.
			while (index < len) {
				var b:int;
				var shift:int = 0;
				var result:int = 0;
				do {
					b = encodedPolyline.charCodeAt(index++) - 63;
					result |= (b & 0x1f) << shift;
					shift += 5;
				} while (b >= 0x20);
				var dlat:int = (((result & 1) != 0) ? ~(result >> 1) : (result >> 1));
				lat += dlat;

				shift = 0;
				result = 0;
				do {
					b = encodedPolyline.charCodeAt(index++) - 63;
					result |= (b & 0x1f) << shift;
					shift += 5;
				} while (b >= 0x20);
				var dlng:int = (((result & 1) != 0) ? ~(result >> 1) : (result >> 1));
				lng += dlng;

				//trace("ll:" + lat * .00001 + "," + lng * .00001);
				_coordinates.push(new LatLng(lat * .00001, lng * .00001));
			}
		}
	}
}
