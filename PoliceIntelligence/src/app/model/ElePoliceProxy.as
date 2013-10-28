package app.model
{
	import app.model.vo.ElePoliceVO;
	import app.model.vo.IntelligencyVO;
	
	import com.esri.ags.geometry.Geometry;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	import spark.formatters.DateTimeFormatter;
	
	public class ElePoliceProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = "ElePoliceProxy";
		
		public function ElePoliceProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get elePolices():Array
		{
			return data as Array;
		}
		
		public function GetElePoliceData(area:Geometry):AsyncToken
		{
			return CallWebServiceMethod("GetElePoliceData",onGetElePoliceData
				,JSON.stringify(area.toJSON().rings[0]));
		}
		
		private function onGetElePoliceData(event:ResultEvent):void
		{
			setData([]);
			
			var a:Array = JSON.parse(String(event.result)) as Array;
			for each(var item:Object in a)
			{
				elePolices.push(new ElePoliceVO(item));
			}
			
			sendNotification(Notifications.GET_ELEPOLICE_DATA,elePolices);
		}
	}
}