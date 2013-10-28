package app.model.vo
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	
	[Bindable]
	public class ElePoliceVO
	{		
		public function get id():Number
		{
			return _source.Id;
		}
		public function set id(value:Number):void
		{
		}
		
		public function get name():String
		{
			return _source.Name;
		}
		public function set name(value:String):void
		{
		}
		
		public function get code():String
		{
			return _source.Code;
		}
		public function set code(value:String):void
		{
		}
		
		public function get mapPoint():MapPoint
		{
			return new MapPoint(Number(_source.X),Number(_source.Y),new SpatialReference(102100));
		}
		public function set mapPoint(value:MapPoint):void
		{
		}
		
		public function get type():Number
		{
			return _source.Type;
		}
		public function set type(value:Number):void
		{
		}
		
		private var _source:Object;
		
		public function ElePoliceVO(source:Object)
		{
			_source = source;
		}
	}
}