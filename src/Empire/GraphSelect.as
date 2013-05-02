package Empire
{
import Base.*;
import Engine.*;
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;
		
public class GraphSelect //extends Shape
{
	private var m_Map:EmpireMap;

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;
	public var m_Radius:Number;
	
	static public var m_Tex:C3DTexture = null;

	public var m_EmptyFirst:C3DParticle = null;
	public var m_EmptyLast:C3DParticle = null;
	public var m_First:C3DParticle = null;
	public var m_Last:C3DParticle = null;

	public var m_QuadBatch:C3DQuadBatch = new C3DQuadBatch();
	
	public function GraphSelect(map:EmpireMap)
	{
		m_Map=map;

		m_SectorX=0;
		m_SectorY=0;
		m_PlanetNum=-1;
		m_ShipNum=-1;

		m_Radius=0;
	}
	
	public function free():void
	{
		m_QuadBatch.free();
	}

	public function SetPos(sectorx:int,sectory:int,planetnum:int, shipnum:int=-1):void
	{
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
	}

	public function SetRadius(r:int):void
	{
		if(m_Radius==r) return;
		m_Radius=r;
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

	public function Draw():void
	{
		var i:int;
		var planet:Planet, planetlink:Planet;
		var gship:GraphShip;
		var ship:Ship;
		var p:C3DParticle;

		var dist:Number, v:Number;
		var dx:Number=0;
		var dy:Number=0;
		var tx:Number=0;
		var ty:Number = 0;

		if (m_Tex == null) m_Tex = C3D.GetTexture("white");
		if (m_Tex.tex == null) return;

		var mv:Matrix3D = EmpireMap.Self.m_MatViewInv;
		var nx:Number = mv.rawData[2 * 4 + 0];
		var ny:Number = mv.rawData[2 * 4 + 1];
		var nz:Number = mv.rawData[2 * 4 + 2];

		var ww:Number = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);

		while (m_PlanetNum >= 0) {
			if (m_Radius <= 0) break;

			planet = m_Map.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
			if (planet == null) break;

			var size:Number = 8;
			var r:Number = m_Radius;

			if(m_ShipNum>=0) {
				m_Map.CalcShipPlaceEx(planet, m_ShipNum, EmpireMap.m_TPos);
				tx = m_Map.WorldToScreenX(EmpireMap.m_TPos.x, EmpireMap.m_TPos.y);
				ty = EmpireMap.m_TWSPos.y;

				r = Math.round(r * Math.min(1.0, ww));
			} else {
				tx = m_Map.WorldToScreenX(planet.m_PosX, planet.m_PosY);
				ty = EmpireMap.m_TWSPos.y;
				
				if (planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge | Planet.PlanetFlagWormhole)) r = 35;
				else r = 25;

				r = Math.round(r * ww);

				tx = Math.round(tx);
				ty = Math.round(ty);
			}
			

			C3D.DrawImg(m_Tex, 0x80000000, tx - r - 1, ty - r - 1, size + 2, size + 2, 0, 0, 1, 1);
			C3D.DrawImg(m_Tex, 0x80000000, tx + r - size, ty - r - 1, size + 3, size + 2, 0, 0, 1, 1);
			C3D.DrawImg(m_Tex, 0x80000000, tx + r - size, ty + r - size, size + 3, size + 3, 0, 0, 1, 1);
			C3D.DrawImg(m_Tex, 0x80000000, tx - r - 1, ty + r - size, size + 2, size + 3, 0, 0, 1, 1);

			C3D.DrawImg(m_Tex, 0xffffffff, tx - r, ty - r, size, 2, 0, 0, 1, 1);
			C3D.DrawImg(m_Tex, 0xffffffff, tx - r, ty - r, 2, size, 0, 0, 1, 1);

			C3D.DrawImg(m_Tex, 0xffffffff, tx + r - size + 1, ty - r, size, 2, 0, 0, 1, 1);
			C3D.DrawImg(m_Tex, 0xffffffff, tx + r, ty - r, 2, size, 0, 0, 1, 1);

			C3D.DrawImg(m_Tex, 0xffffffff, tx + r - size + 2, ty + r, size, 2, 0, 0, 1, 1);
			C3D.DrawImg(m_Tex, 0xffffffff, tx + r, ty + r - size + 2, 2, size, 0, 0, 1, 1);

			C3D.DrawImg(m_Tex, 0xffffffff, tx - r, ty + r, size, 2, 0, 0, 1, 1);
			C3D.DrawImg(m_Tex, 0xffffffff, tx - r, ty + r - size + 1, 2, size, 0, 0, 1, 1);

			break;
		}

		PClear();
		
		while (m_Map.m_Info.m_ShipNum >= 0) {
			if (!m_Map.m_Info.visible) break;

			planet = m_Map.GetPlanet(m_Map.m_Info.m_SectorX, m_Map.m_Info.m_SectorY, m_Map.m_Info.m_PlanetNum);
			if (planet == null) break;
			if (m_Map.m_Info.m_ShipNum<0 || m_Map.m_Info.m_ShipNum>=planet.m_Ship.length) break;
			ship = planet.m_Ship[m_Map.m_Info.m_ShipNum];
			if (ship == null) break;
			if (ship.m_Type == Common.ShipTypeNone) break;
			//if(ship.m_Owner!=Server.Self.m_UserId) break;
			if(ship.m_Type==Common.ShipTypeSciBase && (ship.m_Flag & Common.ShipFlagEject)!=0) {}
			else if (!m_Map.IsEdit() && !m_Map.AccessControl(ship.m_Owner)) break;

//@			if (ship.m_Flag & Common.ShipFlagAutoLogic) { }
//@			else if (ship.m_Flag & Common.ShipFlagAutoReturn) { }
//@			else break;
			if (!ship.m_Link) break;

			gship = m_Map.GetGraphShip(m_Map.m_Info.m_SectorX, m_Map.m_Info.m_SectorY, m_Map.m_Info.m_PlanetNum, m_Map.m_Info.m_ShipNum);
			if (gship == null) break;
			tx = gship.m_PosX;
			ty = gship.m_PosY;

			planetlink = m_Map.Link(planet, ship);
//@			if (ship.m_Flag & Common.ShipFlagAutoLogic) {
			if(planetlink!=null && planetlink==planet) {
//@				planet = m_Map.GetPlanet(m_Map.m_Info.m_SectorX, m_Map.m_Info.m_SectorY, m_Map.m_Info.m_PlanetNum);
				planet = planetlink;
				if (planet == null) break;

				dx = planet.m_PosX - tx;
				dy = planet.m_PosY - ty;
				dist = Math.sqrt(dx * dx + dy * dy);
				v = 1.0 / dist; dx *= v; dy *= v;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagShow;
				p.m_PosX = tx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
				p.m_PosY = ty - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
				p.m_PosZ = 0.0;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 2.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
				p.m_Height = dist;
				p.m_U1 = 0;
				p.m_V1 = 0;
				p.m_U2 = 1;
				p.m_V2 = 1;
				p.m_Color = 0xff00ff00;
				p.m_ColorTo = 0xff00ff00;

//@			} else if(ship.m_Flag & Common.ShipFlagAutoReturn) {
			} else if (planetlink != null) {
//@				planet=m_Map.GetPlanet(ship.m_FromSectorX,ship.m_FromSectorY,ship.m_FromPlanet);
				planet = planetlink;
				if(planet==null) break;
				
				dx = planet.m_PosX - tx;
				dy = planet.m_PosY - ty;
				dist = Math.sqrt(dx * dx + dy * dy);
				v = 1.0 / dist; dx *= v; dy *= v;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagShow;
				p.m_PosX = tx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
				p.m_PosY = ty - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
				p.m_PosZ = 0.0;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 2.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
				p.m_Height = dist;
				p.m_U1 = 0;
				p.m_V1 = 0;
				p.m_U2 = 1;
				p.m_V2 = 1;
				p.m_Color = 0xff00ff00;
				p.m_ColorTo = 0xff00ff00;
			}
			
			break;
		}

		while (m_Map.m_Info.m_ShipNum >= 0) {
			if (!m_Map.m_Info.visible) break;

			ship = m_Map.GetShip(m_Map.m_Info.m_SectorX, m_Map.m_Info.m_SectorY, m_Map.m_Info.m_PlanetNum, m_Map.m_Info.m_ShipNum);
			if (ship == null) break;
			if (ship.m_Type == Common.ShipTypeNone) break;
			//if(ship.m_Owner!=Server.Self.m_UserId) break;
			if (!m_Map.AccessControl(ship.m_Owner)) break;

			if (!ship.m_Path) break;

			gship = m_Map.GetGraphShip(m_Map.m_Info.m_SectorX, m_Map.m_Info.m_SectorY, m_Map.m_Info.m_PlanetNum, m_Map.m_Info.m_ShipNum);
			if (gship == null) break;
			tx = gship.m_PosX;
			ty = gship.m_PosY;

			var csx:int = m_Map.m_Info.m_SectorX;
			var csy:int = m_Map.m_Info.m_SectorY;

			for(i=0;i<3;i++) {
				var off:uint = (ship.m_Path >> (i << 3)) & 255;
				if (!off) break;

			    if (off & 1) csx++;
	    		if (off & 2) csx--;
	    		if (off & 4) csy++;
	 			if (off & 8) csy--;
				var tgtplanet:int = (off >> 4) & 7;

				planet = m_Map.GetPlanet(csx, csy, tgtplanet);
				if (planet == null) break;

				dx = planet.m_PosX - tx;
				dy = planet.m_PosY - ty;
				dist = Math.sqrt(dx * dx + dy * dy);
				v = 1.0 / dist; dx *= v; dy *= v;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagShow;
				p.m_PosX = tx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
				p.m_PosY = ty - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
				p.m_PosZ = 0.0;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 2.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
				p.m_Height = dist;
				p.m_U1 = 0;
				p.m_V1 = 0;
				p.m_U2 = 1;
				p.m_V2 = 1;
				p.m_Color = 0xffffff00;
				p.m_ColorTo = 0xffffff00;

				tx = planet.m_PosX;
				ty = planet.m_PosY;
			}
			
			break;
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
