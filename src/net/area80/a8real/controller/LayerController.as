package net.area80.a8real.controller
{

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import net.area80.a8real.calculation.MercatorProjection;
	import net.area80.a8real.initial.MapOptions;
	import net.area80.a8real.view.interfaces.IBaseView;

	public class LayerController
	{


		protected var projection:MercatorProjection;

		protected var _view:IBaseView;

		protected var _centerLatDegrees:Number;
		protected var _centerLngDegrees:Number;

		protected var latlngchange:Boolean;
		protected var framechange:Boolean = false;
		protected var _frame:Rectangle;
		protected var _helvedUpdate:Boolean;
		protected var _changeWhilePressed:Boolean;
		protected var options:MapOptions;

		protected var _displayRect:Rectangle = new Rectangle(0, 0, 0, 0);
		protected var _centerPixels:Point = new Point(0, 0);

		public function LayerController(baseview:IBaseView, options:MapOptions, projection:MercatorProjection, frame:Rectangle)
		{
			this.options = options;
			this._view = baseview;
			this.projection = projection;
			this.frame = frame;
		}

		public function set frame(value:Rectangle):void
		{
			_frame = value;
			framechange = true;
		}

		public function get view():IBaseView
		{
			return _view;
		}

		public function get frame():Rectangle
		{
			return _frame
		}

		public function setCenterLatLngDegrees(lat:Number, lng:Number):void
		{
			_centerLatDegrees = lat;
			_centerLngDegrees = lng;
			latlngchange = true;
		}

		public function holdUpdate():void
		{
			_helvedUpdate = true;
		}

		public function dispose():void
		{
			_view.destroy();
		}

		public function releaseUpdate():void
		{
			_helvedUpdate = false;

			if (_changeWhilePressed) {
				updateIfNeeded(true);
			}
			_changeWhilePressed = false;

		}

		public function updateIfNeeded(forceUpdate:Boolean = false):void
		{
			latlngchange = false;
			framechange = false;
		}


	}
}
