package com.gridtt.framework.component.uploader.view
{

	import com.gridtt.framework.component.uploader.data.ImageSettings;
	import com.gridtt.framework.ui.BaseUI;
	import com.gridtt.framework.util.GridttUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class UploaderBox extends BaseUI
	{
		public static const MODE_NONE:uint = 0;
		public static const MODE_V:uint = 1;
		public static const MODE_H:uint = 2;
		public static const MODE_FREE:uint = 3;

		private var ldr:Loader;
		private var guideldr:Loader;
		private var masking:Sprite;
		private var bg:Sprite;
		private var display:ResamplingImage;
		private var ghost:ResamplingImage;
		private var _bitmapData:BitmapData;
		private var movemode:uint = 0;
		public var setting:ImageSettings;

		private var downPoint:Point = new Point();
		private var ipoint:Point = new Point();

		private var lcp:Point = new Point();
		private var enlargeClip:Sprite;

		public function UploaderBox(setting:ImageSettings)
		{
			enlargeClip = createEnlargeClip();
			this.setting = setting;
			bg = new Sprite();
			bg.graphics.beginFill(0x999999);
			bg.graphics.drawRect(0, 0, setting.width, setting.height);
			addChild(bg);
			mouseChildren = false;
			mouseEnabled = false;
			loadGuide();
			super();
		}
		protected function createEnlargeClip ():Sprite {
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(0xFFFFFF,1);
			spr.graphics.lineStyle(1,0,1,false,LineScaleMode.NONE);
			spr.graphics.drawRect(-10,-10,20,20);
			return spr;
		}

		public function getSnapshot(transparent:Boolean = false):BitmapData
		{
			var bmp:BitmapData = new BitmapData(setting.width, setting.height, transparent, 0x00FFFFFF);
			bg.visible = false;
			if(guideldr) guideldr.visible = false;
			enlargeClip.visible = false;
			bmp.draw(this, null, null, null, null, true);
			if(guideldr) guideldr.visible = true;
			bg.visible = true;
			enlargeClip.visible = true;
			return bmp;
		}

		protected function setMask():void
		{
			if (!masking) {
				masking = new Sprite();
				masking.graphics.beginFill(0x000000);
				masking.graphics.drawRect(0, 0, setting.width, setting.height);
			}
			if (!contains(masking))
				addChild(masking);
			display.mask = masking;
		}

		protected function unsetMask():void
		{
			if (masking) {
				if (display&&display.mask==masking) {
					display.mask = null;
				}
				if (contains(masking))
					removeChild(masking);
			}
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function loadFromUploadPath():void
		{
			if (ldr) {
				GridttUtils.clearLoader(ldr);
			}
			ldr = new Loader();
			ldr.load(new URLRequest(setting.uploadedpath));
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaded);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
			{
				loadFromUploadPath();
			});
			unsetInteractive();
		}
		public function loadGuide():void
		{
			if(!setting.guidefile || setting.guidefile=="")return;
			if (guideldr) {
				GridttUtils.clearLoader(guideldr);
			}
			guideldr = new Loader();
			guideldr.mouseChildren = false;
			guideldr.mouseEnabled = false;
			guideldr.load(new URLRequest(setting.guidefile));
			guideldr.contentLoaderInfo.addEventListener(Event.COMPLETE, guideLoaded);
			guideldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
			{
				loadGuide();
			});
		}
		public function loadFromBytes(bytes:ByteArray):void
		{
			if (ldr) {
				GridttUtils.clearLoader(ldr);
			}
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaded);

			ldr.loadBytes(bytes);
			unsetInteractive();

		}

		override public function dispose():void
		{
			unsetInteractive();
			if (_bitmapData)
				_bitmapData.dispose();
			if (ldr) {
				GridttUtils.clearLoader(ldr);
			}
			if (guideldr) {
				GridttUtils.clearLoader(guideldr);
			}
		}

		protected function unsetInteractive():void
		{
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
				stage.removeEventListener(MouseEvent.MOUSE_UP, end);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePos);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateScale);
			}
		}
		protected function updateScale(event:MouseEvent):void
		{
			var mx:Number = mouseX;
			var my:Number = mouseY;
			var dy:Number = my-downPoint.y;
			var dx:Number = mx-downPoint.x;
			var d:Number = 0;
			
			var sx:Number = (mx-display.x)/(display.width*(1/display.scaleX));
			display.scaleX = display.scaleY = ghost.scaleX = ghost.scaleY = sx;
			
			moveEnlargeClip();
		}

		protected function setInteractive():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
		}

			
		protected function start(event:MouseEvent):void
		{
			if(mouseX>enlargeClip.x-10 && mouseX<enlargeClip.x+10 &&
				mouseY>enlargeClip.y-10 && mouseY<enlargeClip.y+10) {
				ghost.alpha = .3;
				downPoint.x = stage.mouseX;
				downPoint.y = stage.mouseY;
				
				ipoint.x = ghost.x;
				ipoint.y = ghost.y;
				
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
				stage.addEventListener(MouseEvent.MOUSE_UP, end);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, updateScale);
			} else if (mouseX>0&&mouseX<setting.width&&mouseY>0&&mouseY<setting.height) {
				ghost.alpha = .3;
				downPoint.x = stage.mouseX;
				downPoint.y = stage.mouseY;

				ipoint.x = ghost.x;
				ipoint.y = ghost.y;

				stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
				stage.addEventListener(MouseEvent.MOUSE_UP, end);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, updatePos);
			}
		}

		protected function end(event:MouseEvent):void
		{
			ghost.alpha = 0;
			if (stage) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
				stage.removeEventListener(MouseEvent.MOUSE_UP, end);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePos);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateScale);
			}
		}

		protected function updatePos(event:MouseEvent):void
		{
			var mx:Number = stage.mouseX;
			var my:Number = stage.mouseY;
			var d:Number = 0;
			if (movemode==MODE_H) {
				d = mx-downPoint.x;
				ghost.x = Math.max(-(ghost.width-setting.width), Math.min(0, ipoint.x+d));
				display.x = ghost.x;
			} else if (movemode==MODE_V) {
				d = my-downPoint.y;
				ghost.y = Math.max(-(ghost.height-setting.height), Math.min(0, ipoint.y+d));
				display.y = ghost.y;
			} else if (movemode==MODE_FREE) {
				var dy:Number = my-downPoint.y;
				var dx:Number = mx-downPoint.x;
				ghost.y = ipoint.y+dy;
				ghost.x = ipoint.x+dx;
				display.y = ghost.y;
				display.x = ghost.x;
			}
			moveEnlargeClip();
		}
		protected function moveEnlargeClip():void {
			enlargeClip.x = display.x + display.width;
			enlargeClip.y = display.y + display.height;
		}
		protected function guideLoaded(event:Event = null):void
		{
			
			
			try {
				Bitmap(guideldr.content).smoothing = true;	
			}catch(e:Error) {
			
			}
			
			
			var sx:Number = setting.width/guideldr.width
			var sy:Number = setting.height/guideldr.height;
			var scale:Number = sx;
			
			
			//guideldr.scaleX = guideldr.scaleY = scale;
			
			guideldr.mouseChildren = false;
			guideldr.mouseEnabled = false;
			
			addChild(guideldr);
			
		}
		protected function contentLoaded(event:Event = null):void
		{

			if (_bitmapData)
				_bitmapData.dispose();
			if (display&&contains(display)) {
				display.dispose();
				removeChild(display);
			}
			if (display)
				display = null;
			if (ghost&&contains(ghost)) {
				ghost.dispose();
				removeChild(ghost);
			}
			if (ghost)
				ghost = null;

			_bitmapData = Bitmap(ldr.content).bitmapData;
			

			display =  new ResamplingImage(_bitmapData);
			ghost = new ResamplingImage(_bitmapData);
			//display.addChild(new Bitmap(_bitmapData, "auto", true));
			//ghost.addChild(new Bitmap(_bitmapData, "auto", true));

			ghost.alpha = 0;

			var sx:Number = setting.width/_bitmapData.width
			var sy:Number = setting.height/_bitmapData.height;
			var scale:Number = sx;

			if (sx<sy) {
				//movemode = MODE_H;
				movemode = MODE_FREE;
				scale = sy;
			} else if (sx>sy) {
//				movemode = MODE_V;
				movemode = MODE_FREE;
				scale = sx;
			} else {
				movemode = MODE_FREE;
			}
			if (movemode!=MODE_NONE) {
				setInteractive();
			}

			display.scaleX = display.scaleY = scale;
			ghost.scaleX = ghost.scaleY = scale;

			display.mouseChildren = false;
			display.mouseEnabled = false;

			ghost.mouseChildren = false;
			ghost.mouseEnabled = false;
			
			moveEnlargeClip();

			setMask();
			
			addChildAt(enlargeClip,1);
			addChildAt(display,1);
			addChildAt(ghost,1);

		}

		override public function get height():Number
		{
			return setting.height;
		}

		override public function set height(value:Number):void
		{
			//
		}

		override public function get width():Number
		{
			return setting.width;
		}

		override public function set width(value:Number):void
		{
			//
		}



	}
}
