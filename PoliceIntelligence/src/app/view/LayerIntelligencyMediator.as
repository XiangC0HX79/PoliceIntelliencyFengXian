package app.view
{
	import com.esri.ags.Graphic;
	import com.esri.ags.events.EditEvent;
	import com.esri.ags.events.GraphicEvent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.CompositeSymbol;
	import com.esri.ags.symbols.InfoSymbol;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tools.EditTool;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	
	import spark.effects.Fade;
	import spark.effects.Scale;
	import spark.effects.animation.RepeatBehavior;
	
	import app.model.IntelligencyProxy;
	import app.model.vo.IntelligencyVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LayerIntelligencyMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LayerIntelligencyMediator";
				
		private var intelligencyProxy:IntelligencyProxy = null;
		
		private var isEdit:Boolean = false;
		
		private var editTool:EditTool;
		
		private var flashMovie:Scale;
		
		public function LayerIntelligencyMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			layerIntelligency.addEventListener(GraphicEvent.GRAPHIC_ADD,onGraphicAdd);			
			
			layerIntelligency.visible = false;
			
			editTool = new EditTool(layerIntelligency.map);
			editTool.addEventListener(EditEvent.GRAPHICS_MOVE_STOP,onMoveStop);
			
			flashMovie = new Scale;
			flashMovie.scaleXTo = 1.5;
			flashMovie.scaleYTo = 1.5;
			flashMovie.duration = 1000;			
			flashMovie.repeatCount = 6;
			flashMovie.repeatBehavior = RepeatBehavior.REVERSE;
			
			intelligencyProxy = facade.retrieveProxy(IntelligencyProxy.NAME) as IntelligencyProxy;
		}
		
		private function get layerIntelligency():GraphicsLayer
		{
			return viewComponent as GraphicsLayer;
		}
		
		private function onMoveStop(event:EditEvent):void
		{
			var gr:Graphic = event.graphics[0];
			var inte:IntelligencyVO = gr.attributes as IntelligencyVO;
			inte.mapPoint = gr.geometry as MapPoint;
			inte.isEdit = true;
		}
		
		private function onGraphicAdd(event:GraphicEvent):void
		{	
			event.graphic.addEventListener(MouseEvent.CLICK, onGraphicClick);
		}
		
		private function onGraphicClick(event:MouseEvent):void
		{			
			if(isEdit)
				editTool.activate(EditTool.MOVE,[event.currentTarget]);
			
			sendNotification(Notifications.MAP_INTELLIGENCY_CLICK,event.currentTarget);
		}
				
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.GET_INTELLIGENCY_DATA,
				Notifications.TOOL_QUERY,
				Notifications.TOOL_MAP,
				
				Notifications.TOOL_EDIT,
				Notifications.POPUP_CLOSE,
				
				Notifications.MAP_INTELLIGENCY_FLASH
			];
		}
				
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case Notifications.GET_INTELLIGENCY_DATA:
					initLayer(notification.getBody() as Array);
					break;
				
				case Notifications.TOOL_QUERY:
				case Notifications.TOOL_MAP:
					layerIntelligency.visible = false;
					break;
								
				case Notifications.TOOL_EDIT:
					isEdit = true;
					break;
				
				case Notifications.POPUP_CLOSE:
					isEdit = false;
					editTool.deactivate();
					break;
				
				case Notifications.MAP_INTELLIGENCY_FLASH:
					flashIntelligency(notification.getBody() as IntelligencyVO); 
					break;
			}
		}
		
		private function initLayer(intelligencies:Array):void
		{			
			layerIntelligency.clear();
			
			for each(var item:IntelligencyVO in intelligencies)
			{				
				var graphic:Graphic = new Graphic(item.mapPoint);
				graphic.buttonMode = true;
				graphic.attributes = item;
				if(item.jqjb == "0")
					graphic.symbol = new PictureMarkerSymbol("assets/image/alarm2.png");
				else
					graphic.symbol = new PictureMarkerSymbol("assets/image/alarm4.png");
				layerIntelligency.add(graphic);
			}
			
			layerIntelligency.visible = true;
		}
		
		private function flashIntelligency(inte:IntelligencyVO):void
		{		
			if(!layerIntelligency.visible)
				return;
			
			flashMovie.end();		
			
			for each(var gr:Graphic in layerIntelligency.graphicProvider)
			{
				var attri:IntelligencyVO = gr.attributes as IntelligencyVO;
				if(attri.jqdh == inte.jqdh)
				{
					layerIntelligency.moveToTop(gr);
					
					flashMovie.play([gr]);
					
					editTool.activate(EditTool.MOVE,[gr]);
					
					break;
				}
			}
		}
	}
}