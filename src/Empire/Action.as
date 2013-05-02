// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import flash.utils.*;

public class Action
{
	private var EM:EmpireMap = null;

	static public const ActionTypeMove:int=1;
	static public const ActionTypeBuild:int=2;
	static public const ActionTypePath:int=3;
	static public const ActionTypeSplit:int=4;
	static public const ActionTypePathMove:int=5;
	static public const ActionTypeMake:int=6;
	static public const ActionTypeGive:int=7;
	static public const ActionTypeDestroy:int=8;
	static public const ActionTypeCargo:int=9;
	static public const ActionTypeResChange:int=10;
	static public const ActionTypeSpecial:int=11;
	static public const ActionTypeResearch:int=12;
	static public const ActionTypeTalent:int=13;
	static public const ActionTypeToHyperspace:int=14;
	static public const ActionTypeFromHyperspace:int=15;
	static public const ActionTypeFleetFuel:int=16;
	static public const ActionTypeCopy:int=17;
	static public const ActionTypeCancelAutoMove:int = 18;
	static public const ActionTypeConstruction:int = 19;
	static public const ActionTypeItemMove:int = 20;
	static public const ActionTypePlanetItemOp:int = 21;
	static public const ActionTypeBuildingLvlBuy:int = 22;
	static public const ActionTypeFleetSpecial:int = 23;
//	static public const ActionTypeCombat:int = 24;
	static public const ActionTypeLink:int = 56;

	public var m_ServerTime:Number;
	public var m_Owner:uint;
	public var m_Type:int;
	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;
	public var m_Cnt:int;
	public var m_Kind:int;
	public var m_TargetSectorX:int;
	public var m_TargetSectorY:int;
	public var m_TargetPlanetNum:int;
	public var m_TargetNum:int;
	public var m_Id:uint;
	public var m_Path:Array = null;
	
	public var m_Tmp0:int = 0;
	public var m_Tmp1:int = 0;
	public var m_Tmp2:int = 0;
	public var m_Tmp3:int = 0;
	public var m_Tmp4:int = 0;
	public var m_Tmp5:int = 0;
	public var m_Tmp6:int = 0;

	public function Action(map:EmpireMap)
	{
		EM=map;
	}

	// Должны в точности соответствовать серверной версии
	public function Process():Boolean
	{
		if (m_Type == ActionTypeMove) return ProcessActionMove();
		else if (m_Type == ActionTypeCancelAutoMove) return ProcessActionCancelAutoMove();
		else if (m_Type == ActionTypeCopy) return ProcessActionCopy();
		else if (m_Type == ActionTypeBuild) return ProcessActionBuild();
		else if (m_Type == ActionTypePath) return ProcessActionPath();
		else if (m_Type == ActionTypeSplit) return ProcessActionSplit();
		else if (m_Type == ActionTypePathMove) return ProcessActionPathMove();
		else if (m_Type == ActionTypeMake) return ProcessActionMake();
		else if (m_Type == ActionTypeGive) return ProcessActionGive();
		else if (m_Type == ActionTypeDestroy) return ProcessActionDestroy();
		else if (m_Type == ActionTypeCargo) return ProcessActionCargo();
		else if (m_Type == ActionTypeResChange) return ProcessActionResChange();
		else if (m_Type == ActionTypeSpecial) return ProcessActionSpecial();
		else if (m_Type == ActionTypeResearch) return ProcessActionResearch();
		else if (m_Type == ActionTypeTalent) return ProcessActionTalent();
		else if (m_Type == ActionTypeToHyperspace) return ProcessActionToHyperspace();
		else if (m_Type == ActionTypeFromHyperspace) return ProcessActionFromHyperspace();
		else if (m_Type == ActionTypeFleetFuel) return ProcessActionFleetFuel();
		else if (m_Type == ActionTypeConstruction) return ProcessActionConstruction();
		else if (m_Type == ActionTypeItemMove) return ProcessActionItemMove();
		else if (m_Type == ActionTypePlanetItemOp) return ProcessActionPlanetItemOp();
		else if (m_Type == ActionTypeBuildingLvlBuy) return ProcessActionBuildingLvlBuy();
		else if (m_Type == ActionTypeFleetSpecial) return ProcessActionFleetSpecial();
//		else if (m_Type == ActionTypeCombat) return ProcessActionCombat();
		return false;
	}

	public function ProcessActionPathMove():Boolean
	{
		var ship2:Ship;
		var snn:int, tt:int, n:int;
		
		if (EM.IsEdit()) return false;

		if (EM.m_CotlType == Common.CotlTypeCombat && (EM.m_GameState & Common.GameStatePlacing) != 0) { EM.m_FormHint.Show(Common.Txt.WarningNoMoveInPlacing, Common.WarningHideTime); return false;	}

		var sec:Sector = EM.GetSector(m_SectorX, m_SectorY);
		if (sec == null) return false;
		var planet:Planet = sec.m_Planet[m_PlanetNum];

		if (m_Path == null) return false;
		if (m_Path.length <= 0) return false;

		var goall:Boolean = true;
		
		var gcnt:int = 0;
		if (m_Tmp0 >= 0) gcnt++;
		if (m_Tmp1 >= 0) gcnt++;
		if (m_Tmp2 >= 0) gcnt++;
		if (m_Tmp3 >= 0) gcnt++;
		if (m_Tmp4 >= 0) gcnt++;
		if (m_Tmp5 >= 0) gcnt++;
		if (m_Tmp6 >= 0) gcnt++;

		for (snn = 0; snn < 7; snn++) {
			if (snn == 0) n = m_Tmp0;
			else if (snn == 1) n = m_Tmp1;
			else if (snn == 2) n = m_Tmp2;
			else if (snn == 3) n = m_Tmp3;
			else if (snn == 4) n = m_Tmp4;
			else if (snn == 5) n = m_Tmp5;
			else if (snn == 6) n = m_Tmp6;
			else break;
			if (n < 0) continue;

			var ship:Ship = planet.m_Ship[n];

			if (ship.m_Type == Common.ShipTypeNone || Common.IsBase(ship.m_Type)) { goall = false; continue; }
			//if(ship.m_Owner!=m_Owner) return false;
			if (!EM.AccessControl(ship.m_Owner)) { goall = false; continue; }

			//ship.m_LogicTimeLock=0;
			ship.m_Link = 0;
			ship.m_Flag &= ~(Common.ShipFlagPortal|Common.ShipFlagEject /*@| Common.ShipFlagAutoReturn | Common.ShipFlagAutoLogic*/ | Common.ShipFlagCapture | Common.ShipFlagExchange);

			var off:uint = m_Path[0];
			var tgtsecx:int = m_SectorX;
			var tgtsecy:int = m_SectorY;
			if (off & 1) tgtsecx++;
			if (off & 2) tgtsecx--;
			if (off & 4) tgtsecy++;
			if (off & 8) tgtsecy--;
			var tgtplanet:int = (off >> 4) & 7;

			var tgtsec:Sector = EM.GetSector(tgtsecx, tgtsecy);
			if (tgtsec == null) return false;
			if (tgtplanet<0 || tgtplanet>=tgtsec.m_Planet.length) return false;
			if (m_SectorX == tgtsecx && m_SectorY == tgtsecy && m_PlanetNum == tgtplanet) return false;

			ship.m_Group = m_Id | (gcnt<<4) | snn;
			/*| (m_MoveListNum.length << 4) | (u)*/

			var speed:int = EM.CalcSpeed(ship.m_Owner, ship.m_Id, ship.m_Type);
			if (m_Kind < speed) speed = m_Kind;
			if (speed < 1) speed = 1;

			while(true) {
				if (ship.m_ArrivalTime > EM.m_ServerCalcTime) { goall = false; break; }
				if (ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb)) { goall = false; break; }

				//if(ship.m_Type!=Common.ShipTypeCorvette && EM.IsBattle(planet,m_Owner,Common.RaceNone)) break;
				if (!EM.CanLeavePlanet(planet, ship)) { goall = false; break; }
				if (ship.m_Fuel < Common.FuelFlyOne) { goall = false; break; }

				var planet2:Planet = tgtsec.m_Planet[tgtplanet];
				if(planet2.m_Flag & Planet.PlanetFlagNoMove) { goall = false; break; }
				if((planet2.m_Flag & Planet.PlanetFlagWormhole) && !(planet2.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen))) { goall = false; break; }

				if ((planet2.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
					if (!(planet2.m_Flag & Planet.PlanetFlagStabilizer)) { goall = false; break; }
				}

				if(EM.GetRel(ship.m_Owner,planet2.m_Owner) & Common.PactNoFly) { EM.m_FormHint.Show(Common.Txt.WarningPactNoFly,Common.WarningHideTime); goall = false; break; }

	//			if((planet2.m_Flag & (Planet.PlanetFlagGravitor|Planet.PlanetFlagGravitorSci))!=0) {
	//				EM.m_FormHint.Show(Common.Txt.WarningMoveGravitor,Common.WarningHideTime);
	//				break;
	//			}

				var fly:Boolean = true;
				while (true) {
					if (EM.IsEdit()) break;
					if ((planet2.m_Flag & (Planet.PlanetFlagGravitorSci | Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGravitorSci | Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) { EM.m_FormHint.Show(Common.Txt.WarningMoveGravitorPulsar, Common.WarningHideTime); fly = false; break; }
					if ((planet2.m_Flag & (Planet.PlanetFlagGravitor)) == 0) break;
//					if (ship.m_Type == Common.ShipTypeCorvette || ship.m_Type == Common.ShipTypeTransport) break;
					if (ship.m_Type == Common.ShipTypeFlagship) {
						var user:User = UserList.Self.GetUser(ship.m_Owner);
						if (user != null) {
							var cpt:Cpt = user.GetCpt(ship.m_Id);
							if (cpt != null) {
								if (cpt.CalcVecLvl(Common.VecMoveAccelerator) >= 2) break;
							}
						}
					}

					EM.m_FormHint.Show(Common.Txt.WarningMoveGravitor,Common.WarningHideTime);
					fly=false;
					break;
				}
				if (!fly) { goall = false; break; }
				
				break;
			}
		}

		if(goall)
		for (snn = 0; snn < 7; snn++) {
			if (snn == 0) n = m_Tmp0;
			else if (snn == 1) n = m_Tmp1;
			else if (snn == 2) n = m_Tmp2;
			else if (snn == 3) n = m_Tmp3;
			else if (snn == 4) n = m_Tmp4;
			else if (snn == 5) n = m_Tmp5;
			else if (snn == 6) n = m_Tmp6;
			else break;
			if (n < 0) continue;

			ship = planet.m_Ship[n];

			if (ship.m_Type == Common.ShipTypeNone || Common.IsBase(ship.m_Type)) continue;
			if (!EM.AccessControl(ship.m_Owner)) continue;
			
			off = m_Path[0];
			tgtsecx = m_SectorX;
			tgtsecy = m_SectorY;
			if (off & 1) tgtsecx++;
			if (off & 2) tgtsecx--;
			if (off & 4) tgtsecy++;
			if (off & 8) tgtsecy--;
			tgtplanet = (off >> 4) & 7;

			tgtsec = EM.GetSector(tgtsecx, tgtsecy);
			if (tgtsec == null) continue;
			if (tgtplanet<0 || tgtplanet>=tgtsec.m_Planet.length) continue;
			if (m_SectorX == tgtsecx && m_SectorY == tgtsecy && m_PlanetNum == tgtplanet) continue;

			if (!EM.CanLeavePlanet(planet, ship)) continue;

			planet2 = tgtsec.m_Planet[tgtplanet];

			var tgtnum:int = EM.CalcEmptyPlaceEx(planet2, ship.m_Owner, ship.m_Race, ship.m_Group);
			if (tgtnum < 0) continue;
			ship2 = planet2.m_Ship[tgtnum];
			if (ship2.m_Type != Common.ShipTypeNone) continue;

			if(planet2.m_Flag & Planet.PlanetFlagWormhole) {
				if (EM.m_CotlType == Common.CotlTypeCombat) {
					tt = EM.TeamType();
					if (tt >= 0 && tt != (tgtnum & 1)) continue;
				} else {
					if (tgtnum & 1) continue;
				}
			} else {
				if (ship.m_Type != Common.ShipTypeCorvette && EM.IsRear(planet2, tgtnum, ship.m_Owner, ship.m_Race, true)) continue;
			}
			if (EM.CntFriendGroup(planet2, ship.m_Owner, ship.m_Race) >= Common.GroupInPlanetMax) continue;

			var fuel:int = Math.floor(ship.m_Fuel / Common.FuelFlyOne);
			if (fuel > 0) ship.m_Fuel = (fuel - 1) * Common.FuelFlyOne;
			else ship.m_Fuel = 0;

			ship2.Copy(ship);//,true);
			ship.Clear();
			ship2.m_ArrivalTime = m_ServerTime + EM.CalcFlyTimeEx(speed, ship2.m_Owner,ship2.m_Race, planet, planet2) * 1000;
			ship2.m_FromSectorX = m_SectorX;
			ship2.m_FromSectorY = m_SectorY;
			ship2.m_FromPlanet = m_PlanetNum;
			ship2.m_FromPlace = n;
			ship2.m_Link = 0;
			ship2.m_Flag &= ~(Common.ShipFlagPortal|Common.ShipFlagEject /*@| Common.ShipFlagAutoReturn | Common.ShipFlagAutoLogic*/ | Common.ShipFlagBattle);
			ship2.m_BattleTimeLock = ship2.m_ArrivalTime + Common.BattleLock * 1000;
		}

		return true;
	}
	
	public function ProcessActionCancelAutoMove():Boolean
	{
		var x:int,y:int,i:int,u:int;
		var sec:Sector;
		var planet:Planet;
		var ship:Ship;
		
		if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap)==0) return false;

