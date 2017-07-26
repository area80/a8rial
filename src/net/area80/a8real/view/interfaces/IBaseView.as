package net.area80.a8real.view.interfaces
{

	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface IBaseView
	{

		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;

		function set visible(value:Boolean):void;
		function get visible():Boolean;

		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		
		function get scale():Number;
		function set scale(value:Number):void;

		function destroy():void;

	}
}
