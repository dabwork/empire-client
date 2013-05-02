package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.utils.*;

public class FormMiniMap extends Sprite
{
	private var EM:EmpireMap = null;
	
	static public const MapFlagNoEmpty:uint=1<<2;

	static public const MapFlagArrivalDef:uint=1<<3;
	static public const MapFlagArrivalAtk:uint=1<<4;

	static public const MapFlagTypeMask:uint = (1 << 8) | (1 << 9) | (1 << 10) | (1 << 11);
	static public const MapFlagTypePulsar:uint = 1 << 8;
	static public const MapFlagTypeSun:uint = 2 << 8;
	static public const MapFlagTypeGigant:uint = 3 << 8;
	static public const MapFlagTypeUninhabited:uint = 4 << 8;
	static public const MapFlagTypeLive:uint = 5 << 8;
	static public const MapFlagTypeRich:uint = 6 << 8;
	static public const MapFlagTypeWormhole:uint = 7 << 8;
	static public const MapFlagTypeWormholeRoam:uint = 8 << 8;

//	static public const MapFlagUninhabited:uint=1<<8;
//	static public const MapFlagPulsar:uint=1<<9;
//	static public const MapFlagWormhole:uint=1<<10;
//	static public const MapFlagRich:uint = 1 << 11;

	static public const MapFlagCrystal:uint=1<<12;
	static public const MapFlagTitan:uint=1<<13;
	static public const MapFlagSilicon:uint=MapFlagCrystal|MapFlagTitan;
	static public const MapFlagWormholeExist:uint=1<<14;
	static public const MapFlagHomeworld:uint=1<<15;
	static public const MapFlagCitadel:uint=1<<16;
	static public const MapFlagFriend:uint=1<<17;
	static public const MapFlagEnemy:uint=1<<18;
	static public const MapFlagFlagship:uint = 1 << 19;

	static public const MapFlagBuildingLvl:uint=1<<21;

	static public const MapFlagServiceBase:uint=1<<22;
	static public const MapFlagTransport:uint=1<<23;
	static public const MapFlagCorvette:uint=1<<24;
	static public const MapFlagCruiser:uint=1<<25;
	static public const MapFlagDreadnought:uint=1<<26;
	static public const MapFlagInvader:uint=1<<27;
	static public const MapFlagDevastator:uint=1<<28;
	static public const MapFlagWarBase:uint=1<<29;
	static public const MapFlagShipyard:uint=1<<30;
	static public const MapFlagSciBase:uint = 0x80000000;// 1 << 31;

	static public const MapFlagFriendForHyperspace:uint = MapFlagNoEmpty;// 1 << 1;
	static public const MapFlagEnemyForHyperspace:uint = 1 << 5;// 22;
	static public const MapFlagOwnerForHyperspace:uint = 1 << 6;// 21;
	static public const MapFlagOwner:uint = 1 << 7;// 20;

	static public const MMSizePlanet:int=4+4+4*10+4+4;
	public var m_MMData:ByteArray=new ByteArray();
	public var m_PlanetPos:ByteArray=new ByteArray();
//	public var m_PlanetOwner:ByteArray=new ByteArray();
	public var m_MapVersion:uint=0;

	public var m_ShipPlayerData:ByteArray=new ByteArray();

	public var m_SizeX:int;
	public var m_SizeY:int;

	public var m_OffsetX:Number;
	public var m_OffsetY:Number;

	public var m_Scale:Number;
	public var m_ScaleKof:Number=16;
	public var m_ScaleKofDefault:Number=16;
	public var m_ScaleDir:Number=0;

	public var m_Move:Boolean=false;
	public var m_Float:Boolean=false;

	public var m_MousePosOldX:int=0;
	public var m_MousePosOldY:int=0;

	public var m_ScrollTimeLU:Number=0;
	public var m_ScrollTimerDirX:int=0;
	public var m_ScrollTimerDirY:int=0;

	public var m_Timer:Timer;

	public var m_OpenFull:Boolean=false;
	public var m_ShowPlanet:Boolean=true;
	public var m_ShowShip:Boolean=true;
	
	public var m_BMC:Bitmap=null;
	public var m_BMC2:Bitmap=null;

	public var m_CurOwner:uint=0;
//	public var m_CurIsland:int=0;

	public var m_ShowWormholePath:Boolean=false;
	public var m_ShowPortalPath:Boolean=false;

	public var m_Island:Array=new Array();
//	public var m_VisitColony:Array=new Array();

	public var m_NeedScrollToView:Boolean = false;
	public var m_TimerUpdate:Timer = new Timer(25, 0);
	public var m_TimeScale:Timer=new Timer(150);
	public var m_TimerShipPlayer:Timer=new Timer(50);

	public var m_CaptionBG:Sprite = null;
	public var m_CaptionBG2:Sprite = null;
	public var m_Raz1:Sprite = null;
	public var m_Raz2:Sprite = null;
	public var m_FooterBG:Sprite = null;
	public var m_ButOptions:SimpleButton = null;
	public var m_ButOpen:SimpleButton = null;
	public var m_ButHomeworld:SimpleButton = null;
	public var m_ButCitadel:SimpleButton = null;
	public var m_ButColony:SimpleButton = null;
//	public var m_ButCombat:SimpleButton = null;
	public var m_ButMinus:SimpleButton = null;
	public var m_ButPlus:SimpleButton = null;
	public var m_CotlName:TextField = null;

	public var m_ShowRes:Boolean=false;
	public var m_ShowShipPlayer:uint = 0;
	public var m_ShowBuildingType:uint = 0;

	public var m_ShipPlayerQueryTime:Number=0;
	public var m_ShipPlayerQueryCooldown:Number=0;

//	public var m_NoEnterFromHyperspace:Boolean=false;
//	public var m_NoEnterFromHyperspaceOwner:Boolean=false;
	
	public var m_Occupancy:int=0;
	
	public var m_LandingAccess:Array=new Array();

	public function FormMiniMap(map:EmpireMap)
	{
		EM=map;
		m_SizeX=200;
		m_SizeY=200;

		m_OffsetX=0;
		m_OffsetY=0;
		m_Scale = 5000;
		
		CONFIG::mobil {
			m_TimerUpdate.delay = 100;
		}

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

		doubleClickEnabled=true; 
		addEventListener(MouseEvent.DOUBLE_CLICK,MiniMapLarge);

		m_TimerUpdate.addEventListener("timer", UpdateTimer);
		m_TimerUpdate.stop();
		
		m_TimeScale.addEventListener("timer", ScaleTimer);
		m_TimeScale.stop();
		
		m_TimerShipPlayer.addEventListener("timer", ShipPlayerTimer);
		m_TimerShipPlayer.stop();

		m_PlanetPos.endian=Endian.LITTLE_ENDIAN;
//		m_PlanetOwner.endian=Endian.LITTLE_ENDIAN;
		
		m_BMC2=new Bitmap();
		addChild(m_BMC2);
		
		m_BMC=new Bitmap();
		addChild(m_BMC);
		
		m_CaptionBG=new MMCaptionBG();
		addChild(m_CaptionBG);
		
		m_CaptionBG2=new MMCaptionBG2();
		addChild(m_CaptionBG2);

		m_FooterBG=new MMFooterBG();
		addChild(m_FooterBG);
		
		m_ButOptions=new MMButOptions();
		addChild(m_ButOptions);

		m_ButHomeworld=new MMButCapital();
		addChild(m_ButHomeworld);
		m_ButCitadel=new MMButCitadel();
		addChild(m_ButCitadel);
		m_ButColony=new MMButColony();
		addChild(m_ButColony);
//		m_ButCombat=new MMButCombat();
//		addChild(m_ButCombat);

		m_ButMinus=new MMButMinus();
		addChild(m_ButMinus);
		m_ButPlus=new MMButPlus();
		addChild(m_ButPlus);
		
		m_Raz1=new MMCaptionRaz();
		addChild(m_Raz1);
		m_Raz2=new MMCaptionRaz();
		addChild(m_Raz2);
		
		m_CotlName=new TextField();
		m_CotlName.width=1;
		m_CotlName.height=1;
		m_CotlName.type=TextFieldType.DYNAMIC;
		m_CotlName.selectable=false;
		m_CotlName.textColor=0xffffff;
		m_CotlName.background=false;
		m_CotlName.backgroundColor=0x80000000;
		m_CotlName.alpha=1.0;
		m_CotlName.multiline=false;
		m_CotlName.autoSize=TextFieldAutoSize.LEFT;
		m_CotlName.gridFitType=GridFitType.NONE;
		m_CotlName.defaultTextFormat=new TextFormat("Calibri",14,0xAfAfAf);
		m_CotlName.embedFonts=true;
		addChild(m_CotlName);

		//m_ButMinus.addEventListener(MouseEvent.,MiniMapLarge);
	}

	public function fjOver(e:MouseEvent):void
	{
		var l:TextField=e.target as TextField;
		l.backgroundColor=0x0000ff;
	}

	public function fjOut(e:MouseEvent):void
	{
		var l:TextField=e.target as TextField;
		l.backgroundColor=0x000000;
	}
	
	public function ClearForNewCotl():void
	{
		m_PlanetPos.length=0;
		//m_PlanetOwner.length=0;
		m_MapVersion=0;
		m_ShipPlayerData.length=0;
		m_LandingAccess.length=0;
		
//		m_NoEnterFromHyperspace=false;
//		m_NoEnterFromHyperspaceOwner=false;
	}

	public function Hide():void
	{
		MouseUnlock();
		m_TimerShipPlayer.stop();
		m_TimeScale.stop();
		ScrollTimerDestroy();
		visible=false;
	}

	public function StageResize():void
	{
		if (!visible) return;
		//&& EmpireMap.Self.IsResize()) Show();

		if (m_OpenFull) m_SizeX = Math.round(Math.min(EM.stage.stageWidth, EM.stage.stageHeight - 30) - 40);
		else m_SizeX = Math.round(Math.min(EM.stage.stageWidth, EM.stage.stageHeight) * 0.3);

		m_SizeY = m_SizeX;
		m_Scale = m_SizeX * m_ScaleKof;

		x = EM.stage.stageWidth - m_SizeX - 11;
		y = 37;

		m_CaptionBG.x = -10;
		m_CaptionBG.y = -33;
		m_CaptionBG.width = m_SizeX + 20;

		m_CaptionBG2.x = -10 + 5;
		m_CaptionBG2.y = 0;//-33;
		m_CaptionBG2.width = m_SizeX + 20 - 10;

		m_FooterBG.x = -10;
		m_FooterBG.y = m_SizeY - 31;
		m_FooterBG.width = m_SizeX + 20;

		Update();
	}

	public function Show():void
	{
		EM.FloatTop(this);

		visible=true;

		if(m_ButOpen) {
			if(m_OpenFull && (m_ButOpen is MMButSmall)) {}
			else if(!m_OpenFull && (m_ButOpen is MMButLarge)) {}
			else {
				removeChild(m_ButOpen);
				m_ButOpen=null;
			}
		}
		if(m_ButOpen==null) {
			if(m_OpenFull) m_ButOpen=new (MMButSmall);
			else m_ButOpen=new MMButLarge();
			addChild(m_ButOpen);
		}

		m_TimerShipPlayer.start();

		StageResize();
	}

	public function UpdateBut(short:Boolean=false):void
	{
//		var short:Boolean=false;

//		if(m_SizeX<240) {
//			short=true;
//			if(m_SizeX<195) m_SizeX=195;
//		}

		var right:int = m_SizeX - m_ButOpen.width + 3;
		if(short) right+=1;
		m_ButOpen.x=right;
		m_ButOpen.y=-36;

		if(short) m_ButOptions.x=-4;
		else m_ButOptions.x=-2;
		m_ButOptions.y = -28;

		var sx:int = -1 + 25;
		if (!short) sx = -1 + 50;

		//if(EM.m_HomeworldCotlId!=0) {
			// Домашние созвездие есть всегда.
			m_ButHomeworld.x = sx;
			m_ButHomeworld.y = -29;
			sx += 26;
			m_ButHomeworld.visible = true;
		//} else {
		//	m_ButHomeworld.visible = false;
		//}

		//if(EM.m_CitadelCotlId!=0) {
		if (EM.CitadelExistAny()) {
			m_ButCitadel.x = sx;
			m_ButCitadel.y = -29;
			sx += 26;
			m_ButCitadel.visible = true;
		} else {
			m_ButCitadel.visible = false;
		}

//		if(EM.m_UserCombatId!=0) {
//			m_ButCombat.x = sx;
//			m_ButCombat.y = -29;
//			sx += 26;
//			m_ButColony.visible = false;
//			m_ButCombat.visible = true;
//		} else
		if (EM.IsWinMaxEnclave()) {
			if (EM.m_BasePlanetNum >= 0) {
				m_ButColony.x = sx;
				m_ButColony.y = -29;
				sx += 26;

				m_ButColony.visible = true;
//				m_ButCombat.visible = false;
			} else {
				m_ButColony.visible = false;
//				m_ButCombat.visible = false;
			}
		}
		else {
			m_ButColony.x = sx;
			m_ButColony.y = -29;
			sx += 26;

			m_ButColony.visible = false;// true;
//			m_ButCombat.visible = false;
		}

		if(short) right-=50;
		else right-=55;
		m_ButMinus.x=right;
		m_ButMinus.y=-27;
		m_ButPlus.x=right;
		m_ButPlus.y=-27;

		if(short) {
			m_Raz1.visible=false;
			m_Raz2.visible=false;
		} else {
			m_Raz1.x=28;
			m_Raz1.y=-32;
			m_Raz1.visible=true;
			m_Raz2.x=right-5;
			m_Raz2.y=-32;
			m_Raz2.visible = true;
			
			right -= 5+10;
		}

		if (!short && (sx > right)) {
			UpdateBut(true);
		}
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;

		if(m_CaptionBG.hitTestPoint(stage.mouseX,stage.mouseY)) return true;
		if(m_FooterBG.hitTestPoint(stage.mouseX,stage.mouseY)) return true;
		if(m_ButOpen.hitTestPoint(stage.mouseX,stage.mouseY)) return true;

		return mouseX>=0 && mouseX<m_SizeX && mouseY>=0 && mouseY<m_SizeY;
	}

	private var m_MouseLock:Boolean = false;

