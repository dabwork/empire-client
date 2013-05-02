// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import QE.QEManager;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

public class FormFleetBar extends Sprite
{
	private var EM:EmpireMap = null;

	static public const SlotOffX:int=7; 
	static public const SlotOffY:int=25;
	static public const SlotSize:int=60;
	public var m_SizeX:int = 0;// SlotOffX + SlotSize * Common.FleetSlotMax + SlotOffX;
	static public const SizeY:int = SlotOffY + SlotSize + 5;
	
	public var m_FleetAnm:uint=0;
//	public var m_FleetModule:int=0;
	public var m_FleetFuel:int=0;
	public var m_FormationOld:int = 0;
	public var m_HoldLvl:uint = 0;
	public var m_FleetMoney:int = 0;
	public var m_ReturnCooldown:Number=0;
	public var m_CotlMoveCooldown:Number = 0;
	public var m_CotlMoveCooldownPay:Number=0;
	public var m_FleetSlot:Array = new Array();
	
	public var m_QuarkBaseType:int = 0;
	public var m_QuarkBasePlanet:int = 0;
	public var m_QuarkBaseSectorX:int = 0;
	public var m_QuarkBaseSectorY:int = 0;
	public var m_QuarkBaseCotlId:uint = 0;

	public var m_CombatBG:Sprite = new MBBG();
	public var m_CombatMassIcon:Sprite = null;
	public var m_CombatMass:TextField = new TextField();
	
	public var m_BG:Sprite=new MBBG();
	public var m_Caption:TextField=new TextField();
	public var m_Fuel:TextField=new TextField();
	//public var m_Module:TextField=new TextField();
	public var m_Mass:TextField=new TextField();
	
	public var m_FuelIcon:Sprite=null;
	//public var m_ModuleIcon:Sprite=null;
	public var m_MassIcon:Sprite = null;
	
	public var m_ButTechnician:SimpleButton = new ButTechnician();
	public var m_ButNavigator:SimpleButton = new ButNavigator();
	public var m_ButTechnicianOff:Sprite = new IconSmallCross();
	public var m_ButNavigatorOff:Sprite = new IconSmallCross();
	
	public var m_SlotLayer:Sprite=new Sprite();
	public var m_ShipLayer:Sprite=new Sprite();
	public var m_TxtLayer:Sprite=new Sprite();
	public var m_MoveLayer:Sprite=new Sprite();
	
	public var m_ButMenu:MMButOptions = new MMButOptions();
	
	public var m_ButItem:SimpleButton = new MMButFleetItem();
	
	public var m_SlotMouse:int = -1;
	
	public var m_SlotMove:int=-1;
	public var m_SlotMoveBegin:Boolean=false;
	public var m_SlotMoveType:int=0;

	public var m_RecvFleetAfterAnm:int=0;
	public var m_RecvFleetAfterAnm_Time:Number=0;
//	public var m_LoadFleetLock:int = 0;

	public var m_AutoPilot:Boolean = true;
	public var m_AutoGive:Boolean = true;
	
	//public var m_OrderWaitEnd:Array = new Array();
	
	public function SlotCnt():int
	{
		return Common.FleetSlotMax;
//		var f:uint = m_Formation & 7;
//		if (f == 1 || f == 2 || f == 4) return Common.FleetSlotMax;
//		return Common.FleetSlotMax - 1;
	}

	public function FormFleetBar(map:EmpireMap)
	{
		var i:int;
		EM = map;

		Server.Self.addEventListener("LostQuery",LostQuery);

		for (i = 0; i < Common.FleetSlotMax; i++) m_FleetSlot.push(new FleetSlot());
		
		addChild(m_CombatBG);
		
		m_CombatMass.x=8;
		m_CombatMass.y=3;
		m_CombatMass.width=1;
		m_CombatMass.height=1;
		m_CombatMass.type=TextFieldType.DYNAMIC;
		m_CombatMass.selectable=false;
		m_CombatMass.border=false;
		m_CombatMass.background=false;
		m_CombatMass.multiline=false;
		m_CombatMass.autoSize=TextFieldAutoSize.LEFT;
		m_CombatMass.antiAliasType=AntiAliasType.ADVANCED;
		m_CombatMass.gridFitType=GridFitType.PIXEL;
		m_CombatMass.defaultTextFormat=new TextFormat("Calibri",13,0xf9d569);
		m_CombatMass.embedFonts=true;
		addChild(m_CombatMass);

		addChild(m_BG);
		m_BG.height=SizeY;
		
		m_Caption.x=8;
		m_Caption.y=1;
		m_Caption.width=1;
		m_Caption.height=1;
		m_Caption.type=TextFieldType.DYNAMIC;
		m_Caption.selectable=false;
		m_Caption.border=false;
		m_Caption.background=false;
		m_Caption.multiline=false;
		m_Caption.autoSize=TextFieldAutoSize.LEFT;
		m_Caption.antiAliasType=AntiAliasType.ADVANCED;
		m_Caption.gridFitType=GridFitType.PIXEL;
		m_Caption.defaultTextFormat=new TextFormat("Calibri",16,0xf9d569);
		m_Caption.embedFonts=true;
		m_Caption.text=Common.Txt.FormFleetBarCaption;
		addChild(m_Caption);

		m_Fuel.x=8;
		m_Fuel.y=3;
		m_Fuel.width=1;
		m_Fuel.height=1;
		m_Fuel.type=TextFieldType.DYNAMIC;
		m_Fuel.selectable=false;
		m_Fuel.border=false;
		m_Fuel.background=false;
		m_Fuel.multiline=false;
		m_Fuel.autoSize=TextFieldAutoSize.LEFT;
		m_Fuel.antiAliasType=AntiAliasType.ADVANCED;
		m_Fuel.gridFitType=GridFitType.PIXEL;
		m_Fuel.defaultTextFormat=new TextFormat("Calibri",13,0xf9d569);
		m_Fuel.embedFonts=true;
		addChild(m_Fuel);

/*		m_Module.x=8;
		m_Module.y=3;
		m_Module.width=1;
		m_Module.height=1;
		m_Module.type=TextFieldType.DYNAMIC;
		m_Module.selectable=false;
		m_Module.border=false;
		m_Module.background=false;
		m_Module.multiline=false;
		m_Module.autoSize=TextFieldAutoSize.LEFT;
		m_Module.antiAliasType=AntiAliasType.ADVANCED;
		m_Module.gridFitType=GridFitType.PIXEL;
		m_Module.defaultTextFormat=new TextFormat("Calibri",13,0xf9d569);
		m_Module.embedFonts=true;
		addChild(m_Module);*/

		m_Mass.x=8;
		m_Mass.y=3;
		m_Mass.width=1;
		m_Mass.height=1;
		m_Mass.type=TextFieldType.DYNAMIC;
		m_Mass.selectable=false;
		m_Mass.border=false;
		m_Mass.background=false;
		m_Mass.multiline=false;
		m_Mass.autoSize=TextFieldAutoSize.LEFT;
		m_Mass.antiAliasType=AntiAliasType.ADVANCED;
		m_Mass.gridFitType=GridFitType.PIXEL;
		m_Mass.defaultTextFormat=new TextFormat("Calibri",13,0xf9d569);
		m_Mass.embedFonts=true;
		addChild(m_Mass);
		
		addChild(m_ButMenu);
		m_ButMenu.addEventListener(MouseEvent.MOUSE_DOWN, onMenuClick);
		
		addChild(m_ButItem);
		m_ButItem.addEventListener(MouseEvent.MOUSE_DOWN, onItemOpenClick);
		
		m_ButTechnician.x = 60;
		m_ButTechnician.y = -11;
		m_ButTechnician.addEventListener(MouseEvent.CLICK, onTechnicianClick);
		addChild(m_ButTechnician);
		m_ButNavigator.x = 87;
		m_ButNavigator.y = -11;
		m_ButNavigator.addEventListener(MouseEvent.CLICK, onNavigatorClick);
		addChild(m_ButNavigator);
		m_ButTechnicianOff.x = m_ButTechnician.x + 17;
		m_ButTechnicianOff.y = m_ButTechnician.y + 26;
		m_ButTechnicianOff.mouseEnabled = false;
		addChild(m_ButTechnicianOff);
		m_ButNavigatorOff.x = m_ButNavigator.x + 17;
		m_ButNavigatorOff.y = m_ButNavigator.y + 26;
		m_ButNavigatorOff.mouseEnabled = false;
		addChild(m_ButNavigatorOff);

		addChild(m_SlotLayer);
		addChild(m_ShipLayer);
		addChild(m_TxtLayer);
		EM.addChild(m_MoveLayer);
		
		m_SlotLayer.mouseChildren=false;
		m_ShipLayer.mouseChildren=false;
		m_TxtLayer.mouseChildren=false;
		m_MoveLayer.mouseChildren=false;
		
		m_SlotLayer.mouseEnabled=false;
		m_ShipLayer.mouseEnabled=false;
		m_TxtLayer.mouseEnabled=false;
		m_MoveLayer.mouseEnabled=false;

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		//addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
	}

	public function LostQuery(e:Event):void
	{
//		m_OrderWaitEnd.length = 0;
//		m_LoadFleetLock=0;
	}

	public function Clear():void
	{
		var i:int;

//		m_FleetVersion=0;
	}

	public function ClearForNewConn():void
	{
		m_FleetAnm=0;
//		m_LoadFleetAfterActionNo=0;
//		m_LoadFleetAfterActionNo_Time=0;
//		m_LoadFleetLock = 0;

		m_RecvFleetAfterAnm=0;
		m_RecvFleetAfterAnm_Time=0;

		m_QuarkBaseType = 0;
		m_QuarkBasePlanet = 0;
		m_QuarkBaseSectorX = 0;
		m_QuarkBaseSectorY = 0;
		m_QuarkBaseCotlId = 0;
		
		m_ButTechnician.visible = false;
		m_ButTechnicianOff.visible = false;
		m_ButNavigator.visible = false;
		m_ButNavigatorOff.visible = false;
		
		m_AutoPilot = true;
		m_AutoGive = true;
	}

	public function StageResize():void
	{
		if (!visible) return;
		//&& EmpireMap.Self.IsResize()) Show();
		Update();
	}

