// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base.*;
import flash.display3D.textures.Texture;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.utils.*;

public class HyperspaceEngine
{
	public var HS:HyperspaceBase = null;
	
	static public var m_EmptyFirst:HyperspaceEngineParticle = null;
	static public var m_EmptyLast:HyperspaceEngineParticle = null;

	public var m_First:HyperspaceEngineParticle = null;
	public var m_Last:HyperspaceEngineParticle = null;

	public var m_FirstPP:HyperspaceEngineParticle = null;
	public var m_LastPP:HyperspaceEngineParticle = null;

	public var m_Timer:Number = 0;

	public var m_Pos:Vector3D = new Vector3D();
	public var m_Dir:Vector3D = new Vector3D();
	public var m_Up:Vector3D = new Vector3D();
	
	public var m_Matrix:Matrix3D = new Matrix3D();

	public var m_Size:Number = 0;
	public var m_Power:Number = 0;
	public var m_Super:Number = 0;
	public var m_Alpha:Number = 1.0;
	
	public var tin:Vector.<Number> = new Vector.<Number>(3, true);
	public var tout:Vector.<Number> = new Vector.<Number>(3, true);
	
	public var m_Rnd:PRnd = new PRnd();

	public var m_QuadBatch:C3DQuadBatch = new C3DQuadBatch();
	
	public var m_Trace:HyperspaceEngineParticle = null;
	
	public function HyperspaceEngine(hs:HyperspaceBase)
	{
		HS = hs;
		m_Rnd.Set(getTimer()); //  Common.GetTime()
		m_Rnd.RndEx();
	}
	
	public function free():void
	{
		m_QuadBatch.free();
	}
	
