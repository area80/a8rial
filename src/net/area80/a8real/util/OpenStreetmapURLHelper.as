package net.area80.a8real.util
{

	import net.area80.a8real.enum.OpenStreetMapType;

	public class OpenStreetmapURLHelper{
		public static const BASIC_MAP_URL:String = "http://tile.openstreetmap.org/";
		public static const MAPQUEST_URL:String = "http://otile[$SERVER].mqcdn.com/tiles/1.0.0/osm/";
		public static const OPENCYCLE_URL:String = "http://[$SERVER].tile.opencyclemap.org/cycle/";

		public static function composeURLByTile(tx:int, ty:int, zoom:int, mapTypeId:String):String
		{
			var server:String = getServerURL(mapTypeId);
			//var tileURL:String =  "http://tile.openstreetmap.org/"+zoom+"/"+tx+"/"+ty+".png";
			// EX : http://tile.openstreetmap.org/16/51076/30240.png
			
			var tileURL:String =  server + zoom + "/" + tx + "/" + ty +".png";

			return tileURL;
		}

		private static function getServerURL(mapTypeId:String):String{
			// random between 3 server
			const SERVERS:int = 3;
			var randomserver:int = 1 + Math.round( (SERVERS - 1) * Math.random() );
			var res:String;
			switch (mapTypeId) {
				case OpenStreetMapType.MAPQUEST:
					res = MAPQUEST_URL;
					res = res.split("[$SERVER]").join(randomserver);
					break;
				case OpenStreetMapType.OPENCYCLE:
					res = OPENCYCLE_URL;
					res = res.split("[$SERVER]").join(String.fromCharCode(96+randomserver));
					break;
				default : // OpenStreetMapType.BASIC
					res = BASIC_MAP_URL;
			}
			return res;
		}

	}
}
