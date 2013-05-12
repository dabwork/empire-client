// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base.*;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

public class SpaceShip extends SpaceEntity
{
	static public const gstShip1:uint = 1;

	static public const ForsageDistOn:Number = 4000.0;
	static public const ForsageDistOff:Number = 1000.0;
	static public const ForsageMinFactor:Number = 5.0;
	static public const ForsageMaxFactor:Number = 20.0;
	static public const RadiusToOrbitCotl:Number = 300.0;
	static public const RadiusToOrbitPlanet:Number = 400.0;

	static public const soNone:uint = 0;
	static public const soMove:uint = 1;
	static public const soOrbitCotl:uint = 2;
	static public const soOrbitPlanet:uint = 3;
	static public const soJump:uint = 4;
    static public const soDock:uint = 5;
	static public const soFollow:uint = 6;

	static public const PFlagForsagePrepare:uint = 1 << 0;  // Начальная фаза включения форсажа
	static public const PFlagForsageOn:uint = 1 << 1; // Форсаж включен
	static public const PFlagForsageDisable:uint = 1 << 2;
	static public const PFlagInOrbitCotl:uint = 1 << 3;
	static public const PFlagInOrbitPlanet:uint = 1 << 4;
	static public const PFlagInDock:uint = 1 << 5;
	static public const PFlagUndock:uint = 1 << 6;
    static public const PFlagToDock:uint = 1 << 7;
	static public const PFlagForsageClientReady:uint = 1 << 8;
    static public const PFlagStep0:uint = 1 << 15;
    static public const PFlagStep1:uint = 1 << 14;
    static public const PFlagStep2:uint = 1 << 13;
    static public const PFlagStep3:uint = 1 << 12;
    static public const PFlagStepMask:uint = PFlagStep0 | PFlagStep1 | PFlagStep2 | PFlagStep3;
    static public const PFlagPosMask:uint = PFlagInOrbitCotl | PFlagInOrbitPlanet | PFlagInDock | PFlagUndock | PFlagToDock;

	static public const PFlagEntityTypeShift:uint = 24;

	static public const StateLive:uint = 1 << 0;
	static public const StateDestroy:uint = 1 << 1;
	static public const StateBuild:uint = 1 << 2;
	
	public var m_Angle:Number = 0;		// курс		(rotate z)          matrix_roll*matrix_pitch*matrix_angle
	public var m_Pitch:Number = 0;		// тангаж	(rotate x)
	public var m_Roll:Number = 0;		// крен		(rotate y)

	public var m_PFlag:uint = 0;
	public var m_Forsage:Number = 1.0;
	public var m_PTimer:uint = 0;
	public var m_PId:uint = 0;
	public var m_PPrior:uint = 0;
	public var m_PDist:Number = 0;
//	public var m_OrbAngle:Number = 0.0;

	public var m_ServerZoneX:int = 0;
	public var m_ServerZoneY:int = 0;
	public var m_ServerPosX:Number = 0;
	public var m_ServerPosY:Number = 0;
	public var m_ServerPosZ:Number = 0;
	public var m_ServerAngle:Number = 0;
	public var m_ServerForsage:Number = 0;
	public var m_ServerPFlag:uint = 0;
	public var m_ServerPTimer:uint = 0;
	public var m_ServerPId:uint = 0;
	public var m_ServerPPrior:uint = 0;
	public var m_ServerPDist:Number = 0;

	public var m_ServerCorrectionDist:Number = 0;
	public var m_ServerCorrectionFactor:Number = 0;
	public var m_ServerCorrectionTakt:Number = 0;
	public var m_ClearSmooth:Boolean = true;

	public var m_Order:uint = 0;
	public var m_OrderTargetId:uint = 0;
	public var m_OrderTimer:uint = 0;
	public var m_OrderFlag:uint = 0;
	public var m_OrderDist:int = 0;
	public var m_OrderAngle:uint = 0; // 0..0xffff=0...2*PI

    public var m_DropId:uint = 0;
    public var m_DropProgressId:uint = 0;

    public var m_TakeId:uint = 0;
    public var m_TakeProgressId:uint = 0;

	public var m_TargetType:int = 0;	// =EntityType
	public var m_TargetId:uint = 0;

	public var m_PlaceX:Number = 0;		// Конечная точка куда стремится корабль.
	public var m_PlaceY:Number = 0;
	public var m_PlaceZ:Number = 0;

	public var m_DesX:Number = 0;		// Промежуточная точка куда летит корабль.
	public var m_DesY:Number = 0;
	public var m_DesZ:Number = 0;

	public var m_NewPosX:Number = 0;
	public var m_NewPosY:Number = 0;
	public var m_NewPosZ:Number = 0;

	public var m_ForceX:Number = 0;
	public var m_ForceY:Number = 0;
	public var m_ForceZ:Number = 0;

	public var m_PlaceAngle:Number = 0;

	public var m_SpeedReal:Number = 1600.0 * 0.1 * 0.01;
	public var m_SpeedRotate:Number = 40.0 * 0.01 * Space.ToRad;

	public var m_SpeedAngle:Number = 0;
	public var m_SpeedPitch:Number = 0;
	public var m_SpeedRoll:Number = 0;

	public var m_SpeedMoveX:Number = 0;
	public var m_SpeedMoveY:Number = 0;
	public var m_SpeedMoveZ:Number = 0;

	static public const ShipMaxPitch:Number = 15.0 * Space.ToRad;
	static public const ShipMaxRoll:Number = 30.0 * Space.ToRad;

	public var m_Owner:uint = 0;
	public var m_Union:uint = 0;
	
	public var m_HP:int = 0;
	public var m_Shield:int = 0;
	
	public var m_State:uint = 0;
	public var m_StateTime:uint = 0;
	
	public var m_NearDist:Number = 0;
	public var m_Radius:Number = 0;
	public var m_RadiusInner:Number = 0;
	public var m_RadiusOuter:Number = 0;
//	public var m_Mass:Number = 0;
//	public var m_Repulsion:Boolean = false;
	public var m_RepulsionFactor:Number = 0.0;
	public var m_RepulsionSkip:Vector.<SpaceEntity> = null;

	public var m_DockPosX:Number = 0;
	public var m_DockPosY:Number = 0;
	public var m_DockPosZ:Number = 0;
	public var m_DockDirX:Number = 0;
	public var m_DockDirY:Number = 0;
	public var m_DockDirZ:Number = 0;
	public var m_DockTime:Number = 0;
	public var m_DockLen:Number = 0;

	private static var m_TVec:Vector3D = new Vector3D();
	private static var m_TPos:Vector3D = new Vector3D();
	private static var m_TDir:Vector3D = new Vector3D();
	private static var m_TUp:Vector3D = new Vector3D();
	private static var m_TDockDir:Vector3D = new Vector3D();

	public function SpaceShip(sp:Space, hs:HyperspaceBase):void
	{
		super(sp,hs);
	}

	public function IsLive():Boolean
	{
		return (m_State & StateLive) != 0;
	}

    public function CanOrder():Boolean
	{
		if (!(m_State & StateLive)) return false;
		if (m_State & (StateDestroy | StateBuild)) return false;

		return true;
	}

	public function ForsageOff():void
	{
		if((m_PFlag & PFlagForsageOn) != 0) {
			m_PFlag &= ~PFlagForsageOn;
		}
		if ((m_PFlag & PFlagForsagePrepare) != 0) {
			m_PFlag &= ~PFlagForsagePrepare;
			m_PTimer = 0;
		}
	}

	public function ForsageAccess():Boolean
	{
		if ((m_PFlag & PFlagForsageDisable) != 0) return false;
		if(m_EntityType==SpaceEntity.TypeFleet) {
			if (SpaceFleet(this).m_Fuel <= 0) return false;
		}
		return true;
	}
	
	public function ForsageAccessDist(cnttakt:Number, speed:Number, forsagefactor:Number, test_obstacle:Boolean):Boolean
	{
		var dtx:Number = m_PosX - m_DesX;
		var dty:Number = m_PosY - m_DesY;
		var dtlen:Number = dtx * dtx + dty * dty;

		// s=u0*t+a*t^2*0.5
		var ftime:Number = (forsagefactor - 1.0) / (0.02 * cnttakt);
		var fa:Number = -(speed * cnttakt) * (0.02 * cnttakt);
		var fdistoff:Number = (forsagefactor * speed * cnttakt) * ftime + fa * ftime * ftime * 0.5;
		fdistoff += ForsageDistOff;

		if (dtlen < fdistoff * fdistoff) {
			return false;
		}

		if(!test_obstacle) return true;

		fdistoff *= 0.5;

		dtlen = Math.sqrt(dtlen);
		//if(dtlen<ForsageDistOff) return false;
		var t:Number = 1.0 / dtlen;
		dtx *= t; dty *= t; //dtz*=t;
		
		return true;
	}

	public function OrderNone():void
	{
		m_Order = soNone;
		m_OrderTargetId = 0;
		m_OrderTimer = 0;
		m_OrderFlag = 0;
		m_OrderDist = 0;
		m_OrderAngle = 0;
	}
	
	public function OrderMove(x:Number, y:Number, a:Number):void
	{
		m_Order = soMove;
		m_OrderTargetId = 0;
		m_OrderTimer = 0;
		m_OrderFlag = 0;
		m_OrderDist = 0;
		m_OrderAngle = 0;
		m_PlaceX = x;
		m_PlaceY = y;
		m_PlaceZ = 0.0;
		m_PlaceAngle = a;
//		if ((m_PFlag & PFlagInOrbitCotl) != 0) {
//			m_PFlag &= ~PFlagInOrbitCotl;
//			m_PId = 0;
//		}
	}

	public function OrderOrbitCotl(x:Number, y:Number, a:Number, id:uint):void
	{
		var slot:int = SP.FindEmptyOrbitPlace(SpaceEntity.TypeCotl, id);
		if (slot < 0) return;// { OrderNone(); return; }
		m_Order = soOrbitCotl;
		m_OrderTargetId = id;
		m_OrderTimer = 0;
		m_OrderFlag = slot << 16;
		m_OrderDist = 0;
		m_OrderAngle = 0;
		m_PlaceX = x;
		m_PlaceY = y;
		m_PlaceZ = 0.0;
		m_PlaceAngle = a;
	}

	public function OrderOrbitPlanet(x:Number, y:Number, a:Number, id:uint):void
	{
		var slot:int = SP.FindEmptyOrbitPlace(SpaceEntity.TypePlanet, id);
		if (slot < 0) return;// { OrderNone(); return; }
		m_Order = soOrbitPlanet;
		m_OrderTargetId = id;
		m_OrderTimer = 0;
		m_OrderFlag = slot << 16;
		m_OrderDist = 0;
		m_OrderAngle = 0;
		m_PlaceX = x;
		m_PlaceY = y;
		m_PlaceZ = 0.0;
		m_PlaceAngle = a;
	}

	public function OrderTarget(tgttype:int, tgtid:uint):void
	{
		if (tgttype == 0) {
			m_TargetType = 0;
			m_TargetId = 0;
		} else {
			m_TargetType = tgttype;
			m_TargetId = tgtid;
		}
	}
	
	public function OrderDock(entitytype:uint, id:uint, port:int, followdist:Number):void
	{
		m_Order = soDock;
		m_OrderTargetId = id;
		m_OrderFlag = (port << 16) | ((entitytype) << PFlagEntityTypeShift);
		m_OrderDist = followdist;
		m_OrderAngle = 0;
	}
	
	public function OrderFollow(entitytype:uint, targetid:uint, targetdist:int, angle:int):void
	{
		m_Order = soFollow;
		m_OrderTargetId = targetid;
		m_OrderFlag = ((entitytype) << PFlagEntityTypeShift);
		m_OrderDist = targetdist;
		m_OrderAngle = angle;
	}
	
