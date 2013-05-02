// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.utils.*;

public class FormBattleBar extends Sprite
{
	public var m_BG:Sprite = null;
	public var m_BGMark:Sprite = null;
	public var m_BGCur:Sprite = null;
	public var m_BGMarkCur:Sprite = null;
	public var m_ButOptions:SimpleButton = null;
	public var m_Text:TextField = null;
	
	public var m_Width:int = 110;
	
	public var m_Set_PlayerCnt:int = 1;
	public var m_Set_Flagship:Boolean = false;
	
	public var m_Search:Boolean = false;
	
	public var m_InMouse:Boolean = false;
	
	public var m_Pulse:Boolean = true;
	public var m_PulseTakt:Boolean = false;
	
	public var m_Timer:Timer = new Timer(300);
	public var m_Timer2:Timer = new Timer(2000);
	
	public var m_WaitEnd:Number = 0;
	public var m_WaitCnt:int = 0;

	public function FormBattleBar()
	{
		m_Timer.addEventListener(TimerEvent.TIMER, onTimer);
		m_Timer2.addEventListener(TimerEvent.TIMER,onTimer2);
		
		m_BG = new MMCaptionBG();
		addChild(m_BG);

		m_BGMark = new MMCaptionBGMark();
		addChild(m_BGMark);

		m_BGCur = new MMCaptionBGCur();
		addChild(m_BGCur);

		m_BGMarkCur = new MMCaptionBGMarkCur();
		addChild(m_BGMarkCur);

		m_ButOptions=new MMButOptions();
		addChild(m_ButOptions);
		
		m_Text=new TextField();
		m_Text.width=1;
		m_Text.height=1;
		m_Text.type=TextFieldType.DYNAMIC;
		m_Text.selectable=false;
		m_Text.textColor=0xffffff;
		m_Text.background=false;
		m_Text.backgroundColor=0x80000000;
		m_Text.alpha=1.0;
		m_Text.multiline=false;
		m_Text.autoSize = TextFieldAutoSize.NONE;
		m_Text.gridFitType=GridFitType.PIXEL;
		m_Text.defaultTextFormat=new TextFormat("Calibri",16,0xf9d774);
		m_Text.embedFonts = true;
//		m_Text.mouseEnabled = false;
		addChild(m_Text);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}
	
	public function StageResize():void
	{
		if (!visible) return;
		Update();
	}
	
	public function Show():void
	{
		EmpireMap.Self.FloatTop(this);

		visible = true;
		
		m_Timer.start();
		m_Timer2.start();
		
		Update();
	}

	public function Hide():void
	{
		visible = false;
		
		m_Timer.stop();
		m_Timer2.stop();
	}
	
	public function Update():void
	{
		if (!visible) return;
		var str:String;

		var tx:int = 0;
		var ty:int = 0;
		if (EmpireMap.Self.m_FormMiniMap.visible) {
			tx = EmpireMap.Self.m_FormMiniMap.x;
			ty = EmpireMap.Self.m_FormMiniMap.y;

		} else if (EmpireMap.Self.m_FormRadar.visible) {
			tx = EmpireMap.Self.m_FormRadar.x;
			ty = EmpireMap.Self.m_FormRadar.y;

		} else {
			tx = EmpireMap.Self.m_FormRadar.x;
			ty = EmpireMap.Self.m_FormRadar.y;
		}
		
		var mark:Boolean = false;
		if (EmpireMap.Self.m_UserCombatId != 0 && (!m_Pulse || m_PulseTakt)) mark = true;

		x = tx - m_Width - 12;
		y = ty - 33;
		m_BG.visible = !m_InMouse && (!mark);
		m_BG.width = m_Width;
		m_BGCur.visible = m_InMouse && (!mark);
		m_BGCur.width = m_Width;

		m_BGMark.visible = !m_InMouse && (mark);
		m_BGMark.width = m_Width;
		m_BGMarkCur.visible = m_InMouse && (mark);
		m_BGMarkCur.width = m_Width;

		m_ButOptions.x = 5;
		m_ButOptions.y = 5;
		m_ButOptions.visible = (!m_Search) && (EmpireMap.Self.m_UserCombatId == 0);

		if (m_ButOptions.visible) m_Text.x = 35;
		else m_Text.x = 10;
		m_Text.y = 5;
		m_Text.width = m_Width - m_Text.x - 5;
		m_Text.height = 28;

		if (EmpireMap.Self.m_UserCombatId != 0) {
			str = m_Set_PlayerCnt.toString() + "x" + m_Set_PlayerCnt.toString();
			if (m_Set_Flagship) str += "F";

			//if(EmpireMap.Self.m_FormCombat.m_CombatFlag & FormCombat.FlagDuel) str = BaseStr.Replace(Common.Txt.FormBattleDuel, "<Val>", str);
			//else 
			str = BaseStr.Replace(Common.Txt.FormBattleCombat, "<Val>", str);
			m_Text.htmlText = BaseStr.FormatTag(str);

		} else if (m_Search) {
			str = m_Set_PlayerCnt.toString() + "x" + m_Set_PlayerCnt.toString();
			if (m_Set_Flagship) str += "F";
			str = BaseStr.Replace(Common.Txt.FormBattleSearch, "<Val>", str);
			m_Text.htmlText = BaseStr.FormatTag(str);

			m_Pulse = true;

 		} else {
			m_Text.htmlText = BaseStr.FormatTag(Common.Txt.FormBattleSearchBut);

			m_Pulse = true;
		}
	}
	