	public function MouseLock():void
	{
		if (m_MouseLock) return;
		m_MouseLock = true;
		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,false,999);

		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,true,999);
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,false);
		
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,true);
	}

	public function ScaleTimer(event:TimerEvent=null):void
	{
		m_ScaleKof+=m_ScaleDir;
		if(m_ScaleKof<5) m_ScaleKof=5;
		else if(m_ScaleKof>80) m_ScaleKof=80;

		m_Scale=m_SizeX*m_ScaleKof;
		Update();
		ShipPlayerQuery(true);
	}

	public function onMouseDown(e:MouseEvent):void
	{
		var i:int;
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

		e.stopImmediatePropagation();
		EM.FloatTop(this);

		var ra:Array;

		if (m_ButOptions.hitTestPoint(stage.mouseX, stage.mouseY) && EM.m_Action==0) { SetOpen(); return;  } // { if (EM.m_FormMenu.visible) EM.m_FormMenu.Clear(); else SetOpen(); return;  }
		//EM.m_FormMenu.Clear();
			
		if(m_ButOpen.hitTestPoint(stage.mouseX,stage.mouseY)) {
			MiniMapLarge();
			
		} else if(m_ButHomeworld.hitTestPoint(stage.mouseX,stage.mouseY)) {
			if (EM.m_Action != 0 && EM.m_HomeworldCotlId != Server.Self.m_CotlId) {
			} else if (EM.m_HomeworldCotlId == 0) {
				EM.GoRootCotl();
			} else {
//				m_VisitColony.length = 0;
				EM.GoTo(true, EM.m_HomeworldCotlId, EM.m_HomeworldSectorX, EM.m_HomeworldSectorY, EM.m_HomeworldPlanetNum);
			}

		} else if (m_ButCitadel.visible && m_ButCitadel.hitTestPoint(stage.mouseX, stage.mouseY)) {
			while (true) {
				i = -1;
				if (EmpireMap.Self.m_LastViewCitadelCotlId != 0) {
					i = EmpireMap.Self.CitadelFindEx(EmpireMap.Self.m_LastViewCitadelCotlId, EmpireMap.Self.m_LastViewCitadelSecX, EmpireMap.Self.m_LastViewCitadelSecY, EmpireMap.Self.m_LastViewCitadelPlanet);
					if (i >= 0) {
						i++;
						for (; i < Common.CitadelMax; i++) {
							if (EmpireMap.Self.m_CitadelNum[i] < 0) continue;
							break;
						}
						if (i >= Common.CitadelMax) i = -1;
					}
				}
				if (i < 0) {
					for (i = 0; i < Common.CitadelMax; i++) {
						if (EmpireMap.Self.m_CitadelNum[i] < 0) continue;
						break;
					}
					if (i >= Common.CitadelMax) i = -1;
				}

				if (i < 0 || i>=Common.CitadelMax) break;
				EmpireMap.Self.m_LastViewCitadelCotlId = EmpireMap.Self.m_CitadelCotlId[i];
				EmpireMap.Self.m_LastViewCitadelSecX = EmpireMap.Self.m_CitadelSectorX[i];
				EmpireMap.Self.m_LastViewCitadelSecY = EmpireMap.Self.m_CitadelSectorY[i];
				EmpireMap.Self.m_LastViewCitadelPlanet = EmpireMap.Self.m_CitadelNum[i];
				EM.GoTo(true, EmpireMap.Self.m_LastViewCitadelCotlId, EmpireMap.Self.m_LastViewCitadelSecX, EmpireMap.Self.m_LastViewCitadelSecY, EmpireMap.Self.m_LastViewCitadelPlanet);

				break;
			}
//			if (EM.m_Action != 0 && EM.m_CitadelCotlId != Server.Self.m_CotlId) {
//			} else {
//				m_VisitColony.length=0;
//				EM.GoTo(true, EM.m_CitadelCotlId, EM.m_CitadelSectorX, EM.m_CitadelSectorY, EM.m_CitadelNum);
//			}

		} else if(m_ButColony.visible && m_ButColony.hitTestPoint(stage.mouseX,stage.mouseY)) {
			//GoColony();
			GoBase();

//		} else if (m_ButCombat.visible && m_ButCombat.hitTestPoint(stage.mouseX, stage.mouseY)) {
//			if(EM.m_FormCombat.visible) EM.m_FormCombat.Hide();
//			else EM.m_FormCombat.ShowEx(EM.m_UserCombatId);

		} else if(m_ButMinus.hitTestPoint(stage.mouseX,stage.mouseY)) {
			m_ScaleKof+=2;
			if(m_ScaleKof<5) m_ScaleKof=5;
			else if(m_ScaleKof>80) m_ScaleKof=80;
	
			m_Scale=m_SizeX*m_ScaleKof;
			Update();
			m_ScaleDir=+2;
			m_TimeScale.start();
			ShipPlayerQuery(true);
		
		} else if(m_ButPlus.hitTestPoint(stage.mouseX,stage.mouseY)) {
			m_ScaleKof-=2;
			if(m_ScaleKof<5) m_ScaleKof=5;
			else if(m_ScaleKof>80) m_ScaleKof=80;
	
			m_Scale=m_SizeX*m_ScaleKof;
			Update();
			m_ScaleDir=-2;
			m_TimeScale.start();
			ShipPlayerQuery(true);
			
		} else if(m_CaptionBG.hitTestPoint(stage.mouseX,stage.mouseY)) {
			
		}
		else if (addkey) {
			MouseLock();
			
			m_Float = true;
			m_MousePosOldX=mouseX;
			m_MousePosOldY=mouseY;

			EM.m_GoOpen=false;
			EM.SetCenter(MapToWorldX(mouseX),MapToWorldY(mouseY));
			Update();
		}
		else {
			MouseLock();
			
			m_Move = true;
			
			EM.m_GoOpen=false;
			EM.SetCenter(MapToWorldX(mouseX),MapToWorldY(mouseY));
			Update();

			ScrollToView();
			ScrollTimerDestroy();
			m_ScrollTimeLU=0;
			ScrollTimerUpdate(Common.GetTime());
		}
	}

	public function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		m_TimeScale.stop();
		ScrollTimerDestroy();
		if(m_Float) {
			m_Float=false;
		}
		if(m_Move) {
			m_Move=false;
		}
		MouseUnlock();
	}
	
	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if(m_Float) {
			EM.m_GoOpen=false;
			SetCenter(m_OffsetX-MapToWorldR(mouseX-m_MousePosOldX),m_OffsetY-MapToWorldR(mouseY-m_MousePosOldY));
			
			m_MousePosOldX=mouseX;
			m_MousePosOldY=mouseY;
			
		} else if(m_Move) {
			EM.m_GoOpen=false;
			EM.SetCenter(MapToWorldX(mouseX),MapToWorldY(mouseY));
			ScrollTimerUpdate(Common.GetTime());
			//Update();
			if(!m_TimerUpdate.running) m_TimerUpdate.start();

		} else {
			//SetCurIsland(PickIsland());
			SetCurOwner(PickOwner());
		} 
		
		EM.m_Info.Hide();
	}

	public function SetCurOwner(v:uint):void
	{
		if(v==Server.Self.m_UserId) v=0;
		if(v==m_CurOwner) return;
		m_CurOwner=v;
		if(visible) {
			if(!m_TimerUpdate.running) m_TimerUpdate.start();
			//Update();
		} 
	}

