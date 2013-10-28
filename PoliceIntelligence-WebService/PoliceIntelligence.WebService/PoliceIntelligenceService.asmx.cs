using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using Common;
using LitJson;
using PoliceIntelligence.Bll;
using PoliceIntelligence.Model;

namespace PoliceIntelligence.WebService
{
    /// <summary>
    /// PoliceIntelligenceWebService 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class PoliceIntelligenceWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }


        [WebMethod]
        public string InitConfig()
        {
            var jd = new JsonData();
            jd["MAP_SERVER"] = ConfigurationManager.AppSettings["MAP_SERVER"];

            return jd.ToJson();
        }

        [WebMethod]
        public string GetMapData(string beginTime, string endTime)
        {
            var dt = new PoliceIntelligenceBll().GetStatisByArea(beginTime,endTime);

            var jdArray = new JsonData();
            jdArray.SetJsonType(JsonType.Array);

            foreach (DataRow dr in dt.Rows)
            {
                var ssxq = dr["SSXQ"].ToString();
                ssxq = ssxq.Substring("上海市公安局奉贤分局".Length);

                var jd = new JsonData();
                jd["SSXQ"] = ssxq;
                jd["COUNT"] = (int)dr["COUNT"];
                jdArray.Add(jd);
            }

            return jdArray.ToJson();
        }

        [WebMethod]
        public string GetIntelligencyData(string beginTime, string endTime,string area)
        {
            var list = new PoliceIntelligenceBll().GetModelList("SSXQ = '上海市公安局奉贤分局" + area + "' AND BJSJ BETWEEN '" + beginTime + "' AND '" + endTime + "' ORDER BY BJSJ");
            ;
            return JsonMapper.ToJson(list);
        }
        
        [WebMethod]
        public bool SaveIntelligencyData(string json)
        {
            var bll = new PoliceIntelligenceBll();

            try
            {
                var jd = JsonMapper.ToObject(json);
                if (jd.IsArray)
                {
                    for (var i = 0; i < jd.Count; i++)
                    {
                        var item = jd[i];
                        var model = JsonMapper.ToObject<PoliceIntelligenceModel>(item.ToJson());
                        bll.Update(model);
                    }
                }

                return true;
            }
            catch (Exception)
            {
                return false;
            };
        }

        

        [WebMethod]
        public string GetElePoliceData(string coords)
        {
            var list = new VideoBll().GetModelList("");

            var poly = JsonMapper.ToObject(coords);

            var l =
                from p in list
                where MapMath.PolygonContainPoint(poly, p.X,p.Y) 
                select p;
            ;
            return JsonMapper.ToJson(l.ToList());
        }
    }
}
