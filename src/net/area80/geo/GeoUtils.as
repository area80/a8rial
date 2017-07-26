package net.area80.geo
{

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLVariables;


	public class GeoUtils
	{
		private static const DECIMAL:uint = 1000000;

		public static function createLatLonFromGoogleURI(path:String):Array
		{
			var urlRequest:URLRequest = new URLRequest(path);
			var ul:URLVariables = new URLVariables(path);

			if (ul["ll"] && ul["ll"].split(",").length == 2) {
				var ll:Array = ul["ll"].split(",");
				return new Array(Number(ll[0]), Number(ll[1]));
			} else {
				return null;
			}
		}

		public static function convertLatLonToFlashPoint(lat:Number, lng:Number, srcRect:Rectangle):Point
		{
			var p:Point = new Point();

			var src_xmin:Number = srcRect.x;
			var th_xmin:Number = GoogleTHRectangle.TOP_LEFT.lng() * DECIMAL;

			var src_xmax:Number = srcRect.right;
			var th_xmax:Number = GoogleTHRectangle.TOP_RIGHT.lng() * DECIMAL;

			var src_ymin:Number = srcRect.y;
			var th_ymin:Number = GoogleTHRectangle.TOP_LEFT.lat() * DECIMAL;

			var src_ymax:Number = srcRect.bottom;
			var th_ymax:Number = GoogleTHRectangle.BOTTOM_LEFT.lat() * DECIMAL;

			var src_width:Number = srcRect.width;
			var th_width:Number = th_xmax - th_xmin;

			var src_height:Number = srcRect.height;
			var th_height:Number = th_ymin - th_ymax; //flip bottom to top

			var c_x:Number = lng * DECIMAL - th_xmin;
			var c_y:Number = th_ymin - lat * DECIMAL; //flip bottom to top

			var ratio_x:Number = c_x / th_width;
			var ratio_y:Number = c_y / th_height;

			p.x = src_xmin + src_width * ratio_x;
			p.y = src_ymin + src_height * ratio_y;

			return p;
		}
	}
}