/*	public function SetCurIsland(v:int):void
	{
		if(v==m_CurIsland) return;
//trace("SetCurIsland",v);		
		m_CurIsland=v;
		if(visible) {
			if(!m_TimerUpdate.running) m_TimerUpdate.start();
			//Update();
		} 
	}*/

	public function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		var delta:Number = e.delta;
		
		var tx:Number=MapToWorldX(mouseX);
		var ty:Number=MapToWorldY(mouseY);

		m_ScaleKof-=Math.round(delta/3)*2;
		if(m_ScaleKof<5) m_ScaleKof=5;
		else if(m_ScaleKof>80) m_ScaleKof=80;

		m_Scale=m_SizeX*m_ScaleKof;

		m_OffsetX=tx-MapToWorldR(mouseX-m_SizeX/2);//WorldToMapX(tx);
		m_OffsetY=ty-MapToWorldR(mouseY-m_SizeY/2);//WorldToMapY(ty);

		if(visible) Update();
		
		ShipPlayerQuery(true);
	}
	
	public function SetCenter(x:Number, y:Number):void
	{
		m_OffsetX=x;
		m_OffsetY=y;
		if(visible) {
			if(!m_TimerUpdate.running) m_TimerUpdate.start();
			//Update();
		}
	}

	public function PickOwner():uint
	{
		var tx:Number=MapToWorldX(mouseX);
		var ty:Number=MapToWorldY(mouseY);
		var sx:int=Math.floor(tx/EM.m_SectorSize);
		var sy:int=Math.floor(ty/EM.m_SectorSize);
		
		if(sx<EM.m_SectorMinX) return 0;
		if(sy<EM.m_SectorMinY) return 0;
		if(sx>=EM.m_SectorMinX+EM.m_SectorCntX) return 0;
		if(sy>=EM.m_SectorMinY+EM.m_SectorCntY) return 0;

		var i:int;
		var u:int=-1;
		var cc:uint;
		var md:Number;
		for(i=0;i<4;i++) {
			cc=m_PlanetPos[((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i];
			if(cc==0) continue;
			var px:Number=((cc & 15)-1)/14.0*EM.m_SectorSize+sx*EM.m_SectorSize;
			var py:Number=(((cc>>4) & 15)-1)/14.0*EM.m_SectorSize+sy*EM.m_SectorSize;

			var d:Number=(px-tx)*(px-tx)+(py-ty)*(py-ty);

			if(u<0 || d<md) {
				u=i;
				md=d;
			}
		}
		if(u<0) return 0;

//		var off:int=((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*16+u*4;
//		if(off>=m_PlanetOwner.length) return 0;
//		m_PlanetOwner.position=off;
//		return m_PlanetOwner.readUnsignedInt();

		var off:int=u*MMSizePlanet+(sx-EM.m_SectorMinX)*4*MMSizePlanet+(sy-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
		if(off+MMSizePlanet>m_MMData.length) return 0;
		m_MMData.position=off;
		m_MMData.readUnsignedInt();
		
		return m_MMData.readUnsignedInt();
	}
	
/*	public function PickIsland():int
	{
		if(m_Island.length<=0) return 0;
		
		var tx:Number=MapToWorldX(mouseX);
		var ty:Number=MapToWorldY(mouseY);
		var sx:int=Math.floor(tx/EM.m_SectorSize);
		var sy:int=Math.floor(ty/EM.m_SectorSize);
		
		if(sx<EM.m_SectorMinX) return 0;
		if(sy<EM.m_SectorMinY) return 0;
		if(sx>=EM.m_SectorMinX+EM.m_SectorCntX) return 0;
		if(sy>=EM.m_SectorMinY+EM.m_SectorCntY) return 0;

		var i:int;
		var u:int=-1;
		var cc:uint;
		var md:Number;
		for(i=0;i<4;i++) {
			cc=m_PlanetPos[((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i];
			if(cc==0) continue;
			var px:Number=((cc & 15)-1)/14.0*EM.m_SectorSize+sx*EM.m_SectorSize;
			var py:Number=(((cc>>4) & 15)-1)/14.0*EM.m_SectorSize+sy*EM.m_SectorSize;

			var d:Number=(px-tx)*(px-tx)+(py-ty)*(py-ty);

			if(u<0 || d<md) {
				u=i;
				md=d;
			}
		}
		if(u<0) return 0;
		
//trace("s",sx,sy,"island",m_Island[((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+u]);
		return m_Island[((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+u];
	}*/

	public function GetWormholePos(sx:int, sy:int):Array
	{
		if(sx<EM.m_SectorMinX) return null;
		if(sy<EM.m_SectorMinY) return null;
		if(sx>=EM.m_SectorMinX+EM.m_SectorCntX) return null;
		if(sy>=EM.m_SectorMinY+EM.m_SectorCntY) return null;

		var i:int;
		var cc:uint;
		var fl:uint;
		var off:uint;
		for(i=0;i<4;i++) {
			//off=((EM.m_SectorCntX*EM.m_SectorCntY)<<4)+((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i;
			//if(off>=m_PlanetOwner.length) return null;
			//m_PlanetOwner.position=off;
			//fl=m_PlanetOwner.readUnsignedByte();
			fl=m_PlanetPos[EM.m_SectorCntX*EM.m_SectorCntY*4+((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i]

			//if(!(fl & 64)) continue;
			if ((fl & 15) != 7 && (fl & 15) != 8) continue;

			cc=m_PlanetPos[((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i];
			if(cc==0) continue;
			var px:Number=((cc & 15)-1)/14.0*EM.m_SectorSize+sx*EM.m_SectorSize;
			var py:Number=(((cc>>4) & 15)-1)/14.0*EM.m_SectorSize+sy*EM.m_SectorSize;

			return [px,py];
		}

		return null;
	}

	public function GetPlanetPos(sx:int, sy:int, num:int):Array
	{
		if(sx<EM.m_SectorMinX) return null;
		if(sy<EM.m_SectorMinY) return null;
		if(sx>=EM.m_SectorMinX+EM.m_SectorCntX) return null;
		if(sy>=EM.m_SectorMinY+EM.m_SectorCntY) return null;

		var i:int;
		var cc:uint;
		var fl:uint;
		var off:uint;

//			off=((EM.m_SectorCntX*EM.m_SectorCntY)<<4)+((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+num;
//			if(off>=m_PlanetOwner.length) return null;
//			m_PlanetOwner.position=off;
//			fl=m_PlanetOwner.readUnsignedByte();

			cc=m_PlanetPos[((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4+num];
			if(cc==0) return null;
			var px:Number=((cc & 15)-1)/14.0*EM.m_SectorSize+sx*EM.m_SectorSize;
			var py:Number=(((cc>>4) & 15)-1)/14.0*EM.m_SectorSize+sy*EM.m_SectorSize;

			return [px,py];

		return null;
	}

	public function CreateSptiteBM(w:int, r:int, alpha:Number, clr:uint, sp:Sprite):BitmapData
	{
		if(r<1) r=1;
		
		var bm:BitmapData=new BitmapData(r*2+1,r*2+1,true,0x00000000);
		var m:Matrix=new Matrix();
		m.identity();

		var s:Number=(r*2+1)/w;
		//if(s<0.5) s=0.5;

		m.scale(s,s);
		//m.translate(

		var cr:Number=((clr>>16)&0xff)/255;
		var cg:Number=((clr>>8)&0xff)/255;
		var cb:Number=((clr)&0xff)/255;

		var ct:ColorTransform=new ColorTransform(cr,cg,cb,alpha);
		bm.draw(sp,m,ct);
		return bm;
	}

	public function CreateCircleBM(r:int, alpha:Number, clr:uint):BitmapData
	{
		var at:Number;
		var cx:int, cy:int;
		
		if(r<1) r=1;
		
		var bm:BitmapData=new BitmapData(r*2+1,r*2+1,true,0x00000000);
		
		for(cy=-r;cy<=r;cy++) {
			for(cx=-r;cx<=r;cx++) {
				at=cx*cx+cy*cy;
				if(at>r*r) continue;
				at=1.0-at/Math.sqrt(r*r);
				if(at<0.0) continue;
				if(at>0.5) at=1.0;
				else at*=1.0/0.5;
				if(at>1.0) at=1.0;
				bm.setPixel32(r+cx, r+cy, clr | Math.round((alpha*at)*255.0)<<24);
			}
		}
		return bm;
	}

	public function CreateWormholeBM(r:int, alpha:Number, clr:uint):BitmapData
	{
		var at:Number;
		var cx:int, cy:int;
		
		if(r<1) r=1;
		
		var bm:BitmapData=new BitmapData(r*2+1,r*2+1,true,0x00000000);
		
		for(cy=-r;cy<=r;cy++) {
			for(cx=-r;cx<=r;cx++) {
				at=cx*cx+cy*cy;
				if(at>r*r) continue;
				at=at/Math.sqrt(r*r);
				if(at<0.0) continue;
				else if(at>1.0) continue;
				
				bm.setPixel32(r+cx, r+cy, clr | Math.round((alpha*at)*255.0)<<24);
			}
		}
		return bm;
	}
	
	public function UpdateTimer(event:TimerEvent=null):void
	{
		m_TimerUpdate.stop();
		if (m_NeedScrollToView) {
			if (!ScrollToView()) Update();
		} else {
			Update();
		}
	}

	private var sp_large:Sprite=new MMLarge();
	private var sp_small:Sprite=new MMSmall();
	private var sp_wormhole:Sprite = new MMWormhole();
	private var sp_wormhole_roam:Sprite = new MMWormholeRoam();
	private var sp_citadel:Sprite=new MMCitadel();
	private var sp_homeworld:Sprite=new MMHomeworld();

	static public var v0:Vector3D = new Vector3D();
	static public var v1:Vector3D = new Vector3D();
	static public var v2:Vector3D = new Vector3D();
	static public var v3:Vector3D = new Vector3D();

	public function Update():void
	{
		if(!visible) return;
//var tm0:int=System.totalMemory;

		var ar:Array;
		var i:int,x:int,y:int,r:int,off:int;
		var px:Number,py:Number,px2:Number,py2:Number;
		var cc:uint;
		var clr:uint,a1:uint,a2:uint,a3:uint;
		var a:Number, at:Number;
		var cx:int, cy:int;
		var re:Rectangle=new Rectangle();
		var pt:Point=new Point();
		var tbm:BitmapData;
		var tbm2:BitmapData;
		var tbma:BitmapData;
		var planet:Planet;
		var manuf_planet:Planet;
		var owner:uint, fl:uint, planettype:uint;

		var isedit:Boolean=EM.IsEdit();
		var cotltypeprotect:Boolean = EM.m_CotlType == Common.CotlTypeProtect;// || EM.m_CotlType == Common.CotlTypeCombat;

		var tstr:String="";
		while (true) {
			tstr += EM.CotlName(Server.Self.m_CotlId);
/*			var cotl:Cotl=EM.m_FormGalaxy.GetCotl(Server.Self.m_CotlId);
			if(cotl==null) break;

			var user:User=null;
			if(EM.m_CotlOwnerId!=0) {
				user=UserList.Self.GetUser(EM.m_CotlOwnerId);
			}

			if(cotl.m_Type==Common.CotlTypeRich) tstr+=Common.Txt.CotlRich;
			else if(cotl.m_Type==Common.CotlTypeUser) tstr+=Common.Txt.CotlUser;

			if(Common.CotlName[cotl.m_Id]!=undefined) tstr+=" <font color='#FFFF00'>"+Common.CotlName[cotl.m_Id]+"</font>";
			else if(user!=null && user.m_Name.length>0) tstr+=": <font color='#FFFF00'>"+user.m_Name+"</font>";*/

			break;
		}
//		if(EM.m_CotlType==Common.CotlTypeUser) {
//			if(EM.m_FormMiniMap.m_Occupancy>Common.OccupancyCritical) tstr+="<font color='#ff0000'> ("+EM.m_FormMiniMap.m_Occupancy.toString()+"%)</font>";
//			else tstr+="<font color='#808080'> ("+EM.m_FormMiniMap.m_Occupancy.toString()+"%)</font>";
//		}
//		if(EM.m_CotlType==Common.CotlTypeRich) {
//			if(EM.m_FormMiniMap.m_Occupancy>Common.OccupancyRichCritical) tstr+="<font color='#ff0000'> ("+EM.m_FormMiniMap.m_Occupancy.toString()+"%)</font>";
//			else tstr+="<font color='#808080'> ("+EM.m_FormMiniMap.m_Occupancy.toString()+"%)</font>";
//		}
		m_CotlName.htmlText=tstr;
		m_CotlName.x=3;
		m_CotlName.y=m_SizeY-m_CotlName.height;

		graphics.clear();

		if (m_SizeX <= 5 || m_SizeY <= 5) return;

		UpdateBut();

		if(m_OpenFull) graphics.beginFill(0x000000,0.95);
		else graphics.beginFill(0x000000,0.8);
//		graphics.lineStyle(1.0,0x069ee5,0.9,true);
//		graphics.drawRoundRect(-5,-5,m_SizeX+10,m_SizeY+10,10,10);
		graphics.lineStyle(1.0,0x000000,0.0,true);
		graphics.drawRect(-5,-5,m_SizeX+10,m_SizeY+10);
		graphics.endFill();
		
		if(m_PlanetPos.length!=EM.m_SectorCntX*EM.m_SectorCntY*4*2) return;

		var sx:int=Math.max(EM.m_SectorMinX,Math.floor(MapToWorldX(0)/EM.m_SectorSize));
		var sy:int=Math.max(EM.m_SectorMinY,Math.floor(MapToWorldY(0)/EM.m_SectorSize));
		var ex:int=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,Math.floor(MapToWorldX(m_SizeX)/EM.m_SectorSize)+1);
		var ey:int=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,Math.floor(MapToWorldY(m_SizeY)/EM.m_SectorSize)+1);

/*		graphics.lineStyle(1,0x1E1F1C,0.5,true); //чето както не красиво с сеткой 0x069ee5

		var add:int=Math.ceil(MapToWorldR(50)/EM.m_SectorSize);
		if(add<=0) add+=1;

		x=Math.ceil((sx-EM.m_SectorMinX)/add)*add+EM.m_SectorMinX;
		for(;x<=ex;x+=add) {
			px=WorldToMapX(x*EM.m_SectorSize);
			py=WorldToMapY(sy*EM.m_SectorSize);

			px2=px;
			py2=WorldToMapY(ey*EM.m_SectorSize);
			DrawLineClip(px,py,px2,py2,-3,-3,m_SizeX+3,m_SizeY+3);			
		}
		y=Math.ceil((sy-EM.m_SectorMinY)/add)*add+EM.m_SectorMinY;
		for(;y<=ey;y+=add) {
			px=WorldToMapX(sx*EM.m_SectorSize);
			py=WorldToMapY(y*EM.m_SectorSize);

			px2=WorldToMapX(ex*EM.m_SectorSize);
			py2=py;
			DrawLineClip(px,py,px2,py2,-3,-3,m_SizeX+3,m_SizeY+3);			
		}*/

		//px=Math.round(WorldToMapX(EM.ScreenToWorldX(0)))-1;
		//py=Math.round(WorldToMapY(EM.ScreenToWorldY(0)))-1;
		//px2=Math.round(WorldToMapX(EM.ScreenToWorldX(EM.stage.stageWidth)))+1;
		//py2 = Math.round(WorldToMapY(EM.ScreenToWorldY(EM.stage.stageHeight))) + 1;
		
		if (!EmpireMap.Self.PickWorldCoord(0, 0, v0)) return;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, 0, v1)) return;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, v2)) return;
		if (!EmpireMap.Self.PickWorldCoord(0, C3D.m_SizeY, v3)) return;
		px = Math.round(WorldToMapX(Math.min(v0.x, v1.x, v2.x, v3.x)));
		py = Math.round(WorldToMapY(Math.min(v0.y, v1.y, v2.y, v3.y)));
		px2 = Math.round(WorldToMapX(Math.max(v0.x, v1.x, v2.x, v3.x)));
		py2 = Math.round(WorldToMapY(Math.max(v0.y, v1.y, v2.y, v3.y)));

		graphics.lineStyle(1,0xffffff,1.0,true);
		DrawLineClip(px,py,px2,py,0,0,m_SizeX,m_SizeY);
		DrawLineClip(px,py,px,py2,0,0,m_SizeX,m_SizeY);
		DrawLineClip(px2,py2,px2,py,0,0,m_SizeX,m_SizeY);
		DrawLineClip(px2,py2,px,py2,0,0,m_SizeX,m_SizeY);
		//graphics.drawRect(px,py,px2-px,py2-py);

		m_ShowWormholePath=false;

		while (EM.m_CurShipNum < 0 && EM.m_CurPlanetNum >= 0) {
			planet = EM.GetPlanet(EM.m_CurSectorX, EM.m_CurSectorY, EM.m_CurPlanetNum);
			if (planet == null) break;
			if (!(planet.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen  | Planet.PlanetFlagWormholeClose))) break;

			px = WorldToMapX(planet.m_PosX);
			py = WorldToMapY(planet.m_PosY);

			ar = GetWormholePos(planet.m_PortalSectorX, planet.m_PortalSectorY);
			if (ar == null) break; 

			px2=WorldToMapX(ar[0]);
			py2=WorldToMapY(ar[1]);

			graphics.lineStyle(1,0xffffff,0.5,true);
			DrawLineClip(px,py,px2,py2,0,0,m_SizeX,m_SizeY);
			
			m_ShowWormholePath=true;
			
			break;
		}

		m_ShowPortalPath=false;
		while(EM.m_CurShipNum<0 && EM.m_CurPlanetNum>=0 && EM.m_CurSpecial == 1) {
			planet=EM.GetPlanet(EM.m_CurSectorX,EM.m_CurSectorY,EM.m_CurPlanetNum);
			if(planet==null) break;
			if(planet.m_PortalPlanet<=0 || planet.m_PortalPlanet>=5) break;
			if(planet.m_PortalCotlId!=0) break;
			px=WorldToMapX(planet.m_PosX);
			py=WorldToMapY(planet.m_PosY);

			ar=GetPlanetPos(planet.m_PortalSectorX,planet.m_PortalSectorY,planet.m_PortalPlanet-1);
			if(ar==null) break; 

			px2=WorldToMapX(ar[0]);
			py2=WorldToMapY(ar[1]);

			graphics.lineStyle(1,0xffffff,0.5,true);
			DrawLineClip(px,py,px2,py2,0,0,m_SizeX,m_SizeY);
			
			m_ShowPortalPath=true;
			
			break;
		}

		var bm:BitmapData = new BitmapData(m_SizeX, m_SizeY, true, 0x00000000);
		var bm2:BitmapData = new BitmapData(m_SizeX, m_SizeY, true, 0x00000000);

		var i_own_large:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.8,0x00f0ff,sp_large);
		var i_own_small:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.6,0x00f0ff,sp_small);

		var i_enm_large:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.8,0xff0000,sp_large);
		var i_enm_small:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.6,0xff0000,sp_small);

		var i_friend_large:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.8,0x30A000,sp_large);
		var i_friend_small:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.6,0x30A000,sp_small);

		var i_cur_large:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.8,0xffffff,sp_large);
		var i_cur_small:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.6,0xffffff,sp_small);

		var i_prod:BitmapData = CreateSptiteBM(7, WorldToMapR(97), 0.8, 0x00ff00, sp_large);
		var i_need:BitmapData = CreateSptiteBM(7, WorldToMapR(97), 0.8, 0xff0000, sp_large);
		var i_prod_need:BitmapData = CreateSptiteBM(7, WorldToMapR(97), 0.8, 0xffff00, sp_large);

		var i_net_small:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.3,0xffffff,sp_small);
		var i_sun_small:BitmapData=CreateSptiteBM(5,WorldToMapR(55),0.2,0xffffff,sp_small);
		var i_pulsar_small:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.8,0xff97fc/* 0xffff00*/,sp_small);

		var i_wormhole:BitmapData = CreateSptiteBM(24, WorldToMapR(300), 1.0, 0xffffff, sp_wormhole);
		var i_wormhole_roam:BitmapData = CreateSptiteBM(24, WorldToMapR(300), 1.0, 0xffffff, sp_wormhole_roam);

