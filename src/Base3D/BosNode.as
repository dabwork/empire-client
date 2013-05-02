// Copyright (C) 2013 Elemental Games. All rights reserved.

package Base3D
{
	import Engine.*;
	import flash.geom.Vector3D;
	
public class BosNode
{
	public var m_A:Number = 0;
	public var m_B:Number = 0;
	public var m_C:Number = 0;
	public var m_D:Number = 0;

	public var m_Front:BosNode = null;
	public var m_Back:BosNode = null;

	public var m_ObjFront:BosObj = null;
	public var m_ObjBack:BosObj = null;
	
	public function BosNode():void
	{
	}
	
	public function Clear():void
	{
		m_Front = null;
		m_Back = null;
		m_ObjFront = null;
		m_ObjBack = null;
	}
	
	[Inline] final public function Classify(posx:Number, posy:Number, posz:Number):int
	{
		var v:Number = posx * m_A + posy * m_B + posz * m_C + m_D;
		if (v > 0.0001) return 1;
		else if (v < -0.0001) return -1;
		return 0;
	}
	
	public function Helper(ar:Array):void
	{
		var k:Number;
		var h:C3DHelper;
		var clr:uint = 0;
		
		if (m_ObjFront != null) {
			clr = 0xffff0000;
			if (Classify(m_ObjFront.m_X, m_ObjFront.m_Y, m_ObjFront.m_Z) < 0) clr = 0xffffff00;
			
			k = Math3D.PlaneIntersectLine(m_A, m_B, m_C, m_D, m_ObjFront.m_X, m_ObjFront.m_Y, m_ObjFront.m_Z, m_A, m_B, m_C);
			if (!isNaN(k)) {
				h = new C3DHelper();
				h.Arrow(m_ObjFront.m_X, m_ObjFront.m_Y, m_ObjFront.m_Z,
					m_ObjFront.m_X + m_A * k,
					m_ObjFront.m_Y + m_B * k,
					m_ObjFront.m_Z + m_C * k, 1.0, 3.0, 10.0, clr);
				ar.push(h);
			}
		}

		if (m_ObjBack != null) {
			clr = 0xff00ff00;
			if (Classify(m_ObjBack.m_X, m_ObjBack.m_Y, m_ObjBack.m_Z) >= 0) clr = 0xffffff00;

			k = Math3D.PlaneIntersectLine(m_A, m_B, m_C, m_D, m_ObjBack.m_X, m_ObjBack.m_Y, m_ObjBack.m_Z, m_A, m_B, m_C);
			if (!isNaN(k)) {
				h = new C3DHelper();
				h.Arrow(m_ObjBack.m_X, m_ObjBack.m_Y, m_ObjBack.m_Z,
					m_ObjBack.m_X + m_A * k,
					m_ObjBack.m_Y + m_B * k,
					m_ObjBack.m_Z + m_C * k, 1.0, 3.0, 10.0, clr);
				ar.push(h);
			}
		}

		if (m_Front) m_Front.Helper(ar);
		if (m_Back) m_Back.Helper(ar);
	}
}
	
}