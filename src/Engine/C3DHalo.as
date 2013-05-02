// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.events.Event;
import flash.geom.Matrix3D;

public class C3DHalo
{
	public var m_VB:VertexBuffer3D = null;
	public var m_IB:IndexBuffer3D = null;

	public var m_EventOk:Boolean = false;

	public var m_CntSec:int = 64; // Должно быть четным
	public var m_CntRing:int = 12;

	public function C3DHalo():void
	{
	}
	
	public function Clear():void
	{
		m_VB = null;
		m_IB = null;
		if (m_EventOk) {
			m_EventOk = false;
			C3D.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}

	public function Context3DCreate(e:Event):void
	{
		Clear();
	}
	
	public function InitBufs():void
	{
		Clear();
		
		var cntver:int = (1 + m_CntRing) * (m_CntSec);
		var cntind:int = (m_CntRing * 2 * m_CntSec) * 3;

		var il:Vector.<uint> = new Vector.<uint>(cntind);

		var i:int, u:int;
		var ind:int = 0;
		for (i = 0; i < m_CntSec - 1; i++) {
			for (u = 0; u < m_CntRing; u++) {
				il[ind++] = i * (m_CntRing + 1) + u;
				il[ind++] = i * (m_CntRing + 1) + u + 1;
				il[ind++] = i * (m_CntRing + 1) + u + m_CntRing + 1 + 1;

				il[ind++] = i * (m_CntRing + 1) + u;
				il[ind++] = i * (m_CntRing + 1) + u + m_CntRing + 1 + 1;
				il[ind++] = i * (m_CntRing + 1) + u + m_CntRing + 1;
			}
		}
		for (u = 0; u < m_CntRing; u++) {
			il[ind++] = i * (m_CntRing + 1) + u;
			il[ind++] = i * (m_CntRing + 1) + u + 1;
			il[ind++] = u + 1;

			il[ind++] = i * (m_CntRing + 1) + u;
			il[ind++] = u + 1;
			il[ind++] = u;
		}

		m_IB = C3D.Context.createIndexBuffer(cntind);
		m_IB.uploadFromVector(il, 0, cntind);
		
		m_VB = C3D.Context.createVertexBuffer(cntver, 4/* + 3*/ + 2);

		if (!m_EventOk) {
			m_EventOk = true;
			C3D.stage3D.addEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}
	
	public function Calc(/*d:Number, r:Number, size_inner:Number, size_outer:Number*/):void
	{
		if (m_VB != null) return;
		
		InitBufs();

//		if (size_inner < 0.0001) size_inner = 0.0001;
//		if (size_inner > 1.0) size_inner = 1.0;
//		if (size_outer < 0.0001) size_outer = 0.0001;

		var i:int, u:int;

		var cntver:int = (1 + m_CntRing) * (m_CntSec);

//		var a:Number = Math.acos(r / d);
//		var a2:Number = 0;

		var px:Number, py:Number, pz:Number;
		var nx:Number, ny:Number, nz:Number;

		var vd:Vector.<Number> = new Vector.<Number>(cntver * (4/* + 3*/ + 2));
		var off:int = 0;

//		var aaa:Number = Math.PI - (Math.PI - Math.PI * 0.5 - a) * (1.0 - size_inner);
//		var oi:Object = IntersectSphere(0.0, 0.0, 0.0, r, 0.0, 0.0, d, 0.0, Math.sin(aaa), Math.cos(aaa));
//		if (oi == null) throw Error("Err");
//		var ti:Number = Number(oi);
//		py = 0.0 + Math.sin(aaa) * ti;
//		pz = d + Math.cos(aaa) * ti;
//		aaa = (a - Math.atan2(py, pz)) / (cntring - 1);
		
		var cosa:Number, sina:Number;

		var aas:Number=0.0;
		for (i = 0; i < m_CntSec; i++, aas += (Math.PI * 2.0) / m_CntSec) {
			cosa = Math.cos(aas);
			sina = -Math.sin(aas);

			for (u = 0; u < m_CntRing - 1; u++) {
				//a2 = a - aaa * Number(cntring - 1 - u);
				//ny = Math.sin(a2);
				//nz = Math.cos(a2);

				if (u == 0) {
					vd[off++] = -Math.sin(aas + 0.5 * (Math.PI * 2.0) / m_CntSec);
					vd[off++] = Math.cos(aas + 0.5 * (Math.PI * 2.0) / m_CntSec);
				} else {
					vd[off++] = sina;
					vd[off++] = cosa;
				}
				vd[off++] = Number(m_CntRing - 1 - u);
				vd[off++] = 0.0;
				//vd[off++] = 0.0;
				//vd[off++] = 0.0;
				//vd[off++] = ny * sina * r;
				//vd[off++] = ny * cosa * r;
				//vd[off++] = nz * r;
				//vd[off++] = ny * sina;
				//vd[off++] = ny * cosa;
				//vd[off++] = nz;
				//vd[off++] = u & 1;
				//vd[off++] = i & 1;
				vd[off++] = 0.5 * Number(u) / (m_CntRing - 1 - 1);
				vd[off++] = 0.0;
				//else if (i & 1) vd[off++] = 1.0;
				//else vd[off++] = 0.0;
//trace("Sec:", i, "z:", Number(m_CntRing - 1 - u), "uv:", vd[off - 2], vd[off - 1]);
			}

			// cntring-1
			//ny = Math.sin(a);
			//nz = Math.cos(a);

			vd[off++] = sina;
			vd[off++] = cosa;
			vd[off++] = 0.0;
			vd[off++] = 0.0;
			//vd[off++] = 0.0;
			//vd[off++] = 0.0;
			//vd[off++] = ny * sina * r;
			//vd[off++] = ny * cosa * r;
			//vd[off++] = nz * r;
			//vd[off++] = ny * sina;
			//vd[off++] = ny * cosa;
			//vd[off++] = nz;
//			vd[off++] = (cntring-1) & 1;
//			vd[off++] = i & 1;
			vd[off++] = 0.5;
			vd[off++] = 0.0;
			//if (i & 1) vd[off++] = 1.0;
			//else vd[off++] = 0.0;
//trace("Sec:", i, "z: -", "uv:", vd[off - 2], vd[off - 1]);

			// cntring
			//ny = Math.sin(a);
			//nz = Math.cos(a);

			vd[off++] = sina;
			vd[off++] = cosa;
			vd[off++] = 0.0;
			vd[off++] = 1.0;
			//vd[off++] = 0.0;
			//vd[off++] = 0.0;
//			vd[off++] = ny * sina * (r+size_outer);
//			vd[off++] = ny * cosa * (r+size_outer);
//			vd[off++] = nz * (r+size_outer); // r
//			vd[off++] = ny * sina;
//			vd[off++] = ny * cosa;
//			vd[off++] = nz;
//			vd[off++] = (cntring) & 1;
//			vd[off++] = i & 1;
			vd[off++] = 1.0;
			vd[off++] = 0.0;
//			if (i & 1) vd[off++] = 1.0;
//			else vd[off++] = 0.0;
//trace("Sec:", i, "z: =", "uv:", vd[off - 2], vd[off - 1]);
		}
		if (off != vd.length) throw Error("Err");

/*		var addr:Number;
		off = 0;
		for (i = 0; i < cntver; i++) {
			sina = vd[off + 0];
			cosa = vd[off + 1];
			a2 = vd[off + 2];
			addr = vd[off + 3];
			
			a2 = a - aaa * a2;
			ny = Math.sin(a2);
			nz = Math.cos(a2);
			vd[off + 0] = ny * sina * (r + addr * size_outer);
			vd[off + 1] = ny * cosa * (r + addr * size_outer);
			vd[off + 2] = nz * (r + addr * size_outer);
			vd[off + 3] = ny * sina;
			vd[off + 4] = ny * cosa;
			vd[off + 5] = nz;

			off += 8;
		}*/

		m_VB.uploadFromVector(vd, 0, cntver);
	}
	
	public function Draw(mwvp:Matrix3D, d:Number, r:Number, size_inner:Number, size_outer:Number, clr:uint, forplanet:Boolean):void
	{
		Calc();// d, r, size_inner, size_outer);
		
		var py:Number, pz:Number;

		if (size_inner < 0.0001) size_inner = 0.0001;
		if (size_inner > 1.0) size_inner = 1.0;
		if (size_outer < 0.0001) size_outer = 0.0001;

		var a:Number = Math.acos(r / d);

		var aaa:Number = Math.PI - (Math.PI - Math.PI * 0.5 - a) * (1.0 - size_inner);
		var oi:Object = Space.IntersectSphere(0.0, 0.0, 0.0, r, 0.0, 0.0, d, 0.0, Math.sin(aaa), Math.cos(aaa));
		if (oi == null) throw Error("Err");
		var ti:Number = Number(oi);
		py = 0.0 + Math.sin(aaa) * ti;
		pz = d + Math.cos(aaa) * ti;
		aaa = (a - Math.atan2(py, pz)) / (m_CntRing - 1);

		C3D.ShaderHalo(forplanet);
		C3D.VBHalo(this);
		
		C3D.SetVConstMatrix(0, mwvp);
		C3D.SetVConst_n(4, 0.0, 0.5, 1.0, 2.0);
		C3D.SetVConst_n(5, a, aaa, r, size_outer);
		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(4, 
			Number((clr >> 16) & 255) / 255.0, 
			Number((clr >> 8) & 255) / 255.0, 
			Number((clr) & 255) / 255.0, 
			Number((clr >> 24) & 255) / 255.0);

		C3D.Context.drawTriangles(m_IB);
	}
}

}
