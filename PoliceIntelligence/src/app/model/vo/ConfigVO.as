package app.model.vo
{
	[Bindable]
	public class ConfigVO
	{
		public function get mapServer():String
		{
			return _source.MAP_SERVER;
		}
		public function set mapServer(value:String):void
		{
		}
					
		private var _source:Object;
		
		public function ConfigVO(source:Object)
		{
			_source = source;
		}
	}
}