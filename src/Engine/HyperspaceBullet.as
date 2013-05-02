// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
	import B3DEffect.Effect;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

public class HyperspaceBullet extends HyperspaceEntity
{
	public static const BulletTypeLaser:uint = 1;
	
//	static public var m_EmptyFirst:HyperspaceBulletParticle = null;
//	static public var m_EmptyLast:HyperspaceBulletParticle = null;

//	public var m_First:HyperspaceBulletParticle = null;
//	public var m_Last:HyperspaceBulletParticle = null;

	public var m_DirX:Number = 0;
	public var m_DirY:Number = 0;
	public var m_DirZ:Number = 0;
	
	public var m_AimPosX:Number = 0;
	public var m_AimPosY:Number = 0;
	public var m_AimPosZ:Number = 0;
	
	public var m_DuloX:Number = 0;
	public var m_DuloY:Number = 0;
	public var m_DuloZ:Number = 0;

	public var m_DuloDirX:Number = 0;
	public var m_DuloDirY:Number = 0;
	public var m_DuloDirZ:Number = 0;

	public var m_DuloUpX:Number = 0;
	public var m_DuloUpY:Number = 0;
	public var m_DuloUpZ:Number = 0;

	public var m_FromType:int = 0;
	public var m_FromId:uint = 0;	

	public var m_TargetType:int = 0;
	public var m_TargetId:uint = 0;

	public var m_BulletType:uint = 0;
	
//	public var m_QuadBatch:C3DQuadBatch = new C3DQuadBatch();
	
//	public var m_BirthTime:Number = 0;
	
	public var m_Del:Boolean = false;
	
	public static var m_TPos:Vector3D = new Vector3D();
	public static var m_TDir:Vector3D = new Vector3D();

	public var m_Effect:Effect = null;

	public function HyperspaceBullet(hs:HyperspaceBase):void
	{
		super(hs);
	}

	public function Clear():void
	{
		if (m_Effect != null) {
			m_Effect.Clear();
			m_Effect = null;
		}
/*		var p:HyperspaceBulletParticle, pnext:HyperspaceBulletParticle;

		pnext = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = HyperspaceBulletParticle(pnext.m_Next);
			PDel(p);
		}
		
		m_QuadBatch.GraphClear();*/
	}
	
/*	public function PAdd():HyperspaceBulletParticle 
	{
		var p:HyperspaceBulletParticle = m_EmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_EmptyLast == p) m_EmptyLast = HyperspaceBulletParticle(p.m_Prev);
			if (m_EmptyFirst == p) m_EmptyFirst = HyperspaceBulletParticle(p.m_Next);
		} else {
			p = new HyperspaceBulletParticle();
		}
		if (m_Last != null) m_Last.m_Next = p;
		p.m_Prev = m_Last;
		p.m_Next = null;
		m_Last = p;
		if (m_First == null) m_First = p;
		return p;
	}

	public function PDel(p:HyperspaceBulletParticle):void
	{
		if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
		if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
		if (m_Last == p) m_Last = HyperspaceBulletParticle(p.m_Prev);
		if (m_First == p) m_First = HyperspaceBulletParticle(p.m_Next);

		p.Clear();

		if (m_EmptyLast != null) m_EmptyLast.m_Next = p;
		p.m_Prev = m_EmptyLast;
		p.m_Next = null;
		m_EmptyLast = p;
		if (m_EmptyFirst == null) m_EmptyFirst = p;
	}*/