		var sx:int=Math.max(EM.m_SectorMinX,m_SectorX-1);
		var sy:int=Math.max(EM.m_SectorMinY,m_SectorY-1);
		var ex:int=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,m_SectorX+2);
		var ey:int=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,m_SectorY+2);

		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				sec=EM.GetSector(x,y);
				if(sec==null) continue;
				
				for(i=0;i<sec.m_Planet.length;i++) {
					planet=sec.m_Planet[i];
					
					for(u=0;u<Common.ShipOnPlanetMax;u++) {
						ship=planet.m_Ship[u];
						
						if(ship.m_Id==m_Id) {

							if(!EM.IsEdit() && !EM.AccessControl(ship.m_Owner)) return false;

							ship.m_Link = 0;
							ship.m_Flag&=~(Common.ShipFlagPortal|Common.ShipFlagEject/*|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/|Common.ShipFlagCapture|Common.ShipFlagExchange|Common.ShipFlagAIRoute);
							ship.m_Path = 0;
							if(ship.m_CargoType!=0 && ship.m_CargoCnt<=0) {
								ship.m_CargoType=0;
								ship.m_CargoCnt=0;
							}
							return true;
						}
					}
				}
			}
		}
					
		return false;
	}

	public function ProcessActionMove():Boolean
	{
		var cnt:int, smc:int, tt:int;
		var dx:int, dy:int;
		var ship2:Ship;
		var planet2:Planet;
		
		if (EM.IsEdit()) return false;

		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) {
			if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. sec==null");
			return false;
		}
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		var ship:Ship=planet.m_Ship[m_ShipNum];
		if(ship.m_Type==Common.ShipTypeNone) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. ShipType==None");
			return false;
		}
		//if(ship.m_Owner!=m_Owner) {
		if(!EM.IsEdit() && !EM.AccessControl(ship.m_Owner)) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. ShipOwner!=ActionOwner");
			return false;
		}

		ship.m_Path=0;
		if(m_SectorX==m_TargetSectorX && m_SectorY==m_TargetSectorY && m_PlanetNum==m_TargetPlanetNum && m_ShipNum==m_TargetNum) {
			// Чистим автоматическую логику
			ship.m_Link = 0;
			ship.m_Flag&=~(Common.ShipFlagPortal|Common.ShipFlagEject/*@|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/|Common.ShipFlagCapture|Common.ShipFlagExchange|Common.ShipFlagAIRoute);
			return true;
		}

		if ((ship.m_Type==Common.ShipTypeQuarkBase) && (ship.m_Flag & Common.ShipFlagBattle)!=0 && (ship.m_BattleTimeLock > EM.m_ServerCalcTime)) {
			EM.m_FormHint.Show(Common.Txt.WarningNeedReloadReactor, Common.WarningHideTime); 
			return false;
		}

		if(ship.m_ArrivalTime>EM.m_ServerCalcTime) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. ArrivalTime");
			return false;
		}
		if(ship.m_Flag & (Common.ShipFlagBomb)) return false;

//		if(ship.m_Type==Common.ShipTypeTransport && ship.m_LogicTimeLock) {
//			if(m_ServerTime>ship.m_LogicTimeLock-4000-2000 && m_ServerTime<ship.m_LogicTimeLock+4000) return false; // убрать везде
//		}

		var tgtsec:Sector=EM.GetSector(m_TargetSectorX,m_TargetSectorY);
		if(tgtsec==null) return false;

		if(sec==tgtsec && m_PlanetNum==m_TargetPlanetNum) {
			// Перемещение на орбите текущей планеты
			if(m_ShipNum==m_TargetNum) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. ShipNum==TargetNum");
				return false;
			}

			if(m_TargetNum<0) {
				if(planet.m_Flag & Planet.PlanetFlagWormhole) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. TargetNum<0 && PlanetFlagWormhole");
					return false;
				}
				if(ship.m_Type==Common.ShipTypeInvader) {
					if (planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant)) return false;
					if (EM.IsFriendEx(planet, planet.m_Owner, planet.m_Race, ship.m_Owner, ship.m_Race)) return false;

					if(planet.m_Owner==0 && planet.m_Level>ship.m_Cnt) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureLvl,Common.WarningHideTime); return false; }

					if(EM.m_CotlType!=Common.CotlTypeProtect && EM.m_CotlType!=Common.CotlTypeCombat && !EM.IsWinMaxEnclave()) {
						while(ship.m_Owner==Server.Self.m_UserId) {
							if(!EM.m_EmpireColony && ship.m_Owner==EM.m_CotlOwnerId && EM.IsEmpirePlanet(planet)) {
								if(EM.m_UserEmpirePlanetCnt>=EM.PlanetEmpireMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureEmpire,Common.WarningHideTime); return false; }
								break;
							}
							if (EM.m_EmpireColony && EM.m_HomeworldPlanetNum >= 0 && EM.m_HomeworldIsland != 0 && EM.IsNearIsland(planet, EM.m_HomeworldIsland) && EM.IsEmpirePlanet(planet)) {
								if(EM.m_UserEmpirePlanetCnt>=EM.PlanetEmpireMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureEmpire,Common.WarningHideTime); return false; }
								break;
							}
							if(EM.IsNearIslandCitadel(planet)>0) {
								if(EM.m_UserEnclavePlanetCnt>=EM.PlanetEnclaveMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureEnclave,Common.WarningHideTime); return false; }
								break;
							}
							if(EM.m_UserColonyPlanetCnt>=EM.PlanetColonyMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureColony,Common.WarningHideTime); return false; }
							break;
						}
						if(ship.m_Owner==Server.Self.m_UserId && EM.m_UserPlanetCnt>=(EM.PlanetColonyMax(m_Owner)+EM.PlanetEmpireMax(m_Owner)+EM.PlanetEnclaveMax(m_Owner))) { EM.m_FormHint.Show(Common.Txt.WarningNoCapturePlanet,Common.WarningHideTime); return false; }
					}

	            	ship.m_Flag|=Common.ShipFlagCapture;
	            	return true;
	            }
/*				if(ship.m_CargoCnt>0) {
	            	cnt=ship.m_CargoCnt;
	            	var cpm:int=EM.DirValE(m_Owner,Common.DirModuleMax);
	            	if(planet.m_Flag & (Planet.PlanetFlagHomeworld|Planet.PlanetFlagCitadel)) cpm*=Common.ModuleMaxMul;
    	        	if(planet.m_ConstructionPoint+cnt>cpm) cnt=cpm-planet.m_ConstructionPoint;
        	    	if(cnt>0) {
            		    planet.m_ConstructionPoint+=cnt;
        	    	    ship.m_CargoCnt-=cnt;
	            	}
	   			}*/
	            //if(ship.m_Type==Common.ShipTypeTransport) 
//@				ship.m_Flag=(ship.m_Flag & (~Common.ShipFlagAutoReturn)) | Common.ShipFlagAutoLogic;
				if(ship.m_Flag & Common.ShipFlagEject) {
					ship.m_Flag &= ~Common.ShipFlagEject;
					ship.m_BattleTimeLock = m_ServerTime + Common.BattleLock;
				}

				EM.LinkSet(planet, ship, planet);
	            //else if(ship.m_Type==Common.ShipTypeDevastator || ship.m_Type==Common.ShipTypeFlagship || ship.m_Type==Common.ShipTypeCruiser) ship.m_Flag=(ship.m_Flag & (~Common.ShipFlagAutoReturn)) | Common.ShipFlagAutoLogic;
	            return true;
			}

			if(m_TargetNum<0) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. TargetNum<0");
				return false;
			}
			ship2=planet.m_Ship[m_TargetNum];

			if(ship2.m_Type==Common.ShipTypeNone) {
				// Место пустое
				if(EM.IsEdit()) {}
				else if (planet.m_Flag & Planet.PlanetFlagWormhole) {
					if (m_TargetNum >= planet.ShipOnPlanetLow) return false;
					if((m_ShipNum & 1) != (m_TargetNum & 1)) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. Wormhole");
						return false;
					}
				} else {
					if(ship.m_Type!=Common.ShipTypeCorvette && EM.IsRear(planet,m_TargetNum,ship.m_Owner,ship.m_Race,true)) { 
						EM.m_FormHint.Show(Common.Txt.WarningRear,Common.WarningHideTime);
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. Rear");
						return false; 
					}
				}

				if (m_TargetNum >= planet.ShipOnPlanetLow) {
					if (!Common.ShipLowOrbit[ship.m_Type]) return false;
					if (m_ShipNum<planet.ShipOnPlanetLow && !EM.AccessLowOrbit(planet, ship.m_Owner, ship.m_Race)) return false;
				} else if (m_ShipNum >= planet.ShipOnPlanetLow) {
					if (!EM.AccessBaseOrbit(planet, ship.m_Owner, ship.m_Race)) return false;
				}

				ship2.Copy(ship);//,true);
				ship.Clear();

				if (EM.IsEdit()) {
					ship2.m_Link = 0;
					ship2.m_Flag &= ~(Common.ShipFlagPortal|Common.ShipFlagEject/*|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/| Common.ShipFlagCapture | Common.ShipFlagExchange);
					ship2.m_ArrivalTime=0;
					ship2.m_FromSectorX=m_TargetSectorX;
					ship2.m_FromSectorY=m_TargetSectorY;
					ship2.m_FromPlanet=m_TargetPlanetNum;
					ship2.m_FromPlace=m_TargetNum;
					ship2.m_Flag|=Common.ShipFlagExchange;
				} else {
					ship2.m_Link = 0;
					ship2.m_Flag &= ~(Common.ShipFlagPortal|Common.ShipFlagEject/*|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/| Common.ShipFlagBattle | Common.ShipFlagCapture | Common.ShipFlagExchange);
					ship2.m_ArrivalTime=m_ServerTime+3*1000;
					ship2.m_FromSectorX=m_SectorX;
					ship2.m_FromSectorY=m_SectorY;
					ship2.m_FromPlanet=m_PlanetNum;
					ship2.m_FromPlace=m_ShipNum;
				}
				if(!(ship2.m_Flag & Common.ShipFlagBuild)) ship2.m_BattleTimeLock=ship2.m_ArrivalTime+Common.BattleLock*1000;
				
				//if(ship2.m_Type==Common.ShipTypeTransport) ship2.m_LogicTimeLock=ship2.m_ArrivalTime+Common.TransportLogicLockAfterMove;
				//else ship2.m_LogicTimeLock=0;

			} else {
				// Место занаято
				if (ship.m_Flag & (Common.ShipFlagBuild)) return false;
				if(ship.m_Flag & Common.ShipFlagPhantom) return false;

				smc=EM.ShipMaxCnt(ship2.m_Owner,ship2.m_Type);
				if(ship2.m_Cnt>=smc) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. ShipCnt>=ShipMaxCnt");
					return false;
				}
			    if(ship2.m_Owner!=ship.m_Owner) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. TargetOwner!=ActionOwner");
			    	return false;
			    }
			    if(ship2.m_Type!=ship.m_Type) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. TargetType!=ShipType");
			    	return false;
			    }
				if(ship2.m_Flag & Common.ShipFlagPhantom) return false
			    if(ship2.m_Race!=ship.m_Race) {
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. TargetRace!=ShipRace");
			    	return false;
			    }
				if(ship2.m_Flag & (Common.ShipFlagBuild|Common.ShipFlagBomb)) return false;
			    if(ship2.m_Cnt+ship.m_Cnt<=smc) {
			    	ship2.m_Fuel = Math.floor((ship2.m_Fuel * ship2.m_Cnt + ship.m_Fuel * ship.m_Cnt) / (ship2.m_Cnt + ship.m_Cnt));
					EM.ShieldAdd(ship2, ship);
					//ship2.m_Shield += ship.m_Shield;
			        ship2.m_Cnt+=ship.m_Cnt;
			        ship2.m_CntDestroy+=ship.m_CntDestroy;
			        ship2.m_HP-=EM.ShipMaxHP(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race)-ship.m_HP;
			        if(ship2.m_HP<=0) { ship2.m_HP=EM.ShipMaxHP(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race)+ship2.m_HP; ship2.m_Cnt--; }
			        if(ship2.m_HP<=0 || ship2.m_Cnt<=0) ship2.Clear();
 					//ship2.m_CargoCnt+=ship.m_CargoCnt;
 					if (!(ship2.m_Flag & (Common.ShipFlagPortal | Common.ShipFlagEject))) ship2.m_BattleTimeLock = m_ServerTime;//+Common.LogicLockAfterMove;
 					if (ship.m_Fuel > ship2.m_Fuel) ship2.m_Fuel = ship.m_Fuel;

					if(ship2.m_CargoType!=Common.ItemTypeNone && ship2.m_CargoType==ship.m_CargoType) {
						ship2.m_CargoCnt += ship.m_CargoCnt;
						if (ship2.m_CargoCnt > EM.CargoMax(ship2.m_Type, ship2.m_Cnt + ship2.m_CntDestroy)) ship2.m_CargoCnt = EM.CargoMax(ship2.m_Type, ship2.m_Cnt + ship2.m_CntDestroy);

					} else if(ship2.m_CargoType==Common.ItemTypeNone && ship.m_CargoType!=Common.ItemTypeNone) {
 						ship2.m_CargoType = ship.m_CargoType;
 						ship2.m_CargoCnt = ship.m_CargoCnt;
						if (ship2.m_CargoCnt > EM.CargoMax(ship2.m_Type, ship2.m_Cnt + ship2.m_CntDestroy)) ship2.m_CargoCnt = EM.CargoMax(ship2.m_Type, ship2.m_Cnt + ship2.m_CntDestroy);
 					}

					if(ship2.m_ItemType!=Common.ItemTypeNone && ship2.m_ItemType==ship.m_ItemType) {
						ship2.m_ItemCnt+=ship.m_ItemCnt;

					} else if(ship2.m_ItemType==Common.ItemTypeNone && ship.m_ItemType!=Common.ItemTypeNone) {
 						ship2.m_ItemType=ship.m_ItemType;
 						ship2.m_ItemCnt=ship.m_ItemCnt;
 					}
					
					if (ship.m_AbilityCooldown0 > ship2.m_AbilityCooldown0) ship2.m_AbilityCooldown0 = ship.m_AbilityCooldown0;
					if (ship.m_AbilityCooldown1 > ship2.m_AbilityCooldown1) ship2.m_AbilityCooldown1 = ship.m_AbilityCooldown1;
					if (ship.m_AbilityCooldown2 > ship2.m_AbilityCooldown2) ship2.m_AbilityCooldown2 = ship.m_AbilityCooldown2;

					//if(ship2.m_Type==Common.ShipTypeTransport) ship2.m_LogicTimeLock=m_ServerTime+Common.TransportLogicLockAfterMove;
					//else ship2.m_LogicTimeLock=0;
 			        ship.Clear();
			    } else {
			        cnt=smc-ship2.m_Cnt;
			        ship2.m_Fuel = Math.floor((ship2.m_Fuel * ship2.m_Cnt + ship.m_Fuel * cnt) / (ship2.m_Cnt + cnt));

					if(ship.m_Shield>0 && ship.m_Cnt>0) {
						var sc:int=cnt * Math.floor(ship.m_Shield / ship.m_Cnt);
						ship2.m_Shield += sc;
						ship.m_Shield -= sc;
						if (ship2.m_Shield > Common.GaalBarrierMax && ship2.m_Race == Common.RaceGaal && ship2.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship2.m_Type)) ship2.m_Shield = Common.GaalBarrierMax;
						if (ship.m_Shield > Common.GaalBarrierMax && ship.m_Race == Common.RaceGaal && ship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type)) ship.m_Shield = Common.GaalBarrierMax;
					}

					if(ship.m_CargoType!=0 && ship.m_CargoCnt>0 && (ship2.m_CargoType==Common.ItemTypeNone || ship2.m_CargoType==ship.m_CargoType)) {
						var movecargo:int=Math.floor(((ship.m_CargoCnt)*cnt)/ship.m_Cnt);
						ship.m_CargoCnt-=movecargo;
						if(ship2.m_CargoType==Common.ItemTypeNone) { ship2.m_CargoType=ship.m_CargoType; ship2.m_CargoCnt=0; }
						ship2.m_CargoCnt+=movecargo;
					}
			        ship2.m_Cnt+=cnt;
			        ship.m_Cnt-=cnt;
					if (!(ship2.m_Flag & (Common.ShipFlagPortal | Common.ShipFlagEject))) ship2.m_BattleTimeLock = m_ServerTime;//+Common.LogicLockAfterMove;
					if (!(ship.m_Flag & (Common.ShipFlagPortal | Common.ShipFlagEject))) ship.m_BattleTimeLock = m_ServerTime;//+Common.LogicLockAfterMove;
					
					
					if (cnt > 0) {
						if (ship.m_AbilityCooldown0 > ship2.m_AbilityCooldown0) ship2.m_AbilityCooldown0 = ship.m_AbilityCooldown0;
						if (ship.m_AbilityCooldown1 > ship2.m_AbilityCooldown1) ship2.m_AbilityCooldown1 = ship.m_AbilityCooldown1;
						if (ship.m_AbilityCooldown2 > ship2.m_AbilityCooldown2) ship2.m_AbilityCooldown2 = ship.m_AbilityCooldown2;
					} else if (cnt < 0) {
						if (ship2.m_AbilityCooldown0 > ship.m_AbilityCooldown0) ship.m_AbilityCooldown0 = ship2.m_AbilityCooldown0;
						if (ship2.m_AbilityCooldown1 > ship.m_AbilityCooldown1) ship.m_AbilityCooldown1 = ship2.m_AbilityCooldown1;
						if (ship2.m_AbilityCooldown2 > ship.m_AbilityCooldown2) ship.m_AbilityCooldown2 = ship2.m_AbilityCooldown2;
					}
					
//					if(ship2.m_Type==Common.ShipTypeTransport) {
//						ship2.m_LogicTimeLock=m_ServerTime+Common.TransportLogicLockAfterMove;
//						ship.m_LogicTimeLock=m_ServerTime+Common.TransportLogicLockAfterMove;
//					} else {
//						ship2.m_LogicTimeLock=0;
//						ship.m_LogicTimeLock=0;
//					}
					
			    }
			}
		} else {
			// Перемещение на другую планету
			if (EM.m_CotlType == Common.CotlTypeCombat && (EM.m_GameState & Common.GameStatePlacing) != 0) { EM.m_FormHint.Show(Common.Txt.WarningNoMoveInPlacing,Common.WarningHideTime); return false;	}

			planet2=tgtsec.m_Planet[m_TargetPlanetNum];
			
            if(ship.m_Type!=Common.ShipTypeInvader && m_TargetNum<0) {
				planet2=tgtsec.m_Planet[m_TargetPlanetNum];
				if(planet2.m_Flag & Planet.PlanetFlagWormhole) return false; 

				if (ship.m_Type == Common.ShipTypeSciBase) {
					if (EM.EjectAccess(planet, planet2, ship.m_Owner, ship.m_Race) == 0) return false;
				} else {
					dx = planet2.m_PosX - planet.m_PosX;
					dy = planet2.m_PosY - planet.m_PosY;
					if ((dx * dx + dy * dy) > EM.JumpRadius2) return false;
				}

				if(ship.m_Flag & Common.ShipFlagEject) {
					ship.m_Flag &= ~Common.ShipFlagEject;
					ship.m_BattleTimeLock = m_ServerTime + Common.BattleLock;
				}
				EM.LinkSet(planet, ship, planet2);
                return true;

/*            } else if((ship.m_Type==Common.ShipTypeDevastator || ship.m_Type==Common.ShipTypeFlagship || ship.m_Type==Common.ShipTypeCruiser) && m_TargetNum<0) {
				planet2=tgtsec.m_Planet[m_TargetPlanetNum];
            	if(planet2.m_Flag & Planet.PlanetFlagWormhole) return false; 

                ship.m_Flag=(ship.m_Flag & (~Common.ShipFlagAutoLogic)) | Common.ShipFlagAutoReturn;
                ship.m_FromSectorX=tgtsec.m_SectorX;
                ship.m_FromSectorY=tgtsec.m_SectorY;
                ship.m_FromPlanet=m_TargetPlanetNum;
                ship.m_FromPlace=0;
                return true;*/
            }
			
			dx = planet2.m_PosX - planet.m_PosX;
			dy = planet2.m_PosY - planet.m_PosY;
			if ((dx * dx + dy * dy) > EM.JumpRadius2) return false;

			if(!EM.IsEdit() && Common.IsBase(ship.m_Type)) return false;
			if(ship.m_Flag & (Common.ShipFlagBuild)) return false;

			//if(ship.m_Type!=Common.ShipTypeCorvette && EM.IsBattle(planet,m_Owner,Common.RaceNone)) { EM.m_FormHint.Show(Common.Txt.WarningNoLeaveBattle,Common.WarningHideTime); return false; }
			if(!EM.IsEdit()) {
				if(!EM.CanLeavePlanet(planet,ship)) { EM.m_FormHint.Show(Common.Txt.WarningNoLeaveBattle,Common.WarningHideTime); return false; }
				if ((ship.m_Flag & Common.ShipFlagPhantom) == 0 && ship.m_Fuel < Common.FuelFlyOne) { EM.m_FormHint.Show(Common.Txt.WarningNoFuel, Common.WarningHideTime); return false; }
			}

			if (!EM.IsEdit()) {
				if (planet2.m_Flag & Planet.PlanetFlagNoMove) return false;
				if((planet2.m_Flag & Planet.PlanetFlagWormhole) && !(planet2.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen))) return false;

            	if((planet2.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
                	if(!(planet2.m_Flag & Planet.PlanetFlagStabilizer)) { EM.m_FormHint.Show(Common.Txt.WarningNoToPulsar,Common.WarningHideTime); return false; }
            	}

				if(EM.GetRel(ship.m_Owner,planet2.m_Owner) & Common.PactNoFly) { EM.m_FormHint.Show(Common.Txt.WarningPactNoFly,Common.WarningHideTime); return false; }
   			}

			if (m_TargetNum >= planet2.ShipOnPlanetLow) {
				if (planet2.m_Flag & Planet.PlanetFlagWormhole) return false;
				if (!Common.ShipLowOrbit[ship.m_Type]) return false;
				if (!EM.AccessLowOrbit(planet2, ship.m_Owner, ship.m_Race)) return false;
			}

			var tgtno:Boolean=m_TargetNum<0;
			var targetnum:int=m_TargetNum;
			if(targetnum>=0) {
				ship2=planet2.m_Ship[targetnum];
				if(ship2.m_Type!=Common.ShipTypeNone) tgtno=true;
				else if(!(planet2.m_Flag & Planet.PlanetFlagWormhole)) {				
					if(EM.IsRearEnemyStealth(planet2,targetnum,ship.m_Owner,Common.RaceNone)) tgtno=true;
				}
			}
			if(tgtno) {
				if (planet2.m_Flag & Planet.PlanetFlagWormhole) return false;
				targetnum = EM.CalcEmptyPlace(planet2, ship.m_Owner, ship.m_Race, true, true);
			}
			if(targetnum<0) return false;

			ship2=planet2.m_Ship[targetnum];
			if(ship2.m_Type!=Common.ShipTypeNone) return false;

			if(EM.IsEdit()) {}
			else if (planet2.m_Flag & Planet.PlanetFlagWormhole) {
				if (EM.m_CotlType == Common.CotlTypeCombat) {
					tt = EM.TeamType();
					if (tt >= 0 && tt != (targetnum & 1)) return false;
				} else {
					if (targetnum & 1) return false;
				}
			} else {
				if(ship.m_Type!=Common.ShipTypeCorvette && EM.IsRear(planet2,targetnum,ship.m_Owner,ship.m_Race,true)) { EM.m_FormHint.Show(Common.Txt.WarningRear,Common.WarningHideTime); return false; }
			}
			if (m_TargetNum < planet2.ShipOnPlanetLow && EM.CntFriendGroup(planet2, ship.m_Owner, ship.m_Race) >= Common.GroupInPlanetMax) { 
				EM.m_FormHint.Show(Common.Txt.WarningMaxGroup,Common.WarningHideTime);
if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("ProcessActionMove. InOtherPlanetMaxGroup");
				return false;
			}

			while(true) {
				if(EM.IsEdit()) break;
				if((planet2.m_Flag & (Planet.PlanetFlagGravitorSci|Planet.PlanetFlagSun|Planet.PlanetFlagLarge))==(Planet.PlanetFlagGravitorSci|Planet.PlanetFlagSun|Planet.PlanetFlagLarge)) { EM.m_FormHint.Show(Common.Txt.WarningMoveGravitorPulsar,Common.WarningHideTime); return false; }
				if((planet2.m_Flag & (Planet.PlanetFlagGravitor))==0) break;
//				if(ship.m_Type==Common.ShipTypeCorvette || ship.m_Type==Common.ShipTypeTransport) break;
				if(ship.m_Type==Common.ShipTypeFlagship) {
					var user:User=UserList.Self.GetUser(ship.m_Owner);
					if(user!=null) {
						var cpt:Cpt=user.GetCpt(ship.m_Id);
						if(cpt!=null) {
							if(cpt.CalcVecLvl(Common.VecMoveAccelerator)>=2) break;
						}
					}
				}

				EM.m_FormHint.Show(Common.Txt.WarningMoveGravitor,Common.WarningHideTime);
				return false;
			}

			if(ship.m_Type==Common.ShipTypeInvader && tgtno) {
				if(planet2.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant)) return false;
				
				if(planet2.m_Owner==0 && planet2.m_Level>ship.m_Cnt) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureLvl,Common.WarningHideTime); return false; }
				//if(ship.m_Owner==Server.Self.m_UserId && EM.m_UserColonyPlanetCnt>=EM.DirValE(Common.DirColonyMax)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureColony,Common.WarningHideTime); return false; }
				
				if(EM.m_CotlType!=Common.CotlTypeProtect && EM.m_CotlType!=Common.CotlTypeCombat && !EM.IsWinMaxEnclave()) {
					while(ship.m_Owner==Server.Self.m_UserId) {
						if(!EM.m_EmpireColony && ship.m_Owner==EM.m_CotlOwnerId && EM.IsEmpirePlanet(planet2)) {
							if(EM.m_UserEmpirePlanetCnt>=EM.PlanetEmpireMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureEmpire,Common.WarningHideTime); return false; }
							break;
						}
						if (EM.m_EmpireColony && EM.m_HomeworldPlanetNum >= 0 && EM.IsNearIsland(planet2, EM.m_HomeworldIsland) && EM.IsEmpirePlanet(planet2)) {
							if(EM.m_UserEmpirePlanetCnt>=EM.PlanetEmpireMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureEmpire,Common.WarningHideTime); return false; }
							break;
						}
						if (EM.IsNearIslandCitadel(planet2)>0) {
							if(EM.m_UserEnclavePlanetCnt>=EM.PlanetEnclaveMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureEnclave,Common.WarningHideTime); return false; }
							break;
						}
						if(EM.m_UserColonyPlanetCnt>=EM.PlanetColonyMax(m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningNoCaptureColony,Common.WarningHideTime); return false; }
						break;
					}
					if(ship.m_Owner==Server.Self.m_UserId && EM.m_UserPlanetCnt>=(EM.PlanetColonyMax(m_Owner)+EM.PlanetEmpireMax(m_Owner)+EM.PlanetEnclaveMax(m_Owner))) { EM.m_FormHint.Show(Common.Txt.WarningNoCapturePlanet,Common.WarningHideTime); return false; }
				}
			}

			if ((ship.m_Flag & Common.ShipFlagPhantom) == 0 && !EM.IsEdit()) {
				var fuel:int = Math.floor(ship.m_Fuel / Common.FuelFlyOne);
				if (fuel > 0) ship.m_Fuel = (fuel - 1) * Common.FuelFlyOne;
				else ship.m_Fuel = 0;
			}

			ship2.Copy(ship);//,true);
			ship.Clear();
			if (EM.IsEdit()) {
				ship2.m_Link = 0;
				ship2.m_Flag&=~(Common.ShipFlagPortal|Common.ShipFlagEject/*@|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/|Common.ShipFlagCapture|Common.ShipFlagExchange);
				ship2.m_ArrivalTime=0;
				ship2.m_FromSectorX=m_TargetSectorX;
				ship2.m_FromSectorY=m_TargetSectorY;
				ship2.m_FromPlanet=m_TargetPlanetNum;
				ship2.m_FromPlace=m_TargetNum;
				ship2.m_Flag|=Common.ShipFlagExchange;
			} else {
				ship2.m_Link = 0;
				ship2.m_Flag&=~(Common.ShipFlagPortal|Common.ShipFlagEject/*@|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/|Common.ShipFlagBattle|Common.ShipFlagCapture|Common.ShipFlagExchange);
				ship2.m_ArrivalTime = m_ServerTime + EM.CalcFlyTime(ship2.m_Owner, ship2.m_Id, ship2.m_Type, ship2.m_Race, planet, planet2) * 1000;
				ship2.m_FromSectorX=m_SectorX;
				ship2.m_FromSectorY=m_SectorY;
				ship2.m_FromPlanet=m_PlanetNum;
				ship2.m_FromPlace=m_ShipNum;
			}
            if (ship2.m_Type == Common.ShipTypeInvader && tgtno && !EM.IsFriendEx(planet2, planet2.m_Owner, planet2.m_Race, ship2.m_Owner, ship2.m_Race)) ship2.m_Flag |= Common.ShipFlagCapture;
			ship2.m_BattleTimeLock=ship2.m_ArrivalTime+Common.BattleLock*1000;
//			if(ship2.m_Type==Common.ShipTypeTransport) ship2.m_LogicTimeLock=ship2.m_ArrivalTime+Common.TransportLogicLockAfterMove;
//			else ship2.m_LogicTimeLock=0;
		}
		return true;
	}

	public function ProcessActionCopy():Boolean
	{
		var cnt:int,smc:int;
		var ship2:Ship;
		var planet2:Planet;
		
		if (!EM.IsEdit()) return false;
		if (!(EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap)) return false;

		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		var ship:Ship=planet.m_Ship[m_ShipNum];

		var tgtsec:Sector=EM.GetSector(m_TargetSectorX,m_TargetSectorY);
		if(tgtsec==null) return false;

		if(m_Kind!=0) {
			planet2=tgtsec.m_Planet[m_TargetPlanetNum];
			if(m_TargetNum<0) return false;
			ship2=planet2.m_Ship[m_TargetNum];

			ship2.m_OrbitItemType=ship.m_OrbitItemType;
			ship2.m_OrbitItemTimer=ship.m_OrbitItemTimer;
			ship2.m_OrbitItemOwner=ship.m_OrbitItemOwner;
			ship2.m_OrbitItemCnt=ship.m_OrbitItemCnt;
			
			if(m_Kind>=2) {
				ship.m_OrbitItemType=0;
				ship.m_OrbitItemTimer=0;
				ship.m_OrbitItemOwner=0;
				ship.m_OrbitItemCnt=0;
			}
			
		} else {
			if(ship.m_Type==Common.ShipTypeNone) return false;
//			if(ship.m_Type==Common.ShipTypeFlagship) return false;

//			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;

			if(sec==tgtsec && m_PlanetNum==m_TargetPlanetNum) {
				// Копируем на орбиту текущей планеты
				if (m_ShipNum == m_TargetNum) {
					if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
					EM.LinkSet(planet, ship, null);
					return true;
				}
				if(m_TargetNum<0) {
					if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
					EM.LinkSet(planet, ship, planet);
					return true;
				}
				
				if (m_TargetNum >= planet.ShipOnPlanetLow && !Common.ShipLowOrbit[ship.m_Type]) return false;
				
				ship2=planet.m_Ship[m_TargetNum];
				if(ship2.m_Type!=Common.ShipTypeNone) {
					ship2.Clear();
				}
	
				ship2.Copy(ship);
				if (m_Id != 0) ship2.m_Id = m_Id;
				ship2.m_Link = 0;
				ship2.m_Flag&=~(Common.ShipFlagPortal|Common.ShipFlagEject/*|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/|Common.ShipFlagCapture|Common.ShipFlagExchange);
				ship2.m_ArrivalTime=0;
				ship2.m_FromSectorX=m_TargetSectorX;
				ship2.m_FromSectorY=m_TargetSectorY;
				ship2.m_FromPlanet=m_TargetPlanetNum;
				ship2.m_FromPlace=m_TargetNum;
				ship2.m_Flag |= Common.ShipFlagExchange;
				if (m_TargetNum >= planet.ShipOnPlanetLow) ship2.m_Flag &= ~Common.ShipFlagBattle;
				ship2.m_BattleTimeLock=ship2.m_ArrivalTime+Common.BattleLock*1000;
	
			} else {
				// Копируем на другую планету
				planet2=tgtsec.m_Planet[m_TargetPlanetNum];
	
				if (m_TargetNum < 0) {
					if (planet2.m_Flag & Planet.PlanetFlagWormhole) return false;
					
					if (ship.m_Type == Common.ShipTypeSciBase) {
						if (EM.EjectAccess(planet, planet2, ship.m_Owner, ship.m_Race) == 0) return false;
					} else {
						var dx:int = planet2.m_PosX - planet.m_PosX;
						var dy:int = planet2.m_PosY - planet.m_PosY;
						if ((dx * dx + dy * dy) > EM.JumpRadius2) return false;
					}

					EM.LinkSet(planet, ship, planet2);
					return true;
				}

				if (m_TargetNum >= planet2.ShipOnPlanetLow && !Common.ShipLowOrbit[ship.m_Type]) return false;

				ship2=planet2.m_Ship[m_TargetNum];
				if(ship2.m_Type!=Common.ShipTypeNone) {
					ship2.Clear();
				}
	
				if(EM.CntFriendGroup(planet2,ship.m_Owner,ship.m_Race)>=Common.GroupInPlanetMax) { 
					EM.m_FormHint.Show(Common.Txt.WarningMaxGroup,Common.WarningHideTime);
					return false;
				}
	
				ship2.Copy(ship);
				if (m_Id != 0) ship2.m_Id = m_Id;
				ship2.m_Link = 0;
				ship2.m_Flag&=~(Common.ShipFlagPortal|Common.ShipFlagEject/*|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/|Common.ShipFlagCapture|Common.ShipFlagExchange);
				ship2.m_ArrivalTime=0;
				ship2.m_FromSectorX=m_TargetSectorX;
				ship2.m_FromSectorY=m_TargetSectorY;
				ship2.m_FromPlanet=m_TargetPlanetNum;
				ship2.m_FromPlace=m_TargetNum;
				ship2.m_Flag|=Common.ShipFlagExchange;
				if (m_TargetNum >= planet2.ShipOnPlanetLow) ship2.m_Flag &= ~Common.ShipFlagBattle;
				ship2.m_BattleTimeLock=ship2.m_ArrivalTime+Common.BattleLock*1000;
			}

			if (m_Id == 0 || ship.m_Type == Common.ShipTypeFlagship) ship.Clear();
		}
		return true;
	}

	public function ProcessActionBuild():Boolean
	{
		var ship:Ship;
		var user:User;
		var i:int, score:int, nscore:int, cnt:int, mcnt:int, cost:int;
		
		var buildforowner:uint = m_TargetPlanetNum;
		
		if (EM.IsEdit()) return false;

		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		//if(planet.m_Owner!=m_Owner) return false;
		if(!EM.AccessBuild(buildforowner)) return false;
		
		if((EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeCombat) && m_TargetNum!=0) return false;

		if(buildforowner!=0) {
			user=UserList.Self.GetUser(buildforowner);
			if(user.m_HomeworldCotlId==0) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildNoHomeworld,Common.WarningHideTime); return false; }
		}
		
		if (planet.m_Flag & Planet.PlanetFlagNoCapture) { EM.m_FormHint.Show(Common.Txt.WarningNoBuild, Common.WarningHideTime); return false; }

		cnt=m_Cnt;

		if (m_Kind == Common.ShipTypeNone) {
			return false; // инфраструктуру больше не нужно строить
/*			
			if (buildforowner != planet.m_Owner) return false;
			if(EM.IsBattle(planet,buildforowner,Common.RaceNone,true)) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildInfrBattle,Common.WarningHideTime); return false; }

			cost=0;

			if(m_TargetNum==0 || m_Owner!=buildforowner) {
//				cost=Common.DirPlanetLavelCostLvl[Common.DirPlanetLavelCostLvl.length-1];
//				if(planet.m_Owner==Server.Self.m_UserId) cost=EM.DirValE(m_Owner,Common.DirPlanetLavelCost);
				cost = Common.PlanetLevelCost;

				if(EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeRich) cost=(cost*EM.m_OpsCostBuildLvl)>>8;
				else cost=(cost*EM.m_InfrCostMul)>>8;

				if(cost<=0) return false;

				mcnt=Math.floor(EM.PlanetItemGet(m_Owner,planet,Common.ItemTypeModule,true)/cost);
				if(cnt>mcnt) cnt=mcnt;

			} else if(m_TargetNum==1) {
				//if(Common.PlanetLevelSDM*m_Cnt>EM.m_UserSDM) return false;
				mcnt=Math.floor(EM.m_UserSDM/Common.PlanetLevelSDM);
				if(cnt>mcnt) cnt=mcnt;

			} else return false;

			//mcnt=Common.DirPlanetLevelMaxLvl[Common.DirPlanetLevelMaxLvl.length-1];
			//if(planet.m_Owner==Server.Self.m_UserId) mcnt=EM.DirValE(m_Owner,Common.DirPlanetLevelMax);
			mcnt = Common.BuildPlanetLvlMax;

			if((planet.m_Level+planet.m_LevelBuy+cnt)>mcnt) cnt=mcnt-(planet.m_Level+planet.m_LevelBuy);
			if(cnt>0) {
				if((planet.m_LevelBuy+cnt)>Common.BuildPlanetLvlMax) cnt=Common.BuildPlanetLvlMax-planet.m_LevelBuy;
				if(cnt>0) {
                    if(planet.m_LevelBuy>0) {
                        if(m_TargetNum==0 || m_Owner!=buildforowner) {
                            if(planet.m_Flag & Planet.PlanetFlagBuildSDM) return false;
                        } else {
                            if(!(planet.m_Flag & Planet.PlanetFlagBuildSDM)) return false;
                        }
                    }

					planet.m_LevelBuy+=cnt;

					if(m_TargetNum==0 || m_Owner!=buildforowner) {
						//planet.m_ConstructionPoint-=cost*cnt;
						EM.PlanetItemExtract(m_Owner,planet, Common.ItemTypeModule, cost * cnt, true);
					} else if(m_TargetNum==1) {
						EM.m_UserSDM-=Common.PlanetLevelSDM*cnt;
					} else return false;
				}
			}

			m_Id=EM.NewShipId(buildforowner);
			if(m_Id==0) return false;
			//m_Id=EM.m_UserNewShipId;
			//EM.m_UserNewShipId++;
*/
		} else {
			if((planet.m_Flag & (Planet.PlanetFlagCitadel | Planet.PlanetFlagHomeworld))==0 && EM.IsBattle(planet,buildforowner,Common.RaceNone,true)) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildBattle,Common.WarningHideTime); return false; }

			if((!Common.IsBase(m_Kind)) && !(planet.m_Flag & (Planet.PlanetFlagHomeworld | Planet.PlanetFlagCitadel))) {
				for(i=0;i<Common.ShipOnPlanetMax;i++) {
					ship=planet.m_Ship[i];
					if(ship.m_Type==Common.ShipTypeShipyard && !(ship.m_Flag & Common.ShipFlagBuild) && ship.m_Owner==buildforowner) break;
				}
				if(i>=Common.ShipOnPlanetMax) return false;
			}

			if(!EM.ShipAccess(buildforowner,m_Kind)) return false;
			if(!EM.BuildAccess(buildforowner,m_Kind)) return false;

			var smc:int = EM.ShipMaxCnt(buildforowner, m_Kind);

			if(m_Kind==Common.ShipTypeFlagship) {
//				if(EM.IsBuild(planet)) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildFlagshipIsBuildShip,Common.WarningHideTime); return false; }

				cnt=1;
				if (EM.ShipCost(buildforowner, m_Id, Common.ShipTypeFlagship) > EM.PlanetItemGet_Sub(m_Owner, planet, Common.ItemTypeModule, true)) return false;
				
				if (buildforowner == Server.Self.m_UserId) {
					if ((EM.CalcMassAllShip(Common.ShipAtkMass[m_Kind]) + EM.ShipMass(buildforowner, m_Id, Common.ShipTypeFlagship)) > EM.CalcMaxMassAllShip(buildforowner, Common.ShipAtkMass[m_Kind])) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildMass, Common.WarningHideTime); return false; }
					if ((EM.CalcMassAllShip(!Common.ShipAtkMass[m_Kind])) > EM.CalcMaxMassAllShip(buildforowner, !Common.ShipAtkMass[m_Kind])) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildMass, Common.WarningHideTime); return false; }
				}
				
			} else {
				if(m_TargetNum==0 || m_Owner!=buildforowner) {
					//if(Common.ShipCost[m_Kind]*m_Cnt>planet.m_ConstructionPoint) return false;
					mcnt=Math.floor(EM.PlanetItemGet_Sub(m_Owner,planet,Common.ItemTypeModule,true)/EM.ShipCost(buildforowner,m_Id,m_Kind));
					if(cnt>mcnt) cnt=mcnt;
	
				} else if(m_TargetNum==1) {
					//if(Common.ShipCost[m_Kind]*m_Cnt>EM.m_UserSDM) return false;

					if (EM.m_CotlType != Common.CotlTypeUser || EM.m_CotlOwnerId != buildforowner) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildSDMUser, Common.WarningHideTime); return false; }

					mcnt=Math.floor(EM.m_UserSDM/Common.ShipCostSDM[m_Kind]);
					if(cnt>mcnt) cnt=mcnt;
	
				} else return false;
				
				if (m_Kind == Common.ShipTypeQuarkBase) {
					if ((planet.m_Flag & Planet.PlanetFlagHomeworld) == 0) return false;
					if (EM.m_UserStatShipCnt[Common.ShipTypeQuarkBase] > 0 || EM.m_FormFleetBar.m_QuarkBaseType != 0) { EM.m_FormHint.Show(Common.Txt.WarningNoMoreQuarkBase, Common.WarningHideTime); return false; }
					for (i = 0; i < Common.ShipOnPlanetMax; i++) if (planet.m_Ship[i].m_Type == Common.ShipTypeQuarkBase && planet.m_Ship[i].m_Owner == buildforowner) break;
					if (i < Common.ShipOnPlanetMax) { EM.m_FormHint.Show(Common.Txt.WarningNoMoreQuarkBase, Common.WarningHideTime); return false; }

					if (EM.PlanetItemGet_Sub(m_Owner, planet, Common.ItemTypeQuarkCore, true) < Common.QuarkBaseCostQuarkCore) { 
						EM.m_FormHint.Show(BaseStr.Replace(Common.Txt.WarningNeedQuarkCore, "<Val>", BaseStr.FormatBigInt(Common.QuarkBaseCostQuarkCore)), Common.WarningHideTime); 
						return false;
					}
				}

				if (EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) { }
				else if (EM.IsWinMaxEnclave()) { }
				//else if(EM.m_EmpireEdit) {}
				//else if(!EM.TestBuildSupport()) return false;
				else if (buildforowner == Server.Self.m_UserId && m_Kind != Common.ShipTypeInvader && m_Kind != Common.ShipTypeTransport) {
					if ((EM.CalcMassAllShip(Common.ShipAtkMass[m_Kind]) + EM.ShipMass(buildforowner, 0, m_Kind) * Math.min(smc, cnt)) >= EM.CalcMaxMassAllShip(buildforowner, Common.ShipAtkMass[m_Kind])) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildMass, Common.WarningHideTime); return false; }
					if ((EM.CalcMassAllShip(!Common.ShipAtkMass[m_Kind])) >= EM.CalcMaxMassAllShip(buildforowner, !Common.ShipAtkMass[m_Kind])) { EM.m_FormHint.Show(Common.Txt.WarningNoBuildMass, Common.WarningHideTime); return false; }
				}
			}

			var shipnum:int=m_ShipNum;
			ship=planet.m_Ship[shipnum];

			if(ship.m_Type!=Common.ShipTypeNone && m_Id!=0) {
				shipnum=EM.CalcBuildPlace(planet,buildforowner);
				if(shipnum<0) return false;
				ship=planet.m_Ship[shipnum];
			}

			if(ship.m_Type==m_Kind) {
				return false;
				
				if(m_Kind==Common.ShipTypeFlagship) return false;
				if(ship.m_Flag & Common.ShipFlagBomb) return false;
				if(ship.m_Owner!=buildforowner) return false;
//				if(ship.m_ArrivalTime>EM.GetServerTime()) return false;
				if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
				
				if(ship.m_Cnt+cnt>smc) cnt=smc-ship.m_Cnt;
				while(cnt>0) {
                    if(Common.IsBase(ship.m_Type)) {
                        if(ship.m_Cnt+cnt>Common.BuildStationMax) cnt=Common.BuildStationMax-ship.m_Cnt;
                        if(cnt<=0) break;
                    }
                    
                    if(m_TargetNum==0 || m_Owner!=buildforowner) {
                        if(ship.m_Flag & Common.ShipFlagBuildSDM) break;
                    } else {
                        if(!(ship.m_Flag & Common.ShipFlagBuildSDM)) break;
                    }

					if(ship.m_Flag & Common.ShipFlagBuild) {
						ship.m_Cnt+=cnt;
						ship.m_BattleTimeLock+=EM.CalcBuildTime(planet,ship.m_Owner,ship.m_Id,ship.m_Type,cnt)*1000;
					} else {
						return false;
						//if(EM.IsBuild(planet)) { EM.m_FormHint.Show(Common.Txt.WarningNoMoreBuild,Common.WarningHideTime);  return false; }
						//ship.m_Cnt+=m_Cnt;
						//ship.m_Flag=(ship.m_Flag & (~Common.ShipFlagBattle))|Common.ShipFlagBuild;
						//ship.m_BattleTimeLock=m_ServerTime+EM.CalcBuildTime(ship.m_Type,m_Cnt)*1000;
					}
					break;
				}

			} else if(ship.m_Type==Common.ShipTypeNone) {
//trace("infr2 ",m_Cnt);
				if(m_Id==0) return false;
				if(EM.CntFriendGroup(planet,buildforowner,Common.RaceNone)>=Common.GroupInPlanetMax) { EM.m_FormHint.Show(Common.Txt.WarningMaxGroup,Common.WarningHideTime); return false; }
				if((m_Kind!=Common.ShipTypeCorvette) && EM.IsRear(planet,shipnum,buildforowner,Common.RaceNone,true)) { EM.m_FormHint.Show(Common.Txt.WarningRear,Common.WarningHideTime); return false; }
				//if(EM.IsBuild(planet)) { EM.m_FormHint.Show(Common.Txt.WarningNoMoreBuild,Common.WarningHideTime);  return false; }
				
				if(cnt>smc) cnt=smc;
				if(cnt>0) {
                    if(Common.IsBase(m_Kind)) {
                        if(cnt>Common.BuildStationMax) cnt=Common.BuildStationMax;
                    }

					if(m_Kind==Common.ShipTypeFlagship) {
						//if(planet.m_Owner!=Server.Self.m_UserId) return false;

						user=UserList.Self.GetUser(buildforowner);
						if(user==null) return false;
						var cpt:Cpt=user.GetCpt(m_Id);
						if(cpt==null) return false; 

						if(cpt.m_PlanetNum>=0/* || cpt.m_ArrivalTime!=0*/) return false;

						if(buildforowner!=Server.Self.m_UserId) {}
						else if ((EM.m_Access & Common.AccessPlusarCaptain) && ((EM.m_UserCaptainEnd > EM.GetServerGlobalTime()) || (EM.m_UserControlEnd > EM.GetServerGlobalTime()))) { }
						else {
							var k:int;
							for(k=0;k<user.m_Cpt.length;k++) {
								var cpt2:Cpt=user.m_Cpt[k];
								if(!cpt2.m_Id) continue;
								if(cpt2.m_PlanetNum>=0/* || cpt2.m_ArrivalTime!=0*/) break;
							}
							if(k<Common.CptMax) { EM.m_FormHint.Show(Common.Txt.WarningNoMoreCpt,Common.WarningHideTime); return false; }
						}

						cpt.m_CotlId=Server.Self.m_CotlId;
						cpt.m_SectorX=sec.m_SectorX;
						cpt.m_SectorY=sec.m_SectorY;
						cpt.m_PlanetNum=m_PlanetNum;
						//cpt.m_ArrivalTime=0;
					}

					if(m_Kind==Common.ShipTypeFlagship) ship.m_Id=Common.FlagshipIdFlag | m_Id;
					else ship.m_Id=m_Id;

					ship.m_Owner=buildforowner;
//					ship.m_FleetCptId=0;
					ship.m_Race = EM.RaceByOwner(buildforowner);// , planet.m_Race);
					ship.m_ArrivalTime=0;
					ship.m_FromSectorX=m_SectorX;
					ship.m_FromSectorY=m_SectorY;
					ship.m_FromPlanet=m_PlanetNum;
					ship.m_FromPlace=shipnum;
					ship.m_Type=m_Kind;
					ship.m_Cnt = cnt;
					ship.m_CargoType = 0;
					ship.m_CargoCnt = 0;
					ship.m_HP=EM.ShipMaxHP(ship.m_Owner,ship.m_Id,m_Kind,ship.m_Race);
					ship.m_Shield=EM.ShipMaxShield(ship.m_Owner,ship.m_Id,m_Kind,ship.m_Race,ship.m_Cnt);
					ship.m_Fuel = Common.FuelMax;
					ship.m_Flag = Common.ShipFlagBuild;
					
					if (ship.m_Type == Common.ShipTypeDevastator) ship.m_Flag |= Common.ShipFlagAIAttack;
					
					var bt:Number=EM.CalcBuildTime(planet,ship.m_Owner,ship.m_Id,ship.m_Type,cnt)*1000;
					
					var ship2:Ship;
					
					for(i=0;i<Common.ShipOnPlanetMax;i++) {
						ship2=planet.m_Ship[i];
						if(ship2.m_Type==Common.ShipTypeNone) continue;
						if(ship2.m_Owner!=ship.m_Owner) continue;
						if(i==shipnum) continue;
						if((ship2.m_Flag & Common.ShipFlagBuild)==0) continue;
						
						bt+=Math.max(m_ServerTime,ship2.m_BattleTimeLock);
						break;
					}
					if(i>=Common.ShipOnPlanetMax) {
						ship.m_BattleTimeLock=m_ServerTime+bt;
					} else {
						for(i=0;i<Common.ShipOnPlanetMax;i++) {
							ship2=planet.m_Ship[i];
							if(ship2.m_Type==Common.ShipTypeNone) continue;
							if(ship2.m_Owner!=ship.m_Owner) continue;
							if((ship2.m_Flag & Common.ShipFlagBuild)==0) continue;
							
							ship2.m_BattleTimeLock=bt;
						}
					}
					
					ship.TakeItem();
					
					if(!EM.IsWinMaxEnclave() && EM.m_CotlType!=Common.CotlTypeProtect && (ship.m_Owner==Server.Self.m_UserId)) {
						switch(ship.m_Type) {
							 case Common.ShipTypeTransport: EM.m_UserStatShipCnt[Common.ShipTypeTransport]+=ship.m_Cnt; break;
							 case Common.ShipTypeCorvette: EM.m_UserStatShipCnt[Common.ShipTypeCorvette]+=ship.m_Cnt; break;
							 case Common.ShipTypeCruiser: EM.m_UserStatShipCnt[Common.ShipTypeCruiser]+=ship.m_Cnt; break;
							 case Common.ShipTypeDreadnought: EM.m_UserStatShipCnt[Common.ShipTypeDreadnought]+=ship.m_Cnt; break;
							 case Common.ShipTypeInvader: EM.m_UserStatShipCnt[Common.ShipTypeInvader]+=ship.m_Cnt; break;
							 case Common.ShipTypeDevastator: EM.m_UserStatShipCnt[Common.ShipTypeDevastator]+=ship.m_Cnt; break;
							 case Common.ShipTypeWarBase: EM.m_UserStatShipCnt[Common.ShipTypeWarBase]+=ship.m_Cnt; break;
							 case Common.ShipTypeShipyard: EM.m_UserStatShipCnt[Common.ShipTypeShipyard]+=ship.m_Cnt; break;
							 case Common.ShipTypeSciBase: EM.m_UserStatShipCnt[Common.ShipTypeSciBase]+=ship.m_Cnt; break;
							 case Common.ShipTypeServiceBase: EM.m_UserStatShipCnt[Common.ShipTypeServiceBase]+=ship.m_Cnt; break;
							 case Common.ShipTypeQuarkBase: EM.m_UserStatShipCnt[Common.ShipTypeQuarkBase]+=ship.m_Cnt; break;
						}
					}
				}

			} else return false;

			//ship.m_BattleTimeLock=m_ServerTime+Common.BattleLock*1000;

			if (cnt > 0) {
				if (m_Kind == Common.ShipTypeQuarkBase) {
					EM.PlanetItemExtract(m_Owner, planet, Common.ItemTypeQuarkCore, Common.QuarkBaseCostQuarkCore, true);

				}
				if(m_Kind==Common.ShipTypeFlagship) {
					//planet.m_ConstructionPoint -= EM.ShipCost(planet.m_Owner, m_Id, Common.ShipTypeFlagship);
					EM.PlanetItemExtract(m_Owner,planet,Common.ItemTypeModule,EM.ShipCost(buildforowner, m_Id, Common.ShipTypeFlagship),true)

				} else if(m_TargetNum==0 || m_Owner!=buildforowner) {
					//planet.m_ConstructionPoint -= EM.ShipCost(planet.m_Owner, m_Id, m_Kind) * cnt;
					EM.PlanetItemExtract(m_Owner,planet,Common.ItemTypeModule,EM.ShipCost(buildforowner, m_Id, m_Kind) * cnt,true)

				} else {
					EM.m_UserSDM-=Common.ShipCostSDM[m_Kind]*cnt;

				}
			}
			
			if(ship.m_Type==Common.ShipTypeServiceBase && (planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge))==(Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) planet.PlanetItemBuildByBuilding(0);
		}

		return true;
	}

	public function ProcessActionPath():Boolean
	{
		var route:int,k:int;

		if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;

//trace("ProcessActionPath");
		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		//if(planet.m_Owner!=m_Owner) return false;

		var sec2:Sector=EM.GetSector(m_TargetSectorX,m_TargetSectorY);
		if(sec2==null) return false;
		var planet2:Planet=sec2.m_Planet[m_TargetPlanetNum];

		var newpath:int=EM.CalcPlanetOffset(m_SectorX,m_SectorY,m_PlanetNum,m_TargetSectorX,m_TargetSectorY,m_TargetPlanetNum)

		if(m_Kind==0) {
//			if(EM.IsEdit()) {}
//			else if(EM.AccessBuild(planet.m_Owner)) {
//				if(planet2.m_Owner==planet.m_Owner) {}
//				else return false;
//			}
//			else return false;

			if(EM.IsEdit()) {}
//			else if (EM.m_CotlType == Common.CotlTypeUser) {
//				if (!EM.AccessBuild(EM.m_CotlOwnerId)) return false;
//			}
			else if(EM.RouteAccess(planet,Server.Self.m_UserId)) {}
			else return false;

			if(newpath==planet.m_Path) planet.m_Path=0;
			else planet.m_Path=newpath;
		} else {
			if(EM.IsEdit()) {}
//			else if (EM.m_CotlType == Common.CotlTypeUser) {
//				if (!EM.AccessBuild(EM.m_CotlOwnerId)) return false;
//			}
			else if(EM.RouteAccess(planet,Server.Self.m_UserId)) {}
			else return false;

			for(k=0;k<Common.RouteMax;k++) {
				if(k==0) route=planet.m_Route0;
				else if(k==1) route=planet.m_Route1;
				else route=planet.m_Route2;
				
				if(route==newpath) break;
			}
			if(k<Common.RouteMax) {
				if(k<=0) planet.m_Route0=planet.m_Route1;
				if(k<=1) planet.m_Route1=planet.m_Route2;
				planet.m_Route2=0;
			} else {
				planet.m_Route2=planet.m_Route1;
				planet.m_Route1=planet.m_Route0;
				planet.m_Route0=newpath;

/*				for(k=0;k<Common.RouteMax-1;k++) {
					if(k==0) route=planet.m_Route0;
					else if(k==1) route=planet.m_Route1;
					else route=planet.m_Route2;
					
					if(route==0) break;
				}
				
				if(k==0) planet.m_Route0=newpath;
				else if(k==1) planet.m_Route1=newpath;
				else planet.m_Route2=newpath;*/
			}
		}

		return true;
	}
	
	public function ProcessActionSplit():Boolean
	{
		var itcnt:int, ccnt:int;
		var it:uint;
		
		if (EM.IsEdit()) return false;

		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		var fromship:Ship=planet.m_Ship[m_ShipNum];
		var toship:Ship=planet.m_Ship[m_TargetNum];

		if (fromship.m_Type == Common.ShipTypeNone) return false;
		if(fromship.m_Flag & Common.ShipFlagPhantom) return false;
		//if(fromship.m_Owner!=m_Owner) return false;
		if(!EM.AccessControl(fromship.m_Owner)) return false;
		if(fromship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
		if(fromship.m_Flag & (Common.ShipFlagBuild|Common.ShipFlagBomb)) return false;
		
		if(planet.m_Flag & Planet.PlanetFlagWormhole) {
			if((m_ShipNum & 1) != (m_TargetNum & 1)) return false;
		}

		var maxcnt:int=fromship.m_Cnt;

		var smc:int=EM.ShipMaxCnt(fromship.m_Owner,fromship.m_Type);

		if(toship.m_Type!=Common.ShipTypeNone) {
			if(fromship.m_Type!=toship.m_Type) return false;
			if (fromship.m_Owner != toship.m_Owner) return false;
			if (toship.m_Flag & Common.ShipFlagPhantom) return false;
			if(toship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if(toship.m_Flag & (Common.ShipFlagBuild|Common.ShipFlagBomb)) return false;

			maxcnt+=toship.m_Cnt;
			if(m_Cnt>=maxcnt) return false;

			if(m_Cnt>smc) return false;
			if(maxcnt-m_Cnt>fromship.m_Cnt && maxcnt-m_Cnt>smc) return false;
			if(maxcnt-m_Cnt<=0) return false;

			var s2add:int=m_Cnt-toship.m_Cnt;
			//if(s2add>0) fromship.m_Fuel=Math.floor((fromship.m_Fuel*fromship.m_Cnt+toship.m_Fuel*s2add)/(fromship.m_Cnt+s2add));
			//else if (s2add < 0) toship.m_Fuel = Math.floor((toship.m_Fuel * toship.m_Cnt + fromship.m_Fuel * ( -s2add)) / (toship.m_Cnt + ( -s2add)));
			if (s2add > 0) toship.m_Fuel = Math.floor((toship.m_Fuel * toship.m_Cnt + fromship.m_Fuel * s2add) / (toship.m_Cnt + s2add));
			else if (s2add < 0) fromship.m_Fuel = Math.floor((fromship.m_Fuel * fromship.m_Cnt + toship.m_Fuel * ( -s2add)) / (fromship.m_Cnt + ( -s2add)));

			var sc:int=0;
			if (s2add > 0) sc = s2add * Math.floor(fromship.m_Shield / fromship.m_Cnt);
			else if (s2add < 0) sc = s2add * Math.floor(toship.m_Shield / toship.m_Cnt);
			if(sc!=0) {
				toship.m_Shield = Math.max(0, toship.m_Shield + sc);
				fromship.m_Shield = Math.max(0, fromship.m_Shield - sc);
			}

			toship.m_Cnt=m_Cnt;
			fromship.m_Cnt=maxcnt-m_Cnt;

/*			if(fromship.m_CargoCnt+toship.m_CargoCnt>0) {
				ccnt=fromship.m_CargoCnt+toship.m_CargoCnt;
				toship.m_CargoCnt=(toship.m_Cnt*Math.floor((ccnt<<8)/maxcnt))>>8;
				if(toship.m_CargoCnt<0) toship.m_CargoCnt=0;
				else if(toship.m_CargoCnt>ccnt) toship.m_CargoCnt=ccnt; 
				fromship.m_CargoCnt=ccnt-toship.m_CargoCnt;
			}*/
			while(true) {
				ccnt=0;
				it=Common.ItemTypeNone;
				if(fromship.m_CargoType!=Common.ItemTypeNone) { it=fromship.m_CargoType; ccnt+=fromship.m_CargoCnt; }
				if(toship.m_CargoType!=Common.ItemTypeNone) { it=toship.m_CargoType; ccnt+=toship.m_CargoCnt; }
				if(it==Common.ItemTypeNone || ccnt<=0) break;
				if(fromship.m_CargoType!=Common.ItemTypeNone && toship.m_CargoType!=Common.ItemTypeNone && fromship.m_CargoType!=toship.m_CargoType) break;

				toship.m_CargoType=it;
				toship.m_CargoCnt=(toship.m_Cnt*Math.floor((ccnt<<8)/maxcnt))>>8;
				if(toship.m_CargoCnt<0) { toship.m_CargoType=Common.ItemTypeNone; toship.m_CargoCnt=0; }
				else if(toship.m_CargoCnt>ccnt) toship.m_CargoCnt=ccnt;
				fromship.m_CargoType=it;
				fromship.m_CargoCnt=ccnt-toship.m_CargoCnt;
				if(fromship.m_CargoCnt<=0) { fromship.m_CargoType=Common.ItemTypeNone; fromship.m_CargoCnt=0; }

				break;
			}

			itcnt=m_Kind;
			while(fromship.m_ItemType!=Common.ItemTypeNone || toship.m_ItemType!=Common.ItemTypeNone) {
				if(itcnt<=0 && fromship.m_ItemType!=Common.ItemTypeNone && toship.m_ItemType!=Common.ItemTypeNone && fromship.m_ItemType!=toship.m_ItemType) break;

				maxcnt=0;
				it=fromship.m_ItemType;
				if(it!=Common.ItemTypeNone) maxcnt+=fromship.m_ItemCnt;
				
				if(toship.m_ItemType!=Common.ItemTypeNone) {
					if(it==toship.m_ItemType) maxcnt+=toship.m_ItemCnt;
					else if(it==Common.ItemTypeNone) { it=toship.m_ItemType; maxcnt+=toship.m_ItemCnt; }
				}
				if(maxcnt<=0) break;

				if(itcnt>maxcnt) itcnt=maxcnt;
				if(itcnt<0) itcnt=0;
				
				if(itcnt<=0) { toship.m_ItemType=Common.ItemTypeNone; toship.m_ItemCnt=0; }
				else { toship.m_ItemType=it; toship.m_ItemCnt=itcnt; }

				itcnt=maxcnt-itcnt;
				if(itcnt<=0) { fromship.m_ItemType=Common.ItemTypeNone; fromship.m_ItemCnt=0; }
				else { fromship.m_ItemType=it; fromship.m_ItemCnt=itcnt; }

				break;
			}

			if (s2add > 0) {
				if (fromship.m_AbilityCooldown0 > toship.m_AbilityCooldown0) toship.m_AbilityCooldown0 = fromship.m_AbilityCooldown0;
				if (fromship.m_AbilityCooldown1 > toship.m_AbilityCooldown1) toship.m_AbilityCooldown1 = fromship.m_AbilityCooldown1;
				if (fromship.m_AbilityCooldown2 > toship.m_AbilityCooldown2) toship.m_AbilityCooldown2 = fromship.m_AbilityCooldown2;
			} else if (s2add < 0) {
				if (toship.m_AbilityCooldown0 > fromship.m_AbilityCooldown0) fromship.m_AbilityCooldown0 = toship.m_AbilityCooldown0;
				if (toship.m_AbilityCooldown1 > fromship.m_AbilityCooldown1) fromship.m_AbilityCooldown1 = toship.m_AbilityCooldown1;
				if (toship.m_AbilityCooldown2 > fromship.m_AbilityCooldown2) fromship.m_AbilityCooldown2 = toship.m_AbilityCooldown2;
			}

			m_Id=EM.NewShipId(toship.m_Owner);
			if(m_Id==0) return false;
//			m_Id=EM.m_UserNewShipId;
//			EM.m_UserNewShipId++;

		} else {
			if(m_Cnt>=maxcnt) return false;
			if(EM.CntFriendGroup(planet,fromship.m_Owner,fromship.m_Race)>=Common.GroupInPlanetMax) { EM.m_FormHint.Show(Common.Txt.WarningMaxGroup,Common.WarningHideTime); return false; }
			if (fromship.m_Type != Common.ShipTypeCorvette && EM.IsRear(planet, m_TargetNum, fromship.m_Owner, fromship.m_Race, true)) { EM.m_FormHint.Show(Common.Txt.WarningRear, Common.WarningHideTime); return false; }

			if (m_TargetNum >= planet.ShipOnPlanetLow) {
				if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
				if (!Common.ShipLowOrbit[fromship.m_Type]) return false;
				if (!EM.AccessLowOrbit(planet, fromship.m_Owner, fromship.m_Race)) return false;
			}

			if(m_Cnt>smc) return false;
			//if(maxcnt-m_Cnt>smc) return false;
			if(maxcnt-m_Cnt<=0) return false;

			toship.m_Shield = m_Cnt * Math.floor(fromship.m_Shield / fromship.m_Cnt);
			fromship.m_Shield -= toship.m_Shield;
			fromship.m_Cnt=maxcnt-m_Cnt;

			if (toship.m_Shield > Common.GaalBarrierMax && toship.m_Race == Common.RaceGaal && toship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(toship.m_Type)) toship.m_Shield = Common.GaalBarrierMax;
            if (fromship.m_Shield > Common.GaalBarrierMax && fromship.m_Race == Common.RaceGaal && fromship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(fromship.m_Type)) fromship.m_Shield = Common.GaalBarrierMax;

			toship.m_Owner=fromship.m_Owner;
			toship.m_Race=fromship.m_Race;
			toship.m_ArrivalTime=0;
			toship.m_FromSectorX=m_SectorX;
			toship.m_FromSectorY=m_SectorY;
			toship.m_FromPlanet=m_PlanetNum;
			toship.m_FromPlace=m_TargetNum;
			toship.m_Type=fromship.m_Type;
			toship.m_Cnt=m_Cnt;
			toship.m_HP = EM.ShipMaxHP(toship.m_Owner, toship.m_Id, toship.m_Type,toship.m_Race);
			toship.m_Fuel=fromship.m_Fuel;
//			if(toship.m_Fuel>Common.FuelMax) toship.m_Fuel=Common.FuelMax;
			toship.m_Flag = 0;
			
			if (fromship.m_Flag & Common.ShipFlagAIAttack) toship.m_Flag |= Common.ShipFlagAIAttack;

			toship.m_CargoType=0;
			toship.m_CargoCnt=0;
			if(fromship.m_CargoType!=Common.ItemTypeNone && fromship.m_CargoCnt>0) {
				ccnt = fromship.m_CargoCnt;
				toship.m_CargoType=fromship.m_CargoType;
				toship.m_CargoCnt=(toship.m_Cnt*Math.floor((ccnt<<8)/maxcnt))>>8;
				if(toship.m_CargoCnt<0) { toship.m_CargoType=Common.ItemTypeNone; toship.m_CargoCnt=0; }
				else if(toship.m_CargoCnt>ccnt) toship.m_CargoCnt=ccnt;
				fromship.m_CargoCnt = ccnt - toship.m_CargoCnt;
				if(fromship.m_CargoCnt<=0) { fromship.m_CargoType=Common.ItemTypeNone; fromship.m_CargoCnt=0; }
			}

			toship.TakeItem();

			itcnt=m_Kind;
			while(itcnt>0 && fromship.m_ItemType!=Common.ItemTypeNone) {
				if(itcnt>fromship.m_ItemCnt) itcnt=fromship.m_ItemCnt;
				if(itcnt<=0) break;
				
				if(toship.m_ItemType==fromship.m_ItemType) {
					toship.m_ItemCnt+=itcnt;
				} else {
					toship.m_ItemType=fromship.m_ItemType;
					toship.m_ItemCnt=itcnt;
				}
				
				fromship.m_ItemCnt-=itcnt;
				if(fromship.m_ItemCnt<=0) {
					fromship.m_ItemType=Common.ItemTypeNone;
					fromship.m_ItemCnt=0;
				}

				break;
			}

			toship.m_BattleTimeLock = m_ServerTime + Common.BattleLock * 1000;
			
			toship.m_AbilityCooldown0 = fromship.m_AbilityCooldown0;
			toship.m_AbilityCooldown1 = fromship.m_AbilityCooldown1;
			toship.m_AbilityCooldown2 = fromship.m_AbilityCooldown2;

			m_Id=EM.NewShipId(toship.m_Owner);
			if(m_Id==0) return false;
//			m_Id=EM.m_UserNewShipId;
//			EM.m_UserNewShipId++;
			toship.m_Id=m_Id;
		}
		
		return true;
	}
	
	public function ProcessActionMake():Boolean
	{
		return false;
		
/*		if(m_Kind==Common.ItemTypeFuel) {
			if(m_Cnt*Common.ItemFuelAntimatter>EM.m_UserRes[Common.ItemTypeAntimatter]) return false;
			if(m_Cnt*Common.ItemFuelMetal>EM.m_UserRes[Common.ItemTypeMetal]) return false;
			if(m_Cnt+EM.m_UserRes[Common.ItemTypeFuel]>Common.ResMax) return false;

			EM.m_UserRes[Common.ItemTypeAntimatter]-=m_Cnt*Common.ItemFuelAntimatter;
			EM.m_UserRes[Common.ItemTypeMetal]-=m_Cnt*Common.ItemFuelMetal;
			EM.m_UserRes[Common.ItemTypeFuel]+=m_Cnt;

		} else if(m_Kind==Common.ItemTypeArmour) {
			if(m_Cnt*Common.ItemArmourMetal>EM.m_UserRes[Common.ItemTypeMetal]) return false;
			if(m_Cnt*Common.ItemArmourElectronics>EM.m_UserRes[Common.ItemTypeElectronics]) return false;
			if(m_Cnt+EM.m_UserRes[Common.ItemTypeArmour]>Common.ResMax) return false;

			EM.m_UserRes[Common.ItemTypeMetal]-=m_Cnt*Common.ItemArmourMetal;
			EM.m_UserRes[Common.ItemTypeElectronics]-=m_Cnt*Common.ItemArmourElectronics;
			EM.m_UserRes[Common.ItemTypeArmour]+=m_Cnt;

		} else if(m_Kind==Common.ItemTypeArmour2) {
			if(m_Cnt*Common.ItemArmour2Metal>EM.m_UserRes[Common.ItemTypeMetal]) return false;
			if(m_Cnt*Common.ItemArmour2Electronics>EM.m_UserRes[Common.ItemTypeElectronics]) return false;
			if(m_Cnt*Common.ItemArmour2Nodes>EM.m_UserRes[Common.ItemTypeNodes]) return false;
			if(m_Cnt+EM.m_UserRes[Common.ItemTypeArmour2]>Common.ResMax) return false;

			EM.m_UserRes[Common.ItemTypeMetal]-=m_Cnt*Common.ItemArmour2Metal;
			EM.m_UserRes[Common.ItemTypeElectronics]-=m_Cnt*Common.ItemArmour2Electronics;
			EM.m_UserRes[Common.ItemTypeNodes]-=m_Cnt*Common.ItemArmour2Nodes;
			EM.m_UserRes[Common.ItemTypeArmour2]+=m_Cnt;

		} else if(m_Kind==Common.ItemTypeRepair) {
			if(m_Cnt*Common.ItemRepairMetal>EM.m_UserRes[Common.ItemTypeMetal]) return false;
			if(m_Cnt*Common.ItemRepairElectronics>EM.m_UserRes[Common.ItemTypeElectronics]) return false;
			if(m_Cnt+EM.m_UserRes[Common.ItemTypeRepair]>Common.ResMax) return false;

			EM.m_UserRes[Common.ItemTypeMetal]-=m_Cnt*Common.ItemRepairMetal;
			EM.m_UserRes[Common.ItemTypeElectronics]-=m_Cnt*Common.ItemRepairElectronics;
			EM.m_UserRes[Common.ItemTypeRepair]+=m_Cnt;

		} else if(m_Kind==Common.ItemTypeRepair2) {
			if(m_Cnt*Common.ItemRepair2Metal>EM.m_UserRes[Common.ItemTypeMetal]) return false;
			if(m_Cnt*Common.ItemRepair2Electronics>EM.m_UserRes[Common.ItemTypeElectronics]) return false;
			if(m_Cnt*Common.ItemRepair2Protoplasm>EM.m_UserRes[Common.ItemTypeProtoplasm]) return false;
			if(m_Cnt+EM.m_UserRes[Common.ItemTypeRepair2]>Common.ResMax) return false;

			EM.m_UserRes[Common.ItemTypeMetal]-=m_Cnt*Common.ItemRepair2Metal;
			EM.m_UserRes[Common.ItemTypeElectronics]-=m_Cnt*Common.ItemRepair2Electronics;
			EM.m_UserRes[Common.ItemTypeProtoplasm]-=m_Cnt*Common.ItemRepair2Protoplasm;
			EM.m_UserRes[Common.ItemTypeRepair2]+=m_Cnt;

		} else if(m_Kind==Common.ItemTypePower) {
			if(m_Cnt*Common.ItemPowerAntimatter>EM.m_UserRes[Common.ItemTypeAntimatter]) return false;
			if(m_Cnt*Common.ItemPowerElectronics>EM.m_UserRes[Common.ItemTypeElectronics]) return false;
			if(m_Cnt+EM.m_UserRes[Common.ItemTypePower]>Common.ResMax) return false;

			EM.m_UserRes[Common.ItemTypeAntimatter]-=m_Cnt*Common.ItemPowerAntimatter;
			EM.m_UserRes[Common.ItemTypeElectronics]-=m_Cnt*Common.ItemPowerElectronics;
			EM.m_UserRes[Common.ItemTypePower]+=m_Cnt;

		} else if(m_Kind==Common.ItemTypePower2) {
			if(m_Cnt*Common.ItemPower2Antimatter>EM.m_UserRes[Common.ItemTypeAntimatter]) return false;
			if(m_Cnt*Common.ItemPower2Electronics>EM.m_UserRes[Common.ItemTypeElectronics]) return false;
			if(m_Cnt*Common.ItemPower2Protoplasm>EM.m_UserRes[Common.ItemTypeProtoplasm]) return false;
			if(m_Cnt+EM.m_UserRes[Common.ItemTypePower2]>Common.ResMax) return false;

			EM.m_UserRes[Common.ItemTypeAntimatter]-=m_Cnt*Common.ItemPower2Antimatter;
			EM.m_UserRes[Common.ItemTypeElectronics]-=m_Cnt*Common.ItemPower2Electronics;
			EM.m_UserRes[Common.ItemTypeProtoplasm]-=m_Cnt*Common.ItemPower2Protoplasm;
			EM.m_UserRes[Common.ItemTypePower2]+=m_Cnt;

		} else return false;
		
		return true;*/
	}

	public function ProcessActionGive():Boolean
	{
		var cnt:int;
		var item:Item;
		
		if (EM.IsEdit()) return false;

/*		if(m_Kind==Common.ItemTypeFuel) {}
		else if(m_Kind==Common.ItemTypeArmour) {}
		else if(m_Kind==Common.ItemTypePower) {}
		else if(m_Kind==Common.ItemTypeRepair) {}
		else if(m_Kind==Common.ItemTypeArmour2) {}
		else if(m_Kind==Common.ItemTypePower2) {}
		else if(m_Kind==Common.ItemTypeRepair2) {}
		else return false;
		
		if(m_PlanetNum<0) {
			cnt=m_Cnt;
			if(cnt==0) return false;
			
			if(EM.m_HomeworldCotlId==0 && EM.m_CitadelCotlId==0) return false;
			
			while(true) {
				var hw_cotl:Cotl=EM.m_FormGalaxy.GetCotl(EM.m_HomeworldCotlId);
				if(hw_cotl!=null) {
					if(EM.OnOrbitCotl(hw_cotl,EM.m_FleetPosX,EM.m_FleetPosY)) break;
				}
				
				var co_cotl:Cotl=EM.m_FormGalaxy.GetCotl(EM.m_CitadelCotlId);
				if(co_cotl!=null) {
					if(EM.OnOrbitCotl(co_cotl,EM.m_FleetPosX,EM.m_FleetPosY)) break;
				}
				
				EM.m_FormHint.Show(Common.Txt.WarningFleetFarFuel,Common.WarningHideTime);
				return false;
			}
			
			var user_res:int=EM.m_UserRes[m_Kind];
			if(cnt>0) {
				if(cnt>user_res) cnt=user_res;
			} else {
			}

			if(m_Kind==Common.ItemTypeFuel) {
				cnt=EM.m_FormFleetBar.EmpireFleetFuelChange(cnt);
			} else {
				cnt=EM.m_FormFleetBar.EmpireFleetEqChange(m_ShipNum,m_Kind,cnt);
			}

			if(cnt==0) return false;
			
			EM.m_UserRes[m_Kind]-=cnt;
			
			EM.m_FormFleetBar.Update();
			return true;
		}*/
		
		//var cotl:SpaceCotl=Hyperspace.Self.GetCotl(Server.Self.m_CotlId);
		//if(cotl==null) { /*EM.m_FormHint.Show(Common.Txt.WarningFleetFar,Common.WarningHideTime);*/ return false; }

		var fleetempty:Boolean=EM.m_FormFleetBar.FleetIsEmpty();

		if(!fleetempty) {
			if(EM.m_CotlType!=Common.CotlTypeCombat && !EM.OnOrbitCotl(Server.Self.m_CotlId)) { EM.m_FormHint.Show(Common.Txt.WarningFleetFarEx,Common.WarningHideTime); return false; }
		}

		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet = sec.m_Planet[m_PlanetNum];
		var ship:Ship = planet.m_Ship[m_ShipNum];
		if (ship.m_Type == Common.ShipTypeNone) return false;
		if (ship.m_Flag & Common.ShipFlagPhantom) return false;
		if (ship.m_ArrivalTime > EM.m_ServerCalcTime) return false;
		//if(ship.m_Owner!=Server.Self.m_UserId) return false;
		//if(planet.m_Owner!=Server.Self.m_UserId) return false;
		if (!EM.AccessControl(ship.m_Owner)) return false;

		if (m_Kind == Common.ItemTypeFuel) {
			return false;
//			if (planet.m_Owner != ship.m_Owner && !EM.IsFriendEx(planet, planet.m_Owner, planet.m_Race, ship.m_Owner, ship.m_Race)) return false;
//			if (EM.IsBattle(planet, ship.m_Owner, Common.RaceNone, false)) return false;
//			if ((EM.m_CotlType == Common.CotlTypeRich || EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && (EM.m_OpsFlag & Common.OpsFlagLeaveShip) == 0) return false;

//			var fm:int = EM.FuelMax(ship.m_Owner, ship.m_Id, ship.m_Type);
//			cnt = Math.min(m_Cnt, fm - ship.m_Fuel);
//			if (cnt <= 0) return false;

//			if (cnt > EM.m_FormFleetBar.m_FleetFuel) cnt = EM.m_FormFleetBar.m_FleetFuel;
//			if (cnt <= 0) return false;

//			ship.m_Fuel += cnt;
			
		} else if(m_Kind==Common.ItemTypeQuarkCore || m_Kind==Common.ItemTypeMine) {
//			if (EM.IsBattle(planet, ship.m_Owner, Common.RaceNone, false)) return false;

			item = UserList.Self.GetItem(m_Kind & 0xffff);
			if (item == null) return false;

			cnt=item.m_StackMax;
			if (ship.m_CargoType == m_Kind) cnt -= ship.m_CargoCnt;
			cnt=Math.min(m_Cnt,cnt);
			if (cnt <= 0) return false;

			cnt = EM.m_FormFleetBar.FleetSysItemExtract(m_Kind, cnt);
			if (cnt <= 0) return false;

			if(ship.m_CargoType!=m_Kind) { ship.m_CargoType=m_Kind; ship.m_CargoCnt=0; }
			ship.m_CargoCnt+=cnt;

		} else if (Common.ItemCanOnShip(m_Kind, ship.m_Type)) {
			item = UserList.Self.GetItem(m_Kind & 0xffff);
			if (item == null) return false;

			cnt=item.m_StackMax;
			if (ship.m_ItemType == m_Kind) cnt -= ship.m_ItemCnt;
			cnt=Math.min(m_Cnt,cnt);
			if (cnt <= 0) return false;

			cnt = EM.m_FormFleetBar.FleetSysItemExtract(m_Kind, cnt);
			if (cnt <= 0) return false;

			if(ship.m_ItemType!=m_Kind) { ship.m_ItemType=m_Kind; ship.m_ItemCnt=0; }
			ship.m_ItemCnt+=cnt;

		} else return false;

		return true;
	}

	public function ProcessActionDestroy():Boolean
	{
		if (EM.IsEdit()) return false;
		
		var i:int,cv:int;
		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet = sec.m_Planet[m_PlanetNum];
		if (planet == null) return false;

		if(m_ShipNum<0) {
			if(!EM.AccessBuild(planet.m_Owner)) return false;

			if(m_Kind==0) {
//				if(planet.m_Owner != m_Owner) return false;
				if(planet.m_Flag & Planet.PlanetFlagHomeworld) return false;

				if(EM.IsBattle(planet,planet.m_Owner,planet.m_Race,false)) { EM.m_FormHint.Show(Common.Txt.WarningNoLeaveAccupation,Common.WarningHideTime); return false; }

				//EM.ClearPlanetPath(planet);
				planet.m_Owner=0;

			} else if(m_Kind==1) {
				//var cost:int=Common.DirPlanetLavelCostLvl[Common.DirPlanetLavelCostLvl.length-1];
				//if(planet.m_Owner==Server.Self.m_UserId) cost=EM.DirValE(m_Owner,Common.DirPlanetLavelCost);
				var cost:int = Common.PlanetLevelCost;

				if(EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeCombat || EM.m_CotlType==Common.CotlTypeRich) cost=(cost*EM.m_OpsCostBuildLvl)>>8;
				else cost=(cost*EM.m_InfrCostMul)>>8;
				
				if(planet.m_LevelBuy>0) {
					if(planet.m_Flag & Planet.PlanetFlagBuildSDM) {
						if(planet.m_Owner==Server.Self.m_UserId) EM.m_UserSDM+=planet.m_LevelBuy*Common.PlanetLevelSDM;
					} else {
						cv = planet.m_LevelBuy * cost;
						//planet.m_ConstructionPoint += planet.m_LevelBuy * cost;
						if (cv > 0) EM.PlanetItemAdd(m_Owner, planet, Common.ItemTypeModule, cv, false, true);
					}
					planet.m_LevelBuy=0;
				}
			} else if(m_Kind==2) {

			} else return false;

			return true;

		} else {
			var ship:Ship=planet.m_Ship[m_ShipNum];
			if(ship.m_Type==Common.ShipTypeNone) return false;
			if(!EM.AccessBuild(ship.m_Owner)) return false;
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			
			if(m_Kind==0) {
				if(ship.m_Type!=Common.ShipTypeTransport && ship.m_Type!=Common.ShipTypeInvader && EM.IsBattle(planet,ship.m_Owner,ship.m_Race,false)) return false;

				var mcnt:int = 0;// ship.m_CargoCnt;
				if (ship.m_Type == Common.ShipTypeFlagship && ship.m_Owner == Server.Self.m_UserId && EM.m_UserRelocate > 0) { }
				else if((ship.m_Flag & Common.ShipFlagPhantom)==0) {
					if (ship.m_Type != Common.ShipTypeFlagship && !EM.IsWinMaxEnclave()) mcnt += ((EM.ShipCost(ship.m_Owner, ship.m_Id, ship.m_Type) * ship.m_Cnt) >> 2);
					if (ship.m_CargoType == Common.ItemTypeModule) mcnt += ship.m_CargoCnt;
				}

				var be:BtlEvent = new BtlEvent();
				be.m_Id = ship.m_Id;
				be.m_Type = BtlEvent.TypeExplosion;
				be.m_Slot = m_ShipNum;
				be.m_Time = EM.m_ServerCalcTime;
				planet.m_BtlEvent.splice(0,0,be);

				if(!EM.IsWinMaxEnclave() && EM.m_CotlType!=Common.CotlTypeProtect && (ship.m_Owner==Server.Self.m_UserId)) {
					switch(ship.m_Type) {
						 case Common.ShipTypeTransport: EM.m_UserStatShipCnt[Common.ShipTypeTransport]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeTransport]-ship.m_Cnt); break;
						 case Common.ShipTypeCorvette: EM.m_UserStatShipCnt[Common.ShipTypeCorvette]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeCorvette]-ship.m_Cnt); break;
						 case Common.ShipTypeCruiser: EM.m_UserStatShipCnt[Common.ShipTypeCruiser]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeCruiser]-ship.m_Cnt); break;
						 case Common.ShipTypeDreadnought: EM.m_UserStatShipCnt[Common.ShipTypeDreadnought]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeDreadnought]-ship.m_Cnt); break;
						 case Common.ShipTypeInvader: EM.m_UserStatShipCnt[Common.ShipTypeInvader]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeInvader]-ship.m_Cnt); break;
						 case Common.ShipTypeDevastator: EM.m_UserStatShipCnt[Common.ShipTypeDevastator]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeDevastator]-ship.m_Cnt); break;
						 case Common.ShipTypeWarBase: EM.m_UserStatShipCnt[Common.ShipTypeWarBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeWarBase]-ship.m_Cnt); break;
						 case Common.ShipTypeShipyard: EM.m_UserStatShipCnt[Common.ShipTypeShipyard]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeShipyard]-ship.m_Cnt); break;
						 case Common.ShipTypeSciBase: EM.m_UserStatShipCnt[Common.ShipTypeSciBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeSciBase]-ship.m_Cnt); break;
						 case Common.ShipTypeServiceBase: EM.m_UserStatShipCnt[Common.ShipTypeServiceBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeServiceBase]-ship.m_Cnt); break;
						 case Common.ShipTypeQuarkBase: EM.m_UserStatShipCnt[Common.ShipTypeQuarkBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeQuarkBase]-ship.m_Cnt); break;
					}
				}

				ship.Clear();
				if(mcnt>0) {
					ship.m_OrbitItemType=Common.ItemTypeModule;
					ship.m_OrbitItemCnt=mcnt;
					ship.m_OrbitItemOwner=0;
					ship.m_OrbitItemTimer=EM.m_ServerCalcTime;
				}
				//ship.m_DestroyTime=EM.GetServerTime();

			} else if(m_Kind==1) {
				if (!(ship.m_Flag & Common.ShipFlagBuild)) return false;

				if (ship.m_Type == Common.ShipTypeFlagship && ship.m_Owner==Server.Self.m_UserId) {
					if (EM.m_UserRelocate > 0) { EM.m_FormHint.Show(Common.Txt.WarningNoCancelBuildFlagshipInRelocate,Common.WarningHideTime);  return false; }
				}

				cv = 0;
				if(ship.m_Flag & Common.ShipFlagBuildSDM) {
					if(ship.m_Owner==Server.Self.m_UserId) EM.m_UserSDM+=Common.ShipCostSDM[ship.m_Type]*ship.m_Cnt;
				} else {
					cv += EM.ShipCost(ship.m_Owner, ship.m_Id, ship.m_Type) * ship.m_Cnt;
					//planet.m_ConstructionPoint+=EM.ShipCost(ship.m_Owner,ship.m_Id,ship.m_Type)*ship.m_Cnt;
				}
				if(ship.m_CargoType==Common.ItemTypeModule && ship.m_CargoCnt>0) cv += ship.m_CargoCnt;
				if(cv>0) EM.PlanetItemAdd(ship.m_Owner,planet,Common.ItemTypeModule,cv,false,true,true,PlanetItem.PlanetItemFlagNoMove);
				ship.m_CargoType = 0;
				ship.m_CargoCnt = 0;

//				var bt:Number=EM.CalcBuildTime(planet,ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Cnt)*1000;
//				for(i=0;i<Common.ShipOnPlanetMax;i++) {
//					var ship2:Ship=planet.m_Ship[i];
//					if(ship2.m_Type==Common.ShipTypeNone) continue;
//					if(ship2.m_Owner!=ship.m_Owner) continue;
//					if(!(ship2.m_Flag & Common.ShipFlagBuild)) continue;
//					if(ship2.m_BattleTimeLock<bt) ship2.m_BattleTimeLock=m_ServerTime;
//					else ship2.m_BattleTimeLock=Math.max(m_ServerTime,ship2.m_BattleTimeLock-bt);
//				}

				if(ship.m_ItemType!=Common.ItemTypeNone && ship.m_OrbitItemType==Common.ItemTypeNone) {
					ship.m_OrbitItemType=ship.m_ItemType;
					ship.m_OrbitItemCnt=ship.m_ItemCnt;
					ship.m_OrbitItemOwner=ship.m_Owner;
					ship.m_OrbitItemTimer=m_ServerTime;
				}
				
				if(!EM.IsWinMaxEnclave() && EM.m_CotlType!=Common.CotlTypeProtect && (ship.m_Owner==Server.Self.m_UserId)) {
					switch(ship.m_Type) {
						 case Common.ShipTypeTransport: EM.m_UserStatShipCnt[Common.ShipTypeTransport]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeTransport]-ship.m_Cnt); break;
						 case Common.ShipTypeCorvette: EM.m_UserStatShipCnt[Common.ShipTypeCorvette]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeCorvette]-ship.m_Cnt); break;
						 case Common.ShipTypeCruiser: EM.m_UserStatShipCnt[Common.ShipTypeCruiser]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeCruiser]-ship.m_Cnt); break;
						 case Common.ShipTypeDreadnought: EM.m_UserStatShipCnt[Common.ShipTypeDreadnought]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeDreadnought]-ship.m_Cnt); break;
						 case Common.ShipTypeInvader: EM.m_UserStatShipCnt[Common.ShipTypeInvader]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeInvader]-ship.m_Cnt); break;
						 case Common.ShipTypeDevastator: EM.m_UserStatShipCnt[Common.ShipTypeDevastator]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeDevastator]-ship.m_Cnt); break;
						 case Common.ShipTypeWarBase: EM.m_UserStatShipCnt[Common.ShipTypeWarBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeWarBase]-ship.m_Cnt); break;
						 case Common.ShipTypeShipyard: EM.m_UserStatShipCnt[Common.ShipTypeShipyard]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeShipyard]-ship.m_Cnt); break;
						 case Common.ShipTypeSciBase: EM.m_UserStatShipCnt[Common.ShipTypeSciBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeSciBase]-ship.m_Cnt); break;
						 case Common.ShipTypeServiceBase: EM.m_UserStatShipCnt[Common.ShipTypeServiceBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeServiceBase]-ship.m_Cnt); break;
						 case Common.ShipTypeQuarkBase: EM.m_UserStatShipCnt[Common.ShipTypeQuarkBase]=Math.max(EM.m_UserStatShipCnt[Common.ShipTypeQuarkBase]-ship.m_Cnt); break;
					}
				}
				
				var shiptype:int = ship.m_Type;

				ship.Clear();
				
				if(shiptype==Common.ShipTypeServiceBase && (planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) planet.PlanetItemRemoveByBuilding(0);
			}
			
			return true;
		}
		return false;
	}

	public function ProcessActionCargo():Boolean
	{
		if (EM.IsEdit()) return false;
		var cnt:int, i:int, val:int;
		
		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		if(m_ShipNum<0) return false;
		var ship:Ship=planet.m_Ship[m_ShipNum];
		if (ship.m_Type == Common.ShipTypeNone) return false;
		if (ship.m_Flag & Common.ShipFlagPhantom) return false;
		//if(ship.m_Owner!=Server.Self.m_UserId) return false;
		if(!EM.AccessControl(ship.m_Owner)) return false;
		if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
		if(ship.m_Flag & (Common.ShipFlagBomb)) return false;

		if(m_Kind==10) {
			if (ship.m_ItemType == Common.ItemTypeNone) return false;
			else if (ship.m_ItemType == Common.ItemTypeMine) return false;
			

			if(ship.m_ItemCnt>0) {
				i=m_ShipNum+1;
				if(i>=Common.ShipOnPlanetMax) i=0;
				var ship2:Ship=planet.m_Ship[i];
				if(ship2.m_Type!=Common.ShipTypeNone || (ship2.m_OrbitItemType!=Common.ItemTypeNone && ship2.m_OrbitItemType!=ship.m_ItemType)) {
					i=m_ShipNum-1;
					if(i<0) i=Common.ShipOnPlanetMax-1;
					ship2=planet.m_Ship[i];
					if(ship2.m_Type!=Common.ShipTypeNone || (ship2.m_OrbitItemType!=Common.ItemTypeNone && ship2.m_OrbitItemType!=ship.m_ItemType)) return false;
				}

				if(ship2.m_OrbitItemType==ship.m_ItemType) {
					ship2.m_OrbitItemCnt+=ship.m_ItemCnt;
				} else {
					ship2.m_OrbitItemType=ship.m_ItemType;
					ship2.m_OrbitItemCnt=ship.m_ItemCnt;
				}
				ship2.m_OrbitItemOwner=ship.m_Owner;
				ship2.m_OrbitItemTimer = EM.m_ServerCalcTime;
			}

			ship.m_ItemType=Common.ItemTypeNone;
			ship.m_ItemCnt=0;
			return true;

		} else if(m_Kind>0) {
			// Load
			if (ship.m_Type != Common.ShipTypeTransport) return false;
			
			if ((ship.m_CargoType != Common.ItemTypeModule) && (ship.m_CargoType != Common.ItemTypeNone)) return false;

			cnt = ship.m_Cnt * EM.DirValE(ship.m_Owner, Common.DirTransportCargo);// -ship.m_CargoCnt;
			if(ship.m_CargoType==Common.ItemTypeModule) cnt-=ship.m_CargoCnt;

			if (!EM.RouteAccess(planet, Server.Self.m_UserId)) return false;
				
//			if (planet.m_Owner == 0 && EM.IsBattle(planet, ship.m_Owner, ship.m_Race, false)) { EM.m_FormHint.Show(Common.Txt.WarningItemMoveBattle, Common.WarningHideTime); return false; }

			val = EM.PlanetItemGet_Sub(ship.m_Owner, planet, Common.ItemTypeModule);

			if(cnt>val) cnt=val;
			if(cnt<=0) return false;

			if(ship.m_CargoType!=Common.ItemTypeModule) {
				ship.m_CargoType=Common.ItemTypeModule;
				ship.m_CargoCnt=cnt;
			} else {
				ship.m_CargoCnt+=cnt;
			}

			EM.PlanetItemExtract(ship.m_Owner, planet, Common.ItemTypeModule, cnt);
			
			return true;

/*			} else {
				val = EM.PlanetItemGet(0xffffffff, planet, Common.ItemTypeModule);

				if(cnt>(val-Common.SackHide)) cnt=val-Common.SackHide;
				if (cnt > 0) {
					if(ship.m_CargoType!=Common.ItemTypeModule) {
						ship.m_CargoType=Common.ItemTypeModule;
						ship.m_CargoCnt=cnt;
					} else {
						ship.m_CargoCnt+=cnt;
					}
					EM.PlanetItemExtract(0xffffffff,planet,Common.ItemTypeModule,cnt);
				}
			}
			return true;*/

		} else if(m_Kind<0) {
			// Unload
			//if (planet.m_Owner == 0) return false;
			
			if (!ship.m_CargoType) return false;
			cnt=EM.PlanetItemAdd(ship.m_Owner/*0xffffffff*/,planet,ship.m_CargoType,ship.m_CargoCnt);
			if(cnt<=0) return false;

			ship.m_CargoCnt-=cnt;
			if(ship.m_CargoCnt<=0) { ship.m_CargoType=0; ship.m_CargoCnt=0; }

			return true;

		} else {
			// Refuel
/*			if(planet.m_Owner==ship.m_Owner) {
				if(ship.m_Fuel<Common.FuelPlanetReload) {
					ship.m_Fuel=Common.FuelPlanetReload;
					return true;
				}
				var fm:int=EM.FuelMax(ship.m_Owner,ship.m_Id,ship.m_Type);
				cnt=Math.min(fm-ship.m_Fuel,EM.m_UserRes[Common.ItemTypeFuel]);
				if(cnt<=0) return false;

				ship.m_Fuel+=cnt;
				EM.m_UserRes[Common.ItemTypeFuel]-=cnt;
				return true;
			}*/
			return false;
/*			if(ship.m_Fuel>=Common.FuelPlanetReload) return false;
			var shipbest:Ship=null;
			for(i=0;i<planet.m_Ship.length;i++) {
				if(m_ShipNum==i) continue;
				var s2:Ship=planet.m_Ship[i];
				if(s2.m_Type==Common.ShipTypeNone) continue;
				if(s2.m_Owner!=ship.m_Owner) continue;
				if(ship.m_Fuel>=s2.m_Fuel) continue;

				if(shipbest==null || s2.m_Fuel>cnt) {
					cnt=s2.m_Fuel;
					shipbest=s2;
				}
			}
			if(shipbest==null) return false;
			cnt=Math.min(shipbest.m_Fuel-ship.m_Fuel,Common.FuelPlanetReload-ship.m_Fuel);
			if(cnt<=0) return false;
			if(shipbest.m_Fuel-cnt<ship.m_Fuel+cnt) {
				cnt=shipbest.m_Fuel+ship.m_Fuel;
				shipbest.m_Fuel=cnt>>1;
				ship.m_Fuel=cnt-(cnt>>1);
			} else {
				shipbest.m_Fuel-=cnt;
				ship.m_Fuel+=cnt;
			}
			return true;*/
		} 
		return false;
	}
	
	public function ProcessActionResChange():Boolean
	{
		return false;
		
/*		if(m_Kind==m_Id) return false;
		var fromcnt:int=0;
		if(m_Kind==Common.ItemTypeAntimatter) fromcnt=EM.m_UserRes[Common.ItemTypeAntimatter];
		else if(m_Kind==Common.ItemTypeMetal) fromcnt=EM.m_UserRes[Common.ItemTypeMetal];
		else if(m_Kind==Common.ItemTypeElectronics)  fromcnt=EM.m_UserRes[Common.ItemTypeElectronics];
		else return false;

		var tocnt:int=0;
		if(m_Id==Common.ItemTypeAntimatter) tocnt=EM.m_UserRes[Common.ItemTypeAntimatter];
		else if(m_Id==Common.ItemTypeMetal) tocnt=EM.m_UserRes[Common.ItemTypeMetal];
		else if(m_Id==Common.ItemTypeElectronics)  tocnt=EM.m_UserRes[Common.ItemTypeElectronics];
		else return false;

		var cnt:int=Math.floor(fromcnt/Common.ResChangeFactor);
		if(cnt>m_Cnt) cnt=m_Cnt;
		if(tocnt+cnt>Common.ResMax) cnt=Common.ResMax-tocnt;
		if(cnt<=0) return false;

		if(m_Kind==Common.ItemTypeAntimatter) EM.m_UserRes[Common.ItemTypeAntimatter]-=cnt*Common.ResChangeFactor;
		else if(m_Kind==Common.ItemTypeMetal) EM.m_UserRes[Common.ItemTypeMetal]-=cnt*Common.ResChangeFactor;
		else if(m_Kind==Common.ItemTypeElectronics)  EM.m_UserRes[Common.ItemTypeElectronics]-=cnt*Common.ResChangeFactor;

		if(m_Id==Common.ItemTypeAntimatter) EM.m_UserRes[Common.ItemTypeAntimatter]+=cnt;
		else if(m_Id==Common.ItemTypeMetal) EM.m_UserRes[Common.ItemTypeMetal]+=cnt;
		else if(m_Id==Common.ItemTypeElectronics)  EM.m_UserRes[Common.ItemTypeElectronics]+=cnt;

		return true;*/
	}

	public function ProcessActionSpecial():Boolean
	{
		var cnt:int, i:int, sum:int;
		var ship:Ship
		var ship2:Ship
		var planet:Planet;
		var sec:Sector;

		if (m_Kind == 1 || m_Kind == 2) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			if(m_ShipNum<0) return false;
			ship=planet.m_Ship[m_ShipNum];
			if (ship.m_Type != Common.ShipTypeSciBase) return false;
			if (ship.m_Flag & Common.ShipFlagPhantom) return false;
			//if(ship.m_Owner!=Server.Self.m_UserId) return false;
			if(!EM.IsEdit() && !EM.AccessControl(ship.m_Owner)) return false;
			if(ship.m_Flag & (Common.ShipFlagBuild|Common.ShipFlagBomb)) return false;

			/*if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) ship.m_Flag &= ~Common.ShipFlagStabilizer;
			else*/
			if(m_Kind==1) ship.m_Flag|=Common.ShipFlagStabilizer;
			else ship.m_Flag&=~Common.ShipFlagStabilizer;

			return true;

		} else if (m_Kind == 5) {
			if (EM.IsEdit()) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;

			planet=sec.m_Planet[m_PlanetNum];
			if(planet.m_PortalPlanet==0) return false;
			ship=planet.m_Ship[m_ShipNum];
			if (ship.m_Type == Common.ShipTypeNone) return false;
			if (ship.m_Flag & Common.ShipFlagPhantom) return false;
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if (ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb)) return false;
			if (!EM.AccessControl(ship.m_Owner)) return false;
			
			if ((ship.m_Type==Common.ShipTypeQuarkBase) && (ship.m_Flag & Common.ShipFlagBattle)!=0 && (ship.m_BattleTimeLock > EM.m_ServerCalcTime)) {
				EM.m_FormHint.Show(Common.Txt.WarningNeedReloadReactor, Common.WarningHideTime); 
				return false;
			}
			
			if(!EM.AccessControl(planet.m_PortalOwner)) { EM.m_FormHint.Show(Common.Txt.WarningNoPortalOwner,Common.WarningHideTime); return false; }

