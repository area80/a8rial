package net.area80.starling.texturecatch
{
	import starling.textures.Texture;

	internal class TextureCacheInfo
	{
		public var texture:Texture;
		public var textureName:String;
		private var _timestampWeak:Number = Infinity;

		private var _objectReferences:Vector.<Object> = new Vector.<Object>();
		
		public function TextureCacheInfo(){

		}

		internal function addReference(_ref:*):void
		{
			var isRefered:Boolean = false;
			for (var i:uint = 0; i<=_objectReferences.length-1; i++) {
				if (_objectReferences[i]==_ref) {
					isRefered = true;
					break;
				}
			}
			if (!isRefered) {
				_objectReferences.push(_ref);
				_timestampWeak = Infinity;
			}
		}

		internal function removeReference(_ref:*, _timestampWeak:Number):void
		{
			for (var i:uint = 0; i<=_objectReferences.length-1; i++) {
				if (_objectReferences[i]==_ref) {
					_objectReferences.splice(i, 1);
					if (_objectReferences.length==0) {
						this._timestampWeak = _timestampWeak;
					}
					break;
				}
			}
		}


		internal function get timestampWeak():Number
		{
			return _timestampWeak;
		}

		internal function dispose():void
		{
			_objectReferences = null;
			texture.dispose();
			texture = null;
		}

		internal function toString():String
		{
			if (_timestampWeak==Infinity) {
				return "-";
			}
			return ""+_timestampWeak;
		}

	}
}
