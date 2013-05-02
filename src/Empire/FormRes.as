// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import fl.controls.*;
import fl.events.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class FormRes extends Sprite
{
	private var m_Map:EmpireMap;
	
	public var m_GiveSectorX:int=0;
	public var m_GiveSectorY:int=0;
	public var m_GivePlanetNum:int=-1;
	public var m_GiveShipNum:int=-1;

	public var m_ButChange:Button=null;
	public var m_ButClose:Button=null;
	public var m_BuildCnt:TextInput=null;
	public var m_ButGive:Button=null;
	public var m_CntGive:TextInput=null;
	public var m_NameGive:TextField=null;
	public var m_BuildOk:Button=null;

	static public const SizeX:int=555;
	static public const SizeY:int=530;
	static public const ResRadius:int=55;

	public var m_ResList:Array=new Array();
	
	public var m_Cur:int=0;
	
	public var m_TypeBuild:int=0;
	
	public var m_Move:Boolean=false;
	public var m_MoveOffX:int=0;
	public var m_MoveOffY:int=0;

	public var m_UserStatShipCntAll:int=0;
	public var m_UserStatAntimatterDecAll:int=0;
	public var m_UserStatMetalDecAll:int=0;
	public var m_UserStatElectronicsDecAll:int=0;
//	public var m_UserStatAntimatterDec:Array=new Array();
//	public var m_UserStatMetalDec:Array=new Array();
//	public var m_UserStatElectronicsDec:Array=new Array();;

	public var m_Timer:Timer=new Timer(200);
	
	public var m_ResChangeType:int=0;

	public function FormRes(map:EmpireMap)
	{
		m_Map=map;

		var txt:TextField;
		var but:Button;
		var obj:Object;
		var oi:Object;
		
		m_Timer.addEventListener("timer",UpdateTimer);

		txt=new TextField();
		txt.x=10;
		txt.y=5;
		txt.width=1;
		txt.height=1;
		txt.type=TextFieldType.DYNAMIC;
		txt.selectable=false;
		txt.border=false;
		txt.background=false;
		txt.multiline=false;
		txt.autoSize=TextFieldAutoSize.LEFT;
		txt.antiAliasType=AntiAliasType.ADVANCED;
		txt.gridFitType=GridFitType.PIXEL;
		txt.defaultTextFormat=new TextFormat("Calibri",18,0xffffff);
		txt.embedFonts=true;
		txt.text=Common.Txt.FormResCaption;
		addChild(txt);

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);

		m_ButClose=new Button();
		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width=100;
		m_ButClose.emphasized=false;
		m_ButClose.setStyle("textFormat", tf);
		m_ButClose.setStyle("embedFonts", true);
		m_ButClose.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_ButClose.textField.gridFitType=GridFitType.PIXEL;
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-10-m_ButClose.width;
		m_ButClose.y=SizeY-10-m_ButClose.height;
		addChild(m_ButClose);

		m_ButGive=new Button();
		m_ButGive.label = Common.Txt.ButGive;
		m_ButGive.width=100;
		m_ButGive.emphasized=false;
		//m_ButGive.setStyle("disabledSkin", Button_downSkin);
		m_ButGive.setStyle("textFormat", tf);
		m_ButGive.setStyle("embedFonts", true);
		m_ButGive.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_ButGive.textField.gridFitType=GridFitType.PIXEL;
		m_ButGive.addEventListener(MouseEvent.CLICK, clickGive);
		m_ButGive.x=SizeX-10-m_ButClose.width-10-m_ButGive.width;
		m_ButGive.y=SizeY-10-m_ButClose.height;
		addChild(m_ButGive);

		m_CntGive=new TextInput();
		m_CntGive.width=79;
//		m_CntGive.height=20;
//		m_CntGive.setStyle("upSkin", TextInput_Cnt);
		m_CntGive.setStyle("focusRectSkin", focusRectSkinNone);
		m_CntGive.setStyle("textFormat", tf);
		m_CntGive.setStyle("embedFonts", true);
		m_CntGive.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_CntGive.textField.gridFitType=GridFitType.PIXEL;
		m_CntGive.textField.restrict = "0-9";
		m_CntGive.textField.maxChars = 4;
		m_CntGive.x=SizeX-10-m_ButClose.width-10-m_ButGive.width-10-m_CntGive.width;
		m_CntGive.y=SizeY-10-m_ButClose.height;
		m_CntGive.addEventListener(Event.CHANGE,BuildCntChange);
		m_CntGive.addEventListener(ComponentEvent.ENTER, clickGive);
		m_CntGive.text="1";
		addChild(m_CntGive);

		m_NameGive=new TextField();
		m_NameGive.width=1;
		m_NameGive.height=20;
		m_NameGive.type=TextFieldType.DYNAMIC;
		m_NameGive.selectable=false;
		m_NameGive.border=false;
		m_NameGive.background=false;
		m_NameGive.multiline=false;
		m_NameGive.autoSize=TextFieldAutoSize.LEFT;
		m_NameGive.antiAliasType=AntiAliasType.ADVANCED;
		m_NameGive.gridFitType=GridFitType.PIXEL;
		m_NameGive.defaultTextFormat=tf;
		m_NameGive.embedFonts=true;
		m_NameGive.text="test";
		m_NameGive.x=SizeX-10-m_ButClose.width-10-m_ButGive.width-10-m_CntGive.width-10-m_NameGive.width;
		m_NameGive.y=SizeY-10-m_ButClose.height;
		addChild(m_NameGive);

		m_ButChange=new Button();
		m_ButChange.label = Common.Txt.ButChange;
		m_ButChange.width=100;
		m_ButChange.emphasized=false;
		m_ButChange.setStyle("textFormat", tf);
		m_ButChange.setStyle("embedFonts", true);
		m_ButChange.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_ButChange.textField.gridFitType=GridFitType.PIXEL;
		m_ButChange.addEventListener(MouseEvent.CLICK, clickChange);
		m_ButChange.x=m_ButClose.x;
		m_ButChange.y=m_ButClose.y-5-m_ButClose.height;
		addChild(m_ButChange);

		m_BuildCnt=new TextInput();
		m_BuildCnt.width=40;
		m_BuildCnt.height=18;
		m_BuildCnt.setStyle("upSkin", TextInput_Cnt);
		m_BuildCnt.setStyle("focusRectSkin", focusRectSkinNone);
		m_BuildCnt.setStyle("textFormat", new TextFormat("Calibri",12,0xffffff));
		m_BuildCnt.setStyle("embedFonts", true);
		m_BuildCnt.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_BuildCnt.textField.gridFitType=GridFitType.PIXEL;
		m_BuildCnt.visible=false;
		m_BuildCnt.textField.restrict = "0-9";
		m_BuildCnt.textField.maxChars = 5;

/*		m_BuildCnt=new TextField();
		m_BuildCnt.width=35;
		m_BuildCnt.height=16;
		m_BuildCnt.type=TextFieldType.INPUT;
		m_BuildCnt.selectable=true;
		m_BuildCnt.border=false;
		m_BuildCnt.background=true;
		m_BuildCnt.backgroundColor=0xffffff;
		m_BuildCnt.multiline=false;
		m_BuildCnt.autoSize=TextFieldAutoSize.NONE;
		m_BuildCnt.antiAliasType=AntiAliasType.ADVANCED;
		m_BuildCnt.gridFitType=GridFitType.PIXEL;
		m_BuildCnt.defaultTextFormat=new TextFormat("Calibri",12,0x000000);
		m_BuildCnt.embedFonts=true;
		m_BuildCnt.visible=false;
		m_BuildCnt.restrict = "0-9";
		m_BuildCnt.maxChars = 5;*/
		m_BuildCnt.addEventListener(Event.CHANGE,BuildCntChange);
		m_BuildCnt.addEventListener(ComponentEvent.ENTER, BuildCntSend);
		addChild(m_BuildCnt);

		m_BuildOk=new Button();
		m_BuildOk.label='';
		m_BuildOk.width=14;
		m_BuildOk.height=14;
		m_BuildOk.setStyle("upSkin", BOK_upSkin);
		m_BuildOk.setStyle("overSkin", BOK_overSkin);
		m_BuildOk.setStyle("downSkin", BOK_upSkin);
		m_BuildOk.setStyle("focusRectSkin", focusRectSkinNone);
		m_BuildOk.visible=false;
		m_BuildOk.addEventListener(MouseEvent.CLICK, BuildCntSend);
		addChild(m_BuildOk);

		m_ResList[Common.ItemTypeMetal]=obj=new Object();
		obj.Type=Common.ItemTypeMetal;
		obj.x=220;//220;
		obj.y=305;//298;

		m_ResList[Common.ItemTypeElectronics]=obj=new Object();
		obj.Type=Common.ItemTypeElectronics;
		obj.x=353;//337;
		obj.y=302;//298;

		m_ResList[Common.ItemTypeAntimatter]=obj=new Object();
		obj.Type=Common.ItemTypeAntimatter;
		obj.x=285;//276;
		obj.y=201;//199;

		m_ResList[Common.ItemTypeProtoplasm]=obj=new Object();
		obj.Type=Common.ItemTypeProtoplasm;
		obj.x=475;//452;
		obj.y=253;//257;

		m_ResList[Common.ItemTypeNodes]=obj=new Object();
		obj.Type=Common.ItemTypeNodes;
		obj.x=95;//105;
		obj.y=253;//253;

		m_ResList[Common.ItemTypeFuel]=obj=new Object();
		obj.Type=Common.ItemTypeFuel;
		obj.x=178;//182;
		obj.y=137;//128;
		obj.Src=new Array();
		oi=new Object(); oi.Type=Common.ItemTypeAntimatter; oi.Cnt=Common.ItemFuelAntimatter; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeMetal; oi.Cnt=Common.ItemFuelMetal; obj.Src.push(oi);

		m_ResList[Common.ItemTypeArmour]=obj=new Object();
		obj.Type=Common.ItemTypeArmour;
		obj.x=222;//224;
		obj.y=424;//412;
		obj.Src=new Array();
		oi=new Object(); oi.Type=Common.ItemTypeMetal; oi.Cnt=Common.ItemArmourMetal; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeElectronics; oi.Cnt=Common.ItemArmourElectronics; obj.Src.push(oi);

		m_ResList[Common.ItemTypePower]=obj=new Object();
		obj.Type=Common.ItemTypePower;
		obj.x=313;//310;
		obj.y=81;//92;
		obj.Src=new Array();
		oi=new Object(); oi.Type=Common.ItemTypeAntimatter; oi.Cnt=Common.ItemPowerAntimatter; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeElectronics; oi.Cnt=Common.ItemPowerElectronics; obj.Src.push(oi);

		m_ResList[Common.ItemTypeRepair]=obj=new Object();
		obj.Type=Common.ItemTypeRepair;
		obj.x=358;//340;
		obj.y=425;//412;
		obj.Src=new Array();
		oi=new Object(); oi.Type=Common.ItemTypeMetal; oi.Cnt=Common.ItemRepairMetal; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeElectronics; oi.Cnt=Common.ItemRepairElectronics; obj.Src.push(oi);

		m_ResList[Common.ItemTypePower2]=obj=new Object();
		obj.Type=Common.ItemTypePower2;
		obj.x=413;//402;
		obj.y=150;//158;
		obj.Src=new Array();
		oi=new Object(); oi.Type=Common.ItemTypeAntimatter; oi.Cnt=Common.ItemPower2Antimatter; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeElectronics; oi.Cnt=Common.ItemPower2Electronics; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeProtoplasm; oi.Cnt=Common.ItemPower2Protoplasm; obj.Src.push(oi);

		m_ResList[Common.ItemTypeRepair2]=obj=new Object();
		obj.Type=Common.ItemTypeRepair2;
		obj.x=472;//448;
		obj.y=372;//374;
		obj.Src=new Array();
		oi=new Object(); oi.Type=Common.ItemTypeMetal; oi.Cnt=Common.ItemRepair2Metal; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeElectronics; oi.Cnt=Common.ItemRepair2Electronics; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeProtoplasm; oi.Cnt=Common.ItemRepair2Protoplasm; obj.Src.push(oi);

		m_ResList[Common.ItemTypeArmour2]=obj=new Object();
		obj.Type=Common.ItemTypeArmour2;
		obj.x=97;//120;
		obj.y=379;//374;
		obj.Src=new Array();
		oi=new Object(); oi.Type=Common.ItemTypeMetal; oi.Cnt=Common.ItemArmour2Metal; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeElectronics; oi.Cnt=Common.ItemArmour2Electronics; obj.Src.push(oi);
		oi=new Object(); oi.Type=Common.ItemTypeNodes; oi.Cnt=Common.ItemArmour2Nodes; obj.Src.push(oi);

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
	}

	public function Show(secx:int=0, secy:int=0, planetnum:int=-1, shipnum:int=-1):void
	{
		visible=true;
		
		m_GiveSectorX=secx;
		m_GiveSectorY=secy;
		m_GivePlanetNum=planetnum;
		m_GiveShipNum=shipnum;
		
		x=Math.ceil(m_Map.stage.stageWidth/2-SizeX/2);
		y=Math.ceil(m_Map.stage.stageHeight/2-SizeY/2);

		m_ButGive.visible=false;
		m_CntGive.visible=false;
		m_NameGive.visible=false;

		m_BuildCnt.visible=false;
		m_BuildOk.visible=false;

		m_Cur=0;
		m_TypeBuild=0;
		
		m_ResChangeType=0;
		
		m_Timer.start();

		Update();
	}

	public function Hide():void
	{
//		ResListClear();
		m_Timer.stop();
		visible=false;
	}

	public function UpdateTimer(event:TimerEvent=null):void
	{
		Update();
	}
	
	public function clickClose(event:MouseEvent):void
	{
		if(m_Map.m_FormResChange.visible) m_Map.m_FormResChange.Hide();
		Hide();
	}
	
	public function clickChange(event:MouseEvent):void
	{
		m_Map.m_Info.Hide();
		if(m_Map.m_FormResChange.visible) m_Map.m_FormResChange.Hide(); 
		else m_Map.m_FormResChange.Show();
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		if(m_Map.m_FormResChange.visible) return;

		if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButGive.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_CntGive.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_NameGive.hitTestPoint(e.stageX,e.stageY)) return;

		if(m_Cur) {
/*			m_Move=true;
			m_MoveOffX=mouseX-m_ResList[m_Cur].x;
			m_MoveOffY=mouseY-m_ResList[m_Cur].y;
			return;*/

			BeginBuild(m_Cur);
			
			if(m_Cur==Common.ItemTypeAntimatter || m_Cur==Common.ItemTypeMetal || m_Cur==Common.ItemTypeElectronics) {
				m_ResChangeType=m_Cur;
			}

			return;
		}
		EndBuild();

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpHandler(e:MouseEvent):void
	{
		if(m_ResChangeType) {
			if(m_Cur!=m_ResChangeType && (m_Cur==Common.ItemTypeAntimatter || m_Cur==Common.ItemTypeMetal || m_Cur==Common.ItemTypeElectronics)) {
				m_Map.m_Info.Hide();
				m_Map.m_FormResChange.SetType(m_ResChangeType,m_Cur);
				m_Map.m_FormResChange.Show();
			}
			m_ResChangeType=0;

		} else if(m_Move) {
			m_Move=false;
//trace(Common.ItemName[m_ResList[m_Cur].Type],m_ResList[m_Cur].x,m_ResList[m_Cur].y);
		}
	}

	protected function onMouseMoveHandler(e:MouseEvent):void
	{
		if(m_Map.m_FormResChange.visible) return;

		if(m_Move) {
			m_ResList[m_Cur].x=mouseX-m_MoveOffX;
			m_ResList[m_Cur].y=mouseY-m_MoveOffY;
			Update();
		} else {
			SetCur(Pick());
		}
	}

	protected function BuildCntChange(e:Event):void
	{
		Update();
	}

	public function CalcMaxCnt(t:int):int
	{
		var i:int;
		var oi:Object;

		var cnt:int=1000000;

		if(m_ResList[t]==undefined) return 0;
		if(m_ResList[t].Src==undefined) return 0;

		for(i=0;i<m_ResList[t].Src.length;i++) {
			oi=m_ResList[t].Src[i];
			cnt=Math.min(cnt,Math.floor(m_Map.m_UserRes[oi.Type]/oi.Cnt));
		}
		return cnt;
	}
	
	protected function BuildCntSend(event:Event):void
	{
		var buildcnt:int=int(m_BuildCnt.text);
		if(buildcnt<=0) return;
		if(buildcnt>CalcMaxCnt(m_TypeBuild)) return;
//trace(buildcnt);

		if(buildcnt>100 && buildcnt>(CalcMaxCnt(m_TypeBuild)>>1)) {
			FormMessageBox.Run(Common.Txt.FormResItemBuildQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionBuildCntSend);
			return;
		}

		ActionBuildCntSend();
	}

	private function ActionBuildCntSend():void
	{
		var buildcnt:int=int(m_BuildCnt.text);
		
		var ac:Action=new Action(m_Map);
		ac.ActionMake(m_TypeBuild,buildcnt);
		m_Map.m_LogicAction.push(ac);

		EndBuild();
	}

	public function clickGive(event:Event):void
	{
		if(m_TypeBuild==0) return;
		var cnt:int=int(m_CntGive.text);
		if(cnt<=0 || cnt>m_Map.m_UserRes[m_TypeBuild]) return;
		
		var ac:Action=new Action(m_Map);
		ac.ActionGive(m_GiveSectorX,m_GiveSectorY,m_GivePlanetNum,m_GiveShipNum,m_TypeBuild,cnt);
		m_Map.m_LogicAction.push(ac);

		EndBuild();
		Hide();
	}

	public function SetCur(v:int):void
	{
		if(v==m_Cur) return;
		m_Cur=v;
		Update();

		if(m_Cur==0) m_Map.m_Info.Hide();
		else {
			var tp:Point=localToGlobal(new Point(m_ResList[m_Cur].x,m_ResList[m_Cur].y));
			m_Map.m_Info.ShowRes(m_Cur,tp.x,tp.y);
		}
	}

	public function EndBuild():void
	{
		m_TypeBuild=0;
		m_BuildCnt.visible=false;
		m_BuildOk.visible=false;

		m_ButGive.visible=false;
		m_CntGive.visible=false;
		m_NameGive.visible=false;
		Update();
	}

	public function BeginBuild(v:int):void
	{
		if(m_TypeBuild==v) {
			return;
		}
		m_TypeBuild=v;
		
		if(m_ResList[m_TypeBuild].Src==undefined) {
			m_BuildCnt.visible=false;
			m_BuildOk.visible=false;

			m_ButGive.visible=false;
			m_CntGive.visible=false;
			m_NameGive.visible=false;
			Update();
			return;
		}	

		m_CntGive.text=(Math.min(int(m_CntGive.text),m_Map.m_UserRes[m_TypeBuild])).toString();
		m_CntGive.setFocus();
		m_CntGive.setSelection(0,m_CntGive.text.length);

		m_BuildCnt.visible=true;
		m_BuildCnt.x=m_ResList[m_Cur].x-(m_BuildCnt.width>>1);
		m_BuildCnt.y=m_ResList[m_Cur].y+21+(m_BuildCnt.height>>1);
		m_BuildCnt.text=CalcMaxCnt(m_TypeBuild).toString();
		m_BuildCnt.setFocus();
		m_BuildCnt.setSelection(0,m_BuildCnt.text.length);

		m_BuildOk.visible=true;
		m_BuildOk.x=m_BuildCnt.x+m_BuildCnt.width;
		m_BuildOk.y=m_BuildCnt.y;
		
		if(m_GiveShipNum>=0) {
			m_ButGive.visible=true;
			m_CntGive.visible=true;
			m_NameGive.visible=true;

			m_NameGive.text=Common.ItemName[m_TypeBuild]+":";
			m_NameGive.x=SizeX-10-m_ButClose.width-10-m_ButGive.width-10-m_CntGive.width-10-m_NameGive.width;
		}
		
		Update();
	}

