package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class FormExit extends FormStd
{
	private var m_Map:EmpireMap;

	private var m_ExitLongHour:CtrlInput = null;
	private var m_NewGameKey:CtrlInput = null;
	private var m_DeleteCotlKey:CtrlInput = null;
//	private var m_DeleteCotlBut:CtrlBut = null;

	private var m_CotlMoveTime:TextField = null;
//	private var m_CotlMoveBut:CtrlBut = null;
	private var m_CotlMovePayTime:TextField = null;
//	private var m_CotlMovePayBut:CtrlBut = null;
	
	private var m_ButActivate:CtrlBut = null;

	private var m_Timer:Timer = new Timer(500);

	private var m_Type:int = 1; // 1-exit 2-cotl move 3-new

	public function FormExit(map:EmpireMap)
	{
		super(true, false);
		
		var i:int;

		//width = 600;
		//height = 380;
		scale = StdMap.Main.m_Scale;
		width = 480;// 500;
		height = 380;
/*		caption = Common.Txt.FormExitCaption;

		GridAdd();
		GridSizeX(0, 150);
		LocCnt(2);

		PageAdd(Common.Txt.FormExitFast);
		ItemLabel(Common.Txt.FormExitFastText, true);
		LocNextRow();
		i = ItemBut(Common.Txt.FormExitFastBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); ItemObj(i).addEventListener(MouseEvent.CLICK, clickExitFast);

		PageAdd(Common.Txt.FormExitLong);
		ItemLabel(Common.Txt.FormExitLongText, true);
		LocNextRow();
		i = ItemLabel(Common.Txt.FormExitLongHour + ":"); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); ItemAlign(i, 1, 0);
		i = ItemInput("2", 2, true, 0, false); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); m_ExitLongHour = ItemObj(i) as CtrlInput;
		LocNextRow();
		i = ItemBut(Common.Txt.FormExitLongBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); ItemObj(i).addEventListener(MouseEvent.CLICK, clickExitLong);

		PageAdd(Common.Txt.FormExitCotlJumpDefault);
		ItemLabel(Common.Txt.FormExitCotlMoveText, true);
		LocNextRow();
		i = ItemLabel(Common.Txt.FormExitCotlMoveCooldown, true); ItemSpace(i, 0, 20); m_CotlMoveTime = ItemObj(i) as TextField;
		LocNextRow();
		i = ItemBut(Common.Txt.FormExitCotlMoveBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); m_CotlMoveBut = ItemObj(i) as CtrlBut; m_CotlMoveBut.addEventListener(MouseEvent.CLICK, clickCotlMove);

		PageAdd(Common.Txt.FormExitCotlJumpPay);
		ItemLabel(Common.Txt.FormExitCotlMovePayText, true);
		LocNextRow();
		i = ItemLabel(Common.Txt.FormExitCotlMoveCooldown, true); ItemSpace(i, 0, 20); m_CotlMovePayTime = ItemObj(i) as TextField;
		LocNextRow();
		i = ItemBut(Common.Txt.FormExitCotlMovePayBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); m_CotlMovePayBut = ItemObj(i) as CtrlBut; m_CotlMovePayBut.addEventListener(MouseEvent.CLICK, clickCotlMovePay);

		PageAdd(Common.Txt.FormExitDeleteCotl);
		ItemLabel(Common.Txt.FormExitDeleteCotlText, true);
		LocNextRow();
		i = ItemLabel(Common.Txt.FormDeleteCotlKey + ":"); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); ItemAlign(i, 1, 0);
		i = ItemInput("2", 10, true, Server.LANG_ENG, false); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); m_DeleteCotlKey = ItemObj(i) as CtrlInput; m_DeleteCotlKey.input.addEventListener(Event.CHANGE, deleteChange);
		LocNextRow();
		i = ItemBut(Common.Txt.FormExitDeleteCotlBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); m_DeleteCotlBut = ItemObj(i) as CtrlBut; m_DeleteCotlBut.addEventListener(MouseEvent.CLICK, clickDelete);
		
//		PageAdd(Common.Txt.FormExitNewGame);
//		ItemLabel(Common.Txt.FormExitNewGameText, true);*/

		m_ButActivate = new CtrlBut();
		m_ButActivate.addEventListener(MouseEvent.CLICK, clickActivate);
		addChild(m_ButActivate);
		
		m_Timer.addEventListener("timer", UpdateTimer);
		addEventListener("page", onChangePage);

		m_Map=map;

//		m_Map.stage.addEventListener(Event.RESIZE, onStageResize);
	}

	override public function Hide():void
	{
		super.Hide();
		m_Timer.stop();
	}
	
	public function ShowEx(type:int):void
	{
		var i:int;

		if (visible) Hide();
		m_Type = type;

		GridClear();
		PageClear();
		TabClear();
		ItemClear();
		m_CotlMoveTime = null;
		m_CotlMovePayTime = null;
		m_DeleteCotlKey = null;
		
		m_ButActivate.disable = false;

		if (m_Type == 1) {
			width = 480;// 500;
			height = 360;

			caption = Common.Txt.FormExitCaption;
			
			GridAdd();
			GridSizeX(0, 150);
			LocCnt(2);

			TabAdd(Common.Txt.FormExitFast);
			ItemLabel(Common.Txt.FormExitFastText, true);
			//LocNextRow();
			//i = ItemBut(Common.Txt.FormExitFastBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); ItemObj(i).addEventListener(MouseEvent.CLICK, clickExitFast);

			TabAdd(Common.Txt.FormExitLong);
			ItemLabel(Common.Txt.FormExitLongText, true);
			LocNextRow();
			i = ItemLabel(Common.Txt.FormExitLongHour + ":"); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); ItemAlign(i, 1, 0);
			i = ItemInput("2", 2, true, 0, false); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); m_ExitLongHour = ItemObj(i) as CtrlInput;
			//LocNextRow();
			//i = ItemBut(Common.Txt.FormExitLongBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); ItemObj(i).addEventListener(MouseEvent.CLICK, clickExitLong);
			
			//m_ButActivate.caption = Common.Txt.FormExitLongBut;
			
			tab = 0;
			
		} else if (m_Type == 2) {
			width = 480;// 500;
			height = 360;

			caption = Common.Txt.FormExitCotlJumpCaption;
			
			GridAdd();
			GridSizeX(0, 150);
			LocCnt(2);

			TabAdd(Common.Txt.FormExitCotlJumpDefault);
			ItemLabel(Common.Txt.FormExitCotlMoveText, true);
			LocNextRow();
			i = ItemLabel(Common.Txt.FormExitCotlMoveCooldown, true); ItemSpace(i, 0, 20); m_CotlMoveTime = ItemObj(i) as TextField;
			//LocNextRow();
			//i = ItemBut(Common.Txt.FormExitCotlMoveBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); m_CotlMoveBut = ItemObj(i) as CtrlBut; m_CotlMoveBut.addEventListener(MouseEvent.CLICK, clickCotlMove);

			TabAdd(Common.Txt.FormExitCotlJumpPay);
			ItemLabel(Common.Txt.FormExitCotlMovePayText, true);
			LocNextRow();
			i = ItemLabel(Common.Txt.FormExitCotlMoveCooldown, true); ItemSpace(i, 0, 20); m_CotlMovePayTime = ItemObj(i) as TextField;
			//LocNextRow();
			//i = ItemBut(Common.Txt.FormExitCotlMovePayBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); m_CotlMovePayBut = ItemObj(i) as CtrlBut; m_CotlMovePayBut.addEventListener(MouseEvent.CLICK, clickCotlMovePay);

			if (m_Map.IsAccountTmp()) {
				TabSetVisible(1, false);
			}
			tab = 0;

		} else if (m_Type == 3) {
			width = 480;// 500;
			height = 360;

			caption = Common.Txt.FormExitNewCpation;

			GridAdd();
			GridSizeX(0, 150);
			LocCnt(2);

			TabAdd(Common.Txt.FormExitNewRnd);
			ItemLabel(Common.Txt.FormExitDeleteCotlText, true);
			LocNextRow();
			i = ItemLabel(Common.Txt.FormDeleteCotlKey + ":"); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); ItemAlign(i, 1, 0);
			i = ItemInput("", 10, true, Server.LANG_ENG, false); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); m_DeleteCotlKey = ItemObj(i) as CtrlInput; m_DeleteCotlKey.input.addEventListener(Event.CHANGE, deleteChange);
			//LocNextRow();
			//i = ItemBut(Common.Txt.FormExitDeleteCotlBut); ItemAlign(i, 1); ItemSpace(i, 0, 20); m_DeleteCotlBut = ItemObj(i) as CtrlBut; m_DeleteCotlBut.addEventListener(MouseEvent.CLICK, clickDelete);

			TabAdd(Common.Txt.FormExitNewClear);
			ItemLabel(Common.Txt.FormExitNewGameText, true);
			LocNextRow();
			i = ItemLabel(Common.Txt.FormDeleteCotlKey + ":"); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); ItemAlign(i, 1, 0);
			i = ItemInput("", 10, true, Server.LANG_ENG, false); ItemCellCnt(i, 1); ItemSpace(i, 0, 10); m_NewGameKey = ItemObj(i) as CtrlInput; m_NewGameKey.input.addEventListener(Event.CHANGE, deleteChange);

			if (m_Map.IsAccountTmp()) {
				TabSetVisible(0, false);
				tab = 1;
			} else {
				tab = 0;
			}
		
