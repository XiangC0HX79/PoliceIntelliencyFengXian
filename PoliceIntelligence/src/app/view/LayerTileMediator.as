package app.view
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.events.DetailsEvent;
	import com.esri.ags.events.LayerEvent;
	import com.esri.ags.events.MapEvent;
	import com.esri.ags.events.MapMouseEvent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.supportClasses.LayerInfo;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.events.MouseEvent;
	
	import mx.rpc.AsyncResponder;
	
	import app.model.AppParamProxy;
	import app.model.MapDataProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.MapDataVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LayerTileMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LayerTileMediator";
				
		public function LayerTileMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			layerTile.addEventListener(LayerEvent.LOAD,onLayerLoad);			
			layerTile.addEventListener(LayerEvent.LOAD_ERROR,onLayerLoadError);
		}
		
		protected function get layerTile():ArcGISTiledMapServiceLayer
		{
			return viewComponent as ArcGISTiledMapServiceLayer;
		}
				
		private function getLayerId(layerName:String):Number
		{
			for each(var info:LayerInfo in layerTile.layerInfos)
			{
				if(info.name == layerName)
					return info.layerId;
			}
			
			return -1;
		}
		
		private function onLayerLoadError(event:LayerEvent):void
		{
			sendNotification(Notifications.NOTIFY_APP_ALERTERROR,event.fault.faultString);
		}
		
		private function onLayerLoad(event:LayerEvent):void
		{
			sendNotification(Notifications.NOTIFY_APP_LOADINGTEXT,"系统初始化：正在读取行政区和辖区信息...");
			
			var query:Query = new Query;
			query.outSpatialReference = new SpatialReference(102100);
			query.returnGeometry = true;
			query.outFields = ["名称"];
			query.where = "1=1";
			
			var queryTask:QueryTask = new QueryTask;
			queryTask.useAMF = false;
			
			queryTask.url = layerTile.url + "/" + getLayerId("派出所辖区");
			queryTask.execute(query,new AsyncResponder(onAreaResult, onFault));
						
			queryTask.url = layerTile.url + "/" + getLayerId("行政区");
			queryTask.execute(query,new AsyncResponder(onDistrictResult, onFault));
		}
		
		private function onAreaResult(featureSet:FeatureSet, token:Object = null):void
		{
			for each(var gr:Graphic in featureSet.features)
			{
				var mapData:MapDataVO = new MapDataVO({"SSXQ":gr.attributes["名称"],"COUNT":0});
				gr.attributes = mapData;			
			}
			
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			var mapDataProxy:MapDataProxy = facade.retrieveProxy(MapDataProxy.NAME) as MapDataProxy;
			mapDataProxy.setData(featureSet.features);			
			mapDataProxy.GetMapData(appParamProxy.appParam.beginTime,appParamProxy.appParam.endTime);
			
			sendNotification(Notifications.INIT_AREA,appParamProxy.appParam.districtGeometry);
		}
		
		private function onDistrictResult(featureSet:FeatureSet, token:Object = null):void
		{
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			
			if(featureSet.features.length == 1)
			{
				var gr:Graphic = featureSet.features[0];
				
				appParamProxy.appParam.districtGeometry = gr.geometry as Polygon;				
			}
			else
			{
				appParamProxy.appParam.districtGeometry = layerTile.initialExtent.toPolygon();
			}
			
			sendNotification(Notifications.INIT_DISTRICT,appParamProxy.appParam.districtGeometry);
		}
		
		private function onFault(info:Object, token:Object = null):void
		{
			//Alert.show(info.toString(), "Query Problem");
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.INIT_CONFIG
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.INIT_CONFIG:
					var config:ConfigVO = notification.getBody() as ConfigVO;
					
					sendNotification(Notifications.NOTIFY_APP_LOADINGTEXT,"系统初始化：正在加载地图...");
					
					layerTile.url = config.mapServer;
					break;
			}
		}
	}
}