	public function DockDir(port:uint, out:Vector3D):Number
	{
		out.x = 0;
		out.y = 0;
		out.z = 0;
		out.w = 0;
		
		if (m_EntityType == SpaceEntity.TypeShuttle) return 100.0;
		return 100.0;
	}
	
	public function TakeCorrect():Boolean
	{
		var i:int;
		var cl:SpaceContainer = null;
		var contid:uint = m_TakeId;
		var ardub:Array = new Array();
		while (contid) {
			if (ardub[contid] != undefined) return false;
			ardub[contid] = true;

			cl = SP.EntityFind(SpaceEntity.TypeContainer, contid) as SpaceContainer;
			if (!cl || cl.m_EntityType != SpaceEntity.TypeContainer) return false;

			contid = 0;
			if (cl.m_Take == null) return false;
			for (i = 0; i < SpaceContainer.TakeMax; i++) {
				if (cl.m_Take[i * 3 + 1] != m_Id) continue;
				if (cl.m_Take[i * 3 + 0] != m_EntityType) continue;

				contid = cl.m_Take[i * 3 + 2];
				break;
			}
			if (i >= SpaceContainer.TakeMax) return false;
		}
		if (cl && contid) return false;
		
		return true;
	}

	public function TakeAdd(cont:SpaceContainer, curtime:Number, contanm:Vector.<uint>):Boolean
	{
		var i:int;

		// Если уже подбираем этот контейнер то выходим
		if(cont.m_Take!=null) {
			for (i = 0; i < SpaceContainer.TakeMax; i++) {
				if (cont.m_Take[i * 3 + 1] != m_Id) continue;
				if (cont.m_Take[i * 3 + 0] != m_EntityType) continue;
				break;
			}
			if (i < SpaceContainer.TakeMax) return false;
		}

		// Ищем последний контейнер в списке
		var cl:SpaceContainer = null;
		var ct:int = -1;
		var contid:uint = m_TakeId;
		var ardub:Array = new Array();
		while (contid) {
			if (ardub[contid] != undefined) return false;
			ardub[contid] = true;

			if (contid == cont.m_Id) return false;
			cl = SP.EntityFind(SpaceEntity.TypeContainer, contid) as SpaceContainer;
			if (!cl || cl.m_EntityType != SpaceEntity.TypeContainer) return false;

			contid = 0;
			if (cl.m_Take == null) return false;
			for (i = 0; i < SpaceContainer.TakeMax; i++) {
				ct = i;
				if (cl.m_Take[i * 3 + 1] != m_Id) continue;
				if (cl.m_Take[i * 3 + 0] != m_EntityType) continue;

				contid = cl.m_Take[i * 3 + 2];
				break;
			}
			if (i >= SpaceContainer.TakeMax) return false;// { cl = null; break; }
		}
		if (cl && contid) return false;
		
		// Находим пустое место под указатель
		cont.TakePrepare();
		for (i = 0; i < SpaceContainer.TakeMax; i++) {
			if (!cont.m_Take[i * 3 + 1]) break;
		}
		if (i >= SpaceContainer.TakeMax) return false;

		// Сохраняем идентификаторы
		cont.m_Take[i * 3 + 2] = 0;
		cont.m_Take[i * 3 + 0] = m_EntityType;
		cont.m_Take[i * 3 + 1] = m_Id;

		cont.m_Anm++;
		cont.m_LoadAfterAnm = cont.m_Anm;
		cont.m_LoadAfterAnm_Timer = curtime;
		contanm.push(cont.m_Id);
		contanm.push(cont.m_Anm);

		if (cl) {
			cl.m_Take[ct * 3 + 2] = cont.m_Id;

			cl.m_Anm++;
			cl.m_LoadAfterAnm = cl.m_Anm;
			cl.m_LoadAfterAnm_Timer = curtime;
			contanm.push(cl.m_Id);
			contanm.push(cl.m_Anm);

			if (m_TakeProgressId == 0) {
				m_TakeProgressId=cont.m_Id;
			}
		} else {
			m_TakeId = cont.m_Id;
			m_TakeProgressId = cont.m_Id;
		}
		return true;
	}

	public function TakeDel(cont:SpaceContainer, curtime:Number, contanm:Vector.<uint>):Boolean
	{
		var i:int;

		// Если нет ссылки на шаттл то выходим
		if (cont.m_Take == null) return false;
		for (i = 0; i < SpaceContainer.TakeMax; i++) {
			if (cont.m_Take[i * 3 + 1] != m_Id) continue;
			if (cont.m_Take[i * 3 + 0] != m_EntityType) continue;
			break;
		}
		if (i >= SpaceContainer.TakeMax) return false;
		var findcur:int = i;
		
		// Ищем предыдущий
		var cl:SpaceContainer = null;
		var ct:int = -1;
		var contid:uint = m_TakeId;
		var ardub:Array = new Array();
		while (contid) {
			if (ardub[contid] != undefined) return false;
			ardub[contid] = true;

			if (contid == cont.m_Id) break;
			cl = SP.EntityFind(SpaceEntity.TypeContainer, contid) as SpaceContainer;
			if (!cl || cl.m_EntityType != SpaceEntity.TypeContainer) return false;

			contid = 0;
			if (cl.m_Take == null) return false;
			for (i = 0; i < SpaceContainer.TakeMax; i++) {
				ct = i;
				if (cl.m_Take[i * 3 + 1] != m_Id) continue;
				if (cl.m_Take[i * 3 + 0] != m_EntityType) continue;

				contid = cl.m_Take[i * 3 + 2];
				break;
			}
			if (i >= SpaceContainer.TakeMax) return false;
			if (contid == 0) return false;
		}

		// Удаляем ссылку у текущего контейнера
		i = findcur;
		var nextid:uint = cont.m_Take[i * 3 + 2];
		cont.m_Take[i * 3 + 0] = 0;
		cont.m_Take[i * 3 + 1] = 0;
		cont.m_Take[i * 3 + 2] = 0;

		cont.m_Anm++;
		cont.m_LoadAfterAnm = cont.m_Anm;
		cont.m_LoadAfterAnm_Timer = curtime;
		contanm.push(cont.m_Id);
		contanm.push(cont.m_Anm);

		// Предыдущий должен ссылаться на следующий
		if (cl) {
			cl.m_Anm++;
			cl.m_LoadAfterAnm = cl.m_Anm;
			cl.m_LoadAfterAnm_Timer = curtime;
			contanm.push(cl.m_Id);
			contanm.push(cl.m_Anm);

			cl.m_Take[ct * 3 + 2] = nextid;
			if ((m_TakeProgressId != 0) && (m_TakeProgressId == cont.m_Id)) m_TakeProgressId = nextid;
		} else {
			m_TakeId = nextid;
			if ((m_TakeProgressId != 0) && (m_TakeProgressId == cont.m_Id)) m_TakeProgressId = nextid;
		}
		
		return true;
	}

	public function CalcPar():void
	{
		if(m_EntityType==SpaceEntity.TypeShuttle) {
			m_NearDist = 500.0;
			m_Radius = 50.0;
		} else {
			m_NearDist = 300.0;
			m_Radius = 150.0;
		}
		m_RadiusInner = m_Radius * 0.9;
		m_RadiusOuter = m_Radius;
//		m_Mass = 100.0;
	}
	
	public function ExistDrop():Boolean
	{
		if (!m_DropProgressId) return false;
		if (!SP.EntityFind(SpaceEntity.TypeContainer, m_DropProgressId)) return false;
		return true;
	}

