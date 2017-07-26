package net.area80.a8real.calculation
{

	import flash.geom.*;

	import net.area80.a8real.data.LatLng;
	import net.area80.a8real.util.MapUtil;

	final public class MercatorProjection
	{
		private var pixelBounds:Array;
		public var pixelsPerLonDegree:Array;
		private var pixelOrigo:Array;
		public var pixelsPerLonRadian:Array;
		public static const MERCATOR_ZOOM_LEVEL_ZERO_RANGE:Number = 256;

		public function MercatorProjection(zoomLevel:Number)
		{

			pixelsPerLonDegree = [];
			pixelsPerLonRadian = [];
			pixelOrigo = [];
			pixelBounds = [];
			var currentZoomRange:Number = MERCATOR_ZOOM_LEVEL_ZERO_RANGE;
			var zoomCount:int = 0;
			while (zoomCount < zoomLevel) {

				var center:Number = currentZoomRange / 2;
				pixelsPerLonDegree.push(currentZoomRange / 360);
				pixelsPerLonRadian.push(currentZoomRange / (2 * Math.PI));
				pixelOrigo.push(new Point(center, center));
				pixelBounds.push(currentZoomRange);
				currentZoomRange = currentZoomRange * 2;
				zoomCount++;
			}
			return;
		}

		public function fromPixelToLatLng(fromPoint:Point, zoomLevel:Number, nowrap:Boolean = false):LatLng
		{
			var center:Point = pixelOrigo[zoomLevel];
			var lng:Number = (fromPoint.x - center.x) / pixelsPerLonDegree[zoomLevel];
			var latRadian:Number = (fromPoint.y - center.y) / (-pixelsPerLonRadian[zoomLevel]);
			var lat:Number = MapUtil.radiansToDegrees(2 * Math.atan(Math.exp(latRadian)) - Math.PI / 2);
			return new LatLng(lat, lng, nowrap);
		}

		public function fromLatLngToPixelLight(lat:Number, lng:Number, zoomLevel:Number, point:Point = null):Point
		{

			var center:Point = pixelOrigo[zoomLevel];
			var _loc_4:Number = center.x + lng * pixelsPerLonDegree[zoomLevel];
			var _loc_5:Number = MapUtil.bound(Math.sin(MapUtil.degreesToRadians(lat)), -0.9999, 0.9999);
			var _loc_6:Number = center.y + 0.5 * Math.log((1 + _loc_5) / (1 - _loc_5)) * (-pixelsPerLonRadian[zoomLevel]);

			if (!point) {
				return new Point(_loc_4, _loc_6);
			} else {
				point.x = _loc_4;
				point.y = _loc_6;
				return point;
			}

		}

		public function fromLatLngToPixel(fromLatLng:LatLng, zoomLevel:Number):Point
		{
			var center:Point = pixelOrigo[zoomLevel];
			var _loc_4:Number = center.x + fromLatLng.lng() * pixelsPerLonDegree[zoomLevel];
			var _loc_5:Number = MapUtil.bound(Math.sin(MapUtil.degreesToRadians(fromLatLng.lat())), -0.9999, 0.9999);
			var _loc_6:Number = center.y + 0.5 * Math.log((1 + _loc_5) / (1 - _loc_5)) * (-pixelsPerLonRadian[zoomLevel]);
			return new Point(_loc_4, _loc_6);
		}

		public function tileCheckRange(tile:Point, zoomLevel:Number, tileSize:uint = 256):Boolean
		{
			var pixelBounds:Number = pixelBounds[zoomLevel];
			var totalTile:Number = Math.floor(pixelBounds / tileSize);
			if (tile.y < 0 || tile.y >= totalTile) {
				return false;
			}
			if (tile.x < 0 || tile.x >= totalTile) {
				return false;
				tile.x = tile.x % totalTile;
				if (tile.x < 0) {
					tile.x = totalTile + tile.x;
				}
			}
			return true;
		}

		public function getWrapWidth(zoomLevel:Number):Number
		{
			return pixelBounds[zoomLevel];
		}

	}
}
