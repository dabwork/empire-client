package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;
import fl.motion.AdjustColor;
import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.text.*;
import flash.utils.*;

import flash.geom.Point;

public class FormPlanet extends Sprite
{
	private var EM:EmpireMap;

	public static const SizeX:int = 390;
	public static const SizeYMin:int = 550;

	public var m_SizeY:int = 550;

	public static const PlanetGridCntX:int = 4;
	public static const PlanetGridCntY:int = 4;
	public static const PlanetGridCntXY:int = 16;

	public static const m_GridStartX:int = SizeX >> 1;
	public var m_GridStartY:int = 140;

	public static const PlanetGridToCell_Large:Array = new Array(PlanetGridCntXY);
	public static const PlanetCellToGrid_Large:Array = new Array(Planet.PlanetCellCnt);

	public static const PlanetGridToCell_Small:Array = new Array(PlanetGridCntXY);
	public static const PlanetCellToGrid_Small:Array = new Array(Planet.PlanetCellCnt);

	public var m_Cell:Array = new Array(Planet.PlanetCellCnt);
	public var m_BuildSlot:Array = new Array();
	public var m_Item:Array = new Array();

	public static const BuildSlotOffX:int = 15;
	public var m_BuildSlotOffY:int = 385;
	public static const BuildSlotSize:int = 60;

	public static const ItemSlotSize:int = 44;

	// 121 72
	public static const CellHalfSizeX:int = 59;
	public static const CellHalfSizeY:int = 35;

	public var m_Frame:Sprite=new GrFrame();
	public var m_Title:TextField=new TextField();
	public var m_SubTitle:TextField = new TextField();
	public var m_LabelCnt:TextField = new TextField();
	public var m_EditCnt:TextInput = new TextInput();
	public var m_ButClose:Button = new Button();
	public var m_ButBuild:Button = new Button();
	public var m_ButBuildMax:Button = new Button();
	public var m_ButMenu:SimpleButton = new MMButOptions();

	public var m_BuildingLayer:Sprite = new Sprite();
	public var m_BuildSlotLayer:Sprite = new Sprite();
	public var m_BuildShipLayer:Sprite = new Sprite();
	public var m_BuildTxtLayer:Sprite = new Sprite();
	public var m_IconEnergy:Sprite=new IconEnergy();
	public var m_TxtEnergy:TextField=new TextField();
	public var m_IconEngineer:Sprite=new IconPlanetEngineer();
	public var m_TxtEngineer:TextField=new TextField();
	public var m_IconMachinery:Sprite=new IconPlanetMachinery();
	public var m_TxtMachinery:TextField=new TextField();

	public var m_SectorX:int = 0;
	public var m_SectorY:int = 0;
	public var m_PlanetNum:int = 0;

	public var m_CI_Live_Water0:BitmapData = new Live_Water0(0, 0);
	public var m_CI_Live_Tree0:BitmapData = new Live_Tree0(0, 0);
	public var m_CI_Live_Tree1:BitmapData = new Live_Tree1(0, 0);
	public var m_CI_Live_Grass0:BitmapData = new Live_Grass0(0, 0);
	public var m_CI_Live_Grass1:BitmapData = new Live_Grass1(0, 0);
	public var m_CI_Live_Grass2:BitmapData = new Live_Grass2(0, 0);
	public var m_CI_Live_Field0:BitmapData = new Live_Field0(0, 0);
	public var m_CI_Live_Field1:BitmapData = new Live_Field1(0, 0);
	
	public var m_CI_Ice_Std0:BitmapData = new Ice_Std0(0, 0);
	
	public var m_CI_Lava_Std0:BitmapData = new Lava_Std0(0, 0);
	public var m_CI_Lava_Std1:BitmapData = new Lava_Std1(0, 0);
	public var m_CI_Lava_Std2:BitmapData = new Lava_Std2(0, 0);
	public var m_CI_Lava_Std3:BitmapData = new Lava_Std3(0, 0);

	public var m_CI_Moon_Std0:BitmapData = new Moon_Std0(0, 0);
	public var m_CI_Moon_Std1:BitmapData = new Moon_Std1(0, 0);
	public var m_CI_Moon_Std2:BitmapData = new Moon_Std2(0, 0);
	public var m_CI_Moon_Std3:BitmapData = new Moon_Std3(0, 0);

	public var m_CI_Moon_Bad0:BitmapData = new Moon_Bad0(0, 0);

	public var m_BuildSlotMouse:int = -1;
	public var m_BuildType:int = 0;
	public var m_BuildId:uint = 0;
	
	public var m_ItemSlotMouse:int = -1;
	public var m_ItemSlotDown:int = -1;
	
	public var m_BuildAtSDM:Boolean = false;
	
	public var m_CellMouse:int = -1;
	
	public var m_Timer:Timer = new Timer(1000);

	public var m_ShowFirst:Boolean = true;
	
	public var m_ShowTer:Boolean = false;

	public function FormPlanet(map:EmpireMap)
	{
		EM = map;
		
		PlanetGridCellInit();
		
		m_Timer.addEventListener("timer", Takt);
		
		m_Frame.width = SizeX;
		m_Frame.height = SizeYMin;
		addChild(m_Frame);
		
		m_Title.x = 10;
		m_Title.y = 5;
		m_Title.width = 1;
		m_Title.height = 1;
		m_Title.type = TextFieldType.DYNAMIC;
		m_Title.selectable = false;
		m_Title.border = false;
		m_Title.background = false;
		m_Title.multiline = false;
		m_Title.autoSize = TextFieldAutoSize.LEFT;
		m_Title.antiAliasType = AntiAliasType.ADVANCED;
		m_Title.gridFitType = GridFitType.PIXEL;
		m_Title.defaultTextFormat = new TextFormat("Calibri", 16, 16776960);
		m_Title.embedFonts = true;
		addChild(m_Title);
		
		m_SubTitle.x = 10;
		m_SubTitle.y = 25;
		m_SubTitle.width = 1;
		m_SubTitle.height = 1;
		m_SubTitle.type = TextFieldType.DYNAMIC;
		m_SubTitle.selectable = false;
		m_SubTitle.border = false;
		m_SubTitle.background = false;
		m_SubTitle.multiline = true;
		m_SubTitle.autoSize = TextFieldAutoSize.LEFT;
		m_SubTitle.antiAliasType = AntiAliasType.ADVANCED;
		m_SubTitle.gridFitType = GridFitType.PIXEL;
		m_SubTitle.defaultTextFormat = new TextFormat("Calibri", 13, 16777215);
		m_SubTitle.embedFonts = true;
		addChild(m_SubTitle);
		
		addChild(m_IconEnergy);
		
		m_TxtEnergy.width = 1;
		m_TxtEnergy.height = 1;
		m_TxtEnergy.type = TextFieldType.DYNAMIC;
		m_TxtEnergy.selectable = false;
		m_TxtEnergy.border = false;
		m_TxtEnergy.background = false;
		m_TxtEnergy.multiline = true;
		m_TxtEnergy.autoSize = TextFieldAutoSize.LEFT;
		m_TxtEnergy.antiAliasType = AntiAliasType.ADVANCED;
		m_TxtEnergy.gridFitType = GridFitType.PIXEL;
		m_TxtEnergy.defaultTextFormat = new TextFormat("Calibri", 13, 16777215);
		m_TxtEnergy.embedFonts = true;
		addChild(m_TxtEnergy);

		addChild(m_IconEngineer);
		
		m_TxtEngineer.width = 1;
		m_TxtEngineer.height = 1;
		m_TxtEngineer.type = TextFieldType.DYNAMIC;
		m_TxtEngineer.selectable = false;
		m_TxtEngineer.border = false;
		m_TxtEngineer.background = false;
		m_TxtEngineer.multiline = true;
		m_TxtEngineer.autoSize = TextFieldAutoSize.LEFT;
		m_TxtEngineer.antiAliasType = AntiAliasType.ADVANCED;
		m_TxtEngineer.gridFitType = GridFitType.PIXEL;
		m_TxtEngineer.defaultTextFormat = new TextFormat("Calibri", 13, 16777215);
		m_TxtEngineer.embedFonts = true;
		addChild(m_TxtEngineer);

		addChild(m_IconMachinery);
		
		m_TxtMachinery.width = 1;
		m_TxtMachinery.height = 1;
		m_TxtMachinery.type = TextFieldType.DYNAMIC;
		m_TxtMachinery.selectable = false;
		m_TxtMachinery.border = false;
		m_TxtMachinery.background = false;
		m_TxtMachinery.multiline = true;
		m_TxtMachinery.autoSize = TextFieldAutoSize.LEFT;
		m_TxtMachinery.antiAliasType = AntiAliasType.ADVANCED;
		m_TxtMachinery.gridFitType = GridFitType.PIXEL;
		m_TxtMachinery.defaultTextFormat = new TextFormat("Calibri", 13, 16777215);
		m_TxtMachinery.embedFonts = true;
		addChild(m_TxtMachinery);

		Common.UIStdTextField(m_LabelCnt, 13, 16777215);
		m_LabelCnt.text = Common.Txt.Count + ":";
		addChild(m_LabelCnt);
		
		Common.UIStdInput(m_EditCnt);
		m_EditCnt.restrict = "0-9";
		m_EditCnt.textField.maxChars = 3;
		addChild(m_EditCnt);
		
		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width = 90;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		addChild(m_ButClose);

		m_ButBuild.label = Common.Txt.Build;
		m_ButBuild.width = 80;
		Common.UIStdBut(m_ButBuild);
		m_ButBuild.addEventListener(MouseEvent.CLICK, clickBuild);
		addChild(m_ButBuild);

		m_ButBuildMax.label = "MAX";
		m_ButBuildMax.width = 40;
		Common.UIStdBut(m_ButBuildMax);
		m_ButBuildMax.addEventListener(MouseEvent.CLICK, clickBuildMax);
		addChild(m_ButBuildMax);

		m_ButMenu.x = SizeX - m_ButMenu.width - 5;
		m_ButMenu.y = 3;
		addChild(m_ButMenu);

		addChild(m_BuildingLayer);
		addChild(m_BuildSlotLayer);
		addChild(m_BuildShipLayer);
		addChild(m_BuildTxtLayer);

		m_EditCnt.addEventListener(ComponentEvent.ENTER, clickBuild);
		m_EditCnt.addEventListener(Event.CHANGE, BuildChangeCnt);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
		addEventListener(MouseEvent.CLICK, onMouseClick);
		addEventListener(MouseEvent.DOUBLE_CLICK, onDblClick);

		EM.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler,false,1);
		
		doubleClickEnabled = true;
		m_BuildingLayer.mouseEnabled = false;
		m_BuildingLayer.mouseChildren = false;
		m_BuildSlotLayer.mouseEnabled = false;
		m_BuildSlotLayer.mouseChildren = false;
		m_BuildShipLayer.mouseEnabled = false;
		m_BuildShipLayer.mouseChildren = false;
		m_BuildTxtLayer.mouseEnabled = false;
		m_BuildTxtLayer.mouseChildren = false;
		m_Frame.mouseEnabled = false;
		m_Frame.mouseChildren = false;

