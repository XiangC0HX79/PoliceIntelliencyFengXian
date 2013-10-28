package app.model.vo
{
	[Bindable]
	public class MapDataVO
	{
		public function get area():String
		{
			var ssxq:String = _source.SSXQ;			
			var id:Number = ssxq.indexOf("辖区");
			if(id >= 0)
				ssxq = ssxq.substr(0,id);
			
			return ssxq;
		}
		public function set area(value:String):void
		{
		}
		
		public function get count():Number
		{
			return _source.COUNT;
		}
		public function set count(value:Number):void
		{
			_source.COUNT = value;
		}
		
		private var _source:Object;
		
		public function MapDataVO(source:Object)
		{
			_source = source;
		}
	}
}