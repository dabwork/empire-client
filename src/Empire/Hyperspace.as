// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import B3DEffect.*;
import Base3D.Bos;
import Base3D.BosObj;
import fl.controls.*;
import flash.display3D.textures.Texture;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

import flash.display3D.*;
import com.adobe.utils.PerspectiveMatrix3D;

public class Hyperspace extends HyperspaceBase
{
//	static public var Self:Hyperspace = null;
	public var EM:EmpireMap = null;

	private const ZoneStaticUpdatePeriod:int = 4000;
	private const ZoneDynamicUpdatePeriod:int = 1000;
	private const SpaceDynamicUpdatePeriod:int = 1000;

	static public const FollowNone:int = 0;
	static public const FollowHomeworld:int = 1;
	static public const FollowCitadel:int = 2; 
	static public const FollowFleet:int = 3;

//	private var m_Map:EmpireMap;

	public var m_SizeX:int = 100;
	public var m_SizeY:int = 100;

	//public var m_OffsetX:Number = 0;
	//public var m_OffsetY:Number = 0;
	
	public var m_ScrollLeft:Boolean=false;
	public var m_ScrollRight:Boolean=false;
	public var m_ScrollUp:Boolean=false;
	public var m_ScrollDown:Boolean=false;

	public var m_Float:Boolean = false;
	public var m_FloatBegin:Boolean = false;

	public var m_MousePosOldX:int = 0;
	public var m_MousePosOldY:int = 0;

	public var m_MenuWorldX:int = 0;
	public var m_MenuWorldY:int = 0;

	public var m_ZoneStaticWaitAnswer:Number = 0;
	public var m_ZoneDynamicWaitAnswer:Number = 0;
	public var m_SpaceDynamicWaitAnswer:Number = 0;
	public var m_SpaceDynamicQueryPosTime:Number = 0;
	public var m_SpaceDynamicQueryNearTime:Number = 0;

	public var m_ZoneList:Vector.<Zone> = new Vector.<Zone>();
	public var m_ZoneQueryTimer:Number = 0;
	public var m_ZoneQueryX:int = 0;
	public var m_ZoneQueryY:int = 0;

	//public var m_CotlAll:Vector.<SpaceCotl> = new Vector.<SpaceCotl>();

	public var m_MouseEntityType:uint = 0;
	public var m_MouseEntityId:uint = 0;
//	public var m_PlanetMouse:uint = 0;
//	public var m_CotlMouse:uint = 0;
	public var m_CotlEdit:uint = 0;
	public var m_CotlMove:Boolean = false;
	public var m_CotlOldPosX:Number = 0;
	public var m_CotlOldPosY:Number = 0;
	
	public var m_FleetMouse:uint = 0;

	public var m_SynLast:Number = 0;

	//var m_FleetOldSend_TgtX:int=-2000000000;
	//var m_FleetOldSend_TgtY:int=-2000000000;
	//var m_FleetOldSend_State:int=-1;
//	public var m_FleetMove_NeedSend:Boolean = false;
//	public var m_FleetMove_SendTime:Number = 0;
//	public var m_FleetMove_TimeChange:Number = 0;
//	public var m_FleetMove_Ano:uint = 0;

	public var m_CenterZoneX:int = 0;
	public var m_CenterZoneY:int = 0;
	public var m_CenterX:Number = 0;
	public var m_CenterY:Number = 0;
	public var m_CenterType:int = FollowFleet;
	public var m_CenterId:uint = 0;

	public var m_FollowType:int = FollowFleet;
	public var m_FollowId:uint = 0;

	public var m_RadarUpdateTime:Number = 0;

	public var m_SelectRadius:Number = 0.0;

	public var m_LoadActionAfterAno:uint = 0;
	public var m_LoadActionAfterAno_Time:Number = 0;

	public var m_MoveToX:Number = 0;
	public var m_MoveToY:Number = 0;

	public var m_Anm:uint = 0;

	//public var m_SendTimer:Timer = new Timer(300);

	public var m_ProcessTaktLast:Number = 0;

	public var m_OrderMove_Time:Number = 0;
	public var m_OrderForType:uint = 0;
	public var m_OrderForId:uint = 0;
	public var m_Order:uint = 0;
	public var m_OrderEntityType:uint = 0;
	public var m_OrderId:uint = 0;
	public var m_OrderDist:int = 0;
	public var m_OrderAngle:uint = 0;
	public var m_OrderFlag:uint = 0;
	public var m_OrderMove_X:int = 0;
	public var m_OrderMove_Y:int = 0;

	public var m_LoadCotl_Timer:Number = 0;

	public var m_WaitRecvFull:Boolean = false;
	
	public var m_Work:Boolean = false;
	
	//public function get EM():SiteMap { return SiteMap.Self; }
	
	public function Hyperspace(em:EmpireMap, sp:Space)
	{
//		m_Map = map;
//		Self = this;
		super(sp);
		EM = em;

		//m_SendTimer.addEventListener("timer", SendTimer);

		EM.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
//		EM.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false);
//		EM.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false);
//		EM.stage.addEventListener(MouseEvent.DOUBLE_CLICK, MouseDblClick);

	}

	public function ConnectClose():void
	{
		var i:int=0;
		var zone:Zone;
		for(i=0;i<m_ZoneList.length;i++) {
			zone=m_ZoneList[i];
			//zone.m_CotlList.length=0;
		}
		m_ZoneList.length=0;

//		m_FleetMove_NeedSend=false;
//		m_FleetMove_SendTime=0;
//		m_FleetMove_TimeChange = 0;
//		m_FleetMove_Ano = 0;

		m_LoadActionAfterAno = 0;
		m_LoadActionAfterAno_Time = 0;

		//m_SendTimer.stop();

		if(visible) Hide();
	}
	
	public function StageResize():void 
	{
		if (!visible) return;// && EM.IsResize()) {
		m_SizeX = stage.stageWidth;
		m_SizeY = stage.stageHeight;

			//m_MatPer.perspectiveFieldOfViewRH(m_Fov, Number(EM.stage.stageWidth) / EM.stage.stageHeight, 1.0, 10000.0);
	}

	public function onDeactivate(e:Event):void
	{
		m_ScrollLeft = false;
		m_ScrollRight = false;
		m_ScrollUp = false;
		m_ScrollDown = false;
		m_Float = false;
		MouseUnlock();
	}

	public function Run():void
	{
		//m_SendTimer.start();
	}

	public function ClearForNewConn():void
	{
		var i:int=0;
		var zone:Zone;
		for(i=0;i<m_ZoneList.length;i++) {
			zone=m_ZoneList[i];
			//zone.m_VersionStatic=0;
		}
		m_ZoneList.length = 0;
		m_LoadActionAfterAno = 0;
		m_LoadActionAfterAno_Time = 0;
		//m_SendTimer.stop();
	}
	
	public function WaitRecvFull():void
	{
		if (!visible) return;
		m_WaitRecvFull = true;
		m_SpaceDynamicQueryNearTime = 0;
		m_SpaceDynamicQueryPosTime = 0;
	}

	public function Show():void
	{
		visible = true;
		
		if (!m_Work) {
//trace("Space work on");
//trace("WaitRecvFull=true");
			m_ProcessTaktLast = EM.m_CurTime;
			m_WaitRecvFull = true;
			m_Work = true;
			m_SpaceDynamicQueryNearTime = 0;
			m_SpaceDynamicQueryPosTime = 0;
		}

		EM.m_StateSector = false;
		EM.m_StateEnterCotl = false;

		m_MouseEntityType = 0;
		m_MouseEntityId = 0;

		m_SizeX = stage.stageWidth;
		m_SizeY = stage.stageHeight;

		//m_MatPer.perspectiveFieldOfViewRH(m_Fov, Number(EM.stage.stageWidth) / EM.stage.stageHeight, 1.0, 10000.0);

		m_BG.NeedUpdate();

		//EM.m_FormMiniMap.Hide();
		EM.m_BG.visible=false;
		//EM.m_FormRadar.Show();

		x = 0;
		y = 0;

		var ent:SpaceEntity = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId, false);
		if(ent==null) {
			ent = SP.EntityAdd(SpaceEntity.TypeFleet, EM.m_RootFleetId);
			var ship:SpaceShip = ent as SpaceShip;
			ship.m_ZoneX = SP.m_ZoneMinX + Math.floor((EM.m_FleetPosX - SP.m_ZoneMinX * SP.m_ZoneSize) / SP.m_ZoneSize);
			ship.m_ZoneY = SP.m_ZoneMinY + Math.floor((EM.m_FleetPosY - SP.m_ZoneMinY * SP.m_ZoneSize) / SP.m_ZoneSize);
			ship.m_PosX = EM.m_FleetPosX - ent.m_ZoneX * SP.m_ZoneSize;
			ship.m_PosY = EM.m_FleetPosY - ent.m_ZoneY * SP.m_ZoneSize;
			ship.m_PosZ = 0.0;
			ship.m_ServerZoneX = ship.m_ZoneX;
			ship.m_ServerZoneY = ship.m_ZoneY;
			ship.m_ServerPosX = ship.m_PosX;
			ship.m_ServerPosY = ship.m_PosY;
			ship.m_ServerPosZ = ship.m_PosZ;
			ship.m_PlaceX = ship.m_PosX;
			ship.m_PlaceY = ship.m_PosY;
			ship.m_PlaceZ = ship.m_PosZ;

			m_CamZoneX = ship.m_ZoneX;
			m_CamZoneY = ship.m_ZoneY;
			m_CamPos.x = ship.m_PosX;
			m_CamPos.y = ship.m_PosY;
			m_CamPos.z = 0;// ship.m_PosZ;
		}
	}

	public function Hide():void
	{
		m_ScrollLeft = false;
		m_ScrollRight = false;
		m_ScrollUp = false;
		m_ScrollDown = false;

		m_Float = false;

		FleetLayerClear();
		EM.m_FormHist.Hide();
		EM.m_FormStorage.Hide();
		//EM.m_FormRadar.Hide();
		//EM.m_FormMiniMap.Show();
		EM.m_BG.visible=true;
		visible = false;
		MouseUnlock();
	}
	
	public function SetCenterType(v:int, id:uint = 0):void
	{
		if (m_CenterType == v && m_CenterId == id) return;
		m_CenterType = v;
		m_CenterId = id;
		WaitRecvFull();
	}

	public function SetFollowType(v:int, id:uint = 0):void
	{
		if (m_FollowType == v && m_FollowId == id) return;
		m_FollowType = v;
		m_FollowId = id;
		WaitRecvFull();
	}
	
	public function SetFollowNone(wx:Number, wy:Number):void
	{
		m_FollowType = FollowNone;
		m_CamZoneX = Math.floor(wx / m_ZoneSize);
		m_CamZoneY = Math.floor(wy / m_ZoneSize);
		m_CamPos.x = wx - m_ZoneSize * m_CamZoneX;
		m_CamPos.y = wy - m_ZoneSize * m_CamZoneY;
	}
	
/*	public function FleetFollow(...args):void
	{
		var ignore_stealth:Boolean = true;
		if ((args.length > 0) && (args[0] is Boolean)) ignore_stealth = args[0];

		var fleetid:uint = m_FleetMouse;
		if (fleetid == EM.m_RootFleetId) return;

		var hf:HyperspaceFleet=HyperspaceFleetById(EM.m_RootFleetId);
		if (hf == null) return;

		var fleet:FleetDyn = FleetDynById(EM.m_RootFleetId);
		if (fleet == null) return;

		var hfto:HyperspaceFleet = HyperspaceFleetById(fleetid);
		if (hfto == null) return;

		var dist:Number = Math.sqrt((hf.m_X - hfto.m_X) * (hf.m_X - hfto.m_X) + (hf.m_Y - hfto.m_Y) * (hf.m_Y - hfto.m_Y));
		var stepcnt:int = Math.ceil(dist / Common.FuelConsumptionStep);
		var nf:int = stepcnt * Common.FleetFuelConsumption[EM.m_FormFleetBar.m_Formation & 7];
		
		if (hf.m_TargetType == Common.FleetActionCombat) {
			EM.m_FormHint.Show(Common.Txt.WarningNoMoveFleetInCombat, Common.WarningHideTime);
			return;

		} else if (nf > EM.m_FormFleetBar.m_FleetFuel) {
			var str:String = Common.Txt.WarningNeedMoreFuelForFly;
			str = BaseStr.Replace(str, "<Val>", nf.toString());
			EM.m_FormHint.Show(str, Common.WarningHideTime);

		} else if ((hf.m_TargetType == Common.FleetActionStealth || hf.m_TargetType == Common.FleetActionJump) && !ignore_stealth) {
//			FormMessageBox.Run("[justify]" + Common.Txt.FormHyperspaceQueryStealthOff + "[/justify]", Common.Txt.FormHyperspaceButStealthCancel, Common.Txt.FormHyperspaceButStealthOff, FleetFollow);

		} else {
			hf.m_TargetX = hfto.m_X;
			hf.m_TargetY = hfto.m_Y;
			hf.m_TargetType = Common.FleetActionFollow;
			hf.m_TargetId = fleetid;

			hf.m_OldTargetX = hf.m_TargetX;
			hf.m_OldTargetY = hf.m_TargetY;

			fleet.m_TgtX = hf.m_TargetX;
			fleet.m_TgtY = hf.m_TargetY;
			fleet.m_TgtId = hf.m_TargetType;
			fleet.m_Action = hf.m_TargetType;
			fleet.m_PosTime = EM.GetServerTime();

//			var fd:FleetDyn=FleetDynById(EM.m_RootFleetId);
//			if (fd != null) fd.m_Action = Common.FleetActionFollow;

			m_FleetMove_NeedSend=true;
			m_FleetMove_TimeChange=Common.GetTime();
			m_FleetMove_Ano = Math.max(m_LoadActionAfterAno, fleet.m_Ano) + 1;

			m_LoadActionAfterAno = m_FleetMove_Ano;
			m_LoadActionAfterAno_Time = Common.GetTime();

			EM.m_FormRadar.Update();
		}
	}
	
	public function FleetAttack():void
	{
		var fleetid:uint = m_FleetMouse;
		if (fleetid == EM.m_RootFleetId) return;

		var hf:HyperspaceFleet=HyperspaceFleetById(EM.m_RootFleetId);
		if (hf == null) return;

		var fleet:FleetDyn = FleetDynById(EM.m_RootFleetId);
		if (fleet == null) return;

		var hfto:HyperspaceFleet = HyperspaceFleetById(fleetid);
		if (hfto == null) return;

		var dist:Number = Math.sqrt((hf.m_X - hfto.m_X) * (hf.m_X - hfto.m_X) + (hf.m_Y - hfto.m_Y) * (hf.m_Y - hfto.m_Y));
		var stepcnt:int = Math.ceil(dist / Common.FuelConsumptionStep);
		var nf:int = stepcnt * Common.FleetFuelConsumption[EM.m_FormFleetBar.m_Formation & 7];
		
		if (hf.m_TargetType == Common.FleetActionCombat) {
			EM.m_FormHint.Show(Common.Txt.WarningNoMoveFleetInCombat, Common.WarningHideTime);
			return;

		} else if (hfto.m_TargetType==Common.FleetActionStealth || hfto.m_TargetType==Common.FleetActionJump) {
			EM.m_FormHint.Show(Common.Txt.WarningNoAttackFleetInStealth, Common.WarningHideTime);
			return;

		} else if (nf > EM.m_FormFleetBar.m_FleetFuel) {
			var str:String = Common.Txt.WarningNeedMoreFuelForFly;
			str = BaseStr.Replace(str, "<Val>", nf.toString());
			EM.m_FormHint.Show(str, Common.WarningHideTime);

		} else {
			hf.m_TargetX = hfto.m_X;
			hf.m_TargetY = hfto.m_Y;
			hf.m_TargetType = Common.FleetActionAttack;
			hf.m_TargetId = fleetid;

			hf.m_OldTargetX = hf.m_TargetX;
			hf.m_OldTargetY = hf.m_TargetY;

			fleet.m_TgtX = hf.m_TargetX;
			fleet.m_TgtY = hf.m_TargetY;
			fleet.m_TgtId = hf.m_TargetType;
			fleet.m_Action = hf.m_TargetType;
			fleet.m_PosTime = EM.GetServerTime();

			m_FleetMove_NeedSend=true;
			m_FleetMove_TimeChange=Common.GetTime();
			m_FleetMove_Ano = Math.max(m_LoadActionAfterAno, fleet.m_Ano) + 1;

			m_LoadActionAfterAno = m_FleetMove_Ano;
			m_LoadActionAfterAno_Time = Common.GetTime();

			EM.m_FormRadar.Update();
		}
	}

	public function FleetMoveTo(...args):void
	{
		var ignore_stealth:Boolean = true;
		if ((args.length > 0) && (args[0] is Boolean)) ignore_stealth = args[0];
		
		var x:Number = m_MoveToX;
		var y:Number = m_MoveToY;
		var fleet:FleetDyn = FleetDynById(EM.m_RootFleetId);
		if (fleet == null) return;
		
		var hf:HyperspaceFleet=HyperspaceFleetById(EM.m_RootFleetId);
		if (hf == null) return;
		
		var dist:Number = Math.sqrt((hf.m_X - x) * (hf.m_X - x) + (hf.m_Y - y) * (hf.m_Y - y));
		var stepcnt:int = Math.ceil(dist / Common.FuelConsumptionStep);
		var nf:int = stepcnt * Common.FleetFuelConsumption[EM.m_FormFleetBar.m_Formation & 7];
		
//			if(EM.m_FormFleetBar.m_FleetFuel<=0) {
//				EM.m_FormHint.Show(Common.Txt.WarningNoFuel, Common.WarningHideTime);
		if (hf.m_TargetType == Common.FleetActionCombat) {
			EM.m_FormHint.Show(Common.Txt.WarningNoMoveFleetInCombat, Common.WarningHideTime);
			return;

		} else if (nf > EM.m_FormFleetBar.m_FleetFuel) {
			var str:String = Common.Txt.WarningNeedMoreFuelForFly;
			str = BaseStr.Replace(str, "<Val>", nf.toString());
			EM.m_FormHint.Show(str, Common.WarningHideTime);

		} else if ((hf.m_TargetType == Common.FleetActionStealth || hf.m_TargetType == Common.FleetActionJump) && !ignore_stealth) {
			FormMessageBox.Run("[justify]"+Common.Txt.FormHyperspaceQueryStealthOff+"[/justify]", Common.Txt.FormHyperspaceButStealthCancel, Common.Txt.FormHyperspaceButStealthOff, FleetMoveTo);

		} else {
			hf.m_TargetX = x;
			hf.m_TargetY = y;
//trace("A",hf.m_TargetX,hf.m_TargetY);
			hf.m_TargetType=Common.FleetActionMove;
			hf.m_TargetId = 0;

			hf.m_OldTargetX=hf.m_TargetX;
			hf.m_OldTargetY=hf.m_TargetY;

			fleet.m_TgtX = hf.m_TargetX;
			fleet.m_TgtY = hf.m_TargetY;
			fleet.m_TgtId = hf.m_TargetType;
			fleet.m_Action = hf.m_TargetType;
			fleet.m_PosTime = EM.GetServerTime();

			//var fd:FleetDyn=FleetDynById(EM.m_RootFleetId);
			//if (fd != null) fd.m_Action = Common.FleetActionMove;

			//Server.Self.Query("emfleetmove","&val="+x.toString()+"_"+y.toString(),AnswerSendMove,false);

			m_FleetMove_NeedSend=true;
			m_FleetMove_TimeChange=Common.GetTime();
			m_FleetMove_Ano = Math.max(m_LoadActionAfterAno, fleet.m_Ano) + 1;

			m_LoadActionAfterAno = m_FleetMove_Ano;
			m_LoadActionAfterAno_Time = Common.GetTime();

			EM.m_FormRadar.Update();
		}
	}*/

	private var m_MouseLock:Boolean = false;
	
	public function MouseLock():void
	{
		if (m_MouseLock) return;
		m_MouseLock = true;
		EM.MouseLock();

//		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,999);
//		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,999);
//		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);
//		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
//		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
//		stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,true,999);

//		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 999);
//		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
//		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
//		stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,true,999);

	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;
		EM.MouseUnlock();
		
//		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
//		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
//		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
//		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
//		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
//		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);

//		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
//		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
//		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
//		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
	}

	public function MouseDblClick(e:MouseEvent=null):void
	{
		if (!visible) return;

//		if (m_FleetMouse != 0 && m_FleetMouse != EM.m_RootFleetId) {
//			var hf:HyperspaceFleet=HyperspaceFleetById(EM.m_RootFleetId);
//			if (hf != null && hf.m_TargetType != Common.FleetActionCombat) {
//				FormMessageBox.Run(Common.Txt.FormHyperspaceAttackQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, FleetAttack);
//			}
//		} else 
		if (m_MouseEntityType==SpaceEntity.TypePlanet && (EM.IsEdit() || m_MouseEntityId != Server.Self.m_CotlId) && GetCotl(m_MouseEntityId) != null) {
			//EM.m_GoCotlId=0; EM.m_GoSectorX=0; EM.m_GoSectorY=0; EM.m_GoPlanet=-1; EM.m_GoShipNum=-1; EM.m_GoShipId=0;
			//EM.m_GoOpen=true;
			EM.GoTo(false, m_MouseEntityId);
			//EM.ChangeCotlServerSimple(m_CotlMouse);
			//if(EM.ChangeCotlServer(m_CotlMouse)) {
			//	Hide();
			//}
		} else if(m_MouseEntityType==SpaceEntity.TypePlanet && m_MouseEntityId==Server.Self.m_CotlId) {
			Hide();

		} else {
			onMouseDown(e);
		}
	}

	public var m_LastDownTime:Number = 0;

	public function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

		stage.focus = EM;

