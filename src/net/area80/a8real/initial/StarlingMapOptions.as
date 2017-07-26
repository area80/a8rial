package net.area80.a8real.initial
{
	import net.area80.a8real.enum.GoogleMapType;
	import net.area80.a8real.enum.ServerMapType;
	import net.area80.a8real.util.StarlingTileCache;
	import net.area80.a8real.view.interfaces.IBackgroundView;
	import net.area80.a8real.view.interfaces.IBaseView;
	import net.area80.a8real.view.interfaces.IContainerView;
	import net.area80.a8real.view.interfaces.IPolyLine;
	import net.area80.a8real.view.interfaces.ITileView;
	import net.area80.a8real.view.starling.StarlingBackgroundView;
	import net.area80.a8real.view.starling.StarlingContainerView;
	import net.area80.a8real.view.starling.StarlingGoogleMapLogo;
	import net.area80.a8real.view.starling.StarlingPolyline;
	import net.area80.a8real.view.starling.StarlingTileView;

	public class StarlingMapOptions extends MapOptions
	{
		public function StarlingMapOptions()
		{
			super();
		}

		override public function afterRender():void
		{
			StarlingTileCache.clearIfReachMemoryLimit();
		}

		override public function dispose():void
		{
			StarlingTileCache.clearAllCache();
		}

		override public function beforeRender():void
		{
			// TODO Auto Generated method stub
			super.beforeRender();
		}


		override public function newBackground():IBackgroundView
		{
			return new StarlingBackgroundView();
		}

		override public function newGoogleLogo():IBaseView
		{
			return new StarlingGoogleMapLogo();
		}

		override public function newContainer():IContainerView
		{
			return new StarlingContainerView();
		}

		override public function newPolyLine():IPolyLine
		{
			return new StarlingPolyline();
		}

		override public function newTile(tx:int, ty:int, realx:int, realy:int, zoom:int, mapTypeId:String = GoogleMapType.ROADMAP, ServerType:int = ServerMapType.GOOGLE_MAP):ITileView
		{
			return new StarlingTileView(tx, ty, realx, realy, zoom, mapTypeId,ServerType);
		}



	}
}