	public function Show():void
	{
		EM.FloatTop(this);
		visible=true;
		Update();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function IsMouseIn():Boolean
	{
		if (!visible) return false;
//		if (m_ItemOpen && mouseX >= 0 && mouseX < SizeX && mouseY >= (-ItemSlotSize * m_ItemRowCnt - 5) && mouseY < 0) return true;
		return mouseX>=0 && mouseX<m_SizeX && mouseY>=0 && mouseY<SizeY;
	}
	
	public function IsMouseInTop():Boolean
	{
		if (!IsMouseIn()) return false;

		var pt:Point = new Point(stage.mouseX, stage.mouseY);
		var ar:Array = stage.getObjectsUnderPoint(pt);

		if (ar.length <= 0) return false;

		var obj:DisplayObject = ar[ar.length - 1];
		if (obj == EM.m_MoveItem) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		else if (obj == EM.m_FormFleetBar.m_MoveLayer) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		while (obj!=null) {
			if (obj == this) return true;
			obj = obj.parent;
		}
		return false;
	}

	private var m_MouseLock:Boolean = false;

	public function MouseLock():void
	{
		if (m_MouseLock) return;
		m_MouseLock = true;
		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
//trace("Fleet.MouseLock");
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
//trace("Fleet.MouseUnlock");
	}

	public static function GetImageByType(type:int, race:int, subtype:int):Sprite
	{
		var name:String = '';

		if(type==Common.ShipTypeFlagship) {
			if(subtype==0) name="AFlagshipQ1";
			else if(subtype==1) name="AFlagshipQ2";
			else if(subtype==2) name="AFlagshipQ3";
			else if(subtype==3) name="AFlagshipQ4";
			else if(subtype==4) name="AFlagshipS1";
			else if(subtype==5) name="AFlagshipS2";
			else if(subtype==6) name="AFlagshipS3";
			else name="AFlagshipS4";
		}
		else if(type==Common.ShipTypeWarBase) { name="AWarBase"; }
		else if(type==Common.ShipTypeShipyard) { name="AShipyard"; }
		else if (type == Common.ShipTypeSciBase) { name = "ASciBase"; }
		else if (type == Common.ShipTypeServiceBase) { name = "AServiceBase"; }
		else if (type == Common.ShipTypeQuarkBase) { name = "AQuarkBase"; }
		else if(race==Common.RaceGrantar) {
			if(type==Common.ShipTypeTransport) name="AMalocT";
			else if(type==Common.ShipTypeCorvette) name="AMalocR";
			else if(type==Common.ShipTypeCruiser) name="AMalocP";
			else if(type==Common.ShipTypeDreadnought) name="AMalocW";
			else if(type==Common.ShipTypeInvader) name="AMalocL";
			else if(type==Common.ShipTypeDevastator) name="AMalocD";
		}
		else if(race==Common.RacePeleng) {
			if(type==Common.ShipTypeTransport) name="APelengT";
			else if(type==Common.ShipTypeCorvette) name="APelengR";
			else if(type==Common.ShipTypeCruiser) name="APelengP";
			else if(type==Common.ShipTypeDreadnought) name="APelengW";
			else if(type==Common.ShipTypeInvader) name="APelengL";
			else if(type==Common.ShipTypeDevastator) name="APelengD";
		}
		else if(race==Common.RacePeople) {
			if(type==Common.ShipTypeTransport) name="APeopleT";
			else if(type==Common.ShipTypeCorvette) name="APeopleR";
			else if(type==Common.ShipTypeCruiser) name="APeopleP";
			else if(type==Common.ShipTypeDreadnought) name="APeopleW";
			else if(type==Common.ShipTypeInvader) name="APeopleL";
			else if(type==Common.ShipTypeDevastator) name="APeopleD";
		}
		else if(race==Common.RaceTechnol) {
			if(type==Common.ShipTypeTransport) name="AFeiT";
			else if(type==Common.ShipTypeCorvette) name="AFeiR";
			else if(type==Common.ShipTypeCruiser) name="AFeiP";
			else if(type==Common.ShipTypeDreadnought) name="AFeiW";
			else if(type==Common.ShipTypeInvader) name="AFeiL";
			else if(type==Common.ShipTypeDevastator) name="AFeiD";
		}
		else if(race==Common.RaceGaal) {
			if(type==Common.ShipTypeTransport) name="AGaalT";
			else if(type==Common.ShipTypeCorvette) name="AGaalR";
			else if(type==Common.ShipTypeCruiser) name="AGaalP";
			else if(type==Common.ShipTypeDreadnought) name="AGaalW";
			else if(type==Common.ShipTypeInvader) name="AGaalL";
			else if(type==Common.ShipTypeDevastator) name="AGaalD";
		}
		
		if(name.length<=0) { return GraphShip.GetImageByType(type,race,subtype); }

		var cl:Class=ApplicationDomain.currentDomain.getDefinition(name) as Class;
		var s:Sprite=new cl();
		return s;
	}

	public function Update():void
	{
		var i:int, px:int, py:int;
		var fs:FleetSlot;
		var str:String;
		var cl:Class;

		if (!visible) return;

		m_SizeX = SlotOffX + SlotSize * SlotCnt() + SlotOffX;
		m_BG.width = m_SizeX;

		var user:User = UserList.Self.GetUser(Server.Self.m_UserId, false);
		if (user.m_Race == Common.RaceNone) user = null; // Пользователь загрузился еще не достаточно
//		if (user == null) return;

		var emptyspace:int=EM.m_FormInfoBar.m_ButGalaxy.x-10;
		if(EM.m_FormInfoBar.m_ChatOpen) emptyspace-=EM.m_FormChat.width; 

		if(false && (emptyspace>=m_SizeX)) {
			x = EM.m_FormInfoBar.m_ButGalaxy.x - m_SizeX - 10;
			y = EM.stage.stageHeight - FormInfoBar.BarHeight - SizeY + 4;
			
		} else { 
			x = EM.stage.stageWidth - m_SizeX - 4 - 55;
			//y=EM.stage.stageHeight-FormInfoBar.BarHeight-56-SizeY;
			y = EM.stage.stageHeight - FormInfoBar.BarHeight - SizeY;
		}

		if(m_FuelIcon==null && ApplicationDomain.currentDomain.hasDefinition("ItemFuel")) {
			cl=ApplicationDomain.currentDomain.getDefinition("ItemFuel") as Class;
			m_FuelIcon=new cl();
			m_FuelIcon.y=12;
			m_FuelIcon.scaleX=0.6;
			m_FuelIcon.scaleY=0.6;
			addChildAt(m_FuelIcon,4);
		}
/*		if(m_ModuleIcon==null && ApplicationDomain.currentDomain.hasDefinition("ItemModule")) {
			cl=ApplicationDomain.currentDomain.getDefinition("ItemModule") as Class;
			m_ModuleIcon=new cl();
			m_ModuleIcon.y=12;
			m_ModuleIcon.scaleX=0.7;
			m_ModuleIcon.scaleY=0.7;
			addChildAt(m_ModuleIcon,2);
		}*/
		if(m_MassIcon==null && ApplicationDomain.currentDomain.hasDefinition("IconMass")) {
			cl=ApplicationDomain.currentDomain.getDefinition("IconMass") as Class;
			m_MassIcon=new cl();
			m_MassIcon.y=12;
			//m_MassIcon.scaleX=0.7;
			//m_MassIcon.scaleY=0.7;
			addChildAt(m_MassIcon,4);
		}

		//var fuel:int = 0;
		//var fleet:SpaceFleet = Space.Self.EntityFind(SpaceEntity.TypeFleet, EmpireMap.Self.m_RootFleetId);
		//if (fleet != null) fule = fleet.m_Fuel;
		m_Fuel.text = BaseStr.FormatBigInt(Math.max(0, m_FleetFuel - EM.m_FleetFuelUse));
		//m_Module.text=BaseStr.FormatBigInt(m_FleetModule);
		m_Mass.text=BaseStr.FormatBigInt(EmpireFleetCalcMass());

		var sx:int=m_SizeX-10;
		sx-=20;
		m_ButMenu.x = sx;
		sx-=25;
		m_ButItem.x = sx;
		sx -= 10;
		//sx-=Math.max(40,m_Module.width);
		//m_Module.x=sx;
		//sx-=25;
		//if(m_ModuleIcon!=null) m_ModuleIcon.x=sx+12;
		//sx-=10;
		sx-=Math.max(40,m_Fuel.width);
		m_Fuel.x=sx;
		sx-=25;
		if (m_FuelIcon != null) m_FuelIcon.x = sx + 10;

		sx-=10;
		sx-=Math.max(60,m_Mass.width);
		m_Mass.x=sx;
		sx-=25;
		if(m_MassIcon!=null) m_MassIcon.x=sx+12;
		
//		graphics.clear();

		var slotcnt:int = SlotCnt();
		
		if(user!=null)
		for(i=0;i<Common.FleetSlotMax;i++) {
			fs=m_FleetSlot[i];

//			graphics.lineStyle(null);
//			graphics.beginFill(0x0000ff,0.5);
//			graphics.drawRect(SlotOffX+i*SlotSize,SlotOffY,SlotSize,SlotSize);
//			graphics.endFill();

			var subtype:int=0;
			if(fs.m_Type==Common.ShipTypeFlagship) subtype=EM.CalcFlagshipSubtype(Server.Self.m_UserId,fs.m_Id);

			if (fs.m_Type == 0 || i >= slotcnt) {
				ClearSlotGraph(fs);
//				if(fs.m_Ship!=null) {
//					m_ShipLayer.removeChild(fs.m_Ship);
//					fs.m_Ship=null;
//				}
			} else if (fs.m_Ship == null || !(fs.m_GraphType == fs.m_Type && fs.m_GraphOwner == Server.Self.m_UserId && fs.m_GraphRace == EM.RaceByOwner(Server.Self.m_UserId) && fs.m_GraphSubType == subtype)) {
				ClearSlotGraph(fs);
//				if(fs.m_Ship!=null) {
//					m_ShipLayer.removeChild(fs.m_Ship);
//					fs.m_Ship=null;
//				}

				fs.m_Ship=GetImageByType(fs.m_Type,user.m_Race/*EM.RaceByOwner(Server.Self.m_UserId)*/,subtype);
				//fs.m_Ship=new GraphPeopleC3D();
//trace(fs.m_Ship,fs.m_Type);
				m_ShipLayer.addChild(fs.m_Ship);
				fs.m_Ship.x=SlotOffX+(SlotSize>>1)+i*SlotSize;
				fs.m_Ship.y=SlotOffY+(SlotSize>>1);
			}

			if(fs.m_SlotN==null) {
				fs.m_SlotN=new MBSlotN();
				m_SlotLayer.addChild(fs.m_SlotN);
				fs.m_SlotN.x=SlotOffX+i*SlotSize;
				fs.m_SlotN.y=SlotOffY;
				fs.m_SlotN.width=SlotSize;
				fs.m_SlotN.height=SlotSize;
			}
			if(fs.m_SlotA==null) {
				fs.m_SlotA=new MBSlotA();
				m_SlotLayer.addChild(fs.m_SlotA);
				fs.m_SlotA.x=SlotOffX+i*SlotSize;
				fs.m_SlotA.y=SlotOffY;
				fs.m_SlotA.width=SlotSize;
				fs.m_SlotA.height=SlotSize;
			}

			if(fs.m_Txt==null) {
				fs.m_Txt=new TextField();
				m_TxtLayer.addChild(fs.m_Txt);
				fs.m_Txt.x=SlotOffX+i*SlotSize+1;
				fs.m_Txt.y=SlotOffY+SlotSize-17;
				fs.m_Txt.width=SlotSize-2;
				fs.m_Txt.height=17;
				fs.m_Txt.type=TextFieldType.DYNAMIC;
				fs.m_Txt.selectable=false;
				fs.m_Txt.border=false;
				fs.m_Txt.background=true;
				fs.m_Txt.backgroundColor=0x000000;
				fs.m_Txt.multiline=false;
				fs.m_Txt.autoSize=TextFieldAutoSize.NONE;
				fs.m_Txt.antiAliasType=AntiAliasType.ADVANCED;
				fs.m_Txt.gridFitType=GridFitType.PIXEL;
				fs.m_Txt.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);
				fs.m_Txt.embedFonts=true;
				fs.m_Txt.alpha=0.8;
			}
			
			if (i >= slotcnt) {
				fs.m_SlotN.visible = false;
				fs.m_SlotA.visible = false;
				fs.m_Txt.visible = false;
				
				if(fs.m_ItemIcon!=null) {
					m_TxtLayer.removeChild(fs.m_ItemIcon);
					fs.m_ItemIcon=null;
				}
				continue;
			}

			fs.m_SlotA.visible=(i==m_SlotMouse) || (EM.m_MoveItem.visible && EM.m_MoveItem.m_ToType == 9 && EM.m_MoveItem.m_ToSlot == i);
			fs.m_SlotN.visible=!fs.m_SlotA.visible;
			
			if (fs.m_Type == Common.ShipTypeFlagship) {
				if (user == null) str = "";
				else if (EM.ShipMaxHP(Server.Self.m_UserId, fs.m_Id, fs.m_Type, user.m_Race) == 0) str = "";
				else {
//					str=""+Math.round(fs.m_HP/EM.ShipMaxHP(Server.Self.m_UserId,fs.m_Id,fs.m_Type)*100).toString()+"%";
//					str+=""+Math.round(fs.m_Shield/EM.ShipMaxShield(Server.Self.m_UserId,fs.m_Id,fs.m_Type,0,0)*100).toString()+"%";
					str=""+Math.min(100,Math.round((fs.m_HP+fs.m_Shield)/(EM.ShipMaxHP(Server.Self.m_UserId,fs.m_Id,fs.m_Type,user.m_Race)+EM.ShipMaxShield(Server.Self.m_UserId,fs.m_Id,fs.m_Type,0,0))*100)).toString()+"%";
				}
				fs.m_Txt.text=str;
			} else {
				fs.m_Txt.text=fs.m_Cnt.toString();
			}
			fs.m_Txt.visible=(fs.m_Type!=Common.ShipTypeNone);
			
			if(fs.m_ItemType!=fs.m_ItemTypeShow || fs.m_ItemIcon==null) {
				fs.m_ItemTypeShow=fs.m_ItemType;
				
				if(fs.m_ItemIcon!=null) {
					m_TxtLayer.removeChild(fs.m_ItemIcon);
					fs.m_ItemIcon=null;
				}
				
				if(fs.m_ItemTypeShow!=Common.ItemTypeNone) {
					fs.m_ItemIcon = GraphItem.GetImageByType(fs.m_ItemTypeShow);
					if (fs.m_ItemIcon == null) fs.m_ItemTypeShow = 0;
					else {
						m_TxtLayer.addChild(fs.m_ItemIcon);
						fs.m_ItemIcon.scaleX=0.5;
						fs.m_ItemIcon.scaleY=0.5;
						fs.m_ItemIcon.x=SlotOffX+i*SlotSize+SlotSize-9;
						fs.m_ItemIcon.y = SlotOffY + SlotSize-17 + 8;
					}
				}
			}
		}
		
//		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) {
			m_ButTechnician.visible = false;
			m_ButTechnicianOff.visible = false;
			m_ButNavigator.visible = false;
			m_ButNavigatorOff.visible = false;
		} else {
			m_ButTechnician.visible = user.m_IB1_Type != 0;
			m_ButTechnicianOff.visible = m_ButTechnician.visible && ((user.m_IB1_Type & 0x8000)==0);

			m_ButNavigator.visible = user.m_IB2_Type != 0;
			m_ButNavigatorOff.visible = m_ButNavigator.visible && ((user.m_IB2_Type & 0x8000) == 0);
		}
		
