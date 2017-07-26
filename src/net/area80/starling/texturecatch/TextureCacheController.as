package net.area80.starling.texturecatch
{
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class TextureCacheController
	{
		public var maxTextures:Number;

		private var textureInfoDict:Dictionary = new Dictionary();
		private var textureInfoVector:Vector.<TextureCacheInfo> = new Vector.<TextureCacheInfo>();

		private var timestampWeak:Number = 0;
		private var numWeaks:Number = 0;

		public function TextureCacheController(_maxTextures:Number = 200)
		{
			maxTextures = _maxTextures
		}

		/**
		 * 
		 * @param _texture
		 * @param _textureName Name for referrence in dictionary
		 * @param _ref The object that texture refer to (when not use call setWeak and send _ref object to remove referrence )
		 * 				One texture can refer by many objects.
		 * 
		 */		
		public function deposit(_texture:Texture, _textureName:String, _ref:*):void
		{
			if (textureInfoDict[_textureName]) {
				throw new Error("TextureCatchController ::: Cannot deposit with the same texturename.");
			}
			var textureInfo:TextureCacheInfo = new TextureCacheInfo();
			textureInfo.texture = _texture;
			textureInfo.textureName = _textureName;
			textureInfo.addReference(_ref);
			textureInfoDict[_textureName] = textureInfo;

			textureInfoVector.push(textureInfo);
			clearWeaks();
		}

		/**
		 * 
		 * @param _textureName
		 * @param _ref The object that texture refer to (when not use call setWeak and send _ref object to remove referrence )
		 * 				One texture can refer by many objects.
		 * @return 
		 * 
		 */		
		public function withdraw(_textureName:String, _ref:*):Texture
		{
			var textureCatchInfo:TextureCacheInfo = TextureCacheInfo(textureInfoDict[_textureName]);
			if (textureCatchInfo==null) {
				return null;
			}

			var beforeTimestamp:Number = textureCatchInfo.timestampWeak;
			textureCatchInfo.addReference(_ref);
			var afterTimestamp:Number = textureCatchInfo.timestampWeak;

			if (beforeTimestamp!=Infinity&&afterTimestamp==Infinity) {
				numWeaks--;
			}

			return textureCatchInfo.texture;
		}

		/**
		 * 
		 * @param _textureName
		 * @param _ref remove referrence that texture refer to ( One texture can refer by many objects. )
		 * 
		 */		
		public function setWeak(_textureName:String, _ref:*):void
		{
			var textureCatchInfo:TextureCacheInfo = TextureCacheInfo(textureInfoDict[_textureName]);
			if (textureCatchInfo==null) {
				return;
			}

			var beforeTimestamp:Number = textureCatchInfo.timestampWeak;
			TextureCacheInfo(textureInfoDict[_textureName]).removeReference(_ref, timestampWeak);
			var afterTimestamp:Number = textureCatchInfo.timestampWeak;

			if (beforeTimestamp==Infinity&&afterTimestamp!=Infinity) {
				numWeaks++;
			}
			clearWeaks();
			timestampWeak++;
		}

		/**
		 * Don't foget to dispose, when all texture does not use. 
		 * 
		 */			
		public function dispose():void
		{
			for (var i:uint = 0; i<=textureInfoVector.length-1; i++) {
				textureInfoVector[i].dispose();
			}
			textureInfoDict = null;
			textureInfoVector = null;
		}
		
		/**
		 * <p>Check texture to make sure that not have your texture in cacheController</p>
		 * <p>1. check before load from url</p>
		 * <p>2. When loaded check again. Sometimes another texture is deposited ,meanwhile image is loading.</p>
		 * @param _textureName
		 * @return 
		 * 
		 */		
		public function hasTexture(_textureName:String):Boolean
		{
			return TextureCacheInfo(textureInfoDict[_textureName])?true:false;
		}

		private function clearWeaks():void
		{
			if (textureInfoVector.length>maxTextures) {
				textureInfoVector.sort(
					function(a:TextureCacheInfo, b:TextureCacheInfo):Number
					{
						if (a.timestampWeak>b.timestampWeak) {
							return -1;
						} else if (a.timestampWeak<b.timestampWeak) {
							return 1;
						}
						return 0;
					});
				//trace("___textureInfoVector:", textureInfoVector);
				while (textureInfoVector.length>maxTextures
					&&numWeaks>0
					&&textureInfoVector[textureInfoVector.length-1].timestampWeak!=Infinity) {

					var textureCatchInfo:TextureCacheInfo = textureInfoVector.pop();
					textureInfoDict[textureCatchInfo.textureName] = null;
					delete textureInfoDict[textureCatchInfo.textureName];
					textureCatchInfo.dispose();
					textureCatchInfo = null;
					numWeaks--;

				}
				//trace("clear textureInfoVector:", textureInfoVector);
			}
		}
	}
}
