package com.gridtt.framework.component.graph.bargraph
{

	import com.gridtt.framework.GridttFramework;
	import com.gridtt.framework.component.graph.bargraph.asset.Arrow;
	import com.gridtt.framework.component.graph.bargraph.asset.InfoItem;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarGraphDataAll;
	import com.gridtt.framework.component.graph.bargraph.graphvo.BarInfo;
	import com.gridtt.framework.component.graph.bargraph.view.MainBarGraph;
	import com.gridtt.framework.theme.BootstrapTheme;
	import com.gridtt.framework.ui.BaseUI;
	import com.gridtt.framework.ui.Fill;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import net.area80.utils.FileActivity;


	//f5f5f5
	public class BarGraph extends BaseUI
	{
		private const PADDING_LEFT_RIGHT:Number = 100;
		private const MARGIN_LEFT:Number = 14;
		private const PADDING_TOP_BOTTOM:Number = 100;
		private const MARGIN_TOP:Number = -20;
		private const PADDING_ARROW_LEFT_RIGHT:Number = 40;


		private var titleText:TextField = new TextField();
		private var barGraph:MainBarGraph;
		private var _height:Number = 400;
		private var _width:Number = 400;
		private var arrowLeft:Sprite = new Arrow(Arrow.LEFT);
		private var arrowRight:Sprite = new Arrow(Arrow.RIGHT);

		private var infoMc:Sprite = new Sprite();
		private var bg:Fill;

		private var barGraphInfoVO:BarGraphDataAll;


		public function BarGraph()
		{
			if (!GridttFramework.theme) {
				GridttFramework.theme = new BootstrapTheme();
			}
			bg = new Fill(GridttFramework.theme.fill_well);
			addChildAt(bg, 0);
		}


		public function initFromXMLPath(_path:String):void
		{
			FileActivity.loadXML(_path, initFromXML);
		}

		public function initFromXML($xml:XML):void
		{
			barGraphInfoVO = new BarGraphDataAll().initFromXML($xml);
			initFromVO(barGraphInfoVO);
		}

		public function initFromVO(_barGraphInfoVO:BarGraphDataAll):void
		{
			barGraphInfoVO = _barGraphInfoVO;
			barGraph = new MainBarGraph(barGraphInfoVO, _width, _height, arrowLeft, arrowRight);
			barGraph.x = PADDING_LEFT_RIGHT+MARGIN_LEFT;
			barGraph.y = PADDING_TOP_BOTTOM+MARGIN_TOP;
			arrowLeft.x = PADDING_ARROW_LEFT_RIGHT;
			addChild(arrowLeft);
			addChild(arrowRight);
			this.addChild(barGraph);

			titleText.defaultTextFormat = new TextFormat("Helvetica Neue", 20, 0x333333);
			titleText.text = barGraph.barGraphInfoVO.config.title;
			titleText.autoSize = TextFieldAutoSize.LEFT;
			titleText.selectable = false;
			addChild(titleText);
			titleText.y = 30;

			addInfo();
			update();
		}

		private function addInfo():void
		{
			infoMc.x = PADDING_LEFT_RIGHT+MARGIN_LEFT;
			var paddingInfo:Number = 20;
			var infos:Vector.<BarInfo> = barGraphInfoVO.config.barInfos;
			var nowX:Number = paddingInfo;
			var lastWidth:Number = 0;
			for (var i:uint = 0; i<=infos.length-1; i++) {
				var item:Sprite = new InfoItem(infos[i].color, infos[i].name);
				infoMc.addChild(item);
				item.x = nowX;
				item.y = 18+(i%2)*30;
				if (i%2==0) {
					lastWidth = item.width;
				} else {
					if (item.width>lastWidth) {
						lastWidth = item.width;
					}
					nowX = nowX+lastWidth+paddingInfo;
				}
			}
			infoMc.graphics.beginFill(0x333333);
			infoMc.graphics.drawRoundRect(0, 0, infoMc.width+paddingInfo, infoMc.height+paddingInfo, 6, 6);
			infoMc.graphics.endFill();
			addChild(infoMc);
		}

		protected override function update(event:Event = null):void
		{
			if (barGraph) {
				barGraph.width = _width-PADDING_LEFT_RIGHT*2;
				barGraph.height = _height-PADDING_TOP_BOTTOM*2;
			}

			arrowRight.x = _width-PADDING_ARROW_LEFT_RIGHT;
			arrowLeft.y = _height*.5+MARGIN_TOP;
			arrowRight.y = _height*.5+MARGIN_TOP;


			titleText.x = (_width-titleText.width)*.5;

			bg.width = _width;
			bg.height = _height;

			infoMc.y = _height-infoMc.height-15;


			if (barGraph) {
				if (barGraph.contentWidth<barGraph.width) {
					barGraph.x = (_width-barGraph.contentWidth)*.5+(MARGIN_LEFT);
					infoMc.x = barGraph.x;
				} else {
					barGraph.x = PADDING_LEFT_RIGHT+MARGIN_LEFT;
					infoMc.x = barGraph.x;
				}
			}
		}

		override public function set width($value:Number):void
		{
			_width = $value;
			invalid();
		}

		override public function set height($value:Number):void
		{
			_height = $value;
			invalid();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function get height():Number
		{
			return _height;
		}



	}
}
