// Copyright (C) 2013 Elemental Games. All rights reserved.

package QE
{
import Base.*;
import Engine.*;
import Empire.*;
import flash.utils.*;
//import r1.deval.D;

public class QEEngine
{
	public var m_Id:uint = 0; // Id квеста на сервере
	public var m_Anm:uint = 0;
	public var m_AnmSend:uint = 0;
	public var m_AnmRecvAfterAnm:uint = 0;
	public var m_AnmRecvAfterAnm_Time:Number = 0;
	public var m_FileName:String = null;
	public var m_Num:int = -1;
	//public var m_State:int = 0; // 0-wait file 1-load begin 2-load end
	public var m_StateLoadComplate:Boolean = false;
	public var m_StateLinkComplate:Boolean = false;
	public var m_StateReady:Boolean = false;
	public var m_StateSelection:Boolean = false; // Сервер выбирает квест
	public var m_StateSelectionFail:Boolean = false; // Сервер ответил что квест не найден
	public var m_StateReward:Boolean = false; // Ожидаем когда сервер выдаст награду по заданию
	public var m_StateWaitSelection:Boolean = false;
	public var m_StateSaveInServer:Boolean = false;
	public var m_OpenAfterLoad:Boolean = false;

	public var m_FaceRace:int = Common.RaceNone;
	public var m_FaceNum:int = 0;
	public var m_FaceName:String = "unknown";

	public var m_ChangeDate:Number = 0;
	public var m_Owner:uint = 0;

	// Task begin
	public var m_NextName:String = null;
	public var m_NextNum:int = -1; // >=0 - от игрока ожидаем подтверждение нового квеста
	public var m_NextFromId:uint = 0;
	public var m_Flag:uint = 0;
	public var m_LocId:uint = 0;
	public var m_TaskList:Vector.<QETask> = new Vector.<QETask>(QEManager.TaskMax);
	// Task end

	public var m_RewardExp:int = 0;
	public var m_RewardMoney:int = 0;
	public var m_RewardItemType:uint = 0;
	public var m_RewardItemCnt:int = 0;

	public var m_VarName:Vector.<String> = new Vector.<String>(QEManager.VarMax);
	public var m_Var:Vector.<int> = new Vector.<int>(QEManager.VarMax);
	public var m_VarSave:Vector.<int> = new Vector.<int>(QEManager.VarMax);

	public var m_RunCnt:int = 0;

	public var m_QuestList:Vector.<QEQuest> = new Vector.<QEQuest>();
	public var m_PageList:Vector.<QEPage> = new Vector.<QEPage>();

	public var m_LinkName:Vector.<String> = new Vector.<String>();
	public var m_LinkId:Vector.<uint> = new Vector.<uint>();

//	public var m_QuestCur:int = -1;

	public var m_ErrType:String = null;
	public var m_ErrLine:int = -1;

	public var m_Context:Object = new Object();
	public var m_Init:CodeCompiler = null;
	public var m_Process:CodeCompiler = null;
	public var m_Runtime:Code = new Code();

	public var m_NextQueryFinish:Boolean = false;
	public var m_NextQueryNum:int = -1;
	public var m_NextQueryName:String = null;

	public function QEEngine():void
	{
		var i:int;
		for (i = 0; i < QEManager.TaskMax; i++) {
			m_TaskList[i] = new QETask();
		}
		for (i = 0; i < QEManager.VarMax; i++) {
			m_VarName[i] = null;
			m_Var[i] = 0;
			m_VarSave[i] = 0;
		}

		//m_Runtime.m_Env = QEManager.m_Env;
		m_Runtime.m_Env = new CodeCompiler();
		m_Runtime.m_Env.setEnv("base", QEManager.m_Env);
		m_Runtime.m_This = m_Context;
		m_Runtime.importStaticMethods(QEFun);
	}

	public function Clear():void
	{
		var i:int;

		m_Anm = 0;
		m_AnmSend = 0;
		m_AnmRecvAfterAnm = 0;
		m_AnmRecvAfterAnm_Time = 0;
		m_FileName = null;
		m_Num = -1;

		m_ChangeDate = 0;
		m_Owner = 0;

		m_NextName = null;
		m_NextNum = -1;
		TaskClear();

		m_RewardExp = 0;
		m_RewardMoney = 0;
		m_RewardItemType = 0;
		m_RewardItemCnt = 0;
		
		for (i = 0; i < QEManager.VarMax; i++) {
			m_VarName[i] = null;
			m_Var[i] = 0;
			m_VarSave[i] = 0;
		}

		m_LinkId.length = 0;
		m_LinkName.length = 0;

		m_Context = new Object();
		m_Init = null;
		m_Process = null;

		m_RunCnt = 0;

		m_QuestList.length = 0;
		m_PageList.length = 0;
//		m_QuestCur = -1;
		m_ErrType = null;
		m_ErrLine = -1;

		m_StateLoadComplate = false;
		m_StateLinkComplate = false;
		m_StateReady = false;
		m_StateSelection = false;
		m_StateSelectionFail = false;
		m_StateReward = false;
		m_OpenAfterLoad = false;
	}
	
	public function Err(err:String, line:int):void
	{
		m_ErrType = err;
		m_ErrLine = line;
	}
	
	public function TaskClear():void
	{
		var i:int;
		m_Flag = 0;
		m_LocId = 0;
		for (i = 0; i < QEManager.TaskMax; i++) m_TaskList[i].Clear();
	}
	
	public function IsTaskEmpty():Boolean
	{
		return m_TaskList[0].IsEmpty();
	}
	
	public function LoadQuestAuto(src:String):uint
	{
		var ch:int, cnt:int;
		var off:int = 0;
		var len:int = src.length;
		var name:String;

		var ret:uint = 0;
	
		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch==59 || ch == 32 || ch == 9) off++; else break; }
			if (off >= len) break;

			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 59 || ch == 32 || ch == 9) break;
				cnt++;
			}
			if (cnt < 0) continue;

			name = src.substr(off, cnt);
			off += cnt;

			if (BaseStr.EqNCEng(name, "Accept")) ret |= QEQuest.AutoAccept;
			else if (BaseStr.EqNCEng(name, "ShowComplate")) ret |= QEQuest.AutoShowComplate;
		}
		return ret;
	}
	
	public function LoadTask(src:String):QETask
	{
		var i:int, ch:int, cnt:int;
		var dw:uint;
		var onlyint:Boolean;
		var name:String;
		var off:int = 0;
		var len:int = src.length;
		var t:QETask = new QETask();
		var num:int = 0;
		
		var sub:int = 0; // 1-cotl 2-user 3-planet 4-ship 5-tech 6-construction 7-TradePath or portal 8-item 9-talent
		var cotl:uint = 0;
		var user:uint = 0;
		var planet:uint = 0;
		var ship:uint = 0;

		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch==59 || ch == 32 || ch == 9) off++; else break; }
			if (off >= len) break;
			
			if (src.charCodeAt(off) == 58) { // :
				t.m_Desc = BaseStr.Trim(src.substr(off + 1));
				break;
			}

			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 59 || ch == 32 || ch == 9) break;
				cnt++;
			}
			if (cnt < 0) continue;

			name = src.substr(off, cnt);
			off += cnt;
			
			for (i = 0; i < cnt; i++) {
				ch = name.charCodeAt(i);
				if (i == 0 && ch == 45) continue; // -
				else if (ch<48 || ch>57) break;
			}
			onlyint = i >= cnt;

			if (sub == 1) { // cotl
				if (onlyint) { cotl = int(name); sub = 0; continue; }
				else if (BaseStr.EqNCEng(name, "Neutral")) { cotl |= QETask.CotlSpecialMask | QETask.CotlNeutral; continue; }
				else if (BaseStr.EqNCEng(name, "Player")) { cotl |= QETask.CotlSpecialMask | QETask.CotlPlayer; continue; }
				else if (BaseStr.EqNCEng(name, "Friend")) { cotl |= QETask.CotlSpecialMask | QETask.CotlFriend; continue; }
				else if (BaseStr.EqNCEng(name, "Enemy")) { cotl |= QETask.CotlSpecialMask | QETask.CotlEnemy; continue; }
				else if (BaseStr.EqNCEng(name, "Home")) { cotl |= QETask.CotlSpecialMask | QETask.CotlHome; continue; }
				else if (BaseStr.EqNCEng(name, "Enclave")) { cotl |= QETask.CotlSpecialMask | QETask.CotlEnclave; continue; }
				else if (BaseStr.EqNCEng(name, "My")) { cotl |= QETask.CotlSpecialMask | QETask.CotlMy; continue; }
				else if (BaseStr.EqNCEng(name, "Other")) { cotl |= QETask.CotlSpecialMask | QETask.CotlOther; continue; }
				sub = 0;
			} else if (sub == 2) { // user
				if (onlyint) return null;
				else if (BaseStr.EqNCEng(name, "Neutral")) { user |= QETask.UserSpecialMask | QETask.UserNeutral; continue; }
				else if (BaseStr.EqNCEng(name, "AI0")) { user |= QETask.UserSpecialMask | QETask.UserAI0; continue; }
				else if (BaseStr.EqNCEng(name, "AI1")) { user |= QETask.UserSpecialMask | QETask.UserAI1; continue; }
				else if (BaseStr.EqNCEng(name, "AI2")) { user |= QETask.UserSpecialMask | QETask.UserAI2; continue; }
				else if (BaseStr.EqNCEng(name, "AI3")) { user |= QETask.UserSpecialMask | QETask.UserAI3; continue; }
				else if (BaseStr.EqNCEng(name, "QuestAI")) { user |= QETask.UserSpecialMask | QETask.UserQuestAI; continue; }
				else if (BaseStr.EqNCEng(name, "Player")) { user |= QETask.UserSpecialMask | QETask.UserPlayer; continue; }
				else if (BaseStr.EqNCEng(name, "Friend")) { user |= QETask.UserSpecialMask | QETask.UserFriend; continue; }
				else if (BaseStr.EqNCEng(name, "Enemy")) { user |= QETask.UserSpecialMask | QETask.UserEnemy; continue; }
				else if (BaseStr.EqNCEng(name, "Event")) { user |= QETask.UserSpecialMask | QETask.UserEvent; continue; }
				else if (BaseStr.EqNCEng(name, "Hist")) { user |= QETask.UserSpecialMask | QETask.UserHist; continue; }
				else if (BaseStr.EqNCEng(name, "News")) { user |= QETask.UserSpecialMask | QETask.UserNews; continue; }
				else if (BaseStr.EqNCEng(name, "Battle")) { user |= QETask.UserSpecialMask | QETask.UserBattle; continue; }
				else if (BaseStr.EqNCEng(name, "Peace")) { user |= QETask.UserSpecialMask | QETask.UserPeace; continue; }
				sub = 0;
			} else if (sub == 3) { // planet
				if (BaseStr.EqNCEng(name, "Small")) { planet |= QETask.PlanetSmall; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Large")) { planet |= QETask.PlanetLarge; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Tini")) { planet |= QETask.PlanetTini; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Gas")) { planet |= QETask.PlanetGas; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Sun")) { planet |= QETask.PlanetSun; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Pulsar")) { planet |= QETask.PlanetPulsar; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Wormhole")) { planet |= QETask.PlanetWormhole; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Crystal")) { planet |= QETask.PlanetCrystal; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Titan")) { planet |= QETask.PlanetTitan; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Silicon")) { planet |= QETask.PlanetSilicon; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (BaseStr.EqNCEng(name, "Empty")) { planet |= QETask.PlanetEmpty; t.m_Flag &= ~QETask.FlagPlanetFindMask; continue; }
				else if (name.charCodeAt(0) == 61) {  // =
					dw = BaseStr.ParseUint(name.substr(1), 16) & 0xffff;
					if ((t.m_Flag & QETask.FlagPlanetFindMask) == 0) { planet = dw | (dw << 16); t.m_Flag |= QETask.FlagPlanetFindMask; }
					else planet = (planet & 0xffff) | (dw << 16);
					continue;
				}
				else if (name.charCodeAt(0) == 38) {  // &
					dw = BaseStr.ParseUint(name.substr(1), 16) & 0xffff;
					if ((t.m_Flag & QETask.FlagPlanetFindMask) == 0) { planet = dw | (dw << 16); t.m_Flag |= QETask.FlagPlanetFindMask; }
					else planet = (planet & 0xffff0000) | dw;
					continue;
				}
			} else if (sub == 4) { // ship
				if (BaseStr.EqNCEng(name, "Transport")) { ship |= 1 << Common.ShipTypeTransport; continue; }
				else if (BaseStr.EqNCEng(name, "Corvette")) { ship |= 1 << Common.ShipTypeCorvette; continue; }
				else if (BaseStr.EqNCEng(name, "Cruiser")) { ship |= 1 << Common.ShipTypeCruiser; continue; }
				else if (BaseStr.EqNCEng(name, "Dreadnought")) { ship |= 1 << Common.ShipTypeDreadnought; continue; }
				else if (BaseStr.EqNCEng(name, "Invader")) { ship |= 1 << Common.ShipTypeInvader; continue; }
				else if (BaseStr.EqNCEng(name, "Devastator")) { ship |= 1 << Common.ShipTypeDevastator; continue; }
				else if (BaseStr.EqNCEng(name, "WarBase")) { ship |= 1 << Common.ShipTypeWarBase; continue; }
				else if (BaseStr.EqNCEng(name, "Shipyard")) { ship |= 1 << Common.ShipTypeShipyard; continue; }
				else if (BaseStr.EqNCEng(name, "Kling0")) { ship |= 1 << Common.ShipTypeKling0; continue; }
				else if (BaseStr.EqNCEng(name, "Kling1")) { ship |= 1 << Common.ShipTypeKling1; continue; }
				else if (BaseStr.EqNCEng(name, "SciBase")) { ship |= 1 << Common.ShipTypeSciBase; continue; }
				else if (BaseStr.EqNCEng(name, "Flagship")) { ship |= 1 << Common.ShipTypeFlagship; continue; }
				else if (BaseStr.EqNCEng(name, "ServiceBase")) { ship |= 1 << Common.ShipTypeServiceBase; continue; }
				else if (BaseStr.EqNCEng(name, "QuarkBase")) { ship |= 1 << Common.ShipTypeQuarkBase; continue; }

			} else if (sub == 5) {
				if (onlyint) {
					if (t.m_Par0 == 0) t.m_Par0 = int(name);
					else if (t.m_Par1 == 0) t.m_Par1 = int(name);
					else if (t.m_Par2 == 0) t.m_Par2 = int(name);
					else if (t.m_Par3 == 0) t.m_Par3 = int(name);
					else return null;
					continue;
				}
				else return null;

			} else if (sub == 6) {
				if (BaseStr.EqNCEng(name, "Energy")) { t.m_Par1 = Common.BuildingTypeEnergy; continue; }
				else if (BaseStr.EqNCEng(name, "Lab")) { t.m_Par1 = Common.BuildingTypeLab; continue; }
				else if (BaseStr.EqNCEng(name, "Missile")) { t.m_Par1 = Common.BuildingTypeMissile; continue; }
				else if (BaseStr.EqNCEng(name, "Terraform")) { t.m_Par1 = Common.BuildingTypeTerraform; continue; }
				else if (BaseStr.EqNCEng(name, "Storage")) { t.m_Par1 = Common.BuildingTypeStorage; continue; }
				else if (BaseStr.EqNCEng(name, "Xenon")) { t.m_Par1 = Common.BuildingTypeXenon; continue; }
				else if (BaseStr.EqNCEng(name, "Titan")) { t.m_Par1 = Common.BuildingTypeTitan; continue; }
				else if (BaseStr.EqNCEng(name, "Silicon")) { t.m_Par1 = Common.BuildingTypeSilicon; continue; }
				else if (BaseStr.EqNCEng(name, "Crystal")) { t.m_Par1 = Common.BuildingTypeCrystal; continue; }
				else if (BaseStr.EqNCEng(name, "Farm")) { t.m_Par1 = Common.BuildingTypeFarm; continue; }
				else if (BaseStr.EqNCEng(name, "Electronics")) { t.m_Par1 = Common.BuildingTypeElectronics; continue; }
				else if (BaseStr.EqNCEng(name, "Metal")) { t.m_Par1 = Common.BuildingTypeMetal; continue; }
				else if (BaseStr.EqNCEng(name, "Antimatter")) { t.m_Par1 = Common.BuildingTypeAntimatter; continue; }
				else if (BaseStr.EqNCEng(name, "Plasma")) { t.m_Par1 = Common.BuildingTypePlasma; continue; }
				else if (BaseStr.EqNCEng(name, "City")) { t.m_Par1 = Common.BuildingTypeCity; continue; }
				else if (BaseStr.EqNCEng(name, "Module")) { t.m_Par1 = Common.BuildingTypeModule; continue; }
				else if (BaseStr.EqNCEng(name, "Tech")) { t.m_Par1 = Common.BuildingTypeTech; continue; }
				else if (BaseStr.EqNCEng(name, "Fuel")) { t.m_Par1 = Common.BuildingTypeFuel; continue; }
				else if (BaseStr.EqNCEng(name, "Power")) { t.m_Par1 = Common.BuildingTypePower; continue; }
				else if (BaseStr.EqNCEng(name, "Armour")) { t.m_Par1 = Common.BuildingTypeArmour; continue; }
				else if (BaseStr.EqNCEng(name, "Droid")) { t.m_Par1 = Common.BuildingTypeDroid; continue; }
				else if (BaseStr.EqNCEng(name, "Machinery")) { t.m_Par1 = Common.BuildingTypeMachinery; continue; }
				else if (BaseStr.EqNCEng(name, "Engineer")) { t.m_Par1 = Common.BuildingTypeEngineer; continue; }
				else if (BaseStr.EqNCEng(name, "Mine")) { t.m_Par1 = Common.BuildingTypeMine; continue; }
				else if (BaseStr.EqNCEng(name, "Technician")) { t.m_Par1 = Common.BuildingTypeTechnician; continue; }
				else if (BaseStr.EqNCEng(name, "Navigator")) { t.m_Par1 = Common.BuildingTypeNavigator; continue; }

			} else if (sub == 7) {
				if (onlyint) {
					if (num == 0) t.m_Par1 = int(name)&0xffff;
					else if (num == 1) t.m_Par1 |= uint(int(name)) << 16;
					else t.m_Par3 = int(name);
					num++;
					continue;
				}

			} else if (sub == 8) {
				if (onlyint) t.m_Par3 = int(name);
				else if (BaseStr.EqNCEng(name, "Module")) { t.m_Par3 = Common.ItemTypeModule; continue; }
				else if (BaseStr.EqNCEng(name, "Armour")) { t.m_Par3 = Common.ItemTypeArmour; continue; }
				else if (BaseStr.EqNCEng(name, "Power")) { t.m_Par3 = Common.ItemTypePower; continue; }
				else if (BaseStr.EqNCEng(name, "Repair")) { t.m_Par3 = Common.ItemTypeRepair; continue; }
				else if (BaseStr.EqNCEng(name, "Fuel")) { t.m_Par3 = Common.ItemTypeFuel; continue; }
				else if (BaseStr.EqNCEng(name, "Double")) { t.m_Par3 = Common.ItemTypeDouble; continue; }
				else if (BaseStr.EqNCEng(name, "Monuk")) { t.m_Par3 = Common.ItemTypeMonuk; continue; }
				else if (BaseStr.EqNCEng(name, "Antimatter")) { t.m_Par3 = Common.ItemTypeAntimatter; continue; }
				else if (BaseStr.EqNCEng(name, "Metal")) { t.m_Par3 = Common.ItemTypeMetal; continue; }
				else if (BaseStr.EqNCEng(name, "Electronics")) { t.m_Par3 = Common.ItemTypeElectronics; continue; }
				else if (BaseStr.EqNCEng(name, "Protoplasm")) { t.m_Par3 = Common.ItemTypeProtoplasm; continue; }
				else if (BaseStr.EqNCEng(name, "Nodes")) { t.m_Par3 = Common.ItemTypeNodes; continue; }
				else if (BaseStr.EqNCEng(name, "Armour2")) { t.m_Par3 = Common.ItemTypeArmour2; continue; }
				else if (BaseStr.EqNCEng(name, "Power2")) { t.m_Par3 = Common.ItemTypePower2; continue; }
				else if (BaseStr.EqNCEng(name, "Repair2")) { t.m_Par3 = Common.ItemTypeRepair2; continue; }
				else if (BaseStr.EqNCEng(name, "Mine")) { t.m_Par3 = Common.ItemTypeMine; continue; }
				else if (BaseStr.EqNCEng(name, "Money")) { t.m_Par3 = Common.ItemTypeMoney; continue; }
				else if (BaseStr.EqNCEng(name, "Titan")) { t.m_Par3 = Common.ItemTypeTitan; continue; }
				else if (BaseStr.EqNCEng(name, "Silicon")) { t.m_Par3 = Common.ItemTypeSilicon; continue; }
				else if (BaseStr.EqNCEng(name, "Crystal")) { t.m_Par3 = Common.ItemTypeCrystal; continue; }
				else if (BaseStr.EqNCEng(name, "Xenon")) { t.m_Par3 = Common.ItemTypeXenon; continue; }
				else if (BaseStr.EqNCEng(name, "Hydrogen")) { t.m_Par3 = Common.ItemTypeHydrogen; continue; }
				else if (BaseStr.EqNCEng(name, "Food")) { t.m_Par3 = Common.ItemTypeFood; continue; }
				else if (BaseStr.EqNCEng(name, "Plasma")) { t.m_Par3 = Common.ItemTypePlasma; continue; }
				else if (BaseStr.EqNCEng(name, "Machinery")) { t.m_Par3 = Common.ItemTypeMachinery; continue; }
				else if (BaseStr.EqNCEng(name, "Engineer")) { t.m_Par3 = Common.ItemTypeEngineer; continue; }
				else if (BaseStr.EqNCEng(name, "Technician")) { t.m_Par3 = Common.ItemTypeTechnician; continue; }
				else if (BaseStr.EqNCEng(name, "Navigator")) { t.m_Par3 = Common.ItemTypeNavigator; continue; }
				else if (BaseStr.EqNCEng(name, "QuarkCore")) { t.m_Par3 = Common.ItemTypeQuarkCore; continue; }

				else if (BaseStr.EqNCEng(name, "InShip")) { t.m_Flag |= QETask.Flag_PlaceItem_InShip; continue; }
				else if (BaseStr.EqNCEng(name, "InPlanet")) { t.m_Flag |= QETask.Flag_PlaceItem_InPlanet; continue; }
				else if (BaseStr.EqNCEng(name, "InOrbit")) { t.m_Flag |= QETask.Flag_PlaceItem_InOrbit; continue; }
				else if (BaseStr.EqNCEng(name, "InHold")) { t.m_Flag |= QETask.Flag_PlaceItem_InHold; continue; }

				else if (BaseStr.EqNCEng(name, "NoDefect")) { t.m_Flag |= QETask.Flag_BuildItem_NoDefect; continue; }

			} else if (sub == 9) {
				if (t.m_Par0 == 0) t.m_Par0 = BaseStr.ParseUint(name, 16);
				else if (t.m_Par1 == 0) t.m_Par1 = BaseStr.ParseUint(name, 16);
				else if (t.m_Par2 == 0) t.m_Par2 = BaseStr.ParseUint(name, 16);
				else if (t.m_Par3 == 0) t.m_Par3 = BaseStr.ParseUint(name, 16);
				else return null;
				continue;
			}

			if (onlyint) {
				if (num == 0) t.m_Cnt = int(name);
				else if (num == 1 && (t.m_Flag & QETask.TypeMask) == QETask.TypePlaceShip) t.m_Par3 = int(name);
				else if (num == 1 && (t.m_Flag & QETask.TypeMask) == QETask.TypeLinkage) t.m_Par3 = int(name);
				num++;
				continue;

			} else if((t.m_Flag & QETask.TypeMask)==0) {
				if (BaseStr.EqNCEng(name, "Action")) t.m_Flag |= QETask.TypeAction;
				else if (BaseStr.EqNCEng(name, "DestroyShip")) { t.m_Flag |= QETask.TypeDestroyShip; num = 0; sub = 4; }
				else if (BaseStr.EqNCEng(name, "BuildShip")) { t.m_Flag |= QETask.TypeBuildShip; num = 0; sub = 4; }
				else if (BaseStr.EqNCEng(name, "Capture")) { t.m_Flag |= QETask.TypeCapture; sub = 3; }
				else if (BaseStr.EqNCEng(name, "PlaceShip")) { t.m_Flag |= QETask.TypePlaceShip; num = 0; sub = 4; }
				else if (BaseStr.EqNCEng(name, "Research")) { t.m_Flag |= QETask.TypeResearch; sub = 5; }
				else if (BaseStr.EqNCEng(name, "Construction")) { t.m_Flag |= QETask.TypeConstruction; sub = 6; }
				else if (BaseStr.EqNCEng(name, "TradePath")) { t.m_Flag |= QETask.TypeTradePath; num = 0; sub = 7; }
				else if (BaseStr.EqNCEng(name, "Linkage")) { t.m_Flag |= QETask.TypeLinkage; num = 0; sub = 4; }
				else if (BaseStr.EqNCEng(name, "TakeItem")) { t.m_Flag |= QETask.TypeTakeItem; num = 0; sub = 8; }
				else if (BaseStr.EqNCEng(name, "PlaceItem")) { t.m_Flag |= QETask.TypePlaceItem; num = 0; sub = 8; }
				else if (BaseStr.EqNCEng(name, "Repair")) { t.m_Flag |= QETask.TypeRepair; num = 0; sub = 4; }
				else if (BaseStr.EqNCEng(name, "Balance")) { t.m_Flag |= QETask.TypeBalance; num = 0; sub = 8; }
				else if (BaseStr.EqNCEng(name, "BuildItem")) { t.m_Flag |= QETask.TypeBuildItem; num = 0; sub = 8; }
				else if (BaseStr.EqNCEng(name, "Portal")) { t.m_Flag |= QETask.TypePortal; num = 0; sub = 7; }
				else if (BaseStr.EqNCEng(name, "Talent")) { t.m_Flag |= QETask.TypeTalent; num = 0; sub = 9; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeAction) {
				if (BaseStr.EqNCEng(name, "NewHomeworld")) t.m_Par2 = QETask.ActionNewHomeworld;
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeDestroyShip) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Owner")) { sub = 2; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBuildShip) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeCapture) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Owner")) { sub = 2; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePlaceShip) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else if (BaseStr.EqNCEng(name, "Protect")) { t.m_Flag |= QETask.Flag_PlaceShip_Protect; }
				else if (BaseStr.EqNCEng(name, "NoEnemy")) { t.m_Flag |= QETask.Flag_PlaceShip_NoEnemy; }
				else if (BaseStr.EqNCEng(name, "InMobil")) { t.m_Flag |= QETask.Flag_PlaceShip_InMobil; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeConstruction) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeTradePath) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeLinkage) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeTakeItem) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else if (BaseStr.EqNCEng(name, "Ship")) { sub = 4; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePlaceItem) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else if (BaseStr.EqNCEng(name, "Ship")) { sub = 4; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeRepair) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBalance) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBuildItem) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePortal) {
				if (BaseStr.EqNCEng(name, "Cotl")) { sub = 1; }
				else if (BaseStr.EqNCEng(name, "Planet")) { sub = 3; }
				else return null;

			} else return null;
		}

		if (t.m_Cnt < 1) t.m_Cnt = 1;

		if ((t.m_Flag & QETask.TypeMask) == QETask.TypeDestroyShip) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = user;
			t.m_Par2 = ship;
			t.m_Par3 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBuildShip) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = ship;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeCapture) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = user;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePlaceShip) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = ship;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeConstruction) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeTradePath) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeLinkage) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = ship;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeTakeItem) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = ship;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePlaceItem) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = ship;
			t.m_Par2 = planet;
			
		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeRepair) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par1 = ship;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBalance) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBuildItem) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par2 = planet;

		} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePortal) {
			if (cotl != 0) t.m_Par0 = cotl; else t.m_Par0 = QETask.CotlDefault;
			t.m_Par2 = planet;
		}

		return t;
	}
	
