package net.area80.a8real.view.starling
{

	import flash.geom.Point;

	import net.area80.a8real.assets.Assets;
	import net.area80.a8real.controller.InteractiveController;
	import net.area80.a8real.view.interfaces.IBackgroundView;
	import net.area80.starling.TextureBank;
	import net.area80.starling.TextureUtils;

	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class StarlingBackgroundView extends Sprite implements IBackgroundView
	{

		private var textureCoordinate:Point = new Point(0, 0);
		private var change:Boolean = true;
		private var _scrollX:Number = 0;
		private var _scrollY:Number = 0;
		private var _scale:Number = 1;

		private var _responder:InteractiveController;
		private var touchesBegin:Boolean;
		private var beganPoint:Point;
		private var touchesTab:Boolean;
		private var startMultitouch:Boolean = false;
		private var _img:Image;

		public function StarlingBackgroundView()
		{

			var _texture:Texture = TextureBank.withdraw("GoogleMapBackground");
			if (!_texture) {
				_texture = TextureBank.deposit(Texture.fromBitmapData(Assets.patternBackgroundBitmapdata, false), "GoogleMapBackground");
				_texture.repeat = true;
			}
			_img = new Image(_texture);
			addChild(_img);

			//super(_texture);
		}

		public function set scale(value:Number):void
		{

			_scale = value;

		}

		public function get scale():Number
		{

			return _scale;

		}

		public function set scrollX(value:Number):void
		{

			_scrollX = value;
			change = true;

		}

		public function get scrollX():Number
		{

			return _scrollX;

		}

		public function set scrollY(value:Number):void
		{

			_scrollY = value;
			change = true;

		}

		override public function set width(value:Number):void
		{

			change = true;
			_img.width = value;

		}

		override public function set height(value:Number):void
		{

			change = true;
			_img.height = value;

		}

		public function get scrollY():Number
		{

			return _scrollY;

		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{

			if (change) {
				textureCoordinate.x = _scrollX;
				textureCoordinate.y = _scrollY;
				TextureUtils.updateRepeatTexture(_img, _img.texture, textureCoordinate);
				change = false;
			}
			super.render(support, parentAlpha);

		}

		public function destroy():void
		{

			_img.dispose();
			removeEventListener(TouchEvent.TOUCH, touchHandle);
			dispose();

		}

		public function set responder(responder:InteractiveController):void
		{

			if (responder) {
				if (!_responder) {
					_responder = responder;
					initInteractive();
				} else {
					_responder = responder;
				}

			} else {
				if (_responder) {
					deinitInteractive();
					_responder = null;
				}
			}

		}

		public function get responder():InteractiveController
		{

			return _responder;

		}

		protected function initInteractive():void
		{

			addEventListener(TouchEvent.TOUCH, touchHandle);

		}

		private function processMultitouch(t1:Touch, t2:Touch, mode:String = ""):void
		{

			startMultitouch = true;
			touchesBegin = true;
			touchesTab = false;
			var p1:Point = t1.getLocation(this);
			var p2:Point = t2.getLocation(this);
			var c:Point = new Point();
			c.x = (p1.x + p2.x) * .5
			c.y = (p1.y + p2.y) * .5
			var dist:Number = Point.distance(p1, p2);
			if (mode == "begin") {
				responder.multiTouchStart(c.x, c.y, dist);
			} else if (mode == "move") {
				responder.multiTouchMove(c.x, c.y, dist);
			}

		}

		private function touchHandle(withEvent:TouchEvent):void
		{

			var touchPoint:Point;
			var touch:Touch;

			touch = withEvent.getTouch(this);
			if (!touch)
				return;
			touchPoint = touch.getLocation(this);

			if (withEvent.interactsWith(this)) {
				if (touchesBegin && withEvent.touches.length > 1 && !startMultitouch) {
					if (touchPoint.x > 0 && touchPoint.x < width && touchPoint.y > 0 && touchPoint.y < height) {
						startMultitouch = true;
						processMultitouch(withEvent.touches[0], withEvent.touches[1], "begin");
					}
				}

				if (touch.phase == TouchPhase.BEGAN && !touchesBegin) {

					if (touchPoint.x > 0 && touchPoint.x < width && touchPoint.y > 0 && touchPoint.y < height) {
						if (withEvent.touches.length > 1) {
							startMultitouch = true;
							processMultitouch(withEvent.touches[0], withEvent.touches[1], "begin");
						} else {
							responder.singleTouchSart(touchPoint.x, touchPoint.y);
						}
						touchesBegin = true;
						touchesTab = true;
						beganPoint = touchPoint.clone();
					}

				} else if (touchesBegin && touch.phase == TouchPhase.MOVED) {

					if (touchesTab && Math.abs(Point.distance(beganPoint, touchPoint)) > 12) {
						touchesTab = false;
					}

					if (startMultitouch) {
						if (withEvent.touches.length > 1) {
							processMultitouch(withEvent.touches[0], withEvent.touches[1], "move");
						} else {
							startMultitouch = false;
							responder.multitouchEnd();
						}
					} else {
						//touch move
						responder.singleTouchDrag(touchPoint.x, touchPoint.y);
					}

				}
			} else {
				if (touchesBegin && touch.phase == TouchPhase.ENDED) {

					if (touchesTab) {
						responder.click(touchPoint.x, touchPoint.y);
					}

					if (startMultitouch) {
						startMultitouch = false;
						responder.multitouchEnd();
					} else {
						responder.singleTouchEnd();
					}

					touchesBegin = false;

				}

			}

		}

		protected function deinitInteractive():void
		{

			removeEventListener(TouchEvent.TOUCH, touchHandle);

		}
	}
}