	public function GraphTakt(step:Number):Boolean
	{
		var v:Vector3D;
		var fromx:Number, fromy:Number, fromz:Number;
		var tox:Number, toy:Number, toz:Number;
		var nhx:Number, nhy:Number, nhz:Number;
		var k:Number, dist:Number;

		if (m_BulletType == BulletTypeLaser) {
			var from_ent:HyperspaceEntity = HS.HyperspaceEntityById(m_FromType, m_FromId);
			if (from_ent == null) return false;
			
			var to_ent:HyperspaceEntity = HS.HyperspaceEntityById(m_TargetType, m_TargetId);
			if (to_ent == null) return false;
		
			if (m_Effect == null) {
				m_Effect = new Effect();
			
				m_Effect.Run("laser0");
			}

			fromx = m_DuloX;
			fromy = m_DuloY;
			fromz = m_DuloZ;

			m_Effect.SetPos(fromx, fromy, fromz);
			m_Effect.SetUp(m_DuloUpX, m_DuloUpY, m_DuloUpZ);

			if (to_ent.m_EntityType == SpaceEntity.TypeFleet) {
				m_TPos.x = m_AimPosX;
				m_TPos.y = m_AimPosY;
				m_TPos.z = m_AimPosZ;
				v = (to_ent as HyperspaceFleet).m_World.transformVector(m_TPos);
				tox = v.x;
				toy = v.y;
				toz = v.z;

				if ((to_ent as HyperspaceFleet).CalcHit(fromx, fromy, fromz, tox, toy, toz, m_TPos, m_TDir)) {
					tox = m_TPos.x;
					toy = m_TPos.y;
					toz = m_TPos.z;

					nhx = m_TDir.x;// fromx - tox;
					nhy = m_TDir.y;//fromy - toy;
					nhz = m_TDir.z;//fromz - toz;
				} else {
					nhx = fromx - tox;
					nhy = fromy - toy;
					nhz = fromz - toz;
				}
				dist = 1.0 / Math.sqrt(nhx * nhx + nhy * nhy + nhz * nhz);
				nhx *= dist; nhy *= dist; nhz *= dist;

			} else return false;

			m_DirX = tox - fromx;
			m_DirY = toy - fromy;
			m_DirZ = toz - fromz;
			dist = Math.sqrt(m_DirX * m_DirX + m_DirY * m_DirY + m_DirZ * m_DirZ);
			if (dist < 0.001) { m_DirX = 1.0; m_DirY = 0.0; m_DirZ = 0.0; }
			else { k = 1.0 / dist; m_DirX *= k; m_DirY *= k; m_DirZ *= k; }

			m_Effect.SetDir(m_DirX, m_DirY, m_DirZ);
			m_Effect.SetPathDist(dist);
			m_Effect.SetNormal(nhx, nhy, nhz, m_DuloUpX, m_DuloUpY, m_DuloUpZ);
		}
		
		if (m_Effect != null) {
			m_Effect.GraphTakt(step);
		}

		return true;
		
/*		var i:int, u:int;
		var k:Number,dist:Number, size:Number, width:Number;
		var fromx:Number, fromy:Number, fromz:Number;
		var tox:Number, toy:Number, toz:Number;
		var npx:Number, npy:Number, npz:Number;
		var nhx:Number, nhy:Number, nhz:Number;
		var p:HyperspaceBulletParticle, pnext:HyperspaceBulletParticle;
		var v:Vector3D;

		var mv:Matrix3D = EmpireMap.Self.m_Hyperspace.m_MatViewInv;
		var dx:Number = mv.rawData[1 * 4 + 0];
		var dy:Number = mv.rawData[1 * 4 + 1];
		var dz:Number = mv.rawData[1 * 4 + 2];

		var nx:Number = mv.rawData[2 * 4 + 0];
		var ny:Number = mv.rawData[2 * 4 + 1];
		var nz:Number = mv.rawData[2 * 4 + 2];
		
		//var off:Number;

		if (m_BulletType == BulletTypeLaser) {
			var from_ent:HyperspaceEntity = Hyperspace.Self.HyperspaceEntityById(m_FromType, m_FromId);
			if (from_ent == null) return false;
			
			fromx = m_DuloX;
			fromy = m_DuloY;
			fromz = m_DuloZ;

//			if (from_ent.m_EntityType == SpaceEntity.TypeFleet) {
//				fromx = from_ent.m_PosX - Hyperspace.Self.m_CamPos.x + Space.Self.m_ZoneSize * (from_ent.m_ZoneX - Hyperspace.Self.m_CamZoneX);
//				fromy = from_ent.m_PosY - Hyperspace.Self.m_CamPos.y + Space.Self.m_ZoneSize * (from_ent.m_ZoneY - Hyperspace.Self.m_CamZoneY);
//				fromz = from_ent.m_PosZ - Hyperspace.Self.m_CamPos.z;
//			} else return false;

			var to_ent:HyperspaceEntity = Hyperspace.Self.HyperspaceEntityById(m_TargetType, m_TargetId);
			if (to_ent == null) return false;

			if (to_ent.m_EntityType == SpaceEntity.TypeFleet) {
				//tox = to_ent.m_PosX - Hyperspace.Self.m_CamPos.x + Space.Self.m_ZoneSize * (to_ent.m_ZoneX - Hyperspace.Self.m_CamZoneX);
				//toy = to_ent.m_PosY - Hyperspace.Self.m_CamPos.y + Space.Self.m_ZoneSize * (to_ent.m_ZoneY - Hyperspace.Self.m_CamZoneY);
				//toz = to_ent.m_PosZ - Hyperspace.Self.m_CamPos.z;
				m_TPos.x = m_AimPosX;
				m_TPos.y = m_AimPosY;
				m_TPos.z = m_AimPosZ;
				v = (to_ent as HyperspaceFleet).m_World.transformVector(m_TPos);
				tox = v.x;
				toy = v.y;
				toz = v.z;

				if ((to_ent as HyperspaceFleet).CalcHit(fromx, fromy, fromz, tox, toy, toz, m_TPos, m_TDir)) {
					tox = m_TPos.x;
					toy = m_TPos.y;
					toz = m_TPos.z;
					
					nhx = m_TDir.x;// fromx - tox;
					nhy = m_TDir.y;//fromy - toy;
					nhz = m_TDir.z;//fromz - toz;
				} else {
					nhx = fromx - tox;
					nhy = fromy - toy;
					nhz = fromz - toz;
				}
				dist = 1.0 / Math.sqrt(nhx * nhx + nhy * nhy + nhz * nhz);
				nhx *= dist; nhy *= dist; nhz *= dist;

			} else return false;

			m_DirX = tox - fromx;
			m_DirY = toy - fromy;
			m_DirZ = toz - fromz;
			dist = Math.sqrt(m_DirX * m_DirX + m_DirY * m_DirY + m_DirZ * m_DirZ);
			if (dist < 0.001) { m_DirX = 1.0; m_DirY = 0.0; m_DirZ = 0.0; }
			else { k = 1.0 / dist; m_DirX *= k; m_DirY *= k; m_DirZ *= k; }

			// Line
			pnext = m_First;
			if (pnext == null) pnext = PAdd();
			p = pnext;
			pnext = HyperspaceBulletParticle(pnext.m_Next);

			p.m_Type = 1;
			p.m_Flag |= C3DParticle.FlagShow | C3DParticle.FlagColorAdd;
			p.m_U1 = 0.0;
			p.m_V1 = 1.0 - Number(EmpireMap.Self.m_CurTime % 500) / 500.0;
			p.m_U2 = 0.5;
			p.m_V2 = p.m_V1 + 1.0 * dist / 200.0;
			p.m_PosX = fromx;
			p.m_PosY = fromy;
			p.m_PosZ = fromz;
			p.m_NormalX = nx;
			p.m_NormalY = ny;
			p.m_NormalZ = nz;
			p.m_DirX = m_DirX;
			p.m_DirY = m_DirY;
			p.m_DirZ = m_DirZ;
			p.m_Width = 20.0;
			p.m_Height = dist;
			p.m_Color = 0xffffffff;
			p.m_ColorTo = p.m_Color;

			// cap
			var steppl:Number = 5.0;
			width = 20.0;
			for (u = 0; u < 2; u++) {
				for (i = 0; i < 4; i++) {
					if (pnext == null) pnext = PAdd();
					p = pnext;
					pnext = HyperspaceBulletParticle(pnext.m_Next);

					p.m_Type = 2 + u;
					p.m_Flag |= C3DParticle.FlagShow | C3DParticle.FlagColorAdd;
					if (i == 0) { p.m_U1 = 0.0; p.m_V1 = 0.0; size = 0.8; }
					else if (i == 1) { p.m_U1 = 0.0; p.m_V1 = 1.0; size = 0.5; }
					else if (i == 2) { p.m_U1 = 1.0; p.m_V1 = 1.0; size = 0.5; }
					else { p.m_U1 = 1.0; p.m_V1 = 0.0;  size = 1.0; } 
					p.m_U1 = 0.5 + p.m_U1 * 0.25;
					p.m_V1 = p.m_V1 * 0.5;
					p.m_U2 = p.m_U1 + 0.25;
					p.m_V2 = p.m_V1 + 0.5;
					
					p.m_Width = ((EmpireMap.Self.m_CurTime + i * 200) % 800) / 800.0;
					if (p.m_Width <= 0.5) { p.m_Width = p.m_Width * 2.0; }
					else { p.m_Width = (1.0 - p.m_Width) * 2.0; }
					if (p.m_Width <= 0.5) p.m_Width = (p.m_Width * 2.0) * (p.m_Width * 2.0) * 0.5;
					else p.m_Width = 1.0 - ((1.0 - p.m_Width) * 2.0) * ((1.0 - p.m_Width) * 2.0) * 0.5;
					p.m_Width = p.m_Width * 0.1 + 0.9;
					p.m_Width = p.m_Width * size * width;

					p.m_Height = p.m_Width;

					if (u == 0) { p.m_PosX = fromx; p.m_PosY = fromy; p.m_PosZ = fromz; }
					else { p.m_PosX = tox; p.m_PosY = toy; p.m_PosZ = toz; }

					npx = Hyperspace.Self.m_View.x - p.m_PosX;
					npy = Hyperspace.Self.m_View.y - p.m_PosY;
					npz = Hyperspace.Self.m_View.z - p.m_PosZ;
					dist = 1.0 / Math.sqrt(npx * npx + npy * npy + npz * npz);
					npx *= dist; npy *= dist; npz *= dist; 

					p.m_PosX = p.m_PosX - dx * p.m_Width * 0.5 + npx * Number(i) * steppl;
					p.m_PosY = p.m_PosY - dy * p.m_Width * 0.5 + npy * Number(i) * steppl;
					p.m_PosZ = p.m_PosZ - dz * p.m_Width * 0.5 + npz * Number(i) * steppl;
					p.m_NormalX = npx;
					p.m_NormalY = npy;
					p.m_NormalZ = npz;
					p.m_DirX = dx;
					p.m_DirY = dy;
					p.m_DirZ = dz;

					p.m_Color=0xff4488ff;
					p.m_ColorTo=p.m_Color;
				}
			}

			// sparks
			m_BirthTime += step;
			while (m_BirthTime > 10) {
				m_BirthTime-= 10;

				p = PAdd();
				p.m_Type = 10;
				p.m_Flag |= C3DParticle.FlagShow | C3DParticle.FlagColorAdd;
				p.m_U1 = 0.0;
				p.m_V1 = 1.0;
				p.m_U1 = 0.5 + p.m_U1 * 0.25;
				p.m_V1 = p.m_V1 * 0.5;
				p.m_U2 = p.m_U1 + 0.25;
				p.m_V2 = p.m_V1 + 0.5;
				p.m_Color = 0xffff4040;
				p.m_ColorTo = p.m_Color;
				p.m_Width = 5.0;
				p.m_Height = p.m_Width;

				p.m_TTL = 0;
				p.m_ZoneX = Hyperspace.Self.m_CamZoneX;
				p.m_ZoneY = Hyperspace.Self.m_CamZoneY;
				p.m_MovePosX = Hyperspace.Self.m_CamPos.x + tox;
				p.m_MovePosY = Hyperspace.Self.m_CamPos.y + toy;
				p.m_MovePosZ = Hyperspace.Self.m_CamPos.z + toz;

				while(true) {
					npx = Math.random() * 2.0 - 1.0;
					npy = Math.random() * 2.0 - 1.0;
					npz = Math.random() * 2.0 - 1.0;

					p.m_MoveDirX = npy * nhz - npz * nhy;
					p.m_MoveDirY = npz * nhx - npx * nhz; 
					p.m_MoveDirZ = npx * nhy - npy * nhx;
					dist = p.m_MoveDirX * p.m_MoveDirX + p.m_MoveDirY * p.m_MoveDirY + p.m_MoveDirZ * p.m_MoveDirZ;
					if (dist > 0.0001) break;
				}
				dist = 1.0 / Math.sqrt(dist); p.m_MoveDirX *= dist; p.m_MoveDirY *= dist; p.m_MoveDirZ *= dist;

				dist = Math.random() * 0.8 + 0.1;
				p.m_MoveDirX = (nhx - p.m_MoveDirX) * dist;
				p.m_MoveDirY = (nhy - p.m_MoveDirY) * dist;
				p.m_MoveDirZ = (nhz - p.m_MoveDirZ) * dist;
				dist = p.m_MoveDirX * p.m_MoveDirX + p.m_MoveDirY * p.m_MoveDirY + p.m_MoveDirZ * p.m_MoveDirZ;
				dist = 1.0 / Math.sqrt(dist); p.m_MoveDirX *= dist; p.m_MoveDirY *= dist; p.m_MoveDirZ *= dist;
			}

			width = Hyperspace.Self.FactorScr2WorldDist(tox, toy, toz);

			while (pnext != null) {
				p = pnext;
				pnext = HyperspaceBulletParticle(pnext.m_Next);

				if (p.m_Type != 10) { PDel(p); continue; }
				p.m_TTL += step;
				if (p.m_TTL > 400.0) { PDel(p); continue; }

				p.m_MovePosX += p.m_MoveDirX * step * 0.1;
				p.m_MovePosY += p.m_MoveDirY * step * 0.1;
				p.m_MovePosZ += p.m_MoveDirZ * step * 0.1;

				p.m_PosX = p.m_MovePosX - Hyperspace.Self.m_CamPos.x + Space.Self.m_ZoneSize * (p.m_ZoneX - Hyperspace.Self.m_CamZoneX) - dx * p.m_Width * 0.5;
				p.m_PosY = p.m_MovePosY - Hyperspace.Self.m_CamPos.y + Space.Self.m_ZoneSize * (p.m_ZoneY - Hyperspace.Self.m_CamZoneY) - dy * p.m_Width * 0.5;
				p.m_PosZ = p.m_MovePosZ - Hyperspace.Self.m_CamPos.z - dz * p.m_Width * 0.5;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = dz;
				
				p.m_Width = width * 4.0;
				p.m_Height = p.m_Width;
			}
		}

		return true;*/
	}

