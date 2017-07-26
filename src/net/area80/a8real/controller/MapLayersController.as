package net.area80.a8real.controller
{

	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import net.area80.a8real.calculation.MercatorProjection;
	import net.area80.a8real.enum.GoogleMapType;
	import net.area80.a8real.initial.MapOptions;
	import net.area80.a8real.view.interfaces.IBackgroundView;
	import net.area80.a8real.view.interfaces.IContainerView;

	public class MapLayersController extends LayerController
	{
		protected var zoomlayers:Dictionary = new Dictionary();

		protected var currentZoomLayerController:ZoomLayerController;
		protected var underlayingZoomLayerController:ZoomLayerController;

		protected var _mapTypeId:String = GoogleMapType.ROADMAP;
		protected var _zoom:Number;
		protected var zoomchange:Boolean = false;
		protected var backgroundView:IBackgroundView;

		public function MapLayersController(baseview:IContainerView, options:MapOptions, backgroundView:IBackgroundView, projection:MercatorProjection, frame:Rectangle, zoom:Number)
		{

			this.zoom = zoom;
			this.backgroundView = backgroundView;

			super(baseview, options, projection, frame);

		}

		public function set zoom(value:Number):void
		{

			if (_zoom != value) {
				zoomchange = true;
			}
			_zoom = value;

		}

		private function isDisplayingLayer(zoomLayerToTest:ZoomLayerController):Boolean
		{

			if (currentZoomLayerController && currentZoomLayerController == zoomLayerToTest) {
				return true;
			}
			if (underlayingZoomLayerController && underlayingZoomLayerController == zoomLayerToTest) {
				return true;
			}
			return false;

		}

		private function cleanupZoomLayer():void
		{

			var layer:ZoomLayerController;

			if ((currentZoomLayerController && currentZoomLayerController.tileLoadPercentage >= 100) || (underlayingZoomLayerController && underlayingZoomLayerController.tileLoadPercentage >= 100)) {

				for each (layer in zoomlayers) {
					if (!isDisplayingLayer(layer)) {
						layer.dispose();
						container.removeSubCanvas(layer.view);
						delete zoomlayers[layer.zoom];
					}
				}

				if (underlayingZoomLayerController && (currentZoomLayerController && currentZoomLayerController.tileLoadPercentage >= 100)) {
					underlayingZoomLayerController.dispose();
					container.removeSubCanvas(underlayingZoomLayerController.view);
					delete zoomlayers[underlayingZoomLayerController.zoom];
					underlayingZoomLayerController = null;
				}
			}

		}

		override public function dispose():void
		{

			backgroundView.destroy();

			for each (var zoomlayer:ZoomLayerController in zoomlayers) {
				zoomlayer.dispose();
			}
			super.dispose();

		}

		public function get zoom():Number
		{

			return _zoom;

		}

		protected function get container():IContainerView
		{

			return view as IContainerView;

		}

		protected function getZoomLayerAt(izoom:int, autoCreated:Boolean = true):ZoomLayerController
		{

			if (!zoomlayers[izoom] && autoCreated) {
				var zoomlayer:ZoomLayerController = new ZoomLayerController(izoom, _mapTypeId, frame, options.newContainer(), options, projection);
				zoomlayers[izoom] = zoomlayer;
			}
			zoomlayers[izoom].setCenterLatLngDegrees(_centerLatDegrees, _centerLngDegrees);
			return zoomlayers[izoom];

		}

		public function set mapType(type:String):void
		{

			_mapTypeId = type;

		}

		public function get mapType():String
		{

			return _mapTypeId;

		}

		private function createNewZoomLayerIfNeeded():void
		{

			var newzoom:int = options.roundUpZoom(_zoom);
			if (currentZoomLayerController && currentZoomLayerController.zoom == _zoom) {
				return
			}

			var scale:Number = 1;
			if (newzoom > _zoom) {
				scale = (2 - (newzoom - _zoom)) / 2;
			} else if (newzoom < _zoom) {
				scale = 1 + (_zoom - newzoom);
			}

			var newLayer:ZoomLayerController = getZoomLayerAt(newzoom);
			newLayer.setOverlayingMode();
			newLayer.scale = scale;

			var underlayLayer:ZoomLayerController;
			if (underlayingZoomLayerController && underlayingZoomLayerController.zoom < newzoom) {
				if (currentZoomLayerController && currentZoomLayerController.zoom < newzoom && currentZoomLayerController.tileLoadPercentage > 50) {
					underlayLayer = currentZoomLayerController;
				} else {
					underlayLayer = underlayingZoomLayerController;
				}
			} else if (currentZoomLayerController && currentZoomLayerController.zoom < newzoom) {
				underlayLayer = currentZoomLayerController;
			} else {
				underlayLayer = getZoomLayerAt(newzoom - 2);
			}

			underlayLayer.setUnderlayingMode();
			underlayLayer.scale = scale * Math.pow(2, newLayer.zoom - underlayLayer.zoom);

			if (currentZoomLayerController && (currentZoomLayerController != newLayer && currentZoomLayerController != underlayLayer)) {
				currentZoomLayerController.setUnderlayingMode();
			}

			if (underlayingZoomLayerController && (underlayingZoomLayerController != newLayer && underlayingZoomLayerController != underlayLayer)) {
				underlayingZoomLayerController.setUnderlayingMode();
			}

			var newLayerIsExists:Boolean = (currentZoomLayerController && (currentZoomLayerController == newLayer || underlayingZoomLayerController == newLayer));
			var undarlayLayerIsExists:Boolean = (underlayingZoomLayerController && (currentZoomLayerController == underlayLayer || underlayingZoomLayerController == underlayLayer));

			currentZoomLayerController = newLayer;
			underlayingZoomLayerController = underlayLayer;

			currentZoomLayerController.setCenterLatLngDegrees(_centerLatDegrees, _centerLngDegrees);
			underlayingZoomLayerController.setCenterLatLngDegrees(_centerLatDegrees, _centerLngDegrees);

			container.addSubCanvasAt(underlayingZoomLayerController.view, 0);
			container.addSubCanvas(currentZoomLayerController.view);

		}

		public function updateZoomToLayers():void
		{

			for each (var layer:ZoomLayerController in zoomlayers) {

				var currentZoom:int = layer.zoom;
				var nextZoom:Number = _zoom;
				var nextScale:Number = 1;

				if (nextZoom != currentZoom) {

					var multiplier:Number;
					if (nextZoom > currentZoom) {
						multiplier = nextZoom - currentZoom;
						while (multiplier > 1) {
							nextScale *= 2;
							multiplier--;
						}
						nextScale *= 1 + multiplier;
					} else if (nextZoom < currentZoom) {
						multiplier = currentZoom - Math.floor(nextZoom);
						var s:Number = nextZoom - Math.floor(nextZoom);
						while (multiplier > 0) {
							nextScale *= .5;
							multiplier--;
						}
						nextScale *= 1 + s;
					} else {
						nextScale = multiplier;
					}

					layer.scale = nextScale;

				}
			}

			createNewZoomLayerIfNeeded();

		}

		protected function updateLatLngToLayers():void
		{

			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.setCenterLatLngDegrees(_centerLatDegrees, _centerLngDegrees);
			}
			backgroundView.scrollX = (currentZoomLayerController.view.x * currentZoomLayerController.scale) % 32;
			backgroundView.scrollY = (currentZoomLayerController.view.y * currentZoomLayerController.scale) % 32;

			//backgroundView.zoomScale = 1+currentZoomLayerController.scale;
		}

		protected function updateFrameToLayers():void
		{

			container.frame = frame;
			backgroundView.width = frame.width;
			backgroundView.height = frame.height;
			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.frame = frame;
			}

		}

		override public function updateIfNeeded(forceUpdate:Boolean = false):void
		{

			//1. Need to update zoom first, to create zoom layers if needed.
			if (zoomchange || forceUpdate) {
				updateZoomToLayers();
			}

			if (latlngchange || forceUpdate) {
				updateLatLngToLayers();
			}

			if (framechange || forceUpdate) {
				updateFrameToLayers();
			}

			cleanupZoomLayer();

			//broadcast update to layers
			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.updateIfNeeded(forceUpdate);
			}

			zoomchange = false;
			latlngchange = false;
			super.updateIfNeeded(forceUpdate);

		}
		
		public function clearAllTile():void{
			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.clearAllTile();
			}
		}

		override public function set frame(value:Rectangle):void
		{

			super.frame = value;
			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.frame = frame;
			}

		}

		override public function holdUpdate():void
		{

			super.holdUpdate();
			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.holdUpdate();
			}

		}

		override public function releaseUpdate():void
		{

			super.releaseUpdate();
			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.releaseUpdate();
			}

		}

		override public function setCenterLatLngDegrees(lat:Number, lng:Number):void
		{

			super.setCenterLatLngDegrees(lat, lng);

			for each (var layer:ZoomLayerController in zoomlayers) {
				layer.setCenterLatLngDegrees(_centerLatDegrees, _centerLngDegrees);
			}

		}

	}
}
