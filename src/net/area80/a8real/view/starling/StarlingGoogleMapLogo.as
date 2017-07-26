package net.area80.a8real.view.starling
{

	import net.area80.a8real.assets.Assets;
	import net.area80.a8real.view.interfaces.IBaseView;
	import net.area80.starling.TextureBank;

	import starling.display.Image;
	import starling.textures.Texture;

	public class StarlingGoogleMapLogo extends Image implements IBaseView
	{

		private var _scale:Number = 1;
		public function StarlingGoogleMapLogo()
		{
			var _texture:Texture = TextureBank.withdraw("GoogleMapLogo");
			if (!_texture) {
				_texture = TextureBank.deposit(Texture.fromBitmapData(Assets.googleLogoBitmapdata, false), "GoogleMapLogo");
				_texture.repeat = true;
			}
			super(_texture);

			touchable = false;
		}
		public function set scale(value:Number):void
		{
			_scale = value;
			scaleX = _scale;
			scaleY = _scale;
		}
		public function get scale():Number
		{
			return _scale;
		}
		public function destroy():void
		{
			dispose();
		}
	}
}
