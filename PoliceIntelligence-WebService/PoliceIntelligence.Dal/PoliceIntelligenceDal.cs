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
    public class PoliceIntelligenceDal
    {
        /// <summary>
        /// 更新一条数据
        /// </summary>
        public bool Update(PoliceIntelligenceModel model)
        {
            var sb = new StringBuilder();

            sb.Append("UPDATE T_QW_Burglary SET ");
            sb.Append(" JQLB = @Jqlb , ");
            sb.Append(" BJSJ = @Bjsj , ");
            sb.Append(" BJDZ = @Bjdz , ");
            sb.Append(" BJRXM = @Bjrxm , ");
            sb.Append(" JQBT = @Jqbt , ");
            sb.Append(" BJDH = @Bjdh , ");
            sb.Append(" LXDH = @Lxdh , ");
            sb.Append(" CJR = @Cjr , ");
            sb.Append(" JQNR = @Jqnr , ");
            sb.Append(" SSXQ = @Ssxq , ");
            sb.Append(" JQJB = @Jqjb , ");
            sb.Append(" X = @X , ");
            sb.Append(" Y = @Y ");
            sb.Append(" WHERE JQDH = @Jqdh ");

            var db = new DbModule();

            DbParameter[] sqlParams =
                {
                    db.CreateParameter("@Jqdh",DbType.String,50,model.Jqdh),
                    db.CreateParameter("@Jqlb",DbType.String,50,model.Jqlb),
                    db.CreateParameter("@Bjsj",DbType.DateTime,model.Bjsj),
                    db.CreateParameter("@Bjdz",DbType.String,200,model.Bjdz),
                    db.CreateParameter("@Bjrxm",DbType.String,100,model.Bjrxm),
                    db.CreateParameter("@Jqbt",DbType.String,200,model.Jqbt),
                    db.CreateParameter("@Bjdh",DbType.String,50,model.Bjdh),
                    db.CreateParameter("@Lxdh",DbType.String,50,model.Lxdh),
                    db.CreateParameter("@Cjr",DbType.String,50,model.Cjr),
                    db.CreateParameter("@Jqnr",DbType.String,1000,model.Jqnr),
                    db.CreateParameter("@Ssxq",DbType.String,100,model.Ssxq),
                    db.CreateParameter("@Jqjb",DbType.String,50,model.Jqjb),
                    db.CreateParameter("@X",DbType.String,50,model.X),
                    db.CreateParameter("@Y",DbType.String,50,model.Y)
                };

            return db.ExcuteSql(sb.ToString(), sqlParams) >= 0;
        }

        /// <summary>
        /// 删除一条数据
        /// </summary>
        public bool Delete(PoliceIntelligenceModel model)
        {
            var sb = new StringBuilder();

            sb.Append("DELETE FROM T_QW_Burglary ");
            sb.Append(" WHERE JQDH = @Jqdh ");

            var db = new DbModule();

            DbParameter[] sqlParams =
                {
                    db.CreateParameter("@Jqdh",DbType.String,50,model.Jqdh)
                };

            return db.ExcuteSql(sb.ToString(), sqlParams) >= 0;
        }

        /// <summary>
        /// 插入一条数据
        /// </summary>
        public bool Insert(PoliceIntelligenceModel model)
        {
            var sb = new StringBuilder();

            sb.Append("DELETE FROM T_QW_Burglary WHERE JQDH = @Jqdh;");
            sb.Append("INSERT INTO T_QW_Burglary ( ");
            sb.Append("JQDH,JQLB,BJSJ,BJDZ,BJRXM,JQBT,BJDH,LXDH,CJR,JQNR,SSXQ,JQJB,X,Y");
            sb.Append(") VALUES (");
            sb.Append("@Jqdh,@Jqlb,@Bjsj,@Bjdz,@Bjrxm,@Jqbt,@Bjdh,@Lxdh,@Cjr,@Jqnr,@Ssxq,@Jqjb,@X,@Y");
            sb.Append(")");

            var db = new DbModule();

            DbParameter[] sqlParams =
                {
                    db.CreateParameter("@Jqdh",DbType.String,50,model.Jqdh),
                    db.CreateParameter("@Jqlb",DbType.String,50,model.Jqlb),
                    db.CreateParameter("@Bjsj",DbType.DateTime,model.Bjsj),
                    db.CreateParameter("@Bjdz",DbType.String,200,model.Bjdz),
                    db.CreateParameter("@Bjrxm",DbType.String,100,model.Bjrxm),
                    db.CreateParameter("@Jqbt",DbType.String,200,model.Jqbt),
                    db.CreateParameter("@Bjdh",DbType.String,50,model.Bjdh),
                    db.CreateParameter("@Lxdh",DbType.String,50,model.Lxdh),
                    db.CreateParameter("@Cjr",DbType.String,50,model.Cjr),
                    db.CreateParameter("@Jqnr",DbType.String,1000,model.Jqnr),
                    db.CreateParameter("@Ssxq",DbType.String,100,model.Ssxq),
                    db.CreateParameter("@Jqjb",DbType.String,50,model.Jqjb),
                    db.CreateParameter("@X",DbType.String,50,model.X),
                    db.CreateParameter("@Y",DbType.String,50,model.Y)
                };

            return db.ExcuteSql(sb.ToString(), sqlParams) >= 0;
        }

        /// <summary>
        /// 获得数据列表
        /// </summary>
        public DataTable GetList(string where)
        {
            var sb = new StringBuilder();
            sb.Append("SELECT * FROM T_QW_Burglary");

            if (where.Trim() != "")
            {
                sb.Append(" WHERE " + where);
            }

            return new DbModule().QueryBySql(sb.ToString());
        }
    }
}