/*		var i_own_large:BitmapData=CreateCircleBM(WorldToMapR(500),0.8,0x00f0ff);
		var i_own_small:BitmapData=CreateCircleBM(WorldToMapR(200),0.6,0x00f0ff);
		var i_enm_large:BitmapData=CreateCircleBM(WorldToMapR(500),0.8,0xff0000);
		var i_enm_small:BitmapData=CreateCircleBM(WorldToMapR(200),0.6,0xff0000);
		var i_friend_large:BitmapData=CreateCircleBM(WorldToMapR(500),0.8,0x30A000);
		var i_friend_small:BitmapData=CreateCircleBM(WorldToMapR(200),0.6,0x30A000);
		var i_cur_large:BitmapData=CreateCircleBM(WorldToMapR(500),1.0,0xffffff);
		var i_cur_small:BitmapData=CreateCircleBM(WorldToMapR(200),0.9,0xffffff);

		var i_net_small:BitmapData=CreateCircleBM(WorldToMapR(200),0.3,0xffffff);*/

		var i_own_ship:BitmapData=CreateCircleBM(WorldToMapR(80),1.0,0x00ff00);
		var i_enm_ship:BitmapData=CreateCircleBM(WorldToMapR(80),1.0,0xff8f00);

		//var i_wormhole:BitmapData=CreateWormholeBM(WorldToMapR(500),1.0,0xffffff);

		var sl:int=WorldToMapR(120);
		var ss:int=WorldToMapR(100);

		//var i_red:BitmapData=CreateCircleBM(WorldToMapR(200),0.6,0xff0000);
		//var i_green:BitmapData=CreateCircleBM(WorldToMapR(200),0.6,0x00ff00);
		//var i_blue:BitmapData=CreateCircleBM(WorldToMapR(200),0.6,0x0000ff);
		
		var i_red:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.3,0xff0000,sp_small);
		var i_green:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.3,0x00ff00,sp_small);
		var i_blue:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.3,0x0000ff,sp_small);

		var i_red_big:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.6,0xff0000,sp_large);
		var i_green_big:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.6,0x00ff00,sp_large);
		var i_blue_big:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.6,0x0000ff,sp_large);

		var i_crystal:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.6,0xffff00,sp_small);
		var i_titan:BitmapData=CreateSptiteBM(5,WorldToMapR(65),0.6,0x00f0ff,sp_small); //008e91
		var i_silicon:BitmapData = CreateSptiteBM(5, WorldToMapR(65), 0.6, 0x00ff06, sp_small);

		var i_crystal_big:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.6,0xffff00,sp_large);
		var i_titan_big:BitmapData=CreateSptiteBM(7,WorldToMapR(97),0.6,0x00f0ff,sp_large);
		var i_silicon_big:BitmapData = CreateSptiteBM(7, WorldToMapR(97), 0.6, 0x00ff06, sp_large);
		var i_hydrogen_big:BitmapData = CreateSptiteBM(7, WorldToMapR(97), 0.6, 0xffffff, sp_large);

		var i_own_homeworld:BitmapData=CreateSptiteBM(12,WorldToMapR(150),0.8,0x00f0ff,sp_homeworld);
		var i_enm_homeworld:BitmapData=CreateSptiteBM(12,WorldToMapR(150),0.8,0xff0000,sp_homeworld);
		var i_friend_homeworld:BitmapData=CreateSptiteBM(12,WorldToMapR(150),0.8,0x30A000,sp_homeworld);
		var i_cur_homeworld:BitmapData=CreateSptiteBM(12,WorldToMapR(150),0.8,0xffffff,sp_homeworld);

		var i_own_citadel:BitmapData=CreateSptiteBM(12,WorldToMapR(170),0.8,0x00f0ff,sp_citadel);
		var i_enm_citadel:BitmapData=CreateSptiteBM(12,WorldToMapR(170),0.8,0xff0000,sp_citadel);
		var i_friend_citadel:BitmapData=CreateSptiteBM(12,WorldToMapR(170),0.8,0x30A000,sp_citadel);
		var i_cur_citadel:BitmapData=CreateSptiteBM(12,WorldToMapR(170),0.8,0xffffff,sp_citadel);
		
		var i_access_no_hyperspace:BitmapData=new BitmapData(50,50,true,0x80000000);
		
		var i_enm_bg:BitmapData=CreateSptiteBM(5,WorldToMapR(250),1.0,0x8f0000,sp_small);
		var i_own_bg:BitmapData = CreateSptiteBM(5, WorldToMapR(250), 1.0, 0x00008f, sp_small);
		var i_frn_bg:BitmapData=CreateSptiteBM(5,WorldToMapR(250),1.0,0x004f00,sp_small);
		var i_mix_bg:BitmapData=CreateSptiteBM(5,WorldToMapR(250),1.0,0x008f8f,sp_small);
		var i_def_bg:BitmapData=CreateSptiteBM(5,WorldToMapR(250),1.0,0x008f00,sp_small);
		var i_atk_bg:BitmapData=CreateSptiteBM(5,WorldToMapR(250),1.0,0x00008f,sp_small);

		var f_own:uint=0;
		var f_v:Boolean=false;
		var f_own2:uint=0;
		var f_v2:Boolean=false;
		var f_own3:uint=0;
		var f_v3:Boolean=false;
		var vv:Boolean=false;
		var uu:uint;
		
		var blvl:int;
		var landingplace:int;

		var spar:Array=new Array();
		for(i=0;i<20;i++) spar.push(CreateSptiteBM(7,WorldToMapR(50+i*10),0.5,0x00f0ff,sp_large));

		var _transport:int,_corvette:int,_cruiser:int,_dreadnought:int,_invader:int,_devastator:int,_warbase:int,_shipyard:int,_scibase:int,_servicebase:int;
		
		var userinlandingplace:Boolean=false;
		var enterok:Boolean=true;
		if(cotltypeprotect) {
			for(i=0;i<m_LandingAccess.length;i++) {
				if(m_LandingAccess[i]==Server.Self.m_UserId) { userinlandingplace=true; break; }
			}
			
			if ((EM.m_OpsFlag & Common.OpsFlagPulsarEnterActive) != 0 && !EM.CalcPulsarStateProtect(EM.GetServerCalcTime())) enterok = false;
		}
		
		var manuf_itemtype:uint = EM.m_MB_ItemType;

		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				//if(m_ShowShipPlayer==0)
				for(i=0;i<4;i++) {
					off=((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i;
					if(off>m_PlanetPos.length) continue;					
					cc=m_PlanetPos[off];
					if(cc==0) continue;

					px=Math.round(WorldToMapX(((cc & 15)-1)/14.0*EM.m_SectorSize+x*EM.m_SectorSize));
					py=Math.round(WorldToMapY((((cc>>4) & 15)-1)/14.0*EM.m_SectorSize+y*EM.m_SectorSize));
					if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) continue;

					off=EM.m_SectorCntX*EM.m_SectorCntY*4+((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i;
					if(off>m_PlanetPos.length) continue;
					var fls:uint=m_PlanetPos[off];

					off=i*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
					if(off+MMSizePlanet>m_MMData.length) continue;
					m_MMData.position=off;
					fl=m_MMData.readUnsignedInt();

					//if (fls & 1) fl |= MapFlagUninhabited;
					//if (fls & 2) fl |= MapFlagPulsar;
					//if (fls & 64) fl |= MapFlagWormhole;
					//if (fls & 128) fl |= MapFlagRich;
					planettype = fl & MapFlagTypeMask;
					if (planettype == MapFlagTypeWormholeRoam) { // Так можно так как вокруг БЧТ вседа видно.
						fl = (fl & (~(MapFlagSilicon))) | ((fls & 0xf0) << 8);
					} else {
						fl = (fl & (~(MapFlagTypeMask | MapFlagSilicon))) | (fls << 8);
						planettype = fl & MapFlagTypeMask;
					}

//					if((fls&(16|32))==(16|32)) fl|=MapFlagSilicon;
//					if(fls&16) fl|=MapFlagCrystal;
//					if (fls & 32) fl |= MapFlagTitan;

					if (manuf_itemtype != 0) {
						manuf_planet=EM.GetPlanet(x, y, fl & 3);
					}

					//m_MMData.readInt();
					//m_MMData.readInt();
/*					if(!fl) continue;
					px=Math.round(WorldToMapX(m_MMData.readInt()));
					py=Math.round(WorldToMapY(m_MMData.readInt()));
					if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) continue;*/
					
					owner=m_MMData.readUnsignedInt();
//if((x-EM.m_SectorMinX+1)==32 && (y-EM.m_SectorMinY+1)==10) trace(i,owner);
//if(owner!=0) trace("AG",owner);

					if(m_ShowShipPlayer!=0) {
						_transport=m_MMData.readInt();
						_corvette = m_MMData.readInt();
//if(_corvette!=0) trace(_corvette);
						_cruiser=m_MMData.readInt();
						_dreadnought=m_MMData.readInt();
						_invader=m_MMData.readInt();
						_devastator=m_MMData.readInt();
						_warbase=m_MMData.readInt();
						_shipyard=m_MMData.readInt();
						_scibase = m_MMData.readInt();
						_servicebase = m_MMData.readInt();
						blvl = m_MMData.readInt();
						landingplace=m_MMData.readInt();

						var cnt:int=0;

						if(m_ShowShipPlayer & (1<<Common.ShipTypeCorvette)) cnt+=_corvette;
						if(m_ShowShipPlayer & (1<<Common.ShipTypeCruiser)) cnt+=_cruiser;
						if(m_ShowShipPlayer & (1<<Common.ShipTypeDreadnought)) cnt+=_dreadnought;
						if(m_ShowShipPlayer & (1<<Common.ShipTypeInvader)) cnt+=_invader;
						if(m_ShowShipPlayer & (1<<Common.ShipTypeDevastator)) cnt+=_devastator;
						if(m_ShowShipPlayer & (1<<Common.ShipTypeWarBase)) cnt+=_warbase;
						if(m_ShowShipPlayer & (1<<Common.ShipTypeShipyard)) cnt+=_shipyard;
						if (m_ShowShipPlayer & (1 << Common.ShipTypeSciBase)) cnt += _scibase;
						if (m_ShowShipPlayer & (1 << Common.ShipTypeServiceBase)) cnt += _servicebase;
						if(m_ShowShipPlayer & (1<<Common.ShipTypeTransport)) cnt+=_transport;

						if(cnt>0) {
							cnt=cnt/200;
							if(cnt>=spar.length) cnt=spar.length-1;
							tbm=spar[cnt]; 

							if(tbm!=null) {
								re.left=0; re.top=0;
								re.right=tbm.width; re.bottom=tbm.height;
								pt.x=px-(tbm.width>>1);
								pt.y=py-(tbm.height>>1);
								bm.copyPixels(tbm,re,pt,null,null,true);
							}
						}
						continue;
					} else if (m_ShowBuildingType != 0 || EM.m_Set_ShowColony || EM.m_Set_ShowWormholePoint || EM.m_Set_ShowGravitor || EM.m_Set_ShowMine) {
						m_MMData.position=m_MMData.position+10*4;
						blvl = m_MMData.readInt();

						if(blvl>0) {
							cnt = Math.round(blvl * spar.length / (7 * 4));
							if(cnt>=spar.length) cnt=spar.length-1;
							tbm=spar[cnt]; 

							if(tbm!=null) {
								re.left=0; re.top=0;
								re.right=tbm.width; re.bottom=tbm.height;
								pt.x=px-(tbm.width>>1);
								pt.y=py-(tbm.height>>1);
								bm.copyPixels(tbm,re,pt,null,null,true);
							}
						}
						continue;
					} else if (EM.m_Set_ShowNoCapture) {
						m_MMData.position=m_MMData.position+10*4;
						blvl = m_MMData.readInt();

						if (blvl <= 0) tbm = i_net_small;
						else tbm = i_own_small;

						if(tbm!=null) {
							re.left=0; re.top=0;
							re.right=tbm.width; re.bottom=tbm.height;
							pt.x=px-(tbm.width>>1);
							pt.y=py-(tbm.height>>1);
							bm.copyPixels(tbm,re,pt,null,null,true);
						}
						continue;

					} else {
						m_MMData.position=m_MMData.position+11*4;
						landingplace=m_MMData.readInt();
					}

					if(m_ShowPlanet) {
						tbm2=null;
						tbm=null;
						tbma=null;
//if(owner!=0) trace("AH",owner);

						if(cotltypeprotect) {
							if(isedit) {
								if((fl&MapFlagArrivalDef)!=0 && (fl&MapFlagArrivalAtk)!=0) tbm2=i_mix_bg;
								else if((fl&MapFlagArrivalDef)!=0) tbm2=i_def_bg;
								else if((fl&MapFlagArrivalAtk)!=0) tbm2=i_atk_bg;
							} else {
								if(landingplace>0 && landingplace<m_LandingAccess.length && enterok) {
									if(m_LandingAccess[landingplace]==0 && !userinlandingplace) tbm2=i_own_bg;
									else if(m_LandingAccess[landingplace]==Server.Self.m_UserId) tbm2=i_own_bg;
								}
							}

						} else if((fl & MapFlagEnemyForHyperspace)!=0) {
							//if(m_NoEnterFromHyperspace && ((fl & MapFlagUninhabited)!=0));
							//else 
							tbm2=i_enm_bg;//tbma=i_access_no_hyperspace;
							
						} else if((fl & (MapFlagOwner | MapFlagOwnerForHyperspace))!=0) {
							//if(m_NoEnterFromHyperspaceOwner && ((fl & MapFlagUninhabited)!=0));
							//else
							tbm2=i_own_bg;//tbma=i_access_no_hyperspace;
						} else if ((fl & MapFlagFriendForHyperspace) != 0) {
//trace("!!!Friend",x,y,i);
							tbm2=i_frn_bg;
						}

						if(planettype==MapFlagTypeWormhole/*fl & MapFlagWormhole*/) {
//if(owner!=0) trace("AJ",owner);
							if(!(fl & MapFlagWormholeExist)) {
								if(!isedit) continue;
								else tbma=i_access_no_hyperspace; 
							}
							tbm = i_wormhole;
						}
						else if(planettype==MapFlagTypeWormholeRoam/*fl & MapFlagWormhole*/) {
//if(owner!=0) trace("AJ",owner);
							if(!(fl & MapFlagWormholeExist)) {
								if(!isedit) continue;
								else tbma=i_access_no_hyperspace; 
							}
							tbm = i_wormhole_roam;
						}
						else if(planettype==MapFlagTypePulsar /*fl & MapFlagPulsar*/) { tbm=i_pulsar_small; /*tbma=i_access_no_hyperspace;*/ }
						else if(m_ShowRes) {
//if(owner!=0) trace("AF",owner);
							if (planettype == MapFlagTypeRich) {
								tbm = i_cur_homeworld;
							} else if (planettype == MapFlagTypeGigant) {
								tbm = i_hydrogen_big;
							} else if (planettype == MapFlagTypeLive/* fl & MapFlagRich*/) {
								if ((fl & MapFlagSilicon) == MapFlagSilicon) tbm = i_silicon_big;// i_blue_big;
								else if (fl & MapFlagCrystal) tbm = i_crystal_big;// i_red_big; 
								else if (fl & MapFlagTitan) tbm = i_titan_big;// i_green_big;
//								else if(fl & MapFlagUninhabited) {
//									if(m_ScaleKof>20) tbm=null;
//									else tbm=i_sun_small;
//								}
								else tbm=i_net_small;
							} else {
								if(m_ScaleKof>=32) {}
								else if ((fl & MapFlagSilicon) == MapFlagSilicon) tbm = i_silicon;// i_blue;
								else if (fl & MapFlagCrystal) tbm = i_crystal;// i_red; 
								else if (fl & MapFlagTitan) tbm = i_titan;// i_green;
								else if (planettype != MapFlagTypeUninhabited /*fl & MapFlagUninhabited*/) {
									if(m_ScaleKof>20) tbm=null;
									else tbm=i_sun_small;
								}
								else tbm=i_net_small;
							}
							
						} else if (manuf_itemtype!=0 && manuf_planet != null && manuf_planet.m_Manuf != 0) {
							if ((manuf_planet.m_Manuf & 3) == 3) tbm = i_prod_need;
							else if (manuf_planet.m_Manuf & 1) tbm = i_prod;
							else tbm=i_need;

/*						} else if(m_CurIsland>0 && m_Island.length>0 && m_Island[((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i]==m_CurIsland) { 
//if(owner!=0) trace("AE",owner);
							if(fl & MapFlagHomeworld) tbm=i_cur_large;
							else tbm=i_cur_small;
*/
						} else if(owner==0) {
//if(owner!=0) trace("AD",owner);
							if(planettype==MapFlagTypePulsar /*fl & MapFlagPulsar*/) { tbm=i_pulsar_small; /*tbma=i_access_no_hyperspace;*/ }
							else {
								if ((planettype == 0) || (planettype == MapFlagTypeSun) || (planettype == MapFlagTypeGigant) /*fl & MapFlagUninhabited*/) {
									if(m_ScaleKof>20) tbm=null;
									else tbm=i_sun_small;
								} else tbm=i_net_small;
							}

						} else if(owner==Server.Self.m_UserId) {
//if(owner!=0) trace("AC",owner);
							if((fl & (MapFlagHomeworld|MapFlagCitadel))==(MapFlagHomeworld|MapFlagCitadel)) tbm=i_own_large;
							else if(fl & MapFlagHomeworld) tbm=i_own_homeworld;
							else if(fl & MapFlagCitadel) tbm=i_own_citadel;
							else tbm=i_own_small;

						} else if(owner==m_CurOwner) {
//if(owner!=0) trace("AA",owner);
							if((fl & (MapFlagHomeworld|MapFlagCitadel))==(MapFlagHomeworld|MapFlagCitadel)) tbm=i_cur_large;
							else if(fl & MapFlagHomeworld) tbm=i_cur_homeworld;
							else if(fl & MapFlagCitadel) tbm=i_cur_citadel;
							else tbm=i_cur_small;

						} else if(owner!=Server.Self.m_UserId) {
							if(f_own==owner) {}
							else if(f_own2==owner) {
								vv=f_v2; f_v2=f_v; f_v=vv;
								uu=f_own2; f_own2=f_own; f_own=uu;
							}
							else if(f_own3==owner) {
								vv=f_v3; f_v3=f_v; f_v=vv;
								uu=f_own3; f_own3=f_own; f_own=uu;
							}
							else {
								f_own3=f_own2; f_v3=f_v2;
								f_own2=f_own; f_v2=f_v;
								f_own=owner; f_v=EM.IsFriendEx2(owner,owner,Common.RaceNone,Server.Self.m_UserId,Common.RaceNone);
							}
//if(owner!=0) trace("AB",owner,f_own,f_v);
							if(f_v) {
								if((fl & (MapFlagHomeworld|MapFlagCitadel))==(MapFlagHomeworld|MapFlagCitadel)) tbm=i_friend_large;
								else if(fl & MapFlagHomeworld) tbm=i_friend_homeworld;
								else if(fl & MapFlagCitadel) tbm=i_friend_citadel;
								else tbm=i_friend_small;
							} else {
								if((fl & (MapFlagHomeworld|MapFlagCitadel))==(MapFlagHomeworld|MapFlagCitadel)) tbm=i_enm_large;
								else if(fl & MapFlagHomeworld) tbm=i_enm_homeworld;
								else if(fl & MapFlagCitadel) tbm=i_enm_citadel;
								else tbm=i_enm_small;
							}
						}

						if(tbm!=null) {
							re.left=0; re.top=0;
							re.right=tbm.width; re.bottom=tbm.height;
							pt.x=px-(tbm.width>>1);
							pt.y=py-(tbm.height>>1);

							bm.copyPixels(tbm,re,pt,tbma,null,true);
						}
						if(tbm2!=null) {
							re.left=0; re.top=0;
							re.right=tbm2.width; re.bottom=tbm2.height;
							pt.x=px-(tbm2.width>>1);
							pt.y=py-(tbm2.height>>1);

							bm2.copyPixels(tbm2,re,pt,tbma,null,true);
						}
					}

					if (m_ShowShip) {
						if (fl & (MapFlagFriend | MapFlagCorvette | MapFlagCruiser | MapFlagDreadnought | MapFlagInvader | MapFlagDevastator | MapFlagFlagship)) {
							if (fl & MapFlagHomeworld) { cx = px - sl; cy = py + sl; }
							else { cx = px - ss; cy = py + ss; }

							re.left=0; re.top=0;
							re.right=i_own_ship.width; re.bottom=i_own_ship.height;
							pt.x=cx-(i_own_ship.width>>1);
							pt.y=cy-(i_own_ship.height>>1);
							bm.copyPixels(i_own_ship,re,pt,null,null,true);
						}

						if(fl & MapFlagEnemy) {
							if(fl & MapFlagHomeworld) { cx=px; cy=py+sl; }
							else { cx=px; cy=py+ss; }

							re.left=0; re.top=0;
							re.right=i_enm_ship.width; re.bottom=i_enm_ship.height;
							pt.x=cx-(i_enm_ship.width>>1);
							pt.y=cy-(i_enm_ship.height>>1);
							bm.copyPixels(i_enm_ship,re,pt,null,null,true);
						}
					}

/*					cc=m_PlanetPos[((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i];
					if(cc==0) continue;

					var fls:uint=m_PlanetPos[EM.m_SectorCntX*EM.m_SectorCntY*4+((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i];

					px=Math.round(WorldToMapX(((cc & 15)-1)/14.0*EM.m_SectorSize+x*EM.m_SectorSize));
					py=Math.round(WorldToMapY((((cc>>4) & 15)-1)/14.0*EM.m_SectorSize+y*EM.m_SectorSize));
					if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) continue;

					var owner:uint=0;
					off=((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*16+i*4;
					if(off<m_PlanetOwner.length) {
						m_PlanetOwner.position=off;
						owner=m_PlanetOwner.readUnsignedInt();
//						owner=(m_PlanetOwner[off+0]<<24) | (m_PlanetOwner[off+1]<<16) | (m_PlanetOwner[off+2]<<8) | (m_PlanetOwner[off+3]);
//if(owner!=0) trace(owner,m_PlanetOwner[off+0],m_PlanetOwner[off+1],m_PlanetOwner[off+2],m_PlanetOwner[off+3]);
					}

					var fl:uint=0;
					off=((EM.m_SectorCntX*EM.m_SectorCntY)<<4)+((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i;
					if(off<m_PlanetOwner.length) {
						m_PlanetOwner.position=off;
						fl=m_PlanetOwner.readUnsignedByte();
					}

					//clr=EM.ColorByOwner(owner,true);

					if(m_ShowPlanet) {
						tbm=null;
						
						if(fls & 64) {
							if(!(fl & 128)) continue;
							tbm=i_wormhole;
						}
						
						else if(m_ShowRes) {
							if(fls & 128) {
								if((fls & (16|32))==(16|32)) tbm=i_blue_big;
								else if(fls & 16) tbm=i_red_big; 
								else if(fls & 32) tbm=i_green_big;
								else if(fls & 1) tbm=i_sun_small;
								else tbm=i_net_small;
							} else {
								if((fls & (16|32))==(16|32)) tbm=i_blue;
								else if(fls & 16) tbm=i_red; 
								else if(fls & 32) tbm=i_green;
								else if(fls & 1) tbm=i_sun_small;
								else tbm=i_net_small;
							}

						} else if(m_CurIsland>0 && m_Island.length>0 && m_Island[((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+i]==m_CurIsland) { 
							if(fl & 1) tbm=i_cur_large;
							else tbm=i_cur_small;

						} else if(owner==0) {
							if(fls & 2) tbm=i_pulsar_small;
							else if(fls & 1) tbm=i_sun_small;
							else tbm=i_net_small;

						} else if(owner==Server.Self.m_UserId) {
							if((fl & 3)==3) tbm=i_own_large;
							else if(fl & 1) tbm=i_own_homeworld;
							else if(fl & 2) tbm=i_own_citadel;
							else tbm=i_own_small;

						} else if(owner==m_CurOwner) {
//							if(fl & 1) tbm=i_cur_large;
//							else tbm=i_cur_small;
							if((fl & 3)==3) tbm=i_cur_large;
							else if(fl & 1) tbm=i_cur_homeworld;
							else if(fl & 2) tbm=i_cur_citadel;
							else tbm=i_cur_small;

						} else if(owner!=Server.Self.m_UserId) {
							if(f_own==owner);
							else if(f_own2==owner) {
								vv=f_v2; f_v2=f_v; f_v=vv;
								uu=f_own2; f_own2=f_own; f_own=uu;
							}
							else if(f_own3==owner) {
								vv=f_v3; f_v3=f_v; f_v=vv;
								uu=f_own3; f_own3=f_own; f_own=uu;
							}
							else {
								f_own3=f_own2; f_v3=f_v2;
								f_own2=f_own; f_v2=f_v;
								f_own=owner; f_v=EM.IsFriendEx2(owner,owner,Common.RaceNone,Server.Self.m_UserId,Common.RaceNone);
							}
//							f_v=EM.IsFriendEx2(owner,owner,Common.RaceNone,Server.Self.m_UserId,Common.RaceNone);

//							if(f_own!=owner) {
//								f_own=owner;
//								f_v=EM.IsFriendEx2(owner,owner,Common.RaceNone,Server.Self.m_UserId,Common.RaceNone);
//							}

							//if(EM.IsFriendEx3(owner,owner,Server.Self.m_UserId)) {
//							if(f_v) {
							if(f_v) {
//								if(fl & 1) tbm=i_friend_large;
//								else tbm=i_friend_small;
								if((fl & 3)==3) tbm=i_friend_large;
								else if(fl & 1) tbm=i_friend_homeworld;
								else if(fl & 2) tbm=i_friend_citadel;
								else tbm=i_friend_small;
							} else {
//								if(fl & 1) tbm=i_enm_large;
//								else tbm=i_enm_small;
								if((fl & 3)==3) tbm=i_enm_large;
								else if(fl & 1) tbm=i_enm_homeworld;
								else if(fl & 2) tbm=i_enm_citadel;
								else tbm=i_enm_small;
							}
						}
					
						if(tbm!=null) {
							re.left=0; re.top=0;
							re.right=tbm.width; re.bottom=tbm.height;
							pt.x=px-(tbm.width>>1);
							pt.y=py-(tbm.height>>1);
							bm.copyPixels(tbm,re,pt,null,null,true);
						}
					}

					if(m_ShowShip) {
						if(fl & 4) {
							if(fl & 1) { cx=px-sl; cy=py+sl; }
							else { cx=px-ss; cy=py+ss; }
							
							re.left=0; re.top=0;
							re.right=i_own_ship.width; re.bottom=i_own_ship.height;
							pt.x=cx-(i_own_ship.width>>1);
							pt.y=cy-(i_own_ship.height>>1);
							bm.copyPixels(i_own_ship,re,pt,null,null,true);
						}

						if(fl & 8) {
							if(fl & 1) { cx=px-sl; cy=py+sl; }
							else { cx=px-ss; cy=py+ss; }
							
							re.left=0; re.top=0;
							re.right=i_enm_ship.width; re.bottom=i_enm_ship.height;
							pt.x=cx-(i_enm_ship.width>>1);
							pt.y=cy-(i_enm_ship.height>>1);
							bm.copyPixels(i_enm_ship,re,pt,null,null,true);
						}
					}
*/
				}

/*				if(m_ShowShipPlayer!=0) {
					var cnt:int=0;
					off=((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)<<2;
					if(off<m_ShipPlayerData.length) {
						m_ShipPlayerData.position=off;
						cnt=m_ShipPlayerData.readUnsignedInt();
					}
					if(cnt>0) {
						cnt=cnt/200;
						if(cnt>=spar.length) cnt=spar.length;
						tbm=spar[cnt]; 

						if(tbm!=null) {
							px=Math.round(WorldToMapX((EM.m_SectorSize>>1)+x*EM.m_SectorSize));
							py=Math.round(WorldToMapY((EM.m_SectorSize>>1)+y*EM.m_SectorSize));

							re.left=0; re.top=0;
							re.right=tbm.width; re.bottom=tbm.height;
							pt.x=px-(tbm.width>>1);
							pt.y=py-(tbm.height>>1);
							bm.copyPixels(tbm,re,pt,null,null,true);
						}
					}
				}*/
			}
		}
		
		if(m_BMC.bitmapData!=null) m_BMC.bitmapData.dispose();
		if(m_BMC2.bitmapData!=null) m_BMC2.bitmapData.dispose();
		
		m_BMC.bitmapData=bm;
		m_BMC2.bitmapData=bm2;
		m_BMC2.alpha=0.3;
		
	
		i_own_large.dispose();
		i_own_small.dispose();
		
		i_enm_large.dispose();
		i_enm_small.dispose();
		
		i_friend_large.dispose();
		i_friend_small.dispose();
		
		i_cur_large.dispose();
		i_cur_small.dispose();
		
		i_net_small.dispose();
		i_sun_small.dispose();
		i_pulsar_small.dispose();
		
		i_wormhole.dispose();

		i_own_ship.dispose();
		i_enm_ship.dispose();
		
		i_red.dispose();
		i_green.dispose();
		i_blue.dispose();
		
		i_red_big.dispose();
		i_green_big.dispose();
		i_blue_big.dispose();
		
		i_own_homeworld.dispose();
		i_enm_homeworld.dispose();
		i_friend_homeworld.dispose();
		i_cur_homeworld.dispose();
		
		i_own_citadel.dispose();
		i_enm_citadel.dispose();
		i_friend_citadel.dispose();
		i_cur_citadel.dispose();
		
		i_access_no_hyperspace.dispose();
		
		i_enm_bg.dispose();
		i_own_bg.dispose();

		i_mix_bg.dispose();
		i_def_bg.dispose();
		i_atk_bg.dispose();

		for (i = 0; i < spar.length; i++) spar[i].dispose();
		
		EmpireMap.Self.m_FormBattleBar.Update();

//trace(sx,sy,ex,ey);
//System.gc();
//var tm1:int=System.totalMemory;
//if((tm1-tm0)>160) FormChat.Self.AddDebugMsg("MMUpdate:"+(tm1-tm0).toString());
	}

	public function WorldToMapX(x:Number):Number
	{
		var si:Number=m_SizeX/2;
		var center:Number=m_SizeX/2;
		return center+((x-m_OffsetX)/m_Scale)*si;
	}

	public function WorldToMapY(y:Number):Number
	{
		var si:Number=m_SizeX/2;
		var center:Number=m_SizeY/2;
		return center+((y-m_OffsetY)/m_Scale)*si;
	}
	
	public function MapToWorldX(x:Number):Number
	{
		var si:Number=m_SizeX/2;
		var center:Number=m_SizeX/2;
		return (x-center)/si*m_Scale+m_OffsetX;
	}

	public function MapToWorldY(y:Number):Number
	{
		var si:Number=m_SizeX/2;
		var center:Number=m_SizeY/2;
		return (y-center)/si*m_Scale+m_OffsetY;
	}
	
	public function WorldToMapR(v:Number):Number
	{
		var si:Number=m_SizeX/2;
		return (v/m_Scale)*si;
	}

	public function MapToWorldR(v:Number):Number
	{
		var si:Number=m_SizeX/2;
		return v/si*m_Scale;
	}
	
	public function NeedScrollToViewAndUpdate():void
	{
		m_NeedScrollToView = true;
		if(!m_TimerUpdate.running) m_TimerUpdate.start();
	}
	
	public function ScrollToView():Boolean
	{
		m_NeedScrollToView = false;
		
		var p1x:Number, p1y:Number, p2x:Number, p2y:Number;
		//var p1x:Number=Math.round(WorldToMapX(EM.ScreenToWorldX(0)))-1;
		//var p1y:Number=Math.round(WorldToMapY(EM.ScreenToWorldY(0)))-1;
		//var p2x:Number=Math.round(WorldToMapX(EM.ScreenToWorldX(EM.stage.stageWidth)))+1;
		//var p2y:Number=Math.round(WorldToMapY(EM.ScreenToWorldY(EM.stage.stageHeight)))+1;
		if (!EmpireMap.Self.PickWorldCoord(0, 0, v0)) return false;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, 0, v1)) return false;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, v2)) return false;
		if (!EmpireMap.Self.PickWorldCoord(0, C3D.m_SizeY, v3)) return false;
		p1x = Math.round(WorldToMapX(Math.min(v0.x, v1.x, v2.x, v3.x)));
		p1y = Math.round(WorldToMapY(Math.min(v0.y, v1.y, v2.y, v3.y)));
		p2x = Math.round(WorldToMapX(Math.max(v0.x, v1.x, v2.x, v3.x)));
		p2y = Math.round(WorldToMapY(Math.max(v0.y, v1.y, v2.y, v3.y)));

		var rwleft:Number=0;
		var rwtop:Number=0;
		var rwright:Number=m_SizeX;
		var rwbottom:Number=m_SizeY;

		var x:Number=0;
		var y:Number=0;

		if(p1x<rwleft) {
			x=MapToWorldR(-(rwleft-p1x));
		} else if(p2x>rwright) {
			x=MapToWorldR(p2x-rwright);
		}

		if(p1y<rwtop) {
			y=MapToWorldR(-(rwtop-p1y));
		} else if(p2y>rwbottom) {
			y=MapToWorldR(p2y-rwbottom);
		}
		
		if(x!=0 || y!=0) {
			m_OffsetX+=x;
			m_OffsetY+=y;
			Update();
			return true;
		}
		return false;
	}
	
	public function ScrollTimerUpdate(ct:Number):void
	{
		var p1x:Number, p1y:Number, p2x:Number, p2y:Number;
//		var p1x:Number=Math.round(WorldToMapX(EM.ScreenToWorldX(0)))-1;
//		var p1y:Number=Math.round(WorldToMapY(EM.ScreenToWorldY(0)))-1;
//		var p2x:Number=Math.round(WorldToMapX(EM.ScreenToWorldX(EM.stage.stageWidth)))+1;
//		var p2y:Number=Math.round(WorldToMapY(EM.ScreenToWorldY(EM.stage.stageHeight)))+1;
		if (!EmpireMap.Self.PickWorldCoord(0, 0, v0)) return;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, 0, v1)) return;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, v2)) return;
		if (!EmpireMap.Self.PickWorldCoord(0, C3D.m_SizeY, v3)) return;
		p1x = Math.round(WorldToMapX(Math.min(v0.x, v1.x, v2.x, v3.x)));
		p1y = Math.round(WorldToMapY(Math.min(v0.y, v1.y, v2.y, v3.y)));
		p2x = Math.round(WorldToMapX(Math.max(v0.x, v1.x, v2.x, v3.x)));
		p2y = Math.round(WorldToMapY(Math.max(v0.y, v1.y, v2.y, v3.y)));

		var rwleft:Number=0;
		var rwtop:Number=0;
		var rwright:Number=m_SizeX;
		var rwbottom:Number=m_SizeY;
		
		var x:Number=0;
		var y:Number=0;

		m_ScrollTimerDirX=0;
		if(p1x<rwleft) {
			m_ScrollTimerDirX=-1;
			x=MapToWorldR(-(rwleft-p1x));
		} else if(p2x>rwright) {
			m_ScrollTimerDirX=1;
			x=MapToWorldR(p2x-rwright);
		}

		m_ScrollTimerDirY=0;
		if(p1y<rwtop) {
			m_ScrollTimerDirY=-1;
			y=MapToWorldR(-(rwtop-p1y));
		} else if(p2y>rwbottom) {
			m_ScrollTimerDirY=1;
			y=MapToWorldR(p2y-rwbottom);
		}

		if(m_ScrollTimerDirX || m_ScrollTimerDirY) {
			EM.m_GoOpen=false;
			EM.SetCenter(EM.OffsetX+x,EM.OffsetY+y);

			if(m_Timer==null) {
				m_Timer = new Timer(20);
            	m_Timer.addEventListener("timer", ScrollTimer);
            	m_Timer.start();
   			}
			if(m_ScrollTimeLU) {
				ScrollTimer();
			} else m_ScrollTimeLU=ct;
		} else {
			m_ScrollTimeLU=0;
			ScrollTimerDestroy();
		}
	}

	public function ScrollTimer(event:TimerEvent=null):void
	{
		var ct:Number=Common.GetTime();
		if(ct<=m_ScrollTimeLU) return;

		var k:Number=(ct-m_ScrollTimeLU)*2;

		m_OffsetX+=m_ScrollTimerDirX*k;
		m_OffsetY+=m_ScrollTimerDirY*k;
		
		EM.m_GoOpen=false;
		EM.SetCenter(EM.OffsetX+m_ScrollTimerDirX*k,EM.OffsetY+m_ScrollTimerDirY*k);
		
		Update();
		
		m_ScrollTimeLU=ct;
	}
	
	public function ScrollTimerDestroy():void
	{
		if(m_Timer) {
			m_Timer.stop();
			m_Timer.removeEventListener("timer", ScrollTimer);
			m_Timer=null;
		}
	}
	
	public function OutCodeDouble(x:Number, y:Number, cleft:Number, ctop:Number, cright:Number, cbottom:Number):int
	{
		var code:int=0;
		if(x<cleft) code|=0x1;
		if(y<ctop) code|=0x2;
		if(x>cright) code|=0x4;
		if(y>cbottom) code|=0x8;
		return code;
	}

	public function DrawLineClip(x1:Number, y1:Number, x2:Number, y2:Number, cleft:Number, ctop:Number, cright:Number, cbottom:Number):void
	{
		var t:Number;
		var ti:Number;
		var code1:int=OutCodeDouble(x1,y1,cleft,ctop,cright,cbottom);
		var code2:int=OutCodeDouble(x2,y2,cleft,ctop,cright,cbottom);
		var inside:Boolean=(code1|code2)==0;
		var outside:Boolean=(code1&code2)!=0;
		while((!outside) && (!inside)) {
			if(code1==0) {
				t=x1; x1=x2; x2=t;
				t=y1; y1=y2; y2=t;
				ti=code1; code1=code2; code2=ti;
			}
			if(code1&0x01) { y1+=(y2-y1)*(cleft-x1)/(x2-x1); x1=cleft; }
			else if(code1&0x02) { x1+=(x2-x1)*(ctop-y1)/(y2-y1); y1=ctop; }
			else if(code1&0x04) { y1+=(y2-y1)*(cright-x1-1)/(x2-x1); x1=cright; }
			else if(code1&0x08) { x1+=(x2-x1)*(cbottom-y1-1)/(y2-y1); y1=cbottom; }
	
			code1=OutCodeDouble(x1,y1,cleft,ctop,cright,cbottom);
			code2=OutCodeDouble(x2,y2,cleft,ctop,cright,cbottom);
			inside=(code1|code2)==0;
			outside=(code1&code2)!=0;
		}
		if (outside) return;
		
		graphics.moveTo(x1,y1);
		graphics.lineTo(x2,y2);
	}

	public function MMQuery():void
	{
		if (Server.Self.IsSendCommand("emminimap")) return;
		var str:String = "";
		if (EM.m_Set_ShowWormholePoint) str += "&t=255";
		else if (EM.m_Set_ShowColony) str += "&t=254";
		else if (EM.m_Set_ShowGravitor) str += "&t=253";
		else if (EM.m_Set_ShowMine) str += "&t=252";
		else if (EM.m_Set_ShowNoCapture) str += "&t=251";
		else if (m_ShowBuildingType) str += "&t=" + m_ShowBuildingType.toString();
		Server.Self.Query("emminimap",str,MMAnswer,false);
	}

	public function MMAnswer(event:Event):void
	{
		var i:int,cnt:int;
		var cotl:SpaceCotl;

		if(EM.m_SectorCntX<=0) return;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

var t0:int = getTimer();
		
		m_Occupancy=buf.readUnsignedInt();

		var len:int=EM.m_SectorCntX*EM.m_SectorCntY*4*MMSizePlanet;
		m_MMData.length=len;
		m_MMData.position=0;
		for(i=0;i<(len>>2);i++) m_MMData.writeInt(0);
		if(m_MMData.length!=len) throw Error("");

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var sx:int=0;
		var sy:int=0;
		//var px:int=0;
		//var py:int=0;

		var score:int=0;
		var openscore:int=0;
		var openx:int=0;
		var openy:int=0;
		var findok:Boolean=false;

		var findopen:Boolean=false;
		var findopenx:int=0;
		var findopeny:int=0;
		
		while(EM.m_GoOpen) {
			cotl = EM.HS.GetCotl(Server.Self.m_CotlId);
			if(cotl==null) break;
			if(!cotl.m_OldOffsetSet) break;
			findopen=true;
			findopenx=Math.floor(cotl.m_OldOffsetX/EM.m_SectorSize);
			findopeny=Math.floor(cotl.m_OldOffsetY/EM.m_SectorSize);
			break;
		}

		while(true) {
			var fl:uint=sl.LoadDword();
			if (!fl) break;
			
			fl &= ~MapFlagNoEmpty;

			sx+=sl.LoadInt();
			sy+=sl.LoadInt();
			//px+=sl.LoadInt();
			//py+=sl.LoadInt();
			
			var owner:uint=sl.LoadDword();

			var _transport:int=0; if(fl & MapFlagTransport) _transport=sl.LoadInt();
			var _corvette:int=0; if(fl & MapFlagCorvette) _corvette=sl.LoadInt();
			var _cruiser:int=0; if(fl & MapFlagCruiser) _cruiser=sl.LoadInt();
			var _dreadnought:int=0; if(fl & MapFlagDreadnought) _dreadnought=sl.LoadInt();
			var _invader:int=0; if(fl & MapFlagInvader) _invader=sl.LoadInt();
			var _devastator:int=0; if(fl & MapFlagDevastator) _devastator=sl.LoadInt();
			var _warbase:int=0; if(fl & MapFlagWarBase) _warbase=sl.LoadInt();
			var _shipyard:int=0; if(fl & MapFlagShipyard) _shipyard=sl.LoadInt();
			var _scibase:int = 0; if (fl & MapFlagSciBase) _scibase = sl.LoadInt();
			var _servicebase:int = 0; if (fl & MapFlagServiceBase) _servicebase = sl.LoadInt();
			var _blvl:int = 0; if (fl & MapFlagBuildingLvl) {
				_blvl = sl.LoadInt();
			}

			var _landingplace:int=0; if(fl & (MapFlagArrivalDef|MapFlagArrivalAtk)) _landingplace=sl.LoadInt(); 

			if(sx<EM.m_SectorMinX) continue;
			if(sy<EM.m_SectorMinY) continue;
			if(sx>=EM.m_SectorMinX+EM.m_SectorCntX) continue;
			if(sy>=EM.m_SectorMinY+EM.m_SectorCntY) continue;
			
//			if(owner==Server.Self.m_UserId || _transport>0 || _corvette>0 || _cruiser>0 || _dreadnought>0 || _invader>0 || _devastator>0 || _warbase>0 || _shipyard>0 || _scibase>0 || _servicebase>0 || (fl&MapFlagFlagship)!=0) fl|=MapFlagOwner;
			if(owner==Server.Self.m_UserId || (fl&MapFlagFlagship)!=0) fl|=MapFlagOwner;

			m_MMData.position=((fl&3))*MMSizePlanet+(sx-EM.m_SectorMinX)*4*MMSizePlanet+(sy-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
			m_MMData.writeUnsignedInt(fl);
			//m_MMData.writeInt(px);
			//m_MMData.writeInt(py);
			m_MMData.writeUnsignedInt(owner);
			m_MMData.writeInt(_transport);
			m_MMData.writeInt(_corvette);
			m_MMData.writeInt(_cruiser);
			m_MMData.writeInt(_dreadnought);
			m_MMData.writeInt(_invader);
			m_MMData.writeInt(_devastator);
			m_MMData.writeInt(_warbase);
			m_MMData.writeInt(_shipyard);
			m_MMData.writeInt(_scibase);
			m_MMData.writeInt(_servicebase);
			m_MMData.writeInt(_blvl);
			m_MMData.writeInt(_landingplace);

			if(findopen) {
				score=(findopenx-sx)*(findopenx-sx)+(findopeny-sy)*(findopeny-sy);

				if(!findok || score<openscore) {
					findok=true;
					openx=sx*EM.m_SectorSize+(EM.m_SectorSize>>1);//px;
					openy=sy*EM.m_SectorSize+(EM.m_SectorSize>>1);//py;
					openscore=score;
				}
			} else {
				score=1;

				if(owner==Server.Self.m_UserId) {
					if(fl & (MapFlagHomeworld|MapFlagCitadel)) score|=0x20000000;
					else score|=0x10000000; 
				}
				score+=_transport+_corvette+_cruiser+_dreadnought+_invader+_devastator+_warbase+_shipyard+_scibase+_servicebase;

				if(score>openscore) {
					openx=sx*EM.m_SectorSize+(EM.m_SectorSize>>1);//px;
					openy=sy*EM.m_SectorSize+(EM.m_SectorSize>>1);//py;
					openscore=score;
				}
			}
		}

var t1:int = getTimer();
		m_LandingAccess.length=sl.LoadDword();
		for(i=0;i<m_LandingAccess.length;i++) {
			m_LandingAccess[i]=sl.LoadDword();
		}

		sl.LoadEnd();

		if(buf.position<buf.length) {
			var tx:int,ty:int,xx:int,off:int,x:int,y:int,k:int,ex:int,ey:int;
/*			var rowsize:int=(EM.m_SectorCntX>>3);
			if(EM.m_SectorCntX & 7) rowsize++;
			for(ty=EM.m_SectorMinY;ty<(EM.m_SectorMinY+EM.m_SectorCntY);ty++) {
				tx=EM.m_SectorMinX;
				for(xx=0;xx<rowsize;xx++) {
					var mb:uint=buf.readUnsignedByte();
//trace("mb0:0x"+mb.toString(16),"pos:",tx,ty,"max:",(EM.m_SectorMinX+EM.m_SectorCntX));
					for(k=0;(k<8) && (tx<(EM.m_SectorMinX+EM.m_SectorCntX));k++,tx++,mb>>=1) {
//if(mb!=0) trace("mb1:0x"+mb.toString(16));
						if((mb & 1)==0) continue;

//trace(tx,ty)
						sx=Math.max(EM.m_SectorMinX,tx-1);
						sy=Math.max(EM.m_SectorMinY,ty-1);
						ex=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,tx+2);
						ey=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,ty+2);

//					x=tx;
//					y=ty;

						for(y=sy;y<ey;y++) {
							for(x=sx;x<ex;x++) {
								for(i=0;i<4;i++) {
									off=i*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
									if(off+MMSizePlanet>m_MMData.length) continue;
									m_MMData.position=off;
									fl=m_MMData.readUnsignedInt();

									m_MMData.position=off;
									m_MMData.writeUnsignedInt(fl | MapFlagEnemyForHyperspace);
								}
							}
						}
					}
				}
			}*/
			var rowsize:int=(EM.m_SectorCntX>>2);
			if(EM.m_SectorCntX & 3) rowsize++;
			for(ty=EM.m_SectorMinY;ty<(EM.m_SectorMinY+EM.m_SectorCntY);ty++) {
				tx=EM.m_SectorMinX;
				for(xx=0;xx<rowsize;xx++) {
					var mb:uint=buf.readUnsignedByte();
//trace("mb0:0x"+mb.toString(16),"pos:",tx,ty,"max:",(EM.m_SectorMinX+EM.m_SectorCntX));
					for(k=0;(k<4) && (tx<(EM.m_SectorMinX+EM.m_SectorCntX));k++,tx++,mb>>=2) {
//if(mb!=0) trace("mb1:0x"+mb.toString(16));
						if ((mb & 3) == 0) continue;
						
//trace(tx,ty)
						sx=Math.max(EM.m_SectorMinX,tx-1);
						sy=Math.max(EM.m_SectorMinY,ty-1);
						ex=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,tx+2);
						ey=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,ty+2);

//					x=tx;
//					y=ty;

						for(y=sy;y<ey;y++) {
							for(x=sx;x<ex;x++) {
								for(i=0;i<4;i++) {
									off=i*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
									if(off+MMSizePlanet>m_MMData.length) continue;
									m_MMData.position=off;
									fl=m_MMData.readUnsignedInt();

									m_MMData.position = off;
									if ((mb & 1) != 0) fl |= MapFlagEnemyForHyperspace;
									if ((mb & 2) != 0) fl |= MapFlagFriendForHyperspace;
									m_MMData.writeUnsignedInt(fl);
								}
							}
						}
					}
				}
			}
			if(buf.position!=buf.length) { trace("err"); }

			for(ty=EM.m_SectorMinY;(ty<EM.m_SectorMinY+EM.m_SectorCntY);ty++) {
				for(tx=EM.m_SectorMinX;(tx<EM.m_SectorMinX+EM.m_SectorCntX);tx++) {
					for(k=0;k<4;k++) {
						off=k*MMSizePlanet+(tx-EM.m_SectorMinX)*4*MMSizePlanet+(ty-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
						if(off+MMSizePlanet>m_MMData.length) continue;
						m_MMData.position=off;
						fl=m_MMData.readUnsignedInt();

						if((fl & MapFlagOwner)==0) continue; 

						sx=Math.max(EM.m_SectorMinX,tx-1);
						sy=Math.max(EM.m_SectorMinY,ty-1);
						ex=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,tx+2);
						ey=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,ty+2);

						for(y=sy;y<ey;y++) {
							for(x=sx;x<ex;x++) {
								for(i=0;i<4;i++) {
//trace(x,y,i);
									off=i*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
									if(off+MMSizePlanet>m_MMData.length) continue;
									m_MMData.position=off;
									fl=m_MMData.readUnsignedInt();

									m_MMData.position=off;
									m_MMData.writeUnsignedInt(fl | MapFlagOwnerForHyperspace);
								}
							}
						}

						break;
					}
				}
			}
		}
