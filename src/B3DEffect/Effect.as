// Copyright (C) 2013 Elemental Games. All rights reserved.

package B3DEffect
{
import Base.*;
import Engine.*;
import flash.display3D.textures.Texture;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import utils.eg.HSVRGB;

public class Effect
{
	public var m_PosX:Number = 0;
	public var m_PosY:Number = 0;
	public var m_PosZ:Number = 0;

	public var m_DirX:Number = 0;
	public var m_DirY:Number = 0;
	public var m_DirZ:Number = 1.0;
	
	public var m_UpX:Number = 0;
	public var m_UpY:Number = 1.0;
	public var m_UpZ:Number = 0;

	public var m_PathDist:Number = 100.0;

	public var m_NormalX:Number = 0;
	public var m_NormalY:Number = 0;
	public var m_NormalZ:Number = 1.0;

	public var m_NormalUpX:Number = 0;
	public var m_NormalUpY:Number = 1.0;
	public var m_NormalUpZ:Number = 0;

	public var m_A:Number = 0.0;
	public var m_B:Number = 0.0;
	public var m_ASet:Boolean = false;
	public var m_BSet:Boolean = false;

	static public var m_EmptyFirst:EffectParticle = null;
	static public var m_EmptyLast:EffectParticle = null;

	public var m_First:EffectParticle = null;
	public var m_Last:EffectParticle = null;
	
	public var m_EmitterList:Vector.<Emitter> = new Vector.<Emitter>();

	public var m_Texture:C3DTexture = null;
	public var m_QuadBatch:C3DQuadBatch = new C3DQuadBatch();
	
	public var m_Frame:int = 0;
	public var m_TimeOst:Number = 0.0;
	public var m_FirstFrame:Boolean = true;
	
	public var m_StyleId:String = null;
	public var m_Style:Style = null;
	public var m_TextureStyle:TextureStyle = null;
	public var m_StyleVer:int = 0;

	public static var tin:Vector.<Number> = new Vector.<Number>(3, true);
	public static var tout:Vector.<Number> = new Vector.<Number>(3, true);

	public static var m_HSVRGB:HSVRGB = new HSVRGB();

	public function Effect():void
	{
	}

	public function SetPos(x:Number, y:Number, z:Number):void
	{
		m_PosX = x;
		m_PosY = y;
		m_PosZ = z;
	}

	public function SetDir(x:Number, y:Number, z:Number):void
	{
		m_DirX = x;
		m_DirY = y;
		m_DirZ = z;
	}

	public function SetUp(x:Number, y:Number, z:Number):void
	{
		m_UpX = x;
		m_UpY = y;
		m_UpZ = z;
	}

	public function SetPathDist(v:Number):void
	{
		m_PathDist = v;
	}

	public function SetNormal(x:Number, y:Number, z:Number, ux:Number, uy:Number, uz:Number):void
	{
		m_NormalX = x;
		m_NormalY = y;
		m_NormalZ = z;
		m_NormalUpX = ux;
		m_NormalUpY = uy;
		m_NormalUpZ = uz;
	}

	public function SetA(v:Number):void
	{
		m_A = v;
		m_ASet = true;
	}

	public function SetB(v:Number):void
	{
		m_B = v;
		m_BSet = true;
	}

	public function Clear():void
	{
		var i:int;
		var p:EffectParticle, pnext:EffectParticle;

		pnext = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = EffectParticle(pnext.m_Next);
			PDel(p);
		}

		for (i = 0; i < m_EmitterList.length; i++) {
			m_EmitterList[i].Clear();
		}
		m_EmitterList.length = 0;

		m_Texture = null;
		m_QuadBatch.free();

		m_Style = null;
		m_TextureStyle = null;
		m_Frame = 0;
		m_TimeOst = 0;
		m_FirstFrame = true;
	}

	public function PAdd():EffectParticle 
	{
		var p:EffectParticle = m_EmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_EmptyLast == p) m_EmptyLast = EffectParticle(p.m_Prev);
			if (m_EmptyFirst == p) m_EmptyFirst = EffectParticle(p.m_Next);
		} else {
			p = new EffectParticle();
		}
		if (m_Last != null) m_Last.m_Next = p;
		p.m_Prev = m_Last;
		p.m_Next = null;
		m_Last = p;
		if (m_First == null) m_First = p;
		return p;
	}

	public function PDel(p:EffectParticle):void
	{
		if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
		if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
		if (m_Last == p) m_Last = EffectParticle(p.m_Prev);
		if (m_First == p) m_First = EffectParticle(p.m_Next);

		p.Clear();

		if (m_EmptyLast != null) m_EmptyLast.m_Next = p;
		p.m_Prev = m_EmptyLast;
		p.m_Next = null;
		m_EmptyLast = p;
		if (m_EmptyFirst == null) m_EmptyFirst = p;
	}

	public function ParticleDirMulMatrix(mat:Matrix3D, for_postype:int, velocity:Boolean = false):void
	{
		var offx:Number = mat.rawData[3 * 4 + 0];
		var offy:Number = mat.rawData[3 * 4 + 1];
		var offz:Number = mat.rawData[3 * 4 + 2];

		var p:EffectParticle, pnext:EffectParticle;
		pnext = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = EffectParticle(pnext.m_Next);

			if (p.m_Emitter.m_EmitterStyle.m_PosType == for_postype) {
				tin[0] = p.m_BasePosX;
				tin[1] = p.m_BasePosY;
				tin[2] = p.m_BasePosZ;
				mat.transformVectors(tin, tout);
				p.m_BasePosX = tout[0];
				p.m_BasePosY = tout[1];
				p.m_BasePosZ = tout[2];

				if(velocity) {
					tin[0] = p.m_BaseDirX;
					tin[1] = p.m_BaseDirY;
					tin[2] = p.m_BaseDirZ;
					mat.transformVectors(tin, tout);
					p.m_BaseDirX = tout[0] - offx;
					p.m_BaseDirY = tout[1] - offy;
					p.m_BaseDirZ = tout[2] - offz;
				}
			}
		}
	}

	public function Run(styleid:String):void
	{
		Clear();

		m_StyleId = styleid;
	}

	public function GraphTakt(step:Number/*, dx:Number, dy:Number, dz:Number, vx:Number, vy:Number, vz:Number, nx:Number, by:Number, nz:Number*/):void
	{
		var i:int, u:int, amount:int;
		var a:Number, r:Number, v:Number, tn:Number, sinr:Number, cosr:Number;
		var em:Emitter;
		var es:EmitterStyle;
		var ef:EmitterFrame;
		var p:EffectParticle, pnext:EffectParticle;

		var init:Boolean = true;
		while (true) {
			if (m_Style == null) break;
			if (m_Style.m_Ver != m_StyleVer) break;

			init = false;
			break;
		}

		if (init) {
			m_StyleVer = -1;
			if (!StyleManager.prepare()) return;
			if (StyleManager.m_Map[m_StyleId] == undefined) return;
			m_Style = StyleManager.m_Map[m_StyleId];
			m_Style.Prepare();

			if (StyleManager.m_TextureMap[m_Style.m_Texture] == undefined) return;
			m_TextureStyle = StyleManager.m_TextureMap[m_Style.m_Texture];
			m_Texture = C3D.GetTexture(m_TextureStyle.m_Path);

			if (!m_ASet) m_A = m_Style.m_A;
			if (!m_BSet) m_B = m_Style.m_B;

			m_FirstFrame = true;

			for (i = 0; i < m_Style.m_EmitterList.length; i++) {
				es = m_Style.m_EmitterList[i];

				if (i < m_EmitterList.length) {
					em = m_EmitterList[i];
				} else {
					em = new Emitter();
					m_EmitterList.push(em);
				}
				em.m_EmitterStyle = es;
				em.m_ImgStyle = m_TextureStyle.ImgById(es.m_Img);

				if (es.m_FirstFrame) {
					pnext = m_First;
					while (pnext != null) {
						p = pnext;
						pnext = EffectParticle(pnext.m_Next);
						if (p.m_Emitter == em) PDel(p);
					}
				}
			}

			while (i < m_EmitterList.length) {
				em = m_EmitterList[i];
				em.Clear();
				m_EmitterList.splice(i, 1);

				pnext = m_First;
				while (pnext != null) {
					p = pnext;
					pnext = EffectParticle(pnext.m_Next);
					if (p.m_Emitter == em) PDel(p);
				}
			}

			m_StyleVer = m_Style.m_Ver;
		}

		if (m_Style == null) return;
		if (m_Texture == null) return;

		m_TimeOst += step;
		while (m_FirstFrame || (m_TimeOst >= m_Style.m_FrameTime)) {
			pnext = m_First;
			while (pnext != null) {
				p = pnext;
				pnext = EffectParticle(pnext.m_Next);

				es = p.m_Emitter.m_EmitterStyle;

				p.m_Age += m_Style.m_FrameTime;

				if (es.m_FirstFrame && es.m_Loop) {
					tn = Number(p.m_Age % Math.max(1, es.m_Period)) / Math.max(1.0, es.m_Period);
				} else {
					if (p.m_Age > p.m_Life) {
						PDel(p);
						continue;
					}
					
					tn = p.m_Age / p.m_Life;
				}

				//v = p.m_Velocity;
				//if (es.m_VelocityOV != 0) v += es.m_VelocityOV;
				//if (es.m_VelocityOD != 0) v += es.m_VelocityOD * Style.IG(es.m_VelocityOG, tn);
				v = es.m_VelocityOV;
				if (es.m_VelocityOD != 0) v += es.m_VelocityOD * Style.IG(es.m_VelocityOG, tn);
				v *= p.m_Velocity;
				
				if (es.m_VelocityAAdd != 1 || es.m_VelocityAMul != 0) v *= es.m_VelocityAAdd + es.m_VelocityAMul * Math.pow(m_A, es.m_VelocityAPow);
				if (es.m_VelocityBAdd != 1 || es.m_VelocityBMul != 0) v *= es.m_VelocityBAdd + es.m_VelocityBMul * Math.pow(m_B, es.m_VelocityBPow);
				v *= 0.001 * m_Style.m_FrameTime;
//trace(p.m_Velocity, v);

				p.m_BasePosX += p.m_BaseDirX * v;
				p.m_BasePosY += p.m_BaseDirY * v;
				p.m_BasePosZ += p.m_BaseDirZ * v;
//trace(p.m_BasePosX,p.m_BasePosY,p.m_BasePosZ);
			}

			for (i = 0; i < m_EmitterList.length; i++) {
				em = m_EmitterList[i];
				if (em.m_ImgStyle == null || em.m_ImgStyle.m_UVList.length < 4) continue;
				es = em.m_EmitterStyle;
				if (es.m_Frame.length <= 0) continue;

				if (m_FirstFrame && es.m_FirstFrame) {
					ef = es.m_Frame[0];
				}
				else if (es.m_FirstFrame) continue;
				else if (es.m_Loop) {
					ef = es.m_Frame[m_Frame % es.m_Frame.length];

				} else {
					if (m_Frame >= es.m_Frame.length) continue;
					ef = es.m_Frame[m_Frame];
				}

				v = ef.m_Amount;
				if (es.m_FirstFrame) {
					if (es.m_AmountRV != 0) v += es.m_AmountRV;
				} else {
					if (es.m_AmountRV != 0) v += es.m_AmountRV / m_Style.m_FPS;
				}
				if (es.m_AmountRD != 0) v += ef.m_AmountR * Math.random();
				if (es.m_AmountAAdd != 1 || es.m_AmountAMul != 0) v *= es.m_AmountAAdd + es.m_AmountAMul * Math.pow(m_A, es.m_AmountAPow);
				if (es.m_AmountBAdd != 1 || es.m_AmountBMul != 0) v *= es.m_AmountBAdd + es.m_AmountBMul * Math.pow(m_B, es.m_AmountBPow);
				em.m_AmountOst += v;
				amount = Math.floor(em.m_AmountOst);
//trace(em.m_AmountOst, amount);
				em.m_AmountOst -= amount;
				for (u = 0; u < amount; u++) {
					p = PAdd();
					p.m_Flag = C3DParticle.FlagShow;
					if (es.m_ColorAdd) p.m_Flag |= C3DParticle.FlagColorAdd;

					p.m_Emitter = em;

					p.m_ImgNum = 0;
					if (es.m_ImgRnd) {
						p.m_ImgNum = Math.round(Math.random() * ((em.m_ImgStyle.m_UVList.length >> 2) - 1));
//trace(p.m_ImgNum);
					}

					p.m_U1 = em.m_ImgStyle.m_UVList[(p.m_ImgNum << 2) + 0];
					p.m_V1 = em.m_ImgStyle.m_UVList[(p.m_ImgNum << 2) + 1];
					p.m_U2 = em.m_ImgStyle.m_UVList[(p.m_ImgNum << 2) + 2];
					p.m_V2 = em.m_ImgStyle.m_UVList[(p.m_ImgNum << 2) + 3];

					if(m_TextureStyle.m_ChannelMask) {
						p.m_ColorMask = em.m_ImgStyle.m_MaskList[(p.m_ImgNum << 2) + 0];
						p.m_AlphaMask = em.m_ImgStyle.m_MaskList[(p.m_ImgNum << 2) + 1];
					}

					if (es.m_HeightType == 1 && es.m_ImgDist > 0) {
						p.m_V2 += 1.0 * m_PathDist / es.m_ImgDist;
					}

					p.m_CenterX = es.m_ImgCenterX * 0.5;
					p.m_CenterY = es.m_ImgCenterY * 0.5;
					p.m_ScaleX = es.m_ImgScaleX;
					p.m_ScaleY = es.m_ImgScaleY;

					p.m_Age = 0;
					p.m_Life = ef.m_Life;
					if (es.m_LifeRV != 0) p.m_Life += es.m_LifeRV;
					if (es.m_LifeRD != 0) p.m_Life += ef.m_LifeR * Math.random();
					if (es.m_LifeAAdd != 1 || es.m_LifeAMul != 0) p.m_Life *= es.m_LifeAAdd + es.m_LifeAMul * Math.pow(m_A, es.m_LifeAPow);
					if (es.m_LifeBAdd != 1 || es.m_LifeBMul != 0) p.m_Life *= es.m_LifeBAdd + es.m_LifeBMul * Math.pow(m_B, es.m_LifeBPow);
//trace("Life:", p.m_Life);

					p.m_BaseWidth = ef.m_Width;
					if (es.m_WidthRV != 0) p.m_BaseWidth += es.m_WidthRV;
					if (es.m_WidthRD != 0) p.m_BaseWidth += ef.m_WidthR * Math.random();

					p.m_Velocity = ef.m_Velocity;
					if (es.m_VelocityRV != 0) p.m_Velocity += es.m_VelocityRV;
					if (es.m_VelocityRD != 0) p.m_Velocity += ef.m_VelocityR * Math.random();

					p.m_BaseSpin = ef.m_Spin;
					if (es.m_SpinRV != 0) p.m_BaseSpin += es.m_SpinRV;
					if (es.m_SpinRD != 0) p.m_BaseSpin += ef.m_SpinR * Math.random();
//trace("BaseSpin:", p.m_BaseSpin);

					//a = Math.random() * 2.0 * Math.PI - Math.PI;
					//r = Math.random() * 2.0 * Math.PI - Math.PI;
					a = ef.m_Angle;
					if (es.m_AngleRV != 0) a += es.m_AngleRV;
					if (es.m_AngleRD != 0) a += ef.m_AngleR * Math.random();
					r = ef.m_Rotate;
					if (es.m_RotateRV != 0) r += es.m_RotateRV;
					if (es.m_RotateRD != 0) r += ef.m_RotateR * Math.random();
//trace(a, r);
					a *= Space.ToRad;
					r *= Space.ToRad;
					//tx = 0.0;
					//ty = sin(a);
					//tz = cos(a);
					//p.m_BaseDirX =  cos(r)*tx + sin(r)*ty;
					//p.m_BaseDirY = -sin(r)*tx + cos(r)*ty;
					//p.m_BaseDirZ = tz;
					p.m_BaseDirZ = Math.cos(a);
					a = Math.sin(a);
					sinr = Math.sin(r);
					cosr = Math.cos(r);
					p.m_BaseDirX = a * sinr;
					p.m_BaseDirY = a * cosr;

					r = 1.0 / Math.sqrt(p.m_BaseDirX * p.m_BaseDirX + p.m_BaseDirY * p.m_BaseDirY + p.m_BaseDirZ * p.m_BaseDirZ);
					p.m_BaseDirX *= r;
					p.m_BaseDirY *= r;
					p.m_BaseDirZ *= r;
//trace(p.m_BaseDirX,p.m_BaseDirY,p.m_BaseDirZ);

					if (es.m_PosType == 0) {
						v = ef.m_Radius;
						if (es.m_RadiusRV != 0) v += es.m_RadiusRV;
						if (es.m_RadiusRD != 0) v += ef.m_RadiusR * Math.random();
						if (es.m_RadiusAAdd != 1 || es.m_RadiusAMul != 0) v *= es.m_RadiusAAdd + es.m_RadiusAMul * Math.pow(m_A, es.m_RadiusAPow);
						if (es.m_RadiusBAdd != 1 || es.m_RadiusBMul != 0) v *= es.m_RadiusBAdd + es.m_RadiusBMul * Math.pow(m_B, es.m_RadiusBPow);

						p.m_BasePosX = p.m_BaseDirX * v;
						p.m_BasePosY = p.m_BaseDirY * v;
						p.m_BasePosZ = p.m_BaseDirZ * v;
					} else {
						v = ef.m_Radius;
						if (es.m_RadiusRV != 0) v += es.m_RadiusRV;
						if (es.m_RadiusRD != 0) v += ef.m_RadiusR * Math.random();
						if (es.m_RadiusAAdd != 1 || es.m_RadiusAMul != 0) v *= es.m_RadiusAAdd + es.m_RadiusAMul * Math.pow(m_A, es.m_RadiusAPow);
						if (es.m_RadiusBAdd != 1 || es.m_RadiusBMul != 0) v *= es.m_RadiusBAdd + es.m_RadiusBMul * Math.pow(m_B, es.m_RadiusBPow);

						p.m_BasePosX = sinr * v;
						p.m_BasePosY = cosr * v;
						p.m_BasePosZ = 0;
					}

					p.m_Offset = ef.m_Offset;
					if (es.m_OffsetRV != 0) v += es.m_OffsetRV;
					if (es.m_OffsetRD != 0) v += ef.m_OffsetR * Math.random();

					p.m_BaseColor = 0;

					p.m_BaseAlpha = ef.m_Alpha;
					if (es.m_AlphaRV != 0) p.m_BaseAlpha += es.m_AlphaRV;
					if (es.m_AlphaRD != 0) p.m_BaseAlpha += ef.m_AlphaR * Math.random();

/*					if (es.m_AlphaRV != 0 || es.m_AlphaRD != 0) {
						v = C3D.ClrToFloat * ((p.m_BaseColor >> 24) & 255);
						if (es.m_AlphaRV != 0) v += es.m_AlphaRV;
						if (es.m_AlphaRD != 0) v += ef.m_AlphaR * Math.random();
						if (v < 0) v = 0;
						else if (v > 1.0) v = 1.0;
						p.m_BaseColor = (uint(v * 255) << 24) | (p.m_BaseColor & 0xffffff);
					}
					if (es.m_HueRV != 0 || es.m_SatRV != 0 || es.m_BriRV != 0 || es.m_HueRD != 0 || es.m_SatRD != 0 || es.m_BriRD != 0) {
						m_HSVRGB.r = (p.m_BaseColor >> 16) & 255;
						m_HSVRGB.g = (p.m_BaseColor >> 8) & 255;
						m_HSVRGB.b = (p.m_BaseColor) & 255;
						m_HSVRGB.ToHSV();

						if (es.m_HueRV != 0) m_HSVRGB.h += es.m_HueRV * 360;
						if (es.m_HueRD != 0) m_HSVRGB.h += ef.m_HueR * Math.random() * 360;
						if (m_HSVRGB.h < 0) m_HSVRGB.h = 0;
						else if (m_HSVRGB.h > 360) m_HSVRGB.h = 360;

						if (es.m_SatRV != 0) m_HSVRGB.s += es.m_SatRV * 255;
						if (es.m_SatRD != 0) m_HSVRGB.s += ef.m_SatR * Math.random() * 255;
						if (m_HSVRGB.s < 0) m_HSVRGB.s = 0;
						else if (m_HSVRGB.s > 255) m_HSVRGB.s = 255;

						if (es.m_BriRV != 0) m_HSVRGB.v += es.m_BriRV * 255;
						if (es.m_BriRD != 0) m_HSVRGB.v += ef.m_BriR * Math.random() * 255;
						if (m_HSVRGB.v < 0) m_HSVRGB.v = 0;
						else if (m_HSVRGB.v > 255) m_HSVRGB.v = 255;

						m_HSVRGB.ToRGB();
						p.m_BaseColor = (p.m_BaseColor & 0xff000000) | (m_HSVRGB.r << 16) | (m_HSVRGB.g << 8) | (m_HSVRGB.b);
					}*/

//trace("DirLength:", Math.sqrt(p.m_BaseDirX * p.m_BaseDirX + p.m_BaseDirY * p.m_BaseDirY + p.m_BaseDirZ * p.m_BaseDirZ));
				}
			}

			if (m_FirstFrame) {
				m_FirstFrame = false;
			} 

			m_TimeOst -= m_Style.m_FrameTime;
			if (m_TimeOst < 0) m_TimeOst = 0;
			m_Frame++;
		}
	}
	
	public static var m_MatrixData:Vector.<Number> = new Vector.<Number>(16, true);

	public function Draw(curtime:Number, mvp:Matrix3D, view:Matrix3D, viewinv:Matrix3D, factor_scr2world_dist:Number, camposx:Number = 0.0, camposy:Number = 0.0, camposz:Number = 0.0):void
	{
		if (m_Texture == null) return;
		if (m_First == null) return;

		if (m_Texture.tex == null) return;

//		var dx:Number = viewinv.rawData[1 * 4 + 0];
//		var dy:Number = viewinv.rawData[1 * 4 + 1];
//		var dz:Number = viewinv.rawData[1 * 4 + 2];

//		var nx:Number = viewinv.rawData[2 * 4 + 0];
//		var ny:Number = viewinv.rawData[2 * 4 + 1];
//		var nz:Number = viewinv.rawData[2 * 4 + 2];

		var dx:Number = view.rawData[0 * 4 + 1];
		var dy:Number = view.rawData[1 * 4 + 1];
		var dz:Number = view.rawData[2 * 4 + 1];

		var nx:Number = view.rawData[0 * 4 + 2];
		var ny:Number = view.rawData[1 * 4 + 2];
		var nz:Number = view.rawData[2 * 4 + 2];

		var viewx:Number = viewinv.rawData[3 * 4 + 0];
		var viewy:Number = viewinv.rawData[3 * 4 + 1];
		var viewz:Number = viewinv.rawData[3 * 4 + 2];

		var tx:Number, ty:Number, tz:Number;

		var rx:Number, ry:Number, rz:Number;
		var ux:Number, uy:Number, uz:Number;
		var kx:Number, ky:Number, kz:Number;
		var r:Number;
		var lnx:Number, lny:Number, lnz:Number;

		var i:int, u:int, k:int;
		var em:Emitter;
		for (i = 0; i < m_EmitterList.length; i++) {
			em = m_EmitterList[i];

			if (em.m_EmitterStyle.m_PosType == 3) {
				kx = m_NormalX; ky = m_NormalY; kz = m_NormalZ;
				ux = m_NormalUpX; uy = m_NormalUpY; uz = m_NormalUpZ;
			} else if (em.m_EmitterStyle.m_PosType == 1) {
				kx = nx; ky = ny; kz = nz;
				ux = dx; uy = dy; uz = dz;
			} else {
				kx = m_DirX; ky = m_DirY; kz = m_DirZ;
				ux = m_UpX; uy = m_UpY; uz = m_UpZ;
			}

			rx = ky * uz - kz * uy;
			ry = kz * ux - kx * uz; 
			rz = kx * uy - ky * ux;
			r = 1.0 / Math.sqrt(rx * rx + ry * ry + rz * rz);
			rx *= r; ry *= r; rz *= r;

			ux = ky * rz - kz * ry;
			uy = kz * rx - kx * rz; 
			uz = kx * ry - ky * rx;
			r = 1.0 / Math.sqrt(ux * ux + uy * uy + uz * uz);
			ux *= r; uy *= r; uz *= r;

			m_MatrixData[0 * 4 + 0] = rx;
			m_MatrixData[0 * 4 + 1] = ry;
			m_MatrixData[0 * 4 + 2] = rz;
			m_MatrixData[0 * 4 + 3] = 0;

			m_MatrixData[1 * 4 + 0] = ux;
			m_MatrixData[1 * 4 + 1] = uy;
			m_MatrixData[1 * 4 + 2] = uz;
			m_MatrixData[1 * 4 + 3] = 0;

			m_MatrixData[2 * 4 + 0] = kx;
			m_MatrixData[2 * 4 + 1] = ky;
			m_MatrixData[2 * 4 + 2] = kz;
			m_MatrixData[2 * 4 + 3] = 0;
			
			m_MatrixData[3 * 4 + 0] = m_PosX + m_DirX * m_PathDist * em.m_EmitterStyle.m_PosPath;
			m_MatrixData[3 * 4 + 1] = m_PosY + m_DirY * m_PathDist * em.m_EmitterStyle.m_PosPath;
			m_MatrixData[3 * 4 + 2] = m_PosZ + m_DirZ * m_PathDist * em.m_EmitterStyle.m_PosPath;
			m_MatrixData[3 * 4 + 3] = 1;

			em.m_Matrix.copyRawDataFrom(m_MatrixData);

//			em.m_Matrix.identity();
//			em.m_Matrix.appendTranslation(m_PosX, m_PosY, m_PosZ);
		}
		
		var es:EmitterStyle;
		var tn:Number;
		var spin:Number;
		var v:Number;

		var p:EffectParticle, pnext:EffectParticle;
		pnext = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = EffectParticle(pnext.m_Next);

			es = p.m_Emitter.m_EmitterStyle;

			if (es.m_FirstFrame && es.m_Loop) {
				tn = Number(p.m_Age % Math.max(1, es.m_Period)) / Math.max(1, es.m_Period);
			} else {
				tn = p.m_Age / p.m_Life;
			}

			p.m_Width = p.m_BaseWidth;
			v = es.m_WidthOV;
			//if (es.m_WidthOV != 0) v += es.m_WidthOV;
			if (es.m_WidthOD != 0) v += es.m_WidthOD * Style.IG(es.m_WidthOG, tn);
			p.m_Width *= v;
			if (es.m_WidthAAdd != 1 || es.m_WidthAMul != 0) p.m_Width *= es.m_WidthAAdd + es.m_WidthAMul * Math.pow(m_A, es.m_WidthAPow);
			if (es.m_WidthBAdd != 1 || es.m_WidthBMul != 0) p.m_Width *= es.m_WidthBAdd + es.m_WidthBMul * Math.pow(m_B, es.m_WidthBPow);

			p.m_Spin = p.m_BaseSpin;
			if (es.m_SpinOV != 0) p.m_Spin += es.m_SpinOV;
			if (es.m_SpinOD != 0) p.m_Spin += es.m_SpinOD * Style.IG(es.m_SpinOG, tn);
			p.m_Spin *= Math.PI;
			
			v = p.m_Offset;
			if (es.m_OffsetOV != 0) p.m_Offset += es.m_OffsetOV;
			if (es.m_OffsetOD != 0) p.m_Offset += es.m_OffsetOD * Style.IG(es.m_OffsetOG, tn);
			if (es.m_OffsetAAdd != 1 || es.m_OffsetAMul != 0) p.m_Offset *= es.m_OffsetAAdd + es.m_OffsetAMul * Math.pow(m_A, es.m_OffsetAPow);
			if (es.m_OffsetBAdd != 1 || es.m_OffsetBMul != 0) p.m_Offset *= es.m_OffsetBAdd + es.m_OffsetBMul * Math.pow(m_B, es.m_OffsetBPow);

			tin[0] = p.m_BasePosX;
			tin[1] = p.m_BasePosY;
			tin[2] = p.m_BasePosZ;
			p.m_Emitter.m_Matrix.transformVectors(tin, tout);

			lnx = viewx - tout[0];
			lny = viewy - tout[1];
			lnz = viewz - tout[2];
			r = 1.0 / Math.sqrt(lnx * lnx + lny * lny + lnz * lnz);
			lnx *= r; lny *= r; lnz *= r;

			p.m_PosX = tout[0] + lnx * v;
			p.m_PosY = tout[1] + lny * v;
			p.m_PosZ = tout[2] + lnz * v;
//trace(p.m_PosX,p.m_PosY,p.m_PosZ);
			p.m_NormalX = lnx;
			p.m_NormalY = lny;
			p.m_NormalZ = lnz;

			if (es.m_WidthType == 1) {
				tx = -view.rawData[3 * 4 + 0] - p.m_PosX;
				ty = -view.rawData[3 * 4 + 1] - p.m_PosY;
				tz = -view.rawData[3 * 4 + 2] - p.m_PosZ;
				p.m_Width *= factor_scr2world_dist * Math.sqrt(tx * tx + ty * ty + tz * tz);
			}
			if (es.m_HeightType == 1) {
				p.m_DirX = m_DirX;
				p.m_DirY = m_DirY;
				p.m_DirZ = m_DirZ;
				p.m_Height = m_PathDist;
			} else {
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = dz;
				p.m_Height = p.m_Width;
			}

			if (es.m_ImgAnim && es.m_ImgSpeed != 0) {
				u = 0;
				k = Math.max(1, p.m_Emitter.m_ImgStyle.m_UVList.length >> 2);
				if (k > 1) {
					u = Math.floor(k * (Number(curtime % Math.abs(es.m_ImgSpeed)) / es.m_ImgSpeed));
				}

				u = (p.m_ImgNum + u) % k;
				p.m_U1 = p.m_Emitter.m_ImgStyle.m_UVList[(u << 2) + 0];
				p.m_V1 = p.m_Emitter.m_ImgStyle.m_UVList[(u << 2) + 1];
				p.m_U2 = p.m_Emitter.m_ImgStyle.m_UVList[(u << 2) + 2];
				p.m_V2 = p.m_Emitter.m_ImgStyle.m_UVList[(u << 2) + 3];

				if(m_TextureStyle.m_ChannelMask) {
					p.m_ColorMask = p.m_Emitter.m_ImgStyle.m_MaskList[(u << 2) + 0];
					p.m_AlphaMask = p.m_Emitter.m_ImgStyle.m_MaskList[(u << 2) + 1];
				}

				if (es.m_HeightType == 1 && es.m_ImgDist > 0) {
					p.m_V2 += 1.0 * m_PathDist / es.m_ImgDist;
				}

				if(k<=1) {
					v = -Number(curtime % Math.abs(es.m_ImgSpeed)) / es.m_ImgSpeed;
					p.m_V1 += v;
					p.m_V2 += v;
				}
			}

			if (p.m_BaseColor == 0) p.m_Color = Style.IC(es.m_ColorG, tn);
			else p.m_Color = Style.IC(es.m_ColorG, (Math.floor((p.m_BaseColor + tn) * 10000) % 10000) / 10000);
			
			v = p.m_BaseAlpha;
			if (es.m_AlphaOV != 0) v += es.m_AlphaOV;
			if (es.m_AlphaOD != 0) v += es.m_AlphaOD * Style.IG(es.m_AlphaOG, tn);
			if (v != 1) {
				v = v * ((p.m_Color >> 24) & 255);
				if (v < 0) v = 0;
				else if (v > 255) v = 255;
				p.m_Color = (uint(v) << 24) | (p.m_Color & 0xffffff);
			}

/*			if (es.m_AlphaOV != 0 || es.m_AlphaOD != 0) {
				v = C3D.ClrToFloat * ((p.m_Color >> 24) & 255);
				if (es.m_AlphaOV != 0) v += es.m_AlphaOV;
				if (es.m_AlphaOD != 0) v += es.m_AlphaOD * Style.IG(es.m_AlphaOG, tn);
				if (v < 0) v = 0;
				else if (v > 1.0) v = 1.0;
				p.m_Color = (uint(v * 255) << 24) | (p.m_Color & 0xffffff);
			}
			if (es.m_HueOV != 0 || es.m_SatOV != 0 || es.m_BriOV != 0 || es.m_HueOD != 0 || es.m_SatOD != 0 || es.m_BriOD != 0) {
				m_HSVRGB.r = (p.m_Color >> 16) & 255;
				m_HSVRGB.g = (p.m_Color >> 8) & 255;
				m_HSVRGB.b = (p.m_Color) & 255;
				m_HSVRGB.ToHSV();

				if (es.m_HueOV != 0) m_HSVRGB.h += es.m_HueOV * 360;
				if (es.m_HueOD != 0) m_HSVRGB.h += es.m_HueOD * Style.IG(es.m_HueOG, tn) * 360;
				if (m_HSVRGB.h < 0) m_HSVRGB.h = 0;
				else if (m_HSVRGB.h > 360) m_HSVRGB.h = 360;

				if (es.m_SatOV != 0) m_HSVRGB.s += es.m_SatOV * 255;
				if (es.m_SatOD != 0) m_HSVRGB.s += es.m_SatOD * Style.IG(es.m_SatOG, tn) * 255;
				if (m_HSVRGB.s < 0) m_HSVRGB.s = 0;
				else if (m_HSVRGB.s > 255) m_HSVRGB.s = 255;

				if (es.m_BriOV != 0) m_HSVRGB.v += es.m_BriOV * 255;
				if (es.m_BriOD != 0) m_HSVRGB.v += es.m_BriOD * Style.IG(es.m_BriOG, tn) * 255;
				if (m_HSVRGB.v < 0) m_HSVRGB.v = 0;
				else if (m_HSVRGB.v > 255) m_HSVRGB.v = 255;

				m_HSVRGB.ToRGB();
				p.m_Color = (p.m_Color & 0xff000000) | (m_HSVRGB.r << 16) | (m_HSVRGB.g << 8) | (m_HSVRGB.b);
			}*/
			p.m_ColorTo = p.m_Color;
			
		}

		if (m_Style.m_Sort) m_Last.ToQuadBatch(true, m_QuadBatch, m_TextureStyle.m_ChannelMask);
		else m_First.ToQuadBatch(false, m_QuadBatch, m_TextureStyle.m_ChannelMask);

		C3D.SetVConstMatrix(0, mvp);
		C3D.SetVConst_n(8, camposx, camposy, camposz, 1.0);

		if(m_TextureStyle.m_ChannelMask) C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);

		C3D.ShaderParticle(m_TextureStyle.m_ChannelMask);

		C3D.SetTexture(0, m_Texture.tex);

		C3D.VBQuadBatch(m_QuadBatch);

		C3D.DrawQuadBatch();

		C3D.SetTexture(0, null);
	}
}

}

import B3DEffect.Emitter;
import Engine.*;

class EffectParticle extends C3DParticle
{
	public var m_Emitter:Emitter = null;
	
	public var m_Type:int = 0;

	public var m_Life:Number = 0;
	public var m_Age:Number = 0;

	public var m_Velocity:Number = 0;
	public var m_BaseSpin:Number = 0;

	public var m_BaseWidth:Number = 0;

	public var m_BasePosX:Number = 0;
	public var m_BasePosY:Number = 0;
	public var m_BasePosZ:Number = 0;

	public var m_BaseDirX:Number = 0;
	public var m_BaseDirY:Number = 0;
	public var m_BaseDirZ:Number = 0;
	
	public var m_Offset:Number = 0;
	
	public var m_BaseColor:Number = 0;
	public var m_BaseAlpha:uint = 0;
	
	public var m_ImgNum:int = 0;

	public function EffectParticle():void
	{
	}

	public function Clear():void
	{
	}
}
