// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;
import fl.motion.AdjustColor;
import flash.display.*;
import flash.events.*;
import flash.filters.ColorMatrixFilter;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;
import flash.system.*;
	
public class FormConstruction extends Sprite
{
	private var m_Map:EmpireMap;

	static public const SizeX:int = 640;
	static public const SizeY:int = 430;
	//static public const SizeYMin:int = 550;

	//public  var m_SizeY:int = SizeYMin;
	
	public var m_Frame:Sprite=new GrFrame();
	public var m_Title:TextField=new TextField();
	public var m_ButClose:Button = new Button();
	public var m_ButBuild:Button = new Button();
	public var m_ButSelect:Button = new Button();
	
	public var m_List:Array = new Array();

	public var m_BuildingLayer:Sprite=new Sprite();
	
	public var m_TypeMouse:int = 0;
	public var m_TypeMouseLvl:int = 0;
	public var m_TypeCur:int = 0;

	public var m_Pages:Array = new Array();
	public var m_PageCur:int = 0;
	public var m_PageMouse:int = 0;
	
	public var m_PageBase:int=-1;
	public var m_PageMining:int=-1;
	public var m_PageRefining:int=-1;
	public var m_PageLive:int=-1;
	public var m_PageProduction:int=-1;
	public var m_PageEquipment:int = -1;
	
	public var m_PickLvl:int = 0;
	