//		PageAdd(Common.Txt.FormExitNewGame);
//		ItemLabel(Common.Txt.FormExitNewGameText, true);
			
		}

		Show();
	}

	override public function Show():void
	{
		//page = 0;
		//m_CotlMoveTime.text = "";
		//m_CotlMovePayTime.text = "";
		super.Show();
		
		
		//m_DeleteCotlKey.text = "";
		//m_DeleteCotlBut.disable = true;
		
		m_Timer.start();
		UpdateTimer();
	}

	private function clickCancel(event:MouseEvent):void
	{
		Hide();
	}

	private function clickExitLong(event:MouseEvent):void
	{
		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		if (user.m_ExitDate) return;
		
		m_Map.SendActionEx(m_Map.m_RootCotlId, "emspecial", "11_" + int(m_ExitLongHour.text));
		Hide();
	}

	private function clickExitFast(event:MouseEvent):void
	{
		if ((m_Map.m_GameState & Common.GameStateEnemy)!=0 && Server.Self.m_CotlId==m_Map.m_RootCotlId) {
			FormMessageBox.RunErr(BaseStr.Replace(Common.Txt.WarningNoOpEnemy, "[br]", " "));
			return;
		}

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		if(user.m_ExitDate) return;

		m_Map.SendActionEx(m_Map.m_RootCotlId,"emspecial","12");
		Hide();
	}

	private function clickDelete(event:MouseEvent):void
	{
		if ((m_Map.m_GameState & Common.GameStateEnemy)!=0 && Server.Self.m_CotlId==m_Map.m_RootCotlId) {
			FormMessageBox.RunErr(BaseStr.Replace(Common.Txt.WarningNoOpEnemy, "[br]", " "));
			return;
		}

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		if(user.m_ExitDate) return;

		m_Map.SendActionEx(m_Map.m_RootCotlId,"emspecial","13");
		Hide();
	}

	private function clickNewGame(event:MouseEvent):void
	{
		if ((m_Map.m_GameState & Common.GameStateEnemy)!=0 && Server.Self.m_CotlId==m_Map.m_RootCotlId) {
			FormMessageBox.RunErr(BaseStr.Replace(Common.Txt.WarningNoOpEnemy, "[br]", " "));
			return;
		}

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		if(user.m_ExitDate) return;

		m_Map.SendActionEx(m_Map.m_RootCotlId,"emspecial","32");
		Hide();
	}

	private function deleteChange(e:Event):void
	{
		if(tab==0) {
			if (m_DeleteCotlKey != null) {
				m_ButActivate.disable = m_DeleteCotlKey.text != 'DELETE';
			} 
		} else {
			if (m_NewGameKey != null) {
				m_ButActivate.disable = m_NewGameKey.text != 'NEW GAME';
			}
		}
	}
	
	private function clickActivate(...args):void
	{
		if (m_Type == 1 && tab == 0) clickExitFast(null);
		else if (m_Type == 1 && tab == 1) clickExitLong(null);
		else if (m_Type == 2 && tab == 0) clickCotlMove(null);
		else if (m_Type == 2 && tab == 1) clickCotlMovePay(null);
		else if (m_Type == 3 && tab == 0) clickDelete(null);
		else if (m_Type == 3 && tab == 1) clickNewGame(null);
	}

	public function onChangePage(e:Event):void
	{
		UpdateTimer();
	}
	
	private function UpdateTimer(event:TimerEvent = null):void
	{
		var str:String;

		if (m_Type == 1 && tab == 0) m_ButActivate.caption = Common.Txt.FormExitFastBut;
		else if (m_Type == 1 && tab == 1) m_ButActivate.caption = Common.Txt.FormExitLongBut;
		else if (m_Type == 2 && tab == 0) m_ButActivate.caption = Common.Txt.FormExitCotlMoveBut;
		else if (m_Type == 2 && tab == 1) m_ButActivate.caption = Common.Txt.FormExitCotlMovePayBut;
		else if (m_Type == 3 && tab == 0) m_ButActivate.caption = Common.Txt.FormExitDeleteCotlBut;
		else if (m_Type == 3 && tab == 1) m_ButActivate.caption = Common.Txt.FormExitNewGameBut;

		m_ButActivate.x = contentX + contentWidth - m_ButActivate.width;
		m_ButActivate.y = contentY + contentHeight - m_ButActivate.height;

		if(m_Type == 2) {
			if ((!m_Map.m_EmpireEdit) && (EmpireMap.Self.m_FormFleetBar.m_CotlMoveCooldown > m_Map.GetServerGlobalTime())) {
				str = Common.Txt.FormExitCotlMoveCooldown;
				str = BaseStr.Replace(str, "<Val>", Common.FormatPeriodLong((EmpireMap.Self.m_FormFleetBar.m_CotlMoveCooldown - m_Map.GetServerGlobalTime()) / 1000, true, 3));
				m_CotlMoveTime.htmlText = BaseStr.FormatTag(str,true,true);
				if (tab == 0) m_ButActivate.disable = true;
			} else {
				m_CotlMoveTime.text = "";
				if (tab == 0) m_ButActivate.disable = false;
			}

			if ((!m_Map.m_EmpireEdit) && (EmpireMap.Self.m_FormFleetBar.m_CotlMoveCooldownPay > m_Map.GetServerGlobalTime())) {
				str = Common.Txt.FormExitCotlMoveCooldown;
				str = BaseStr.Replace(str, "<Val>", Common.FormatPeriodLong((EmpireMap.Self.m_FormFleetBar.m_CotlMoveCooldownPay - m_Map.GetServerGlobalTime()) / 1000, true, 3));
				m_CotlMovePayTime.htmlText = BaseStr.FormatTag(str,true,true);
				if (tab == 1) m_ButActivate.disable = true;
			} else {
				m_CotlMovePayTime.text = "";
				if (tab == 1) m_ButActivate.disable = false;
			}
		}

		deleteChange(null);
	}
	
	private function clickCotlMove(event:Event):void
	{
//		if ((m_Map.m_FormFleetBar.m_Formation & 7) == 3 || (m_Map.m_FormFleetBar.m_Formation & 7) == 4) {
//			FormMessageBox.Run(Common.Txt.FormFleetTypeNoCotlMove, Common.Txt.ButClose);
//			return;
//		}

		m_Map.SendActionEx(m_Map.m_RootCotlId,"emspecial","27");
		//Server.Self.QueryHS("emfleetspecial", "&type=3", m_Map.m_FormFleetBar.AnswerSpecial, false);
		Hide();
	}

	private function clickCotlMovePay(event:Event):void
	{
		if (EmpireMap.Self.m_UserEGM < 10000) { FormMessageBox.Run(Common.Txt.NoEnoughEGM2, Common.Txt.ButClose); return; }

/*		if ((m_Map.m_FormFleetBar.m_Formation & 7) == 3 || (m_Map.m_FormFleetBar.m_Formation & 7) == 4) {
			FormMessageBox.Run(Common.Txt.FormFleetTypeNoCotlMove, Common.Txt.ButClose);
			return;
		}*/

		m_Map.SendActionEx(m_Map.m_RootCotlId,"emspecial","28");
		//Server.Self.QueryHS("emfleetspecial", "&type=5", m_Map.m_FormFleetBar.AnswerSpecial, false);
		Hide();
	}
}

}
