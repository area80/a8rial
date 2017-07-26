package com.gridtt.framework.component.editor
{
	
	import com.gridtt.framework.ui.BaseUI;
	import com.gridtt.framework.util.GridttUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class ImageEditorFixSingleSide extends BaseUI
	{
		public static const MODE_NONE:uint = 0;
		public static const MODE_V:uint = 1;
		public static const MODE_H:uint = 2;
		
		private var ldr:Loader;
		private var masking:Sprite;
		private var bg:Sprite;
		private var display:Sprite;
		private var ghost:Sprite;
		private var _bitmapData:BitmapData;
		private var movemode:uint = 0;
		
		private var boxWidth:int = 0;
		private var boxHeight:int = 0;
		
		private var downPoint:Point = new Point();
		private var ipoint:Point = new Point();
		
		private var lcp:Point = new Point();
		
		public function ImageEditorFixSingleSide(w:int,h:int,bgColor:int=0x999999,bgTrasparent:int=1)
		{
			boxWidth = w;
			boxHeight = h;
			
			bg = new Sprite();
			bg.graphics.beginFill(bgColor);
			bg.alpha = bgTrasparent;
			bg.graphics.drawRect(0, 0, boxWidth, boxHeight);
			addChild(bg);
			mouseChildren = false;
			mouseEnabled = false;
			super();
		}
		
		public function getSnapshot(transparent:Boolean = false):BitmapData
		{
			var bmp:BitmapData = new BitmapData(boxWidth, boxHeight, transparent, 0x00FFFFFF);
			bg.visible = false;
			bmp.draw(this, null, null, null, null, true);
			bg.visible = true;
			return bmp;
		}
		
		protected function setMask():void
		{
			if (!masking) {
				masking = new Sprite();
				masking.graphics.beginFill(0x000000);
				masking.graphics.drawRect(0, 0, boxWidth, boxHeight);
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
		
		public function loadFromUploadPath(url:String):void
		{
			if (ldr) {
				GridttUtils.clearLoader(ldr);
			}
			ldr = new Loader();
			ldr.load(new URLRequest(url));
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaded);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
			{
				loadFromUploadPath(url);
			});
			unsetInteractive();
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
		}
		
		public function unsetInteractive():void
		{
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
				stage.removeEventListener(MouseEvent.MOUSE_UP, end);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePos);
			}
		}
		
		public function setInteractive():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
		}
		
		protected function start(event:MouseEvent):void
		{
			
			if (mouseX>0&&mouseX<boxWidth&&mouseY>0&&mouseY<boxHeight) {
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
			}
		}
		public function get imagePosition():Point {
			return new Point(display.x,display.y);
		}
		public function set imagePosition(o:Point):void {
			display.x = ghost.x = o.x;
			display.y = ghost.y = o.y;
		}
		protected function updatePos(event:MouseEvent):void
		{
			var mx:Number = stage.mouseX;
			var my:Number = stage.mouseY;
			var d:Number = 0;
			if (movemode==MODE_H) {
				d = mx-downPoint.x;
				ghost.x = Math.max(-(ghost.width-boxWidth), Math.min(0, ipoint.x+d));
				display.x = ghost.x;
			} else if (movemode==MODE_V) {
				d = my-downPoint.y;
				ghost.y = Math.max(-(ghost.height-boxHeight), Math.min(0, ipoint.y+d));
				display.y = ghost.y;
			}
		}
		protected function contentLoaded(event:Event = null):void
		{
			try {
				loadFromBitmapData(Bitmap(ldr.content).bitmapData);
			} catch (e:Error) {
				throw new Error("Can't find Bitmap from loaded content");
			}
		}
		
		public function loadFromBitmapData(bmpdata:BitmapData):void
		{
			
			if (_bitmapData)
				_bitmapData.dispose();
			if (display&&contains(display))
				removeChild(display);
			if (display)
				display = null;
			if (ghost&&contains(ghost))
				removeChild(ghost);
			if (ghost)
				ghost = null;
			
			_bitmapData = bmpdata.clone();
			
			display = new Sprite();
			ghost = new Sprite();
			ghost.mouseChildren = false;
			ghost.mouseEnabled = false;
			display.mouseChildren = false;
			display.mouseEnabled = false;
			display.addChild(new Bitmap(_bitmapData, "auto", true));
			ghost.addChild(new Bitmap(_bitmapData, "auto", true));
			
			ghost.alpha = 0;
			
			var sx:Number = boxWidth/_bitmapData.width
			var sy:Number = boxHeight/_bitmapData.height;
			var scale:Number = sx;
			
			if (sx<sy) {
				movemode = MODE_H;
				scale = sy;
			} else if (sx>sy) {
				movemode = MODE_V;
				scale = sx;
			} else {
				movemode = MODE_NONE;
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
			
			setMask();
			
			addChild(ghost);
			addChild(display);
			
		}
		
		override public function get height():Number
		{
			return boxHeight;
		}
		
		override public function set height(value:Number):void
		{
			//
		}
		
		override public function get width():Number
		{
			return boxWidth;
		}
		
		override public function set width(value:Number):void
		{
			//
		}
		
		
		
	}
}
