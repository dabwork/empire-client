// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base.*;
import flash.geom.Vector3D;
	
public class  HyperspaceSmooth
{
	public var m_Max:int;
	public var m_List:Vector.<Number> = new Vector.<Number>();
	public var m_Cnt:int = 0;
	public var m_Cur:int = 0;

	static private var m_BezierMax:int = 0;
	static private var m_Bezier:Vector.<Number> = new Vector.<Number>();

	public function HyperspaceSmooth(max:int = 16):void
	{
		m_Max = max;
		m_List.length = max << 2;

		if (max > m_BezierMax) {
			var cnt:int, i:int;
			var ext:Number;
			for (cnt = m_BezierMax; cnt <= max; cnt++) {
				ext = fact(cnt - 1);
				for (i = 0; i < cnt; i++) {
					m_Bezier.push(ext / (fact(i) * fact(cnt - 1 - i)));
				}
			}
			m_BezierMax = max;
		}
	}

	static public function fact(zn:int):Number
	{
		var cz:Number = 1.0;
		var t:Number = 2.0;
		var ti:int = 2;
		while (ti <= zn) {
			cz = cz * t;
			t = t + 1.0;
			ti++;
		}
		return cz;
	}

	public function Clear():void
	{
		m_Cnt = 0;
	}
	
	public function IsEmpty():Boolean
	{
		return m_Cnt <= 0;
	}

	// для угла: vx - Угол должен быть нормирован
	public function Add(t:Number, vx:Number, vy:Number = 0, vz:Number = 0):void
	{
		if(m_Cnt<=0) {
			m_List[0] = t;
			m_List[1] = vx;
			m_List[2] = vy;
			m_List[3] = vz;
			m_Cur=0;
			m_Cnt=1;
			return;
		}
		if (t < m_List[m_Cur << 2]) {
			throw Error("Smooth.Add");

		} else if (t == m_List[m_Cur << 2]) {
			m_List[(m_Cur << 2) + 1] = vx;
			m_List[(m_Cur << 2) + 2] = vy;
			m_List[(m_Cur << 2) + 3] = vz;
			return;
		}
		m_Cur++; if (m_Cur >= m_Max) m_Cur = 0;
		m_List[m_Cur << 2] = t;
		m_List[(m_Cur << 2) + 1] = vx;
		m_List[(m_Cur << 2) + 2] = vy;
		m_List[(m_Cur << 2) + 3] = vz;
		if (m_Cnt < m_Max) m_Cnt++;
	}
	
	public function AddOffset(xoff:Number, yoff:Number, zoff:Number):void
	{
		var i:int;
		for (i = 0; i < m_Cnt; i++) {
			m_List[(i << 2) + 1] += xoff;
			m_List[(i << 2) + 2] += yoff;
			m_List[(i << 2) + 3] += zoff;
		}
	}
	
	public function GetAngle(t:Number):Number
	{
		if (m_Cnt <= 0) throw Error("Smooth.Get");
		if (m_Cnt == 1 || t >= m_List[m_Cur << 2]) {
			return m_List[(m_Cur << 2) + 1];
		}
		var c:int = m_Cur;
		var cnt:int = m_Cnt - 1;
		var p:int = 0;
		var v:Number;
		do {
			p = c - 1;
			if (p < 0) p = m_Max - 1;

			if (t >= m_List[p << 2]) {
				v = (t - m_List[p << 2]) / (m_List[c << 2] - m_List[p << 2]);
				return BaseMath.AngleNorm(v * BaseMath.AngleDist(m_List[(p << 2) + 1], m_List[(c << 2) + 1]) + m_List[(p << 2) + 1]);
			}

			c = p;
			cnt--;
		} while (cnt != 0);
		return m_List[(p << 2) + 1];
	}