		if(EM.m_CotlType==Common.CotlTypeCombat) {
			m_CombatBG.visible = true;
			m_CombatBG.x = m_MassIcon.x - 18;
			m_CombatBG.y = m_MassIcon.y - 34;
			m_CombatBG.width = 100;
			//m_CombatBG.height = 30;
			
			if(m_CombatMassIcon==null && ApplicationDomain.currentDomain.hasDefinition("IconMass")) {
				m_CombatMassIcon = Common.CreateByName("IconMass") as Sprite;
				addChildAt(m_CombatMassIcon,2);
			}
			m_CombatMassIcon.visible = true;
			m_CombatMassIcon.x = m_MassIcon.x;
			m_CombatMassIcon.y = m_MassIcon.y - 22;
			m_CombatMass.visible = true;
			str = BaseStr.FormatBigInt(EM.m_CombatMass);
			//if ((EM.m_CombatFlag & (FormCombat.FlagDuel | FormCombat.FlagRandom))==0 && )
			m_CombatMass.text = str;
			m_CombatMass.x = m_Mass.x;
			m_CombatMass.y = m_Mass.y - 22;
			
		} else {
			m_CombatBG.visible = false;			
			if (m_CombatMassIcon != null) m_CombatMassIcon.visible = false;
			m_CombatMass.visible = false;
		}
		
		EM.m_Info.Update();
	}
	
	public function ClearSlotGraph(fs:FleetSlot):void
	{
		if(fs.m_Ship!=null) {
			m_ShipLayer.removeChild(fs.m_Ship);
			fs.m_Ship=null;
		}
		if(fs.m_ItemIcon!=null) {
			m_TxtLayer.removeChild(fs.m_ItemIcon);
			fs.m_ItemIcon=null;
		}
	}
	
	public function UpdateMove():void
	{
		m_MoveLayer.graphics.clear();
		EM.m_TxtExtractLayer.visible=false;

		if(m_SlotMove<0) return;
		if(!m_SlotMoveBegin) return;

		var px:int=SlotOffX+m_SlotMove*SlotSize+(SlotSize>>1);
		var py:int=SlotOffY+(SlotSize>>1);

		m_MoveLayer.graphics.lineStyle(1.5,0xffffff,1.0,true);
		m_MoveLayer.graphics.moveTo(x + px, y + py);

		px=stage.mouseX;
		py=stage.mouseY;
		if(EM.m_CurPlanetNum>=0 && EM.m_CurShipNum>=0) {
			var pl:Planet=EM.GetPlanet(EM.m_CurSectorX,EM.m_CurSectorY,EM.m_CurPlanetNum);
			if(pl!=null) {
				var ar:Array=EM.CalcShipPlace(pl,EM.m_CurShipNum);

				px = EM.WorldToScreenX(ar[0], ar[1]);// -x;
				py = EmpireMap.m_TWSPos.y;// EM.WorldToScreenY(ar[1]);// -y;

				EM.m_TxtExtractLayer.visible=true;
				EM.m_TxtExtractLayer.x = EM.WorldToScreenX(ar[0], ar[1]);
				EM.m_TxtExtractLayer.y = EmpireMap.m_TWSPos.y;//EM.WorldToScreenY(ar[1]);
			}
		} else if (EM.m_MoveItem.m_ToType == 1) {
			px = EM.m_FormPlanet.GetItemSlotX(EM.m_MoveItem.m_ToSlot);
			py = EM.m_FormPlanet.GetItemSlotY(EM.m_MoveItem.m_ToSlot);
		} else if(EM.m_MoveItem.m_ToType == 2) {
			px = EM.m_FormFleetItem.GetItemSlotX(EM.m_MoveItem.m_ToSlot);
			py = EM.m_FormFleetItem.GetItemSlotY(EM.m_MoveItem.m_ToSlot);
		}

		m_MoveLayer.graphics.lineTo(px,py);
	}

