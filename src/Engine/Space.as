// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
	import Base.*;
	import flash.geom.Vector3D;

public class Space
{
	static public const pi:Number = 3.14159265358979;
	static public const ToRad:Number = pi / 180.0;
	static public const ToGrad:Number = 180.0 / pi;

	static public const MsecPerTakt:int = 100;// 10;
	static public const TaktStep:int = 10;// 1;

	static public const OrbitTime:int = 200;

//	public static var Self:Space = null;
	public var HS:HyperspaceBase = null;

	public var m_EntityList:Vector.<SpaceEntity> = new Vector.<SpaceEntity>();

	public var m_ZoneMinX:int = 0;
	public var m_ZoneMinY:int = 0;
	public var m_ZoneCntX:int = 0;
	public var m_ZoneCntY:int = 0;
	public var m_ZoneSize:int = 0;

	public var m_NearCotl:Vector.<uint> = new Vector.<uint>();

	public function Space(hs:HyperspaceBase):void
	{
		HS = hs;
	}

	public static function EmpireCotlSizeToRadius(s:int):int { return (Math.max(5, s) >> 1) * 25; }

	public function Clear():void
	{
		var i:int;

		for (i = 0; i < m_EntityList.length; i++) {
			var ent:SpaceEntity = m_EntityList[i];

			m_EntityList[i] = null;
		}
		m_EntityList.length = 0;
	}
	
	public function ClearFar(zx:int, zy:int, skip:SpaceEntity):void
	{
		var i:int, u:int;
		var ent:SpaceEntity;
		var ent2:SpaceEntity;
		var fleet:SpaceFleet;
		var shu:SpaceShuttle;
		var ship:SpaceShip;
		var cont:SpaceContainer;
		var contid:uint;
		
		var ardub:Array = new Array();
		
		for (i = m_EntityList.length - 1; i >= 0 ; i--) {
			ent = m_EntityList[i];
			if (!ent.m_RecvFull) ent.m_Tmp = 0;
			else if (ent == skip) ent.m_Tmp = 0;
			else if (Math.abs(ent.m_ZoneX - zx) <= 5 && Math.abs(ent.m_ZoneY - zy) <= 5) ent.m_Tmp = 0;
			else ent.m_Tmp = 1;
		}
		
		for (i = m_EntityList.length - 1; i >= 0 ; i--) {
			ent = m_EntityList[i];
			if (ent.m_Tmp == 0) continue;

			if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				if (ent.m_Id == HS.m_RootFleetId) { ent.m_Tmp = 0; continue; }

			} else if (ent.m_EntityType == SpaceEntity.TypeShuttle) {

			} else if (ent.m_EntityType == SpaceEntity.TypePlanet) {
				if (m_NearCotl.indexOf(SpacePlanet(ent).m_CotlId) >= 0) { ent.m_Tmp = 0; continue; }

			} else if (ent.m_EntityType == SpaceEntity.TypeCotl) {
				if (m_NearCotl.indexOf(ent.m_Id) >= 0) { ent.m_Tmp = 0; continue; }

			} else if (ent.m_EntityType == SpaceEntity.TypeContainer) {
			}
		}

