using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using LitJson;
using Aspose.Cells;
using PoliceIntelligence.Bll;
using PoliceIntelligence.Model;

namespace PoliceIntelligence.WebService
{
    public partial class ImportIntelligence : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var r = new JsonData();

            try
            {
                var type = Request.Params["type"];

                var b = new Byte[Request.InputStream.Length];
                Request.InputStream.Read(b, 0, b.Length);

                var s = new MemoryStream();
                s.Write(b, 0, b.Length);

                var wb = new Workbook(s);
                var ws = wb.Worksheets[0];
                var cells = ws.Cells;

                int iJqdh = 0, iBjsj = 0, iBjdz = 0, iJqlb = 0, iJqnr = 0, iCjr = 0, iSsxq = 0;
                for (var i = 0; i < 30; i++)
                {
                    switch (cells[0, i].StringValue)
                    {
                        case "案事件编号":
                            iJqdh = i;
                            break;
                        case "报警时间":
                            iBjsj = i;
                            break;
                        case "发生地全称":
                            iBjdz = i;
                            break;
                        case "处警事由名称":
                            iJqlb = i;
                            break;
                        case "简要情况描述":
                            iJqnr = i;
                            break;
                        case "受理人姓名":
                            iCjr = i;
                            break;
                        case "受理人单位名称":
                            iSsxq = i;
                            break;
                    }
                }

                var bll = new PoliceIntelligenceBll();
                var webS = new WebServiceReference.ServiceSoapClient();
                for (var i = 1; i < cells.Rows.Count; i++)
                {
                    DateTime bjsj;
                    if (!DateTime.TryParse(cells[i, iBjsj].StringValue, out bjsj)) continue;

                    var inte = new PoliceIntelligenceModel
                    {
                        Jqdh = cells[i, iJqdh].StringValue,
                        Bjsj = bjsj,
                        Bjdz = cells[i, iBjdz].StringValue,
                        Jqlb = cells[i, iJqlb].StringValue,
                        Jqnr = cells[i, iJqnr].StringValue,
                        Cjr = cells[i, iCjr].StringValue,
                        Ssxq = cells[i, iSsxq].StringValue,
                        Jqjb = type
                    };

                    var bjdz = inte.Bjdz;
                    bjdz = bjdz.Substring("上海市奉贤区".Length);

                    var dt = webS.addressLocator(bjdz);
                    if (dt.Rows.Count > 0)
                    {
                        inte.X = dt.Rows[0]["X"].ToString();
                        inte.Y = dt.Rows[0]["Y"].ToString();
                    }

                    bll.Insert(inte);
                }

                r["msgCode"] = 0;
                r["msgInfo"] = "导入成功。";
                Response.Write(r.ToJson());
            }
            catch (Exception ex)
            {

                r["msgCode"] = 1;
                r["msgInfo"] = ex.Message;
                Response.Write(r.ToJson());
            }

            Response.End();
        }
    }
}