//	public function QueryFleet():void
//	{
//		Server.Self.Query("emfleet",'',AnswerFleet,false);
//	}
		
	public function RecvFleet(buf:ByteArray):void
	{
		var i:int,cnt:int,type:int;
		var fs:FleetSlot;
		var fi:FleetItem;

//		if(!(EM.m_ActionNoComplate>=m_LoadFleetAfterActionNo || (m_LoadFleetAfterActionNo_Time+5000)<Common.GetTime())) {
//			return;
//		}
//		if(m_LoadFleetLock>0) return;
//
//		if(buf.length-buf.position<=0) {
//			//m_FleetModule=0;
//			m_FleetFuel=0;
//			m_ReturnCooldown=0;
//			m_CotlMoveCooldown = 0;
//			m_CotlMoveCooldownPay = 0;
//			for(i=0;i<Common.FleetSlotMax;i++) {
//				fs=m_FleetSlot[i];
//				fs.m_Type=Common.ShipTypeNone;
//			}
//			return;
//		}
		
		var updtaecptbar:Boolean = false;

		var sl:SaveLoad=new SaveLoad();

		sl.LoadBegin(buf);
		
		var posanm:uint = sl.LoadDword();
		if (posanm != 0) {
//trace("recv fleetpos",posanm);
			EM.m_FleetPosAnm = posanm;
			if (EM.m_FleetPosAnm >= Server.Self.m_Anm) Server.Self.m_Anm = EM.m_FleetPosAnm;

			EM.m_FleetPosX = sl.LoadInt();
			EM.m_FleetPosY = sl.LoadInt();
			EM.m_FleetAction = sl.LoadInt();
			if (EM.m_FleetAction == Common.FleetActionInOrbitCotl) EM.m_FleetTgtId = sl.LoadDword();
			else EM.m_FleetTgtId = 0;
			EM.m_FleetFuelUse = sl.LoadInt();
		}
		
		var anm:uint = sl.LoadDword();
		if (anm == 0) {
			if (posanm != 0) Update();
			return;
		}
		if (!(anm >= m_RecvFleetAfterAnm || (m_RecvFleetAfterAnm_Time + 5000) < EM.m_CurTime)) {
//trace("Fleet reject anm",anm);
			return;
		}
		m_FleetAnm = anm;
		if (m_FleetAnm >= Server.Self.m_Anm) Server.Self.m_Anm = m_FleetAnm;
//trace("Fleet accept anm",anm);
		//m_FleetVersion=ver;
		//m_FleetModule=sl.LoadInt();
		m_FleetFuel=sl.LoadInt();
		m_FormationOld = sl.LoadInt();
		m_HoldLvl = sl.LoadDword();
		m_FleetMoney=sl.LoadInt();
		m_ReturnCooldown = 1000 * sl.LoadDword();
		m_CotlMoveCooldown = 1000 * sl.LoadDword();
		m_CotlMoveCooldownPay = 1000 * sl.LoadDword();

		type = sl.LoadDword();
		if (m_QuarkBaseType != type) { m_QuarkBaseType = type; updtaecptbar = true; }
		if (m_QuarkBaseType != 0) {
			m_QuarkBasePlanet = sl.LoadInt();
			m_QuarkBaseSectorX = sl.LoadInt();
			m_QuarkBaseSectorY = sl.LoadInt();
			m_QuarkBaseCotlId = sl.LoadDword();
		} else {
			m_QuarkBasePlanet = 0;
			m_QuarkBaseSectorX = 0;
			m_QuarkBaseSectorY = 0;
			m_QuarkBaseCotlId = 0;
		}

		for(i=0;i<Common.FleetSlotMax;i++) {
			fs=m_FleetSlot[i];
			
			type=sl.LoadDword();
			if(fs.m_Type!=type) {
				fs.m_Type = type;
				ClearSlotGraph(fs);
//				if(fs.m_Ship!=null) {
//					m_ShipLayer.removeChild(fs.m_Ship);
//					fs.m_Ship=null;
//				}
			}
			  
			if (fs.m_Type == Common.ShipTypeNone) {
				fs.m_ItemType = 0;
				continue;
			}
			if(fs.m_Type==Common.ShipTypeFlagship) fs.m_Id=sl.LoadDword();
			else fs.m_Id=0;
			fs.m_Cnt=sl.LoadInt();
			fs.m_CntDestroy=sl.LoadInt();
			fs.m_HP=sl.LoadInt();
			if(fs.m_Type==Common.ShipTypeFlagship) fs.m_Shield=sl.LoadInt();
			else fs.m_Shield = 0;
			type = sl.LoadDword();
			if (type != fs.m_ItemType) {
				fs.m_ItemType = type;
				ClearSlotGraph(fs);
			}
			if(fs.m_ItemType) fs.m_ItemCnt=sl.LoadInt();
		}
		
		for (i = 0; i < Common.FleetItemCnt; i++) {
			fi = EM.m_FormFleetItem.m_FleetItem[i];
			fi.m_Type = 0;
			fi.m_Cnt = 0;
			fi.m_Broken = 0;
		}
		
		while (true) {
			var item_type:uint = sl.LoadDword();
			if (item_type == 0) break;
			var item_slot:int = sl.LoadInt();
			
			fi = EM.m_FormFleetItem.m_FleetItem[item_slot];
			fi.m_Type = item_type;
			fi.m_Cnt = sl.LoadInt();
			fi.m_Broken = sl.LoadInt();
		}
		
		sl.LoadEnd();
		
		Update();
		EM.m_FormFleetItem.Update();
		EM.m_FormInfoBar.Update();
		//EM.m_FormFleetType.Update();
		if (updtaecptbar) EM.m_FormCptBar.Update();
	}
	
	public function PickSlot():int
	{
		var x:int=Math.floor((mouseX-SlotOffX)/SlotSize);
		var y:int=Math.floor((mouseY-SlotOffY)/SlotSize);
		if(x<0 || x>=SlotCnt()) return -1;
		if(y!=0) return -1;
		return x;
	}
	
	public function SlotMoveBegin(no:int):void
	{
		var slot:FleetSlot;
		if(no<0 || no>=SlotCnt()) {
			if(m_SlotMove>=0 && m_SlotMoveBegin) {
				m_SlotMove = -1;
				MouseUnlock();
			}
		} else {
			if(m_SlotMoveBegin || m_SlotMove<0) {
				slot=m_FleetSlot[no];
				if(slot.m_Type!=Common.ShipTypeNone) {
					m_SlotMove=no;
					m_SlotMoveType = 1;
					m_SlotMoveBegin = true;
					MouseLock();
					
					EM.m_FormMenu.Clear();
					
					EM.m_FormSplit.FleetFromHyperspace_Run(m_SlotMove,EM.m_CurSectorX,EM.m_CurSectorY,EM.m_CurPlanetNum,EM.m_CurShipNum);
					EM.m_FormSplit.Hide();
					EM.m_TxtExtractLayer.text = EM.m_FormSplit.EditCnt.text;
				}
			}
		}
		UpdateMove();
		EM.CalcPick(x+mouseX,y+mouseY);
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		EM.FloatTop(this);
		
//		if(FormMessageBox.Self.visible) return;
//		if(EM.m_FormInput.visible) return;

		var i:int;

		i=PickSlot();
//trace("Down",i)
		if(i>=0) {
			m_SlotMove=i;
			m_SlotMoveBegin = false;
			MouseLock();
		}
	}

	public function onMouseUp(e:MouseEvent):void
	{
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;
		
		e.stopImmediatePropagation();

		//if(FormMessageBox.Self.visible) return;
		//if(EM.m_FormInput.visible) return;
		//if(EM.m_FormRes.visible) return;

		if(m_SlotMove>=0 && !m_SlotMoveBegin) {
//trace("Fleet.Up",m_SlotMove,m_SlotMoveBegin);
			m_SlotMouse=m_SlotMove;
			m_SlotMove = -1;
			MouseUnlock();

			UpdateMove();
			Update();
			MenuSlot();
		} else if (m_SlotMove >= 0 && m_SlotMoveBegin) {
			MouseUnlock();
			if(EM.m_CurPlanetNum>=0 && EM.m_CurShipNum>=0) {
				//if(adkey) {
				EM.m_FormSplit.FleetFromHyperspace_Run(m_SlotMove,EM.m_CurSectorX,EM.m_CurSectorY,EM.m_CurPlanetNum,EM.m_CurShipNum);
				if(!addkey) {
					EM.m_FormSplit.clickSplit();
				}

//} else {
//				var id:uint=EM.NewShipId(Server.Self.m_UserId);
//				if(id!=0) {
//					var ac:Action=new Action(m_Map);
//					ac.ActionFromHyperspace(id,EM.m_CurSectorX,EM.m_CurSectorY,EM.m_CurPlanetNum,EM.m_CurShipNum,m_SlotMove,999,0);
//					EM.m_LogicAction.push(ac);
//				}
			} else if(m_SlotMouse>=0) {
				MoveEnd(addkey);
			} else if (EM.m_MoveItem.m_ToType != 0) {
				EM.m_MoveItem.FinMove(addkey);
			}
			m_SlotMove=-1;
			UpdateMove();
		}
	}

	//protected function onMouseMoveHandler(e:MouseEvent):void
	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		//if(FormMessageBox.Self.visible) return;
		//if(EM.m_FormInput.visible) return;
		//if(EM.m_FormRes.visible) return;

		var slot:FleetSlot;
		var i:int;
		var user:User;
		
		var infohide:Boolean = true;
		
		i = PickSlot();
		if(EM.m_Action==EmpireMap.ActionMove && i>=0) {
			var ship:Ship=EM.GetShip(EM.m_MoveSectorX,EM.m_MoveSectorY,EM.m_MovePlanetNum,EM.m_MoveShipNum);
			if(ship==null) i=-1;
			else if(ship.m_Owner!=Server.Self.m_UserId) i=-1;
			else if(Common.IsBase(ship.m_Type)) i=-1;
			else {
				slot=m_FleetSlot[i];
				if(slot.m_Type==Common.ShipTypeNone) {}
				else if(ship.m_Type==Common.ShipTypeFlagship) i=-1;
				else if(ship.m_Type!=slot.m_Type) i=-1;
			}
		}
		if(i!=m_SlotMouse) {
			m_SlotMouse=i;
			Update();
		}
		