//			for(i=0;i<Common.ShipOnPlanetMax;i++) {
//				ship2=planet.m_Ship[i];
//            	if(ship2.m_Type==Common.ShipTypeNone) continue;
//                if(ship2.m_Flag & Common.ShipFlagPortal) break;
//			}
//			if(i<Common.ShipOnPlanetMax) { EM.m_FormHint.Show(Common.Txt.WarningNoMorePortal,Common.WarningHideTime); return false; }
			
			if(planet.m_PortalCnt>0) {
				if(planet.m_PortalCnt<ship.m_Cnt) {
					EM.m_FormHint.Show(Common.Txt.WarningNoPortalCnt,Common.WarningHideTime);
					return false;
				}
			}

			ship.m_Link = 0;
            ship.m_Flag &= ~(/*Common.ShipFlagAutoReturn | Common.ShipFlagAutoLogic |*/ Common.ShipFlagBattle | Common.ShipFlagCapture | Common.ShipFlagExchange);
			if ((ship.m_Flag & Common.ShipFlagPortal) == 0) {
				ship.m_Flag &= ~Common.ShipFlagEject;
				ship.m_Flag |= Common.ShipFlagPortal;
				if(planet.m_PortalCnt>0) ship.m_BattleTimeLock=m_ServerTime+Common.FlagshipPortalTime*1000;
				else if(Common.IsBase(ship.m_Type)) ship.m_BattleTimeLock=m_ServerTime+Common.StationPortalTime*1000;
				else ship.m_BattleTimeLock = m_ServerTime + Common.ShipPortalTime * 1000;
			} else {
				ship.m_Flag &= ~(Common.ShipFlagPortal | Common.ShipFlagEject);
				ship.m_BattleTimeLock = m_ServerTime + Common.BattleLock;
			}

            return true;

		} else if (m_Kind == 6) {
			if (EM.IsEdit()) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if (ship.m_Flag & (Common.ShipFlagPhantom | Common.ShipFlagBuild)) return false;

            if (ship.m_Type == Common.ShipTypeDevastator) {
				if(ship.m_Flag & Common.ShipFlagBomb) return false;
				if (!EM.AccessControl(ship.m_Owner)) return false;
				if (ship.m_Cnt < 500) return false;

				ship.m_Link = 0;
				ship.m_Flag&=~(Common.ShipFlagPortal|Common.ShipFlagEject/*|Common.ShipFlagAutoReturn|Common.ShipFlagAutoLogic*/|Common.ShipFlagBattle|Common.ShipFlagCapture|Common.ShipFlagExchange);
				ship.m_Flag |= Common.ShipFlagBomb;
				if(ship.m_Race==Common.RaceGrantar) ship.m_BattleTimeLock = m_ServerTime + Common.DevastatorBombTimeGrantar * 1000;
				else ship.m_BattleTimeLock = m_ServerTime + Common.DevastatorBombTime * 1000;
			} else {
				if (m_ShipNum < planet.ShipOnPlanetLow) return false;

				var fctrl:Boolean = false;
				var fenemy:Boolean = false;
				for (i = 0; i < planet.ShipOnPlanetLow; i++) {
					ship2 = planet.m_Ship[i];
					if (ship2.m_Type == Common.ShipTypeNone) continue;
					if (ship2.m_Flag & (Common.ShipFlagPhantom | Common.ShipFlagBuild)) continue;
					if (EM.IsFlyOtherPlanet(ship2,planet)) continue;

					if (!fenemy && !EM.IsFriendEx(planet, ship2.m_Owner, ship2.m_Race, m_Owner, Common.RaceNone)) fenemy = true;
					if (!fctrl && EM.AccessControl(ship2.m_Owner)) fctrl = true;
					if (fenemy && fctrl) break;
				}
				if(fenemy) return false;
				if(!fctrl && !EM.AccessControl(ship.m_Owner)) return false;

				ship.m_Link = 0;
				ship.m_Flag &= ~(Common.ShipFlagPortal | Common.ShipFlagEject /*| Common.ShipFlagAutoReturn | Common.ShipFlagAutoLogic*/ | Common.ShipFlagBattle | Common.ShipFlagCapture | Common.ShipFlagExchange);
				if (ship.m_Flag & Common.ShipFlagBomb) {
					ship.m_Flag &= ~Common.ShipFlagBomb;
					ship.m_BattleTimeLock = m_ServerTime + (3) * 1000;
				} else {
					ship.m_Flag |= Common.ShipFlagBomb;
					if((EM.m_CotlType==Common.CotlTypeRich || EM.m_CotlType==Common.CotlTypeProtect) && (EM.m_OpsFlag & Common.OpsFlagEnclave)==0) ship.m_BattleTimeLock = m_ServerTime + (60 * 5) * 1000;
					else ship.m_BattleTimeLock = m_ServerTime + (60 * 60 * 2) * 1000;
				}
			}

            return true;

		} else if (m_Kind == 7) {
			if (EM.IsEdit()) return false;
			return true;
		} else if (m_Kind == 8) {
			if (EM.IsEdit()) return false;
			return true;
		} else if (m_Kind == 9) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			return true;
		} else if (m_Kind == 10) {
			if (EM.IsEdit()) return false;
			return true;
			
		} else if (m_Kind == 14) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if(ship.m_Flag & (Common.ShipFlagBomb)) return false;
			if(!EM.IsEdit()) {
				if(!EM.AccessControl(ship.m_Owner)) return false;
			}
			
			if ((ship.m_Type==Common.ShipTypeQuarkBase) && (ship.m_Flag & Common.ShipFlagBattle)!=0 && (ship.m_BattleTimeLock > EM.m_ServerCalcTime)) {
				EM.m_FormHint.Show(Common.Txt.WarningNeedReloadReactor, Common.WarningHideTime); 
				return false;
			}

			if(ship.m_Flag & Common.ShipFlagNoToBattle) {
				ship.m_Flag&=~Common.ShipFlagNoToBattle;

				if(m_ShipNum>=planet.ShipOnPlanetLow) {}
				else if(EM.IsEdit()) ship.m_Flag|=Common.ShipFlagBattle;
				else if ((ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagBattle | Common.ShipFlagPhantom)) != 0) { }
				else if ((planet.m_Flag & Planet.PlanetFlagWormhole) == 0 && (ship.m_Type==Common.ShipTypeCruiser || ship.m_Type==Common.ShipTypeWarBase) && EM.IsRear(planet, m_ShipNum, ship.m_Owner, ship.m_Race, true, true)) { }
				else if (EM.CntFriendGroup(planet, ship.m_Owner, ship.m_Race, true) < Common.BattleGroupInPlanetMax) { ship.m_Flag |= Common.ShipFlagBattle; EM.OutBattleRearShip(ship, planet.m_Ship.indexOf(ship), planet); }
				else {
					ship2 = EM.FindOutBattleShip(planet, ship);
					if (ship2 != null) {
						ship.m_Flag |= Common.ShipFlagBattle;
						ship2.m_Flag &= ~(Common.ShipFlagBattle | Common.ShipFlagNoToBattle);
						EM.OutBattleRearShip(ship, planet.m_Ship.indexOf(ship), planet);
					}
				}

			} else {
                ship.m_Flag&=~Common.ShipFlagBattle;
            	ship.m_Flag|=Common.ShipFlagNoToBattle;
			}

            return true;

		} else if(m_Kind==15) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship = planet.m_Ship[m_ShipNum];
			if (ship.m_Flag & Common.ShipFlagPhantom) return false;

			if(EM.IsEdit()) {}
			else if(EM.AccessControl(ship.m_Owner)) {}
			else return false;

			if(ship.m_Flag & Common.ShipFlagAIRoute) {
				ship.m_Flag&=~Common.ShipFlagAIRoute;
			} else {
				ship.m_Flag|=Common.ShipFlagAIRoute;
			}
			
			if (ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject)) { }
			else ship.m_BattleTimeLock=m_ServerTime+Common.BattleLock*1000;

			return true;

		} else if(m_Kind==16) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship = planet.m_Ship[m_ShipNum];
			if (ship.m_Flag & Common.ShipFlagPhantom) return false;

			if(EM.IsEdit()) {}
			else if(EM.AccessControl(ship.m_Owner)) {}
			else return false;

			if(ship.m_Flag & Common.ShipFlagAIAttack) {
				ship.m_Flag&=~Common.ShipFlagAIAttack;
			} else {
				ship.m_Flag|=Common.ShipFlagAIAttack;
			}
			
			return true;

		} else if(m_Kind==17) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			return true;

		} else if(m_Kind==18) {
			return true;

		} else if(m_Kind==19) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			
			if(EM.IsEdit()) {}
			else if(EM.AccessBuild(planet.m_Owner)) {}
			else return false;
			
			if(planet.m_Flag & Planet.PlanetFlagAutoBuild) {
				planet.m_Flag&=~Planet.PlanetFlagAutoBuild;
			} else {
				planet.m_Flag|=Planet.PlanetFlagAutoBuild;
			}

			return true;

		} else if(m_Kind==20) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if (ship.m_Type == Common.ShipTypeFlagship) {}
			else if (ship.m_Type == Common.ShipTypeQuarkBase) { }
			else if (ship.m_Race == Common.RaceTechnol) { }
			else return false;
			if (ship.m_Flag & Common.ShipFlagPhantom) return false;
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if(!EM.IsEdit()) {
				if(!EM.AccessControl(ship.m_Owner)) return false;
			}
			
			if (EM.ShipMaxShield(ship.m_Owner, ship.m_Id, ship.m_Type, ship.m_Race, ship.m_Cnt) <= 0) return false;

			if(ship.m_Flag & Common.ShipFlagPolar) {
				ship.m_Flag&=~Common.ShipFlagPolar;
			} else {
				ship.m_Flag|=Common.ShipFlagPolar;
			}

			return true;
			
		} else if(m_Kind==21) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if(ship.m_Type!=Common.ShipTypeServiceBase) return false;
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if(!EM.IsEdit()) {
				if(!EM.AccessControl(ship.m_Owner)) return false;
			}

			if(ship.m_Flag & Common.ShipFlagExtract) {
				ship.m_Flag&=~Common.ShipFlagExtract;
			} else {
				ship.m_Flag|=Common.ShipFlagExtract;
			}

			return true;
		} else if (m_Kind == 22) {
			return true;
			
		} else if(m_Kind==23) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if (ship.m_Type != Common.ShipTypeDreadnought) return false;
			if (ship.m_Race != Common.RaceTechnol) return false;
			if (ship.m_Flag & Common.ShipFlagPhantom) return false;
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if(!EM.IsEdit()) {
				if(!EM.AccessControl(ship.m_Owner)) return false;
			}
			
			if(ship.m_Flag & Common.ShipFlagTransiver) {
				ship.m_Flag&=~Common.ShipFlagTransiver;
			} else {
				ship.m_Flag|=Common.ShipFlagTransiver;
			}

			return true;

		} else if(m_Kind==24) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if (ship.m_Type != Common.ShipTypeCruiser) return false;
			if (ship.m_Race != Common.RacePeople) return false;
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if(!EM.IsEdit()) {
				if(!EM.AccessControl(ship.m_Owner)) return false;
			}
			
			if(ship.m_Flag & Common.ShipFlagSiege) {
				ship.m_Flag&=~Common.ShipFlagSiege;
			} else {
				ship.m_Flag|=Common.ShipFlagSiege;
			}

			return true;

		} else if(m_Kind==26) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if (!EM.AccessControl(ship.m_Owner)) return false;

			if (ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) return false;

			if ((ship.m_Flag & Common.ShipFlagBattle) == 0) {
				ship.m_Flag&=~Common.ShipFlagNoToBattle;

				if (m_ShipNum >= planet.ShipOnPlanetLow) { }
				else if(EM.IsEdit()) ship.m_Flag|=Common.ShipFlagBattle;
				else if ((ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagBattle | Common.ShipFlagPhantom)) != 0) { }
				else if ((planet.m_Flag & Planet.PlanetFlagWormhole) == 0 && (ship.m_Type == Common.ShipTypeCruiser || ship.m_Type == Common.ShipTypeWarBase) && EM.IsRear(planet, m_ShipNum, ship.m_Owner, ship.m_Race, true, true)) { }
				else if (EM.CntFriendGroup(planet, ship.m_Owner, ship.m_Race, true) < Common.BattleGroupInPlanetMax) { ship.m_Flag |= Common.ShipFlagBattle; EM.OutBattleRearShip(ship, planet.m_Ship.indexOf(ship), planet); }
				else {
					ship2 = EM.FindOutBattleShip(planet, ship);
					if (ship2 != null) {
						ship.m_Flag |= Common.ShipFlagBattle;
						ship2.m_Flag &= ~(Common.ShipFlagBattle | Common.ShipFlagNoToBattle);
						EM.OutBattleRearShip(ship, planet.m_Ship.indexOf(ship), planet);
					}
				}
			}

			var ave:int;
			if (ship.m_Type != Common.ShipTypeFlagship && ship.m_Type != Common.ShipTypeQuarkBase) {
				sum = 0;
				cnt = 0;
				for (i = 0; i < Common.ShipOnPlanetMax; i++) {
					ship2 = planet.m_Ship[i];
					if (ship2.m_Owner != ship.m_Owner) continue;
					if (ship2.m_Type != ship.m_Type) continue;
					if ((ship2.m_Flag & Common.ShipFlagBattle) == 0) continue;
					if (ship2.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) continue;
					sum += ship2.m_Cnt;
					cnt++;
				}
				if (sum >= cnt) {
					ave = Math.floor(sum / cnt);
					for (i = 0; i < Common.ShipOnPlanetMax; i++) {
						ship2 = planet.m_Ship[i];
						if (ship2.m_Owner != ship.m_Owner) continue;
						if (ship2.m_Type != ship.m_Type) continue;
						if ((ship2.m_Flag & Common.ShipFlagBattle) == 0) continue;
						if (ship2.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) continue;
						ship2.m_Cnt = ave;
						sum -= ave;
					}
					for (i = 0; (i < Common.ShipOnPlanetMax) && (sum > 0); i++) {
						ship2 = planet.m_Ship[i];
						if (ship2.m_Owner != ship.m_Owner) continue;
						if (ship2.m_Type != ship.m_Type) continue;
						if ((ship2.m_Flag & Common.ShipFlagBattle) == 0) continue;
						if (ship2.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) continue;
						ship2.m_Cnt++;
						sum--;
					}
				}
			}

			if (ship.m_ItemType!=Common.ItemTypeNone && ship.m_Type != Common.ShipTypeQuarkBase) {
				sum = 0;
				cnt = 0;
				for (i = 0; i < Common.ShipOnPlanetMax; i++) {
					ship2 = planet.m_Ship[i];
					if (ship2.m_Owner != ship.m_Owner) continue;
					if (ship2.m_Type != ship.m_Type) continue;
					if (ship2.m_ItemType != Common.ItemTypeNone && ship2.m_ItemType != ship.m_ItemType) continue;
					if ((ship2.m_Flag & Common.ShipFlagBattle) == 0) continue;
					if (ship2.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) continue;

					if (ship2.m_ItemType != Common.ItemTypeNone) sum += ship2.m_ItemCnt;
					cnt++;
				}
				if (sum >= cnt) {
					ave = Math.floor(sum / cnt);
					for (i = 0; i < Common.ShipOnPlanetMax; i++) {
						ship2 = planet.m_Ship[i];
						if (ship2.m_Owner != ship.m_Owner) continue;
						if (ship2.m_Type != ship.m_Type) continue;
						if (ship2.m_ItemType != Common.ItemTypeNone && ship2.m_ItemType != ship.m_ItemType) continue;
						if ((ship2.m_Flag & Common.ShipFlagBattle) == 0) continue;
						if (ship2.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) continue;

						if (ship2.m_ItemType == Common.ItemTypeNone) ship2.m_ItemType = ship.m_ItemType;
						ship2.m_ItemCnt = ave;
						sum -= ave;
					}
					for (i = 0; (i < Common.ShipOnPlanetMax) && (sum > 0); i++) {
						ship2 = planet.m_Ship[i];
						if (ship2.m_Owner != ship.m_Owner) continue;
						if (ship2.m_Type != ship.m_Type) continue;
						if (ship2.m_ItemType != Common.ItemTypeNone && ship2.m_ItemType != ship.m_ItemType) continue;
						if ((ship2.m_Flag & Common.ShipFlagBattle) == 0) continue;
						if (ship2.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) continue;
						
						if (ship2.m_ItemType == Common.ItemTypeNone) ship2.m_ItemType = ship.m_ItemType;
						ship2.m_ItemCnt++;
						sum--;
					}
				}
			}

			return true;
		} else if (m_Kind == 29) {
			if (EM.IsEdit()) return false;
			return true;
		} else if (m_Kind == 30) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;
			planet=sec.m_Planet[m_PlanetNum];
			ship = planet.m_Ship[m_ShipNum];

			planet = sec.m_Planet[m_PlanetNum];
			ship = planet.m_Ship[m_ShipNum];
			if (ship.m_Type == Common.ShipTypeFlagship || Common.IsBase(ship.m_Type)) return false;
			if (ship.m_Race != Common.RacePeople) return false;
			if (ship.m_ArrivalTime > EM.m_ServerCalcTime) return false;

			if (!EM.IsEdit()) {
				if(!EM.AccessControl(ship.m_Owner)) return false;
			}

			ship.m_Flag|=Common.ShipFlagNanits;
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship2 = planet.m_Ship[i];
				if(ship2.m_Type==Common.ShipTypeNone) continue;
				if (ship2.m_Owner != ship.m_Owner) continue;
				if (ship == ship2) continue;
				if (!(ship2.m_Flag & Common.ShipFlagNanits)) continue;

				ship2.m_Flag &= ~Common.ShipFlagNanits;
			}
			
			return true;
		} else if (m_Kind == 31) {
			if (EM.IsEdit()) return false;
			return true;
		} else if (m_Kind == 33) {
			return true;
		} else if (m_Kind == 34) {
			if (EM.IsEdit()) return false;
			return true;
		} else if (m_Kind == 35) {
			if (!EM.IsEdit()) return false;
			return true;
		} else if (m_Kind == 36) {
			if (EM.IsEdit()) return false;
			sec=EM.GetSector(m_SectorX,m_SectorY);
			if(sec==null) return false;
			if(m_PlanetNum<0) return false;
			if(m_ShipNum<0) return false;

			planet=sec.m_Planet[m_PlanetNum];
			ship=planet.m_Ship[m_ShipNum];
			if (ship.m_Type == Common.ShipTypeNone) return false;
			if (ship.m_Flag & Common.ShipFlagPhantom) return false;
			if(ship.m_ArrivalTime>EM.m_ServerCalcTime) return false;
			if (ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb)) return false;
			if (ship.m_Type != Common.ShipTypeSciBase) return false;
			if (!EM.AccessControl(ship.m_Owner)) return false;

            ship.m_Flag &= ~(/*Common.ShipFlagAutoReturn | Common.ShipFlagAutoLogic |*/ Common.ShipFlagBattle | Common.ShipFlagCapture | Common.ShipFlagExchange);
			if ((ship.m_Flag & Common.ShipFlagEject) == 0) {
				ship.m_Flag &= ~Common.ShipFlagPortal;
				ship.m_Flag |= Common.ShipFlagEject;
				ship.m_BattleTimeLock = m_ServerTime + Common.EjectTime * 1000;
			} else {
				ship.m_Flag &= ~(Common.ShipFlagPortal | Common.ShipFlagEject);
				ship.m_BattleTimeLock = m_ServerTime + Common.BattleLock;
			}

            return true;
		} else if (m_Kind == 37) {
			if (!EM.IsEdit()) return false;
			return true;
		}

		return false;
	}
	
	public function ProcessActionResearch():Boolean
	{
		var tech:int, dir:int, kof:int, alll:int;
		var ra:Array;
		var user:User,user2:User;

		var ai:Boolean=(m_Id & Common.OwnerAI)!=0;
		user=UserList.Self.GetUser(m_Id,false);
		if(user==null) return false;

		var atech:int=m_Kind;
		var adir:int=m_TargetNum;

		if(atech<0) {
			if(ai) return false;

            if(EM.m_UserResearchLeft!=0) {}
            else if(EM.m_UserFlag & Common.UserFlagTechNext) {}
            else return false;

            while(EM.m_UserFlag & Common.UserFlagTechNext) {
                tech=EM.m_UserResearchTechNext;
                dir=EM.m_UserResearchDirNext;
                if(tech<0 || tech>=Common.TechCnt) break;
                if(dir<0 || dir>=32) break;

                //kof=(1+alll)*(1+alll)*(1+(alll>>2));
                //if(kof>500000) kof=500000;
                
                ra=EM.CalcTechCost(m_Owner,tech);

//                EM.m_UserRes[Common.ItemTypeAntimatter]+=ra[0];
//                EM.m_UserRes[Common.ItemTypeMetal]+=ra[1];
//                EM.m_UserRes[Common.ItemTypeElectronics]+=ra[2];
//                EM.m_UserRes[Common.ItemTypeProtoplasm]+=ra[3];
//                EM.m_UserRes[Common.ItemTypeNodes]+=ra[4];
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeAntimatter, ra[0],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeMetal, ra[1],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeElectronics, ra[2],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeProtoplasm, ra[3],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeNodes, ra[4],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeQuarkCore, ra[5],false, false);

                break;
            }

            while(EM.m_UserResearchLeft!=0) {
                tech=EM.m_UserResearchTech;
                dir=EM.m_UserResearchDir;
                if(tech<0 || tech>=Common.TechCnt) break;
                if(dir<0 || dir>=32) break;

                ra=EM.CalcTechCost(m_Owner,tech,false);

//                EM.m_UserRes[Common.ItemTypeAntimatter]+=ra[0];
//                EM.m_UserRes[Common.ItemTypeMetal]+=ra[1];
//                EM.m_UserRes[Common.ItemTypeElectronics]+=ra[2];
//                EM.m_UserRes[Common.ItemTypeProtoplasm]+=ra[3];
//                EM.m_UserRes[Common.ItemTypeNodes]+=ra[4];
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeAntimatter, ra[0],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeMetal, ra[1],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeElectronics, ra[2],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeProtoplasm, ra[3],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeNodes, ra[4],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeQuarkCore, ra[5],false, false);

                break;
            }

            EM.m_UserResearchLeft=0;
            EM.m_UserResearchTech=0;
            EM.m_UserResearchDir=0;
            EM.m_UserResearchTechNext=0;
            EM.m_UserResearchDirNext=0;
            EM.m_UserFlag &= ~Common.UserFlagTechNext;
            
            return true;

        } else if(EM.IsUnResearch(user,atech,adir)) {
            if (!EM.CanUnResearch(user, atech, adir)) return false;
			
			dir = Common.TechDir[32 * atech + adir];
			if (!ai && (
				dir == Common.DirTransportPrice || 
				dir == Common.DirCorvettePrice || 
				dir == Common.DirCruiserPrice || 
				dir == Common.DirDreadnoughtPrice || 
				dir == Common.DirInvaderPrice ||
				dir == Common.DirDevastatorPrice ||
				dir == Common.DirWarBasePrice ||
				dir == Common.DirShipyardPrice ||
				dir == Common.DirSciBasePrice)) return false;
            
            user.m_Tech[atech]&=~(1<<adir);
            
            return true;

        } else if(EM.m_UserResearchLeft) {
        	if(ai) return false;
        	
			if (EM.PlusarTech()) { }
			else return false;
			if(EM.m_TechSpeed==0) return false;
        	
            alll=EM.TechCalcAllLvl();
            while(true) {
                tech=EM.m_UserResearchTech;
                dir=EM.m_UserResearchDir;
                if(tech<0 || tech>=Common.TechCnt) break;
                if(dir<0 || dir>=32) break;
                alll++;
                break;
            }

            var addnext:Boolean=true;
            while(EM.m_UserFlag & Common.UserFlagTechNext) {
                tech=EM.m_UserResearchTechNext;
                dir=EM.m_UserResearchDirNext;
                if(tech<0 || tech>=Common.TechCnt) break;
                if(dir<0 || dir>=32) break;

                if(tech==atech && dir==adir) addnext=false;

                //kof=(1+alll)*(1+alll)*(1+(alll>>2));
                //if(kof>500000) kof=500000;
                
                ra=EM.CalcTechCost(m_Owner,tech);

//                EM.m_UserRes[Common.ItemTypeAntimatter]+=ra[0];
//                EM.m_UserRes[Common.ItemTypeMetal]+=ra[1];
//                EM.m_UserRes[Common.ItemTypeElectronics]+=ra[2];
//                EM.m_UserRes[Common.ItemTypeProtoplasm]+=ra[3];
//                EM.m_UserRes[Common.ItemTypeNodes]+=ra[4];
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeAntimatter, ra[0],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeMetal, ra[1],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeElectronics, ra[2],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeProtoplasm, ra[3],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeNodes, ra[4],false, false);
				EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, Common.ItemTypeQuarkCore, ra[5],false, false);

                EM.m_UserResearchTechNext=0;
                EM.m_UserResearchDirNext=0;
                EM.m_UserFlag &= ~Common.UserFlagTechNext;
                break;
            }

            while(addnext) {
                tech=atech;
                dir=adir;

                if(!EM.CanResearch(user,tech,dir,EM.m_UserResearchTech,EM.m_UserResearchDir)) break;

                //kof=(1+alll)*(1+alll)*(1+(alll>>2));
                //if(kof>500000) kof=500000;
                
                ra=EM.CalcTechCost(m_Owner,tech);

//                if(ra[0]>EM.m_UserRes[Common.ItemTypeAntimatter]) break;
//                if(ra[1]>EM.m_UserRes[Common.ItemTypeMetal]) break;
//                if(ra[2]>EM.m_UserRes[Common.ItemTypeElectronics]) break;
//                if(ra[3]>EM.m_UserRes[Common.ItemTypeProtoplasm]) break;
//                if(ra[4]>EM.m_UserRes[Common.ItemTypeNodes]) break;
				if (ra[0] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeAntimatter)) break;
				if (ra[1] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeMetal)) break;
				if (ra[2] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeElectronics)) break;
				if (ra[3] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeProtoplasm)) break;
				if (ra[4] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeNodes)) break;
				if (ra[5] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeQuarkCore)) break;

