package app.view
{
	import flash.events.Event;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import app.model.AppParamProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PoliceIntelligencyMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PoliceIntelligencyMediator";
		
		public function PoliceIntelligencyMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			policeIntelligence.appParam = appParamProxy.appParam;
		}
		
		protected function get policeIntelligence():PoliceIntelligence
		{
			return viewComponent as PoliceIntelligence;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.TOOL_EDIT,
				Notifications.POPUP_CLOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case Notifications.TOOL_EDIT:
					var popupWindowEdit:IFlexDisplayObject = facade.retrieveMediator(PopupWindowEditMediator.NAME).getViewComponent() as IFlexDisplayObject;
					popupWindowEdit.x = policeIntelligence.width - popupWindowEdit.width - 10;
					popupWindowEdit.y = 50;
					PopUpManager.addPopUp(popupWindowEdit,policeIntelligence);
					break;
				
				case Notifications.POPUP_CLOSE:
					PopUpManager.removePopUp(notification.getBody() as IFlexDisplayObject);
					break;
			}
		}
	}
}