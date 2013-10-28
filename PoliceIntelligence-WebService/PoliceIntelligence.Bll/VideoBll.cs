using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using PoliceIntelligence.DAL;
using PoliceIntelligence.Model;

namespace PoliceIntelligence.Bll
{
    public class VideoBll
    {
        private readonly VideoDal _dal = new VideoDal();

        /// <summary>
        /// 更新一条数据
        /// </summary>
        public bool Update(VideoModel model)
        {
            return _dal.Update(model);
        }

        public List<VideoModel> GetModelList(string where)
        {
            var dt = _dal.GetList(where);
            return dt == null ? null : DataTableToList(dt);
        }

        private static List<VideoModel> DataTableToList(DataTable dt)
        {
            var list = new List<VideoModel>();

            foreach(DataRow dr in dt.Rows)
            {
                try
                {
                    var model = new VideoModel
                        {
                            Id = (int) dr["ID"],
                            Name = Convert.IsDBNull(dr["NAME"]) ? "" : (string) dr["NAME"],
                            Code = Convert.IsDBNull(dr["CODE"]) ? "" : (string) dr["CODE"],
                            X = Convert.IsDBNull(dr["X"]) ? "" : (string) dr["X"],
                            Y = Convert.IsDBNull(dr["Y"]) ? "" : (string) dr["Y"],
                            Type = Convert.IsDBNull(dr["TYPE"]) ? 1 : (int) dr["TYPE"]
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
