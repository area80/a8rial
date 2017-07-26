package com.gridtt.framework.component.preload
{

	import com.gridtt.framework.GridttFramework;
	import com.gridtt.framework.component.popup.Popup;
	import com.gridtt.framework.style.FillStyle;
	import com.gridtt.framework.style.FontStyle;
	import com.gridtt.framework.ui.Label;
	import com.gridtt.framework.ui.LoadingSpinner;
	
	import flash.display.Sprite;

	public class Spinner extends Popup
	{
		public function Spinner(message:String = "Loading", dimmAlpha:Number = 0)
		{
			var multiplier:Number = (GridttFramework.theme && GridttFramework.theme.isRatina) ? 2 : 1;
			var container:Sprite = new Sprite();

			var spinner:LoadingSpinner = new LoadingSpinner(0xFFFFFF, 12, 6 * multiplier, 2 * multiplier, 9 * multiplier);
			container.addChild(spinner);
			spinner.y = 4 * multiplier+spinner.height *.8;
			spinner.x = spinner.width * .5;

			if (message != "") {
				var font:FontStyle = new FontStyle();
				font.color = 0xFFFFFF;
				font.fontSize = 16 * multiplier;
				font.fontWeight = "normal";
				var lb:Label = new Label(message, font);
				lb.align = "center";
				lb.registerationPoint = "center";
				lb.resizeMode = Label.RESIZE_AUTO;
				lb.y = spinner.y+spinner.height;
				var w:Number = Math.max(lb.width, spinner.width);
				lb.x = w * .5;
				spinner.x = w * .5;

				container.addChild(lb);
			}

			var block:FillStyle = new FillStyle();
			block.alpha = .8;
			block.cornerRadius = 10 * multiplier;
			block.color = 0;
			var bg:FillStyle = new FillStyle();
			bg.color = 0;
			bg.alpha = dimmAlpha;
			super(container, block, false, bg, 22 * multiplier);
		}
	}
}
