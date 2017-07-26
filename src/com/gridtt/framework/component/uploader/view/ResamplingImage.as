package com.gridtt.framework.component.uploader.view
{
	import com.gridtt.framework.ui.BaseUI;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class ResamplingImage extends BaseUI
	{
		private var src:BitmapData;
		private var displaybmp:BitmapData;
		private var display:Bitmap;
		private var ownSource:Boolean = false;
		public function ResamplingImage(src:BitmapData, ownSource:Boolean=false)
		{
			this.src = src;
			this.ownSource = ownSource;
			invalid();
			super();
		}
		protected function recreate ():void {
			if(displaybmp) displaybmp.dispose();
			if(display && contains(display)) removeChild(display);
			displaybmp = new BitmapData(src.width*scaleX, src.height*scaleY,true,0x00000000);
			var mat:Matrix = new Matrix();
			mat.scale(scaleX,scaleY);
			displaybmp.draw(src,mat,null,null,null,true);
			display = new Bitmap(displaybmp,PixelSnapping.NEVER,true);
			addChild(display);
			display.scaleX = 1/scaleX;
			display.scaleY = 1/scaleY;
		}
		
		override public function set scaleX(value:Number):void
		{
			super.scaleX = value;
			invalid();
		}
		
		override public function set scaleY(value:Number):void
		{
			super.scaleY = value;
			invalid();
		}
		
		override protected function update(event:Event=null):void
		{
			recreate();
			super.update(event);
		}
		
		override public function dispose():void
		{
			if(displaybmp) displaybmp.dispose();
			if(ownSource && src) src.dispose();
			super.dispose();
		}
		
		
		override public function get height():Number
		{
			return (src) ? src.height*scaleY : 0;
		}
		
		override public function get width():Number
		{
			return (src) ? src.width*scaleX : 0;
		}
		
	}
}