		return;
	}

	public function PlanetGridCellInit():void
	{
		var x:int, y:int;
		var l:int = 0;
		var s:int = 0;
		var u:int = 0;

		for (y = 0; y < PlanetGridCntY; y++) {
			for (x = 0; x < PlanetGridCntX; x++, u++) {
				if(	(x==0 && y==0) ||
					(x==3 && y==0) ||
					(x==0 && y==3) ||
					(x==3 && y==3)
					)
				{
					PlanetGridToCell_Large[u] = -1;
				} else {
					PlanetGridToCell_Large[u] = l;
					PlanetCellToGrid_Large[l] = u;
					l++;
				}
				if(	(x==0 && y==0) ||
					(x==3 && y==0) ||
					(x==0 && y==3) ||
					(x == 3 && y == 3) ||
					(x >= 3) ||
					(y >= 3)
					)
				{
					PlanetGridToCell_Small[u] = -1;
				} else {
					PlanetGridToCell_Small[u] = s;
					PlanetCellToGrid_Small[s] = u;
					s++;
				}
			}
		}
		if (l != Planet.PlanetCellCnt) throw Error("");
		if (s != Planet.PlanetCellCnt - 4) throw Error("");
		if (u != PlanetGridCntXY) throw Error("");
	}

	protected function onMouseOutHandler(event:MouseEvent) : void
	{
		if (FormMessageBox.Self.visible) return;
		if (EM.m_FormInput.visible) return;
		if (EM.m_FormMenu.visible) return;
		if (EM.m_FormConstruction.visible) return;

		if (m_ItemSlotDown >= 0 && -1 != m_ItemSlotDown)
		{
			EM.m_Info.Hide();
			EM.m_MoveItem.Begin(1, m_ItemSlotDown);
			m_ItemSlotDown = -1;
			m_ItemSlotMouse = -1;
			Update();
			return;
		}

		if(m_ItemSlotMouse!=-1 || m_BuildSlotMouse!=-1 || m_CellMouse!=-1) {
			m_ItemSlotMouse = -1;
			m_ItemSlotDown = -1;
			m_BuildSlotMouse = -1;
			m_CellMouse = -1;
			Update();
		}

		return;
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<SizeX && mouseY>=0 && mouseY<m_SizeY) return true;
		return false;
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

	public function StageResize():void
	{
//		if (!m_ShowFirst && EmpireMap.Self.IsResize()) {
//		}
		if (!m_ShowFirst) {
			x = 100;// (stage.stageWidth >> 1) - (SizeX >> 1);
			y = 50;// (stage.stageHeight >> 1) - (m_SizeY >> 1);
		}
	}

	public function Show(sx:int, sy:int, planetnum:int) : void
	{
		var i:int;
		
		EM.FloatTop(this);
		
		EM.m_FormConstruction.m_TypeCur = 0;

		m_SectorX=sx;
		m_SectorY=sy;
		m_PlanetNum = planetnum;

		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) { Hide(); return; }
		if ((planet.m_Owner == Server.Self.m_UserId || planet.m_Owner == 0) && (EM.m_CotlType == Common.CotlTypeUser)) { }
		else m_BuildAtSDM = false;

		m_BuildSlotMouse = -1;
		m_CellMouse = -1;
		m_ItemSlotMouse = -1;
		m_ItemSlotDown = -1;
		
		visible = true;
		
		BuildChangeType();
		
		Update();
		m_Timer.start();
		
		if (m_ShowFirst) {
			m_ShowFirst = false;

			x = 100;// (stage.stageWidth >> 1) - (SizeX >> 1);
			y = 50;// (stage.stageHeight >> 1) - (m_SizeY >> 1);
		}
	}

	public function Hide() : void
	{
		m_Timer.stop();
		visible = false;
		if(EM.m_FormItemBalans!=null) EM.m_FormItemBalans.Hide();
		return;
	}

	public function clickClose(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if (FormMessageBox.Self.visible) return;
		
		
		if (EM.m_FormConstruction.visible) EM.m_FormConstruction.Hide();
		Hide();
	}

	public function Takt(event:TimerEvent=null):void
	{
		if (visible) Update();
		if (EM.m_FormConstruction.visible) Update();
	}

	public function Update():void
	{
		var ix:int, iy:int, icell:int, px:int, py:int, u:int, t:int, i:int, cnt:int, bcnt:int;
		var user:User = null;
		var uni:Union = null;
		var ship:Ship;
		var str:String;
		var obj:Object;

		if (!visible) return;

		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

		var pr:PRnd = new PRnd(m_SectorX ^ m_SectorY ^ m_PlanetNum);
		pr.RndEx();

		if(planet.m_Owner!=0) {
			user = UserList.Self.GetUser(planet.m_Owner);
		}
		if(user!=null && user.m_UnionId!=0) {
			uni = UserList.Self.GetUnion(user.m_UnionId);
		}

		var isvis:Boolean = planet.m_Vis;
		if (EM.IsEdit()) isvis = true;

		var ti:int=0; // 0-не игрока 1=столица 2-империя 3-цитадель 4-анклав 5-колония
		if(isvis && planet.m_Owner==Server.Self.m_UserId) {
			if(planet.m_Flag & Planet.PlanetFlagHomeworld) ti=1;
			else if(planet.m_Flag & Planet.PlanetFlagCitadel) ti=3;
			else if(!EM.m_EmpireColony && planet.m_Owner!=0 && planet.m_Owner==EM.m_CotlOwnerId) ti=2;
			else if(EM.m_EmpireColony && planet.m_Island!=0 && planet.m_Island==EM.m_HomeworldIsland) ti=2;
			//else if(planet.m_Island!=0 && planet.m_Island==EM.m_CitadelIsland) ti=4;
			else if (planet.m_Flag & Planet.PlanetFlagEnclave) ti = 4;
			else ti=5;
		}

		var occupy:Boolean=false;
		if (isvis) occupy = (EM.m_CotlType == Common.CotlTypeUser) && (planet.m_Owner != 0) && (EM.m_CotlOwnerId != planet.m_Owner);
		if (isvis && !occupy && !EM.IsWinMaxEnclave()) occupy = (EM.m_CotlType == Common.CotlTypeRich) && (planet.m_Owner != 0) && (planet.m_Owner & Common.OwnerAI) == 0 && (EM.m_OpsFlag & Common.OpsFlagEnclave) == 0;

		if(true) {
			str = EM.TxtCotl_PlanetName(m_SectorX, m_SectorY, m_PlanetNum);
			if (str.length > 0) { }
			else if((planet.m_Flag & Planet.PlanetFlagWormhole)!=0 && (planet.m_Flag & Planet.PlanetFlagLarge)!=0) str=Common.Txt.WormholeRoam;
			else if(planet.m_Flag & Planet.PlanetFlagWormhole) str=Common.Txt.Wormhole;
			else if(planet.m_Flag & Planet.PlanetFlagRich) str=Common.Txt.PlanetRich;
			else if((planet.m_Flag & Planet.PlanetFlagSun) && (planet.m_Flag & Planet.PlanetFlagLarge)) str=Common.Txt.Pulsar;
			else if(planet.m_Flag & Planet.PlanetFlagSun) str=Common.Txt.Sun;
			else if((planet.m_Flag & Planet.PlanetFlagGigant) && (planet.m_Flag & Planet.PlanetFlagLarge)) str=Common.Txt.Gigant;
			else if((planet.m_Flag & Planet.PlanetFlagGigant) && !(planet.m_Flag & Planet.PlanetFlagLarge)) str=Common.Txt.PlanetTini;
			else if(planet.m_Flag & Planet.PlanetFlagLarge) str=Common.Txt.PlanetLarge;
			else str=Common.Txt.Planet;

			if (EM.m_CotlType != Common.CotlTypeProtect && EM.m_CotlType != Common.CotlTypeCombat) {
				if(ti==2 && EM.m_UserEmpirePlanetCnt>EM.PlanetEmpireMax(Server.Self.m_UserId)) str+="<font color='#ff0000'>("+Common.Txt.OutControl+")</font>";
				if(ti==4 && EM.m_UserEnclavePlanetCnt>EM.PlanetEnclaveMax(Server.Self.m_UserId)) str+="<font color='#ff0000'>("+Common.Txt.OutControl+")</font>";
				if(occupy) str+="<font color='#ff0000'>("+Common.Txt.Occupy+")</font>"; 
				else if(ti==5 && EM.m_UserColonyPlanetCnt>EM.PlanetColonyMax(Server.Self.m_UserId)) str+="<font color='#ff0000'>("+Common.Txt.OutControl+")</font>";
			}

			m_Title.htmlText = str;
		}

		str = EM.TxtCotl_PlanetDesc(m_SectorX, m_SectorY, m_PlanetNum); if (str.length > 0) str += "[br]";
		if(isvis && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))) {
			if(planet.m_Owner!=0) {
				if(user!=null) {
					str += Common.Txt.Owner + ": [clr]" + EM.Txt_CotlOwnerName(Server.Self.m_CotlId, planet.m_Owner) + "[/clr][br]";

					if (uni != null) str += "<font color='#00b7ff'>" + uni.NameUnion() + " " + uni.m_Name + "</font>[br]";
				}
			} else {
				str += Common.Txt.Owner + ": [clr]" + Common.Txt.Neutral + "[/clr][br]";
			}
		}
		m_SubTitle.htmlText = BaseStr.FormatTag(str);

		// Grid
		var sizey:int = 0;
		m_GridStartY = 140;
		
		m_ShowTer = true;
		if (planet.m_Flag & Planet.PlanetFlagSun) m_ShowTer = false;
		else if (planet.m_Flag & Planet.PlanetFlagWormhole) m_ShowTer = false;
		else if (planet.m_Flag & Planet.PlanetFlagGigant) m_ShowTer = false;
		
		while (m_ShowTer && planet.m_Owner != 0 && planet.m_Owner != Server.Self.m_UserId && !EM.AccessBuild(planet.m_Owner) && (!EM.IsEdit()) && EM.m_CotlType != Common.CotlTypeProtect && EM.m_CotlType != Common.CotlTypeCombat) {
			if (/*(planet.m_Owner & Common.OwnerAI) != 0 &&*/ ((EM.m_OpsFlag & Common.OpsFlagViewAll) != 0 || (user.m_Flag & Common.UserFlagVisAll) != 0)) break;
			
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i];
				if (ship.m_Type == Common.ShipTypeNone) continue;
				if (EM.IsFlyOtherPlanet(ship, planet)) continue;
				if (!EM.AccessControl(ship.m_Owner)) continue;
				break;
			}
			if (i >= Common.ShipOnPlanetMax) m_ShowTer = false;
			break;
		}

		for (icell = 0; icell < Planet.PlanetCellCnt;icell++) {
			obj = m_Cell[icell];
			if (obj == null) continue;
			obj.BG.visible = false;
			obj.Building.visible = false;
			obj.BuildBar.visible = false;
		}

		if(m_ShowTer) {
			var buildstate:Number = 0;
			if (planet.m_CellBuildFlag != 0) {
				buildstate = 0;
				for (i = 0; i < Planet.PlanetCellCnt; i++) {
					if ((planet.m_CellBuildFlag & (1 << i)) == 0) continue;
					buildstate += EM.CalcBuildingBuildTime(planet.m_Cell[i] >> 3, planet.m_Cell[i] & 7) * 1000;
				}
				buildstate = 100 * (EM.m_ServerCalcTime - (planet.m_CellBuildEnd - buildstate)) / buildstate;
				if (buildstate <= 5) buildstate = 5;
				else if (buildstate > 100) buildstate = 100;
			}

			for (iy = 0; iy < PlanetGridCntY; iy++) {
				for (ix = 0; ix < PlanetGridCntX; ix++) {
					icell = -1;
					if ((planet.m_Flag & Planet.PlanetFlagLarge) != 0) icell = PlanetGridToCell_Large[ix + iy * PlanetGridCntX];
					else icell = PlanetGridToCell_Small[ix + iy * PlanetGridCntX];
					if (icell < 0) continue;

					px = m_GridStartX + ix * CellHalfSizeX - iy * CellHalfSizeX;
					py = m_GridStartY + ix * CellHalfSizeY + iy * CellHalfSizeY;

					obj = m_Cell[icell];
					if (obj == null) {
						obj = new Object();
						m_Cell[icell] = obj;
						obj.BG = new Bitmap();
						m_BuildingLayer.addChild(obj.BG);
						obj.Building = new Bitmap();
						m_BuildingLayer.addChild(obj.Building);
						obj.BuildBar = new Sprite();
						m_BuildTxtLayer.addChild(obj.BuildBar);
					}
					u = pr.Rnd(0, 100);
					if(planet.m_Flag & Planet.PlanetFlagLarge) {
						if (planet.PlanetCellType(icell)<0) {
							if ((planet.m_OreItem == Common.ItemTypeCrystal || planet.m_OreItem == Common.ItemTypeTitan || planet.m_OreItem == Common.ItemTypeSilicon)) obj.BG.bitmapData = m_CI_Live_Grass0;
							else obj.BG.bitmapData = m_CI_Live_Water0;
						}
						else if (u < 33) {
							u = pr.Rnd(0, 100);
							if (u < 33) obj.BG.bitmapData = m_CI_Live_Grass0;
							else if (u < 66) obj.BG.bitmapData = m_CI_Live_Grass1;
							else obj.BG.bitmapData = m_CI_Live_Grass2;
						}
						else if (u < 66) {
							u = pr.Rnd(0, 100);
							if (u < 33) obj.BG.bitmapData = m_CI_Live_Field0;
							else obj.BG.bitmapData = m_CI_Live_Field1;
						}
						else {
							if (pr.Rnd(0, 100) < 50) obj.BG.bitmapData = m_CI_Live_Tree0;
							else obj.BG.bitmapData = m_CI_Live_Tree1;
						}
					} else {
						if (planet.PlanetCellType(icell)<0) {
							if ((planet.m_OreItem == Common.ItemTypeCrystal || planet.m_OreItem == Common.ItemTypeTitan || planet.m_OreItem == Common.ItemTypeSilicon)) obj.BG.bitmapData = m_CI_Moon_Std0;
							else obj.BG.bitmapData = m_CI_Moon_Bad0;
						} else if (u < 25) {
							obj.BG.bitmapData = m_CI_Moon_Std0;
						} else if (u < 50) {
							obj.BG.bitmapData = m_CI_Moon_Std1;
						} else if (u < 75) {
							obj.BG.bitmapData = m_CI_Moon_Std2;
						} else {
							obj.BG.bitmapData = m_CI_Moon_Std3;
						}
					}
					obj.BG.x = px-(obj.BG.bitmapData.width>>1);
					obj.BG.y = py - obj.BG.bitmapData.height;
					obj.BG.visible = true;

					if ((planet.m_OreItem == Common.ItemTypeCrystal || planet.m_OreItem == Common.ItemTypeTitan || planet.m_OreItem == Common.ItemTypeSilicon) && planet.PlanetCellType(icell) < 0/*(icell == 4 || icell == 7)*/) {
						if (planet.m_OreItem == Common.ItemTypeCrystal) t = Common.BuildingTypeCrystal;
						else if (planet.m_OreItem == Common.ItemTypeTitan) t = Common.BuildingTypeTitan;
						else t = Common.BuildingTypeSilicon;
						obj.Building.bitmapData = FormConstruction.GetImageByType(t, 0);
						obj.Building.visible = true;

						obj.Building.x = px-(obj.Building.bitmapData.width>>1);
						obj.Building.y = py - obj.Building.bitmapData.height;
						
					} else if (planet.m_Cell[icell] == 0) {
						obj.Building.bitmapData = null;
						obj.Building.visible = false;
					} else {
						obj.Building.bitmapData = FormConstruction.GetImageByType(planet.m_Cell[icell] >> 3, planet.m_Cell[icell] & 7);
						obj.Building.visible = true;

						obj.Building.x = px-(obj.Building.bitmapData.width>>1);
						obj.Building.y = py - obj.Building.bitmapData.height;
					}

					obj.BuildBar.graphics.clear();
					if ((planet.m_CellBuildFlag & (1 << icell))!=0) {
						obj.BuildBar.graphics.lineStyle(0,0,0.0);
						obj.BuildBar.graphics.beginFill(0x000000,0.8);
						obj.BuildBar.graphics.drawRoundRect(-20-2,-2-2,40+4,5+4,1,1);
						obj.BuildBar.graphics.endFill();
						obj.BuildBar.graphics.beginFill(0xffff00,1.0);
						obj.BuildBar.graphics.drawRoundRect(-20,-2,Math.round(40.0*buildstate/100),5,2,2);
						obj.BuildBar.graphics.endFill();
						obj.BuildBar.x = px;
						obj.BuildBar.y = py-15;
						obj.BuildBar.visible = true;
					} else {
						obj.BuildBar.visible = false;
					}

					if(/*icell==m_CellCur ||*/ icell==m_CellMouse) {
						var ac:AdjustColor=new AdjustColor();
						ac.brightness=10;
						ac.contrast=0;
						ac.hue = 0;// -100;//EM.m_TmpVal;
						ac.saturation=50;
						var filter:ColorMatrixFilter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
						var filters:Array = new Array();
						filters.push(filter);
						obj.BG.filters = filters;
						obj.Building.filters = filters;
					} else {
						obj.BG.filters = null;
						obj.Building.filters = null;
					}
				}
			}

			m_TxtEnergy.visible = true;
			m_TxtEnergy.text = planet.PlanetCalcEnergy().toString();
			m_TxtEnergy.x = SizeX-m_TxtEnergy.width-30;
			if ((planet.m_Flag & Planet.PlanetFlagLarge) != 0) m_TxtEnergy.y = m_GridStartY + 160-10;
			else m_TxtEnergy.y = m_GridStartY + 120-20;
			m_IconEnergy.visible = true;
			m_IconEnergy.x = m_TxtEnergy.x - (m_IconEnergy.width >> 1);
			m_IconEnergy.y = m_TxtEnergy.y + (m_TxtEnergy.height >> 1);

			if(planet.PlanetNeedSupplyMax()>0 && !EM.IsWinMaxEnclave()) {
				m_TxtEngineer.visible = true;
				m_TxtEngineer.text = planet.m_Engineer.toString()+"/"+planet.PlanetNeedSupplyMax().toString();
				m_TxtEngineer.x = 30;
				if ((planet.m_Flag & Planet.PlanetFlagLarge) != 0) m_TxtEngineer.y = m_GridStartY + 160 + 5;
				else m_TxtEngineer.y = m_GridStartY + 120 - 10;
				m_IconEngineer.visible = true;
				m_IconEngineer.x = m_TxtEngineer.x - (m_IconEngineer.width >> 1);
				m_IconEngineer.y = m_TxtEngineer.y + (m_TxtEngineer.height >> 1);

				m_TxtMachinery.visible = true;
				m_TxtMachinery.text = planet.m_Machinery.toString()+"/"+planet.PlanetNeedSupplyMax().toString();
				m_TxtMachinery.x = 30;
				m_TxtMachinery.y = m_TxtEngineer.y - 22;
				m_IconMachinery.visible = true;
				m_IconMachinery.x = m_TxtMachinery.x - (m_IconMachinery.width >> 1)+3;
				m_IconMachinery.y = m_TxtMachinery.y + (m_TxtMachinery.height >> 1);
			} else {
				m_TxtEngineer.visible = false;
				m_IconEngineer.visible = false;
				m_TxtMachinery.visible = false;
				m_IconMachinery.visible = false;
			}

			if ((planet.m_Flag & Planet.PlanetFlagLarge) != 0) sizey += 330;
			else sizey += 290;
		} else {
/*			for (iy = 0; iy < PlanetGridCntY; iy++) {
				for (ix = 0; ix < PlanetGridCntX; ix++) {
					icell = PlanetGridToCell[ix + iy * PlanetGridCntX];
					if (icell < 0) continue;
					
					px = m_GridStartX + ix * CellHalfSizeX - iy * CellHalfSizeX;
					py = m_GridStartY + ix * CellHalfSizeY + iy * CellHalfSizeY;
					
					obj = m_Cell[icell];
					if (obj == null) continue;
					obj.BG.visible = false;
					obj.Building.visible = false;
					obj.BuildBar.visible = false;
				}
			}*/
			m_TxtEnergy.visible = false;
			m_IconEnergy.visible = false;
			m_TxtEngineer.visible = false;
			m_IconEngineer.visible = false;
			m_TxtMachinery.visible = false;
			m_IconMachinery.visible = false;
			
			sizey += 50;
		}
		
		// Item
		var itemcntrow:int = 0;
		var storage:int = planet.PlanetItemMax();
		var itemcntmax:int = Math.min(Planet.PlanetItemCnt, storage);
		var itemrowsize:int = itemcntmax;
		for (t = 0; t < Planet.PlanetItemCnt; t++) {
			if (planet.m_Item[t].m_Type == 0) continue;
			if ((t + 1) > itemrowsize) itemrowsize = t + 1;
		}
