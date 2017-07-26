package com.gridtt.framework.layout
{

	public class Row extends Base
	{
		private var _columns:Vector.<Column> = new Vector.<Column>;

		public function Row()
		{
			super();
			if (LayoutSettings.SHOW_DEBUG_LINE) {
				createDebugLine(LayoutSettings.DEBUG_LINE_ROW_COLOR);
			}
		}

		public function totalSpan():int
		{
			var span:int = 0;
			for (var i:int = 0; i < _columns.length; i++) {
				span += _columns[i].totalSpan;
			}
			return span;
		}

		public function makeColumn(span:int):Column
		{
			var col:Column = new Column(span);
			col.setLayout(_layout);
			_columns.push(col);
			addChild(col);
			_layout.change = true;
			return col;
		}


		public function removeColumnAt(index:int):void
		{
			var column:Column = getColumnAt(index);
			if (column) {
				column.setLayout(null);
				removeChild(column);
				_columns.splice(index, 1);
				_layout.change = true;
			}
		}

		public function removeColumn(column:Column):void
		{
			for (var i:int = 0; i < _columns.length; i++) {
				if (_columns[i] == column) {
					removeColumnAt(i);
				}
			}
		}

		public function getColumnAt(index:int):Column
		{
			return (_columns) ? _columns[index] : null;
		}

		public function get numColumn():int
		{
			return (_columns) ? _columns.length : 0;
		}

		public override function get height():Number
		{
			if (heightIsFixed) {
				return _fixedHeight;
			}

			var withoutView:Number = 0;
			if (_content) {
				withoutView = _content.height;
			}

			if (_columns) {
				var value:Number = 0;
				for (var i:int = 0; i < _columns.length; i++) {
					value = Math.max(value, _columns[i].height);
				}
				return Math.max(withoutView, value);

			} else {
				return withoutView;
			}

		}

		internal override function tryResizeToHeight(value:Number = -1):void
		{
			var minHeight:Number = value;
			if (heightIsFixed)
				minHeight = _fixedHeight;
			if (_content)
				minHeight = Math.max(_content.height, minHeight);

			super.tryResizeToHeight(minHeight);

			if (_columns) {
				var maxHeight:Number = minHeight;
				var i:int = 0;
				if (!heightIsFixed) {
					for (i = 0; i < _columns.length; i++) {
						maxHeight = Math.max(maxHeight, _columns[i].height);
					}
				}

				for (i = 0; i < _columns.length; i++) {
					_columns[i].tryResizeToHeight(maxHeight);
					if (i == 0) {
						_columns[i].x = 0;
					} else {
						_columns[i].x = _columns[i - 1].x + _columns[i - 1].width;
					}
				}

			}
		}

		internal override function tryResizeToWidth(value:Number):void
		{
			super.tryResizeToWidth(value);

			if (_columns) {
				var widthPerGrid:Number = value / LayoutSettings.GRID;
				for (var i:int = 0; i < _columns.length; i++) {

					_columns[i].tryResizeToWidth(_columns[i].totalSpan * widthPerGrid);
					if (i == 0) {
						_columns[i].x = 0;
					} else {
						_columns[i].x = _columns[i - 1].x + _columns[i - 1].width;
					}

				}
			}

		}
	}
}