//trace("Move",m_SlotMove)
		if(m_SlotMove>=0 && m_SlotMoveBegin==false && i!=m_SlotMove) {
			slot=m_FleetSlot[m_SlotMove];
			if(slot.m_Type!=Common.ShipTypeNone) {
				m_SlotMoveBegin = true;
				m_SlotMoveType = 0;

				EM.m_MoveItem.m_FromType = 0;
				EM.m_MoveItem.m_FromSlot = 0;
				EM.m_MoveItem.m_ToType = 0;
				EM.m_MoveItem.m_ToSlot = 0;

				EM.m_FormSplit.FleetFromHyperspace_Run(m_SlotMove,0,0,-1,-1);
				EM.m_FormSplit.Hide();
				EM.m_TxtExtractLayer.text=EM.m_FormSplit.EditCnt.text;
				
				UpdateMove();
			}
		}

		if(m_SlotMove>=0 && m_SlotMoveBegin) {
			var new_type:int = 0;
			var new_slot:int = 0;
			var inform:Boolean = false;
			
			if (EM.m_FormPlanet.IsMouseInTop()) {
				inform = true;
				EM.FloatTop(EM.m_FormPlanet);

				new_slot = EM.m_FormPlanet.PickItem();
				if (new_slot >= 0) new_type = 1;
			}
			if (new_type == 0 && EM.m_FormFleetItem.IsMouseInTop()) {
				inform = true;
				EM.FloatTop(EM.m_FormFleetItem);

				new_slot = EM.m_FormFleetItem.PickItem();
				if (new_slot >= 0) new_type = 2;
			}
			if (new_type == 0 && IsMouseInTop()) {
				inform = true;
				EM.FloatTop(this);
			}

			EM.m_MoveItem.m_FromType = 0;
			EM.m_MoveItem.m_FromSlot = 0;
			EM.m_MoveItem.m_ToType = 0;
			EM.m_MoveItem.m_ToSlot = 0;

			if (new_type == 0 && !inform && !EM.HS.visible) {
				//if (!IsMouseInTop())
				EM.CalcPick(x + mouseX, y + mouseY);

				EM.m_FormPlanet.Update();
				EM.m_FormFleetItem.Update();
				EM.m_FormFleetBar.Update();
			} else {
				EM.m_CurSectorX=0;
				EM.m_CurSectorY=0;
				EM.m_CurPlanetNum = -1;
				EM.m_CurShipNum = -1;
				EM.m_GraphSelect.SetRadius(0);
				
				if ((EM.m_MoveItem.m_ToType != new_type) || (EM.m_MoveItem.m_ToSlot != new_slot)) {
					EM.m_MoveItem.m_FromType = 9;
					EM.m_MoveItem.m_FromSlot = m_SlotMove;
					EM.m_MoveItem.m_ToType = new_type;
					EM.m_MoveItem.m_ToSlot = new_slot;
					EM.m_FormPlanet.Update();
					EM.m_FormFleetItem.Update();
					EM.m_FormFleetBar.Update();
				}
			}
			
			UpdateMove();
		}

		if (m_ButTechnician.hitTestPoint(e.stageX, e.stageY)) {
			EM.m_Info.ShowItemBonusLive(1, x + m_ButTechnician.x, y + m_ButTechnician.y, m_ButTechnician.width, m_ButTechnician.height);
			infohide = false;

		} else if (m_ButNavigator.hitTestPoint(e.stageX, e.stageY)) {
			EM.m_Info.ShowItemBonusLive(2, x + m_ButNavigator.x, y + m_ButNavigator.y, m_ButNavigator.width, m_ButNavigator.height);
			infohide = false;
			
		} else if (m_SlotMouse >= 0) {
			EM.m_Info.ShowShipHyperspace(m_SlotMouse);
			infohide = false;
		}

		if (infohide) EM.m_Info.Hide();
	}

	protected function onMouseOut(e:MouseEvent):void
	{
		if(FormMessageBox.Self.visible) return;
		if(EM.m_FormInput.visible) return;
		//if(EM.m_FormRes.visible) return;

		if(!EM.m_FormMenu.visible && (m_SlotMouse!=-1)) {
			m_SlotMouse = -1;
			Update();
		}
	}

	public function MoveEnd(openform:Boolean):void
	{
		var fromno:int=m_SlotMove;
		var tono:int=m_SlotMouse;
		var cnt:int=0;
		var itemcnt:int=0;

		if(fromno==tono) return;
		if(fromno<0 || fromno>=m_FleetSlot.length) return;
		if(tono<0 || tono>=SlotCnt()) return;

		var src:FleetSlot=m_FleetSlot[fromno];
		var des:FleetSlot=m_FleetSlot[tono];
		if(src.m_Type==Common.ShipTypeNone)  return;
		
		cnt=src.m_Cnt;
		if(des.m_Type==src.m_Type) cnt+=des.m_Cnt;
		
//		if(des.m_Type==Common.ShipTypeNone) {
//			cnt=0;
//		}

		if(src.m_Type!=des.m_Type && des.m_Type!=Common.ShipTypeNone) openform=false;
		if(src.m_Type==Common.ShipTypeFlagship) openform=false;

		if(openform) {
			EM.m_FormSplit.Fleet_Run(fromno,tono);
		} else {
			var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user == null) return;
			FleetSplit(fromno,tono,cnt,itemcnt,user.m_Race);
		}
	}
	
	public function FleetSplit(fromslot:int,toslot:int,shipcnt:int,itemcnt:int,race:uint):void
	{
		var maxhp:int;
		if (toslot >= SlotCnt()) return;
		var src:FleetSlot=m_FleetSlot[fromslot];
		var des:FleetSlot = m_FleetSlot[toslot];
		
        if(src.m_Type==Common.ShipTypeNone) {
            // Исходный слот пустой
            return;
        } else if(des.m_Type==Common.ShipTypeNone) {
            // Слот назначения пустой
            if(shipcnt<=0 || shipcnt>=src.m_Cnt) {
                // Полностью перемещаем
                des.Copy(src);
                src.Clear();

            } else if(des.m_Type==Common.ShipTypeFlagship) {
                // Флагман игнорируем так как его не нужно разделять.
                return;

            } else {
                // Разделяем
                des.m_Type=src.m_Type;
                des.m_Cnt=shipcnt;
                des.m_CntDestroy=0;
                des.m_HP = Common.ShipMaxHP[src.m_Type];
				if ((race == Common.RaceGrantar) && (des.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(des.m_Type))) des.m_HP += des.m_HP >> 1;
                des.m_Shield=0;
                des.m_Id=0;
                src.m_Cnt-=shipcnt;

                if(src.m_ItemType==Common.ItemTypeNone || itemcnt<=0) {
                    des.m_ItemType=0;
                    des.m_ItemCnt=0;
                } else {
                    des.m_ItemType=src.m_ItemType;
                    if(itemcnt>=src.m_ItemCnt) {
                        des.m_ItemCnt=src.m_ItemCnt;
                        src.m_ItemCnt=0;
                        src.m_ItemType=Common.ItemTypeNone;
                    } else {
                        des.m_ItemCnt=itemcnt;
                        src.m_ItemCnt-=itemcnt;
                    }
                }
            }
        } else if((des.m_Type!=src.m_Type) || (des.m_Type==Common.ShipTypeFlagship)) {
            // В слотах разные типы кораблей, или флагманы
            if(itemcnt<=0) {
                // Меняем местами
                var tmpc:FleetSlot=new FleetSlot();
                tmpc.Copy(src);
                src.Copy(des);
                des.Copy(tmpc);

            } else if(src.m_ItemType!=Common.ItemTypeNone) {
                des.m_ItemType=src.m_ItemType;
                if(itemcnt>=src.m_ItemCnt) {
                    des.m_ItemCnt=src.m_ItemCnt;
                    src.m_ItemCnt=0;
                    src.m_ItemType=Common.ItemTypeNone;
                } else {
                    des.m_ItemCnt=itemcnt;
                    src.m_ItemCnt-=itemcnt;
                }
            }
        } else {
            // В слотах один тип кораблей.
            if(shipcnt<=0 || shipcnt>=(src.m_Cnt+des.m_Cnt)) {
                // Полностью переносим в один из слотов
                if(shipcnt<=0) { var tmp:FleetSlot=src; src=des; des=tmp; }
                des.m_Cnt+=src.m_Cnt;
                des.m_CntDestroy+=src.m_CntDestroy;

                maxhp = Common.ShipMaxHP[src.m_Type];
				if ((race == Common.RaceGrantar) && (src.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(src.m_Type))) maxhp += maxhp >> 1;
                des.m_HP-=maxhp-src.m_HP;
                if(des.m_HP<=0) { des.m_HP=maxhp+des.m_HP; des.m_Cnt--; des.m_CntDestroy++; }
                if(des.m_HP<=0 || des.m_Cnt<=0) { des.m_Cnt=1; des.m_HP=1; }

                if(src.m_ItemType==Common.ItemTypeNone) {}
                else if(des.m_ItemType==Common.ItemTypeNone) {
                    des.m_ItemType=src.m_ItemType;
                    des.m_ItemCnt=src.m_ItemCnt;

                } else if(src.m_ItemType==des.m_ItemType) {
                    des.m_ItemType=src.m_ItemType;
                    des.m_ItemCnt+=src.m_ItemCnt;

                } else if((itemcnt>0 && shipcnt>0) || (itemcnt<=0 && shipcnt<=0)) {
                    des.m_ItemType=src.m_ItemType;
                    des.m_ItemCnt=src.m_ItemCnt;
                }

				src.Clear();
            } else {
                // Перераспределяем кол-во кораблей между слотами
                src.m_Cnt=src.m_Cnt+des.m_Cnt-shipcnt;
                des.m_Cnt=shipcnt;

                if(src.m_ItemType==Common.ItemTypeNone) {}
                else if(des.m_ItemType!=src.m_ItemType) {
                    if(itemcnt>=src.m_ItemCnt) {
                        des.m_ItemType=src.m_ItemType;
                        des.m_ItemCnt=src.m_ItemCnt;
                        src.m_ItemType=0;
                        src.m_ItemCnt=0;
                    } else if(itemcnt>0) {
                        des.m_ItemType=src.m_ItemType;
                        des.m_ItemCnt=itemcnt;
                        src.m_ItemCnt-=itemcnt;
                    }
                } else {
                    if(itemcnt>des.m_ItemCnt+src.m_ItemCnt) itemcnt=des.m_ItemCnt+src.m_ItemCnt;
                    src.m_ItemCnt=src.m_ItemCnt+des.m_ItemCnt-itemcnt;
                    des.m_ItemCnt=itemcnt;
                    if(src.m_ItemCnt<=0) src.m_ItemType=0;
                    if(des.m_ItemCnt<=0) des.m_ItemType=0;
                }
            }
        }

		//m_LoadFleetAfterActionNo=EM.SendAction("emfleetsplit",""+fromslot.toString()+"_"+toslot.toString()+"_"+shipcnt.toString()+"_"+itemcnt.toString());
		//m_LoadFleetAfterActionNo_Time=Common.GetTime();
//		m_LoadFleetLock++;
		Server.Self.QueryHS("emfleetsplit",'&val='+fromslot.toString()+"_"+toslot.toString()+"_"+shipcnt.toString()+"_"+itemcnt.toString(),FleetSplitAnswer,false);

		ClearSlotGraph(src);
		ClearSlotGraph(des);
		Update();
	}

	private function FleetSplitAnswer(event:Event):void
	{
//		m_LoadFleetLock=Math.max(0,m_LoadFleetLock-1);
	}

	public function EmpireFleetExtract(fromslot:int,shiptype:int,shipid:uint,cnt:int,itemcnt:int,maxmodulecntps:int,alldestroy:Boolean,race:uint,out:FleetSlot,out_module_cnt:Object):Boolean
	{
		out_module_cnt.cnt=0;

		if(fromslot<0 || fromslot>=Common.FleetSlotMax) return false;

        var slot:FleetSlot=m_FleetSlot[fromslot];
        if(slot.m_Type==Common.ShipTypeNone) return false;
        if (slot.m_Type != shiptype) return false;
		if (shiptype == Common.ShipTypeFlagship && (slot.m_Id | Common.FlagshipIdFlag) != (shipid | Common.FlagshipIdFlag)) return false;
        if(cnt>=slot.m_Cnt) cnt=slot.m_Cnt;
        if (cnt < 0) return false;
		else if (cnt > 0) { }
		else if(!(cnt==0 && alldestroy && slot.m_CntDestroy>0)) return false;

        if(m_FleetFuel<Common.FuelFromHyperspaceNeed) return false;

        m_FleetFuel-=Common.FuelFromHyperspaceNeed;

        out.m_Type=slot.m_Type;
        out.m_Cnt=cnt;
        if(slot.m_CntDestroy) {
        	if (alldestroy) out.m_CntDestroy = slot.m_CntDestroy;
			else out.m_CntDestroy = 0;//out.m_CntDestroy=Math.floor((slot.m_CntDestroy*cnt)/slot.m_Cnt);
            slot.m_CntDestroy-=out.m_CntDestroy;
        }
        slot.m_Cnt-=cnt;
        out.m_HP=slot.m_HP;
        if(out.m_Type==Common.ShipTypeFlagship) {
            out.m_Shield=slot.m_Shield;
            out.m_Id=slot.m_Id;
            out.m_Cnt=1;
            out.m_CntDestroy=0;
        } else {
            slot.m_HP = Common.ShipMaxHP[slot.m_Type];
			if ((race == Common.RaceGrantar) && (slot.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(slot.m_Type))) slot.m_HP += slot.m_HP >> 1;
        }

        var full:Boolean=((slot.m_Cnt<=0) && (slot.m_CntDestroy<=0)) || (out.m_Type==Common.ShipTypeFlagship);

        if((slot.m_ItemType!=Common.ItemTypeNone) && (full || (itemcnt>0))) {
            if(full) itemcnt=slot.m_ItemCnt;
            else if(itemcnt>=slot.m_ItemCnt) itemcnt=slot.m_ItemCnt;
            out.m_ItemType=slot.m_ItemType;
            out.m_ItemCnt=itemcnt;
            slot.m_ItemCnt-=itemcnt;
            if(slot.m_ItemCnt<=0) {
                //slot.m_ItemType=Common.ItemTypeNone;
                slot.m_ItemCnt=0;
            }
        }

        if(full) {
        	slot.Clear();
        }

        if(maxmodulecntps>0 && out.m_Type==Common.ShipTypeTransport) {
            maxmodulecntps *= out.m_Cnt;
            var mcnt:int=FleetSysItemGet(Common.ItemTypeModule);
			
            if (maxmodulecntps > mcnt) maxmodulecntps = mcnt;
			FleetSysItemExtract(Common.ItemTypeModule,maxmodulecntps);
            out_module_cnt.cnt=maxmodulecntps;
        }

        ClearSlotGraph(slot);

		return true;
	}
	
	public function FleetSysItemGet(it:uint):int
	{
		var i:int;
		var fi:FleetItem;
		var cnt:int=0;
		for(i=0;i<Common.FleetItemCnt;i++) {
			fi=EM.m_FormFleetItem.m_FleetItem[i];
			if(fi.m_Type!=it) continue;
			cnt+=fi.m_Cnt;
		}
		return cnt;
	}

	public function FleetSysItemEmpty(formation:int, holdlvl:int, it:uint):int
	{
		var i:int,k:int;
		var fi:FleetItem;

		//var mul:int = Common.FleetFormationCargoMul[formation & 7];
		var mul:int = Common.FleetHoldCargoMulByLvl[(holdlvl & 0xf0) >> 4];

		var ifrom:int = 0;
		if (mul <= 1) ifrom = 8;
		var ito:int = Common.FleetHoldRowByLvl[holdlvl & 0x0f] * 8;

		var itdesc:Item = UserList.Self.GetItem(it & 0xffff);
		if(itdesc==null) return 0;
		var m:int = itdesc.m_StackMax;
		
		var h:int = 0;
		for (i = ifrom; i < ito; i++) {
			fi = EM.m_FormFleetItem.m_FleetItem[i];
			k = 0;
			if (i < 8) {
				if (!fi.m_Type) k = m * mul;
				else if (fi.m_Type != it) continue;
				else k = m * mul - fi.m_Cnt;
			} else {
				if (!fi.m_Type) k = m;
				else if (fi.m_Type != it) continue;
				else k = m - fi.m_Cnt;
			}
			if (k <= 0) continue;
			h += k;
		}
		return h;
	}

	public function FleetSysItemAdd(formation:int, holdlvl:int, it:uint, cnt:int, ttf:Boolean, full:Boolean):int
	{
		var i:int,k:int;
		var fi:FleetItem;

		if (cnt <= 0) return 0;

//		var mul:int = Common.FleetFormationCargoMul[formation & 7];
		var mul:int = Common.FleetHoldCargoMulByLvl[(holdlvl & 0xf0) >> 4];

		var ifrom:int = 0;
		if (mul <= 1) ifrom = 8;
		var ito:int = Common.FleetHoldRowByLvl[holdlvl & 0x0f] * 8;

		var itdesc:Item = UserList.Self.GetItem(it & 0xffff);
		if(itdesc==null) return 0;
		var m:int=itdesc.m_StackMax;

		if(full) {
			var h:int=0;
			for(i=ifrom;i<ito;i++) {
				fi=EM.m_FormFleetItem.m_FleetItem[i];
				k = 0;
				if (i < 8) {
					if(!fi.m_Type) k=m*mul;
					else if(fi.m_Type!=it) continue;
					else k = m*mul - fi.m_Cnt;
				} else {
					if(!fi.m_Type) k=m;
					else if(fi.m_Type!=it) continue;
					else k = m - fi.m_Cnt;
				}
				if(k<=0) continue;
				h+=k;
			}
			if(h<cnt) return 0;
		}

		var addcnt:int = 0;

		for(i=ifrom;(cnt>0) && (i<ito);i++) {
			fi=EM.m_FormFleetItem.m_FleetItem[i];
			if(fi.m_Type!=it) continue;

			if (i < 8) k = m * mul - fi.m_Cnt;
			else k = m - fi.m_Cnt;
			if(k<=0) continue;

			if(k>cnt) k=cnt;
			if(k<=0) continue;

			fi.m_Cnt+=k;

			cnt-=k;
			addcnt+=k;
		}
		
		if (ttf && mul > 1) {
			for(i=0;(cnt>0) && (i<8);i++) {
				fi=EM.m_FormFleetItem.m_FleetItem[i];
				if(fi.m_Type) continue;

				k = m * mul;

				if(k>cnt) k=cnt;
				if(k<=0) continue;

				fi.m_Type=it;
				fi.m_Cnt=k;
				fi.m_Broken=0;

				cnt-=k;
				addcnt+=k;
			}
		}
		
		for(i=ito-1;(cnt>0) && (i>=ifrom);i--) {
			fi=EM.m_FormFleetItem.m_FleetItem[i];
			if(fi.m_Type) continue;

			if (i < 8) k = m * mul;
			else k = m;

			if(k>cnt) k=cnt;
			if(k<=0) continue;

			fi.m_Type=it;
			fi.m_Cnt=k;
			fi.m_Broken=0;

			cnt-=k;
			addcnt+=k;
		}

		return addcnt;
	}

	public function FleetSysItemExtract(it:uint, cnt:int):int
	{
		var i:int,subcnt:int;
		var fi:FleetItem;
		var ret:int=0;

		if(cnt<=0) return 0;

		for(i=Common.FleetItemCnt-1;(i>=0) && (cnt>0);i--) {
			fi=EM.m_FormFleetItem.m_FleetItem[i];
			if(fi.m_Type!=it) continue;

			subcnt=cnt;
			if(subcnt>fi.m_Cnt) subcnt=fi.m_Cnt;
			if(subcnt<=0) continue;

			ret+=subcnt;
			fi.m_Cnt-=subcnt;
			cnt-=subcnt;

			if(fi.m_Cnt>0) continue;

			fi.m_Type=0;
			fi.m_Cnt=0;
			fi.m_Broken=0;
		}

		return ret;
	}

	public function FleetSysItemDestroy(islot:int):Boolean
	{
		var fi:FleetItem;

		if (islot<0 || islot>=Common.FleetItemCnt) return false;

		fi=EM.m_FormFleetItem.m_FleetItem[islot];
		if(fi.m_Type==0) return false;

		fi.m_Type=0;
		fi.m_Cnt=0;
		fi.m_Broken=0;

		return true;
	}

	public function EmpireFleetAdd(slotno:int, shipid:uint, type:int, cnt:int, cntdestroy:int, hp:int, shield:int, itemtype:int, itemcnt:int, cargotype:uint, cargocnt:int, fuel:int, race:uint):int
	{
		var u:int,i:int,score:int,bscore:int;
		var slot:FleetSlot;

		if(cargocnt<=0) { cargotype=0; cargocnt=0; } else if(cargocnt>1000000000) cargocnt=1000000000;
		if (fuel<0) fuel=0; else if(fuel>1000000000) fuel=1000000000;

		var ret:int=0;

	    if(type==Common.ShipTypeNone) return 0;
		if(cnt<=0) return 0;
		if (slotno<-1 || slotno>=SlotCnt()) return 0;
		
        u=slotno;
        if(u<0) {
            for (i = 0; i < SlotCnt(); i++) {
            	slot=m_FleetSlot[i];
                score=0;
                if(slot.m_Type==Common.ShipTypeNone) score=1;//8;
                else if(type==Common.ShipTypeFlagship) continue;
                else if(slot.m_Type!=type) continue;
                else score=2;//1;

                if(slot.m_Type!=Common.ShipTypeNone) {
                    if(slot.m_ItemType==itemtype) score=9;
                    else if(slot.m_ItemType==Common.ItemTypeNone || itemtype==Common.ItemTypeNone) score=9;//7;
                }

                if(u<0 || score>bscore) {
                    u=i;
                    bscore=score;
                }
            }
            if(u<0) return 0;
        }
        
        while(u>=0) {
	        slot=m_FleetSlot[u];
    	    if(slot.m_Type==Common.ShipTypeNone) {}
        	else if(type==Common.ShipTypeFlagship) break;
        	else if(slot.m_Type!=type) break;

        	ret=1;

/*        	if (module) {
				if (m_FleetModule + module > Common.FleetModuleMax) module = Common.FleetModuleMax - m_FleetModule;
				if(module>0) {
					m_FleetModule += module;
				}
			}*/
			if(cargotype!=0) {
				FleetSysItemAdd(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl ,cargotype,cargocnt,false,false);
			}
/*        	if (fuel) {
				if (m_FleetFuel + fuel > 1000000000) fuel = 1000000000 - m_FleetFuel;
				if(fuel>0) {
					m_FleetFuel += fuel;
				}
			}*/

	        if(slot.m_Type==Common.ShipTypeNone) {
    	        slot.m_Id=shipid;
        	    slot.m_Type=type;
            	slot.m_Cnt=cnt;
            	slot.m_CntDestroy=cntdestroy;
	            slot.m_HP=hp;
    	        slot.m_Shield=shield;
        	    slot.m_ItemType=itemtype;
            	slot.m_ItemCnt=itemcnt;
        	} else {
	            slot.m_Cnt+=cnt;
	            slot.m_CntDestroy+=cntdestroy;
	
	            var maxhp:int = Common.ShipMaxHP[type];
				if ((race == Common.RaceGrantar) && (slot.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(slot.m_Type))) maxhp += maxhp >> 1;
	            slot.m_HP-=maxhp-hp;
	            if(slot.m_HP<=0) { slot.m_HP=maxhp+slot.m_HP; slot.m_Cnt--; slot.m_CntDestroy++; }
	            if(slot.m_HP<=0 || slot.m_Cnt<=0) { slot.m_Cnt=1; slot.m_HP=1; }

	            if(itemtype!=Common.ItemTypeNone) {
	                if(slot.m_ItemType==itemtype) {
	                    slot.m_ItemCnt+=itemcnt;
	                } else if(slot.m_ItemType==Common.ItemTypeNone) {
	                    slot.m_ItemType=itemtype;
	                    slot.m_ItemCnt=itemcnt;
	                } else {
	                    ret=2;
	                }
	            }
        	}

			ClearSlotGraph(slot);
        	break;
        }

        return ret;
		
	}

	public function EmpireFleetFuelChange(changeval:int):int
	{
        if(changeval<0) {
            if(m_FleetFuel<=0) return 0;
            if((-changeval)>m_FleetFuel) changeval=-m_FleetFuel;
            if(changeval==0) return 0;
            m_FleetFuel+=changeval;
        } else {
            if(m_FleetFuel+changeval>Common.FleetFuelMax) changeval=Common.FleetFuelMax-m_FleetFuel;
            if(changeval<=0) { changeval=0; return 0; }
            m_FleetFuel+=changeval;
        }
        return changeval;
	}

	public function EmpireFleetEqChange(slotno:int,itemtype:int,changeval:int):int
	{
		if (slotno<0 || slotno>=Common.FleetSlotMax) return 0;
		if (itemtype <= Common.ItemTypeNone) return 0;
		if (itemtype >= Common.ItemTypeCnt) return 0;

		if (changeval == 0) return 0;
		if (changeval > 10000000) changeval = 10000000;

		var slot:FleetSlot = m_FleetSlot[slotno];

		if (changeval < 0) {
			if (slot.m_ItemType != itemtype) {
				changeval = 0;
				return 0;
			} else {
				if (slot.m_ItemCnt <= 0) { changeval = 0; return 0; }
				if (( -changeval) > slot.m_ItemCnt) changeval = -slot.m_ItemCnt;
				if (changeval == 0) return 0;
				slot.m_ItemCnt += changeval;
			}
		} else {
			if (slot.m_ItemType != itemtype) {
				slot.m_ItemType = itemtype;
				slot.m_ItemCnt = 0;
			}
			if (slot.m_ItemCnt + changeval > 10000000) changeval = 10000000 - slot.m_ItemCnt;
			if (changeval <= 0) { changeval = 0; return 0; }
			slot.m_ItemCnt += changeval;
//trace("!!!EmpireFleetEqChange05",slot.m_ItemType,slot.m_ItemCnt);
		}

		return changeval;
	}
	
	public function EmpireFleetCalcMass():int
	{
		var i:int;
		var slot:FleetSlot;
		var m:int = 0;
		
		for (i = 0; i < Common.FleetSlotMax; i++) {
			slot = m_FleetSlot[i];
			if (slot.m_Type == 0) continue;
			
			m += EM.ShipMass(Server.Self.m_UserId, slot.m_Id, slot.m_Type) * slot.m_Cnt;
		}

		return m;
	}
	
	public function FleetIsEmpty():Boolean
	{
		return false;
/*		var i:int;

		for(i=0;i<m_FleetSlot.length;i++) {
			var slot:FleetSlot=m_FleetSlot[i];
			if(slot.m_Type!=Common.ShipTypeNone) return false;
		}
		return true;*/
	}
	
	public function onItemOpenClick(e:Event):void
	{
//		m_ItemOpen = !m_ItemOpen;
		if (EM.m_FormFleetItem.visible) EM.m_FormFleetItem.Hide();
		else EM.m_FormFleetItem.Show();
		Update();
	}
	
	public function onMenuClick(e:Event):void
	{
		var obj:Object;
		//EM.CloseForModal();
		EM.m_FormMenu.Clear();

		EM.m_FormMenu.Add(Common.Txt.FormFleetBarAutoPilot, AutoPilot).Check = m_AutoPilot;
		EM.m_FormMenu.Add(Common.Txt.FormFleetBarAutoGive, AutoGive).Check = m_AutoGive;

		EM.m_FormMenu.Add();
		
		EM.m_FormMenu.Add(Common.Txt.FormFleetBarLoadFuel, MsgLoadFuel);
		EM.m_FormMenu.Add(Common.Txt.FormFleetBarBuyFuel, MsgBuyFuel);
		
		obj=EM.m_FormMenu.Add(Common.Txt.FormFleetBarReturn);
		if(FleetIsEmpty()) obj.Disable=true;
		else obj.Fun=MsgReturn;

		//obj=EM.m_FormMenu.Add(Common.Txt.FormFleetBarFleetType,MsgFleetType);
		
//		obj=EM.m_FormMenu.Add(Common.Txt.FormFleetBarCotlMove);
//		if(FleetIsEmpty()) obj.Disable=true;
//		else obj.Fun=MsgCotlMove;
		
//		obj=EM.m_FormMenu.Add(Common.Txt.FormFleetBarCotlMovePay);
//		if(FleetIsEmpty()) obj.Disable=true;
//		else obj.Fun = MsgCotlMovePay;
		
		if ((m_HoldLvl & 0x0f) < (Common.FleetHoldLvlCnt - 1)) {
			EM.m_FormMenu.Add(Common.Txt.FormFleetBarBuyHoldLvl, MsgBuyHoldLvl);
		}

		if (((m_HoldLvl & 0xf0) >> 4) < (Common.FleetHoldCargoLvlCnt - 1)) {
			EM.m_FormMenu.Add(Common.Txt.FormFleetBarBuyHoldCargoLvl, MsgBuyHoldCargoLvl);
		}

		if (EM.m_UserAccess & User.AccessGalaxyJump) {
			EM.m_FormMenu.Add("Galaxy jump", MsgEditorJump);
		}
		if (EM.m_UserAccess & User.AccessGalaxyOps) {
			EM.m_FormMenu.Add("Save quest in server", MsgSaveQuest);
		}
		
		EM.m_FormMenu.SetButOpen(m_ButMenu);
		EM.m_FormMenu.Show(x+m_ButMenu.x,y+m_ButMenu.y,x+m_ButMenu.x+20,y+m_ButMenu.y+20);
	}
	
	private function AutoPilot(...args):void
	{
		m_AutoPilot = !m_AutoPilot;
		AutoPilotSave();
	}
	
	private function AutoGive(...args):void
	{
		m_AutoGive = !m_AutoGive;
		AutoGiveSave();
	}

	private function MsgSaveQuest(...args):void
	{
		EmpireMap.Self.m_FormInput.Init();
		EmpireMap.Self.m_FormInput.AddLabel("Save quest in server");
		EmpireMap.Self.m_FormInput.AddInput("", 128, true, Server.Self.m_Lang, true);
		EmpireMap.Self.m_FormInput.Run(MsgSaveQuestSend,"Send");
	}

	private function MsgSaveQuestSend(...args):void
	{
		var name:String = EmpireMap.Self.m_FormInput.GetStr(0);

		QEManager.RunByName(name, null);
		if (QEManager.m_NameToId[name] != undefined) {
			QEManager.m_NameToId[name].m_SaveInServer = true;
		}
	}

	private function MsgEditorJump(...args):void
	{
		EmpireMap.Self.FI.Init(250, 200);
		EmpireMap.Self.FI.caption = "Galaxy jump";
		EmpireMap.Self.FI.AddInput("", 64, true, Server.Self.m_Lang, true);
		EmpireMap.Self.FI.Run(MsgEditorJumpSend, "Jump", "Cancel");
	}

	private function MsgEditorJumpSend(...args):void
	{
		var t:int;
		var src:String = BaseStr.Trim(EmpireMap.Self.FI.GetStr(0));

/*		var x:int = 0, y:int = 0;
		var userid:uint = EM.m_FormHist.FindUser(str);
		var cotlid:uint = 0;
		if (userid == 0) cotlid = EM.m_FormHist.FindCotlDefault(str);
		if (userid == 0 && cotlid == 0) {
			str = BaseStr.Replace(str, "\t", " ");
			str = BaseStr.Replace(str, "\n", " ");
			str = BaseStr.Replace(str, ",", " ");
			str = BaseStr.Replace(str, ";", " ");
			str = BaseStr.Trim(BaseStr.TrimRepeat(str));

			var ar:Array = str.split(" ");
			
			if (ar.length <= 0) return;
			else if (ar.length <= 1) cotlid = int(ar[0]);
			else { x = int(ar[0]); y = int(ar[1]); }
		}*/

		var x:int = 0, y:int = 0;
		var cotlid:uint = 0;
		var userid:uint = 0;

		cotlid = EM.TxtFind(EM.m_Txt, 1, src);
		if (cotlid == 0) {
			t = src.indexOf(":");
			if (t < 0) {
				var user:User = UserList.Self.FindUser(src);
				if (user != null) userid = user.m_Id;
				else {
					src = BaseStr.Replace(src, "\t", " ");
					src = BaseStr.Replace(src, "\n", " ");
					src = BaseStr.Replace(src, ",", " ");
					src = BaseStr.Replace(src, ";", " ");
					src = BaseStr.Trim(BaseStr.TrimRepeat(src));

					var ar:Array = src.split(" ");

					if (ar.length <= 0) return;
					else if (ar.length <= 1) cotlid = int(ar[0]);
					else { x = int(ar[0]); y = int(ar[1]); }
				}
			} else {
				userid = BaseStr.ParseUint(src.substr(0, t));
			}
		}
		

		//trace(userid, cotlid, x, y);
		var ship:SpaceFleet = EM.HS.SP.EntityFind(SpaceEntity.TypeFleet, EmpireMap.Self.m_RootFleetId) as SpaceFleet;
		if (ship == null) return;
		ship.m_Anm++;
		ship.m_LoadAfterAnm = ship.m_Anm;
		ship.m_LoadAfterAnm_Timer = Common.GetTime();

		Server.Self.QuerySS("emfleetspecial", "&type=10&userid=" + userid.toString() + "&cotlid=" + cotlid.toString() + "&x=" + x.toString() + "&y=" + y.toString() + "&anm=" + ship.m_Anm.toString(), AnswerSpecial, false);
	}

	private function MsgLoadFuel(...args):void
	{
		EmpireMap.Self.m_FormInput.Init();
		EmpireMap.Self.m_FormInput.AddLabel(Common.Txt.FormFleetBarLoadFuelTxt);
		EmpireMap.Self.m_FormInput.AddInput("1000",9,true,0);
		EmpireMap.Self.m_FormInput.Run(MsgLoadFuelSend,Common.Txt.FormFleetBarLoadFuelOk);
	}

	private function MsgLoadFuelSend():void
	{
		var ac:Action=new Action(EM);
		ac.ActionFleetFuel(EmpireMap.Self.m_FormInput.GetInt(0));
		EM.m_LogicAction.push(ac);
	}

	private var m_InputLabel:TextField=null;

	private function MsgBuyFuel(...args):void
	{
		var ti:TextInput;
		//FormMessageBox.Run(Common.Txt.FormFleetBarBuyFuelQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionBuyFuel);
		EmpireMap.Self.m_FormInput.Init(400);
		EmpireMap.Self.m_FormInput.AddLabel(Common.Txt.FormFleetBarBuyFuelCaption,15);

		EmpireMap.Self.m_FormInput.AddLabel(Common.Txt.FormFleetBarBuyFuelCost+":");
		EmpireMap.Self.m_FormInput.Col();

		var cnt:int = Common.FleetFuelMax - m_FleetFuel;
		if (cnt < 0) cnt = 0;
		else {
			cnt = Math.floor(cnt / Common.FuelCostEGM);
		}

		ti=EmpireMap.Self.m_FormInput.AddInput(cnt.toString(),8,true,0);
		ti.addEventListener(Event.CHANGE,ChangeBuyFuel);

		m_InputLabel=EmpireMap.Self.m_FormInput.AddLabel(Common.Txt.FormFleetBarBuyFuelCnt+Common.Txt.FormFleetBarBuyFuelCnt);
		
		ChangeBuyFuel(null);
		
		EmpireMap.Self.m_FormInput.ColAlign();
		EmpireMap.Self.m_FormInput.Run(ActionBuyFuel,StdMap.Txt.ButYes,StdMap.Txt.ButNo);
	}

	private function ChangeBuyFuel(e:Event):void
	{
		var v:int=EmpireMap.Self.m_FormInput.GetInt(0);
		if(v<0) v=0;
		else if(v>100000000) v=100000000;

		var str:String=Common.Txt.FormFleetBarBuyFuelCnt;
		str = BaseStr.Replace(str, "<Sum>", BaseStr.FormatBigInt(v));
		str = BaseStr.Replace(str, "<Cnt>", BaseStr.FormatBigInt(v * Common.FuelCostEGM));

		m_InputLabel.htmlText=str;
	}

	private function ActionBuyFuel():void
	{
		var v:int=EmpireMap.Self.m_FormInput.GetInt(0);
		if(v<=0) return;
		else if(v>100000000) v=100000000;

		Server.Self.QueryHS("emfleetspecial","&type=1&val="+v.toString(),AnswerSpecial,false);
	}

	public function AnswerSpecial(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;
		
		var err:uint=buf.readUnsignedByte();

		if(!err) EM.m_UserVersion=0;
		else if (err == Server.ErrorNoEnoughEGM) { FormMessageBox.Run(Common.Txt.NoEnoughEGM2, Common.Txt.ButClose); }
		else if (err == Server.ErrorNoEnoughMoney) { FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose); }
		else EM.ErrorFromServer(err);
	}

	private function MsgReturn(...args):void
	{
		if ((!EM.m_EmpireEdit) && (m_ReturnCooldown > EM.GetServerGlobalTime())) {
			var str:String = Common.Txt.FormFleetBarReturnCooldown;
			str = BaseStr.Replace(str, "<Val>", Common.FormatPeriodLong((m_ReturnCooldown - EM.GetServerGlobalTime()) / 1000, true, 3));
			FormMessageBox.Run(str, Common.Txt.ButClose);
		} else {
			FormMessageBox.Run(Common.Txt.FormFleetBarReturnQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionReturn);
		}
	}

	private function ActionReturn():void
	{
		Server.Self.QuerySS("emfleetspecial", "&type=2", AnswerSpecial, false);
	}
	
	//private function MsgFleetType(...args):void
	//{
	//	EM.m_FormFleetType.Show();
	//}