//		if (itemrowsize > 8) itemrowsize = (itemcntmax >> 1) + (itemcntmax & 1);
		if (itemrowsize > 8) itemrowsize = (itemrowsize >> 1) + (itemrowsize & 1);
		var ab:Boolean = (planet.m_Owner == 0) || EM.AccessBuild(planet.m_Owner) || EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat;
		if (!ab && EM.ExistFriendShip(planet, Server.Self.m_UserId, Common.RaceNone, true, 0)) ab = true;
		if (!ab && /*(planet.m_Owner & Common.OwnerAI) != 0 &&*/ ((EM.m_OpsFlag & Common.OpsFlagViewAll) != 0 || (user.m_Flag & Common.UserFlagVisAll) != 0)) ab = true;
		if (EM.IsEdit()) ab = true;
		for (t = 0; t < Planet.PlanetItemCnt; t++) {
			if (t < m_Item.length) {
				obj = m_Item[t];
				
			} else {
				obj = new Object();
				obj.Num = t;
				obj.Img = null;
				m_Item.push(obj);
			}

			if(obj.SlotN==undefined || obj.SlotN==null) {
				obj.SlotN=new MBSlotG();
				m_BuildSlotLayer.addChild(obj.SlotN);
				obj.SlotN.width=ItemSlotSize;
				obj.SlotN.height=ItemSlotSize;
			}
			if(obj.SlotN2==undefined || obj.SlotN2==null) {
				obj.SlotN2=new MBSlotC();
				m_BuildSlotLayer.addChild(obj.SlotN2);
				obj.SlotN2.width=ItemSlotSize;
				obj.SlotN2.height=ItemSlotSize;
			}
			if(obj.SlotA==undefined || obj.SlotA==null) {
				obj.SlotA = new MBSlotA();
				m_BuildSlotLayer.addChild(obj.SlotA);
				obj.SlotA.width = ItemSlotSize;
				obj.SlotA.height = ItemSlotSize;
			}
			if(obj.SlotE==undefined || obj.SlotE==null) {
				obj.SlotE = new MBSlotE();
				m_BuildSlotLayer.addChild(obj.SlotE);
				obj.SlotE.width = ItemSlotSize;
				obj.SlotE.height = ItemSlotSize;
			}

			if(obj.Txt==undefined || obj.Txt==null) {
				obj.Txt=new TextField();
				m_BuildTxtLayer.addChild(obj.Txt);
				obj.Txt.width=ItemSlotSize-2;
				obj.Txt.type=TextFieldType.DYNAMIC;
				obj.Txt.selectable=false;
				obj.Txt.border=false;
				obj.Txt.background=true;
				obj.Txt.backgroundColor=0x000000;
				obj.Txt.multiline=false;
				obj.Txt.autoSize=TextFieldAutoSize.NONE;
				obj.Txt.antiAliasType=AntiAliasType.ADVANCED;
				obj.Txt.gridFitType=GridFitType.PIXEL;
				obj.Txt.defaultTextFormat=new TextFormat("Calibri",11,0xffffff);
				obj.Txt.embedFonts=true;
				obj.Txt.alpha=0.8;
			}

			if(obj.IconBuild==undefined || obj.IconBuild==null) {
				obj.IconBuild = Common.CreateByName("IconBuild");
				m_BuildTxtLayer.addChild(obj.IconBuild);
			}

			if(obj.IconNoMove==undefined || obj.IconNoMove==null) {
				obj.IconNoMove = Common.CreateByName("IconPlanetItemNoMove");
				m_BuildTxtLayer.addChild(obj.IconNoMove);
			}
			
			if(obj.IconImport==undefined || obj.IconImport==null) {
				obj.IconImport = Common.CreateByName("IconPlanetItemImport");
				m_BuildTxtLayer.addChild(obj.IconImport);
			}

			if(obj.IconExport==undefined || obj.IconExport==null) {
				obj.IconExport = Common.CreateByName("IconPlanetItemExport");
				m_BuildTxtLayer.addChild(obj.IconExport);
			}

			if(obj.IconPortal==undefined || obj.IconPortal==null) {
				obj.IconPortal = Common.CreateByName("IconPlanetItemPortal");
				m_BuildTxtLayer.addChild(obj.IconPortal);
			}
			
			if(obj.IconShow==undefined || obj.IconShow==null) {
				obj.IconShow = Common.CreateByName("IconPlanetItemShow");
				m_BuildTxtLayer.addChild(obj.IconShow);
			}
			
			var item:Item = null;
			if (ab && planet.m_Item[t].m_Type!=0) item = UserList.Self.GetItem(planet.m_Item[t].m_Type & 0xffff);
			
			if (item==null || item.m_Img != obj.ImgNo) {
				if (obj.Img != undefined && obj.Img != null) {
					m_BuildShipLayer.removeChild(obj.Img);
					obj.Img = null;
				}
				obj.ImgNo = 0;
			}
			
			if (planet.m_Item[t].m_Type != 0 && (obj.Img == undefined || obj.Img == null) && item!=null) {
				obj.ImgNo = item.m_Img;
				obj.Img = Common.ItemImg(obj.ImgNo);
				if (obj.Img != null) {
					m_BuildShipLayer.addChild(obj.Img);
				}
			}
			
			if ((t >= itemcntmax && planet.m_Item[t].m_Type == 0) || !ab) {
				obj.SlotA.visible = false;
				obj.SlotN.visible = false;
				obj.SlotN2.visible = false;
				obj.SlotE.visible = false;
			} else {
				obj.SlotA.visible = (t == m_ItemSlotMouse) || (EM.m_MoveItem.visible && EM.m_MoveItem.m_ToType == 1 && EM.m_MoveItem.m_ToSlot == obj.Num) || (EM.m_MoveItem.visible && EM.m_MoveItem.m_FromType == 1 && EM.m_MoveItem.m_FromSlot == obj.Num) || (EM.m_FormFleetBar.m_SlotMove >= 0 && EM.m_FormFleetBar.m_SlotMoveBegin && EM.m_MoveItem.m_ToType == 1 && EM.m_MoveItem.m_ToSlot == obj.Num);
				obj.SlotN.visible = (!obj.SlotA.visible) && (t < itemcntmax) && Common.StackMax(t,storage,1)==1;
				obj.SlotN2.visible = (!obj.SlotA.visible) && (t < itemcntmax) && Common.StackMax(t,storage,1)!=1;
				obj.SlotE.visible = (!obj.SlotA.visible) && (t>=itemcntmax);

				if (t >= itemrowsize) itemcntrow = 2;
				else itemcntrow = 1;
			}

			ix = (SizeX>>1)-((itemrowsize*ItemSlotSize)>>1) + t * ItemSlotSize;
			iy = sizey;
			if (t >= itemrowsize) {
				ix = (SizeX>>1)-((itemrowsize*ItemSlotSize)>>1) + (t - itemrowsize) * ItemSlotSize;
				iy += ItemSlotSize;
			}

			if(ab && planet.m_Item[t].m_Type != 0) {
				obj.Txt.height = 17;
				obj.Txt.x = ix + 1;
				obj.Txt.y = iy + ItemSlotSize-obj.Txt.height;

				if (planet.m_Item[t].m_Cnt >= 500000) str = BaseStr.FormatBigInt(Math.floor(planet.m_Item[t].m_Cnt/1000))/*+"."+Math.floor((planet.m_Item[t].m_Cnt%1000)/100).toString()*/+"k";
				else str = BaseStr.FormatBigInt(planet.m_Item[t].m_Cnt);

				if ((planet.m_Item[t].m_Cnt < 10) && (planet.m_Item[t].m_Complete > 0) && planet.m_Item[t].m_Type!=Common.ItemTypeModule) {
					i = EM.CalcItemDifficult(planet, planet.m_Item[t].m_Type);
					if (i > 1) {
						i = Math.floor((planet.m_Item[t].m_Complete * 100) / i);
						if (i < 1) i = 1;
						else if (i > 99) i = 99;
						str += " <font color='#00ffff'>(" +i.toString()+ "%)</font>";
					}
				}

				obj.Txt.htmlText = str;
				obj.Txt.visible = true;
			} else {
				obj.Txt.visible = false;
			}

			obj.IconBuild.visible = ((planet.m_Item[t].m_Flag & PlanetItem.PlanetItemFlagBuild) != 0) && ab;
			obj.IconBuild.x = ix+32;
			obj.IconBuild.y = iy + 5;

			var ttx:int = ix + 4;

			obj.IconNoMove.visible = ((planet.m_Item[t].m_Flag & PlanetItem.PlanetItemFlagNoMove) != 0) && ab;
			obj.IconNoMove.x = ttx;
			obj.IconNoMove.y = iy - 2;
			if (obj.IconNoMove.visible) ttx += 13;

			obj.IconPortal.visible = ((planet.m_Item[t].m_Flag & PlanetItem.PlanetItemFlagToPortal) != 0) && ab;
			obj.IconPortal.y = iy - 2;
			obj.IconPortal.x = ttx;
			if (obj.IconPortal.visible) ttx += 11;
			
			obj.IconImport.visible = ((planet.m_Item[t].m_Flag & PlanetItem.PlanetItemFlagImport) != 0) && ab;
			obj.IconImport.y = iy - 2;
			obj.IconImport.x = ttx-1;
			if (obj.IconImport.visible) ttx += 9;

			obj.IconExport.visible = ((planet.m_Item[t].m_Flag & PlanetItem.PlanetItemFlagExport) != 0) && ab;
			obj.IconExport.y = iy - 2;
			obj.IconExport.x = ttx-1;
			if (obj.IconExport.visible) ttx += 10;

			obj.IconShow.visible = ((planet.m_Item[t].m_Flag & PlanetItem.PlanetItemFlagShowCnt) != 0) && ab;
			obj.IconShow.y = iy - 2;
			obj.IconShow.x = ttx;
			if (obj.IconShow.visible) ttx += 10;

			obj.SlotN.x = ix;
			obj.SlotN.y = iy;
			obj.SlotN2.x = ix;
			obj.SlotN2.y = iy;
			obj.SlotA.x = ix;
			obj.SlotA.y = iy;
			obj.SlotE.x = ix;
			obj.SlotE.y = iy;
			
			if (obj.Img != null) {
				obj.Img.x = ix + (ItemSlotSize >> 1);
				obj.Img.y = iy + (ItemSlotSize >> 1);
			}
		}
		if(itemcntrow>0) sizey += itemcntrow*ItemSlotSize + 10;

		// Build
		var buildowner:uint = 0;
		if (EM.IsEdit()) {
		} else if (planet.m_Owner != 0) {
			if (EM.AccessBuild(planet.m_Owner)) buildowner = planet.m_Owner;

		} else if (planet.m_Owner == 0) {
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i];
				if (ship.m_Type == Common.ShipTypeNone) continue;
				if (EM.IsFlyOtherPlanet(ship, planet)) continue;
				if (!EM.AccessControl(ship.m_Owner)) continue;

				buildowner = Server.Self.m_UserId;
				break;
			}
		}

		m_BuildSlotOffY = sizey;
		var bf:Boolean = false;
		cnt = 0;
		if(buildowner!=0)
		for (t = 0; t < 14; t++) {
			var st:int = Common.ShipTypeNone;
			var sst:int = 0;
			var sid:uint = 0;
			var cpt:Cpt = null;
			var cptdsc:Object = null;
			
			if (t == 0) st = Common.ShipTypeCorvette;
			else if (t == 1) st = Common.ShipTypeCruiser;
			else if (t == 2) st = Common.ShipTypeDreadnought;
			else if (t == 3) st = Common.ShipTypeDevastator;
			else if (t == 4) st = Common.ShipTypeInvader;
			else if (t == 5) st = Common.ShipTypeTransport;
			else if (t == 6) st = Common.ShipTypeWarBase;
			else if (t == 7) st = Common.ShipTypeShipyard;
			else if (t == 8) st = Common.ShipTypeSciBase;
			else if (t == 9) st = Common.ShipTypeServiceBase;
			else if (t == 10) st = Common.ShipTypeQuarkBase;
			//else if (t >= 13) st = Common.ShipTypeServiceBase;
			else if (t >= 11 && t <= 13 && user != null && user.m_Cpt != null) {
				var cptno:int = t - 11;
				while (cptno < user.m_Cpt.length) {
					if (m_BuildAtSDM) break;
					if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat || EM.m_CotlType == Common.CotlTypeRich) && (EM.m_OpsFlag & Common.OpsFlagBuildFlagship) == 0) break;
					if (planet.m_Owner != Server.Self.m_UserId) break;

					cpt=user.m_Cpt[cptno];
					if (cpt.m_Id == 0) { cpt = null; cptdsc = null; break; }
					cptdsc=EM.m_FormCptBar.CptDsc(cpt.m_Id);
					if (cptdsc == null) { cpt = null; cptdsc = null; break; }

					if (cpt.m_PlanetNum >= 0) { cpt = null; cptdsc = null; break; }

					st = Common.ShipTypeFlagship;
					sst = EM.CalcFlagshipSubtype(Server.Self.m_UserId, cpt.m_Id);
					sid = cpt.m_Id;
					break;
				}
			}

			//if (m_BuildAtSDM && (planet.m_Owner != Server.Self.m_UserId || planet.m_Owner == 0)) break;
			if (m_BuildAtSDM && buildowner != Server.Self.m_UserId) break;

			//var old_type:int = 0;
			//var old_stype:int = 0;
			//obj = null;

			if (st == Common.ShipTypeNone) continue;
			if (!EM.ShipAccess(buildowner, st)) continue;
			if (!EM.BuildAccess(buildowner, st)) continue;
			if (st == Common.ShipTypeQuarkBase && (planet.m_Flag & Planet.PlanetFlagHomeworld) == 0) continue;

			if((!Common.IsBase(st)) && !(planet.m_Flag & (Planet.PlanetFlagHomeworld | Planet.PlanetFlagCitadel))) {
				for(i=0;i<Common.ShipOnPlanetMax;i++) {
					ship=planet.m_Ship[i];
					if (ship.m_Type == Common.ShipTypeShipyard && !(ship.m_Flag & Common.ShipFlagBuild) && ship.m_Owner == buildowner) break;
				}
				if(i>=Common.ShipOnPlanetMax) { continue; }
			}
