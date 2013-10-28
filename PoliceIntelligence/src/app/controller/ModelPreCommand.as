package app.controller
{	
	import app.model.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{						
			facade.registerProxy(new AppParamProxy);
			facade.registerProxy(new ConfigProxy);
			facade.registerProxy(new MapDataProxy);
			facade.registerProxy(new IntelligencyProxy);
			facade.registerProxy(new ElePoliceProxy);
			facade.registerProxy(new ImportProxy);
		}
	}
}