	public function Get(t:Number, out:Vector3D):void
	{
		if (m_Cnt <= 0) throw Error("Smooth.Get");
		if (m_Cnt == 1 || t >= m_List[m_Cur << 2]) {
			out.x = m_List[(m_Cur << 2) + 1];
			out.y = m_List[(m_Cur << 2) + 2];
			out.z = m_List[(m_Cur << 2) + 3];
			return;
		}

		var first:int = m_Cur - (m_Cnt - 1);
		if(first<0) first=m_Max+first;
		if (t <= m_List[first << 2]) {
			out.x = m_List[(first << 2) + 1];
			out.y = m_List[(first << 2) + 2];
			out.z = m_List[(first << 2) + 3];
			return;
		}

		var v:Number;
		var c:int = m_Cur;
		var cnt:int = m_Cnt - 1;
		var p:int = 0;
		do {
			p = c - 1;
			if (p < 0) p = m_Max - 1;
			
			if (t >= m_List[p << 2]) {
				v = (t - m_List[p << 2]) / (m_List[c << 2] - m_List[p << 2]);
				out.x = v * (m_List[(c << 2) + 1] - m_List[(p << 2) + 1]) + m_List[(p << 2) + 1];
				out.y = v * (m_List[(c << 2) + 2] - m_List[(p << 2) + 2]) + m_List[(p << 2) + 2];
				out.z = v * (m_List[(c << 2) + 3] - m_List[(p << 2) + 3]) + m_List[(p << 2) + 3];
				return;
			}

			c = p;
			cnt--;
		} while (cnt != 0);
		out.x = m_List[(p << 2) + 1];
		out.y = m_List[(p << 2) + 2];
		out.z = m_List[(p << 2) + 3];
	}
	
	static private var m_TPos:Vector3D = new Vector3D();
	
	public function GetB(t:Number, out:Vector3D):void
	{
		if (m_Cnt <= 0) throw Error("Smooth.Get");
		if (m_Cnt == 1 || t >= m_List[m_Cur << 2]) {
			out.x = m_List[(m_Cur << 2) + 1];
			out.y = m_List[(m_Cur << 2) + 2];
			out.z = m_List[(m_Cur << 2) + 3];
			return;
		}
		
		var tlast:Number = m_List[m_Cur << 2];

		var first:int = m_Cur - (m_Cnt - 1);
		if (first < 0) first = m_Max + first;
		var tfirst:Number = m_List[first << 2];
		if (t <= tfirst) {
			out.x = m_List[(first << 2) + 1];
			out.y = m_List[(first << 2) + 2];
			out.z = m_List[(first << 2) + 3];
			return;
		}

		var i:int;
//		if (m_BezierCnt != m_Cnt) {
//			m_BezierCnt = m_Cnt;
//			var ext:Number = fact(m_BezierCnt - 1);
//			for (i = 0; i < m_BezierCnt; i++) {
//				m_List[i * 5 + 4] = ext / (fact(i) * fact(m_BezierCnt - 1 - i));
//			}
//		}
		
		out.x = 0.0;
		out.y = 0.0;
		out.z = 0.0;
		
		var te:Number = (t - tfirst) / (tlast - tfirst);
//trace(te);
		var tpower:Number = 1.0;
		var m1to:Number = 1.0 / (1.0 - te);
		var m1topower:Number = Math.pow(1.0 - te, m_Cnt - 1);
		var it:Number = 0.0;
		var step:Number = (tlast - tfirst) / (m_Cnt - 1);

		var boff:int = 0;
		for (i = 1; i < m_Cnt; i++) boff += i;

		var td:Number;
		for (i = 0; i < m_Cnt; i++) {
			td = m_Bezier[boff + i] * tpower * m1topower;
			Get(tfirst + it, m_TPos);
			out.x += m_TPos.x * td;
			out.y += m_TPos.y * td;
			out.z += m_TPos.z * td;

			it += step;
			tpower = tpower * te;
			m1topower = m1topower * m1to;
		}
	}

	public function LastTime():Number
	{
		if (m_Cnt <= 0) return 0.0;
		return m_List[m_Cur << 2];
	}

	public function LastValue(out:Vector3D):void
	{
		if (m_Cnt <= 0) return;
		out.x = m_List[(m_Cur << 2) + 1];
		out.y = m_List[(m_Cur << 2) + 2];
		out.z = m_List[(m_Cur << 2) + 3];
	}

	public function LastAngle():Number
	{
		if (m_Cnt <= 0) return 0.0;
		return m_List[(m_Cur << 2) + 1];
	}

	public function Begin():int
	{
		var i:int = m_Cur - m_Cnt + 1;
		if (i < 0) i = m_Max + i;
		return i;
	}
}
	
}