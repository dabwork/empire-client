// Copyright (C) 2013 Elemental Games. All rights reserved.

package QE
{
import Base.*;
import Engine.*;
import Empire.*;
import flash.events.*;
import flash.net.*;
import flash.utils.*;
//import r1.deval.D;

public class QEManager
{
	public static var Self:QEManager = null;

	public static var m_NameToId:Dictionary = new Dictionary();

	public static var m_EngineList:Vector.<QEEngine> = null;

	public static const QuestMax:int = 3;
	public static const TaskMax:int = 3;
	public static const VarMax:int = 4;
	public static const HistRewardMax:int = 4;
	
	public static const FromTakt:int = 1;
	public static const FromEnterCotl:int = 2;
	public static const FromEnterHyperspace:int = 3;
	
	public static var m_Context:Object = new Object();
	public static var m_Process:CodeCompiler = null;
	public static var m_Runtime:Code = new Code();
	public static var m_Env:CodeCompiler = new CodeCompiler();

	public static var m_FileList:Dictionary = null;
	public static var m_ExternList:Vector.<QEQuest> = new Vector.<QEQuest>();

	public static var m_ThisEngine:QEEngine = null; // Файл, для которого выполняется код

	public function QEManager():void
	{
		m_EngineList = new Vector.<QEEngine>();
		
		m_Env.declConst("RaceNone", CodeBlock.dtDword, Common.RaceNone);
		m_Env.declConst("RaceGrantar", CodeBlock.dtDword, Common.RaceGrantar);
		m_Env.declConst("RacePeleng", CodeBlock.dtDword, Common.RacePeleng);
		m_Env.declConst("RacePeople", CodeBlock.dtDword, Common.RacePeople);
		m_Env.declConst("RaceTechnol", CodeBlock.dtDword, Common.RaceTechnol);
		m_Env.declConst("RaceGaal", CodeBlock.dtDword, Common.RaceGaal);
		m_Env.declConst("RaceKling", CodeBlock.dtDword, Common.RaceKling);
		
		m_Env.declConst("ItemTypeNone", CodeBlock.dtDword, Common.ItemTypeNone);
		m_Env.declConst("ItemTypeModule", CodeBlock.dtDword, Common.ItemTypeModule);
		m_Env.declConst("ItemTypeArmour", CodeBlock.dtDword, Common.ItemTypeArmour);
		m_Env.declConst("ItemTypePower", CodeBlock.dtDword, Common.ItemTypePower);
		m_Env.declConst("ItemTypeRepair", CodeBlock.dtDword, Common.ItemTypeRepair);
		m_Env.declConst("ItemTypeFuel", CodeBlock.dtDword, Common.ItemTypeFuel);
		m_Env.declConst("ItemTypeDouble", CodeBlock.dtDword, Common.ItemTypeDouble);
		m_Env.declConst("ItemTypeMonuk", CodeBlock.dtDword, Common.ItemTypeMonuk);
		m_Env.declConst("ItemTypeAntimatter", CodeBlock.dtDword, Common.ItemTypeAntimatter);
		m_Env.declConst("ItemTypeMetal", CodeBlock.dtDword, Common.ItemTypeMetal);
		m_Env.declConst("ItemTypeElectronics", CodeBlock.dtDword, Common.ItemTypeElectronics);
		m_Env.declConst("ItemTypeProtoplasm", CodeBlock.dtDword, Common.ItemTypeProtoplasm);
		m_Env.declConst("ItemTypeArmour2", CodeBlock.dtDword, Common.ItemTypeArmour2);
		m_Env.declConst("ItemTypePower2", CodeBlock.dtDword, Common.ItemTypePower2);
		m_Env.declConst("ItemTypeRepair2", CodeBlock.dtDword, Common.ItemTypeRepair2);
		m_Env.declConst("ItemTypeMine", CodeBlock.dtDword, Common.ItemTypeMine);
		m_Env.declConst("ItemTypeMoney", CodeBlock.dtDword, Common.ItemTypeMoney);
		m_Env.declConst("ItemTypeTitan", CodeBlock.dtDword, Common.ItemTypeTitan);
		m_Env.declConst("ItemTypeSilicon", CodeBlock.dtDword, Common.ItemTypeSilicon);
		m_Env.declConst("ItemTypeCrystal", CodeBlock.dtDword, Common.ItemTypeCrystal);
		m_Env.declConst("ItemTypeXenon", CodeBlock.dtDword, Common.ItemTypeXenon);
		m_Env.declConst("ItemTypeHydrogen", CodeBlock.dtDword, Common.ItemTypeHydrogen);
		m_Env.declConst("ItemTypeFood", CodeBlock.dtDword, Common.ItemTypeFood);
		m_Env.declConst("ItemTypePlasma", CodeBlock.dtDword, Common.ItemTypePlasma);
		m_Env.declConst("ItemTypeMachinery", CodeBlock.dtDword, Common.ItemTypeMachinery);
		m_Env.declConst("ItemTypeEngineer", CodeBlock.dtDword, Common.ItemTypeEngineer);
		m_Env.declConst("ItemTypeTechnician", CodeBlock.dtDword, Common.ItemTypeTechnician);
		m_Env.declConst("ItemTypeNavigator", CodeBlock.dtDword, Common.ItemTypeNavigator);
		m_Env.declConst("ItemTypeQuarkCore", CodeBlock.dtDword, Common.ItemTypeQuarkCore);

		m_Env.declConst("ShipTypeTransport", CodeBlock.dtDword, Common.ShipTypeTransport);
		m_Env.declConst("ShipTypeCorvette", CodeBlock.dtDword, Common.ShipTypeCorvette);
		m_Env.declConst("ShipTypeCruiser", CodeBlock.dtDword, Common.ShipTypeCruiser);
		m_Env.declConst("ShipTypeDreadnought", CodeBlock.dtDword, Common.ShipTypeDreadnought);
		m_Env.declConst("ShipTypeInvader", CodeBlock.dtDword, Common.ShipTypeInvader);
		m_Env.declConst("ShipTypeDevastator", CodeBlock.dtDword, Common.ShipTypeDevastator);
		m_Env.declConst("ShipTypeWarBase", CodeBlock.dtDword, Common.ShipTypeWarBase);
		m_Env.declConst("ShipTypeShipyard", CodeBlock.dtDword, Common.ShipTypeShipyard);
		m_Env.declConst("ShipTypeKling0", CodeBlock.dtDword, Common.ShipTypeKling0);
		m_Env.declConst("ShipTypeKling1", CodeBlock.dtDword, Common.ShipTypeKling1);
		m_Env.declConst("ShipTypeSciBase", CodeBlock.dtDword, Common.ShipTypeSciBase);
		m_Env.declConst("ShipTypeFlagship", CodeBlock.dtDword, Common.ShipTypeFlagship);
		m_Env.declConst("ShipTypeServiceBase", CodeBlock.dtDword, Common.ShipTypeServiceBase);
		m_Env.declConst("ShipTypeQuarkBase", CodeBlock.dtDword, Common.ShipTypeQuarkBase);

		m_Env.declConst("OwnerAI", CodeBlock.dtDword, Common.OwnerAI);
		m_Env.declConst("OwnerAI0", CodeBlock.dtDword, Common.OwnerAI0);
		m_Env.declConst("OwnerAI1", CodeBlock.dtDword, Common.OwnerAI1);
		m_Env.declConst("OwnerAI2", CodeBlock.dtDword, Common.OwnerAI2);
		m_Env.declConst("OwnerAI3", CodeBlock.dtDword, Common.OwnerAI3);

		m_Env.declConst("ffSelf", CodeBlock.dtDword, 1);
		m_Env.declConst("ffFriend", CodeBlock.dtDword, 2);
		m_Env.declConst("ffEnemy", CodeBlock.dtDword, 4);
		m_Env.declConst("ffInBattle", CodeBlock.dtDword, 8);
		m_Env.declConst("ffOutBattle", CodeBlock.dtDword, 16);

		m_Env.declConst("TeamRelDefault", CodeBlock.dtDword, Common.TeamRelDefault);
		m_Env.declConst("TeamRelWar", CodeBlock.dtDword, Common.TeamRelWar);
		m_Env.declConst("TeamRelPeace", CodeBlock.dtDword, Common.TeamRelPeace);

		m_Runtime.m_Env = m_Env;
		m_Runtime.m_This = m_Context;
		m_Runtime.importStaticMethods(QEFun);
	}

	public static function Clear():void
	{
		var i:int;
		for (i = 0; i < m_EngineList.length; i++) {
			var e:QEEngine = m_EngineList[i];
			e.Clear();
			m_EngineList[i] = null;
		}
		m_EngineList.length = 0;
		m_ThisEngine = null;
		
		m_NameToId = new Dictionary();
	}

	public static function FindByName(filename:String):QEEngine
	{
		var i:int;
		for (i = 0; i < m_EngineList.length; i++) {
			var e:QEEngine = m_EngineList[i];
			if (BaseStr.EqNCEng(e.m_FileName, filename)) return e;
		}
		return null;
	}
	
	public static function FindById(id:uint):QEEngine
	{
		var i:int;
		for (i = 0; i < m_EngineList.length; i++) {
			var e:QEEngine = m_EngineList[i];
			if (e.m_Id == id) return e;
		}
		return null;
	}

	public static function RecvQuest(buf:ByteArray):void
	{
		var i:int;
		var qe:QEEngine;
		var q:QEQuest;
		var sl:SaveLoad = new SaveLoad();
		sl.LoadBegin(buf);

		var tl:Vector.<QETask> = null;

		while (true) {
			var id:uint = sl.LoadDword();
			if (id == 0) break;
			var anm:uint = sl.LoadDword();

			if (anm == 0) {
				continue;
			}

			var changedate:uint = sl.LoadDword();
			var len:int = buf.readByte();
			var filename:String = buf.readUTFBytes(len);
			var owner:uint = sl.LoadDword();
			var num:int = sl.LoadInt();
			var flag:uint = sl.LoadDword();
			var locid:uint = sl.LoadDword();

			if (tl == null) {
				tl = new Vector.<QETask>(TaskMax);
				for (i = 0; i < TaskMax; i++) tl[i] = new QETask();
			}
			for (i = 0; i < TaskMax; i++) {
				tl[i].m_Flag = sl.LoadDword();
				tl[i].m_Cnt = sl.LoadInt();
				tl[i].m_Val = sl.LoadInt();
				tl[i].m_Par0 = sl.LoadDword();
				tl[i].m_Par1 = sl.LoadDword();
				tl[i].m_Par2 = sl.LoadDword();
				tl[i].m_Par3 = sl.LoadDword();
			}

			var rewardexp:int = sl.LoadInt();
			var rewardmoney:int = sl.LoadInt();
			var rewarditemtype:int = sl.LoadDword();
			var rewarditemcnt:int = sl.LoadInt();
			var var0:int = sl.LoadInt();
			var var1:int = sl.LoadInt();
			var var2:int = sl.LoadInt();
			var var3:int = sl.LoadInt();
			var runcnt:int = sl.LoadInt();

			qe = FindById(id);
			if (qe != null) {
				if (qe.m_FileName != filename) {
					qe.Clear();
					qe.m_FileName = filename;
				}
			}
			if (qe == null) {
				qe = new QEEngine();
				qe.m_Id = id;
				qe.m_FileName = filename;
				m_EngineList.push(qe);
			}

			if (!(anm >= qe.m_AnmRecvAfterAnm || (qe.m_AnmRecvAfterAnm_Time + 5000) < EmpireMap.Self.m_CurTime)) {
				continue;
			}

			if (qe.m_StateSelection) continue; // На период выбора квеста данный по нему не грузим

			qe.m_Anm = anm;
			if (qe.m_Anm > qe.m_AnmSend) qe.m_AnmSend = qe.m_Anm;
			qe.m_Num = num;

			//if (qe.m_StateLoadComplate == false) {
			//if(IsInQuestList(qe.m_Id)) {
			if (qe.m_NextNum < 0) {
				// Пока квест не взят на выполнение не нужно грузить задачи
				qe.m_Flag = flag;
				qe.m_LocId = locid;
				for (i = 0; i < TaskMax; i++) {
					qe.m_TaskList[i].m_Flag = tl[i].m_Flag;
					qe.m_TaskList[i].m_Cnt = tl[i].m_Cnt;
					qe.m_TaskList[i].m_Par0 = tl[i].m_Par0;
					qe.m_TaskList[i].m_Par1 = tl[i].m_Par1;
					qe.m_TaskList[i].m_Par2 = tl[i].m_Par2;
					qe.m_TaskList[i].m_Par3 = tl[i].m_Par3;
				}

				for (i = 0; i < TaskMax; i++) {
					qe.m_TaskList[i].m_Val = tl[i].m_Val;
				}
				qe.m_RewardExp = rewardexp;
				qe.m_RewardMoney = rewardmoney;
				qe.m_RewardItemType = rewarditemtype;
				qe.m_RewardItemCnt = rewarditemcnt;
			}

			qe.m_ChangeDate = changedate;
			qe.m_Owner = owner;
			qe.m_Var[0] = var0;
			qe.m_Var[1] = var1;
			qe.m_Var[2] = var2;
			qe.m_Var[3] = var3;
			qe.m_RunCnt = runcnt;
		}
		
		sl.LoadEnd();
		
		if(!EmpireMap.Self.m_StateQuest) {
			for (i = 0; i < EmpireMap.Self.m_UserQuestId.length; i++) {
				if (EmpireMap.Self.m_UserQuestId[i] == 0) continue;
				qe = FindById(EmpireMap.Self.m_UserQuestId[i]);
				if (qe == null) break;
//				if (qe.m_ErrLine < 0 && !qe.m_StateReady) break;
			}
			if (i >= EmpireMap.Self.m_UserQuestId.length) {
				EmpireMap.Self.m_StateQuest = true;
//trace("StateQuest");
			}
		}
		
		for (i = 0; i < EmpireMap.Self.m_UserQuestId.length; i++) {
			if (EmpireMap.Self.m_UserQuestId[i] == 0) continue;
			qe = FindById(EmpireMap.Self.m_UserQuestId[i]);
			if (qe == null) continue;
			if (!qe.m_StateReady) continue;
			if (qe.m_Num<0 || qe.m_Num>=qe.m_QuestList.length) continue;
			q = qe.m_QuestList[qe.m_Num];
			if ((q.m_Auto & QEQuest.AutoShowComplate) == 0) continue;
			if (q.m_ShowComplateOk) continue;

			if (!qe.IsComplate()) continue;
			
			if (!EmpireMap.Self.m_FormDialog.visible) { }
			else if (EmpireMap.Self.m_FormDialog.m_QuestId == qe.m_Id) { }
			else continue;

			q.m_ShowComplateOk = true;
			if (EmpireMap.Self.m_FormDialog.visible) EmpireMap.Self.m_FormDialog.Hide();
			EmpireMap.Self.m_FormDialog.ShowEx(qe.m_Id);
		}
	}
	
	public static function IsProcessPrepare():Boolean
	{
		if (m_Process != null) return true;

		var o:Object;
		o = LoadManager.Self.Get("quest/rus/process.txt");
		if (o == null) return false;

		try {
			//m_Process = D.parseProgram(o as String);
			m_Process = new CodeCompiler();
			m_Process.m_Src = new CodeSrc(o as String);
			m_Process.parseFun();
			m_Process.prepare(m_Env);
			m_Process.extractStaticVar(m_Context);
			if (m_Process.m_Src.err) {
				FormChat.Self.AddDebugMsg("QE(process.txt): Compiler error: " + m_Process.m_Src.err.toString() + " line: " + (m_Process.m_Src.m_Line + 1).toString() + " char: " + (m_Process.m_Src.m_Char + 1).toString());
			}
			
		} catch (err:*) {
			FormChat.Self.AddDebugMsg("QE(process.txt): Compiler exception: " + err.message);
		}
		return true;
	}

	public static function Process(from:int):void
	{
		var i:int, u:int;
		var id:uint;
		var e:QEEngine = null;
		var e2:QEEngine;
		var o:Object;

		LoadList();

		m_Context.FromEnterCotl = from == FromEnterCotl;
		m_Context.FromEnterHyperspace = from == FromEnterHyperspace;

		EmpireMap.Self.m_FormQuestBar.BeginDialogBar();

		if (IsProcessPrepare() && !m_Process.m_Src.err && !m_Runtime.err && EmpireMap.Self.StateReady()) {
			try {
//				D.eval(m_Process,m_Context);
				m_Runtime.runFun(m_Process);
				if (m_Runtime.err) {
					FormChat.Self.AddDebugMsg("QE(process.txt): Runtime error: " + m_Runtime.err.toString() + (m_Runtime.errName == null?"":'"' + m_Runtime.errName + '"') + " line: " + (m_Runtime.m_Line + 1).toString());
				}
			} catch (err:*) {
				FormChat.Self.AddDebugMsg("QE(process.txt): Runtime exception: " + err.message);
			}
		}

		FixId();
		FixIdRun();

		// Run extern
/*		for (i = m_EngineList.length - 1; i >= 0 ; i--) {
			if (i >= m_EngineList.length) break;
			e = m_EngineList[i];
			if (!e.m_StateReady) continue;
			if (e.m_StateSelectionFail) continue;
			if (e.m_NextNum < 0) continue;
			if (e.m_NextName == m_FileName) continue;
			
			QuestBreak(e.m_Id, false);
		}*/

		// Load
		for (i = 0; i < m_EngineList.length; i++) {
			e = m_EngineList[i];
			if (e.m_ErrLine >= 0) continue;
			if (e.m_StateLoadComplate) continue;
			o = LoadManager.Self.Get("quest/rus/" + e.m_FileName + ".txt");
			if (o == null) continue;

			e.Load(o as String);
			if (e.m_ErrLine >= 0) {
				FormChat.Self.AddDebugMsg("LoadQuest (" + e.m_FileName + ": " +e.m_ErrLine.toString() + "): " + e.m_ErrType);
				continue;
			}

			e.m_StateLoadComplate = true;
			EmpireMap.Self.QuestTimeDrop();
		}
		
		// LinkComplate
		for (i = 0; i < m_EngineList.length; i++) {
			e = m_EngineList[i];
			if (e.m_StateSaveInServer) continue;
			if (!e.m_StateLoadComplate) continue;
			if (e.m_StateLinkComplate) continue;

			var ok:Boolean = true;
			for (u = 0; u < e.m_LinkName.length; u++) {
				if (e.m_LinkId[u] != 0) continue;

				e2 = FindByName(e.m_LinkName[u]);
				if (e2 != null && e2.m_Id != 0) {
					if (!e2.m_StateLoadComplate) { ok = false; continue; }
					e.m_LinkId[u] = e2.m_Id;
					continue;
				}

				//id = NameToId(e.m_LinkName[u]);
				//if (e.m_LinkId[u] == 0) break;
				RunByName(e.m_LinkName[u], null);
				ok = false;
			}
			if (!ok) continue;

			e.m_StateLinkComplate = true;
			EmpireMap.Self.QuestTimeDrop();
		}

		// QuestProcess
		if(EmpireMap.Self.StateReady()) {
			GlobalVarSave();
			for (i = 0; i < m_EngineList.length; i++) {
				e = m_EngineList[i];
				if (!e.m_StateLinkComplate) continue;

				GlobalVarToQuest(e);
				if (!e.m_StateReady) {
					e.m_StateReady = true;
					e.QuestInit();
				}
				e.QuestProcess();
				GlobalVarFromQuest(e);
			}
			GloablVarSend();
		}

		DeleteUseless();
		
		EmpireMap.Self.m_FormQuestBar.EndDialogBar();
	}
	
	public static function QuestAccept(questid:uint):void
	{
		var i:int;

		var qe:QEEngine = QEManager.FindById(questid);
		if (qe == null) return;
		if (qe.m_NextNum < 0) return;

		if (qe.m_NextName != qe.m_FileName) {
			FormChat.Self.AddDebugMsg("QE: Quest switch not implemented.");
			return;
		}

		for (i = 0; i < EmpireMap.Self.m_UserQuestId.length; i++) {
			if (EmpireMap.Self.m_UserQuestId[i] == questid) break;
		}
		if (i >= EmpireMap.Self.m_UserQuestId.length) {
			for (i = 0; i < EmpireMap.Self.m_UserQuestId.length; i++) {
				if (EmpireMap.Self.m_UserQuestId[i] == 0) break;
			}
			if (i >= EmpireMap.Self.m_UserQuestId.length) {
				FormMessageBox.RunErr(Common.Txt.FormDialogMaxQuest);
				return;
			}
		}

		qe.m_Num = qe.m_NextNum;
		qe.m_NextName = null;
		qe.m_NextNum = -1;

		EmpireMap.Self.m_UserQuestId[i] = qe.m_Id;

		Server.Self.m_Anm += 256;
		Server.Self.QueryHS("emquest", "&type=1&uanm=" + Server.Self.m_Anm.toString() + "&fqid=" + ((qe.m_NextFromId == 0)?questid:qe.m_NextFromId).toString() + "&qid=" + questid.toString(), QuestAcceptAnswer, false);
		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;

		EmpireMap.Self.m_FormQuestBar.Update();
	}

	public static function QuestAcceptAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

//trace(buf.readUTFBytes(buf.length));
		var err:uint=buf.readUnsignedByte();

		if (err == 0) { }
		else if (err == Server.ErrorNotFound) { FormChat.Self.AddDebugMsg("QE: Not found selection."); return; }
		else EmpireMap.Self.ErrorFromServer(err);
	}
	
	public static function QuestReward(questid:uint, querynum:int = -1, queryname:String = null, finish:Boolean = false):void
	{
		var qe:QEEngine = QEManager.FindById(questid);
		if (qe == null) return;
		
		if (qe.m_Flag & QEQuest.FlagRewardRecv) {
			if (finish) QuestBreak(questid);
			else QuestNext(questid, querynum, queryname);
			return;
		}

		if (qe.m_StateReward) return;
		var i:int;
		var t:QETask;
		for (i = 0; i < qe.m_TaskList.length; i++) {
			t = qe.m_TaskList[i];
			if (t.m_Flag == 0) continue;
			if (t.m_Val < t.m_Cnt) break;
		}
		if (i < qe.m_TaskList.length) return;

		qe.m_StateReward = true;
		qe.m_NextQueryNum = querynum;
		qe.m_NextQueryName = queryname;
		qe.m_NextQueryFinish = finish;

		Server.Self.m_Anm += 256;
		Server.Self.QueryHS("emquest", "&type=6&uanm=" + Server.Self.m_Anm.toString() + "&qid=" + questid.toString(), QuestRewardAnswer, false);
		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;
	}
	
	public static function QuestRewardAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

//trace(buf.readUTFBytes(buf.length));
		var err:uint = buf.readUnsignedByte();
		if (err == Server.ErrorNotFound) FormMessageBox.RunErr(Common.TxtQuest.ErrHoldPlace);
		else if (err != 0) { EmpireMap.Self.ErrorFromServer(err); return; }

		if ((buf.length - buf.position) >= 4) {
			var qid:uint = buf.readUnsignedInt();

			var qe:QEEngine = QEManager.FindById(qid);
			if (qe != null) {
				qe.m_StateReward = false;

				if (err == 0) {
					if (qe.m_NextQueryFinish) QuestBreak(qid);
					else QuestNext(qid, qe.m_NextQueryNum, qe.m_NextQueryName);
				}
			}
		}
	}

	
	public static function QuestNext(questid:uint, querynum:int = -1, queryname:String = null, openafterselection:Boolean = true):void
	{
		var i:int;
		
		var qe:QEEngine = QEManager.FindById(questid);
		if (qe == null) return;
		
		qe.m_NextQueryNum = querynum;
		qe.m_NextQueryName = queryname;

		var num:int = qe.m_Num;
		
		if (qe.m_NextQueryName == null) {
			if (querynum >= 0) {
				num = querynum;
			} else {
				if (num < 0) num = 0;
				else num++;
			}
			if (num >= qe.m_QuestList.length) { QuestBreak(questid); return; }
		} else if ((num = qe.QuestFind(qe.m_NextQueryName)) >= 0) {
		} 

//		RunByName(qe.m_Name, true);

		if(openafterselection) {
			NameToId(qe.m_FileName);
			if (m_NameToId[qe.m_FileName] != undefined) {
				m_NameToId[qe.m_FileName].m_OpenAfterLoad = true;
			}
		}

		QuestSelection(qe, num, qe.m_NextQueryName);
	}
	
	public static function QuestBreak(id:uint, update:Boolean = true):void
	{
		var i:int;

		var qe:QEEngine = FindById(id);
		if (qe == null) return;
		if (qe.m_Id == 0) return;
		
		for (i = 0; i < EmpireMap.Self.m_UserQuestId.length; i++) {
			if (EmpireMap.Self.m_UserQuestId[i] == qe.m_Id) break;
		}
		if (i >= EmpireMap.Self.m_UserQuestId.length) return;
		
		for (i = i + 1; i < EmpireMap.Self.m_UserQuestId.length; i++) EmpireMap.Self.m_UserQuestId[i - 1] = EmpireMap.Self.m_UserQuestId[i];
		EmpireMap.Self.m_UserQuestId[EmpireMap.Self.m_UserQuestId.length - 1] = 0;

		Server.Self.m_Anm += 256;
		Server.Self.QueryHS("emquest", '&type=2&qid=' + qe.m_Id.toString() + "&uanm=" + Server.Self.m_Anm.toString(), QuestAnswer, false);
		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;

		if(update) {
			DeleteUseless();
			EmpireMap.Self.m_FormQuestBar.Update();
		}
	}
	
	public static function QuestAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