/*	public function LoadActionCotl(src:String, sl:SaveLoad):void
	{
		var i:int, ch:int, cnt:int;
		var dw:uint;
		var onlyint:Boolean;
		var name:String;
		var off:int = 0;
		var len:int = src.length;

		var cotl:uint = 0;

		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch==59 || ch == 32 || ch == 9) off++; else break; }
			if (off >= len) break;

			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 59 || ch == 32 || ch == 9) break;
				cnt++;
			}
			if (cnt < 0) continue;

			name = src.substr(off, cnt);
			off += cnt;

			for (i = 0; i < cnt; i++) {
				ch = name.charCodeAt(i);
				if (ch<48 || ch>57) break;
			}
			onlyint = i >= cnt;

			if (onlyint) { cotl = int(name); continue; }
			else if (BaseStr.EqNCEng(name, "Home")) { cotl |= QETask.CotlSpecialMask | QETask.CotlHome; continue; }
			else if (BaseStr.EqNCEng(name, "Enclave")) { cotl |= QETask.CotlSpecialMask | QETask.CotlEnclave; continue; }
		}

		sl.SaveDword(cotl);
	}*/
	
	public function LoadCall(src:String, q:QEQuest):Boolean
	{
		q.m_CallCotlId = 0;
		q.m_CallName = null;
		q.m_CallVal = 0;
		
		var i:int, ch:int, cnt:int;
		var num:int = 0;
		var dw:uint;
		var onlyint:Boolean;
		var name:String;
		var off:int = 0;
		var len:int = src.length;

		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch==59 || ch == 32 || ch == 9) off++; else break; }
			if (off >= len) break;

			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 59 || ch == 32 || ch == 9) break;
				cnt++;
			}
			if (cnt < 0) continue;

			name = src.substr(off, cnt);
			off += cnt;

			for (i = 0; i < cnt; i++) {
				ch = name.charCodeAt(i);
				if (ch<48 || ch>57) break;
			}
			onlyint = i >= cnt;

			if (onlyint) {
				if (num == 0) q.m_CallCotlId = int(name);
				else q.m_CallVal = int(name);
				num++;
				continue;
			}
			else if (BaseStr.EqNCEng(name, "Home")) { q.m_CallCotlId |= QETask.CotlSpecialMask | QETask.CotlHome; num++; continue; }
			else if (BaseStr.EqNCEng(name, "Enclave")) { q.m_CallCotlId |= QETask.CotlSpecialMask | QETask.CotlEnclave; num++; continue; }
			else q.m_CallName = name;
		}

		return true;
	}

	public function LoadActionPlanetMask(src:String, sl:SaveLoad):void
	{
		var mask:uint = 0;
		var eq:uint = 0;

		var ch:int, cnt:int;
		var off:int = 0;
		var len:int = src.length;
		var name:String;

		var first:Boolean = true;
	
		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch==59 || ch == 32 || ch == 9) off++; else break; }
			if (off >= len) break;

			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 59 || ch == 32 || ch == 9) break;
				cnt++;
			}
			if (cnt < 0) continue;

			name = src.substr(off, cnt);
			off += cnt;
			
			if (BaseStr.EqNCEng(name, "all")) {
				mask = 0;
				eq = 0;
				break;
			} else if (name.charCodeAt(0) == 38) { // &
				mask = BaseStr.ParseUint(name.substr(1), 2);
				if (first) eq = mask;
				first = false;

			} else if (name.charCodeAt(0) == 61) { // =
				eq = BaseStr.ParseUint(name.substr(1), 2);
				if (first) mask = eq;
				first = false;
			}
		}

		sl.SaveDword(mask);
		sl.SaveDword(eq);
	}
	
	public function LoadHistRewardNeed(src:String):String
	{
		var i:int, ch:int, cnt:int;
		var off:int = 0;
		var len:int = src.length;

		var ret:String = null;
		
		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch==59 || ch==44 || ch == 32 || ch == 9) off++; else break; }
			if (off >= len) break;
			
			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 59 || ch==44 || ch == 32 || ch == 9) break;
				cnt++;
			}
			if (cnt < 0) continue;

			if (ret == null) ret = "";
			else ret += "~";
			ret += src.substr(off, cnt);
			off += cnt;
		}
		
		return ret;
	}

	public function Load(src:String, full:Boolean = true):void
	{
		var name:String, str:String;
		var code:Object;
		var i:int, u:int, k:int, cnt:int, linebegin:int;
		var ibegin:int, iend:int;
		var ch:int, ch2:int;
		var len:int=src.length;
		var off:int = 0;
		var line:int = 1;
		var cc:CodeCompiler;

		m_ErrType = null;
		m_ErrLine = -1;

		var qtxt:QEText;

		var global:Boolean = false;
		var process:Boolean = false;
		var quest:QEQuest = null;
//		var action:Boolean = false;
		var page:QEPage = null;
		var answer:QEAnswer = null;

//		var action_sl:SaveLoad = new SaveLoad();
//		var action_open:Boolean = false;

		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch == 32 || ch == 9 || ch == 13) off++; else if (ch == 10) { off++; line++; } else break; }
			if(off>=len) break;

			ch = src.charCodeAt(off);
			if (ch == 0x5b) { // []
				if (off <= 0 || src.charCodeAt(off - 1) == 10) answer = null;
				
				off++;
				while (off < len) { ch = src.charCodeAt(off); if (ch == 32 || ch == 9) off++; else if (ch == 10) { off++; line++; } else break; }

				ibegin=off;
				while(off<len) { ch=src.charCodeAt(off); if(ch!=0x5D) off++; else break; }
				if(off>=len) break;

				iend=off; off++;
				while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

				if (iend > ibegin) {
					u = src.indexOf(",", ibegin);
					name = null;
					if (u > ibegin && u < iend) {
						name = src.substring(u + 1, iend);
						iend = u;
					}

					if (iend > ibegin) {
						str = src.substring(ibegin, iend);
						if (answer != null) {
							answer.m_Page = str;

						} else if (BaseStr.EqNCEng(str, "global")) {
							global = true;
							process = false;
							quest = null;
//							action = false;
							page = null;
							answer = null;

						} else if (BaseStr.EqNCEng(str, "process")) {
							global = false;
							process = true;
							quest = null;
//							action = false;
							page = null;
							answer = null;

						} else if (BaseStr.EqNCEng(str, "quest")) {
//							if (action_open) {
//								action_sl.SaveEnd();
//								action_open = false;
//							}
							global = false;
							process = false;
							page = null;
							answer = null;
//							action = false;
							if (m_QuestList.length >= (32 * QEManager.HistRewardMax)) { Err("too many quest", line); return; }
							quest = new QEQuest();
							if (name != null) name = BaseStr.Trim(name);
							quest.m_Name = name;
							quest.m_Num = m_QuestList.length;
							m_QuestList.push(quest);

//						} else if (BaseStr.EqNCEng(str, "action")) {
//							if(quest==null) { m_ErrType = "action is no in quest"; m_ErrLine = line; return; }
//							action = true;
//							if (quest.m_Action == null) {
//								quest.m_Action = new ByteArray();
//								quest.m_Action.endian = Endian.LITTLE_ENDIAN;
//								action_sl.SaveBegin(quest.m_Action);
//								action_open = true;
//							}

						} else {
							global = false;
							process = false;
							answer = null;
//							action = false;
							page = new QEPage();
							page.m_SrcLine = line;
							page.m_Name = str;
							page.m_Quest = quest;
							m_PageList.push(page);
						}
					}
				}
			} else if(ch==0x2f) { // /
				off++; if(off>=len) break;
				if(src.charCodeAt(off)!=0x2f) continue;

				while (off < len) { ch = src.charCodeAt(off); if (ch != 10) off++; else break; }

			} else if (ch == 123) { // {}
				off++;
				while (off < len) { ch = src.charCodeAt(off); if (ch == 32 || ch == 9 || ch==13) off++; else if (ch == 10) { off++; line++; } else break; }

				linebegin = line;
				ibegin = off;
				i = 0;
				while (off < len) {
					ch = src.charCodeAt(off);
					if (ch == 123) i++;
					else if (ch == 125) {
						i--;
						if (i < 0) break;
					}
					else if (ch == 10) line++;
					off++;
				}
				if (off >= len) break;

				if (i != -1) { Err("syntax", line); return; }

				iend=off; off++;
				while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

				if (iend > ibegin && full) {
					if (global) {
						try {
							m_Init = new CodeCompiler();
							m_Init.m_Src = new CodeSrc(src.substring(ibegin, iend));
							m_Init.m_Src.m_Line = linebegin-1;
							m_Init.parseFun();
							m_Init.prepare(m_Runtime.m_Env);// QEManager.m_Env);
							m_Init.extractStaticVar(m_Context);
							if (m_Init.m_Src.err) {
								Err("Compiler error: " + m_Init.m_Src.err.toString() + " line: " + (m_Init.m_Src.m_Line + 1).toString() + " char: " + (m_Init.m_Src.m_Char + 1).toString(), linebegin);
								return;
							}
							m_Runtime.m_Env.setEnv("init", m_Init);

							//m_Init = D.parseProgram(src.substring(ibegin, iend));
							//m_Context = D.parseFunctions(src.substring(ibegin, iend));
//							QEManager.InitContext(m_Context);
//							m_Context.vaaa = 998;
//							m_Context.vccc = new Object();// { q:555 };
//							m_Context.vccc.q = 555;
						} catch (err:*) {
							Err("Compiler exception: " + err.message, linebegin); return;
						}
					} else {
						try {
							str = src.substring(ibegin, iend);

							cc = null;

							if (process) {
								cc = new CodeCompiler(new CodeSrc(str)); m_Process = cc; /*D.parseProgram(str);*/
							}
							else if (answer != null) { cc = new CodeCompiler(new CodeSrc(str)); answer.m_If = cc; /*D.parseProgram(str);*/ }
							else if (page != null) { 
								//trace("PageIf:", src.substring(ibegin, iend)); 
								if (page.m_SrcLine == linebegin) { cc = new CodeCompiler(new CodeSrc(str)); page.m_If = cc; /*D.parseProgram(str);*/ }
								else if (BaseStr.EqNCEng(str, "#end")) {
									qtxt = new QEText(); qtxt.m_Type = QEText.TypeIfEnd;
									if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
									page.m_TextList.push(qtxt);

								} else if (BaseStr.EqNCEng(str, "#else")) {
									qtxt = new QEText(); qtxt.m_Type = QEText.TypeElse;
									if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
									page.m_TextList.push(qtxt);

								} else if (BaseStr.IsTagEqNCEng(str, 0, 7, "#elseif")) {
									qtxt = new QEText(); qtxt.m_Type = QEText.TypeElseIf; cc = new CodeCompiler(new CodeSrc(str.substr(7))); qtxt.m_Data = cc;// D.parseProgram(str.substr(7));
									if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
									page.m_TextList.push(qtxt);

								} else if (BaseStr.IsTagEqNCEng(str, 0, 3, "#if")) {
									qtxt = new QEText(); qtxt.m_Type = QEText.TypeIf; cc = new CodeCompiler(new CodeSrc(str.substr(3))); qtxt.m_Data = cc;// D.parseProgram(str.substr(3));
									if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
									page.m_TextList.push(qtxt);

								} else {
									qtxt = new QEText(); qtxt.m_Type = QEText.TypeRun; cc = new CodeCompiler(new CodeSrc(str)); qtxt.m_Data = cc;// D.parseProgram(str);
									if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
									page.m_TextList.push(qtxt);
								}
							}
							else if (quest != null) { cc = new CodeCompiler(new CodeSrc(str)); quest.m_If = cc; /*D.parseProgram(str);*/ }

							if (cc != null) {
								cc.m_Src.m_Line = linebegin - 1;
								cc.parseFun();
								cc.prepare(m_Runtime.m_Env);// QEManager.m_Env);
								if (cc.m_Src.err) {
									Err("Compiler error: " + cc.m_Src.err.toString() + " line: " + (cc.m_Src.m_Line + 1).toString() + " char: " + (cc.m_Src.m_Char + 1).toString(), linebegin);
									return;
								}
								if (process) {
									m_Runtime.m_Env.setEnv("process", m_Process);
								}
							}
						} catch (err:*) {
							Err("Compiler exception: " + err.message, linebegin); return;
						}
					}
				}
			} else if(ch==45) { // -
				off++; if (off >= len) break;

				if (page == null) { Err("syntax", line); return; }

				if (page.m_AnswerList == null) page.m_AnswerList = new Vector.<QEAnswer>();
				answer = new QEAnswer();
				page.m_AnswerList.push(answer);

			} else if(ch==124) { // |
				off++; if (off >= len) break;
				
				if (page == null) { Err("syntax", line); return; }
				
				if (page.m_AnswerList == null) page.m_AnswerList = new Vector.<QEAnswer>();
				answer = new QEAnswer();
				answer.m_Or = true;
				page.m_AnswerList.push(answer);

			} else if ((quest != null && page == null && answer == null) || global) {
				// Par
				ibegin = off;
				var par:Boolean = true;
				if(par) {
					while (ibegin < len) {
						ch = src.charCodeAt(ibegin);
						ibegin++;
						if (ch == 61) break;
						else if (ch == 32 || ch == 9 || ch==10) { par = false; break;  }
					}
					if (ibegin >= len) par = false;
				}

				if (par) {
					name = src.substring(off, ibegin-1);
					off = ibegin;

					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend = off;

					for (i = ibegin + 1; i < iend; i++) if (src.charCodeAt(i - 1) == 0x2f && src.charCodeAt(i) == 0x2f) { iend = i - 1; break; } // //

					if (iend > ibegin) {
						str = BaseStr.Trim(src.substring(ibegin, iend));
						if (global) {
							if (BaseStr.EqNCEng(name, "var0")) m_VarName[0] = str;
							else if (BaseStr.EqNCEng(name, "var1")) m_VarName[1] = str;
							else if (BaseStr.EqNCEng(name, "var2")) m_VarName[2] = str;
							else if (BaseStr.EqNCEng(name, "var3")) m_VarName[3] = str;
							else if (BaseStr.EqNCEng(name, "link")) { m_LinkName.push(str); m_LinkId.push(0); }
							else if (BaseStr.EqNCEng(name, "FaceRace")) {
								for (i = 0; i < Common.RaceSysName.length; i++) if (BaseStr.EqNCEng(str, Common.RaceSysName[i])) m_FaceRace = i;
							}
							else if (BaseStr.EqNCEng(name, "FaceNum")) m_FaceNum = int(str);
							else if (BaseStr.EqNCEng(name, "FaceName")) m_FaceName = str;

/*						} else if (action) {
							if (BaseStr.EqNCEng(name, "cotl")) {
								action_sl.SaveDword(QEQuest.ActionCotl);
								LoadActionCotl(str, action_sl);
								if(quest.m_Action.length>QEQuest.ActionMax) { m_ErrType = "action size"; m_ErrLine = line; return; }

							} else if (BaseStr.EqNCEng(name, "VisOff")) {
								action_sl.SaveDword(QEQuest.ActionVisOff);
								LoadActionPlanetMask(str, action_sl);
								if(quest.m_Action.length>QEQuest.ActionMax) { m_ErrType = "action size"; m_ErrLine = line; return; }

							} else if (BaseStr.EqNCEng(name, "VisOn")) {
								action_sl.SaveDword(QEQuest.ActionVisOn);
								LoadActionPlanetMask(str, action_sl);
								if(quest.m_Action.length>QEQuest.ActionMax) { m_ErrType = "action size"; m_ErrLine = line; return; }

							} else if (BaseStr.EqNCEng(name, "MoveOff")) {
								action_sl.SaveDword(QEQuest.ActionMoveOff);
								LoadActionPlanetMask(str, action_sl);
								if(quest.m_Action.length>QEQuest.ActionMax) { m_ErrType = "action size"; m_ErrLine = line; return; }

							} else if (BaseStr.EqNCEng(name, "MoveOn")) {
								action_sl.SaveDword(QEQuest.ActionMoveOn);
								LoadActionPlanetMask(str, action_sl);
								if(quest.m_Action.length>QEQuest.ActionMax) { m_ErrType = "action size"; m_ErrLine = line; return; }

							} else if (BaseStr.EqNCEng(name, "CaptureOff")) {
								action_sl.SaveDword(QEQuest.ActionCaptureOff);
								LoadActionPlanetMask(str, action_sl);
								if(quest.m_Action.length>QEQuest.ActionMax) { m_ErrType = "action size"; m_ErrLine = line; return; }

							} else if (BaseStr.EqNCEng(name, "CaptureOn")) {
								action_sl.SaveDword(QEQuest.ActionCaptureOn);
								LoadActionPlanetMask(str, action_sl);
								if(quest.m_Action.length>QEQuest.ActionMax) { m_ErrType = "action size"; m_ErrLine = line; return; }
							}*/
						} else {
							if (BaseStr.EqNCEng(name, "Task")) {
								var q:QETask = LoadTask(str);
								if (q != null && !q.IsEmpty()) {
									if (quest.m_TaskList == null) quest.m_TaskList = new Vector.<QETask>();
									quest.m_TaskList.push(q);
								} else {
									Err("task", line);
									return;
								}
							} else if (BaseStr.EqNCEng(name, "RewardExp")) {
								quest.m_RewardExp = int(str);

							} else if (BaseStr.EqNCEng(name, "RewardMoney")) {
								quest.m_RewardMoney = int(str);

							} else if (BaseStr.EqNCEng(name, "RewardItem")) {
								k = str.indexOf(",");
								if (k >= 0) {
									quest.m_RewardItemCnt = int(str.substr(k + 1));
									str = str.substr(0, k);
								}
								quest.m_RewardItemType = FormHist.StrToItemType(str);
								if (quest.m_RewardItemType == 0) quest.m_RewardItemCnt = 0;

							} else if (BaseStr.EqNCEng(name, "EnterFrom")) {
								quest.m_HistRewardNeed = LoadHistRewardNeed(str);

							} else if (BaseStr.EqNCEng(name, "Extern")) {
								quest.m_Extern = BaseStr.Trim(str);

							} else if (BaseStr.EqNCEng(name, "Auto")) {
								quest.m_Auto = LoadQuestAuto(str);
							
							} else if (BaseStr.EqNCEng(name, "Call")) {
								if (!LoadCall(str, quest)) { Err("call", line); return; }
							}
						}
					}
				}
			} else {
				// Text
				while (off < len) {
					cnt = 0;
					var ch123:Boolean = false;
					while ((off + cnt) < len) {
						ch = src.charCodeAt(off + cnt);
						if (ch == 60) break; // <
						else if (ch == 123) { ch123 = true; break; } // {
						else if (ch == 10 || ch==13) break;
						cnt++;
					}

					if (cnt > 0) {
						if(full) {
							qtxt = new QEText();
							qtxt.m_Type = QEText.TypeText;
							qtxt.m_Data = src.substr(off, cnt);

							if (answer != null) {
								if (answer.m_TextList == null) answer.m_TextList = new Vector.<QEText>();
								answer.m_TextList.push(qtxt);
							} else if (page != null) {
								if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
								page.m_TextList.push(qtxt);
							}
						}
						off += cnt;
					}

					if (ch123) break;

					if (((off + 1) < len) && src.charCodeAt(off) == 60 && src.charCodeAt(off+1) == 123) { // <{
						off += 2;
						linebegin = line;
						ibegin = off;
						i = 0;
						while ((off + 1) < len) {
							ch = src.charCodeAt(off);
							ch2 = src.charCodeAt(off + 1);
							if (ch == 60 && ch2 == 123) { // <{
								off += 2;
								i++;
							} else if (ch == 125 && ch2 == 62) { // }>
								off += 2;
								i--;
								if (i < 0) break;
							} else if (ch == 10) {
								line++;
								off++;
							} else off++;
						}
						if (i != -1) { Err("syntax", linebegin); return; }
						iend = off - 2;

						if ((ibegin < iend) && full) {
							try {
								cc = new CodeCompiler(new CodeSrc(src.substring(ibegin, iend)))
								cc.m_Src.m_Line = linebegin - 1;
								cc.parseFun();
								cc.prepare(m_Runtime.m_Env);// QEManager.m_Env);
								if (cc.m_Src.err) {
									Err("Compiler error: " + cc.m_Src.err.toString() + " line: " + (cc.m_Src.m_Line + 1).toString() + " char: " + (cc.m_Src.m_Char + 1).toString(), line);
									return;
								}

								//code = D.parseProgram(src.substring(ibegin, iend));
								qtxt = new QEText();
								qtxt.m_Type = QEText.TypeCode;
								qtxt.m_Data = cc;
								if (answer != null) {
									if (answer.m_TextList == null) answer.m_TextList = new Vector.<QEText>();
									answer.m_TextList.push(qtxt);
								} else if (page != null) {
									if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
									page.m_TextList.push(qtxt);
								}
							} catch (err:*) {
								Err("Compiler exception: " + err.message, line); return;
							}
						}

					} else if (((off + 1) < len) && src.charCodeAt(off) == 60 && src.charCodeAt(off+1) == 91) { // <[
						off += 2;
						linebegin = line;
						ibegin = off;
						i = 0;
						while ((off + 1) < len) {
							ch = src.charCodeAt(off);
							ch2 = src.charCodeAt(off + 1);
							if (ch == 60 && ch2 == 91) { // <[
								off += 2;
								i++;
							} else if (ch == 93 && ch2 == 62) { // ]>
								off += 2;
								i--;
								if (i < 0) break;
							} else if (ch == 10) {
								line++;
								off++;
							} else off++;
						}
						if (i != -1) { Err("syntax", linebegin); return; }
						iend = off - 2;

						if ((ibegin < iend) && full) {
							qtxt = new QEText();
							qtxt.m_Type = QEText.TypePage;
							qtxt.m_Data = BaseStr.Trim(src.substring(ibegin, iend));
							if (answer != null) {
								if (answer.m_TextList == null) answer.m_TextList = new Vector.<QEText>();
								answer.m_TextList.push(qtxt);
							} else if (page != null) {
								if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
								page.m_TextList.push(qtxt);
							}
						}

					} else if ((off < len) && src.charCodeAt(off) == 60) { // <
						off += 1;
						linebegin = line;
						ibegin = off;
						i = 0;
						while (off < len) {
							ch = src.charCodeAt(off);
							if (ch == 60) { // <
								off++;
								i++;
							} else if (ch == 62) { // >
								off++;
								i--;
								if (i < 0) break;
							} else if (ch == 10) {
								line++;
								off++;
							} else off++;
						}
						if (i != -1) { Err("syntax", linebegin); return; }
						iend = off - 1;

						
						if ((ibegin < iend) && full) {
							qtxt = new QEText();
							qtxt.m_Type = QEText.TypeSub;
							qtxt.m_Data = BaseStr.Trim(src.substring(ibegin, iend));
							if (answer != null) {
								if (answer.m_TextList == null) answer.m_TextList = new Vector.<QEText>();
								answer.m_TextList.push(qtxt);
							} else if (page != null) {
								if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
								page.m_TextList.push(qtxt);
							}
						}

					} else {
						if (full) {
							qtxt = new QEText();
							qtxt.m_Type = QEText.TypeEnd;
							if (answer != null) {
								if (answer.m_TextList == null) answer.m_TextList = new Vector.<QEText>();
								answer.m_TextList.push(qtxt);
								answer = null;
							} else if (page != null) {
								if (page.m_TextList == null) page.m_TextList = new Vector.<QEText>();
								page.m_TextList.push(qtxt);
							}
						}
						break;
					}
				}

				if (answer != null) answer = null;
			}
		}
