// Copyright (C) 2013 Elemental Games. All rights reserved.

package QE
{
import Base.*;
import Engine.*;
import Empire.*;

public class QEFun
{
	public static function GoTo(name:String):void
	{
		EmpireMap.Self.m_FormDialog.m_GoTo = name;
		//trace("GoTo:", name);
	}

	public static function AddDialog(filename:String, questname:String, race:int = 0, facenum:int = 0, cptname:String = null):void
	{
		EmpireMap.Self.m_FormQuestBar.AddDialog(filename, questname, race, facenum, cptname);
	}

	public static function InCotl():Boolean
	{
		return !EmpireMap.Self.HS.visible;
	}

	public static function InHome():Boolean
	{
		if (EmpireMap.Self.HS.visible) {
			if (EmpireMap.Self.HS.SP.m_NearCotl.indexOf(EmpireMap.Self.m_RootCotlId) >= 0) return true;

		} else {
			if (EmpireMap.Self.m_CotlType == Common.CotlTypeUser && EmpireMap.Self.m_CotlOwnerId == Server.Self.m_UserId) return true;
		}
		return false;
	}

	public static function IsRunQuest(filename:String):Boolean
	{
		return QEManager.FindByName(filename) != null;
	}

	public static function RunQuest(filename:String, questname:String = null, openafterload:Boolean = true):void
	{
		QEManager.RunByName(filename, questname, openafterload);
	}
	
	public static function StateReady():Boolean
	{
		return EmpireMap.Self.StateReady();
	}


	public static function OpenQuestDialog(filename:String, pagename:String = null):void
	{
		var qe:QEEngine = QEManager.FindByName(filename);
		if (qe == null) return;

		if (qe.m_StateReady) {
			var page:int = -1;
			if (pagename != null) page = qe.PageFind(pagename);

			if (EmpireMap.Self.m_FormDialog.visible && EmpireMap.Self.m_FormDialog.m_QuestId == qe.m_Id && (page < 0 || page == EmpireMap.Self.m_FormDialog.m_QuestPage || pagename == EmpireMap.Self.m_FormDialog.m_GoTo)) {
				return;
			}

			if (EmpireMap.Self.m_FormDialog.visible) EmpireMap.Self.m_FormDialog.Hide();
			EmpireMap.Self.m_FormDialog.ShowEx(qe.m_Id, pagename);
		} else {
			QEManager.NameToId(filename);
			if (QEManager.m_NameToId[filename] != undefined) {
				QEManager.m_NameToId[filename].m_OpenAfterLoad = true;
			}
		}
	}
	
	public static function NextQuest(questname:String = null):void
	{
		var qe:QEEngine = QEManager.m_ThisEngine;
		
		if (EmpireMap.Self.m_FormDialog.visible && EmpireMap.Self.m_FormDialog.m_QuestId == qe.m_Id) {
			EmpireMap.Self.m_FormDialog.Hide();
		}

		QEManager.QuestReward(qe.m_Id, -1, questname);
	}
	
	public static function BreakQuest(questname:String = null):void
	{
		var qe:QEEngine = QEManager.FindByName(questname);
		if (qe != null) {
//			if (QEManager.m_NameToId[questname] != undefined && QEManager.m_NameToId[questname].m_SaveInServer) return;
			QEManager.QuestBreak(qe.m_Id);
		}
	}

	public static function Close():void
	{
		EmpireMap.Self.m_FormDialog.Hide();
	}

	public static function CurQuestName(filename:String = null):String
	{
		var qe:QEEngine = QEManager.m_ThisEngine;
		if (filename != null) qe = QEManager.FindByName(filename);
		if (qe == null) return null;
		if (qe.m_Num<0 || qe.m_Num>=qe.m_QuestList.length) return null;
		return qe.m_QuestList[qe.m_Num].m_Name;
	}

	public static function CurQuestNum(filename:String = null):int
	{
		var qe:QEEngine = QEManager.m_ThisEngine;
		if (filename != null) qe = QEManager.FindByName(filename);
		if (qe == null) return -1;
		if (qe.m_Num<0 || qe.m_Num>=qe.m_QuestList.length) return -1;
		return qe.m_Num;
	}

	public static function FindQuest(name:String, filename:String = null):int
	{
		var qe:QEEngine = QEManager.m_ThisEngine;
		if (filename != null) qe = QEManager.FindByName(filename);
		if (qe == null) return -1;
		return qe.QuestFind(name);
	}

	public static function RootCotlId():uint
	{
		return EmpireMap.Self.m_RootCotlId;
	}

	public static function HomeworldCotlId():uint
	{
		return EmpireMap.Self.m_HomeworldCotlId;
	}

	public static function CitadelExist(cotlid:uint):Boolean
	{
		return EmpireMap.Self.CitadelExist(cotlid);
	}

	public static function IsFlagshipIn(no:int, cotlid:uint, secx:int = 0, secy:int = 0, planetnum:int = -1):Boolean
	{
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return false;

		var i:int,u:int;
		var cpt:Cpt;
		var ship:Ship;
		var planet:Planet;
		for (i = 0; i < user.m_Cpt.length;i++) {
			if (no >= 0 && no != i) continue;
			cpt = user.m_Cpt[i];
			if (cpt == null) continue;
			if (cpt.m_Id == 0) continue;
			if (cpt.m_PlanetNum < 0) continue;
			if (cpt.m_CotlId != cotlid) continue;
			if (planetnum >= 0) {
				if (cpt.m_CotlId == 0) continue;
				if (cpt.m_SectorX != secx) continue;
				if (cpt.m_SectorY != secy) continue;
				if (cpt.m_PlanetNum != planetnum) continue;

				if (Server.Self.m_CotlId != cotlid) continue;
				planet = EmpireMap.Self.GetPlanet(secx, secy, planetnum);
				if (planet == null) continue;
				for (u = 0; u < planet.m_Ship.length; u++) {
					ship = planet.m_Ship[u];
					if (ship.m_Type != Common.ShipTypeFlagship) continue;
					if (ship.m_Owner != Server.Self.m_UserId) continue;
					if ((ship.m_Id & (~Common.FlagshipIdFlag)) != cpt.m_Id) continue;
					if (ship.m_Flag & Common.ShipFlagBuild) continue;
					if (EmpireMap.Self.IsFlyOtherPlanet(ship, planet)) continue;
					break;
				}
				if (u >= planet.m_Ship.length) continue;
			}
			return true;
		}
		return false;
	}

	public static function ChatDebugMsg(str:String):void
	{
		EmpireMap.Self.m_FormChat.AddDebugMsg(str);
	}

	public static function DebugMsg(str:String):void
	{
		trace(str);
	}

	public static function SetFace(race:int, num:int, name:String):void
	{
		if (QEManager.m_ThisEngine == null) return;
		if (QEManager.m_ThisEngine.m_FaceRace == race && QEManager.m_ThisEngine.m_FaceNum == num && QEManager.m_ThisEngine.m_FaceName == name) return;
		QEManager.m_ThisEngine.m_FaceRace = race;
		QEManager.m_ThisEngine.m_FaceNum = num;
		QEManager.m_ThisEngine.m_FaceName = name;
		if (EmpireMap.Self.m_FormDialog.visible && EmpireMap.Self.m_FormDialog.m_QuestId == QEManager.m_ThisEngine.m_Id) EmpireMap.Self.m_FormDialog.UpdateFace();
		EmpireMap.Self.m_FormQuestBar.UpdateFace(QEManager.m_ThisEngine.m_Id);
	}

	public static function IsTraining():Boolean
	{
		var v:Boolean = (EmpireMap.Self.m_UserFlag & Common.UserFlagTraining) != 0;
		return v;
	}

	public static function GoToCpt(no:int = -1, show:Boolean = true):void
	{
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;

		var cpt:Cpt;
		var i:int;
		for (i = 0; i < user.m_Cpt.length;i++) {
			if (no >= 0 && no != i) continue;
			cpt = user.m_Cpt[i];
			if (cpt == null) continue;

			if (cpt == null) continue;
			if (cpt.m_Id == 0) continue;
			if (cpt.m_PlanetNum < 0) continue;
		
			EmpireMap.Self.GoTo(show, cpt.m_CotlId, cpt.m_SectorX, cpt.m_SectorY, cpt.m_PlanetNum, -1, cpt.m_Id | Common.FlagshipIdFlag);
			return;
		}
	}

	public static function Rnd(vmin:int, vmax:int):int
	{
		return Math.floor(Math.random() * (vmax - vmin + 1)) + vmin;
	}

	public static function ItfNews(v:Boolean):void	{ EmpireMap.Self.m_ItfNews = v; }
	public static function ItfChat(v:Boolean):void	{ 
		EmpireMap.Self.m_ItfChat = v;
//		if (v && EmpireMap.Self.m_FormChat.visible) return;
//		else if (!v && !EmpireMap.Self.m_FormChat.visible) return;
//		EmpireMap.Self.m_FormInfoBar.Show();
	}
	public static function ItfBattle(v:Boolean):void {
		//if (EmpireMap.Self.m_ItfBattle == v) return;
		EmpireMap.Self.m_ItfBattle = v; 
		//if (EmpireMap.Self.m_ItfBattle) EmpireMap.Self.m_FormBattleBar.Show();
		//else EmpireMap.Self.m_FormBattleBar.Hide();
	}
	public static function ItfFleet(v:Boolean):void	{
		//if (EmpireMap.Self.m_ItfFleet == v) return;
		EmpireMap.Self.m_ItfFleet = v;
		//if (v && EmpireMap.Self.m_FormFleetBar.visible) return;
		//else if (!v && !EmpireMap.Self.m_FormFleetBar.visible) return;
		//if (EmpireMap.Self.m_ItfFleet) EmpireMap.Self.m_FormFleetBar.Show();
		//else EmpireMap.Self.m_FormFleetBar.Hide();
	}
}
	
}