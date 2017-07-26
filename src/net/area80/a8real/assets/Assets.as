package net.area80.a8real.assets
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Assets
	{
		[Embed(source = "./bg.png")]
		private static var GoogleBackground:Class;

		[Embed(source = "./googlelogo.png")]
		private static var GoogleLogo:Class;

		public static var patternBackgroundBitmapdata:BitmapData;
		public static var googleLogoBitmapdata:BitmapData;

		private static const _init:Boolean = Assets._isinit();

		private static function _isinit():Boolean
		{
			patternBackgroundBitmapdata = Bitmap(new GoogleBackground()).bitmapData;
			googleLogoBitmapdata = Bitmap(new GoogleLogo()).bitmapData;
			return true;
		}
	}
}