		for (i = m_EntityList.length - 1; i >= 0 ; i--) {
			ent = m_EntityList[i];
			if (ent.m_Tmp != 0) continue;

			if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				fleet = SpaceFleet(ent);
				if (fleet.m_ShuttleId) {
					ent2 = EntityFind(SpaceEntity.TypeShuttle, fleet.m_ShuttleId, false);
					if (ent2) ent2.m_Tmp = 0;
				}
			}
			if (ent.IsShip()) {
				ship = SpaceShip(ent);
				contid = ship.m_DropId;
				ardub.length = 0;
				while (contid) {
					if (ardub[contid] != undefined) break;
					ardub[contid] = true;

					cont = EntityFind(SpaceEntity.TypeContainer, contid) as SpaceContainer;
					if (cont) {
						cont.m_Tmp = 0;
						contid = cont.m_DropNextContainerId;
					} else break;
				}
				contid = ship.m_TakeId;
				ardub.length = 0;
				while (contid) {
					if (ardub[contid] != undefined) break;
					ardub[contid] = true;

					cont = EntityFind(SpaceEntity.TypeContainer, contid) as SpaceContainer;
					if (cont) {
						cont.m_Tmp = 0;
						contid = 0;
						if(cont.m_Take)
						for (u = 0; u < SpaceContainer.TakeMax; u++) {
							if (cont.m_Take[u * 3 + 1] != ship.m_Id) continue;
							if (cont.m_Take[u * 3 + 0] != ship.m_EntityType) continue;
							contid = cont.m_Take[u * 3 + 2];
							break;
						}
					} else break;
				}
			}
		}

		for (i = m_EntityList.length - 1; i >= 0 ; i--) {
			if (m_EntityList[i].m_Tmp == 0) continue;
//trace("fardel:", m_EntityList[i].m_EntityType, m_EntityList[i].m_Id);
			m_EntityList.splice(i, 1);
		}
	}
	
	public function FindPlanetNum():void
	{
		var i:int,u:int,num:int;
		var planet:SpacePlanet;
		for (i = 0; i < m_EntityList.length; i++) {
			var ent:SpaceEntity = m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypePlanet) continue;
			planet = ent as SpacePlanet
			if (planet.m_PlanetNum >= 0) continue;
			if (!planet.m_RecvFull) return;
			
			if (planet.m_CenterId == 0) { planet.m_PlanetNum = 0; continue; }
			
			num = 0;
			for (u = 0; u < i; u++) {
				ent = m_EntityList[u];
				if (ent.m_EntityType == SpaceEntity.TypePlanet && SpacePlanet(ent).m_CenterId == planet.m_CenterId) num++;
			}
			
			planet.m_PlanetNum = num;
		}
	}

	public function DockIsBusy(shipid:uint, port:uint, skip:SpaceEntity = null):Boolean
	{
		var i:int;
		var ship:SpaceShip;

		for (i = 0; i < m_EntityList.length; i++) {
			var ent:SpaceEntity = m_EntityList[i];
            if (ent == skip) continue;
            if (ent.m_EntityType != SpaceEntity.TypeFleet) continue;
			ship = ent as SpaceShip;
            if (!ship.IsLive()) continue;
			if ((ship.m_PFlag & (SpaceShip.PFlagInDock | SpaceShip.PFlagUndock | SpaceShip.PFlagToDock)) && (ship.m_PId == shipid) && (((ship.m_PFlag >> 16) & 255) == port)) return true;
		}
		return false;
	}

	public function EntityFind(type:uint, id:uint, recvfull:Boolean = true):SpaceEntity
	{
		var i:int;

		for (i = 0; i < m_EntityList.length; i++) {
			var ent:SpaceEntity = m_EntityList[i];
			if (recvfull && ent.m_RecvFull==false) continue;
			if (ent.m_EntityType == type && ent.m_Id == id) return ent;
		}
		
		return null;
	}

	public function EntityAdd(type:uint, id:uint):SpaceEntity
	{
		var ent:SpaceEntity = null;

		if (type == SpaceEntity.TypeFleet) {
			ent = new SpaceFleet(this,HS);
			ent.m_EntityType = type;
			ent.m_Id = id;

		} else if (type == SpaceEntity.TypeShuttle) {
			ent = new SpaceShuttle(this, HS);
			ent.m_EntityType = type;
			ent.m_Id = id;

		} else if (type == SpaceEntity.TypeCotl) {
			ent = HS.GetCotl(id, false);
			ent.m_VerOrder = 0;
			ent.m_VerState = 0;
			ent.m_VerSet = 0;
			ent.m_RecvFull = false;

		} else if (type == SpaceEntity.TypePlanet) {
			ent = new SpacePlanet(this,HS);
			ent.m_EntityType = type;
			ent.m_Id = id;

		} else if (type == SpaceEntity.TypeContainer) {
			ent = new SpaceContainer(this,HS);
			ent.m_EntityType = type;
			ent.m_Id = id;
		}
		else throw Error("EntityAdd.Type");

		m_EntityList.push(ent);

		return ent;
	}
	
	static public const EntitySortPrior:Array = [0, 3, 2, 1, 3, 4];
	
	public function EntitySortFun(a:SpaceEntity, b:SpaceEntity):int
	{
		var ent:SpaceEntity;
		var ship:SpaceShip;
		var pa:uint = EntitySortPrior[a.m_EntityType] << 24;
		var pb:uint = EntitySortPrior[b.m_EntityType] << 24;
		
		if (a.m_EntityType == SpaceEntity.TypeFleet || a.m_EntityType == SpaceEntity.TypeShuttle) {
			ship = SpaceShip(a);
			while(ship!=null) {
				if (ship.m_PFlag & SpaceShip.PFlagInDock) {}
				else break;
				pa++;
				ent = EntityFind(ship.m_PFlag >> SpaceShip.PFlagEntityTypeShift, ship.m_PId);
				if (!ent || (ent.m_EntityType != SpaceEntity.TypeFleet && ent.m_EntityType != SpaceEntity.TypeShuttle)) break;
				ship = SpaceShip(ent);
			}
		}
		
		if (b.m_EntityType == SpaceEntity.TypeFleet || b.m_EntityType == SpaceEntity.TypeShuttle) {
			ship = SpaceShip(b);
			while(ship!=null) {
				if (ship.m_PFlag & SpaceShip.PFlagInDock) {}
				else break;
				pb++;
				ent = EntityFind(ship.m_PFlag >> SpaceShip.PFlagEntityTypeShift, ship.m_PId);
				if (!ent || (ent.m_EntityType != SpaceEntity.TypeFleet && ent.m_EntityType != SpaceEntity.TypeShuttle)) break;
				ship = SpaceShip(ent);
			}
		}

		if (pa < pb) return -1;
		else if (pa > pb) return 1;

		if ((a.m_EntityType == SpaceEntity.TypeFleet || a.m_EntityType == SpaceEntity.TypeShuttle) && (b.m_EntityType == SpaceEntity.TypeFleet || b.m_EntityType == SpaceEntity.TypeShuttle)) {
			var aship:SpaceShip = SpaceShip(a);
			var bship:SpaceShip = SpaceShip(b);

			if (aship.m_PPrior < bship.m_PPrior) return -1;
			else if (aship.m_PPrior > bship.m_PPrior) return 1;
		}
		
		if (a.m_Id < b.m_Id) return -1;
		else if (a.m_Id > b.m_Id) return 1;

		return 0;
	}
	
	public function Process(cnttakt:Number):void
	{
		var i:int;
		var ent:SpaceEntity;
		
		m_EntityList.sort(EntitySortFun);

//var t0:Number = Common.GetTime();
		for (i = 0; i < m_EntityList.length; i++) {
			ent = m_EntityList[i];
			if (!ent.m_RecvFull) continue;
			if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				SpaceShip(ent).ProcessOrder(cnttakt);
				SpaceShip(ent).InitRepulsion(cnttakt);
			}
			else if (ent.m_EntityType == SpaceEntity.TypeShuttle) {
				SpaceShuttle(ent).ProcessOrder(cnttakt);
				SpaceShuttle(ent).InitRepulsion(cnttakt);
			}
		}

