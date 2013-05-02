package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormRadar extends Sprite
{
	private var EM:EmpireMap = null;
	private var HS:Hyperspace = null;
	private var SP:Space = null;

	public var m_SizeX:int;
	public var m_SizeY:int;

	public var m_Angle:Number = 0.0;
	public var m_OffsetX:Number;
	public var m_OffsetY:Number;

	public var m_OffsetFullX:Number;
	public var m_OffsetFullY:Number;

	public var m_Scale:Number;
	public var m_ScaleKof:Number = 50;// 8;
	public var m_ScaleKofDefault:Number = 50;// 8;
	public var m_ScaleDir:Number=0;
	static public const ScaleMin:Number = 20;// 5;
	static public const ScaleMax:Number = 256;// 12;

	public var m_ScaleFull:Number;
	public var m_ScaleFullKof:Number = 800;// 20;
	public var m_ScaleFullKofDefault:Number = 800;// 20;
	static public const ScaleFullMin:Number = 200;// 5;
	static public const ScaleFullMax:Number = 4000;// 300;

	public var m_OpenFull:Boolean=false;

	public var m_Float:Boolean=false;
	public var m_FloatBegin:Boolean = false;
	public var m_CamMove:Boolean = false;
	
	public var m_MousePosOldX:int=0;
	public var m_MousePosOldY:int=0;

	public var m_BMC:Bitmap=null;
	public var m_LayerVec:Sprite=null;
	public var m_LayerBattle:MovieClip = null;
	public var m_LayerFleet:Sprite = null;

	public var m_CaptionBG:Sprite=null;
	public var m_CaptionBG2:Sprite=null;
	public var m_Raz1:Sprite=null;
	public var m_Raz2:Sprite=null;
	public var m_FooterBG:Sprite=null;
	public var m_ButOptions:SimpleButton=null;
	public var m_ButOpen:SimpleButton=null;
	public var m_ButHomeworld:SimpleButton=null;
//	public var m_ButHomeworldOn:Sprite=null;
	public var m_ButCitadel:SimpleButton=null;
//	public var m_ButCitadelOn:Sprite=null;
	public var m_ButFleet:SimpleButton=null;
//	public var m_ButFleetOn:Sprite = null;
//	public var m_ButCombat:SimpleButton = null;
	public var m_ButMinus:SimpleButton = null;
	public var m_ButPlus:SimpleButton = null;
	public var m_SubText:TextField = null;

	public var m_TimeScale:Timer = new Timer(150);
	public var m_TimerShowZone:Timer = new Timer(250, 1);
	
	public var m_TimerBattleFrame:Timer = new Timer(50);
	
	public var m_UpdateTimer:Timer = new Timer(250,1);

	public var m_GalaxyMapTime:Number=0;
	public var m_GalaxyMapVersion:int=0;
	public var m_GalaxyMapData:ByteArray=new ByteArray();

	public var m_GalaxyMapLastQuertSX:int=0;
	public var m_GalaxyMapLastQuertSY:int=0;
	public var m_GalaxyMapLastQuertCntX:int=0;
	public var m_GalaxyMapLastQuertCntY:int=0;
	public var m_GalaxyMapLastQuertUCotl:int=0;
	public var m_GalaxyMapLastQuertZInfo:int=0;
	
	public var m_Mask:Sprite = new Sprite();
	
	public var m_BonusFilter:int = 0;
	public var m_PriceFilter:int = 0;
	
	public var m_BattleFrame:int = 0;
	
	public var m_ShowClanIcon:Boolean = true;
	public var m_ShowCurBattle:Boolean = true;

	public var m_LineSX:int = 0;
	public var m_LineSY:int = 0;
	public var m_LineEX:int = 0;
	public var m_LineEY:int = 0;

	public static var m_TVec:Vector3D = new Vector3D();

	public function FormRadar(map:EmpireMap)
	{
		EM = map;
		HS = map.HS;
		SP = HS.SP;

		m_SizeX=200;
		m_SizeY=200;

		m_OffsetX=0;
		m_OffsetY=0;

		m_OffsetFullX=0;
		m_OffsetFullY=0;
		
		m_Scale=5000;

		m_GalaxyMapData.endian=Endian.LITTLE_ENDIAN;

		EM.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

		doubleClickEnabled=true; 
		addEventListener(MouseEvent.DOUBLE_CLICK,MapLarge);

		m_TimeScale.addEventListener("timer", ScaleTimer);
		m_TimeScale.stop();

		m_TimerShowZone.addEventListener("timer", TimerShowZone);
		m_TimerShowZone.stop();

		m_TimerBattleFrame.addEventListener("timer", BattleFrameChange);
		m_TimerBattleFrame.stop();

		m_UpdateTimer.addEventListener("timer", UpdateTimer);
		m_UpdateTimer.stop();

		m_BMC=new Bitmap();
		addChild(m_BMC);

		m_LayerVec=new Sprite();
		addChild(m_LayerVec);

		m_LayerBattle = new MovieClip();
		m_LayerVec.addChild(m_LayerBattle);

		m_LayerFleet=new Sprite();
		addChild(m_LayerFleet);

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
//		m_ButHomeworldOn=new MMButCapitalOn();
//		addChild(m_ButHomeworldOn);
		m_ButCitadel=new MMButCitadel();
		addChild(m_ButCitadel);
//		m_ButCitadelOn=new MMButCitadelOn();
//		addChild(m_ButCitadelOn);
//		m_ButCombat = new MMButCombat();
//		addChild(m_ButCombat);
		m_ButFleet=new MMButFleet();
		addChild(m_ButFleet);
//		m_ButFleetOn=new MMButFleetOn();
//		addChild(m_ButFleetOn);

		m_ButMinus=new MMButMinus();
		addChild(m_ButMinus);
		m_ButPlus=new MMButPlus();
		addChild(m_ButPlus);

		m_Raz1=new MMCaptionRaz();
		addChild(m_Raz1);
		m_Raz2=new MMCaptionRaz();
		addChild(m_Raz2);

		m_SubText=new TextField();
		m_SubText.width=1;
		m_SubText.height=1;
		m_SubText.type=TextFieldType.DYNAMIC;
		m_SubText.selectable=false;
		m_SubText.textColor=0xffffff;
		m_SubText.background=false;
		m_SubText.backgroundColor=0x80000000;
		m_SubText.alpha=1.0;
		m_SubText.multiline=false;
		m_SubText.autoSize=TextFieldAutoSize.LEFT;
		m_SubText.gridFitType=GridFitType.NONE;
		m_SubText.defaultTextFormat=new TextFormat("Calibri",14,0xAfAfAf);
		m_SubText.embedFonts=true;
		addChild(m_SubText);

		addChild(m_Mask);
		m_LayerVec.mask=m_Mask;
	}

	public function Hide():void
	{
		MouseUnlock();
		
		m_CamMove = false;

		m_LineSX = 0;
		m_LineSY = 0;
		m_LineEX = 0;
		m_LineEY = 0;

		m_TimeScale.stop();
		m_TimerShowZone.stop();
		m_TimerBattleFrame.stop();
		m_UpdateTimer.stop();
		visible=false;
	}

	public function StageResize():void
	{
		if (!visible) return;
		//&& EmpireMap.Self.IsResize()) Show();
		x = EM.stage.stageWidth - m_SizeX - 11;
		y = 37;

		Update();
	}

	public function Show():void // short:Boolean=false
	{
		EM.FloatTop(this);
		
		visible = true;

		m_PickPlanetId = 0;
		m_PickCotlId = 0;
		m_PickCotl.Clear();
//		m_PickCotlType=0;
//		m_PickCotlAccountId=0;
//		m_PickCotlUnionId=0;
		m_PickCotlZoneLvl=0;

		if(m_OpenFull) m_SizeX=Math.round(Math.min(EM.stage.stageWidth,EM.stage.stageHeight-30)-40);
		else m_SizeX=Math.round(Math.min(EM.stage.stageWidth,EM.stage.stageHeight)*0.3);

		m_GalaxyMapLastQuertCntX=0;
		m_GalaxyMapLastQuertCntY=0;
		//if(m_OpenFull && m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();

		//var short:Boolean=false;

		//if(m_SizeX<240) {
		//	short=true;
		//	if(m_SizeX<195) m_SizeX=195;
		//}

		m_SizeY=m_SizeX;
		m_Scale=m_SizeX*m_ScaleKof;
		m_ScaleFull=m_SizeX*m_ScaleFullKof;

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


		m_CaptionBG.x=-10;
		m_CaptionBG.y=-33;
		m_CaptionBG.width=m_SizeX+20;

		m_CaptionBG2.x=-10+5;
		m_CaptionBG2.y=0;//-33;
		m_CaptionBG2.width=m_SizeX+20-10;

		m_FooterBG.x=-10;
		m_FooterBG.y=m_SizeY-31;
		m_FooterBG.width=m_SizeX+20;
		
		//var right:int=m_SizeX-m_ButOpen.width+3;
		//if(short) right+=1;		
		//m_ButOpen.x=right;
		//m_ButOpen.y=-36;
		
		//if(short) m_ButOptions.x=-4;
		//else m_ButOptions.x=-2;
		//m_ButOptions.y=-28;
		
		//if(short) {
		//	m_ButHomeworld.x=-1+25;
		//	m_ButHomeworld.y=-29;
		//	m_ButCitadel.x=-1+25+26;
		//	m_ButCitadel.y=-29;
		//	m_ButFleet.x=-1+25+26+26;
		//	m_ButFleet.y=-29;
		//} else {
		//	m_ButHomeworld.x=-1+50;
		//	m_ButHomeworld.y=-29;
		//	m_ButCitadel.x=-1+50+26;
		//	m_ButCitadel.y=-29;
		//	m_ButFleet.x=-1+50+26+26;
		//	m_ButFleet.y=-29;
		//}

		//m_ButHomeworldOn.x=m_ButHomeworld.x;
		//m_ButHomeworldOn.y=m_ButHomeworld.y;
		//m_ButCitadelOn.x=m_ButCitadel.x;
		//m_ButCitadelOn.y=m_ButCitadel.y;
		//m_ButFleetOn.x=m_ButFleet.x;
		//m_ButFleetOn.y=m_ButFleet.y;

//		if(short) right-=50;
//		else right-=55;
//		m_ButMinus.x=right;
//		m_ButMinus.y=-27;
//		m_ButPlus.x=right;
//		m_ButPlus.y=-27;

		//if(short) {
		//	m_Raz1.visible=false;
		//	m_Raz2.visible=false;
		//} else {
		//	m_Raz1.x=28;
		//	m_Raz1.y=-32;
		//	m_Raz1.visible=true;
		//	m_Raz2.x=right-5;
		//	m_Raz2.y=-32;
		//	m_Raz2.visible=true;
		//}
		
		m_TimerBattleFrame.start();
		
		StageResize();
	}

	public function UpdateBut(short:Boolean=false):void
	{
		var right:int = m_SizeX - m_ButOpen.width + 3;
		if(short) right+=1;
		m_ButOpen.x=right;
		m_ButOpen.y=-36;

		if(short) m_ButOptions.x=-4;
		else m_ButOptions.x=-2;
		m_ButOptions.y = -28;

		var sx:int = -1 + 25;
		if (!short) sx = -1 + 50;

//		if(EM.m_HomeworldCotlId!=0) {
			m_ButHomeworld.x = sx;
			m_ButHomeworld.y = -29;
			sx += 26;
//			m_ButHomeworldOn.visible = (HS.m_FollowType == Hyperspace.FollowHomeworld);
			m_ButHomeworld.visible = true;// !m_ButHomeworldOn.visible;
//		} else {
//			m_ButHomeworldOn.visible = false;
//			m_ButHomeworld.visible = false;
//		}

		//if(EM.m_CitadelCotlId!=0) {
		if (EM.CitadelExistAny()) {
			m_ButCitadel.x = sx;
			m_ButCitadel.y = -29;
			sx += 26;
//			m_ButCitadelOn.visible = (HS.m_FollowType == Hyperspace.FollowCitadel);
			m_ButCitadel.visible = true;// !m_ButCitadelOn.visible;
		} else {
//			m_ButCitadelOn.visible = false;
			m_ButCitadel.visible = false;
		}

//		if(EM.m_UserCombatId!=0) {
//			m_ButCombat.x = sx;
//			m_ButCombat.y = -29;
//			sx += 26;
//			m_ButCombat.visible = true;
//			m_ButFleetOn.visible = false;
//			m_ButFleet.visible = false;
//		} else
		{
			m_ButFleet.x = sx;
			m_ButFleet.y = -29;
			sx += 26;

//			m_ButCombat.visible = false;
			//m_ButFleetOn.visible = (HS.m_FollowType == Hyperspace.FollowFleet);
			m_ButFleet.visible = true;// !m_ButFleetOn.visible;
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

//		m_ButHomeworldOn.x = m_ButHomeworld.x;
//		m_ButHomeworldOn.y = m_ButHomeworld.y;
//		m_ButCitadelOn.x = m_ButCitadel.x;
//		m_ButCitadelOn.y = m_ButCitadel.y;
//		m_ButFleetOn.x = m_ButFleet.x;
//		m_ButFleetOn.y = m_ButFleet.y;
//		m_ButFleetOn.x = m_ButFleet.x;
//		m_ButFleetOn.y = m_ButFleet.y;

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
		if(m_OpenFull) {
			m_ScaleFullKof += m_ScaleDir * ScaleFullSpeed();
			if(m_ScaleFullKof<ScaleFullMin) m_ScaleFullKof=ScaleFullMin;
			else if(m_ScaleFullKof>ScaleFullMax) m_ScaleFullKof=ScaleFullMax;

			m_ScaleFull=m_SizeX*m_ScaleFullKof;

			//if(m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();
		} else {
			m_ScaleKof += m_ScaleDir * ScaleSpeed();
			if(m_ScaleKof<ScaleMin) m_ScaleKof=ScaleMin;
			else if(m_ScaleKof>ScaleMax) m_ScaleKof=ScaleMax;

			m_Scale=m_SizeX*m_ScaleKof;
		}
		Update();
	}

	private var m_MenuAddKey:Boolean = false;

	private var m_CitadelList:Vector.<uint> = new Vector.<uint>(Common.CitadelMax);

	public function clickCitadel():void
	{
		var i:int, u:int;
		var id:uint;
		var cnt:int = 0;

		for (i = 0; i < Common.CitadelMax; i++) {
			if (EmpireMap.Self.m_CitadelNum[i] < 0) continue;
			id = EmpireMap.Self.m_CitadelCotlId[i];
			
			for (u = 0; u < cnt; u++) {
				if (m_CitadelList[u] == id) break;
			}
			if (u < cnt) continue;
			m_CitadelList[cnt] = id;
			cnt++;
		}

		if (cnt <= 0) return;

		i = -1;
		if (HS.m_FollowType == Hyperspace.FollowCitadel) {
			for (i = 0; i < cnt; i++) {
				if (m_CitadelList[i] == HS.m_FollowId) break;
			}
			i++;
		}
		if (i<0 || i>=cnt) i=0;

		HS.SetCenterType(Hyperspace.FollowCitadel, m_CitadelList[i]);
		HS.SetFollowType(Hyperspace.FollowCitadel, m_CitadelList[i]);
	}

	public function onDeactivate(e:Event):void
	{
		m_Float = false;
		m_CamMove = false;
		MouseUnlock();
	}

	public function onMouseDown(e:MouseEvent):void
	{
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

		e.stopImmediatePropagation();
		EM.FloatTop(this);

		if (m_ButOptions.hitTestPoint(stage.mouseX, stage.mouseY)) {
			m_MenuAddKey = addkey;
			SetOpen();
//			if(EM.m_FormMenu.visible) EM.m_FormMenu.Clear();
//			else SetOpen();
			return;
		}
//		EM.m_FormMenu.Clear();
			
		if(m_ButOpen.hitTestPoint(stage.mouseX,stage.mouseY)) {
			MapLarge();

		} else if (m_ButHomeworld.hitTestPoint(stage.mouseX, stage.mouseY)) {
			HS.SetCenterType(Hyperspace.FollowHomeworld);
			HS.SetFollowType(Hyperspace.FollowHomeworld);

		} else if (m_ButCitadel.hitTestPoint(stage.mouseX, stage.mouseY)) {
			clickCitadel();

		} else if (m_ButFleet.visible && m_ButFleet.hitTestPoint(stage.mouseX, stage.mouseY)) {
			HS.SetCenterType(Hyperspace.FollowFleet);
			HS.SetFollowType(Hyperspace.FollowFleet);

//		} else if(m_ButCombat.visible && m_ButCombat.hitTestPoint(stage.mouseX,stage.mouseY)) {
//			HS.SetFollowType(Hyperspace.FollowFleet);
//			if(EM.m_FormCombat.visible) EM.m_FormCombat.Hide();
//			else EM.m_FormCombat.ShowEx(EM.m_UserCombatId);

		} else if(m_ButMinus.hitTestPoint(stage.mouseX,stage.mouseY)) {
			if(m_OpenFull) {
				m_ScaleFullKof+=ScaleFullSpeed();
				if(m_ScaleFullKof<ScaleFullMin) m_ScaleFullKof=ScaleFullMin;
				else if(m_ScaleFullKof>ScaleFullMax) m_ScaleFullKof=ScaleFullMax;

				m_ScaleFull=m_SizeX*m_ScaleFullKof;
				m_ScaleDir=+1;
				
				//if(m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();
			} else {
				m_ScaleKof += ScaleSpeed();
				if(m_ScaleKof<ScaleMin) m_ScaleKof=ScaleMin;
				else if(m_ScaleKof>ScaleMax) m_ScaleKof=ScaleMax;

				m_Scale=m_SizeX*m_ScaleKof;
				m_ScaleDir=+1;
			}
			Update();
			m_TimeScale.start();

		} else if(m_ButPlus.hitTestPoint(stage.mouseX,stage.mouseY)) {
			if(m_OpenFull) {
				m_ScaleFullKof-=ScaleFullSpeed();
				if(m_ScaleFullKof<ScaleFullMin) m_ScaleFullKof=ScaleFullMin;
				else if(m_ScaleFullKof>ScaleFullMax) m_ScaleFullKof=ScaleFullMax;

				m_ScaleFull=m_SizeX*m_ScaleFullKof;
				m_ScaleDir=-1;
				
				//if(m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();
			} else {
				m_ScaleKof -= ScaleSpeed();
				if(m_ScaleKof<ScaleMin) m_ScaleKof=ScaleMin;
				else if(m_ScaleKof>ScaleMax) m_ScaleKof=ScaleMax;

				m_Scale=m_SizeX*m_ScaleKof;
				m_ScaleDir=-1;
			}
			Update();
			m_TimeScale.start();

		} else if (m_CaptionBG.hitTestPoint(stage.mouseX, stage.mouseY)) {
			
		} else if (!m_OpenFull) {
			EM.InfoHide();
			RadarToWorld(mouseX, mouseY, m_TVec);
			HS.SetFollowNone(m_TVec.x, m_TVec.y)
			m_CamMove = true;
			MouseLock();

		} else {
			m_Float=true;
			m_FloatBegin=false;
			m_MousePosOldX=mouseX;
			m_MousePosOldY=mouseY;
		}
	}

	public function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		m_TimeScale.stop();
		
		if(m_Float && !m_FloatBegin) {
			if (HS.m_FollowType == Hyperspace.FollowFleet) {
				RadarToWorld(mouseX, mouseY, m_TVec);
				HS.OrderMoveEx(SpaceEntity.TypeFleet, EM.m_RootFleetId, m_TVec.x, m_TVec.y);
				HS.m_MoveToX = m_TVec.x;
				HS.m_MoveToY = m_TVec.y;

				//HS.FleetMoveTo(false);	
			}
		}
		if(m_Float) {
			m_Float=false;
		}
		if (m_CamMove) {
			m_CamMove = false;
		}
		MouseUnlock();
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		if (m_CamMove) {
			EM.InfoHide();
			RadarToWorld(mouseX, mouseY, m_TVec);
			HS.SetFollowNone(m_TVec.x, m_TVec.y)

		} else if (m_Float) {
			MouseLock();
			m_FloatBegin=true;
			if(m_OpenFull) {
				//SetCenter(m_OffsetFullX - MapToWorldR(mouseX - m_MousePosOldX), m_OffsetFullY + MapToWorldR(mouseY - m_MousePosOldY));
				SetCenter(m_OffsetFullX - RadarToWorldR(mouseX - m_MousePosOldX), m_OffsetFullY + RadarToWorldR(mouseY - m_MousePosOldY));

				m_MousePosOldX=mouseX;
				m_MousePosOldY=mouseY;

				//if(m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();

				Update();
			}
		} else {
			m_TimerShowZone.stop();
			
			var splanet:SpacePlanet;

			var oldid:uint = m_PickCotlId;
			var oldplanetid:uint = m_PickPlanetId;
			var oldzonelvl:int = m_PickCotlZoneLvl;
			PickCotl();
			if (m_PickCotlId != oldid || m_PickPlanetId != oldplanetid/* || m_PickCotlZoneLvl!=oldzonelvl*/) {
				if (m_PickCotlId != 0) {
					if (!m_OpenFull) {
						 var ent:SpaceEntity = SP.EntityFind(SpaceEntity.TypeCotl, m_PickCotlId);
						 var ent2:SpaceEntity = SP.EntityFind(SpaceEntity.TypePlanet, m_PickPlanetId);
						 if (ent2 != null) splanet = ent2 as SpacePlanet;
						 if (ent != null) EM.m_Info.ShowCotlLive(splanet, ent as SpaceCotl, x + mouseX, y + mouseY, 5); // EM.m_FormGalaxy.GetCotl(m_PickCotlId)
					} else {
						EM.m_Info.ShowCotlLive(null, m_PickCotl, x + mouseX, y + mouseY, 5, m_PickCotlZoneLvl);
//						EM.m_Info.ShowCotlRadar(x + mouseX, y + mouseY, m_PickCotlId, m_PickCotlType, m_PickCotlAccountId, m_PickCotlUnionId, m_PickCotlZoneLvl,
//							m_PickCotlBonusType0, m_PickCotlBonusVal0, m_PickCotlBonusType1, m_PickCotlBonusVal1, m_PickCotlBonusType2, m_PickCotlBonusVal2, m_PickCotlBonusType3, m_PickCotlBonusVal3,
//							m_PickCotl_PriceEnterType, m_PickCotl_PriceEnter, m_PickCotl_PriceCaptureType, m_PickCotl_PriceCapture, m_PickCotl_PriceCaptureEgm,
//							m_PickCotl_ProtectTime
//							);
					}
				} else {
					EM.m_Info.Hide();
					m_TimerShowZone.start();
				}
				Update();
			} else if(m_PickCotlId==0) {
				EM.m_Info.Hide();
				m_TimerShowZone.start();
			}
		}
	}
	
	public function TimerShowZone(event:TimerEvent=null):void
	{
		if (!IsMouseIn()) return;
		if (!visible) return;
		if (!m_OpenFull) return;
		if (m_CaptionBG.hitTestPoint(stage.mouseX, stage.mouseY)) return;
		if (m_FooterBG.hitTestPoint(stage.mouseX, stage.mouseY)) return;
		if (m_ButOpen.hitTestPoint(stage.mouseX, stage.mouseY)) return;

		EM.m_Info.ShowHyperspaceZone(x+mouseX,y+mouseY,m_PickCotlZoneLvl);
	}

	public function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var delta:Number = e.delta;

		RadarToWorld(mouseX, mouseY, m_TVec);
		var tx:Number = m_TVec.x;
		var ty:Number = m_TVec.y;

		if(m_OpenFull) {
			m_ScaleFullKof -= Math.round(delta / 3) * 1 * ScaleFullSpeed();
			if (m_ScaleFullKof < ScaleFullMin) m_ScaleFullKof = ScaleFullMin;
			else if (m_ScaleFullKof > ScaleFullMax) m_ScaleFullKof = ScaleFullMax;

			m_ScaleFull = m_SizeX * m_ScaleFullKof;

			//m_OffsetFullX = tx - MapToWorldR(mouseX - m_SizeX / 2);
			//m_OffsetFullY = ty + MapToWorldR(mouseY - m_SizeY / 2);
			m_OffsetFullX = tx - RadarToWorldR(mouseX - m_SizeX / 2);
			m_OffsetFullY = ty + RadarToWorldR(mouseY - m_SizeY / 2);

			//if(m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();

		} else {
			m_ScaleKof -= Math.round(delta / 3) * ScaleSpeed();
			if(m_ScaleKof<ScaleMin) m_ScaleKof=ScaleMin;
			else if(m_ScaleKof>ScaleMax) m_ScaleKof=ScaleMax;

			m_Scale=m_SizeX*m_ScaleKof;
		}

		if(visible) Update();
	}

	public function SetCenter(x:Number, y:Number):void
	{
		if(m_OpenFull) {
			m_OffsetFullX=x;
			m_OffsetFullY=y;
		} else {
			m_OffsetX=x;
			m_OffsetY=y;
		}
	}

	private var m_PickPlanetId:uint = 0;
	private var m_PickCotlId:uint = 0;
	private var m_PickCotl:SpaceCotl = new SpaceCotl(null, null);
	private var m_PickCotlZoneLvl:int = 0;

	public function ReadCotl(cotl:SpaceCotl, sl:SaveLoad):void
	{
		cotl.m_CotlSize=sl.LoadInt();
		cotl.m_Id=sl.LoadDword();
		cotl.m_AccountId=sl.LoadDword();
		cotl.m_UnionId = sl.LoadDword();
		var tx:Number = sl.LoadInt();
		var ty:Number = sl.LoadInt();
		cotl.m_ZoneX = Math.floor(tx / SP.m_ZoneSize);
		cotl.m_ZoneY = Math.floor(ty / SP.m_ZoneSize);
		cotl.m_PosX = tx - cotl.m_ZoneX * SP.m_ZoneSize;
		cotl.m_PosY = ty - cotl.m_ZoneY * SP.m_ZoneSize;
		cotl.m_PosZ = 0.0;
		cotl.m_ProtectTime = 1000 * sl.LoadDword();
		if (cotl.m_CotlType == Common.CotlTypeProtect || cotl.m_CotlType == Common.CotlTypeRich) {
			cotl.m_RestartTime = sl.LoadDword();
			cotl.m_TimeData = sl.LoadDword();
		}
		if (cotl.m_CotlType == Common.CotlTypeRich || cotl.m_CotlType == Common.CotlTypeProtect) cotl.m_RewardExp = sl.LoadInt();
		if(cotl.m_CotlType!=Common.CotlTypeUser) {
			var btype:uint = sl.LoadDword();
			cotl.m_BonusType0 = ((btype) & 0xff);
			cotl.m_BonusType1 = ((btype >> 8) & 0xff);
			cotl.m_BonusType2 = ((btype >> 16) & 0xff);
			cotl.m_BonusType3 = ((btype >> 24) & 0xff);
			if (cotl.m_BonusType0 != 0) cotl.m_BonusVal0 = sl.LoadInt();
			if (cotl.m_BonusType1 != 0) cotl.m_BonusVal1 = sl.LoadInt();
			if (cotl.m_BonusType2 != 0) cotl.m_BonusVal2 = sl.LoadInt();
			if (cotl.m_BonusType3 != 0) cotl.m_BonusVal3 = sl.LoadInt();

			cotl.m_PriceEnterType = sl.LoadInt();
			if (cotl.m_PriceEnterType != 0) cotl.m_PriceEnter = sl.LoadInt(); else cotl.m_PriceEnter = 0;
			cotl.m_PriceCaptureType = sl.LoadInt();
			if (cotl.m_PriceCaptureType != 0) cotl.m_PriceCapture = sl.LoadInt(); else cotl.m_PriceCapture = 0;
			cotl.m_PriceCaptureEgm = sl.LoadInt();
			
		} else {
			cotl.m_BonusType0 = 0; cotl.m_BonusType1 = 0; cotl.m_BonusType2 = 0; cotl.m_BonusType3 = 0;
			cotl.m_BonusVal0 = 0; cotl.m_BonusVal1 = 0; cotl.m_BonusVal2 = 0; cotl.m_BonusVal3 = 0;
			cotl.m_PriceEnterType = 0; cotl.m_PriceEnter = 0;
			cotl.m_PriceCaptureType = 0; cotl.m_PriceCapture = 0; cotl.m_PriceCaptureEgm = 0;
		}
		if (cotl.m_CotlType == Common.CotlTypeUser) {
			cotl.m_ExitTime=sl.LoadDword();
		} else {
			cotl.m_ExitTime = 0;
		}
		cotl.m_CotlFlag = sl.LoadDword();
		if (cotl.m_CotlFlag & SpaceCotl.fPlanetShield) {
			cotl.m_PlanetShieldHour = sl.LoadInt();
			cotl.m_PlanetShieldEnd = sl.LoadDword();
			cotl.m_PlanetShieldCooldown = sl.LoadDword();
		} else {
			cotl.m_PlanetShieldHour = 0;
			cotl.m_PlanetShieldEnd = 0;
			cotl.m_PlanetShieldCooldown = 0;
		}
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
		cotl.m_Dev0 = sl.LoadDword();
		cotl.m_Dev1 = sl.LoadDword();
		cotl.m_Dev2 = sl.LoadDword();
		cotl.m_Dev3 = sl.LoadDword();
		cotl.m_DevAccess = sl.LoadDword();
		cotl.m_DevFlag = sl.LoadDword();
		cotl.m_DevTime = 1000 * sl.LoadDword();
	}

	public function PickCotl():void
	{
		
		var dsx:int, dsy:int, dex:int, dey:int, tx:int, ty:int;
		var bval0:int, bval1:int, bval2:int, bval3:int;
		var i:int, k:int, u:int;
		var dx:Number, dy:Number;
		var off:uint;
		var mx:Number = RadarToWorld(mouseX, mouseY, m_TVec);
		var my:Number = m_TVec.y;
		var r:Number,rr:Number;
		var mr:Number;
		var hc:HyperspaceCotl;
		var hp:HyperspacePlanet;
		var sl:SaveLoad = new SaveLoad();
		var cotl:SpaceCotl = new SpaceCotl(HS.SP, HS);
		var cotl_priceentertype:int,cotl_priceenter:int,cotl_pricecapturetype:int,cotl_pricecapture:int,cotl_pricecaptureegm:int;

		m_PickPlanetId = 0;
		m_PickCotlId = 0;
		m_PickCotl.Clear();
//		m_PickCotlType=0;
//		m_PickCotlAccountId=0;
//		m_PickCotlUnionId=0;
		m_PickCotlZoneLvl=0;
		var pzx:int = Math.floor(mx / SP.m_ZoneSize);
		var pzy:int = Math.floor(my / SP.m_ZoneSize);

		if (!IsMouseIn()) return;

		//var maxr:Number=MapToWorldR(5);
		var maxr:Number = RadarToWorldR(5);
		maxr*=maxr;

		if (m_OpenFull) {
			if(m_GalaxyMapData.length>20) {
				m_GalaxyMapData.position=16;
				m_GalaxyMapData.position=m_GalaxyMapData.readUnsignedInt();
				sl.LoadBegin(m_GalaxyMapData);

				while(true) {
					var cotl_type:uint=sl.LoadDword();
					if (cotl_type == 0) break; 
					cotl.m_CotlType = cotl_type;
					ReadCotl(cotl, sl);

					dx = mx - (cotl.m_ZoneX * SP.m_ZoneSize + cotl.m_PosX);
					dy = my - (cotl.m_ZoneY * SP.m_ZoneSize + cotl.m_PosY);
					r = dx * dx + dy * dy;

					//r=(mx-cotl.m_X)*(mx-cotl.m_X)+(my-cotl.m_Y)*(my-cotl.m_Y);
					if(r>maxr) continue;
					if(m_PickCotlId==0 || r<mr) {
						mr=r;
						m_PickCotlId=cotl.m_Id;
//						m_PickCotlType=cotl_type;
//						m_PickCotlAccountId=cotl_accountid;
//						m_PickCotlUnionId=cotl_unionid;
						//pcx=cotl.m_X;
						//pcy=cotl.m_Y;
						pzx = cotl.m_ZoneX;
						pzy = cotl.m_ZoneY;

						m_PickCotl.CopyFrom(cotl);

						var cotlin:SpaceCotl = HS.GetCotl(cotl.m_Id, false);
						if (cotlin.m_CotlType != cotl.m_CotlType) {
							cotlin.m_CotlType = cotl.m_CotlType;
							cotlin.m_AccountId = cotl.m_AccountId;
							cotlin.m_UnionId = cotl.m_UnionId;
						}

/*						m_PickCotlBonusType0 = (btype) & 0xff;
						m_PickCotlBonusType1 = (btype >> 8) & 0xff;
						m_PickCotlBonusType2 = (btype >> 16) & 0xff;
						m_PickCotlBonusType3 = (btype >> 24) & 0xff;
						m_PickCotlBonusVal0 = bval0;
						m_PickCotlBonusVal1 = bval1;
						m_PickCotlBonusVal2 = bval2;
						m_PickCotlBonusVal3 = bval3;
						m_PickCotl_PriceEnterType = cotl_priceentertype;
						m_PickCotl_PriceEnter = cotl_priceenter;
						m_PickCotl_PriceCaptureType = cotl_pricecapturetype;
						m_PickCotl_PriceCapture = cotl_pricecapture;
						m_PickCotl_PriceCaptureEgm = cotl_pricecaptureegm;
						m_PickCotl_ProtectTime = protect_time;*/
					}
				}
				sl.LoadEnd();
			}

			while(/*m_PickCotlId!=0 && */m_GalaxyMapData.length>24) {
				//var pzx:int=Math.floor(pcx/HS.m_ZoneSize);
				//var pzy:int=Math.floor(pcy/HS.m_ZoneSize);
//trace("Zone:",pzx,pzy);

				m_GalaxyMapData.position=0;
				dsx=m_GalaxyMapData.readInt();
				dsy=m_GalaxyMapData.readInt();
				dex=dsx+m_GalaxyMapData.readInt();
				dey=dsy+m_GalaxyMapData.readInt();

				m_GalaxyMapData.position=20;
				off=m_GalaxyMapData.readUnsignedInt();
				if(off==0) break;
				m_GalaxyMapData.position=off;

				var findok:Boolean=false;

				for(ty=dsy;ty<dey;ty++) {
					for(tx=dsx;tx<dex;tx+=4) {
						k=m_GalaxyMapData.readUnsignedByte();
						for(i=0;i<4;i++,k>>=2) {
							if(tx+i!=pzx) continue;
							if(ty!=pzy) continue;

							m_PickCotlZoneLvl=k & 3;
//trace("Find:",m_PickCotlZoneLvl);
							findok=true;
							break;
						}
						if(findok) break;
					}
					if(findok) break;
				}
				
				break;
			}
			
		} else {
			var hs:Hyperspace=EM.HS;
			for (i = 0; i < hs.m_PlanetList.length; i++) {
				hp = hs.m_PlanetList[i];
				if ((hp.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;
				
				dx = mouseX - WorldToRadar(hp.m_ZoneX * SP.m_ZoneSize + hp.m_PosX, hp.m_ZoneY * SP.m_ZoneSize + hp.m_PosY, m_TVec);
				dy = mouseY - m_TVec.y;

//				dx = mx - (hp.m_ZoneX * SP.m_ZoneSize + hp.m_PosX);
//				dy = my - (hp.m_ZoneY * SP.m_ZoneSize + hp.m_PosY);

				r = dx * dx + dy * dy;
				//rr = Math.max(5, WorldToMapR(hp.m_Radius));
				rr = Math.max(5, WorldToRadarR(hp.m_Radius));
//trace(r);
				//if (r > (hp.m_Radius * hp.m_Radius)) continue;
				if (r > (rr * rr)) continue;
				if (m_PickPlanetId == 0 || r < mr) {
					mr = r;
					m_PickPlanetId = hp.m_Id;
					m_PickCotlId = hp.m_CotlId;
//					m_PickCotlType=hc.m_Type;
//					m_PickCotlAccountId=hc.m_AccountId;
//					m_PickCotlUnionId=hc.m_UnionId;
				}
			}
		}
	}

	public function DrawOrbit(gr:Graphics, posx:Number, posy:Number, radius:Number):void
	{
		var sa:Number = (10.0 / (2.0 * Math.PI * radius)) * 2.0 * Math.PI;
		
		var a:Number, x:Number, y:Number;
		for (a = 0.0; a < (2.0 * Math.PI - sa * 0.5); a += sa) {
			x = posx + radius * Math.sin(a);
			y = posy + radius * Math.cos(a);
			
			gr.moveTo(x, y);
			
			x = posx + radius * Math.sin(a + sa * 0.7);
			y = posy + radius * Math.cos(a + sa * 0.7);
			gr.lineTo(x, y);
		}
	}

	private var sp_fleet:Sprite=new MMFleet();
	private var sp_large:Sprite=new MMLarge();
	private var update_dt:TextField = null;

	public function UpdateTimer(e:TimerEvent):void
	{
		m_UpdateTimer.stop();
		Update();
	}

	public function Update():void
	{
		if(!visible) return;

		var i:int,u:int,k:int,off:int,tx:int,ty:int,dsx:int,dsy:int,dex:int,dey:int;
		var clr:uint=0;
		var px:Number,py:Number,px2:Number,py2:Number,alpha:Number,r:Number;
		var hc:HyperspaceCotl;
		var hf:HyperspaceFleet;
		var hp:HyperspacePlanet, hp2:HyperspacePlanet, hp3:HyperspacePlanet;
		var hcont:HyperspaceContainer;
		var re:Rectangle=new Rectangle();
		var pt:Point=new Point();
		var tbm:BitmapData;
		var user:User;
		var uni:Union;
		var str:String;
		var mat:Matrix;
		var zone:Zone;
		var sl:SaveLoad = new SaveLoad();
		var cotl:SpaceCotl = new SpaceCotl(SP,HS);
//		var cotl_priceentertype:int,cotl_priceenter:int,cotl_pricecapturetype:int,cotl_pricecapture:int,cotl_pricecaptureegm:int;

		if(m_OpenFull) m_SubText.htmlText=Common.Txt.FormRadarGalaxyMap;
		else m_SubText.htmlText=Common.Txt.FormRadarRadar;
		m_SubText.x=3;
		m_SubText.y=m_SizeY-m_SubText.height;

		graphics.clear();
		m_LayerVec.graphics.clear();

		if (m_SizeX <= 5 || m_SizeY <= 5) return;
		
		UpdateBut();

		if(m_OpenFull) graphics.beginFill(0x000000,0.95);
		else graphics.beginFill(0x000000,0.8);
		graphics.lineStyle(1.0,0x000000,0.0,true);
		graphics.drawRect(-5,-5,m_SizeX+10,m_SizeY+10);
		graphics.endFill();

		var i_cotl:BitmapData = EM.m_FormMiniMap.CreateSptiteBM(7, WorldToRadarR(97), 0.8, 0x57a3d7, sp_large);
		var i_cotl_sel:BitmapData = EM.m_FormMiniMap.CreateSptiteBM(7, WorldToRadarR(97), 0.8, 0xffffff, sp_large);
		var i_cotl_bonus:BitmapData = EM.m_FormMiniMap.CreateSptiteBM(7, WorldToRadarR(250), 0.8, 0x9cff00, sp_large);
		var i_cotl_crit:BitmapData = EM.m_FormMiniMap.CreateSptiteBM(7, WorldToRadarR(250), 0.8, 0xff0000, sp_large);
		var i_fleet_bg:BitmapData = EM.m_FormMiniMap.CreateSptiteBM(7, WorldToRadarR(100), 0.8, 0x000000, sp_fleet);
		var i_fleet:BitmapData = EM.m_FormMiniMap.CreateSptiteBM(7, WorldToRadarR(70), 0.8, 0xffff00, sp_fleet);

		var hs:Hyperspace=EM.HS;

		var zonesize:int=HS.m_ZoneSize;
		
		m_Mask.graphics.clear();
		m_Mask.graphics.beginFill(0xFF0000);
		m_Mask.graphics.drawRect(0, 0, m_SizeX, m_SizeY);
		m_Mask.graphics.endFill();
		
		while(m_LayerBattle.numChildren>0) m_LayerBattle.removeChildAt(m_LayerBattle.numChildren-1);

		if(!m_OpenFull) {
			RadarToWorld(0, 0, m_TVec);
			var p1x:Number = m_TVec.x;
			var p1y:Number = m_TVec.y;
			RadarToWorld(m_SizeX, 0, m_TVec);
			var p2x:Number = m_TVec.x;
			var p2y:Number = m_TVec.y;
			RadarToWorld(m_SizeX, m_SizeY, m_TVec);
			var p3x:Number = m_TVec.x;
			var p3y:Number = m_TVec.y;
			RadarToWorld(0, m_SizeY, m_TVec);
			var p4x:Number = m_TVec.x;
			var p4y:Number = m_TVec.y;

			var v1x:Number = Math.min(p1x, p2x, p3x, p4x);
			var v1y:Number = Math.min(p1y, p2y, p3y, p4y);
			var v2x:Number = Math.max(p1x, p2x, p3x, p4x);
			var v2y:Number = Math.max(p1y, p2y, p3y, p4y);

			if (v1x < SP.m_ZoneMinX * SP.m_ZoneSize) v1x = SP.m_ZoneMinX * SP.m_ZoneSize;
			else if (v1x > (SP.m_ZoneMinX + SP.m_ZoneCntX) * SP.m_ZoneSize) v1x = (SP.m_ZoneMinX + SP.m_ZoneCntX) * SP.m_ZoneSize;
			if (v1y < SP.m_ZoneMinY * SP.m_ZoneSize) v1y = SP.m_ZoneMinY * SP.m_ZoneSize;
			else if (v1y > (SP.m_ZoneMinY + SP.m_ZoneCntY) * SP.m_ZoneSize) v1y = (SP.m_ZoneMinY + SP.m_ZoneCntY) * SP.m_ZoneSize;

			if (v2x < SP.m_ZoneMinX * SP.m_ZoneSize) v2x = SP.m_ZoneMinX * SP.m_ZoneSize;
			else if (v2x > (SP.m_ZoneMinX + SP.m_ZoneCntX) * SP.m_ZoneSize) v2x = (SP.m_ZoneMinX + SP.m_ZoneCntX) * SP.m_ZoneSize;
			if (v2y < SP.m_ZoneMinY * SP.m_ZoneSize) v2y = SP.m_ZoneMinY * SP.m_ZoneSize;
			else if (v2y > (SP.m_ZoneMinY + SP.m_ZoneCntY) * SP.m_ZoneSize) v2y = (SP.m_ZoneMinY + SP.m_ZoneCntY) * SP.m_ZoneSize;

			// Cell
			var xb:Number;
			ty = Math.floor(v1y / zonesize);
			var yb:Number = ty * zonesize;
/*			for (; yb < v2y; ty++, yb += zonesize) {
				tx = Math.floor(v1x / zonesize);
				xb = tx * zonesize;
				for (; xb < v2x; tx++, xb += zonesize) {
					zone=HS.GetZone(tx,ty);
					if(zone==null) continue;

					u=zone.m_Lvl & 3;
					if(u==0) continue;
					else if(u==1) alpha=0.05;
					else if(u==2) alpha=0.10;
					else alpha=0.15;

					px=Math.floor(WorldToMapX(xb));
					py=Math.floor(WorldToMapY(yb));
					px2=Math.floor(WorldToMapX(xb+zonesize));
					py2=Math.floor(WorldToMapY(yb+zonesize));

					//if(px<0) px=0;
					//if(py<0) py=0;
					//if(px2>m_SizeX) px2=m_SizeX;
					//if(py2>m_SizeY) py2=m_SizeY;
					//if(px2<=px) continue;
					//if(py2<=py) continue;

					m_LayerVec.graphics.beginFill(0x00ff00,alpha);
					m_LayerVec.graphics.lineStyle(0.0,0x000000,0.0,true);
					m_LayerVec.graphics.drawRect(Math.min(px, px2), Math.min(py, py2), Math.abs(px2 - px), Math.abs(py2 - py));
					m_LayerVec.graphics.endFill();
				}
			}*/

			// grid
			m_LayerVec.graphics.lineStyle(1.5, 0x003040, 0.4, false);

			xb = Math.floor(v1x / zonesize) * zonesize;
			for (i = 0; xb <= v2x; i++, xb += zonesize) {
				WorldToRadar(xb, v1y, m_TVec);
				p1x = m_TVec.x;
				p1y = m_TVec.y;
				WorldToRadar(xb, v2y, m_TVec);
				p2x = m_TVec.x;
				p2y = m_TVec.y;

				m_LayerVec.graphics.moveTo(p1x, p1y);
				m_LayerVec.graphics.lineTo(p2x, p2y);
			}
			
			yb = Math.floor(v1y / zonesize) * zonesize;
			for (i = 0; yb <= v2y; i++, yb += zonesize) {
				WorldToRadar(v1x, yb, m_TVec);
				p1x = m_TVec.x;
				p1y = m_TVec.y;
				WorldToRadar(v2x, yb, m_TVec);
				p2x = m_TVec.x;
				p2y = m_TVec.y;

				m_LayerVec.graphics.moveTo(p1x, p1y);
				m_LayerVec.graphics.lineTo(p2x, p2y);
			}

			// Orbit
			m_LayerVec.graphics.lineStyle(1.5, 0x006090, 0.5, false);

			for (u = 0; u < hs.m_PlanetList.length; u++) {
				hp = hs.m_PlanetList[u];
				if (hp.m_CenterId == 0) continue;
				if ((hp.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;
				if ((hp.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeSun) continue;

				hp2 = hs.HyperspacePlanetById(hp.m_CenterId);
				if (hp2 == null) continue;

				for (i = 0; i < u; i++) {
					hp3 = hs.m_PlanetList[i];
					if (hp3.m_CenterId == hp.m_CenterId && Math.abs(hp3.m_OrbitRadius - hp.m_OrbitRadius) < 100) break;
				}
				if (i < u) continue;

				px = WorldToRadar(hp2.m_ZoneX * SP.m_ZoneSize + hp2.m_PosX, hp2.m_ZoneY * SP.m_ZoneSize + hp2.m_PosY, m_TVec);
				py = m_TVec.y;
				r = WorldToRadarR(hp.m_OrbitRadius);
				
				DrawOrbit(m_LayerVec.graphics, px, py, r);

//				m_LayerVec.graphics.drawCircle(px, py, r);
			}
			
			for (u = 0; u < hs.m_PlanetList.length; u++) {
				hp = hs.m_PlanetList[u];
				if ((hp.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;

				px = WorldToRadar(hp.m_ZoneX * SP.m_ZoneSize + hp.m_PosX, hp.m_ZoneY * SP.m_ZoneSize + hp.m_PosY, m_TVec);
				py = m_TVec.y;

				r = Math.max(3, WorldToRadarR(hp.m_Radius));
				if (px < -r || py < -r || px >= m_SizeX + r || py >= m_SizeY + r) continue;

				if (hp.m_Id == m_PickPlanetId) m_LayerVec.graphics.beginFill(0xffffff, 1.0);
				//else if(hp.m_Type==Common.CotlTypeCombat) m_LayerVec.graphics.beginFill(0xff0000,1.0);
				else m_LayerVec.graphics.beginFill(0x57a3d7, 1.0);
				m_LayerVec.graphics.lineStyle(0.0, 0x000000, 0.0, true);
				m_LayerVec.graphics.drawCircle(px, py, r);
				m_LayerVec.graphics.endFill();
			}

			for(u=0;u<hs.m_FleetList.length;u++) {
				hf=hs.m_FleetList[u];

				if (hf.m_Id == EM.m_RootFleetId) continue;
				if ((hf.m_State & SpaceShip.StateLive) == 0) continue;

				px = WorldToRadar(hf.m_ZoneX * SP.m_ZoneSize + hf.m_PosX, hf.m_ZoneY * SP.m_ZoneSize + hf.m_PosY, m_TVec);
				py = m_TVec.y;

				if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) continue;

				m_LayerVec.graphics.beginFill(0xffff00,1.0);
				m_LayerVec.graphics.lineStyle(0.0,0x000000,0.0,true);
				m_LayerVec.graphics.drawRect(px-1,py-1,3,3);
				m_LayerVec.graphics.endFill();

/*				tbm=i_fleet;

				if(tbm!=null) {
					re.left=0; re.top=0;
					re.right=tbm.width; re.bottom=tbm.height;
					pt.x=px-(tbm.width>>1);
					pt.y=py-(tbm.height>>1);
					bm.copyPixels(tbm,re,pt,null,null,true);
				}*/
			}
			
			for (u = 0; u < hs.m_ContainerList.length; u++) {
				hcont = hs.m_ContainerList[u];

				if (!hcont.m_Vis) continue;

				px = WorldToRadar(hcont.m_ZoneX * SP.m_ZoneSize + hcont.m_PosX, hcont.m_ZoneY * SP.m_ZoneSize + hcont.m_PosY, m_TVec);
				py = m_TVec.y;

				if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) continue;

				m_LayerVec.graphics.beginFill(0x00ffff,1.0);
				m_LayerVec.graphics.lineStyle(0.0,0x000000,0.0,true);
				m_LayerVec.graphics.drawRect(px-1,py-1,2,2);
				m_LayerVec.graphics.endFill();
			}

			while(true) {
				if (!HS.PickWorldCoord(0, 0, HyperspaceBase.m_TPos)) break;
				p1x = WorldToRadar(HyperspaceBase.m_TPos.x, HyperspaceBase.m_TPos.y, m_TVec);
				p1y = m_TVec.y;
				if (!HS.PickWorldCoord(C3D.m_SizeX, 0, HyperspaceBase.m_TPos)) break;
				p2x = WorldToRadar(HyperspaceBase.m_TPos.x, HyperspaceBase.m_TPos.y, m_TVec);
				p2y = m_TVec.y;
				if (!HS.PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, HyperspaceBase.m_TPos)) break;
				p3x = WorldToRadar(HyperspaceBase.m_TPos.x, HyperspaceBase.m_TPos.y, m_TVec);
				p3y = m_TVec.y;
				if (!HS.PickWorldCoord(0, C3D.m_SizeY, HyperspaceBase.m_TPos)) break;
				p4x = WorldToRadar(HyperspaceBase.m_TPos.x, HyperspaceBase.m_TPos.y, m_TVec);
				p4y = m_TVec.y;

				m_LayerVec.graphics.lineStyle(1.1, 0xffffff, 0.5, false);
				m_LayerVec.graphics.moveTo(p1x, p1y);
				m_LayerVec.graphics.lineTo(p2x, p2y);
				m_LayerVec.graphics.lineTo(p3x, p3y);
				m_LayerVec.graphics.lineTo(p4x, p4y);
				m_LayerVec.graphics.lineTo(p1x, p1y);
				break;
			}

			m_BMC.bitmapData=null;

		} else {
			if(update_dt==null) {
				update_dt=new TextField();
				update_dt.width=1;
				update_dt.height=1;
				update_dt.type=TextFieldType.DYNAMIC;
				update_dt.selectable=false;
				update_dt.textColor=0xffffff;
				update_dt.background=false;
				update_dt.alpha=1.0;
				update_dt.multiline=false;
				update_dt.autoSize=TextFieldAutoSize.LEFT;
				update_dt.gridFitType=GridFitType.NONE;
				update_dt.defaultTextFormat=new TextFormat("Calibri",12,0xAfAfAf);
				update_dt.embedFonts=true;
			}
			
			mat=new Matrix();

			var bm:BitmapData = new BitmapData(m_SizeX, m_SizeY, true, 0x00000000);
			//var bm2:BitmapData = new BitmapData(m_SizeX, m_SizeY, true, 0x00000000);

			while(m_GalaxyMapData.length>24) {
				m_GalaxyMapData.position=0;
				dsx=m_GalaxyMapData.readInt();
				dsy=m_GalaxyMapData.readInt();
				dex=dsx+m_GalaxyMapData.readInt();
				dey=dsy+m_GalaxyMapData.readInt();

				m_GalaxyMapData.position=20;
				off=m_GalaxyMapData.readUnsignedInt();
				if(off==0) break;
				m_GalaxyMapData.position=off;

				for(ty=dsy;ty<dey;ty++) {
					for(tx=dsx;tx<dex;tx+=4) {
						k=m_GalaxyMapData.readUnsignedByte();
						for(i=0;i<4;i++,k>>=2) {
							u=k & 3;
							if(u==0) continue;
							else if(u==1) clr=0x0c00ff00;
							else if(u==2) clr=0x1900ff00;
							else clr=0x2600ff00;

							px = Math.floor(WorldToRadar((tx + i) * zonesize, (ty + 1) * zonesize, m_TVec));
							py = Math.floor(m_TVec.y);
							px2 = Math.floor(WorldToRadar((tx + i + 1) * zonesize, (ty + 0) * zonesize, m_TVec));
							py2 = Math.floor(m_TVec.y);

							if(px<0) px=0;
							if(py<0) py=0;
							if(px2>m_SizeX) px2=m_SizeX;
							if(py2>m_SizeY) py2=m_SizeY;
							if(px2<=px) continue;
							if(py2<=py) continue;

							re.left=px;
							re.top=py;
							re.right=px2;
							re.bottom=py2;

							bm.fillRect(re,clr);
						}
					}
				}
				
				break;
			}

			if(m_GalaxyMapData.length>20) {
				m_GalaxyMapData.position=16;
				off=m_GalaxyMapData.readUnsignedInt();
				m_GalaxyMapData.position=off;
				sl.LoadBegin(m_GalaxyMapData);
				while(true) {
					var cotl_type:uint=sl.LoadDword();
					if (cotl_type == 0) break; 
					cotl.m_CotlType = cotl_type;
					ReadCotl(cotl, sl);
					
/*					var cotl_size:int=sl.LoadInt();
					var cotl_id:uint=sl.LoadDword();
					var cotl_accountid:uint=sl.LoadDword();
					var cotl_unionid:uint=sl.LoadDword();
					var cotl_x:int=sl.LoadInt();
					var cotl_y:int = sl.LoadInt();
					var protect_time:Number = 1000*sl.LoadDword();
					
					if(cotl_type!=Common.CotlTypeUser) {
						var btype:uint = sl.LoadDword();
						if (((btype) & 0xff) != 0) sl.LoadInt();
						if (((btype>>8) & 0xff) != 0) sl.LoadInt();
						if (((btype>>16) & 0xff) != 0) sl.LoadInt();
						if (((btype >> 24) & 0xff) != 0) sl.LoadInt();
						
						cotl_priceentertype = sl.LoadInt();
						if (cotl_priceentertype != 0) cotl_priceenter = sl.LoadInt(); else cotl_priceenter = 0;
						cotl_pricecapturetype = sl.LoadInt();
						if (cotl_pricecapturetype != 0) cotl_pricecapture = sl.LoadInt(); else cotl_pricecapture = 0;
						cotl_pricecaptureegm = sl.LoadInt();
					}*/

					if (m_BonusFilter != 0 || m_PriceFilter!=0) {
						if ((cotl.m_CotlType != Common.CotlTypeUser) && (cotl.m_BonusType0==0 && cotl.m_BonusType1==0 && cotl.m_BonusType2==0 && cotl.m_BonusType3==0)) {
							tbm = i_cotl_crit;	
						} else if (
							(((1 << (cotl.m_BonusType0)) & m_BonusFilter) != 0)
							|| (((1 << (cotl.m_BonusType1)) & m_BonusFilter) != 0)
							|| (((1 << (cotl.m_BonusType2)) & m_BonusFilter) != 0)
							|| (((1 << (cotl.m_BonusType3)) & m_BonusFilter) != 0)
							|| (((1 << cotl.m_PriceCaptureType) & m_PriceFilter) != 0)
							)
						{
							tbm = i_cotl_bonus;	
						} else {
							tbm = i_cotl;
						}
					} else {
						if (!m_ShowClanIcon) {
							if(cotl.m_Id==m_PickCotlId) tbm=i_cotl_sel;
							else tbm = i_cotl;

						} else {
							user=null;
							if(cotl_type==Common.CotlTypeUser) user=UserList.Self.GetUser(cotl.m_AccountId);
							uni=null;
							if(cotl_type==Common.CotlTypeUser) {
								if(user!=null && user.m_UnionId) uni=UserList.Self.GetUnion(user.m_UnionId);
							} else if(cotl.m_UnionId) {
								uni=UserList.Self.GetUnion(cotl.m_UnionId);
							}

							if(uni!=null && uni.m_EmblemSmall!=null) tbm=uni.m_EmblemSmall;				
							else if(cotl.m_Id==m_PickCotlId) tbm=i_cotl_sel;
							else tbm = i_cotl;
						}
					}

					px = WorldToRadar(cotl.m_ZoneX * HS.m_ZoneSize + cotl.m_PosX, cotl.m_ZoneY * HS.m_ZoneSize + cotl.m_PosY, m_TVec);
					py = m_TVec.y;

					if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) continue;

					if(tbm!=null) {
						re.left=0; re.top=0;
						re.right=tbm.width; re.bottom=tbm.height;
						pt.x=px-(tbm.width>>1);
						pt.y=py-(tbm.height>>1);
						bm.copyPixels(tbm,re,pt,null,null,true);
					}

					str=EM.Txt_CotlName(cotl.m_Id);
					if(str=='' && cotl_type==Common.CotlTypeUser) {
						if(user!=null) str=EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
					}

					if (str.length > 0) {
						if (tbm == i_cotl_bonus) update_dt.htmlText = "<font color='#9cff00'>"+str+"</font>";
						else update_dt.text = str;
						mat.identity();
						px2=px;
						if(tbm) px2+=2+(tbm.width>>1);
						mat.translate(px2,py-(update_dt.height>>1));
						bm.draw(update_dt,mat);
					}
					
					if (m_ShowCurBattle && (cotl.m_AtkCnt > 0 || cotl.m_DefCnt > 0)) {
						var smb:MovieClip=new MapBattle();
						m_LayerBattle.addChild(smb);
						smb.gotoAndStop(m_BattleFrame % smb.totalFrames);
						smb.x = px-(smb.width>>1)+11;
						smb.y = py-(smb.height>>1)-11;
					}
				
				}
				sl.LoadEnd();
			}

/*			while(true) {			
				px=WorldToMapX(EM.m_FleetPosX);
				py=WorldToMapY(EM.m_FleetPosY);

				if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) break;

				tbm=i_fleet_bg;
				if(tbm!=null) {
					re.left=0; re.top=0;
					re.right=tbm.width; re.bottom=tbm.height;
					pt.x=px-(tbm.width>>1);
					pt.y=py-(tbm.height>>1);
					bm.copyPixels(tbm,re,pt,null,null,true);
				}
				tbm=i_fleet;
				if(tbm!=null) {
					re.left=0; re.top=0;
					re.right=tbm.width; re.bottom=tbm.height;
					pt.x=px-(tbm.width>>1);
					pt.y=py-(tbm.height>>1);
					bm.copyPixels(tbm,re,pt,null,null,true);
				}

				break;
			}*/

			if(m_BMC.bitmapData!=null) m_BMC.bitmapData.dispose();

			m_BMC.bitmapData=bm;
		}

		m_LayerFleet.graphics.clear();
		while(true) {
			hf=HS.HyperspaceFleetById(EM.m_RootFleetId);
			if (hf == null) break;
			px = WorldToRadar(hf.m_ZoneX * SP.m_ZoneSize + hf.m_PosX, hf.m_ZoneY * SP.m_ZoneSize + hf.m_PosY, m_TVec);
			py = m_TVec.y;

			while(true) {
				if(px<0 || py<0 || px>=m_SizeX || py>=m_SizeY) break;;

				m_LayerFleet.graphics.beginFill(0xffff00,1.0);
				m_LayerFleet.graphics.lineStyle(1.0,0x000000,1.0);
				m_LayerFleet.graphics.drawRect(px-2,py-2,4,4);
				m_LayerFleet.graphics.endFill();

				break;
			}

			//if ((hf.m_PFlag & (SpaceShip.PFlagInOrbitCotl | SpaceShip.PFlagInOrbitPlanet)) != 0) break;
			if (hf.m_Order != SpaceShip.soMove) break;

			//if (hf.m_TargetType != Common.FleetActionMove) break;
			
			px2 = WorldToRadar(hf.m_ZoneX * SP.m_ZoneSize + hf.m_PlaceX, hf.m_ZoneY * SP.m_ZoneSize + hf.m_PlaceY, m_TVec);
			py2 = m_TVec.y;

			m_LayerFleet.graphics.lineStyle(1,0xffffff,1.0);
			DrawLineClip(px,py,px2,py2,0,0,m_SizeX,m_SizeY);

			break;
		}
		
		if (m_LineSX != 0 || m_LineSY != 0 || m_LineEX != 0 || m_LineEY != 0) {
			px = WorldToRadar(m_LineSX, m_LineSY, m_TVec);
			py = m_TVec.y;
			px2 = WorldToRadar(m_LineEX, m_LineEY, m_TVec);
			py2 = m_TVec.y;

			m_LayerFleet.graphics.lineStyle(1,0xffffff,1.0);
			DrawLineClip(px,py,px2,py2,0,0,m_SizeX,m_SizeY);
		}

		i_cotl.dispose();
		i_cotl_sel.dispose();
		i_fleet_bg.dispose();
		i_fleet.dispose();
		
		EmpireMap.Self.m_FormBattleBar.Update();
	}
	
	public function BattleFrameChange(event:TimerEvent=null):void
	{
		var i:int;

		m_BattleFrame++;

		for (i = 0; i < m_LayerBattle.numChildren; i++) {
			var mc:MovieClip = m_LayerBattle.getChildAt(i) as MovieClip;
			mc.gotoAndStop(m_BattleFrame % mc.totalFrames);
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
		
		m_LayerFleet.graphics.moveTo(x1,y1);
		m_LayerFleet.graphics.lineTo(x2,y2);
	}

	public function WorldToRadar(tpx:Number, tpy:Number, out:Vector3D):Number
	{
		var centerx:Number = m_SizeX >> 1;
		var centery:Number = m_SizeY >> 1;
		var si:Number = m_SizeX >> 1;

		var x2:Number, y2:Number, scale:Number;

		if (m_OpenFull) {
			x2 = tpx - m_OffsetFullX;
			y2 = tpy - m_OffsetFullY;
			scale = m_ScaleFull;

		} else {
			var x:Number = tpx - m_OffsetX;
			var y:Number = tpy - m_OffsetY;
			
			var sina:Number = Math.sin( -m_Angle);
			var cosa:Number = Math.cos( -m_Angle);
			x2 = cosa * x + sina * y;
			y2 = -sina * x + cosa * y;

			scale = m_Scale;
		}

		out.x = (centerx) + Math.round(((x2) / scale) * si);
        out.y = (centery) - Math.round(((y2) / scale) * si);
		return out.x;
	}

	public function RadarToWorld(tpx:int, tpy:int, out:Vector3D):Number
	{
		var centerx:Number = m_SizeX >> 1;
		var centery:Number = m_SizeY >> 1;
		var si:Number = m_SizeX >> 1;

		var scale:Number;

		if (m_OpenFull) {
			scale = m_ScaleFull;
		} else {
			scale = m_Scale;
		}

		var x:Number = Number(tpx - centerx) / si * scale;
		var y:Number = -Number(tpy - centery) / si * scale;

		if (m_OpenFull) {
			out.x = x + m_OffsetFullX;
			out.y = y + m_OffsetFullY;
		} else {
			var sina:Number = Math.sin(m_Angle);
			var cosa:Number = Math.cos(m_Angle);
			out.x = cosa * x + sina * y + m_OffsetX;
			out.y = -sina * x + cosa * y + m_OffsetY;
		}
		return out.x;
	}

	public function WorldToRadarR(v:Number):Number
	{
		var si:Number = m_SizeX / 2;
		if (m_OpenFull) return (v / m_ScaleFull) * si;
		else return (v / m_Scale) * si;
	}

	public function RadarToWorldR(v:Number):Number
	{
		var si:Number = m_SizeX / 2;
		if (m_OpenFull) return v / si * m_ScaleFull;
		else return v / si * m_Scale;
	}

	public function SetOpen():void
	{
		var i:int, t:int;
		//EM.CloseForModal();
		EM.m_FormMenu.Clear();

		if (m_OpenFull) {
			EM.m_FormMenu.Add(Common.Txt.GalaxyMapClanIcon, ChangeClanIcon).Check = m_ShowClanIcon;
			EM.m_FormMenu.Add(Common.Txt.GalaxyMapCurBattle, ChangeCurBattle).Check = m_ShowCurBattle;

			EM.m_FormMenu.Add();
			
			for (i = 0; i < Common.CotlBonusTypeList.length; i++) {
				t = Common.CotlBonusTypeList[i];
				if (t == Common.CotlBonusAntimatter) continue;
				if (t == Common.CotlBonusMetal) continue;
				if (t == Common.CotlBonusElectronics) continue;
				if (t == Common.CotlBonusProtoplasm) continue;
				if (t == Common.CotlBonusNodes) continue;

				EM.m_FormMenu.Add(Common.CotlBonusName[t], ChangeBonusFilter, t).Check = (m_BonusFilter & (1<<t))!=0;
			}

			EM.m_FormMenu.Add();
			
			EM.m_FormMenu.Add(Common.OpsPriceTypeName[Common.OpsPriceTypeAntimatter], ChangePriceFilter, Common.OpsPriceTypeAntimatter).Check = (m_PriceFilter & (1 << Common.OpsPriceTypeAntimatter)) != 0;
			EM.m_FormMenu.Add(Common.OpsPriceTypeName[Common.OpsPriceTypeMetal], ChangePriceFilter, Common.OpsPriceTypeMetal).Check = (m_PriceFilter & (1 << Common.OpsPriceTypeMetal)) != 0;
			EM.m_FormMenu.Add(Common.OpsPriceTypeName[Common.OpsPriceTypeElectronics], ChangePriceFilter, Common.OpsPriceTypeElectronics).Check = (m_PriceFilter & (1 << Common.OpsPriceTypeElectronics)) != 0;
			EM.m_FormMenu.Add(Common.OpsPriceTypeName[Common.OpsPriceTypeProtoplasm], ChangePriceFilter, Common.OpsPriceTypeProtoplasm).Check = (m_PriceFilter & (1 << Common.OpsPriceTypeProtoplasm))!=0;
			
			EM.m_FormMenu.Add();
		}

		EM.m_FormMenu.Add(Common.Txt.MiniMapScaleDefault,MiniMapScaleDefault);

		var cx:int=m_ButOptions.x+x;
		var cy:int=m_ButOptions.y+y;

		EM.m_FormMenu.SetButOpen(m_ButOptions);
		EM.m_FormMenu.Show(cx,cy,cx+1,cy+m_ButOptions.height);
	}

	public function ChangeClanIcon(...args):void
	{
		m_ShowClanIcon = !m_ShowClanIcon;
		Update();
	}

	public function ChangeCurBattle(...args):void
	{
		m_ShowCurBattle = !m_ShowCurBattle;
		Update();
	}

	public function ChangeBonusFilter(obj:Object, type:int):void
	{
		if (m_MenuAddKey) {
			if ((m_BonusFilter & (1 << type)) != 0) m_BonusFilter &= ~(1 << type);
			else m_BonusFilter |= (1 << type);
		} else {
			if ((m_BonusFilter & (1 << type)) != 0) m_BonusFilter=0;
			else m_BonusFilter = (1 << type);
		}
		
		Update();
	}

	public function ChangePriceFilter(obj:Object, type:int):void
	{
		if (m_MenuAddKey) {
			if ((m_PriceFilter & (1 << type)) != 0) m_PriceFilter &= ~(1 << type);
			else m_PriceFilter |= (1 << type);
		} else {
			if ((m_PriceFilter & (1 << type)) != 0) m_PriceFilter=0;
			else m_PriceFilter = (1 << type);
		}
	}

	private function MapLarge(...args):void
	{
		m_PickCotlId=0;
//		m_PickCotlType=0;
//		m_PickCotlAccountId=0;
//		m_PickCotlUnionId=0;
		m_PickCotlZoneLvl = 0;

		m_OpenFull=!m_OpenFull;
		if(visible) {
			//if(m_OpenFull && m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();
			//SetCenter(HS.m_OffsetX,HS.m_OffsetY);
			SetCenter(HS.m_CamZoneX * SP.m_ZoneSize + HS.m_CamPos.x, HS.m_CamZoneY * SP.m_ZoneSize + HS.m_CamPos.y);
			Show();
			//EM.m_GoOpen=false;
			//if(m_OpenFull) ScrollToView();
			//else SetCenter(EM.m_OffsetX,EM.m_OffsetY);
		}
	}

	private function MiniMapScaleDefault(...args):void
	{
		if(m_OpenFull) m_ScaleFullKof=m_ScaleFullKofDefault;
		else m_ScaleKof=m_ScaleKofDefault;
		if(visible) {
			//if(m_OpenFull && m_GalaxyMapTime==0) m_GalaxyMapTime=Common.GetTime();
			Show();
		}
	}
	
	public function GalaxyMapQuery():void
	{
		//if(m_GalaxyMapTime==0) return;

		if(m_GalaxyMapTime+1*1000>Common.GetTime()) return;
		m_GalaxyMapTime=Common.GetTime();

		var sx:int = Math.max(HS.m_ZoneMinX, Math.floor(RadarToWorld(0, m_SizeY, m_TVec) / HS.m_ZoneSize));
		var sy:int = Math.max(HS.m_ZoneMinY, Math.floor(m_TVec.y / HS.m_ZoneSize));
		var ex:int = Math.min(HS.m_ZoneMinX + HS.m_ZoneCntX, Math.floor(RadarToWorld(m_SizeX, 0, m_TVec) / HS.m_ZoneSize) + 1);
		var ey:int = Math.min(HS.m_ZoneMinY + HS.m_ZoneCntY, Math.floor(m_TVec.y / HS.m_ZoneSize) + 1);

		var cntx:int=ex-sx;
		var cnty:int=ey-sy;
		var ucotl:int=1;
		var zinfo:int=1;
		
		if(m_ScaleFullKof>1500) {
			ucotl=0;
		}
		
		var fin:Boolean=(sx>=m_GalaxyMapLastQuertSX) && (sy>=m_GalaxyMapLastQuertSY) && (sx+cntx<=m_GalaxyMapLastQuertSX+m_GalaxyMapLastQuertCntX) && (sy+cnty<=m_GalaxyMapLastQuertSY+m_GalaxyMapLastQuertCntY);

		if(m_GalaxyMapTime+60*1000>Common.GetTime() &&
			fin &&
//			m_GalaxyMapLastQuertSX==sx && 
//			m_GalaxyMapLastQuertSY==sy && 
//			m_GalaxyMapLastQuertCntX==cntx && 
//			m_GalaxyMapLastQuertCntY==cnty &&
			m_GalaxyMapLastQuertUCotl==ucotl &&
			m_GalaxyMapLastQuertZInfo==zinfo)
		{
			return;
		}
		m_GalaxyMapLastQuertSX=sx;
		m_GalaxyMapLastQuertSY=sy;
		m_GalaxyMapLastQuertCntX=cntx;
		m_GalaxyMapLastQuertCntY=cnty;
		m_GalaxyMapLastQuertUCotl=ucotl;
		m_GalaxyMapLastQuertZInfo=zinfo;

//trace("GalaxyMapQuery: ",sx,sy,cntx,cnty);
		Server.Self.QueryHS("emgalaxymap","&val="+sx.toString()+"_"+sy.toString()+"_"+cntx.toString()+"_"+cnty.toString()+"_"+ucotl.toString()+"_"+zinfo.toString(),GalaxyMapRecv,false);
	}

	public function GalaxyMapRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);
//trace("GalaxyMapRecv:",loader.bytesTotal);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(buf.position>=buf.length) return;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		if(buf.position>=buf.length) return;

//		m_GalaxyMapVersion=buf.readUnsignedInt();

		m_GalaxyMapData.length=0;
		buf.readBytes(m_GalaxyMapData,0,buf.length-buf.position);
		//m_GalaxyMapData.uncompress();

		m_GalaxyMapData.position=0;

		if(m_OpenFull) Update();
	}
	
	public function ScaleSpeed():int
	{
		//return 2;
		return (5 + Math.floor((m_ScaleKof - ScaleMin) / (ScaleMax - ScaleMin) * 5)) * 2;
	}
	
	public function ScaleFullSpeed():int
	{
//		var v:int=1+Math.floor((m_ScaleFullKof-ScaleFullMin)*0.05);
//		return v*v;
		
		return (100 + Math.floor((m_ScaleFullKof - ScaleFullMin) / (ScaleFullMax - ScaleFullMin) * 100)) * 2;
	}
	
	public function ShowLine(sx:int, sy:int, ex:int, ey:int):void
	{
		if ((m_LineSX == sx) && (m_LineSY == sy) && (m_LineEX == ex) && (m_LineEY == ey)) return;
		m_LineSX = sx;
		m_LineSY = sy;
		m_LineEX = ex;
		m_LineEY = ey;
		//Update();
		if (!m_UpdateTimer.running) m_UpdateTimer.start();
	}
	
	public function HideLine():void
	{
		ShowLine(0, 0, 0, 0);
	}
}

}