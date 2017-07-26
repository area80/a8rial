package com.gridtt.framework.component.popup
{

	import com.gridtt.framework.GridttFramework;
	import com.gridtt.framework.style.FillStyle;
	import com.gridtt.framework.ui.BaseUI;
	import com.gridtt.framework.ui.Fill;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.area80.ui2d.assets.CloseButtonCircleRound;

	public class Popup extends BaseUI
	{
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var dimfill:Fill;
		private var block:Fill;
		private var _content:DisplayObject;
		private var closeBtn:CloseButtonCircleRound;
		private var padding:Number;
		private var btnContainer:Sprite;

		public function Popup(content:DisplayObject, style:FillStyle, closeButton:Boolean = true, dimstyle:FillStyle = null, padding:int = 20)
		{
			this.padding = padding;
			dimfill = new Fill(dimstyle);
			addChild(dimfill);
			block = new Fill(style);
			addChild(block);
			this.content = content;

			if (closeButton) {
				var r:int = (GridttFramework.theme.isRatina) ? 36 : 18;
				var s:int = (GridttFramework.theme.isRatina) ? 8 : 4;
				btnContainer = new Sprite();
				btnContainer.graphics.beginFill(0xEEEEEE, 1);
				btnContainer.graphics.drawCircle(0, 0, (r + s) * .5);
				btnContainer.filters = style.filters;
				closeBtn = new CloseButtonCircleRound();
				closeBtn.width = r
				closeBtn.height = r
				closeBtn.x = -r * .5;
				closeBtn.y = -r * .5;
				closeBtn.color = 0x333333;
				btnContainer.addChild(closeBtn);
				addChild(btnContainer);
				btnContainer.addEventListener(MouseEvent.CLICK, closeHandler);
			}
		}

		public function closePopup():void
		{
			if (parent) {
				parent.removeChild(this);
			}
		}

		protected function closeHandler(event:MouseEvent):void
		{
			closePopup();
		}

		override protected function update(event:Event = null):void
		{
			if (_content) {
				_content.x = Math.round((_width - content.width) * .5);
				_content.y = Math.round((_height - content.height) * .5);
				block.width = _content.width + padding * 2;
				block.height = _content.height + padding * 2;
				block.x = Math.round((_width - block.width) * .5);
				block.y = Math.round((_height - block.height) * .5);
				block.visible = true;
			} else {
				block.visible = false;
			}
			if (closeBtn) {
				if (block.visible) {
					btnContainer.x = (block.x + block.width);
					btnContainer.y = block.y
				} else {
					btnContainer.x = _width + block.width - (padding) * .5;
					btnContainer.y = (padding) * .5;
				}
			}
		}

		public function get content():DisplayObject
		{
			return _content;
		}

		public function set content(value:DisplayObject):void
		{
			if (_content && _content != value) {
				removeChild(_content);
			}
			_content = value;

			if (_content) {
				addChild(_content);
			} else {

			}
			invalid();
		}

		override public function get height():Number
		{
			return _width;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			dimfill.height = _height;
			invalid();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			dimfill.width = _width;
			invalid();
		}

	}
}
