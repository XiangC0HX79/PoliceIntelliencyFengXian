package app.model.vo
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;

	[Bindable]
	public class IntelligencyVO
	{
		public function get jqdh():String
		{
			return _source.Jqdh;
		}
		public function set jqdh(value:String):void
		{
		}
		
		public function get jqlb():String
		{
			return _source.Jqlb;
		}
		public function set jqlb(value:String):void
		{
		}
		
		public function get bjsj():Date
		{
			return new Date(Date.parse(_source.Bjsj));
		}
		public function set bjsj(value:Date):void
		{
		}
		
		public function get jqbt():String
		{
			return _source.Jqbt;
		}
		public function set jqbt(value:String):void
		{
		}
		
		public function get bjdz():String
		{
			var s:String = _source.Bjdz;			
			s = s.replace("上海市奉贤区","");
			
			return s;
		}
		public function set bjdz(value:String):void
		{
		}
				
		public function get bjrxm():String
		{
			return _source.Bjrxm;
		}
		public function set bjrxm(value:String):void
		{
		}
		
		public function get bjdh():String
		{
			return _source.Bjdh;
		}
		public function set bjdh(value:String):void
		{
		}
		
		public function get lxdh():String
		{
			return _source.Lxdh;
		}
		public function set lxdh(value:String):void
		{
		}
		
		public function get cjr():String
		{
			return _source.Cjr;
		}
		public function set cjr(value:String):void
		{
		}
		
		public function get ssxq():String
		{
			var s:String = _source.Ssxq;			
			s = s.replace("上海市公安局奉贤分局","");
			
			return s;
		}
		public function set ssxq(value:String):void
		{
		}
		
		public function get jqnr():String
		{
			return _source.Jqnr;
		}
		public function set jqnr(value:String):void
		{
		}
		
		public function get jqjb():String
		{
			return _source.Jqjb;
		}
		public function set jqjb(value:String):void
		{
		}
		
		public function get mapPoint():MapPoint
		{
			var x:Number = Number(_source.X);
			var y:Number = Number(_source.Y);
			if(!_source.X || !_source.Y || isNaN(x) || isNaN(y))
				return null;
			else
				return new MapPoint(x,y,new SpatialReference(102100));
		}
		public function set mapPoint(value:MapPoint):void
		{
			_source.X = String(value.x);
			_source.Y = String(value.y);
		}
				
		public var isEdit:Boolean = false;
		
		private var _source:Object;
		
		public function IntelligencyVO(source:Object)
		{
			_source = source;
		}
		
		public function toJson():String
		{
			return JSON.stringify(_source);
		}
	}
}