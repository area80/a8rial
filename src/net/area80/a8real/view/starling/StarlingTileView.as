package net.area80.a8real.view.starling
{

	import net.area80.a8real.util.StarlingTileCache;
	import net.area80.a8real.view.interfaces.ITileView;
	
	import starling.core.RenderSupport;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.VertexData;

	public class StarlingTileView extends Quad implements ITileView
	{
		private var zoom:int;
		private var mapTypeId:String;

		private var _tx:int;
		private var _ty:int;
		private var _realy:int;
		private var _realx:int;
		private var _posy:int;

		private var _isReady:Boolean = false;
		private var _imageLoaded:Boolean = false;
		private var _alp:Number = 1;

		private var account:StarlingTileCache;
		private var _animationInertia:Number = 0.2;

		private var _scale:Number = 1;
		
		private var mTexture:Texture;
		
		private static var globalVertexData:VertexData;
		private static const mSmoothing:String = TextureSmoothing.BILINEAR;

		public function StarlingTileView(tx:int, ty:int, realx:int, realy:int, zoom:int, mapTypeId:String,ServerType:int)
		{
			super(256,256);

			this._tx = tx;
			this._ty = ty;
			this._realx = realx;
			this._realy = realy;
			this.zoom = zoom;
			this.mapTypeId = mapTypeId;
		
			_animationInertia = 0.1 + Math.random() * .2;
			
			visible = false;
			
			account = StarlingTileCache.getCacheAt(zoom, mapTypeId,ServerType);
			initWithTexture(account.getTileAt(tx, ty, onload));
		}
		
		override protected function onVertexDataChanged():void
		{

			if(!globalVertexData) {
				globalVertexData = new VertexData(4, true);
				globalVertexData.setPosition(0, 0.0, 0.0);
				globalVertexData.setPosition(1, 256, 0.0);
				globalVertexData.setPosition(2, 0.0, 256);
				globalVertexData.setPosition(3, 256, 256);            
				globalVertexData.setUniformColor(0xffffff);
				globalVertexData.setTexCoords(0, 0.0, 0.0);
				globalVertexData.setTexCoords(1, 1.0, 0.0);
				globalVertexData.setTexCoords(2, 0.0, 1.0);
				globalVertexData.setTexCoords(3, 1.0, 1.0);
			}
			mVertexData = globalVertexData;
		}
		private function initWithTexture (texture:Texture):void {
			mTexture = texture; 
			//mTexture.adjustVertexData(globalVertexData, 0, 4);
			account.setUsage(mTexture, this);
		}

		/** Copies the raw vertex data to a VertexData instance.
		 *  The texture coordinates are already in the format required for rendering. */ 
		public override function copyVertexDataTo(targetData:VertexData, targetVertexID:int=0):void
		{
			mVertexData.copyTo(targetData, targetVertexID);
		}
		public function set scale(value:Number):void
		{
			_scale = value;
		}
		public function get scale():Number
		{
			return _scale;
		}
		public function get tx():int
		{
			return _tx;
		}

		public function get ty():int
		{
			return _ty;
		}

		public function get realx():int
		{
			return _realx;
		}

		public function get realy():int
		{
			return _realy;
		}

		private function onload(fromCache:Boolean = false):void
		{
			visible = true;
			_imageLoaded = true;
			if (fromCache) {
				_alp = 1;
				_isReady = true;
			} else {
				_alp = 0;
			}
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (_imageLoaded && !_isReady) {
				if (_alp < 0.9998) {
					_alp += (1 - _alp) * _animationInertia;
				} else {
					_isReady = true;
					_alp = 1;
				}
			}
			support.batchQuad(this, parentAlpha*_alp, mTexture, mSmoothing);
		}

		public function get isLoaded():Boolean
		{
			return _isReady;
		}

		public function destroy():void
		{
			account.setUnuse(mTexture, this);
			dispose();
		}

		
		
	}
}