//trace(buf.readUTFBytes(buf.length));
		var err:uint=buf.readUnsignedByte();

		if (!err) { }
		else EmpireMap.Self.ErrorFromServer(err);
	}

	public static function DeleteUseless():void
	{
		var i:int, u:int, k:int;
		var e2:QEEngine;
		var ntid:*;

		for (i = m_EngineList.length - 1; i >= 0; i--) {
			var e:QEEngine = m_EngineList[i];
//			if (!e.m_StateLoadComplate) continue;
			if (e.m_OpenAfterLoad) continue;
			if (e.m_StateSelection) continue; // Если ждем ответа сервера по квесту то не выгружаем
			if (e.m_StateReady && e.m_StateWaitSelection && e.m_StateSelectionFail == false) continue;
//			if (e.m_NextNum >= 0) continue; // В момент переадресации на другой квест, нельзя удалять
			if (e.m_StateSaveInServer) continue;
//			ntid = m_NameToId[e.m_FileName];
//			if (ntid != undefined && ntid.m_SaveInServer) continue;

			var del:Boolean = true;
			if (e.m_Id != 0) {
				for (u = 0; u < EmpireMap.Self.m_UserQuestId.length; u++) {
					if (EmpireMap.Self.m_UserQuestId[u] == e.m_Id) { del = false; break; }
				}

				if(del) {
					for (u = 0; u < EmpireMap.Self.m_UserQuestId.length; u++) {
						if (EmpireMap.Self.m_UserQuestId[u] == 0) continue;
						e2 = FindById(EmpireMap.Self.m_UserQuestId[u]);
						if (!e2.m_StateLoadComplate) continue; // m_StateLoadComplate - нельзя так как может образоваться дедлок ожидания друг друга

						//if (e2.m_LinkId.indexOf(e.m_Id) >= 0) { del = false; break; }
						//if (e2.m_LinkName.indexOf(e.m_Name) >= 0) { del = false; break; }
						for (k = 0; k < e2.m_LinkName.length; k++) {
							if (BaseStr.EqNCEng(e2.m_LinkName[k], e.m_FileName)) { del = false; break; }
						}
					}
				}
				if (del) {
					for (u = 0; u < m_EngineList.length; u++) {
						e2 = m_EngineList[u];
						if (!e2.m_OpenAfterLoad) continue;
						if (!e2.m_StateLoadComplate) continue; // m_StateLoadComplate - нельзя так как может образоваться дедлок ожидания друг друга

						for (k = 0; k < e2.m_LinkName.length; k++) {
							if (BaseStr.EqNCEng(e2.m_LinkName[k], e.m_FileName)) { del = false; break; }
						}
					}
				}
			}

			if (!del) continue;
			if (EmpireMap.Self.m_FormDialog.visible && EmpireMap.Self.m_FormDialog.m_QuestId == e.m_Id) EmpireMap.Self.m_FormDialog.Hide();
//trace("DeleteUseless:", e.m_FileName, e.m_Id);
			e.Clear();
			m_EngineList.splice(i, 1);
			if (m_ThisEngine == e) m_ThisEngine = null;
		}
	}

	public static function NameToId(name:String):uint
	{
		var i:int;
		if (name == null) { FormChat.Self.AddDebugMsg("Quest: Incorrect name."); return 0; }
		if (name.length <= 0 || name.length >= 16) { FormChat.Self.AddDebugMsg("Quest: Incorrect name: " + name); return 0; }
		for (i = 0; i < name.length; i++) {
			var ch:int = name.charCodeAt(i);
			if (ch >= 65 && ch <= 90) { } // AZ
			else if (ch >= 97 && ch < 122) { } //az
			else if (ch >= 48 && ch < 57) { } // 09
			else if (ch == 95) { } // _
			else { FormChat.Self.AddDebugMsg("Quest: Incorrect name: " + name); return 0; }
		}

		if (m_NameToId[name] == undefined) {
			var u:NameToIdUnit = new NameToIdUnit();
			u.m_Name = name;
			m_NameToId[name] = u;
		}
		return m_NameToId[name].m_Id;
	}
	
	public static function RunByName(filename:String, questname:String, openafterload:Boolean = false):void
	{
		NameToId(filename);
		if (m_NameToId[filename] != undefined) {
			m_NameToId[filename].m_Run = true;
			m_NameToId[filename].m_Selection = true;
			m_NameToId[filename].m_SelectionName = questname;
			m_NameToId[filename].m_OpenAfterLoad = openafterload;
		}
		EmpireMap.Self.QuestTimeDrop();
	}
	
	public static function FixId():void
	{
		if (Server.Self.IsSendCommand("emquest")) return;

		var str:String = "";
		var cnt:int = 0;
		for each (var v:NameToIdUnit in m_NameToId) {
			if (v.m_Id != 0) continue;
			if (str.length > 0) str += "~";
			str += v.m_Name;
			cnt++;
			if (cnt >= 16) break;
		}
		if (cnt > 0) {
			Server.Self.QueryHS("emquest", '&type=3&ql=' + str, FixIdAnswer, false);
		}
	}

	public static function FixIdAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

