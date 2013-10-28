package app.view
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	
	import spark.formatters.DateTimeFormatter;
	
	import app.model.AppParamProxy;
	import app.model.ImportProxy;
	import app.model.MapDataProxy;
	import app.view.components.ToolPanel;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ToolPanelMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "";
		
		private var appParamProxy:AppParamProxy;
		private var importProxy:ImportProxy;
		
		public function ToolPanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			toolPanel.addEventListener(ToolPanel.QUERY,onQuery);
			toolPanel.addEventListener(ToolPanel.MAP,onMap);
			toolPanel.addEventListener(ToolPanel.CHART,onChart);
			
			toolPanel.addEventListener(ToolPanel.IMPORT_ROOM,onImportRoom);
			toolPanel.addEventListener(ToolPanel.IMPORT_OTHER,onImportOther);
			
			toolPanel.addEventListener(ToolPanel.EDIT,onEdit);
			
			appParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			importProxy = facade.retrieveProxy(ImportProxy.NAME) as ImportProxy;
		}
		
		protected function get toolPanel():ToolPanel
		{
			return viewComponent as ToolPanel;
		}
		
		private function onQuery(event:Event):void
		{
			var st:Date = new Date(
				toolPanel.dfStart.selectedDate.fullYear,
				toolPanel.dfStart.selectedDate.month,
				toolPanel.dfStart.selectedDate.date
					);
			st.time += toolPanel.tfStart.time;
			
			var et:Date;
			if(toolPanel.tfEnd.time == 0)
				et = new Date(
					toolPanel.dfEnd.selectedDate.fullYear,
					toolPanel.dfEnd.selectedDate.month,
					toolPanel.dfEnd.selectedDate.date + 1
				);
			else
				et = new Date(
					toolPanel.dfEnd.selectedDate.fullYear,
					toolPanel.dfEnd.selectedDate.month,
					toolPanel.dfEnd.selectedDate.date
				);
			et.time += toolPanel.tfEnd.time;
			
			if(st.time >= et.time)
				return;
			
			var df:DateTimeFormatter = new DateTimeFormatter;
			df.dateTimePattern = "yyyy-MM-dd HH:mm:ss";
			
			appParamProxy.appParam.beginTime = df.format(st);
			appParamProxy.appParam.endTime = df.format(et);
			
			var mapDataProxy:MapDataProxy = facade.retrieveProxy(MapDataProxy.NAME) as MapDataProxy;
			mapDataProxy.GetMapData(appParamProxy.appParam.beginTime,appParamProxy.appParam.endTime);
			
			sendNotification(Notifications.TOOL_QUERY);
		}
		
		private function onMap(event:Event):void
		{
			appParamProxy.appParam.viewIndex = 0;
			
			sendNotification(Notifications.TOOL_MAP);			
		}
		
		private function onChart(event:Event):void
		{
			appParamProxy.appParam.viewIndex = 1;
			
			sendNotification(Notifications.TOOL_CHART);			
		}
		
		private function onImportRoom(event:Event):void
		{			
			var fileRef:FileReference = new FileReference;
			fileRef.addEventListener(Event.SELECT,onFileSelect);	
			fileRef.addEventListener(Event.COMPLETE,onFileLoad); 			
			fileRef.addEventListener(IOErrorEvent.IO_ERROR,onFileIOError);			
			fileRef.browse();
			
			function onFileSelect(event:Event):void
			{							
				fileRef.load(); 
			}
			
			function onFileLoad(event:Event):void   
			{   		
				importProxy.importRoom(event.currentTarget.data,"0");
			}
		}
		
		private function onImportOther(event:Event):void
		{			
			var fileRef:FileReference = new FileReference;
			fileRef.addEventListener(Event.SELECT,onFileSelect);	
			fileRef.addEventListener(Event.COMPLETE,onFileLoad); 			
			fileRef.addEventListener(IOErrorEvent.IO_ERROR,onFileIOError);			
			fileRef.browse();
			
			function onFileSelect(event:Event):void
			{							
				fileRef.load(); 
			}
			
			function onFileLoad(event:Event):void   
			{   		
				importProxy.importRoom(event.currentTarget.data,"1");
			}
		}
		
		private function onFileIOError(event:IOErrorEvent):void   
		{   		
			sendNotification(Notifications.NOTIFY_APP_ALERTERROR,event.text);
		}
		
		private function onEdit(event:Event):void
		{		
			sendNotification(Notifications.TOOL_EDIT);
		}
	}
}