//		var cotl:Cotl;
		var cotl:SpaceCotl;
		var planet:SpacePlanet;

		if (FormMessageBox.Self.visible) return;

		if ((m_LastDownTime + StdMap.DblClickTime > EM.m_CurTime) && m_MouseEntityType==SpaceEntity.TypePlanet) {
			m_LastDownTime = EM.m_CurTime;
			
			planet = SP.EntityFind(m_MouseEntityType, m_MouseEntityId) as SpacePlanet;
			if (planet != null) {
				cotl = SP.EntityFind(SpaceEntity.TypeCotl, planet.m_CotlId) as SpaceCotl;
				if (cotl != null) {
					if ((EM.IsEdit() || cotl.m_Id != Server.Self.m_CotlId)) {
						EM.GoTo(false, cotl.m_Id);
						return;
					} else if (cotl.m_Id == Server.Self.m_CotlId) {
						Hide();
						return;
					}
				}
			}

		} else if ((m_LastDownTime + StdMap.DblClickTime > EM.m_CurTime) && m_MouseEntityType==0) {
			m_LastDownTime = EM.m_CurTime;

			if (StyleManager.m_EditId.length > 0 && StyleManager.m_Map[StyleManager.m_EditId] != undefined) {
				PickWorldCoord(mouseX, mouseY, m_TPos);
				
				if (m_TestEffect != null) { m_TestEffect.Clear(); m_TestEffect = null; }

				m_TestEffect = new Effect();
				m_TestEffect.SetPos(m_TPos.x - (m_CamPos.x + m_CamZoneX * SP.m_ZoneSize), m_TPos.y - (m_CamPos.y + m_CamZoneY * SP.m_ZoneSize), m_TPos.z - m_CamPos.z);
				m_TestEffect.SetDir(1.0, 0.0, 0.0);
				m_TestEffect.SetPathDist(1000.0);
				m_TestEffect.SetNormal(0.0, 0.0, 1.0, 0.0, 1.0, 0.0);
				m_TestEffect.Run(StyleManager.m_EditId);

				return;
			}
		}
		m_LastDownTime = EM.m_CurTime;

		if(EM.m_FormInput.visible) return;

		//if(!addkey) {
			m_Float = true;
			m_FloatBegin = false;
			m_MousePosOldX = mouseX;
			m_MousePosOldY = mouseY;
			MouseLock();
		//}
	}

	public function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

		//var cotl:Cotl;
		var cotl:SpaceCotl;
		var planet:SpacePlanet;
		var fleet:SpaceFleet;
		var cont:SpaceContainer;
		var shu:SpaceShuttle;

		if(EM.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;

		if (m_Float && m_FloatBegin) {
			m_Float = false;
			MouseUnlock();
			return;
		} else if(m_Float) {
			if (m_MouseEntityType == SpaceEntity.TypeFleet) {
				if (addkey) {
					fleet = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId) as SpaceFleet;
					if (fleet && EM.m_RootFleetId == m_MouseEntityId) {
						OrderDock(SpaceEntity.TypeShuttle, fleet.m_ShuttleId, SpaceEntity.TypeFleet, EM.m_RootFleetId, 1, 0);
					}

				} else if (EM.m_RootFleetId != m_MouseEntityId) {
					OrderTarget(SpaceEntity.TypeFleet, m_MouseEntityId);
				}
			
			} else if (m_MouseEntityType == 0) {
				//while (m_FollowType == FollowFleet) {
//						m_MoveToX = MapToWorldX(mouseX);
//						m_MoveToY = MapToWorldY(mouseY);
//						FleetMoveTo(false);

					if (PickWorldCoord(mouseX, mouseY, m_TPos)) {
						planet = PickPlanet(true);
						if (planet != null && GetOrbitPlanetId() == 0) {
							OrderOrbitPlanet(SpaceEntity.TypeFleet, EM.m_RootFleetId, Math.round(m_TPos.x), Math.round(m_TPos.y), planet.m_Id);
							//OrderFollow(SpaceEntity.TypeFleet, EM.m_RootFleetId, SpaceEntity.TypePlanet, planet.m_Id, 1000, 90.0 / 360.0 * 65536.0);
						} else {
							if (addkey) {
								fleet = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId) as SpaceFleet;
								if (fleet != null && fleet.m_ShuttleId != 0) OrderMoveEx(SpaceEntity.TypeShuttle, fleet.m_ShuttleId, Math.round(m_TPos.x), Math.round(m_TPos.y));
							} else {
								OrderMoveEx(SpaceEntity.TypeFleet, EM.m_RootFleetId, Math.round(m_TPos.x), Math.round(m_TPos.y));
							}
						}
					}
				//	break;
				//}
			} else if (m_MouseEntityType == SpaceEntity.TypePlanet) {
				planet = SP.EntityFind(m_MouseEntityType, m_MouseEntityId) as SpacePlanet;
				if (planet != null) {
					cotl = SP.EntityFind(SpaceEntity.TypeCotl, planet.m_CotlId) as SpaceCotl;
					if (cotl != null) {
//						if(addkey) {
//							EM.FormHideAll();
//							EM.m_FormHist.m_CotlId=cotl.m_Id;
//							EM.m_FormHist.Show();
//						} else {
							if (EM.m_FormStorage.visible) EM.m_FormStorage.Hide();
							EM.FormHideAll();
							EM.m_FormStorage.m_CotlId = cotl.m_Id;
							EM.m_FormStorage.tab = EM.m_FormStorage.tabDesc;
							EM.m_FormStorage.Show();
//						}
					}
				}
			} else if (m_MouseEntityType == SpaceEntity.TypeContainer) {
				cont = SP.EntityFind(m_MouseEntityType, m_MouseEntityId) as SpaceContainer;
				if (cont) Take(cont);
			}
/*				else {
					//cotl = EM.m_FormGalaxy.GetCotl(m_CotlMouse);
					scotl = SP.EntityFind(SpaceEntity.TypeCotl, m_CotlMouse) as SpaceCotl;
					if (scotl == null) {}
					else if (scotl.m_CotlType == Common.CotlTypeCombat && (scotl.m_CotlFlag & SpaceCotl.fTemplate) == 0 && scotl.m_UnionId != 0) {
						EM.m_FormCombat.ShowEx(scotl.m_UnionId);
					} else {
						EM.CloseForModal();
						EM.m_FormHist.m_CotlId=m_CotlMouse;
						EM.m_FormHist.Show();
					}
				}*/

			m_Float = false;
			MouseUnlock();
			return;
		} 
		if(m_CotlMove) {
			m_CotlMove = false;
			MouseUnlock();

//			cotl=EM.m_FormGalaxy.GetCotl(m_CotlMouse);
//			if(cotl!=null) {
////trace("emedcotlmove",cotl.m_X,cotl.m_Y);
//				Server.Self.Query("emedcotlmove",'&val='+cotl.m_Id.toString()+'_'+cotl.m_X.toString()+'_'+cotl.m_Y.toString(),SimpleRecv,false);
//				if(((m_CotlOldPosX-cotl.m_X)*(m_CotlOldPosX-cotl.m_X)+(m_CotlOldPosY-cotl.m_Y)*(m_CotlOldPosY-cotl.m_Y))>4) return;
//			}
		}
		if(addkey) {
			MenuEdit();
		}
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var cotl:SpaceCotl;
		var planet:SpacePlanet;
		var cont:SpaceContainer;
		var he:HyperspaceEntity;
		var hf:HyperspaceFleet;
		var hp:HyperspacePlanet;

		if(EM.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		var infohide:Boolean = true;
		
		var cursor:String = MouseCursor.AUTO;

		if(m_Float) {
			if(!m_FloatBegin && ((mouseX-m_MousePosOldX)*(mouseX-m_MousePosOldX)+(mouseY-m_MousePosOldY)*(mouseY-m_MousePosOldY))>4) {
				m_FloatBegin=true;
			}

			if(m_FloatBegin) {
//				SetCenter(m_OffsetX-MapToWorldR(mouseX-m_MousePosOldX),m_OffsetY-MapToWorldR(mouseY-m_MousePosOldY));

				m_MousePosOldX=mouseX;
				m_MousePosOldY=mouseY;
			}

		} else if(m_CotlMove) {
/*			cotl=EM.m_FormGalaxy.GetCotl(m_CotlMouse);
			if(cotl!=null) {
				cotl.m_X+=mouseX-m_MousePosOldX;
				cotl.m_Y+=mouseY-m_MousePosOldY;

				m_MousePosOldX=mouseX;
				m_MousePosOldY=mouseY;
			}*/
		} else {
			he = PickEntity();
			if (he==null) {
				if (m_MouseEntityType != 0) {
					m_MouseEntityType = 0;
					m_MouseEntityId = 0;
				}
			} else if (m_MouseEntityType != he.m_EntityType || m_MouseEntityId != he.m_Id) {
				m_MouseEntityType = he.m_EntityType;
				m_MouseEntityId = he.m_Id;
			}

			if (m_MouseEntityType == SpaceEntity.TypePlanet) {
				hp = he as HyperspacePlanet;
				
				planet = SP.EntityFind(m_MouseEntityType, he.m_Id) as SpacePlanet;
				if (planet != null) {
					cotl = SP.EntityFind(SpaceEntity.TypeCotl, planet.m_CotlId) as SpaceCotl;

					infohide = false;
					EM.m_Info.ShowCotlLive(planet, cotl, e.stageX, e.stageY, 10);
				}
			} else if (m_MouseEntityType == SpaceEntity.TypeContainer) {
				cont = SP.EntityFind(m_MouseEntityType, he.m_Id) as SpaceContainer;
				if (cont != null) {
					infohide = false;
					
					m_TPos.x = cont.m_PosX - m_CamPos.x + (cont.m_ZoneX - m_CamZoneX) * SP.m_ZoneSize;
					m_TPos.y = cont.m_PosY - m_CamPos.y + (cont.m_ZoneY - m_CamZoneY) * SP.m_ZoneSize;
					m_TPos.z = cont.m_PosZ - m_CamPos.z;
					WorldToScreen(m_TPos);

					if(CanTake(cont)) cursor = MouseCursor.HAND;
					EM.m_Info.ShowItemEx(cont, cont.m_ItemType, cont.m_ItemCnt, cont.m_Owner, 0, cont.m_Broken, Math.round(m_TPos.x - 10), Math.round(m_TPos.y - 10), 20, 20);
				}
			}
			
/*			if (he != null) {
				if(m_FleetMouse != hf.m_FleetId) {
					m_FleetMouse = hf.m_FleetId;
				}
				infohide=false;
				EM.m_Info.ShowFleet(m_FleetMouse);
			} else {
				if(m_FleetMouse!=0) {
					m_FleetMouse = 0;
				}
			}

			if (m_FleetMouse != 0) {
				m_PlanetMouse = 0;
				m_CotlMouse = 0;
			} else {
				planet = PickPlanet();
				if (planet != null && planet.m_CotlId != 0 && (SP.EntityFind(SpaceEntity.TypeCotl, planet.m_CotlId)) != null) {
					m_PlanetMouse = planet.m_Id;
					m_CotlMouse = planet.m_CotlId;
					cotl = SP.EntityFind(SpaceEntity.TypeCotl, planet.m_CotlId) as SpaceCotl;

					infohide = false;
					//m_TPos.x = planet.m_PosX - m_CamPos.x + (planet.m_ZoneX - m_CamZoneX) * SP.m_ZoneSize;
					//m_TPos.y = planet.m_PosY - m_CamPos.y + (planet.m_ZoneY - m_CamZoneY) * SP.m_ZoneSize;
					//m_TPos.z = planet.m_PosZ - m_CamPos.z;
					//WorldToScreen(m_TPos);
					EM.m_Info.ShowCotlLive(planet, cotl, e.stageX, e.stageY, 10);
				} else {
					m_PlanetMouse = 0;
					m_CotlMouse = 0;
				}
			}*/
		}

		Mouse.cursor = cursor;
		if(infohide) EM.m_Info.Hide();
	}

	public function onMouseWheelHandler(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		var d:int = e.delta;
		
		if (d < 0) {
			m_CamDistDir = 1;
			m_CamDistChangeTime = 0;
			CamDistChange();
			m_CamDistDir = 0;
		} else if (d > 0) {
			m_CamDistDir = -1;
			m_CamDistChangeTime = 0;
			CamDistChange();
			m_CamDistDir = 0;
		}
	}
	
	public function onKeyDownHandler(e:KeyboardEvent):void
	{
//trace(e.keyCode);
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

		if (StdMap.Main.IsFocusInput()) { 
		} else if (e.keyCode == 36) { // Home
			m_CamDistTo=CamDistDefault;

		} else if (e.keyCode == 35) { // End
			m_CamDistTo=CamDistMax;

		} else if (e.keyCode == 33) { // PageUp
			if (m_CamDistDir != -1) {
				m_CamDistDir = -1;
				m_CamDistChangeTime = 0;
				CamDistChange();
			}

		} else if (e.keyCode == 34) { // PageDown
			if (m_CamDistDir != 1) {
				m_CamDistDir = 1;
				m_CamDistChangeTime=0;
				CamDistChange();
			}

		} else if((e.keyCode==38 || e.keyCode==87) && !addkey) {
			m_ScrollUp=true;

		} else if((e.keyCode==40 || e.keyCode==83) && !addkey) {
			m_ScrollDown=true;

		} else if((e.keyCode==37 || e.keyCode==65) && !addkey) {
			m_ScrollLeft=true;

		} else if((e.keyCode==39 || e.keyCode==68) && !addkey) {
			m_ScrollRight = true;

		} else if (e.keyCode == 49 && e.shiftKey) { // Shift+1
			m_SysModify = 1;

		} else if (e.keyCode == 50 && e.shiftKey) { // Shift+2
			m_SysModify = 2;

		} else if (e.keyCode == 51 && e.shiftKey) { // shift+3
			m_SysModify = 3;
			
		} else if (e.keyCode == 83 && e.shiftKey) { // shift+S
			if (m_MouseEntityType == SpaceEntity.TypePlanet) {
				var hp:HyperspacePlanet = HyperspacePlanetById(m_MouseEntityId);
				if (hp != null && hp.m_Style != 0) {
					StdMap.Main.InfoHide();
					HyperspacePlanetStyle.Edit(hp.m_Style);
				}
			}

		} else if (e.keyCode == 69 && e.shiftKey) { // shift+E
			B3DEffect.StyleManager.Edit(B3DEffect.StyleManager.m_EditStyle);

		} else if ((e.keyCode == 38 || e.keyCode == 87)) {
			if (m_SysModify == 1) m_CamAngle += 1.0 * Space.ToRad;
			else if (m_SysModify == 2) m_LightAngle += 1.0 * Space.ToRad;
			else if (m_SysModify == 3) m_LightPlanetAngle += 1.0 * Space.ToRad;

		} else if((e.keyCode==40 || e.keyCode==83)) {
			if (m_SysModify == 1) m_CamAngle -= 1.0 * Space.ToRad;
			else if (m_SysModify == 2) m_LightAngle -= 1.0 * Space.ToRad;
			else if (m_SysModify == 3) m_LightPlanetAngle -= 1.0 * Space.ToRad;

		} else if((e.keyCode==37 || e.keyCode==65)) {
			if (m_SysModify == 1) m_CamRotate += 1.0 * Space.ToRad;
			else if (m_SysModify == 2) m_LightRotate += 1.0 * Space.ToRad;
			else if (m_SysModify == 3) m_LightPlanetRotate += 1.0 * Space.ToRad;

		} else if((e.keyCode==39 || e.keyCode==68)) {
			if (m_SysModify == 1) m_CamRotate -= 1.0 * Space.ToRad;
			else if (m_SysModify == 2) m_LightRotate -= 1.0 * Space.ToRad;
			else if (m_SysModify == 3) m_LightPlanetRotate -= 1.0 * Space.ToRad;

		} else if (e.keyCode == 72 && !EM.IsFocusInput()) { // H
			if (Hangar.Self.visible) {
				Hangar.Self.Hide();
				EM.ItfUpdate();
			} else {
				EM.FormHideAll();
				Hangar.Self.Show();
				EM.ItfUpdate();
			}
		}
	}

	public function onKeyUpHandler(e:KeyboardEvent):void
	{
		if (e.keyCode == 33) { // PageUp
			m_CamDistDir=0;

		} else if (e.keyCode == 34) { // PageDown
			m_CamDistDir=0;

		} else if(e.keyCode==38 || e.keyCode==87) {
			m_ScrollUp=false;

		} else if(e.keyCode==40 || e.keyCode==83) {
			m_ScrollDown=false;

		} else if(e.keyCode==37 || e.keyCode==65) {
			m_ScrollLeft=false;

		} else if(e.keyCode==39 || e.keyCode==68) {
			m_ScrollRight=false;
		}
	}

	public function CancelAction():void
	{
		m_Float=false;
		m_CotlMove = false;
		MouseUnlock();

//		if(visible)	Update();
	}
	
	public function UpdateSelect(radius:Number):void
	{
		var size:Number = 5;

		if (m_SelectRadius == radius) return;
		m_SelectRadius = radius;

		var tx:Number = 0;
		var ty:Number = 0;

		var gr:Graphics=m_SelectLayer.graphics;

		gr.lineStyle(1.5,0xffffff,1.0,true);

		gr.moveTo(tx-radius,ty-radius+size);
		gr.lineTo(tx-radius,ty-radius);
		gr.lineTo(tx-radius+size,ty-radius);
		
		gr.moveTo(tx+radius,ty-radius+size);
		gr.lineTo(tx+radius,ty-radius);
		gr.lineTo(tx+radius-size,ty-radius);
		
		gr.moveTo(tx-radius,ty+radius-size);
		gr.lineTo(tx-radius,ty+radius);
		gr.lineTo(tx-radius+size,ty+radius);
		
		gr.moveTo(tx+radius,ty+radius-size);
		gr.lineTo(tx+radius,ty+radius);
		gr.lineTo(tx + radius - size, ty + radius);
	}
	
	public function Takt():void
	{
		var dx:Number, dy:Number;
		
		if (m_LoadCotl && (EM.m_CurTime > (m_LoadCotl_Timer + 300))) LoadCotl();
		
		dx = 0;
		dy = 0;

		if(m_ScrollUp || m_ScrollDown || m_ScrollLeft || m_ScrollRight) {
			var step:int = Math.round(Math.min(stage.stageHeight, stage.stageWidth) / 30);

			if (m_ScrollUp) dy += step;
			if (m_ScrollDown) dy -= step;
			if (m_ScrollLeft) dx -= step;
			if (m_ScrollRight) dx += step;
		}

		if (dx != 0 || dy != 0) {
//			SetCenter(OffsetX+dx,OffsetY+dy);
			m_FollowType = FollowNone;

			var asin:Number = Math.sin(m_CamRotate);
			var acos:Number = Math.cos(m_CamRotate);

			var px:Number = dx * acos + dy * asin;
			var py:Number = -dx * asin + dy * acos;

			m_CamPos.x += px;
			while (m_CamPos.x < 0) { m_CamPos.x += m_ZoneSize; m_CamZoneX--; }
			while (m_CamPos.x >= m_ZoneSize) { m_CamPos.x -= m_ZoneSize; m_CamZoneX++; }
			m_CamPos.y += py;
			while (m_CamPos.y < 0) { m_CamPos.y += m_ZoneSize; m_CamZoneY--; }
			while (m_CamPos.y >= m_ZoneSize) { m_CamPos.y -= m_ZoneSize; m_CamZoneY++; }
		}

		if (m_Work && (visible==false) && (EM.m_CurTime > (m_DrawLast + 5000))) {
//trace("Space work off");
			SP.Clear();
			m_Work = false;
		}
		if (m_Work) {
			SpaceDynamicSend();
			Syn();
		}
		
		ForsageAccessClient();
	}

