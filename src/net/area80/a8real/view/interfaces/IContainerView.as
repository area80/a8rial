package net.area80.a8real.view.interfaces
{

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	import net.area80.a8real.controller.InteractiveController;
	import net.area80.a8real.enum.GoogleMapType;

	public interface IContainerView extends IBaseView
	{
		function set frame(rect:Rectangle):void;
		function get frame():Rectangle;
		
		function set touchEnabled(value:Boolean):void;
		function get touchEnabled():Boolean;

		function set masking(value:Boolean):void;
		function get masking():Boolean;

		function addSubCanvas(subcanvas:IBaseView):void;
		function addAnyChild(display:*):void;

		function addSubCanvasAt(subcanvas:IBaseView, position:int):void;

		function removeSubCanvas(subcanvas:IBaseView):void;
		function removeAnyChild(display:*):void;

		function removeSubCanvasAt(position:int):void;

		function get numSubCanvases():int;

	}
}
