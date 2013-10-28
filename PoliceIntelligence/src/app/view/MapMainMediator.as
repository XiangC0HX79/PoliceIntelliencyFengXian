package app.view
{
	import com.esri.ags.Graphic;
	import com.esri.ags.events.MapMouseEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	
	import flash.utils.getQualifiedClassName;
	
	import app.model.AppParamProxy;
	import app.model.ElePoliceProxy;
	import app.model.IntelligencyProxy;
	import app.model.MapDataProxy;
	import app.model.vo.ElePoliceVO;
	import app.model.vo.IntelligencyVO;
	import app.view.components.InfoWindowElePolice;
	import app.view.components.InfoWindowIntelligency;
	import app.view.components.MapMain;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MapMainMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MapMainMediator";
		
		public function MapMainMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
			
			facade.registerMediator(new LayerTileMediator(mapMain.layerTile));
			facade.registerMediator(new LayerChartMediator(mapMain.layerChart));
			facade.registerMediator(new LayerMaskMediator(mapMain.layerMask));
			
			facade.registerMediator(new LayerElePoliceMediator(mapMain.layerElePolice));
			facade.registerMediator(new LayerIntelligencyMediator(mapMain.layerIntelligency));
			
			mapMain.addEventListener(MapMouseEvent.MAP_CLICK,onMapClick);
		}
		
		protected function get mapMain():MapMain
		{
			return viewComponent as MapMain;
		}
		
		private function onMapClick(event:MapMouseEvent):void
		{
			if(getQualifiedClassName(event.originalTarget) == "com.esri.ags.symbols::CustomSprite")
				return;
				
			var mapDataProxy:MapDataProxy = facade.retrieveProxy(MapDataProxy.NAME) as MapDataProxy;
						
			for each(var gr:Graphic in mapDataProxy.features)
			{
				if((gr.geometry as Polygon).contains(event.mapPoint))
				{
					sendNotification(Notifications.MAP_AREA_SET,gr);
					break;
				}
			}			
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.INIT_DISTRICT,
				Notifications.TOOL_QUERY,
				Notifications.TOOL_MAP,
				Notifications.MAP_AREA_SET,
				Notifications.MAP_ELEPOLICE_CLICK,
				Notifications.MAP_INTELLIGENCY_CLICK,
				Notifications.MAP_INTELLIGENCY_LOCATE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.INIT_DISTRICT:
					var geometry:Geometry = notification.getBody() as Geometry;
					mapMain.zoomTo(geometry);
					break;
				
				case Notifications.TOOL_QUERY:
				case Notifications.TOOL_MAP:
					mapMain.infoWindow.hide();
					
					var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
					mapMain.zoomTo(appParamProxy.appParam.districtGeometry);
					break;
				
				case Notifications.MAP_AREA_SET:
					var gr:Graphic = notification.getBody() as Graphic;
					mapMain.zoomTo(gr.geometry);
					break;
				
				case Notifications.MAP_ELEPOLICE_CLICK:
					showElePoliceInfo(notification.getBody() as Graphic);
					break;
				
				case Notifications.MAP_INTELLIGENCY_CLICK:
					showIntelligencyInfo(notification.getBody() as Graphic);
					break;
				
				case Notifications.MAP_INTELLIGENCY_LOCATE:
					var inte:IntelligencyVO = notification.getBody() as IntelligencyVO;
					mapMain.zoomTo(new Extent(inte.mapPoint.x - 250,inte.mapPoint.y - 250,inte.mapPoint.x + 250,inte.mapPoint.y + 250));
					break;
			}
		}
		
		private function showElePoliceInfo(gr:Graphic):void
		{
			var infoWindow:InfoWindowElePolice = facade.retrieveMediator(InfoWindowElePoliceMediator.NAME).getViewComponent() as InfoWindowElePolice;
			infoWindow.elePolice = gr.attributes as ElePoliceVO;
			
			mapMain.infoContainer.removeAllElements();
			mapMain.infoContainer.addElement(infoWindow);
			
			mapMain.infoWindow.label = infoWindow.elePolice.name;
			mapMain.infoWindow.show(gr.geometry as MapPoint);
		}
		
		private function showIntelligencyInfo(gr:Graphic):void
		{
			var infoWindow:InfoWindowIntelligency = facade.retrieveMediator(InfoWindowIntelligencyMediator.NAME).getViewComponent() as InfoWindowIntelligency;
			infoWindow.intelligency = gr.attributes as IntelligencyVO;
			
			mapMain.infoContainer.removeAllElements();
			mapMain.infoContainer.addElement(infoWindow);
			
			mapMain.infoWindow.label = infoWindow.intelligency.jqdh;
			mapMain.infoWindow.show(gr.geometry as MapPoint);
		}
	}
}