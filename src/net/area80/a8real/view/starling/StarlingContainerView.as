package net.area80.a8real.view.starling
{

	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import net.area80.a8real.controller.InteractiveController;
	import net.area80.a8real.view.interfaces.*;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class StarlingContainerView extends Sprite implements IContainerView
	{
		private var _frame:Rectangle;
		private var _responder:InteractiveController;

		private var renderRect:Rectangle = new Rectangle();
		private var _cacheMatrix:Matrix = new Matrix();
		private var _masking:Boolean = false;

		public function StarlingContainerView()
		{

			super();

		}

		public function get touchEnabled():Boolean
		{

			return touchable;

		}

		public function set touchEnabled(value:Boolean):void
		{

			touchable = value;

		}

		public function addSubCanvas(subcanvas:IBaseView):void
		{

			addChild(DisplayObject(subcanvas));

		}

		public function addAnyChild(display:*):void
		{

			addChild(display);

		}

		public function set masking(value:Boolean):void
		{

			_masking = value;

		}

		public function get masking():Boolean
		{

			return _masking;

		}

		public function addSubCanvasAt(subcanvas:IBaseView, position:int):void
		{

			if (!contains(DisplayObject(subcanvas))) {
				addChildAt(DisplayObject(subcanvas), position);
			}

		}

		public function removeSubCanvas(subcanvas:IBaseView):void
		{

			if (contains(DisplayObject(subcanvas))) {
				removeChild(DisplayObject(subcanvas), true);
			}

		}

		public function removeAnyChild(display:*):void
		{

			if (contains(display)) {
				removeChild(display, true);
			}

		}

		public function removeSubCanvasAt(position:int):void
		{

			removeChildAt(position, true);

		}

		public function get numSubCanvases():int
		{

			return numChildren;

		}

		public function set scale(value:Number):void
		{

			scaleX = value;
			scaleY = value;

		}

		public function get scale():Number
		{

			return scaleX

		}

		public function set frame(rect:Rectangle):void
		{

			_frame = rect;

		}

		public function get frame():Rectangle
		{

			return _frame;

		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{

			if (frame && _masking) {
				_cacheMatrix = support.modelViewMatrix.clone();
				renderRect.x = frame.x + _cacheMatrix.tx;
				renderRect.y = frame.y + _cacheMatrix.ty;
				renderRect.width = _cacheMatrix.a * frame.width;
				renderRect.height = _cacheMatrix.d * frame.height;
				support.finishQuadBatch();
				Starling.context.setScissorRectangle(renderRect);
				super.render(support, alpha);
				support.finishQuadBatch();
				Starling.context.setScissorRectangle(null);
			} else {
				super.render(support, parentAlpha);
			}

		}

		public function destroy():void
		{

			dispose();

		}

	}
}
