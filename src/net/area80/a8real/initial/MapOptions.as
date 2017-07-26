package net.area80.a8real.initial
{
	import net.area80.a8real.enum.GoogleMapType;
	import net.area80.a8real.enum.ServerMapType;
	import net.area80.a8real.view.interfaces.IBackgroundView;
	import net.area80.a8real.view.interfaces.IBaseView;
	import net.area80.a8real.view.interfaces.IContainerView;
	import net.area80.a8real.view.interfaces.IPolyLine;
	import net.area80.a8real.view.interfaces.ITileView;

	public class MapOptions
	{
		public var touchInertia:Boolean = true;
		public var moveAnimation:Boolean = true;
		public var zoomAnimation:Boolean = true;
		
		public var ServerType:int = ServerMapType.GOOGLE_MAP;
		
		/**
		 * This will be applied to googlemap logo 
		 */
		public var elementScale:Number = 1;//1 is ratina 0.5 for others

		public function MapOptions()
		{
		}

		public function roundUpZoom(value:Number):Number
		{
			if (value - Math.floor(value) > 0.6) {
				return Math.ceil(value);
			} else {
				return Math.floor(value);
			}
			//return Math.round(value);
		}

		public function validateZoom(zoom:Number):Number
		{
			return zoom;
		}

		public function get timeBeforeZoomLayerInit():int
		{
			return 60;
		}

		public function beforeRender():void
		{

		}

		public function dispose():void
		{

		}

		public function afterRender():void
		{

		}

		public function newContainer():IContainerView
		{
			return null;
		}

		public function newGoogleLogo():IBaseView
		{
			return null;
		}

		public function newBackground():IBackgroundView
		{
			return null;
		}

		public function newPolyLine():IPolyLine
		{
			return null;
		}

		public function newTile(tx:int, ty:int, realx:int, realy:int, zoom:int, mapTypeId:String = GoogleMapType.ROADMAP, ServerType:int = ServerMapType.GOOGLE_MAP):ITileView
		{
			return null;
		}
	}
}