var t2:int = getTimer();

/*		m_NoEnterFromHyperspace=true;
		m_NoEnterFromHyperspaceOwner=true;
		var cc:uint;
		for(ty=EM.m_SectorMinY;(ty<EM.m_SectorMinY+EM.m_SectorCntY);ty++) {
			for(tx=EM.m_SectorMinX;(tx<EM.m_SectorMinX+EM.m_SectorCntX);tx++) {
				for(i=0;i<8;i++) {
					x=tx; y=ty;
					if(i==0) { if(x<=0) continue; x--; }
					else if(i==1)  { if(x>=(EM.m_SectorCntX-1)) continue; x++; }
					else if(i==2)  { if(y<=0) continue; y--; }
					else if(i==3)  { if(y>=(EM.m_SectorCntY-1)) continue; y++; }
					else if(i==4)  { if(x<=0 || y<=0) continue; x--; y--; }
					else if(i==5)  { if(x<=0 || y>=(EM.m_SectorCntY-1)) continue; x--; y++; }
					else if(i==6)  { if(x>=(EM.m_SectorCntX-1) || y<=0) continue; x++; y--; }
					else if(i==7)  { if(x>=(EM.m_SectorCntX-1) || y>=(EM.m_SectorCntY-1)) continue; x++; y++; }

					off=((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+0;
					if(off>m_PlanetPos.length) continue;					
					cc=m_PlanetPos[off];
					if(cc==0) continue;

					off=EM.m_SectorCntX*EM.m_SectorCntY*4+((x-EM.m_SectorMinX)+(y-EM.m_SectorMinY)*EM.m_SectorCntX)*4+0;
					if(off>m_PlanetPos.length) continue;
					var fls:uint=m_PlanetPos[off];

					off=0*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
					if(off+MMSizePlanet>m_MMData.length) continue;
					m_MMData.position=off;
					fl=m_MMData.readUnsignedInt();

					if(fls & 2) continue;
					if(!(fl & MapFlagEnemyForHyperspace)) {
//trace(x-EM.m_SectorMinX+1,y-EM.m_SectorMinY+1,fl.toString(16));
						m_NoEnterFromHyperspace=false;
//						break;
					}
					if(!(fl & MapFlagOwnerForHyperspace)) {
						m_NoEnterFromHyperspaceOwner=false;
//						break;
					}
				}
			}
		}*/

