package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;
import flash.display.*;
import flash.events.*;
import flash.filters.ColorMatrixFilter;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class FormRace extends Sprite
{
	private var m_Map:EmpireMap;

	static public const SizeX:int=500;
	static public const SizeY:int = 420;
	
	public var m_Pay:Boolean = false;

	public var m_Frame:Sprite=new GrFrame();
	public var m_LabelCaption:TextField = new TextField();
	public var m_LabelCaption2:TextField = new TextField();
	public var m_LabelFeatures:TextField = new TextField();
	public var m_LabelShip:TextField = new TextField();
	public var m_LabelWarning:TextField = new TextField();
	public var m_ButClose:Button = new Button();
	public var m_ButOk:Button = new Button();

	public var m_RaceList:Array = new Array();
	public var m_ShipList:Array = new Array();

	public var m_CurRace:uint = Common.RacePeople;
	public var m_MouseRace:uint = 0;

	public function FormRace(map:EmpireMap)
	{
		m_Map = map;

		m_Frame.width = SizeX;
		m_Frame.height = SizeY;
		addChild(m_Frame);

		m_LabelCaption.x=10;
		m_LabelCaption.y=5;
		m_LabelCaption.width=1;
		m_LabelCaption.height=1;
		m_LabelCaption.type=TextFieldType.DYNAMIC;
		m_LabelCaption.selectable=false;
		m_LabelCaption.border=false;
		m_LabelCaption.background=false;
		m_LabelCaption.multiline=false;
		m_LabelCaption.autoSize=TextFieldAutoSize.LEFT;
		m_LabelCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelCaption.gridFitType=GridFitType.PIXEL;
		m_LabelCaption.defaultTextFormat=new TextFormat("Calibri",18,0xffffff);
		m_LabelCaption.embedFonts=true;
		addChild(m_LabelCaption);

		m_LabelCaption2.x=10;
		m_LabelCaption2.y=30;
		m_LabelCaption2.width=1;
		m_LabelCaption2.height=1;
		m_LabelCaption2.type=TextFieldType.DYNAMIC;
		m_LabelCaption2.selectable=false;
		m_LabelCaption2.border=false;
		m_LabelCaption2.background=false;
		m_LabelCaption2.multiline=false;
		m_LabelCaption2.autoSize=TextFieldAutoSize.LEFT;
		m_LabelCaption2.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelCaption2.gridFitType=GridFitType.PIXEL;
		m_LabelCaption2.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_LabelCaption2.embedFonts=true;
		addChild(m_LabelCaption2);
		
		m_LabelShip.x=170;
		m_LabelShip.y=60;
		m_LabelShip.width=SizeX-10-m_LabelShip.x;
		m_LabelShip.height=1;
		m_LabelShip.type=TextFieldType.DYNAMIC;
		m_LabelShip.selectable=false;
		m_LabelShip.border=false;
		m_LabelShip.background=false;
		m_LabelShip.multiline = false;
		m_LabelShip.autoSize=TextFieldAutoSize.LEFT;
		m_LabelShip.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelShip.gridFitType=GridFitType.PIXEL;
		m_LabelShip.defaultTextFormat=new TextFormat("Calibri",13,0xffff00);
		m_LabelShip.embedFonts=true;
		addChild(m_LabelShip);

		m_LabelFeatures.x=170;
		m_LabelFeatures.y=220;
		m_LabelFeatures.width=SizeX-10-m_LabelFeatures.x;
		m_LabelFeatures.height=1;
		m_LabelFeatures.type=TextFieldType.DYNAMIC;
		m_LabelFeatures.selectable=false;
		m_LabelFeatures.border=false;
		m_LabelFeatures.background=false;
		m_LabelFeatures.multiline = true;
		m_LabelFeatures.wordWrap = true;
		m_LabelFeatures.autoSize=TextFieldAutoSize.LEFT;
		m_LabelFeatures.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelFeatures.gridFitType=GridFitType.PIXEL;
		m_LabelFeatures.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_LabelFeatures.embedFonts=true;
		addChild(m_LabelFeatures);
		
		m_LabelWarning.x=20;
		m_LabelWarning.y=370;
		m_LabelWarning.width = SizeX - 10 - m_LabelWarning.x;
		m_LabelWarning.height=1;
		m_LabelWarning.type=TextFieldType.DYNAMIC;
		m_LabelWarning.selectable=false;
		m_LabelWarning.border=false;
		m_LabelWarning.background=false;
		m_LabelWarning.multiline = true;
		m_LabelWarning.wordWrap = true;
		m_LabelWarning.autoSize=TextFieldAutoSize.LEFT;
		m_LabelWarning.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelWarning.gridFitType=GridFitType.PIXEL;
		m_LabelWarning.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_LabelWarning.embedFonts=true;
		addChild(m_LabelWarning);

		m_ButClose.label = Common.Txt.ButCancel;
		m_ButClose.width=100;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-10-m_ButClose.width;
		m_ButClose.y=SizeY-15-m_ButClose.height;
		addChild(m_ButClose);
		
		m_ButOk.label = Common.Txt.FormRaceButOk;
		m_ButOk.width=100;
		Common.UIStdBut(m_ButOk);
		m_ButOk.addEventListener(MouseEvent.CLICK, clickOk);
		m_ButOk.x=m_ButClose.x-10-m_ButOk.width;
		m_ButOk.y=SizeY-15-m_ButOk.height;
		addChild(m_ButOk);
		
//		mouseEnabled = false;
//		mouseChildren = false;
		
		
		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
	}
	
	public function Show(pay:Boolean):void
	{
		if(m_RaceList.length<=0) {
			RaceAdd(Common.RaceGrantar);
			RaceAdd(Common.RacePeleng);
			RaceAdd(Common.RacePeople);
			RaceAdd(Common.RaceTechnol);
			RaceAdd(Common.RaceGaal);
		}

		visible = true;

		m_Pay = pay && (m_Map.m_HomeworldCotlId != 0);

		x=Math.ceil(m_Map.stage.stageWidth/2-SizeX/2);
		y=Math.ceil(m_Map.stage.stageHeight/2-SizeY/2);

		ChangeRace();
		Update();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function clickClose(event:MouseEvent):void
	{
		Hide();
	}
	
	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		var i:int;

		if(FormMessageBox.Self.visible) return;
	
		if (m_ButClose.hitTestPoint(e.stageX, e.stageY)) return;
		
		var mr:uint = PickRace();
		if (mr != 0) {
			if(m_CurRace != mr) {
				m_CurRace = mr;
				ChangeRace();
				Update();
			}
			return;
		}

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	public function onMouseMoveHandler(e:MouseEvent):void
	{
		var i:int;
		var obj:Object;
		
		if (FormMessageBox.Self.visible) return;
		
		var infohide:Boolean = true;
		
		var mr:uint = PickRace();
		if (m_MouseRace != mr) {
			m_MouseRace = mr;
			Update();
		}
		
		var ms:int = PickShip();
		if (ms != 0) {
			for (i = 0; i < m_ShipList.length; i++) {
				obj = m_ShipList[i];
				if (obj.Type == ms) break;
			}
			if (i < m_ShipList.length) {
				m_Map.m_Info.ShowShipType(Server.Self.m_UserId, m_CurRace, ms, 0, x + obj.Img.x - 20, y + obj.Img.y - 20, 40, 40);
				infohide = false;
			}
		}
		
		if (infohide) m_Map.m_Info.Hide();
	}
	
	protected function onMouseOutHandler(event:MouseEvent) : void
	{
		if (FormMessageBox.Self.visible) return;
		if (m_Map.m_FormInput.visible) return;
		if (m_Map.m_FormMenu.visible) return;
		if (m_Map.m_FormConstruction.visible) return;

		if (m_MouseRace != 0) {
			m_MouseRace = 0;
			Update();
		}
	}
	
	public function RaceAdd(race:uint):void
	{
		var y:int = m_RaceList.length * 40 + 80;

		var obj:Object = new Object();
		m_RaceList.push(obj);
		
		obj.Sel = new Sprite();
		obj.Sel.mouseEnabled = false;
		addChild(obj.Sel);
		
		obj.Race = race;
		if (race == Common.RaceGrantar) obj.Icon = new GrantarIconBig();
		else if (race == Common.RacePeleng) obj.Icon = new PelengIconBig();
		else if (race == Common.RacePeople) obj.Icon = new PeopleIconBig();
		else if (race == Common.RaceTechnol) obj.Icon = new TechnolIconBig();
		else if (race == Common.RaceGaal) obj.Icon = new GaalIconBig();
		else throw Error("");
		obj.Icon.mouseEnabled = false;
		addChild(obj.Icon);

		obj.Name = new TextField();
		obj.Name.x=60;
		obj.Name.y=y;
		obj.Name.width=1;
		obj.Name.height=1;
		obj.Name.type=TextFieldType.DYNAMIC;
		obj.Name.selectable=false;
		obj.Name.border=false;
		obj.Name.background=false;
		obj.Name.multiline=false;
		obj.Name.autoSize=TextFieldAutoSize.LEFT;
		obj.Name.antiAliasType=AntiAliasType.ADVANCED;
		obj.Name.gridFitType=GridFitType.PIXEL;
		obj.Name.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		obj.Name.embedFonts = true;
		obj.Name.text = Common.RaceName[race];
		obj.Name.mouseEnabled = false;
		addChild(obj.Name);
		
		obj.Icon.x = 20;
		obj.Icon.y = y + (obj.Name.height >> 1) - (32/*obj.Icon.Height*/ >> 1);
		
		obj.Sel.visible = false;
		obj.Sel.x = 15;
		obj.Sel.y = y + (obj.Name.height >> 1) - (20 >> 1);
		var g:Graphics = obj.Sel.graphics;
		g.clear();
		g.lineStyle(1.0,0x0000ff,0.8,true);
		g.beginFill(0x0000ff,0.95);
		g.drawRect(0,0,130,20);
		g.endFill();
	}

	public function Update():void
	{
		var i:int;
		var obj:Object;

		m_LabelCaption.text = Common.Txt.FormRaceCaption;
		if (m_Pay) m_LabelCaption2.text = Common.Txt.FormRaceCaption2Pay;
		else m_LabelCaption2.text = Common.Txt.FormRaceCaption2;
		m_LabelShip.text = Common.Txt.FormRaceShip+":";

		for (i = 0; i < m_RaceList.length; i++) {
			obj = m_RaceList[i];

			obj.Sel.visible = (obj.Race == m_CurRace) || (obj.Race == m_MouseRace);
		}
		
		if (m_Pay) m_ButOk.label = Common.Txt.FormRaceButOkPay;
		else m_ButOk.label = Common.Txt.FormRaceButOk;

		if (m_Pay) m_LabelWarning.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormRaceWarningPay, "<Val>", BaseStr.FormatBigInt(10000)));
		else m_LabelWarning.htmlText = BaseStr.FormatTag(Common.Txt.FormRaceWarningDestroy);
		m_LabelWarning.y = m_ButClose.y - m_LabelWarning.height - 5;
		m_LabelWarning.visible = m_Map.m_HomeworldCotlId != 0;
	}
	
	public function ChangeRace():void
	{
		var i:int;
		var obj:Object;
		var str:String="";

		str = "[clr]" + Common.Txt.FormRaseFeatures + ":[/clr][br]";
		if (m_CurRace == Common.RaceGrantar) str += Common.Txt.FormRaseFeaturesGrantar;
		else if (m_CurRace == Common.RacePeleng) str += Common.Txt.FormRaseFeaturesPeleng;
		else if (m_CurRace == Common.RacePeople) str += Common.Txt.FormRaseFeaturesPeople;
		else if (m_CurRace == Common.RaceTechnol) str += Common.Txt.FormRaseFeaturesTechnol;
		else if (m_CurRace == Common.RaceGaal) str += Common.Txt.FormRaseFeaturesGaal;
		m_LabelFeatures.htmlText = BaseStr.FormatTag(str);

		for (i = 0; i < m_ShipList.length; i++) {
			obj = m_ShipList[i];
			if (obj.Img != null) {	removeChild(obj.Img); obj.Img = null; }
		}
		m_ShipList.length = 0;
		
		ShipAdd(m_CurRace, Common.ShipTypeCorvette);
		ShipAdd(m_CurRace, Common.ShipTypeCruiser);
		ShipAdd(m_CurRace, Common.ShipTypeDreadnought);
		ShipAdd(m_CurRace, Common.ShipTypeDevastator);
		ShipAdd(m_CurRace, Common.ShipTypeInvader);
		ShipAdd(m_CurRace, Common.ShipTypeTransport);
	}
	
	public function ShipAdd(race:uint, type:int):void
	{
		var i:int = m_ShipList.length;
		var x:int = (i % 4) * 70 + 220;
		var y:int = Math.floor(i / 4) * 60 + 120;

		var obj:Object = new Object();
		m_ShipList.push(obj);
		
		obj.Race = race;
		obj.Type = type;
		
		obj.Img = FormFleetBar.GetImageByType(type, race, 0);
		obj.Img.x = x;
		obj.Img.y = y;
		addChild(obj.Img);
	}
	
	public function PickRace():uint
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_RaceList.length; i++) {
			obj = m_RaceList[i];

			if (obj.Sel.hitTestPoint(stage.mouseX, stage.mouseY)) return obj.Race;
		}
		return 0;
	}
	
	public function PickShip():int
	{
		var i:int;
		var obj:Object;

		for (i = 0; i < m_ShipList.length; i++) {
			obj = m_ShipList[i];
			
			if (obj.Img.hitTestPoint(stage.mouseX, stage.mouseY)) return obj.Type;
		}
		
		return 0;
	}
	
	public function clickOk(event:MouseEvent):void
	{
		if (m_Pay) {
			if (m_Map.m_UserEGM < 10000) { FormMessageBox.Run(Common.Txt.NoEnoughEGM2); return; }

			Server.Self.QueryHS("emfleetspecial", "&type=12&val=" + m_CurRace.toString(), EmpireMap.Self.m_FormFleetBar.AnswerSpecial, false);

			FormMessageBox.Run(Common.Txt.FormRaceWarningWait);
		} else {
			m_Map.SendAction("emnewhomeworld", "" + m_Map.m_FormPlanet.m_SectorX.toString() + "_" + m_Map.m_FormPlanet.m_SectorY.toString() + "_" + m_Map.m_FormPlanet.m_PlanetNum.toString() + "_" + m_CurRace.toString());
		}
		Hide();
	}
}

}
