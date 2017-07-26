package net.area80.starling
{

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.textures.ConcreteTexture;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.utils.getNextPowerOfTwo;

	public class CanvasTextureSet
	{

		public var canvas:BitmapData;
		public var canvasTexture:ConcreteTexture;
		protected var ownTexture:Boolean;
		protected var textureByName:Dictionary = new Dictionary();
		protected var repeatBmpDataByName:Dictionary = new Dictionary(); // for Android handle lost context
		
		/** helper object */
		private static var sOrigin:Point = new Point();

		/**
		 *
		 * @param canvas Large bitmapdata to use as canvas, its size should be power of two for speed init.
		 * @param ownTexture If owned, canvas bitmapdata will be disposed when destroyed.
		 *
		 */
		public function CanvasTextureSet(canvas:BitmapData, ownTexture:Boolean = true, generateMimMaps:Boolean = false)
		{
			this.ownTexture = ownTexture;
			this.canvas = canvas;

			canvas.lock();

			canvasTexture = Texture.fromBitmapData(canvas, generateMimMaps) as ConcreteTexture;

		}

		public function destroy():void
		{
			for (var name:String in textureByName) {
				var texture:SubTexture = textureByName[name] as SubTexture;
				texture.dispose();
				textureByName[name] = null;
				delete textureByName[name];
				if (repeatBmpDataByName[name] is BitmapData){
					BitmapData(repeatBmpDataByName[name]).dispose();
					repeatBmpDataByName[name] = null;
					delete repeatBmpDataByName[name];
				}
			}
			textureByName = new Dictionary();
			repeatBmpDataByName = new Dictionary();
			if (ownTexture) {
				canvas.dispose();
			}
		}

		public function getSubTextureByName(name:String):Texture
		{
			return textureByName[name] as Texture;
		}

		/**
		 *
		 * @param name Unique name for dictionary
		 * @param rect
		 * @param repeat Repeat texture needs more time to init, and must be sized in power of two.
		 * @return
		 *
		 */
		public function initSubTextureByRect(name:String, rect:Rectangle, repeat:Boolean = false):Texture
		{
			var sub:Texture;
			if (repeat) {
				// SubTexture from big canvas (Texture Atlas) can't repeat so we need to create new bitmapdata
				// If width or height not power of two "Texture.fromBitmapData" will create new bmpData, our bmpData will useless and repeat texture will not display correctly
				var bmpdata:BitmapData = new BitmapData( getNextPowerOfTwo(rect.width) , getNextPowerOfTwo(rect.height), true , 0 );
				bmpdata.copyPixels(canvas, rect, sOrigin);
				var bmpTexture:Texture = new SubTexture( Texture.fromBitmapData(bmpdata,false) , new Rectangle(0,0, Math.ceil(rect.width), Math.ceil(rect.height)), true );
				bmpTexture.repeat = repeat;
				if (!Starling.handleLostContext) {
					bmpdata.dispose();
				}else{
					repeatBmpDataByName[name] = bmpdata; // can't dispose if handleLostContext so keep it for dispose later
				}
				sub = bmpTexture;
			} else {
				sub = Texture.fromTexture(canvasTexture, rect) as SubTexture;
			}
			textureByName[name] = sub;
			
			// to do next : Check if already have texture with the same name, we will ?
			return sub;
		}



		/*private function getBmpdataByRect(rect:Rectangle):BitmapData
		{
			var resbmp:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
			var mat:Matrix = new Matrix();
			mat.translate(-rect.x,-rect.y);
			resbmp.draw(canvas, mat);
			resbmp.lock();
			return resbmp;
		}*/

	}
}