//var t1:Number = Common.GetTime();
		SpaceShip.ProcessRepulsionZ(this);
		SpaceShip.ProcessRepulsion(cnttakt, this);
//var t2:Number = Common.GetTime();

		for (i = 0; i < m_EntityList.length; i++) {
			ent = m_EntityList[i];
			if (!ent.m_RecvFull) continue;
			if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				if ((ent as SpaceShip).m_ServerCorrectionFactor > 0.0) (ent as SpaceShip).ToServerCorrectionTakt(cnttakt);
				else (ent as SpaceShip).ProcessMove(cnttakt);
				//(ent as SpaceShip).ProcessMove(cnttakt);
				//(ent as SpaceShip).ToServerCorrectionTakt(cnttakt);
				EntityZoneCalc(ent);

			} else if (ent.m_EntityType == SpaceEntity.TypeShuttle) {
				if ((ent as SpaceShip).m_ServerCorrectionFactor > 0.0) (ent as SpaceShip).ToServerCorrectionTakt(cnttakt);
				else (ent as SpaceShip).ProcessMove(cnttakt);
				EntityZoneCalc(ent);

			} else if (ent.m_EntityType == SpaceEntity.TypePlanet) {
				(ent as SpacePlanet).ProcessMove(cnttakt);
				EntityZoneCalc(ent);

			} else if (ent.m_EntityType == SpaceEntity.TypeContainer) {
				(ent as SpaceContainer).ProcessMove(cnttakt);
				EntityZoneCalc(ent);
			}
		}
