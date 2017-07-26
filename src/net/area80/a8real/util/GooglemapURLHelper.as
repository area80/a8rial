package net.area80.a8real.util
{

	import net.area80.a8real.enum.GoogleMapType;

	public class GooglemapURLHelper
	{
		//["http://mt0.google.com/mapslt","http://mt1.google.com/mapslt","http://mt2.google.com/mapslt","http://mt3.google.com/mapslt"]
		public static const MAP_URL:String = "http://mt[$SERVER].google.com/vt/lyrs=m@177000000&hl=en&src=app&";
		public static const SATELLITE_URL:String = "http://khm[$SERVER].google.com/kh/v=113&src=app&";
		public static const HYBRID_URL:String = "http://mt[$SERVER].google.com/vt/lyrs=h@177000000&hl=en&src=app&";
		public static const PHYSICAL_URL:String = "http://mt[$SERVER].google.com/vt/lyrs=t@128,r@177000000&hl=en&src=app&";
		public static const SERVERS:int = 2;

		public static function composeURLByTile(tx:int, ty:int, zoom:int, mapTypeId:String):String
		{
			var server:String = getServerURL(mapTypeId);
			var lyrs:String = "m@177000000"; 
			var hl:String = "en"; 
			var src:String = "app";
			//var tileURL:String =  "http://tile.openstreetmap.org/"+zoom+"/"+tx+"/"+ty+".png";
			// EX : http://tile.openstreetmap.org/16/51076/30240.png
			var tileURL:String =  server + "x=" + tx + "&y=" + ty + "&z=" + zoom + "&s=" + getSecureWord(tx, ty);

			return tileURL;
		}

		private static function getServerURL(mapTypeId:String):String
		{
			//return "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Portland/ESRI_LandBase_WebMercator/MapServer/"
			var res:String = MAP_URL; 
			switch (mapTypeId) {
				case GoogleMapType.HYBRID:
					res = HYBRID_URL;
					break;
				case GoogleMapType.SATELLITE:
					res = SATELLITE_URL;
					break;
				case GoogleMapType.TERRAIN:
					res = PHYSICAL_URL;
					break;
			}
			return res.split("[$SERVER]").join(Math.round(Math.random() * SERVERS));
		}

		private static function getSecureWord(x:int, y:int):String
		{
			if (y >= 10000 && y < 100000) {
				return "";
			}
			var str:String = "Galileo";
			var len:int = (3 * x + y) % 8;
			return str.substring(0, len);
		}

	}
}