//                EM.m_UserRes[Common.ItemTypeAntimatter]-=ra[0];
//                EM.m_UserRes[Common.ItemTypeMetal]-=ra[1];
//                EM.m_UserRes[Common.ItemTypeElectronics]-=ra[2];
//                EM.m_UserRes[Common.ItemTypeProtoplasm]-=ra[3];
//                EM.m_UserRes[Common.ItemTypeNodes]-=ra[4];
				EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeAntimatter, ra[0]);
				EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeMetal, ra[1]);
				EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeElectronics, ra[2]);
				EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeProtoplasm, ra[3]);
				EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeNodes, ra[4]);
				EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeQuarkCore, ra[5]);
                
                EM.m_UserResearchTechNext=tech;
   	            EM.m_UserResearchDirNext=dir;
       	        EM.m_UserFlag |= Common.UserFlagTechNext;

                break;
            }

            return true;

        } else if(ai) {
            if(!EM.CanResearch(user,atech,adir)) return false;
            user.m_Tech[atech]|=1<<adir;
            return true;

        } else {
            tech=atech;
            dir=adir;

            if(!EM.CanResearch(user,tech,dir)) return false;

            alll=EM.TechCalcAllLvl();
            //kof=(1+alll)*(1+alll)*(1+(alll>>2));
            //if(kof>500000) kof=500000;
            
            ra=EM.CalcTechCost(m_Owner,tech);

//            if(ra[0]>EM.m_UserRes[Common.ItemTypeAntimatter]) return false;
//            if(ra[1]>EM.m_UserRes[Common.ItemTypeMetal]) return false;
//            if(ra[2]>EM.m_UserRes[Common.ItemTypeElectronics]) return false;
//            if(ra[3]>EM.m_UserRes[Common.ItemTypeProtoplasm]) return false;
//            if(ra[4]>EM.m_UserRes[Common.ItemTypeNodes]) return false;
			if (ra[0] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeAntimatter)) return false;
			if (ra[1] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeMetal)) return false;
			if (ra[2] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeElectronics)) return false;
			if (ra[3] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeProtoplasm)) return false;
			if (ra[4] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeNodes)) return false;
			if (ra[5] > EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeQuarkCore)) return false;

