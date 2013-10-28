package app.view
{
	import com.esri.ags.Graphic;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.model.MapDataProxy;
	import app.model.vo.IntelligencyVO;
	import app.model.vo.MapDataVO;
	import app.view.components.MapChart;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MapChartMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MapChartMediator";
		
		public function MapChartMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			mapChart.addEventListener(MapChart.ITME_CLICK,onItemClick);
		}
		
		protected function get mapChart():MapChart
		{
			return viewComponent as MapChart;
		}
		
		private function onItemClick(event:Event):void
		{
			var mapDataProxy:MapDataProxy = facade.retrieveProxy(MapDataProxy.NAME) as MapDataProxy;
			
			if(mapChart.mapData)
			{				
				for each(var gr:Graphic in mapDataProxy.features)
				{
					if((gr.attributes as MapDataVO).area == mapChart.mapData.area)
					{
						sendNotification(Notifications.MAP_AREA_SET,gr);
						break;
					}
				}			
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.GET_MAP_DATA
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.GET_MAP_DATA:
					initMapData(notification.getBody() as Array);
					break;
			}
		}
		
		private function initMapData(features:Array):void
		{			
			var source:Array = [];
			for each(var gr:Graphic in features)
			{
				source.push(gr.attributes);
			}
			
			mapChart.columnChart.dataProvider = new ArrayCollection(source);
		}
	}
}