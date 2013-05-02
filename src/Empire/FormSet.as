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
import flash.system.*;

public class FormSet extends FormStd
{
	private var m_Hint:CtrlCheckBox = null;
	private var m_AccessKey:CtrlInput = null;
	private var m_HourPlanetShield:CtrlInput = null;
	private var m_Unprintable:CtrlCheckBox = null;
	private var m_ScopeVis:CtrlCheckBox = null;
	private var m_FPSShow:CtrlCheckBox = null;
	private var m_FPSMax:CtrlInput = null;
	private var m_ShieldPercent:CtrlCheckBox = null;

	private var m_ButSave:CtrlBut = null;
	private var m_ButFlash:CtrlBut = null;
	private var m_ButFlash2:CtrlBut = null;
	private var m_ButFon:CtrlBut = null;

	public function FormSet()
	{
		var i:int;

		super(true, false);

		GridAdd();
		GridSizeX(0, 100);

		scale = StdMap.Main.m_Scale;
		width = 430;
		height = 335;
		caption = Common.Txt.FormSetCaption;

		TabAdd(Common.Txt.FormSetTabGame);

		i = ItemCheckBox(Common.Txt.FormSetHint); m_Hint = ItemObj(i) as CtrlCheckBox;
		LocNextRow();

		i = ItemInput("", 2, true, 0, false); m_HourPlanetShield = ItemObj(i) as CtrlInput;
		i = ItemLabel(Common.Txt.FormSetHourPlanetShield); ItemAlign(i, -1, 0);
		LocNextRow();

		i = ItemInput("", 10, true, 0, false); m_AccessKey = ItemObj(i) as CtrlInput;
		i = ItemLabel(Common.Txt.FormSetAccessKey); ItemAlign(i, -1, 0);
		LocNextRow();
		
		i = ItemCheckBox(Common.Txt.FormSetShieldPercent); m_ShieldPercent = ItemObj(i) as CtrlCheckBox;
		LocNextRow();

		i = ItemCheckBox(Common.Txt.FormSetUnprintable); m_Unprintable = ItemObj(i) as CtrlCheckBox;
		LocNextRow();

		TabAdd(Common.Txt.FormSetTabGraph);

		i = ItemCheckBox(Common.Txt.FormSetScopeVis); m_ScopeVis = ItemObj(i) as CtrlCheckBox;
		LocNextRow();

		i = ItemCheckBox(Common.Txt.FormSetFPS); m_FPSShow = ItemObj(i) as CtrlCheckBox;
		LocNextRow();

		i = ItemInput("", 4, true, 0, false); m_FPSMax = ItemObj(i) as CtrlInput;
		i = ItemLabel(Common.Txt.FormSetFPSMax); ItemAlign(i, -1, 0);
		LocNextRow();

		m_ButSave = new CtrlBut();
		m_ButSave.caption = Common.Txt.FormSetButSave;
		m_ButSave.x = width - m_ButSave.width - 25;
		m_ButSave.y = height - m_ButSave.height - 35;
		m_ButSave.addEventListener(MouseEvent.CLICK, clickSave);
		addChild(m_ButSave);

		m_ButFlash2 = new CtrlBut();
		m_ButFlash2.caption = Common.Txt.FormSetButFlashSettings2;
		m_ButFlash2.x = m_ButSave.x - 5 - m_ButFlash2.width;
		m_ButFlash2.y = height - m_ButFlash2.height - 35;
		m_ButFlash2.addEventListener(MouseEvent.CLICK, clickFlashSettings2);
		addChild(m_ButFlash2);

		m_ButFlash = new CtrlBut();
		m_ButFlash.caption = Common.Txt.FormSetButFlashSettings;
		m_ButFlash.x = m_ButFlash2.x - 5 - m_ButFlash.width;
		m_ButFlash.y = height - m_ButFlash.height - 35;
		m_ButFlash.addEventListener(MouseEvent.CLICK, clickFlashSettings);
		addChild(m_ButFlash);

		m_ButFon = new CtrlBut();
		m_ButFon.caption = Common.Txt.FormSetButFon;
		m_ButFon.x = 25;
		m_ButFon.y = height - m_ButFon.height - 35;
		m_ButFon.addEventListener(MouseEvent.CLICK, clickFon);
		addChild(m_ButFon);

		tab = 0;
	}

	private function clickClose(event:MouseEvent):void
	{
		event.stopImmediatePropagation();
		Hide();
	}