//			if (st == Common.ShipTypeServiceBase) {
//				if (planet.m_Flag & (Planet.PlanetFlagHomeworld | Planet.PlanetFlagCitadel)) continue;
//				for(i=0;i<Common.ShipOnPlanetMax;i++) {
//					ship=planet.m_Ship[i];
//					if(ship.m_Type==Common.ShipTypeShipyard && !(ship.m_Flag & Common.ShipFlagBuild) && ship.m_Owner==buildowner) break;
//				}
//				if(i<Common.ShipOnPlanetMax) { continue; }
//			}

			if (cnt < m_BuildSlot.length) {
				obj = m_BuildSlot[cnt];
//				old_type = obj.Type;
//				old_stype = obj.SubType;
			
//				obj.Type = 0;
//				obj.SubType = 0;
				
			} else {
				obj = new Object();
				obj.Type = 0;
				obj.SubType = 0;
				obj.Id = 0;
				m_BuildSlot.push(obj);
			}
			i = cnt;
			cnt++;

			if (obj.ShipImg == undefined || !(obj.Type == st && obj.SubType == sst)) {
				if (obj.ShipImg != undefined && obj.ShipImg != null) {
					m_BuildShipLayer.removeChild(obj.ShipImg);
					obj.ShipImg = null;
				}
				obj.ShipImg = FormFleetBar.GetImageByType(st, EM.RaceByOwner(buildowner), sst);
				m_BuildShipLayer.addChild(obj.ShipImg);
			}

			if(obj.SlotN==undefined || obj.SlotN==null) {
				obj.SlotN=new MBSlotN();
				m_BuildSlotLayer.addChild(obj.SlotN);
				obj.SlotN.width=BuildSlotSize;
				obj.SlotN.height=BuildSlotSize;
			}
			if(obj.SlotA==undefined || obj.SlotA==null) {
				obj.SlotA = new MBSlotA();
				m_BuildSlotLayer.addChild(obj.SlotA);
				obj.SlotA.width = BuildSlotSize;
				obj.SlotA.height = BuildSlotSize;
			}
			obj.SlotA.visible = (i == m_BuildSlotMouse) || (st==m_BuildType && sid==m_BuildId);
			obj.SlotN.visible = !obj.SlotA.visible;
			
			if(obj.Txt==undefined || obj.Txt==null) {
				obj.Txt=new TextField();
				m_BuildTxtLayer.addChild(obj.Txt);
				obj.Txt.width=BuildSlotSize-2;
				obj.Txt.type=TextFieldType.DYNAMIC;
				obj.Txt.selectable=false;
				obj.Txt.border=false;
				obj.Txt.background=true;
				obj.Txt.backgroundColor=0x000000;
				obj.Txt.multiline=false;
				obj.Txt.autoSize=TextFieldAutoSize.NONE;
				obj.Txt.antiAliasType=AntiAliasType.ADVANCED;
				obj.Txt.gridFitType=GridFitType.PIXEL;
				obj.Txt.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);
				obj.Txt.embedFonts=true;
				obj.Txt.alpha=0.8;
			}
			
			ix = BuildSlotOffX + i * BuildSlotSize;
			iy = m_BuildSlotOffY;
			if (i >= 12) {
				ix -= 12 * BuildSlotSize;
				iy += BuildSlotSize * 2;
			} else if (i >= 6) {
				ix -= 6 * BuildSlotSize;
				iy += BuildSlotSize;
			}

			obj.SlotN.x = ix;
			obj.SlotN.y = iy;
			obj.SlotA.x = ix;
			obj.SlotA.y = iy;

			obj.Txt.x=ix+1;

			obj.Type = st;
			obj.SubType = sst;
			obj.Id = sid;
			
			if (m_BuildType == st && m_BuildId == sid) bf = true;

			obj.ShipImg.x = ix + (BuildSlotSize >> 1);
			obj.ShipImg.y = iy + (BuildSlotSize >> 1);

			bcnt = Math.min(int(m_EditCnt.text), CalcMaxCnt(st, sid));
				
			if (st == m_BuildType && sid == m_BuildId && bcnt>1) {
				obj.Txt.height = 34;
				obj.Txt.y = iy + BuildSlotSize-obj.Txt.height;

				var bprice:int = 0;
				if (m_BuildAtSDM) bprice = Common.ShipCostSDM[st];
				else bprice = EM.ShipCost(buildowner, sid, st);

				obj.Txt.htmlText = bprice.toString() + " x " + BaseStr.FormatBigInt(bcnt) + "\n=" + BaseStr.FormatBigInt(bprice * bcnt);

			} else {
				obj.Txt.height=17;
				obj.Txt.y=iy+BuildSlotSize-obj.Txt.height;
				if (m_BuildAtSDM) obj.Txt.text = BaseStr.FormatBigInt(Common.ShipCostSDM[st]);
				else obj.Txt.text = BaseStr.FormatBigInt(EM.ShipCost(buildowner, sid, st));
			}

