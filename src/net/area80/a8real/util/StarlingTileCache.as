package net.area80.a8real.util
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import net.area80.a8real.enum.GoogleMapType;
	import net.area80.a8real.enum.OpenStreetMapType;
	import net.area80.a8real.enum.ServerMapType;
	import net.area80.starling.TextureBank;
	
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;

	public class StarlingTileCache
	{
		public static const MAX_WEAK_TILES:int = 100;
		private static var BLANKTEXTURE:BitmapData = new BitmapData(256, 256, true, 0x00CCCCCC);
		private static var caches:Dictionary = new Dictionary();
		private static var _totalWeak:int = 0;

		public static function get totalWeakTiles():int
		{
			return _totalWeak;
		}

		public static function clearIfReachMemoryLimit(timediff:int = 10000):void
		{
			if (_totalWeak >= MAX_WEAK_TILES) {
				trace("before clearing " + _totalWeak);
				doClearingByTime(timediff);
				trace("after clearing " + _totalWeak);
			}
		}

		private static function doClearingByTime(timediff:int = 10000, needmore:int = -1):void
		{
			//trace("clearing diff of " + timediff);
			var total:int = 0;
			var deleted:Number = 0;
			for each (var cache:StarlingTileCache in caches) {
				deleted += cache.removeWeakTiles(timediff);
				total++;
			}
			//	trace(deleted + "/" + total);
			var deletedratio:Number = deleted / total;
			//must clear 50% up
			if (needmore == -1) {
				if (deletedratio < .5) {
					doClearingByTime(timediff * .5, Math.round(total * .5 - deleted));
				}
			} else {
				if (deleted < needmore) {
					doClearingByTime(timediff * .5, needmore)
				}
			}
		}

		public static function clearAllWeakTiles():void
		{
			for each (var cache:StarlingTileCache in caches) {
				cache.removeWeakTiles();
			}
		}

		public static function getCacheAt(zoom:int, mapTypeId:String = GoogleMapType.ROADMAP,ServerType:int = ServerMapType.GOOGLE_MAP):StarlingTileCache
		{
			var str:String = generateAccountName(zoom, mapTypeId);
			if (!caches[str])
				caches[str] = new StarlingTileCache(str, zoom, mapTypeId,ServerType);
			return caches[str];
		}


		public static function clearAllCache():void
		{
			for each (var cache:StarlingTileCache in caches) {
				cache.clearCache();
				delete caches[cache.accountName];
			}

			_totalWeak = 0;
		}

		public static function generateAccountName(zoom:int, mapTypeId:String = ""):String
		{
			return "gmkit:" + zoom + ":" + mapTypeId;
		}

		public var accountName:String;
		public var zoom:int;
		public var mapTypeId:String;
		public var serverType:int;

		private var usageByTexture:Dictionary = new Dictionary();
		private var loaderByTexture:Dictionary = new Dictionary();
		private var weakTexture:Dictionary = new Dictionary();
		private var keyByTexture:Dictionary = new Dictionary();

		//private var account:

		public function StarlingTileCache(accountName:String, zoom:int, mapTypeId:String,ServerType:int):void
		{
			this.zoom = zoom;
			this.mapTypeId = mapTypeId;
			this.serverType = ServerType;
			this.accountName = accountName;
			TextureBank.getAccount(accountName, true);
		}

		public function clearCache():void
		{
			for (var key:* in keyByTexture) {
				deleteTexture(ConcreteTexture(key));
			}
			if (caches[accountName])
				delete caches[accountName];

			TextureBank.closeAccount(accountName);

		}

		public function composeKey(tx:int, ty:int):String
		{
			return tx + ":" + ty + ":" + zoom + ":" + mapTypeId;
		}


		private function destroyLoader(ldr:Loader):void
		{
			if (ldr) {
				try {
					Bitmap(ldr.content).bitmapData.dispose();
				} catch (e:Error) {
				}
				try {
					ldr.close();
				} catch (e:Error) {
				}
				try {
					ldr.unload();
				} catch (e:Error) {
				}
			}

		}

		public function removeWeakTiles(timediff:int = 0):Number
		{
			var time:int = getTimer();
			var total:int = 0;
			var deleted:int = 0;
			for (var key:* in weakTexture) {
				total++;
				var texture:starling.textures.Texture = key as starling.textures.Texture;
				if (time - weakTexture[texture] >= timediff) {
					deleteTexture(texture);
					deleted++;
				}
			}
			return (total == 0 && deleted == 0) ? 1 : deleted / total;
		}

		private function composeLoader(tx:int, ty:int, texture:ConcreteTexture, callback:Function = null, loadCount:int = 0):void
		{
			if (loaderByTexture[texture]) {
				destroyLoader(loaderByTexture[texture]);
				delete loaderByTexture[texture];
			}
			if (loadCount > 10) {
				trace("Loader Exceed Limit @ tx:" + tx + ",ty:" + ty + ", mapType:" + mapTypeId + ", zoom:" + zoom);
				return;
			}
			var ldr:Loader = new Loader();
			loaderByTexture[texture] = ldr;
			
			var errorFunc:Function = function(e:IOErrorEvent):void{
				ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,errorFunc );
				destroyLoader(ldr);
				delete loaderByTexture[texture];
				composeLoader(tx, ty, texture, callback, loadCount + 1);
			}
				
			var completeFunc:Function = function(e:Event):void{
				ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeFunc );
				try {
					flash.display3D.textures.Texture(texture.base).uploadFromBitmapData(Bitmap(LoaderInfo(e.currentTarget).loader.content).bitmapData);
					texture.root.onRestore = null; // don't want starling to handle lost context
				} catch (e:Error) {
					
				}
				callback(false);
				destroyLoader(ldr);
				delete loaderByTexture[texture];
			}

			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorFunc );
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,completeFunc );
			
			var url:String;
			switch(serverType){
				case ServerMapType.OPENSTREET_MAP:
					url= OpenStreetmapURLHelper.composeURLByTile(tx, ty, zoom, mapTypeId);
					break;
				default: // ServerMapType.GOOGLE_MAP:
					url= GooglemapURLHelper.composeURLByTile(tx, ty, zoom, mapTypeId);
			}
			
			ldr.load(new URLRequest(url));
		}

		public function deleteTexture(texture:starling.textures.Texture):void
		{
			if (loaderByTexture[texture]) {
				destroyLoader(loaderByTexture[texture]);
				delete loaderByTexture[texture];
			}
			var key:String = keyByTexture[texture];

			if (key) {
				delete keyByTexture[texture];

				if (weakTexture[texture]) {
					delete weakTexture[texture];
					_totalWeak--;
				}
				TextureBank.removeTexture(key, accountName);
			} else {
				trace("key not found?");
			}
		}

		private function setWeakTileByKey(key:String):void
		{
			var texture:starling.textures.Texture = TextureBank.withdraw(key, accountName);
			if (texture) {
				setWeakTileByTexture(texture);
			}
		}

		private function setWeakTileByID(tx:int, ty:int):void
		{
			var key:String = composeKey(tx, ty);
			setWeakTileByKey(key);
		}

		private function setWeakTileByTexture(texture:starling.textures.Texture):void
		{
			if (typeof(weakTexture[texture]) == "undefined") {
				_totalWeak++;
			}
			weakTexture[texture] = getTimer();
		}

		private function unSetWeakTileByKey(key:String):void
		{
			var texture:starling.textures.Texture = TextureBank.withdraw(key, accountName);
			if (texture) {
				unSetWeakTileByTexture(texture);
			}
		}

		private function unSetWeakTileByID(tx:int, ty:int):void
		{
			var key:String = composeKey(tx, ty);
			unSetWeakTileByKey(key);
		}

		private function unSetWeakTileByTexture(texture:starling.textures.Texture):void
		{
			if (typeof(weakTexture[texture]) != "undefined") {
				delete weakTexture[texture];
				_totalWeak--;
			}
		}

		public function setUsage(texture:starling.textures.Texture, objectKey:*):void
		{
			if (!usageByTexture[texture])
				usageByTexture[texture] = new Array();
			for (var i:int = 0; i < usageByTexture[texture].length; i++) {
				if (usageByTexture[texture][i] == objectKey)
					return;
			}
			usageByTexture[texture].push(objectKey);
			unSetWeakTileByTexture(texture);
		}

		public function setUnuse(texture:starling.textures.Texture, objectKey:*):void
		{
			if (!usageByTexture[texture])
				return;
			for (var i:int = 0; i < usageByTexture[texture].length; i++) {
				if (usageByTexture[texture][i] == objectKey) {
					usageByTexture[texture].splice(i, 1);
					i -= 1;
				}
			}
			if (usageByTexture[texture].length == 0) {
				delete usageByTexture[texture];
				setWeakTileByTexture(texture);
			}
		}

		public function isInUse(texture:starling.textures.Texture):Boolean
		{
			if (!usageByTexture[texture] || usageByTexture[texture].length == 0)
				return false;
			return true;
		}

		public function getTileAt(tx:int, ty:int, callback:Function):ConcreteTexture
		{
			var key:String = composeKey(tx, ty);
			var texture:ConcreteTexture = TextureBank.withdraw(key, accountName) as ConcreteTexture;

			if (texture) {
				keyByTexture[texture] = key;
				unSetWeakTileByID(tx, ty);
				callback(true);
				return texture;
			} else {
				texture = starling.textures.Texture.fromBitmapData(BLANKTEXTURE, false, false) as ConcreteTexture;
				keyByTexture[texture] = key;
				unSetWeakTileByID(tx, ty);
				TextureBank.deposit(texture, key, accountName);
				composeLoader(tx, ty, texture, callback);
				return texture;
			}
		}

	}
}