//		if (action_open) {
//			action_sl.SaveEnd();
//			action_open = false;
//		}
	}
	
	public function IsComplate():Boolean
	{
		if (m_StateSelectionFail) return false;
		if (m_NextNum >= 0) return false;
		
		var i:int;
		var t:QETask;
		for (i = 0; i < m_TaskList.length; i++) {
			t = m_TaskList[i];
			if (t.IsEmpty()) continue;
			if (t.m_Val < t.m_Cnt) break;
		}
		return i >= m_TaskList.length;
	}
	
	public function CodeVarSetByShowQuest():void
	{
		var i:int;
		var t:QETask;

		var qnum:int = NumShow();

		var selectionfail:Boolean = false;
		var complate:Boolean = false;
		var offer:Boolean = false;
		var wait:Boolean = false;

		while (qnum >= 0) {
			if (m_StateSelectionFail) { selectionfail = true; break; }

			if (m_NextNum >= 0) offer = true;

			if (!offer) {
				for (i = 0; i < m_TaskList.length; i++) {
					t = m_TaskList[i];
					if (t.IsEmpty()) continue;
					if (t.m_Val < t.m_Cnt) break;
				}
				if (i >= m_TaskList.length) complate = true;
			}
			if ((!offer) && (!complate)) wait = true;
			break;
		}

		m_Context.Offer = offer;
		m_Context.Wait = wait;
		m_Context.Complate = complate;
		m_Context.SelectionFail = selectionfail;
		
		m_Context.FromEnterCotl = QEManager.m_Context.FromEnterCotl;
		m_Context.FromEnterHyperspace = QEManager.m_Context.FromEnterHyperspace;
	}
	
	public function runFun(cc:Object):*
	{
		if (cc == null) return undefined;
		if (!(cc is CodeCompiler)) return undefined;
		if (m_Runtime.err) return undefined;
		var r:*= undefined;
		try {
			QEManager.m_ThisEngine = this;
			r = m_Runtime.runFun(cc as CodeCompiler);
			if (m_Runtime.err) {
				FormChat.Self.AddDebugMsg("QE("+m_FileName+"): Runtime error: " + m_Runtime.err.toString() + (m_Runtime.errName == null?"":'"' + m_Runtime.errName + '"') + " line: " + (m_Runtime.m_Line + 1).toString());
			}
		} catch (err:*) {
			FormChat.Self.AddDebugMsg("QE(" + m_FileName + "): Runtime exception: " + err.message);
		}
		return r;
	}
	
	public function QuestInit():void
	{
		if (m_Init == null) return;

		CodeVarSetByShowQuest();
		runFun(m_Init);
	}

	public function QuestProcess():void
	{
		if (m_Process == null) return;

		CodeVarSetByShowQuest();
		runFun(m_Process);
	}