//			obj=m_FormMenu.Add("        "+Common.ShipName[m_CMShipBuildType[t]]+" ("+Common.Txt.Cost+" "+ShipCost(planet.m_Owner,0,m_CMShipBuildType[t])+")",null,m_CMShipBuildType[t]);
//			if((ShipCost(planet.m_Owner,0,m_CMShipBuildType[t])<=planet.m_ConstructionPoint) || (m_UserSDM>=Common.ShipCostSDM[m_CMShipBuildType[t]])) obj.Fun=ActionBuildShip2;
//			else obj.Disable=true;
		}
		//for (u = cnt; u < m_BuildSlot.length; u++) m_BuildSlot[u].Type = 0;
		for (u = m_BuildSlot.length - 1; u >= cnt ; u--) {
			obj = m_BuildSlot[u];
			//if (obj.Type != 0) continue;
//			if (obj.SlotN != undefined && obj.SlotN != null) obj.SlotN.visible = false;
//			if (obj.SlotA != undefined && obj.SlotA != null) obj.SlotA.visible = false;
			if (obj.ShipImg != undefined && obj.ShipImg != null) {
				m_BuildShipLayer.removeChild(obj.ShipImg);
				obj.ShipImg = null;
			}
			if (obj.SlotN != undefined && obj.SlotN != null) {
				m_BuildSlotLayer.removeChild(obj.SlotN);
				obj.SlotN = null;
			}
			if (obj.SlotA != undefined && obj.SlotA != null) {
				m_BuildSlotLayer.removeChild(obj.SlotA);
				obj.SlotA = null;
			}
			if (obj.Txt != undefined && obj.Txt != null) {
				m_BuildTxtLayer.removeChild(obj.Txt);
				obj.Txt = null;
			}
			m_BuildSlot.splice(u, 1);
		}
		if (m_BuildType != 0 && !bf) { m_BuildType = 0; m_BuildId = 0; }
		
		//
		var buildok:Boolean = (m_BuildType != 0) && (buildowner != 0);
		var buildokbut:Boolean = true;
		if (buildok) {
			if (m_BuildType == Common.ShipTypeFlagship) {
				if (user == null) buildok = false;
				else {
					cpt = user.GetCpt(m_BuildId);
					if (cpt == null) buildok = false;
					else if (cpt.m_PlanetNum >= 0) buildok = false;
					else if (EM.ShipCost(buildowner, cpt.m_Id, Common.ShipTypeFlagship) > EM.PlanetItemGet_Sub(buildowner, planet, Common.ItemTypeModule, true)) buildok = false;
				}
			} else {
				bcnt = Math.min(int(m_EditCnt.text), CalcMaxCnt(m_BuildType, m_BuildId));

				if (CalcMaxCnt(m_BuildType, m_BuildId) <= 0) buildok = false;
				else if (bcnt <= 0) buildokbut = false;// buildok = false;
				else if ((!m_BuildAtSDM) && ((EM.ShipCost(buildowner, 0, m_BuildType) * bcnt) > EM.PlanetItemGet_Sub(buildowner,planet,Common.ItemTypeModule,true))) buildok = false;
				else if ((m_BuildAtSDM) && ((Common.ShipCostSDM[m_BuildType] * bcnt) > EM.m_UserSDM)) buildok = false;
			}
		}

		//
		if (m_BuildSlot.length > 0) sizey += BuildSlotSize;
		if (m_BuildSlot.length > 6) sizey += BuildSlotSize;
		if (m_BuildSlot.length > 12) sizey += BuildSlotSize;
		sizey += 10;
		
		m_ButClose.x = SizeX - 15 - m_ButClose.width;
		m_ButClose.y = sizey;
		
		m_ButBuild.x = m_ButClose.x - 15 - m_ButBuild.width;
		m_ButBuild.y = sizey;
		
		m_ButBuildMax.x = m_ButBuild.x - 5 - m_ButBuildMax.width;
		m_ButBuildMax.y = sizey;
		
		m_LabelCnt.x = 10;
		m_LabelCnt.y = sizey + 2;
		
		m_EditCnt.x = m_LabelCnt.x + m_LabelCnt.width + 5;
		m_EditCnt.y = sizey;
		m_EditCnt.width = m_ButBuildMax.x - m_EditCnt.x - 5;
		
		m_ButBuild.visible = buildok && buildokbut;
		m_LabelCnt.visible = buildok && (m_BuildType != Common.ShipTypeFlagship) && (m_BuildType != Common.ShipTypeQuarkBase);
		m_EditCnt.visible = m_LabelCnt.visible;
		m_ButBuildMax.visible = m_LabelCnt.visible;

		sizey += m_ButClose.height + 15;

		m_SizeY = sizey;

		m_Frame.width = SizeX;
		m_Frame.height = m_SizeY;
	}

	public function GetItemSlotX(slot:int):int
	{
		var i:int;
		for (i = 0; i < m_Item.length; i++) {
			var obj:Object = m_Item[i];
			if (obj.Num == slot) return x + obj.SlotN.x + (ItemSlotSize >> 1);
		}
		return 0;
	}
	
	public function GetItemSlotY(slot:int):int
	{
		var i:int;
		for (i = 0; i < m_Item.length; i++) {
			var obj:Object = m_Item[i];
			if (obj.Num == slot) return y + obj.SlotN.y + (ItemSlotSize >> 1);
		}
		return 0;
	}

	public function PickItem():int
	{
		if (!visible) return -1;
		var i:int;
		for (i = 0; i < m_Item.length; i++) {
			var obj:Object = m_Item[i];
			if (obj.SlotN.visible && obj.SlotN.hitTestPoint(stage.mouseX, stage.mouseY)) return i;
			if (obj.SlotN2.visible && obj.SlotN2.hitTestPoint(stage.mouseX, stage.mouseY)) return i;
			if (obj.SlotA.visible && obj.SlotA.hitTestPoint(stage.mouseX, stage.mouseY)) return i;
			if (obj.SlotE.visible && obj.SlotE.hitTestPoint(stage.mouseX, stage.mouseY)) return i;
		}
		return -1;
	}

	public function PickBuild():int
	{
		var ix:int = (mouseX - BuildSlotOffX);
		var iy:int = (mouseY - m_BuildSlotOffY);

		if (ix < 0) return -1;
		if (iy < 0) return -1;

		ix = Math.floor(ix / BuildSlotSize);
		iy = Math.floor(iy / BuildSlotSize);
		
		if (ix >= 6) return -1;

		var n:int = ix + iy * 6;
		if (n<0 || n>=m_BuildSlot.length) return -1;
		
		if (m_BuildSlot[n].Type == 0) return -1;

		return n;
	}
	
	public function PickCell():int
	{
		if (!m_ShowTer) return -1;
		
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return -1;
		
		var tpx:int = mouseX;
		var tpy:int = mouseY;
		
		var iy:int = Math.ceil(Number(CellHalfSizeX * (tpy - m_GridStartY) + CellHalfSizeY * (m_GridStartX - tpx)) / Number(CellHalfSizeX * 2 * CellHalfSizeY));
		var ix:int = Math.ceil(Number(CellHalfSizeX * (tpy - m_GridStartY) + CellHalfSizeY * (tpx - m_GridStartX)) / Number(CellHalfSizeX * 2 * CellHalfSizeY));
		
		if (ix<0 || ix>=PlanetGridCntX || iy<0 || iy>=PlanetGridCntY) return -1;
		
		if (planet.m_Flag & Planet.PlanetFlagLarge) return PlanetGridToCell_Large[ix + iy * PlanetGridCntX];
		else return PlanetGridToCell_Small[ix + iy * PlanetGridCntX];
	}
	
	public function GetCellX(icell:int):int
	{
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return 0;
		
		if (planet.PlanetCellType(icell) == 0) return 0;
		
		var g:int = 0;
		if (planet.m_Flag & Planet.PlanetFlagLarge) g = PlanetCellToGrid_Large[icell];
		else g = PlanetCellToGrid_Small[icell];
		
		var ix:int = g % PlanetGridCntX;
		var iy:int = Math.floor(g / PlanetGridCntX);
		
		return m_GridStartX + ix * CellHalfSizeX - iy * CellHalfSizeX;
	}

	public function GetCellY(icell:int):int
	{
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return 0;
		
		if (planet.PlanetCellType(icell) == 0) return 0;
		
		var g:int = 0;
		if (planet.m_Flag & Planet.PlanetFlagLarge) g = PlanetCellToGrid_Large[icell];
		else g = PlanetCellToGrid_Small[icell];
		
		var ix:int = g % PlanetGridCntX;
		var iy:int = Math.floor(g / PlanetGridCntX);
		
		return m_GridStartY + ix * CellHalfSizeY + iy * CellHalfSizeY;
	}

	public function onMouseClick(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function onMouseDown(e:MouseEvent) : void
	{
		var planet:Planet;

		e.stopImmediatePropagation();
		EM.FloatTop(this);

		if (FormMessageBox.Self.visible) return;
		if (EM.m_FormInput.visible) return;
		if (EM.m_FormConstruction.visible) return;

		if (m_ButMenu.hitTestPoint(e.stageX, e.stageY)) { MenuOpen(); return; } // { if (EM.m_FormMenu.visible) EM.m_FormMenu.Clear(); else MenuOpen(); return; }
		//EM.m_FormMenu.Clear();

		if (m_ButClose.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ButBuild.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ButBuildMax.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_EditCnt.hitTestPoint(e.stageX, e.stageY)) return;

		onMouseMove(e);

		if (m_BuildSlotMouse >= 0 && m_BuildSlotMouse < m_BuildSlot.length) {
			if(m_BuildType != m_BuildSlot[m_BuildSlotMouse].Type || m_BuildId != m_BuildSlot[m_BuildSlotMouse].Id) {
				m_BuildType = m_BuildSlot[m_BuildSlotMouse].Type;
				m_BuildId = m_BuildSlot[m_BuildSlotMouse].Id;
				BuildChangeType();
				Update();
			}
			return;

		} else if (m_CellMouse >= 0) {
			planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
			if (planet != null) {
				if (planet.PlanetCellType(m_CellMouse)<=0/* m_CellMouse == 4 || m_CellMouse == 7*/) { }
				else {
					if ((planet.m_Cell[m_CellMouse] >> 3) == 0) {
						while (true) {
							if (EM.IsEdit()) { }
							else if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && ((EM.m_OpsFlag & Common.OpsFlagBuilding) == 0)) break;
							else if (EM.AccessBuild(planet.m_Owner)) { }
							else break;

							EM.m_FormConstruction.Show();
							break;
						}
					}
					else MenuCell();
				}
			}

			return;
		} else if (m_ItemSlotMouse >= 0) {
			m_ItemSlotDown = m_ItemSlotMouse;
			return;
		}

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true, 999);
		return;
	}

	public function onMouseUp(event:MouseEvent) : void
	{
		event.stopImmediatePropagation();
		if (m_ItemSlotDown >= 0) {
			m_ItemSlotDown = -1;
			if (m_ItemSlotMouse >= 0) {
				MenuItem();
			}
		}
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	public function onMouseMove(e:MouseEvent) : void
	{
		e.stopImmediatePropagation();

		if (EM.m_FormMenu.visible) return;
		if (EM.m_FormConstruction.visible) return;

		var s:int, icell:int, nitem:int;
		var planet:Planet;
		
		var hideinfo:Boolean = true;

		s = PickBuild();
		if (s != m_BuildSlotMouse) {
			m_BuildSlotMouse = s;
			Update();
		}
		icell = PickCell();
		if (icell != m_CellMouse) {
			m_CellMouse = icell;
			Update();
		}
		nitem = PickItem();
		if (nitem != m_ItemSlotMouse) {
			m_ItemSlotMouse = nitem;
			Update();
		}

		if (m_ItemSlotDown >= 0 && m_ItemSlotMouse != m_ItemSlotDown)
		{
			EM.m_Info.Hide();
			EM.m_MoveItem.Begin(1, m_ItemSlotDown);
			m_ItemSlotDown = -1;
			m_ItemSlotMouse = -1;
			Update();
			return;
		}

		if (hideinfo && s >= 0)	{
			planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
			if (planet != null)	{
				var obj:Object = m_BuildSlot[s];
				if(obj!=null) {
					EM.m_Info.ShowShipType(planet.m_Owner, 0, obj.Type, obj.Id, x + obj.SlotN.x - 2, y + obj.SlotN.y - 2, obj.SlotN.width + 4, obj.SlotN.height + 4);
					hideinfo = false;
				}
			}
		}
		if (hideinfo && nitem >= 0) {
			planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
			if (planet != null && planet.m_Item[nitem].m_Type != 0)
			{
				EM.m_Info.ShowItemEx(planet.m_Item[nitem], planet.m_Item[nitem].m_Type, planet.m_Item[nitem].m_Cnt, 0, planet.m_Item[nitem].m_Complete, planet.m_Item[nitem].m_Broken, GetItemSlotX(nitem) - (ItemSlotSize >> 1), GetItemSlotY(nitem) - (ItemSlotSize >> 1), ItemSlotSize, ItemSlotSize);
				hideinfo = false;
			}
		}
		if (hideinfo && icell >= 0)
		{
			planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
			if (planet != null && planet.PlanetCellType(icell)<0/* (icell == 4 || icell == 7)*/ && planet.m_OreItem) {
				EM.m_Info.ShowPlanetOre(icell,planet.m_OreItem, x+GetCellX(icell)-CellHalfSizeX, y+GetCellY(icell)-CellHalfSizeY*2, CellHalfSizeX*2, CellHalfSizeY*2);
				hideinfo = false;

			} else if (planet != null && planet.m_Cell[icell] != 0) {
				EM.m_Info.ShowBuilding(icell, planet.m_Cell[icell] >> 3, planet.m_Cell[icell] & 7, 0, x+GetCellX(icell)-CellHalfSizeX, y+GetCellY(icell)-CellHalfSizeY*2, CellHalfSizeX*2, CellHalfSizeY*2);
				hideinfo = false;
			}
		}

		if (hideinfo) EM.m_Info.Hide();
	}

	public function MenuOpen() : void
	{
		var obj:Object;
		var pc:int;
		
		EM.m_FormMenu.Clear();
		
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

//		if (planet.m_PortalPlanet != 0)	{
//			if (planet.m_PortalCotlId == 0) EM.m_FormMenu.Add(Common.Txt.ButPortalJump, EM.MsgPortalJump, 1);
//			else EM.m_FormMenu.Add(Common.Txt.ButPortalHyperJump, EM.MsgPortalHyperJump, 1);
//		}

		if ((EM.m_GameState & Common.GameStateWait) == 0 && (EM.m_GameState & Common.GameStateDevelopment)==0) {
			while(!EM.IsEdit() && EM.m_UnionId != 0 && EM.m_CotlUnionId != EM.m_UnionId && (EM.m_OpsPriceCaptureType != 0 || EM.m_OpsPriceCaptureEgm != 0)) {
				if ((EM.m_CotlType == Common.CotlTypeProtect) && planet.m_Owner == Server.Self.m_UserId && (planet.m_Flag & Planet.PlanetFlagHomeworld) != 0) {}
				else if (EM.IsWinMaxEnclave() && (planet.m_Flag & Planet.PlanetFlagCitadel) != 0) { }
				else if (EM.IsWinOccupyHomeworld() && (planet.m_Flag & Planet.PlanetFlagHomeworld) != 0) { }
				else break;

				pc = Math.floor((EM.m_BasePlanetCnt * 100.0) / EM.m_AllPlanetCnt);

				if(EM.IsWinMaxEnclave() || EM.IsWinOccupyHomeworld()) obj = EM.m_FormMenu.Add(Common.Txt.CotlCaptureAndControl);
				else obj = EM.m_FormMenu.Add(Common.Txt.CotlBuyControl);
				//if (EM.m_CotlType == Common.CotlTypeRich && EM.CntFriendGroup(planet, Server.Self.m_UserId, Common.RaceNone, false)>0 && EM.IsBattle(planet, Server.Self.m_UserId, Common.RaceNone, false, true)) obj.Disable = true;
				if (EM.IsWinOccupyHomeworld() && (EM.m_GameTime*1000 > EM.m_ServerCalcTime || EM.CntFriendGroup(planet,Server.Self.m_UserId,Common.RaceNone,false)<=0 || EM.IsBattle(planet,Server.Self.m_UserId,Common.RaceNone,false,true))) obj.Disable = true;
				else if (EM.IsWinMaxEnclave() && pc < EM.m_OpsWinScore) obj.Disable = true;
				else obj.Fun = clickBuyControl; //EM.MsgBuyControl;

				break;
			}

			while (EM.IsWinOccupyHomeworld() && !EM.IsEdit() && (planet.m_Flag & Planet.PlanetFlagHomeworld) != 0) {
				obj = EM.m_FormMenu.Add(Common.Txt.CotlCapture);
				
				if (EM.m_GameTime*1000 > EM.m_ServerCalcTime || EM.CntFriendGroup(planet,Server.Self.m_UserId,Common.RaceNone,false)<=0 || EM.IsBattle(planet,Server.Self.m_UserId,Common.RaceNone,false,true)) obj.Disable = true;
				else obj.Fun = clickFixControl;// EM.ActionFixControl;

				break;
			}
			while (EM.IsWinMaxEnclave() && !EM.IsEdit() && (planet.m_Flag & Planet.PlanetFlagCitadel) != 0 && (planet.m_Owner==Server.Self.m_UserId)) {
				obj = EM.m_FormMenu.Add(Common.Txt.CotlCapture);

				pc = Math.floor((EM.m_BasePlanetCnt * 100.0) / EM.m_AllPlanetCnt);

				if (/*EM.m_UnionId == 0 || */pc<EM.m_OpsWinScore) obj.Disable = true;
				else obj.Fun = clickFixControl;// EM.ActionFixControl;

				break;
			}
		}

		EM.m_FormMenu.Add();

		if(EM.AccessBuild(planet.m_Owner)) {
			if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat || EM.m_CotlType == Common.CotlTypeRich) && (EM.m_OpsFlag & Common.OpsFlagBuildMask)==0) {}
			else EM.m_FormMenu.Add(Common.Txt.AutoBuild, PlanetAutoBuild).Check = (planet.m_Flag & Planet.PlanetFlagAutoBuild) != 0;
		}
		
		if((!EM.IsEdit()) && (planet.m_Owner==Server.Self.m_UserId || planet.m_Owner==0) && (EM.m_CotlType==Common.CotlTypeUser)) EM.m_FormMenu.Add(Common.Txt.BuildSDM, PriceAtSDM).Check = m_BuildAtSDM;

		EM.m_FormMenu.Add();

		while (planet.m_Owner == 0 && (planet.m_Flag & (Planet.PlanetFlagHomeworld | Planet.PlanetFlagCitadel | Planet.PlanetFlagRich | Planet.PlanetFlagGigant | Planet.PlanetFlagSun)) == 0 && EM.IsWinMaxEnclave()) {
			EM.m_FormMenu.Add(Common.Txt.ButBase,MsgBase);
			break;
		}

		while((planet.m_Owner==Server.Self.m_UserId) && !(planet.m_Flag & Planet.PlanetFlagHomeworld) && !(planet.m_Flag & Planet.PlanetFlagCitadel)) {
			//if (EM.m_CotlType == 0) { }
			//else 
			if (EM.m_CotlType == Common.CotlTypeRich && (EM.m_OpsFlag & Common.OpsFlagEnclave) == 0) break;
			else if (EM.m_CotlType == Common.CotlTypeRich) { }
			else break;

			EM.m_FormMenu.Add(Common.Txt.ButCitadel,MsgCitadel);
			break;
		}

		if(!(planet.m_Flag & Planet.PlanetFlagHomeworld) && !(planet.m_Flag & Planet.PlanetFlagWormhole) && (EM.AccessBuild(planet.m_Owner))) {
			EM.m_FormMenu.Add(Common.Txt.ButLeave,MsgDestroy);
		}

		if ((planet.m_Flag & Planet.PlanetFlagHomeworld) && !(planet.m_Flag & Planet.PlanetFlagWormhole) && (planet.m_Owner == Server.Self.m_UserId) && EM.m_CotlType == Common.CotlTypeUser) {
			EM.m_FormMenu.Add(Common.Txt.ButChangeRace, MsgChangeRace);
			EM.m_FormMenu.Add(Common.Txt.ButDestroyEmpire, MsgDestroyEmpire);
		}
	
