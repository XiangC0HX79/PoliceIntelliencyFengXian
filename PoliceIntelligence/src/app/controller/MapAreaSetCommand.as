package app.controller
{
	import app.model.*;
	import app.model.vo.MapDataVO;
	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Polygon;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class MapAreaSetCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{							
			var gr:Graphic = note.getBody() as Graphic;
			
			var polygon:Polygon = gr.geometry as Polygon;
			var mapData:MapDataVO = gr.attributes as MapDataVO;
			
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;			
			var intelligencyProxy:IntelligencyProxy  = facade.retrieveProxy(IntelligencyProxy.NAME) as IntelligencyProxy;
			var elePoliceProxy:ElePoliceProxy  = facade.retrieveProxy(ElePoliceProxy.NAME) as ElePoliceProxy;
			
			appParamProxy.appParam.viewIndex = 0;
			
			intelligencyProxy.GetIntelligencyData(appParamProxy.appParam.beginTime,appParamProxy.appParam.endTime,gr);
			elePoliceProxy.GetElePoliceData(polygon);
		}
	}
}