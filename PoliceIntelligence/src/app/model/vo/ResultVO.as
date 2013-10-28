package app.model.vo
{
	[Bindable]
	public class ResultVO
	{
		public function get msgCode():Number
		{
			return _source.msgCode;
		}
		public function set msgCode(value:Number):void
		{
		}
		
		public function get msgInfo():String
		{
			return _source.msgInfo;
		}
		public function set msgInfo(value:String):void
		{
		}
		
		private var _source:Object;
		
		public function ResultVO(source:Object = null)
		{
			_source = source;
		}
	}
}