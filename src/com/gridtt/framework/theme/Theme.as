package com.gridtt.framework.theme
{

	import com.gridtt.framework.style.ButtonStyle;
	import com.gridtt.framework.style.FillStyle;
	import com.gridtt.framework.style.FontStyle;


	public class Theme
	{
		protected var _isRatina:Boolean = false;

		public function get isRatina():Boolean
		{
			return _isRatina;
		}
		public var font_h1:FontStyle;
		public var font_h2:FontStyle;
		public var font_h3:FontStyle;
		public var font_h4:FontStyle;
		public var font_h5:FontStyle;



		public var font_legend:FontStyle;
		public var font_normal_dark:FontStyle;
		public var font_normal_medium:FontStyle;
		public var font_normal_bright:FontStyle;

		public var button_default:ButtonStyle;
		public var button_primary:ButtonStyle;
		public var button_info:ButtonStyle;
		public var button_success:ButtonStyle;
		public var button_warning:ButtonStyle;
		public var button_danger:ButtonStyle;
		public var button_inverse:ButtonStyle;

		public var buttonstate_down_filter:Array = [];
		public var buttonstate_over_filter:Array = [];
		public var buttonstate_disable_filter:Array = [];

		public var fill_dim_black:FillStyle;
		public var fill_dim_white:FillStyle;

		public var fill_white:FillStyle;
		public var fill_well:FillStyle;
		public var fill_white_popup:FillStyle;

		public function Theme(isRatina:Boolean = false)
		{
			_isRatina = isRatina;
		}
	}
}
