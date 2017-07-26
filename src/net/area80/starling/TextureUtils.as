package net.area80.starling
{

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	public class TextureUtils
	{
		/**
		 * Update repeat rect for specify image and texture
		 * @param toImage image to update repeat rect
		 * @param texture Texture must has size, use SubTexture or ConcreteTexture for width, height information. If you need sub texture, sub texture width &amp; height must be identicle to its parent texture (the same texture as parent).
		 * @param uvTranslate Set this if you want to move the uv texture.
		 *
		 */
		public static function updateRepeatTexture(toImage:Image, texture:Texture, uvTranslate:Point = null):void
		{
			/*if (texture is SubTexture) {
				if (SubTexture(texture).parent.width != texture.width || SubTexture(texture).parent.height != texture.height) {
					throw new Error("If you need sub texture, texture width & height must be identicle to parent texture (Is the same texture as parent).");
				}
			}*/
			if (texture.width==0||texture.height==0) {
				throw new Error("Texture must has size, use SubTexture or ConcreteTexture for width, height information");
			}

			var textureScale:Number = texture.scale;
			var repeatX:Number = (toImage.width)/(texture.width*textureScale);
			var repeatY:Number = (toImage.height)/(texture.height*textureScale);
			var px:Number = 0;
			var py:Number = 0;
			if (uvTranslate) {
				px = -uvTranslate.x/(texture.width*textureScale);
				py = -uvTranslate.y/(texture.height*textureScale);
			}

			toImage.setTexCoords(0, new Point(px, py));
			toImage.setTexCoords(1, new Point(repeatX+px, py));
			toImage.setTexCoords(2, new Point(px, repeatY+py));
			toImage.setTexCoords(3, new Point(repeatX+px, repeatY+py));
		}


		public static function getRepeatTextureImage(pattern:BitmapData, imageWidth:uint, imageHeight:uint, textureScale:Number = 1):Image
		{
			var texture:Texture;
			texture = Texture.fromBitmapData(pattern, false);
			texture.repeat = true;
			var image:Image = new Image(texture);
			image.width = imageWidth;
			image.height = imageHeight;
			updateRepeatTexture(image, texture);
			return image;
		}
	}
}