	override public function Show():void
	{
		m_Hint.check = EmpireMap.Self.m_Set_Hint;
		m_AccessKey.text = EmpireMap.Self.m_UserAccessKey.toString();
		m_HourPlanetShield.text = Common.NormHour(EmpireMap.Self.m_UserHourPlanetShield + EmpireMap.Self.m_DifClientServerHour).toString();
		m_Unprintable.check = EmpireMap.Self.m_Set_Unprintable;
		m_ScopeVis.check = EmpireMap.Self.m_Set_ScopeVis;
		m_FPSShow.check = EmpireMap.Self.m_Set_FPSOn;
		m_FPSMax.text = EmpireMap.Self.m_Set_FPSMax.toString();
		m_ShieldPercent.check = EmpireMap.Self.m_Set_ShieldPercent;

		m_ButFon.visible = !EmpireMap.Self.HS.visible;
		
		m_ButFlash.visible = true;
		m_ButFlash2.visible = true;
		CONFIG::air {
			m_ButFlash.visible = false;
			m_ButFlash2.visible = false;
		}

		super.Show();
	}

	private function clickSave(event:MouseEvent):void
	{
		event.stopImmediatePropagation();

		EmpireMap.Self.m_Set_Hint = m_Hint.check;

		var key:uint = int(m_AccessKey.text);

		var psh:int = Common.NormHour(int(m_HourPlanetShield.text) - EmpireMap.Self.m_DifClientServerHour);
		
		var fl:uint=0;
//		if(CheckASEmpire.selected) fl|=Common.UserFlagAutoShieldEmpire;
//		if(CheckASEnclave.selected) fl|=Common.UserFlagAutoShieldEnclave;
//		if (CheckASColony.selected) fl |= Common.UserFlagAutoShieldColony;

		if (EmpireMap.Self.m_UserHourPlanetShield != psh || EmpireMap.Self.m_UserAccessKey != key || (EmpireMap.Self.m_UserFlag & Common.UserFlagAutoShieldMask) != fl) {
			EmpireMap.Self.m_UserHourPlanetShield = psh;
			EmpireMap.Self.m_UserFlag = (EmpireMap.Self.m_UserFlag & (~Common.UserFlagAutoShieldMask)) | fl;

			EmpireMap.Self.SendActionEx(EmpireMap.Self.m_RootCotlId, "emspecial", "4_" + fl.toString() + "_0_" + key + "_" + psh.toString());
			EmpireMap.Self.m_UserAccessKey = key;
		}

		if (EmpireMap.Self.m_Set_Unprintable != m_Unprintable.check) {
			EmpireMap.Self.m_Set_Unprintable = m_Unprintable.check;
			FormChat.Self.ReloadMsg();
		}
		
		EmpireMap.Self.m_Set_ScopeVis = m_ScopeVis.check;
		EmpireMap.Self.m_Set_FPSOn = m_FPSShow.check;
		EmpireMap.Self.SetFPSMax(int(m_FPSMax.text));
		
		EmpireMap.Self.m_Set_ShieldPercent = m_ShieldPercent.check;

		SaveSet();
		
		Hide();
	}

	public function SaveSet():void
	{
		var so:SharedObject = SharedObject.getLocal("EGEmpireSet");
		if (so == null) return;
		so.data.Unprintable = EmpireMap.Self.m_Set_Unprintable;
		so.data.ScopeVis = EmpireMap.Self.m_Set_ScopeVis;
		so.data.FPS = EmpireMap.Self.m_Set_FPSOn;
		so.data.FPSMax = EmpireMap.Self.m_Set_FPSMax;
		so.data.hint = EmpireMap.Self.m_Set_Hint;
		so.data.ShieldPercent = EmpireMap.Self.m_Set_ShieldPercent;
	}

	public function LoadSet():void
	{
		var so:SharedObject = SharedObject.getLocal("EGEmpireSet");
		if (so == null || so.size == 0) return;

		if (so.data.hint == undefined) EmpireMap.Self.m_Set_Hint = true; else EmpireMap.Self.m_Set_Hint = so.data.hint;

		if (so.data.Unprintable != undefined) EmpireMap.Self.m_Set_Unprintable = so.data.Unprintable;
		if(so.data.ScopeVis!=undefined) EmpireMap.Self.m_Set_ScopeVis=so.data.ScopeVis;
		if(so.data.FPS!=undefined) EmpireMap.Self.m_Set_FPSOn=so.data.FPS;
		if(so.data.FPSMax!=undefined) {
			EmpireMap.Self.m_Set_FPSMax=so.data.FPSMax;
			if(EmpireMap.Self.m_Set_FPSMax<1) EmpireMap.Self.m_Set_FPSMax=1;
			else if(EmpireMap.Self.m_Set_FPSMax>1000) EmpireMap.Self.m_Set_FPSMax=1000;
		}
		if (so.data.ShieldPercent != undefined) {
			EmpireMap.Self.m_Set_ShieldPercent = so.data.ShieldPercent;
		}
	}

	private function clickFlashSettings(event:MouseEvent):void
	{
		Hide();
		Security.showSettings();
	}

	private function clickFlashSettings2(event:MouseEvent):void
	{
		Hide();
		Security.showSettings(SecurityPanel.SETTINGS_MANAGER);
	}

	private function clickFon(event:MouseEvent):void
	{
		Hide();
		EmpireMap.Self.SpaceStyle();
	}
}

}
