package com.gridtt.framework.component.graph.bargraph.graphvo
{

	public class BarGraphDataAll
	{
		public static const STACK:String = 'stack';
		public static const CLSTER:String = 'cluster';

		public var config:BarGraphConfig = new BarGraphConfig();
		public var datas:Vector.<BarGraphData> = new Vector.<BarGraphData>();

		public function BarGraphDataAll():void
		{
		}

		public function initFromXML($xml:XML):BarGraphDataAll
		{
			//// config /////
			var configXML:XMLList = $xml.config;
			config.title = configXML.@title;
			config.type = configXML.@type;
			config.unitX = configXML.@unitX;
			config.unitY = configXML.@unitY;
			config.maxValue = configXML.@maxValue;
			config.minValue = configXML.@minValue;
			config.majorDiff = configXML.@majorDiff;
			config.minorDiff = configXML.@minorDiff;
			config.lineColor = configXML.@lineColor;
			config.bgColor1 = configXML.@bgColor1;
			config.bgColor2 = configXML.@bgColor2;
			config.barWidth = configXML.@barWidth;
			config.paddingGroup = configXML.@paddingGroup;
			config.paddingBar = configXML.@paddingBar;
			var barConfigXML:XMLList = configXML.barconfig.bar;
			for (var i:uint = 0; i<=barConfigXML.length()-1; i++) {
				var barInfo:BarInfo = new BarInfo(barConfigXML[i].@name, barConfigXML[i].@color);
				config.barInfos.push(barInfo);
			}


			var dataXML:XMLList = $xml.content.data;
			for (i = 0; i<=dataXML.length()-1; i++) {
				var data:BarGraphData = new BarGraphData();
				data.name = dataXML[i].@name;
				data.subData = new Vector.<BarGraphSubData>();
				data.i = i;

				var subDataXML:XMLList = dataXML[i].subData;
				trace("  ++++++++++++++++ ", i, "  +++++++++++++++");
				for (var j:uint = 0; j<=subDataXML.length()-1; j++) {
					trace("subDataXML[j]:", j, subDataXML[j]);
					var subData:BarGraphSubData = new BarGraphSubData(barConfigXML[j].@name, barConfigXML[j].@color, subDataXML[j]);
					data.subData.push(subData);
				}
				datas.push(data);
			}
			return this;
		}
	}
}

