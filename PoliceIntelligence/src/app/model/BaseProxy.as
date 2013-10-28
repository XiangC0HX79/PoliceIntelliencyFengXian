package app.model
{
	import com.esri.ags.tasks.supportClasses.CalculationType;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	import mx.utils.ObjectProxy;
	
	import app.ApplicationFacade;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BaseProxy extends Proxy implements IProxy
	{
		public function BaseProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		protected function CallWebServiceMethod(operationName:String,listener:Function,...args):AsyncToken
		{							
			var url:String = "PoliceIntelligenceService.asmx?wsdl";
			IFDEF::Debug
			{				
				url = "http://localhost:2383/" + url;
			}
			
			var webService:WebService = new WebService;
			webService.loadWSDL(url);
			
			var operation:Operation = webService.getOperation(operationName) as Operation;
			operation.arguments = args;
			operation.addEventListener(FaultEvent.FAULT,onCallWebServiceMethodFault);
			operation.resultFormat = "object";
			
			var responder:CallResponder = new CallResponder;
			responder.addEventListener(ResultEvent.RESULT,listener);
			
			var token:AsyncToken = operation.send();
			token.addResponder(responder);
			token.operationName = operationName;
			
			return token;
		}
				
		private function onCallWebServiceMethodFault(event:FaultEvent):void
		{	
			if(event.token)
				sendNotification(Notifications.NOTIFY_APP_ALERTERROR,event.token.operationName + "\n" + event.fault.faultString + "\n" + event.fault.faultDetail);
			else
				sendNotification(Notifications.NOTIFY_APP_ALERTERROR,event.fault.faultString + "\n" + event.fault.faultDetail);
		}	
	}
}