//trace(buf.readUTFBytes(buf.length));
		var err:uint=buf.readUnsignedByte();

		if (!err) { }
		else EmpireMap.Self.ErrorFromServer(err);

		while (true) {
			var id:uint = buf.readUnsignedInt();
			if (id == 0) break;
			var len:int = buf.readByte();
			var name:String = buf.readUTFBytes(len);

			var v:NameToIdUnit = m_NameToId[name];
			v.m_Id = id;
		}
		
		EmpireMap.Self.QuestTimeDrop();
	}
	
	public static function FixIdRun():void
	{
		var eq:QEEngine;

		for each (var v:NameToIdUnit in m_NameToId) {
			if (v.m_Id == 0) continue;

			eq = FindById(v.m_Id);

			if (v.m_Run) {
				v.m_Run = false;
				if (eq == null) {
					eq = new QEEngine();
					eq.m_Id = v.m_Id;
					eq.m_FileName = v.m_Name;
					eq.m_OpenAfterLoad = v.m_OpenAfterLoad;
					eq.m_StateWaitSelection = v.m_Selection;
					eq.m_StateSaveInServer = v.m_SaveInServer;
					m_EngineList.push(eq);
				}
				EmpireMap.Self.QuestTimeDrop();
			}
			if (v.m_Selection && eq != null && eq.m_StateReady && eq.m_StateSelection == false && eq.m_StateSelectionFail == false) {
				v.m_Selection = false;
				eq.m_StateWaitSelection = false;
				if (eq.m_Num < 0) {
					if (v.m_SelectionExist != null) {
						v.m_SelectionExist.CopyTaskToEngine(eq);
						//eq.m_Num = v.m_SelectionExist.m_Num;
						eq.m_NextName = eq.m_FileName;
						eq.m_NextNum = v.m_SelectionExist.m_Num;
						eq.m_NextFromId = v.m_SelectionFromId;
						eq.m_StateSelection = false;
						eq.m_StateSelectionFail = false;
						eq.m_OpenAfterLoad = true;

						v.m_SelectionExist = null;
						v.m_SelectionFromId = 0;
					} else {
						QuestNext(eq.m_Id, -1, v.m_SelectionName, v.m_OpenAfterLoad);
					}
				}
			}
			if (v.m_SaveInServer && (eq != null) && eq.m_StateLoadComplate) {
				v.m_SaveInServer = false;
				eq.m_StateSaveInServer = false;
				QuestSaveInServer(eq);
			}
			if (v.m_OpenAfterLoad && eq != null && eq.m_StateReady && eq.m_StateSelection == false /*&& eq.m_StateSelectionFail == false*/ && eq.m_StateReward == false && eq.NumShow() >= 0) {
				v.m_OpenAfterLoad = false;
				if (!EmpireMap.Self.m_FormDialog.visible || EmpireMap.Self.m_FormDialog.m_QuestId != v.m_Id) {
					eq.m_OpenAfterLoad = true;
					EmpireMap.Self.m_FormDialog.ShowEx(v.m_Id);
				}
			}
		}
	}

	public static function QuestSelection(eq:QEEngine, num:int, extern:String = null):void
	{
		var i:int, u:int;
		var dw:uint;

        var boundary:String = Server.Self.CreateBoundary();

        var d:String = "";

        d += "--" + boundary + "\r\n";
        d += "Content-Disposition: form-data; name=\"id\"\r\n\r\n";
		d += eq.m_Id.toString() + "\r\n";

		if (num >= 0) {
			if (num >= eq.m_QuestList.length) return;
			var q:QEQuest = eq.m_QuestList[num];
/*			if (q.m_TaskList == null || q.m_TaskList.length <= 0) {
				eq.m_NextName = eq.m_FileName;
				eq.m_NextNum = num;
				eq.m_NextFromId = 0;
				eq.m_Flag = q.m_Flag;
				eq.m_LocId = q.m_LocId;
				for (i = 0; i < eq.m_TaskList.length; i++) eq.m_TaskList[i].Clear();

				EmpireMap.Self.QuestTimeDrop();
				return;
			}*/

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"skipifexist\"\r\n\r\n";
			d += "0\r\n";

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"desc\"\r\n\r\n";
			d += eq.m_FileName;
			d += "~" +num.toString();
			d += "~" + q.m_RewardExp.toString();
			d += "~" + q.m_RewardMoney.toString();
			d += "~" + q.m_RewardItemType.toString();
			d += "~" + q.m_RewardItemCnt.toString();
			d += "~" + q.m_CallCotlId.toString();
			d += "~" + ((q.m_CallName == null)?"":q.m_CallName);
			d += "~" + q.m_CallVal.toString();
//			d += "~";
//			if (q.m_Action != null) {
//				q.m_Action.position = 0;
//				for (i = 0; i < q.m_Action.length; i++) {
//					dw = q.m_Action.readByte();
//					d += Common.BaseChar[(dw >> 4) & 0xf] + Common.BaseChar[dw & 0xf];
//				}
//			}
			if (q.m_TaskList != null)
			for (i = 0; i < q.m_TaskList.length; i++) {
				d += "~" + q.m_TaskList[i].m_Flag.toString();
				d += "~" + q.m_TaskList[i].m_Cnt.toString();
				d += "~" + q.m_TaskList[i].m_Par0.toString();
				d += "~" + q.m_TaskList[i].m_Par1.toString();
				d += "~" + q.m_TaskList[i].m_Par2.toString();
				d += "~" + q.m_TaskList[i].m_Par3.toString();
			}
			d += "\r\n";

		} else if (extern != null) {
			var find:Vector.<QEQuest>=new Vector.<QEQuest>();
			for (i = 0; i < m_ExternList.length; i++) {
				q = m_ExternList[i];
				if (!BaseStr.EqNCEng(q.m_Extern, extern)) continue;
				find.push(q);
			}
			if (find.length <= 0) {
				FormChat.Self.AddDebugMsg("QE: Not found extern quest: " + extern);
				return;
			}
			if (find.length > 1) {
				// Случайно перемешиваем
				for (i = 0; i < find.length; i++) {
					u = Math.floor(Math.random() * find.length);
					q = find[i];
					find[i] = find[u];
					find[u] = q;
				}
			}
			
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"skipifexist\"\r\n\r\n";
			d += "1\r\n";
			
			for (u = 0; u < 256 && u < find.length; u++) {
				q = find[u];
				
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"desc\"\r\n\r\n";
				d += q.m_FileName;
				d += "~" +q.m_Num.toString();
				d += "~" + q.m_RewardExp.toString();
				d += "~" + q.m_RewardMoney.toString();
				d += "~" + q.m_RewardItemType.toString();
				d += "~" + q.m_RewardItemCnt.toString();
				d += "~" + q.m_CallCotlId.toString();
				d += "~" + ((q.m_CallName == null)?"":q.m_CallName);
				d += "~" + q.m_CallVal.toString();
//				d += "~";
//				if (q.m_Action != null) {
//					q.m_Action.position = 0;
//					for (i = 0; i < q.m_Action.length; i++) {
//						dw = q.m_Action.readByte();
//						d += Common.BaseChar[(dw >> 4) & 0xf] + Common.BaseChar[dw & 0xf];
//					}
//				}
				if (q.m_TaskList != null)
				for (i = 0; i < q.m_TaskList.length; i++) {
					d += "~" + q.m_TaskList[i].m_Flag.toString();
					d += "~" + q.m_TaskList[i].m_Cnt.toString();
					d += "~" + q.m_TaskList[i].m_Par0.toString();
					d += "~" + q.m_TaskList[i].m_Par1.toString();
					d += "~" + q.m_TaskList[i].m_Par2.toString();
					d += "~" + q.m_TaskList[i].m_Par3.toString();
				}
				d += "\r\n";
			}

		} else return;

		eq.m_StateSelectionFail = false;
		eq.m_StateSelection = true;

		d += "--" + boundary + "--\r\n";

		Server.Self.QueryPostHS("emquest", "&type=5", d, boundary, QuestSelectionAnswer, false);		
	}

	public static function QuestSelectionAnswer(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint=buf.readUnsignedByte();

		if (err != 0) { EmpireMap.Self.ErrorFromServer(err); return; }
		
		var forquestid:uint = buf.readUnsignedInt();
		var q:QEEngine = FindById(forquestid);
		if (q == null) return;
		
		q.m_StateSelection = false;
		q.m_StateSelectionFail = false;
		
		if (buf.position >= buf.length) {
			q.m_StateSelectionFail = true;
			
//			NameToId(q.m_FileName);
//			if (m_NameToId[q.m_FileName] != undefined) {
//				m_NameToId[q.m_FileName].m_OpenAfterLoad = true;
//			}
			EmpireMap.Self.QuestTimeDrop();

			return;
		}

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var len:int = buf.readUnsignedByte();
		var nextname:String = buf.readUTFBytes(len);
		var nextnum:int = sl.LoadInt();

		q.m_NextName = nextname;
		q.m_NextNum = nextnum;
		q.m_NextFromId = 0;
		q.m_Flag = sl.LoadDword();
		q.m_LocId = sl.LoadDword();
		for (i = 0; i < TaskMax; i++) {
			q.m_TaskList[i].m_Flag = sl.LoadDword();
			q.m_TaskList[i].m_Cnt = sl.LoadInt();
			q.m_TaskList[i].m_Val = 0;
			q.m_TaskList[i].m_Par0 = sl.LoadDword();
			q.m_TaskList[i].m_Par1 = sl.LoadDword();
			q.m_TaskList[i].m_Par2 = sl.LoadDword();
			q.m_TaskList[i].m_Par3 = sl.LoadDword();
		}
		q.m_RewardExp = sl.LoadInt();
		q.m_RewardMoney = sl.LoadInt();
		q.m_RewardItemType = sl.LoadDword();
		q.m_RewardItemCnt = sl.LoadInt();

		sl.LoadEnd();
//trace("QSelection", q.m_TaskList[0].m_Flag, q.m_TaskList[1].m_Flag, q.m_TaskList[2].m_Flag);

		if (nextnum >= 0 && nextname != q.m_FileName) {
			RunByName(nextname, null, true);

			var u:NameToIdUnit = m_NameToId[nextname];

			u.m_SelectionExist = new QEQuest();
			u.m_SelectionExist.CopyTaskFromEngine(q);
			u.m_SelectionExist.m_Num = nextnum;
			u.m_SelectionFromId = q.m_Id;

			QuestBreak(q.m_Id);

		} else {
			if (q.m_NextNum >= 0 && q.m_NextNum < q.m_QuestList.length) {
				if (q.m_QuestList[q.m_NextNum].m_Auto & QEQuest.AutoAccept) {
					QuestAccept(q.m_Id);
				}
			}
		}

		EmpireMap.Self.QuestTimeDrop();
	}

	public static function QuestSaveInServer(eq:QEEngine):void
	{
		var i:int, u:int, k:int;
		var dw:uint;

		eq.m_StateSelection = true;

        var boundary:String = Server.Self.CreateBoundary();

        var d:String = "";

		var hrn:Vector.<uint> = new Vector.<uint>(HistRewardMax);

		for (i = 0; i < eq.m_QuestList.length; i++) {
			var q:QEQuest = eq.m_QuestList[i];
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"desc\"\r\n\r\n";
			d += eq.m_FileName;
			d += "~" + i.toString();
			d += "~" + q.m_RewardExp.toString();
			d += "~" + q.m_RewardMoney.toString();
			d += "~" + q.m_RewardItemType.toString();
			d += "~" + q.m_RewardItemCnt.toString();

			// HistReward
			for (u = 0; u < HistRewardMax; u++) {
				hrn[u] = 0;
			}
			if (q.m_HistRewardNeed != null) {
				var nl:Array = q.m_HistRewardNeed.split("~");
				for (u = 0; u < nl.length; u++) {
					var f:Boolean = false;

					for (k = 0; k < eq.m_QuestList.length; k++) {
						if (eq.m_QuestList[k].m_Name == null) continue;
						if (!BaseStr.EqNCEng(eq.m_QuestList[k].m_Name, nl[u])) continue;

						if ((k >= (32 * HistRewardMax))) {
							FormChat.Self.AddDebugMsg("QE: EnterFrom out range: " + nl[u]);
							return;
						}
						hrn[k >> 5] |= 1 << (k & 31);
						f = true;
					}
					if (!f) {
						FormChat.Self.AddDebugMsg("QE: EnterFrom not found: " + nl[u]);
						return;
					}
				}
			}
			for (u = 0; u < HistRewardMax; u++) {
				d += "~" + hrn[u].toString(16);
			}

			// Call
			d += "~" + q.m_CallCotlId.toString();
			d += "~" + ((q.m_CallName == null)?"":q.m_CallName);
			d += "~" + q.m_CallVal.toString();

			// Action
//			d += "~";
//			if (q.m_Action != null) {
//				q.m_Action.position = 0;
//				for (u = 0; u < q.m_Action.length; u++) {
//					dw = q.m_Action.readByte();
//					d += Common.BaseChar[(dw >> 4) & 0xf] + Common.BaseChar[dw & 0xf];
//				}
//			}

			// Task
			if (q.m_TaskList != null)
			for (u = 0; u < q.m_TaskList.length; u++) {
				d += "~" + q.m_TaskList[u].m_Flag.toString();
				d += "~" + q.m_TaskList[u].m_Cnt.toString();
				d += "~" + q.m_TaskList[u].m_Par0.toString();
				d += "~" + q.m_TaskList[u].m_Par1.toString();
				d += "~" + q.m_TaskList[u].m_Par2.toString();
				d += "~" + q.m_TaskList[u].m_Par3.toString();
			}
			d += "\r\n";
		}

		d += "--" + boundary + "--\r\n";

		Server.Self.QueryPostHS("emquest", "&type=7", d, boundary, QuestSaveInServerAnswer, false);		
	}

	public static function QuestSaveInServerAnswer(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint=buf.readUnsignedByte();

		if (err != 0) { EmpireMap.Self.ErrorFromServer(err); return; }
		
		FormMessageBox.Run("complate");
	}

	public static function GlobalVarSave():void
	{
		var i:int, u:int;
		var eq:QEEngine;
		for (i = 0; i < m_EngineList.length; i++) {
			eq = m_EngineList[i];
			for (u = 0; u < VarMax; u++) {
				eq.m_VarSave[u] = eq.m_Var[u];
			}
		}
	}
	
	public static function GloablVarSend():void
	{
		var i:int, u:int;
		var eq:QEEngine;
		var str:String;
		var cnt:int;
		
		while (true) {
			cnt = 0;
			str = "";
			for (i = 0; i < m_EngineList.length; i++) {
				eq = m_EngineList[i];
				if (!eq.m_StateReady) continue;
				
				for (u = 0; u < VarMax; u++) {
					if (eq.m_VarSave[u] != eq.m_Var[u]) break;
				}
				if (u >= VarMax) continue;

				if (str.length > 0) str += "~";
				str += eq.m_Id.toString();
				eq.m_AnmSend += 256;
				str += "~" + eq.m_AnmSend.toString();
				eq.m_AnmRecvAfterAnm = eq.m_AnmSend;
				eq.m_AnmRecvAfterAnm_Time = EmpireMap.Self.m_CurTime;

				for (u = 0; u < VarMax; u++) {
					str += "~";
					if (eq.m_VarSave[u] == eq.m_Var[u]) continue;
					str += eq.m_Var[u].toString();
					eq.m_VarSave[u] = eq.m_Var[u];
				}
				cnt++;
				if (cnt >= 16) break;
			}
			if (cnt <= 0) break;
			
			Server.Self.QueryHS("emquest", '&type=4&val=' + str + ".", QuestAnswer, false);
		}
	}

	public static function GlobalVarToQuest(eq:QEEngine):void
	{
		var i:int, u:int;
		var eq2:QEEngine;
		
		for (i = 0; i < VarMax; i++) {
			if (eq.m_VarName[i] == null) continue;
			eq.m_Context[eq.m_VarName[i]] = eq.m_Var[i];
		}
		for (u = 0; u < eq.m_LinkName.length; u++) {
			if (eq.m_LinkId[u] == 0) { 
				FormChat.Self.AddDebugMsg("Quest: Lost link: " + eq.m_LinkName[u]); continue; 
			}
			eq2 = FindById(eq.m_LinkId[u]);
			if (eq2 == null || !eq2.m_StateLoadComplate) { 
				FormChat.Self.AddDebugMsg("Quest: Lost link: " + eq.m_LinkName[u]); continue; 
			}
			
			if (eq.m_Context[eq2.m_FileName] == undefined || eq.m_Context[eq2.m_FileName] == null) {
				eq.m_Context[eq2.m_FileName] = new Object();
			}
			
			for (i = 0; i < VarMax; i++) {
				if (eq2.m_VarName[i] == null) continue;
				eq.m_Context[eq2.m_FileName][eq2.m_VarName[i]] = eq2.m_Var[i];
			}
		}
	}

	public static function GlobalVarFromQuest(eq:QEEngine):void
	{
		var i:int, u:int;
		var eq2:QEEngine;

		for (i = 0; i < VarMax; i++) {
			if (eq.m_VarName[i] == null) continue;
			eq.m_Var[i] = eq.m_Context[eq.m_VarName[i]];
		}
		for (u = 0; u < eq.m_LinkName.length; u++) {
			if (eq.m_LinkId[u] == 0) continue;
			eq2 = FindById(eq.m_LinkId[u]);
			if (eq2 == null || !eq2.m_StateLoadComplate) continue;
			
			if (eq.m_Context[eq2.m_FileName] == undefined || eq.m_Context[eq2.m_FileName] == null) continue;
			
			for (i = 0; i < VarMax; i++) {
				if (eq2.m_VarName[i] == null) continue;
				eq2.m_Var[i] = eq.m_Context[eq2.m_FileName][eq2.m_VarName[i]];
			}
		}
	}

	public static function IsInQuestList(qid:uint):Boolean // Взят ли квест на выполнение
	{
		var i:int;
		for (i = 0; i < EmpireMap.Self.m_UserQuestId.length; i++) {
			if (EmpireMap.Self.m_UserQuestId[i] == qid) return true;
		}
		return false;
	}

	public static function LoadList():void
	{
		if (m_FileList != null) {
			LoadExtern();
			return;
		}
		var o:Object;
		o = LoadManager.Self.Get("quest/rus/list.txt");
		if (o == null) return;
		var src:String = o as String;
		var len:int = src.length;
		var off:int = 0;
		var name:String;
		var cnt:int, ch:int;

		m_FileList = new Dictionary();

		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch == 32 || ch == 9 || ch == 13  || ch == 10) off++; else break; }
			if (off >= len) break;
			
			if (((off + 1) < len) && (src.charCodeAt(off) == 47) && (src.charCodeAt(off + 1) == 47)) { //
				while ((off < len) && (src.charCodeAt(off) != 10)) off++;
				continue;
			}

			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 32 || ch == 9 || ch == 13 || ch == 10) break;
				cnt++;
			}
			if (cnt < 0) continue;

			name = src.substr(off, cnt);
			off += cnt;

			m_FileList[name] = false;
		}
	}

	public static function LoadExtern():void
	{
		var i:int;
		var o:Object;
		var e:QEEngine;
		for (var name:String in m_FileList) {
			if (!m_FileList[name]) {
				o = LoadManager.Self.Get("quest/rus/" + name + ".txt");
				if (o == null) continue;

				m_FileList[name] = true;

				e = new QEEngine();
				e.Load(o as String,false);
				if (e.m_ErrLine >= 0) {
					FormChat.Self.AddDebugMsg("LoadQuest (" + name + ": " +e.m_ErrLine.toString() + "): " + e.m_ErrType);
					continue;
				}

				for (i = 0; i < e.m_QuestList.length; i++) {
					var q:QEQuest = e.m_QuestList[i];
					if (q.m_Extern == null) continue;
					q.m_FileName = name;
					m_ExternList.push(q);
				}
				e.m_QuestList.length = 0;
				e.Clear();
			}
		}
	}
}

}

{
import QE.QEQuest;

class NameToIdUnit {
	public var m_Name:String = null;
	public var m_QuestName:String = null;
	public var m_Id:uint = 0;
	public var m_Run:Boolean = false;
	public var m_Selection:Boolean = false;
	public var m_SelectionName:String = null;
	public var m_OpenAfterLoad:Boolean = false;
	public var m_SaveInServer:Boolean = false;
	
	public var m_SelectionExist:QEQuest = null;
	public var m_SelectionFromId:uint = 0;

	public function NameToIdUnit():void
	{
	}
}
}