/*		var ax:int,ay:int,off:int,ex:int,ey:int,x:int,y:int;
		for(ay=EM.m_SectorMinY;ay<EM.m_SectorMinY+EM.m_SectorCntY;ay++) {
			for(ax=EM.m_SectorMinX;ax<EM.m_SectorMinX+EM.m_SectorCntX;ax++) {
				sx=Math.max(EM.m_SectorMinX,ax-1);
				sy=Math.max(EM.m_SectorMinY,ay-1);
				ex=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,ax+2);
				ey=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,ay+2);

				var acc:Boolean=true;

				for(y=sy;y<ey;y++) {
					for(x=sx;x<ex;x++) {
						for(i=0;i<4;i++) {
							off=i*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
							if(off+MMSizePlanet>m_MMData.length) continue;
							m_MMData.position=off;
							fl=m_MMData.readUnsignedInt();

							if(fl & MapFlagEnemy) acc=false;
						}
					}
				}

				if(acc) {
					for(i=0;i<4;i++) {
						off=i*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
						if(off+MMSizePlanet>m_MMData.length) continue;
						m_MMData.position=off;
						fl=m_MMData.readUnsignedInt();

						m_MMData.position=off;
						m_MMData.writeUnsignedInt(fl | MapFlagAccessHyperspace);
					}
				}
			}
		}*/
		
