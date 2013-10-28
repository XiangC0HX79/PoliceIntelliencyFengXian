package app.model.vo
{
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.Polygon;
	
	import spark.formatters.DateTimeFormatter;

	[Bindable]
	public class AppParamVO
	{
		public var districtGeometry:Polygon;
		
		public var beginTime:String;
		
		public var endTime:String;
		
		public var viewIndex:Number = 0;
				
		public function AppParamVO()
		{
			var now:Date = new Date;
			
			var st:Date = new Date(now.fullYear,now.month,now.date);
			var et:Date = new Date(now.fullYear,now.month,now.date + 1);
			
			var df:DateTimeFormatter = new DateTimeFormatter;
			df.dateTimePattern = "yyyy-MM-dd HH:mm:ss";
			
			beginTime = df.format(st);
			endTime = df.format(et);
		}
	}
}