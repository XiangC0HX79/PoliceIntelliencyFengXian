package app.view
{
	import com.esri.ags.Graphic;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	
	import app.model.IntelligencyProxy;
	import app.model.vo.IntelligencyVO;
	import app.view.components.PopupWindowEdit;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PopupWindowEditMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PopupWindowEditMediator";
		
		public function PopupWindowEditMediator()
		{
			super(NAME, new PopupWindowEdit);
			
			popupWindowEdit.addEventListener(CloseEvent.CLOSE,onClose);
			
			popupWindowEdit.addEventListener(PopupWindowEdit.FLASH,onFlash);			
			popupWindowEdit.addEventListener(PopupWindowEdit.LOCATE,onLocate);
			
			popupWindowEdit.addEventListener(PopupWindowEdit.SAVE,onSave);
		}
		
		protected function get popupWindowEdit():PopupWindowEdit
		{
			return viewComponent as PopupWindowEdit;
		}
		
		private function onClose(event:CloseEvent):void
		{
			sendNotification(Notifications.POPUP_CLOSE,popupWindowEdit);
		}
		
		private function onFlash(event:Event):void
		{
			sendNotification(Notifications.MAP_INTELLIGENCY_FLASH,popupWindowEdit.selectedItem);
		}
		
		private function onLocate(event:Event):void
		{
			sendNotification(Notifications.MAP_INTELLIGENCY_LOCATE,popupWindowEdit.selectedItem);
		}
		
		private function onSave(event:Event):void
		{
			var intelligencyProxy:IntelligencyProxy = facade.retrieveProxy(IntelligencyProxy.NAME) as IntelligencyProxy;
			intelligencyProxy.SaveIntelligencyData();
		}
				
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.GET_INTELLIGENCY_DATA,
				Notifications.MAP_INTELLIGENCY_CLICK
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case Notifications.GET_INTELLIGENCY_DATA:
					popupWindowEdit.dataProvider = new ArrayCollection(notification.getBody() as Array);
					break;
				
				case Notifications.MAP_INTELLIGENCY_CLICK:
					if(popupWindowEdit.isPopUp)
					{
						var inte:IntelligencyVO = (notification.getBody() as Graphic).attributes as IntelligencyVO;
						var rowId:Number = popupWindowEdit.dataProvider.getItemIndex(inte);
						popupWindowEdit.dataGrid.selectedIndex = rowId;
						popupWindowEdit.dataGrid.ensureCellIsVisible(rowId);
					}
					break;
			}
		}
	}
}