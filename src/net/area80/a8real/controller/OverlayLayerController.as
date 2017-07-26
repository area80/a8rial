package net.area80.a8real.controller
{

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import net.area80.a8real.calculation.MercatorProjection;
	import net.area80.a8real.data.LatLng;
	import net.area80.a8real.data.direction.RouteData;
	import net.area80.a8real.initial.MapOptions;
	import net.area80.a8real.util.Polyline;
	import net.area80.a8real.view.interfaces.IContainerView;
	import net.area80.a8real.view.interfaces.IPolyLine;

	public class OverlayLayerController extends LayerController
	{
		private var containerview:IContainerView;
		private var overlayLayerByName:Dictionary = new Dictionary();
		private var disableAutoHideByLayer:Dictionary = new Dictionary();

		private var pinsByLayer:Dictionary = new Dictionary();

		private var polyLine:IPolyLine;

		private var _zoom:Number = 0;
		private var zoomchange:Boolean = false;
		private var _route:Vector.<LatLng>;
		private var lineNeedRedraw:Boolean = false;

		private var polylineContainer:IContainerView;

		public function OverlayLayerController(containerview:IContainerView, options:MapOptions, projection:MercatorProjection, frame:Rectangle, zoom:Number)
		{
			super(containerview, options, projection, frame);

			this.containerview = containerview;
			this.zoom = zoom;
			polylineContainer = options.newContainer();
			containerview.addSubCanvas(polylineContainer);
		}

		public override function dispose():void
		{
			clearPolyLine();
			super.dispose();
		}

		public function set zoom(value:Number):void
		{
			if (_zoom!=value) {
				_zoom = value;
				zoomchange = true;
				clearPolyLine();
				lineNeedRedraw = true;
			}
		}

		public function get zoom():Number
		{
			return _zoom;
		}

		public function setLayerAutoHide(layername:String, autohide:Boolean = true):void
		{
			var layer:IContainerView = getLayerByName(layername, false);
			if (layer) {
				if (autohide) {
					if (layer) {
						delete disableAutoHideByLayer[layer];
					}
				} else {
					disableAutoHideByLayer[layer] = "autohide";
				}
			}
		}

		public function removeLayer(name:String, dispose:Boolean = true):void
		{
			if (overlayLayerByName[name]) {
				var containerlayer:IContainerView = overlayLayerByName[name] as IContainerView;

				var pins:Vector.<Pin> = pinsByLayer[containerlayer] as Vector.<Pin>;

				for each (var pin:Pin in pins) {
					if (dispose) {
						try {
							pin.display["dispose"]();
						} catch (e:Error) {
						}
					}
				}
				delete pinsByLayer[containerlayer];
				if (disableAutoHideByLayer[containerlayer])
					delete disableAutoHideByLayer[containerlayer];
				containerlayer.destroy();
				containerview.removeSubCanvas(containerlayer);

				delete overlayLayerByName[name];
			}
			framechange = true;
		}

		public function showLayer(name:String):void
		{
			var pinlayer:IContainerView = getLayerByName(name, false);
			if (pinlayer)
				pinlayer.visible = true;
			framechange = true;
		}

		public function hideLayer(name:String):void
		{
			var pinlayer:IContainerView = getLayerByName(name, false);
			if (pinlayer)
				pinlayer.visible = false;
			framechange = true;
		}

		public function createLayer(name:String, autohide:Boolean = true):IContainerView
		{
			var layer:IContainerView = getLayerByName(name, true);
			setLayerAutoHide(name, autohide);
			return layer;
		}

		public function setPinToLayer(name:String, display:*, lat:Number, lng:Number):void
		{
			var pinlayer:IContainerView = getLayerByName(name);
			if (!pinsByLayer[pinlayer]) {
				pinsByLayer[pinlayer] = new Vector.<Pin>;
			}
			var currentPin:Pin = null;
			for each (var pin:Pin in pinsByLayer[pinlayer]) {
				if (pin.display==display) {
					currentPin = pin;
					break;
				}
			}
			if (!currentPin) {
				currentPin = new Pin(display, lat, lng);
				pinlayer.addAnyChild(currentPin.display);
				pinsByLayer[pinlayer].push(currentPin);
			} else {
				currentPin.lat = lat;
				currentPin.lng = lng;
			}
			framechange = true;
			//	pinlayer.setPin(display, lat, lng);
		}

		public function removePinFromLayer(name:String, display:* = null, dispose:Boolean = true):void
		{
			if (overlayLayerByName[name]) {
				var containerlayer:IContainerView = overlayLayerByName[name] as IContainerView;

				var pins:Vector.<Pin> = pinsByLayer[containerlayer] as Vector.<Pin>;
				for (var i:int = 0; i<pins.length; i++) {
					var pin:Pin = pins[i];
					if (pin.display==display||display==null) {
						if (dispose) {
							try {
								pin.display["dispose"]();
							} catch (e:Error) {
							}
						}
						containerlayer.removeAnyChild(pin.display);
						pins.splice(i, 1);
						i = 0;
					}
				}
			}
		}
		public function removeAllPinFromLayer(name:String, dispose:Boolean = true):void
		{
			if (overlayLayerByName[name]) {
				var containerlayer:IContainerView = overlayLayerByName[name] as IContainerView;
				
				var pins:Vector.<Pin> = pinsByLayer[containerlayer] as Vector.<Pin>;
				if(pins) {
					for (var i:int = 0; i<pins.length; i++) {
						var pin:Pin = pins[i];
						
						if (dispose) {
							try {
								pin.display["dispose"]();
							} catch (e:Error) {
							}
						}
						containerlayer.removeAnyChild(pin.display);
					}
				}
				pins = null;
			}
		}
		protected function getLayerByName(name:String, autoCreate:Boolean = true):IContainerView
		{
			if (!overlayLayerByName[name]&&autoCreate) {
				overlayLayerByName[name] = options.newContainer();
				containerview.addSubCanvasAt(overlayLayerByName[name], 0);
			}

			return overlayLayerByName[name] as IContainerView;
		}


		public function showDirection(route:RouteData):void
		{
			_route = new Vector.<LatLng>;
			var p:Polyline = new Polyline(route.overviewPolylineEncodedPoints, Polyline.getEncodingLevelByZoom(Math.round(zoom)));
			_route = p.coordinates;
			framechange = true;
			lineNeedRedraw = true;
		}

		public function removeDirection():void
		{
			if (this._route) {
				this._route = null;
				framechange = true;
			}
			clearPolyLine();
			lineNeedRedraw = true;
		}

		protected function clearPolyLine():void
		{
			if (polyLine) {
				polyLine.destroy();
				polylineContainer.removeSubCanvas(polyLine);
				polyLine = null;
			}

		}


		override public function updateIfNeeded(forceUpdate:Boolean = false):void
		{
			if (latlngchange||zoomchange||forceUpdate) {

				projection.fromLatLngToPixelLight(_centerLatDegrees, _centerLngDegrees, Math.floor(zoom), _centerPixels);
				//if lat lng change frame must be change too
				framechange = true;
			}
			if (framechange||lineNeedRedraw||forceUpdate) {
				var excZoom:int = Math.floor(zoom);
				var _scale:Number = 1+(zoom-Math.floor(zoom));
				var reverseScale:Number = 1/_scale;

				_displayRect.x = _centerPixels.x-(frame.width*reverseScale*.5);
				_displayRect.y = _centerPixels.y-(frame.height*reverseScale*.5);

				_displayRect.width = _frame.width*reverseScale;
				_displayRect.height = _frame.height*reverseScale;

				var pos:Point = new Point();

				for each (var containerlayer:IContainerView in overlayLayerByName) {
					//var disableAutoHide:Boolean = disableAutoHideByLayer[containerlayer];
					if (containerlayer.visible) {

						var pins:Vector.<Pin> = pinsByLayer[containerlayer] as Vector.<Pin>;

						for each (var pin:Pin in pins) {
							projection.fromLatLngToPixelLight(pin.lat, pin.lng, excZoom, pos);
							pin.display.x = (pos.x-_displayRect.x)*_scale;
							pin.display.y = (pos.y-_displayRect.y)*_scale;
							//pin.display.scaleY =  pin.display.scaleX = options.elementScale;
							//if (!disableAutoHide) {
							pin.display.visible = (pin.display.x>0&&pin.display.x<frame.width&&pin.display.y>0&&pin.display.y<frame.height);
								//}

						}
					}

				}
				var px:Number;
				var py:Number;
				var latlng:LatLng;
				//var pixelperdegrees:Number = projection.pixelsPerLonDegree[excZoom] * _scale;

				polylineContainer.x = -(_displayRect.x)*_scale;
				polylineContainer.y = -(_displayRect.y)*_scale;

				if (!_helvedUpdate) {
					if (lineNeedRedraw) {
						if (_route&&_route.length>1) {
							if (!polyLine) {
								polyLine = options.newPolyLine();
								//trace("NEW POLYLINE");
								polylineContainer.addSubCanvas(polyLine);
							} else {
								//never touch this state...
								//trace("SAME POLY");
								polyLine.clear();
							}
							polyLine.beginToLine();
							latlng = _route[0];
							projection.fromLatLngToPixelLight(latlng.lat(), latlng.lng(), excZoom, pos);
							px = (pos.x)*_scale;
							py = (pos.y)*_scale;

							polyLine.moveTo(px, py);
							//trace("move>", px + polylineContainer.x, ",", py + polylineContainer.y);

							for (var i:int = 1; i<_route.length; i++) {
								latlng = _route[i];
								projection.fromLatLngToPixelLight(latlng.lat(), latlng.lng(), excZoom, pos);
								px = (pos.x)*_scale;
								py = (pos.y)*_scale;
								polyLine.lineTo(px, py);
							}
							polyLine.endStroke();
								//trace("LineENd");

						} else {
							clearPolyLine();
						}
						lineNeedRedraw = false;
					}
				}


			}
			zoomchange = false;

			super.updateIfNeeded(forceUpdate);
		}

	}
}

class Pin
{
	public var lat:Number;
	public var lng:Number;
	public var display:*;

	public function Pin(display:*, lat:Number, lng:Number)
	{
		this.display = display;
		this.lat = lat;
		this.lng = lng;
	}
}
