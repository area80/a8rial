package com.gridtt.framework.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import net.area80.ui2d.remote.ImageBox;
	import net.area80.utils.FileActivity;

	public class ImageBrowser
	{
		
		private var fileRef:FileReference;
		private var ldr:Loader;
		private var fileFil:FileFilter;
		
		public var DispatcherBitmapDataLoaded:Dispatcher = new Dispatcher(BitmapData);
		public var DispatcherCancel:Dispatcher = new Dispatcher();
		public var DispatcherErrorWithReason:Dispatcher = new Dispatcher(String);
		
		public function ImageBrowser()
		{
			fileFil = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg; *.png; *.JPG; *.PNG; *.jpeg; *.JPEG;");
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, selectHandler);
			fileRef.addEventListener(Event.COMPLETE, resterImage);
			fileRef.addEventListener(Event.CANCEL, onCancel);
		}
		public function browse ():void {
			try {
				var success:Boolean = fileRef.browse([fileFil]);
			} catch (error:Error) {
				trace("Unable to browse.");
				DispatcherCancel.dispatch();
			}
		}
		protected function resterImage(event:Event):void
		{
			loadFromBytes(fileRef.data);
		}
		
		protected function selectHandler(event:Event):void
		{
			fileRef.load();
		}
		protected function onCancel(event:Event):void
		{
			DispatcherCancel.dispatch();
		}
		public function loadFromBytes(bytes:ByteArray):void
		{
			if (ldr) {
				GridttUtils.clearLoader(ldr);
			}
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaded);
			
			try {
				ldr.loadBytes(bytes);
			} catch (e:Error) {
				DispatcherErrorWithReason.dispatch("Can't convert file to bitmapdata");
			}
			
		}
		
		protected function contentLoaded(event:Event):void
		{
			var _bitmapData:BitmapData = Bitmap(ldr.content).bitmapData;
			DispatcherBitmapDataLoaded.dispatch(_bitmapData);
		}
	}
}