package com.gridtt.framework.ui
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class ContentGrid extends BaseUI
	{
		public static const PAGESCROLL_SIDE:int = 1;
		public static const PAGESCROLL_UPDOWN:int = 2;
		/**
		 * This will fill content in each page left to right, then create new row
		 */
		public static const ARRANGEMENT_LR:int = 1;
		/**
		 *  This will fill content in each page top to bottom first, them create new column
		 */
		public static const ARRANGEMENT_TB:int = 2;
		
		private var _pagescroll:int;
		private var _arrangement:int;
		
		private var _contents:Vector.<Content>;
		
		private var _row:int;
		private var _col:int;
		private var _cellHeight:int;
		private var _cellWidth:int;
		
		public function ContentGrid(row:int, col:int, cellWidth:int, cellHeight:int, pagescroll:int, arrangement:int)
		{
			_pagescroll = pagescroll;
			_arrangement = arrangement;
			_row = row;
			_col = col; 
			_cellHeight = cellHeight;
			_cellWidth = cellWidth;
			
			super();
		}
		public function addContent (content:Sprite, contentWidth:Number=0,contentHeight:Number=0):void {
			if(!_contents) _contents = new Vector.<Content>;
			var c:Content = new Content(content,contentWidth,contentHeight);
			addChild(content);
			_contents.push(c);
			invalid();
		}
		public function get pageWidth():int {
			return _col*_cellWidth;
		}
		public function get pageHeight():int {
			return _row*_cellHeight;
		}
		public function get totalPage ():int {
			return Math.ceil(_contents.length/(_row*_col)); 
		}
		override public function get width():Number {
			return ((_pagescroll==PAGESCROLL_SIDE) ? pageWidth*totalPage : pageWidth);
		}
		override public function get height():Number {
			return ((_pagescroll==PAGESCROLL_UPDOWN) ? pageHeight*totalPage : pageHeight);
		}
		private function arrange ():void {
			for(var i:int=0; i<_contents.length;i++) {
				//position adjustment
				var ax:int = Math.floor((_cellWidth-_contents[i].width)*.5);
				var ay:int = Math.floor((_cellHeight-_contents[i].height)*.5);
				var cpage:int = Math.floor(i/(_row*_col));
				//pitch by page
				var px:int = (_pagescroll==PAGESCROLL_SIDE) ? pageWidth*(cpage) : 0;
				var py:int = (_pagescroll==PAGESCROLL_UPDOWN) ? pageHeight*(cpage) : 0;
				 
				var idinpage:int = i%(_row*_col); 
				
				_contents[i].view.x = px + ax +( ((_arrangement==ARRANGEMENT_LR) ? idinpage%_col : Math.floor(idinpage/_row)) * _cellWidth);
				_contents[i].view.y = py + ay + (((_arrangement==ARRANGEMENT_LR) ? Math.floor(idinpage/_col) : idinpage%_row) * _cellHeight);
			
			}
		}
		
		override protected function update(event:Event=null):void
		{
			arrange();
			super.update(event);
		} 
		
	}
}
import flash.display.Sprite;

class Content {
	public var view:Sprite;
	public var width:int;
	public var height:int;
	public function Content(content:Sprite, width:int=0,height:int=0):void {
		this.view = content;
		this.width = (width>0) ? width : content.width;
		this.height = (height>0) ? height : content.height;
	}
}