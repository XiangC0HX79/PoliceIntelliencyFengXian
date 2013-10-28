using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using LitJson;

namespace Common
{
    /// <summary>
    ///MapMath 的摘要说明
    /// </summary>
    public class MapMath
    {
        public MapMath()
        {
            //
            //TODO: 在此处添加构造函数逻辑
            //
        }

        // 判断点象限函数
        private static Int32 GetQuad(Double x, Double y)
        {
            return (x >= 0) ? ((y >= 0) ? 0 : 3) : ((y >= 0) ? 1 : 2);
        }

        public static Boolean PolygonContainPoint(JsonData jd, string sx, string sy)
        {
            // 检查顶点数
            if (!jd.IsArray || (jd.Count < 3))
                return false;

            double x,y;
            if (!double.TryParse(sx, out x) || !double.TryParse(sy, out y))
                return false;
                       

            // 平移多边形，使point在新坐标系中为原点
            var vPoly = new Double[jd.Count, 2];
            for (int i = 0; i < jd.Count; i++)
            {
                vPoly[i, 0] = (double) jd[i][0] - x;
                vPoly[i, 1] = (double) jd[i][1] - y;
            }

            Int32 sum = 0; //弧长和*2/π
            Int32 q1, q2; //相邻两节点的象限
            Double ep = 0; //用来存放外积
            Boolean dq = false; //用来存放两点是否在相对象限中

            q1 = GetQuad(vPoly[0, 0], vPoly[0, 1]);
            for (int i = 1; i < jd.Count; i++)
            {
                // point为多边形的一个节点
                if (vPoly[i, 0] == 0 && vPoly[i, 1] == 0)
                    return true;

                // 计算两点向量外积，用来判断点是否在多边形边上（即三点共线）
                ep = vPoly[i, 1]*vPoly[i - 1, 0] - vPoly[i, 0]*vPoly[i - 1, 1];
                dq = (vPoly[i - 1, 0]*vPoly[i, 0] <= 0) && (vPoly[i - 1, 1]*vPoly[i, 1] <= 0);
                if ((ep == 0) && dq)
                    return true;

                // 计算象限判断相邻两点的象限关系，并修改sum
                q2 = GetQuad(vPoly[i, 0], vPoly[i, 1]);
                if (q2 == (q1 + 1)%4)
                {
                    sum = sum - 1;
                }
                else if (q2 == (q1 + 3)%4)
                {
                    sum = sum + 1;
                }
                else if (q2 == (q1 + 2)%4)
                {
                    if (ep > 0)
                        sum = sum + 2;
                    else
                        sum = sum - 2;
                }
                q1 = q2;
            }
            if (sum > 0)
                return true;

            return false;
        }
    }
}