//            EM.m_UserRes[Common.ItemTypeAntimatter]-=ra[0];
//            EM.m_UserRes[Common.ItemTypeMetal]-=ra[1];
//            EM.m_UserRes[Common.ItemTypeElectronics]-=ra[2];
//            EM.m_UserRes[Common.ItemTypeProtoplasm]-=ra[3];
//            EM.m_UserRes[Common.ItemTypeNodes]-=ra[4];
			EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeAntimatter, ra[0]);
			EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeMetal, ra[1]);
			EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeElectronics, ra[2]);
			EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeProtoplasm, ra[3]);
			EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeNodes, ra[4]);
			EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeQuarkCore, ra[5]);

            if(EM.m_TechSpeed==0) {
	            user.m_Tech[tech]|=1<<dir;
            	
            } else {
	            if(alll<Common.ResearchPeriod.length) EM.m_UserResearchLeft=Common.ResearchPeriod[alll];
    	        else EM.m_UserResearchLeft=400+alll*400;

        	    EM.m_UserResearchLeft=(EM.m_UserResearchLeft*EM.m_TechSpeed)>>8;
            	if(EM.m_UserResearchLeft<1) EM.m_UserResearchLeft=1;

            	EM.m_UserResearchTech=tech;
            	EM.m_UserResearchDir=dir;
            }

            return true;
        }
		
		return false;
	}
	
	public function ProcessActionTalent():Boolean
	{
		var cpt:Cpt;
		var user:User;
		var lvl:int;
		var cost:int;
		
		var forowner:uint = m_Tmp0;
		user = UserList.Self.GetUser(forowner, false);
		if (!user) return false;
		cpt=user.GetCpt(m_Id);
		if(cpt==null) return false;
		
		var talent:int=m_Kind;
		var vec:int=m_TargetNum;

		if(EM.IsTalentOff(user,cpt,talent,vec)) {
			if(!EM.CanTalentOff(user,cpt,talent,vec)) return false;

			lvl=1+cpt.CalcAllLvl()-1;
			cost=lvl*lvl*Common.CptCostTech;

			cpt.m_Talent[talent]&=~(1<<vec);

			if ((forowner & Common.OwnerAI) == 0) {
				user.m_Exp += cost;
				if (user.m_Exp > Common.ExpMax) user.m_Exp = Common.ExpMax;
			}
			return true;

		} else {
			if(!EM.CanTalentOn(user,cpt,talent,vec)) return false;

			lvl=1+cpt.CalcAllLvl();
			if(lvl>=Common.CptMaxLvl) return false;
			cost=lvl*lvl*Common.CptCostTech;
			if((forowner & Common.OwnerAI) == 0 && cost>user.m_Exp) return false;

            cpt.m_Talent[talent]|=1<<vec;
            
            if ((forowner & Common.OwnerAI) == 0) {
				user.m_Exp -= cost;
				if (user.m_Exp > Common.ExpMax) user.m_Exp = Common.ExpMax;
			}
            return true;
		}
		
		return false;
	}
	
	public function ProcessActionToHyperspace():Boolean
	{
		var ship2:Ship;

		if (EM.IsEdit()) return false;
		if (!EM.m_ItfFleet) return false;

		if (EM.m_CotlType == Common.CotlTypeCombat && (EM.m_GameState & Common.GameStatePlacing) == 0) { EM.m_FormHint.Show(Common.Txt.WarningFleetToHyperspaceInCombat, Common.WarningHideTime); return false;  }

		var cotl:SpaceCotl = EM.HS.GetCotl(Server.Self.m_CotlId);
		if (cotl == null || (cotl.m_RecvFull == false && cotl.m_RecvInfo == false)) { /*EM.m_FormHint.Show(Common.Txt.WarningFleetFar,Common.WarningHideTime);*/ return false; }
		
		var fleetempty:Boolean=EM.m_FormFleetBar.FleetIsEmpty();

		if (cotl.m_CotlType == Common.CotlTypeCombat) {
		} else if(!fleetempty) {
			if(!EM.OnOrbitCotl(Server.Self.m_CotlId)) { EM.m_FormHint.Show(Common.Txt.WarningFleetFar,Common.WarningHideTime); return false; }
			//if(((cotl.m_X-EM.m_FleetPosX)*(cotl.m_X-EM.m_FleetPosX)+(cotl.m_Y-EM.m_FleetPosY)*(cotl.m_Y-EM.m_FleetPosY))>(Common.CotlOrbitRadius*Common.CotlOrbitRadius)) { EM.m_FormHint.Show(Common.Txt.WarningFleetFar,Common.WarningHideTime); return false; }
		}

		var user:User=UserList.Self.GetUser(m_Owner);
		if(user==null) return false;

		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		var ship:Ship=planet.m_Ship[m_ShipNum];

		if ((cotl.m_CotlFlag & SpaceCotl.fDevelopment)) { EM.m_FormHint.Show(Common.Txt.WarningInDevNoExtract, Common.WarningHideTime); return false; }

		if(EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeCombat || EM.m_CotlType==Common.CotlTypeRich) {
			if(ship.m_Type==Common.ShipTypeFlagship) {
				if (!(EM.m_OpsFlag & Common.OpsFlagLeaveFlagship)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessFlagshipToHyperspace, Common.WarningHideTime); return false; } 
			} else if(ship.m_Type==Common.ShipTypeTransport) {
				if(!(EM.m_OpsFlag & Common.OpsFlagLeaveTransport)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessTransportToHyperspace,Common.WarningHideTime); return false; } 
			} else if (ship.m_Type == Common.ShipTypeInvader && EM.m_CotlType == Common.CotlTypeProtect) {
				if(EM.m_OpsSpeedCapture==0 || (EM.m_OpsFlag & Common.OpsFlagEnterSingleInvader)!=0) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessInvaderToHyperspace,Common.WarningHideTime); return false; } 
			} else {
				if(!(EM.m_OpsFlag & Common.OpsFlagLeaveShip)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessShipToHyperspace,Common.WarningHideTime); return false; } 
			}
		}
		
		var slotno:int=m_TargetNum;

		if (ship.m_Type == Common.ShipTypeNone) return false;
		if(ship.m_Flag & Common.ShipFlagPhantom) return false;
		if(ship.m_Owner!=m_Owner) return false;
		if(Common.IsBase(ship.m_Type)) return false;
		if (ship.m_ArrivalTime > EM.m_ServerCalcTime) return false;
		if(ship.m_Flag & (Common.ShipFlagBuild|Common.ShipFlagBomb)) return false;
		if(ship.m_Fuel<Common.FuelToHyperspace) { EM.m_FormHint.Show(Common.Txt.WarningFleetToHyperspaceNoFuel,Common.WarningHideTime); return false; }
		if(EM.IsBattle(planet,m_Owner,Common.RaceNone)) { EM.m_FormHint.Show(Common.Txt.WarningFleetToHyperspaceBattle,Common.WarningHideTime); return false; }

		if (EM.m_GameState & Common.GameStateWait) { EM.m_FormHint.Show(Common.Txt.WarningCotlWait, Common.WarningHideTime); return false;  }

		var cpt:Cpt=null;
		if(ship.m_Type==Common.ShipTypeFlagship) {
			cpt=user.GetCpt(ship.m_Id);
			if(cpt==null) return false;
			if(cpt.m_PlanetNum<0) return false;
			if(cpt.InHyperspace()) return false;
			if(cpt.m_CotlId!=Server.Self.m_CotlId) return false;
		}
		
		var id:uint=0;
		if (ship.m_Type == Common.ShipTypeFlagship) id = ship.m_Id;
		
		var shipmass:int = EM.ShipMass(m_Owner, id, ship.m_Type);

		if ((EM.m_FormFleetBar.EmpireFleetCalcMass() + shipmass * ship.m_Cnt) > Common.FleetMassMax/*[EM.m_FormFleetBar.m_Formation & 7]*/) {
			EM.m_FormHint.Show(Common.Txt.WarningFleetAddShipOutMass,Common.WarningHideTime);
			return false;
		}

		var cargotype:uint = ship.m_CargoType;
		var cargocnt:int = ship.m_CargoCnt;
		var itemtype:int = ship.m_ItemType;
		var itemcnt:int = ship.m_ItemCnt;
		if ((cotl.m_CotlFlag & SpaceCotl.fDevelopment)) { cargotype = 0; cargocnt = 0; itemtype = 0; itemcnt = 0; }
		else if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat || EM.m_CotlType == Common.CotlTypeRich) && (EM.m_OpsFlag & Common.OpsFlagItemToHyperspace) == 0) { cargotype = 0; cargocnt = 0; }

		var ship_shield:int = ship.m_Shield;
		if (ship.m_Type != Common.ShipTypeFlagship) ship_shield = 0;

		var ret:int = EM.m_FormFleetBar.EmpireFleetAdd(slotno, id, ship.m_Type, ship.m_Cnt, ship.m_CntDestroy, ship.m_HP, ship_shield, itemtype, itemcnt, cargotype, cargocnt, 0/*ship.m_Fuel*/, user.m_Race);
		if (ret <= 0) return false;
		
		if(fleetempty) {
//			EM.m_FleetPosX=cotl.m_X;
//			EM.m_FleetPosY=cotl.m_Y;
		}

		if(cpt!=null) {
			cpt.m_CotlId=0;
		}		

		while((ret==2) && (ship.m_ItemType!=Common.ItemTypeNone)) {
			// Drop
			var i:int=m_ShipNum;
			ship2=planet.m_Ship[i];
			if(((ship2.m_OrbitItemType!=Common.ItemTypeNone) && (ship2.m_OrbitItemType!=ship.m_ItemType))) {
			    i=m_ShipNum+1;
			    if(i>=Common.ShipOnPlanetMax) i=0;
			    ship2=planet.m_Ship[i];
			    if((ship2.m_Type!=Common.ShipTypeNone) || ((ship2.m_OrbitItemType!=Common.ItemTypeNone) && (ship2.m_OrbitItemType!=ship.m_ItemType))) {
			        i=m_ShipNum-1;
			        if(i<0) i=Common.ShipOnPlanetMax-1;
			        ship2=planet.m_Ship[i];
			        if((ship2.m_Type!=Common.ShipTypeNone) || ((ship2.m_OrbitItemType!=Common.ItemTypeNone) && (ship2.m_OrbitItemType!=ship.m_ItemType))) break;
			    }
			}

			if(ship2.m_OrbitItemType==ship.m_ItemType) {
			    ship2.m_OrbitItemCnt+=ship.m_ItemCnt;
			} else {
			    ship2.m_OrbitItemType=ship.m_ItemType;
			    ship2.m_OrbitItemCnt=ship.m_ItemCnt;
			}
			ship2.m_OrbitItemOwner=ship.m_Owner;
			ship2.m_OrbitItemTimer=EM.m_ServerCalcTime;

			ship.m_ItemType=Common.ItemTypeNone;
			ship.m_ItemCnt=0;
			break;
		}

		if(EM.m_CotlType==Common.CotlTypeCombat && shipmass>0) {
			EM.m_CombatMass += ship.m_Cnt * shipmass;
		}
		
		ship.Clear();

		EM.m_FormFleetBar.Update();
		EM.m_FormFleetItem.Update();
		
		return true;
	}

	public function ProcessActionFromHyperspace():Boolean
	{
		var i:int,tt:int;
		var cotl2:SpaceCotl;
		var user_test:User;

		if (EM.IsEdit()) return false;

		var cotl:SpaceCotl=EM.HS.GetCotl(Server.Self.m_CotlId);
		if (cotl == null || cotl.m_RecvInfo == false) { EM.m_FormHint.Show(Common.Txt.WarningFleetFar, Common.WarningHideTime); return false; }

		while (cotl.m_ProtectTime > EM.GetServerGlobalTime()) {
			if (EM.IsWinMaxEnclave()) {
			} else if (EM.m_CotlType == Common.CotlTypeRich) {
				if (EM.m_UnionId == 0) { }
				else if (cotl.m_UnionId == EM.m_UnionId) break;
			} else if (EM.m_CotlType == Common.CotlTypeUser) {
				if (EM.IsFriendHome(EM.m_CotlOwnerId, m_Owner)) break;
			} else break;

			EM.m_FormHint.Show(Common.Txt.WarningCotlProtect, Common.WarningHideTime); 
			return false;
		}

		var slotno:int=m_TargetNum;
		var cnt:int=m_Cnt; if(cnt>Common.ShipMaxCnt) cnt=Common.ShipMaxCnt;
		var itemcnt:int = m_Kind;

		var shiptype:int=m_TargetPlanetNum;
		var module:int = m_TargetSectorX;

		var shipmass:int=0;
		if (EM.m_CotlType == Common.CotlTypeCombat) {
			if ((shiptype==Common.ShipTypeFlagship) && (EM.m_CombatFlag & FormCombat.FlagFlagship)==0) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessFlagshipFromHyperspace, Common.WarningHideTime); return false; } 

			var maxmass:int=EM.m_CombatMass;
			if (maxmass == 0) { EM.m_FormHint.Show(Common.Txt.WarningFleetOutLimitCombat,Common.WarningHideTime); return false; }
			else if(maxmass>0) {
				shipmass=EM.ShipMass(m_Owner,m_Id,shiptype);
				if (shipmass <= 0) return false;
				var cntmax:int = Math.floor(maxmass / shipmass);
				if(cnt>cntmax) cnt=cntmax;
				if (cnt <= 0) { EM.m_FormHint.Show(Common.Txt.WarningFleetOutLimitCombat,Common.WarningHideTime); return false; }
			}
		}

		if(EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeCombat || EM.m_CotlType==Common.CotlTypeRich) {
			if((EM.m_OpsFlag & Common.OpsFlagEnterSingleInvader)!=0) {}
			else if(shiptype==Common.ShipTypeFlagship) {
				if (!(EM.m_OpsFlag & Common.OpsFlagEnterFlagship)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessFlagshipFromHyperspace, Common.WarningHideTime); return false; }
			} else if(shiptype==Common.ShipTypeTransport) {
				if(!(EM.m_OpsFlag & Common.OpsFlagEnterTransport)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessTransportFromHyperspace,Common.WarningHideTime); return false; }
			} else if(shiptype==Common.ShipTypeInvader) {
				if(EM.m_OpsSpeedCapture==0 || !(EM.m_OpsFlag & Common.OpsFlagEnterShip)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessInvaderFromHyperspace,Common.WarningHideTime); return false; }
			} else {
				if(!(EM.m_OpsFlag & Common.OpsFlagEnterShip)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessShipFromHyperspace,Common.WarningHideTime); return false; }
			}
		}

		if (cotl.m_CotlType != Common.CotlTypeUser || cotl.m_AccountId != Server.Self.m_UserId) {
			var user_ac:User = UserList.Self.GetUser(m_Owner);
			if (user_ac == null) return false;
			if (((user_ac.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift) <= Common.UserRankNovice) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceRank2, Common.WarningHideTime); return false; }
		}

		if ((cotl.m_CotlType == Common.CotlTypeUser) && (cotl.m_AccountId != Server.Self.m_UserId)) {
			var user_cotl:User = UserList.Self.GetUser(cotl.m_AccountId);
			if (user_cotl == null) return false;
			if (((user_cotl.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift) <= Common.UserRankNovice) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceRank, Common.WarningHideTime); return false; }

			var zone:Zone = EM.HS.GetZone(cotl.m_ZoneX, cotl.m_ZoneY);
			if (zone && zone.m_Lvl != 0) {
				if (!EM.TestRatingFlyCotl(cotl.m_AccountId, EM.m_CotlZoneLvl)) { EM.m_FormHint.Show(Common.Txt.WarningNoRating, Common.WarningHideTime); return false; }
			}
		}

		if (cotl.m_CotlType == Common.CotlTypeCombat) {
			//for (i = 0; i < CombatUser.UserMax; i++) {
			//	if (EM.m_FormCombat.m_CombatAtkUser[i].m_Id == m_Owner) break;
			//	if (EM.m_FormCombat.m_CombatDefUser[i].m_Id == m_Owner) break;
			//}
			//if(i>=CombatUser.UserMax)
			var usercombat:User = UserList.Self.GetUser(m_Owner);
			if (usercombat == null || usercombat.m_Team < 0) { EM.m_FormHint.Show(Common.Txt.WarningNoAccessCombat, Common.WarningHideTime); return false; }
		} else {
			if (!EM.OnOrbitCotl(Server.Self.m_CotlId)) { EM.m_FormHint.Show(Common.Txt.WarningFleetFar, Common.WarningHideTime); return false; }
		}

		if (EM.m_GameState & Common.GameStateWait) { EM.m_FormHint.Show(Common.Txt.WarningCotlWait, Common.WarningHideTime); return false;  }

		var user:User=UserList.Self.GetUser(m_Owner);
		if(user==null) return false;

		if(EM.m_OpsMaxRating>0 && user.m_Rating>=EM.m_OpsMaxRating) { EM.m_FormHint.Show(Common.Txt.WarningLargeRating,Common.WarningHideTime); return false; }

		var sec:Sector=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		var planet:Planet=sec.m_Planet[m_PlanetNum];
		var ship:Ship = planet.m_Ship[m_ShipNum];

		if (m_ShipNum >= planet.ShipOnPlanetLow) {
			if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
			if (!Common.ShipLowOrbit[shiptype]) return false;
			if (!EM.AccessLowOrbit(planet, m_Owner, Common.RaceNone)) return false;
		}

		if (cotl.m_CotlType == Common.CotlTypeCombat) {
			if((planet.m_Flag & Planet.PlanetFlagWormhole)!=0) {
				tt = EM.TeamType();
				if (tt < 0) return false;
				if (tt != (m_ShipNum & 1)) return false;
			}
		}

		while (cotl.m_CotlType == Common.CotlTypeUser) {
			if (cotl.m_AccountId == m_Owner) break;

			cotl2 = EM.HS.GetCotl(EM.m_RootCotlId);
			if (cotl2 == null) { EM.m_FormHint.Show(Common.Txt.WarningFleetFar, Common.WarningHideTime); return false; }

			if (cotl2.m_ProtectTime > EM.GetServerGlobalTime()) { EM.m_FormHint.Show(Common.Txt.WarningCotlProtectOnlyHome, Common.WarningHideTime); return false;  }

			break;
		}

		while (cotl.m_CotlType == Common.CotlTypeRich) {
			cotl2 = EM.HS.GetCotl(EM.m_RootCotlId);
			if (cotl2 == null) { EM.m_FormHint.Show(Common.Txt.WarningFleetFar, Common.WarningHideTime); return false; }

			if (EM.IsWinMaxEnclave()) {
				if ((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) != (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) {
					EM.m_FormHint.Show(Common.Txt.WarningCotlOnlyRWH, Common.WarningHideTime);
					return false;
				}
			} else {
				if ((planet.m_Flag & Planet.PlanetFlagEnclave) != 0) {
					if (planet.m_Owner == m_Owner) break;
//					user_test = UserList.Self.GetUser(Server.Self.m_UserId);
//					if (user_test != null) {
//						cotl2 = EM.m_FormGalaxy.GetCotl(user_test.m_CitadelCotlId);
//						if (cotl2 != null && EM.OnOrbitCotl(cotl2, EM.m_FleetPosX, EM.m_FleetPosY)) break;
//					}
				}
			}

//			if (EM.IsWinMaxEnclave()) { EM.m_FormHint.Show(Common.Txt.WarningCotlOnlyBase, Common.WarningHideTime); return false; }
			if ((EM.m_GameState & Common.GameStateDevelopment) == 0 && cotl2.m_ProtectTime > EM.GetServerGlobalTime()) { EM.m_FormHint.Show(Common.Txt.WarningCotlProtectOnlyHome, Common.WarningHideTime); return false;  }

			break;
		}

/*		while (((EM.m_FormFleetBar.m_Formation & 7) == 3) || ((EM.m_FormFleetBar.m_Formation & 7) == 4)) {
			if (EM.m_CotlType == Common.CotlTypeCombat) break; // Для битвы построение не важно

			if ((EM.m_CotlType == Common.CotlTypeUser) && (EM.m_CotlOwnerId == m_Owner)) break;
			//cotl2=EM.m_FormGalaxy.GetCotl(EM.m_RootCotlId);
			//if (cotl2 != null && EM.OnOrbitCotl(cotl2, EM.m_FleetPosX, EM.m_FleetPosY)) break;
			
			if ((EM.m_CotlType == Common.CotlTypeRich) && (planet.m_Owner == m_Owner) && (planet.m_Flag & Planet.PlanetFlagEnclave) != 0) break;

//			if ((planet.m_Flag & Planet.PlanetFlagEnclave) != 0) {
//				if (planet.m_Owner == m_Owner) break;
//				user_test = UserList.Self.GetUser(Server.Self.m_UserId);
//				if (user_test != null) {
//					cotl2 = EM.m_FormGalaxy.GetCotl(user_test.m_CitadelCotlId);
//					if (cotl2 != null && EM.OnOrbitCotl(cotl2, EM.m_FleetPosX, EM.m_FleetPosY)) break;
//				}
//			}

			EM.m_FormHint.Show(Common.Txt.WarningFleetFormationNoFromHyperspace, Common.WarningHideTime);
			return false;
		}*/

		if (planet.m_Flag & Planet.PlanetFlagNoMove) return false;
		if (planet.m_Flag & Planet.PlanetFlagGravitor) return false;
		if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0 && (planet.m_Flag & Planet.PlanetFlagLarge) == 0) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceWormhole, Common.WarningHideTime); return false; }
		if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceWormhole, Common.WarningHideTime); return false; }

		if (EM.m_CotlType == Common.CotlTypeCombat) {
			if ((EM.m_GameState & Common.GameStatePlacing) == 0) {
				if ((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) { }
				else { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceProtectZone, Common.WarningHideTime); return false; }
			}

			if ((planet.m_Team < 0) && (planet.m_Flag & Planet.PlanetFlagWormhole) != 0) { }
			else {
				if (planet.m_Team < 0) return false;
				tt = EM.TeamType();
				if (tt < 0) return false;
				if (tt == 0 && planet.m_Team == EM.m_OpsTeamEnemy) { }
				else if(tt == 1 && planet.m_Team == EM.m_OpsTeamOwner) { }
				else { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceProtectZone, Common.WarningHideTime); return false; }
			}

		} else if(EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeCombat) {
			if((planet.m_Flag & Planet.PlanetFlagArrivalDef)!=0 && EM.m_UnionId==EM.m_CotlUnionId) {}
			else if((planet.m_Flag & Planet.PlanetFlagArrivalAtk)!=0 && EM.m_UnionId!=EM.m_CotlUnionId) {}
			else { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceProtectZone,Common.WarningHideTime); return false; }

			if(planet.m_LandingPlace<=0 || planet.m_LandingPlace>=EM.m_FormMiniMap.m_LandingAccess.length) return false;

			var userinlandingplace:Boolean=false;
			for(i=0;i<EM.m_FormMiniMap.m_LandingAccess.length;i++) {
				if(EM.m_FormMiniMap.m_LandingAccess[i]==Server.Self.m_UserId) { userinlandingplace=true; break; }
			}

			if(EM.m_FormMiniMap.m_LandingAccess[planet.m_LandingPlace]==0 && !userinlandingplace) {}
			else if(EM.m_FormMiniMap.m_LandingAccess[planet.m_LandingPlace]==Server.Self.m_UserId) {}
			else { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceProtectZone,Common.WarningHideTime); return false; }

			if(EM.m_OpsPriceEnterType==Common.OpsPriceTypeFuel) {
				if(EM.m_FormFleetBar.m_FleetFuel<EM.m_OpsPriceEnter) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceProtectNoFuel,Common.WarningHideTime); return false; }

			} else if(EM.m_OpsPriceEnterType!=0) return false;

			if(EM.m_CotlType==Common.CotlTypeProtect && (EM.m_OpsFlag & Common.OpsFlagPulsarEnterActive)!=0 && !EM.CalcPulsarStateProtect(EM.m_ServerCalcTime)) return false;
			
		} else {
			//var noenter:Boolean=false;//EM.m_FormMiniMap.m_NoEnterFromHyperspace;
			/*if((planet.m_Flag & Planet.PlanetFlagWormhole)!=0) {
				if((planet.m_Flag & Planet.PlanetFlagWormholeOpen)==0) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceWormhole,Common.WarningHideTime); return false; }
				if(EM.m_CotlType!=Common.CotlTypeRich) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceWormhole,Common.WarningHideTime); return false; }
			} else */
			//if(!noenter) {
			if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0) {
				if((planet.m_Flag & Planet.PlanetFlagWormholeOpen)==0) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceWormholeOpen,Common.WarningHideTime); return false; }
			} else {
				if(!EM.TestExitFromHyperspace(m_SectorX,m_SectorY,m_PlanetNum,m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceEnemy,Common.WarningHideTime); return false; }
			}
			//}
		}

		if(ship.m_Type!=Common.ShipTypeNone) return false;
