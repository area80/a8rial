package net.area80.a8real
{

	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.area80.a8real.calculation.MercatorProjection;
	import net.area80.a8real.controller.InteractiveController;
	import net.area80.a8real.controller.MapLayersController;
	import net.area80.a8real.controller.OverlayLayerController;
	import net.area80.a8real.data.LatLng;
	import net.area80.a8real.enum.GoogleMapConst;
	import net.area80.a8real.enum.GoogleMapType;
	import net.area80.a8real.enum.ServerMapType;
	import net.area80.a8real.event.A8realMapEvent;
	import net.area80.a8real.initial.MapOptions;
	import net.area80.a8real.util.MapUtil;
	import net.area80.a8real.util.StarlingTileCache;
	import net.area80.a8real.view.interfaces.IBackgroundView;
	import net.area80.a8real.view.interfaces.IBaseView;
	import net.area80.a8real.view.interfaces.IContainerView;
	
	import starling.core.Starling;
	import starling.events.Event;


	/**
	 * Dispatchs when map has been hold to un-update state.
	 * @eventType net.area80.a8real.event.A8realMapEvent
	 */
	[Event(name = "hold", type = "net.area80.a8real.event.A8realMapEvent")]

	/**
	 * Dispatchs map has been released.
	 * @eventType net.area80.a8real.event.A8realMapEvent
	 */
	[Event(name = "released", type = "net.area80.a8real.event.A8realMapEvent")]

	/**
	 * Dispatchs when map zoom is changed.
	 * @eventType net.area80.a8real.event.A8realMapEvent
	 */
	[Event(name = "zoomchange", type = "net.area80.a8real.event.A8realMapEvent")]

	/**
	 * Dispatchs when map lat lng has been changed.
	 * @eventType net.area80.a8real.event.A8realMapEvent
	 */
	[Event(name = "latlngchange", type = "net.area80.a8real.event.A8realMapEvent")]

	public class A8realMap extends EventDispatcher
	{
		private var rootViewContainerView:IContainerView;
		private var zoomLayerContainerView:IContainerView;
		private var overlayLayerContainerView:IContainerView;
		private var backgroundView:IBackgroundView;
		private var LogoView:IBaseView;

		private var projection:MercatorProjection;

		private var frame:Rectangle = new Rectangle(0, 0, 400, 400);

		private var frameChange:Boolean = false;
		private var zoomChange:Boolean = false;
		private var mapTypeChange:Boolean = false; //TODO Change Map Type
		private var centerChange:Boolean = false;

		//get set
		private var _heldUpdate:Boolean = true;
		private var _zoom:Number = 0;
		private var _minZoom:int = 10;
		private var _maxZoom:int = 19;
		private var _mapTypeId:String = GoogleMapType.ROADMAP;

		private var _inertiaX:Number = 0;
		private var _inertiaY:Number = 0;

		private var _centerLatDegrees:Number = 0;
		private var _centerLngDegrees:Number = 0;

		public var overlayLayerController:OverlayLayerController;

		private var mapLayerController:MapLayersController;
		private var interactiveController:InteractiveController;

		private var currentPixels:Point = new Point();
		private var calcPoint:Point = new Point();

		private var options:MapOptions;
		private var _animateZoom:Number = 0;
		private var _animateLat:Number = 0;
		private var _animateLng:Number = 0;

		public function A8realMap(options:MapOptions, width:int = 400, height:int = 400, zoom:int = 10, centerlat:Number = 0, centerlng:Number = 0, mapTypeId:String = GoogleMapType.ROADMAP)
		{
			projection = new MercatorProjection(30);

			this.options = options;
			this.rootViewContainerView = this.options.newContainer();
			this.rootViewContainerView.masking = true;
			this.width = width;
			this.height = height;
			this.mapTypeId = mapTypeId;
			this.zoom = zoom;
			this.setCenterByLatLonDegrees(centerlat, centerlng,false);

			Starling.current.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
			
			initDisplay();
		}
		
		private function onContextCreated(e:starling.events.Event):void{
			mapLayerController.clearAllTile();
			StarlingTileCache.clearAllCache();
		}

		public function get view():IContainerView
		{
			return rootViewContainerView;
		}

		public function setCenterMapAtBounds(ne:LatLng, sw:LatLng, updateZoom:Boolean = true):void
		{
			var clat:Number = sw.lat() + (ne.lat() - sw.lat()) * .5;
			var clng:Number = sw.lng() + (ne.lng() - sw.lng()) * .5;
			setCenterByLatLonDegrees(clat, clng);

			if (updateZoom) {
				var availablePixels:Number = Math.min(frame.width, frame.height);
				var bounding:Number = Math.max(Math.abs(ne.lat() - sw.lat()), Math.abs(ne.lng() - sw.lng()));
				var szoom:int = maxZoom;
				var pixels:int = Math.pow(2, szoom) * 256;

				while (szoom > minZoom) {
					var pixelPerDegree:Number = pixels / 360;
					var pixelInbound:Number = (bounding * pixelPerDegree);
					if (pixelInbound < availablePixels) {
						break;
					}
					pixels /= 2;
					szoom--;
				}
				zoom = szoom;
			}
		}

		public function get centerLat():Number
		{
			return _centerLatDegrees;
		}

		public function get centerLng():Number
		{
			return _centerLngDegrees;
		}

		protected function initDisplay():void
		{

			backgroundView = options.newBackground();
			zoomLayerContainerView = options.newContainer();
			overlayLayerContainerView = options.newContainer();
			if (options.ServerType == ServerMapType.GOOGLE_MAP){
				LogoView = options.newGoogleLogo();
				LogoView.scale = options.elementScale;
			}
			

			rootViewContainerView.addSubCanvas(backgroundView); //0
			rootViewContainerView.addSubCanvas(zoomLayerContainerView); //1
			rootViewContainerView.addSubCanvas(overlayLayerContainerView); //2
			if (LogoView) rootViewContainerView.addSubCanvas(LogoView); //2

			interactiveController = new InteractiveController(this);
			backgroundView.responder = interactiveController;

			mapLayerController = new MapLayersController(zoomLayerContainerView, options, backgroundView, projection, frame, zoom);
			mapLayerController.mapType = mapTypeId; 
			overlayLayerController = new OverlayLayerController(overlayLayerContainerView, options, projection, frame, zoom);

			render();
		}

		public function dispose():void
		{
			Starling.current.removeEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
			options.dispose();

			backgroundView.responder = null;

			mapLayerController.dispose();
			overlayLayerController.dispose();

			backgroundView.destroy();
			if (LogoView) LogoView.destroy();
			zoomLayerContainerView.destroy();
			rootViewContainerView.destroy();
		}

		protected function wrapUpLatLng():void
		{
			var cZoom:int = Math.round(_zoom);
			var scale:Number = 1 + (_zoom - cZoom);

			var pixelPerLngWithScale:Number = projection.pixelsPerLonDegree[cZoom];
			var frameLng:Number = (frame.width * (1 / scale) * .5) / pixelPerLngWithScale;
			var frameLat:Number = ((frame.height * (1 / scale) * .5) / pixelPerLngWithScale) * .5;


			if (_centerLngDegrees > 180 - frameLng) {
				centerChange = true;
				_centerLngDegrees = 180 - frameLng;
			} else if (_centerLngDegrees < -180 + frameLng) {
				centerChange = true;
				_centerLngDegrees = -180 + frameLng;
			}

			if (_centerLatDegrees > 90 - frameLat) {
				centerChange = true;
				_centerLatDegrees = 90 - frameLat;
			} else if (_centerLatDegrees < -90 + frameLat) {
				centerChange = true;
				_centerLatDegrees = -90 + frameLat;
			}
		}

		public function render(forceRender:Boolean = false):void
		{
			options.beforeRender();

			interactiveController.framePassBy();

			if (options.touchInertia && Math.abs(_inertiaX) > 0.01 || Math.abs(_inertiaY) > 0.01) {
				moveByLocalXY(_inertiaX, _inertiaY);
				_inertiaX *= .8;
				_inertiaY *= .8;
			} else {
				_inertiaX = 0;
				_inertiaY = 0;
			}

			if (options.zoomAnimation) {
				_animateZoom += (_zoom - _animateZoom) * .4;
			} else {
				_animateZoom = _zoom;
			}
			if (options.moveAnimation) {
				if (Math.abs(_centerLngDegrees - _animateLng) > 350) {
					_animateLng += (_centerLngDegrees - _animateLng > 0) ? 360 : -360;
				}
				_animateLat += (_centerLatDegrees - _animateLat) * .1;
				_animateLng += (_centerLngDegrees - _animateLng) * .1;
				_animateLng = MapUtil.wrap(_animateLng, -180, 180);
			} else {
				_animateLat = _centerLatDegrees;
				_animateLng = _centerLngDegrees;
			}

			//Need to ordered by zoom=>latlng=>frame then update affected layer
			//1. Zoom
			if (zoomChange || options.zoomAnimation || forceRender) {

				mapLayerController.zoom = _animateZoom;
				overlayLayerController.zoom = _animateZoom;
				zoomChange = false;
			}

			//2. Latlng
			if (centerChange || options.moveAnimation || forceRender) {
				mapLayerController.setCenterLatLngDegrees(_animateLat, _animateLng);
				overlayLayerController.setCenterLatLngDegrees(_animateLat, _animateLng);
				centerChange = false;
			}
			//3. Frame
			if (frameChange || forceRender) {
				if (LogoView){
					LogoView.x = Math.round(20*LogoView.scale);
					LogoView.y = Math.round(frame.height - (54*LogoView.scale));
				}
				zoomLayerContainerView.frame = frame;
				rootViewContainerView.frame = frame;

				mapLayerController.frame = frame;
				overlayLayerController.frame = frame;

				frameChange = false;
			}

			//update
			mapLayerController.updateIfNeeded(forceRender);
			overlayLayerController.updateIfNeeded(forceRender);

			options.afterRender();
		}


		public function get isHeldUpdate():Boolean
		{
			return _heldUpdate;
		}

		public function holdUpdate():void
		{
			_heldUpdate = true;
			mapLayerController.holdUpdate();
			overlayLayerController.holdUpdate();
			dispatchEvent(new A8realMapEvent(A8realMapEvent.HOLD));
		}

		public function releaseUpdate():void
		{
			_heldUpdate = false;
			mapLayerController.releaseUpdate();
			overlayLayerController.releaseUpdate();
			dispatchEvent(new A8realMapEvent(A8realMapEvent.RELEASED));
		}


		public function setCenterByLatLonRadian(lat:Number, lng:Number, animated:Boolean = true):void
		{
			var degreesLat:Number = MapUtil.radiansToDegrees(lat);
			var degreesLng:Number = MapUtil.radiansToDegrees(lng);

			setCenterByLatLonDegrees(degreesLat, degreesLng, animated);
		}

		public function setCenterByLatLonDegrees(lat:Number, lng:Number, animated:Boolean = true):void
		{
			var lat:Number = MapUtil.bound(lat, -90, 90);
			var lng:Number = MapUtil.bound(lng, -180, 180);

			if (lat != _centerLatDegrees || lng != _centerLngDegrees) {
				_centerLatDegrees = lat;
				_centerLngDegrees = lng;
				wrapUpLatLng();
				if (!animated) {
					_animateLat = _centerLatDegrees;
					_animateLng = _centerLngDegrees;
				}
				centerChange = true;
				dispatchEvent(new A8realMapEvent(A8realMapEvent.LATLNG_CHANGE));
			}
		}

		public function clickAtLocalXY(lx:Number, ly:Number):void
		{
			//do something?
		}

		public function setLocalXYInertia(lx:Number, ly:Number):void
		{
			_inertiaX = lx;
			_inertiaY = ly;
		}

		public function moveByLocalXY(lx:Number, ly:Number, animated:Boolean = true):void
		{
			var cZoom:int = exactZoom;
			var scale:Number = _zoom / cZoom;

			projection.fromLatLngToPixelLight(_centerLatDegrees, _centerLngDegrees, cZoom, calcPoint);
			calcPoint.x -= lx / scale;
			calcPoint.y -= ly / scale;

			var latlng:LatLng = projection.fromPixelToLatLng(calcPoint, cZoom, true);
			setCenterByLatLonDegrees(latlng.lat(), latlng.lng(), animated);

		}

		public function get exactZoom():int
		{
			return options.roundUpZoom(zoom);
		}

		public function set mapTypeId(value:String):void
		{
			_mapTypeId = value;
			mapTypeChange = false;
		}

		public function get height():int
		{
			return frame.height;
		}

		public function set height(value:int):void
		{
			if (frame.height != value) {
				frame.height = value;
				wrapUpLatLng();
				frameChange = true;
			}
		}

		public function get width():int
		{
			return frame.width;
		}

		public function get mapTypeId():String
		{
			return _mapTypeId;
		}

		public function set width(value:int):void
		{
			if (frame.width != value) {
				frame.width = value;
				wrapUpLatLng();
				frameChange = true;
			}
		}

		public function set zoom(value:Number):void
		{
			if (_zoom != value) {
				_zoom = options.validateZoom(Math.min(maxZoom, Math.max(value, minZoom)));
				zoomChange = true;
				wrapUpLatLng();
				dispatchEvent(new A8realMapEvent(A8realMapEvent.ZOOM_CHANGE));
			}
		}

		public function get zoom():Number
		{
			return _zoom;
		}

		public function get minZoom():int
		{
			return _minZoom;
		}

		public function set minZoom(value:int):void
		{
			_minZoom = Math.max(1, Math.min(value, _maxZoom));
		}

		public function get maxZoom():int
		{
			return _maxZoom;
		}

		public function set maxZoom(value:int):void
		{
			_maxZoom = Math.max(minZoom, Math.min(value, GoogleMapConst.ZOOM_LEVEL_LIMIT));
		}
	}
}
