package app.model
{
	import app.model.vo.MapDataVO;
	
	import com.esri.ags.Graphic;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class MapDataProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = "MapDataProxy";
		
		public function MapDataProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get features():Array
		{
			return data as Array;
		}
		
		public function GetMapData(beginTime:String,endTime:String):AsyncToken
		{			
			return CallWebServiceMethod("GetMapData",onGetMapData,beginTime,endTime);
		}
		
		private function onGetMapData(event:ResultEvent):void
		{
			var c:Array = JSON.parse(String(event.result)) as Array;
			for each(var gr:Graphic in features)
			{
				var mapData:MapDataVO = gr.attributes as MapDataVO;
				
				for each(var item:Object in c)
				{
					if(mapData.area == item["SSXQ"])
					{
						mapData.count = item["COUNT"];
						break;
					}
				}
			}
			
			sendNotification(Notifications.GET_MAP_DATA,features);
		}
	}
}