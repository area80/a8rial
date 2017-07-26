package net.area80.starling
{

	import flash.utils.Dictionary;
	import starling.textures.Texture;

	public class TextureBank
	{
		public static const DEFAULT_ACCOUNT:String = "default";
		public static const URI_ACCOUNT:String = "uri";
		public static const UIKIT_ACCOUNT:String = "uikit";

		protected static var _storage:Dictionary = new Dictionary();

		public static function withdraw(textureName:String, fromAccount:String = DEFAULT_ACCOUNT):Texture
		{
			//trace("withdraw " + textureName + " from " + fromAccount + " has:" + (getAccount(fromAccount) && (getAccount(fromAccount))[textureName]));
			return (getAccount(fromAccount)) ? getAccount(fromAccount)[textureName] : null;
		}

		public static function deposit(texture:Texture, textureName:String, account:String = DEFAULT_ACCOUNT):Texture
		{
			var acc:Dictionary = getAccount(account, true);
			if (acc[textureName]) {
				return texture;
					//removeTexture(textureName, account);
			}
			acc[textureName] = texture;
			//trace(textureName + " is deposit " + acc[textureName]);
			return texture;
		}



		public static function getAccount(name:String, createIfNotExist:Boolean = false):Dictionary
		{
			if (!_storage[name]) {
				if (createIfNotExist) {
					_storage[name] = new Dictionary();
				}
			}
			return _storage[name];
		}

		public static function closeAccount(accountName:String):void
		{
			var acc:Dictionary = getAccount(accountName);
			if (acc) {
				for (var name:String in acc) {
					removeTexture(name, accountName);
				}
				delete _storage[accountName];
			} else {
				trace(getClassName() + "Account name \"" + accountName + "\" is not found, can't be closed!");
			}
		}

		public static function removeTexture(textureName:String, fromAccount:String):void
		{
			var acc:Dictionary = getAccount(fromAccount);
			var texture:Texture = acc[textureName];
			if (acc) {
				if (!texture) {
					trace(getClassName() + "Texture name \"" + textureName + "\" not found, can't be removed!");
					return;
				}
				texture.dispose();

				delete acc[textureName];


			} else {
				trace(getClassName() + "Account name \"" + fromAccount + "\" is not found, can't remove the texture \"" + textureName + "\"!");
			}
		}

		private static function getClassName():String
		{
			return "[TextureBank]";
		}
	}
}
