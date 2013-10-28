package app.view
{
	import app.view.components.InfoWindowElePolice;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class InfoWindowElePoliceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "InfoWindowElePolicMediator";
		
		public function InfoWindowElePoliceMediator()
		{
			super(NAME, new InfoWindowElePolice);
		}
		
		protected function get infoWindowElePolice():InfoWindowElePolice
		{
			return viewComponent as InfoWindowElePolice;
		}
	}
}