//		if(noenter && (planet.m_Flag & Planet.PlanetFlagGigant)==0) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceEnemyAll,Common.WarningHideTime); return false; }
		if(planet.m_Owner && EM.GetRel(m_Owner,planet.m_Owner) & Common.PactNoFly) { EM.m_FormHint.Show(Common.Txt.WarningPactNoFly,Common.WarningHideTime); return false; }
		if(EM.CntFriendGroup(planet,m_Owner,Common.RaceNone)>=Common.GroupInPlanetMax) return false;

		if((EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeCombat) && EM.m_OpsPriceEnterType==Common.OpsPriceTypeFuel) {}
		else if(EM.m_FormFleetBar.m_FleetFuel<Common.FuelFromHyperspaceNeed) { EM.m_FormHint.Show(Common.Txt.WarningFleetFromHyperspaceNoFuel,Common.WarningHideTime); return false; }

		if(EM.IsRear(planet,m_ShipNum,m_Owner,Common.RaceNone,true)) return false;

		var slot:FleetSlot=new FleetSlot();
		var maxmoduleps:int=0;
		if(EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeCombat) {}
		else if(module<=0) {}
		//else if(planet.m_Owner!=0 && (planet.m_Owner==Server.Self.m_UserId || EM.IsFriendEx(planet, planet.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone))) maxmoduleps=EM.DirValE(m_Owner,Common.DirTransportCargo);
		else maxmoduleps=EM.DirValE(m_Owner,Common.DirTransportCargo); 

		var cntmodule:Object=new Object();
		var alldestroy:Boolean=false;
		for(i=0;i<Common.ShipOnPlanetMax;i++) {
			var ship2:Ship=planet.m_Ship[i];
			if((ship2.m_Type==Common.ShipTypeShipyard) && (ship2.m_Owner==m_Owner)) { alldestroy=true; break; }
		}
		//if (m_GameState & GameStateDevelopment) {
		if((cotl.m_CotlFlag & SpaceCotl.fDevelopment)) {
			slot.m_Id=m_Id;
			slot.m_Type=shiptype;
			slot.m_Cnt=cnt;
			slot.m_CntDestroy=0;
			slot.m_HP = EM.ShipMaxHP(m_Owner, m_Id, shiptype, user.m_Race);
			slot.m_Shield = EM.ShipMaxShield(m_Owner, m_Id, shiptype, user.m_Race, cnt);
			slot.m_ItemType=Common.ItemTypeNone;
			slot.m_ItemCnt=0;
		} else if((EM.m_OpsFlag & Common.OpsFlagEnterSingleInvader)!=0) {
			slot.m_Id=0;
			slot.m_Type=Common.ShipTypeInvader;
			slot.m_Cnt=1;
			slot.m_CntDestroy=0;
			slot.m_HP=EM.ShipMaxHP(m_Owner,0,Common.ShipTypeInvader,user.m_Race);
			slot.m_Shield=0;
			slot.m_ItemType=Common.ItemTypeNone;
			slot.m_ItemCnt=0;
		} else {
			if(!EM.m_FormFleetBar.EmpireFleetExtract(slotno,shiptype,m_Id,cnt,itemcnt,maxmoduleps,alldestroy,user.m_Race,slot,cntmodule)) return false;
		}

		if(slot.m_Type==Common.ShipTypeFlagship) ship.m_Id=Common.FlagshipIdFlag | slot.m_Id;
		else ship.m_Id=m_Id;

		if (cntmodule.cnt > 0) {
			ship.m_CargoType = Common.ItemTypeModule;
			ship.m_CargoCnt = cntmodule.cnt;
		} else {
			ship.m_CargoType = 0;
			ship.m_CargoCnt = 0;
		}
		ship.m_Owner=m_Owner;
