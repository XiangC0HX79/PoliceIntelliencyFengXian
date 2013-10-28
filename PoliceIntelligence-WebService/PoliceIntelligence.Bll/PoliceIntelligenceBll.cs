using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using DBModule;
using PoliceIntelligence.DAL;
using PoliceIntelligence.Model;

namespace PoliceIntelligence.Bll
{
    public class PoliceIntelligenceBll
    {
        private readonly PoliceIntelligenceDal _dal = new PoliceIntelligenceDal();

        /// <summary>
        /// 更新一条数据
        /// </summary>
        public bool Update(PoliceIntelligenceModel model)
        {
            return _dal.Update(model);
        }

        /// <summary>
        /// 删除一条数据
        /// </summary>
        public bool Delete(PoliceIntelligenceModel model)
        {
            return _dal.Delete(model);
        }

        /// <summary>
        /// 插入一条数据
        /// </summary>
        public bool Insert(PoliceIntelligenceModel model)
        {
            return _dal.Insert(model);
        }

        public List<PoliceIntelligenceModel> GetModelList(string where)
        {
            var dt = _dal.GetList(where);
            return dt == null ? null : DataTableToList(dt);
        }

        public DataTable GetStatisByArea(string beginTime, string endTime)
        {
            var sb = new StringBuilder();
            sb.Append("SELECT COUNT(*) AS COUNT,SSXQ FROM T_QW_Burglary WHERE SSXQ IS NOT NULL");
            sb.Append(" AND BJSJ BETWEEN '" + beginTime + "' AND '" + endTime + "'");
            sb.Append(" GROUP BY SSXQ");

            return new DbModule().QueryBySql(sb.ToString());
        }

        private static List<PoliceIntelligenceModel> DataTableToList(DataTable dt)
        {
            var list = new List<PoliceIntelligenceModel>();

            foreach(DataRow dr in dt.Rows)
            {
                try
                {
                    var model = new PoliceIntelligenceModel
                        {
                            Jqdh = (string)dr["JQDH"],
                            Jqlb = Convert.IsDBNull(dr["JQLB"]) ? "" : (string)dr["JQLB"],
                            Bjsj = (DateTime) dr["BJSJ"],
                            Bjdz = Convert.IsDBNull(dr["BJDZ"]) ? "" : (string)dr["BJDZ"],
                            Bjrxm = Convert.IsDBNull(dr["BJRXM"]) ? "" : (string)dr["BJRXM"],
                            Jqbt = Convert.IsDBNull(dr["JQBT"]) ? "" : (string)dr["JQBT"],
                            Bjdh = Convert.IsDBNull(dr["BJDH"]) ? "" : (string)dr["BJDH"],
                            Lxdh = Convert.IsDBNull(dr["LXDH"]) ? "" : (string)dr["LXDH"],
                            Cjr = Convert.IsDBNull(dr["CJR"]) ? "" : (string)dr["CJR"],
                            Jqnr = Convert.IsDBNull(dr["JQNR"]) ? "" : (string)dr["JQNR"],
                            Ssxq = Convert.IsDBNull(dr["SSXQ"]) ? "" : (string)dr["SSXQ"],
                            Jqjb = Convert.IsDBNull(dr["JQJB"]) ? "" : (string)dr["JQJB"],
                            X = Convert.IsDBNull(dr["X"]) ? "" : (string)dr["X"],
                            Y = Convert.IsDBNull(dr["Y"]) ? "" : (string)dr["Y"]
                        };

                    list.Add(model);
                }
                catch (Exception)
                {
                    
                }
            }
            return list;
        }
    }
}
