using System;
using System.Data;
using System.Configuration;

using System.Data.Common;

namespace DBModule
{
    /// <summary>
    /// 类：访问数据库
    /// </summary>
    public class DbModule
    {
        private readonly string _connectionString;
        private readonly DbProviderFactory _dbProviderFactory;

        public DbModule()
        {
            var s = ConfigurationManager.ConnectionStrings["QWConnectionString"];

            _dbProviderFactory = DbProviderFactories.GetFactory(s.ProviderName);

            _connectionString = s.ConnectionString;
        }

        public DbParameter CreateParameter(string paramName, DbType paramType, object value)
        {
            return CreateParameter(paramName, paramType, 0, value);
        }

        public DbParameter CreateParameter(string paramName, DbType paramType, int size,object value)
        {
            var param = _dbProviderFactory.CreateParameter();
            if (param != null)
            {
                param.DbType = paramType;
                param.ParameterName = paramName;
                if(size > 0)param.Size = size;
                param.Value = value;
            }
            return param;
        }

        public DataTable QueryBySql(string sql)
        {
            return QueryBySql(sql,null);
        }

        public DataTable QueryBySql(string sql, Array sqlParams)
        {
            DataTable result = null;

            var dbConnection = _dbProviderFactory.CreateConnection();

            if (dbConnection != null) dbConnection.ConnectionString = _connectionString;

            var dbCommand = _dbProviderFactory.CreateCommand();
            if (dbCommand != null)
            {
                dbCommand.CommandText = sql;
                if(sqlParams != null) dbCommand.Parameters.AddRange(sqlParams);
                dbCommand.Connection = dbConnection;
            }

            var dataAdapter = _dbProviderFactory.CreateDataAdapter();
            if (dataAdapter != null)
            {
                dataAdapter.SelectCommand = dbCommand;

                try
                {
                    var st = DateTime.Now.Ticks;

                    var dataSet = new DataSet();
                    dataAdapter.Fill(dataSet);
                    result = dataSet.Tables[0];

                    var et = DateTime.Now.Ticks;
                    LogFile.WriteSqlTimeOutLog(sql, et - st);
                }
                catch (Exception errMsg)
                {
                    LogFile.WriteSqlErroLog(sql, errMsg.Message);

                    result = null;
                }
            }

            if ((dbConnection != null) && (dbConnection.State == ConnectionState.Open))
            {
                dbConnection.Close();
                dbConnection.Dispose();
            }

            return result;
        }

        public object QueryScalar(string sql)
        {
            return QueryScalar(sql,null);
        }

        public object QueryScalar(string sql, Array sqlParams)
        {
            object result = null;

            var dbConnection = _dbProviderFactory.CreateConnection();

            if (dbConnection != null)
            {
                dbConnection.ConnectionString = _connectionString;
                dbConnection.Open();
            }

            var dbCommand = _dbProviderFactory.CreateCommand();
            if (dbCommand != null)
            {
                dbCommand.CommandText = sql;
                if (sqlParams != null) dbCommand.Parameters.AddRange(sqlParams);
                dbCommand.Connection = dbConnection;

                try
                {
                    var st = DateTime.Now.Ticks;

                    result = dbCommand.ExecuteScalar();

                    var et = DateTime.Now.Ticks;
                    LogFile.WriteSqlTimeOutLog(sql, et - st);

                }
                catch (Exception errMsg)
                {
                    LogFile.WriteSqlErroLog(sql, errMsg.Message);

                    result = null;
                }
            }

            if ((dbConnection != null) && (dbConnection.State == ConnectionState.Open))
            {
                dbConnection.Close();
                dbConnection.Dispose();
            }

            return result;
        }
        
        public int ExcuteSql(string sql)
        {
            return ExcuteSql(sql, null);
        }

        public int ExcuteSql(string sql, Array sqlParams)
        {
            var result = -1;

            var dbConnection = _dbProviderFactory.CreateConnection();

            if (dbConnection != null)
            {
                dbConnection.ConnectionString = _connectionString;
                dbConnection.Open();
            }

            var dbCommand = _dbProviderFactory.CreateCommand();
            if (dbCommand != null)
            {
                dbCommand.CommandText = sql;
                if (sqlParams != null) dbCommand.Parameters.AddRange(sqlParams);
                dbCommand.Connection = dbConnection;

                try
                {
                    var st = DateTime.Now.Ticks;

                    result = dbCommand.ExecuteNonQuery();

                    var et = DateTime.Now.Ticks;
                    LogFile.WriteSqlTimeOutLog(sql, et - st);
                }
                catch (Exception errMsg)
                {
                    LogFile.WriteSqlErroLog(sql, errMsg.Message);

                    result = -1;
                }
            }

            if ((dbConnection != null) && (dbConnection.State == ConnectionState.Open))
            {
                dbConnection.Close();
                dbConnection.Dispose();
            }

            return result;
        }

        public int ExcuteMultiSql(string multiSql)
        {
            var result = -1;

            var sqls = multiSql.Split(';');

            var dbConnection = _dbProviderFactory.CreateConnection();

            if (dbConnection != null)
            {
                dbConnection.ConnectionString = _connectionString;
                dbConnection.Open();

                var dbTrans = dbConnection.BeginTransaction();

                try
                {
                    var st = DateTime.Now.Ticks;

                    foreach (var sql in sqls)
                    {
                        if (sql == "") continue;

                        var dbCommand = _dbProviderFactory.CreateCommand();

                        if (dbCommand == null) continue;
                        
                        dbCommand.CommandText = sql;
                        dbCommand.Connection = dbConnection;
                        dbCommand.Transaction = dbTrans;

                        result += dbCommand.ExecuteNonQuery();
                    }

                    dbTrans.Commit();

                    var et = DateTime.Now.Ticks;
                    LogFile.WriteSqlTimeOutLog(multiSql, et - st);
                }
                catch (Exception errMsg)
                {
                    LogFile.WriteSqlErroLog(multiSql, errMsg.Message);

                    if (dbConnection.State == ConnectionState.Open)
                        dbTrans.Rollback();

                    result = -1;
                }
            }

            if ((dbConnection != null) && (dbConnection.State == ConnectionState.Open))
            {
                dbConnection.Close();
                dbConnection.Dispose();
            }


            return result;
        }
    }
}
