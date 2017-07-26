package net.area80.a8real.view.interfaces
{

	import net.area80.a8real.data.LatLng;

	public interface IPolyLine extends IBaseView
	{
		function moveTo(x:Number, y:Number):void;
		function clear():void;
		function beginToLine():void;
		function endStroke():void;
		function lineTo(x:Number, y:Number):void;
	}
}
