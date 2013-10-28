package app.model
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.Polygon;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import spark.formatters.DateTimeFormatter;
	
	import app.model.vo.IntelligencyVO;
	import app.model.vo.MapDataVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class IntelligencyProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = "IntelligencyProxy";
		
		public function IntelligencyProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get intelligencies():Array
		{
			return data as Array;
		}
		
		public function GetIntelligencyData(beginTime:String,endTime:String,gr:Graphic):AsyncToken
		{
			var polygon:Polygon = gr.geometry as Polygon;
			var mapData:MapDataVO = gr.attributes as MapDataVO;
			
			var token:AsyncToken = CallWebServiceMethod("GetIntelligencyData",onGetIntelligencyData
				,beginTime
				,endTime
				,mapData.area);
			token.polygon = polygon;
			return token;
		}
		
		private function onGetIntelligencyData(event:ResultEvent):void
		{
			var polygon:Polygon = event.token.polygon as Polygon;
			
			setData([]);
			
			var a:Array = JSON.parse(String(event.result)) as Array;
			for each(var item:Object in a)
			{
				var inte:IntelligencyVO = new IntelligencyVO(item);
				if(!inte.mapPoint)
					inte.mapPoint = polygon.extent.center;
				intelligencies.push(inte);
			}
			
			sendNotification(Notifications.GET_INTELLIGENCY_DATA,intelligencies);
		}
		
		public function SaveIntelligencyData():AsyncToken
		{
			var a:Array = [];
			for each(var item:IntelligencyVO in intelligencies)
			{
				if(item.isEdit)
				{
					a.push(JSON.parse(item.toJson()));
				}
			}
			
			return CallWebServiceMethod("SaveIntelligencyData",onSaveIntelligencyData,JSON.stringify(a));
		}
		
		private function onSaveIntelligencyData(event:ResultEvent):void
		{
			if(event.result)
			{
				for each(var item:IntelligencyVO in intelligencies)
				{
					item.isEdit = false;
				}
				
				sendNotification(Notifications.NOTIFY_APP_ALERTINFO,"地址保存成功。");
			}
			else
			{
				sendNotification(Notifications.NOTIFY_APP_ALERTERROR,"地址保存失败。");				
			}
		}
	}
}