	public function PAdd(pp:Boolean=false):HyperspaceEngineParticle 
	{
		var p:HyperspaceEngineParticle = m_EmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_EmptyLast == p) m_EmptyLast = HyperspaceEngineParticle(p.m_Prev);
			if (m_EmptyFirst == p) m_EmptyFirst = HyperspaceEngineParticle(p.m_Next);
		} else {
			p = new HyperspaceEngineParticle();
		}
		if (pp) {
			if (m_LastPP != null) m_LastPP.m_Next = p;
			p.m_Prev = m_LastPP;
			p.m_Next = null;
			m_LastPP = p;
			if (m_FirstPP == null) m_FirstPP = p;

		} else {
			if (m_Last != null) m_Last.m_Next = p;
			p.m_Prev = m_Last;
			p.m_Next = null;
			m_Last = p;
			if (m_First == null) m_First = p;
		}
		return p;
	}

	public function PDel(p:HyperspaceEngineParticle, pp:Boolean = false):void
	{
		if (pp) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_LastPP == p) m_LastPP = HyperspaceEngineParticle(p.m_Prev);
			if (m_FirstPP == p) m_FirstPP = HyperspaceEngineParticle(p.m_Next);
		} else {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_Last == p) m_Last = HyperspaceEngineParticle(p.m_Prev);
			if (m_First == p) m_First = HyperspaceEngineParticle(p.m_Next);
		}

		p.Clear();

		if (m_EmptyLast != null) m_EmptyLast.m_Next = p;
		p.m_Prev = m_EmptyLast;
		p.m_Next = null;
		m_EmptyLast = p;
		if (m_EmptyFirst == null) m_EmptyFirst = p;
	}
	
	public function Init(posx:Number, posy:Number, posz:Number,
		_dirx:Number, _diry:Number, _dirz:Number,
		upx:Number, upy:Number, upz:Number,
		size:Number, power:Number, supper:Number, color:uint):void
	{
		m_Pos.x = posx; m_Pos.y = posy; m_Pos.z = posz; m_Pos.w = 1.0;
		m_Dir.x = _dirx; m_Dir.y = _diry; m_Dir.z = _dirz;
		m_Up.x = upx; m_Up.y = upy; m_Up.z = upz;
		m_Size = size;
		m_Power = power;
		m_Super = supper;
		
		m_Dir.normalize();
		
		var dirx:Vector3D = m_Dir.crossProduct(m_Up);
		dirx.normalize();
		m_Up = m_Dir.crossProduct(dirx);
		m_Up.normalize();
		
		var m:Matrix3D = new Matrix3D(new <Number>[
			m_Matrix.rawData[0], m_Matrix.rawData[1], m_Matrix.rawData[2], m_Matrix.rawData[3],
			m_Matrix.rawData[4], m_Matrix.rawData[5], m_Matrix.rawData[6], m_Matrix.rawData[7],
			m_Matrix.rawData[8], m_Matrix.rawData[9], m_Matrix.rawData[10], m_Matrix.rawData[11],
			0.0, 0.0, 0.0, 1.0
			]);
		
		m_Matrix.copyRawDataFrom(new <Number>[
			dirx.x, dirx.y, dirx.z, 0.0,
			m_Up.x, m_Up.y, m_Up.z, 0.0,
			m_Dir.x, m_Dir.y, m_Dir.z, 0.0,
			0.0, 0.0, 0.0, 1.0]);
		
		var p:HyperspaceEngineParticle = m_First;
		if (p != null || m_FirstPP != null) {
			var mi:Matrix3D = new Matrix3D();
			mi.copyFrom(m_Matrix);
			mi.invert();
			m.append(mi);

			while (p != null) {
				tin[0] = p.m_MovePosX;
				tin[1] = p.m_MovePosY;
				tin[2] = p.m_MovePosZ;
				m.transformVectors(tin, tout);
				p.m_MovePosX = tout[0];
				p.m_MovePosY = tout[1];
				p.m_MovePosZ = tout[2];
//var d:Number = (p.m_MovePosX - tin[0]) * (p.m_MovePosX - tin[0]) + (p.m_MovePosY - tin[1]) * (p.m_MovePosY - tin[1]) + (p.m_MovePosZ - tin[2]) * (p.m_MovePosZ - tin[2]);
//if(d > 0.1) trace(Math.sqrt(d));
//				p.m_MovePosX += 100.0;

				p = HyperspaceEngineParticle(p.m_Next);
			}
			
			p = m_FirstPP;
			while (p != null) {
				tin[0] = p.m_MovePosX;
				tin[1] = p.m_MovePosY;
				tin[2] = p.m_MovePosZ;
				m.transformVectors(tin, tout);
				p.m_MovePosX = tout[0];
				p.m_MovePosY = tout[1];
				p.m_MovePosZ = tout[2];

				p = HyperspaceEngineParticle(p.m_Next);
			}
		}
	}

	static public const gicc:Vector.<Number> = new <Number>[ 200.0, 128.0, 128.0, 64.0 ];
	//static public const gicc:Vector.<Number> = new <Number>[ 255.0, 200.0, 200.0, 128.0 ];
	static public const gict:Vector.<Number> = new <Number>[ 0.0, 0.15, 0.5, 1.0 ];
	static public const gis:Vector.<Number> =  new <Number>[ 0.5, 1.0, 0.6, 0.3, 0.0 ];
	static public const gis2:Vector.<Number> = new <Number>[ 0.6, 1.0, 0.6, 0.6, 0.4, 0.5, 0.0 ];

	public function Takt(ms:Number):void
	{
		var i:int;
		var k:Number, a:Number, r:Number, size:Number;
		var p:HyperspaceEngineParticle, pnext:HyperspaceEngineParticle;

		m_Matrix.copyColumnFrom(3, m_Pos);
		//m_Matrix.copyRowFrom(3, m_Pos);

		var mv:Matrix3D = HS.m_MatViewInv;
		var dx:Number = mv.rawData[1 * 4 + 0];
		var dy:Number = mv.rawData[1 * 4 + 1];
		var dz:Number = mv.rawData[1 * 4 + 2];

		var nx:Number = mv.rawData[2 * 4 + 0];
		var ny:Number = mv.rawData[2 * 4 + 1];
		var nz:Number = mv.rawData[2 * 4 + 2];

		m_Timer -= ms;
		while (m_Timer <= 0) {
			m_Timer += 40;

			for (i = 0; i < 5/*5*/; i++) {
				if (m_Rnd.Rnd(0, 100) < 3) continue;
//if(i != 2) continue;
				p = PAdd();
				p.m_Flag |= C3DParticle.FlagShow | C3DParticle.FlagColorAdd;
				p.m_TTL = 0.0;

				k = m_Rnd.RndFloat(0.0, 1.0);
				a = m_Rnd.RndFloat( -Math.PI, Math.PI);
				
				if(i==0) {
					p.m_Type = 0;
					r = k * 1.0;
					p.m_MovePosX = r * Math.sin(a);
					p.m_MovePosY = r * Math.cos(a);
					p.m_MovePosZ = 0.0;
					p.m_Alpha = 0.5;// 0.3;
					p.m_Size = 130.0 * m_Size * 1.5;
					p.m_Life = 390.0 * m_Size;

					p.m_U1 = 0.25 * 1.0;
					p.m_V1 = 0.25 * 0.0;
					p.m_U2 = p.m_U1 + 0.25;
					p.m_V2 = p.m_V1 + 0.25;
					
					if (m_Trace == null) m_Trace = p;
				} else {
					p.m_Type = 1;
					r = k * 2.0;
					p.m_MovePosX = r * Math.sin(a);
					p.m_MovePosY = r * Math.cos(a);
					p.m_MovePosZ = m_Rnd.RndFloat(0.0, 10.0);
//trace(p.m_MovePosZ);
					p.m_Alpha = 1.0;// 0.8;
					if(i==2) {
						p.m_Size = 26.0 * m_Size * 1.2;
						p.m_Life = 520.0 * m_Size;
					} else {
						p.m_Type = 2;
						p.m_Size = 10.0 * m_Size * 2.0;
						p.m_Life = 650.0 * m_Size;
					}

					p.m_U1 = 0.25 * 2.0;
					p.m_V1 = 0.25 * 3.0;
					p.m_U2 = p.m_U1 + 0.25;
					p.m_V2 = p.m_V1 + 0.25;
				}

				p.m_Alpha *= BaseMath.C2Rn(m_Power, 0.0, 1.0, 0.6, 1.0) * BaseMath.C2Rn(m_Super, 0.0, 1.0, 1.0, 0.8);
				p.m_Life *= BaseMath.C2Rn(m_Power, 0.0, 1.0, 0.5, 1.0) * BaseMath.C2Rn(m_Super, 0.0, 1.0, 1.0, 1.5);
				p.m_Size *= BaseMath.C2Rn(m_Super, 0.0, 1.0, 1.0, 1.5);
			}

			for (i = 0; i < 1; i++) {
				p = PAdd(true);
				p.m_Flag |= C3DParticle.FlagShow | C3DParticle.FlagColorAdd;
				p.m_TTL = 0.0;
				
				k = m_Rnd.RndFloat(0.0, 1.0);
				a = m_Rnd.RndFloat( -Math.PI, Math.PI);

				r = k * 10.0;
				p.m_MovePosX = r * Math.sin(a);
				p.m_MovePosY = r * Math.cos(a);
				p.m_MovePosZ = 0.0;
				p.m_Alpha = 1.0;
				p.m_Size = 30.0 * m_Size * 2.0;
				p.m_Life = 700.0 * m_Size;

				p.m_U1 = 0.25 * 2.0;
				p.m_V1 = 0.25 * 3.0;
				p.m_U2 = p.m_U1 + 0.25;
				p.m_V2 = p.m_V1 + 0.25;

				p.m_Alpha *= BaseMath.C2Rn(m_Power, 0.0, 1.0, 0.6, 1.0) * BaseMath.C2Rn(m_Super, 0.0, 1.0, 1.0, 0.8);
				p.m_Life *= BaseMath.C2Rn(m_Power, 0.0, 1.0, 0.5, 1.0) * BaseMath.C2Rn(m_Super, 0.0, 1.0, 1.0, 1.5);
				p.m_Size *= BaseMath.C2Rn(m_Super, 0.0, 1.0, 1.0, 1.5);
			}
		}

		var cnt:int = 0;
		pnext = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = HyperspaceEngineParticle(pnext.m_Next);
			
			p.m_TTL += ms;
			if (p.m_TTL >= p.m_Life) {
				if (p == m_Trace) m_Trace = null;
				PDel(p);
				continue;
			}

			size = p.m_Size;
			if (p.m_Type == 0) size *= BaseMath.Interpolate_n(gis, p.m_TTL / p.m_Life);
			else size *= BaseMath.Interpolate_n(gis2, p.m_TTL / p.m_Life);

			p.m_MovePosZ += 0.2 * ms;

			tin[0] = p.m_MovePosX;
			tin[1] = p.m_MovePosY;
			tin[2] = p.m_MovePosZ;
			m_Matrix.transformVectors(tin, tout);
			p.m_PosX = tout[0] - dx * size * 0.5;
			p.m_PosY = tout[1] - dy * size * 0.5;
			p.m_PosZ = tout[2] - dz * size * 0.5;
			p.m_NormalX = nx;
			p.m_NormalY = ny;
			p.m_NormalZ = nz;
			p.m_DirX = dx;
			p.m_DirY = dy;
			p.m_DirZ = dz;
			p.m_Width = size;
			p.m_Height = size;

			if (p.m_Type == 2) {
				p.m_Color = 0xffffff | (uint(Math.floor(255.0 * p.m_Alpha * m_Alpha)) << 24);
			} else {
//if((p.m_TTL / p.m_Life) > 0.3 && (p.m_TTL / p.m_Life) < 0.4) {
//	trace("test");
//}
				a = BaseMath.InterpolateKeys_n(gicc, gict, p.m_TTL / p.m_Life);
//if(m_Trace == p) trace(p.m_TTL / p.m_Life, a);
				p.m_Color = 0xff7c2e | (uint(Math.floor(a * p.m_Alpha * m_Alpha)) << 24);
			}
			p.m_ColorTo = p.m_Color;
			
			cnt++;
		}