	public function FormConstruction(map:EmpireMap)
	{
		m_Map = map;

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.CLICK, onMouseClick);
		addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDblClick);

		m_Map.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler, false, 1);

		m_Frame.width=SizeX;
		m_Frame.height=SizeY;
		addChild(m_Frame);
		
		m_Title.x=10;
		m_Title.y=5;
		m_Title.width=1;
		m_Title.height=1;
		m_Title.type=TextFieldType.DYNAMIC;
		m_Title.selectable=false;
		m_Title.border=false;
		m_Title.background=false;
		m_Title.multiline=false;
		m_Title.autoSize=TextFieldAutoSize.LEFT;
		m_Title.antiAliasType=AntiAliasType.ADVANCED;
		m_Title.gridFitType=GridFitType.PIXEL;
		m_Title.defaultTextFormat=new TextFormat("Calibri",18,0xffffff);
		m_Title.embedFonts=true;
		addChild(m_Title);

		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width=90;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		addChild(m_ButClose);
		
		m_ButBuild.label = Common.Txt.Build;
		m_ButBuild.width=80;
		Common.UIStdBut(m_ButBuild);
		m_ButBuild.addEventListener(MouseEvent.CLICK, clickBuild);
		addChild(m_ButBuild);
		
		m_ButSelect.label = Common.Txt.Select;
		m_ButSelect.width=80;
		Common.UIStdBut(m_ButSelect);
		m_ButSelect.addEventListener(MouseEvent.CLICK, clickSelect);
		addChild(m_ButSelect);

		addChild(m_BuildingLayer);
		
		doubleClickEnabled=true;
		m_BuildingLayer.mouseEnabled = false;
		m_BuildingLayer.mouseChildren = false;
		m_Frame.mouseEnabled = false;
		m_Frame.mouseChildren = false;
		
		m_PageBase = PageAdd(Common.Txt.FormConstructionPageBase);
		m_PageMining = PageAdd(Common.Txt.FormConstructionPageMining);
		m_PageRefining = PageAdd(Common.Txt.FormConstructionPageRefining);
		m_PageLive = PageAdd(Common.Txt.FormConstructionPageLive);
		m_PageProduction = PageAdd(Common.Txt.FormConstructionPageProduction);
		m_PageEquipment = PageAdd(Common.Txt.FormConstructionPageEquipment);
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if(FormMessageBox.Self.visible) return;
		if (m_ButClose.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ButBuild.visible &&m_ButBuild.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ButSelect.visible && m_ButSelect.hitTestPoint(e.stageX, e.stageY)) return;
		if (Pick() > 0) return;
		if (PickPage() >= 0) return;
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<width && mouseY>=0 && mouseY<height) return true;
		return false;
	}
	
	public function IsMouseInTop():Boolean
	{
		if (!IsMouseIn()) return false;

		var pt:Point = new Point(stage.mouseX, stage.mouseY);
		var ar:Array = stage.getObjectsUnderPoint(pt);

		if (ar.length <= 0) return false;

		var obj:DisplayObject = ar[ar.length - 1];
		if (obj == m_Map.m_MoveItem) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		else if (obj == m_Map.m_FormFleetBar.m_MoveLayer) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		while (obj!=null) {
			if (obj == this) return true;
			obj = obj.parent;
		}
		return false;
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) Show();
		x = Math.ceil(m_Map.stage.stageWidth / 2 - SizeX / 2);
		y = Math.ceil(m_Map.stage.stageHeight / 2 - SizeY / 2);
	}

	public function Show():void
	{
		//if(m_List.length<=0) ListFill();

		m_TypeMouse = -1;
		m_TypeMouseLvl = 0;
		m_TypeCur = -1;

		visible = true;
		StageResize();
		UpdatePage();
		ListFill();
		Update();
	}

	public function Hide():void
	{
		visible = false;
		ListClear();
	}
	
	public function clickClose(...args):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		
		Hide();
	}

	public function UpdatePage():void
	{
		var i:int;
		var l:TextField;

		for (i = 0; i < m_Pages.length; i++) {
			l = m_Pages[i].Txt;

			if (m_Map.IsWinMaxEnclave() && i != m_PageBase)  {
				l.visible = false;
			} else if (i == m_PageCur) {
				l.visible = true;
				l.background=true;
				l.backgroundColor=0x0000ff;
			} else if(i==m_PageMouse) {
				l.visible = true;
				l.background=true;
				l.backgroundColor=0x000080;
			} else {
				l.visible = true;
				l.background=false;
				l.backgroundColor=0x00008f;
			}
		}
		while(true) {
			if (m_PageCur < 0 || m_PageCur >= m_Pages.length) { }
			else if(!m_Pages[m_PageCur].Txt.visible) {}
			else break;

			for (i = 0; i < m_Pages.length; i++) {
				l = m_Pages[i].Txt;
				if (l.visible) break;
			}
			if (i < m_Pages.length) {
				m_PageCur = i;
				UpdatePage();
			}
			break;
		}
	}

	public function Update():void
	{
		var e:int;
		var i:int,u:int;
		var o:Object;
		var ac:AdjustColor;
		var filter:ColorMatrixFilter;
		var filters:Array;
		
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;

		var planet:Planet = null;
		if (m_Map.m_FormPlanet.visible) planet = m_Map.GetPlanet(m_Map.m_FormPlanet.m_SectorX, m_Map.m_FormPlanet.m_SectorY, m_Map.m_FormPlanet.m_PlanetNum);
//		if (planet == null) return;
		
		m_Title.text = Common.Txt.FormConstructionCaption;
		
		//
		var maxcx:int = 3;
		var cx:int = maxcx;
		var cy:int = -1;
		for (i = 0; i < m_List.length; i++) {
			o = m_List[i];
			
			var bt:int = o.Type;

			cx++;
			if (cx >= maxcx) {
				cx = 0;
				cy++;
			}
			
			var lvl:int = 1;
			if (m_Map.IsEdit()) lvl = Common.BuildingLvlCnt;
			else if (user.m_BuildingLvl[o.Type] > 0) lvl = user.m_BuildingLvl[o.Type];
			if (o.Type == m_TypeMouse && m_PickLvl > 0) lvl = m_PickLvl;
			
			if (o.BMLvl != lvl) {
				o.BMLvl = lvl;
				o.BM.bitmapData = GetImageByType(o.Type, lvl);
			}
			
			o.BM.x = 270 + cx * 140 - (o.BM.width >> 1);
			o.BM.y = 150 + cy * 170 - o.BM.height;
			
			if (planet!=null && (user.m_BuildingLvl[o.Type] <= 0) && (!m_Map.IsEdit())) {
				ac=new AdjustColor();
				ac.brightness=0;
				ac.contrast=0;
				ac.hue = 0;
				ac.saturation=-100;
				filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
				filters = new Array();
				filters.push(filter);
				o.BM.filters = filters;

			} else if (o.Type == m_TypeMouse || o.Type == m_TypeCur) {
				ac=new AdjustColor();
				ac.brightness=10;
				ac.contrast=0;
				ac.hue = 0;
				ac.saturation=50;
				filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
				filters = new Array();
				filters.push(filter);
				o.BM.filters = filters;
				
			} else {
				o.BM.filters = null;
			}

			if (o.Buy != null) {
				o.Buy.visible = planet != null;
				o.Buy.x = o.BM.x + (o.BM.width >> 1) - (o.Buy.width >> 1);
				o.Buy.y = o.BM.y + o.BM.height - 30;
				
				if (o.Type == m_TypeMouse) {
					o.Buy.backgroundColor = 0x0000ff;
				} else {
					o.Buy.backgroundColor = 0x000000;
				}
			}

			if (planet == null) {
				o.Cost.visible = false;
			} else if ((!m_Map.IsEdit()) && (m_Map.PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeModule, true) < Common.BuildingCost[bt * Common.BuildingLvlCnt + 0])) {
				o.Cost.visible = true;
				o.Cost.htmlText = "<font color='#ff0000'>"+Common.BuildingCost[bt * Common.BuildingLvlCnt + 0]+"</font>";
			} else {
				o.Cost.visible = true;
				o.Cost.text = Common.BuildingCost[bt * Common.BuildingLvlCnt + 0];
			}

			e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + 0];
			if (planet == null) o.EnergyCost.visible = false;
			else if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) { o.EnergyCost.htmlText = "<font color='#ff0000'>"+e.toString()+"</font>"; o.EnergyCost.visible = true; }
			else if (e >= 0) { o.EnergyCost.text = "+" + e.toString(); o.EnergyCost.visible = true; }
			else { o.EnergyCost.text = e.toString(); o.EnergyCost.visible = true; }

			var ky:int = o.BM.y + o.BM.height + 12;
			
			o.Name.x = o.BM.x + (o.BM.width >> 1) - (o.Name.width >> 1);
			o.Name.y = ky - (o.Name.height>>1);

			o.Cost.x = o.BM.x + (o.BM.width >> 1) - ((o.Cost.width + o.Module.width + 6 + o.EnergyCost.width + o.EnergyIcon.width) >> 1);
			o.Cost.y = ky + 20;// o.Name.y + o.Name.height;

			o.Module.visible = o.Cost.visible;
			o.Module.x = o.Cost.x + o.Cost.width + (o.Module.width >> 1);
			o.Module.y = o.Cost.y + (o.Cost.height >> 1);

			o.EnergyCost.x = o.Module.x + (o.Module.width >> 1) + 6;
			o.EnergyCost.y = o.Cost.y;

			o.EnergyIcon.visible = o.EnergyCost.visible;
			o.EnergyIcon.x = o.EnergyCost.x + o.EnergyCost.width + (o.EnergyIcon.width >> 1);
			o.EnergyIcon.y = o.EnergyCost.y + (o.EnergyCost.height >> 1);
			
			for (u = 0; u < o.LvlList.length; u++) {
				var l:TextField = o.LvlList[u];
				
				l.x = o.BM.x + o.BM.width - 20;
				l.y = o.BM.y + o.BM.height - 100 + u * 17;
				
				if (o.Type == m_TypeMouse && (u + 1) == m_PickLvl) {
					l.backgroundColor = 0x0000ff;// 000000;
				} else {
					l.backgroundColor = 0x000000;// 000000;
				}
				
//				l.x = o.BM.x + u * 15;
//				l.y = ky - 30;
			}
		}

		//
		var sizey:int = 150 + cy * 150 + 20;

		m_ButClose.x = SizeX - 15 - m_ButClose.width;
		m_ButClose.y = SizeY - m_ButClose.height - 15;

		m_ButBuild.x = m_ButClose.x - 15 - m_ButBuild.width;
		m_ButBuild.y = m_ButClose.y;

		m_ButSelect.x = m_ButBuild.x;
		m_ButSelect.y = m_ButBuild.y;
		
		if (planet == null) {
			m_ButBuild.visible = false;
			m_ButSelect.visible = true;
		} else {
			m_ButBuild.visible = (m_TypeCur > 0) && (m_Map.IsEdit() || (user.m_BuildingLvl[m_TypeCur] > 0)) && (m_Map.m_FormPlanet.m_CellMouse >= 0);
			m_ButSelect.visible = false;
		}

		//sizey += m_ButClose.height + 15;

		//m_SizeY = sizey;

		m_Frame.width = SizeX;
		m_Frame.height = SizeY;
	}
	
	public function clickSelect(...args):void
	{
		if (FormMessageBox.Self.visible) return;
		
		if (m_TypeCur <= 0) return;
		
		if (!m_Map.m_FormMiniMap.visible) return;
		
		m_Map.m_FormMiniMap.m_ShowBuildingType = m_TypeCur;
		m_Map.m_FormMiniMap.m_ShowShipPlayer = 0;
			
		m_Map.m_FormMiniMap.MMQuery();
		m_Map.m_FormMiniMap.Update();
		
		Hide();
	}

	public function clickBuild(...args):void
	{
		var e:int;
		
		if (FormMessageBox.Self.visible) return;
		if (m_Map.m_FormPlanet.m_CellMouse < 0) return;
		
		if (m_TypeCur <= 0) return;

		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;

		if ((!m_Map.IsEdit()) && (user.m_BuildingLvl[m_TypeCur] <= 0)) return;

		var planet:Planet = m_Map.GetPlanet(m_Map.m_FormPlanet.m_SectorX, m_Map.m_FormPlanet.m_SectorY, m_Map.m_FormPlanet.m_PlanetNum);
		if (planet == null) return;
		
		var bt:int = m_TypeCur;
		
		m_Map.m_Info.Hide();

		if (bt == Common.BuildingTypeCrystal && planet.m_OreItem != Common.ItemTypeCrystal) {
			if (args.length <= 0) return;
			FormMessageBox.Run(Common.Txt.FormPlanetBuildErrNoCrystalOre, Common.Txt.ButClose);
			return;

		} else if (bt == Common.BuildingTypeTitan && planet.m_OreItem != Common.ItemTypeTitan) {
			if (args.length <= 0) return;
			FormMessageBox.Run(Common.Txt.FormPlanetBuildErrNoTitanOre, Common.Txt.ButClose);
			return;

		} else if (bt == Common.BuildingTypeSilicon && planet.m_OreItem != Common.ItemTypeSilicon) {
			if (args.length <= 0) return;
			FormMessageBox.Run(Common.Txt.FormPlanetBuildErrNoSiliconOre, Common.Txt.ButClose);
			return;
		}

		if (bt == Common.BuildingTypeCity || bt == Common.BuildingTypeFarm || bt == Common.BuildingTypeTech || bt == Common.BuildingTypeEngineer || bt == Common.BuildingTypeTechnician || bt == Common.BuildingTypeNavigator) {
			if ((planet.m_Flag & Planet.PlanetFlagLarge) == 0) {
				FormMessageBox.Run(Common.Txt.WarningBuildingNeedLargePlanet, Common.Txt.ButClose);
				return;
			}
		} else if (bt == Common.BuildingTypeModule || bt == Common.BuildingTypeFuel || bt == Common.BuildingTypePower || bt == Common.BuildingTypeArmour || bt == Common.BuildingTypeDroid || bt == Common.BuildingTypeMachinery || bt == Common.BuildingTypeMine) {
			if ((planet.m_Flag & Planet.PlanetFlagLarge) == 0) {
				if (args.length <= 0) return;
				FormMessageBox.Run(Common.Txt.WarningBuildingNeedLargePlanet, Common.Txt.ButClose);
				return;
			}
		} else if (bt == Common.BuildingTypeElectronics || bt == Common.BuildingTypeMetal || bt == Common.BuildingTypeAntimatter || bt == Common.BuildingTypePlasma) {
			if ((planet.m_Flag & Planet.PlanetFlagLarge) != 0) {
				if (args.length <= 0) return;
				FormMessageBox.Run(Common.Txt.WarningBuildingNeedSmallPlanet, Common.Txt.ButClose);
				return;
			}
		}
		
		if (bt == Common.BuildingTypeModule) {
			if (planet.ExistBuilding(Common.BuildingTypeLab)) {
				FormMessageBox.Run(Common.Txt.WarningBuildingLabAndModule, Common.Txt.ButClose);
				return;
			}
		} else if (bt == Common.BuildingTypeLab) {
			if (planet.ExistBuilding(Common.BuildingTypeModule)) {
				FormMessageBox.Run(Common.Txt.WarningBuildingLabAndModule, Common.Txt.ButClose);
				return;
			}
		}
		
		if (m_Map.IsEdit()) { }
		else if (m_Map.PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeModule, true) < Common.BuildingCost[bt * Common.BuildingLvlCnt + 0]) {
			if (args.length <= 0) return;
			FormMessageBox.Run(Common.Txt.NoEnoughModule, Common.Txt.ButClose);
			return;
		}

		e = Common.BuildingEnergy[bt * Common.BuildingLvlCnt + 0];
		if (e < 0 && (planet.PlanetCalcEnergy() + e) < 0) {
			if (args.length <= 0) return;
			FormMessageBox.Run(Common.Txt.FormPlanetNoEnough, Common.Txt.ButClose);
			return;
		}

		var ac:Action=new Action(m_Map);
		ac.ActionConstruction(m_Map.m_FormPlanet.m_SectorX,m_Map.m_FormPlanet.m_SectorY,m_Map.m_FormPlanet.m_PlanetNum,m_Map.m_FormPlanet.m_CellMouse,1,bt);
		m_Map.m_LogicAction.push(ac);

		Hide();
	}
	
	public static function GetImageByType(ct:int, lvl:int):BitmapData
	{
		var str:String = "";
		
		if (ct == Common.BuildingTypeEnergy) str = "C_Energy"; // ok
		else if (ct == Common.BuildingTypeStorage) str = "C_Storage"; // ok
		else if (ct == Common.BuildingTypeLab) str = "C_Lab"; // ok
		else if (ct == Common.BuildingTypeMissile) str = "C_IB"; // ok
		else if (ct == Common.BuildingTypeTerraform) str = "C_Stim";

		else if (ct == Common.BuildingTypeXenon) str = "C_Xenon"; // ok
		else if (ct == Common.BuildingTypeTitan) str = "C_Titan"; // ok
		else if (ct == Common.BuildingTypeSilicon) str = "C_Silicon"; // ok
		else if (ct == Common.BuildingTypeCrystal) str = "C_Diamonds"; // ok

		else if (ct == Common.BuildingTypeFarm) str = "C_Farm"; // ok
		else if (ct == Common.BuildingTypeElectronics) str = "C_Electr"; // ok
		else if (ct == Common.BuildingTypeMetal) str = "C_IA";
		else if (ct == Common.BuildingTypeAntimatter) str = "C_Def"; // ok
		else if (ct == Common.BuildingTypePlasma) str = "C_Stim"; // ok

		else if (ct == Common.BuildingTypeCity) str = "C_City"; // ok
		else if (ct == Common.BuildingTypeTech) str = "C_Labr"; // ok
		else if (ct == Common.BuildingTypeEngineer) str = "C_Uni"; // ok
		else if (ct == Common.BuildingTypeTechnician) str = "C_Academy"; // ok
		else if (ct == Common.BuildingTypeNavigator) str = "C_Academy";

		else if (ct == Common.BuildingTypeModule) str = "C_Module"; // ok
		else if (ct == Common.BuildingTypeFuel) str = "C_Polar"; // ok
		else if (ct == Common.BuildingTypeMine) str = "C_II"; // ok
		else if (ct == Common.BuildingTypeMachinery) str = "C_Module";

		else if (ct == Common.BuildingTypePower) str = "C_Labr";
		else if (ct == Common.BuildingTypeArmour) str = "C_Labr";
		else if (ct == Common.BuildingTypeDroid) str = "C_Labr";
		else str = "C_Def";
		
		// C_Uni
		// C_Stim
		// C_Lab
		// C_II
		// C_IB
		// C_IA
		// C_Def
		// C_Academy
		
		var cl:Class=ApplicationDomain.currentDomain.getDefinition(str+lvl.toString()) as Class;
		var s:BitmapData=new cl();
		return s;
	}
	
	public function ListAdd(ct:int):void
	{
		var i:int,u:int;
		var str:String;
		var l:TextField;

		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;

		var o:Object = new Object();
		o.Type = ct;
		
//		o.Disable = false;
//		if (m_Map.IsWinMaxEnclave()) {
//			if (ct == Common.BuildingTypeEnergy) { }
//			else if (ct == Common.BuildingTypeStorage) { }
//			else if (ct == Common.BuildingTypeLab) { }
//			else o.Disable = true;
//		}

		var lvl:int = 1;
		if (m_Map.IsEdit()) lvl = Common.BuildingLvlCnt;
		else if (user.m_BuildingLvl[o.Type] > 0) lvl = user.m_BuildingLvl[o.Type];

		o.BMLvl = lvl;

		o.BM = new Bitmap();
		o.BM.bitmapData = GetImageByType(ct, lvl);
		m_BuildingLayer.addChild(o.BM);
		
		if ((user.m_BuildingLvl[o.Type] == 0) && (!m_Map.IsEdit())) {
			o.Buy = new TextField();
			o.Buy.width=1;
			o.Buy.height=1;
			o.Buy.type=TextFieldType.DYNAMIC;
			o.Buy.selectable=false;
			o.Buy.border=false;
			o.Buy.background = true;
			o.Buy.backgroundColor = 0x000000;
			o.Buy.alpha = 0.8;
			o.Buy.multiline=false;
			o.Buy.autoSize=TextFieldAutoSize.LEFT;
			o.Buy.antiAliasType=AntiAliasType.ADVANCED;
			o.Buy.gridFitType=GridFitType.PIXEL;
			o.Buy.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
			o.Buy.embedFonts = true;
			o.Buy.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormConstructionBuyLvlFirst, "<Val>", BaseStr.FormatBigInt(Common.BuildingTechLvlCost[o.Type * Common.BuildingLvlCnt + 0])));
			m_BuildingLayer.addChild(o.Buy);
		} else {
			o.Buy = null;
		}

		o.Name = new TextField();
		o.Name.width=1;
		o.Name.height=1;
		o.Name.type=TextFieldType.DYNAMIC;
		o.Name.selectable=false;
		o.Name.border=false;
		o.Name.background=false;
		o.Name.multiline=false;
		o.Name.autoSize=TextFieldAutoSize.LEFT;
		o.Name.antiAliasType=AntiAliasType.ADVANCED;
		o.Name.gridFitType=GridFitType.PIXEL;
		o.Name.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		o.Name.embedFonts = true;

		str = Common.BuildingName[o.Type];
		if (str.length >= 20) {
			i = str.indexOf(" ");
			if (i < 0) o.Name.text = str;
			else {
				o.Name.htmlText = BaseStr.FormatTag("[center]"+str.substr(0, i) + "[/center]\n[center]" + str.substr(i + 1)+"[/center]");
				o.Name.multiline = true;
				//o.Name.autoSize=TextFieldAutoSize.CENTER;
			}
		} else {
			o.Name.text = str;
		}
		m_BuildingLayer.addChild(o.Name);

		o.Cost = new TextField();
		o.Cost.width=1;
		o.Cost.height=1;
		o.Cost.type=TextFieldType.DYNAMIC;
		o.Cost.selectable=false;
		o.Cost.border=false;
		o.Cost.background = false;
		o.Cost.multiline=false;
		o.Cost.autoSize=TextFieldAutoSize.LEFT;
		o.Cost.antiAliasType=AntiAliasType.ADVANCED;
		o.Cost.gridFitType=GridFitType.PIXEL;
		o.Cost.defaultTextFormat=new TextFormat("Calibri",13,0xffff00);
		o.Cost.embedFonts = true;
		m_BuildingLayer.addChild(o.Cost);

		o.Module = Common.ItemImgVec(1);
		o.Module.scaleX = 0.7;
		o.Module.scaleY = 0.7;
		m_BuildingLayer.addChild(o.Module);

		o.EnergyCost = new TextField();
		o.EnergyCost.width=1;
		o.EnergyCost.height=1;
		o.EnergyCost.type=TextFieldType.DYNAMIC;
		o.EnergyCost.selectable=false;
		o.EnergyCost.border=false;
		o.EnergyCost.background=false;
		o.EnergyCost.multiline=false;
		o.EnergyCost.autoSize=TextFieldAutoSize.LEFT;
		o.EnergyCost.antiAliasType=AntiAliasType.ADVANCED;
		o.EnergyCost.gridFitType=GridFitType.PIXEL;
		o.EnergyCost.defaultTextFormat=new TextFormat("Calibri",13,0xffff00);
		o.EnergyCost.embedFonts = true;
		m_BuildingLayer.addChild(o.EnergyCost);

		o.EnergyIcon = new IconEnergy();
		m_BuildingLayer.addChild(o.EnergyIcon);

		o.LvlList = new Array();
		var cnt:int = user.m_BuildingLvl[o.Type];
		if (m_Map.IsEdit()) cnt = Common.BuildingLvlCnt;
		for (u = 0; u < cnt; u++) {
			l = new TextField();
			l.width = 14;
			l.height = 16;
			l.type = TextFieldType.DYNAMIC;
			l.alpha = 0.7;
			l.selectable = false;
			l.border = false;
			l.background = true;
			l.backgroundColor = 0x000000;// 000000;
			l.multiline = false;
			l.autoSize = TextFieldAutoSize.NONE;
			l.antiAliasType = AntiAliasType.ADVANCED;
			l.gridFitType = GridFitType.PIXEL;
			l.defaultTextFormat = new TextFormat("Calibri", 12, 0xffffff);
			l.embedFonts = true;
			l.htmlText = BaseStr.FormatTag("[center]" + Common.RomanNum[u + 1] + "[/center]");
			m_BuildingLayer.addChild(l);
			o.LvlList.push(l);
		}
		if (u>0 && u < Common.BuildingLvlCnt) {
			l = new TextField();
			l.width = 14;
			l.height = 16;
			l.type = TextFieldType.DYNAMIC;
			l.alpha = 0.7;
			l.selectable = false;
			l.border = false;
			l.background = true;
			l.backgroundColor = 0x000000;// 000000;
			l.multiline = false;
			l.autoSize = TextFieldAutoSize.NONE;
			l.antiAliasType = AntiAliasType.ADVANCED;
			l.gridFitType = GridFitType.PIXEL;
			l.defaultTextFormat = new TextFormat("Calibri", 12, 0xffffff);
			l.embedFonts = true;
			l.htmlText = BaseStr.FormatTag("[center]+[/center]");
			m_BuildingLayer.addChild(l);
			o.LvlList.push(l);
		}

		m_List.push(o);
	}
	
	public function ListFill():void
	{
		ListClear();
		
		if (m_PageCur == m_PageBase) {
			ListAdd(Common.BuildingTypeEnergy);
			ListAdd(Common.BuildingTypeStorage);
			ListAdd(Common.BuildingTypeLab);
//			ListAdd(Common.BuildingTypeMissile);
//			ListAdd(Common.BuildingTypeTerraform);

		} else if (m_PageCur == m_PageMining) {
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeXenon);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeTitan);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeSilicon);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeCrystal);

		} else if (m_PageCur == m_PageRefining) {
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeFarm);

			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeElectronics);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeMetal);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeAntimatter);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypePlasma);

		} else if (m_PageCur == m_PageLive) {
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeCity);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeTech);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeEngineer);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeTechnician);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeNavigator);

		} else if (m_PageCur == m_PageProduction) {
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeModule);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeFuel);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeMine);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeMachinery);

		} else if (m_PageCur == m_PageEquipment) {
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypePower);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeArmour);
			if(!m_Map.IsWinMaxEnclave()) ListAdd(Common.BuildingTypeDroid);
		}
	}
	
	public function ListClear():void
	{
		var i:int,u:int;
		var o:Object;
		for (i = 0; i < m_List.length; i++) {
			o = m_List[i];
			
			if (o.BM != null) { m_BuildingLayer.removeChild(o.BM); o.BM = null; }
			if (o.Buy != null)  { m_BuildingLayer.removeChild(o.Buy); o.Buy = null; }
			if (o.Name != null) { m_BuildingLayer.removeChild(o.Name); o.Name = null; }
			if (o.Cost != null) { m_BuildingLayer.removeChild(o.Cost); o.Cost = null; }
			if (o.Module != null) { m_BuildingLayer.removeChild(o.Module); o.Module = null; }
			if (o.EnergyCost != null) { m_BuildingLayer.removeChild(o.EnergyCost); o.EnergyCost = null; }
			if (o.EnergyIcon != null) { m_BuildingLayer.removeChild(o.EnergyIcon); o.EnergyIcon = null; }
			
			for (u = 0; u < o.LvlList.length; u++) {
				if(o.LvlList[u]!=null) {
					m_BuildingLayer.removeChild(o.LvlList[u]);
					o.LvlList[u] = null;
				}
			}
			o.LvlList.length = 0;
			o.LvlList = null;
		}
		m_List.length = 0;
	}
	
	public function Pick():int
	{
		var i:int,u:int;
		var o:Object;

		for (i = 0; i < m_List.length; i++) {
			o = m_List[i];
			if (!o.BM.visible) continue;

			for (u = 0; u < o.LvlList.length; u++) {
				if (o.LvlList[u].hitTestPoint(stage.mouseX, stage.mouseY)) { m_PickLvl = u + 1; return o.Type; }
			}

			if (o.BM.hitTestPoint(stage.mouseX, stage.mouseY)) { m_PickLvl = 0; return o.Type; }
		}
		m_PickLvl = 0;
		return 0;
	}
	
	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var i:int;
		
		var hideinfo:Boolean = true;
		
		i=PickPage();
		if (i != m_PageMouse) {
			m_PageMouse=i;
			UpdatePage();
		}

		i = Pick();
		if (i != m_TypeMouse || m_PickLvl!=m_TypeMouseLvl) {
			m_TypeMouse = i;
			m_TypeMouseLvl = m_PickLvl;
			Update();
		}
		
		if (m_TypeMouse != 0) {
			for (i = 0; i < m_List.length; i++) {
				var o:Object = m_List[i];
				if (o.Type == m_TypeMouse) {
					var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
					if (user == null) break;

					var so:Object = o;
					var lvl:int = user.m_BuildingLvl[o.Type];
					if (m_Map.IsEdit()) lvl = Common.BuildingLvlCnt;
					if (lvl < 1) lvl = 1;
					if (m_TypeMouseLvl > 0) { so = o.LvlList[m_TypeMouseLvl - 1]; lvl = m_TypeMouseLvl; }
//					else lvl = 1;
					m_Map.m_Info.ShowBuilding(so, o.Type, lvl, 0, x + o.BM.x, y + o.BM.y, o.BM.width, o.BM.height,true);
					hideinfo = false;
					break;
				}
			}
		}
		
		if(hideinfo) m_Map.m_Info.Hide();
	}
	
	public function onMouseClick(e:MouseEvent):void
	{
		var i:int,v:int;
		
		e.stopImmediatePropagation();

		i=PickPage();
		if (i>=0 && i != m_PageCur) {
			m_PageCur=i;
			UpdatePage();
			ListFill();
			Update();
		}
		
		if (m_TypeMouse != m_TypeCur) {
			m_TypeCur = m_TypeMouse;
			Update();
		}
		
		while (m_TypeCur > 0) {
			if (!m_Map.m_FormPlanet.visible) break;
			if (m_Map.IsEdit()) break;
			var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user == null) break;
			
			var lvl:int = Common.BuildingLvlCnt;
			if (!m_Map.IsEdit()) lvl = user.m_BuildingLvl[m_TypeCur];
			
			if (lvl >= Common.BuildingLvlCnt) break;
			
			if(lvl>0) {
				if ( m_TypeMouseLvl <= 0) break;
				if ((m_TypeMouseLvl - 1) < lvl) break;
			}
			
			m_Map.m_Info.Hide();

			var str:String = Common.Txt.FormConstructionBuyLvlQuery;
			if(lvl==0) str=Common.Txt.FormConstructionBuyLvlFirstQuery;
			v = Common.BuildingTechLvlCost[m_TypeCur * Common.BuildingLvlCnt + (lvl)];
			str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(v));
			FormMessageBox.Run(str, StdMap.Txt.ButNo, StdMap.Txt.ButYes, MsgBuyLvl);

			break;
		}
	}

	public function onMouseDblClick(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if (m_TypeCur > 0 && m_TypeMouseLvl <= 0) {
			if (m_ButBuild.visible) clickBuild(null);
			else if (m_ButSelect.visible) clickSelect(null);
		}
	}

	public function PageAdd(txt:String):int
	{
		var p:Object = new Object();
		p.Txt = new TextField();
		p.Txt.x=40;
		p.Txt.y=40+m_Pages.length*25;
		p.Txt.width=150;
		p.Txt.height=22;
		p.Txt.type=TextFieldType.DYNAMIC;
		p.Txt.selectable=false;
		p.Txt.border=false;
		p.Txt.background=false;
		p.Txt.multiline=false;
		p.Txt.autoSize=TextFieldAutoSize.NONE;
		p.Txt.antiAliasType=AntiAliasType.ADVANCED;
		p.Txt.gridFitType=GridFitType.PIXEL;
		p.Txt.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		p.Txt.embedFonts = true;
		p.Txt.htmlText = txt;
		addChild(p.Txt);
		m_Pages.push(p);

		return m_Pages.length - 1;
	}

	public function PickPage():int
	{
		var i:int;
		var l:TextField;

		for (i = 0; i < m_Pages.length; i++) {
			l = m_Pages[i].Txt;
			if (!l.visible) continue;
			if(l.mouseX>0 && l.mouseY>0 && l.mouseX<l.width && l.mouseY<l.height) return i;
		}
		return -1;
	}

	public function MsgBuyLvl():void
	{
		if (m_Map.IsEdit()) return;
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;
		if (user.m_BuildingLvl[m_TypeCur] >= Common.BuildingLvlCnt) return;

		var cost:int = Common.BuildingTechLvlCost[m_TypeCur * Common.BuildingLvlCnt + (user.m_BuildingLvl[m_TypeCur])];
		if (m_Map.m_FormFleetBar.m_FleetMoney < cost) {
			FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose);
			return;
		}

		var ac:Action=new Action(m_Map);
		ac.ActionBuildingLvlBuy(Server.Self.m_UserId, m_TypeCur);
		m_Map.m_LogicAction.push(ac);
	}

	public function onKeyDownHandler(event:KeyboardEvent):void
	{
		var i:int,e:int;

		while (event.keyCode == 32 && IsMouseInTop()) { // space
			event.stopImmediatePropagation();
			
			if (m_TypeMouse != 0) {
				m_TypeCur = m_TypeMouse;
				Update();
				clickBuild();
			}
			
			break;
		}
	}
}
	
}
