// Copyright (C) 2013 Elemental Games. All rights reserved.

package QE
{
import flash.utils.ByteArray;
	
public class QEQuest
{
    static public const FlagRewardRecv:uint = 0x80000000;// 1 << 31;

	static public const AutoAccept:uint = 1;
	static public const AutoShowComplate:uint = 2;

	static public const ActionVisOn:uint = 1;
	static public const ActionVisOff:uint = 2;
	static public const ActionMoveOn:uint = 3;
	static public const ActionMoveOff:uint = 4;
	static public const ActionCaptureOn:uint = 5;
	static public const ActionCaptureOff:uint = 6;
	static public const ActionCotl:uint = 7;
	
	static public const ActionMax:int = 128;

	public var m_FileName:String = null;
	public var m_Name:String = null;
	public var m_Num:int = 0;
	public var m_Extern:String = null;

	public var m_If:Object = null;

	public var m_Flag:uint = 0;
	public var m_LocId:uint = 0;
	public var m_TaskList:Vector.<QETask> = null;
	public var m_RewardExp:int = 0;
	public var m_RewardMoney:int = 0;
	public var m_RewardItemType:uint = 0;
	public var m_RewardItemCnt:int = 0;
	
	public var m_HistRewardNeed:String = null;

//	public var m_Action:ByteArray = null;

	public var m_CallCotlId:uint = 0;
	public var m_CallName:String = null;
	public var m_CallVal:uint = 0;

	public var m_Auto:uint = 0;
	public var m_ShowComplateOk:Boolean = false;

	public function QEQuest():void
	{
	}
	
	public function CopyTaskFromQuest(src:QEQuest):void
	{
		var i:int;

		m_Flag = src.m_Flag;
		m_LocId = src.m_LocId;
		
		if (src.m_TaskList == null) {
			m_TaskList = null;
		} else {
			if (m_TaskList == null || m_TaskList.length != src.m_TaskList.length) {
				m_TaskList = new Vector.<QETask>();
				for (i = 0; i < src.m_TaskList.length; i++) m_TaskList.push(new QETask());
			}
			for (i = 0; i < src.m_TaskList.length; i++) {
				m_TaskList[i].m_Flag = src.m_TaskList[i].m_Flag;
				m_TaskList[i].m_Cnt = src.m_TaskList[i].m_Cnt;
				m_TaskList[i].m_Val = src.m_TaskList[i].m_Val;
				m_TaskList[i].m_Par0 = src.m_TaskList[i].m_Par0;
				m_TaskList[i].m_Par1 = src.m_TaskList[i].m_Par1;
				m_TaskList[i].m_Par2 = src.m_TaskList[i].m_Par2;
				m_TaskList[i].m_Par3 = src.m_TaskList[i].m_Par3;
				m_TaskList[i].m_Desc = src.m_TaskList[i].m_Desc;
			}
		}

		m_RewardExp = src.m_RewardExp;
		m_RewardMoney = src.m_RewardMoney;
		m_RewardItemType = src.m_RewardItemType;
		m_RewardItemCnt = src.m_RewardItemCnt;

		m_CallCotlId = src.m_CallCotlId;
		m_CallName = src.m_CallName;
		m_CallVal = src.m_CallVal;

//		if (src.m_Action == null) {
//			m_Action = null;
//		} else {
//			if (m_Action == null) m_Action = new ByteArray();
//			m_Action.length = 0;
//			m_Action.writeBytes(src.m_Action, 0, src.m_Action.length);
//		}
	}
	
	public function CopyTaskFromEngine(src:QEEngine):void
	{
		var i:int;

		m_Flag = src.m_Flag;
		m_LocId = src.m_LocId;
		
		if (src.m_TaskList == null) {
			m_TaskList = null;
		} else {
			if (m_TaskList == null || m_TaskList.length != src.m_TaskList.length) {
				m_TaskList = new Vector.<QETask>();
				for (i = 0; i < src.m_TaskList.length; i++) m_TaskList.push(new QETask());
			}
			for (i = 0; i < src.m_TaskList.length; i++) {
				m_TaskList[i].m_Flag = src.m_TaskList[i].m_Flag;
				m_TaskList[i].m_Cnt = src.m_TaskList[i].m_Cnt;
				m_TaskList[i].m_Val = src.m_TaskList[i].m_Val;
				m_TaskList[i].m_Par0 = src.m_TaskList[i].m_Par0;
				m_TaskList[i].m_Par1 = src.m_TaskList[i].m_Par1;
				m_TaskList[i].m_Par2 = src.m_TaskList[i].m_Par2;
				m_TaskList[i].m_Par3 = src.m_TaskList[i].m_Par3;
				m_TaskList[i].m_Desc = src.m_TaskList[i].m_Desc;
			}
		}
		
		m_RewardExp = src.m_RewardExp;
		m_RewardMoney = src.m_RewardMoney;
		m_RewardItemType = src.m_RewardItemType;
		m_RewardItemCnt = src.m_RewardItemCnt;
	}

	public function CopyTaskToEngine(des:QEEngine):void
	{
		var i:int;

		des.m_Flag = m_Flag;
		des.m_LocId = m_LocId;

		for (i = 0; i < des.m_TaskList.length; i++) des.m_TaskList[i].Clear();

		if (m_TaskList != null) {
			for (i = 0; i < m_TaskList.length; i++) {
				des.m_TaskList[i].m_Flag = m_TaskList[i].m_Flag;
				des.m_TaskList[i].m_Cnt = m_TaskList[i].m_Cnt;
				des.m_TaskList[i].m_Val = m_TaskList[i].m_Val;
				des.m_TaskList[i].m_Par0 = m_TaskList[i].m_Par0;
				des.m_TaskList[i].m_Par1 = m_TaskList[i].m_Par1;
				des.m_TaskList[i].m_Par2 = m_TaskList[i].m_Par2;
				des.m_TaskList[i].m_Par3 = m_TaskList[i].m_Par3;
				des.m_TaskList[i].m_Desc = m_TaskList[i].m_Desc;
			}
		}

		des.m_RewardExp = m_RewardExp;
		des.m_RewardMoney = m_RewardMoney;
		des.m_RewardItemType = m_RewardItemType;
		des.m_RewardItemCnt = m_RewardItemCnt;
	}
}
	
}