//		CalcMiniMapIsland();
		m_NeedCalcMiniMapIsland = true;
var t3:int = getTimer();

		while(EM.m_GoOpen) {
			if(!findopen) {
				cotl = EM.HS.GetCotl(Server.Self.m_CotlId);
				if(cotl!=null) {
					if(cotl.m_OldOffsetSet) break;
				}
			}

			if (!EM.IsVisCamSector()) {
				EM.SetCenter(openx,openy);
				SetCenter(openx, openy);
			} else EM.m_GoOpen = false;
			break;
		}

var t4:int = getTimer();

		Update();		
var t5:int = getTimer();
if((t5 - t0) > 50 && EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("!SLOW.MMA " + (t1 - t0).toString() + " " + (t2 - t1).toString() + " " + (t3 - t2).toString() + " " + (t4 - t3).toString() + " " + (t5 - t4).toString());

//trace("MMAnswer:", t1 - t0, t2 - t1, t3 - t2, t4 - t3, t5 - t4);
	}

	public function QueryOwner():void
	{
/*		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, AnswerOwner);
		loader.addEventListener(IOErrorEvent.IO_ERROR, EM.ConnectError);
		var lr:URLRequest = new URLRequest("http://www.elementalgames.com:8000/emmmowner?ss="+EM.m_Session+"&nc="+EM.m_NoCacheStr+EM.m_NoCacheNo); EM.m_NoCacheNo++;
		loader.load(lr);*/

//		Server.Self.Query("emmmowner",'',AnswerOwner,false);
		
	}

/*	public function AnswerOwner(event:Event):void
	{
		var i,cnt:int;
		
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		m_MapVersion=buf.readUnsignedInt();
		var size:uint=buf.readUnsignedInt();
//trace("AnswerOwner size=",size);
		
		m_PlanetOwner.length=0;
		buf.readBytes(m_PlanetOwner,0,size);
		m_PlanetOwner.uncompress();

//trace("AnswerOwner complate");

//trace("AnswerOwner="+buf.length+" Version="+m_MapVersion+" size="+m_PlanetOwner.length);

		CalcMiniMapIsland();
		
		if(EM.m_GoToBirthSector) {
			if(EM.m_HomeworldPlanetNum<0) {
				if(GoToBirthSector()) EM.m_GoToBirthSector=false; 
			} else {
				EM.m_GoToBirthSector=false;
			}
		}

		Update();
	}*/
	
	private var m_NeedCalcMiniMapIsland:Boolean = true;
	
	public function CalcMiniMapIsland():void
	{
		var i:int,nsx:int,nsy:int,npl:int,npn:int,tsx:int,tsy:int,tpl:int,tpn:int;
		var cc:uint,off:uint,owner:uint;
		var cnt:int,sme:int;
		var px:Number, py:Number;
		
		m_NeedCalcMiniMapIsland = false;
		
		var ss:int=EM.m_SectorSize;

		cnt=EM.m_SectorCntX*EM.m_SectorCntY*4;
		
		m_Island.length=cnt;
		for(i=0;i<cnt;i++) m_Island[i]=0;
		
		var islandcnt:int=1;
		
		var pl:Array=new Array();
		
		var rm2:Number = (EM.m_OpsJumpRadius + 25) * (EM.m_OpsJumpRadius + 25);
		
		npn=0;
		for(nsy=0;nsy<EM.m_SectorCntY;nsy++) {
			for(nsx=0;nsx<EM.m_SectorCntX;nsx++) {
				for(npl=0;npl<4;npl++,npn++) {
					if(m_Island[npn]!=0) continue;

					cc=m_PlanetPos[npn];
					if(cc==0) continue;

//					off=npn<<2;
//					if(off>=m_PlanetOwner.length) continue;
//					m_PlanetOwner.position=off;
//					owner=m_PlanetOwner.readUnsignedInt();
//trace("owner",owner);
					off=npl*MMSizePlanet+(nsx/*-EM.m_SectorMinX*/)*4*MMSizePlanet+(nsy/*-EM.m_SectorMinY*/)*4*MMSizePlanet*EM.m_SectorCntX;
					if(off+MMSizePlanet>m_MMData.length) continue;
					m_MMData.position=off;
					m_MMData.readUnsignedInt();
					
					owner=m_MMData.readUnsignedInt();

					islandcnt++;
					m_Island[npn]=islandcnt;

					px=((cc & 15)-1)/14.0*ss+(EM.m_SectorMinX+nsx)*ss;
					py=(((cc>>4) & 15)-1)/14.0*ss+(EM.m_SectorMinX+nsy)*ss;

					sme=0;
					pl.length=0;
					pl.push(nsx);
					pl.push(nsy);
					pl.push(px);
					pl.push(py);

					while(sme<pl.length) {
						var fsx:int=pl[sme+0];
						var fsy:int=pl[sme+1];
						var fpx:Number=pl[sme+2];
						var fpy:Number=pl[sme+3];
						sme+=4;

						var bsx:int=fsx-1; if(bsx<0) bsx=0;
						var bsy:int=fsy-1; if(bsy<0) bsy=0; 
						var esx:int=fsx+2; if(esx>EM.m_SectorCntX) esx=EM.m_SectorCntX;
						var esy:int=fsy+2; if(esy>EM.m_SectorCntY) esy=EM.m_SectorCntY;

						tpn=(bsx<<2)+(bsy*(EM.m_SectorCntX<<2));
						for(tsy=bsy;tsy<esy;tsy++,tpn+=((EM.m_SectorCntX-(esx-bsx))<<2)) {
							for(tsx=bsx;tsx<esx;tsx++) {
								for(tpl=0;tpl<4;tpl++,tpn++) {
									if(m_Island[tpn]!=0) continue;

//									off=tpn<<2;
//									if(off>=m_PlanetOwner.length) continue;
//									m_PlanetOwner.position=off;
//									if(owner!=m_PlanetOwner.readUnsignedInt()) continue;
									
									off=tpl*MMSizePlanet+(tsx/*-EM.m_SectorMinX*/)*4*MMSizePlanet+(tsy/*-EM.m_SectorMinY*/)*4*MMSizePlanet*EM.m_SectorCntX;
									if(off+MMSizePlanet>m_MMData.length) continue;
									m_MMData.position=off;
									m_MMData.readUnsignedInt();
									
									if(owner!=m_MMData.readUnsignedInt()) continue;

									cc=m_PlanetPos[tpn];
									if(cc==0) continue;

									px=((cc & 15)-1)/14.0*ss+(EM.m_SectorMinX+tsx)*ss;
									py=(((cc>>4) & 15)-1)/14.0*ss+(EM.m_SectorMinX+tsy)*ss;

									if(((px-fpx)*(px-fpx)+(py-fpy)*(py-fpy))>rm2) continue;

									m_Island[tpn]=islandcnt;

									pl.push(tsx);
									pl.push(tsy);
									pl.push(px);
									pl.push(py);
								}
							}
						} 
					}
					
				}
			}
		}
//trace("islandcnt",islandcnt);
	}
	
	public function CalcDanger(secx:int, secy:int, r:int):int
	{
		var x:int, y:int, npn:int, npl:int;
		var cc:uint,off:uint,owner:uint;

		var sx:int=Math.max(EM.m_SectorMinX,secx-r);
		var sy:int=Math.max(EM.m_SectorMinY,secy-r);
		var ex:int=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,secx+r+1);
		var ey:int=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,secy+r+1);

		npn=((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)*4;
		
		var score:int=0;

		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				for(npl=0;npl<4;npl++,npn++) {
					cc=m_PlanetPos[npn];
					if(cc==0) continue;

//					off=npn<<2;
//					if(off>=m_PlanetOwner.length) continue;
//					m_PlanetOwner.position=off;
//					owner=m_PlanetOwner.readUnsignedInt();
					off=npl*MMSizePlanet+(x-EM.m_SectorMinX)*4*MMSizePlanet+(y-EM.m_SectorMinY)*4*MMSizePlanet*EM.m_SectorCntX;
					if(off+MMSizePlanet>m_MMData.length) continue;
					m_MMData.position=off;
					m_MMData.readUnsignedInt();
					
					owner=m_MMData.readUnsignedInt();

					if(owner==0) score-=1;
					else score+=1;
				}
			}
		}

		return score;
	}
	
/*	public function GoToBirthSector():Boolean
	{
		var score:int, i:int, x:int, y:int;
		var bscore:int=-1000000000;
		var bx:int=0;
		var by:int=0;
		
		if(m_PlanetOwner.length<=0) return false;

		for(i=0;i<1000;i++) {
			x=Math.round(Math.random()*(EM.m_SectorCntX-1))+EM.m_SectorMinX;
			y=Math.round(Math.random()*(EM.m_SectorCntY-1))+EM.m_SectorMinY;
			if(x<EM.m_SectorMinX || x>=EM.m_SectorMinX+EM.m_SectorCntX) continue;
			if(y<EM.m_SectorMinY || y>=EM.m_SectorMinY+EM.m_SectorCntY) continue;

			score=-CalcDanger(x,y,0)*1000;
			score+=-CalcDanger(x,y,5);

			if(score>bscore) { bscore=score; bx=x; by=y; }
		}		

		EM.m_GoOpen=false;
		EM.SetCenter(bx*EM.m_SectorSize+(EM.m_SectorSize>>1),by*EM.m_SectorSize+(EM.m_SectorSize>>1));
		SetCenter(EM.m_OffsetX,EM.m_OffsetY);
		
		return true;
	}*/
	
	public function GoBase():void
	{
		if (EM.IsWinMaxEnclave()) {
			if (EM.m_BasePlanetNum >= 0) {
				EM.GoTo(true, Server.Self.m_CotlId, EM.m_BaseSectorX, EM.m_BaseSectorY, EM.m_BasePlanetNum);
			}
			return;
		}
	}
	
	
