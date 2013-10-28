package app.view
{
	import app.view.components.AppLoadingBar;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AppLoadingBarMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "AppLoadingBarMediator";
		
		public static const INIT_CONFIG:String 			= "00000001";
		public static const INIT_DISTRICT:String 		= "00000010";
		public static const INIT_AREA:String 			= "00000100";
		
		private static const APP_INIT_COMPLETE:Number = 
			parseInt(INIT_CONFIG,2) |
			parseInt(INIT_DISTRICT,2) |
			parseInt(INIT_AREA,2);
				
		private var _loadingCount:Number = 0;
		
		private var _initProgress:Number = 0;
		
		public function AppLoadingBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get appLoadingBar():AppLoadingBar
		{
			return viewComponent as AppLoadingBar;
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.INIT_CONFIG,
				Notifications.INIT_DISTRICT,
				Notifications.INIT_AREA,
				
				Notifications.NOTIFY_APP_LOADINGTEXT,
				Notifications.NOTIFY_APP_LOADINGHIDE,
				Notifications.NOTIFY_APP_LOADINGSHOW
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.INIT_CONFIG:
					validAppInitComplete(INIT_CONFIG);
					break;
				case Notifications.INIT_DISTRICT:
					validAppInitComplete(INIT_DISTRICT);
					break;
				case Notifications.INIT_AREA:
					validAppInitComplete(INIT_AREA);
					break;
				
				case Notifications.NOTIFY_APP_LOADINGTEXT:
					if(notification.getBody() != null)
						appLoadingBar.loadingInfo = notification.getBody() as String;	
					break;
				
				case Notifications.NOTIFY_APP_LOADINGHIDE:
					if(notification.getBody() != null)
						appLoadingBar.loadingInfo = notification.getBody() as String;	
										
					this._loadingCount--;
					
					if(this._loadingCount == 0)
					{
						appLoadingBar.visible = false;
					}
					break;
				
				case Notifications.NOTIFY_APP_LOADINGSHOW:
					if(notification.getBody() != null)
						appLoadingBar.loadingInfo = notification.getBody() as String;	
										
					this._loadingCount++;
					
					if(this._loadingCount == 1)
					{					
						appLoadingBar.visible = true;
					}
					break;
			}
		}
		
		private function validAppInitComplete(p:String):void
		{
			_initProgress |= parseInt(p,2);
			
			if(_initProgress == APP_INIT_COMPLETE)
			{
				appLoadingBar.visible = false;
				
				sendNotification(Notifications.INIT_APP_COMPLETE);
			}						
		}
	}
}