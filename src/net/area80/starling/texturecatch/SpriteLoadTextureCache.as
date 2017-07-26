package net.area80.starling.texturecatch
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class SpriteLoadTextureCache extends Sprite
	{
		//// STEP
		// 1. no focus
		// 2. focus first / no load image / timeout to load image
		// 3. focus time out ready to load image
		// 4. focus loaded image
		
		protected const STEP_IDLE:String = "stepidle";
		protected const STEP_WAITING_LOAD:String = "stepwaitingload";
		protected const STEP_START_LOAD_IMAGE:String = "stepstartloadimage";
		protected const STEP_LOADED_IMAGE:String = "steploadedimage";
		protected var step:String = STEP_IDLE;
		
		protected var TIMEOUT_TO_LOAD:Number = 600;
		
		protected var url:String;
		private const SUFFIX:String = "PICTURE";
		protected var texturePictureCacheController:TextureCacheController;
		
		protected var loader:Loader;
		protected var loaderContext:LoaderContext = new LoaderContext();;
		protected var isFocus:Boolean = false;
		protected var delayStartLoad:uint = 0;
		protected var image:Image;
		
		/**
		 * 
		 * @param _url This class will load image when focus and not have _url in textureCacheController.
		 * @param _texturePictureCacheController
		 * 
		 */		
		public function SpriteLoadTextureCache( _url:String , _texturePictureCacheController:TextureCacheController )
		{
			super();
			this.texturePictureCacheController = _texturePictureCacheController;
			this.url = _url;
			blur();
		}
		
		public function focus():void
		{
			if (!isFocus) {
				visible = true;
				isFocus = true;
				
				if (step==STEP_IDLE) {
					//check if load the same texture , use loaded texture instead.
					if( !texturePictureCacheController.hasTexture(url+SUFFIX) ){
						step = STEP_WAITING_LOAD;
						delayStartLoad = setTimeout(loadImage, TIMEOUT_TO_LOAD);
					}else{
						step=STEP_LOADED_IMAGE;
						addImageIfLoadedAndFocus();
					}
				} else if (step==STEP_LOADED_IMAGE) {
					addImageIfLoadedAndFocus();
				}
			}
		}
		
		public function blur():void
		{
			if (isFocus) {
				visible = false;
				isFocus = false;
				if (image!=null)
					removeChild(image);
				
				if (step==STEP_WAITING_LOAD) {
					step = STEP_IDLE;
					clearTimeout(delayStartLoad);
				} else if (step==STEP_START_LOAD_IMAGE) {
					step = STEP_IDLE;
					destroyLoader();
				} else if (step==STEP_LOADED_IMAGE) {
					texturePictureCacheController.setWeak(url+SUFFIX, this);
				}
			}
		}
		
		/**
		 * destroy not removeReferrence(setWeak) to texturePictureCacheController 
		 * If texturePictureCacheController still be used ,want to destroy only this object ,removeReferrence() too.
		 * 
		 */		
		public function destroy():void
		{
			clearTimeout(delayStartLoad);
			destroyLoader();
		}
		
		/**
		 * setWeak to texturePictureCacheController 
		 * 
		 */		
		public function removeReferrence():void
		{
			texturePictureCacheController.setWeak(url+SUFFIX, this);
		}
		
		
		/**
		 * Override to manage the texture that loaded 
		 * 
		 */		
		protected function composeTexture(_texture:Texture):void
		{
			image = new Image(_texture);
			image.touchable = false;
			addChild(image);	
		}
		
		
		
		
		/**
		 *  LOADER
		 * 
		 */		
		
		protected function loadImage():void
		{
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			if (!loader) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedImage);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			}
			step = STEP_START_LOAD_IMAGE;
			loader.load(new URLRequest(url),loaderContext);
		}
		
		protected function loadedImage(event:Event):void
		{
			step = STEP_LOADED_IMAGE;
			//Check again. Sometimes another texture is deposited ,meanwhile image is loading 
			if( !texturePictureCacheController.hasTexture(url+SUFFIX) ){
				var bmpd:BitmapData = Bitmap(loader.contentLoaderInfo.content).bitmapData;
				var texture:Texture = Texture.fromBitmapData(bmpd, false);
				bmpd.dispose();
				texturePictureCacheController.deposit(texture, url+SUFFIX, this);
			}
			addImageIfLoadedAndFocus();
		}
		
		protected function loadError(event:IOErrorEvent):void
		{
			if(delayStartLoad) clearTimeout(delayStartLoad);
			delayStartLoad = setTimeout(loadImage, TIMEOUT_TO_LOAD);
			step = STEP_WAITING_LOAD;
		}
		
		protected function destroyLoader():void
		{
			if (!loader)
				return;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedImage);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			try {
				loader.close();
			} catch (e:Error) {
			}
			try {
				loader.unload();
			} catch (e:Error) {
			}
			loader = null;
		}
		
		protected function addImageIfLoadedAndFocus():void
		{
			if (step==STEP_LOADED_IMAGE&&isFocus) {
				var texture:Texture = texturePictureCacheController.withdraw(url+SUFFIX, this);
				if (texture) {
					composeTexture(texture);
				} else {
					delayStartLoad = setTimeout(loadImage, TIMEOUT_TO_LOAD);
					step = STEP_WAITING_LOAD;
				}
			}
		}
	}
}