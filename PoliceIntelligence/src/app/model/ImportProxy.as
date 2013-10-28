package app.model
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import app.model.vo.ResultVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ImportProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ImportProxy";
		
		public function ImportProxy()
		{
			super(NAME, new ResultVO);
		}
		
		public function get r():ResultVO
		{
			return data as ResultVO;
		}
		
		public function importRoom(fileData:ByteArray,fileType:String):void
		{
			sendNotification(Notifications.NOTIFY_APP_LOADINGSHOW,"正在上传文件...");
			
			var url:String = "ImportIntelligence.aspx";
			url += "?type=" + fileType;
			
			IFDEF::Debug
			{				
				url = "http://localhost:2383/" + url;
			}
			
			var request:URLRequest = new URLRequest(encodeURI(url));	
			request.method = URLRequestMethod.POST;
			request.contentType = "application/octet-stream";		
			request.data = fileData;	
			
			var urlLoader:URLLoader = new URLLoader();	
			urlLoader.addEventListener(Event.COMPLETE, onImport);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlLoader.load(request);
		}		
		
		private function onImport(event:Event):void
		{	
			sendNotification(Notifications.NOTIFY_APP_LOADINGHIDE);
			
			var r:ResultVO = new ResultVO(JSON.parse(event.target.data));
			if(r.msgCode == 0)
				sendNotification(Notifications.NOTIFY_APP_ALERTINFO,"导入数据成功。");
			else
				sendNotification(Notifications.NOTIFY_APP_ALERTERROR,r.msgInfo);
		}
		
		private function onIOError(event:IOErrorEvent):void
		{	
			sendNotification(Notifications.NOTIFY_APP_LOADINGHIDE);
			
			sendNotification(Notifications.NOTIFY_APP_ALERTERROR,event.text);
		}
	}
}