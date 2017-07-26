package com.gridtt.framework.ui
{

	import com.gridtt.framework.style.FontStyle;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.text.engine.FontWeight;

	/**
	 * Label
	 * @author wissarut
	 *
	 */
	public class Label extends BaseUI 
	{
		public static const RESIZE_AUTO:String = "auto";
		public static const RESIZE_AUTO_FIXWIDTH:String = "fixwidth";
		public static const RESIZE_NONE:String = "non";

		public static const BASELINE_TOP:String = "top";
		public static const BASELINE_MIDDLE:String = "middle";
		public static const BASELINE_BOTTOM:String = "bottom";

		protected var _textField:TextField;

		private var _text:String;
		private var _style:FontStyle;
		private var _width:Number = 0;
		private var _height:Number = 0;

		private var _registerationPoint:String = "left";
		private var _align:String = "left";
		private var _line:uint = 1;
		private var _truncateTail:Boolean = false;
		private var _autoShrinkMinimumFontSize:int = 1;
		private var _baseLine:String = Label.BASELINE_TOP;
		private var _resizeMode:String = Label.RESIZE_AUTO;
		private var _tfWidth:Number = 0;
		private var _tfHeight:Number = 0;
		private var _format:TextFormat = new TextFormat();
		private var padding:int;

		public function Label(text:String = "", fontStyle:FontStyle = null)
		{

			super(true, 99);

			_textField = new TextField();
			setFontStyle((fontStyle)?fontStyle:new FontStyle());
			_autoShrinkMinimumFontSize = _style.fontSize;

			interactable = false;
			_text = text;

			addChild(_textField);

			invalid();

		}

		protected function identityTextField(fontSize:int):void
		{
			_format.font = _style.embeded?_style.embedFont:fontFamily;
			_format.size = fontSize;
			//_format.color = int("0x" + (_style.color.substr(1)));
			_format.color = _style.color;
			_format.align = _align;
			_format.bold = (_style.fontWeight==FontWeight.BOLD);
			_format.italic = _style.italic;
			_format.leading = _style.leading;

			_textField.text = "";
			
			_textField.setTextFormat(_format);
			_textField.defaultTextFormat = _format;

			switch (_resizeMode) {
				case Label.RESIZE_AUTO:
					_textField.width = 1;
					_textField.height = 1;
					_textField.multiline = true;
					_textField.wordWrap = false;
					_textField.autoSize = TextFieldAutoSize.LEFT;
					break;
				case Label.RESIZE_AUTO_FIXWIDTH:
					_textField.width = _width;
					_textField.height = 1;
					_textField.multiline = true;
					_textField.wordWrap = true;
					_textField.autoSize = TextFieldAutoSize.NONE;
					break;
				case Label.RESIZE_NONE:
					_textField.width = _width;
					_textField.height = _height;
					_textField.multiline = true;
					_textField.wordWrap = true;
					_textField.autoSize = TextFieldAutoSize.NONE;
					break;
			}

		}

		protected function updateFlow():void
		{

			var htmlText:String = "";

			switch (_resizeMode) {
				case Label.RESIZE_AUTO:
					htmlText = shrinkTextAutoSize();
					break;
				case Label.RESIZE_AUTO_FIXWIDTH:
					htmlText = shrinkTextAutoSize();
					break;
				case Label.RESIZE_NONE:
					htmlText = shrinkTextFixSize();
					break;
			}

			addLineAndSetSize(htmlText);
			readjustPosition();

		}

		protected function addLineAndSetSize(htmlText:String):void
		{

			var lines:Number = _textField.numLines;
			var h:int = _textField.textHeight;
			var lm:TextLineMetrics = _textField.getLineMetrics(0);

			//heep these line for debug
			/*
			if(text.indexOf("AutoResize line=1")>-1) {
				trace("??-----------------");
				trace("text="+text);
				trace("height="+_textField.height);
				trace("line="+textField.numLines);
				trace("textHeight="+_textField.textHeight);
				trace("textWidth="+_textField.textWidth);
				trace("??-----------------");
			}*/

			_textField.multiline = true;
			_textField.htmlText = " <br/>"+htmlText+"<br/> ";

			padding = lm.height-lm.descent;

			_textField.width = (_resizeMode!=Label.RESIZE_AUTO)?_width:textField.textWidth+4;
			_textField.height = _textField.textHeight+4;

			_tfWidth = _textField.width;
			_tfHeight = (lines*lm.height)+(lm.descent*2)+4;

			_textField.y = -padding;

		}

		protected function shrinkTextFixSize():String
		{

			var currentFontSize:int = fontSize;
			var trunPos:int = 0;
			var textLength:int = _text.length;
			var htmlText:String = updateText(text, currentFontSize);

			while (currentFontSize>autoShrinkMinimumFontSize&&(textField.numLines>_line||textField.height>_height)) {
				currentFontSize--;
				htmlText = updateText(text, currentFontSize);
			}
			while ((_textField.numLines>_line||textField.height>_height)&&trunPos>-textLength) {
				trunPos--;
				htmlText = updateText(text, currentFontSize, trunPos);
			}

			return htmlText;

		}

		protected function shrinkTextAutoSize():String
		{

			var currentFontSize:int = fontSize;
			var trunPos:int = 0;
			var textLength:int = _text.length;
			var htmlText:String = updateText(text, currentFontSize);

			while (currentFontSize>autoShrinkMinimumFontSize&&textField.numLines>_line) {
				currentFontSize--;
				htmlText = updateText(text, currentFontSize);
			}
			while (_textField.numLines>_line&&trunPos>-textLength) {
				trunPos--;
				htmlText = updateText(text, currentFontSize, trunPos);
			}

			return htmlText;

		}

		protected function updateText(text:String, fontSize:int, pos:int = 0):String
		{

			identityTextField(fontSize);

			var txt:String = "";
			var subText:String = text.substr(0, text.length+pos);
			var trunString:String = (_truncateTail&&pos<0)?"...":"";

			txt = subText+trunString;
			_textField.htmlText = txt;

			//here is the trick! Fix Bug TextField
			if (_resizeMode==Label.RESIZE_AUTO_FIXWIDTH) {
				_textField.autoSize = TextFieldAutoSize.LEFT;
				_textField.width = _textField.width;
			} else if (_resizeMode==Label.RESIZE_AUTO) {
				_textField.width = _textField.width;
			}

			return txt;

		}

		protected function readjustPosition():void
		{

			//y
			if (_resizeMode==RESIZE_NONE) {
				if (_baseLine==Label.BASELINE_MIDDLE) {
					_textField.y = ((_height-_tfHeight)*.5)-padding;
				} else if (_baseLine==Label.BASELINE_BOTTOM) {
					_textField.y = _height-(_tfHeight+padding);
				} else {
					_textField.y = -padding;
				}
			} else {
				_textField.y = -padding;
			}

			//x
			switch (registerationPoint) {
				case TextFieldAutoSize.LEFT:
				case TextFieldAutoSize.NONE:
					_textField.x = 0;
					break;
				case TextFieldAutoSize.RIGHT:
					_textField.x = -_tfWidth;
					break;
				case TextFieldAutoSize.CENTER:
					_textField.x = -_tfWidth*.5;
					break;
			}

		}

		override protected function update(event:Event = null):void
		{

			updateFlow();
			super.update(event);

		}

		/*
		* Get / Set
		*/

		public function get resizeMode():String
		{

			return _resizeMode;

		}

		public function set resizeMode(value:String):void
		{

			_resizeMode = value;
			invalid();

		}

		public function get registerationPoint():String
		{

			return _registerationPoint;

		}

		public function set registerationPoint(value:String):void
		{

			_registerationPoint = value;
			invalid();

		}

		public function get baseLine():String
		{

			return _baseLine;

		}

		public function set baseLine(value:String):void
		{

			_baseLine = value;
			invalid();

		}

		public function set interactable(value:Boolean):void
		{

			_textField.mouseEnabled = mouseChildren = mouseEnabled = value;

		}

		public function get interactable():Boolean
		{

			return mouseChildren;

		}

		public function get autoShrinkMinimumFontSize():int
		{

			return _autoShrinkMinimumFontSize;

		}

		public function set autoShrinkMinimumFontSize(value:int):void
		{

			if (_autoShrinkMinimumFontSize>_style.fontSize) {
				_autoShrinkMinimumFontSize = _style.fontSize;
			}
			_autoShrinkMinimumFontSize = value;
			invalid();

		}

		public function get line():uint
		{

			return _line;

		}

		public function set line(value:uint):void
		{

			_line = value;
			invalid();

		}

		public function set fontFamily(value:String):void
		{

			_style.fontFamily = value;
			invalid();

		}

		public function get fontFamily():String
		{

			return _style.fontFamily;

		}

		public function setFontStyle(style:FontStyle):void
		{

			_style = style.clone();

			fontSize = style.fontSize; //update autoshrink
			_textField.embedFonts = _style.embeded;
			if (_style.embeded) {
				var format:TextFormat = _textField.getTextFormat();
				format.font = _style.embedFont;
				_textField.setTextFormat(format);
			}
			invalid();

		}

		public function set selectable(value:Boolean):void
		{

			_textField.selectable = value;

		}

		public function get selectable():Boolean
		{

			return _textField.selectable;

		}

		public function set fontSize(value:int):void
		{

			_style.fontSize = value;
			autoShrinkMinimumFontSize = _autoShrinkMinimumFontSize;
			invalid();

		}

		public function get leading():int
		{

			return _style.leading;

		}

		public function set leading(value:int):void
		{

			_style.leading = value;
			invalid();

		}

		public function get fontSize():int
		{

			return _style.fontSize;

		}

		public function get truncateTail():Boolean
		{

			return _truncateTail;

		}

		public function set truncateTail(value:Boolean):void
		{

			_truncateTail = value;

		}

		public function set align(value:String):void
		{

			_align = value;

		}

		public function get align():String
		{

			return _align;

		}

		public function get textField():TextField
		{

			return _textField;

		}

		public override function set width(value:Number):void
		{

			_width = value;
			invalid();

		}

		public override function set height(value:Number):void
		{

			_height = value;
			invalid();

		}

		public override function get height():Number
		{

			if (_resizeMode!=RESIZE_NONE) {
				updateIfInvalid();
				return _tfHeight;
			} else {
				return _height;
			}

		}

		public override function get width():Number
		{

			if (_resizeMode==RESIZE_AUTO) {
				updateIfInvalid();
				return _tfWidth;
			} else {
				return _width;
			}

		}

		public function set text(message:String):void
		{

			_text = message;
			invalid();

		}

		public function get text():String
		{

			return _text;

		}

	}
}