//		ship.m_FleetCptId=0;
		ship.m_Race=user.m_Race;
		ship.m_ArrivalTime=0;
		ship.m_FromSectorX=m_SectorX;
		ship.m_FromSectorY=m_SectorY;
		ship.m_FromPlanet=m_PlanetNum;
		ship.m_FromPlace=m_ShipNum;
		ship.m_Type=slot.m_Type;
		ship.m_Cnt=slot.m_Cnt;
		ship.m_CntDestroy=slot.m_CntDestroy;
		ship.m_HP = slot.m_HP;
		if(ship.m_Type!=Common.ShipTypeFlagship) ship.m_Shield=EM.ShipMaxShield(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race,ship.m_Cnt);
		else ship.m_Shield=slot.m_Shield;
		ship.m_Fuel=Common.FuelFromHyperspaceLoad;
		ship.m_Flag=Common.ShipFlagExchange;
		ship.m_BattleTimeLock=0;
		ship.m_ItemType=slot.m_ItemType;
		ship.m_ItemCnt = slot.m_ItemCnt;
		ship.m_Link = 0;
		if((planet.m_Flag & Planet.PlanetFlagWormhole)!=0) ship.m_BattleTimeLock=m_ServerTime+5*60*1000;
		else ship.m_BattleTimeLock = m_ServerTime + Common.BattleLock * 1000;
		
		if (ship.m_Type == Common.ShipTypeDevastator) ship.m_Flag |= Common.ShipFlagAIAttack;
		else if (ship.m_Type == Common.ShipTypeTransport) ship.m_Flag |= Common.ShipFlagNoToBattle;

		if(ship.m_Type==Common.ShipTypeFlagship) {
			var cpt:Cpt=user.GetCpt(ship.m_Id);
			if(cpt!=null) {
			    cpt.m_SectorX=m_SectorX;
			    cpt.m_SectorY=m_SectorY;
			    cpt.m_PlanetNum=m_PlanetNum;
			    cpt.m_CotlId=Server.Self.m_CotlId;
			}
		}

		if(EM.m_CotlType==Common.CotlTypeCombat && shipmass>0) {
			if (EM.m_CombatMass > 0) {
				EM.m_CombatMass = Math.max(0, EM.m_CombatMass - ship.m_Cnt * shipmass);
			}
		}

		EM.m_FormFleetBar.Update();
		EM.m_FormFleetItem.Update();

		return true;
	}
	
	public function ProcessActionFleetFuel():Boolean
	{
		var cnt:int=m_Cnt;
		if (cnt <= 0) return false;
		
		var vvv:int = EM.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeFuel);
		if (cnt > vvv) cnt = vvv;
		if (cnt <= 0) return false;

		cnt=EM.m_FormFleetBar.EmpireFleetFuelChange(cnt);
        if (cnt == 0) return false;
		
		EM.m_FormFleetBar.FleetSysItemExtract(Common.ItemTypeFuel,cnt);

		EM.m_FormFleetBar.Update();
		EM.m_FormFleetItem.Update();
		return true;
	}
	
	public function ProcessActionConstruction():Boolean
	{
		var e:int;
		var sec:Sector;
		var planet:Planet;
		var lvl:int;

		sec=EM.GetSector(m_SectorX,m_SectorY);
		if(sec==null) return false;
		if (m_PlanetNum < 0) return false;
		else if (m_PlanetNum >= sec.m_Planet.length) return false;
		planet = sec.m_Planet[m_PlanetNum];

		if (EM.IsEdit()) {
			if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
		}
		else if (EM.m_CotlType == Common.CotlTypeUser && m_Owner != EM.m_CotlOwnerId) return false;
		else if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && ((EM.m_OpsFlag & Common.OpsFlagBuilding) == 0)) return false;
		else if(!EM.AccessBuild(planet.m_Owner)) return false;
		//if(EM.m_CotlType==Common.CotlTypeUser && !EM.AccessBuild(EM.m_CotlOwnerId)) return false;

		var cell:int = m_ShipNum;
		var bt:int = m_Id;

		if (m_Kind == 1) {
			//if (cell == 4 || cell == 7) return false;
			if (planet.PlanetCellType(cell) <= 0) return false;

			var user:User = null;
			if (EM.IsEdit()) { }
			else {
				user = UserList.Self.GetUser(planet.m_Owner);
				if (user == null) return false;
			}

			if (cell<0 || cell>=Planet.PlanetCellCnt) return false;
			if ((planet.m_CellBuildFlag & (1 << cell)) != 0) return false;

			if ((planet.m_Cell[cell] >> 3) == 0) {
				if (bt <= 0) return false;
				
				if (EM.IsWinMaxEnclave() && (bt != Common.BuildingTypeEnergy && bt != Common.BuildingTypeLab && bt != Common.BuildingTypeStorage)) return false;

				if (bt == Common.BuildingTypeCity || bt == Common.BuildingTypeFarm || bt == Common.BuildingTypeTech || bt == Common.BuildingTypeEngineer || bt == Common.BuildingTypeTechnician || bt == Common.BuildingTypeNavigator) {
					if ((planet.m_Flag & Planet.PlanetFlagLarge) == 0) {
//						EM.m_FormHint.Show(Common.Txt.WarningBuildingNeedLargePlanet,Common.WarningHideTime); return false;
						return false;
					}
				} else if (bt == Common.BuildingTypeModule || bt == Common.BuildingTypeFuel || bt == Common.BuildingTypePower || bt == Common.BuildingTypeArmour || bt == Common.BuildingTypeDroid || bt == Common.BuildingTypeMachinery || bt == Common.BuildingTypeMine) {
					if ((planet.m_Flag & Planet.PlanetFlagLarge) == 0) {
//						EM.m_FormHint.Show(Common.Txt.WarningBuildingNeedLargePlanet,Common.WarningHideTime); return false;
						return false;
					}
				} else if (bt == Common.BuildingTypeElectronics || bt == Common.BuildingTypeMetal || bt == Common.BuildingTypeAntimatter || bt == Common.BuildingTypePlasma) {
					if ((planet.m_Flag & Planet.PlanetFlagLarge) != 0) {
//						EM.m_FormHint.Show(Common.Txt.WarningBuildingNeedSmallPlanet,Common.WarningHideTime); return false;
						return false;
					}
				}

				if(EM.IsEdit()) {}
				else if (EM.PlanetItemGet_Sub(m_Owner, planet, Common.ItemTypeModule, true) < Common.BuildingCost[bt * Common.BuildingLvlCnt + 0]) return false;

				e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + 0];
				if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) return false;

				if(EM.IsEdit()) {}
				else if (user.m_BuildingLvl[bt] <= 0) return false;

				planet.m_Cell[cell] = (bt << 3) | 1;
				if (EM.IsEdit()) {
					planet.m_CellBuildFlag &= ~(1 << cell);
				} else {
					planet.m_CellBuildFlag |= 1 << cell;
					planet.m_CellBuildEnd = Math.max(planet.m_CellBuildEnd, EM.m_ServerCalcTime) + EM.CalcBuildingBuildTime(bt, 1) * 1000;
				}
				
				planet.PlanetItemBuildByBuilding(bt);

				if(EM.IsEdit()) {}
				else EM.PlanetItemExtract(m_Owner, planet, Common.ItemTypeModule, Common.BuildingCost[bt * Common.BuildingLvlCnt + 0], true);

			} else {
				bt = (planet.m_Cell[cell] >> 3);
				lvl = (planet.m_Cell[cell] & 7);
				if (lvl >= Common.BuildingLvlCnt) return false;

				if(EM.IsEdit()) {}
				else if (EM.PlanetItemGet_Sub(m_Owner, planet, Common.ItemTypeModule, true) < Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl + 1 - 1]) return false;

				e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl + 1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
				if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) return false;

				if (EM.IsEdit()) {
					if (Common.BuildingLvlCnt < (lvl + 1)) return false;
				} else if (user.m_BuildingLvl[bt] < (lvl + 1)) return false;

					planet.m_Cell[cell] = (bt << 3) | (lvl + 1);
				if (EM.IsEdit()) {
					planet.m_CellBuildFlag &= ~(1 << cell);
				} else {
					planet.m_CellBuildFlag |= 1 << cell;
					planet.m_CellBuildEnd = Math.max(planet.m_CellBuildEnd, EM.m_ServerCalcTime) + EM.CalcBuildingBuildTime(bt, lvl + 1) * 1000;
				}

				if(EM.IsEdit()) {}
				else EM.PlanetItemExtract(m_Owner, planet, Common.ItemTypeModule, Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl + 1 - 1], true);
			}

			if (EM.m_FormPlanet.visible) EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 2) {
			if (cell<0 || cell>=Planet.PlanetCellCnt) return false;
			if ((planet.m_CellBuildFlag & (1 << cell)) == 0) return false;
			
			bt = planet.m_Cell[cell] >> 3;
			lvl = (planet.m_Cell[cell] & 7);
			
			if (lvl <= 1) {
				e = 0 - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
				if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) return false;

				planet.m_Cell[cell] = 0;
			} else {
				e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
				if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) return false;
				
				planet.m_Cell[cell] = (bt << 3) | (lvl - 1);
			}

			planet.m_CellBuildFlag &= ~(1 << cell);
			if (planet.m_CellBuildFlag == 0) planet.m_CellBuildEnd = 0;
			else {
				var p:int = EM.CalcBuildingBuildTime(bt, lvl);
				if (planet.m_CellBuildEnd > p*1000) planet.m_CellBuildEnd = Math.max(planet.m_CellBuildEnd - p*1000, EM.m_ServerCalcTime);
				else planet.m_CellBuildEnd = EM.m_ServerCalcTime;
			}

			planet.PlanetItemRemoveByBuilding(bt);

			if (EM.IsEdit()) {}
			else EM.PlanetItemAdd(m_Owner, planet, Common.ItemTypeModule, Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl - 1], false, true, true, PlanetItem.PlanetItemFlagNoMove);

			if (EM.m_FormPlanet.visible) EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 3) {
			if (cell<0 || cell>=Planet.PlanetCellCnt) return false;
			if ((planet.m_CellBuildFlag & (1 << cell)) != 0) return false;
			if (planet.m_Cell[cell] == 0) return false;

			bt = planet.m_Cell[cell] >> 3;
			lvl = (planet.m_Cell[cell] & 7);
//			if (lvl <= 1) {
				e = 0 - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
				if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) return false;