/*	public function ResListClear():void
	{
		var i:int;
		var obj:Object;
		for(i=0;i<m_ResList.length;i++) {
			obj=m_ResList[i];
			if(obj.Name!=undefined && obj.Name!=null) {
				removeChild(obj.Name);
				obj.Name=null;
			}
			m_ResList[i]=null;
		}
		m_ResList.length=0;
	}*/

	public function Pick():int
	{
		var i:int, sx:int, sy:int;
//		var obj:Object;

		var px:int=mouseX;
		var py:int=mouseY;

		for each (var obj:Object in m_ResList) {
//			obj=m_ResList[t];
			sx=px-obj.x;
			sy=py-obj.y;

			if((sx*sx+sy*sy)>ResRadius*ResRadius) continue;

			return obj.Type;
		}
		return 0;
	}

	public function Update():void
	{
		var  i:int, v:int, px:int, py:int, ty:int;
		var oi:Object;
		var txt:TextField;
		var spr:Sprite;
		var str:String,str2:String;

		graphics.clear();

		var buildcnt:int=int(m_BuildCnt.text);

		graphics.lineStyle(1.0,0x069ee5,0.8,true);
		graphics.beginFill(0x000000,0.95);
		graphics.drawRoundRect(0,0,SizeX,SizeY,10,10);
		graphics.endFill();

		for each (var obj:Object in m_ResList) {
/*			if(m_Cur==obj.Type) {
				graphics.lineStyle(3.0,0xffffff,1.0,true);
			} else { 
				graphics.lineStyle(3.0,0x184d6a,1.0,true);
			}*/

			var mat:Matrix=Common.MatrixForGradientLine(obj.x,obj.y-ResRadius,obj.x,obj.y+ResRadius);

			var clrtxt:uint=0;

			if(obj.Type==Common.ItemTypeProtoplasm || obj.Type==Common.ItemTypeNodes) {
				//graphics.beginFill(0xe46c0a,0.5);
				graphics.beginGradientFill(GradientType.LINEAR,[0xe46c0a,0xe46c0a,0xe46c0a],[0.3,0.8,0.8],[0,150,255],mat);
				graphics.lineStyle(3.0,0xa42c00,1.0,true);
				clrtxt=0xffe3a0;

			} else if(obj.Type==Common.ItemTypeAntimatter || obj.Type==Common.ItemTypeMetal || obj.Type==Common.ItemTypeElectronics) {
				//graphics.beginFill(0x3f71Ad,0.5);
				graphics.beginGradientFill(GradientType.LINEAR,[0x3f71Ad,0x3f71Ad,0x3f71Ad],[0.3,0.8,0.8],[0,150,255],mat);
				graphics.lineStyle(3.0,0x184d6a,1.0,true);
				clrtxt=0x9ecaff;

			} else {
//				graphics.beginFill(0x67932c,0.5);
				graphics.beginGradientFill(GradientType.LINEAR,[0x67932c,0x67932c,0x67932c],[0.3,0.8,0.8],[0,150,255],mat);
				graphics.lineStyle(3.0,0x275300,1.0,true);
				clrtxt=0x92ff00;
			}

			if(m_TypeBuild==obj.Type) {
				graphics.lineStyle(3.0,0xffffff,1.0,true);
			} else if(m_Cur==obj.Type) {
				graphics.lineStyle(3.0,0xffffff,0.6,true);
			}

			graphics.drawCircle(obj.x,obj.y,ResRadius);
			
			graphics.drawCircle(obj.x-ResRadius,obj.y,17);
			
			graphics.endFill();

			
			if(obj.Type==Common.ItemTypeProtoplasm || obj.Type==Common.ItemTypeNodes) {
				graphics.beginFill(0xe46c0a,0.8);

			} else if(obj.Type==Common.ItemTypeAntimatter || obj.Type==Common.ItemTypeMetal || obj.Type==Common.ItemTypeElectronics) {
				graphics.beginFill(0x3f71Ad,0.8);

			} else {
				graphics.beginFill(0x67932c,0.8);
			}
			
			graphics.drawCircle(obj.x-ResRadius,obj.y,17);
			
			graphics.endFill();
			
			// Name
			if(obj.Name==undefined) {
				txt=new TextField();
				obj.Name=txt;
				txt.width=1;
				txt.height=1;
				txt.type=TextFieldType.DYNAMIC;
				txt.selectable=false;
				txt.border=false;
				txt.background=false;
				txt.multiline=false;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.gridFitType=GridFitType.PIXEL;
				txt.defaultTextFormat=new TextFormat("Calibri",15,0xffffff);
				txt.embedFonts=true;
				txt.text=Common.ItemName[obj.Type];
				addChild(txt);
			} else txt=obj.Name;
			//txt.x=obj.x-ResRadius+18;//(txt.width>>1);
			txt.x=obj.x-Math.min(37,txt.width>>1);
			txt.y=obj.y-(txt.height>>1);

			// Count
			if(obj.Cnt==undefined) {
				txt=new TextField();
				obj.Cnt=txt;
				txt.width=1;
				txt.height=1;
				txt.type=TextFieldType.DYNAMIC;
				txt.selectable=false;
				txt.border=false;
				txt.background=false;
				txt.multiline=false;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.gridFitType=GridFitType.PIXEL;
				txt.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
				txt.embedFonts=true;
				addChild(txt);
			} else txt=obj.Cnt;
			str=BaseStr.FormatBigInt(m_Map.m_UserRes[obj.Type]);//.toString();
			txt.htmlText=str;
			txt.x=obj.x-(txt.width>>1);//-10;
			txt.y=obj.y+12;

			// Count
			if(obj.Add==undefined) {
				txt=new TextField();
				obj.Add=txt;
				txt.width=1;
				txt.height=1;
				txt.type=TextFieldType.DYNAMIC;
				txt.selectable=false;
				txt.border=false;
				txt.background=false;
				txt.multiline=false;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.gridFitType=GridFitType.PIXEL;
				txt.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
				txt.embedFonts=true;
				addChild(txt);
			} else txt=obj.Add;
			str2="";
			
			if(obj.Type==Common.ItemTypeAntimatter) {
				v=m_Map.m_UserStatAntimatterInc+m_Map.m_UserStatAntimatterIncPact-m_UserStatAntimatterDecAll;
				if((m_Map.m_Access & Common.AccessPlusarModule) && ((m_Map.m_UserAddModuleEnd>m_Map.GetServerTime()) || (m_Map.m_UserControlEnd>m_Map.GetServerTime()))) v+=((m_Map.m_UserStatAntimatterInc*Common.PlusarResBonus)>>8);
				v+=((m_Map.m_UserStatAntimatterInc*m_Map.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8);

				if(v>=0) str2="<font size='11' color='#25ec16'>+"+BaseStr.FormatBigInt(v);
				else str2="<font size='11' color='#79000b'>"+BaseStr.FormatBigInt(v);
				
				if(m_Map.m_UserMulTime>0) str2=str2+"x"+Common.MulFactor.toString();
				str2=str2+"</font>";

			} else if(obj.Type==Common.ItemTypeMetal) {
				v=m_Map.m_UserStatMetalInc+m_Map.m_UserStatMetalIncPact-m_UserStatMetalDecAll;
				if((m_Map.m_Access & Common.AccessPlusarModule) && ((m_Map.m_UserAddModuleEnd>m_Map.GetServerTime()) || (m_Map.m_UserControlEnd>m_Map.GetServerTime()))) v+=((m_Map.m_UserStatMetalInc*Common.PlusarResBonus)>>8);
				v+=((m_Map.m_UserStatMetalInc*m_Map.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8);

				if(v>=0) str2="<font size='11' color='#25ec16'>+"+BaseStr.FormatBigInt(v);
				else str2="<font size='11' color='#79000b'>"+BaseStr.FormatBigInt(v);

				if(m_Map.m_UserMulTime>0) str2=str2+"x"+Common.MulFactor.toString();
				str2=str2+"</font>";

			} else if(obj.Type==Common.ItemTypeElectronics) {
				v=m_Map.m_UserStatElectronicsInc+m_Map.m_UserStatElectronicsIncPact-m_UserStatElectronicsDecAll;
				if((m_Map.m_Access & Common.AccessPlusarModule) && ((m_Map.m_UserAddModuleEnd>m_Map.GetServerTime()) || (m_Map.m_UserControlEnd>m_Map.GetServerTime()))) v+=((m_Map.m_UserStatElectronicsInc*Common.PlusarResBonus)>>8);
				v+=((m_Map.m_UserStatElectronicsInc*m_Map.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8);

				if(v>=0) str2="<font size='11' color='#25ec16'>+"+BaseStr.FormatBigInt(v);
				else str2="<font size='11' color='#79000b'>"+BaseStr.FormatBigInt(v);

				if(m_Map.m_UserMulTime>0) str2=str2+"x"+Common.MulFactor.toString();
				str2=str2+"</font>";
			}
			txt.visible=(str2.length>0) && (m_TypeBuild==0 || m_TypeBuild==Common.ItemTypeAntimatter || m_TypeBuild==Common.ItemTypeMetal || m_TypeBuild==Common.ItemTypeElectronics || m_TypeBuild==Common.ItemTypeProtoplasm || m_TypeBuild==Common.ItemTypeNodes);
			txt.htmlText=str2;
			txt.x=obj.x-(txt.width>>1);//-10;
			txt.y=obj.Cnt.y+obj.Cnt.height;

			// Icon
			if(obj.Icon==undefined) {
				spr=GraphItem.GetImageByType(obj.Type);
				obj.Icon=spr;
				spr.scaleX=spr.scaleX*0.8;
				spr.scaleY=spr.scaleY*0.8;
				//spr.alpha=0.9;
				addChild(spr);
			} else spr=obj.Icon;
			//spr.x=obj.x-25;
			//spr.y=obj.y+20;
			spr.x=obj.x-ResRadius;
			spr.y=obj.y+0;
			
			// ACnt
			if(obj.ACnt==undefined) {
				txt=new TextField();
				obj.ACnt=txt;
				txt.width=1;
				txt.height=1;
				txt.type=TextFieldType.DYNAMIC;
				txt.selectable=false;
				txt.border=false;
				txt.background=false;
				txt.multiline=false;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.gridFitType=GridFitType.PIXEL;
				txt.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);
				txt.embedFonts=true;
				addChild(txt);
			} else txt=obj.ACnt;
			
			while(true) {
				txt.visible=false;
				
				if(m_TypeBuild==0) break;
				if(m_ResList[m_TypeBuild].Src==undefined) break;
				
				if(m_TypeBuild==obj.Type) {
					txt.visible=true; 
					txt.text="+";//m_Map.m_UserRes[obj.Type].toString();
					txt.x=obj.x-30;
					txt.y=obj.y+30;
					break;
				}
				
				for(i=0;i<m_ResList[m_TypeBuild].Src.length;i++) {
					oi=m_ResList[m_TypeBuild].Src[i];
					if(oi.Type==obj.Type) break;
				}
				if(i>=m_ResList[m_TypeBuild].Src.length) break;
				txt.visible=true;
				if(oi.Cnt*buildcnt>m_Map.m_UserRes[obj.Type]) txt.htmlText="<font color='#ffc995'>-"+(oi.Cnt*buildcnt).toString()+"</font>";
				else txt.htmlText="<font color='#ffff00'>-"+(oi.Cnt*buildcnt).toString()+"</font>";
				txt.x=obj.x-(txt.width>>1)-2;
				txt.y=obj.y+32;

				break;
			}

			// Src
			if(obj.Src!=undefined) {
				//ty=obj.y-ResRadius-((obj.Src.length*20)>>1);

				for(i=0;i<obj.Src.length;i++,ty+=20) {
					oi=obj.Src[i];
					if(oi.Icon==undefined) {
						spr=GraphItem.GetImageByType(oi.Type);
						oi.Icon=spr;
						spr.alpha=0.5;
						spr.scaleX=spr.scaleX*0.8;
						spr.scaleY=spr.scaleY*0.8;
						addChild(spr);
					} else spr=oi.Icon;

					if(oi.Txt==undefined) {
						txt=new TextField();
						oi.Txt=txt;
						txt.width=1;
						txt.height=1;
						txt.type=TextFieldType.DYNAMIC;
						txt.selectable=false;
						txt.border=false;
						txt.background=false;
						txt.multiline=false;
						txt.autoSize=TextFieldAutoSize.LEFT;
						txt.antiAliasType=AntiAliasType.ADVANCED;
						txt.gridFitType=GridFitType.PIXEL;
						txt.defaultTextFormat=new TextFormat("Calibri",12,clrtxt);
						txt.embedFonts=true;
						txt.alpha=0.5;
						addChild(txt);
					} else txt=oi.Txt;
					txt.text=oi.Cnt.toString();

					spr.visible=m_TypeBuild==obj.Type;
					txt.visible=m_TypeBuild==obj.Type;					
					//if(m_TypeBuild==obj.Type) {

					if(i==0) { spr.x=obj.x-30+5; spr.y=obj.y-20; txt.x=obj.x-20+3+5; txt.y=obj.y-20-(txt.height>>1); }
					else if(i==1) { spr.x=obj.x+10+5; spr.y=obj.y-20; txt.x=obj.x+20+3+5; txt.y=obj.y-20-(txt.height>>1); }
					else if(i==2) { spr.x=obj.x-10+5; spr.y=obj.y-40; txt.x=obj.x+3+5; txt.y=obj.y-40-(txt.height>>1); }
				}
			}

		}

		while(m_NameGive.visible) {
			i=int(m_CntGive.textField.text);
			m_ButGive.enabled=i>0 && i<=m_Map.m_UserRes[m_TypeBuild];
			
			break;
		}
	}
	
	public function UpdateResDec():void
	{
		var i:int;

		m_UserStatShipCntAll=0;
		m_UserStatAntimatterDecAll=0;
		m_UserStatMetalDecAll=0;
		m_UserStatElectronicsDecAll=0;

		for(i=0;i<Common.ShipTypeCnt;i++) {
			if(m_Map.m_UserStatShipCnt[i]<=0) continue;
			m_UserStatShipCntAll+=m_Map.m_UserStatShipCnt[i];

			var kof:int=(((1+(m_Map.m_UserStatShipCnt[i]>>Common.ShipSupplyS[i]))*m_Map.SupplyMul(Server.Self.m_UserId,i))>>8)*m_Map.m_SupplyMul;
			m_UserStatAntimatterDecAll+=Common.ShipSupplyA[i]*kof;
			m_UserStatMetalDecAll+=Common.ShipSupplyM[i]*kof;
			m_UserStatElectronicsDecAll+=Common.ShipSupplyE[i]*kof;
		}

		if(m_UserStatShipCntAll>=m_Map.DirValE(Server.Self.m_UserId,Common.DirSupplyNormal)) {
			if(m_UserStatShipCntAll<(m_Map.DirValE(Server.Self.m_UserId,Common.DirSupplyNormal)<<1)) {
				m_UserStatAntimatterDecAll=m_UserStatAntimatterDecAll>>1;
				m_UserStatMetalDecAll=m_UserStatMetalDecAll>>1;
				m_UserStatElectronicsDecAll=m_UserStatElectronicsDecAll>>1;

			} else if(m_UserStatShipCntAll>m_Map.DirValE(Server.Self.m_UserId,Common.DirSupplyMuch)) {
				m_UserStatAntimatterDecAll=m_UserStatAntimatterDecAll<<1;
				m_UserStatMetalDecAll=m_UserStatMetalDecAll<<1;
				m_UserStatElectronicsDecAll=m_UserStatElectronicsDecAll<<1;
			}

		} else {
			m_UserStatAntimatterDecAll=0;
			m_UserStatMetalDecAll=0;
			m_UserStatElectronicsDecAll=0;
		}

		var pa:int = m_Map.m_UserStatAntimatterInc;
		var pm:int = m_Map.m_UserStatMetalInc;
		var pe:int = m_Map.m_UserStatElectronicsInc;

		pa+=(m_Map.m_UserStatAntimatterInc*m_Map.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8;
		pm+=(m_Map.m_UserStatMetalInc*m_Map.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8;
		pe+=(m_Map.m_UserStatElectronicsInc*m_Map.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8;

		if((m_Map.m_Access & Common.AccessPlusarModule) && ((m_Map.m_UserAddModuleEnd>m_Map.GetServerTime()) || (m_Map.m_UserControlEnd>m_Map.GetServerTime()))) {
			pa+=((m_Map.m_UserStatAntimatterInc*Common.PlusarResBonus)>>8);
			pm+=((m_Map.m_UserStatMetalInc*Common.PlusarResBonus)>>8);
			pe+=((m_Map.m_UserStatElectronicsInc*Common.PlusarResBonus)>>8);
		}

		m_UserStatAntimatterDecAll+=(pa*m_Map.PactDecProc(Common.ItemTypeAntimatter))>>8;
		m_UserStatMetalDecAll+=(pm*m_Map.PactDecProc(Common.ItemTypeMetal))>>8;
		m_UserStatElectronicsDecAll+=(pe*m_Map.PactDecProc(Common.ItemTypeElectronics))>>8;
	
	}
}

}
