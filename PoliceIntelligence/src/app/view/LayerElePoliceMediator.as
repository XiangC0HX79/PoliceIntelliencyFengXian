package app.view
{
	import app.model.vo.ElePoliceVO;
	
	import com.esri.ags.Graphic;
	import com.esri.ags.events.GraphicEvent;
	import com.esri.ags.events.ZoomEvent;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.layers.supportClasses.LOD;
	import com.esri.ags.symbols.CompositeSymbol;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.TextSymbol;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LayerElePoliceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LayerElePoliceMediator";
										
		public function LayerElePoliceMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			layerElePolice.addEventListener(GraphicEvent.GRAPHIC_ADD,onGraphicAdd);
			
			layerElePolice.visible = false;
		}
		
		private function get layerElePolice():GraphicsLayer
		{
			return viewComponent as GraphicsLayer;
		}
				
		private function onGraphicAdd(event:GraphicEvent):void
		{	
			event.graphic.addEventListener(MouseEvent.CLICK, onGraphicClick);
		}
		
		private function onGraphicClick(event:MouseEvent):void
		{			
			sendNotification(Notifications.MAP_ELEPOLICE_CLICK,event.currentTarget);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.GET_ELEPOLICE_DATA,
				Notifications.TOOL_QUERY,
				Notifications.TOOL_MAP
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case Notifications.GET_ELEPOLICE_DATA:
					initLayer(notification.getBody() as Array);
					break;
				
				case Notifications.TOOL_QUERY:			
				case Notifications.TOOL_MAP:
					layerElePolice.visible = false;
					break;
			}
		}
		
		private function initLayer(elePolices:Array):void
		{			
			layerElePolice.clear();
			
			for each(var item:ElePoliceVO in elePolices)
			{				
				var graphic:Graphic = new Graphic(item.mapPoint);
				graphic.buttonMode = true;
				graphic.attributes = item;
				
				var symbol:PictureMarkerSymbol = new PictureMarkerSymbol;
				if(item.type == 1)
					graphic.symbol = new PictureMarkerSymbol("assets/image/elepolice.png");
				else if(item.type == 2)
					graphic.symbol = new PictureMarkerSymbol("assets/image/gateway.png");
				else if(item.type == 3)
					graphic.symbol = new PictureMarkerSymbol("assets/image/video.png");
								
				layerElePolice.add(graphic);
			}
			
			layerElePolice.visible = true;
		}
	}
}