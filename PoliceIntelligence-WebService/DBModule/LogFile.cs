using System;
using System.IO;
using System.Web;

namespace DBModule
{
    class LogFile
    {
        public static void WriteSqlTimeOutLog(string sql, long m)
        {
            if (m > 10000000)
                WriteFile("log_" + DateTime.Now.ToString("HH"), string.Format(@"{0:N} {1}", m, sql));
        }

        public static void WriteSqlErroLog(string sql, string err)
        {
            WriteFile("err_" + DateTime.Now.ToString("HH"), sql + " " + err);
        }

        public static void WriteErroLog(string err)
        {
            WriteFile("err_" + DateTime.Now.ToString("HH"), err);
        }

        private static void WriteFile(string filename, string filecontent)
        {
            try
            {
                var path = HttpContext.Current.Server.MapPath("~\\SqlLog\\") + DateTime.Now.ToString("yyyyMMdd") + "\\";
                var dir = new DirectoryInfo(path);
                if (!dir.Exists) dir.Create();

                filename = path + filename;

                using (var w = File.AppendText(filename))
                {
                    w.WriteLine(filecontent);
                    w.Flush();
                    w.Close();
                    w.Dispose();
                }
            }
            catch (Exception)
            {


            }
        }
    }
}