/*	private function MsgCotlMove(...args):void
	{
		if ((EM.m_FormFleetBar.m_Formation & 7) == 3 || (EM.m_FormFleetBar.m_Formation & 7) == 4) {
			FormMessageBox.Run(BaseStr.FormatTag(Common.Txt.FormFleetTypeNoCotlMove), Common.Txt.ButClose);
			return;
		}
		
		if((!EM.m_EmpireEdit) && (m_CotlMoveCooldown>EM.GetServerTime())) {
			var str:String=Common.Txt.FormFleetBarCotlMoveCooldown;
			str=BaseStr.Replace(str,"<Val>",Common.FormatPeriodLong((m_CotlMoveCooldown-EM.GetServerTime())/1000,true,3));
			FormMessageBox.Run(BaseStr.FormatTag(str),Common.Txt.ButClose);
		} else {
			FormMessageBox.Run(BaseStr.FormatTag(Common.Txt.FormFleetBarCotlMoveQuery),StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionCotlMove);
		}
	}

	private function ActionCotlMove():void
	{
		Server.Self.QueryHS("emfleetspecial","&type=3",AnswerSpecial,false);
	}

	private function MsgCotlMovePay(...args):void
	{
		if ((EM.m_FormFleetBar.m_Formation & 7) == 3 || (EM.m_FormFleetBar.m_Formation & 7) == 4) {
			FormMessageBox.Run(BaseStr.FormatTag(Common.Txt.FormFleetTypeNoCotlMove), Common.Txt.ButClose);
			return;
		}

		if((!EM.m_EmpireEdit) && (m_CotlMoveCooldownPay>EM.GetServerTime())) {
			var str:String=Common.Txt.FormFleetBarCotlMoveCooldownPay;
			str=BaseStr.Replace(str,"<Val>",Common.FormatPeriodLong((m_CotlMoveCooldownPay-EM.GetServerTime())/1000,true,3));
			FormMessageBox.Run(BaseStr.FormatTag(str),Common.Txt.ButClose);
		} else {
			FormMessageBox.Run(BaseStr.FormatTag(Common.Txt.FormFleetBarCotlMoveQueryPay),StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionCotlMovePay);
		}
	}

	private function ActionCotlMovePay():void
	{
		Server.Self.QueryHS("emfleetspecial","&type=5",AnswerSpecial,false);
	}*/

	public function MenuSlot():void
	{
		var obj:Object;
		var slot:FleetSlot;

		if(m_SlotMouse<0) return;
		slot = m_FleetSlot[m_SlotMouse];
		if (slot.m_SlotN == null) return;

		EM.FormHideAll();
		EM.m_FormMenu.Clear();

//		if(slot.m_Type!=Common.ShipTypeNone) EM.m_FormMenu.Add(Common.Txt.ButGive,MsgGive);
		if (EM.m_EmpireEdit) EM.m_FormMenu.Add(Common.TxtEdit.FleetAddShip, MsgAddShip);
		if (slot.m_Type != 0) EM.m_FormMenu.Add(Common.Txt.FormFleetBarDestroyShip, MsgDestroyShip);

		EM.m_FormMenu.SetCaptureMouseMove(true);
		EM.m_FormMenu.Show(x+slot.m_SlotN.x,y+slot.m_SlotN.y-2,x+slot.m_SlotN.x+1,y+slot.m_SlotN.y+SlotSize+4,1,-1);
	}

	private function MsgGive(...args):void
	{
		EM.FormHideAll();
		//EM.m_FormRes.Show(0,0,-1,m_SlotMouse);
	}

	private function MsgAddShip(...args):void
	{
		var slot:FleetSlot;

		if(m_SlotMouse<0) return;
		slot=m_FleetSlot[m_SlotMouse];

		EmpireMap.Self.m_FormInput.Init();
		EmpireMap.Self.m_FormInput.AddLabel(Common.TxtEdit.FleetAddShip,18);

		EmpireMap.Self.m_FormInput.AddLabel(Common.TxtEdit.ShipType+":");
		EmpireMap.Self.m_FormInput.Col();
		EmpireMap.Self.m_FormInput.AddComboBox();
		EmpireMap.Self.m_FormInput.AddItem(Common.ShipName[Common.ShipTypeTransport],Common.ShipTypeTransport,Common.ShipTypeTransport==slot.m_Type);
		EmpireMap.Self.m_FormInput.AddItem(Common.ShipName[Common.ShipTypeCorvette],Common.ShipTypeCorvette,Common.ShipTypeCorvette==slot.m_Type);
		EmpireMap.Self.m_FormInput.AddItem(Common.ShipName[Common.ShipTypeCruiser],Common.ShipTypeCruiser,Common.ShipTypeCruiser==slot.m_Type);
		EmpireMap.Self.m_FormInput.AddItem(Common.ShipName[Common.ShipTypeDreadnought],Common.ShipTypeDreadnought,Common.ShipTypeDreadnought==slot.m_Type);
		EmpireMap.Self.m_FormInput.AddItem(Common.ShipName[Common.ShipTypeInvader],Common.ShipTypeInvader,Common.ShipTypeInvader==slot.m_Type);
		EmpireMap.Self.m_FormInput.AddItem(Common.ShipName[Common.ShipTypeDevastator],Common.ShipTypeDevastator,Common.ShipTypeDevastator==slot.m_Type);

		EmpireMap.Self.m_FormInput.AddLabel(Common.Txt.Count+":");
		EmpireMap.Self.m_FormInput.Col();
		EmpireMap.Self.m_FormInput.AddInput("999",6,true,0);

		EmpireMap.Self.m_FormInput.AddLabel(Common.TxtEdit.Module+":");
		EmpireMap.Self.m_FormInput.Col();
		EmpireMap.Self.m_FormInput.AddInput("0",7,true,0);

		EmpireMap.Self.m_FormInput.ColAlign();
		EmpireMap.Self.m_FormInput.Run(ActionAddShip,Common.TxtEdit.Add);
	}

	private function ActionAddShip():void
	{
		var type:int=EmpireMap.Self.m_FormInput.GetInt(0);
		var cnt:int=EmpireMap.Self.m_FormInput.GetInt(1);
		var module:int=EmpireMap.Self.m_FormInput.GetInt(2);
		
		Server.Self.Query("emfleetspecial","&type=4&s="+m_SlotMouse.toString()+"&t="+type.toString()+"&cnt="+cnt.toString()+"&m="+module.toString(),AnswerSpecial,false);
	}
	
	private function MsgDestroyShip(...args):void
	{
		FormMessageBox.Run(Common.Txt.FormFleetBarDestroyShipQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionDestroyShip);		
	}
	
	private function ActionDestroyShip():void
	{
		var slot:FleetSlot;

		if(m_SlotMouse<0) return;
		slot=m_FleetSlot[m_SlotMouse];

		Server.Self.Query("emfleetspecial", "&type=11&s=" + m_SlotMouse.toString() + "&t=" + slot.m_Type.toString() + "&id=" + slot.m_Id.toString(), AnswerSpecial, false);
	}
	
	private function MsgBuyHoldLvl(...args):void
	{
		var str:String = Common.Txt.FormFleetBarBuyHoldLvlQuery;
		str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(Common.FleetHoldLvlCost[(m_HoldLvl & 0x0f) + 1]));
		FormMessageBox.Run(str,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionBuyHoldLvl);		
	}
	
	private function ActionBuyHoldLvl():void
	{
		if (m_FleetMoney < Common.FleetHoldLvlCost[(m_HoldLvl & 0x0f) + 1]) {
			FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose);
			return;
		}
		
		if (EM.m_FormFleetItem.visible) EM.m_FormFleetItem.Hide();
		
		m_HoldLvl += 1;

		Server.Self.Query("emfleetspecial", "&type=8", AnswerSpecial, false);
	}
	
	private function MsgBuyHoldCargoLvl(...args):void
	{
		var str:String = Common.Txt.FormFleetBarBuyHoldCargoLvlQuery;
		str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(Common.FleetHoldCargoLvlCost[((m_HoldLvl & 0xf0) >> 4) + 1]));
		str = BaseStr.Replace(str, "<Mul>", BaseStr.FormatBigInt(Common.FleetHoldCargoMulByLvl[((m_HoldLvl & 0xf0) >> 4) + 1]));
		FormMessageBox.Run(str, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionBuyHoldCargoLvl);
	}
	
	private function ActionBuyHoldCargoLvl():void
	{
		if (m_FleetMoney < Common.FleetHoldCargoLvlCost[((m_HoldLvl & 0xf0) >> 4) + 1]) {
			FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose);
			return;
		}
		
		if (EM.m_FormFleetItem.visible) EM.m_FormFleetItem.Hide();
		
		m_HoldLvl += 1 << 4;

		Server.Self.Query("emfleetspecial", "&type=14", AnswerSpecial, false);
	}

	public function onTechnicianClick(e:MouseEvent):void
	{
		var ac:Action = new Action(EM);
		ac.ActionFleetSpecial(10,1);
		EM.m_LogicAction.push(ac);
	}

	public function onNavigatorClick(e:MouseEvent):void
	{
		var ac:Action = new Action(EM);
		ac.ActionFleetSpecial(10,2);
		EM.m_LogicAction.push(ac);
	}
	
	private var m_AutoPilotUpdateTime:Number = 0;
	
	public function AutoPilotUpdate():void
	{
		var i:int;
		var obj:Object;
		var ac:Action;
		
		if (EM.m_AutoOff) return;
		if (!m_AutoPilot) return;

		if ((m_AutoPilotUpdateTime + 10 * 1000) > Common.GetTime()) return;
		m_AutoPilotUpdateTime = Common.GetTime();

		var on:Boolean = (EM.m_ViewBattleTimeSelfWithUser + 60 * 1000) > Common.GetTime();
		if (!on) {
			for (i = 0; i < EM.m_FormInfoBar.m_TicketList.length; i++) {
				obj = EM.m_FormInfoBar.m_TicketList[i];
				if (obj.Type == Common.TicketTypeAttack && obj.State == 0 && (obj.Flag & 0x80000000) == 0) { on = true; break; }
			}
		}

		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;

		var msg:Boolean = false;
		if (on) {
			if ((user.m_IB1_Type != 0) && (user.m_IB1_Type & 0x8000) == 0) {
				ac = new Action(EM);
				ac.ActionFleetSpecial(10,1);
				EM.m_LogicAction.push(ac);
				msg = true;
			}

			if ((user.m_IB2_Type != 0) && (user.m_IB2_Type & 0x8000) == 0) {
				ac = new Action(EM);
				ac.ActionFleetSpecial(10,2);
				EM.m_LogicAction.push(ac);
				msg = true;
			}
			if (msg) EM.m_FormHint.Show(Common.Txt.WarningAutoPilotOn, Common.WarningHideTime);

		} else {
			if ((user.m_IB1_Type != 0) && (user.m_IB1_Type & 0x8000) != 0) {
				ac = new Action(EM);
				ac.ActionFleetSpecial(10,1);
				EM.m_LogicAction.push(ac);
				msg = true;
			}

			if ((user.m_IB2_Type != 0) && (user.m_IB2_Type & 0x8000) != 0) {
				ac = new Action(EM);
				ac.ActionFleetSpecial(10,2);
				EM.m_LogicAction.push(ac);
				msg = true;
			}
			if (msg) EM.m_FormHint.Show(Common.Txt.WarningAutoPilotOff, Common.WarningHideTime);

		}
	}

	public function AutoPilotSave():void
	{
		var so:SharedObject = SharedObject.getLocal("EGEmpireSet");
		so.data.AutoPilot=m_AutoPilot;
	}

	public function AutoPilotLoad():void
	{
		var so:SharedObject = SharedObject.getLocal("EGEmpireSet");
		if (so.size == 0) return;
		if(so.data.AutoPilot!=undefined) m_AutoPilot=so.data.AutoPilot;
	}

	public function AutoGiveSave():void
	{
		var so:SharedObject = SharedObject.getLocal("EGEmpireSet");
		so.data.AutoGive=m_AutoGive;
	}

	public function AutoGiveLoad():void
	{
		var so:SharedObject = SharedObject.getLocal("EGEmpireSet");
		if (so.size == 0) return;
		if(so.data.AutoGive!=undefined) m_AutoGive=so.data.AutoGive;
	}
}

}
