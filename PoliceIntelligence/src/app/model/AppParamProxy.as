package app.model
{
	import app.model.vo.AppParamVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AppParamProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "AppParamProxy";
		
		public function AppParamProxy()
		{
			super(NAME, new AppParamVO);
		}
		
		public function get appParam():AppParamVO
		{
			return data as AppParamVO;
		}
	}
}