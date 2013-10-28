package app.model
{
	import app.model.vo.ConfigVO;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ConfigProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = "ConfigProxy";
		
		public function ConfigProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get config():ConfigVO
		{
			return data as  ConfigVO;			
		}
		
		public function InitConfig():AsyncToken
		{			
			sendNotification(Notifications.NOTIFY_APP_LOADINGTEXT,"系统初始化：正在读取系统配置...");
			
			return CallWebServiceMethod("InitConfig",onInitConfig);
		}
		
		private function onInitConfig(event:ResultEvent):void
		{
			setData(new ConfigVO(JSON.parse(String(event.result))));
			
			sendNotification(Notifications.INIT_CONFIG,config);
		}
	}
}