//trace(cnt);
//		if (m_Trace != null) trace("Trace ttl=" + m_Trace.m_TTL.toString() + " MovePos=" + m_Trace.m_MovePosX.toString() + "," + m_Trace.m_MovePosY.toString() + "," + m_Trace.m_MovePosZ.toString() + " Pos=" + m_Trace.m_PosX.toString() + "," + m_Trace.m_PosY.toString() + "," + m_Trace.m_PosZ.toString());
		
		pnext = m_FirstPP;
		while (pnext) {
			p = pnext;
			pnext = HyperspaceEngineParticle(pnext.m_Next);

			p.m_TTL += ms;
			if (p.m_TTL >= p.m_Life) {
				if (p == m_Trace) m_Trace = null;
				PDel(p,true);
				continue;
			}

			size = p.m_Size;
			size *= BaseMath.Interpolate_n(gis2, p.m_TTL / p.m_Life);

			p.m_MovePosZ += 0.2 * ms;

			tin[0] = p.m_MovePosX;
			tin[1] = p.m_MovePosY;
			tin[2] = p.m_MovePosZ;
			m_Matrix.transformVectors(tin, tout);
			p.m_PosX = tout[0] - dx * size * 0.5;
			p.m_PosY = tout[1] - dy * size * 0.5;
			p.m_PosZ = tout[2] - dz * size * 0.5;
			p.m_NormalX = nx;
			p.m_NormalY = ny;
			p.m_NormalZ = nz;
			p.m_DirX = dx;
			p.m_DirY = dy;
			p.m_DirZ = dz;
			p.m_Width = size;
			p.m_Height = size;

			p.m_Color = 0xffffff | (uint(Math.floor(255.0 * p.m_Alpha)) << 24);
			p.m_ColorTo = p.m_Color;
		}
	}
	
	public function Draw():void
	{
		if (m_First == null) return;
		
		var t_dif:C3DTexture = C3D.GetTexture("effect/motor0.png");
		if (t_dif.tex == null) return;

//m_QuadBatch = new C3DQuadBatch();
		m_First.ToQuadBatch(false,m_QuadBatch);

		C3D.SetVConstMatrix(0, HS.m_MatViewPer);
		C3D.SetVConst_n(8, -HS.m_CamPos.x, -HS.m_CamPos.y, -HS.m_CamPos.z, 1.0);

		C3D.ShaderParticle();

		C3D.SetTexture(0, t_dif.tex);
		
		C3D.VBQuadBatch(m_QuadBatch);
		
		C3D.DrawQuadBatch();
		
		C3D.SetTexture(0, null);
	}

	public function DrawOld():void
	{
		var p:HyperspaceEngineParticle = new HyperspaceEngineParticle();

		p.m_Flag |= C3DParticle.FlagShow | C3DParticle.FlagColorAdd;

		p.m_DirX = HS.m_MatViewInv.rawData[1 * 4 + 0];
		p.m_DirY = HS.m_MatViewInv.rawData[1 * 4 + 1];
		p.m_DirZ = HS.m_MatViewInv.rawData[1 * 4 + 2];

		p.m_NormalX = HS.m_MatViewInv.rawData[2 * 4 + 0];
		p.m_NormalY = HS.m_MatViewInv.rawData[2 * 4 + 1];
		p.m_NormalZ = HS.m_MatViewInv.rawData[2 * 4 + 2];

		p.m_Width = 500.0;
		p.m_Height = 200.0;

		p.m_U1 = 0.0;
		p.m_V1 = 0.0;
		p.m_U2 = 1.0;
		p.m_V2 = 1.0;

		p.m_PosX = 0.0 - p.m_DirX * 200.0 * 0.5;
		p.m_PosY = 0.0 - p.m_DirY * 200.0 * 0.5;
		p.m_PosZ = 0.0 - p.m_DirZ * 200.0 * 0.5;

		p.m_Color = 0x8fffffff;
		p.m_ColorTo = 0x8fffffff;

		var qb:C3DQuadBatch = new C3DQuadBatch();
		p.ToQuadBatch(false,qb);
		
		var t_dif:C3DTexture = C3D.GetTexture("xy.png");
		if (t_dif.tex == null) return;

		C3D.SetVConstMatrix(0, HS.m_MatViewPer);
		C3D.SetVConst_n(8, -HS.m_CamPos.x, -HS.m_CamPos.y, -HS.m_CamPos.z, 1.0);

		C3D.ShaderParticle();

		C3D.SetTexture(0, t_dif.tex);
		
		C3D.VBQuadBatch(qb);
		
		C3D.DrawQuadBatch();
		
		C3D.SetTexture(0, null);
	}
}

}

import Engine.*;

class HyperspaceEngineParticle extends C3DParticle
{
	public var m_MovePosX:Number = 0;
	public var m_MovePosY:Number = 0;
	public var m_MovePosZ:Number = 0;
	public var m_TTL:Number = 0;
	public var m_Alpha:Number = 0;
	public var m_Size:Number = 0;
	public var m_Life:Number = 0;
	public var m_Type:Number = 0;

	public function HyperspaceEngineParticle():void
	{
	}

	public function Clear():void
	{
		//ClearData();
		m_MovePosX = 0;
		m_MovePosY = 0;
		m_MovePosZ = 0;
		m_TTL = 0;
		m_Alpha = 0;
		m_Size = 0;
		m_Life = 0;
		m_Type = 0;
	}
}