	public function onMouseDown(e:MouseEvent):void
	{
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

		e.stopImmediatePropagation();
		EmpireMap.Self.FloatTop(this);
		
		if (m_ButOptions.visible && m_ButOptions.hitTestPoint(stage.mouseX, stage.mouseY) && EmpireMap.Self.m_Action == 0) { SetOpen(); return;  }
		
		if (m_InMouse && EmpireMap.Self.m_UserCombatId != 0) {
			if(EmpireMap.Self.m_FormCombat.visible) EmpireMap.Self.m_FormCombat.Hide();
			else EmpireMap.Self.m_FormCombat.ShowEx(EmpireMap.Self.m_UserCombatId);

		} else if (m_InMouse && !m_Search) {
			Search();
		} else if (m_InMouse && m_Search) {
			SearchCancel();
		}
	}

	public function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		var mi:Boolean = !(m_ButOptions.visible && m_ButOptions.hitTestPoint(stage.mouseX, stage.mouseY));
		if (mi && m_Pulse && EmpireMap.Self.m_UserCombatId != 0) m_Pulse = false;
		if (m_InMouse != mi) {
			m_InMouse = mi;
			Update();
		}
		
		if (m_InMouse) EmpireMap.Self.m_Info.ShowSearchCombatLive();
		else EmpireMap.Self.m_Info.Hide();
	}

	private function onMouseOut(e:MouseEvent):void
	{
		m_InMouse = false;
		Update();
	}

	public function SetOpen():void
	{
		var fm:FormMenu = EmpireMap.Self.m_FormMenu;
		fm.Clear();
		
		fm.Add(Common.Txt.FormBattleBar1, SetPlayerCnt, 1).Check = m_Set_PlayerCnt == 1;
		fm.Add(Common.Txt.FormBattleBar2, SetPlayerCnt, 2).Check = m_Set_PlayerCnt == 2;
		
		fm.Add();

		fm.Add(Common.Txt.FormBattleBarFlagship, SetFlagship).Check = m_Set_Flagship;

		var cx:int=m_ButOptions.x+x;
		var cy:int=m_ButOptions.y+y;

		fm.SetButOpen(m_ButOptions);
		fm.Show(cx, cy, cx + 1, cy + m_ButOptions.height);
	}

	private function SetPlayerCnt(obj:Object, v:int):void
	{
		m_Set_PlayerCnt = v;
	}

	private function SetFlagship(obj:Object, v:int):void
	{
		m_Set_Flagship = !m_Set_Flagship;
	}
	
	public function AnswerOpponent(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if (EmpireMap.Self.ErrorFromServer(buf.readUnsignedByte())) return;
	}

	
	public function Search():void
	{
		var i:int;
		var fs:FleetSlot;

		if (EmpireMap.Self.m_FormFleetBar.EmpireFleetCalcMass() < 300000) {
			FormMessageBox.RunErr(Common.Txt.FormBattleSearchNoMass);
			return;
		}
			
		var tf:uint = 0;
		if (m_Set_Flagship) {
			tf = 1;

			for (i = 0; i < EmpireMap.Self.m_FormFleetBar.m_FleetSlot.length; i++) {
				fs = EmpireMap.Self.m_FormFleetBar.m_FleetSlot[i];
				if (fs.m_Type == Common.ShipTypeFlagship) break;
			}
			if (i >= EmpireMap.Self.m_FormFleetBar.m_FleetSlot.length) {
				FormMessageBox.RunErr(Common.Txt.FormBattleSearchNoFlagship);
				return;
			}
		}

		m_Search = true;
		m_WaitEnd = 0;
		m_WaitCnt = 0;
		Update();
	
		EmpireMap.Self.m_Info.ShowSearchCombatLive();

		Server.Self.m_Anm += 256;
		Server.Self.QueryHS("emopponent", '&type=1&tc=' + m_Set_PlayerCnt.toString() + "&tf=" + tf.toString() + "&anm=" + Server.Self.m_Anm.toString(), AnswerOpponent, false);
		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;
		
		EmpireMap.Self.m_SendGv_Time = 0;
		EmpireMap.Self.m_UserAnm = 0;
	}

	public function SearchCancel():void
	{
		m_Search = false;
		Update();
		
		Server.Self.m_Anm += 256;
		Server.Self.QueryHS("emopponent", "&type=2&anm=" + Server.Self.m_Anm.toString(), AnswerOpponent, false);
		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;
	}
	
	public function onTimer(event:TimerEvent):void
	{
		if(m_Pulse && EmpireMap.Self.m_UserCombatId != 0) {
			m_PulseTakt = !m_PulseTakt;
			Update();
		}
	}
	public function onTimer2(event:TimerEvent):void
	{
		if (m_Search) {
			EmpireMap.Self.m_SendGv_Time = 0;
			EmpireMap.Self.m_UserAnm = 0;
		}
	}
}
	
}