package app.view
{
	import app.model.vo.MapDataVO;
	
	import com.esri.ags.Graphic;
	import com.esri.ags.events.GraphicEvent;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.renderers.ClassBreaksRenderer;
	import com.esri.ags.renderers.supportClasses.ClassBreakInfo;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.TextSymbol;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LayerChartMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LayerChartMediator";
		
		public function LayerChartMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			var borderSym:SimpleLineSymbol = new SimpleLineSymbol;
			
			layerChart.renderer = new ClassBreaksRenderer("count",null,
				[
					new ClassBreakInfo(new SimpleMarkerSymbol("circle",20,0xFF00,0.7,0,0,0,borderSym))
					,new ClassBreakInfo(new SimpleMarkerSymbol("circle",35,0xFFFF00,0.7,0,0,0,borderSym))
					,new ClassBreakInfo(new SimpleMarkerSymbol("circle",50,0xFF0000,0.7,0,0,0,borderSym))
				]);
			
			layerChart.addEventListener(GraphicEvent.GRAPHIC_ADD,onGraphicAdd);
		}
		
		protected function get layerChart():GraphicsLayer
		{
			return viewComponent as GraphicsLayer;
		}
		
		private function onGraphicAdd(event:GraphicEvent):void
		{
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.GET_MAP_DATA,
				Notifications.MAP_AREA_SET,
				Notifications.TOOL_MAP
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.GET_MAP_DATA:
					initMapData(notification.getBody() as Array);
					break;
				
				case Notifications.MAP_AREA_SET:
					layerChart.visible = false;
					break;
				
				case Notifications.TOOL_MAP:
					layerChart.visible = true;
					break;
			}
		}
		
		private function initMapData(features:Array):void
		{			
			layerChart.clear();
			
			var max:Number = 0;
			for each(var gr:Graphic in features)
			{
				var mapData:MapDataVO = gr.attributes as MapDataVO;
				if(mapData.count > max)
					max = mapData.count;
				
				var sym:TextSymbol = new TextSymbol;
				sym.text = String(mapData.count);
				
				layerChart.add(new Graphic((gr.geometry as Polygon).extent.center,null,mapData));
				layerChart.add(new Graphic((gr.geometry as Polygon).extent.center,sym,mapData));
			}
			
			var classBreakInfo:ClassBreakInfo = (layerChart.renderer as ClassBreaksRenderer).infos[0];
			classBreakInfo.maxValue = max / 3;
			
			classBreakInfo = (layerChart.renderer as ClassBreaksRenderer).infos[1];
			classBreakInfo.minValue = max / 3;
			classBreakInfo.maxValue = max / 3 * 2;
			
			classBreakInfo = (layerChart.renderer as ClassBreaksRenderer).infos[2];
			classBreakInfo.minValue = max / 3 * 2;
			
			layerChart.visible = true;
		}
	}
}