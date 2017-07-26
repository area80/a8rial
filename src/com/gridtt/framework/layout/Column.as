package com.gridtt.framework.layout
{


	public class Column extends Base
	{
		private var _span:int = 1;

		public var before:int = 0;
		public var after:int = 0;

		protected var _widthPerSpan:Number = 0;
		protected var _rows:Vector.<Row>;

		public function Column(span:int = 1)
		{
			this.span = span;
			super();
			if (LayoutSettings.SHOW_DEBUG_LINE) {
				createDebugLine(LayoutSettings.DEBUG_LINE_COL_COLOR);
			}
		}

		public function makeRow():Row
		{
			if (!_rows)
				_rows = new Vector.<Row>;
			var arow:Row = new Row();
			arow.setLayout(_layout);
			_rows.push(arow);
			addChild(arow);
			_layout.change = true;
			return arow;
		}

		public function removeRowAt(index:int):void
		{
			var row:Row = getRowAt(index);
			if (row) {
				row.setLayout(null);
				removeChild(row);
				_rows.splice(index, 1);
				_layout.change = true;
			}
		}

		public function removeRow(row:Row):void
		{
			for (var i:int = 0; i < _rows.length; i++) {
				if (_rows[i] == row) {
					removeRowAt(i);
				}
			}
		}

		public function getRowAt(index:int):Row
		{
			return (_rows) ? _rows[index] : null;
		}

		public function get numRows():int
		{
			return (_rows) ? _rows.length : 0;
		}

		public function get totalSpan():int
		{
			return before + after + _span;
		}

		public function get span():int
		{
			return _span;
		}

		public function set span(value:int):void
		{
			_span = value;
			if (_layout)
				_layout.change = true;
		}

		public override function get width():Number
		{
			return _widthPerSpan * totalSpan;
		}

		public override function get height():Number
		{
			if (_fixedHeight >= 0)
				return _fixedHeight;

			var withoutView:Number = 0;
			if (_content) {
				withoutView = Math.max(_content.height, withoutView);
			}
			if (_rows) {
				var value:Number = 0;
				for (var i:int = 0; i < _rows.length; i++) {
					value += _rows[i].height;
				}
				return Math.max(withoutView, value);

			} else {
				return withoutView;
			}
		}

		internal override function tryResizeToHeight(value:Number = -1):void
		{
			var minHeight:Number = value;
			if (heightIsFixed) {
				minHeight = _fixedHeight;
			} else {
				if (_content) {
					minHeight = Math.max(_content.height, minHeight);
				}
			}

			super.tryResizeToHeight(minHeight);

			if (_rows) {
				for (var i:int = 0; i < _rows.length; i++) {
					_rows[i].tryResizeToHeight(minHeight);
					if (i == 0) {
						_rows[i].y = 0;
					} else {
						_rows[i].y = _rows[i - 1].y + _rows[i - 1].height;
					}
				}
			}
		}

		internal override function tryResizeToWidth(value:Number):void
		{
			_widthPerSpan = value / totalSpan;
			if (_content) {
				_content.width = _span * _widthPerSpan;
				_content.x = before * _widthPerSpan;
			}
			if (_debugLine) {
				_debugLine.width = value;
			}
			if (_rows) {
				for (var i:int = 0; i < _rows.length; i++) {
					_rows[i].x = before * _widthPerSpan;
					_rows[i].tryResizeToWidth(span * _widthPerSpan);
				}
			}
		}



	}
}
