// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
	
import Base.*;
import flash.geom.*;
import flash.utils.*;
	
public class HyperspaceDust
{
	public static const CellSize:Number = 2000.0;
	public static const MovePeriod:Number = 120 * 1000.0;
	
	public var HS:HyperspaceBase = null;
	
	public var m_QB:C3DQuadBatch = new C3DQuadBatch();
	
	public var m_Texture:C3DTexture = null;
	
	public var m_Animate:Boolean = true;
	
	public var m_Time:Number = 0;
	public var m_LastTime:Number = 0;
	
	public function HyperspaceDust(hs:HyperspaceBase):void
	{
		HS = hs;
	}

	public function Clear():void
	{
		m_QB.free();
	}
	
	public function QBInit():void
	{
		var i:int;
		var px:Number, py:Number, pz:Number;
		var scalex:Number, scaley:Number, centerx:Number, centery:Number;
		var b1x:Number, b1y:Number, b2x:Number, b2y:Number, b3x:Number, b3y:Number, b4x:Number, b4y:Number;
		var u1:Number, v1:Number, u2:Number, v2:Number;
		var ax:int, ay:int;

		var pcnt:int = 1000;
		m_QB.InitRaw(pcnt, 3, 0, 2, -1, 2);
		var w:ByteArray = m_QB.m_Raw;
		w.position = 0;
		
		var clr:uint;

		for (i = 0; i < pcnt; i++) {
			px = Math.random() * CellSize;
			py = Math.random() * CellSize;
			pz = Math.random();

			while(true) {
				ax = Math.floor(Math.random() * 4.0);
				ay = Math.floor(Math.random() * 4.0);
				if (ax == 2 && ay == 0) continue;
				if (ax == 3 && ay == 0) continue;
				u1 = 0.25 * ax;
				v1 = 0.25 * ay;
				u2 = u1 + 0.25;
				v2 = v1 + 0.25;
				break;
			}

			scalex = Math.random() * 2 + 8;
			scaley = scalex;
			centerx = 0.5;
			centery = 0.5;

			b1x = (centerx - 0.5) * scalex;
			b1y = (centery + 0.5) * scaley;
			b2x = (centerx - 0.5) * scalex;
			b2y = (centery - 0.5) * scaley;
			b3x = (centerx + 0.5) * scalex;
			b3y = (centery - 0.5) * scaley;
			b4x = (centerx + 0.5) * scalex;
			b4y = (centery + 0.5) * scaley;
			
			clr = 0x6fffffff;

			// 1
			w.writeFloat(px);
			w.writeFloat(py);
			w.writeFloat(pz);
			w.writeFloat(u1); // u
			w.writeFloat(v1); // v
			w.writeUnsignedInt(clr);
			w.writeFloat(b1x);
			w.writeFloat(b1y);

			// 2
			w.writeFloat(px);
			w.writeFloat(py);
			w.writeFloat(pz);
			w.writeFloat(u2); // u
			w.writeFloat(v1); // v
			w.writeUnsignedInt(clr);
			w.writeFloat(b2x);
			w.writeFloat(b2y);

			// 3
			w.writeFloat(px);
			w.writeFloat(py);
			w.writeFloat(pz);
			w.writeFloat(u2); // u
			w.writeFloat(v2); // v
			w.writeUnsignedInt(clr);
			w.writeFloat(b3x);
			w.writeFloat(b3y);

			// 4
			w.writeFloat(px);
			w.writeFloat(py);
			w.writeFloat(pz);
			w.writeFloat(u1); // u
			w.writeFloat(v2); // v
			w.writeUnsignedInt(clr);
			w.writeFloat(b4x);
			w.writeFloat(b4y);
		}

		m_QB.Apply();
	}
	
	public function Draw():void
	{
		var dt:Number = HS.m_CurTime-m_LastTime;
		m_LastTime = HS.m_CurTime;
		if (m_Animate) m_Time += dt;
		
		
		C3D.SetVConstMatrix(0, HS.m_MatViewPer);
		C3D.SetVConst_n(9, HS.m_View.x, HS.m_View.y, HS.m_View.z, 1.0);
		
		//C3D.SetVConst_n(9, HS.m_MatViewInv.rawData[3 * 4 + 0], HS.m_MatViewInv.rawData[3 * 4 + 1], HS.m_MatViewInv.rawData[3 * 4 + 2], 1.0);
		
		var dx:Number = HS.m_MatView.rawData[0 * 4 + 1];
		var dy:Number = HS.m_MatView.rawData[1 * 4 + 1];
		var dz:Number = HS.m_MatView.rawData[2 * 4 + 1];
		C3D.SetVConst_n(10, dx, dy, dz, 0.0);
		C3D.SetVConst_n(12, 1000.0, 1.0 / 1500.0, 0.0, 0.0);

		if (!m_QB.m_Raw) QBInit();
		if (!m_Texture) m_Texture = C3D.GetTexture("effect/motor0.png");

		if (!HS.PickWorldCoord(C3D.m_SizeX >> 1, C3D.m_SizeY >> 1, HyperspaceBase.m_TPos)) return;
		
		if (!m_Texture.tex) return;

		C3D.ShaderDust();

		C3D.SetTexture(0, m_Texture.tex);

		C3D.VBQuadBatch(m_QB);

		var cx:Number = Math.floor(HyperspaceBase.m_TPos.x / CellSize);
		var cy:Number = Math.floor(HyperspaceBase.m_TPos.y / CellSize);
		var kx:Number, ky:Number;
		
		var rnd:PRnd = new PRnd();;

		for (ky = -2; ky <= 2; ky++) {
			for (kx = -2; kx <= 2; kx++) {
				rnd.Set((kx + cx) * 123 + (ky + cy));
				rnd.RndEx();
				var px:Number = (kx + cx) * CellSize;
				var py:Number = (ky + cy) * CellSize;
				var pz:Number = 0.0;
				var zx:int = px / HS.m_ZoneSize;
				var zy:int = py / HS.m_ZoneSize;
				px -= zx * HS.m_ZoneSize;
				py -= zy * HS.m_ZoneSize;

				C3D.SetVConst_n(11, -1500.0, 3000.0, ((m_Time + rnd.Rnd(0, MovePeriod)) % MovePeriod) / MovePeriod, 0.0);

				var offx:Number = px - HS.m_CamPos.x + HS.m_ZoneSize * (zx - HS.m_CamZoneX);
				var offy:Number = py - HS.m_CamPos.y + HS.m_ZoneSize * (zy - HS.m_CamZoneY);
				var offz:Number = pz - (HS.m_CamPos.z);

				C3D.SetVConst_n(8, offx, offy, offz, 1.0);
				C3D.DrawQuadBatch();
			}
		}

		C3D.SetTexture(0, null);
	}
}
	
}