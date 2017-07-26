package com.gridtt.framework.ui
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Icon extends Sprite
	{
		[Embed(source = "../asset/glyphicons-halflings-white.png")]
		public static const White:Class;
		//20x7

		private static var whiteBmp:BitmapData;

		[Embed(source = "../asset/glyphicons-halflings.png")]
		public static const Black:Class;

		private static var blackBmp:BitmapData;


		//http://twitter.github.com/bootstrap/base-css.html

		//1st COL
		public static const ICON_GLASS:int = 0;
		public static const ICON_MUSIC:int = 1;
		public static const ICON_SEARCH:int = 2;
		public static const ICON_ENVELOPE:int = 3;
		public static const ICON_HEART:int = 4;
		public static const ICON_STAR:int = 5;
		public static const ICON_STAR_EMPTY:int = 6;
		public static const ICON_USER:int = 7;
		public static const ICON_FILM:int = 8;
		public static const ICON_TH_LARGE:int = 9;
		public static const ICON_TH:int = 10;
		public static const ICON_TH_LIST:int = 11;
		public static const ICON_OK:int = 12;
		public static const ICON_REMOVE:int = 13;
		public static const ICON_ZOOM_IN:int = 14;
		public static const ICON_ZOOM_OUT:int = 15;
		public static const ICON_OFF:int = 16;
		public static const ICON_SIGNAL:int = 17;
		public static const ICON_COG:int = 18;
		public static const ICON_TRASH:int = 19;
		public static const ICON_HOME:int = 20;
		public static const ICON_FILE:int = 21;
		public static const ICON_TIME:int = 22;
		public static const ICON_ROAD:int = 23;
		public static const ICON_DOWNLOAD_ALT:int = 24;
		public static const ICON_DOWNLOAD:int = 25;
		public static const ICON_UPLOAD:int = 26;
		public static const ICON_INBOX:int = 27;
		public static const ICON_PLAY_CIRCLE:int = 28;
		public static const ICON_REPEAT:int = 29;
		public static const ICON_REFRESH:int = 30;
		public static const ICON_LIST_ALT:int = 31;
		public static const ICON_LOCK:int = 32;
		public static const ICON_FLAG:int = 33;
		public static const ICON_HEADPHONES:int = 34;

		//2nd COL


		public static var isInit:Boolean = Icon._init();

		private static function _init():Boolean
		{
			whiteBmp = Bitmap(new White()).bitmapData;
			blackBmp = Bitmap(new Black()).bitmapData;

			return true;
		}

		public static const IP:String = "";

		public function Icon(type:int, isWhite:Boolean = false)
		{
			super();
			var mat:Matrix = new Matrix();
			mat.translate(-(type % 20) * 24, -Math.floor(type / 20) * 24);

			graphics.beginBitmapFill((isWhite) ? whiteBmp : blackBmp, mat, false);
			graphics.drawRect(0, 0, 14, 14);
		}
	}
}
