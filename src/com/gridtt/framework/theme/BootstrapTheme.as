package com.gridtt.framework.theme
{

	import com.gridtt.framework.style.ButtonStyle;
	import com.gridtt.framework.style.FillStyle;
	import com.gridtt.framework.style.FontStyle;

	import flash.filters.BevelFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class BootstrapTheme extends Theme
	{


		public function BootstrapTheme(isRatina:Boolean = false)
		{
			super(isRatina);

			buttonstate_down_filter = [new ColorMatrixFilter([.92, 0, 0, 0, 0, 0, .92, 0, 0, -0, 0, 0, .92, 0, 0, 0, 0, 0, 1, 0]), new BevelFilter((_isRatina) ? 4 : 2, 270, 0xFFFFFF, 0, 0x00000, 0.3, (_isRatina) ? 4 : 2, (_isRatina) ? 12 : 6, 1)];
			var br:Array = [1, 0, 0, 0, 10, 0, 1, 0, 0, 10, 0, 0, 1, 0, 10, 0, 0, 0, 1, 0];
			buttonstate_over_filter = [new ColorMatrixFilter(br)];

			var bw:Array = new Array();
			bw = bw.concat([0.4, 0.4, 0.4, 0, 0]); // red
			bw = bw.concat([0.4, 0.4, 0.4, 0, 0]); // green
			bw = bw.concat([0.4, 0.4, 0.4, 0, 0]); // blue
			bw = bw.concat([0, 0, 0, 1, 0]); // alpha
			buttonstate_disable_filter = [new ColorMatrixFilter(bw)];

			fill_dim_black = new FillStyle();
			fill_dim_black.color = 0x000000;
			fill_dim_black.alpha = .6;
			fill_dim_white = new FillStyle();
			fill_dim_white.color = 0xFFFFFF;
			fill_dim_white.alpha = .6;

			fill_white = new FillStyle();
			fill_white.cornerRadius = (_isRatina) ? 16 : 8;
			fill_white.filters = [new BevelFilter((_isRatina) ? 2 : 1, 60, 0xFFFFFF, 0.7, 0x00000, 0.246094, (_isRatina) ? 2 : 1, (_isRatina) ? 4 : 2, 2, 1), new BevelFilter((_isRatina) ? 2 : 1, 60, 0x00000, 0.0976563, 0x00000, 0.246094, (_isRatina) ? 2 : 1, (_isRatina) ? 4 : 2, .8, 1)];
			fill_white.colorTop = 0xFFFFFF;
			fill_white.colorBottom = 0xEEEEEE;

			fill_well = new FillStyle();
			fill_well.color = 0xF5F5F5; //white smoke
			fill_well.cornerRadius = (_isRatina) ? 16 : 8;
			fill_well.filters = [new GlowFilter(0x000000, .05, (_isRatina) ? 10 : 5, (_isRatina) ? 10 : 5, 2, 1, true), new GlowFilter(0x000000, .05, (_isRatina) ? 4 : 2, (_isRatina) ? 8 : 4, 2, 1, true)];

			font_h1 = new FontStyle();
			font_h1.fontSize = (_isRatina) ? 64 : 38;
			font_h1.fontWeight = "bold";
			font_h1.color = 0x333333;

			font_h2 = new FontStyle();
			font_h2.fontSize = (_isRatina) ? 56 : 28;
			font_h2.fontWeight = "bold";
			font_h2.color = 0x333333;

			font_h3 = new FontStyle();
			font_h3.fontSize = (_isRatina) ? 52 : 26;
			font_h3.color = 0x333333;

			font_h4 = new FontStyle();
			font_h4.fontSize = (_isRatina) ? 44 : 22;
			font_h4.color = 0x333333;

			font_h5 = new FontStyle();
			font_h5.fontSize = (_isRatina) ? 36 : 18;
			font_h5.color = 0x333333;


			font_legend = new FontStyle();
			font_legend.fontSize = (_isRatina) ? 38 : 19;
			font_legend.color = 0x333333;

			font_normal_dark = new FontStyle();
			font_normal_dark.fontSize = (_isRatina) ? 26 : 13;
			font_normal_dark.color = 0x333333;

			font_normal_medium = new FontStyle();
			font_normal_medium.fontSize = (_isRatina) ? 26 : 13;
			font_normal_medium.color = 0x999999;

			font_normal_bright = new FontStyle();
			font_normal_bright.fontSize = (_isRatina) ? 26 : 13;
			font_normal_bright.color = 0xFFFFFF;


			var default_font:FontStyle = new FontStyle();
			default_font.fontFamily = "Helvetica Neue, Helvetica, Arial, Tahoma";
			default_font.fontSize = (_isRatina) ? 26 : 13;
			default_font.fontWeight = "normal";
			default_font.color = 0x333333;
			default_font.whiteIcon = false;
			//	default_font.filters = [new DropShadowFilter((_isRatina) ? 2 : 1, 270, 0xFFFFFF, .25, (_isRatina) ? 4 : 2, (_isRatina) ? 2 : 1, 2)];

			var default_white_font:FontStyle = default_font.clone();
			default_white_font.color = 0xFFFFFF;
			default_white_font.whiteIcon = true;
			//default_white_font.filters = [new DropShadowFilter((_isRatina) ? 2 : 1, 270, 0x000000, .25, (_isRatina) ? 4 : 2, (_isRatina) ? 2 : 1, 2)];

			button_default = new ButtonStyle();
			button_default.font = default_font;
			button_default.padding = (_isRatina) ? 16 : 8;
			button_default.fill.colorTop = 0xFFFFFF;
			button_default.fill.colorBottom = 0xE6E6E6;
			button_default.fill.cornerRadius = (_isRatina) ? 8 : 4;
			button_default.fill.filters = [new GlowFilter(0x000000, 0.35, 2, 2, .6, 1, true), new BevelFilter((_isRatina) ? 2 : 1, 90, 0xFFFFFF, 0.7, 0x00000, 0.246094, (_isRatina) ? 2 : 1, (_isRatina) ? 4 : 2, 1), new BevelFilter((_isRatina) ? 2 : 1, 60, 0x00000, 0.0976563, 0x00000, 0.246094, (_isRatina) ? 2 : 1, (_isRatina) ? 4 : 2, .8, 1)];


			button_primary = button_default.clone();
			button_primary.font = default_white_font;
			button_primary.fill.colorTop = 0x0081d2;
			button_primary.fill.colorBottom = 0x0052d3;


			button_info = button_primary.clone();
			button_info.fill.colorTop = 0x58bde0;
			button_info.fill.colorBottom = 0x2e95b7;

			button_success = button_primary.clone();
			button_success.fill.colorTop = 0x62c250;
			button_success.fill.colorBottom = 0x53a343;

			button_warning = button_primary.clone();
			button_warning.fill.colorTop = 0xfbb42d;
			button_warning.fill.colorBottom = 0xf99600;

			button_danger = button_primary.clone();
			button_danger.fill.colorTop = 0xea5d53;
			button_danger.fill.colorBottom = 0xbc3728;

			button_inverse = button_primary.clone();
			button_inverse.fill.colorTop = 0x535353;
			button_inverse.fill.colorBottom = 0x222222;

			fill_white_popup = button_default.fill.clone();
			fill_white_popup.filters = [new GlowFilter(0x000000, .05, (_isRatina) ? 10 : 5, (_isRatina) ? 10 : 5, 2, 1, true), new GlowFilter(0x000000, .05, (_isRatina) ? 4 : 2, (_isRatina) ? 8 : 4, 2, 1, true)];

		}
	}
}