/*	public function QuestNext():void // Переходим к следующему квесту
	{
		while(true) {
			m_QuestCur++;
			if (m_QuestCur >= m_QuestList.length) return;

			break;
		}
	}*/
	
	public function DialogBegin():int // Запускаем диалог по текущему квесту
	{
		var qnum:int = NumShow();
		if (qnum < 0) return -1;
		return DialogGoTo("begin", m_QuestList[qnum]);
	}
	
	public function QuestFind(name:String):int
	{
		if (name == null) return -1;
		var i:int;
		for (i = 0; i < m_QuestList.length; i++) {
			var q:QEQuest = m_QuestList[i];
			if (q.m_Name == null) continue;
			if (BaseStr.EqNCEng(q.m_Name, name)) return i;
		}
		return -1;
	}
	
	public function PageFind(pagename:String, quest:QEQuest = null):int
	{
		var obj:Object;
		var i:int;
		var p:QEPage;
		for (i = 0; i < m_PageList.length; i++) {
			p = m_PageList[i];
			if (quest != null && quest != p.m_Quest) continue;
			if (!BaseStr.EqNCEng(p.m_Name, pagename)) continue;

			if (p.m_If) {
					CodeVarSetByShowQuest();
					//obj = D.eval(p.m_If, m_Context);
					obj = runFun(p.m_If);
					//QEManager.m_ThisEngine = null;
					if (obj == null) continue;
					else if (obj) { }
					else continue;
			}

			return i;
		}
		return -1;
	}

	public function PageFindWithRnd(pagename:String, quest:QEQuest = null):int
	{
		var obj:Object;
		var i:int, ccc:int, kv:int;
		var p:QEPage;
		var best:int = -1;
		var rnd:PRnd = new PRnd();
		rnd.Set(getTimer()); rnd.RndEx();
		
		for (i = 0; i < m_PageList.length; i++) {
			p = m_PageList[i];
			if (quest != null && quest != p.m_Quest) continue;
			if (!BaseStr.EqNCEng(p.m_Name, pagename)) continue;

			if (p.m_If) {
					CodeVarSetByShowQuest();
					//obj = D.eval(p.m_If, m_Context);
					obj = runFun(p.m_If);
					//QEManager.m_ThisEngine = null;
					if (obj == null) continue;
					else if (obj) { }
					else continue;
			}
			
			if (best < 0) {
				best = i;
				ccc = 1;
			} else {
				ccc++;
                kv=10000000/ccc;
                if (rnd.Rnd(0, 10000000) <= kv) { best = i; }
			}
		}
		return best;
	}

	public function DialogGoTo(pagename:String, quest:QEQuest = null):int // Переходим к другой страничке диалога
	{
		return PageFindWithRnd(pagename, quest);
	}
	
	public function BuildText(page:int, rnd:PRnd, tl:Vector.<QEText>):String
	{
		var i:int, k:int, u:int;
		var qt:QEText;
		var str:String = "";
		var obj:Object;

		if (tl == null) return str;

		for (i = 0; i < tl.length; i++) {
			qt = tl[i];
			if (qt.m_Type == QEText.TypeText) {
				if (qt.m_Data != null) str += qt.m_Data;

			} else if (qt.m_Type == QEText.TypeEnd) {
				for (u = str.length - 4; u >= 0; u--) {
					if (str.substr(u, 4) == "[/p]") { u += 4; break; }
				}
				if (u < 0) u = 0;
				str = str.substr(0, u) + "[p]" + str.substr(u) + "[/p]";
				//str += "\n";
				
			} else if (qt.m_Type == QEText.TypePage) {
				var cp:int = PageFind(qt.m_Data as String);
				if (cp >= 0) {
					str += BaseStr.TrimEnd(BuildText(cp, rnd, m_PageList[cp].m_TextList));
				} else FormChat.Self.AddDebugMsg("Quest: Not found page: " + qt.m_Data);

			} else if (qt.m_Type == QEText.TypeCode) {
				CodeVarSetByShowQuest();
				//obj = D.eval(qt.m_Data, m_Context);
				obj = runFun(qt.m_Data);
				if (obj == null) str += "null";
				else str += obj.toString();

			} else if (qt.m_Type == QEText.TypeRun) {
				CodeVarSetByShowQuest();
				//D.eval(qt.m_Data, m_Context);
				runFun(qt.m_Data);

			} else if (qt.m_Type == QEText.TypeIf) {
				while (i < tl.length) {
					// Проверяем условие, если истина, то выходим из цикла и начинаем выполнять внутренние команды
					CodeVarSetByShowQuest();
					//obj = D.eval(qt.m_Data, m_Context);
					obj = runFun(qt.m_Data);
					
					if (obj == null) { }
					else if (obj) break;

					// Внутрь не заходим а следовательно ищем end, else, elseif того же if-а. Внутрение if-ы пропускаем.
					i++;
					k = 0;
					for (; i < tl.length; i++) {
						qt = tl[i];
						if(k>0) {
							if (qt.m_Type == QEText.TypeIf) { k++; continue; }
							else if (qt.m_Type != QEText.TypeIfEnd) continue;
							k--;
						} else {
							if (qt.m_Type == QEText.TypeElseIf) { k = -1; break; }
							else if (qt.m_Type == QEText.TypeElse) { k = -2; break; }
							else if (qt.m_Type == QEText.TypeIf) { k++; continue; }
							else if (qt.m_Type != QEText.TypeIfEnd) continue;
							k = -3;
							break;
						}
					}
					if (i >= tl.length) continue;

					if (k == -2 || k == -3) { break; } // Else, End - выходим из цикла поиска и начинаем выполнять команды за ними

					// ElseIf - проверяем это условие на выполнение
					qt = tl[i];
				}
				continue;

			} else if (qt.m_Type == QEText.TypeElse || qt.m_Type == QEText.TypeElseIf) {
				// Если встретили else или elseif, то значит закончился текущий блок команд, а следовательно пропускаем все до end.
				i++;
				k = 0;
				for (; i < tl.length; i++) {
					qt = tl[i];
					if (qt.m_Type == QEText.TypeIf) { k++; continue; }
					else if (qt.m_Type != QEText.TypeIfEnd) continue;
					k--;
					if (k < 0) break;
				}

			} else if (qt.m_Type == QEText.TypeSub) {
				if (BaseStr.EqNCEng(qt.m_Data as String, "br")) {
					if (i + 1 < tl.length && tl[i + 1].m_Type != QEText.TypeEnd) str += "\n";
				}
				else if (BaseStr.EqNCEng(qt.m_Data as String, "clr")) str += "[clr]";
				else if (BaseStr.EqNCEng(qt.m_Data as String, "/clr")) str += "[/clr]";
				else if (BaseStr.EqNCEng(qt.m_Data as String, "crt")) str += "[crt]";
				else if (BaseStr.EqNCEng(qt.m_Data as String, "/crt")) str += "[/crt]";
				else if (BaseStr.EqNCEng(qt.m_Data as String, "task")) str += TaskText();
				else if (BaseStr.EqNCEng(qt.m_Data as String, "reward")) str += RewardText();
			}
		}

		str = BaseStr.Replace(str, "[p][/p][p][/p]", "[p][/p]");
		//str = BaseStr.Replace(str, "[p][/p]", "");
		str = BaseStr.Replace(str, "\n\n\n", "\n\n");

		return str;
	}

	public function DialogText(page:int, rnd:PRnd):String
	{
		if (page<0 || page>=m_PageList.length) return null;
		var p:QEPage = m_PageList[page];

		return BuildText(page, rnd, p.m_TextList);
	}
	
	public function DialogAnswer(page:int, rnd:PRnd, al:Vector.<QEAnswer>):void
	{
		if (page<0 || page>=m_PageList.length) return;
		var p:QEPage = m_PageList[page];

		var i:int, ccc:int, kv:int;
		var first:Boolean;
		var a:QEAnswer, b:QEAnswer;
		var obj:Object;
		
		i = 0;
		if(p.m_AnswerList!=null)
		while (i < p.m_AnswerList.length) {
			b = null;
			first = true;
			while(i < p.m_AnswerList.length) {
				a = p.m_AnswerList[i];
				if (!first && !a.m_Or) break;
				i++;
				first = false;
				
				if (a.m_If != null) {
					CodeVarSetByShowQuest();
					//obj = D.eval(a.m_If, m_Context);
					obj = runFun(a.m_If);
					if (obj == null) continue;
					else if (obj) { }
					else continue;
				}

				if (b == null) {
					b = a;
					ccc = 1;
				} else {
					ccc++;
					kv = 10000000 / ccc;
					if (rnd.Rnd(0, 10000000) <= kv) { b = a; }
				}
			}

			if (b == null) continue;

			if (b.m_TextList == null) {
				if (b.m_Page != null) {
					var newp:int = PageFind(b.m_Page);
					if (newp >= 0) DialogAnswer(newp, rnd, al);
					else FormChat.Self.AddDebugMsg("Quest: Not found page: " + b.m_Page);
				}
			} else {
				al.push(b);
			}
		}
	}
	
	public function NumShow():int
	{
		var qnum:int = m_Num;
		if (m_NextNum >= 0) {
			if (m_NextName != m_FileName) qnum = -1;
			else qnum = m_NextNum;
		}
		if (qnum<0 || qnum>=m_QuestList.length) qnum=-1;
		return qnum;
	}
	
	public function TaskText():String
	{
		var cotlplaceid:uint, cotlidotheruser:uint;
		var str:String = "";
		var ts:String, vs:String;
		var i:int, u:int, k:int;
		var t:QETask, tori:QETask;
		var user:User;

		var qnum:int = NumShow();
		if (qnum < 0) return "";
		var qcur:QEQuest = m_QuestList[qnum];
		
//trace("TaskText", m_TaskList[0].m_Flag, m_TaskList[1].m_Flag, m_TaskList[2].m_Flag);

		for (i = 0; i < m_TaskList.length; i++) {
			t = m_TaskList[i];
			t.m_Tmp = 0;
		}
		for (i = 0; i < m_TaskList.length; i++) {
			t = m_TaskList[i];
			if (t.m_Flag == 0) continue;
			if (t.m_Tmp != 0) continue;

			cotlplaceid = t.CotlPlaceId();
			cotlidotheruser = t.CotlIdOtherUser();

			str += "[p]"+Common.TxtQuest.Task;
			while ((cotlplaceid & (QETask.CotlNeutral | QETask.CotlPlayer | QETask.CotlFriend | QETask.CotlEnemy)) != 0) {
				if ((cotlplaceid & (QETask.CotlNeutral | QETask.CotlPlayer | QETask.CotlFriend | QETask.CotlEnemy)) == (QETask.CotlNeutral | QETask.CotlPlayer | QETask.CotlFriend | QETask.CotlEnemy)) break;
				ts = "";
				if (cotlplaceid & QETask.CotlNeutral) { if (ts.length > 0) ts += ", "; ts += "[clr]" + Common.TxtQuest.TaskPlanetNeutral + "[/clr]"; }
				if (cotlplaceid & QETask.CotlPlayer) { if (ts.length > 0) ts += ", "; ts += "[clr]" + Common.TxtQuest.TaskPlanetPlayer + "[/clr]"; }
				if (cotlplaceid & QETask.CotlFriend) { if (ts.length > 0) ts += ", "; ts += "[clr]" + Common.TxtQuest.TaskPlanetFriend + "[/clr]"; }
				if (cotlplaceid & QETask.CotlEnemy) { if (ts.length > 0) ts += ", "; ts += "[clr]" + Common.TxtQuest.TaskPlanetEnemy + "[/clr]"; }
				str += " " + BaseStr.Replace(Common.TxtQuest.TaskPlanet, "<Val>", ts);
				break;
			}
			while (cotlplaceid != 0) {
				if ((cotlplaceid & QETask.CotlSpecialMask) == QETask.CotlSpecialMask) {
					if ((cotlplaceid & (QETask.CotlHome | QETask.CotlEnclave | QETask.CotlMy | QETask.CotlOther)) == 0) break;
				}
				ts = "";
				if ((cotlplaceid & (QETask.CotlHome | QETask.CotlMy)) == (QETask.CotlHome | QETask.CotlMy)) {
					if (ts.length > 0) ts += ", ";
					ts += "[clr]" + Common.TxtQuest.CotlHome + "[/clr]";
				}
				if ((cotlplaceid & (QETask.CotlEnclave | QETask.CotlMy)) == (QETask.CotlEnclave | QETask.CotlMy)) {
					if (ts.length > 0) ts += ", ";
					ts += "[clr]" + Common.TxtQuest.CotlEnclave + "[/clr]";
				}
				if (cotlidotheruser != 0) {
					if (ts.length > 0) ts += ", ";
					var cotl:SpaceCotl = EmpireMap.Self.HS.GetCotl(cotlidotheruser);
					if (cotl != null && cotl.m_CotlType == Common.CotlTypeUser) ts += Common.TxtQuest.InCotlUser;
					else ts += Common.TxtQuest.InCotl;
					ts += " [clr]" + EmpireMap.Self.CotlName(cotlidotheruser) + "[/clr]";
				}
				if (ts.length > 0) {
					str += " " + Common.TxtQuest.In + " " + ts;
				}
				break;
			}
			str += ":[/p]"

			for (u = i; u < m_TaskList.length; u++) {
				t = m_TaskList[u];
				if (t.m_Flag == 0) continue;
				if (t.CotlPlaceId() != cotlplaceid && t.CotlIdOtherUser() != cotlidotheruser) continue;

				tori = null;
				if (u < qcur.m_TaskList.length) {
					tori = qcur.m_TaskList[u];
					if (tori.m_Flag != t.m_Flag) tori = null;
				}

				t.m_Tmp = 1;

				//if(t.m_Val>=t.m_Cnt) str += "+ ";
				//else
				str += "[p]- ";

				if ((t.m_Flag & QETask.TypeMask) == QETask.TypeAction) {
					if (t.m_Par2 == QETask.ActionNewHomeworld) vs = Common.TxtQuest.TaskActionNewHomeworld;
					else vs = "Unknown action " + (t.m_Flag & QETask.TypeMask).toString() + " " + t.m_Par2.toString();

					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;

					ts = vs;
					str += ts;
					
				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeDestroyShip) {
					ts = "";
					if (t.m_Par2 == 0) ts = Common.TxtQuest.Ships;
					else
					for (k = 1; k < Common.ShipTypeCnt; k++) {
						if (t.m_Par2 & (1 << k)) {
							if (ts.length > 0) ts += ", ";
							ts += Common.ShipNameForCnt[k].toLowerCase();
						}
					}
					vs = Common.TxtQuest.TaskDestroyShip;
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					ts = BaseStr.Replace(vs, "<Type>", ts);
					ts = BaseStr.Replace(ts, "<Cnt>", "[clr]" + t.m_Cnt.toString() + "[/clr]");
					ts = BaseStr.Replace(ts, "<Val>", "[clr]" + Math.min(t.m_Cnt, t.m_Val).toString() + "[/clr]");
					vs = "";
					if (t.UserId() != 0) {
						vs = EmpireMap.Self.Txt_CotlOwnerName(0, t.UserId());
//						user = UserList.Self.GetUser(t.UserId());
//						if (user != null) vs = user.m_Name;
					}
					ts = BaseStr.Replace(ts, "<User>", vs);
					str += ts;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBuildShip) {
					ts = "";
					if (t.m_Par1 == 0) ts = Common.TxtQuest.Ships;
					else
					for (k = 1; k < Common.ShipTypeCnt; k++) {
						if (t.m_Par1 & (1 << k)) {
							if (ts.length > 0) ts += ", ";
							ts += Common.ShipNameForCnt[k].toLowerCase();
						}
					}
					vs = Common.TxtQuest.TaskBuildShip;
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					ts = BaseStr.Replace(vs, "<Type>", ts);
					ts = BaseStr.Replace(ts, "<Cnt>", "[clr]" + t.m_Cnt.toString() + "[/clr]");
					ts = BaseStr.Replace(ts, "<Val>", "[clr]" + Math.min(t.m_Cnt, t.m_Val).toString() + "[/clr]");
					str += ts;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeCapture) {
					vs = Common.TxtQuest.TaskCapture;
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					ts = vs;
					ts = BaseStr.Replace(ts, "<Cnt>", "[clr]" + t.m_Cnt.toString() + "[/clr]");
					ts = BaseStr.Replace(ts, "<Val>", "[clr]" + Math.min(t.m_Cnt, t.m_Val).toString() + "[/clr]");
					str += ts;
					
				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePlaceShip) {
					ts = "";
					if (t.m_Par1 == 0) ts = Common.TxtQuest.Ships;
					else
					for (k = 1; k < Common.ShipTypeCnt; k++) {
						if (t.m_Par1 & (1 << k)) {
							if (ts.length > 0) ts += ", ";
							ts += Common.ShipNameForCnt[k].toLowerCase();
						}
					}
					vs = Common.TxtQuest.TaskPlaceShip;
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					ts = BaseStr.Replace(vs, "<Type>", ts);
					ts = BaseStr.Replace(ts, "<Cnt>", "[clr]" + t.m_Cnt.toString() + "[/clr]");
					ts = BaseStr.Replace(ts, "<Val>", "[clr]" + Math.min(t.m_Cnt, t.m_Val).toString() + "[/clr]");
					str += ts;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeResearch) {
					vs = "Research " + t.m_Par0.toString() + " " + t.m_Par1.toString() + " " + t.m_Par2.toString() + " " + t.m_Par3.toString();
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeTalent) {
					vs = "Talent" + t.m_Par0.toString(16) + " " + t.m_Par1.toString(16) + " " + t.m_Par2.toString(16) + " " + t.m_Par3.toString(16);
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeConstruction) {
					vs = "Construction";
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeTradePath) {
					vs = "TradePath";
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeLinkage) {
					vs = "Linkage";
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeTakeItem) {
					ts = "TakeItem <Cnt>/<Val>";
					if (tori != null && tori.m_Desc != null) ts = tori.m_Desc;
					ts = BaseStr.Replace(ts, "<Cnt>", "[clr]" + t.m_Cnt.toString() + "[/clr]");
					ts = BaseStr.Replace(ts, "<Val>", "[clr]" + Math.min(t.m_Cnt, t.m_Val).toString() + "[/clr]");
					str += ts;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePlaceItem) {
					vs = "PlaceItem";
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeRepair) {
					ts = "Repair <Cnt>/<Val>";
					if (tori != null && tori.m_Desc != null) ts = tori.m_Desc;
					ts = BaseStr.Replace(ts, "<Cnt>", "[clr]" + t.m_Cnt.toString() + "[/clr]");
					ts = BaseStr.Replace(ts, "<Val>", "[clr]" + Math.min(t.m_Cnt, t.m_Val).toString() + "[/clr]");
					str += ts;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBalance) {
					vs = "Balance";
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypeBuildItem) {
					ts = "BuildItem <Cnt>/<Val>";
					if (tori != null && tori.m_Desc != null) ts = tori.m_Desc;
					ts = BaseStr.Replace(ts, "<Cnt>", "[clr]" + t.m_Cnt.toString() + "[/clr]");
					ts = BaseStr.Replace(ts, "<Val>", "[clr]" + Math.min(t.m_Cnt, t.m_Val).toString() + "[/clr]");
					str += ts;

				} else if ((t.m_Flag & QETask.TypeMask) == QETask.TypePortal) {
					vs = "Portal";
					if (tori != null && tori.m_Desc != null) vs = tori.m_Desc;
					str += vs;

				} else {
					str += "Unknown task " + (t.m_Flag & QETask.TypeMask).toString();
				}

				if(t.m_Val>=t.m_Cnt) str += " <font color='#0000ff'>(" +Common.TxtQuest.Complate + ")</font>";
				
				str += "[/p]";
			}
			
		}
		return str;
	}
	
	public function RewardText():String
	{
		var str:String = "";

		if ((m_RewardMoney != 0) || (m_RewardExp != 0) || (m_RewardItemType != 0)) {
			str += "[p]" + Common.TxtQuest.Reward + ":[/p]";
			
			if (m_RewardExp != 0) {
				str += "[p]"+Common.TxtQuest.RewardExp + ": [clr]" + BaseStr.FormatBigInt(m_RewardExp) + "[/clr][/p]";
			}
			if (m_RewardMoney != 0) {
				str += "[p]"+Common.TxtQuest.RewardMoney + ": [clr]" + BaseStr.FormatBigInt(m_RewardMoney) + "[/clr] cr[/p]";
			}
			if (m_RewardItemType != 0) {
				str += "[p]"+Common.ItemName[m_RewardItemType] + ": [clr]" + BaseStr.FormatBigInt(m_RewardItemCnt) + "[/clr][/p]";
			}
		}

		return str;
	}
}
	
}