package com.gridtt.framework.component.uploader.view
{

	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.adobejson.AdobeJSON;
	import com.gridtt.framework.component.uploader.data.ImageSettings;
	import com.gridtt.framework.component.uploader.data.Settings;
	import com.gridtt.framework.ui.BaseUI;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import net.area80.utils.FileActivity;

	public class ImageSetContainer extends BaseUI
	{
		private var _height:Number;
		private var _width:Number;
		private var settings:Settings;
		private var container:Sprite;
		private var images:Vector.<ImageSettings>;
		private var sumwidth:Number = 0;
		private var sumheight:Number = 0;
		private const PADDING:int = 20;
		private var boxByImage:Dictionary = new Dictionary();

		private var fileRef:FileReference;

		public function ImageSetContainer(settings:Settings)
		{
			super();
			this.settings = settings;
			container = new Sprite();
			addChild(container);
			this.images = settings.images;
			initSetting();
		}

		public function browse():void
		{
			fileRef = new FileReference();
			var fileFil:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg; *.png; *.JPG; *.PNG; *.jpeg; *.JPEG;");
			fileRef.addEventListener(Event.SELECT, selectHandler);
			fileRef.addEventListener(Event.COMPLETE, resterImage);
			fileRef.addEventListener(Event.CANCEL, onCancel);
			try {
				var success:Boolean = fileRef.browse([fileFil]);
			} catch (error:Error) {
				trace("Unable to browse for files.");
			}
			stage.mouseChildren = false;
		}

		protected function resterImage(event:Event):void
		{
			browsedImage(fileRef.data);
			dispatchEvent(new Event("image"));
		}

		protected function onCancel(event:Event):void
		{
			stage.mouseChildren = true;
		}

		public function doSave():void
		{

			stage.mouseChildren = false;

			var api:String = settings.apiuri;
			var data:Object = {};
			var bmpInBytesList:Vector.<ByteArray> = new Vector.<ByteArray>;
			var types:Array = [];

			data.images = [];
			var i:int;
			for (i = 0; i<images.length; i++) {
				var imagedata:ImageSettings = images[i];
				var box:UploaderBox = boxByImage[images[i]] as UploaderBox;
				var transparent:Boolean = (String(imagedata.name.split(".")[1]).toLowerCase()=="png");
				var bmp:BitmapData = box.getSnapshot(transparent);
				data.images.push({folder: imagedata.folder, name: imagedata.name});
				var encoder:*;
				if (transparent) {
					types.push("image/png");
					bmpInBytesList.push(PNGEncoder.encode(bmp));
				} else {
					encoder = new JPGEncoder(94);
					types.push("image/jpg");
					bmpInBytesList.push(encoder.encode(bmp));
				}

				bmp.dispose();

			}
			var ul:URLVariables = new URLVariables();
			ul["data"] = AdobeJSON.encode(data);
			for (i = 0; i<settings.params.length; i++) {
				ul[settings.params[i].name] = settings.params[i].value;
			}


			FileActivity.uploadMultipleBynaryImage(api, bmpInBytesList, types, function(data:String):void
			{
				try {
					var j:Object = AdobeJSON.decode(data);
					if (j.error) {
						alert(j.error);
					} else if (j.success) {
						alert(j.description);
					}
				} catch (e:Error) {
					alert("API Error!");
				}
				stage.mouseChildren = true;
			}, ul);
		}

		protected function alert(str:String):void
		{
			if (ExternalInterface.available) {
				ExternalInterface.call("alert", str);
			} else {
				trace("[alert]"+str);
			}
		}


		protected function selectHandler(event:Event):void
		{
			fileRef.load();
			stage.mouseChildren = true;
		}

		protected function initSetting(bytes:ByteArray = null):void
		{
			var sx:Number = 0;
			for (var i:int = 0; i<images.length; i++) {
				if (i>0) {
					sx += PADDING;
				}

				var image:UploaderBox = new UploaderBox(images[i]);

				image.x = sx;
				if (bytes) {
					image.loadFromBytes(bytes);
				} else {
					if (image.setting.uploadedpath!="") {
						//trace("\"" + image.setting.uploadedpath + "\"");
						image.loadFromUploadPath();
					}
				}

				boxByImage[images[i]] = image;
				sx += image.width;

				sumheight = Math.max(image.height, sumheight)
				container.addChild(image);
			}
			sumwidth = sx;

			resize();
		}


		protected function browsedImage(bytes:ByteArray = null):void
		{
			for (var i:int = 0; i<images.length; i++) {

				var image:UploaderBox = container.getChildAt(i) as UploaderBox;


				if (bytes) {
					image.loadFromBytes(bytes);
				} else {
					if (image.setting.uploadedpath!="") {
						image.loadFromUploadPath();
					}
				}

			}

			resize();
		}

		protected function resize(event:Event = null):void
		{
			var scale:Number = Math.max(0, Math.min(1, Math.min(_width/sumwidth, _height/sumheight)));
			container.scaleX = container.scaleY = scale;
			container.x = (_width-(sumwidth*scale))*.5;
			container.y = (_height-(sumheight*scale))*.5;
		}

		override protected function update(event:Event = null):void
		{
			resize();
		}


		override public function get height():Number
		{

			return _height;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			invalid();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			invalid();
		}

	}
}
