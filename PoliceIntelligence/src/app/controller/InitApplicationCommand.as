package app.controller
{
	import app.model.ConfigProxy;
	import app.view.*;
	import app.view.components.*;
		
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitApplicationCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{					
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			configProxy.InitConfig();
		}
	}
}