/*		if((m_Access & Common.AccessPact) && (planet.m_Owner!=0) && (planet.m_Owner!=Server.Self.m_UserId) && (planet.m_Owner & Common.OwnerAI)==0) {
			m_FormMenu.Add(Common.Txt.PactMenu,EM.MsgPact,1);
		}*/
		
		EM.m_FormMenu.Add();
		if (EM.AccessBuild(planet.m_Owner)) EM.m_FormMenu.Add(Common.Txt.FormPlanetBuilding, clickConstruction);

		if (EM.m_UserAccess & User.AccessGalaxyOps) {
			EM.m_FormMenu.Add("Log: Planet", clickLogPlanet);
			EM.m_FormMenu.Add("Log: Off", clickLogOff);
		}
		
		while((planet.m_Owner==0) && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))) {
			if(EM.m_CotlType==0) {}
			else if(EM.m_CotlType==Common.CotlTypeUser && Server.Self.m_UserId==EM.m_CotlOwnerId) {}
			else break;
			EM.m_FormMenu.Add(Common.Txt.NewHomeworld,EM.MsgNewHomeworld);
			break;
		}

		EM.m_FormMenu.Add(Common.Txt.ButClose, clickClose);
		
		EM.m_FormMenu.SetButOpen(m_ButMenu);
		EM.m_FormMenu.Show(x + m_ButMenu.x, y + m_ButMenu.y, x + m_ButMenu.x + m_ButMenu.width, y + m_ButMenu.y + m_ButMenu.height);
	}
	
	private function clickBuyControl(...args):void
	{
		var date:Date = new Date();
		var h:int = date.hours;

		var str:String = "";

		if (EM.m_OpsPriceCaptureType != 0 && EM.m_OpsPriceCaptureEgm != 0) {
			str = Common.Txt.CotlBuyControlQueryPlusEgm;

			str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(EM.m_OpsPriceCapture));
			str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[EM.m_OpsPriceCaptureType]);
			str = BaseStr.Replace(str, "<PriceEGM>", BaseStr.FormatBigInt(EM.m_OpsPriceCaptureEgm));

		} else if(EM.m_OpsPriceCaptureType != 0) {
			str = Common.Txt.CotlBuyControlQuery;

			str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(EM.m_OpsPriceCapture));
			str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[EM.m_OpsPriceCaptureType]);

		} else if (EM.m_OpsPriceCaptureEgm != 0) {
			str = Common.Txt.CotlBuyControlQuery;

			str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(EM.m_OpsPriceCaptureEgm));
			str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[Common.OpsPriceTypeEGM]);

		} else return;

		EM.m_FormInput.Init(300);

		EM.m_FormInput.AddLabel(str, 16, 0xffffff, true);

		EM.m_FormInput.AddLabel(Common.Txt.CotlCaptureNextHour+":");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddInput(h.toString(), 2, true, 0, false);

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(ActionBuyControl,StdMap.Txt.ButYes,Common.Txt.ButClose);
	}

	private function ActionBuyControl():void
	{
		var h:int = Common.NormHour(EM.m_FormInput.GetInt(0) - EmpireMap.Self.m_DifClientServerHour);

		var sumegm:int = EM.m_OpsPriceCaptureEgm;
		if (EM.m_OpsPriceCaptureType == Common.OpsPriceTypeEGM) sumegm += EM.m_OpsPriceCapture;

		if(sumegm>0 && EM.m_UserEGM<sumegm) { FormMessageBox.Run(Common.Txt.NoEnoughEGM2,Common.Txt.ButClose); return; }

		if (EM.m_OpsPriceCaptureType == Common.OpsPriceTypeCr && EM.m_FormFleetBar.m_FleetMoney < EM.m_OpsPriceCapture) { FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose); return;  }

		EM.m_CotlUnionId=EM.m_UnionId; 

		EM.SendAction("embuycotl", m_SectorX.toString() + "_" + m_SectorY.toString() + "_" + m_PlanetNum.toString() + "_1_" + h.toString());
	}

	private function clickFixControl(...args):void
	{
		var date:Date = new Date();
		var h:int = date.hours;

		EM.m_FormInput.Init(300);

		EM.m_FormInput.AddLabel(Common.Txt.CotlCaptureQuery, 16, 0xffffff, true);

		EM.m_FormInput.AddLabel(Common.Txt.CotlCaptureNextHour+":");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddInput(h.toString(), 2, true, 0, false);

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(ActionFixControl,StdMap.Txt.ButYes,Common.Txt.ButClose);
	}
	
	private function ActionFixControl():void
	{
		var h:int = Common.NormHour(EM.m_FormInput.GetInt(0) - EmpireMap.Self.m_DifClientServerHour);

		EM.SendAction("embuycotl", m_SectorX.toString() + "_" + m_SectorY.toString() + "_" + m_PlanetNum.toString() + "_0_" + h.toString());
	}

	private function clickLogPlanet(...args):void
	{
		var ac:Action=new Action(EM);
		ac.ActionSpecial(22,m_SectorX,m_SectorY,m_PlanetNum,-1);
		EM.m_LogicAction.push(ac);
	}

	private function clickLogOff(...args):void
	{
		var ac:Action=new Action(EM);
		ac.ActionSpecial(22,0,0,-1,-1);
		EM.m_LogicAction.push(ac);
	}

	private function clickConstruction(...args):void
	{
		m_CellMouse = -1;
		EM.m_FormConstruction.Show();
	}

	private function MsgBase(...args):void
	{
		var str:String;
		
		var cotl:SpaceCotl=EM.HS.GetCotl(Server.Self.m_CotlId);
		if (cotl == null) return;
		
		if (!EM.OnOrbitCotl(Server.Self.m_CotlId)) {
			FormMessageBox.Run(BaseStr.Replace(Common.Txt.WarningFleetFarEx,"[br]"," "));
			
		} else if (cotl.m_ProtectTime > EM.GetServerGlobalTime()) {
			FormMessageBox.Run(Common.Txt.WarningCotlProtectSimple);
			
		} else {
			var et:Number = Math.max(EM.m_UserEmpireCreateTime + Common.NewBaseCooldown * 1000, EM.m_UserCitadelBuildDate + 60 * 60 * 12 * 1000);
			if (EM.GetServerGlobalTime() < et) {
				str=Common.Txt.NewBaseCooldown;
				str = BaseStr.Replace(str, "<Val>", Common.FormatPeriodLong((et - EM.GetServerGlobalTime()) / 1000));
				FormMessageBox.Run(str);
			} else {
				str = Common.Txt.QueryBase;
				str=BaseStr.Replace(str,"<Val>",BaseStr.FormatBigInt(Common.CitadelCost));  

				FormMessageBox.Run(str, null, null/*StdMap.Txt.ButNo, StdMap.Txt.ButYes*/, ActionBase);
			}
		}
	}

	private function ActionBase():void
	{
		if (EM.m_FormFleetBar.m_FleetMoney < Common.CitadelCost) {
			FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose);
			return;
		}

		EM.SendAction("emspecial", "25_" + m_SectorX.toString() + "_" + m_SectorY.toString() + "_" + m_PlanetNum.toString() + "_-1");
	}

	private function MsgCitadel(...args):void
	{
		var et:Number = EM.m_UserCitadelBuildDate + 60 * 60 * 12 * 1000;
		if (EM.GetServerGlobalTime() < et) {
			str=Common.Txt.NewCitadelCooldown;
			str = BaseStr.Replace(str, "<Val>", Common.FormatPeriodLong((et - EM.GetServerGlobalTime()) / 1000));
			FormMessageBox.Run(str);
			return;
		}

		var i:int;
		var cnt:int = 0;
		var cost:int = Common.CitadelCost;
		for (i = 0; i < Common.CitadelMax; i++) {
			if (EmpireMap.Self.m_CitadelNum[i] < 0) continue;
			cost *= 2;
			cnt++;
		}

		if (cnt >= Common.CitadelMax) {
			FormMessageBox.RunErr(Common.Txt.NewCitadelMax);
			return;
		}

		var str:String = Common.Txt.QueryCitadel;
		str=BaseStr.Replace(str,"<Val>",BaseStr.FormatBigInt(cost));  

		FormMessageBox.Run(str,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionCitadel);
	}
	
	private function ActionCitadel():void
	{
		var i:int;
		var cnt:int = 0;
		var cost:int = Common.CitadelCost;
		for (i = 0; i < Common.CitadelMax; i++) {
			if (EmpireMap.Self.m_CitadelNum[i] < 0) continue;
			cost *= 2;
			cnt++;
		}

		if (EM.m_FormFleetBar.m_FleetMoney < cost) {
			FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose);
			return;
		}

		var cotl2:SpaceCotl = EM.HS.GetCotl(EM.m_RootCotlId);
		if (cotl2 != null) { 
			if (cotl2.m_ProtectTime > EM.GetServerGlobalTime()) {
				FormMessageBox.Run(Common.Txt.WarningCotlProtectNoCitadel, Common.Txt.ButClose);
				return;
			}
			//if (cotl2.m_ProtectTime > EM.GetServerTime()) { EM.m_FormHint.Show(Common.Txt.WarningCotlProtectNoCitadel, Common.WarningHideTime); return;  }
		}
		
		
