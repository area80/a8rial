package com.gridtt.framework.component.alert
{

	import com.gridtt.framework.GridttFramework;
	import com.gridtt.framework.style.ButtonStyle;
	import com.gridtt.framework.style.FontStyle;

	public class AlertOptions
	{
		public var htmlMessage:String = "";
		public var comfirmCallBack:Function;
		public var cancelCallBack:Function;
		public var isConfirmation:Boolean = false;
		public var confirmButtonMessage:String = "OK";
		public var cancelButtonMessage:String = "Cancel";
		public var styleButtonOk:ButtonStyle;
		public var styleButtonCancel:ButtonStyle;
		public var fontStyle:FontStyle;

		public function AlertOptions(htmlMessage:String)
		{
			this.htmlMessage = htmlMessage;
			this.fontStyle = GridttFramework.theme.font_h5;
		}
	}
}
