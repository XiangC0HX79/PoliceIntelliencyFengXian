package app.controller
{		
	import spark.components.Application;
	
	import app.view.AppAlertMediator;
	import app.view.AppLoadingBarMediator;
	import app.view.InfoWindowElePoliceMediator;
	import app.view.InfoWindowIntelligencyMediator;
	import app.view.MapChartMediator;
	import app.view.MapMainMediator;
	import app.view.PoliceIntelligencyMediator;
	import app.view.PopupWindowEditMediator;
	import app.view.ToolPanelMediator;
	
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:PoliceIntelligence = note.getBody() as PoliceIntelligence;
			
			facade.registerMediator(new PoliceIntelligencyMediator(application));
			
			facade.registerMediator(new AppAlertMediator);
			facade.registerMediator(new AppLoadingBarMediator(application.appLoadingBar));
			
			facade.registerMediator(new MapMainMediator(application.mapMain));
			facade.registerMediator(new MapChartMediator(application.mapChart));
			facade.registerMediator(new ToolPanelMediator(application.toolPanel));
			
			facade.registerMediator(new InfoWindowElePoliceMediator);
			facade.registerMediator(new InfoWindowIntelligencyMediator);
			
			facade.registerMediator(new PopupWindowEditMediator);
		}
	}
}