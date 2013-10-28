package app.view
{	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.SimpleFillSymbol;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LayerMaskMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LayerMaskMediator";
		
		private var graphicMask:Graphic;
		
		public function LayerMaskMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			graphicMask = new Graphic;
			
			graphicMask.symbol = new SimpleFillSymbol("solid",0xFFFFFF,0.8);
			
			layerMask.add(graphicMask);
		}
		
		protected function get layerMask():GraphicsLayer
		{
			return viewComponent as GraphicsLayer;
		}
				
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.INIT_DISTRICT,				
				Notifications.MAP_AREA_SET,
				Notifications.TOOL_QUERY,
				Notifications.TOOL_MAP
				]
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{						
				case Notifications.INIT_DISTRICT:
					var polygon:Polygon = notification.getBody() as Polygon;
					polygon = polygon.extent.expand(1.5).toPolygon();
					
					var polygonMask:Polygon = new Polygon;
					polygonMask.addRing(polygon.rings[0]);
					polygonMask.addRing(polygon.rings[0]);
					
					graphicMask.geometry = polygonMask;
					break;
				
				case Notifications.MAP_AREA_SET:					
					var gr:Graphic = notification.getBody() as Graphic;
					
					polygon = gr.geometry as Polygon;
					
					polygonMask = graphicMask.geometry as Polygon;
					
					polygonMask.rings.pop();
					
					polygonMask.addRing(polygon.rings[0]);
					
					graphicMask.visible = true;
					break;
				
				case Notifications.TOOL_QUERY:
				case Notifications.TOOL_MAP:
					graphicMask.visible = false;
					break;
			}
		}
	}
}