	public function ProcessOrder(cnttakt:Number):void
	{
		var angle:Number, angleto:Number, r:Number, v:Number, k:Number, dockdist:Number, d:Number, dd:Number;
		var i:int;
		var dw:uint;
		var et:uint,port:uint;
		var vdx:Number, vdy:Number, vdz:Number;
		var px:Number, py:Number, pz:Number;
		var ent:SpaceEntity;
		var cotl:SpaceCotl;
		var planet:SpacePlanet;
		var tgt_ship:SpaceShip;
		var cont:SpaceContainer;

		CalcPar();

		m_DesX = m_PlaceX;
		m_DesY = m_PlaceY;
		m_DesZ = m_PlaceZ;
//trace("PA", m_PlaceAngle);

		while ((m_PFlag & PFlagInOrbitCotl) != 0) {
			if (((m_Order == soOrbitCotl) && (m_PId != m_OrderTargetId)) || (m_Order != soOrbitCotl && m_Order != soNone && m_Order != soJump)) {
				m_PFlag &= ~PFlagInOrbitCotl;
				m_PId = 0;
				break;
			}
			ent = SP.EntityFind(SpaceEntity.TypeCotl, m_PId);
			if (ent == null) {
				m_DesZ = SpaceCotl.DefaultZ * 0.5;
				break;
			}
			cotl = ent as SpaceCotl;
			dw = (m_PFlag >> 16) & 255;

			r = Space.EmpireCotlSizeToRadius(cotl.m_CotlSize) + RadiusToOrbitCotl;
			angle = SP.ClacOrbitAngle(r, dw);
			r = SP.CalcOrbitRadius(r, dw);

			m_DesX = cotl.m_PosX + r * Math.sin(angle) + (cotl.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
			m_DesY = cotl.m_PosY + r * Math.cos(angle) + (cotl.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
			m_DesZ = cotl.m_PosZ * 0.5;
			
			m_PlaceAngle = BaseMath.AngleNorm(angle + (Space.pi * 0.5));
			break;
		}
		while ((m_PFlag & PFlagInOrbitPlanet) != 0) {
			if (((m_Order == soOrbitPlanet) && (m_PId != m_OrderTargetId)) || (m_Order != soOrbitPlanet && m_Order != soNone && m_Order != soJump)) {
				m_PFlag &= ~PFlagInOrbitPlanet;
				m_PId = 0;
				break;
			}
			ent = SP.EntityFind(SpaceEntity.TypePlanet, m_PId);
			if (ent == null) {
				m_DesZ = SpacePlanet.DefaultZ;
				break;
			}
			planet = ent as SpacePlanet;
			dw = (m_PFlag >> 16) & 255;

			r = planet.m_Radius + RadiusToOrbitPlanet;
			angle = SP.ClacOrbitAngle(r, dw);
			r = SP.CalcOrbitRadius(r, dw);

			m_DesX = planet.m_PosX + r * Math.sin(angle) + (planet.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
			m_DesY = planet.m_PosY + r * Math.cos(angle) + (planet.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
			m_DesZ = planet.m_PosZ;
//m_DesZ = 0;
//trace((EmpireMap.Self.m_CurTime).toString() + "\t" + EmpireMap.Self.m_ServerTime.toString() + "\t" + m_PosX.toString() + "\t" + m_PosY.toString() + "\t" + m_DesX.toString() + "\t" + m_DesY.toString() + "\t" + planet.m_PosX.toString() + "\t" + planet.m_PosY.toString() + "\t" + angle.toString() + "\t" + r.toString());
			
			m_PlaceAngle = BaseMath.AngleNorm(angle + (Space.pi * 0.5));
			break;
		}
//trace(this, m_EntityType, m_Id, m_PFlag);
		while (m_PFlag & PFlagUndock) {
			m_PTimer += cnttakt;
			if ((m_PTimer & 0xffff) >= (m_PTimer >> 16)) {
				m_PFlag &= ~(PFlagUndock | 0xffff0000);
				m_PId = 0;
				m_PDist = 0;
			} else {
				tgt_ship = SP.EntityFind(m_PFlag >> PFlagEntityTypeShift, m_PId) as SpaceShip;

				if(!tgt_ship || tgt_ship.m_EntityType != SpaceEntity.TypeFleet) {
					m_PFlag &= ~(PFlagUndock | 0xffff0000);
					m_PId = 0;
					m_PDist = 0;
					break;
				}
			}
			break;
		}
		while (m_PFlag & PFlagToDock) {
			if (!ExistDrop() && m_TakeProgressId == 0 && m_Order == soDock && m_PId == m_OrderTargetId && (m_PFlag & 0xff0000) == (m_OrderFlag & 0xff0000));
			else {
				m_PFlag &= ~(PFlagToDock|PFlagStepMask);
				m_PId = 0;
				break;
			}

			ent = SP.EntityFind(m_PFlag >> PFlagEntityTypeShift, m_PId);
			if (ent == null || ent.m_EntityType != SpaceEntity.TypeFleet) {
				//m_PFlag &= ~PFlagToDock;
				//m_PId = 0;
				break;
			}
			tgt_ship = ent as SpaceShip;
			if (!tgt_ship.IsLive()) {
				//m_PFlag &= ~PFlagToDock;
				//m_PId = 0;
				break;
			}
			
			// Выходим на крус
			if (m_PFlag & PFlagStep0) {
				dockdist = DockDir((m_PFlag >> 16) & 255, m_TVec);
				tgt_ship.DockCalcPos(0.0 - (m_RadiusOuter + tgt_ship.m_RadiusOuter + dockdist), m_TVec.x, m_TVec.y, m_TVec.z, (m_PFlag >> 16) & 255, false, m_TPos, null);
				m_DesX = m_TPos.x + (tgt_ship.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				m_DesY = m_TPos.y + (tgt_ship.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				m_DesZ = m_TPos.z;

				m_PlaceAngle = tgt_ship.m_Angle;

				px = m_PosX - m_DesX;
				py = m_PosY - m_DesY;
				pz = m_PosZ - m_DesZ;

				d = px * px + py * py + pz * pz;
				dd = m_RadiusOuter + dockdist * 0.3;
				if (d < dd * dd) {
					m_PFlag &= ~PFlagStep0;
					m_PFlag |= PFlagStep1;
					m_PTimer = 0;
				}
			}

			// Выходим на точку стыковки
			if (m_PFlag & PFlagStep1) {
				DockDir((m_PFlag >> 16) & 255, m_TVec);
				tgt_ship.DockCalcPos(0.0, m_TVec.x, m_TVec.y, m_TVec.z, (m_PFlag >> 16) & 255, false, m_TPos, m_TVec);
				m_PlaceAngle = m_TVec.x;
				m_DesX = m_TPos.x + (tgt_ship.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				m_DesY = m_TPos.y + (tgt_ship.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				m_DesZ = m_TPos.z;
			}

			// Стыкуемся
			if (m_PFlag & PFlagStep3) {
				m_PTimer += cnttakt;

				if ((m_PTimer & 0xffff) >= (m_PTimer >> 16)) {
					port = (m_PFlag >> 16) & 255;
					m_PFlag &= ~(SpaceShip.PFlagToDock | SpaceShip.PFlagStepMask);
					m_PFlag |= SpaceShip.PFlagInDock;
					m_PTimer = 0;
					//OrderNone();
				}
			}
			break;
		}
		while ((m_PFlag & PFlagInDock) != 0) {
			tgt_ship = SP.EntityFind(m_PFlag >> PFlagEntityTypeShift, m_PId) as SpaceShip;

			if (!tgt_ship || tgt_ship.m_EntityType != SpaceEntity.TypeFleet) {
				m_PFlag &= ~(PFlagInDock & 0xffff0000);
				m_PId = 0;
				m_PDist = 0;
				break;

			} else if (!(tgt_ship.m_State & SpaceShip.StateLive)) {
				m_PFlag &= ~PFlagInDock;
				m_PFlag |= PFlagUndock;
				m_PTimer = int(2.0 * tgt_ship.DockPathLen((m_PFlag >> 16) & 255, true) / (m_SpeedReal)) << 16;
				break;
				
			} else {
				DockDir((m_PFlag >> 16) & 255, m_TVec);
				tgt_ship.DockCalcPos(0.0, m_TVec.x, m_TVec.y, m_TVec.z, (m_PFlag >> 16) & 255, true, m_TPos, m_TVec);

				m_PlaceAngle = m_TVec.x;
				m_Pitch = m_TVec.y;
				m_Roll = m_TVec.z;
				m_DesX = m_TPos.x + (tgt_ship.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				m_DesY = m_TPos.y + (tgt_ship.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				m_DesZ = m_TPos.z;

				if (tgt_ship.m_Forsage > 1.0 || (tgt_ship.m_PFlag & PFlagForsageOn));
				else if (!ExistDrop() && m_TakeProgressId == 0 && m_Order == soNone);
				else if (!ExistDrop() && m_TakeProgressId == 0 && m_Order == soDock && (m_PId == m_OrderTargetId) && (m_PFlag & 0xffff0000) == (m_OrderFlag & 0xffff0000));
				else {
					m_PFlag &= ~PFlagInDock;
					m_PFlag |= PFlagUndock;
					m_PTimer = int(2.0 * tgt_ship.DockPathLen((m_PFlag >> 16) & 255, true) / (m_SpeedReal)) << 16;
				}
			}
			break;
		}

		while (true) {
//trace(m_DropId, m_DropProgressId);
			if (m_DropProgressId) {
				if ((m_PFlag & PFlagPosMask) == 0) {
					cont = SP.EntityFind(SpaceEntity.TypeContainer, m_DropProgressId) as SpaceContainer;
					if (cont && cont.m_EntityType == SpaceEntity.TypeContainer) {
						m_DesX = cont.m_PosX + (cont.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
						m_DesY = cont.m_PosY + (cont.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
						m_DesZ = cont.m_PosZ;

						px = m_DesX - m_PosX;
						py = m_DesY - m_PosY;
						pz = m_DesZ - m_PosZ;

						if ((px * px + py * py + pz * pz) < 100.0) {
							if(cont.m_Flag & SpaceContainer.FlagNoMove) {
								cont.m_Flag &= ~SpaceContainer.FlagNoMove;
								cont.m_Time = Math.floor(HS.m_ServerTime / 1000);
							}
							cont.m_Vis = true;
							m_DropProgressId = cont.m_DropNextContainerId;
							if (m_DropProgressId) break;
						} else break;
					}
				}
			} else if (m_TakeProgressId) {
				if ((m_PFlag & PFlagPosMask) == 0) {
					cont = SP.EntityFind(SpaceEntity.TypeContainer, m_TakeProgressId) as SpaceContainer;
					if (cont && cont.m_EntityType == SpaceEntity.TypeContainer) {
						m_DesX = cont.m_PosX + (cont.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
						m_DesY = cont.m_PosY + (cont.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
						m_DesZ = cont.m_PosZ;

						px = m_DesX - m_PosX;
						py = m_DesY - m_PosY;
						pz = m_DesZ - m_PosZ;

						if ((px * px + py * py + pz * pz) < 100.0 || cont.m_ItemCnt <= 0) {
							if (m_Owner == Server.Self.m_UserId) cont.m_Vis = false;
							
							m_TakeProgressId = 0;
							if (cont.m_Take != null)
							for (i = 0; i < SpaceContainer.TakeMax; i++) {
								if (cont.m_Take[i * 3 + 1] != m_Id) continue;
								if (cont.m_Take[i * 3 + 0] != m_EntityType) continue;

								m_TakeProgressId = cont.m_Take[i * 3 + 2];
								break;
							}
							if(m_TakeProgressId) break;
						} else break;
					}
				}
			}

			if (m_Order == soMove) {

			} else if(m_Order==soJump) {

			} else if (m_Order == soOrbitCotl) {
				if ((m_PFlag & PFlagInOrbitCotl) != 0) break;

				ent = SP.EntityFind(SpaceEntity.TypeCotl, m_OrderTargetId);
				if (ent == null) break;
				cotl = ent as SpaceCotl;

				if (m_OrderTimer == 0) {
					vdx = m_PosX - cotl.m_PosX + (m_ZoneX - cotl.m_ZoneX) * SP.m_ZoneSize;
					vdy = m_PosY - cotl.m_PosY + (m_ZoneY - cotl.m_ZoneY) * SP.m_ZoneSize;
					r = Space.EmpireCotlSizeToRadius(cotl.m_CotlSize) + 2000.0;// RadiusToOrbitCotl;
					if ((vdx * vdx + vdy * vdy) > (r * r)) break;
					vdx = m_PosX - m_DesX;
					vdy = m_PosY - m_DesY;
					if ((vdx * vdx + vdy * vdy) > 100) break;
					m_OrderTimer = cnttakt;
					break;
				} else {
					m_OrderTimer += cnttakt;
					if (m_OrderTimer < 500) break;
				}
				dw = (m_OrderFlag >> 16) & 255;

//trace("aa", Math.sqrt((m_PosX - m_DesX) * (m_PosX - m_DesX) + (m_PosY - m_DesY) * (m_PosY - m_DesY) + (m_PosZ - m_DesZ) * (m_PosZ - m_DesZ)));
				r = Space.EmpireCotlSizeToRadius(cotl.m_CotlSize) + RadiusToOrbitCotl;
				angle = SP.ClacOrbitAngle(r, dw);
				r = SP.CalcOrbitRadius(r, dw);

				m_DesX = cotl.m_PosX + r * Math.sin(angle) + (cotl.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				m_DesY = cotl.m_PosY + r * Math.cos(angle) + (cotl.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				if ((m_OrderFlag & 0xff) == 0) {
					m_DesZ = 0.0;

					vdx = m_DesX - m_PosX;
					vdy = m_DesY - m_PosY;
					if((vdx*vdx+vdy*vdy)<(500.0*500.0)) m_OrderFlag = (m_OrderFlag & 0xff0000) | 1;
				}

				if ((m_OrderFlag & 0xff) == 1) {
					m_DesZ = cotl.m_PosZ * 0.25;

					vdx = m_DesX - m_PosX;
					vdy = m_DesY - m_PosY;
					vdz = m_DesZ - m_PosZ;
					if((vdx*vdx+vdy*vdy)<(100.0*100.0)) m_OrderFlag = (m_OrderFlag & 0xff0000) | 2;
				}

				if ((m_OrderFlag & 0xff) == 2) {
					m_DesZ = cotl.m_PosZ * 0.5;
				}

//				vdx = m_PosX - cotl.m_PosX + (m_ZoneX - cotl.m_ZoneX) * SP.m_ZoneSize;
//				vdy = m_PosY - cotl.m_PosY + (m_ZoneY - cotl.m_ZoneY) * SP.m_ZoneSize;
//				r = vdx * vdx + vdy * vdy;
//				if (r < 0.1) { r = cotlr; vdx = 1.0; vdy = 0.0; }
//				//else { r = Math.sqrt(r); }
//				//if (r < cotlr)
//				r = cotlr;
//				angle = Math.atan2( vdx, vdy);
//
//				k = Math.abs(cotl.m_PosZ * 0.5 - m_PosZ);
//				if (k <= 0.0001) { k = 0.0; m_OrderFlag = (m_OrderFlag & 0xff0000) | 2; }
//
//				//if((m_PFlag & PFlagInOrbitCotl) == 0) angle = Space.AngleNorm(angle + (100 * cnttakt) / r);
//				//else
//				angle = Space.AngleNorm(angle + ((0.4 + 2.0 * k) * cnttakt) / r);
//
//				m_DesX = cotl.m_PosX + r * Math.sin(angle);
//				m_DesY = cotl.m_PosY + r * Math.cos(angle);
//				m_DesZ = cotl.m_PosZ * 0.5;

				m_PlaceAngle = BaseMath.AngleNorm(angle + (Space.pi * 0.5));
				
			} else if (m_Order == soOrbitPlanet) {
				if ((m_PFlag & PFlagInOrbitPlanet) != 0) break;

				ent = SP.EntityFind(SpaceEntity.TypePlanet, m_OrderTargetId);
				if (ent == null) break;
				planet = ent as SpacePlanet;

				if (m_OrderTimer == 0) {
					vdx = m_PosX - planet.m_PosX + (m_ZoneX - planet.m_ZoneX) * SP.m_ZoneSize;
					vdy = m_PosY - planet.m_PosY + (m_ZoneY - planet.m_ZoneY) * SP.m_ZoneSize;
					r = planet.m_Radius + 2000.0;
					if ((vdx * vdx + vdy * vdy) > (r * r)) {
//trace("po.op01", m_OrderTimer, Math.sqrt(r));
						break;
					}
					vdx = m_PosX - m_DesX;
					vdy = m_PosY - m_DesY;
					if ((vdx * vdx + vdy * vdy) > (100 * 100)) {
//trace("po.op02", m_OrderTimer, Math.sqrt(vdx * vdx + vdy * vdy));
						break;
					}
					m_OrderTimer = cnttakt;
//trace("po.op03", m_OrderTimer, Math.sqrt(vdx * vdx + vdy * vdy));
					break;
				} else {
//trace("po.op04",m_OrderTimer);
					m_OrderTimer += cnttakt;
					if (m_OrderTimer < 500) break;
				}
				dw = (m_OrderFlag >> 16) & 255;

//trace("aa", Math.sqrt((m_PosX - m_DesX) * (m_PosX - m_DesX) + (m_PosY - m_DesY) * (m_PosY - m_DesY) + (m_PosZ - m_DesZ) * (m_PosZ - m_DesZ)));
				r = planet.m_Radius + RadiusToOrbitPlanet;
				angle = SP.ClacOrbitAngle(r, dw);
				r = SP.CalcOrbitRadius(r, dw);

				m_DesX = planet.m_PosX + r * Math.sin(angle) + (planet.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				m_DesY = planet.m_PosY + r * Math.cos(angle) + (planet.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				if ((m_OrderFlag & 0xff) == 0) {
					m_DesZ = 0.0;

					vdx = m_DesX - m_PosX;
					vdy = m_DesY - m_PosY;
					if((vdx*vdx+vdy*vdy)<(500.0*500.0)) m_OrderFlag = (m_OrderFlag & 0xff0000) | 1;
				}

				if ((m_OrderFlag & 0xff) == 1) {
					m_DesZ = planet.m_PosZ * 0.5;

					vdx = m_DesX - m_PosX;
					vdy = m_DesY - m_PosY;
					vdz = m_DesZ - m_PosZ;
					if((vdx*vdx+vdy*vdy)<(100.0*100.0)) m_OrderFlag = (m_OrderFlag & 0xff0000) | 2;
				}

				if ((m_OrderFlag & 0xff) == 2) {
					m_DesZ = planet.m_PosZ;
				}
				m_PlaceAngle = BaseMath.AngleNorm(angle + (Space.pi * 0.5));

			} else if (m_Order == soFollow) {
				if (m_PFlag & PFlagPosMask) break;

				ProcessOrderFollow(cnttakt);

			} else if (m_Order == soDock) {
				if (m_PFlag & PFlagPosMask) break;

				ent = SP.EntityFind(m_OrderFlag >> PFlagEntityTypeShift, m_OrderTargetId);
				if (ent == null || ent.m_EntityType != SpaceEntity.TypeFleet) break;
				tgt_ship = ent as SpaceShip;

				// Приблежаемся
				ProcessOrderFollow(cnttakt);

				if (tgt_ship.m_Forsage > 1.0) break;
				px = m_PosX - tgt_ship.m_PosX + (m_ZoneX - tgt_ship.m_ZoneX) * SP.m_ZoneSize;
				py = m_PosY - tgt_ship.m_PosY + (m_ZoneY - tgt_ship.m_ZoneY) * SP.m_ZoneSize;

				r = 1000.0 + m_RadiusOuter + tgt_ship.m_RadiusOuter;
				if ((px * px + py * py) > r * r) break;

				if (SP.DockIsBusy(m_OrderTargetId, (m_OrderFlag >> 16) & 255)) break;

				port = (m_OrderFlag >> 16) & 255;
				m_PFlag &= ~SpaceShip.PFlagStepMask;
				m_PFlag = (SpaceShip.PFlagToDock) | (uint(tgt_ship.m_EntityType) << SpaceShip.PFlagEntityTypeShift) | (port << 16) | SpaceShip.PFlagStep0;
				m_PId = tgt_ship.m_Id;
			}
			
			break;
		}

		vdx = m_DesX - m_PosX;
		vdy = m_DesY - m_PosY;
		vdz = m_DesZ - m_PosZ;
		var dd2:Number = vdx * vdx + vdy * vdy + vdz * vdz;

		if ((m_PFlag & PFlagForsagePrepare) != 0) m_PTimer += cnttakt;

		while ((m_PFlag & PFlagForsagePrepare) != 0 && m_PTimer >= 500) {
			// Включение форсажа
			if (dd2 <= (ForsageDistOn * ForsageDistOn)) break;

			angle = Math.atan2(vdx, vdy);
			angleto = Math.abs(BaseMath.AngleDist(m_Angle, angle));
			if (angleto >= 0.5 * Space.ToRad) break;

			if (!ForsageAccess()) break;
			if (!ForsageAccessDist(cnttakt, m_SpeedReal, ForsageMinFactor + 1.0, true)) break;

			m_PFlag &= ~PFlagForsagePrepare;
			m_PFlag |= PFlagForsageOn;
			m_PTimer = 0;

			break;
		}

		if ((dd2 > ForsageDistOn * ForsageDistOn) && (m_PFlag & (PFlagForsageOn | PFlagForsageDisable | PFlagForsagePrepare)) == 0) {
			// Решение принемается на сервере
			//m_PFlag |= PFlagForsagePrepare;
			//m_PTimer = 0;

		} else if ((m_PFlag & (PFlagForsagePrepare)) != 0 && (dd2 < ForsageDistOn * ForsageDistOn)) {
			ForsageOff();

		} else if ((m_PFlag & (PFlagForsageOn)) != 0 && !(ForsageAccess() && ForsageAccessDist(cnttakt, m_SpeedReal, m_Forsage, false))) {
			ForsageOff();

		} else if ((m_PFlag & (PFlagForsageOn)) != 0) {
			angle = Math.atan2(vdx, vdy);
			angleto = Math.abs(BaseMath.AngleDist(m_Angle, angle));
			if ((vdx * vdx + vdy * vdy) > (2000.0 * 2000.0)) {
				if (angleto > 30.0 * Space.ToRad) {
					ForsageOff();
				}
			} else if (angleto > 3.0 * Space.ToRad) {
				ForsageOff();
			}
		}

		if ((m_PFlag & (PFlagForsageOn)) != 0) {
			k = BaseMath.C2Rn(Math.sqrt(vdx * vdx + vdy * vdy), 2000.0, 20000.0, ForsageMinFactor, ForsageMaxFactor);
			if(k>m_Forsage) {
				m_Forsage += 0.02 * cnttakt;
				if (m_Forsage > k) m_Forsage = k;
			} else {
				m_Forsage -= 0.02 * cnttakt;
				if (m_Forsage < k) m_Forsage = k;
			}
			m_DesZ = 1000.0;
			vdz = m_DesZ - m_PosZ;
			dd2 = vdx * vdx + vdy * vdy + vdz * vdz;
		} else {
			m_Forsage-= 0.02 * cnttakt;
			if(m_Forsage<1.0) m_Forsage=1.0;
		}

		var speed:Number = m_Forsage * m_SpeedReal * 500.0;///*cnttakt*/ * 10.0;

		if (dd2 <= speed * speed) {
			m_NewPosX = m_DesX;
			m_NewPosY = m_DesY;
			m_NewPosZ = m_DesZ;
		} else {
			k = speed / Math.sqrt(dd2);
			m_NewPosX = m_PosX + vdx * k;
			m_NewPosY = m_PosY + vdy * k;
			m_NewPosZ = m_PosZ + vdz * k;
		}

		m_ForceX = 0.0;
		m_ForceY = 0.0;
		m_ForceZ = 0.0;

//trace((EmpireMap.Self.m_CurTime).toString() + "\t" + m_PosX.toString() + "\t" + m_PosY.toString() + "\t" + m_NewPosX.toString() + "\t" + m_NewPosY.toString());
	}

	public function ProcessOrderFollow(cnttakt:Number):void
	{
		m_DesX = m_PosX;
		m_DesY = m_PosY;
		m_DesZ = m_PosZ;

		var posx:Number, posy:Number, posz:Number;
		var dirx:Number, diry:Number;
		var r:Number, t:Number, a:Number;
		var ent:SpaceEntity;

		var ook:Boolean = false;
		while(true) {
			if(!m_OrderTargetId) break;
			ent = SP.EntityFind(m_OrderFlag >> PFlagEntityTypeShift, m_OrderTargetId);
			if (!ent) break;

			var ra:Number = 0.0001;

			posx = ent.m_PosX + (ent.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
			posy = ent.m_PosY + (ent.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
			posz = ent.m_PosZ;
			
			if (ent.m_EntityType == SpaceEntity.TypePlanet) {
				posz = 0.0;
				r = (ent as SpacePlanet).m_Radius;

				ra = 0.005; // Имитируем вращение по орбите

			} else if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				r = (ent as SpaceShip).m_RadiusOuter;

			} else break;

			r += m_RadiusOuter;
			if (m_OrderDist > 0.0) r += m_OrderDist;

			dirx = m_DesX - posx;
			diry = m_DesY - posy;

			if (ra != 0.0) {
				a = ra * cnttakt;
				var ca:Number = Math.cos(a);
				var sa:Number = Math.sin(a);

				var x:Number = ca * dirx - sa * diry;
				var y:Number = sa * dirx + ca * diry;
				dirx = x;
				diry = y;
			}

			t = dirx * dirx + diry * diry;
			if (t < 0.0001) { dirx = 1.0; diry = 0.0; }
			else { t = 1.0 / Math.sqrt(t); dirx *= t; diry *= t; }

			m_DesX = posx + dirx * r;
			m_DesY = posy + diry * r;
			m_DesZ = posz;
			m_PlaceX = m_DesX;
			m_PlaceY = m_DesY;
			m_PlaceZ = m_DesZ;

			m_PlaceAngle = BaseMath.AngleNorm(Math.atan2( -dirx, -diry) + Number(m_OrderAngle) * (2.0 * Space.pi / 65536.0));

			ook=true;
			break;
		}

		//if(!ook) OrderNone();
	}

	public function ProcessMove(cnttakt:Number):void
	{
		var kk:Number, t:Number, l:Number, t1:Number, t2:Number, t3:Number, t4:Number, k:Number, ss:Number, vto:Number, vtoabs:Number;
		var et:uint;
		var tgt_ship:SpaceShip;
		var tmpv:Vector3D;
		var path:SpacePath;
		var tx:Number, ty:Number, tz:Number;
		var p1x:Number, p1y:Number, p1z:Number;
		var p2x:Number, p2y:Number, p2z:Number;
		var p3x:Number, p3y:Number, p3z:Number;
		var p4x:Number, p4y:Number, p4z:Number;

		var isshuttle:Boolean = m_EntityType==SpaceEntity.TypeShuttle;

		var force:Boolean = m_ForceX != 0.0 || m_ForceY != 0.0 || m_ForceZ != 0.0;

		var px:Number = m_PosX;
		var py:Number = m_PosY;
		var pz:Number = m_PosZ;

		var smoothmove:Boolean = true;

		var de:Number = (m_DesX - px) * (m_DesX - px) + (m_DesY - py) * (m_DesY - py);
		var def:Number = de + (m_DesZ - pz) * (m_DesZ - pz);

		var vdx:Number = m_NewPosX - px;
		var vdy:Number = m_NewPosY - py;
		var vdz:Number = m_NewPosZ - pz;
		var dd2:Number = vdx * vdx + vdy * vdy + vdz * vdz;

		var speed:Number = m_Forsage * m_SpeedReal * cnttakt;

		var needangle:Number = 0.0;
		var needpitch:Number = 0.0;
		var needroll:Number = 0.0;

		var roll_if_angle:Boolean=true;

		var speedangle:Number = m_SpeedRotate * cnttakt; if (m_Forsage > 1.0) speedangle *= 0.1;
		var speedpitch:Number = m_SpeedRotate * cnttakt;
		var speedroll:Number = m_SpeedRotate * cnttakt;
		var speedz:Number = m_SpeedReal * 0.5 * cnttakt;

		var neardist:Number = m_NearDist;

		// Определяем цель
		var tgt_px:Number, tgt_py:Number, tgt_pz:Number;
		var tgt_forward:Boolean = false;
		var tgt_ent:SpaceEntity = null;
		while (m_TargetType != 0) {
			if (m_TargetType == SpaceEntity.TypeFleet && m_TargetId == m_Id) break;
			tgt_ent = SP.EntityFind(m_TargetType, m_TargetId);
			if (tgt_ent == null) break;
			
			tgt_px = tgt_ent.m_PosX - px + SP.m_ZoneSize * (tgt_ent.m_ZoneX - m_ZoneX);
			tgt_py = tgt_ent.m_PosY - py + SP.m_ZoneSize * (tgt_ent.m_ZoneY - m_ZoneY);
			tgt_pz = tgt_ent.m_PosZ - pz;
			
			if ((tgt_px * tgt_px + tgt_py * tgt_py) > (1000.0 * 1000.0)) { tgt_ent = null; break; }
			
			break;
		}

		// Определение движения корабля в зависимости от его состояния
		if ((m_PFlag & (PFlagInOrbitCotl | PFlagInOrbitPlanet)) != 0) {
			px = m_DesX;
			py = m_DesY;
			pz = m_DesZ;
/*			dd2 = vdx * vdx + vdy * vdy;
			if (dd2 < 1.0) {
				px = m_NewPosX;
				py = m_NewPosY;
			} else {
				dd2 = Math.sqrt(dd2);
				ss = speed * BaseMath.C2Rn(dd2, neardist, 0.0, 1.0, 0.2);
				k = Math.sqrt(m_SpeedMoveX * m_SpeedMoveX + m_SpeedMoveY * m_SpeedMoveY) * cnttakt;
				if (ss > k * 1.1) ss = k = 1.0;

				if (dd2 <= ss) {
					px = m_NewPosX;
					py = m_NewPosY;
				} else {
					k = ss / dd2;
					px = px + vdx * k;
					py = py + vdy * k;
				}
			}
			pz = m_NewPosZ;*/

			m_Angle = m_PlaceAngle;

			speedangle=0.0;
			speed=0.0;
			speedz=0.0;
			roll_if_angle=false;
			smoothmove=false;
			force = false;

		} else if (m_PFlag & PFlagInDock) {
			px = m_DesX;
			py = m_DesY;
			pz = m_DesZ;

			tgt_ship = SP.EntityFind(m_PFlag >> PFlagEntityTypeShift, m_PId) as SpaceShip;

			if (!tgt_ship || tgt_ship.m_EntityType != SpaceEntity.TypeFleet) {
			} else {
				DockDir((m_PFlag >> 16) & 255, m_TVec);
				tgt_ship.DockCalcPos(0.0, m_TVec.x, m_TVec.y, m_TVec.z, (m_PFlag >> 16) & 255, true, m_TPos, m_TVec);

				m_PlaceAngle = m_TVec.x;
				m_Pitch = m_TVec.y;
				m_Roll = m_TVec.z;
				px = m_TPos.x + (tgt_ship.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				py = m_TPos.y + (tgt_ship.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				pz = m_TPos.z;
			}

			m_Angle = m_PlaceAngle;

			speedangle = 0.0;
			speedpitch = 0.0;
			speedroll = 0.0;
			speed = 0.0;
			speedz = 0.0;
			roll_if_angle = false;
			smoothmove = false;
			force = false;

		} else if (m_PFlag & PFlagUndock) {
			tgt_ship = null;
			et = m_PFlag >> PFlagEntityTypeShift;
			if (et == SpaceEntity.TypeFleet) tgt_ship = SP.EntityFind(et, m_PId) as SpaceShip;

			if (tgt_ship) {
				k = BaseMath.C2Rn(Number(m_PTimer & 0xffff), 0.0, Number(m_PTimer >> 16), 0.0, 1.0);
				k *= k;

				DockDir((m_PFlag >> 16) & 255, m_TVec);
				tgt_ship.DockCalcPos(k, m_TVec.x, m_TVec.y, m_TVec.z, (m_PFlag >> 16) & 255, true, m_TPos, m_TVec);

				needangle = m_TVec.x;
				needpitch = m_TVec.y;
				needroll = m_TVec.z;
				px = m_TPos.x + (tgt_ship.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				py = m_TPos.y + (tgt_ship.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				pz = m_TPos.z;
			}
			
			speed = 0.0;
			speedz = 0.0;
			roll_if_angle = false;
			smoothmove = false;
			force = false;

		} else if ((m_PFlag & PFlagToDock) && (m_PFlag & (PFlagStep1 | PFlagStep2 | PFlagStep3)) != 0) {
			while(true) {
				tgt_ship = SP.EntityFind(m_PFlag >> PFlagEntityTypeShift, m_PId) as SpaceShip;
				if (!tgt_ship || tgt_ship.m_EntityType != SpaceEntity.TypeFleet) break;

				if (m_PFlag & PFlagStep1) {
					if (de > (m_NearDist * 1.1 * m_NearDist * 1.1)) {
//trace("mdock_s1a");
						needangle = Math.atan2(vdx, vdy);
					} else {
//trace("mdock_s1b");
						C3D.CalcMatrixShipOri(dcWorld, m_Angle, m_Pitch, m_Roll);

						m_TVec.x = 0.0; m_TVec.y = 1.0; m_TVec.z = 0.0; m_TVec.w = 0;
						tmpv = dcWorld.deltaTransformVector(m_TVec);

						C3D.CalcMatrixShipOriInv(dcWorld, tgt_ship.m_Angle, tgt_ship.m_Pitch, tgt_ship.m_Roll);
						
						tmpv = dcWorld.deltaTransformVector(tmpv);
						m_DockDirX = tmpv.x; m_DockDirY = tmpv.y; m_DockDirZ = tmpv.z;

						m_TVec.x = m_PosX - tgt_ship.m_PosX + (m_ZoneX - tgt_ship.m_ZoneX) * SP.m_ZoneSize;
						m_TVec.y = m_PosY - tgt_ship.m_PosY + (m_ZoneY - tgt_ship.m_ZoneY) * SP.m_ZoneSize;
						m_TVec.z = m_PosZ - tgt_ship.m_PosZ;
						m_TVec.w = 0;

						tmpv = dcWorld.deltaTransformVector(m_TVec);
						m_DockPosX = tmpv.x; m_DockPosY = tmpv.y; m_DockPosZ = tmpv.z;

						m_DockTime = 0.0;
						m_DockLen = 0.0;

						m_PFlag&=~PFlagStep1;
						m_PFlag|=PFlagStep2;
						m_PTimer=0;
//trace("Step2 Init");
					}
				}

				if (m_PFlag & PFlagStep2) {
//trace("mdock_s2a");
					speed *= BaseMath.C2Rn(m_DockTime, 0.0, 0.9, 1.0, 0.4);

					path = tgt_ship.OrderDockPath((m_PFlag >> 16) & 255, false);
					path.Get(0.0, m_TPos, m_TDir, m_TUp);

					var needpath:Number = speed;
					var step:Number = 0.05;

					DockDir((m_PFlag >> 16) & 255, m_TDockDir);

					p1x = m_DockPosX; p1y = m_DockPosY; p1z = m_DockPosZ;
					p2x = p1x + m_DockDirX * 120.0; p2y = p1y + m_DockDirY * 120.0; p2z = p1z + m_DockDirZ * 120.0;
					p3x = m_TPos.x + m_TDockDir.x - m_TDir.x * 120.0; p3y = m_TPos.y + m_TDockDir.y - m_TDir.y * 120.0; p3z = m_TPos.z + m_TDockDir.z - m_TDir.z * 120.0;
					p4x = m_TPos.x + m_TDockDir.x; p4y = m_TPos.y + m_TDockDir.y; p4z = m_TPos.z + m_TDockDir.z;

					// Приблежаемся по бизе-кривой
					t = m_DockTime;
					
					var psx:Number, psy:Number, psz:Number;
					var pex:Number, pey:Number, pez:Number;

					t1 = 1.0 - t; t2 = t1 * t1; t1 = t2 * t1;
					t2 = 3.0 * t * t2;
					t3 = 3.0 * t * t * (1.0 - t);
					t4 = t * t * t;
					psx = t1 * p1x + t2 * p2x + t3 * p3x + t4 * p4x;
					psy = t1 * p1y + t2 * p2y + t3 * p3y + t4 * p4y;
					psz = t1 * p1z + t2 * p2z + t3 * p3z + t4 * p4z;

					t = Math.min(1.0, t + step);
					t1 = 1.0 - t; t2 = t1 * t1; t1 = t2 * t1;
					t2 = 3.0 * t * t2;
					t3 = 3.0 * t * t * (1.0 - t);
					t4 = t * t * t;
					pex = t1 * p1x + t2 * p2x + t3 * p3x + t4 * p4x;
					pey = t1 * p1y + t2 * p2y + t3 * p3y + t4 * p4y;
					pez = t1 * p1z + t2 * p2z + t3 * p3z + t4 * p4z;
					
					tx = pex - psx;
					ty = pey - psy;
					tz = pez - psz;
					l = Math.sqrt(tx * tx + ty * ty + tz * tz);
					k = 1.0 / l;
					psx += tx * k * m_DockLen;
					psy += ty * k * m_DockLen;
					psz += tz * k * m_DockLen;
					l -= m_DockLen;
					
					if(l>needpath) {
						tx = pex - psx;
						ty = pey - psy;
						tz = pez - psz;
						l = Math.sqrt(tx * tx + ty * ty + tz * tz);
						k = 1.0 / l;

						m_DockLen += needpath;
						pex = psx + tx * k * needpath;
						pey = psy + ty * k * needpath;
						pez = psz + tz * k * needpath;
						needpath = 0.0;
					} else {
						m_DockTime = Math.min(1.0, m_DockTime + step);
						m_DockLen = 0.0;
						needpath -= l;
						if(m_DockTime>=1.0) {
						} else if (needpath <= 0.0) {
						} else {
							do {
								psx = pex; psy = pey; psz = pez;
								t = Math.min(1.0, t + step);
								t1 = 1.0 - t; t2 = t1 * t1; t1 = t2 * t1;
								t2 = 3.0 * t * t2;
								t3 = 3.0 * t * t * (1.0 - t);
								t4 = t * t * t;
								pex = t1 * p1x + t2 * p2x + t3 * p3x + t4 * p4x;
								pey = t1 * p1y + t2 * p2y + t3 * p3y + t4 * p4y;
								pez = t1 * p1z + t2 * p2z + t3 * p3z + t4 * p4z;

								tx = pex - psx;
								ty = pey - psy;
								tz = pez - psz;

								l = Math.sqrt(tx * tx + ty * ty + tz * tz);
								if (l > needpath) {
									m_DockLen = needpath;
									k = needpath / l;
									pex = psx + tx * k;
									pey = psy + ty * k;
									pez = psz + tz * k;
									needpath = 0.0;
									break;
								}
								needpath -= l;

								m_DockTime = Math.min(1.0, m_DockTime + step);
								m_DockLen = 0.0;
							} while (m_DockTime < 1.0);
						}
					}

					C3D.CalcMatrixShipOri(dcWorld, tgt_ship.m_Angle, tgt_ship.m_Pitch, tgt_ship.m_Roll);

					if (m_DockTime < 1.0) {
//trace("mdock_s2b\t" + m_DockTime.toString() +"\t" + step.toString() + "\t" + pex.toString() + "\t" + pey.toString() + "\t" + pez.toString());

						m_TPos.x = pex; m_TPos.y = pey; m_TPos.z = pez; m_TPos.w = 0;
						m_TDir.x = pex - psx; m_TDir.y = pey - psy; m_TDir.z = pez - psz; m_TDir.normalize();

						tmpv = dcWorld.deltaTransformVector(m_TPos);
						m_TPos.x = tmpv.x; m_TPos.y = tmpv.y; m_TPos.z = tmpv.z;
						
						tmpv = dcWorld.deltaTransformVector(m_TDir);
						m_TDir.x = tmpv.x; m_TDir.y = tmpv.y; m_TDir.z = tmpv.z;
						
						tmpv = dcWorld.deltaTransformVector(m_TUp);
						m_TUp.x = tmpv.x; m_TUp.y = tmpv.y; m_TUp.z = tmpv.z;

						px = tgt_ship.m_PosX + m_TPos.x + (tgt_ship.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
						py = tgt_ship.m_PosY + m_TPos.y + (tgt_ship.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
						pz = tgt_ship.m_PosZ + m_TPos.z;

						CalcAnglePitchRoll(m_TDir, m_TUp, m_TVec);
						needangle = m_TVec.x;
						needpitch = m_TVec.y;
						needroll = m_TVec.z;

						//m_SD->m_Des=m_SD->m_Place=p;
						//m_SD->m_PlaceAngle=m_SD->m_Angle;

						speed = 0.0;
						speedz = 0.0;
//						speedangle *= 1.0 + m_DockTime * 2.0;
//						speedpitch *= 1.0 + m_DockTime * 2.0;
//						speedroll *= 1.0 + m_DockTime * 2.0;
						roll_if_angle = false;
						smoothmove = false;
						force = false;
					} else {
//trace("mdock_s2c");
						m_PFlag &= ~PFlagStep2;
						m_PFlag |= PFlagStep3;
						k = 2.0 * path.m_Length / (speed / cnttakt);
						m_PTimer = uint(Math.round(k)) << 16;

						k = path.FindByLength(needpath);
						m_PTimer += Math.round(Number(m_PTimer >> 16) * k);
//trace("Step3 Init");
					}
				}

				if (m_PFlag & PFlagStep3) {
//trace("mdock_s3a");
					t = BaseMath.C2Rn(m_PTimer & 0xffff, 0.0, m_PTimer >> 16, 0.0, 1.0);
					t = 1.0 - t;
					t *= t;
					t = 1.0 - t;

					DockDir((m_PFlag >> 16) & 255, m_TDockDir);
					tgt_ship.DockCalcPos(t, m_TDockDir.x, m_TDockDir.y, m_TDockDir.z, (m_PFlag >> 16) & 255, false, m_TPos, m_TVec);
//trace(t.toString() + "\t" + m_TPos.x.toString() + "\t" + m_TPos.y.toString() + "\t" + m_TPos.z.toString());
					
					px = m_TPos.x + (tgt_ship.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
					py = m_TPos.y + (tgt_ship.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
					pz = m_TPos.z;
					
//					m_Angle = m_TVec.x;
//					m_Pitch = m_TVec.y;
//					m_Roll = m_TVec.z;
					needangle = m_TVec.x;
					needpitch = m_TVec.y;
					needroll = m_TVec.z;

					speed = 0.0;
					speedz = 0.0;
//					speedangle = 0.0;
//					speedpitch = 0.0;
//					speedroll = 0.0;
					roll_if_angle = false;
					smoothmove = false;
					force = false;
				}

				break;
			}
			tgt_ent = null;

		} else if (tgt_forward || (de < neardist * neardist) || ((Math.abs(m_DesZ - pz) * 2.0) >= de) || isshuttle) {
			kk = 1.0;
			if ((m_Order == soOrbitCotl || m_Order == soOrbitPlanet) && m_OrderTimer != 0) { }  // при выходе на орбиту скорость не сбрасываем
			else {
				if (isshuttle) kk = 0.5;
				else kk = 0.2;
				kk = BaseMath.C2Rn(Math.sqrt(def), neardist, 0.0, 1.0, kk);
			}
			ss = speed * kk;

			needangle = m_PlaceAngle;

			if (dd2 <= (ss * ss)) {
			//if(Math.sqrt(dd2)<=ss) {
				px = m_NewPosX;
				py = m_NewPosY;
				pz = m_NewPosZ;

				smoothmove = false;
				speedz = 0.0;
				if (isshuttle) speedangle = 0.0;
			} else {
				k = ss / Math.sqrt(dd2);
				px = px + vdx * k;
				py = py + vdy * k;
				pz = pz + vdz * k;

				speedz*=kk;
				if (isshuttle) needangle = Math.atan2(m_DesX - px, m_DesY - py);
			}

			speed=0.0;
			speedz=0.0;

		} else {
			needangle = Math.atan2(m_DesX - px, m_DesY - py);
		}

		// Наклон если есть цель
		if (tgt_ent != null) {
			var ud:Number = Math.atan2(Math.sqrt(tgt_px * tgt_px + tgt_py * tgt_py), tgt_pz);

			var ad:Number = Math.atan2(tgt_px, tgt_py);
			var a:Number = BaseMath.AngleDist(m_Angle, ad);

			if (a >= 0.0) needroll = ud - Space.pi * 0.5 * 0.8;
			else needroll = -ud + Space.pi * 0.5 * 0.8;

			if (Math.abs(a) >= Space.pi * 0.5) needpitch = ud - Space.pi * 0.5 * 0.8;
			else needpitch = -ud + Space.pi * 0.5 * 0.8;

			t = Math.abs(Math.abs(a) - Space.pi * 0.5);
			needpitch *= BaseMath.C2Rn(t, 0.0, Space.pi * 0.5, 0.0, 1.0);
			needroll *= BaseMath.C2Rn(t, 0.0, Space.pi * 0.5, 1.0, 0.0);

			roll_if_angle = false;
		}

		// Меняем курс
		if (m_ServerCorrectionFactor != 0.0) speedangle = 0; // Только для клиента. В момент коррекции угол не меняем.
		if (speedangle > 0.0) {
			vto = BaseMath.AngleDist(m_Angle, needangle);
			vtoabs = Math.abs(vto);

			ss = 0.2 * speedangle;

			if(vto<0.0) {
				m_SpeedAngle -= ss;
				if (m_SpeedAngle < -speedangle) m_SpeedAngle = -speedangle;
			} else {
				m_SpeedAngle += ss;
				if (m_SpeedAngle > speedangle) m_SpeedAngle = speedangle;
			}

			if (vtoabs <= speedangle) {
				m_SpeedAngle=0.0;
				m_Angle=needangle;
			} else {
				m_Angle = BaseMath.AngleNorm(m_Angle + m_SpeedAngle);
			}

			if (roll_if_angle) needroll = BaseMath.C2Rn(vto, -Space.pi * 0.5, Space.pi * 0.5, -ShipMaxRoll, ShipMaxRoll);
		}
		
		// Меняем тангаж
		if(speedpitch>0.0) {
			vto = BaseMath.AngleDist(m_Pitch, needpitch);
			vtoabs = Math.abs(vto);

			ss = 0.2 * speedpitch;

			if (vto < 0.0) {
				m_SpeedPitch-=ss;
				if (m_SpeedPitch < -speedpitch) m_SpeedPitch = -speedpitch;
			} else {
				m_SpeedPitch += ss;
				if (m_SpeedPitch > speedpitch) m_SpeedPitch = speedpitch;
			}

			if (vtoabs <= speedpitch) {
				m_SpeedPitch = 0.0;
				m_Pitch = needpitch;
			} else {
				m_Pitch = BaseMath.AngleNorm(m_Pitch + m_SpeedPitch);
			}
		}

		// Меняем крен
		if (speedroll > 0.0) {
			if (m_Forsage > 1.0) needroll = 0.0;

			vto = BaseMath.AngleDist(m_Roll, needroll);
			vtoabs = Math.abs(vto);

			ss = 0.2 * speedroll;

			if (vto < 0.0) {
				m_SpeedRoll -= ss;
				if (m_SpeedRoll < -speedroll) m_SpeedRoll = -speedroll;
			} else {
				m_SpeedRoll += ss;
				if (m_SpeedRoll > speedroll) m_SpeedRoll = speedroll;
			}

			if(vtoabs<=speedroll) {
				m_SpeedRoll = 0.0;
				m_Roll = needroll;
			} else {
				m_Roll = BaseMath.AngleNorm(m_Roll + m_SpeedRoll);
			}
		}

		// Меняем положение x,y
		if(speed>0.0) {
			px = px + Math.sin(m_Angle) * speed;
			py = py + Math.cos(m_Angle) * speed;
		}

		// Меняем положение z
		if(speedz>0.0) {
			var vdz2:Number = m_NewPosZ - pz;
			if (vdz2 < -speedz) pz -= speedz;
			else if (vdz2 > speedz) pz += speedz;
			else pz = m_NewPosZ;
		}

		// Force
		if(force) {
			var mass:Number = 200.0;// m_Mass;
			if (m_EntityType == SpaceEntity.TypeShuttle) mass = 75;
			if (m_Forsage > 1.0) mass *= 0.5;
			mass = 1.0 / mass;
			px += m_ForceX * cnttakt * mass;
			py += m_ForceY * cnttakt * mass;
			pz += m_ForceZ * cnttakt * mass;
//if(m_EntityType == SpaceEntity.TypeShuttle) trace("Force", m_ForceX * cnttakt * mass, m_ForceY * cnttakt * mass, m_ForceZ * cnttakt * mass);
		}

		// Сглаживаем движение
		while (smoothmove) {
			if ((m_SpeedMoveX * m_SpeedMoveX + m_SpeedMoveY * m_SpeedMoveY) > (2.0 * speed * 2.0 * speed)) break;

			p2x = m_PosX + m_SpeedMoveX * cnttakt;
			p2y = m_PosY + m_SpeedMoveY * cnttakt;
			p2z = m_PosZ + m_SpeedMoveZ * cnttakt;

			var pvx:Number = px - p2x;
			var pvy:Number = py - p2y;
			var pvz:Number = pz - p2z;
			var pvd:Number = pvx * pvx + pvy * pvy + pvz * pvz;

			if(pvd>0.0001) {
				pvd = Math.sqrt(pvd);
				k = 1.0 / pvd;
				pvx *= k; pvy *= k; pvz *= k;

				ss = 0.4 * cnttakt;
				if (pvd > ss) pvd = ss;

				px = p2x + pvx * pvd;
				py = p2y + pvy * pvd;
				pz = p2z + pvz * pvd;
			}
			break;
		}
		
		// Выходим на орбиту
		if (m_Order == soOrbitCotl && (m_OrderFlag & 0xff) == 2 && (m_PFlag & PFlagInOrbitCotl) == 0) {
			vdx = px - m_DesX;
			vdy = py - m_DesY;
			vdz = pz - m_DesZ;
			if (((vdx * vdx + vdy * vdy + vdz * vdz) < 1.0) && (Math.abs(BaseMath.AngleDist(m_Angle, m_PlaceAngle)) < (2.0 * Space.ToRad))) {
				m_PFlag |= PFlagInOrbitCotl;
				m_PId = m_OrderTargetId;
				m_PFlag = (m_PFlag & (~0xff0000)) | (m_OrderFlag & 0xff0000);
				//OrderNone(); сбрасывать приказ нельзя, так как он на клиенте может заменить еще не завершенный.
			}
		}
		else if (m_Order == soOrbitPlanet && (m_OrderFlag & 0xff) == 2 && (m_PFlag & PFlagInOrbitPlanet) == 0) {
			vdx = px - m_DesX;
			vdy = py - m_DesY;
			vdz = pz - m_DesZ;
			if (((vdx * vdx + vdy * vdy + vdz * vdz) < 1.0) && (Math.abs(BaseMath.AngleDist(m_Angle, m_PlaceAngle)) < (2.0 * Space.ToRad))) {
				m_PFlag |= PFlagInOrbitPlanet;
				m_PId = m_OrderTargetId;
				m_PFlag = (m_PFlag & (~0xff0000)) | (m_OrderFlag & 0xff0000);
			}
		}

		// Расчитываем реальную скокрость перемещения
		var cnttaktO:Number = 1.0 / cnttakt;
		m_SpeedMoveX = (px - m_PosX) * cnttaktO;
		m_SpeedMoveY = (py - m_PosY) * cnttaktO;
		m_SpeedMoveZ = (pz - m_PosZ) * cnttaktO;

		while(true) {
			if ((m_PFlag & (PFlagInOrbitCotl | PFlagInOrbitPlanet)) != 0) break;
			k = m_SpeedMoveX * m_SpeedMoveX + m_SpeedMoveY * m_SpeedMoveY;
			if (k <= 0.000001) break;
			m_PDist += Math.sqrt(k) * cnttakt;
			if (m_PDist < 500.0) break;
			m_PDist -= 500.0;
			if (m_PDist >= 500.0) m_PDist = 0;

			m_PPrior = Math.floor(HS.m_ServerTime / 1000);
//trace("dist:", m_PDist, "prior:", m_PPrior);
			break;
		}

		// Сохраняем новое положение корабля
//trace((EmpireMap.Self.m_CurTime).toString() + "\t" + m_PosX.toString() + "\t" + m_PosY.toString() + "\t" + px.toString() + "\t" + py.toString());
		m_PosX = px;
		m_PosY = py;
		m_PosZ = pz;

		
//if(m_Id == 8) trace("ProcessMove", m_Id, m_PosX, m_PosY, "Place", m_PlaceX, m_PlaceY);
//trace("ProcessMove\t" + m_PosX.toString() + "\t" + m_PosY.toString());
	}

	public function InitRepulsion(cnttakt:Number):void
	{
		if (m_RepulsionSkip != null) m_RepulsionSkip.length = 0;
		var rep:Boolean = true;
		if ((m_State & StateLive) == 0) { m_RepulsionFactor = 0.0; return; }
		else if (m_PFlag & (PFlagInOrbitCotl | PFlagInOrbitPlanet | PFlagInDock | PFlagUndock)) { m_RepulsionFactor = 0.0; return; }
		else if ((m_PFlag & PFlagToDock) && m_DropProgressId == 0 && m_TakeProgressId == 0) {
			if ((m_PFlag & (PFlagStep0 | PFlagStep1)) == 0) { m_RepulsionFactor = 0.0; return; }
			else {
				if (m_RepulsionSkip == null) m_RepulsionSkip = new Vector.<SpaceEntity>();
				SP.SpaceBusy(m_ZoneX, m_ZoneY, m_NewPosX, m_NewPosY, m_NewPosZ, m_Radius, this, m_RepulsionSkip);
			}
		}
		else if (m_Order == soOrbitCotl && (m_OrderFlag & 0xff) >= 1) rep = false;
		else if (m_Order == soOrbitPlanet && (m_OrderFlag & 0xff) >= 1) rep = false;
	
		var cont:SpaceContainer;

		if (rep) {
			if (m_DropProgressId || m_TakeProgressId) {
				if (m_RepulsionSkip == null) m_RepulsionSkip = new Vector.<SpaceEntity>();

				if(m_DropProgressId) {
					cont = SP.EntityFind(SpaceEntity.TypeContainer, m_DropProgressId) as SpaceContainer;
					if (cont) {
						SP.SpaceBusy(cont.m_ZoneX, cont.m_ZoneY, cont.m_PosX, cont.m_PosY, cont.m_PosZ, m_Radius, this, m_RepulsionSkip);
					}
				} else if(m_TakeProgressId) {
					cont = SP.EntityFind(SpaceEntity.TypeContainer, m_TakeProgressId) as SpaceContainer;
					if (cont) {
						SP.SpaceBusy(cont.m_ZoneX, cont.m_ZoneY, cont.m_PosX, cont.m_PosY, cont.m_PosZ, m_Radius, this, m_RepulsionSkip);
					}
				}
			}
			
			m_RepulsionFactor += 0.002 * cnttakt;
			if (m_RepulsionFactor > 1.0) m_RepulsionFactor = 1.0;
		} else {
			m_RepulsionFactor -= 0.002 * cnttakt;
			if (m_RepulsionFactor < 0.0) m_RepulsionFactor = 0.0;
		}
//trace("RP", m_RepulsionFactor);
	}

	static public function ProcessRepulsionZ(space:Space):void
	{
		var i:int,u:int;
		var dx:Number, dy:Number, dz:Number, r:Number;
		var ent:SpaceEntity, ent2:SpaceEntity;
		var ship:SpaceShip, ship2:SpaceShip;
		var planet2:SpacePlanet;

		for (i = 0; i < space.m_EntityList.length; i++) {
			ent = space.m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypeFleet && ent.m_EntityType != SpaceEntity.TypeShuttle) continue;
			ship = SpaceShip(ent);
			if (!ship.m_RecvFull) continue;
			if (ship.m_RepulsionFactor <= 0.0) continue;
			if (ship.m_PFlag & (SpaceShip.PFlagInDock | SpaceShip.PFlagUndock)) continue;
			if ((ship.m_PFlag & SpaceShip.PFlagToDock) && (ship.m_PFlag & SpaceShip.PFlagStep0) == 0) continue;
			if (ship.m_RadiusInner <= 0.0) continue;
			if (ship.m_ServerCorrectionFactor > 0.0) continue;

			for (u = 0; u < space.m_EntityList.length; u++) {
				ent2 = space.m_EntityList[u];
				if (ent2.m_EntityType == SpaceEntity.TypePlanet) {
					planet2 = SpacePlanet(ent2);
					if ((planet2.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;

					if (ship.m_RepulsionSkip != null && ship.m_RepulsionSkip.indexOf(ent2) >= 0) continue;

					dx = ship.m_NewPosX - planet2.m_PosX + (ship.m_ZoneX - planet2.m_ZoneX) * space.m_ZoneSize;
					dy = ship.m_NewPosY - planet2.m_PosY + (ship.m_ZoneY - planet2.m_ZoneY) * space.m_ZoneSize;
					dz = ship.m_NewPosZ - planet2.m_PosZ;

					r = (ship.m_Radius + planet2.m_Radius + 50.0) * ship.m_RepulsionFactor;
					if ((dx * dx + dy * dy + dz * dz) >= (r * r)) continue;
					r = r * r - (dx * dx + dy * dy);
					if (r <= 0.0) continue;
					ship.m_NewPosZ = planet2.m_PosZ + Math.sqrt(r);
				}
			}

			for (u = 0; u < i; u++) {
				ent2 = space.m_EntityList[u];
				if (ent2.m_EntityType == SpaceEntity.TypeFleet) {
					ship2 = SpaceShip(ent2);
					if (!ship2.m_RecvFull) continue;
					if (ship2.m_RepulsionFactor <= 0.0) continue;
					if (ship2.m_RadiusInner <= 0.0) continue;
					if (ship2.m_ServerCorrectionFactor > 0.0) continue;
					
					if (ship.m_RepulsionSkip != null && ship.m_RepulsionSkip.indexOf(ent2) >= 0) continue;

					dx = ship.m_NewPosX - ship2.m_NewPosX + (ship.m_ZoneX - ship2.m_ZoneX) * space.m_ZoneSize;
					dy = ship.m_NewPosY - ship2.m_NewPosY + (ship.m_ZoneY - ship2.m_ZoneY) * space.m_ZoneSize;
					dz = ship.m_NewPosZ - ship2.m_NewPosZ;

					r = (ship.m_Radius + ship2.m_Radius) * ship.m_RepulsionFactor;
					if ((dx * dx + dy * dy + dz * dz) >= (r * r)) continue;
					//r *= 0.5;
					r = r * r - (dx * dx + dy * dy);
					if (r <= 0.0) continue;
					ship.m_NewPosZ = ship2.m_NewPosZ + Math.sqrt(r);
				}
			}
		}
	}

	static public function ProcessRepulsion(cnttakt:Number, space:Space):void
	{
		var i:int, u:int;
		var dx:Number, dy:Number, dz:Number, dd2:Number, ri:Number, ro:Number, k:Number, w:Number, r:Number, r2:Number, dd:Number, d:Number, f:Number;
		var ent:SpaceEntity, ent2:SpaceEntity;
		var ship:SpaceShip, ship2:SpaceShip;
		var planet2:SpacePlanet;

//trace("calc repulsion:");
		for (i = 0; i < space.m_EntityList.length; i++) {
			ent = space.m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypeFleet && ent.m_EntityType != SpaceEntity.TypeShuttle) continue;
			ship = SpaceShip(ent);
			if (!ship.m_RecvFull) continue;
			if (ship.m_RepulsionFactor <= 0.0) continue;
			if (ship.m_PFlag & (SpaceShip.PFlagInDock | SpaceShip.PFlagUndock)) continue;
			if ((ship.m_PFlag & SpaceShip.PFlagToDock) && (ship.m_PFlag & SpaceShip.PFlagStep0) == 0) continue;
			if (ship.m_RadiusInner <= 0.0) continue;
			if (ship.m_ServerCorrectionFactor > 0.0) continue;

			for (u = 0; u < space.m_EntityList.length; u++) {
				ent2 = space.m_EntityList[u];
				if (ent2 == ent) continue;
				if (ent2.m_EntityType == SpaceEntity.TypePlanet) {
					planet2 = SpacePlanet(ent2);

					if ((planet2.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;

					if (ship.m_RepulsionSkip != null && ship.m_RepulsionSkip.indexOf(ent2) >= 0) continue;

					dx = ship.m_PosX - planet2.m_PosX + (ship.m_ZoneX - planet2.m_ZoneX) * space.m_ZoneSize;
					dy = ship.m_PosY - planet2.m_PosY + (ship.m_ZoneY - planet2.m_ZoneY) * space.m_ZoneSize;
					dz = ship.m_PosZ - planet2.m_PosZ;

					dd2 = dx * dx + dy * dy + dz * dz;

					ro = ship.m_RadiusOuter + planet2.m_Radius + 100.0;
					ri = ro - 50.0; if (ri < 0.0) ri = 0.0;

					if (dd2 < 0.0001) { dd = 0.0; dx = dy = 0.0; dz = 1.0; }
					else { dd = Math.sqrt(dd2); k = 1.0 / dd; dx *= k; dy *= k; dz *= k; }

					f = 1.0 - Math.max(0.0, dd - ri) / (ro - ri);
					if (f > 0.00001) {
						f *= ship.m_SpeedReal * 500.0;

//						ship.m_ForceX += dx * f;
//						ship.m_ForceY += dy * f;
						ship.m_ForceZ += dz * f * ship.m_RepulsionFactor;
					}

				} else if (ent2.m_EntityType == SpaceEntity.TypeFleet) {
					ship2 = SpaceShip(ent2);
					if (!ship2.m_RecvFull) continue;
					if (ship2.m_RadiusInner <= 0.0) continue;
					if (ship2.m_ServerCorrectionFactor > 0.0) continue;

					if (ship.m_RepulsionSkip != null && ship.m_RepulsionSkip.indexOf(ent2) >= 0) continue;

					dx = ship.m_NewPosX - ship2.m_NewPosX + (ship.m_ZoneX - ship2.m_ZoneX) * space.m_ZoneSize;
					dy = ship.m_NewPosY - ship2.m_NewPosY + (ship.m_ZoneY - ship2.m_ZoneY) * space.m_ZoneSize;
					dz = ship.m_NewPosZ - ship2.m_NewPosZ;

					ro = ship.m_RadiusOuter + ship2.m_RadiusOuter;
					ri = ship.m_RadiusInner + ship2.m_RadiusInner;

					dd2 = dx * dx + dy * dy + dz * dz;

/*					if (dd2 < ro * ro) {
						if (dd2 < 0.0001) { dd2 = 1.0; dx = dy = dz = 0.0; dz = 1.0; }

						dd = Math.sqrt(dd2);
						d = ro - dd;
						k = 1.0 / dd;

						r = d;

						ship.m_NewPosX += dx * k * r;
						ship.m_NewPosY += dy * k * r;
						ship.m_NewPosZ += dz * k * r;
					}*/

					if (ship.m_Forsage <= 1.0) {
					//if (false) {
						f=0.0;

						dx = ship.m_PosX - ship2.m_PosX + (ship.m_ZoneX - ship2.m_ZoneX) * space.m_ZoneSize;
						dy = ship.m_PosY - ship2.m_PosY + (ship.m_ZoneY - ship2.m_ZoneY) * space.m_ZoneSize;
						dz = ship.m_PosZ - ship2.m_PosZ;
						w = dz;
						dd2 = dx * dx + dy * dy + dz * dz;

						ri = ro - 50.0; if (ri < 0.0) ri = 0.0;

						if (dd2 < 0.0001) { dd = 0.0; dx = dy = 0.0; dz = 1.0; }
						else { dd = Math.sqrt(dd2); k = 1.0 / dd; dx *= k; dy *= k; dz *= k; }

						f = 1.0 - Math.max(0.0, dd - ri) / (ro - ri);
						if (f > 0.00001) {
							f *= ship.m_SpeedReal * 40.0;

							ship.m_ForceX += dx * f * ship.m_RepulsionFactor;
							ship.m_ForceY += dy * f * ship.m_RepulsionFactor;
							ship.m_ForceZ += dz * f * ship.m_RepulsionFactor;

							if (f < 100.0) f = 100.0;
							f *= 1.5;
							if (Math.abs(w) <= 0.000001) {
								if (ship.m_PPrior > ship2.m_PPrior) ship.m_ForceZ += f * ship.m_RepulsionFactor;
								else if(ship.m_PPrior < ship2.m_PPrior) ship.m_ForceZ -= f * ship.m_RepulsionFactor;
								else if(ship.m_Id > ship2.m_Id) ship.m_ForceZ += f * ship.m_RepulsionFactor;
								else ship.m_ForceZ -= f * ship.m_RepulsionFactor;
							}
							else if (w > 0.0) ship.m_ForceZ += f * ship.m_RepulsionFactor;
							else ship.m_ForceZ -= f * ship.m_RepulsionFactor;
	//trace("        ",ship2.m_ForceZ);
	//if(ship.m_Id == 7) trace("    f:", f, "id:", ship.m_Id, "dist:", dd, w, "forse:", ship.m_ForceZ,"                 posz:",ship.m_PosZ,ship2.m_PosZ);
						}
					}
				}
			}
		}
	}
	
	public function ToServerCorrection(dt:Number):void
	{
//return;
		var k:Number;

		if ((m_Order == soOrbitCotl || m_Order == soOrbitPlanet) && (m_OrderFlag & 0xff) >= 1) { m_ServerCorrectionFactor = 0; return; }

		if (m_ServerCorrectionFactor == 0.0) {
			k = 600.0;
			if (m_EntityType == SpaceEntity.TypeShuttle) k = 2000;
			k = k * m_SpeedReal * Math.max(m_ServerForsage, m_Forsage);
			if (m_ServerPFlag & (PFlagInOrbitCotl|PFlagInOrbitPlanet)) k *= 0.3;
			if (m_ServerCorrectionDist < k) return;
//trace("!!!ToServerCorrection00", k, "dist:", m_ServerCorrectionDist);
			
//			m_ServerCorrectionFactor = dt * 0.0001;
//			m_ServerCorrectionTakt = 200;
//		} else {
//			m_ServerCorrectionFactor += dt * 0.0001;
//			m_ServerCorrectionTakt = 200;
//			if (m_ServerCorrectionFactor >= 1.0) {
				m_PlaceX += (m_ZoneX - m_ServerZoneX) * SP.m_ZoneSize;
				m_PlaceY += (m_ZoneY - m_ServerZoneY) * SP.m_ZoneSize;

				m_ZoneX = m_ServerZoneX;
				m_ZoneY = m_ServerZoneY;
				m_PosX = m_ServerPosX;
				m_PosY = m_ServerPosY;
				m_PosZ = m_ServerPosZ;
				m_Angle = m_ServerAngle;
				m_Forsage = m_ServerForsage;
				m_PFlag = m_ServerPFlag;
				m_PTimer = m_ServerPTimer;
				m_PId = m_ServerPId;
				//m_PPrior = m_ServerPPrior;
				m_PDist = m_ServerPDist;
				m_ServerCorrectionDist = 0;
				m_ServerCorrectionFactor = 0;
				m_ServerCorrectionTakt = 0;
				
				m_ClearSmooth = true;
				
				return;
//			}
		}

	}

	public function ToServerCorrectionTakt(cnttakt:Number):void
	{
		var dx:Number, dy:Number, dz:Number, dd:Number, k:Number, t:Number;
		var ent:SpaceEntity;

		if (m_ServerCorrectionFactor <= 0) return;

		m_ServerCorrectionTakt -= cnttakt;
		if (m_ServerCorrectionTakt <= 0) return;

		k = m_ServerCorrectionFactor * 0.02 * cnttakt;

		dd = m_ServerForsage-m_Forsage;
		m_Forsage += dd * k;

		if (m_ServerPFlag & PFlagInOrbitCotl) {
			// Приближаем по круговой траектории
			ent = SP.EntityFind(SpaceEntity.TypeCotl, m_ServerPId);
			while (ent != null) {
				var cotl:SpaceCotl = ent as SpaceCotl;
				dx = m_ServerPosX - cotl.m_PosX + (m_ServerZoneX - cotl.m_ZoneX) * SP.m_ZoneSize;
				dy = m_ServerPosY - cotl.m_PosY + (m_ServerZoneY - cotl.m_ZoneY) * SP.m_ZoneSize;
				var needr:Number = dx * dx + dy * dy;
				if (needr < 0.01) break;
				needr = Math.sqrt(needr);
				var needa:Number = Math.atan2(dx, dy);

				dx = m_PosX - cotl.m_PosX + (m_ZoneX - cotl.m_ZoneX) * SP.m_ZoneSize;
				dy = m_PosY - cotl.m_PosY + (m_ZoneY - cotl.m_ZoneY) * SP.m_ZoneSize;
				var curr:Number = dx * dx + dy * dy;
				if (curr < 0.01) break;
				curr = Math.sqrt(curr);
				var cura:Number = Math.atan2(dx, dy);

				dd = needr - curr;
				curr += dd * k;

				dd = BaseMath.AngleDist(cura, needa);
				cura = BaseMath.AngleNorm(cura + dd * k);

				//m_ZoneX = cotl.m_ZoneX;
				//m_ZoneY = cotl.m_ZoneY;
				m_PosX = cotl.m_PosX + Math.sin(cura) * curr + (cotl.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				m_PosY = cotl.m_PosY + Math.cos(cura) * curr + (cotl.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;

				dd = BaseMath.AngleDist(m_Angle, BaseMath.AngleNorm(needa + (Space.pi * 0.5)));
				m_Angle = BaseMath.AngleNorm(m_Angle + dd * k);

				break;
			}

			dd = m_ServerPosZ - m_PosZ;
			m_PosZ += dd * k;

		} else {
			// Приближаем линейно
			dx = m_ServerPosX - m_PosX + (m_ServerZoneX - m_ZoneX) * SP.m_ZoneSize;
			dy = m_ServerPosY - m_PosY + (m_ServerZoneY - m_ZoneY) * SP.m_ZoneSize;
			dz = m_ServerPosZ - m_PosZ;
			dd = dx * dx + dy * dy + dz * dz;
			if (dd < 1.0)  return;
			//dd = Math.sqrt(dd);
			m_PosX += dx*k;
			m_PosY += dy*k;
			m_PosZ += dz*k;

			dd = BaseMath.AngleDist(m_Angle, m_ServerAngle);
			m_Angle = BaseMath.AngleNorm(m_Angle + dd * k);
		}
	}
	
	[Inline] public static function CalcAnglePitchRoll(dir:Vector3D, up:Vector3D, out_angle_pitch_roll:Vector3D):void
	{
		out_angle_pitch_roll.x = Math.atan2(dir.x, dir.y); // angle
		out_angle_pitch_roll.y = Math.atan2(dir.z, Math.sqrt(dir.x * dir.x + dir.y * dir.y)); // pitch

		var cosx:Number = Math.cos( -out_angle_pitch_roll.y);
		var sinx:Number = Math.sin( -out_angle_pitch_roll.y);
		var cosz:Number = Math.cos( out_angle_pitch_roll.x);
		var sinz:Number = Math.sin( out_angle_pitch_roll.x);

		var x:Number = up.x * cosz - up.y * sinz;
		var z:Number = up.x * sinx * sinz + up.y * sinx * cosz + up.z * cosx;

		out_angle_pitch_roll.z = Math.atan2(x, z); // roll
	}

	private static var dcpDir:Vector3D = new Vector3D();
	private static var dcpUp:Vector3D = new Vector3D();
	private static var dcWorld:Matrix3D = new Matrix3D();
	public function DockCalcPos(t:Number, add_posx:Number, add_posy:Number, add_posz:Number, port:uint, undock:Boolean, out_pos:Vector3D, out_angle_pitch_roll:Vector3D):void
	{
		var v:Vector3D;
		var spath:SpacePath = OrderDockPath(port, undock);
		
		if(t>=0) {
			spath.Get(t, out_pos, dcpDir, dcpUp);
		} else {
			spath.Get(0.0, out_pos, dcpDir, dcpUp);
			out_pos.x += dcpDir.x * t;
			out_pos.y += dcpDir.y * t;
			out_pos.z += dcpDir.z * t;
			t = 0.0;
		}
		
		out_pos.x += add_posx;
		out_pos.y += add_posy;
		out_pos.z += add_posz;
		
		C3D.CalcMatrixShipOri(dcWorld, m_Angle, m_Pitch, m_Roll);

		v = dcWorld.transformVector(out_pos);
		out_pos.x = v.x + m_PosX;
		out_pos.y = v.y + m_PosY;
		out_pos.z = v.z + m_PosZ;

		if (out_angle_pitch_roll) {
			v = dcWorld.deltaTransformVector(dcpDir);
			dcpDir.x = v.x;
			dcpDir.y = v.y;
			dcpDir.z = v.z;

			v = dcWorld.deltaTransformVector(dcpUp);
			dcpUp.x = v.x;
			dcpUp.y = v.y;
			dcpUp.z = v.z;
			
			CalcAnglePitchRoll(dcpDir,dcpUp,out_angle_pitch_roll);
		}
	}
	
	public function OrderDockPath(port:uint, undock:Boolean):SpacePath
	{
		var connect:uint = 0;
		switch(port) {
			case 0: connect = undock?SpacePath.ConnectUndock0:SpacePath.ConnectDock0; break;
			case 1: connect = undock?SpacePath.ConnectUndock1:SpacePath.ConnectDock1; break;
			case 2: connect = undock?SpacePath.ConnectUndock2:SpacePath.ConnectDock2; break;
			case 3: connect = undock?SpacePath.ConnectUndock3:SpacePath.ConnectDock3; break;
			case 4: connect = undock?SpacePath.ConnectUndock4:SpacePath.ConnectDock4; break;
			default: throw Error("");
		}
		return SpacePath.GetPath(gstShip1, connect);
	}
	
	public function DockPathLen(port:uint, undock:Boolean):Number
	{
		return OrderDockPath(port, undock).m_Length;
	}

}

}
