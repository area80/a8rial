package net.area80.a8real.view.interfaces
{
	
	import net.area80.a8real.controller.InteractiveController;

	public interface IBackgroundView extends IBaseView
	{
		function set scrollX(value:Number):void;
		function get scrollX():Number;
		function set scrollY(value:Number):void;
		function get scrollY():Number;
		
		
		function set responder(responder:InteractiveController):void;
		
		function get responder():InteractiveController;
	}
}
