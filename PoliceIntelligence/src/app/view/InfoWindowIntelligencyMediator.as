package app.view
{
	import app.view.components.InfoWindowIntelligency;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class InfoWindowIntelligencyMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "InfoWindowIntelligencyMediator";
		
		public function InfoWindowIntelligencyMediator()
		{
			super(NAME, new InfoWindowIntelligency);
		}
		
		protected function get infoWindowIntelligency():InfoWindowIntelligency
		{
			return viewComponent as InfoWindowIntelligency;
		}
	}
}