	public function Draw():void
	{
		if (m_Effect != null) {
			m_Effect.Draw(HS.m_CurTime, HS.m_MatViewPer, HS.m_MatView, HS.m_MatViewInv, HS.m_FactorScr2WorldDist);
		}
		
/*		if (m_First == null) return;

		var t_dif:C3DTexture = C3D.GetTexture("effect/laser0.png");
		if (t_dif.tex == null) return;

//m_QuadBatch = new C3DQuadBatch();
		m_First.ToQuadBatch(false,m_QuadBatch);

		C3D.SetVConstMatrix(0, EmpireMap.Self.m_Hyperspace.m_MatViewPer);
		C3D.SetVConst_n(8, 0.0, 0.0, 0.0, 1.0);
		//C3D.SetVConst_n(5, -EmpireMap.Self.m_Hyperspace.m_CamPos.x, -EmpireMap.Self.m_Hyperspace.m_CamPos.y, -EmpireMap.Self.m_Hyperspace.m_CamPos.z, 1.0);

		C3D.ShaderParticle();

		C3D.SetTexture(0, t_dif.tex);

		C3D.VBQuadBatch(m_QuadBatch);

		C3D.DrawQuadBatch();

		C3D.SetTexture(0, null);*/
	}
}

}

/*class HyperspaceBulletParticle extends C3DParticle
{
	public var m_Type:int = 0;
	public var m_TTL:Number = 0;
	
	public var m_ZoneX:int = 0;
	public var m_ZoneY:int = 0;

	public var m_MovePosX:Number = 0;
	public var m_MovePosY:Number = 0;
	public var m_MovePosZ:Number = 0;

	public var m_MoveDirX:Number = 0;
	public var m_MoveDirY:Number = 0;
	public var m_MoveDirZ:Number = 0;

	public function Clear():void
	{
	}
}
*/