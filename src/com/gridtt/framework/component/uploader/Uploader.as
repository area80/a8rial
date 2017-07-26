package com.gridtt.framework.component.uploader
{

	import com.gridtt.framework.component.uploader.data.Settings;
	import com.gridtt.framework.component.uploader.view.ImageSetContainer;
	import com.gridtt.framework.style.FontStyle;
	import com.gridtt.framework.theme.BootstrapTheme;
	import com.gridtt.framework.ui.BaseUI;
	import com.gridtt.framework.ui.Button;
	import com.gridtt.framework.ui.Fill;
	import com.gridtt.framework.ui.Label;
	import com.gridtt.framework.util.ClassMapper;
	
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class Uploader extends BaseUI
	{

		private var theme:BootstrapTheme = new BootstrapTheme();
		private var setting:Settings;

		private var _height:Number = 300;
		private var _width:Number = 300;

		private var container:ImageSetContainer;

		private var legend:Label;
		private var hint:Label;
		private var drag:Label;
		private var version:Label;

		private var uploadbtn:Button;
		private var savebtn:Button;

		private var bg:Sprite;
		private var line:Sprite;

		private const PADDING:int = 20;
		private const VERSION:String = "3.1";

		public function Uploader()
		{

		}

		public function initFromJSONString(jstr:String):void
		{
			setting = parseSettings(jstr);
			initLayout();
			invalid();
		}

		public function initFromSetting(setting:Settings):void
		{
			this.setting = setting;
			initLayout();
			invalid();
		}

		protected function initLayout():void
		{

			bg = new Fill(theme.fill_well);
			addChild(bg);

			line = new Sprite();
			line.graphics.lineStyle(1, 0xDDDDDD, 1, false, LineScaleMode.HORIZONTAL);
			line.graphics.lineTo(1000, 0);
			addChild(line);

			uploadbtn = new Button(theme.button_primary, "Browse...");
			savebtn = new Button(theme.button_success, "Save");
			savebtn.visible = false;

			legend = new Label(setting.title, theme.font_legend);
			legend.resizeMode = Label.RESIZE_AUTO;
			legend.x = PADDING;
			legend.y = PADDING;
			addChild(legend);

			var f:FontStyle = theme.font_normal_medium.clone();
			f.fontSize = 11;
			drag = new Label("You can drag to reposition the image.", f);
			drag.resizeMode = Label.RESIZE_AUTO;
			addChild(drag);

			hint = new Label(setting.hint, theme.font_normal_medium);
			hint.resizeMode = Label.RESIZE_AUTO;
			hint.line = 2;
			hint.x = 20;
			addChild(hint);
			
			version = new Label("version "+VERSION,theme.font_normal_medium);
			version.resizeMode = Label.RESIZE_AUTO;
			version.line = 1;
			version.x = 20;
			addChild(version);

			container = new ImageSetContainer(setting);
			container.y = 60;
			container.x = PADDING;
			container.addEventListener("image", onImage);
			addChild(container);

			uploadbtn.addEventListener(MouseEvent.CLICK, uploadHandler);
			savebtn.addEventListener(MouseEvent.CLICK, saveHandler);

			addChild(uploadbtn);
			addChild(savebtn);

		}

		protected function saveHandler(event:MouseEvent):void
		{
			container.doSave();
		}

		protected function onImage(event:Event):void
		{
			savebtn.visible = true;
			invalid();
		}

		protected function uploadHandler(event:MouseEvent):void
		{
			container.browse();
		}


		private function parseSettings(json:String):Settings
		{
			var o:* = ClassMapper.JSONToClass(json, Settings);
			return o as Settings;
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			bg.height = _height;
			invalid();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			bg.width = _width;
			invalid();
		}


		override public function dispose():void
		{
			super.dispose();
		}

		override protected function update(event:Event = null):void
		{

			var barHeight:int = PADDING*4;
			var topHeight:int = PADDING*3;
			line.width = _width;
			line.y = _height-barHeight;
			container.height = _height-(barHeight+PADDING+topHeight);
			container.width = _width-PADDING*2;

			drag.y = _height-(barHeight+PADDING);
			drag.x = (_width-drag.width)*.5;

			savebtn.x = _width-(PADDING+savebtn.width);
			savebtn.y = (_height-barHeight)+(barHeight-savebtn.height)*.5;


			uploadbtn.x = (savebtn.visible)?savebtn.x-(uploadbtn.width+PADDING*.5):_width-(PADDING+uploadbtn.width);
			uploadbtn.y = (_height-barHeight)+(barHeight-uploadbtn.height)*.5;


			hint.width = (savebtn.visible)?_width-(savebtn.width+uploadbtn.width+PADDING*.5+PADDING*2):_width-PADDING*2;
			hint.y = (_height-barHeight)+(barHeight-hint.height)*.5;
			
			version.x =  (_width-version.width-20);
			version.y = 20;
		}
	}
}


