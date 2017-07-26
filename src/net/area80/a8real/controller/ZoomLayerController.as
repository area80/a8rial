package net.area80.a8real.controller
{

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import net.area80.a8real.calculation.MercatorProjection;
	import net.area80.a8real.initial.MapOptions;
	import net.area80.a8real.view.interfaces.IContainerView;
	import net.area80.a8real.view.interfaces.ITileView;

	public class ZoomLayerController extends LayerController
	{

		private var _zoom:int;
		private var _scale:Number = 1;
		private var _mapTypeId:String;
		private var _overlaying:Boolean = true;

		private var tiles:Dictionary = new Dictionary(true);
		private var initCount:int = 0;

		public function ZoomLayerController(zoom:int, mapTypeId:String, frame:Rectangle, canvas:IContainerView, options:MapOptions, projection:MercatorProjection)
		{

			super(canvas, options, projection, frame);
			canvas.touchEnabled = false;
			this._zoom = zoom;
			this._mapTypeId = mapTypeId;

		}

		public function get zoom():int
		{
			return _zoom;
		}

		public function setUnderlayingMode():void
		{
			_overlaying = false;
		}

		public function setOverlayingMode():void
		{
			_overlaying = true;
		}

		private function get container():IContainerView
		{
			return _view as IContainerView;
		}

		private function loadTileAt(point:Point):void
		{
			var sp:Point = point.clone();
			if (projection.tileCheckRange(point, zoom)) {
				var tile:ITileView = tiles[sp.x + ":" + sp.y];
				if (!tile) {
					tile = options.newTile(point.x, point.y, sp.x, sp.y, zoom, _mapTypeId,this.options.ServerType);
					tile.x = sp.x * 256;
					tile.y = sp.y * 256;
					tiles[sp.x + ":" + sp.y] = tile;
					container.addSubCanvas(tile);
				}
			}
		}

		public function set scale(value:Number):void
		{
			if (_scale != value) {
				_scale = value;
				framechange = true;
			}
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function clearAllTile():void
		{
			for (var key:* in tiles) {
				var tile:ITileView = tiles[key];
				tile.destroy();
				container.removeSubCanvas(tile);
				delete tiles[key];
			}
		}


		protected function loadAllTilesInRect(rect:Rectangle):void
		{

			var firstX:int = Math.floor(rect.x / 256);
			var totalX:int = Math.ceil(rect.width / 256);
			var firstY:int = Math.floor(rect.y / 256);
			var totalY:int = Math.ceil(rect.height / 256);

			if (256 * firstX + totalX * 256 < rect.x + rect.width)
				totalX += 1;
			if (256 * firstY + totalY * 256 < rect.y + rect.height)
				totalY += 1;

			for (var key:* in tiles) {
				var tile:ITileView = tiles[key];
				if (tile.realx < firstX || tile.realx >= firstX + totalX || tile.realy < firstY || tile.realy >= firstY + totalY) {
					tile.destroy();
					container.removeSubCanvas(tile);
					delete tiles[key];
				}
			}
			var p:Point = new Point();

			for (var i:int = firstX; i < firstX + totalX; i++) {
				for (var j:int = firstY; j < firstY + totalY; j++) {
					p.x = i;
					p.y = j;
					loadTileAt(p);
				}
			}

		}

		public function get isInit():Boolean
		{
			return initCount > options.timeBeforeZoomLayerInit;
		}

		public function get tileLoadPercentage():Number
		{
			var p:int = 0;
			var c:int = 0;
			for each (var tile:ITileView in tiles) {
				if (tile.isLoaded)
					p++;
				c++;
			}
			return (p / c) * 100;
		}

		public override function updateIfNeeded(forceUpdate:Boolean = false):void
		{
			if (!isInit) {
				initCount++;
				return;
			}

			if (_changeWhilePressed) {
				forceUpdate = true;
				_changeWhilePressed = false;
			}
			if (_overlaying) {
				overlayLayerUpdate(forceUpdate);
			} else {
				underlayLayerUpdate(forceUpdate);
			}

			super.updateIfNeeded(forceUpdate);
		}

		protected function underlayLayerUpdate(forceUpdate:Boolean = false):void
		{
			if (latlngchange || forceUpdate) {
				projection.fromLatLngToPixelLight(_centerLatDegrees, _centerLngDegrees, _zoom, _centerPixels);
				//if lat lng change frame must be change too
				framechange = true;
			}

			if (framechange || forceUpdate) {

				var reverseScale:Number = 1 / _scale;

				container.scale = _scale;
				var mw:Number = _frame.width * reverseScale;
				var mh:Number = _frame.height * reverseScale;
				_displayRect.x = _centerPixels.x - (mw * .5);
				_displayRect.y = _centerPixels.y - (mh * .5);

				container.x = -_displayRect.x * _scale;
				container.y = -_displayRect.y * _scale;

				_displayRect.width = mw;
				_displayRect.height = mh;

				container.scale = _scale;


			}
		}

		protected function overlayLayerUpdate(forceUpdate:Boolean = false):void
		{
			if (latlngchange || forceUpdate) {
				projection.fromLatLngToPixelLight(_centerLatDegrees, _centerLngDegrees, _zoom, _centerPixels);
				//if lat lng change frame must be change too
				framechange = true;
			}

			if (framechange || forceUpdate) {

				var reverseScale:Number = 1 / _scale;

				container.scale = _scale;
				var mw:Number = _frame.width * reverseScale;
				var mh:Number = _frame.height * reverseScale;

				_displayRect.x = _centerPixels.x - (mw * .5);
				_displayRect.y = _centerPixels.y - (mh * .5);

				container.x = -_displayRect.x * _scale;
				container.y = -_displayRect.y * _scale;

				//	if (_scale > .7) {
				if (!_helvedUpdate || forceUpdate) {
					_displayRect.width = mw;
					_displayRect.height = mh;
					loadAllTilesInRect(_displayRect);
				} else {
					_changeWhilePressed = true;
				}
					//}

			}
		}

		public override function dispose():void
		{
			clearAllTile();
			super.dispose();
		}

	}
}
