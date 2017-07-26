package net.area80.starling
{

	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class TilesLibrary
	{

		private var tilesDict:Dictionary = new Dictionary(false);
		private var textureBaseByBitmapData:Dictionary = new Dictionary(false);
		private var invalidBitmapDataDict:Dictionary = new Dictionary(false);
		private var spaces:Vector.<BitmapData>;
		private var buffer:int = 0;
		private var rectToFill:Rectangle = new Rectangle();
		private var tileWidth:int;
		private var tileHeight:int;
		private var spaceSize:int;
		private var argb:int;
		private var transparent:Boolean;
		private var context:Context3D;

		public function TilesLibrary(forContext:Context3D, tileWidth:int, tileHeight:int, spaceSize:int = 2048, argb:int = 0xFFFFFFFF, transparent:Boolean = false)
		{
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.spaceSize = spaceSize;
			this.argb = argb;
			this.transparent = transparent;
			_overload();
		}

		private function get maxBuffer():int
		{
			return spaces.length * bitmapPerSpace;
		}

		private function get bitmapPerSpace():int
		{
			return totalX * totalY;
		}

		private function _overload():void
		{
			rectToFill.width = tileWidth;
			rectToFill.height = tileHeight;
			spaces = new Vector.<BitmapData>();
		}

		private function get totalX():int
		{
			return Math.floor(spaceSize / tileWidth);
		}

		private function get totalY():int
		{
			return Math.floor(spaceSize / tileHeight);
		}

		private function getNextEmptyTile():BitmapTile
		{
			var tile:BitmapTile;
			if (buffer < maxBuffer - 1) {
				tile = new BitmapTile();
				tile.spaceid = Math.floor(buffer / bitmapPerSpace);
				tile.bmpid = buffer % bitmapPerSpace;
				buffer++;
				return tile;
			} else {
				for each (var key:String in tilesDict) {
					if (BitmapTile(tilesDict[key]).weak) {
						tile = BitmapTile(tilesDict[key]);
						delete tilesDict[key];
						break;
					}
				}
				if (tile) {
					prepareWeakTile(tile);
					return tile;
				} else {
					//create space
					createBitmapSpace();
					return getNextEmptyTile();
				}
			}
		}

		private function prepareWeakTile(tile:BitmapTile):void
		{
			tile.weak = false;
			rectToFill.x = (tile.bmpid % totalX) * tileWidth;
			rectToFill.y = Math.floor(tile.bmpid / totalY) * tileHeight;
			if (transparent) {
				spaces[tile.spaceid].fillRect(rectToFill, argb);
			}
		}



		public function storeBitmapData(keyword:String, bitmapData:BitmapData, matrix:Matrix = null, replaceIfDuplicate:Boolean = true):void
		{
			var tile:BitmapTile = tilesDict[keyword] as BitmapTile;
			if (!tile) {
				tile = getNextEmptyTile();
				drawToTile(tile, bitmapData, matrix);
			} else {
				if (replaceIfDuplicate) {
					prepareWeakTile(tile);
					drawToTile(tile, bitmapData, matrix);
				}
			}
		}

		public function isChange():Boolean
		{
			for each (var bmpData:BitmapData in invalidBitmapDataDict) {
				if (invalidBitmapDataDict[bmpData] == "invalid")
					return true;
			}
			return false;
		}

		public function markWeak(keyword:String, weak:Boolean = true):void
		{
			var tile:BitmapTile = tilesDict[keyword];
			if (tile)
				tile.weak = weak;
		}

		public function uploadToContext():void
		{
			var texture:Texture = context.createTexture(spaceSize, spaceSize, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(null);
		}

		private function drawToTile(tile:BitmapTile, bitmapData:BitmapData, matrix:Matrix = null):void
		{
			rectToFill.x = (tile.bmpid % totalX) * tileWidth;
			rectToFill.y = Math.floor(tile.bmpid / totalY) * tileHeight;
			spaces[tile.spaceid].draw(bitmapData, matrix, null, null, rectToFill);
			invalidBitmapDataDict[spaces[tile.spaceid]] = "invalid";
		}



		private function createBitmapSpace():void
		{
			spaces.push(new BitmapData(spaceSize, spaceSize, transparent, argb));
		}


	}
}
import flash.geom.Rectangle;

class BitmapTile
{
	public var spaceid:int = 0;
	public var bmpid:int = 0;
	public var weak:Boolean = false;
	
	public function BitmapTile(){
		
	}
}