/*	public function GraphClear():void
	{
		var i:int;
		var hc:HyperspaceCotl;
		var hf:HyperspaceFleet;

		for (i = m_CotlList.length - 1; i >= 0; i--) {
			hc = m_CotlList[i];
			hc.Clear();
		}

		for (i = m_FleetList.length - 1; i >= 0; i--) {
			hf=m_FleetList[i];
			hf.Clear();
		}
	}*/
	
	public function DebugTextForShip(ship:SpaceShip):String
	{
		var str:String = "";
		str += "Order: " + ship.m_VerOrder;
		if (ship.m_Order == SpaceShip.soNone) str += " none";
		else if (ship.m_Order == SpaceShip.soMove) str += " move";
		else if (ship.m_Order == SpaceShip.soOrbitCotl) str += " orbitcotl";
		else if (ship.m_Order == SpaceShip.soOrbitPlanet) str += " orbitplanet";
		else if (ship.m_Order == SpaceShip.soFollow) str += " follow";
		else if (ship.m_Order == SpaceShip.soDock) str += " dock:" + ((ship.m_OrderFlag >> 16) & 255).toString();
		else str += " unknown";
		str += " " + ship.m_OrderFlag.toString(16);
		str += " " + ship.m_OrderTargetId.toString(10);
		str += "\n";
		
		str += "Pos:";
		if (ship.m_PFlag & SpaceShip.PFlagInOrbitCotl) str += " orbitcotl";
		if (ship.m_PFlag & SpaceShip.PFlagInOrbitPlanet) str += " orbitplanet";
		if (ship.m_PFlag & SpaceShip.PFlagInDock) str += " indock:" + ((ship.m_PFlag >> 16) & 255).toString();
		if (ship.m_PFlag & SpaceShip.PFlagUndock) str += " undock:" + ((ship.m_PFlag >> 16) & 255).toString();
		if (ship.m_PFlag & SpaceShip.PFlagToDock) str += " todock:" + ((ship.m_PFlag >> 16) & 255).toString();
		if (ship.m_PFlag & SpaceShip.PFlagStep0) str += " step0";
		if (ship.m_PFlag & SpaceShip.PFlagStep1) str += " step1";
		if (ship.m_PFlag & SpaceShip.PFlagStep2) str += " step2";
		if (ship.m_PFlag & SpaceShip.PFlagStep3) str += " step3";
		str += " " + Math.ceil(ship.m_PosX + ship.m_ZoneX * SP.m_ZoneSize).toString();
		str += " " + Math.ceil(ship.m_PosY + ship.m_ZoneY * SP.m_ZoneSize).toString();
		str += " " + Math.ceil(ship.m_PosZ).toString();
		str += "\n";
		
		str += "Server:";
		if (ship.m_ServerPFlag & SpaceShip.PFlagInOrbitCotl) str += " orbitcotl";
		if (ship.m_ServerPFlag & SpaceShip.PFlagInOrbitPlanet) str += " orbitplanet";
		if (ship.m_ServerPFlag & SpaceShip.PFlagInDock) str += " indock:" + ((ship.m_ServerPFlag >> 16) & 255).toString();
		if (ship.m_ServerPFlag & SpaceShip.PFlagUndock) str += " undock:" + ((ship.m_ServerPFlag >> 16) & 255).toString();
		if (ship.m_ServerPFlag & SpaceShip.PFlagToDock) str += " todock:" + ((ship.m_ServerPFlag >> 16) & 255).toString();
		if (ship.m_ServerPFlag & SpaceShip.PFlagStep0) str += " step0";
		if (ship.m_ServerPFlag & SpaceShip.PFlagStep1) str += " step1";
		if (ship.m_ServerPFlag & SpaceShip.PFlagStep2) str += " step2";
		if (ship.m_ServerPFlag & SpaceShip.PFlagStep3) str += " step3";
		str += "\n";

		str += "Corr: " + Math.round(ship.m_ServerCorrectionDist).toString();
		str += " f:" + Math.floor(ship.m_ServerCorrectionFactor * 100).toString();
		str += "\n";
		
		if (ship.m_DropId || ship.m_DropProgressId) {
			str += "Drop: " + ship.m_DropId.toString() + " " + ship.m_DropProgressId.toString() + "\n";
		}
		if (ship.m_TakeId || ship.m_TakeProgressId) {
			str += "Take: " + ship.m_TakeId.toString() + " " + ship.m_TakeProgressId.toString() + "\n";
		}
		return str;
	}
	
	public function Syn():void
	{
		var i:int, u:int;
		var str:String;
		var hc:HyperspaceCotl;
		var hp:HyperspacePlanet;
		var hf:HyperspaceFleet;
		var hs:HyperspaceShuttle;
		var hcont:HyperspaceContainer;
		var scotl:SpaceCotl;
		var splanet:SpacePlanet;
		var cont:SpaceContainer;
		var user:User;
		var zone:Zone=null;

		SendOrder();
		EM.m_FormRadar.GalaxyMapQuery();

		var ct:Number = EM.m_CurTime;// Common.GetTime();
		var dt:Number=ct-m_SynLast;
		if(dt>1000) dt=1000;
		m_SynLast = ct;
		
		var cnttakt:int = 0;

		if (m_WaitRecvFull) {
			m_ProcessTaktLast = ct;
		} else {
			if (m_ProcessTaktLast == 0) m_ProcessTaktLast = ct;
			else if((ct - m_ProcessTaktLast) > 100 * Space.MsecPerTakt) m_ProcessTaktLast = ct - 10 * Space.MsecPerTakt; // Space.TaktStep
			if ((ct - m_ProcessTaktLast) >= (Space.MsecPerTakt)) {
				cnttakt = Math.floor((ct - m_ProcessTaktLast) / (Space.MsecPerTakt));
				m_ProcessTaktLast = ct - ((ct - m_ProcessTaktLast) % (Space.MsecPerTakt));
				
				//while (cnttakt >= 10) {
				//	SP.Process(Space.TaktStep * 10);
				//	cnttakt -= 10;
				//}
				for (i = 0; i < cnttakt;i++) {
					SP.Process(Space.TaktStep);
				}
			}
		}
		
		if (cnttakt <= 0) return;
		
		var playerfleet:SpaceFleet = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId) as SpaceFleet;
		var playershuttle:SpaceShuttle = null;
		if (playerfleet) {
			playershuttle = SP.EntityFind(SpaceEntity.TypeShuttle, playerfleet.m_ShuttleId) as SpaceShuttle;
		}

		for(i=0;i<m_CotlList.length;i++) {
			hc = m_CotlList[i];
			hc.m_Tmp = 0;
		}

		for(i=0;i<m_PlanetList.length;i++) {
			hp = m_PlanetList[i];
			hp.m_Tmp = 0;
		}

		for(i=0;i<m_FleetList.length;i++) {
			hf=m_FleetList[i];
			hf.m_Tmp = 0;
		}

		for(i=0;i<m_ShuttleList.length;i++) {
			hs = m_ShuttleList[i];
			hs.m_Tmp = 0;
		}

		for(i=0;i<m_ContainerList.length;i++) {
			hcont = m_ContainerList[i];
			hcont.m_Tmp = 0;
		}

		var ent:SpaceEntity;
		var ship:SpaceShip;
		if (m_WaitRecvFull || !visible) { }
		else
		for (i = 0; i < SP.m_EntityList.length; i++) {
			ent = SP.m_EntityList[i];
			if (!ent.m_RecvFull) continue;
			if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				ship = ent as SpaceShip;

				for(u=0;u<m_FleetList.length;u++) {
					hf=m_FleetList[u];
					if(hf.m_Id==ship.m_Id) break;
				}
				if(u>=m_FleetList.length) {
					hf = new HyperspaceFleet(this);
					hf.m_EntityType = ent.m_EntityType;
					hf.m_Id = ship.m_Id;
					m_FleetList.push(hf);
					m_EntityList.push(hf);
				}

				hf.m_Tmp = 1;

				hf.SetFormation(1 & 7);

				str = "";
				user = UserList.Self.GetUser(ship.m_Owner);
				if (user != null) str = EM.Txt_CotlOwnerName(0, user.m_Id) + "\n";
				if (EM.m_Debug) str += DebugTextForShip(ship);
				hf.SetText(str);

				hf.Update(ship);

			} else if (ent.m_EntityType == SpaceEntity.TypeShuttle) {
				ship = ent as SpaceShip;

				for(u=0;u<m_ShuttleList.length;u++) {
					hs=m_ShuttleList[u];
					if (hs.m_Id == ship.m_Id) break;
				}
				if(u>=m_ShuttleList.length) {
					hs = new HyperspaceShuttle(this);
					hs.m_EntityType = ent.m_EntityType;
					hs.m_Id = ship.m_Id;
					m_ShuttleList.push(hs);
					m_EntityList.push(hs);

					hs.SetFormation();
				}

				hs.m_Tmp = 1;
				
				str = "";
				if (EM.m_Debug) {
					user = UserList.Self.GetUser(ship.m_Owner);
					if (user != null) str = EM.Txt_CotlOwnerName(0, user.m_Id) + "\n";
					str += DebugTextForShip(ship);
				}
				hs.SetText(str);
				
				hs.Update(ship);

			} else if (ent.m_EntityType == SpaceEntity.TypeCotl) {
				scotl = ent as SpaceCotl;

				for(u=0;u<m_CotlList.length;u++) {
					hc = m_CotlList[u];
					if (hc.m_CotlId == scotl.m_Id) break;
				}
				if(u>=m_CotlList.length) {
					hc = new HyperspaceCotl();
					hc.m_CotlId = scotl.m_Id;
					hc.PInit();
				}
				
				zone = GetZone(scotl.m_ZoneX, scotl.m_ZoneY);

				hc.m_Tmp = 1;

				user=null;
				if (scotl.m_CotlType == Common.CotlTypeUser) user = UserList.Self.GetUser(scotl.m_AccountId);

				str = EM.Txt_CotlName(scotl.m_Id);
				if (scotl.m_CotlType == Common.CotlTypeCombat) {
					str = Common.Txt.HyperspaceCotlCombat;
				} else if(str.length<=0 && scotl.m_CotlType==Common.CotlTypeUser) {
					if (user != null) str = EM.Txt_CotlOwnerName(0, user.m_Id);
				}
				str+="\n"

				if (user != null && zone != null) {
					if(zone.m_Lvl!=0 && !EM.TestRatingFlyCotl(scotl.m_AccountId,zone.m_Lvl)) {
						str += "<font color='#650e00'>" + user.m_Rating.toString() + "</font>\n";
					}
					//else str+="<font color='#136500'>"+user.m_Rating.toString()+"</font>";
				}

				if (user != null && user.m_ExitDate != 0) {
					str += Common.FormatPeriod((user.m_ExitDate-EM.GetServerGlobalTime()) / 1000) + "\n";
				}
				if(scotl.m_CotlType==Common.CotlTypeProtect) {
					if((scotl.m_TimeData & 0xffff0000)!=0) {
						if (scotl.m_RestartTime != 0 && (scotl.m_RestartTime * 1000 > EM.GetServerGlobalTime())) {
							str += "<font color='#00ff00'>" + Common.FormatPeriod((scotl.m_RestartTime * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>" + "\n";
						} else if (scotl.m_RestartTime != 0 && ((scotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 > EM.GetServerGlobalTime())) {
							str += "<font color='#ffff00'>" + Common.FormatPeriod(((scotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>" + "\n";
						} else {
							u = Common.CotlProtectCalcPeriod((scotl.m_TimeData >> 16) * 60, (scotl.m_TimeData & 0xffff) * 60, EM.GetServerDate());
							if(u>=0) {
								str += "<font color='#00ff00'>" + Common.FormatPeriod(u).toString() + "</font>" + "\n";
							} else {
								str += "<font color='#ffff00'>" + Common.FormatPeriod( -u).toString() + "</font>" + "\n";
							}
						}

					} else {
						if (scotl.m_RestartTime != 0 && (scotl.m_RestartTime * 1000 > EM.GetServerGlobalTime())) {
							str += "<font color='#00ff00'>" + Common.FormatPeriod((scotl.m_RestartTime * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>" + "/n";
						} else if (scotl.m_RestartTime != 0 && ((scotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 > EM.GetServerGlobalTime())) {
							str += "<font color='#ffff00'>" + Common.FormatPeriod(((scotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>" + "/n";
						} else if (scotl.m_ServerAdr != 0) {
							str += "<font color='#00ff00'>∞</font>";
						}
					}
				}
//trace(str);
				hc.SetText(str);
				
				hc.Update(scotl);
				
			} else if (ent.m_EntityType == SpaceEntity.TypePlanet) {
				splanet = ent as SpacePlanet;

				for(u=0;u<m_PlanetList.length;u++) {
					hp = m_PlanetList[u];
					if (hp.m_Id == splanet.m_Id) break;
				}
				if(u>=m_PlanetList.length) {
					hp = new HyperspacePlanet(this);
					hp.m_EntityType = ent.m_EntityType;
					hp.m_Id = splanet.m_Id;
					m_PlanetList.push(hp);
					m_EntityList.push(hp);
				}

//				zone = GetZone(splanet.m_ZoneX, splanet.m_ZoneY);

				hp.m_Tmp = 1;

				hp.Syn(splanet);

			} else if (ent.m_EntityType == SpaceEntity.TypeContainer) {
				cont = ent as SpaceContainer;

				for(u=0;u<m_ContainerList.length;u++) {
					hcont=m_ContainerList[u];
					if (hcont.m_Id == cont.m_Id) break;
				}
				if(u>=m_ContainerList.length) {
					hcont = new HyperspaceContainer(this);
					hcont.m_EntityType = ent.m_EntityType;
					hcont.m_Id = cont.m_Id;
					m_ContainerList.push(hcont);
					m_EntityList.push(hcont);

					hcont.SetFormation();
				}

				hcont.m_Tmp = 1;
				
				hcont.Update(cont, playershuttle);
			}
		}

		for (i = m_CotlList.length - 1; i >= 0; i--) {
			hc = m_CotlList[i];
			if(hc.m_Tmp==0) {
				hc.Clear();
			}
		}

		for (i = m_PlanetList.length - 1; i >= 0; i--) {
			hp = m_PlanetList[i];
			if(hp.m_Tmp==0) {
				hp.Clear();
				
				m_PlanetList.splice(i, 1);
				u = m_EntityList.indexOf(hp);
				if (u >= 0) m_EntityList.splice(u, 1);
			}
		}

		for (i = m_FleetList.length - 1; i >= 0; i--) {
			hf = m_FleetList[i];
			if(hf.m_Tmp==0) {
				hf.Clear();

				m_FleetList.splice(i, 1);
				u = m_EntityList.indexOf(hf);
				if (u >= 0) m_EntityList.splice(u, 1);
			}
		}

		for (i = m_ShuttleList.length - 1; i >= 0; i--) {
			hs = m_ShuttleList[i];
			if(hs.m_Tmp==0) {
				hs.Clear();

				m_ShuttleList.splice(i, 1);
				u = m_EntityList.indexOf(hs);
				if (u >= 0) m_EntityList.splice(u, 1);
			}
		}

		for (i = m_ContainerList.length - 1; i >= 0; i--) {
			hcont = m_ContainerList[i];
			if(hcont.m_Tmp==0) {
				hcont.Clear();

				m_ContainerList.splice(i, 1);
				u = m_EntityList.indexOf(hcont);
				if (u >= 0) m_EntityList.splice(u, 1);
			}
		}
	}

	public var m_TestHalo:C3DHalo = null;
	public var m_TestTextLine:C3DTextLine = null;
	//public var m_TestCotl:HyperspaceCotl = null;
	
	public var m_HyperspaceEngine:HyperspaceEngine = null;
	
	public function FleetLayerClear():void
	{
		var i:int,u:int;
		var hf:HyperspaceFleet;
		for (i = m_FleetList.length - 1; i >= 0; i--) {
			hf=m_FleetList[i];
			hf.Clear();
			m_FleetList.splice(i, 1);
			
			u = m_EntityList.indexOf(hf);
			if (u >= 0) m_EntityList.splice(u, 1);
		}

		var hs:HyperspaceShuttle;
		for (i = m_ShuttleList.length - 1; i >= 0; i--) {
			hs = m_ShuttleList[i];
			hs.Clear();
			m_ShuttleList.splice(i, 1);
			
			u = m_EntityList.indexOf(hs);
			if (u >= 0) m_EntityList.splice(u, 1);
		}

		var hcont:HyperspaceContainer;
		for (i = m_ContainerList.length - 1; i >= 0; i--) {
			hcont = m_ContainerList[i];
			hcont.Clear();
			m_ContainerList.splice(i, 1);
			
			u = m_EntityList.indexOf(hcont);
			if (u >= 0) m_EntityList.splice(u, 1);
		}
	}

	private function DrawImg(bm:BitmapData, x:Number, y:Number):void
	{
		var m:Matrix=new Matrix();
		m.identity();
		m.translate(x-bm.width/2, y-bm.height/2);

		m_StarLayer.graphics.lineStyle(0,0x000099,0);
		m_StarLayer.graphics.beginBitmapFill(bm,m,true);
		m_StarLayer.graphics.drawRect(x-bm.width/2, y-bm.height/2, bm.width, bm.height);
		m_StarLayer.graphics.endFill();
	}

	private function MenuEdit():void
	{
/*		m_MenuWorldX=MapToWorldX(mouseX);
		m_MenuWorldY=MapToWorldY(mouseY);
		
		EM.CloseForModal();
		EM.m_FormMenu.Clear();

		var zx:int=Math.floor(m_MenuWorldX/m_ZoneSize);
		var zy:int=Math.floor(m_MenuWorldY/m_ZoneSize);
		
		var zone:Zone=GetZone(zx,zy);
		if(zone==null) return;
		
		if(IsEditCotl(zx,zy)) {
			if(m_CotlMouse) {
//				EM.m_FormMenu.Add(Common.TxtEdit.CotlSet,EditCotlProtectBegin);
//				EM.m_FormMenu.Add(Common.TxtEdit.MapEdit,EditCotlMapEdit);
//				EM.m_FormMenu.Add(Common.TxtEdit.MapSave,EditCotlMapSave);
//				EM.m_FormMenu.Add(Common.TxtEdit.MapUnload,EditCotlMapUnload);
//				EM.m_FormMenu.Add(Common.TxtEdit.MapUnloadNormal,EditCotlMapUnloadNormal);
//				EM.m_FormMenu.Add(Common.TxtEdit.MapDelete,EditCotlMapDelete);
			} else {
				EM.m_FormMenu.Add(Common.Txt.HyperspaceAddCotlProtect,NewCotlProtectBegin);
			}
		}
		
		EM.m_FormMenu.Add();

		if(m_CotlMouse==0 && (EM.m_MapEditor || zone.m_Dev0==Server.Self.m_UserId)) { 
			EM.m_FormMenu.Add(Common.Txt.HyperspaceZoneEdit,ZoneEditBegin);
		}

		var cx:int=mouseX;
		var cy:int=mouseY;

		EM.m_FormMenu.Show(cx,cy,cx+1,cy+1);*/
//trace("MenuEdit");
	}
	
	private function ZoneEditBegin(...args):void
	{
		var str:String;
		var user:User;
		var zx:int=Math.floor(m_MenuWorldX/m_ZoneSize);
		var zy:int=Math.floor(m_MenuWorldY/m_ZoneSize);
		
		var zone:Zone=GetZone(zx,zy);
		if(zone==null) return; 

		EM.m_FormInput.Init();

		EM.m_FormInput.AddLabel(Common.Txt.HyperspaceZoneEdit+": "+(zx-m_ZoneMinX+1).toString()+","+(zy-m_ZoneMinY+1).toString());

		EM.m_FormInput.AddLabel(Common.Txt.HyperspaceZoneRating+":");
		EM.m_FormInput.AddInput(zone.m_Lvl.toString(),10,true,0);

		EM.m_FormInput.Run(ZoneEditSend);
	}
	
	private function ZoneEditSend():void
	{
		var str:String;
		var user:User;
		var zx:int=Math.floor(m_MenuWorldX/m_ZoneSize);
		var zy:int=Math.floor(m_MenuWorldY/m_ZoneSize);

		var zone:Zone=GetZone(zx,zy);
		if(zone==null) return;

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"lvl\"\r\n\r\n";
        d+=(EM.m_FormInput.Get(3) as TextInput).text+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"x\"\r\n\r\n";
        d+=zx.toString()+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"y\"\r\n\r\n";
        d+=zy.toString()+"\r\n"

        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emedzone","",d,boundary,ZoneEditRecv,false);
	}

	private function ZoneEditRecv(event:Event):void
	{
	}

	private function NewCotlProtectBegin(...args):void
	{
		var cb:ComboBox;

		EM.m_FormInput.Init();
		EM.m_FormInput.AddLabel(Common.Txt.HyperspaceCotlEditCaption+":",18);
		
		EM.m_FormInput.AddLabel(Common.Txt.HyperspaceCotlId+":");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddInput("0",8,true);

		EM.m_FormInput.AddLabel(Common.Txt.HyperspaceCotlName+":");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddInput("",32-1,true,Server.Self.m_Lang);
		
		EM.m_FormInput.AddLabel(Common.Txt.HyperspaceRace+":");
		EM.m_FormInput.Col();
		cb = EM.m_FormInput.AddComboBox();
		cb.addItem( { label:Common.RaceName[Common.RaceNone], data:Common.RaceNone } );
		cb.addItem( { label:Common.RaceName[Common.RaceGrantar], data:Common.RaceGrantar } );
		cb.addItem( { label:Common.RaceName[Common.RacePeleng], data:Common.RacePeleng } );
		cb.addItem( { label:Common.RaceName[Common.RacePeople], data:Common.RacePeople } );
		cb.addItem( { label:Common.RaceName[Common.RaceTechnol], data:Common.RaceTechnol } );
		cb.addItem( { label:Common.RaceName[Common.RaceGaal], data:Common.RaceGaal } );

		EM.m_FormInput.AddLabel(Common.Txt.HyperspaceCotlSize+":");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddInput("35",5,true,0);

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(NewCotlProtectSend);
	}

	private function NewCotlProtectSend():void
	{
        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
		d+="--"+boundary+"\r\n";
		d+="Content-Disposition: form-data; name=\"id\"\r\n\r\n";
		d+=EM.m_FormInput.GetInt(0).toString()+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"name\"\r\n\r\n";
        d+=EM.m_FormInput.GetStr(1)+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"race\"\r\n\r\n";
        d+=EM.m_FormInput.GetInt(2).toString()+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"lang\"\r\n\r\n";
        d+=Server.Self.m_Lang.toString()+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"type\"\r\n\r\n";
        d+="3\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"size\"\r\n\r\n";
        d+=EM.m_FormInput.GetInt(3).toString()+"\r\n"
        
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"x\"\r\n\r\n";
        d+=m_MenuWorldX.toString()+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"y\"\r\n\r\n";
        d+=m_MenuWorldY.toString()+"\r\n"

        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emedcotladd","&a=1",d,boundary,NewCotlProtectRecv,false);
	}

	private function NewCotlProtectRecv(event:Event):void
	{
	}
	
	public function GetZone(x:int, y:int):Zone
	{
		var i:int=0;
		var zone:Zone;
		for(i=0;i<m_ZoneList.length;i++) {
			zone=m_ZoneList[i];
			if (zone.m_ZoneX == x && zone.m_ZoneY == y) {
				zone.m_GetTime = EM.m_CurTime;
				return zone;
			}
		}
		return null;
	}

	private function SpaceDynamicSend():void
	{
		var i:int, u:int;
		var ent:SpaceEntity;
		var zx:int, zy:int;

		var ct:Number = Common.GetTime();
		if (ct < m_SpaceDynamicWaitAnswer) return;
		
//trace("SpaceDynamicSend");

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();
		sl.SaveBegin(ba);

//		sl.SaveInt(m_CamZoneX);
//		sl.SaveInt(m_CamZoneY);


//		var zonesize:int = SP.m_ZoneSize;
//		var sx:int = Math.max(SP.m_ZoneMinX, Math.floor(EM.m_FormRadar.MapToWorldX(0) / zonesize));
//		var sy:int = Math.max(SP.m_ZoneMinY, Math.ceil(EM.m_FormRadar.MapToWorldY(0) / zonesize));
//		var ex:int = Math.min(SP.m_ZoneMinX + SP.m_ZoneCntX, Math.floor(EM.m_FormRadar.MapToWorldX(m_SizeX) / zonesize) + 1);
//		var ey:int = Math.min(SP.m_ZoneMinY + SP.m_ZoneCntY, Math.ceil(EM.m_FormRadar.MapToWorldY(m_SizeY) / zonesize) + 1);
//		sl.SaveInt(sx);
//		sl.SaveInt(sy);
//		sl.SaveInt(ex);
//		sl.SaveInt(ey);
/*
		var fzx:int = m_CamZoneX;
		var fzy:int = m_CamZoneY;
		var ezx:int = m_CamZoneX;
		var ezy:int = m_CamZoneY;

		PickWorldCoord(0, 0, m_TPos);
		zx = Math.floor(m_TPos.x / SP.m_ZoneSize); zy = Math.floor(m_TPos.y / SP.m_ZoneSize);
		fzx = Math.min(fzx, zx); fzy = Math.min(fzy, zy);
		ezx = Math.max(ezx, zx); ezy = Math.max(ezy, zy);

		PickWorldCoord(C3D.m_SizeX, 0, m_TPos);
		zx = Math.floor(m_TPos.x / SP.m_ZoneSize); zy = Math.floor(m_TPos.y / SP.m_ZoneSize);
		fzx = Math.min(fzx, zx); fzy = Math.min(fzy, zy);
		ezx = Math.max(ezx, zx); ezy = Math.max(ezy, zy);

		PickWorldCoord(0, C3D.m_SizeY, m_TPos);
		zx = Math.floor(m_TPos.x / SP.m_ZoneSize); zy = Math.floor(m_TPos.y / SP.m_ZoneSize);
		fzx = Math.min(fzx, zx); fzy = Math.min(fzy, zy);
		ezx = Math.max(ezx, zx); ezy = Math.max(ezy, zy);

		PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TPos);
		zx = Math.floor(m_TPos.x / SP.m_ZoneSize); zy = Math.floor(m_TPos.y / SP.m_ZoneSize);
		fzx = Math.min(fzx, zx); fzy = Math.min(fzy, zy);
		ezx = Math.max(ezx, zx); ezy = Math.max(ezy, zy);

		fzx -= 2; fzy -= 2;
		ezx += 2 + 2; ezy += 2 + 2;
		if (fzx < (m_CamZoneX - 4)) fzx = m_CamZoneX - 4;
		if (fzy < (m_CamZoneY - 4)) fzy = m_CamZoneY - 4;
		if (ezx > (m_CamZoneX + 4 + 1)) ezx = m_CamZoneX + 4 + 1;
		if (ezy > (m_CamZoneY + 4 + 1)) ezy = m_CamZoneY + 4 + 1;*/

		var fzx:int = m_CenterZoneX - 2;
		var fzy:int = m_CenterZoneY - 2;
		var ezx:int = m_CenterZoneX + 2 + 1;
		var ezy:int = m_CenterZoneY + 2 + 1;

		sl.SaveInt(fzx);
		sl.SaveInt(fzy);
		sl.SaveInt(ezx - fzx);
		sl.SaveInt(ezy - fzy);
//trace(fzx, fzy, ezx - fzx, ezy - fzy, m_CamZoneX, m_CamZoneY);

		sl.SaveEnd();

		sl.SaveBegin(ba);

		var fl:uint = 0;

		var fleet_player:SpaceShip = null;
		ent = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId);
		if (ent != null) {
			fleet_player = ent as SpaceShip;
		}

		if (m_WaitRecvFull || (m_SpaceDynamicQueryNearTime + 3000) <= ct) {
			m_SpaceDynamicQueryNearTime = ct;
			fl |= 2;
		}

		if ((m_SpaceDynamicQueryPosTime + 5000) <= ct) {
			m_SpaceDynamicQueryPosTime = ct;
			fl |= 1;
		}

		for (i = 0; i < SP.m_EntityList.length; i++) {
			ent = SP.m_EntityList[i];
			if (!ent.m_RecvFull) { fl |= 1; break; }
		}

//	public var m_ZoneQueryTimer:Number = 0;
//	public var m_ZoneQueryX:int = 0;
//	public var m_ZoneQueryY:int = 0;
		if (m_ZoneQueryX != fzx || m_ZoneQueryY != fzy || (m_ZoneQueryTimer + 30000) < ct) {
			fl |= 4;
		}

		ba.writeByte(fl);
		
		var ship:SpaceShip;
		var fleet:SpaceFleet;
		var shu:SpaceShuttle;
		var cont:SpaceContainer;
		var contid:uint;
		
		var idsend:Array = new Array();
		var idstr:String;
		var ardub:Array = new Array();

//trace("query start:");
		var ort:uint;
		for (i = 0; i < SP.m_EntityList.length; i++) {
			ent = SP.m_EntityList[i];
			ort = 0;
			if (ent.m_EntityType == SpaceEntity.TypeFleet && (ent as SpaceShip).m_ServerCorrectionFactor != 0.0) ort |= 0x80; // Need pos
			ba.writeByte(ent.m_EntityType | ort);
//trace("    query:", ent.m_EntityType, ent.m_Id, ent.m_VerOrder, ent.m_VerState, ent.m_VerSet);
			sl.SaveDword(ent.m_Id);
			ba.writeByte(ent.m_VerOrder);
			ba.writeByte(ent.m_VerState);
			ba.writeByte(ent.m_VerSet);
			ent.m_Tmp = 1;

			if (ent.m_EntityType == SpaceEntity.TypeFleet) {
				fleet = SpaceFleet(ent);
				if (fleet.m_ShuttleId != 0 && SP.EntityFind(SpaceEntity.TypeShuttle, fleet.m_ShuttleId) == null) {
					idstr = SpaceEntity.TypeShuttle.toString() + "_" + fleet.m_ShuttleId.toString();
					if (idsend[idstr] == undefined) {
						ba.writeByte(SpaceEntity.TypeShuttle | 0x80);
						sl.SaveDword(fleet.m_ShuttleId);
						ba.writeByte(0);
						ba.writeByte(0);
						ba.writeByte(0);
						idsend[idstr] = true;
					}
				}
			}
			if (ent.m_EntityType == SpaceEntity.TypeFleet || ent.m_EntityType == SpaceEntity.TypeShuttle) {
				ship = SpaceShip(ent);
				contid = ship.m_DropId;
				ardub.length = 0;
				while (contid) {
					if (ardub[contid] != undefined) break;
					ardub[contid] = true;

					cont = SP.EntityFind(SpaceEntity.TypeContainer, contid) as SpaceContainer;
					if (cont == null) {
						idstr = SpaceEntity.TypeContainer.toString() + "_" + contid.toString();
						if (idsend[idstr] == undefined) {
							ba.writeByte(SpaceEntity.TypeContainer | 0x80);
							sl.SaveDword(contid);
							ba.writeByte(0);
							ba.writeByte(0);
							ba.writeByte(0);
							idsend[idstr] = true;
						}
						break;
					} else {
						contid = cont.m_DropNextContainerId;
					}
				}
				contid = ship.m_TakeId;
				ardub.length = 0;
				while (contid) {
					if (ardub[contid] != undefined) break;
					ardub[contid] = true;
					
					cont = SP.EntityFind(SpaceEntity.TypeContainer, contid) as SpaceContainer;
					if (cont == null) {
						idstr = SpaceEntity.TypeContainer.toString() + "_" + contid.toString();
						if (idsend[idstr] == undefined) {
							ba.writeByte(SpaceEntity.TypeContainer | 0x80);
							sl.SaveDword(contid);
							ba.writeByte(0);
							ba.writeByte(0);
							ba.writeByte(0);
							idsend[idstr] = true;
						}
						break;
					} else {
						contid = 0;
						if(cont.m_Take)
						for (u = 0; u < SpaceContainer.TakeMax; u++) {
							if (cont.m_Take[u * 3 + 1] != ship.m_Id) continue;
							if (cont.m_Take[u * 3 + 0] != ship.m_EntityType) continue;
							contid = cont.m_Take[u * 3 + 2];
							break;
						}
					}
				}
			}
		}
		ba.writeByte(0);

//		if (fl & 2) {
//			ba.writeFloat(fleet_player.m_PosX);
//			ba.writeFloat(fleet_player.m_PosY);
//		}

		sl.SaveEnd();

		m_SpaceDynamicWaitAnswer = Common.GetTime() + SpaceDynamicUpdatePeriod * 5;

//trace(Server.Self.m_SpaceServerAdr);
		Server.Self.QuerySmallSS("emspaced", true, Server.sqSpaceD, ba, SpaceDynamicRecv);
	}
	
	public var m_SpaceDynamicRecv_LastTime:Number = 0;

	private function SpaceDynamicRecv(errcode:uint, buf:ByteArray):void
	{
		var i:int;
		var type:uint, id:uint, fl:uint, anm:uint;
		var dx:Number, dy:Number, dz:Number;
		var ent:SpaceEntity;
		var ship:SpaceShip;
		var fleet:SpaceFleet;
		var shu:SpaceShuttle;
		var cont:SpaceContainer;
		var cotl:SpaceCotl;
		var planet:SpacePlanet;
		var zone:Zone;
		var vdw:uint, vdw2:uint;
		
		if (!m_Work) return;
		
//trace("SpaceDynamicRecv");

//		var updateradar:Boolean = false;

		var ct:Number = Common.GetTime();

		var sl:SaveLoad = new SaveLoad();

		var dt:Number = ct - m_SpaceDynamicRecv_LastTime;
		m_SpaceDynamicRecv_LastTime = ct;
		if (dt > 5000) dt = 1000;

		if(EM.ErrorFromServer(errcode)) return;
		if (buf == null || buf.length <= 0) throw Error("SpaceDynamicRecv");

		sl.LoadBegin(buf);
//		vdw = sl.LoadDword(); if (vdw != EM.m_UserCombatId) { EM.m_UserCombatId = vdw; updateradar = true;  }
//		EM.m_HomeworldCotlX = sl.LoadInt();
//		EM.m_HomeworldCotlY = sl.LoadInt();
//		EM.m_CitadelCotlX = sl.LoadInt();
//		EM.m_CitadelCotlY = sl.LoadInt();
//		EM.m_FleetPosX = sl.LoadInt();
//		EM.m_FleetPosY = sl.LoadInt();
//		EM.m_FleetAction = sl.LoadInt();
//		if (EM.m_FleetAction == Common.FleetActionInOrbitCotl) EM.m_FleetTgtId = sl.LoadDword();
//		else EM.m_FleetTgtId = 0;
		sl.LoadEnd();
//trace("fleetpos:", EM.m_FleetPosX, EM.m_FleetPosY, "homeworld:", EM.m_HomeworldCotlX, EM.m_HomeworldCotlY);

		var gfl:uint = buf.readUnsignedByte();

		sl.LoadBegin(buf);
		
		var recvplayerfleet:Boolean = false;
		
		for (i = 0; i < SP.m_EntityList.length; i++) {
			SP.m_EntityList[i].m_Tmp = 0;
		}

//trace("answer start:");
		while (true) {
			type = buf.readUnsignedByte();
			if (type == 0) break;
			id = sl.LoadDword();
//trace("SDR", type, id);

			ent = SP.EntityFind(type, id, false);
			if (ent == null) {
				ent = SP.EntityAdd(type, id);
			}

			ent.m_Tmp = 1;

			if (type == SpaceEntity.TypeFleet || type == SpaceEntity.TypeShuttle) {
				ship = ent as SpaceShip;
				fleet = null;
				shu = null;
				if (type == SpaceEntity.TypeFleet) fleet = ent as SpaceFleet;
				else if (type == SpaceEntity.TypeShuttle) shu = ent as SpaceShuttle;

				fl = buf.readUnsignedByte();
//if(type == SpaceEntity.TypeShuttle) trace("    shuttle:", id, "fl:", fl.toString(2));
//else trace("    fleet:", id, "fl:", fl.toString(2));
			
				if (EM.m_RootFleetId == id) recvplayerfleet = true;

				if (fl & 128) {
					anm = sl.LoadDword();
//trace("test skip",anm,ship.m_LoadAfterAnm);
					if ((anm >= ship.m_LoadAfterAnm) || (ct > (ship.m_LoadAfterAnm_Timer + 5000))) { }
					else {
//trace("skip ship answer");
						ship = new SpaceShip(SP, this);
					}
					ship.m_Anm = anm;
				}

				if (fl & 1) {
					ship.m_ServerZoneX = sl.LoadInt();
					ship.m_ServerZoneY = sl.LoadInt();
					ship.m_ServerPosX = buf.readFloat();
					ship.m_ServerPosY = buf.readFloat();
					ship.m_ServerPosZ = buf.readFloat();
					ship.m_ServerAngle = buf.readFloat();
					ship.m_ServerForsage = buf.readFloat();
					ship.m_ServerPFlag = sl.LoadDword();
					ship.m_ServerPTimer = sl.LoadDword();
					ship.m_ServerPId = sl.LoadDword();
					ship.m_ServerPPrior = sl.LoadDword();
					ship.m_ServerPDist = sl.LoadInt();
//trace("        recv pos", ship.m_ServerZoneX, ship.m_ServerZoneY, ship.m_ServerPosX, ship.m_ServerPosY, ship.m_ServerPosZ);
//trace("recv id:", ship.m_Id, "pos:", ship.m_ServerZoneX, ship.m_ServerZoneY, ship.m_ServerPosX, ship.m_ServerPosY);


/*trace("Zone:" + ship.m_ServerZoneX.toString() + "," + ship.m_ServerZoneY.toString() + "(" + ship.m_ZoneX.toString() + "," + ship.m_ZoneY.toString() + ")", "ServerPos:", ship.m_ServerPosX, ship.m_ServerPosY, ship.m_ServerPosZ, ship.m_ServerAngle, "Dist:",
Math.sqrt(
	((ship.m_ServerPosX + ship.m_ServerZoneX * m_ZoneSize) - (ship.m_PosX + ship.m_ZoneX * m_ZoneSize)) * ((ship.m_ServerPosX + ship.m_ServerZoneX * m_ZoneSize) - (ship.m_PosX + ship.m_ZoneX * m_ZoneSize)) + 
	((ship.m_ServerPosY + ship.m_ServerZoneY * m_ZoneSize) - (ship.m_PosY + ship.m_ZoneY * m_ZoneSize)) * ((ship.m_ServerPosY + ship.m_ServerZoneY * m_ZoneSize) - (ship.m_PosY + ship.m_ZoneY * m_ZoneSize)) + 
	(ship.m_ServerPosZ - ship.m_PosZ) * (ship.m_ServerPosZ - ship.m_PosZ))
);*/
					if (!ship.m_RecvFull) {
						ship.m_ZoneX = ship.m_ServerZoneX;
						ship.m_ZoneY = ship.m_ServerZoneY;
						ship.m_PosX = ship.m_ServerPosX;
						ship.m_PosY = ship.m_ServerPosY;
						ship.m_PosZ = ship.m_ServerPosZ;
						ship.m_Angle = ship.m_ServerAngle;
						ship.m_Forsage = ship.m_ServerForsage;
						ship.m_PFlag = ship.m_ServerPFlag;
						ship.m_PTimer = ship.m_ServerPTimer;
						ship.m_PId = ship.m_ServerPId;
						ship.m_PPrior = ship.m_ServerPPrior;
						ship.m_PDist = ship.m_ServerPDist;
						ship.m_ServerCorrectionDist = 0;
						ship.m_ServerCorrectionFactor = 0;
						ship.m_ServerCorrectionTakt = 0;
					} else {
						ship.m_PFlag = (ship.m_PFlag & (~(SpaceShip.PFlagForsageClientReady))) | (ship.m_ServerPFlag & (SpaceShip.PFlagForsageClientReady));

						if (ship.m_ServerPFlag & SpaceShip.PFlagForsagePrepare) {
							ship.m_PFlag |= SpaceShip.PFlagForsagePrepare;
							ship.m_PTimer = ship.m_ServerPTimer;
						} else {
							ship.m_PFlag &= ~SpaceShip.PFlagForsagePrepare;							
						}
						
						dx = ship.m_ServerPosX - ship.m_PosX + (ship.m_ServerZoneX - ship.m_ZoneX) * SP.m_ZoneSize;
						dy = ship.m_ServerPosY - ship.m_PosY + (ship.m_ServerZoneY - ship.m_ZoneY) * SP.m_ZoneSize;
						dz = ship.m_ServerPosZ - ship.m_PosZ;
						ship.m_ServerCorrectionDist = Math.sqrt(dx * dx + dy * dy);// + dz * dz);
//if(ship.m_Id == 7)
//if(ship.m_EntityType == 4) trace("SP", ship.m_Id, "Server:", ship.m_ServerZoneX, ship.m_ServerZoneY, ship.m_ServerPosX, ship.m_ServerPosY, ship.m_ServerPosZ, "Client:", ship.m_ZoneX, ship.m_ZoneY, ship.m_PosX, ship.m_PosY, ship.m_PosZ, "cd:", ship.m_ServerCorrectionDist);
					}
				}
				if (fl & 2) {
					ship.m_VerOrder = buf.readUnsignedByte();
					ship.m_Order = sl.LoadDword();
					ship.m_OrderTargetId = sl.LoadDword();
					ship.m_OrderTimer = sl.LoadDword();
					ship.m_OrderFlag = sl.LoadDword();
					ship.m_OrderDist = sl.LoadInt();
					ship.m_OrderAngle = sl.LoadDword();
//trace("    order",ship.m_EntityType,ship.m_Id,"order:",ship.m_Order, ship.m_OrderFlag, "ver:", ship.m_VerOrder);
					ship.m_PlaceX = sl.LoadInt() - ship.m_ZoneX * SP.m_ZoneSize;
					ship.m_PlaceY = sl.LoadInt() - ship.m_ZoneY * SP.m_ZoneSize;
					ship.m_PlaceZ = sl.LoadInt();
					ship.m_PlaceAngle = (sl.LoadInt() / 127.0) * Space.pi;
					ship.m_TargetType = sl.LoadDword();
					ship.m_TargetId = sl.LoadDword();
				}
				if (fl & 4) {
					ship.m_VerState = buf.readUnsignedByte();
					ship.m_State = sl.LoadDword();
					ship.m_StateTime = sl.LoadDword();
					if (!ship.m_RecvFull) {
						ship.m_DropId = sl.LoadDword();
						ship.m_DropProgressId = sl.LoadDword();
						ship.m_TakeId = sl.LoadDword();
						ship.m_TakeProgressId = sl.LoadDword();
					} else {
						vdw = sl.LoadDword();
						vdw2 = sl.LoadDword();
						if (ship.m_DropId != vdw) { ship.m_DropId = vdw; ship.m_DropProgressId = vdw2; }
						else if (ship.m_DropProgressId == 0 && vdw2 != 0) ship.m_DropProgressId = vdw2;
						
						vdw = sl.LoadDword();
						vdw2 = sl.LoadDword();
						if (ship.m_TakeId != vdw) { ship.m_TakeId = vdw; ship.m_TakeProgressId = vdw2; }
						else if (ship.m_TakeProgressId == 0 && vdw2 != 0) ship.m_TakeProgressId = vdw2;
					}
					if(fleet) {
						fleet.m_Fuel = sl.LoadInt();
						fleet.m_HP = sl.LoadInt();
						fleet.m_Shield = sl.LoadInt();
					}
//trace("fuel:",fleet.m_Fuel);
				}
				if (fl & 8) {
					ship.m_VerSet = buf.readUnsignedByte();
					ship.m_Owner = sl.LoadDword();
					ship.m_Union = sl.LoadDword();
					if(fleet) {
						fleet.m_ShuttleId = sl.LoadDword();
					}
					if (shu) {
						shu.m_FleetId = sl.LoadDword();
					}
				}

				if ((ship.m_RecvFull == false) && (ship.m_VerOrder != 0) && (ship.m_VerState != 0) && (ship.m_VerSet != 0) && (fl & 1) != 0) ship.m_RecvFull = true;
				
				if (ship.m_RecvFull && (fl & 1)) ship.ToServerCorrection(dt);
//trace("        recvfull:", ship.m_RecvFull);

			} else if (type == SpaceEntity.TypeCotl) {
				cotl = ent as SpaceCotl;
				fl = buf.readUnsignedByte();

				if (fl & 1) {
					cotl.m_ZoneX = sl.LoadInt();
					cotl.m_ZoneY = sl.LoadInt();
					cotl.m_PosX = buf.readFloat();
					cotl.m_PosY = buf.readFloat();
					cotl.m_PosZ = buf.readFloat();
				}
				if (fl & 2) {
					cotl.m_VerOrder = buf.readUnsignedByte();
				}
				if (fl & 4) {
					cotl.m_VerState = buf.readUnsignedByte();

					cotl.m_DefCnt = sl.LoadInt();
					if (cotl.m_DefCnt > 0) {
						cotl.m_DefScoreAll = sl.LoadInt();
						cotl.m_DefOwner0 = sl.LoadDword(); cotl.m_DefScore0 = sl.LoadInt();
						if (cotl.m_DefCnt >= 2) { cotl.m_DefOwner1 = sl.LoadDword(); cotl.m_DefScore1 = sl.LoadInt(); }
						else { cotl.m_DefOwner1 = 0;  cotl.m_DefScore1 = 0;  }
						if (cotl.m_DefCnt >= 3) { cotl.m_DefOwner2 = sl.LoadDword(); cotl.m_DefScore2 = sl.LoadInt(); }
						else { cotl.m_DefOwner2 = 0;  cotl.m_DefScore2 = 0;  }
					} else {
						cotl.m_DefScoreAll = 0;
						cotl.m_DefOwner0 = 0; cotl.m_DefScore0 = 0;
						cotl.m_DefOwner1 = 0; cotl.m_DefScore1 = 0;
						cotl.m_DefOwner2 = 0; cotl.m_DefScore2 = 0;
					}
					cotl.m_AtkCnt = sl.LoadInt();
					if (cotl.m_AtkCnt > 0) {
						cotl.m_AtkScoreAll = sl.LoadInt();
						cotl.m_AtkOwner0 = sl.LoadDword(); cotl.m_AtkScore0 = sl.LoadInt();
						if (cotl.m_AtkCnt >= 2) { cotl.m_AtkOwner1 = sl.LoadDword(); cotl.m_AtkScore1 = sl.LoadInt(); }
						else { cotl.m_AtkOwner1 = 0;  cotl.m_AtkScore1 = 0;  }
						if (cotl.m_AtkCnt >= 3) { cotl.m_AtkOwner2 = sl.LoadDword(); cotl.m_AtkScore2 = sl.LoadInt(); }
						else { cotl.m_AtkOwner2 = 0;  cotl.m_AtkScore2 = 0;  }
					} else {
						cotl.m_AtkScoreAll = 0;
						cotl.m_AtkOwner0 = 0; cotl.m_AtkScore0 = 0;
						cotl.m_AtkOwner1 = 0; cotl.m_AtkScore1 = 0;
						cotl.m_AtkOwner2 = 0; cotl.m_AtkScore2 = 0;
					}
				}
				if (fl & 8) {
					cotl.m_VerSet = buf.readUnsignedByte();

					cotl.m_CotlType = buf.readUnsignedByte();
					cotl.m_CotlFlag = sl.LoadDword();
					cotl.m_CotlSize = sl.LoadInt();
					cotl.m_AccountId = sl.LoadDword();
					cotl.m_UnionId = sl.LoadDword();

					cotl.m_ProtectTime = 1000 * sl.LoadDword();
					if(cotl.m_CotlType==Common.CotlTypeProtect || cotl.m_CotlType==Common.CotlTypeRich) {
						cotl.m_RestartTime=sl.LoadDword();
						cotl.m_TimeData=sl.LoadDword();
					} else {
						cotl.m_RestartTime=0;
						cotl.m_TimeData=0;
					}
					if (cotl.m_CotlType == Common.CotlTypeProtect || cotl.m_CotlType == Common.CotlTypeRich) cotl.m_RewardExp = sl.LoadInt();
					else cotl.m_RewardExp = 0;

					if(cotl.m_CotlType!=Common.CotlTypeUser) {
						cotl.m_BonusType0=sl.LoadInt();
						cotl.m_BonusVal0=sl.LoadInt();
						cotl.m_BonusType1=sl.LoadInt();
						cotl.m_BonusVal1=sl.LoadInt();
						cotl.m_BonusType2=sl.LoadInt();
						cotl.m_BonusVal2=sl.LoadInt();
						cotl.m_BonusType3=sl.LoadInt();
						cotl.m_BonusVal3=sl.LoadInt();

						cotl.m_PriceEnterType = sl.LoadInt();
						if (cotl.m_PriceEnterType != 0) cotl.m_PriceEnter = sl.LoadInt(); else cotl.m_PriceEnter = 0;
						cotl.m_PriceCaptureType = sl.LoadInt();
						if (cotl.m_PriceCaptureType != 0) cotl.m_PriceCapture = sl.LoadInt(); else cotl.m_PriceCapture = 0;
						cotl.m_PriceCaptureEgm = sl.LoadInt();
					} else {
						cotl.m_BonusType0=0;
						cotl.m_BonusVal0=0;
						cotl.m_BonusType1=0;
						cotl.m_BonusVal1=0;
						cotl.m_BonusType2=0;
						cotl.m_BonusVal2=0;
						cotl.m_BonusType3=0;
						cotl.m_BonusVal3 = 0;
						cotl.m_PriceEnterType=0;
						cotl.m_PriceEnter=0;
						cotl.m_PriceCaptureType=0;
						cotl.m_PriceCapture=0;
						cotl.m_PriceCaptureEgm=0;
					}
					
					cotl.m_Dev0 = sl.LoadDword();
					cotl.m_Dev1 = sl.LoadDword();
					cotl.m_Dev2 = sl.LoadDword();
					cotl.m_Dev3 = sl.LoadDword();
					cotl.m_DevAccess = sl.LoadDword();
					cotl.m_DevFlag = sl.LoadDword();
					cotl.m_DevTime = 1000 * sl.LoadDword();

					if (cotl.m_CotlType == Common.CotlTypeUser) {
						cotl.m_ExitTime=sl.LoadDword();
					} else {
						cotl.m_ExitTime = 0;
					}
					if (cotl.m_CotlFlag & SpaceCotl.fPlanetShield) {
						cotl.m_PlanetShieldHour = sl.LoadInt();
						cotl.m_PlanetShieldEnd = sl.LoadDword();
						cotl.m_PlanetShieldCooldown = sl.LoadDword();
					} else {
						cotl.m_PlanetShieldHour = 0;
						cotl.m_PlanetShieldEnd = 0;
						cotl.m_PlanetShieldCooldown = 0;
					}

					cotl.m_ServerAdr=sl.LoadDword();
					if(cotl.m_ServerAdr==0) {
						cotl.m_ServerPort=0;
						cotl.m_ServerNum=0;
						cotl.m_ServerMode=0;
					} else {
						cotl.m_ServerPort=sl.LoadDword();
						cotl.m_ServerNum=sl.LoadDword();
						cotl.m_ServerMode=sl.LoadDword();
					}
				}
				
				if ((cotl.m_RecvInfo == false) && (cotl.m_VerOrder != 0) && (cotl.m_VerState != 0) && (cotl.m_VerSet != 0)) {
					cotl.m_RecvInfo = true;
				}

				if ((cotl.m_RecvFull == false) && (cotl.m_VerOrder != 0) && (cotl.m_VerState != 0) && (cotl.m_VerSet != 0) && (fl & 1) != 0) {
					cotl.m_RecvFull = true;
					cotl.m_LoadTime = EM.m_CurTime;
				} else if (cotl.m_RecvFull) cotl.m_LoadTime = EM.m_CurTime;
				
			} else if (type == SpaceEntity.TypePlanet) {
				planet = ent as SpacePlanet;
				fl = buf.readUnsignedByte();
//trace("    planet:", id, "fl:", fl.toString(2));

				if (fl & 1) {
					planet.m_ServerZoneX = sl.LoadInt();
					planet.m_ServerZoneY = sl.LoadInt();
					planet.m_ServerPosX = buf.readFloat();
					planet.m_ServerPosY = buf.readFloat();
					planet.m_ServerPosZ = buf.readFloat();

					if (!planet.m_RecvFull) {
						planet.m_ZoneX = planet.m_ServerZoneX;
						planet.m_ZoneY = planet.m_ServerZoneY;
						planet.m_PosX = planet.m_ServerPosX;
						planet.m_PosY = planet.m_ServerPosY;
						planet.m_PosZ = planet.m_ServerPosZ;
					}
				}
				if (fl & 2) {
					planet.m_VerOrder = buf.readUnsignedByte();
				}
				if (fl & 4) {
					planet.m_VerState = buf.readUnsignedByte();
				}
				if (fl & 8) {
					planet.m_VerSet = buf.readUnsignedByte();
					planet.m_PlanetFlag = sl.LoadDword();
					planet.m_Style = sl.LoadDword();
					planet.m_CenterId = sl.LoadDword();
					planet.m_OrbitAngle = buf.readFloat();
					planet.m_OrbitRadius = buf.readFloat();
					planet.m_OrbitTime = sl.LoadInt();
					planet.m_Radius = sl.LoadInt();
					planet.m_CotlId = sl.LoadDword();
				}

				if ((planet.m_RecvFull == false) && (planet.m_VerOrder != 0) && (planet.m_VerState != 0) && (planet.m_VerSet != 0) && (fl & 1) != 0) planet.m_RecvFull = true;
//trace("        recvfull:", planet.m_RecvFull);

			} else if (type == SpaceEntity.TypeContainer) {
				cont = ent as SpaceContainer;
				fl = buf.readUnsignedByte();

				anm = sl.LoadDword();
				if ((anm >= cont.m_LoadAfterAnm) || (ct > (cont.m_LoadAfterAnm_Timer + 5000))) { }
				else {
//trace("recv skip container");
					cont = new SpaceContainer(SP, this);
				}
				cont.m_Anm = anm;

				if (fl & 1) {
					cont.m_ServerZoneX = sl.LoadInt();
					cont.m_ServerZoneY = sl.LoadInt();
					cont.m_ServerPosX = buf.readFloat();
					cont.m_ServerPosY = buf.readFloat();
					cont.m_ServerPosZ = buf.readFloat();
					cont.m_ServerSpeedX = buf.readFloat();
					cont.m_ServerSpeedY = buf.readFloat();

					if (!cont.m_RecvFull) {
						cont.m_ZoneX = cont.m_ServerZoneX;
						cont.m_ZoneY = cont.m_ServerZoneY;
						cont.m_PosX = cont.m_ServerPosX;
						cont.m_PosY = cont.m_ServerPosY;
						cont.m_PosZ = cont.m_ServerPosZ;
						cont.m_SpeedX = cont.m_ServerSpeedX;
						cont.m_SpeedY = cont.m_ServerSpeedY;
					}
				}
				if (fl & 2) {
					cont.m_VerOrder = buf.readUnsignedByte();
				}
				if (fl & 4) {
					cont.m_VerState = buf.readUnsignedByte();
					cont.m_Flag = sl.LoadDword();
//trace("cont.flag:", cont.m_Flag.toString(16));
					cont.m_DropNextContainerId = sl.LoadDword();
					cont.m_DropEntityId = sl.LoadDword();
					cont.m_DropEntityType = sl.LoadDword();
					
					if (cont.m_Take != null) {
						for (i = 0; i < cont.m_Take.length; i++) cont.m_Take[i] = 0;
					}
					
					while (true) {
						var et:uint = sl.LoadDword();
						if (!et) break;
						if (!cont.m_Take) cont.TakePrepare();
						i = sl.LoadDword();
						cont.m_Take[i * 3 + 0] = et;
						cont.m_Take[i * 3 + 1] = sl.LoadDword();
						cont.m_Take[i * 3 + 2] = sl.LoadDword();
					}
				}
				if (fl & 8) {
					cont.m_VerSet = buf.readUnsignedByte();
					cont.m_ItemType = sl.LoadDword();
					cont.m_ItemCnt = sl.LoadDword();
					cont.m_Owner = sl.LoadDword();
					cont.m_Broken = sl.LoadInt();
					cont.m_Time = sl.LoadDword();
					cont.m_PlanetId = sl.LoadDword();
				}

				if ((cont.m_RecvFull == false) && (cont.m_VerOrder != 0) && (cont.m_VerState != 0) && (cont.m_VerSet != 0) && (fl & 1) != 0) cont.m_RecvFull = true;
			} else throw Error("err");
		}

		var newentity:Boolean = false;
		if (gfl & 2) {
			SP.m_NearCotl.length = 0;
			while (true) {
				type = buf.readUnsignedByte();
				if (type == 0) break;
				id = sl.LoadDword();

				if (type == SpaceEntity.TypeCotl) SP.m_NearCotl.push(id);

				ent = SP.EntityFind(type, id, false);
				if (ent == null) {
					ent = SP.EntityAdd(type, id);
				}
				if (!ent.m_RecvFull) {
					newentity = true;
//trace("newentity", type, id);
				}

				ent.m_Tmp = 1;
			}
//trace("    newentity:",newentity);
//if(newentity) trace("!!!newentity");
			if (!newentity && m_WaitRecvFull) {
//trace("    WaitRecvFull=false");
				m_WaitRecvFull = false;
			}

			for (i = SP.m_EntityList.length - 1; i >= 0; i--) {
				ent = SP.m_EntityList[i];
				if (ent.m_Tmp != 0) continue;
				if (ent.m_EntityType == SpaceEntity.TypeFleet && ent.m_Id == EM.m_RootFleetId) continue;
				//if (!ent.m_RecvFull) continue;
				SP.m_EntityList.splice(i, 1);
			}
		}
		
		var zonecnt:int = sl.LoadDword();
		if (zonecnt > 0) {
			m_ZoneQueryTimer = ct;
			m_ZoneQueryX = sl.LoadInt();
			m_ZoneQueryY = sl.LoadInt();

			for (i = 0; i < zonecnt; i++) {
				var zx:int = sl.LoadInt();
				var zy:int = sl.LoadInt();
				zone = GetZone(zx, zy);
				if (zone == null) {
					zone = new Zone(zx, zy);
					zone.m_GetTime = ct;
					m_ZoneList.push(zone);
				}
				zone.m_Lvl = sl.LoadInt();
			}
		}

		sl.LoadEnd();

		if (!m_WaitRecvFull) {
			ent = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId, false);
			if (ent != null && !recvplayerfleet) {
				ent.m_RecvFull = false;
				ent.m_VerOrder = 0;
				ent.m_VerState = 0;
				ent.m_VerSet = 0;
			}
			SP.ClearFar(m_CamZoneX, m_CamZoneY, ent);

			// Удаляем старые зоны
			for (i = m_ZoneList.length - 1; i >= 0; i--) {
				zone = m_ZoneList[i];
				if (ct > (zone.m_GetTime + 5 * 60000)) {
					m_ZoneList.splice(i, 1);
				}
			}
		}
//trace("WaitRecvFull:", m_WaitRecvFull);

		SP.FindPlanetNum();
		SP.CalcContainerVis();

		if (newentity || m_WaitRecvFull) {
			m_SpaceDynamicWaitAnswer = 0;
//trace("WaitAnswer=0");
		} else {
			m_SpaceDynamicWaitAnswer = Common.GetTime() + SpaceDynamicUpdatePeriod;
//trace("WaitAnswer=", SpaceDynamicUpdatePeriod);
		}
	}

/*	public function FleetRepulseFromCotl():void
	{
		var i:int;
		//var cotl:Cotl;
		var hc:HyperspaceCotl;
		var hf:HyperspaceFleet;
		var r:Number = 120;
		
		var pr:PRnd = new PRnd();
		
		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];

			//if(hf.m_CotlId==0) continue;
			//cotl=EM.m_FormGalaxy.GetCotl(hf.m_CotlId);
			//if(cotl==null) continue;

			//if(cotl.m_X!=hf.m_X || cotl.m_Y!=hf.m_Y) continue;
			
//			var a:Number=Common.AngleNorm(Math.random()*Math.PI*2.0);
//			hf.m_X=hf.m_X+Math.sin(a)*r;
//			hf.m_Y=hf.m_Y-Math.cos(a)*r;
//			hf.m_Angle=Common.AngleNorm(a+Math.PI*0.5);
//			hf.Update();

			hc = FindOrbitCotl(hf.m_X, hf.m_Y);
			if (hc == null) continue;
			if (hc.m_X != hf.m_X || hc.m_Y != hf.m_Y) continue;
			
			pr.Set(hf.m_FleetId ^ hc.m_CotlId); pr.RndEx();

			r = hc.m_Radius + pr.RndFloatEx() * Common.CotlOrbitRadius * 0.9;

			var a:Number = Common.AngleNorm(pr.RndFloatEx() * Math.PI * 2.0);
			hf.m_X=hf.m_X+Math.sin(a)*r;
			hf.m_Y=hf.m_Y-Math.cos(a)*r;
			hf.m_Angle=Common.AngleNorm(a+Math.PI*0.5);
//			hf.Update();
			
			//trace("repulsionfleet:",hf.m_FleetId);
		}
	}
	
	public function FindOrbitCotl(px:Number, py:Number, fromcenter:Boolean = true):HyperspaceCotl
	{
		var i:int;
		var hc:HyperspaceCotl;
		var hcbest:HyperspaceCotl=null;
		var mind:Number;
		
		for(i=0;i<m_CotlList.length;i++) {
			hc=m_CotlList[i];

			var maxd:Number=Common.CotlOrbitRadius+hc.m_Radius;

			var d:Number = (hc.m_X - px) * (hc.m_X - px) + (hc.m_Y - py) * (hc.m_Y - py);
//if(hc.m_CotlId == 6) trace(Math.sqrt(d));
			if (d > (maxd * maxd)) continue;

			if (!fromcenter) d = Math.abs(Math.sqrt(d) - hc.m_Radius);

			if(hcbest==null || d<mind) {
				hcbest=hc;
				mind=d;
			}
		}
		return hcbest;
	}
	
	public function InOrbit(px:Number, py:Number, hc:HyperspaceCotl):Boolean
	{
//		if (cotlid == 0) return false;
//		var hc:HyperspaceCotl = HyperspaceCotlById(cotlid);
		if (hc == null) return false;
		var maxd:Number=Common.CotlOrbitRadius+hc.m_Radius;
		var d:Number = (hc.m_X - px) * (hc.m_X - px) + (hc.m_Y - py) * (hc.m_Y - py);
		if (d > (maxd * maxd)) return false;
		return true;
	}

	public function FleetOrbitMove(dt:Number):void
	{
		var i:int;
		var vx:Number,vy:Number,a:Number,r:Number;
		var hf:HyperspaceFleet;
		var hc:HyperspaceCotl;

		var aspeed:Number=dt*0.0002*Math.PI;

		for(i=0;i<m_FleetList.length;i++) {
			hf=m_FleetList[i];

			if (hf.m_TargetType == Common.FleetActionDefault || hf.m_TargetType == Common.FleetActionStealth || hf.m_TargetType == Common.FleetActionJump || (hf.m_TargetType == Common.FleetActionCombat && hf.m_TargetId == 0)) {
				hc = HyperspaceCotlById(hf.m_OnOrbitId);
				if (hc != null && !InOrbit(hf.m_X, hf.m_Y, hc)) hc = null;
				if (hc == null) hc = FindOrbitCotl(hf.m_X, hf.m_Y, false);

			} else if (hf.m_TargetType == Common.FleetActionCombat) {
				hc = HyperspaceCotlById(hf.m_TargetId);

			} else continue;

			if (hc == null) { hf.m_OnOrbitId = 0; continue; }
			hf.m_OnOrbitId = hc.m_CotlId;

			vx=hf.m_X-hc.m_X;
			vy=hf.m_Y-hc.m_Y;

			a=Math.atan2(vx,-vy);
			r=Math.sqrt(vx*vx+vy*vy);

			if (r <= 0.001) a = Math.random() * Math.PI * 2.0;
			else a += (dt * 0.03 / (2.0 * Math.PI * r)) * (2.0 * Math.PI);

			if (r < (hc.m_Radius + 10)) {
				r += Math.min(30, hc.m_Radius + 10 - r) * 0.001 * dt;
			}

			hf.m_X = hc.m_X + Math.sin(a) * r;
			hf.m_Y = hc.m_Y - Math.cos(a) * r;
			//hf.m_Angle=Common.AngleNorm(a+Math.PI*0.5);

//trace("a:",a);
			var needangle:Number = Common.AngleNorm(a + Math.PI * 0.5);
			var ad:Number = Common.AngleDist(hf.m_Angle, needangle);
			if (ad < -aspeed) hf.m_Angle-= aspeed;
			else if (ad > aspeed) hf.m_Angle += aspeed;
			
//			hf.Update();
		}
	}
	
	public function FleetRepulsion(dt:Number):void
	{
		var i:int,u:int;
		var hf1:HyperspaceFleet;
		var hf2:HyperspaceFleet;
		var vx:Number,vy:Number,dist:Number,tt:Number;
		
		var mindist:Number=50;
		
		for(i=0;i<m_FleetList.length-1;i++) {
			hf1 = m_FleetList[i];
			//if (hf1.m_TargetType != Common.FleetActionDefault) continue;

			for(u=i+1;u<m_FleetList.length;u++) {
				hf2 = m_FleetLayer.getChildAt(u) as HyperspaceFleet;
				//if (hf2.m_TargetType != Common.FleetActionDefault) continue;
				
				//if(hf1.m_OnOrbitId==false && hf2.m_OnOrbitId==false) {
					if ((hf1.m_TargetType == Common.FleetActionFollow || hf1.m_TargetType == Common.FleetActionAttack) && hf1.m_TargetId == hf2.m_FleetId) continue;
					if ((hf2.m_TargetType == Common.FleetActionFollow || hf2.m_TargetType == Common.FleetActionAttack) && hf2.m_TargetId == hf1.m_FleetId) continue;
				//}
				//if (hf1.m_TargetType != hf2.m_TargetType) continue;
				
				if (hf1.m_OnOrbitId != hf2.m_OnOrbitId) continue;
				
				//if(hf1.m_TargetType==Common.FleetActionCombat
				
				vx = hf2.m_X - hf1.m_X;
				vy = hf2.m_Y - hf1.m_Y;
				dist = vx * vx + vy * vy;
				if (dist >= mindist * mindist) continue;
				if (dist <= 0.001) { vx = 1.0; vy = 0.0; dist = 1.0; }
				else { dist = Math.sqrt(dist); tt = 1.0 / dist; vx *= tt; vy *= tt; }

				tt = (mindist - dist) * 0.001 * dt;
				hf1.m_X -= vx * tt;
				hf1.m_Y -= vy * tt;
				hf2.m_X += vx * tt;
				hf2.m_Y += vy * tt;
			}
		}
	}
	
	public function FleetMove(dt:Number):void
	{
		var i:int, u:int;
		var dx:Number, dy:Number, dist:Number;
		var hf:HyperspaceFleet;
		var hc:HyperspaceCotl;

		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];

			var const_speed:Number = Common.FleetSpeed[hf.m_Formation & 7];
			var angle_speed:Number = Common.FleetSpeedAngle[hf.m_Formation & 7];//0.0005*Math.PI;
//angle_speed *= 0.2;
			if(EM.m_EmpireEdit) {
				const_speed *= 5;
				angle_speed *= 5;
			}

			var tgtx:Number = hf.m_TargetX;
			var tgty:Number = hf.m_TargetY;

			if (hf.m_TargetType == Common.FleetActionFollow || hf.m_TargetType == Common.FleetActionAttack) {
				var hfto:HyperspaceFleet = HyperspaceFleetById(hf.m_TargetId);
				if (hfto != null) {
					if(hfto.m_TargetType==Common.FleetActionMove || hfto.m_TargetType==Common.FleetActionFollow || hfto.m_TargetType==Common.FleetActionAttack) {
						var uA:Number = const_speed;// * dt / 1000;
						var uB:Number = Common.FleetSpeed[hfto.m_Formation & 7];// * dt / 1000;
						if (EM.m_EmpireEdit) uB *= 5;
						dx = Math.sin(hfto.m_Angle) * uB;
						dy = -Math.cos(hfto.m_Angle) * uB;
						dist = BaseMath.CalcAimWithVelocity(uA, hfto.m_X - hf.m_X, hfto.m_Y - hf.m_Y, 0.0, dx, dy, 0.0);
						tgtx = hfto.m_X + dx * dist;
						tgty = hfto.m_Y + dy * dist;
					} else {
						tgtx = hfto.m_X;
						tgty = hfto.m_Y;
					}
				}
			}

			hf.m_AimX = tgtx;
			hf.m_AimY = tgty;

			if(hf.m_TargetType!=Common.FleetActionDefault && hf.m_TargetType!=Common.FleetActionStealth && hf.m_TargetType!=Common.FleetActionJump) {
				var speed:Number = dt * const_speed;
				var aspeed:Number = dt * angle_speed;

				dx=tgtx-hf.m_X;
				dy=tgty-hf.m_Y;
				dist = Math.sqrt(dx * dx + dy * dy);

				if (hf.m_TargetType == Common.FleetActionCombat) {
					if (hf.m_TargetId == 0) hc = HyperspaceCotlById(hf.m_OnOrbitId);
					else hc = HyperspaceCotlById(hf.m_TargetId);
					if (hc != null) {
						if (dist < Common.CotlOrbitRadius + hc.m_Radius) continue;
					}
				}

				if(dist<=speed) {
					hf.m_X=tgtx;
					hf.m_Y=tgty;
					//hf.m_TargetType=Common.FleetActionDefault;
//					hf.Update();
					continue;
				}
				dx/=dist;
				dy/=dist;

				var needangle:Number = Math.atan2(dx, -dy);

				var ad:Number = Common.AngleDist(hf.m_Angle, needangle);
				if (Math.abs(ad) <= aspeed) hf.m_Angle = needangle;
				else {
					if (ad < 0) hf.m_Angle = Common.AngleNorm(hf.m_Angle-aspeed);
					else hf.m_Angle = Common.AngleNorm(hf.m_Angle + aspeed);

					if(dist<200) {
						speed*=1.0-Math.abs(ad)/Math.PI;
					}
				}

				if(dist<100) {
					hf.m_X += dx * speed;
					hf.m_Y += dy * speed;
				} else {
					hf.m_X += speed * Math.sin(hf.m_Angle);
					hf.m_Y += -speed * Math.cos(hf.m_Angle);
				}
				
				if (hf.m_X < m_ZoneMinX * m_ZoneSize) hf.m_X = m_ZoneMinX * m_ZoneSize;
				else if (hf.m_X > ((m_ZoneMinX + m_ZoneCntX) * m_ZoneSize-1)) hf.m_X = ((m_ZoneMinX + m_ZoneCntX) * m_ZoneSize-1); 

				if (hf.m_Y < m_ZoneMinY * m_ZoneSize) hf.m_Y = m_ZoneMinY * m_ZoneSize;
				else if (hf.m_Y > ((m_ZoneMinY + m_ZoneCntY) * m_ZoneSize-1)) hf.m_Y = ((m_ZoneMinY + m_ZoneCntY) * m_ZoneSize-1);

//				hf.Update();
			}
		}
	}
	
	public function FleetCorrectMove(hf:HyperspaceFleet, fleet:FleetDyn, full:Boolean, st:Number):void
	{
		var dx:Number, dy:Number, dist:Number, speed:Number, v:Number;

		var px:Number = fleet.m_X;
		var py:Number = fleet.m_Y;
		var tx:Number = fleet.m_TgtX;
		var ty:Number = fleet.m_TgtY;
		var tgtid:uint = fleet.m_TgtId;
		var a:int = fleet.m_Action;

		var dt:Number = st - hf.m_CorrectTime;
		hf.m_CorrectTime = st;

		if (hf.m_OnOrbitId != 0 && (hf.m_TargetType == Common.FleetActionDefault || hf.m_TargetType == Common.FleetActionStealth || hf.m_TargetType == Common.FleetActionJump)) return;

		if ((fleet.m_PosTime < st) && (a == Common.FleetActionMove || a == Common.FleetActionFollow || a == Common.FleetActionAttack)) {
			// Расчет текущего положения флота
			dx=tx-px;
			dy=ty-py;
			dist=Math.sqrt(dx*dx+dy*dy);
			speed = Common.FleetSpeed[fleet.m_Formation & 7];
			if(EM.m_EmpireEdit) speed*=5;
			v = (st - fleet.m_PosTime) / (dist / speed);
			if(v>=1.0) {
				px=tx;
				py=ty;
			} else {
				px = px + dx * v;
				py = py + dy * v;
			}
		}

		// Приближаем графическое положение флота к серверному положению
		if (full) {
			hf.m_X = px;
			hf.m_Y = py;
			return;
		}

//		if (hf.m_TargetType == Common.FleetActionDefault) return;

		dx = px - hf.m_X;
		dy = py - hf.m_Y;
		dist = Math.sqrt(dx * dx + dy * dy);
		if (dist < 10) return;
		
		v = Math.max(0, Math.min(dist / 2000, 1.0));
		if (v < 0.002) return;
		speed = v * v * 0.5 * dt;
//		speed = 0.1 * dt;
		if (dist <= speed) {
			hf.m_X = px;
			hf.m_Y = py;
		} else {
//if(fleet.m_FleetId == EM.m_RootFleetId && v >= 0.1) trace((dx / dist * speed).toFixed(5) +"\t" + (dy / dist * speed).toFixed(5) +"\t" + v.toFixed(5));
			hf.m_X = hf.m_X + dx / dist * speed;
			hf.m_Y = hf.m_Y + dy / dist * speed;
		}
	}*/

/*	public function FleetSendMove():void
	{
		var hf:HyperspaceFleet=HyperspaceFleetById(EM.m_RootFleetId);
		if (hf == null) return;

		var fleet:FleetDyn = FleetDynById(EM.m_RootFleetId);
		if (fleet == null) return;

		var action:int = hf.m_TargetType;
		var px:int=hf.m_X;
		var py:int=hf.m_Y;
		var tx:int=px;
		var ty:int=py;
		var period:int=0;
		var state:int=0;

//		var const_speed:Number=Common.FleetSpeed[hf.m_Formation & 7];
//		if(EM.m_EmpireEdit) const_speed*=5;
//		
//		if(hf.m_TargetType==1) {
//			state=1;
//			var dist:Number=Math.sqrt((hf.m_TargetX-hf.m_X)*(hf.m_TargetX-hf.m_X)+(hf.m_TargetY-hf.m_Y)*(hf.m_TargetY-hf.m_Y));
//			period=Math.ceil(dist/(const_speed*1000));
//
//			tx=hf.m_TargetX;
//			ty=hf.m_TargetY;
//			if(period<=2) {
//				state=0;
//				period=0;
//				px=tx;
//				py=ty;
//			}
//		}
		tx = hf.m_TargetX;
		ty = hf.m_TargetY;
//trace(px, py, tx, ty);

		//if(m_FleetOldSend_TgtX==tx && m_FleetOldSend_TgtY==ty) return;
		//if(m_FleetOldSend_State==state && ((tx-m_FleetOldSend_TgtX)*(tx-m_FleetOldSend_TgtX)+(ty-m_FleetOldSend_TgtY)*(ty-m_FleetOldSend_TgtY))<(20*20)) return;
		//if(m_FleetOldSend_State!=state);
		//else if(state==1 && ((tx-m_FleetOldSend_TgtX)*(tx-m_FleetOldSend_TgtX)+(ty-m_FleetOldSend_TgtY)*(ty-m_FleetOldSend_TgtY))>(20*20));
		//else return;
		//m_FleetOldSend_State=state;
		//m_FleetOldSend_TgtX=tx; 
		//m_FleetOldSend_TgtY=ty;

//		var ano:uint = Math.max(m_LoadActionAfterAno, fleet.m_Ano) + 1;
		var ano:uint = m_FleetMove_Ano;

		var val:String = "&val=" + ano.toString() +"_" + action.toString() + "_" + tx.toString() + "_" + ty.toString();
		if (hf.m_TargetType == Common.FleetActionFollow || hf.m_TargetType == Common.FleetActionAttack) val += "_" + hf.m_TargetId.toString();

		//if(period>0) {
		//	var d:Date=EM.GetServerDate();
		//	val+="_"+d.fullYear.toString()+"-"+(d.month+1).toString()+"-"+d.date.toString()+"-"+d.hours.toString()+":"+d.minutes.toString()+":"+d.seconds.toString();
		//	val+="_"+tx.toString();
		//	val+="_"+ty.toString();
		//}

//trace(val);
		Server.Self.QueryHS("emfleetmove", val, AnswerSendMove, false);

//		m_LoadActionAfterAno = ano;
//		m_LoadActionAfterAno_Time = Common.GetTime();
	}

	private function AnswerSendMove(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray = loader.data;
		if (loader.data == null) return;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int = buf.readUnsignedByte();
		if (EM.ErrorFromServer(err)) return;

		var nf:int = buf.readInt();
//trace("NeedFuel:",nf);
		if (nf == 0) return;

		var hf:HyperspaceFleet=HyperspaceFleetById(EM.m_RootFleetId);
		if (hf == null) return;

		hf.m_TargetX=hf.x;
		hf.m_TargetY=hf.y;
		hf.m_TargetType = 0;

		if (nf <= 0) return;

		var str:String = Common.Txt.WarningNeedMoreFuelForFly;
		str=BaseStr.Replace(str, "<Val>", nf.toString());
		EM.m_FormHint.Show(str, Common.WarningHideTime);
		
	}*/
	
	public function GetOrbitCotlId():uint
	{
		var ent:SpaceEntity = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId);
		if (ent == null) return 0;
		var fleet:SpaceShip = ent as SpaceShip;
		
		if ((fleet.m_PFlag & SpaceShip.PFlagInOrbitCotl) != 0) return fleet.m_PId;
		return 0;
	}

	public function GetOrbitPlanetId():uint
	{
		var ent:SpaceEntity = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId);
		if (ent == null) return 0;
		var fleet:SpaceShip = ent as SpaceShip;

		if ((fleet.m_PFlag & SpaceShip.PFlagInOrbitPlanet) != 0) return fleet.m_PId;
		return 0;
	}

	public function OrderMoveEx(fortype:uint, forid:uint, x:int, y:int):void
	{
		var ent:SpaceEntity = SP.EntityFind(fortype, forid);
		if (ent == null) return;
		var ship:SpaceShip = ent as SpaceShip;
		if (!ship.CanOrder()) return;

		if (GetOrbitCotlId() != 0 || GetOrbitPlanetId() != 0) {
			m_OrderMove_X = x;
			m_OrderMove_Y = y;
			FormMessageBox.Run("[justify]" + Common.Txt.FormHyperspaceLeaveOrbitQuery + "[/justify]", Common.Txt.FormHyperspaceLeaveOrbitStay, Common.Txt.FormHyperspaceLeaveOrbitLeave, OrderMoveOk);
		} else {
			OrderMove(fortype, forid, x, y);
		}
	}
	
	public function OrderMoveOk():void
	{
		OrderMove(SpaceEntity.TypeFleet, EM.m_RootFleetId, m_OrderMove_X, m_OrderMove_Y);
	}
	
	public function OrderMove(fortype:uint, forid:uint, x:int, y:int):void
	{
		if (x < SP.m_ZoneMinX * SP.m_ZoneSize) x = SP.m_ZoneMinX * SP.m_ZoneSize;
		if (x >= (SP.m_ZoneMinX + SP.m_ZoneCntX) * SP.m_ZoneSize) x = (SP.m_ZoneMinX + SP.m_ZoneCntX) * SP.m_ZoneSize-1;

		if (y < SP.m_ZoneMinY * SP.m_ZoneSize) y = SP.m_ZoneMinY * SP.m_ZoneSize;
		if (y >= (SP.m_ZoneMinY + SP.m_ZoneCntY) * SP.m_ZoneSize) y = (SP.m_ZoneMinY + SP.m_ZoneCntY) * SP.m_ZoneSize-1;
		
		if (m_OrderMove_Time == 0) m_OrderMove_Time = Common.GetTime();
		m_OrderForType = fortype;
		m_OrderForId = forid;
		m_Order = SpaceShip.soMove;
		m_OrderMove_X = x;
		m_OrderMove_Y = y;
		m_OrderEntityType = 0;
		m_OrderId = 0;
		m_OrderDist = 0;
		m_OrderAngle = 0;
		m_OrderFlag = 0;
	}

	public function OrderOrbitCotl(fortype:uint, forid:uint, x:int, y:int, id:uint):void
	{
		if (m_OrderMove_Time == 0) m_OrderMove_Time = Common.GetTime();
		m_OrderForType = fortype;
		m_OrderForId = forid;
		m_Order = SpaceShip.soOrbitCotl;
		m_OrderMove_X = x;
		m_OrderMove_Y = y;
		m_OrderEntityType = 0;
		m_OrderId = id;
		m_OrderDist = 0;
		m_OrderAngle = 0;
		m_OrderFlag = 0;
	}

	public function OrderOrbitPlanet(fortype:uint, forid:uint, x:int, y:int, id:uint):void
	{
		if (m_OrderMove_Time == 0) m_OrderMove_Time = Common.GetTime();
		m_OrderForType = fortype;
		m_OrderForId = forid;
		m_Order = SpaceShip.soOrbitPlanet;
		m_OrderMove_X = x;
		m_OrderMove_Y = y;
		m_OrderEntityType = 0;
		m_OrderId = id;
		m_OrderDist = 0;
		m_OrderAngle = 0;
		m_OrderFlag = 0;
	}

	public function OrderFollow(fortype:uint, forid:uint, tgttype:uint, tgtid:uint, dist:int, angle:uint):void
	{
		if (m_OrderMove_Time == 0) m_OrderMove_Time = Common.GetTime();
		m_OrderForType = fortype;
		m_OrderForId = forid;
		m_Order = SpaceShip.soFollow;
		m_OrderEntityType = tgttype;
		m_OrderId = tgtid;
		m_OrderDist = dist;
		m_OrderAngle = angle;
		m_OrderFlag = 0;
	}

	public function OrderDock(fortype:uint, forid:uint, tgttype:uint, tgtid:uint, port:int, dist:int):void
	{
		if (m_OrderMove_Time == 0) m_OrderMove_Time = Common.GetTime();
		m_OrderForType = fortype;
		m_OrderForId = forid;
		m_Order = SpaceShip.soDock;
		m_OrderEntityType = tgttype;
		m_OrderId = tgtid;
		m_OrderDist = dist;
		m_OrderFlag = port;
	}
	
	public function SendOrder():void
	{
		var px:Number, py:Number, a:Number;

		if ((m_OrderMove_Time != 0) && ((m_OrderMove_Time + 150) < Common.GetTime())) {
			m_OrderMove_Time = 0;

			var ent:SpaceEntity = SP.EntityFind(m_OrderForType, m_OrderForId);
			if (ent == null) return;

			var ship:SpaceShip = ent as SpaceShip;
			if (!ship.CanOrder()) return;

			px = (m_OrderMove_X - ship.m_ZoneX * SP.m_ZoneSize) - ship.m_PosX;
			py = (m_OrderMove_Y - ship.m_ZoneY * SP.m_ZoneSize) - ship.m_PosY;

			var dist:Number = Math.sqrt(px * px + py * py);
			var stepcnt:int = Math.ceil(dist / 500);
			var nf:int = (stepcnt * 32 * 6) >> 8;

			if (EM.m_FormFleetBar.m_FleetFuel < nf) {
				var str:String = Common.Txt.WarningNeedMoreFuelForFly;
				str = BaseStr.Replace(str, "<Val>", nf.toString());
				EM.m_FormHint.Show(str, Common.WarningHideTime);
				return;
			}

			if (m_Order == SpaceShip.soOrbitCotl || m_Order == SpaceShip.soOrbitPlanet) {
				px = m_OrderMove_X - ship.m_ZoneX * SP.m_ZoneSize;
				py = m_OrderMove_Y - ship.m_ZoneY * SP.m_ZoneSize;
				a = Math.round(Math.atan2(px - ship.m_PosX, py - ship.m_PosY) * 10000);
				if (m_Order == SpaceShip.soOrbitCotl) ship.OrderOrbitCotl(px, py, Number(a) / 10000.0, m_OrderId);
				else ship.OrderOrbitPlanet(px, py, Number(a) / 10000.0, m_OrderId);
				ship.m_Anm++;
				ship.m_LoadAfterAnm = ship.m_Anm;
				ship.m_LoadAfterAnm_Timer = Common.GetTime();

				Server.Self.QuerySS("emspaceorder", "&val=" + ship.m_ZoneX.toString() + "_" + ship.m_ZoneY.toString() + "_" + ship.m_Anm.toString() + "_" + m_OrderForType.toString() + "_" + m_OrderForId.toString() + "_" +
					m_Order.toString() + "_" + m_OrderMove_X.toString() + "_" + m_OrderMove_Y.toString() + "_" + a.toString() + "_" + m_OrderId.toString(), AnswerOrder, false);

			} else if (m_Order == SpaceShip.soFollow) {
				ship.OrderFollow(m_OrderEntityType, m_OrderId, m_OrderDist, m_OrderAngle);

				ship.m_Anm++;
				ship.m_LoadAfterAnm = ship.m_Anm;
				ship.m_LoadAfterAnm_Timer = Common.GetTime();

				Server.Self.QuerySS("emspaceorder", "&val=" + ship.m_ZoneX.toString() + "_" + ship.m_ZoneY.toString() + "_" + ship.m_Anm.toString() + "_" + m_OrderForType.toString() + "_" + m_OrderForId.toString() + "_" +
					m_Order.toString() + "_" + m_OrderEntityType.toString() + "_" + m_OrderId.toString() + "_" + m_OrderDist.toString() + "_" + m_OrderAngle.toString(), AnswerOrder, false);

			} else if (m_Order == SpaceShip.soDock) {
				ship.OrderDock(m_OrderEntityType, m_OrderId, m_OrderFlag, m_OrderDist);

				ship.m_Anm++;
				ship.m_LoadAfterAnm = ship.m_Anm;
				ship.m_LoadAfterAnm_Timer = Common.GetTime();

				Server.Self.QuerySS("emspaceorder", "&val=" + ship.m_ZoneX.toString() + "_" + ship.m_ZoneY.toString() + "_" + ship.m_Anm.toString() + "_" + m_OrderForType.toString() + "_" + m_OrderForId.toString() + "_" +
					m_Order.toString() + "_" + m_OrderEntityType.toString() + "_" + m_OrderId.toString() + "_" + m_OrderFlag.toString() + "_" + m_OrderDist.toString(), AnswerOrder, false);

			} else if (m_Order == SpaceShip.soMove) {
				px = m_OrderMove_X - ship.m_ZoneX * SP.m_ZoneSize;
				py = m_OrderMove_Y - ship.m_ZoneY * SP.m_ZoneSize;
				a = Math.round(Math.atan2(px - ship.m_PosX, py - ship.m_PosY) * 10000);
				ship.OrderMove(px, py, Number(a) / 10000.0);
				ship.m_Anm++;
				ship.m_LoadAfterAnm = ship.m_Anm;
				ship.m_LoadAfterAnm_Timer = Common.GetTime();
//trace("SendMove, OrderPos:", m_OrderMove_X, m_OrderMove_Y, "Zone:", ship.m_ZoneX, ship.m_ZoneY, "Place:", ship.m_PlaceX, ship.m_PlaceY);

				Server.Self.QuerySS("emspaceorder", "&val=" + ship.m_ZoneX.toString() + "_" + ship.m_ZoneY.toString() + "_" + ship.m_Anm.toString() + "_" + m_OrderForType.toString() + "_" + m_OrderForId.toString() + "_" +
					SpaceShip.soMove.toString() + "_" + m_OrderMove_X.toString() + "_" + m_OrderMove_Y.toString() + "_" + a.toString(), AnswerOrder, false);
			}
			m_Order = 0;
		}
	}
	
	public function CanTake(cont:SpaceContainer):Boolean
	{
		var fleet:SpaceFleet = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId) as SpaceFleet;
		if (!fleet) return false;

		if (fleet.m_PFlag & SpaceShip.PFlagForsageOn) return false;

		if (fleet.Dist2(cont) >= SpaceContainer.TakeDist * SpaceContainer.TakeDist) return false;
		
		return true;
	}
	
	public function Take(cont:SpaceContainer):void
	{
		var fleet:SpaceFleet = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId) as SpaceFleet;
		if (!fleet) return;

		var shu:SpaceShuttle = SP.EntityFind(SpaceEntity.TypeShuttle, fleet.m_ShuttleId) as SpaceShuttle;
		if (!shu) return;
		
		if (!cont.m_ItemType) return;
		
		if (!shu.TakeCorrect()) return;

		var contanm:Vector.<uint> = new Vector.<uint>();
		if (!shu.TakeDel(cont, Common.GetTime(), contanm)) {
			if (cont.m_ItemCnt > 0) {

				if (!CanTake(cont)) return;
				if (!EM.CanTransfer(fleet.m_Owner, cont.m_Owner)) { EM.m_FormHint.Show(Common.Txt.WarningItemNoAccessOpByRank, Common.WarningHideTime); return; }

				shu.TakeAdd(cont, Common.GetTime(), contanm);
			}
		}

		shu.m_Anm++;
		shu.m_LoadAfterAnm = shu.m_Anm;
		shu.m_LoadAfterAnm_Timer = Common.GetTime();

		var str:String = "";
		if (contanm.length >= 2) {
			str += "_" + contanm[0].toString();
			str += "_" + contanm[1].toString();
		}
		if (contanm.length >= 4) {
			str += "_" + contanm[2].toString();
			str += "_" + contanm[3].toString();
		}

		Server.Self.QuerySS("emspacetake", "&val=" + shu.m_ZoneX.toString() + "_" + shu.m_ZoneY.toString() + "_" + shu.m_Anm.toString() + "_" + shu.m_EntityType.toString() + "_" + shu.m_Id.toString() + "_" +
			cont.m_Id.toString() + str, AnswerOrder, false);
	}

	public function Drop(itemtype:uint, itemcnt:int, slotno:int = -1):void
	{
		var ent:SpaceEntity = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId);
		if (ent == null) return;
		if (!(ent is SpaceFleet)) return;
		var fleet:SpaceFleet = ent as SpaceFleet;
		
		if (fleet.m_PFlag & SpaceShip.PFlagForsageOn) return;

		ent = SP.EntityFind(SpaceEntity.TypeShuttle, fleet.m_ShuttleId);
		if (ent == null) return;
		if (!(ent is SpaceShuttle)) return;
		var shu:SpaceShuttle = ent as SpaceShuttle;

		shu.m_Anm++;
		shu.m_LoadAfterAnm = shu.m_Anm;
		shu.m_LoadAfterAnm_Timer = Common.GetTime();

		Server.Self.QuerySS("emspacedrop", "&val=" + shu.m_ZoneX.toString() + "_" + shu.m_ZoneY.toString() + "_" + shu.m_Anm.toString() + "_" + shu.m_EntityType.toString() + "_" + shu.m_Id.toString() + "_" +
			itemtype.toString(16) + "_" + itemcnt.toString() + "_" + slotno.toString(), AnswerOrder, false);
	}

	private function AnswerOrder(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray = loader.data;
		if (loader.data == null) return;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int = buf.readUnsignedByte();
		if (EM.ErrorFromServer(err)) return;
	}

	public function OrderTarget(enttype:int, entid:uint):void
	{
		var fleet:SpaceFleet = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId) as SpaceFleet;
		if (fleet == null) return;

		if ((fleet.m_State & SpaceShip.StateLive) == 0) return;
		if ((fleet.m_State & SpaceShip.StateBuild) != 0) return;

		if (enttype == fleet.m_TargetType && entid == fleet.m_TargetId) {
			enttype = 0;
			entid = 0;
		}
		fleet.OrderTarget(enttype, entid);

		fleet.m_Anm++;
		fleet.m_LoadAfterAnm = fleet.m_Anm;
		fleet.m_LoadAfterAnm_Timer = Common.GetTime();

		Server.Self.QuerySS("emspacetgt", "&val=" + fleet.m_ZoneX.toString() + "_" + fleet.m_ZoneY.toString() + "_" + fleet.m_Anm.toString() + "_" +SpaceEntity.TypeFleet.toString() + "_" +EM.m_RootFleetId + "_" + 
			enttype.toString() + "_" + entid.toString(), AnswerOrder, false);
	}

	public function LoadCotl():void
	{
		if (Server.Self.IsSendCommand("emcotl")) return;

		var i:int;
		var qs:String = "";
		var cotl:SpaceCotl;

		var ct:Number = EM.m_CurTime;
		m_LoadCotl_Timer = ct;

		for each (cotl in m_CotlMap) {
//		for (i = 0; i < m_CotlAll.length; i++) {
//			cotl = m_CotlAll[i];
			if (!cotl.m_Reload) continue;

			if (SP.EntityFind(SpaceEntity.TypeCotl, cotl.m_Id, false) != null) {
				// Созвездие которое загружается через видимое пространство не нужно загружать прямым способом.
				if (cotl.m_RecvFull) cotl.m_Reload = false;
				continue;
			}

			if (qs.length > 0) qs += "_";
			qs += cotl.m_Id.toString();
			if (qs.length > 64) break;
		}
		if (qs.length <= 0) { m_LoadCotl = false; return; }

		Server.Self.QueryHS("emcotl", '&cotl=' + qs, LoadCotlAnswer, false);
	}
	
	private function LoadCotlAnswer(event:Event):void
	{
		var x:int,y:int,u:int;
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		m_LoadCotl_Timer = EM.m_CurTime;

		var loadok:Boolean=false;

		var sl:SaveLoad=new SaveLoad();

		while(true) {
			var cotl_id:int=buf.readUnsignedInt();
//trace("LoadCotlAnswer02",cotl_id);
			if (!cotl_id) break;

//trace("emcotl answer",cotl_id);

			var cotl:SpaceCotl = GetCotl(cotl_id, false);
			cotl.m_Reload = false;
			cotl.m_LoadTime = EM.m_CurTime;

			cotl.m_AccountId = buf.readUnsignedInt();
			cotl.m_UnionId = buf.readUnsignedInt();
			cotl.m_CotlType = buf.readInt();
			cotl.m_CotlSize = buf.readInt();
			/*cotl.m_SlotCnt = */buf.readInt();

			cotl.m_ProtectTime = 1000 * buf.readUnsignedInt();
//trace("LoadCotlAnswer.","AccountId:",cotl.m_AccountId,"UnionId:",cotl.m_UnionId,"Type:",cotl.m_Type,"Pos:",cotl.m_X,cotl.m_Y);

			if (cotl.m_CotlType == Common.CotlTypeProtect || cotl.m_CotlType == Common.CotlTypeRich) cotl.m_RewardExp = buf.readInt();

			if(cotl.m_CotlType!=Common.CotlTypeUser) {
				cotl.m_BonusType0=buf.readUnsignedByte();
				cotl.m_BonusVal0=buf.readUnsignedInt();
				cotl.m_BonusType1=buf.readUnsignedByte();
				cotl.m_BonusVal1=buf.readUnsignedInt();
				cotl.m_BonusType2=buf.readUnsignedByte();
				cotl.m_BonusVal2=buf.readUnsignedInt();
				cotl.m_BonusType3=buf.readUnsignedByte();
				cotl.m_BonusVal3 = buf.readUnsignedInt();
				//cotl.m_RewardExp=buf.readInt();
				//cotl.m_MaxRating=buf.readInt();
			
				cotl.m_PriceEnterType = buf.readInt();
				if (cotl.m_PriceEnterType != 0) cotl.m_PriceEnter = buf.readInt(); else cotl.m_PriceEnter = 0;
				cotl.m_PriceCaptureType = buf.readInt();
				if (cotl.m_PriceCaptureType != 0) cotl.m_PriceCapture = buf.readInt(); else cotl.m_PriceCapture = 0;
				cotl.m_PriceCaptureEgm = buf.readInt();
			} else {
				cotl.m_BonusType0=0;
				cotl.m_BonusVal0=0;
				cotl.m_BonusType1=0;
				cotl.m_BonusVal1=0;
				cotl.m_BonusType2=0;
				cotl.m_BonusVal2=0;
				cotl.m_BonusType3=0;
				cotl.m_BonusVal3 = 0;
				cotl.m_PriceEnterType=0;
				cotl.m_PriceEnter=0;
				cotl.m_PriceCaptureType=0;
				cotl.m_PriceCapture=0;
				cotl.m_PriceCaptureEgm=0;
			}
			
			cotl.m_Dev0 = buf.readUnsignedInt();
			cotl.m_Dev1 = buf.readUnsignedInt();
			cotl.m_Dev2 = buf.readUnsignedInt();
			cotl.m_Dev3 = buf.readUnsignedInt();
			cotl.m_DevAccess = buf.readUnsignedInt();
			cotl.m_DevFlag = buf.readUnsignedInt();
			cotl.m_DevTime = 1000 * buf.readUnsignedInt();

			cotl.m_CotlFlag = buf.readUnsignedInt();

			cotl.m_ServerAdr=buf.readUnsignedInt();
			if(cotl.m_ServerAdr==0) {
				cotl.m_ServerPort=0;
				cotl.m_ServerNum=0;
				cotl.m_ServerMode=0;
			} else {
				cotl.m_ServerPort=buf.readUnsignedInt();
				cotl.m_ServerNum=buf.readUnsignedInt();
				cotl.m_ServerMode=buf.readUnsignedInt();
			}
			
			cotl.m_RecvInfo = true;

			loadok=true;
		}

		if(loadok) {
			EM.GoToProcess();
		}
	}
	
	public override function CamCalc(dt:Number):void
	{
		var i:int;
		var ent:SpaceEntity;
		var hf:HyperspaceFleet;
		var ship:SpaceShip;
		var zcamcenter:Number = 0.0;
		
		if (m_CenterType == FollowHomeworld) {
			m_CenterZoneX = Math.floor(EM.m_HomeworldCotlX / SP.m_ZoneSize);
			m_CenterZoneY = Math.floor(EM.m_HomeworldCotlY / SP.m_ZoneSize);
			m_CenterX = EM.m_HomeworldCotlX - m_CenterZoneX * SP.m_ZoneSize;
			m_CenterY = EM.m_HomeworldCotlY - m_CenterZoneY * SP.m_ZoneSize;

		} else if (m_CenterType == FollowCitadel) {
			for (i = 0; i < Common.CitadelMax; i++) {
				if (EM.m_CitadelNum[i] < 0) continue;
				if (EM.m_CitadelCotlId[i] != m_CenterId) continue;

				m_CenterZoneX = Math.floor(EM.m_CitadelCotlX[i] / SP.m_ZoneSize);
				m_CenterZoneY = Math.floor(EM.m_CitadelCotlY[i] / SP.m_ZoneSize);
				m_CenterX = EM.m_CitadelCotlX[i] - m_CenterZoneX * SP.m_ZoneSize;
				m_CenterY = EM.m_CitadelCotlY[i] - m_CenterZoneY * SP.m_ZoneSize;
				break;
			}

		} else if (m_CenterType == FollowFleet) {
			ent = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId);

			hf = HyperspaceFleetById(EM.m_RootFleetId);
		
			if (hf != null) {
				ship = ent as SpaceShip;
				m_CenterZoneX = hf.m_ZoneX;
				m_CenterZoneY = hf.m_ZoneY;
				m_CenterX = hf.m_PosX;
				m_CenterY = hf.m_PosY;
			} else {
				m_CenterZoneX = Math.floor(EM.m_FleetPosX / SP.m_ZoneSize);
				m_CenterZoneY = Math.floor(EM.m_FleetPosY / SP.m_ZoneSize);
				m_CenterX = EM.m_FleetPosX - m_CenterZoneX * SP.m_ZoneSize;
				m_CenterY = EM.m_FleetPosY - m_CenterZoneY * SP.m_ZoneSize;
			}
		}

		var ft:int = m_FollowType;
		if (ft == FollowNone) {
			m_CamPos.z = 0;
			
		} else if (ft == FollowHomeworld) {
			m_CamZoneX = Math.floor(EM.m_HomeworldCotlX / SP.m_ZoneSize);
			m_CamZoneY = Math.floor(EM.m_HomeworldCotlY / SP.m_ZoneSize);
			m_CamPos.x = EM.m_HomeworldCotlX - m_CamZoneX * SP.m_ZoneSize;
			m_CamPos.y = EM.m_HomeworldCotlY - m_CamZoneY * SP.m_ZoneSize;
			m_CamPos.z = -700;

		} else if (ft == FollowCitadel) {
			for (i = 0; i < Common.CitadelMax; i++) {
				if (EM.m_CitadelNum[i] < 0) continue;
				if (EM.m_CitadelCotlId[i] != m_FollowId) continue;

				m_CamZoneX = Math.floor(EM.m_CitadelCotlX[i] / SP.m_ZoneSize);
				m_CamZoneY = Math.floor(EM.m_CitadelCotlY[i] / SP.m_ZoneSize);
				m_CamPos.x = EM.m_CitadelCotlX[i] - m_CamZoneX * SP.m_ZoneSize;
				m_CamPos.y = EM.m_CitadelCotlY[i] - m_CamZoneY * SP.m_ZoneSize;
				m_CamPos.z = -700;
				break;
			}

		} else if (ft == FollowFleet) {
			ent = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId);

			hf = HyperspaceFleetById(EM.m_RootFleetId);
		
			if (hf != null) {
				ship = ent as SpaceShip;
				m_CamZoneX = hf.m_ZoneX;
				m_CamZoneY = hf.m_ZoneY;
				m_CamPos.x = hf.m_PosX;
				m_CamPos.y = hf.m_PosY;
				m_CamPos.z = hf.m_PosZ;
			} else {
				m_CamZoneX = Math.floor(EM.m_FleetPosX / SP.m_ZoneSize);
				m_CamZoneY = Math.floor(EM.m_FleetPosY / SP.m_ZoneSize);
				m_CamPos.x = EM.m_FleetPosX - m_CamZoneX * SP.m_ZoneSize;
				m_CamPos.y = EM.m_FleetPosY - m_CamZoneY * SP.m_ZoneSize;
				m_CamPos.z = 0;
			}
			if (m_CamPos.z < 0.0) zcamcenter = m_CamPos.z * 0.25;
		}

		super.CamCalc(dt);

		if (m_CamPos.z != zcamcenter) {
			m_TPos.x = m_CamPos.x;
			m_TPos.y = m_CamPos.y;
			m_TPos.z = zcamcenter;
			m_TDir.x = 0.0;
			m_TDir.y = 0.0;
			m_TDir.z = 1.0;
			PlaneFromPointNormal(m_TPos, m_TDir, m_TPlane);

			m_TPos.x = m_CamPos.x + m_View.x;
			m_TPos.y = m_CamPos.y + m_View.y;
			m_TPos.z = m_CamPos.z + m_View.z;

			if (PlaneIntersectionLine(m_TPlane, m_CamPos, m_TPos, m_TDir)) {
				var k:Number = m_CamDist - Math.sqrt((m_TDir.x - m_CamPos.x) * (m_TDir.x - m_CamPos.x) + (m_TDir.y - m_CamPos.y) * (m_TDir.y - m_CamPos.y) + (m_TDir.z - m_CamPos.z) * (m_TDir.z - m_CamPos.z));
				if ((m_TDir.z < m_CamPos.z) && (k < CamDistMin)) {
					var vd:Number = 1.0 / Math.sqrt(m_View.x * m_View.x + m_View.y * m_View.y + m_View.z * m_View.z);
					m_CamPos.x = m_TDir.x + m_View.x * vd * (CamDistMin - k);
					m_CamPos.y = m_TDir.y + m_View.y * vd * (CamDistMin - k);
					m_CamPos.z = m_TDir.z + m_View.z * vd * (CamDistMin - k);
				} else {
					m_CamPos.x = m_TDir.x;
					m_CamPos.y = m_TDir.y;
					m_CamPos.z = m_TDir.z;
				}
			}
		}
	}

	public override function Draw():void
	{
		super.Draw();

		if (!EM.m_FormRadar.m_OpenFull) {
//trace(m_CenterZoneX * SP.m_ZoneSize + m_CenterX - m_OffX, m_CenterZoneY * SP.m_ZoneSize + m_CenterY - m_OffY);
			EM.m_FormRadar.SetCenter(m_CenterZoneX * SP.m_ZoneSize + m_CenterX/* - m_OffX*/, m_CenterZoneY * SP.m_ZoneSize + m_CenterY/* - m_OffY*/);
			//EM.m_FormRadar.SetCenter(m_CamZoneX * m_ZoneSize + m_CamPos.x, m_CamZoneY * m_ZoneSize + m_CamPos.y);
			EM.m_FormRadar.Update();
		} else if(m_RadarUpdateTime+1000<m_CurTime) {
			m_RadarUpdateTime=m_CurTime;
			EM.m_FormRadar.Update();
		}
	}

	public function ForsageAccessClient():void
	{
		var fleet:SpaceFleet = SP.EntityFind(SpaceEntity.TypeFleet, EM.m_RootFleetId) as SpaceFleet;
		if (!fleet) return;

		var ret:Boolean = true;

		while (true) {
			var shu:SpaceShuttle = SP.EntityFind(SpaceEntity.TypeShuttle, fleet.m_ShuttleId) as SpaceShuttle;
			if (!shu) { ret = false; break; }

			if ((shu.m_PFlag & SpaceShip.PFlagInDock) == 0) { ret = false; break; }
			if ((shu.m_PFlag >> 24) != fleet.m_EntityType) { ret = false; break; }
			if (shu.m_PId != fleet.m_Id) { ret = false; break; }

			if (shu.m_DropProgressId) { ret = false; break; }
			if (shu.m_TakeProgressId) { ret = false; break; }

			break;
		}

		if(ret) {
			if (fleet.m_PFlag & SpaceShip.PFlagForsageClientReady) return;
		} else {
			if (!(fleet.m_PFlag & SpaceShip.PFlagForsageClientReady)) return;
		}
		
		if (ret) fleet.m_PFlag |= SpaceShip.PFlagForsageClientReady;
		else fleet.m_PFlag &= ~SpaceShip.PFlagForsageClientReady;

		fleet.m_Anm++;
		fleet.m_LoadAfterAnm = fleet.m_Anm;
		fleet.m_LoadAfterAnm_Timer = Common.GetTime();

		Server.Self.QuerySS("emspacefcr", "&val=" + fleet.m_ZoneX.toString() + "_" + fleet.m_ZoneY.toString() + "_" + fleet.m_Anm.toString() + "_" + fleet.m_EntityType.toString() + "_" + fleet.m_Id.toString() + "_" +
			(ret?"1":"0"), AnswerOrder, false);
//trace("emspacefcr", ret);
	}
}

}