//var t3:Number = Common.GetTime();
//trace(t1 - t0, t2 - t1, t3 - t2);
	}

	public function EntityZoneCalc(ent:SpaceEntity):void
	{
		var zx:int = 0;
		var zy:int = 0;
		if (ent.m_PosX<0.0 || ent.m_PosX>=m_ZoneSize) zx=Math.floor(ent.m_PosX/m_ZoneSize);
		if (ent.m_PosY<0.0 || ent.m_PosY>=m_ZoneSize) zy=Math.floor(ent.m_PosY/m_ZoneSize);
		if (zx == 0 && zy == 0) return;

		if ((ent.m_ZoneX + zx) < m_ZoneMinX) zx = m_ZoneMinX - ent.m_ZoneX;
		if ((ent.m_ZoneX + zx) >= (m_ZoneMinX + m_ZoneCntX)) zx = (m_ZoneMinX + m_ZoneCntX - 1) - ent.m_ZoneX;

		if ((ent.m_ZoneY + zy) < m_ZoneMinY) zy = m_ZoneMinY - ent.m_ZoneY;
		if ((ent.m_ZoneY + zy) >= (m_ZoneMinY + m_ZoneCntY)) zy = (m_ZoneMinY + m_ZoneCntY - 1) - ent.m_ZoneY;
		
		if (zx == 0 && zy == 0) return;

		ent.m_ZoneX += zx;
		ent.m_ZoneY += zy;
		var cx:Number = -Number(zx) * m_ZoneSize;
		var cy:Number = -Number(zy) * m_ZoneSize;
		ent.m_PosX += cx;
		ent.m_PosY += cy;

		if (ent is SpaceShip) {
			var ship:SpaceShip = ent as SpaceShip;
			ship.m_PlaceX += cx;
			ship.m_PlaceY += cy;
			ship.m_DesX += cx;
			ship.m_DesY += cy;
			ship.m_NewPosX += cx;
			ship.m_NewPosY += cy;
		}
	}
	
	static public function IntersectSphere(centerx:Number, centery:Number, centerz:Number, r:Number, sx:Number, sy:Number, sz:Number, dirx:Number, diry:Number, dirz:Number):Object
	{
		// NaN
		var dx:Number = sx - centerx;
		var dy:Number = sy - centery;
		var dz:Number = sz - centerz;

		var a:Number,b:Number,c:Number;
		a = dirx * dirx + diry * diry + dirz * dirz;
		b = 2.0 * (dirx * dx + diry * dy + dirz * dz);
		c = (dx * dx) + (dy * dy) + (dz * dz) - (r * r);

		var d:Number;

		d = (b * b) - (4.0 * a * c);
		if (d<0.0) {
			//нет пересечения
			return null;
		}

		d = Math.sqrt(d);

		var t1:Number,t2:Number;

		//Вычисяем t1 и t2 (Это длина луча из начальной точки
		var k:Number = 1.0 / (a * 2.0);
		t1 = ( - b + d ) * k;
		t2 = ( - b - d ) * k;

		if (t1 < t2) {
			if (t1 < 0) return t2; else return t1;
		} else {
			if (t2 < 0) return t1; else return t2;
		}

		return null;
	}
	
	public function ClacOrbitAngle(r:Number, n:uint):Number
	{
//return 0;
		var a:Number = Number(n & 15) / 16.0 * 2.0 * Space.pi;
		if (((n >> 4) & 1) != 0) a += (2.0 * Space.pi) / 32.0;

		var mulk:Number = (1.0 / (Number(OrbitTime) * 1000.0)) * 2.0 * Space.pi;
		a = BaseMath.AngleNorm(a + Number(HS.m_ServerTime % (OrbitTime * 1000)) * mulk);

		return a;
	}
	
	public function CalcOrbitRadius(r:Number, n:uint):Number
	{
//return r-500.0;
		return r + Number(n >> 4) * 200.0;
	}

	static private var m_FindEmptyOrbitPlace:Vector.<int> = new Vector.<int>(256);
	
	public function FindEmptyOrbitPlace(et:int, id:Number):int
	{
		var i:int;
		var ent:SpaceEntity;
		var ship:SpaceShip;

		for (i = 0; i < 256; i++) m_FindEmptyOrbitPlace[i] = 0;

		for (i = 0; i < m_EntityList.length; i++) {
			ent = m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypeFleet) continue;
			ship = SpaceShip(ent);
			if ((ship.m_PFlag & SpaceShip.PFlagInOrbitCotl) != 0 && ship.m_PId == id) {
				m_FindEmptyOrbitPlace[(ship.m_PFlag >> 16) & 255] = 1;
			}
			else if ((ship.m_PFlag & SpaceShip.PFlagInOrbitPlanet) != 0 && ship.m_PId == id) {
				m_FindEmptyOrbitPlace[(ship.m_PFlag >> 16) & 255] = 1;
			}
			else if (ship.m_Order == SpaceShip.soOrbitCotl && ship.m_OrderTargetId == id) {
				m_FindEmptyOrbitPlace[(ship.m_OrderFlag >> 16) & 255] = 1;
			}
			else if (ship.m_Order == SpaceShip.soOrbitPlanet && ship.m_OrderTargetId == id) {
				m_FindEmptyOrbitPlace[(ship.m_OrderFlag >> 16) & 255] = 1;
			}
			else continue;
		}
		for (i = 0; i < 256; i++) if (m_FindEmptyOrbitPlace[i] == 0) return i;
		return -1;
	}

	public function FindNearPlanet(zx:int, zy:int, px:Number, py:Number):SpacePlanet
	{
		var dx:Number, dy:Number, dd:Number, bdd:Number;
		var i:int;
		var pt:uint;
		var ent:SpaceEntity;
		var pl:SpacePlanet;
		var bp:SpacePlanet = null;

		for (i = 0; i < m_EntityList.length; i++) {
			ent = m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypePlanet) continue;
			pl = SpacePlanet(ent);
			if (!pl.m_RecvFull) continue;

            pt = pl.m_PlanetFlag & SpacePlanet.FlagTypeMask;
            if (pt != SpacePlanet.FlagTypeSun && pt != SpacePlanet.FlagTypePlanet) continue;

            dx = px - pl.m_PosX + (zx - pl.m_ZoneX) * m_ZoneSize;
            dy = py - pl.m_PosY + (zy - pl.m_ZoneY) * m_ZoneSize;
            dd = dx * dx + dy * dy;

			if (dd >= m_ZoneSize * m_ZoneSize) continue;

            if (bp == null || dd < bdd) {
                bp = pl;
                bdd = dd;
            }
		}
		return bp;
	}
	
	public function SpaceBusy(zx:int, zy:int, px:Number, py:Number, pz:Number, r:Number, skip:SpaceEntity, out:Vector.<SpaceEntity>):Boolean
	{
		var i:int;
		var rent:Number, dx:Number, dy:Number, dz:Number;
		var dw:uint;
		var ent:SpaceEntity;
		var pl:SpacePlanet;
		var ship:SpaceShip;
		
		var ret:Boolean = false;

		for (i = 0; i < m_EntityList.length; i++) {
			ent = m_EntityList[i];
			if (ent == skip) continue;

			rent = 0.0;
			if (ent.m_EntityType == SpaceEntity.TypePlanet) {
				pl = SpacePlanet(ent);
				dw = pl.m_PlanetFlag & SpacePlanet.FlagTypeMask;
				if (dw != SpacePlanet.FlagTypeSun && dw != SpacePlanet.FlagTypePlanet && dw != SpacePlanet.FlagTypeSputnik) continue;
				rent = pl.m_Radius + 100.0;
				
			} else if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				ship = SpaceShip(ent);
				rent = ship.m_Radius;

			} else continue;

			dx = px - ent.m_PosX + m_ZoneSize * (zx - ent.m_ZoneX);
			dy = py - ent.m_PosY + m_ZoneSize * (zy - ent.m_ZoneY);
			dz = pz - ent.m_PosZ;

			if ((dx * dx + dy * dy + dz * dz) > (r + rent) * (r + rent)) continue;

			ret = true;
			if(out) out.push(ent);
		}
		return ret;
	}

	public function CalcContainerVis():void
	{
		var i:int, u:int;
		var ent:SpaceEntity;
		var cont:SpaceContainer;
		var ship:SpaceShip;
		var contid:uint;
		var findstart:Boolean = false;
		for (i = 0; i < m_EntityList.length; i++) {
			ent = m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypeContainer) continue;
			cont = ent as SpaceContainer;
			cont.m_Vis = cont.m_ItemCnt > 0;
		}
		for (i = 0; i < m_EntityList.length; i++) {
			ent = m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypeFleet && ent.m_EntityType != SpaceEntity.TypeShuttle) continue;
			ship = ent as SpaceShip;
			contid = ship.m_DropId;
			findstart = false;
			while (contid) {
				cont = SpaceContainer(EntityFind(SpaceEntity.TypeContainer, contid));
				if (!cont || cont.m_EntityType != SpaceEntity.TypeContainer) break;
				if (!findstart && contid == ship.m_DropProgressId) findstart = true;

				if (cont.m_Vis) cont.m_Vis = !findstart;

				contid = cont.m_DropNextContainerId;
			}

			if (ship.m_Owner != Server.Self.m_UserId) continue;
			contid = ship.m_TakeId;
			while (contid) {
				if (contid == ship.m_TakeProgressId) break;
				cont = SpaceContainer(EntityFind(SpaceEntity.TypeContainer, contid));
				if (!cont || cont.m_EntityType != SpaceEntity.TypeContainer) break;
				
				if (cont.m_Vis) cont.m_Vis = false;
				
				contid = 0;
				for (u = 0; u < SpaceContainer.TakeMax; u++) {
					if (cont.m_Take[u * 3 + 1] != ship.m_Id) continue;
					if (cont.m_Take[u * 3 + 0] != ship.m_EntityType) continue;
					contid = cont.m_Take[u * 3 + 2];
				}
			}
		}
	}
}

}