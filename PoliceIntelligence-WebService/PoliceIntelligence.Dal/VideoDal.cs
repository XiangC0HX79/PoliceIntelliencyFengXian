using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using DBModule;
using PoliceIntelligence.Model;

namespace PoliceIntelligence.DAL
{
    public class VideoDal
    {
        /// <summary>
        /// 更新一条数据
        /// </summary>
        public bool Update(VideoModel model)
        {
            var sb = new StringBuilder();

            sb.Append("UPDATE T_QW_VIDEOPOINT SET ");
            sb.Append(" NAME = @Name , ");
            sb.Append(" CODE = @Code , ");
            sb.Append(" X = @X , ");
            sb.Append(" Y = @Y , ");
            sb.Append(" TYPE = @Type ");
            sb.Append(" WHERE ID = @Id ");

            var db = new DbModule();

            DbParameter[] sqlParams =
                {
                    db.CreateParameter("@Id",DbType.Int32,model.Id),
                    db.CreateParameter("@Name",DbType.String,50,model.Name),
                    db.CreateParameter("@Code",DbType.String,50,model.Code),
                    db.CreateParameter("@X",DbType.String,50,model.X),
                    db.CreateParameter("@Y",DbType.String,50,model.Y),
                    db.CreateParameter("@Type",DbType.Int32,model.Type)
                };

            return db.ExcuteSql(sb.ToString(), sqlParams) >= 0;
        }

        /// <summary>
        /// 获得数据列表
        /// </summary>
        public DataTable GetList(string where)
        {
            var sb = new StringBuilder();
            sb.Append("SELECT * FROM T_QW_VIDEOPOINT");

            if (where.Trim() != "")
            {
                sb.Append(" WHERE " + where);
            }

            return new DbModule().QueryBySql(sb.ToString());
        }
    }
}