/*	public function GoColony():void
	{
		var k:int, nsx:int, nsy:int, npl:int, npn:int;
		var cc:uint,off:uint,owner:uint;
		var px:Number, py:Number;
		
		if (EM.IsWinMaxEnclave()) {
			if (EM.m_BasePlanetNum >= 0) {
				EM.GoTo(false, Server.Self.m_CotlId, EM.m_BaseSectorX, EM.m_BaseSectorY, EM.m_BasePlanetNum);
			}
			return;
		}
		
		if(m_NeedCalcMiniMapIsland) CalcMiniMapIsland();

		if(m_Island.length<=0) return;

		var ss:int=EM.m_SectorSize;

		var skipisland1:int=0;
		var skipisland2:int=0;

		if(EM.m_HomeworldPlanetNum>=0) skipisland1=m_Island[((EM.m_HomeworldSectorX-EM.m_SectorMinX)+(EM.m_HomeworldSectorY-EM.m_SectorMinY)*(EM.m_SectorCntX))*4+EM.m_HomeworldPlanetNum];
		if(EM.m_CitadelNum>=0) skipisland2=m_Island[((EM.m_CitadelSectorX-EM.m_SectorMinX)+(EM.m_CitadelSectorY-EM.m_SectorMinY)*(EM.m_SectorCntX))*4+EM.m_CitadelNum];
//trace("skip",skipisland1,skipisland2);
		var mr:Number;
		var bp:int=-1;
		var bsx:int=0;
		var bsy:int=0;
		var bpx:int=0;
		var bpy:int=0;

		npn=0;
		for(nsy=0;nsy<EM.m_SectorCntY;nsy++) {
			for(nsx=0;nsx<EM.m_SectorCntX;nsx++) {
				for(npl=0;npl<4;npl++,npn++) {
					if(m_Island[npn]==0) continue;
					if(m_Island[npn]==skipisland1) continue;
					if(m_Island[npn]==skipisland2) continue;

					cc=m_PlanetPos[npn];
					if(cc==0) continue;

//					off=npn<<2;
//					if(off>=m_PlanetOwner.length) continue;
//					m_PlanetOwner.position=off;
//					if(m_PlanetOwner.readUnsignedInt()!=Server.Self.m_UserId) continue;

					off=npl*MMSizePlanet+(nsx)*4*MMSizePlanet+(nsy)*4*MMSizePlanet*EM.m_SectorCntX; // -EM.m_SectorMinX -EM.m_SectorMinY
					if(off+MMSizePlanet>m_MMData.length) continue;
					m_MMData.position=off;
					m_MMData.readUnsignedInt();
					
					if(m_MMData.readUnsignedInt()!=Server.Self.m_UserId) continue;

					px=((cc & 15)-1)/14.0*ss+(EM.m_SectorMinX+nsx)*ss;
					py=(((cc>>4) & 15)-1)/14.0*ss+(EM.m_SectorMinX+nsy)*ss;
					
					var r:Number = (px - EM.OffsetX) * (px - EM.OffsetX) + (py - EM.OffsetY) * (py - EM.OffsetY);
					
					if(bp>=0 && r>=mr) continue;
					
					for(k=0;k<m_VisitColony.length;k+=3) {
						var tx:int=m_VisitColony[k+0];
						var ty:int=m_VisitColony[k+1];
						var tp:int=m_VisitColony[k+2];
						
						if(m_Island[((tx+ty*EM.m_SectorCntX)<<2)+tp]==m_Island[npn]) break;
					}
					if(k<m_VisitColony.length) continue;
					
					mr=r;
					bp=npl;
					bsx=nsx;
					bsy=nsy;
					bpx=px;
					bpy=py;
				}
			}
		}
		
		if(bp>=0) {
			m_VisitColony.push(bsx);
			m_VisitColony.push(bsy);
			m_VisitColony.push(bp);

			EM.m_GoOpen=false;
			EM.SetCenter(bpx,bpy);
			EM.m_FormMiniMap.SetCenter(EM.OffsetX,EM.OffsetY);
			
//trace(bsx+EM.m_SectorMinX,bsy+EM.m_SectorMinY,bp);
			EM.AddGraphFind(Server.Self.m_CotlId,bsx+EM.m_SectorMinX,bsy+EM.m_SectorMinY,bp);
		}
	}*/
	
	public function SetOpen():void
	{
		//EM.CloseForModal();
		EM.m_FormMenu.Clear();

		//if(m_OpenFull) EM.m_FormMenu.Add(Common.Txt.MiniMapSmall,MiniMapLarge);
		//else EM.m_FormMenu.Add(Common.Txt.MiniMapLarge,MiniMapLarge);

		EM.m_FormMenu.Add(Common.Txt.MiniMapPlanet,MiniMapPlanet).Check=m_ShowPlanet;
		EM.m_FormMenu.Add(Common.Txt.MiniMapShip,MiniMapShip).Check=m_ShowShip;
		EM.m_FormMenu.Add(Common.Txt.MiniMapRes,MiniMapRes).Check=m_ShowRes;

		//if(m_ShowPlanet) EM.m_FormMenu.Add(Common.Txt.MiniMapHidePlanet,MiniMapPlanet);
		//else EM.m_FormMenu.Add(Common.Txt.MiniMapShowPlanet,MiniMapPlanet);

		//if(m_ShowShip) EM.m_FormMenu.Add(Common.Txt.MiniMapHideShip,MiniMapShip);
		//else EM.m_FormMenu.Add(Common.Txt.MiniMapShowShip,MiniMapShip);

		EM.m_FormMenu.Add();

		var chb:Boolean = false;
		if(EM.IsWinMaxEnclave()) {
			EM.m_FormMenu.Add(Common.BuildingName[Common.BuildingTypeLab], ShowBuildingType, Common.BuildingTypeLab).Check = m_ShowBuildingType == Common.BuildingTypeLab; if (!chb) chb = (m_ShowBuildingType == Common.BuildingTypeLab);
//			EM.m_FormMenu.Add(Common.BuildingName[Common.BuildingTypeModule], ShowBuildingType, Common.BuildingTypeModule).Check = m_ShowBuildingType == Common.BuildingTypeModule; if (!chb) chb = (m_ShowBuildingType == Common.BuildingTypeModule);
		}
		if (m_ShowBuildingType != 0 && !chb) {
			EM.m_FormMenu.Add(Common.BuildingName[m_ShowBuildingType], ShowBuildingType, m_ShowBuildingType).Check = true;
		}
		EM.m_FormMenu.Add(Common.Txt.FormConstructionSelect, SelectBuildingType);
		
		EM.m_FormMenu.Add(Common.Txt.FormMiniMapWormholes, SelectWormholePoint).Check = EM.m_Set_ShowWormholePoint;
		EM.m_FormMenu.Add(Common.Txt.FormMiniMapGravitor, SelectShowGravitor).Check = EM.m_Set_ShowGravitor;
		EM.m_FormMenu.Add(Common.Txt.FormMiniMapMine, SelectShowMine).Check = EM.m_Set_ShowMine;
		EM.m_FormMenu.Add(Common.Txt.FormMiniMapColony, SelectShowColony).Check = EM.m_Set_ShowColony;
		if (EM.IsEdit()) EM.m_FormMenu.Add(Common.Txt.FormMiniMapNoCapture, SelectShowNoCapture).Check = EM.m_Set_ShowNoCapture;

		EM.m_FormMenu.Add();

		EM.m_FormMenu.Add(Common.Txt.MiniMapAllShip,ShowPlayerShip,Common.ShipTypeNone).Check=m_ShowShipPlayer==0;
		EM.m_FormMenu.Add(Common.Txt.MiniMapPlayerShip+":");
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeCorvette], ShowPlayerShip, Common.ShipTypeCorvette).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeCorvette)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeCruiser], ShowPlayerShip, Common.ShipTypeCruiser).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeCruiser)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeDreadnought], ShowPlayerShip, Common.ShipTypeDreadnought).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeDreadnought)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeInvader], ShowPlayerShip, Common.ShipTypeInvader).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeInvader)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeDevastator], ShowPlayerShip, Common.ShipTypeDevastator).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeDevastator)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeWarBase], ShowPlayerShip, Common.ShipTypeWarBase).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeWarBase)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeShipyard], ShowPlayerShip, Common.ShipTypeShipyard).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeShipyard)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeSciBase], ShowPlayerShip, Common.ShipTypeSciBase).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeSciBase)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeServiceBase], ShowPlayerShip, Common.ShipTypeServiceBase).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeServiceBase)) != 0;
		EM.m_FormMenu.Add("    " + Common.ShipNameM[Common.ShipTypeTransport], ShowPlayerShip, Common.ShipTypeTransport).Check = (m_ShowShipPlayer & (1 << Common.ShipTypeTransport)) != 0;

		EM.m_FormMenu.Add();

		EM.m_FormMenu.Add(Common.Txt.MiniMapScaleDefault,MiniMapScaleDefault);

		var cx:int=m_ButOptions.x+x;
		var cy:int=m_ButOptions.y+y;

		EM.m_FormMenu.SetButOpen(m_ButOptions);
		EM.m_FormMenu.Show(cx, cy, cx + 1, cy + m_ButOptions.height);
	}
	
	private function MiniMapLarge(...args):void
	{
//trace(1);
		m_OpenFull=!m_OpenFull;
		if(visible) {
			Show();
			EM.m_GoOpen=false;
			if(m_OpenFull) ScrollToView();
			else SetCenter(EM.OffsetX,EM.OffsetY);
		}
	}

	private function MiniMapPlanet(...args):void
	{
		m_ShowPlanet=!m_ShowPlanet;
		if(visible) {
			Show();
			ScrollToView();
		}
	}

	private function MiniMapShip(...args):void
	{
		m_ShowShip=!m_ShowShip;
		if(visible) {
			Show();
			ScrollToView();
		}
	}

	private function MiniMapRes(...args):void
	{
		m_ShowRes=!m_ShowRes;
		if(visible) {
			Show();
		}
	}

	private function MiniMapScaleDefault(...args):void
	{
		m_ScaleKof=m_ScaleKofDefault;
		if(visible) {
			Show();
		}
		ShipPlayerQuery(true);
	}

	private function SelectShowColony(...args):void
	{
		EM.m_Set_ShowWormholePoint = false;
		EM.m_Set_ShowColony = !EM.m_Set_ShowColony;
		EM.m_Set_ShowGravitor = false;
		EM.m_Set_ShowMine = false;
		EM.m_Set_ShowNoCapture = false;
		
		m_ShowBuildingType = 0;
		MMQuery();
		Update();
	}
	
	private function SelectShowNoCapture(...args):void
	{
		EM.m_Set_ShowWormholePoint = false;
		EM.m_Set_ShowColony = false;
		EM.m_Set_ShowGravitor = false;
		EM.m_Set_ShowMine = false;
		EM.m_Set_ShowNoCapture = !EM.m_Set_ShowNoCapture;
		
		m_ShowBuildingType = 0;
		MMQuery();
		Update();
	}

	private function SelectShowGravitor(...args):void
	{
		EM.m_Set_ShowWormholePoint = false;
		EM.m_Set_ShowColony = false;
		EM.m_Set_ShowGravitor = !EM.m_Set_ShowGravitor;
		EM.m_Set_ShowMine = false;
		EM.m_Set_ShowNoCapture = false;
		
		m_ShowBuildingType = 0;
		MMQuery();
		Update();
	}

	private function SelectShowMine(...args):void
	{
		EM.m_Set_ShowWormholePoint = false;
		EM.m_Set_ShowColony = false;
		EM.m_Set_ShowGravitor = false;
		EM.m_Set_ShowMine = !EM.m_Set_ShowMine;
		EM.m_Set_ShowNoCapture = false;
		
		m_ShowBuildingType = 0;
		MMQuery();
		Update();
	}

	private function SelectWormholePoint(...args):void
	{
		EM.m_Set_ShowWormholePoint = !EM.m_Set_ShowWormholePoint;
		EM.m_Set_ShowColony = false;
		EM.m_Set_ShowGravitor = false;
		EM.m_Set_ShowMine = false;
		EM.m_Set_ShowNoCapture = false;

		m_ShowBuildingType = 0;
		MMQuery();
		Update();
	}

	private function SelectBuildingType(obj:Object, d:int):void
	{
		EM.m_FormPlanet.Hide();
		EM.m_FormConstruction.m_TypeCur = m_ShowBuildingType;
		EM.m_Set_ShowWormholePoint = false;
		EM.m_Set_ShowColony = false;
		EM.m_Set_ShowGravitor = false;
		EM.m_Set_ShowMine = false;
		EM.m_Set_ShowNoCapture = false;
		EM.m_FormConstruction.Show();
	}
	
	private function ShowBuildingType(obj:Object, d:int):void
	{
		EM.m_Set_ShowWormholePoint = false;
		EM.m_Set_ShowColony = false;
		EM.m_Set_ShowGravitor = false;
		EM.m_Set_ShowMine = false;
		EM.m_Set_ShowNoCapture = false;
		if (d == m_ShowBuildingType) m_ShowBuildingType = 0;
		else {
			m_ShowBuildingType = d;
			m_ShowShipPlayer = 0;
			
			if(m_ShowBuildingType!=0) MMQuery();
		}
		Update();
	}

	private function ShowPlayerShip(obj:Object, d:int):void
	{
		if(d==Common.ShipTypeNone) m_ShowShipPlayer=0;
		else if(m_ShowShipPlayer & (1<<d)) m_ShowShipPlayer=0;//&=~(1<<d); 
		else {
			m_ShowShipPlayer=(1<<d);
			ShipPlayerQuery(true,true);
		}
		Update();
	}

	public var m_MMQueryTime:Number=0;
	public function ShipPlayerTimer(event:TimerEvent=null):void
	{
		if(m_MMQueryTime+10000<Common.GetTime()) {
			m_MMQueryTime=Common.GetTime();
			MMQuery();
		}
		//ShipPlayerQuery();
	}

	public function ShipPlayerQuery(ignorecooldown:Boolean=false,test:Boolean=false):void
	{
//if(test) trace("t00");
		return;
		
		if(m_ShowShipPlayer==0) return;

//if(test) trace("t01");
		if(!ignorecooldown) {
			if(m_ShipPlayerQueryCooldown>Common.GetTime()) return;
		}
//if(test) trace("t02");
		if(m_ShipPlayerQueryTime+2*1000>Common.GetTime()) {
			if(ignorecooldown) m_ShipPlayerQueryCooldown=m_ShipPlayerQueryTime;
//if(test) trace("t03",m_ShipPlayerQueryCooldown-Common.GetTime());
			return;
		}
//if(test) trace("t04");
		m_ShipPlayerQueryTime=Common.GetTime();

		var fx:int,fy:int,ex:int,ey:int;

		fx=Math.max(EM.m_SectorMinX,Math.floor(MapToWorldX(0)/EM.m_SectorSize));
		fy=Math.max(EM.m_SectorMinY,Math.floor(MapToWorldY(0)/EM.m_SectorSize));
		ex=Math.min(EM.m_SectorMinX+EM.m_SectorCntX,Math.floor(MapToWorldX(m_SizeX)/EM.m_SectorSize)+1);
		ey=Math.min(EM.m_SectorMinY+EM.m_SectorCntY,Math.floor(MapToWorldY(m_SizeY)/EM.m_SectorSize)+1);

		var cooldown:int=((ex-fx)*(ey-fy))*10;
//trace("cooldown",cooldown,(ex-fx)*(ey-fy));
		if(cooldown<5*1000) cooldown=5*1000;
		if(cooldown>30*1000) cooldown=30*1000;
		m_ShipPlayerQueryCooldown=m_ShipPlayerQueryTime+cooldown;

		Server.Self.Query("emshipplayer",'&val='+fx.toString()+'_'+fy.toString()+'_'+ex.toString()+'_'+ey.toString()+"_"+m_ShowShipPlayer.toString(),ShipPlayerAnswer,false);
	}
	
	private function ShipPlayerAnswer(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);
//trace(loader.bytesTotal);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		var size:int=4*EM.m_SectorCntX*EM.m_SectorCntY;
		if(m_ShipPlayerData.length!=size) m_ShipPlayerData.length=size;
		m_ShipPlayerData.position=0;
		for(i=0;i<(size>>2);i++) m_ShipPlayerData.writeInt(0);

		var sx:int=0;
		var sy:int=0;

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		while(true) {
			var cnt:uint=sl.LoadDword();
			if(cnt==0) break;
			sx+=sl.LoadInt();
			sy+=sl.LoadInt();
//trace("Sector",sx,sy,"Cnt",cnt);

			var off:int=((sx-EM.m_SectorMinX)+(sy-EM.m_SectorMinY)*EM.m_SectorCntX)<<2;
			m_ShipPlayerData.position=off;
			m_ShipPlayerData.writeInt(cnt<<4);
		}

		sl.LoadEnd();

		Update();
	}
}

}
