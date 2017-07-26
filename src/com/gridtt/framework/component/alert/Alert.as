package com.gridtt.framework.component.alert
{

	import com.gridtt.framework.GridttFramework;
	import com.gridtt.framework.component.popup.Popup;
	import com.gridtt.framework.style.ButtonStyle;
	import com.gridtt.framework.ui.Button;
	import com.gridtt.framework.ui.Label;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.area80.utils.DrawingUtils;

	public class Alert extends Popup
	{
		private var boxwidth:int = 250;
		private var padding:int = 20;
		private var label:Label;
		private var options:AlertOptions;
		private var alertcontent:Sprite;
		private var buttoncontent:Sprite;

		public function Alert(options:AlertOptions)
		{
			this.options = options;
			if (GridttFramework.theme.isRatina) {
				padding *= 2;
				boxwidth *= 2;
			}

			alertcontent = new Sprite();
			var bg:Sprite = DrawingUtils.getRectSprite(boxwidth, 100);
			bg.alpha = 0;
			alertcontent.addChild(bg);
			var label:Label = new Label(options.htmlMessage, options.fontStyle);
			label.line = 3;
			label.baseLine = "middle";
			label.width = boxwidth;
			label.height = 80;
			label.align = "center";
			label.resizeMode = Label.RESIZE_NONE;
			label.registerationPoint = "center";
			//label.text = options.htmlMessage;
			label.x = boxwidth*.5;
			label.y = padding*.5;
			alertcontent.addChild(label);

			buttoncontent = new Sprite();
			var w:int = 0;
			if (options.isConfirmation) {
				var cancels:ButtonStyle = (options.styleButtonCancel)?options.styleButtonCancel:GridttFramework.theme.button_default;
				var calncelbtn:Button = new Button(cancels, options.cancelButtonMessage);
				buttoncontent.addChild(calncelbtn);
				calncelbtn.addEventListener(MouseEvent.CLICK, cancelHandler);
				w += calncelbtn.width+padding*.5;
			}
			var oks:ButtonStyle = (options.styleButtonOk)?options.styleButtonOk:GridttFramework.theme.button_primary;
			var okbtn:Button = new Button(oks, options.confirmButtonMessage);
			okbtn.addEventListener(MouseEvent.CLICK, okHandler);
			if (options.isConfirmation) {
				okbtn.x = w;
			}
			w += okbtn.width;
			buttoncontent.addChild(okbtn);

			alertcontent.addChild(buttoncontent);
			buttoncontent.y = padding+label.height+padding*.5;

			buttoncontent.x = (boxwidth-w)*.5;

			super(alertcontent, GridttFramework.theme.fill_white_popup, false, GridttFramework.theme.fill_dim_black, padding);
		}

		protected function cancelHandler(event:MouseEvent):void
		{
			if (typeof(options.cancelCallBack)=="function")
				options.cancelCallBack();
			closePopup();
		}

		protected function okHandler(event:MouseEvent):void
		{
			if (typeof(options.comfirmCallBack)=="function")
				options.comfirmCallBack();
			closePopup();
		}

		override protected function update(event:Event = null):void
		{
			// TODO Auto Generated method stub
			super.update(event);
		}

	}
}
