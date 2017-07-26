package net.area80.a8real.view.interfaces
{

	public interface ITileView extends IBaseView
	{
		function get isLoaded():Boolean;
		function get tx():int;
		function get ty():int;
		function get realx():int;
		function get realy():int;
	}
}
