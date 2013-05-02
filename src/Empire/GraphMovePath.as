// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;
		
public class GraphMovePath
{
	private var m_Map:EmpireMap;

	static public var m_Tex:C3DTexture = null;

	public var m_EmptyFirst:C3DParticle = null;
	public var m_EmptyLast:C3DParticle = null;
	public var m_First:C3DParticle = null;
	public var m_Last:C3DParticle = null;

	public var m_QuadBatch:C3DQuadBatch = new C3DQuadBatch();

	public function GraphMovePath(map:EmpireMap)
	{
		m_Map=map;
	}

	public function PAdd():C3DParticle 
	{
		var p:C3DParticle = m_EmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_EmptyLast == p) m_EmptyLast = C3DParticle(p.m_Prev);
			if (m_EmptyFirst == p) m_EmptyFirst = C3DParticle(p.m_Next);
		} else {
			p = new C3DParticle();
		}
		if (m_Last != null) m_Last.m_Next = p;
		p.m_Prev = m_Last;
		p.m_Next = null;
		m_Last = p;
		if (m_First == null) m_First = p;
		return p;
	}

	public function PDel(p:C3DParticle):void
	{
		if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
		if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
		if (m_Last == p) m_Last = C3DParticle(p.m_Prev);
		if (m_First == p) m_First = C3DParticle(p.m_Next);

		//p.Clear();

		if (m_EmptyLast != null) m_EmptyLast.m_Next = p;
		p.m_Prev = m_EmptyLast;
		p.m_Next = null;
		m_EmptyLast = p;
		if (m_EmptyFirst == null) m_EmptyFirst = p;
	}
	
	public function PClear():void
	{
		var p:C3DParticle;
		var pnext:C3DParticle = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = C3DParticle(pnext.m_Next);
			PDel(p);
		}
	}

	private var m_FX:Number = 0;
	private var m_FY:Number = 0;
	public function PMove(fx:Number, fy:Number):void
	{
		m_FX = fx;
		m_FY = fy;
	}

	public function PLine(tx:Number, ty:Number):void
	{
		var dx:Number, dy:Number, v:Number, dist:Number;
		dx = tx - m_FX;
		dy = ty - m_FY;
		dist = Math.sqrt(dx * dx + dy * dy);
		v = 1.0 / dist; dx *= v; dy *= v;
		
		var p:C3DParticle;
		p = PAdd();
		p.m_Flag |= C3DParticle.FlagShow;
		p.m_PosX = m_FX - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
		p.m_PosY = m_FY - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
		p.m_PosZ = 0.0;
		p.m_NormalX = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 0];
		p.m_NormalY = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 1];
		p.m_NormalZ = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 2];
		p.m_DirX = dx;
		p.m_DirY = dy;
		p.m_DirZ = 0.0;
		p.m_Width = 2.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
		p.m_Height = dist;
		p.m_U1 = 0;
		p.m_V1 = 0;
		p.m_U2 = 1;
		p.m_V2 = 1;
		p.m_Color = 0xffffffff;
		p.m_ColorTo = 0xffffffff;
		
		m_FX = tx;
		m_FY = ty;
	}

	public function Draw():void
	{
		var i:int, u:int;
		var planet2:Planet;

		if (m_Map.m_Action != EmpireMap.ActionMove && 
			m_Map.m_Action != EmpireMap.ActionSplit && 
			m_Map.m_Action != EmpireMap.ActionPathMove && 
			m_Map.m_Action != EmpireMap.ActionPlanet &&
			m_Map.m_Action != EmpireMap.ActionRoute &&
			m_Map.m_Action != EmpireMap.ActionExchange &&
			m_Map.m_Action != EmpireMap.ActionConstructor &&
			m_Map.m_Action != EmpireMap.ActionRecharge &&
			m_Map.m_Action != EmpireMap.ActionPlanetMove &&
			m_Map.m_Action != EmpireMap.ActionPortal &&
			m_Map.m_Action != EmpireMap.ActionLink &&
			m_Map.m_Action != EmpireMap.ActionEject &&
			m_Map.m_Action != EmpireMap.ActionWormhole &&
			m_Map.m_Action != EmpireMap.ActionAntiGravitor &&
			m_Map.m_Action != EmpireMap.ActionGravWell &&
			m_Map.m_Action != EmpireMap.ActionBlackHole &&
			m_Map.m_Action != EmpireMap.ActionTransition
			) return;

		if (m_Tex == null) m_Tex = C3D.GetTexture("white");
		if (m_Tex.tex == null) return;

		var planet:Planet = m_Map.GetPlanet(m_Map.m_MoveSectorX, m_Map.m_MoveSectorY, m_Map.m_MovePlanetNum);
		if (!planet) return;
		
		PClear();

		var fx:Number = planet.m_PosX;
		var fy:Number = planet.m_PosY;

		if (m_Map.m_MoveShipNum >= 0) {
			m_Map.CalcShipPlaceEx(planet, m_Map.m_MoveShipNum,EmpireMap.m_TPos);

			fx = EmpireMap.m_TPos.x;
			fy = EmpireMap.m_TPos.y;
		}

		var tx:Number, ty:Number;

		if (m_Map.m_CurPlanetNum < 0) {
			EmpireMap.Self.PickWorldCoord(m_Map.mouseX, m_Map.mouseY, EmpireMap.m_TPos);
			tx = EmpireMap.m_TPos.x;
			ty = EmpireMap.m_TPos.y;
		} else {
			planet2 = m_Map.GetPlanet(m_Map.m_CurSectorX, m_Map.m_CurSectorY, m_Map.m_CurPlanetNum);
			if (!planet2) return;

			tx = planet2.m_PosX;
			ty = planet2.m_PosY;

			if(m_Map.m_CurShipNum>=0) {
				m_Map.CalcShipPlaceEx(planet2, m_Map.m_CurShipNum, EmpireMap.m_TPos);

				tx = EmpireMap.m_TPos.x;
				ty = EmpireMap.m_TPos.y;
			}
		}

		PMove(fx, fy);

		if (m_Map.m_MovePath.length == 0) {
			if (m_Map.m_Action == EmpireMap.ActionConstructor && m_Map.m_ActionShipNum >= 0) {
				m_Map.CalcShipPlaceEx(planet, m_Map.m_ActionShipNum, EmpireMap.m_TPos);

				fx = EmpireMap.m_TPos.x;
				fy = EmpireMap.m_TPos.y;

				PLine(fx, fy);
			}

			PLine(tx, ty);
			
			for (u = 0; u < m_Map.m_MoveListNum.length; u++) {
				m_Map.CalcShipPlaceEx(planet, m_Map.m_MoveListNum[u], EmpireMap.m_TPos);

				fx = EmpireMap.m_TPos.x;
				fy = EmpireMap.m_TPos.y;

				PMove(fx, fy);
				PLine(tx, ty);
			}

		} else {
			for (i = 1; i < m_Map.m_MovePath.length; i++) {
				planet2 = m_Map.m_MovePath[i];

				tx = planet2.m_PosX;
				ty = planet2.m_PosY;

				PLine(tx, ty);

				if(i==1) {
					for (u = 0; u < m_Map.m_MoveListNum.length; u++) {
						m_Map.CalcShipPlaceEx(planet, m_Map.m_MoveListNum[u], EmpireMap.m_TPos);
		
						fx = EmpireMap.m_TPos.x;
						fy = EmpireMap.m_TPos.y;
		
						PMove(fx, fy);
						PLine(tx, ty);
					}
				}			
			}

			EmpireMap.Self.PickWorldCoord(m_Map.mouseX, m_Map.mouseY, EmpireMap.m_TPos);
			tx = EmpireMap.m_TPos.x;
			ty = EmpireMap.m_TPos.y;
			PLine(tx, ty);
		}

		if(m_First!=null) {
			m_First.ToQuadBatch(false, m_QuadBatch);

			C3D.SetVConstMatrix(0, EmpireMap.Self.m_MatViewPer);
			C3D.SetVConst_n(8, 0.0, 0.0, 0.0, 1.0);

			C3D.ShaderParticle();

			C3D.SetTexture(0, m_Tex.tex);

			C3D.VBQuadBatch(m_QuadBatch);

			C3D.DrawQuadBatch();

			C3D.SetTexture(0, null);
		}
	}
}

}