//			} else {
//				e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
//				if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) return false;
//			}

			if (EM.m_CotlType != Common.CotlTypeUser && !EM.IsEdit()) {
				if (EM.PlanetItemGet_Sub(m_Owner, planet, Common.ItemTypeModule, true) < (Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl - 1] >> 1)) return false;

				EM.PlanetItemExtract(m_Owner, planet, Common.ItemTypeModule, (Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl - 1] >> 1), true);
			}

			planet.m_Cell[cell] = 0;

			planet.PlanetItemRemoveByBuilding(bt);

			if (EM.m_FormPlanet.visible) EM.m_FormPlanet.Update();
			return true;
		}

		return false;
	}

	public function ProcessActionItemMove():Boolean
	{
		var pi:PlanetItem;
		var fi:FleetItem;
		var fs:FleetSlot;
		var vin:int;
		var vdw:uint;
		var i:int;
		var ship:Ship;
		
		var fromtype:int = m_Kind;
		var fromslot:int = m_Id;
		var totype:int = m_TargetPlanetNum;
		var toslot:int = m_TargetNum;
		var cnt:int = m_Cnt;
		
		if (EM.IsEdit()) {
			if (fromtype == 1 || totype == 1) {
				if (fromtype != totype) return false;
				if ((EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
			}
		}
		
		if (cnt < 0) return false;
		if (fromtype == totype && fromslot == toslot) return false;
		if (fromtype == 9 && totype == 9) return false;

		if (!EM.m_ItfFleet) {
			if (fromtype == 2 || totype == 2) return false;
		}

		var planet:Planet = null;
		if (m_PlanetNum >= 0) {
			var sec:Sector = EM.GetSector(m_SectorX, m_SectorY);
			if (sec == null) return false;
			if (m_PlanetNum >= sec.m_Planet.length) return false;
			planet = sec.m_Planet[m_PlanetNum];
		}
		
		if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat || EM.IsWinMaxEnclave()) && ((EM.m_OpsFlag & Common.OpsFlagItemToHyperspace) == 0)) {
			if ((fromtype == 1) && (totype != 1)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessItemMove, Common.WarningHideTime); return false; }
			else if((fromtype != 1) && (totype == 1)) { EM.m_FormHint.Show(Common.Txt.WarningFleetNoAccessItemMove, Common.WarningHideTime); return false; }
		}
		
		var sack:Boolean = false;
		var ctrl:Boolean = true;
		
		while ((fromtype == 1 && totype != 1) || (fromtype != 1 && totype == 1)) {
			if (planet == null) return false;

			var cotl:SpaceCotl=EM.HS.GetCotl(Server.Self.m_CotlId);
			if (cotl == null || (cotl.m_RecvInfo == false && cotl.m_RecvFull == false)) { return false; }

			//if (fromtype == 1) {
				if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) { EM.m_FormHint.Show(Common.Txt.WarningInDevNoExtract, Common.WarningHideTime); return false; }
			//}

			var fleetempty:Boolean = EM.m_FormFleetBar.FleetIsEmpty();

			if(!fleetempty) {
				if(!EM.OnOrbitCotl(Server.Self.m_CotlId)) { EM.m_FormHint.Show(Common.Txt.WarningItemFar,Common.WarningHideTime); return false; }
			}

			if (planet.m_Owner == 0) {
				var own:uint = EM.PlanetOwnerReal(planet);
				if (own != 0 && own != m_Owner) ctrl = false;
				else if (!own) {
					for (i = 0; i < Common.ShipOnPlanetMax; i++) {
						ship = planet.m_Ship[i];
						if (ship.m_Type == Common.ShipTypeNone) continue;
						if ((ship.m_Flag & Common.ShipFlagBuild) != 0) continue;
						if (ship.m_Owner != m_Owner) continue;
						break;
					}
					if (i >= Common.ShipOnPlanetMax) ctrl = false;
				}
			} else if (planet.m_Owner != m_Owner) ctrl = false;

			if (EM.IsBattleIgnoreNeutral(planet, m_Owner, Common.RaceNone, false)) { EM.m_FormHint.Show(Common.Txt.WarningItemMoveBattle, Common.WarningHideTime); return false; }
			
			if (!ctrl && fromtype==1 && totype==2) {
				if (EM.ExistFriendShip(planet, m_Owner, Common.RaceNone, false, 0) && !EM.ExistEnemyShip(planet, m_Owner, Common.RaceNone, false, 0, true)) {
					sack = true;
				}
			}
			if (!ctrl && !sack) return false;

			break;
		}

		if (fromtype == 2 && totype == 1 && toslot < 0) {
			while(true) {
				if (fromslot<0 || fromslot>=Common.FleetItemCnt) break;
				fi = EM.m_FormFleetItem.m_FleetItem[fromslot];
				if (fi.m_Type == 0) break;
				if (fi.m_Cnt <= 0) break;

				var flagfornewslot:uint = 0;
				if (fi.m_Type == Common.ItemTypeModule) flagfornewslot = PlanetItem.PlanetItemFlagNoMove;
				cnt = EM.PlanetItemAdd(m_Owner, planet, fi.m_Type, fi.m_Cnt,false,false,false,flagfornewslot);
				if (cnt <= 0) break;

				fi.m_Cnt -= cnt;
				if (fi.m_Cnt <= 0) {
					fi.m_Type = 0;
					fi.m_Cnt = 0;
					fi.m_Broken = 0;
				}
				
				EM.m_FormPlanet.Update();
				EM.m_FormFleetItem.Update();
				return true;
			}
			return false;

		} else if (fromtype == 1 && totype == 2 && toslot < 0) {
			while (true) {
				if (planet == null) return false;
				if (fromslot<0 || fromslot>=Planet.PlanetItemCnt) return false;
				pi = planet.m_Item[fromslot];
				if (pi.m_Type == 0) break;
				if (pi.m_Cnt <= 0) break;
				
				if(!EM.CanTransfer(m_Owner,pi.m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime); return false; }
				
				if (pi.m_Type == Common.ItemTypeMoney) {
					cnt = pi.m_Cnt;
					EM.m_FormFleetBar.m_FleetMoney += cnt;
				} else {
					cnt = EM.m_FormFleetBar.FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, pi.m_Type, pi.m_Cnt, false, false);
					if (cnt <= 0) break;
				}

				pi.m_Cnt -= cnt;
				if (pi.m_Cnt <= 0 && pi.m_Complete==0 && ((pi.m_Flag == 0) || (pi.m_Type==Common.ItemTypeModule && pi.m_Flag==PlanetItem.PlanetItemFlagNoMove))) {
					pi.m_Cnt = 0;
					pi.m_Owner = 0;
					pi.m_Complete = 0;
					pi.m_Broken = 0;
					pi.m_Flag = 0;
					pi.m_Type = 0;
				}

				EM.m_FormPlanet.Update();
				EM.m_FormFleetItem.Update();
				EM.m_FormInfoBar.Update();
				return true;
			}
			return false;
		}
		
		var storage:int;

		var from_item_type:uint = 0;
		var from_item_cnt:int = 0;
		var from_item_complete:int = 0;
		var from_item_broken:int = 0;
		var from_item_flag:uint = 0;
		var from_mul:int = 1;
		var from_owner:uint = 0;

		var to_item_type:uint = 0;
		var to_item_cnt:int = 0;
		var to_item_complete:int = 0;
		var to_item_broken:int = 0;
		var to_item_flag:uint = 0;
		var to_mul:int = 1;
		var to_owner:uint = 0;

		if (fromtype == 1) {
			if (planet == null) return false;
			if (fromslot<0 || fromslot>Planet.PlanetItemCnt) return false;
			pi = planet.m_Item[fromslot];
			from_item_type = pi.m_Type;
			from_item_cnt = pi.m_Cnt;
			from_item_complete = pi.m_Complete;
			from_item_broken = pi.m_Broken;
			from_item_flag = pi.m_Flag;
			storage = planet.PlanetItemMax();
			from_mul = Common.StackMax(fromslot, storage, 1);
			from_owner = pi.m_Owner;

		} else if (fromtype == 2) {
			if (fromslot<0 || fromslot>=Common.FleetItemCnt) return false;
			fi = EM.m_FormFleetItem.m_FleetItem[fromslot];
			from_item_type = fi.m_Type;
			from_item_cnt = fi.m_Cnt;
			from_item_broken = fi.m_Broken;
			//if (fromslot < 8) from_mul = Common.FleetFormationCargoMul[EM.m_FormFleetBar.m_Formation & 7];
			if (fromslot < 8) from_mul = Common.FleetHoldCargoMulByLvl[(EM.m_FormFleetBar.m_HoldLvl & 0xf0) >> 4];
			from_owner = m_Owner;
			
		} else if (fromtype == 9) {
			if (fromslot<0 || fromslot>=Common.FleetSlotMax) return false;
			fs = EM.m_FormFleetBar.m_FleetSlot[fromslot];
			if (fs.m_Type == Common.ShipTypeNone) return false;
			from_item_type = fs.m_ItemType;
			from_item_cnt = fs.m_ItemCnt;
			from_owner = m_Owner;

		} else return false;

		if (totype == 1) {
			if (planet == null) return false;
			if (toslot<0 || toslot>Planet.PlanetItemCnt) return false;
			storage = planet.PlanetItemMax();
			if (toslot > storage) return false;
			pi = planet.m_Item[toslot];
			to_item_type = pi.m_Type;
			to_item_cnt = pi.m_Cnt;
			to_item_complete = pi.m_Complete;
			to_item_broken = pi.m_Broken;
			to_item_flag = pi.m_Flag;
			to_mul = Common.StackMax(toslot, storage, 1);
			to_owner = pi.m_Owner;

		} else if(totype==2) {
			if (toslot<0 || toslot>=Common.FleetItemCnt) return false;
			fi = EM.m_FormFleetItem.m_FleetItem[toslot];
			to_item_type = fi.m_Type;
			to_item_cnt = fi.m_Cnt;
			to_item_broken = fi.m_Broken;
			if (toslot < 8) {
				//to_mul = Common.FleetFormationCargoMul[EM.m_FormFleetBar.m_Formation & 7];
				to_mul = Common.FleetHoldCargoMulByLvl[(EM.m_FormFleetBar.m_HoldLvl & 0xf0) >> 4];
				if (to_mul <= 1) return false; // Не транспортный флот
			}
			if (toslot >= (Common.FleetHoldRowByLvl[EM.m_FormFleetBar.m_HoldLvl & 0x0f] * 8)) return false;
			to_owner = m_Owner;
			
		} else if (totype == 9) {
			if (toslot<0 || toslot>=Common.FleetSlotMax) return false;
			fs = EM.m_FormFleetBar.m_FleetSlot[toslot];
			if (fs.m_Type == Common.ShipTypeNone) return false;
			
			to_item_type = fs.m_ItemType;
			to_item_cnt = fs.m_ItemCnt;
			to_owner = m_Owner;

		} else return false;

		if (from_item_type == 0) return false;

		var fromzero:Boolean = (fromtype == 1) && (totype != 1) && (from_item_complete==0) && (!(from_item_flag == 0 || (from_item_type == Common.ItemTypeModule && from_item_flag == PlanetItem.PlanetItemFlagNoMove)));
		
		var idesc:Item = UserList.Self.GetItem(from_item_type & 0xffff);
		if (idesc == null) return false;

		if (to_item_type != 0 && from_item_type != to_item_type) { // Обмен разных итемов
            if ((fromtype != 1) != (totype != 1)) {
                if (!EM.CanTransfer(from_owner, to_owner)) { EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime); return false; }
                if (!EM.CanTransfer(to_owner, from_owner)) { EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime); return false; }
            }

			if (from_item_cnt > idesc.m_StackMax * to_mul) { EM.m_FormHint.Show(Common.Txt.WarningItemMoveHoldOverload,Common.WarningHideTime); return false; }

			var idesc2:Item = UserList.Self.GetItem(to_item_type & 0xffff);
			if (idesc2 == null) return false;
			if (to_item_cnt > idesc2.m_StackMax * from_mul) { EM.m_FormHint.Show(Common.Txt.WarningItemMoveHoldOverload,Common.WarningHideTime); return false; }

			vdw = from_item_type; from_item_type = to_item_type; to_item_type = vdw;
			vin = from_item_cnt; from_item_cnt = to_item_cnt; to_item_cnt = vin;
			vin = from_item_complete; from_item_complete = to_item_complete; to_item_complete = vin;
			vin = from_item_broken; from_item_broken = to_item_broken; to_item_broken = vin;
			vdw = from_item_flag; from_item_flag = to_item_flag; to_item_flag = vdw;
			vdw = from_owner; from_owner = to_owner; to_owner = vdw;
			
		} else if (to_item_type == 0 && cnt == 0 && from_item_cnt <= idesc.m_StackMax * to_mul) { // Полность перемещаем в пустой слот
            if (totype != 1 && fromtype == 1) {
                if(!EM.CanTransfer(to_owner,from_owner)) { EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime); return false; }
            }

            if(fromzero) {
                to_item_type = from_item_type;
                to_item_cnt = from_item_cnt;
                to_item_complete = 0;
                to_item_broken = from_item_broken;
                to_item_flag = 0;
				to_owner = from_owner;

                from_item_cnt=0;
                from_item_broken=0;
            } else {
				to_item_type = from_item_type;
				to_item_cnt = from_item_cnt;
				to_item_complete = from_item_complete;
				to_item_broken = from_item_broken;
				to_item_flag = from_item_flag;
				to_owner = from_owner;

				from_item_type=0;
				from_item_cnt=0;
				from_item_complete=0;
				from_item_broken=0;
				from_item_flag = 0;
				from_owner = 0;
			}
			if (fromtype != 1 && totype == 1 && to_item_type == Common.ItemTypeModule) to_item_flag |= PlanetItem.PlanetItemFlagNoMove;

		} else if (to_item_type == 0) { // Частично перемещаем в пустой слот
			if (cnt <= 0) cnt = from_item_cnt;
			if (cnt > from_item_cnt) cnt = from_item_cnt;
			if (cnt > idesc.m_StackMax * to_mul) cnt = idesc.m_StackMax * to_mul;
			if (cnt <= 0) return false;
			
            if(totype!=1 && fromtype==1) {
                if (!EM.CanTransfer(to_owner, from_owner)) { EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime); return false; }
            }
			
			to_item_type = from_item_type;
			to_item_cnt = cnt;
			to_item_complete = 0;
			to_item_broken = from_item_broken;
			to_item_flag = 0;
			to_owner=from_owner;

			from_item_cnt-=cnt;
			from_item_broken = 0;
			
			if (fromtype != 1 && totype == 1 && to_item_type == Common.ItemTypeModule) to_item_flag |= PlanetItem.PlanetItemFlagNoMove;

		} else if (to_item_type != 0) { // Полностью перемещаем в занятый слот
			if (from_item_type != to_item_type) return false;
			if (cnt == 0) cnt = from_item_cnt;
			if (cnt > from_item_cnt) cnt = from_item_cnt;
			if (cnt <= 0) return false;

			if ((to_item_cnt + cnt) > idesc.m_StackMax * to_mul) cnt = idesc.m_StackMax * to_mul - to_item_cnt;
			if (cnt <= 0) return false;

            if(!EM.CanTransfer(to_owner,from_owner)) { EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime); return false; }

            if(!to_owner) to_owner=from_owner;

			to_item_cnt += cnt;
			from_item_cnt -= cnt;

			if (from_item_cnt <= 0) {
                if(fromzero) {
                    to_item_broken += from_item_broken;
                    from_item_broken=0;
                } else {
					to_item_complete += from_item_complete;
					to_item_broken += from_item_broken;

					from_item_type=0;
					from_item_cnt=0;
					from_item_complete=0;
					from_item_broken=0;
					from_item_flag = 0;
					from_owner = 0;
				}
			}
		} else return false;
		
		if (fromtype == 9 && from_item_type != 0) {
			fs = EM.m_FormFleetBar.m_FleetSlot[fromslot];
			if(!Common.ItemCanOnShip(from_item_type,fs.m_Type)) return false;
		}
		
		if (totype == 9 && to_item_type != 0) {
			fs = EM.m_FormFleetBar.m_FleetSlot[toslot];
			if(!Common.ItemCanOnShip(to_item_type,fs.m_Type)) return false;
		}

		if (fromtype == 1) {
			pi = planet.m_Item[fromslot];
			pi.m_Type = from_item_type;
			pi.m_Cnt = from_item_cnt;
			pi.m_Complete = from_item_complete;
			pi.m_Broken = from_item_broken;
			pi.m_Flag = from_item_flag;
			pi.m_Owner = from_owner;
			
		} else if (fromtype == 2) {
			fi = EM.m_FormFleetItem.m_FleetItem[fromslot];
			fi.m_Type = from_item_type;
			fi.m_Cnt = from_item_cnt;
			fi.m_Broken = from_item_broken;

		} else if (fromtype == 9) {
			fs = EM.m_FormFleetBar.m_FleetSlot[fromslot];
			fs.m_ItemType = from_item_type;
			fs.m_ItemCnt = from_item_cnt;
		}

		if (totype == 1) {
			pi = planet.m_Item[toslot];
			pi.m_Type = to_item_type;
			pi.m_Cnt = to_item_cnt;
			pi.m_Complete = to_item_complete;
			pi.m_Broken = to_item_broken;
			pi.m_Flag = to_item_flag;
			pi.m_Owner = to_owner;

		} else if(totype==2) {
			fi = EM.m_FormFleetItem.m_FleetItem[toslot];
			fi.m_Type = to_item_type;
			fi.m_Cnt = to_item_cnt;
			fi.m_Broken = to_item_broken;

		} else if (totype == 9) {
			fs = EM.m_FormFleetBar.m_FleetSlot[toslot];
			fs.m_ItemType = to_item_type;
			fs.m_ItemCnt = to_item_cnt;
			
		} else return false;

		EM.m_FormPlanet.Update();
		EM.m_FormFleetItem.Update();
		EM.m_FormFleetBar.Update();

		return true;
	}

	public function ProcessActionPlanetItemOp():Boolean
	{
		if (EM.IsEdit() && (EM.CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0) return false;
		
		var i:int,u:int;
		var ship:Ship;
		var sec:Sector = EM.GetSector(m_SectorX, m_SectorY);
		if (sec == null) return false;
		if (m_PlanetNum < 0 || m_PlanetNum >= sec.m_Planet.length) return false;
		var planet:Planet = sec.m_Planet[m_PlanetNum];

		var slot:int = m_Id;
		if (slot<0 || slot>=Planet.PlanetItemCnt) return false;

		var val:uint = m_Cnt;
		
		if(!EM.IsEdit()) {
			if (planet.m_Owner == 0) {
				for (i = 0; i < Common.ShipOnPlanetMax; i++) {
					ship = planet.m_Ship[i];
					if (ship.m_Type != Common.ShipTypeServiceBase) continue;
					if ((ship.m_Flag & Common.ShipFlagBuild) != 0) continue;
					if (ship.m_Owner != m_Owner) continue;
					break;
				}
				if (i >= Common.ShipOnPlanetMax) return false;
			} else if (planet.m_Owner != m_Owner) return false;
			if (EM.IsBattleIgnoreNeutral(planet, m_Owner, Common.RaceNone, false)) { EM.m_FormHint.Show(Common.Txt.WarningOpBattle, Common.WarningHideTime); return false; }
		}

		if (m_Kind == 1) {
			if (planet.m_Item[slot].m_Type == 0) return false;
			if ((planet.m_Item[slot].m_Flag & PlanetItem.PlanetItemFlagShowCnt) == 0) planet.m_Item[slot].m_Flag |= PlanetItem.PlanetItemFlagShowCnt;
			else planet.m_Item[slot].m_Flag &= ~PlanetItem.PlanetItemFlagShowCnt;

			EM.m_FormPlanet.Update();
			return true;

		} else if (m_Kind == 6) {
			if (planet.m_Item[slot].m_Type == 0) return false;
			if ((planet.m_Item[slot].m_Flag & PlanetItem.PlanetItemFlagNoMove) == 0) planet.m_Item[slot].m_Flag |= PlanetItem.PlanetItemFlagNoMove;
			else planet.m_Item[slot].m_Flag &= ~PlanetItem.PlanetItemFlagNoMove;

			EM.m_FormPlanet.Update();
			return true;

		} else if (m_Kind == 2) {
			planet.m_Item[slot].m_Type = 0;
			planet.m_Item[slot].m_Cnt = 0;
			planet.m_Item[slot].m_Complete = 0;
			planet.m_Item[slot].m_Broken = 0;
			planet.m_Item[slot].m_Flag = 0;

			EM.m_FormPlanet.Update();
			return true;

		} else if (m_Kind == 3) {
			if (planet.m_Item[slot].m_Type == 0) return false;

			if ((planet.m_Item[slot].m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) {
				if (EM.CalcItemDifficult(planet,planet.m_Item[slot].m_Type) <= 0) return false;
				planet.m_Item[slot].m_Flag |= PlanetItem.PlanetItemFlagBuild;
			}
			else planet.m_Item[slot].m_Flag &= ~PlanetItem.PlanetItemFlagBuild;

			EM.m_FormPlanet.Update();
			return true;

		} else if (m_Kind == 4) {
			if (planet.m_Item[slot].m_Type != 0) return false;
			if (slot >= Planet.PlanetItemCnt) return false;
			if (slot>=planet.PlanetItemMax()) return false;

//			var item:Item = UserList.Self.GetItem(val);
//			if (item == null) return;

			planet.m_Item[slot].m_Type = val;
			planet.m_Item[slot].m_Cnt = 0;
			planet.m_Item[slot].m_Complete = 0;
			planet.m_Item[slot].m_Broken = 0;
			planet.m_Item[slot].m_Flag = 0;

			EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 5) {
			if (planet.m_Item[slot].m_Type == 0) return false;
			if (planet.m_Item[slot].m_Cnt > 0) return false;
			//if ((planet.m_Item[slot].m_Flag & PlanetItem.PlanetItemFlagBuild) != 0) return false;

			var idesc:Item = UserList.Self.GetItem(planet.m_Item[slot].m_Type & 0xffff);
			if (idesc == null) return false;
			if (val<4 || val>=12) return false;
			if (idesc.m_BonusType[val] == 0) return false;

			var bl:Vector.<uint> = new Vector.<uint>(4, true);
			var blcnt:int = 0;
			for (i = 0; i < 4;i++) {
				bl[blcnt] = ((planet.m_Item[slot].m_Type >> (16 + i * 4)) & 15);
				blcnt++;
			}

			for (i = 0; i < blcnt; i++) {
				if (bl[i] == val) break;
			}
			if (i < 4) {
				bl[i] = 0;
			} else {
				// вырубаем у кого совпадает тип бонуса
				for (i = 0; i < blcnt; i++) {
					if (idesc.m_BonusType[bl[i]] == idesc.m_BonusType[val]) bl[i] = 0;
				}
				
				// Ищем пустое место под новый бонус
				for (i = 0; i < blcnt; i++) {
					if (bl[i] == 0) break;
				}
				if (i < blcnt) {
					bl[i] = val;
				} else {
					if (blcnt < 4) {
						bl[blcnt] = val;
						blcnt++;
					} else {
						// Пустое место не нашли. Находим меньший бонус и его замещаем на новый.
						u = -1;
						for (i = 0; i < blcnt; i++) {
							if ((u < 0) || (idesc.m_BonusVal[bl[i]] < idesc.m_BonusVal[bl[u]])) {
								u = i;
							}
						}
						if (u < 0) return false;
						bl[u] = val;
					}
				}
			}

			// Оптимизируем и сохраняем
			for (i = blcnt - 1; i >= 0; i--) {
				if (bl[i] == 0) {
					for (u = i; u < blcnt - 1; u++) bl[u] = bl[u + 1];
					blcnt--;
				}
			}
			for (i = 0; i < (blcnt - 1); i++) {
				for (u = i + 1; u < blcnt; u++) {
					if (bl[i] > bl[u]) {
						var swp:uint = bl[i]; bl[i] = bl[u]; bl[u] = swp;
					}
				}
			}
			planet.m_Item[slot].m_Type = planet.m_Item[slot].m_Type & 0xffff;
			for (i = 0; i < blcnt; i++) {
				planet.m_Item[slot].m_Type |= bl[i] << (16 + i * 4);
			}

			planet.m_Item[slot].m_Flag &= ~PlanetItem.PlanetItemFlagBuild;

			EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 7) {
			if ((!EM.m_EmpireEdit) && (!EM.IsEdit())) return false;
			if (planet.m_Item[slot].m_Type == 0) return false;

			planet.m_Item[slot].m_Cnt = m_Cnt;

			EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 8) {
			if (planet.m_Item[slot].m_Type == 0) return false;
			if ((planet.m_Item[slot].m_Flag & PlanetItem.PlanetItemFlagToPortal) == 0) planet.m_Item[slot].m_Flag |= PlanetItem.PlanetItemFlagToPortal;
			else planet.m_Item[slot].m_Flag &= ~PlanetItem.PlanetItemFlagToPortal;

			EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 9) {
			var pi:PlanetItem = planet.m_Item[slot];
			if (pi.m_Type == 0) return false;
			if (pi.m_Cnt <= 0) return false;
			
			var cm:int;
			var cmax:int = EM.DirValE(m_Owner, Common.DirTransportCargo);
			
			var score:int, bscore:int;
			
			var transferon:Boolean = true;
			u = -1;
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i];
				if(ship.m_Type!=Common.ShipTypeTransport) continue;
				if(ship.m_Flag & Common.ShipFlagBuild) continue;
				if (ship.m_ArrivalTime > EM.m_ServerCalcTime) continue;
				
				if (!EM.CanTransfer(ship.m_Owner, pi.m_Owner)) { transferon = false; continue; }
				
				cm = cmax;
				if (ship.m_Owner != m_Owner) {
					cm = EM.DirValE(ship.m_Owner, Common.DirTransportCargo);
				}

				score=0;

				if(ship.m_CargoType==pi.m_Type && ship.m_CargoCnt<(cm*ship.m_Cnt)) score=4;
				else if(!ship.m_CargoType) score=2;
				else continue;
				
//@				if ((ship.m_Flag & (Common.ShipFlagAutoLogic | Common.ShipFlagAutoReturn)) == 0) score |= 1;
				if (ship.m_Link) score |= 1;
				
				if(ship.m_Owner==planet.m_Owner) score|=0x40000000;
				else if(EM.IsFriendEx(planet,planet.m_Owner,planet.m_Race,ship.m_Owner,ship.m_Race)) score|=0x20000000;
				else continue;

				if(u<0 || score>bscore) {
					bscore=score;
					u=i;
				}
			}
			if (u < 0) {
				if(!transferon) EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime);
				return false;
			}
			
			ship = planet.m_Ship[u];
			
			cm=cmax;
			if (ship.m_Owner != m_Owner) {
				cm = EM.DirValE(ship.m_Owner, Common.DirTransportCargo);
			}
			
			var cnt:int=0;
			if(ship.m_CargoType==pi.m_Type) {
				cnt=Math.min(pi.m_Cnt,cm*ship.m_Cnt-ship.m_CargoCnt);
			} else {
				ship.m_CargoType=pi.m_Type;
				ship.m_CargoCnt=0;
				cnt=Math.min(pi.m_Cnt,cm*ship.m_Cnt);
			}
			if(cnt>0) {
				ship.m_CargoCnt+=cnt;
				pi.m_Cnt -= cnt;
			}

			while(pi.m_Cnt<=0) {
				if(pi.m_Flag==0) {}
				else if(pi.m_Type==Common.ItemTypeModule && pi.m_Flag==PlanetItem.PlanetItemFlagNoMove) {}
				else break;

				pi.m_Broken = 0;
				pi.m_Cnt = 0;
				pi.m_Complete = 0;
				pi.m_Flag = 0;
				pi.m_Type = 0;
				break;
			}

			EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 10) {
			if (EM.m_CotlType == Common.CotlTypeUser || (EM.m_CotlType == Common.CotlTypeRich && EM.IsEdit())) { }
			else return false;
			if (planet.m_Item[slot].m_Type == 0) return false;
			if ((planet.m_Item[slot].m_Flag & PlanetItem.PlanetItemFlagImport) == 0) planet.m_Item[slot].m_Flag |= PlanetItem.PlanetItemFlagImport;
			else planet.m_Item[slot].m_Flag &= ~PlanetItem.PlanetItemFlagImport;

			EM.m_FormPlanet.Update();
			return true;
			
		} else if (m_Kind == 11) {
			if (EM.m_CotlType == Common.CotlTypeUser || (EM.m_CotlType == Common.CotlTypeRich && EM.IsEdit())) { }
			else return false;
			if (planet.m_Item[slot].m_Type == 0) return false;
			if ((planet.m_Item[slot].m_Flag & PlanetItem.PlanetItemFlagExport) == 0) planet.m_Item[slot].m_Flag |= PlanetItem.PlanetItemFlagExport;
			else planet.m_Item[slot].m_Flag &= ~PlanetItem.PlanetItemFlagExport;

			EM.m_FormPlanet.Update();
			return true;
		}
		
		return false;
	}

	public function ProcessActionBuildingLvlBuy():Boolean
	{
		var user:User = UserList.Self.GetUser(m_Id);
		if (user == null) return false;

		if (m_Kind<=0 || m_Kind>=Common.BuildingTypeCnt) return false;

		if (user.m_BuildingLvl[m_Kind] >= Common.BuildingLvlCnt) return false;

		if(user.m_Id==Server.Self.m_UserId) {
			var cost:int = Common.BuildingTechLvlCost[m_Kind * Common.BuildingLvlCnt + (user.m_BuildingLvl[m_Kind])];
			if (cost > EM.m_FormFleetBar.m_FleetMoney) return false;
			
			EM.m_FormFleetBar.m_FleetMoney -= cost;
		}

		user.m_BuildingLvl[m_Kind]++;

		if(EM.m_FormConstruction.visible) { EM.m_FormConstruction.ListFill(); EM.m_FormConstruction.Update(); }

		return true;
	}
	
	public function ProcessActionFleetSpecial():Boolean
	{
		var user:User;
		var type:int = m_Kind;
		var val:uint = m_Id;
		
		if (type == 9) {
			user = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user == null) return false;
			
			var slot:int = val;
			
			if (EM.m_FormFleetItem.m_FleetItem[slot].m_Cnt <= 0) return false;

			if ((EM.m_FormFleetItem.m_FleetItem[slot].m_Type & 0xffff)==Common.ItemTypeTechnician) {
				if (user.m_IB1_Type != 0) {
//					user.m_IB1_Type = 0;
//					user.m_IB1_Date = 0;
					EM.m_FormHint.Show(Common.Txt.WarningNoMorePilot,Common.WarningHideTime);
					return false;
				} else {
					user.m_IB1_Type = EM.m_FormFleetItem.m_FleetItem[slot].m_Type;
					user.m_IB1_Date = EM.GetServerCalcTime() + 2 * 60 * 60 * 1000;
					user.m_IB1_Type |= 0x8000;
				}
			} else if((EM.m_FormFleetItem.m_FleetItem[slot].m_Type & 0xffff)==Common.ItemTypeNavigator) {
				if (user.m_IB2_Type != 0) {
//					user.m_IB2_Type = 0;
//					user.m_IB2_Date = 0;
					EM.m_FormHint.Show(Common.Txt.WarningNoMorePilot,Common.WarningHideTime);
					return false;
				} else {
					user.m_IB2_Type = EM.m_FormFleetItem.m_FleetItem[slot].m_Type;
					user.m_IB2_Date = EM.GetServerCalcTime() + 2 * 60 * 60 * 1000;
					user.m_IB2_Type |= 0x8000;
				}

			} else return false;
			
			EM.m_FormFleetItem.m_FleetItem[slot].m_Cnt--;
			if (EM.m_FormFleetItem.m_FleetItem[slot].m_Cnt <= 0) {
				EM.m_FormFleetItem.m_FleetItem[slot].m_Cnt = 0;
				EM.m_FormFleetItem.m_FleetItem[slot].m_Type = 0;
				EM.m_FormFleetItem.m_FleetItem[slot].m_Broken = 0;
			}
			
			EM.m_FormFleetItem.Update();
			EM.m_FormFleetBar.Update();
			return true;
			
		} else if (type == 10) {
			user = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user == null) return false;

			if (val == 1) {
				if (user.m_IB1_Type == 0) return false;
				if ((user.m_IB1_Type & 0x8000) != 0) {
					user.m_IB1_Type &= ~0x8000;
                    if (EM.GetServerCalcTime() >= user.m_IB1_Date) user.m_IB1_Date = 0;
					else user.m_IB1_Date -= EM.GetServerCalcTime();
				} else {
					user.m_IB1_Type |= 0x8000;
					user.m_IB1_Date += EM.GetServerCalcTime();
				}

			} else {
				if (user.m_IB2_Type == 0) return false;
				if ((user.m_IB2_Type & 0x8000) != 0) {
					user.m_IB2_Type &= ~0x8000;
                    if (EM.GetServerCalcTime() >= user.m_IB2_Date) user.m_IB2_Date = 0;
					else user.m_IB2_Date -= EM.GetServerCalcTime();
				} else {
					user.m_IB2_Type |= 0x8000;
					user.m_IB2_Date += EM.GetServerCalcTime();
				}
			}

			EM.m_FormFleetBar.Update();
			return true;
		}
        
		return false;
	}
	
//	public function ProcessActionCombat():Boolean
//	{
//		if (m_Kind == 1) {
//			return true;
//		} else if (m_Kind == 2) {
//			return true;
//		} else if (m_Kind == 3) {
//			return true;
//		} else if (m_Kind == 4) {
//			if(EM.m_FormCombat.m_CombatAtkUser[0].m_Id==m_Owner) {
//				EM.m_FormCombat.m_CombatFlag|=FormCombat.FlagAtkReady;
//			}
//			if(EM.m_FormCombat.m_CombatDefUser[0].m_Id==m_Owner) {
//				EM.m_FormCombat.m_CombatFlag|=FormCombat.FlagDefReady;
//			}
//			if (EM.m_FormCombat.visible) EM.m_FormCombat.Update();
//			return true;
//		} else if (m_Kind == 5) {
//			return true;
//		} else if (m_Kind == 6) {
//			return true;
//		} else 
//		if (m_Kind == 7) {
//			return true;
//		} else if (m_Kind == 8) {
//			return true;
//		} else if (m_Kind == 9) {
//			return true;
//		} else if (m_Kind == 10) {
//			return true;
//		}
//		
//		return false;
//	}

	public function ActionPathMove(sectorx:int, sectory:int, planetnum:int, shipnum0:int, shipnum1:int, shipnum2:int, shipnum3:int, shipnum4:int, shipnum5:int, shipnum6:int, group:uint, speed:int, path:Array):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypePathMove;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum0;
		m_Id=group;
		m_Path=path;
		m_Kind = speed;
		
		m_Tmp0 = shipnum0;
		m_Tmp1 = shipnum1;
		m_Tmp2 = shipnum2;
		m_Tmp3 = shipnum3;
		m_Tmp4 = shipnum4;
		m_Tmp5 = shipnum5;
		m_Tmp6 = shipnum6;
	}
	
	public function ActionCancelAutoMove(id:uint,sectorx:int,sectory:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeCancelAutoMove;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_Id=id;
	}

	public function ActionMove(sectorx:int,sectory:int,planetnum:int,shipnum:int, tgt_sectorx:int,tgt_sectory:int,tgt_planetnum:int,tgt_shipnum:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeMove;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_TargetSectorX=tgt_sectorx;
		m_TargetSectorY=tgt_sectory;
		m_TargetPlanetNum=tgt_planetnum;
		m_TargetNum=tgt_shipnum;
	}

	public function ActionCopy(id:uint, sectorx:int,sectory:int,planetnum:int,shipnum:int, tgt_sectorx:int,tgt_sectory:int,tgt_planetnum:int,tgt_shipnum:int,kind:int=0):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Id=id;
		m_Type=ActionTypeCopy;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_TargetSectorX=tgt_sectorx;
		m_TargetSectorY=tgt_sectory;
		m_TargetPlanetNum=tgt_planetnum;
		m_TargetNum=tgt_shipnum;
		m_Kind=kind;
	}

	public function ActionBuild(id:uint, sectorx:int, sectory:int, planetnum:int, shipnum:int, type:int, cnt:int, currency:int, buildforowner:uint):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeBuild;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		if(type==Common.ShipTypeNone) m_ShipNum=0;
		else m_ShipNum=shipnum;
		m_Kind=type;
		m_Cnt=cnt;
		m_Id=id;
		m_TargetNum = currency;
		m_TargetPlanetNum = buildforowner;
	}

	public function ActionPath(sectorx:int, sectory:int, planetnum:int, tgt_sectorx:int, tgt_sectory:int, tgt_planetnum:int, kind:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypePath;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_TargetSectorX=tgt_sectorx;
		m_TargetSectorY=tgt_sectory;
		m_TargetPlanetNum=tgt_planetnum;
		m_Kind=kind;
	}

	public function ActionSplit(sectorx:int,sectory:int,planetnum:int,shipnum:int,tonum:int,cnt:int,itcnt:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeSplit;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_TargetNum=tonum;
		m_Cnt=cnt;
		m_Kind=itcnt;
	}

	public function ActionMake(itemtype:int, cnt:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeMake;
		m_Kind=itemtype;
		m_Cnt=cnt;
	}

	public function ActionGive(sectorx:int,sectory:int,planetnum:int,shipnum:int,itemtype:int,cnt:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeGive;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_Kind=itemtype;
		m_Cnt=cnt;
	}

	public function ActionDestroy(type:int,sectorx:int,sectory:int,planetnum:int,shipnum:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeDestroy;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_Kind=type;
	}

	public function ActionCargo(sectorx:int,sectory:int,planetnum:int,shipnum:int, op:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeCargo;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_Kind=op;
	}

	public function ActionResChange(fromtype:int, totype:int, cnt:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeResChange;
		m_Kind=fromtype;
		m_Id=totype;
		m_Cnt=cnt;
	}

	public function ActionSpecial(type:int, sectorx:int,sectory:int,planetnum:int,shipnum:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeSpecial;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_Kind=type;
	}

	public function ActionResearch(tech:int, dir:int, owner:uint):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeResearch;
		m_Kind=tech;
		m_Id=owner;
		m_TargetNum=dir;
	}

	public function ActionTalent(forowner:uint, cptid:uint, talent:int, vec:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type = ActionTypeTalent;
		m_Tmp0 = forowner;
		m_Kind=talent;
		m_TargetNum=vec;
		m_Id=cptid;
	}

	public function ActionToHyperspace(sectorx:int, sectory:int, planetnum:int, shipnum:int, slot:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeToHyperspace;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_TargetNum=slot;
	}

	public function ActionFromHyperspace(id:uint, shiptype:int, sectorx:int, sectory:int, planetnum:int, shipnum:int, slot:int, cnt:int, itemcnt:int, module:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeFromHyperspace;
		m_SectorX=sectorx;
		m_SectorY=sectory;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_Id=id;
    	m_TargetNum=slot;
    	m_Cnt=cnt;
    	m_Kind=itemcnt;
    	m_TargetPlanetNum=shiptype;
		m_TargetSectorX=module;
	}

	public function ActionFleetFuel(valuechange:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type=ActionTypeFleetFuel;
    	m_Cnt=valuechange;
	}

	public function ActionConstruction(sectorx:int, sectory:int, planetnum:int, cell:int, kind:int, building:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner=Server.Self.m_UserId;

		m_Type = ActionTypeConstruction;
		m_SectorX = sectorx;
		m_SectorY = sectory;
		m_PlanetNum = planetnum;
		m_ShipNum = cell;
		m_Kind = kind;
		m_Id = building;
	}

	public function ActionItemMove(sectorx:int, sectory:int, planetnum:int, fromtype:int, fromslot:int, totype:int, toslot:int, cnt:int = 0):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner = Server.Self.m_UserId;

		m_Type = ActionTypeItemMove;

		m_SectorX = sectorx;
		m_SectorY = sectory;
		m_PlanetNum = planetnum;

		m_Kind = fromtype;
		m_Id = fromslot;
		m_TargetPlanetNum = totype;
		m_TargetNum = toslot;

		m_Cnt = cnt;
	}

	public function ActionPlanetItemOp(sectorx:int, sectory:int, planetnum:int, slot:int, kind:int, val:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner = Server.Self.m_UserId;

		m_Type = ActionTypePlanetItemOp;

		m_SectorX = sectorx;
		m_SectorY = sectory;
		m_PlanetNum = planetnum;

		m_Id = slot;
		m_Kind = kind;
		m_Cnt = val;
	}

	public function ActionBuildingLvlBuy(owner:uint, building_type:int):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner = Server.Self.m_UserId;

		m_Type = ActionTypeBuildingLvlBuy;

		m_Id = owner;
		m_Kind = building_type;
	}

	public function ActionFleetSpecial(type:int, val:uint):void
	{
		m_ServerTime=EM.m_ServerCalcTime;
		m_Owner = Server.Self.m_UserId;

		m_Type = ActionTypeFleetSpecial;
		
		m_Kind = type;
		m_Id = val;
	}

//	public function ActionCombat(type:int, id:uint = 0, val:uint = 0):void
//	{
//		m_ServerTime=EM.GetServerTime();
//		m_Owner = Server.Self.m_UserId;
//
//		m_Type = ActionTypeCombat;
//
//		m_Kind = type;
//		m_Id = id;
//		m_Cnt = val;
//	}
}

}