//		if(m_CotlType==0) {
//			var dx:int=(m_HomeworldSectorX-m_CurSectorX);
//			var dy:int=(m_HomeworldSectorY-m_CurSectorY);
//			if((dx*dx+dy*dy)<(Common.CitadelMinDist*Common.CitadelMinDist)) {
//				m_FormHint.Show(Common.Txt.WarningCitadelDist,Common.WarningHideTime);
//				return;
//			}
//		}

		EM.SendAction("emspecial", "3_" + m_SectorX.toString() + "_" + m_SectorY.toString() + "_" + m_PlanetNum.toString() + "_-1");
	}

	private function PlanetAutoBuild(...args):void
	{
		var ac:Action=new Action(EM);
		ac.ActionSpecial(19,m_SectorX,m_SectorY,m_PlanetNum,-1);
		EM.m_LogicAction.push(ac);
	}

	private function MsgDestroy(...args):void
	{
//		EM.FormHideAll();
		FormMessageBox.Run(Common.Txt.WarningLeave,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionDestroy);
	}

	private function ActionDestroy():void
	{
		var ac:Action=new Action(EM);
		ac.ActionDestroy(0, m_SectorX, m_SectorY, m_PlanetNum, -1);
		EM.m_LogicAction.push(ac);
		
		Hide();
	}

	private function MsgChangeRace(...args):void
	{
		var str:String;
		var et:Number = EM.m_UserEmpireCreateTime + 60 * 15 * 1000;

		if ((!EM.m_EmpireEdit) && EM.GetServerGlobalTime() < et) {
			str = Common.Txt.RaceChangeCooldown;
			str = BaseStr.Replace(str, "<Val>", Common.FormatPeriodLong((et - EM.GetServerGlobalTime()) / 1000));
			FormMessageBox.Run(str);
			return;
		}

		EmpireMap.Self.m_FormRace.Show(true);
	}

	private function MsgDestroyEmpire(...args):void
	{
		if (EM.m_GameState & Common.GameStateEnemy) {
			EM.m_FormHint.Show(Common.Txt.WarningNoOpEnemy, Common.WarningHideTime);
			return;
		}
		EM.FormHideAll();

		EM.m_FormInput.Init(400);

		EM.m_FormInput.AddLabel(Common.Txt.DestroyEmpireQuery+":");

		EM.m_FormInput.AddInput("",9,false,Server.LANG_ENG).addEventListener(Event.CHANGE,DestroyEmpireChange);

		EM.m_FormInput.AddLabel(Common.Txt.DestroyEmpireCom);

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(ActionDestroyEmpire,Common.Txt.DestroyEmpire);
		EM.m_FormInput.m_ButOk.visible=false;
	}

	private function DestroyEmpireChange(e:Event):void
	{
		EM.m_FormInput.m_ButOk.visible=EM.m_FormInput.GetStr(0)=='DELETE';
	}

	private function ActionDestroyEmpire():void
	{
		var ac:Action=new Action(EM);
		ac.ActionDestroy(2, m_SectorX, m_SectorY, m_PlanetNum, -1);
		EM.m_LogicAction.push(ac);

		Hide();
	}

	public function CalcMaxCnt(type:int, id:uint):int
	{
		if (m_BuildType == 0) return 0;
		var cnt:int = 0;
		
		var planet:Planet=EM.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if (planet == null) return 0;
			
		var buildforowner:uint = 0;
		if (planet.m_Owner != 0) {
			if (EM.AccessBuild(planet.m_Owner)) buildforowner = planet.m_Owner;

		} else if (planet.m_Owner == 0) {
			buildforowner = Server.Self.m_UserId;
		}
		if (buildforowner==0) return 0;

		if (!m_BuildAtSDM) cnt = EM.CalcBuildMaxCnt(buildforowner, type, m_SectorX, m_SectorY, m_PlanetNum);
		else cnt = EM.CalcBuildMaxCntSDM(buildforowner,type, m_SectorX, m_SectorY, m_PlanetNum);

		return cnt;
	}

	private function onDblClick(...args):void
	{
		if (m_BuildSlotMouse >= 0 && m_BuildSlotMouse < m_BuildSlot.length && m_BuildType != Common.ShipTypeNone && m_ButBuild.visible) {
			clickBuild();
		}
	}

	public function clickBuild(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if (FormMessageBox.Self.visible) return;
		if (EM.m_FormConstruction.visible) return;

		var cnt:int=int(m_EditCnt.text);
		var maxcnt:int=CalcMaxCnt(m_BuildType,m_BuildId);
		if(cnt>maxcnt) cnt=maxcnt;

		var id:uint=0;

		while(cnt>0) {
			var planet:Planet=EM.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
			if (planet == null) break;

			var buildforowner:uint = 0;
			if (planet.m_Owner != 0) {
				if (EM.AccessBuild(planet.m_Owner)) buildforowner = planet.m_Owner;

			} else if (planet.m_Owner == 0) {
				buildforowner = Server.Self.m_UserId;
			}
			if (buildforowner==0) break;

			var sn:int=EM.CalcBuildPlace(planet,buildforowner);
			if(sn<0) break;

			if (m_BuildType == Common.ShipTypeFlagship) id = m_BuildId;
			else {
				id=EM.NewShipId(buildforowner);
				if (id == 0) return;
			}

			var currency:int = 0;
			if (m_BuildAtSDM) currency = 1;

			var ac:Action=new Action(EM);
			ac.ActionBuild(id,m_SectorX,m_SectorY,m_PlanetNum,sn,m_BuildType,cnt,currency,buildforowner);
			EM.m_LogicAction.push(ac);
	
			break;
		}
		
		Hide();
	}	

	public function clickBuildMax(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if (FormMessageBox.Self.visible) return;
		if (EM.m_FormConstruction.visible) return;

		m_EditCnt.text=CalcMaxCnt(m_BuildType,m_BuildId).toString();
		m_EditCnt.setFocus();
		m_EditCnt.setSelection(0,m_EditCnt.text.length);
		Update();
	}

	public function BuildChangeCnt(event:Event=null):void
	{
		Update();
	}

	public function BuildChangeType(event:Event = null):void
	{
		var cnt:int = 0;
		if (m_BuildType != 0) {
			cnt = CalcMaxCnt(m_BuildType, m_BuildId);
			if (cnt>1 && m_BuildType == Common.ShipTypeSciBase) cnt = 1;
		}
		m_EditCnt.text = cnt.toString();
	}

	public function PriceAtSDM(...args):void
	{
		m_BuildAtSDM = !m_BuildAtSDM;
		Update();
	}

	public function MenuCell() : void
	{
		var i:int;
		
		EM.m_Info.Hide();
		
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

		var bt:int = planet.m_Cell[m_CellMouse] >> 3;
		var lvl:int = planet.m_Cell[m_CellMouse] & 7;
		if (bt == 0) return;

		EM.m_FormMenu.Clear();

		while (true) {
			if (EM.IsEdit()) { }
			else if (!EM.AccessBuild(planet.m_Owner)) break;
			else if (EM.m_CotlType == Common.CotlTypeUser && !EM.AccessBuild(EM.m_CotlOwnerId)) break;
			else if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && ((EM.m_OpsFlag & Common.OpsFlagBuilding) == 0)) break;

			while ((lvl < Common.BuildingLvlCnt) && (planet.m_CellBuildFlag & (1 << m_CellMouse)) == 0) {

				if(!EM.IsEdit()) {
					var user:User = UserList.Self.GetUser(planet.m_Owner);
					if (user == null) break;
					if (user.m_BuildingLvl[bt] < (lvl + 1)) break;
				}

				EM.m_FormMenu.Add(Common.Txt.FormPlanetCellUpgrade + ": " + Common.BuildingName[bt]);

				i = Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl + 1 - 1];
				if ((!EM.IsEdit()) && (i > EM.PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeModule, true))) EM.m_FormMenu.Add("    <font color='#afafaf'>" + Common.Txt.Cost + ":</font> <font color='#FF0000'>" + BaseStr.FormatBigInt(i) + "</font>");
				else EM.m_FormMenu.Add("    <font color='#afafaf'>" + Common.Txt.Cost + ":</font> <font color='#FFFF00'>" + BaseStr.FormatBigInt(i) + "</font>");

				i = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl +1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
				if (i == 0) { }
				else if (i < 0 && (planet.PlanetCalcEnergy() + i) < 0) EM.m_FormMenu.Add("    <font color='#afafaf'>" + Common.Txt.FormPlanetEnergy + ":</font> <font color='#FF0000'>" + i.toString() + "</font>");
				else if (i > 0) EM.m_FormMenu.Add("    <font color='#afafaf'>" + Common.Txt.FormPlanetEnergy + ":</font> <font color='#FFFF00'>+" + i.toString() + "</font>");
				else EM.m_FormMenu.Add("    <font color='#afafaf'>" + Common.Txt.FormPlanetEnergy + ":</font> <font color='#FFFF00'>" + i.toString() + "</font>");

				EM.m_FormMenu.Add("    " + Common.Txt.FormPlanetCellUpgradeBut + "", MsgCellUpgrade);

				break;
			}
			EM.m_FormMenu.Add();
			if ((planet.m_CellBuildFlag & (1 << m_CellMouse)) != 0) {
				EM.m_FormMenu.Add(Common.Txt.FormPlanetCellCancel,MsgCellCancel);
			} else {
				EM.m_FormMenu.Add(Common.Txt.FormPlanetCellDestroy,MsgCellDestroy);
			}
			break;
		}

		var cx:int=stage.mouseX;
		var cy:int=stage.mouseY;

		EM.m_FormMenu.Show(cx, cy, cx, cy);
	}

	public function MsgCellUpgrade(... args) : void
	{
		var i:int;

		if ((!EM.IsEdit()) && (EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && ((EM.m_OpsFlag & Common.OpsFlagBuilding) == 0)) return;

		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

		var bt:int = planet.m_Cell[m_CellMouse] >> 3;
		var lvl:int = planet.m_Cell[m_CellMouse] & 7;
		if (bt == 0) return;
		if (lvl >= Common.BuildingLvlCnt) return;

		if (EM.IsEdit()) { }
		else if (EM.PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeModule, true) < Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl + 1 - 1]) {
			FormMessageBox.Run(Common.Txt.NoEnoughModule, Common.Txt.ButClose);
			return;
		}

		i = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl + 1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
		if (i < 0 && (planet.PlanetCalcEnergy() + i) < 0) {
			FormMessageBox.Run(Common.Txt.FormPlanetNoEnough, Common.Txt.ButClose);
			return;
		}

		var ac:Action=new Action(EM);
		ac.ActionConstruction(m_SectorX,m_SectorY,m_PlanetNum,m_CellMouse,1,0);
		EM.m_LogicAction.push(ac);
	}

	public function MsgCellCancel(... args) : void
	{
		var e:int;

		if ((!EM.IsEdit()) && (EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && ((EM.m_OpsFlag & Common.OpsFlagBuilding) == 0)) return;

		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;
		
		var bt:int = planet.m_Cell[m_CellMouse] >> 3;
		var lvl:int = planet.m_Cell[m_CellMouse] & 7;
		if (bt == 0) return;
		
		if (lvl <= 1) {
			e = 0 - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
			if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) { FormMessageBox.Run(Common.Txt.FormPlanetNoEnoughDel,Common.Txt.ButClose); return; }
		} else {
			e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
			if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) { FormMessageBox.Run(Common.Txt.FormPlanetNoEnoughDel,Common.Txt.ButClose); return; }
		}

		var ac:Action=new Action(EM);
		ac.ActionConstruction(m_SectorX,m_SectorY,m_PlanetNum,m_CellMouse,2,0);
		EM.m_LogicAction.push(ac);
	}

	public function MsgCellDestroy(... args) : void
	{
		var e:int;

		if ((!EM.IsEdit()) && (EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && ((EM.m_OpsFlag & Common.OpsFlagBuilding) == 0)) return;

		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

		var bt:int = planet.m_Cell[m_CellMouse] >> 3;
		var lvl:int = planet.m_Cell[m_CellMouse] & 7;
		if (bt == 0) return;

//		if (lvl <= 1) {
			e = 0 - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
			if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) { FormMessageBox.Run(Common.Txt.FormPlanetNoEnoughDel,Common.Txt.ButClose); return; }
//		} else {
//			e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
//			if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) { FormMessageBox.Run(Common.Txt.FormPlanetNoEnoughDel,Common.Txt.ButClose); return; }
//		}

		var str:String;
		if (EM.IsEdit() || EM.m_CotlType == Common.CotlTypeUser) {
			str = Common.Txt.FormPlanetCellDestroyQuery;
		} else {
			str = Common.Txt.FormPlanetCellDestroyModuleQuery;
			str = BaseStr.Replace(str, "<Val>", "[clr]" + BaseStr.FormatBigInt(Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl - 1] >> 1) + "[/clr]");
		}

		FormMessageBox.Run(str, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionCellDestroy);
	}

	public function ActionCellDestroy() : void
	{
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

		var bt:int = planet.m_Cell[m_CellMouse] >> 3;
		var lvl:int = planet.m_Cell[m_CellMouse] & 7;
		if (bt == 0) return;

		if (!EM.IsEdit() && EM.m_CotlType != Common.CotlTypeUser && EM.PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeModule, true) < (Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl - 1] >> 1)) {
			FormMessageBox.Run(Common.Txt.NoEnoughModule, Common.Txt.ButClose);
			return;
		}

		var ac:Action=new Action(EM);
		ac.ActionConstruction(m_SectorX,m_SectorY,m_PlanetNum,m_CellMouse,3,0);
		EM.m_LogicAction.push(ac);
	}

	public function MenuItem() : void
	{
		var bh:Boolean;
		var ship:Ship;
		var i:int;
		var ar:Array = new Array();
		var obj:Object;

		EM.m_Info.Hide();

		EM.m_FormMenu.Clear();
		
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;
		
		var ctrl:Boolean = false;
		var sack:Boolean = false;

		if (EM.IsEdit()) ctrl = true;
		else if (planet.m_Owner == 0) {
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i];
				if (ship.m_Type != Common.ShipTypeServiceBase) continue;
				if ((ship.m_Flag & Common.ShipFlagBuild) != 0) continue;
				if (ship.m_Owner != Server.Self.m_UserId) continue;
				ctrl = true;
				break;
			}
			//if (i >= Common.ShipOnPlanetMax) return;
		}
		else if (planet.m_Owner == Server.Self.m_UserId) ctrl = true;
		
		if (!ctrl && EM.ExistFriendShip(planet, Server.Self.m_UserId, Common.RaceNone, false, 0)) {
			sack = true;
		}
		
		if ((!ctrl) && (!sack) && (EM.m_CotlType != Common.CotlTypeProtect && EM.m_CotlType != Common.CotlTypeCombat)) return;

		if (ctrl && (planet.m_Item[m_ItemSlotMouse].m_Type != 0)) {
			EM.m_FormMenu.Add(Common.Txt.FormPlanetItemShowCnt, MsgItemShowCnt).Check = (planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagShowCnt) != 0;

			EM.m_FormMenu.Add();

			EM.m_FormMenu.Add(Common.Txt.FormPlanetItemNoMove, MsgItemNoMove).Check = (planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagNoMove) != 0;

			EM.m_FormMenu.Add(Common.Txt.FormPlanetItemToPortal, MsgItemToPortal).Check = (planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagToPortal) != 0;
			
			if (EM.m_CotlType == Common.CotlTypeUser || (EM.m_CotlType == Common.CotlTypeRich && EM.IsEdit())) {
				if (planet.m_Item[m_ItemSlotMouse].m_Type != Common.ItemTypeEGM && planet.m_Item[m_ItemSlotMouse].m_Type != Common.ItemTypeMoney) EM.m_FormMenu.Add(Common.Txt.FormPlanetItemImport, MsgItemImport).Check = (planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagImport) != 0;
				if(planet.m_Item[m_ItemSlotMouse].m_Type!=Common.ItemTypeEGM) EM.m_FormMenu.Add(Common.Txt.FormPlanetItemExport, MsgItemExport).Check = (planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagExport) != 0;
			}
		}

		EM.m_FormMenu.Add();

		var str_build:String = Common.Txt.FormPlanetItemBuild;
		if (((planet.m_Item[m_ItemSlotMouse].m_Type & 0xffff) == Common.ItemTypeTechnician) || ((planet.m_Item[m_ItemSlotMouse].m_Type & 0xffff) == Common.ItemTypeNavigator)) str_build = Common.Txt.FormPlanetItemBuildNav;

		if(ctrl) {
			if (planet.m_Item[m_ItemSlotMouse].m_Type == 0) {
				// Производимые итемы
				bh = false;
				ar.length = 0;

				while (true) {
					if ((planet.m_Flag & (Planet.PlanetFlagHomeworld)) != 0) { }
					if ((planet.m_Flag & (Planet.PlanetFlagCitadel)) != 0 && EM.IsWinMaxEnclave()) { }
					else break;

					ar.push(Common.ItemTypeModule);
					if (!bh) { bh = true; EM.m_FormMenu.Add(Common.Txt.FormPlanetItemBuildBase + ": "); }
					EM.m_FormMenu.Add("    " + EM.Txt_ItemName(Common.ItemTypeModule), MsgItemBuildBase, Common.ItemTypeModule);
					break;
				}

				if ((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge) && ar.indexOf(Common.ItemTypeHydrogen)<0) {
					for (i = 0; i < Common.ShipOnPlanetMax; i++) {
						ship = planet.m_Ship[i];
						if (ship.m_Type != Common.ShipTypeServiceBase) continue;
						if ((ship.m_Flag & Common.ShipFlagBuild) != 0) continue;
						break;
					}
					if (i < Common.ShipOnPlanetMax) {
						ar.push(Common.ItemTypeHydrogen);
						if (!bh) { bh = true; EM.m_FormMenu.Add(Common.Txt.FormPlanetItemBuildBase + ": "); }
						EM.m_FormMenu.Add("    " + EM.Txt_ItemName(Common.ItemTypeHydrogen), MsgItemBuildBase, Common.ItemTypeHydrogen);
					}
				}

				for (i = 0; i < Common.BuildingItem.length; i++) {
					obj = Common.BuildingItem[i];
					if (obj.Build==0) continue;
					if (ar.indexOf(obj.ItemType) >= 0) continue;
					if (planet.ConstructionLvl(obj.BuildingType, false) <= 0) continue;
					ar.push(obj.ItemType);
					if (!bh) { bh = true; EM.m_FormMenu.Add(Common.Txt.FormPlanetItemBuildBase + ": "); }
					EM.m_FormMenu.Add("    " + EM.Txt_ItemName(obj.ItemType), MsgItemBuildBase, obj.ItemType);
				}

				// Итемы потребления
				bh = false;
				ar.length = 0;

				for (i = 0; i < Common.BuildingItem.length; i++) {
					obj = Common.BuildingItem[i];
					if (obj.Build!=0) continue;
					if (ar.indexOf(obj.ItemType) >= 0) continue;
					if (planet.ConstructionLvl(obj.BuildingType,false) <= 0) continue;
					ar.push(obj.ItemType);
					if (!bh) { bh = true; EM.m_FormMenu.Add(Common.Txt.FormPlanetItemBuildSupply + ": "); }
					EM.m_FormMenu.Add("    " + EM.Txt_ItemName(obj.ItemType), MsgItemBuildBase, obj.ItemType);
				}

				// Другие итемы для редактирования
				if(EmpireMap.Self.IsEdit()) {
					bh = false;
					ar.length = 0;

					for (i = 0; i < Common.BuildingItem.length; i++) {
						obj = Common.BuildingItem[i];
//						if (obj.Build!=0) continue;
						if (ar.indexOf(obj.ItemType) >= 0) continue;
//						if (planet.ConstructionLvl(obj.BuildingType,false) <= 0) continue;
						ar.push(obj.ItemType);
						if (!bh) { bh = true; EM.m_FormMenu.Add(Common.Txt.FormPlanetItemEditItem + ": "); }
						EM.m_FormMenu.Add("    " + EM.Txt_ItemName(obj.ItemType), MsgItemBuildBase, obj.ItemType);
					}
				}

			} else if (planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagBuild) {
				EM.m_FormMenu.Add(str_build, MsgItemBuild).Check = true;

			} else if ((planet.m_Flag & (Planet.PlanetFlagHomeworld)) != 0) {
				EM.m_FormMenu.Add(str_build, MsgItemBuild).Check = false;
				
			} else if ((planet.m_Flag & (Planet.PlanetFlagCitadel)) != 0 && EM.IsWinMaxEnclave()) {
				EM.m_FormMenu.Add(str_build, MsgItemBuild).Check = false;

			} else if ((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) {
				EM.m_FormMenu.Add(str_build, MsgItemBuild).Check = false;

			} else {
				for (i = 0; i < Common.BuildingItem.length; i++) {
					if (Common.BuildingItem[i].Build == 0) continue;
					if (Common.BuildingItem[i].ItemType != (planet.m_Item[m_ItemSlotMouse].m_Type & 0xffff)) continue;
					if (planet.ConstructionLvl(Common.BuildingItem[i].BuildingType,false) <= 0) continue;
					break;
				}
				if (planet.m_Item[m_ItemSlotMouse].m_Type != 0 && i<Common.BuildingItem.length) {
					EM.m_FormMenu.Add(str_build, MsgItemBuild).Check = false;
				}
			}
		}

		while (ctrl && (planet.m_Item[m_ItemSlotMouse].m_Type != 0)) {
			var idesc:Item = UserList.Self.GetItem(planet.m_Item[m_ItemSlotMouse].m_Type & 0xffff);
			if (idesc == null) break;

			bh = false;

			var ib0:int = (planet.m_Item[m_ItemSlotMouse].m_Type >> 16) & 15;
			var ib1:int = (planet.m_Item[m_ItemSlotMouse].m_Type >> 20) & 15;
			var ib2:int = (planet.m_Item[m_ItemSlotMouse].m_Type >> 24) & 15;
			var ib3:int = (planet.m_Item[m_ItemSlotMouse].m_Type >> 28) & 15;

			for (i = 4; i < 12; i++) {
				if (idesc.m_BonusType[i] == 0) continue;

				if (!bh) { 
					bh = true; EM.m_FormMenu.Add(); 
					if((planet.m_Item[m_ItemSlotMouse].m_Type & 0xffff)==Common.ItemTypeTechnician || (planet.m_Item[m_ItemSlotMouse].m_Type & 0xffff)==Common.ItemTypeNavigator) EM.m_FormMenu.Add(Common.Txt.FormPlanetBonusCaptionNavigator+":"); 
				}
				obj = EM.m_FormMenu.Add(BaseStr.FormatTag("    " + Common.ItemBonusName[idesc.m_BonusType[i]] + ": [clr]" + Math.round(idesc.m_BonusVal[i] * 100.0 / 256.0).toString() + "%[/clr]"), MsgItemBonusChange, i);
				if (ib0 == i || ib1 == i || ib2 == i || ib3 == i) obj.Check = true;
			}

			break;
		}

		if(!sack && planet.m_Item[m_ItemSlotMouse].m_Type != 0 && planet.m_Owner!=0/*&& planet.m_Owner==Server.Self.m_UserId*/) {
			EM.m_FormMenu.Add();
			EM.m_FormMenu.Add(Common.Txt.FormPlanetItemBalans, ItemBalans);
		}

		EM.m_FormMenu.Add();

		if (!sack && planet.m_Item[m_ItemSlotMouse].m_Type != 0 && (EM.m_EmpireEdit || EM.IsEdit())) {
			EM.m_FormMenu.Add(Common.TxtEdit.ChangeCnt, MsgItemChangeCnt);
		}

		if (ctrl && (planet.m_Item[m_ItemSlotMouse].m_Type != 0)) {
			obj = EM.m_FormMenu.Add(Common.Txt.FormPlanetToTransport);
			obj.Fun = ItemToTransport;
		}

		if(ctrl && (planet.m_Item[m_ItemSlotMouse].m_Type != 0)) {
			if (planet.m_Item[m_ItemSlotMouse].m_Type == Common.ItemTypeMoney) obj=EM.m_FormMenu.Add(Common.Txt.FormPlanetToFleetMoney); 
			else obj = EM.m_FormMenu.Add(Common.Txt.FormPlanetToFleet); 

			if (planet.m_Item[m_ItemSlotMouse].m_Cnt > 0) obj.Fun = ItemToFleet;
			else obj.Disable = true;
			
		} else if (sack && (planet.m_Item[m_ItemSlotMouse].m_Type != 0)) {
			if (planet.m_Item[m_ItemSlotMouse].m_Type == Common.ItemTypeMoney) obj=EM.m_FormMenu.Add(Common.Txt.FormPlanetSackToFleetMoney); 
			else obj = EM.m_FormMenu.Add(Common.Txt.FormPlanetSackToFleet); 

			if (planet.m_Item[m_ItemSlotMouse].m_Cnt > 0 && !EM.ExistEnemyShip(planet, Server.Self.m_UserId, Common.RaceNone, false, 0, true)) obj.Fun = ItemToFleet;
			else obj.Disable = true;
		}

		if (ctrl && (planet.m_Item[m_ItemSlotMouse].m_Type != 0)) {
			if (planet.m_Item[m_ItemSlotMouse].m_Cnt > 0) EM.m_FormMenu.Add(Common.Txt.FormPlanetItemDestroy, MsgItemDelete);
			else EM.m_FormMenu.Add(Common.Txt.FormPlanetItemClear, MsgItemClear);
		}

		var tx:int = GetItemSlotX(m_ItemSlotMouse) - (ItemSlotSize >> 1);
		var ty:int = GetItemSlotY(m_ItemSlotMouse) - (ItemSlotSize >> 1);
		EM.m_FormMenu.Show(tx, ty, tx + ItemSlotSize, ty + ItemSlotSize);
	}
	
	public function ItemBalans(...args):void
	{
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

		if (EM.m_MB_SectorX != m_SectorX || EM.m_MB_SectorY != m_SectorY || EM.m_MB_PlanetNum != m_PlanetNum) EM.m_MB_Hist.length = 0;
		EM.m_MB_ItemType = planet.m_Item[m_ItemSlotMouse].m_Type;
		EM.m_MB_SectorX = m_SectorX;
		EM.m_MB_SectorY = m_SectorY;
		EM.m_MB_PlanetNum = m_PlanetNum;
		EM.m_MB_Send = false;
		
		EM.m_FormItemBalans.SetVal(0, 0, 0, 0);
		EM.m_FormItemBalans.Show();
	}
	
	public function ItemToTransport(...args):void
	{
		var ac:Action = new Action(EM);
		ac.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 9, 0);
		EM.m_LogicAction.push(ac);
	}
	
	public function ItemToFleet(...args):void
	{
		var ac:Action = new Action(EM);
		ac.ActionItemMove(m_SectorX, m_SectorY, m_PlanetNum, 1, m_ItemSlotMouse, 2, -1, 0);
		EM.m_LogicAction.push(ac);
	}

	public function MsgItemBonusChange(eo:Object, no:uint):void
	{
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;

//		if ((planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagBuild) != 0) {
//			FormMessageBox.Run(Common.Txt.FormPlanetBonusChangeErrorBuildNav, Common.Txt.ButClose);
//			return;
//		}
		if (planet.m_Item[m_ItemSlotMouse].m_Cnt>0) {
			FormMessageBox.Run(Common.Txt.FormPlanetBonusChangeErrorCntNav, Common.Txt.ButClose);
			return;
		}

		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 5, no);
		EM.m_LogicAction.push(a);
	}

	public function MsgItemShowCnt(... args) : void
	{
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 1, 0);
		EM.m_LogicAction.push(a);
	}

	public function MsgItemNoMove(... args) : void
	{
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 6, 0);
		EM.m_LogicAction.push(a);
	}

	public function MsgItemToPortal(... args) : void
	{
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 8, 0);
		EM.m_LogicAction.push(a);
	}

	public function MsgItemBuild(... args):void
	{
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 3, 0);
		EM.m_LogicAction.push(a);
	}

	public function MsgItemImport(... args) : void
	{
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;
		if ((planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagImport) == 0) FormMessageBox.Run(Common.Txt.FormPlanetItemImportInfo, StdMap.Txt.ButClose);
		
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 10, 0);
		EM.m_LogicAction.push(a);
	}

	public function MsgItemExport(... args) : void
	{
		var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;
		
		if ((planet.m_Item[m_ItemSlotMouse].m_Flag & PlanetItem.PlanetItemFlagExport) == 0) FormMessageBox.Run(Common.Txt.FormPlanetItemExportInfo, StdMap.Txt.ButClose);

		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 11, 0);
		EM.m_LogicAction.push(a);
	}

	public function MsgItemClear(... args) : void
	{
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 2, 0);
		EM.m_LogicAction.push(a);
	}
	
	public function MsgItemChangeCnt(... args) : void
	{
		EmpireMap.Self.m_FormInput.Init();
		EmpireMap.Self.m_FormInput.AddLabel("PlanetItemChange",18);
		
		EmpireMap.Self.m_FormInput.AddLabel("Cnt:");
		EmpireMap.Self.m_FormInput.Col();
		EmpireMap.Self.m_FormInput.AddInput("0",8,true,0);

		EmpireMap.Self.m_FormInput.ColAlign();
		EmpireMap.Self.m_FormInput.Run(ActionItemChangeCnt,"Set","Cancel");
	}
	
	public function ActionItemChangeCnt():void
	{
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 7, EM.m_FormInput.GetInt(0));
		EM.m_LogicAction.push(a);
	}

	public function MsgItemDelete(... args) : void
	{
		//EM.FormHideAll();
		
		FormMessageBox.Run(Common.Txt.FormPlanetItemDestroyQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, MsgItemClear);
	}

	public function MsgItemBuildBase(eo:Object, item_type:uint) : void
	{
		var a:Action = new Action(EM);
		a.ActionPlanetItemOp(m_SectorX, m_SectorY, m_PlanetNum, m_ItemSlotMouse, 4, item_type);
		EM.m_LogicAction.push(a);
	}

	public function onKeyDownHandler(event:KeyboardEvent):void
	{
		var i:int,e:int;

		while (event.keyCode == 32 && IsMouseInTop()) { // space
			event.stopImmediatePropagation();

			EM.m_FormMenu.Clear();

			var planet:Planet = EM.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
			if (planet == null) break;

			if (m_CellMouse >= 0) {
				var user:User = null;
				if(!EM.IsEdit()) {
					user = UserList.Self.GetUser(planet.m_Owner);
					if (user == null) break;
				}

				if ((!EM.IsEdit()) && (EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && ((EM.m_OpsFlag & Common.OpsFlagBuilding) == 0)) break;

				var bt:int = planet.m_Cell[m_CellMouse] >> 3;
				var lvl:int = planet.m_Cell[m_CellMouse] & 7;

				if (bt == 0) {
					if(EM.IsEdit()) {}
					else if (!EM.AccessBuild(planet.m_Owner)) break;

					i = EM.m_FormConstruction.m_TypeCur;
					EM.m_FormConstruction.Show();
					if (i != 0) {
						EM.m_FormConstruction.m_TypeCur = i;
						EM.m_FormConstruction.clickBuild();
						EM.m_FormConstruction.Hide();
					}

					break;

				} else if ((planet.m_CellBuildFlag & (1 << m_CellMouse)) == 0) {
					if (lvl >= Common.BuildingLvlCnt) break;

					if(!EM.IsEdit()) {
						if (user.m_BuildingLvl[bt] < (lvl + 1)) break;

						i = Common.BuildingCost[bt * Common.BuildingLvlCnt + lvl + 1 - 1];
						if (i > EM.PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeModule, true)) break;
					}

					i = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl +1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
					if (i == 0) { }
					else if (i < 0 && (planet.PlanetCalcEnergy() + i) < 0) break;
					
					MsgCellUpgrade();
					break;

				} else if ((planet.m_CellBuildFlag & (1 << m_CellMouse)) != 0) {
					if (lvl <= 1) {
						e = 0 - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
						if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) break;
					} else {
						e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1 - 1] - Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
						if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) break;
					}
					
					MsgCellCancel();
					break;
				}
			}
			
			if (m_ItemSlotMouse >= 0) {
				var pi:PlanetItem = planet.m_Item[m_ItemSlotMouse];
				if (pi.m_Type == 0) break;

				var ac:Action = new Action(EM);
				ac.ActionItemMove(m_SectorX, m_SectorY, m_PlanetNum, 1, m_ItemSlotMouse, 2, -1, 0);
				EM.m_LogicAction.push(ac);
			}

			break;
		}
	}
}

}
